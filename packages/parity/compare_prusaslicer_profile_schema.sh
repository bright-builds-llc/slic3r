#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 4 ]]; then
	printf 'error: expected summary_binary PrusaResearch.ini expected-summary.tsv fixture-provenance.tsv\n' >&2
	exit 2
fi

summary_binary="${1}"
prusa_research_ini="${2}"
expected_summary="${3}"
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
assert_file "PrusaResearch.ini" "${prusa_research_ini}"
assert_file "expected-summary.tsv" "${expected_summary}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

first_mismatch_label() {
	local expected_file="${1}"
	local actual_file="${2}"

	awk -F '\t' '
		NR == FNR {
			expected[FNR] = $0
			expected_label[FNR] = $1
			expected_count = FNR
			next
		}
		{
			actual_count = FNR
			if (!found && expected[FNR] != $0) {
				if (expected_label[FNR] != "") {
					print expected_label[FNR]
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

temp_root="$(mktemp -d /tmp/slic3r-prusa-profile-schema.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
actual_summary="${temp_root}/actual-summary.tsv"

"${summary_binary}" "${prusa_research_ini}" >"${actual_summary}"

if ! diff_output="$(diff -u "${expected_summary}" "${actual_summary}")"; then
	mismatch_label="$(first_mismatch_label "${expected_summary}" "${actual_summary}")"
	printf 'error: expected-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

sections="$(field_value "section_count" "${actual_summary}")" || {
	printf 'error: section_count missing from actual summary\n' >&2
	exit 1
}
entries="$(field_value "entry_count" "${actual_summary}")" || {
	printf 'error: entry_count missing from actual summary\n' >&2
	exit 1
}

printf 'ok: fork.prusaslicer.profile-schema parity passed\n'
printf 'source_ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\n'
printf 'fixture: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini\n'
printf 'expected: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv\n'
printf 'sections: %s\n' "${sections}"
printf 'entries: %s\n' "${entries}"
