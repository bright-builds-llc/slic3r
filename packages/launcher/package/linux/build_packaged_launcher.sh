#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

rust_launcher="${1}"
startup_script="${2}"
slice_notes="${3}"
output_root="${4:-${repo_root}/.planning/.tmp/linux-packaged-launcher}"

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

resolved_rust_launcher="$(resolve_input "${rust_launcher}")"
startup_script="$(resolve_input "${startup_script}")"
slice_notes="$(resolve_input "${slice_notes}")"

if [[ -x "${resolved_rust_launcher}" ]]; then
	rust_launcher="${resolved_rust_launcher}"
else
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

artifact_root="${output_root}/Slic3r-linux"
bin_root="${artifact_root}/bin"
share_root="${artifact_root}/share/slic3r"

printf 'Preparing packaged Linux launcher tree at %s\n' "${artifact_root}"
rm -rf "${artifact_root}"
mkdir -p "${bin_root}" "${share_root}"

printf 'Copying Rust launcher binary...\n'
cp -f "${rust_launcher}" "${bin_root}/slic3r_cli"
chmod +x "${bin_root}/slic3r_cli"

printf 'Copying startup script...\n'
cp -f "${startup_script}" "${bin_root}/slic3r"
chmod +x "${bin_root}/slic3r"

printf 'Copying packaged slice notes...\n'
cp -f "${slice_notes}" "${share_root}/packaged-slice.txt"

printf 'Packaged Linux launcher ready: %s\n' "${artifact_root}"
