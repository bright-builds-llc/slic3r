#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

comparator="${workspace_root}/packages/parity/compare_prusaslicer_project_file.sh"
summary_binary="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/prusa_project_file_summary"
if [[ ! -x "${summary_binary}" ]]; then
	summary_binary="${workspace_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_project_file_summary"
fi
fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file"
expected_project_summary="${fixture_dir}/expected-project-summary.tsv"
fixture_provenance="${fixture_dir}/fixture-provenance.tsv"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/compare-prusaslicer-project-file-test.XXXXXX")"
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

mutate_model_marker_order() {
	local path="${1}"
	local tmp_file="${path}.tmp"

	awk '
		BEGIN {
			FS = OFS = "\t"
		}
		$3 == "3D/3dmodel.model" && $4 == "slic3rpe:Version3mf" {
			version_row = $0
			next
		}
		$3 == "3D/3dmodel.model" && $4 == "Application=PrusaSlicer-2.8.0-alpha3" {
			print
			if (version_row == "") {
				exit 1
			}
			print version_row
			version_row = ""
			changed = 1
			next
		}
		{
			if (version_row != "") {
				print version_row
				version_row = ""
			}
			print
		}
		END {
			if (!changed || version_row != "") {
				exit 1
			}
		}
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}

assert_application_before_version_marker() {
	local path="${1}"

	awk -F '\t' '
		$3 == "3D/3dmodel.model" && $4 == "Application=PrusaSlicer-2.8.0-alpha3" {
			application_line = NR
		}
		$3 == "3D/3dmodel.model" && $4 == "slic3rpe:Version3mf" {
			version_line = NR
		}
		END {
			if (!application_line || !version_line || application_line >= version_line) {
				exit 1
			}
		}
	' "${path}" || fail "mutated_expected did not place Application=PrusaSlicer-2.8.0-alpha3 before slic3rpe:Version3mf"
}

run_comparator() {
	local expected_artifact="${1}"
	local stdout_file="${2}"
	local stderr_file="${3}"

	set +e
	"${comparator}" \
		"${summary_binary}" \
		"${expected_project_summary}" \
		"${expected_artifact}" \
		"${fixture_provenance}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

assert_executable "comparator" "${comparator}"
assert_executable "summary binary" "${summary_binary}"
assert_file "expected-project-summary.tsv" "${expected_project_summary}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

mutated_expected="${tmp_dir}/expected-project-summary.tsv"
cp "${expected_project_summary}" "${mutated_expected}"
mutate_model_marker_order "${mutated_expected}"

if run_comparator "${mutated_expected}" "${tmp_dir}/mutated.out" "${tmp_dir}/mutated.err"; then
	fail "mutated expected-project-summary.tsv passed"
fi

assert_contains "${tmp_dir}/mutated.err" "expected-project-summary.tsv"
assert_contains "${tmp_dir}/mutated.err" "3D/3dmodel.model"
assert_contains "${tmp_dir}/mutated.err" "@@"
assert_contains "${tmp_dir}/mutated.err" "diff"
assert_application_before_version_marker "${mutated_expected}"
assert_contains "${expected_project_summary}" $'3D/3dmodel.model\tslic3rpe:Version3mf\tmember-marker-only'

printf 'ok: prusaslicer_project_file_parity_failure_test\n'
