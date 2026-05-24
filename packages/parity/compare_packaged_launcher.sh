#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

platform="${1}"
build_package="${2}"
runtime_launcher="${3}"
startup_script="${4}"
slice_notes="${5}"
expected_files="${6}"
expected_notes="${7}"
version_expected="${8}"
help_expected="${9}"
config_save_expected="${10}"
config_load_base="${11}"
config_load_extra="${12}"
config_load_expected="${13}"
export_model="${14}"
export_gcode_expected="${15}"
transform_info_expected="${16}"
transform_repair_expected="${17}"
transform_split_stdout_expected="${18}"
transform_split_part_01_expected="${19}"
transform_split_part_02_expected="${20}"

resolve_input() {
	local path="${1}"
	if [[ "${path}" == /* ]]; then
		printf '%s\n' "${path}"
		return
	fi
	if [[ -e "${path}" ]]; then
		printf '%s/%s\n' "$(cd "$(dirname "${path}")" && pwd)" "$(basename "${path}")"
		return
	fi
	if [[ -e "${repo_root}/bazel-bin/${path}" ]]; then
		printf '%s/bazel-bin/%s\n' "${repo_root}" "${path}"
		return
	fi
	printf '%s/%s\n' "${repo_root}" "${path}"
}

assert_equal() {
	local label="${1}"
	local expected="${2}"
	local actual="${3}"
	if [[ "${actual}" != "${expected}" ]]; then
		printf '%s mismatch\nexpected:\n%s\nactual:\n%s\n' "${label}" "${expected}" "${actual}" >&2
		exit 1
	fi
}

runtime_visible_path() {
	local path="${1}"
	if [[ "${platform}" == "windows" ]] && command -v cygpath >/dev/null 2>&1; then
		cygpath -m -s "${path}"
		return
	fi

	printf '%s\n' "${path}"
}

build_package="$(resolve_input "${build_package}")"
runtime_launcher="$(resolve_input "${runtime_launcher}")"
if [[ "${startup_script}" != "-" ]]; then
	startup_script="$(resolve_input "${startup_script}")"
fi
slice_notes="$(resolve_input "${slice_notes}")"
expected_files="$(resolve_input "${expected_files}")"
expected_notes="$(resolve_input "${expected_notes}")"
version_expected="$(resolve_input "${version_expected}")"
help_expected="$(resolve_input "${help_expected}")"
config_save_expected="$(resolve_input "${config_save_expected}")"
config_load_base="$(resolve_input "${config_load_base}")"
config_load_extra="$(resolve_input "${config_load_extra}")"
config_load_expected="$(resolve_input "${config_load_expected}")"
export_model="$(resolve_input "${export_model}")"
export_gcode_expected="$(resolve_input "${export_gcode_expected}")"
transform_info_expected="$(resolve_input "${transform_info_expected}")"
transform_repair_expected="$(resolve_input "${transform_repair_expected}")"
transform_split_stdout_expected="$(resolve_input "${transform_split_stdout_expected}")"
transform_split_part_01_expected="$(resolve_input "${transform_split_part_01_expected}")"
transform_split_part_02_expected="$(resolve_input "${transform_split_part_02_expected}")"

temp_root="$(mktemp -d /tmp/slic3r-packaged-launcher-parity.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
package_root="${temp_root}/package"
build_log="${temp_root}/build.log"

case "${platform}" in
linux)
	"${build_package}" "${runtime_launcher}" "${startup_script}" "${slice_notes}" "${package_root}" >"${build_log}"
	artifact_root="${package_root}/Slic3r-linux"
	launcher_path="${artifact_root}/bin/slic3r"
	success_label="linux packaged launcher"
	;;
windows)
	"${build_package}" "${runtime_launcher}" "${slice_notes}" "${package_root}" >"${build_log}"
	artifact_root="${package_root}/Slic3r-windows"
	launcher_path="${artifact_root}/Slic3r-console.exe"
	success_label="windows packaged launcher"
	;;
*)
	printf 'unsupported packaged launcher platform: %s\n' "${platform}" >&2
	exit 1
	;;
esac

[[ -x "${launcher_path}" ]]
[[ -f "${artifact_root}/share/slic3r/packaged-slice.txt" ]]

actual_files="$(cd "${artifact_root}" && find . -type f | LC_ALL=C sort)"
assert_equal "${platform} packaged file list" "$(cat "${expected_files}")" "${actual_files}"

actual_notes="$(cat "${artifact_root}/share/slic3r/packaged-slice.txt")"
assert_equal "${platform} packaged notes" "$(cat "${expected_notes}")" "${actual_notes}"

version_output="$("${launcher_path}" --version)"
assert_equal "${platform} packaged version" "$(cat "${version_expected}")" "${version_output}"

help_output="$("${launcher_path}" --help)"
assert_equal "${platform} packaged help" "$(cat "${help_expected}")" "${help_output}"

save_target="${temp_root}/saved.ini"
save_output="$("${launcher_path}" --save "${save_target}")"
expected_save_target="$(runtime_visible_path "${save_target}")"
assert_equal "${platform} packaged save contents" "$(cat "${config_save_expected}")" "$(cat "${save_target}")"
assert_equal "${platform} packaged save stdout" "Saved config to ${expected_save_target}" "${save_output}"

datadir="${temp_root}/profiles"
mkdir -p "${datadir}"
cp "${config_load_base}" "${datadir}/base.ini"
cp "${config_load_extra}" "${datadir}/extra.ini"
load_output="$("${launcher_path}" --datadir "${datadir}" --load base.ini --load extra.ini)"
assert_equal "${platform} packaged load" "$(cat "${config_load_expected}")" "${load_output}"

model_path="${temp_root}/model.stl"
cp "${export_model}" "${model_path}"

gcode_output="$("${launcher_path}" --export-gcode "${model_path}")"
expected_gcode_target="$(runtime_visible_path "${temp_root}/model.gcode")"
assert_equal "${platform} packaged export stdout" "Exported G-code to ${expected_gcode_target}" "${gcode_output}"
assert_equal "${platform} packaged export content" "$(cat "${export_gcode_expected}")" "$(cat "${temp_root}/model.gcode")"

info_output="$("${launcher_path}" --info "${model_path}")"
assert_equal "${platform} packaged info" "$(cat "${transform_info_expected}")" "${info_output}"

repair_output="$("${launcher_path}" --repair "${model_path}")"
assert_equal "${platform} packaged repair stdout" "" "${repair_output}"
assert_equal "${platform} packaged repair content" "$(cat "${transform_repair_expected}")" "$(cat "${temp_root}/model_fixed.obj")"

split_output="$("${launcher_path}" --split "${model_path}")"
assert_equal "${platform} packaged split stdout" "$(cat "${transform_split_stdout_expected}")" "${split_output}"
assert_equal "${platform} packaged split part 01" "$(cat "${transform_split_part_01_expected}")" "$(cat "${temp_root}/model.stl_01.stl")"
assert_equal "${platform} packaged split part 02" "$(cat "${transform_split_part_02_expected}")" "$(cat "${temp_root}/model.stl_02.stl")"

printf 'verified %s fixture\n' "${success_label}"
