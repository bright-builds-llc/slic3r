#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

comparator="${workspace_root}/packages/parity/compare_prusaslicer_profile_schema.sh"
summary_binary="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/prusa_profile_schema_summary"
if [[ ! -x "${summary_binary}" ]]; then
	summary_binary="${workspace_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_profile_schema_summary"
fi
fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema"
prusa_research_ini="${fixture_dir}/PrusaResearch.ini"
expected_summary="${fixture_dir}/expected-summary.tsv"
fixture_provenance="${fixture_dir}/fixture-provenance.tsv"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/compare-prusaslicer-profile-schema-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="${1}"
	local pattern="${2}"

	if ! grep -Fq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,160p' "${file}" >&2
		exit 1
	fi
}

assert_executable() {
	local label="${1}"
	local path="${2}"

	if [[ ! -x "${path}" ]]; then
		fail "${label} is not executable: ${path}"
	fi
}

assert_file() {
	local label="${1}"
	local path="${2}"

	if [[ ! -f "${path}" ]]; then
		fail "${label} is missing: ${path}"
	fi
}

mutate_section_count() {
	local path="${1}"
	local tmp_file="${path}.tmp"

	awk '
		BEGIN {
			FS = OFS = "\t"
		}
		!changed && $1 == "section_count" && $2 == "6976" {
			$2 = "6975"
			changed = 1
		}
		{
			print
		}
		END {
			if (!changed) {
				exit 1
			}
		}
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}

run_comparator() {
	local expected_path="${1}"
	local stdout_file="${2}"
	local stderr_file="${3}"

	set +e
	"${comparator}" \
		"${summary_binary}" \
		"${prusa_research_ini}" \
		"${expected_path}" \
		"${fixture_provenance}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

assert_executable "comparator" "${comparator}"
assert_executable "summary binary" "${summary_binary}"
assert_file "PrusaResearch.ini" "${prusa_research_ini}"
assert_file "expected-summary.tsv" "${expected_summary}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

mutated_expected="${tmp_dir}/expected-summary.tsv"
cp "${expected_summary}" "${mutated_expected}"
mutate_section_count "${mutated_expected}"

if run_comparator "${mutated_expected}" "${tmp_dir}/mutated.out" "${tmp_dir}/mutated.err"; then
	fail "mutated expected-summary.tsv passed"
fi

assert_contains "${tmp_dir}/mutated.err" "section_count"
assert_contains "${tmp_dir}/mutated.err" "expected-summary.tsv"
assert_contains "${mutated_expected}" $'section_count\t6975'
assert_contains "${expected_summary}" $'section_count\t6976'

printf 'ok: prusaslicer_profile_schema_parity_failure_test\n'
