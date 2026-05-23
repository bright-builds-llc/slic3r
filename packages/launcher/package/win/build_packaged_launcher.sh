#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

windows_launcher="${1}"
slice_notes="${2}"
output_root="${3:-${repo_root}/.planning/.tmp/windows-packaged-launcher}"

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

resolved_windows_launcher="$(resolve_input "${windows_launcher}")"
slice_notes="$(resolve_input "${slice_notes}")"

if [[ -x "${resolved_windows_launcher}" ]]; then
	windows_launcher="${resolved_windows_launcher}"
else
	windows_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_windows_runtime"
fi

artifact_root="${output_root}/Slic3r-windows"
share_root="${artifact_root}/share/slic3r"

printf 'Preparing packaged Windows launcher tree at %s\n' "${artifact_root}"
rm -rf "${artifact_root}"
mkdir -p "${share_root}"

printf 'Copying Windows Rust console runtime...\n'
cp -f "${windows_launcher}" "${artifact_root}/Slic3r-console.exe"
chmod +x "${artifact_root}/Slic3r-console.exe"

printf 'Copying packaged slice notes...\n'
cp -f "${slice_notes}" "${share_root}/packaged-slice.txt"

printf 'Packaged Windows launcher ready: %s\n' "${artifact_root}"
