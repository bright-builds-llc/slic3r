#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 4 ]]; then
	printf 'error: expected summary_binary rust-summary-input.tsv expected-project-summary.tsv fixture-provenance.tsv\n' >&2
	exit 2
fi

summary_binary="${1}"
rust_summary_input="${2}"
expected_artifact="${3}"
fixture_provenance="${4}"

assert_file() {
	local label="${1}"
	local path="${2}"

	if [[ ! -f "${path}" ]]; then
		printf 'error: missing %s: %s\n' "${label}" "${path}" >&2
		exit 1
	fi
}

assert_file "summary binary" "${summary_binary}"
if [[ ! -x "${summary_binary}" ]]; then
	printf 'error: summary binary is not executable: %s\n' "${summary_binary}" >&2
	exit 1
fi
assert_file "rust-summary-input.tsv" "${rust_summary_input}"
assert_file "expected-project-summary.tsv" "${expected_artifact}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

first_mismatch_label() {
	local expected_file="${1}"
	local actual_file="${2}"

	awk -F '\t' '
		NR == FNR {
			expected[FNR] = $0
			expected_count = FNR
			next
		}
		{
			actual_count = FNR
			if (!found && expected[FNR] != $0) {
				if (expected[FNR] != "") {
					split(expected[FNR], fields, "\t")
					if (fields[1] == "evidence_row") {
						print fields[2] "/" fields[3] "/" fields[4]
					} else {
						print fields[1]
					}
				} else if ($1 != "") {
					print $1
				} else {
					print "line"
				}
				found = 1
				exit
			}
		}
		END {
			if (!found && expected_count != actual_count) {
				print "line_count"
			}
		}
	' "${expected_file}" "${actual_file}"
}

field_value() {
	local key="${1}"
	local path="${2}"

	awk -v key="${key}" -F '\t' '
		$1 == key {
			print $2
			found = 1
			exit
		}
		END {
			if (!found) {
				exit 1
			}
		}
	' "${path}"
}

temp_root="$(mktemp -d /tmp/slic3r-prusa-project-file.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
actual_summary="${temp_root}/actual-summary.tsv"
expected_summary_lines="${temp_root}/expected-summary-lines.tsv"

if ! "${summary_binary}" "${rust_summary_input}" >"${actual_summary}"; then
	printf 'error: rust-summary-input.tsv failed Rust summary validation for %s\n' \
		"${rust_summary_input}" >&2
	exit 1
fi

if ! "${summary_binary}" "${expected_artifact}" >"${expected_summary_lines}"; then
	printf 'error: expected-project-summary.tsv failed Rust summary validation for %s\n' \
		"${expected_artifact}" >&2
	if ! diff_output="$(diff -u "${rust_summary_input}" "${expected_artifact}")"; then
		printf 'diff -u %s %s\n' "${rust_summary_input}" "${expected_artifact}" >&2
		printf '%s\n' "${diff_output}" >&2
	fi
	exit 1
fi

if ! diff_output="$(diff -u "${expected_summary_lines}" "${actual_summary}")"; then
	mismatch_label="$(first_mismatch_label "${expected_summary_lines}" "${actual_summary}")"
	printf 'error: expected-project-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_artifact}" >&2
	printf 'diff -u %s %s\n' "${expected_summary_lines}" "${actual_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

rows="$(field_value "row_count" "${actual_summary}")" || {
	printf 'error: row_count missing from actual summary\n' >&2
	exit 1
}
if [[ "${rows}" != "7" ]]; then
	printf 'error: expected row_count 7, got %s\n' "${rows}" >&2
	exit 1
fi

printf 'ok: fork.prusaslicer.project-file parity passed\n'
printf 'source_ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\n'
printf 'fixture: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\n'
printf 'expected: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv\n'
printf 'rows: 7\n'
