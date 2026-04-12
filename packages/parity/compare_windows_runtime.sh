#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

launcher_path="${1}"
version_expected="${2}"
help_expected="${3}"
config_save_expected="${4}"
config_load_base="${5}"
config_load_extra="${6}"
config_load_expected="${7}"
export_model="${8}"
export_gcode_expected="${9}"
transform_info_expected="${10}"
transform_repair_expected="${11}"
transform_split_stdout_expected="${12}"
transform_split_part_01_expected="${13}"
transform_split_part_02_expected="${14}"

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
	printf '%s/%s\n' "${repo_root}" "${path}"
}

launcher_path="$(resolve_input "${launcher_path}")"
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

temp_root="$(mktemp -d /tmp/slic3r-windows-runtime-parity.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT

cp -f "${launcher_path}" "${temp_root}/slic3r-console"
chmod +x "${temp_root}/slic3r-console"

launcher_path="${temp_root}/slic3r-console"

version_output="$("${launcher_path}" --version)"
expected_version_output="$(cat "${version_expected}")"
if [[ "${version_output}" != "${expected_version_output}" ]]; then
	printf 'windows runtime version mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_version_output}" "${version_output}" >&2
	exit 1
fi

help_output="$("${launcher_path}" --help)"
expected_help_output="$(cat "${help_expected}")"
if [[ "${help_output}" != "${expected_help_output}" ]]; then
	printf 'windows runtime help mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_help_output}" "${help_output}" >&2
	exit 1
fi

save_target="${temp_root}/saved.ini"
save_output="$("${launcher_path}" --save "${save_target}")"
expected_save_contents="$(cat "${config_save_expected}")"
save_contents="$(cat "${save_target}")"
if [[ "${save_contents}" != "${expected_save_contents}" ]]; then
	printf 'windows runtime save mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_save_contents}" "${save_contents}" >&2
	exit 1
fi
expected_save_output="Saved config to ${save_target}"
if [[ "${save_output}" != "${expected_save_output}" ]]; then
	printf 'windows runtime save stdout mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_save_output}" "${save_output}" >&2
	exit 1
fi

datadir="${temp_root}/profiles"
mkdir -p "${datadir}"
cp "${config_load_base}" "${datadir}/base.ini"
cp "${config_load_extra}" "${datadir}/extra.ini"
load_output="$("${launcher_path}" --datadir "${datadir}" --load base.ini --load extra.ini)"
expected_load_output="$(cat "${config_load_expected}")"
if [[ "${load_output}" != "${expected_load_output}" ]]; then
	printf 'windows runtime load mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_load_output}" "${load_output}" >&2
	exit 1
fi

model_path="${temp_root}/model.stl"
cp "${export_model}" "${model_path}"

gcode_output="$("${launcher_path}" --export-gcode "${model_path}")"
expected_gcode_output="Exported G-code to ${temp_root}/model.gcode"
if [[ "${gcode_output}" != "${expected_gcode_output}" ]]; then
	printf 'windows runtime export stdout mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_gcode_output}" "${gcode_output}" >&2
	exit 1
fi
expected_gcode_contents="$(cat "${export_gcode_expected}")"
gcode_contents="$(cat "${temp_root}/model.gcode")"
if [[ "${gcode_contents}" != "${expected_gcode_contents}" ]]; then
	printf 'windows runtime export content mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_gcode_contents}" "${gcode_contents}" >&2
	exit 1
fi

info_output="$("${launcher_path}" --info "${model_path}")"
expected_info_output="$(cat "${transform_info_expected}")"
if [[ "${info_output}" != "${expected_info_output}" ]]; then
	printf 'windows runtime info mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_info_output}" "${info_output}" >&2
	exit 1
fi

repair_output="$("${launcher_path}" --repair "${model_path}")"
expected_repair_output=""
if [[ "${repair_output}" != "${expected_repair_output}" ]]; then
	printf 'windows runtime repair stdout mismatch\nexpected empty output\nactual:\n%s\n' "${repair_output}" >&2
	exit 1
fi
repair_contents="$(cat "${temp_root}/model_fixed.obj")"
expected_repair_contents="$(cat "${transform_repair_expected}")"
if [[ "${repair_contents}" != "${expected_repair_contents}" ]]; then
	printf 'windows runtime repair mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_repair_contents}" "${repair_contents}" >&2
	exit 1
fi

split_output="$("${launcher_path}" --split "${model_path}")"
expected_split_output="$(cat "${transform_split_stdout_expected}")"
if [[ "${split_output}" != "${expected_split_output}" ]]; then
	printf 'windows runtime split stdout mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_split_output}" "${split_output}" >&2
	exit 1
fi
split_part_01_contents="$(cat "${temp_root}/model.stl_01.stl")"
expected_split_part_01_contents="$(cat "${transform_split_part_01_expected}")"
if [[ "${split_part_01_contents}" != "${expected_split_part_01_contents}" ]]; then
	printf 'windows runtime split part 01 mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_split_part_01_contents}" "${split_part_01_contents}" >&2
	exit 1
fi
split_part_02_contents="$(cat "${temp_root}/model.stl_02.stl")"
expected_split_part_02_contents="$(cat "${transform_split_part_02_expected}")"
if [[ "${split_part_02_contents}" != "${expected_split_part_02_contents}" ]]; then
	printf 'windows runtime split part 02 mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_split_part_02_contents}" "${split_part_02_contents}" >&2
	exit 1
fi

printf 'verified windows runtime fixture\n'
