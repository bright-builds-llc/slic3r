#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

comparator="${workspace_root}/packages/parity/compare_prusaslicer_gcode_output.sh"
summary_binary="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/prusa_gcode_output_summary"
if [[ ! -x "${summary_binary}" ]]; then
	summary_binary="${workspace_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_gcode_output_summary"
fi
fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
expected_gcode_summary="${fixture_dir}/expected-gcode-summary.tsv"
fixture_provenance="${fixture_dir}/fixture-provenance.tsv"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/compare-prusaslicer-gcode-output-test.XXXXXX")"
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

mutate_line_4_marker_value() {
	local path="${1}"
	local tmp_file="${path}.tmp"

	awk '
		BEGIN {
			FS = OFS = "\t"
		}
		$5 == "line_4" && $6 == "G1 F203.201" {
			$6 = "G1 F203.200"
			changed++
		}
		{
			print
		}
		END {
			if (changed != 1) {
				exit 1
			}
		}
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}

run_comparator() {
	local expected_artifact="${1}"
	local stdout_file="${2}"
	local stderr_file="${3}"

	set +e
	"${comparator}" \
		"${summary_binary}" \
		"${expected_gcode_summary}" \
		"${expected_artifact}" \
		"${fixture_provenance}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

assert_executable "comparator" "${comparator}"
assert_executable "summary binary" "${summary_binary}"
assert_file "expected-gcode-summary.tsv" "${expected_gcode_summary}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

mutated_expected="${tmp_dir}/expected-gcode-summary.tsv"
cp "${expected_gcode_summary}" "${mutated_expected}"
mutate_line_4_marker_value "${mutated_expected}"

if run_comparator "${mutated_expected}" "${tmp_dir}/mutated.out" "${tmp_dir}/mutated.err"; then
	fail "mutated expected-gcode-summary.tsv passed"
fi

assert_contains "${tmp_dir}/mutated.err" "expected-gcode-summary.tsv"
assert_contains "${tmp_dir}/mutated.err" "line_4"
assert_contains "${tmp_dir}/mutated.err" "diff"
assert_contains "${tmp_dir}/mutated.err" "@@"
assert_contains "${tmp_dir}/mutated.err" "G1 F203.200"
assert_contains "${expected_gcode_summary}" $'line_4\tG1 F203.201'

printf 'ok: prusaslicer_gcode_output_parity_failure_test\n'
