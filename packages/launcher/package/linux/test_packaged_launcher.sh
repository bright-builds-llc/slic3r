#!/usr/bin/env bash
set -euo pipefail

build_package="${1}"
rust_launcher="${2}"
startup_script="${3}"
slice_notes="${4}"

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
fi

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

build_package="$(resolve_input "${build_package}")"
resolved_rust_launcher="$(resolve_input "${rust_launcher}")"
startup_script="$(resolve_input "${startup_script}")"
slice_notes="$(resolve_input "${slice_notes}")"
if [[ -x "${resolved_rust_launcher}" ]]; then
	rust_launcher="${resolved_rust_launcher}"
else
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-linux-packaged-launcher.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
build_log="${temp_root}/build.log"

"${build_package}" "${rust_launcher}" "${startup_script}" "${slice_notes}" "${temp_root}" >"${build_log}"

artifact_root="${temp_root}/Slic3r-linux"
startup_path="${artifact_root}/bin/slic3r"
launcher_path="${artifact_root}/bin/slic3r_cli"
resource_notes="${artifact_root}/share/slic3r/packaged-slice.txt"

[[ -x "${startup_path}" ]]
[[ -x "${launcher_path}" ]]
[[ -f "${resource_notes}" ]]

version_output="$("${startup_path}" --version)"
[[ "${version_output}" == "1.3.1-dev" ]]

help_output="$("${startup_path}" --help)"
[[ "${help_output}" == *"Rust-backed export slices in this milestone"* ]]
[[ "${help_output}" == *"Rust-backed transform/info slices in this milestone"* ]]
[[ "${help_output}" == *"Linux packaged launcher tree"* ]]
[[ "${help_output}" == *"release-grade packaging"* ]]
[[ "${help_output}" != *"packaged launcher behavior"* ]]

save_target="${temp_root}/saved.ini"
save_output="$("${startup_path}" --save "${save_target}")"
[[ "${save_output}" == "Saved config to ${save_target}" ]]
grep -q '^generated_by=rust_cli$' "${save_target}"

datadir="${temp_root}/profiles"
mkdir -p "${datadir}"
printf 'alpha=1\n' >"${datadir}/base.ini"
printf 'beta=2\n' >"${datadir}/extra.ini"
load_output="$("${startup_path}" --datadir "${datadir}" --load base.ini --load extra.ini)"
[[ "${load_output}" == *"# base.ini"* ]]
[[ "${load_output}" == *"alpha=1"* ]]
[[ "${load_output}" == *"# extra.ini"* ]]
[[ "${load_output}" == *"beta=2"* ]]

model_path="${temp_root}/model.stl"
cat >"${model_path}" <<'EOF'
solid triangle
  facet normal 0 0 1
    outer loop
      vertex 0 0 0
      vertex 1 0 0
      vertex 0 1 0
    endloop
  endfacet
endsolid triangle
EOF

gcode_output="$("${startup_path}" --export-gcode "${model_path}")"
[[ "${gcode_output}" == "Exported G-code to ${temp_root}/model.gcode" ]]
[[ -f "${temp_root}/model.gcode" ]]

info_output="$("${startup_path}" --info "${model_path}")"
[[ "${info_output}" == *"File: model.stl"* ]]
[[ "${info_output}" == *"Format: STL"* ]]

repair_output="$("${startup_path}" --repair "${model_path}")"
[[ -z "${repair_output}" ]]
[[ -f "${temp_root}/model_fixed.obj" ]]

split_output="$("${startup_path}" --split "${model_path}")"
[[ "${split_output}" == *"Writing to model.stl_01.stl"* ]]
[[ "${split_output}" == *"Writing to model.stl_02.stl"* ]]
[[ -f "${temp_root}/model.stl_01.stl" ]]
[[ -f "${temp_root}/model.stl_02.stl" ]]

grep -q "scoped Linux packaging-visible launcher slice" "${resource_notes}"
