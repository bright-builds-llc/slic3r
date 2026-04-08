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

build_wrapper="${repo_root}/tools/bazel/legacy/build_legacy_oracle.sh"
package_dir="${repo_root}/packages/legacy-slic3r"

"${build_wrapper}"

archname="$(/usr/bin/perl -MConfig -e 'print $Config{archname}')"
legacy_output="$(
	cd "${package_dir}" &&
		/usr/bin/perl \
			-I"${package_dir}/local-lib/lib/perl5" \
			-I"${package_dir}/local-lib/lib/perl5/${archname}" \
			-I"${package_dir}/xs/blib/lib" \
			-I"${package_dir}/xs/blib/arch" \
			-I"${package_dir}/lib" \
			slic3r.pl $(tr '\n' ' ' <"${args_file}")
)"
rust_output="$("${rust_launcher}" $(tr '\n' ' ' <"${args_file}"))"
expected_output="$(cat "${expected_file}")"

if [[ "${legacy_output}" != "${expected_output}" ]]; then
	printf 'legacy output mismatch\nexpected: %s\nactual: %s\n' "${expected_output}" "${legacy_output}" >&2
	exit 1
fi

if [[ "${rust_output}" != "${expected_output}" ]]; then
	printf 'rust output mismatch\nexpected: %s\nactual: %s\n' "${expected_output}" "${rust_output}" >&2
	exit 1
fi

if [[ "${legacy_output}" != "${rust_output}" ]]; then
	printf 'legacy and rust outputs diverged\nlegacy: %s\nrust: %s\n' "${legacy_output}" "${rust_output}" >&2
	exit 1
fi

printf 'verified cli.version fixture: %s\n' "${expected_output}"
