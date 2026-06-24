#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 4 ]]; then
	printf 'error: expected summary_binary rust-arc-input.tsv expected-arc-summary.tsv fixture-provenance.tsv\n' >&2
	exit 2
fi

summary_binary="${1}"
rust_arc_input="${2}"
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
assert_file "rust-arc-input.tsv" "${rust_arc_input}"
assert_file "expected-arc-summary.tsv" "${expected_artifact}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

first_arc_raw_mismatch_label() {
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
					if (fields[3] != "") {
						print fields[3]
					} else {
						print fields[1]
					}
				} else if ($3 != "") {
					print $3
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

first_arc_summary_mismatch_label() {
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
					if (fields[1] != "") {
						print fields[1]
					} else {
						print "line"
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

assert_field() {
	local key="${1}"
	local expected_value="${2}"
	local path="${3}"
	local actual_value

	actual_value="$(field_value "${key}" "${path}")" || {
		printf 'error: %s missing from actual arc summary\n' "${key}" >&2
		exit 1
	}
	if [[ "${actual_value}" != "${expected_value}" ]]; then
		printf 'error: expected %s %s, got %s\n' "${key}" "${expected_value}" "${actual_value}" >&2
		exit 1
	fi
}

temp_root="$(mktemp -d /tmp/slic3r-prusa-arc-fitting.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
actual_summary="${temp_root}/actual-arc-summary.tsv"
expected_summary_lines="${temp_root}/expected-arc-summary-lines.tsv"

if ! "${summary_binary}" "${rust_arc_input}" >"${actual_summary}"; then
	printf 'error: rust-arc-input.tsv failed Rust arc validation for %s\n' \
		"${rust_arc_input}" >&2
	exit 1
fi

if ! "${summary_binary}" "${expected_artifact}" >"${expected_summary_lines}"; then
	mismatch_label="$(first_arc_raw_mismatch_label "${rust_arc_input}" "${expected_artifact}")"
	printf 'error: expected-arc-summary.tsv failed Rust arc validation at %s in %s\n' \
		"${mismatch_label}" "${expected_artifact}" >&2
	if ! diff_output="$(diff -u "${rust_arc_input}" "${expected_artifact}")"; then
		printf 'diff -u %s %s\n' "${rust_arc_input}" "${expected_artifact}" >&2
		printf '%s\n' "${diff_output}" >&2
	fi
	exit 1
fi

if ! diff_output="$(diff -u "${expected_summary_lines}" "${actual_summary}")"; then
	mismatch_label="$(first_arc_summary_mismatch_label "${expected_summary_lines}" "${actual_summary}")"
	printf 'error: expected-arc-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_artifact}" >&2
	printf 'diff -u %s %s\n' "${expected_summary_lines}" "${actual_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

assert_field "arc_summary_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv" "${actual_summary}"
assert_field "arc_row_count" "12" "${actual_summary}"
assert_field "source_ref" "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" "${actual_summary}"
assert_field "fixture_id" "arc-fitting-observations.gcode" "${actual_summary}"
assert_field "fixture_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode" "${actual_summary}"
assert_field "arc_command_counts" "G2:1;G3:1;total_arc_commands:2" "${actual_summary}"
assert_field "arc_direction_counts" "clockwise_g2:1;counterclockwise_g3:1" "${actual_summary}"
assert_field "center_offset_observations" "i_values:5.000,-5.000;j_values:0.000,0.000" "${actual_summary}"
assert_field "coordinate_bounds" "x_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000" "${actual_summary}"
assert_field "extrusion_observations" "e_values:0.50000,1.00000;e_axis_observed:true" "${actual_summary}"
assert_field "feedrate_observations" "F1800:2" "${actual_summary}"
assert_field "evidence_boundary" "checked-in-arc-summary-only" "${actual_summary}"

printf 'ok: fork.prusaslicer.arc-fitting checked-in summary evidence passed\n'
printf 'source_ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\n'
printf 'fixture: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\n'
printf 'expected_arc_summary: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv\n'
printf 'arc_rows: 12\n'
printf 'arc_command_counts: G2:1;G3:1;total_arc_commands:2\n'
printf 'arc_direction_counts: clockwise_g2:1;counterclockwise_g3:1\n'
printf 'center_offset_observations: i_values:5.000,-5.000;j_values:0.000,0.000\n'
printf 'coordinate_bounds: x_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000\n'
printf 'extrusion_observations: e_values:0.50000,1.00000;e_axis_observed:true\n'
printf 'feedrate_observations: F1800:2\n'
printf 'evidence_boundary: checked-in-arc-summary-only\n'
