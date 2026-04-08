#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

rust_launcher="${1}"
args_file="${2}"
expected_file="${3}"

if [[ "${args_file}" != /* ]]; then
	args_file="${repo_root}/${args_file}"
fi

if [[ "${expected_file}" != /* ]]; then
	expected_file="${repo_root}/${expected_file}"
fi

if [[ "${rust_launcher}" != /* || ! -x "${rust_launcher}" ]]; then
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

rust_output="$("${rust_launcher}" $(tr '\n' ' ' <"${args_file}"))"
expected_output="$(cat "${expected_file}")"

if [[ "${rust_output}" != "${expected_output}" ]]; then
	printf 'rust help output mismatch\nexpected:\n%s\nactual:\n%s\n' "${expected_output}" "${rust_output}" >&2
	exit 1
fi

printf 'verified cli.help fixture\n'
