#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

rust_launcher="${1}"
expected_save_file="${2}"
load_base_file="${3}"
load_extra_file="${4}"
expected_load_file="${5}"

for path_var in expected_save_file load_base_file load_extra_file expected_load_file; do
	value="${!path_var}"
	if [[ "${value}" != /* ]]; then
		printf -v "${path_var}" '%s/%s' "${repo_root}" "${value}"
	fi
done

if [[ "${rust_launcher}" != /* || ! -x "${rust_launcher}" ]]; then
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-cli-config.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT

save_target="${temp_root}/saved.ini"
save_stdout="$("${rust_launcher}" --save "${save_target}")"
save_contents="$(cat "${save_target}")"
expected_save_contents="$(cat "${expected_save_file}")"

if [[ "${save_contents}" != "${expected_save_contents}" ]]; then
	printf 'saved config mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_save_contents}" "${save_contents}" >&2
	exit 1
fi

if [[ "${save_stdout}" != "Saved config to ${save_target}" ]]; then
	printf 'save stdout mismatch\nexpected: Saved config to %s\nactual: %s\n' "${save_target}" "${save_stdout}" >&2
	exit 1
fi

datadir="${temp_root}/profiles"
mkdir -p "${datadir}"
cp "${load_base_file}" "${datadir}/base.ini"
cp "${load_extra_file}" "${datadir}/extra.ini"
load_output="$("${rust_launcher}" --datadir "${datadir}" --load base.ini --load extra.ini)"
expected_load_output="$(cat "${expected_load_file}")"

if [[ "${load_output}" != "${expected_load_output}" ]]; then
	printf 'load output mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_load_output}" "${load_output}" >&2
	exit 1
fi

printf 'verified config.persistence fixture\n'
