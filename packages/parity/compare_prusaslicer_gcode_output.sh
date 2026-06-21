#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 8 ]]; then
	printf 'error: expected summary_binary rust-summary-input.tsv expected-gcode-summary.tsv rust-structural-input.tsv expected-gcode-structural-summary.tsv rust-semantic-input.tsv expected-gcode-semantic-summary.tsv fixture-provenance.tsv\n' >&2
	exit 2
fi

summary_binary="${1}"
rust_summary_input="${2}"
expected_artifact="${3}"
rust_structural_input="${4}"
expected_structural_artifact="${5}"
rust_semantic_input="${6}"
expected_semantic_artifact="${7}"
fixture_provenance="${8}"

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
assert_file "expected-gcode-summary.tsv" "${expected_artifact}"
assert_file "rust-structural-input.tsv" "${rust_structural_input}"
assert_file "expected-gcode-structural-summary.tsv" "${expected_structural_artifact}"
assert_file "rust-semantic-input.tsv" "${rust_semantic_input}"
assert_file "expected-gcode-semantic-summary.tsv" "${expected_semantic_artifact}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

first_raw_mismatch_label() {
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
					if (fields[3] != "" && fields[4] != "" && fields[5] != "") {
						print fields[3] "/" fields[4] "/" fields[5]
					} else {
						print fields[1]
					}
				} else if ($3 != "" && $4 != "" && $5 != "") {
					print $3 "/" $4 "/" $5
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

first_summary_mismatch_label() {
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

first_structural_raw_mismatch_label() {
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

first_semantic_raw_mismatch_label() {
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
		printf 'error: %s missing from actual summary\n' "${key}" >&2
		exit 1
	}
	if [[ "${actual_value}" != "${expected_value}" ]]; then
		printf 'error: expected %s %s, got %s\n' "${key}" "${expected_value}" "${actual_value}" >&2
		exit 1
	fi
}

assert_exact_line() {
	local expected_line="${1}"
	local path="${2}"

	if ! grep -Fxq "${expected_line}" "${path}"; then
		printf 'error: expected summary line missing: %s\n' "${expected_line}" >&2
		exit 1
	fi
}

temp_root="$(mktemp -d /tmp/slic3r-prusa-gcode-output.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
actual_summary="${temp_root}/actual-summary.tsv"
expected_summary_lines="${temp_root}/expected-summary-lines.tsv"
actual_structural_summary="${temp_root}/actual-structural-summary.tsv"
expected_structural_summary_lines="${temp_root}/expected-structural-summary-lines.tsv"
actual_semantic_summary="${temp_root}/actual-semantic-summary.tsv"
expected_semantic_summary_lines="${temp_root}/expected-semantic-summary-lines.tsv"

if ! "${summary_binary}" "${rust_summary_input}" >"${actual_summary}"; then
	printf 'error: rust-summary-input.tsv failed Rust summary validation for %s\n' \
		"${rust_summary_input}" >&2
	exit 1
fi

if ! "${summary_binary}" "${expected_artifact}" >"${expected_summary_lines}"; then
	mismatch_label="$(first_raw_mismatch_label "${rust_summary_input}" "${expected_artifact}")"
	printf 'error: expected-gcode-summary.tsv failed Rust summary validation at %s in %s\n' \
		"${mismatch_label}" "${expected_artifact}" >&2
	if ! diff_output="$(diff -u "${rust_summary_input}" "${expected_artifact}")"; then
		printf 'diff -u %s %s\n' "${rust_summary_input}" "${expected_artifact}" >&2
		printf '%s\n' "${diff_output}" >&2
	fi
	exit 1
fi

if ! diff_output="$(diff -u "${expected_summary_lines}" "${actual_summary}")"; then
	mismatch_label="$(first_summary_mismatch_label "${expected_summary_lines}" "${actual_summary}")"
	printf 'error: expected-gcode-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_artifact}" >&2
	printf 'diff -u %s %s\n' "${expected_summary_lines}" "${actual_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

if ! "${summary_binary}" --structural "${rust_structural_input}" >"${actual_structural_summary}"; then
	printf 'error: rust-structural-input.tsv failed Rust structural validation for %s\n' \
		"${rust_structural_input}" >&2
	exit 1
fi

if ! "${summary_binary}" --structural "${expected_structural_artifact}" >"${expected_structural_summary_lines}"; then
	mismatch_label="$(first_structural_raw_mismatch_label "${rust_structural_input}" "${expected_structural_artifact}")"
	printf 'error: expected-gcode-structural-summary.tsv failed Rust structural validation at %s in %s\n' \
		"${mismatch_label}" "${expected_structural_artifact}" >&2
	if ! diff_output="$(diff -u "${rust_structural_input}" "${expected_structural_artifact}")"; then
		printf 'diff -u %s %s\n' "${rust_structural_input}" "${expected_structural_artifact}" >&2
		printf '%s\n' "${diff_output}" >&2
	fi
	exit 1
fi

if ! diff_output="$(diff -u "${expected_structural_summary_lines}" "${actual_structural_summary}")"; then
	mismatch_label="$(first_summary_mismatch_label "${expected_structural_summary_lines}" "${actual_structural_summary}")"
	printf 'error: expected-gcode-structural-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_structural_artifact}" >&2
	printf 'diff -u %s %s\n' "${expected_structural_summary_lines}" "${actual_structural_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

if ! "${summary_binary}" --semantic "${rust_semantic_input}" >"${actual_semantic_summary}"; then
	printf 'error: rust-semantic-input.tsv failed Rust semantic validation for %s\n' \
		"${rust_semantic_input}" >&2
	exit 1
fi

if ! "${summary_binary}" --semantic "${expected_semantic_artifact}" >"${expected_semantic_summary_lines}"; then
	mismatch_label="$(first_semantic_raw_mismatch_label "${rust_semantic_input}" "${expected_semantic_artifact}")"
	printf 'error: expected-gcode-semantic-summary.tsv failed Rust semantic validation at %s in %s\n' \
		"${mismatch_label}" "${expected_semantic_artifact}" >&2
	if ! diff_output="$(diff -u "${rust_semantic_input}" "${expected_semantic_artifact}")"; then
		printf 'diff -u %s %s\n' "${rust_semantic_input}" "${expected_semantic_artifact}" >&2
		printf '%s\n' "${diff_output}" >&2
	fi
	exit 1
fi

if ! diff_output="$(diff -u "${expected_semantic_summary_lines}" "${actual_semantic_summary}")"; then
	mismatch_label="$(first_summary_mismatch_label "${expected_semantic_summary_lines}" "${actual_semantic_summary}")"
	printf 'error: expected-gcode-semantic-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_semantic_artifact}" >&2
	printf 'diff -u %s %s\n' "${expected_semantic_summary_lines}" "${actual_semantic_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi

assert_field "surface" "fork.prusaslicer.gcode-output" "${actual_summary}"
assert_field "inventory_id" "prusaslicer.gcode-output" "${actual_summary}"
assert_field "vendor_id" "prusaslicer" "${actual_summary}"
assert_field "source_ref" "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" "${actual_summary}"
assert_field "fixture_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode" "${actual_summary}"
assert_field "expected_summary_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv" "${actual_summary}"
assert_field "reserved_future_status_token" "fork.prusaslicer.gcode-output" "${actual_summary}"
assert_field "row_count" "5" "${actual_summary}"
assert_exact_line $'evidence_row\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_4\tG1 F203.201\tRepresentative three-decimal rounded feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.' "${actual_summary}"

assert_field "source_ref" "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" "${actual_structural_summary}"
assert_field "fixture_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode" "${actual_structural_summary}"
assert_field "structural_row_count" "16" "${actual_structural_summary}"
assert_field "fixture_id" "gcodewriter-set-speed.gcode" "${actual_structural_summary}"
assert_field "command_count_total" "4" "${actual_structural_summary}"
assert_field "command_count_g1" "4" "${actual_structural_summary}"
assert_field "ordered_marker_1" "G1 F99999.123" "${actual_structural_summary}"
assert_field "ordered_marker_2" "G1 F1" "${actual_structural_summary}"
assert_field "ordered_marker_3" "G1 F203.2" "${actual_structural_summary}"
assert_field "ordered_marker_4" "G1 F203.201" "${actual_structural_summary}"
assert_field "movement_axis_present" "false" "${actual_structural_summary}"
assert_field "extrusion_axis_present" "false" "${actual_structural_summary}"
assert_field "temperature_marker_count" "0" "${actual_structural_summary}"
assert_field "tool_change_marker_count" "0" "${actual_structural_summary}"

assert_field "semantic_summary_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv" "${actual_semantic_summary}"
assert_field "semantic_row_count" "9" "${actual_semantic_summary}"
assert_field "source_ref" "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" "${actual_semantic_summary}"
assert_field "fixture_id" "gcodewriter-set-speed.gcode" "${actual_semantic_summary}"
assert_field "fixture_path" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode" "${actual_semantic_summary}"
assert_field "command_class_counts" "G1:4;feedrate_only:4" "${actual_semantic_summary}"
assert_field "movement_class_counts" "travel:0;extrusion:0;coordinate_motion:0;feedrate_only:4" "${actual_semantic_summary}"
assert_field "coordinate_bounds" "x:none;y:none;z:none" "${actual_semantic_summary}"
assert_field "extrusion_total" "e_axis_observed:false;extrusion_total:not_observed" "${actual_semantic_summary}"
assert_field "feedrate_observations" "F99999.123;F1;F203.2;F203.201" "${actual_semantic_summary}"
assert_field "layer_marker_relationships" "layer_markers:0;marker_relationships:none" "${actual_semantic_summary}"

printf 'ok: fork.prusaslicer.gcode-output semantic evidence passed\n'
printf 'source_ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\n'
printf 'fixture: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\n'
printf 'expected: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv\n'
printf 'structural_expected: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv\n'
printf 'semantic_expected: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv\n'
printf 'summary_rows: 5\n'
printf 'structural_rows: 16\n'
printf 'command_counts: total=4 g1=4\n'
printf 'ordered_markers: G1 F99999.123 | G1 F1 | G1 F203.2 | G1 F203.201\n'
printf 'movement_extrusion: movement_axis_present=false extrusion_axis_present=false\n'
printf 'temperature_tool_change_markers: temperature_marker_count=0 tool_change_marker_count=0\n'
printf 'semantic_rows: 9\n'
printf 'semantic_command_classes: G1:4;feedrate_only:4\n'
printf 'semantic_movement_classes: travel:0;extrusion:0;coordinate_motion:0;feedrate_only:4\n'
printf 'semantic_coordinate_bounds: x:none;y:none;z:none\n'
printf 'semantic_extrusion_total: e_axis_observed:false;extrusion_total:not_observed\n'
printf 'semantic_feedrates: F99999.123;F1;F203.2;F203.201\n'
printf 'semantic_layer_markers: layer_markers:0;marker_relationships:none\n'
