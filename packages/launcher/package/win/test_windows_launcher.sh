#!/usr/bin/env bash
set -euo pipefail

launcher_path="${1}"

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

resolved_launcher_path="$(resolve_input "${launcher_path}")"
if [[ -x "${resolved_launcher_path}" ]]; then
	launcher_path="${resolved_launcher_path}"
else
	launcher_path="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_windows_runtime"
fi

temp_root="$(mktemp -d /tmp/slic3r-windows-launcher.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT

cp -f "${launcher_path}" "${temp_root}/slic3r-console"
chmod +x "${temp_root}/slic3r-console"

launcher_path="${temp_root}/slic3r-console"

version_output="$("${launcher_path}" --version)"
[[ "${version_output}" == "1.3.1-dev" ]]

help_output="$("${launcher_path}" --help)"
[[ "${help_output}" == *"Rust-backed export slices in this milestone"* ]]
[[ "${help_output}" == *"Rust-backed transform/info slices in this milestone"* ]]

save_target="${temp_root}/saved.ini"
save_output="$("${launcher_path}" --save "${save_target}")"
[[ "${save_output}" == "Saved config to ${save_target}" ]]
grep -q '^generated_by=rust_cli$' "${save_target}"

datadir="${temp_root}/profiles"
mkdir -p "${datadir}"
printf 'alpha=1\n' >"${datadir}/base.ini"
printf 'beta=2\n' >"${datadir}/extra.ini"
load_output="$("${launcher_path}" --datadir "${datadir}" --load base.ini --load extra.ini)"
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

gcode_output="$("${launcher_path}" --export-gcode "${model_path}")"
[[ "${gcode_output}" == "Exported G-code to ${temp_root}/model.gcode" ]]
[[ -f "${temp_root}/model.gcode" ]]

info_output="$("${launcher_path}" --info "${model_path}")"
[[ "${info_output}" == *"File: model.stl"* ]]
[[ "${info_output}" == *"Format: STL"* ]]

repair_output="$("${launcher_path}" --repair "${model_path}")"
[[ -z "${repair_output}" ]]
[[ -f "${temp_root}/model_fixed.obj" ]]

split_output="$("${launcher_path}" --split "${model_path}")"
[[ "${split_output}" == *"Writing to model.stl_01.stl"* ]]
[[ "${split_output}" == *"Writing to model.stl_02.stl"* ]]
[[ -f "${temp_root}/model.stl_01.stl" ]]
[[ -f "${temp_root}/model.stl_02.stl" ]]
