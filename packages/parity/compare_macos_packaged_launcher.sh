#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

build_bundle="${1}"
rust_launcher="${2}"
startup_script="${3}"
icon_path="${4}"
slice_notes="${5}"
expected_files="${6}"
expected_notes="${7}"
expected_plist="${8}"
version_expected="${9}"
help_expected="${10}"

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
startup_script="$(resolve_input "${startup_script}")"
icon_path="$(resolve_input "${icon_path}")"
slice_notes="$(resolve_input "${slice_notes}")"
expected_files="$(resolve_input "${expected_files}")"
expected_notes="$(resolve_input "${expected_notes}")"
expected_plist="$(resolve_input "${expected_plist}")"
version_expected="$(resolve_input "${version_expected}")"
help_expected="$(resolve_input "${help_expected}")"

resolved_rust_launcher="$(resolve_input "${rust_launcher}")"
if [[ -x "${resolved_rust_launcher}" ]]; then
	rust_launcher="${resolved_rust_launcher}"
else
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-packaged-parity.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT

"${build_bundle}" "${rust_launcher}" "${startup_script}" "${icon_path}" "${slice_notes}" "${temp_root}" >/tmp/slic3r-packaged-parity.log

app_root="${temp_root}/Slic3r.app"
startup_path="${app_root}/Contents/MacOS/Slic3r"
info_plist="${app_root}/Contents/Info.plist"

actual_files="$(cd "${app_root}" && find . -type f | sort)"
expected_files_contents="$(cat "${expected_files}")"
if [[ "${actual_files}" != "${expected_files_contents}" ]]; then
	printf 'bundle file list mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_files_contents}" "${actual_files}" >&2
	exit 1
fi

actual_notes="$(cat "${app_root}/Contents/Resources/packaged-slice.txt")"
expected_notes_contents="$(cat "${expected_notes}")"
if [[ "${actual_notes}" != "${expected_notes_contents}" ]]; then
	printf 'packaged slice notes mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_notes_contents}" "${actual_notes}" >&2
	exit 1
fi

actual_plist="$(
	{
		printf 'CFBundleExecutable=%s\n' "$(/usr/bin/plutil -extract CFBundleExecutable raw -o - "${info_plist}")"
		printf 'CFBundleIdentifier=%s\n' "$(/usr/bin/plutil -extract CFBundleIdentifier raw -o - "${info_plist}")"
		printf 'CFBundlePackageType=%s\n' "$(/usr/bin/plutil -extract CFBundlePackageType raw -o - "${info_plist}")"
		printf 'CFBundleIconFile=%s\n' "$(/usr/bin/plutil -extract CFBundleIconFile raw -o - "${info_plist}")"
		printf 'LSMinimumSystemVersion=%s\n' "$(/usr/bin/plutil -extract LSMinimumSystemVersion raw -o - "${info_plist}")"
	}
)"
expected_plist_contents="$(cat "${expected_plist}")"
if [[ "${actual_plist}" != "${expected_plist_contents}" ]]; then
	printf 'Info.plist metadata mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_plist_contents}" "${actual_plist}" >&2
	exit 1
fi

version_output="$("${startup_path}" --version)"
expected_version_output="$(cat "${version_expected}")"
if [[ "${version_output}" != "${expected_version_output}" ]]; then
	printf 'packaged version mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_version_output}" "${version_output}" >&2
	exit 1
fi

help_output="$("${startup_path}" --help)"
expected_help_output="$(cat "${help_expected}")"
if [[ "${help_output}" != "${expected_help_output}" ]]; then
	printf 'packaged help mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_help_output}" "${help_output}" >&2
	exit 1
fi

printf 'verified launcher-packaging fixture\n'
