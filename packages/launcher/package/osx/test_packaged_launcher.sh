#!/usr/bin/env bash
set -euo pipefail

build_bundle="${1}"
rust_launcher="${2}"
startup_script="${3}"
icon_path="${4}"
slice_notes="${5}"

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

build_bundle="$(resolve_input "${build_bundle}")"
resolved_rust_launcher="$(resolve_input "${rust_launcher}")"
startup_script="$(resolve_input "${startup_script}")"
icon_path="$(resolve_input "${icon_path}")"
slice_notes="$(resolve_input "${slice_notes}")"
if [[ -x "${resolved_rust_launcher}" ]]; then
	rust_launcher="${resolved_rust_launcher}"
else
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-packaged-launcher.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT

"${build_bundle}" "${rust_launcher}" "${startup_script}" "${icon_path}" "${slice_notes}" "${temp_root}" >/tmp/slic3r-packaged-launcher.log

app_root="${temp_root}/Slic3r.app"
startup_path="${app_root}/Contents/MacOS/Slic3r"
launcher_path="${app_root}/Contents/MacOS/slic3r_cli"
info_plist="${app_root}/Contents/Info.plist"
pkg_info="${app_root}/Contents/PkgInfo"
resource_notes="${app_root}/Contents/Resources/packaged-slice.txt"
bundle_icon="${app_root}/Contents/Resources/Slic3r.icns"

[[ -x "${startup_path}" ]]
[[ -x "${launcher_path}" ]]
[[ -f "${info_plist}" ]]
[[ -f "${pkg_info}" ]]
[[ -f "${resource_notes}" ]]
[[ -f "${bundle_icon}" ]]

version_output="$("${startup_path}" --version)"
[[ "${version_output}" == "1.3.1-dev" ]]

help_output="$("${startup_path}" --help)"
[[ "${help_output}" == *"Rust-backed export slices in this milestone"* ]]
[[ "${help_output}" == *"Rust-backed transform/info slices in this milestone"* ]]

grep -q "scoped macOS packaging-visible launcher slice" "${resource_notes}"
