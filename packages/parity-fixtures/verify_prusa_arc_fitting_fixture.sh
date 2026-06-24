#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

default_checkout_root() {
	if [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
		printf '%s\n' "${BUILD_WORKSPACE_DIRECTORY}"
		return
	fi

	cd "${script_dir}/../.." && pwd
}

checkout_root="$(default_checkout_root)"

if [[ "$#" -eq 0 ]]; then
	package_dir="${checkout_root}/packages/parity-fixtures"
	fixture_dir="${package_dir}/forks/prusaslicer/prusaslicer.arc-fitting"
	fixture_readme="${fixture_dir}/README.md"
	provenance_file="${fixture_dir}/fixture-provenance.tsv"
	arc_summary_file="${fixture_dir}/expected-arc-summary.tsv"
	gcode_file="${fixture_dir}/arc-fitting-observations.gcode"
	status_file="${checkout_root}/packages/parity/status.tsv"
	package_readme="${package_dir}/README.md"
elif [[ "$#" -eq 6 || "$#" -eq 7 ]]; then
	fixture_readme="$1"
	provenance_file="$2"
	arc_summary_file="$3"
	gcode_file="$4"
	status_file="$5"
	package_readme="$6"
	if [[ "$#" -eq 7 ]]; then
		checkout_root="$7"
	fi
else
	error "usage: verify_prusa_arc_fitting_fixture.sh [fixture-README fixture-provenance expected-arc-summary arc-observations-gcode parity-status parity-fixtures-README [checkout-root]]"
fi

readonly SOURCE_REF="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PEELED_COMMIT="9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly FIXTURE_PATH="packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode"
readonly FIXTURE_ID="arc-fitting-observations.gcode"
readonly SOURCE_PATH="src/libslic3r/Geometry/ArcWelder.cpp"
readonly SOURCE_ANCHOR="ArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634"
readonly EXPECTED_SHA="b1db8e3ef28d47f045f1eec852e4f83675da920b312abeeb3f3e40a5927f796f"
readonly EXPECTED_SIZE="94"
readonly ARC_SUMMARY_HEADER=$'source_ref\tfixture_path\tarc_field\tarc_category\tarc_value\tevidence_boundary'
readonly ARC_SUMMARY_ROW_COUNT="13"
readonly ARC_REQUIRED_FIELDS="source_ref inventory_source_paths source_anchor fixture_id fixture_path arc_command_counts arc_direction_counts center_offset_observations coordinate_bounds extrusion_observations feedrate_observations evidence_boundary"
readonly PROVENANCE_HEADER=$'fixture_id\tvendor_id\tinventory_id\tsource_ref\taccepted_tag\tpeeled_commit\tsource_path\tsource_anchor\tbytes\tsha256\tline_endings_encoding\trole\tphase57_scope_record\tupdate_route\tstatus_scope\tprivacy_post_processing_exclusions\tbroad_deferrals'
readonly PROVENANCE_ROW=$'arc-fitting-observations.gcode\tprusaslicer\tprusaslicer.arc-fitting\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tversion_2.9.5\t9a583bd438b195856f3bcf7ea99b69ba4003a961\tsrc/libslic3r/Geometry/ArcWelder.cpp\tArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634\t94\tb1db8e3ef28d47f045f1eec852e4f83675da920b312abeeb3f3e40a5927f796f\tascii-lf\treviewed-arc-command-observation-fixture\tpackages/prusa-arc-fitting-scope/arc-fitting-scope.md\treviewed-intake-change-updates-packages/fork-vendors/forks.tsv-packages/fork-inventories/prusaslicer.tsv-and-packages/prusa-arc-fitting-scope/arc-fitting-scope.md\tPhase-58-fixture-corpus-only-no-parity-status\tno-generator-no-runtime-no-network-no-sync-no-host-upload-no-post-processing-no-thumbnail-no-printability-no-gui\tno-byte-for-byte-gcode-parity-no-full-arcwelder-equivalence-no-tolerance-geometry-parity-no-generated-output-status-promotion-no-printer-runtime-no-firmware-no-support-no-wall-seam-no-release-no-bambu-no-orca-no-upstream-source-import-no-sync'
readonly GCODE_OUTPUT_STATUS_ROW=$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tShared fixture comparison proves the narrow semantic Prusa G-code evidence slice backed by the Phase 53 closed semantic scope contract, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion behavior, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host '$'upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'
readonly ARC_FITTING_STATUS_ROW=$'fork.prusaslicer.arc-fitting\tverified\t//packages/parity:prusaslicer_arc_fitting_parity\tShared fixture comparison proves the narrow Prusa arc-fitting checked-in summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command only; byte-for-byte G-code parity, full generated-output parity, broad generated-output verification, full ArcWelder algorithm equivalence, tolerance or geometry parity, printability, firmware behavior, printer-runtime behavior, GUI behavior, support generation, wall seam behavior, STEP import, full 3MF import/export, binary G-code, thumbnails, post-processing, host '$'upload, network/device behavior, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, sync automation, and non-Prusa fork behavior remain deferred'
readonly GCODE_LINE_1="G2 X10.000 Y0.000 I5.000 J0.000 E0.50000 F1800"
readonly GCODE_LINE_2="G3 X0.000 Y0.000 I-5.000 J0.000 E1.00000 F1800"
readonly ARC_SOURCE_REF_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tsource_ref\tsource identity\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tAccepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.'
readonly ARC_INVENTORY_SOURCE_PATHS_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tinventory_source_paths\tsource identity\tpackages/fork-inventories/prusaslicer.tsv;src/libslic3r/Geometry/ArcWelder.cpp\tInventory source paths only: `packages/fork-inventories/prusaslicer.tsv` and `src/libslic3r/Geometry/ArcWelder.cpp`.'
readonly ARC_SOURCE_ANCHOR_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tsource_anchor\tsource identity\tArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634\tReviewed source anchors only; no upstream import, Git access, or runtime source discovery.'
readonly ARC_FIXTURE_ID_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfixture_id\tfixture identity\tarc-fitting-observations.gcode\tFixture identity string only for the Phase 58 checked-in fixture.'
readonly ARC_FIXTURE_PATH_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfixture_path\tfixture identity\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tChecked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` only.'
readonly ARC_COMMAND_COUNTS_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tarc_command_counts\tcommand observations\tG2:1;G3:1;total_arc_commands:2\tCounts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity.'
readonly ARC_DIRECTION_COUNTS_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tarc_direction_counts\tcommand observations\tclockwise_g2:1;counterclockwise_g3:1\tClockwise/counterclockwise direction observations from the checked-in summary only; no algorithm equivalence or tolerance claim.'
readonly ARC_CENTER_OFFSET_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tcenter_offset_observations\tcenter offset observations\ti_values:5.000,-5.000;j_values:0.000,0.000\tObserved I/J center-offset facts from the checked-in summary only; no geometry, planner, or printer-runtime behavior claim.'
readonly ARC_COORDINATE_BOUNDS_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tcoordinate_bounds\tcoordinate bounds\tx_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000\tBounded coordinate observations only; no toolpath geometry or printability claim.'
readonly ARC_EXTRUSION_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\textrusion_observations\textrusion observations\te_values:0.50000,1.00000;e_axis_observed:true\tSummary extrusion observations only; no material-use, runtime, or printability claim.'
readonly ARC_FEEDRATE_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfeedrate_observations\tfeedrate observations\tF1800:2\tFeedrate metadata observations only; no timing, firmware, or printer-runtime behavior claim.'
readonly ARC_EVIDENCE_BOUNDARY_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tevidence_boundary\tboundary text\tchecked-in-arc-summary-only\tChecked-in fixture summary evidence only; no executable public status claim before Phase 60.'
readonly ARC_EXPECTED_ROWS="${ARC_SOURCE_REF_ROW}"$'\n'"${ARC_INVENTORY_SOURCE_PATHS_ROW}"$'\n'"${ARC_SOURCE_ANCHOR_ROW}"$'\n'"${ARC_FIXTURE_ID_ROW}"$'\n'"${ARC_FIXTURE_PATH_ROW}"$'\n'"${ARC_COMMAND_COUNTS_ROW}"$'\n'"${ARC_DIRECTION_COUNTS_ROW}"$'\n'"${ARC_CENTER_OFFSET_ROW}"$'\n'"${ARC_COORDINATE_BOUNDS_ROW}"$'\n'"${ARC_EXTRUSION_ROW}"$'\n'"${ARC_FEEDRATE_ROW}"$'\n'"${ARC_EVIDENCE_BOUNDARY_ROW}"

require_file() {
	local file="$1"
	local label="$2"
	if [[ ! -f "${file}" ]]; then
		error "${label} file not found: ${file}"
	fi
}

require_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if ! grep -Fq -- "${pattern}" "${file}"; then
		error "${label}: missing required text: ${pattern}"
	fi
}

reject_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if grep -Fq -- "${pattern}" "${file}"; then
		error "${label}: forbidden text: ${pattern}"
	fi
}

require_exact_header() {
	local file="$1"
	local label="$2"
	local expected_header="$3"
	local actual_header
	IFS= read -r actual_header <"${file}" || error "${label}: missing header"
	if [[ "${actual_header}" != "${expected_header}" ]]; then
		error "${label}: expected header ${expected_header}"
	fi
}

require_line_count() {
	local file="$1"
	local label="$2"
	local expected_count="$3"
	local actual_count
	actual_count="$(wc -l <"${file}" | tr -d ' ')"
	if [[ "${actual_count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} rows, got ${actual_count}"
	fi
}

require_size() {
	local file="$1"
	local label="$2"
	local expected_size="$3"
	local actual_size
	actual_size="$(wc -c <"${file}" | tr -d ' ')"
	if [[ "${actual_size}" != "${expected_size}" ]]; then
		error "${label}: expected ${expected_size} bytes, got ${actual_size}"
	fi
}

require_sha256() {
	local file="$1"
	local label="$2"
	local expected_sha="$3"
	local actual_sha
	actual_sha="$(shasum -a 256 "${file}" | awk '{ print $1 }')"
	if [[ "${actual_sha}" != "${expected_sha}" ]]; then
		error "${label}: expected SHA-256 ${expected_sha}, got ${actual_sha}"
	fi
}

require_exact_line() {
	local file="$1"
	local label="$2"
	local expected_line="$3"
	local description="$4"
	if ! grep -Fxq -- "${expected_line}" "${file}"; then
		error "${label}: missing required row for ${description}: ${expected_line}"
	fi
}

require_first_field_count() {
	local file="$1"
	local label="$2"
	local id="$3"
	local expected_count="$4"
	local count

	count="$(awk -F '\t' -v id="${id}" '$1 == id { count++ } END { print count + 0 }' "${file}")"
	if [[ "${count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} row(s) with first field ${id}, found ${count}"
	fi
}

require_ascii_lf() {
	local file="$1"
	local label="$2"
	if ! LC_ALL=C awk '
		index($0, "\r") { exit 1 }
		{
			for (i = 1; i <= length($0); i++) {
				character = substr($0, i, 1)
				if (character == "\t") {
					continue
				}
				if (character < " " || character > "~") {
					exit 1
				}
			}
		}
	' "${file}"; then
		error "${label}: expected US-ASCII text with LF line endings"
	fi
}

require_tsv_column_count() {
	local file="$1"
	local label="$2"
	local expected_count="$3"
	awk -F '\t' -v label="${label}" -v expected_count="${expected_count}" '
		NR == 1 { next }
		NF != expected_count {
			printf "error: %s: expected %d columns on line %d, got %d\n", label, expected_count, NR, NF > "/dev/stderr"
			exit 1
		}
	' "${file}"
}

reject_verifier_behavior_terms() {
	local verifier_file="${BASH_SOURCE[0]}"
	local term_http term_git_space term_git_tab term_cl term_ft
	local term_prusaslicer term_slic3r term_send_gcode term_host_upload
	local forbidden_term

	term_http="cu""rl "
	term_git_space="g""it "
	term_git_tab="$(printf 'g%s\t' "it")"
	term_cl="cl""one"
	term_ft="fet""ch"
	term_prusaslicer="PrusaSlicer ""--"
	term_slic3r="slic3r ""--"
	term_send_gcode="send-""gcode"
	term_host_upload="host ""upload"

	for forbidden_term in \
		"${term_http}" \
		"${term_git_space}" \
		"${term_git_tab}" \
		"${term_cl}" \
		"${term_ft}" \
		"${term_prusaslicer}" \
		"${term_slic3r}" \
		"${term_send_gcode}" \
		"${term_host_upload}"; do
		if grep -Fq -- "${forbidden_term}" "${verifier_file}"; then
			error "verify_prusa_arc_fitting_fixture.sh: forbidden verifier behavior term present"
		fi
	done
}

reject_overclaiming_text() {
	local checked_file
	local checked_label
	local forbidden_claim

	for checked_file in "${fixture_readme}" "${package_readme}" "${provenance_file}" "${arc_summary_file}" "${BASH_SOURCE[0]}"; do
		checked_label="$(basename "${checked_file}")"
		for forbidden_claim in \
			"verified Prusa arc-fitting ""parity" \
			"byte-for-byte G-code parity ""verified" \
			"full ArcWelder algorithm equivalence ""verified" \
			"tolerance or geometry parity ""verified" \
			"printability ""verified" \
			"firmware behavior ""verified" \
			"printer-runtime behavior ""verified" \
			"GUI behavior ""verified" \
			"support generation ""verified" \
			"wall seam behavior ""verified" \
			"release behavior ""verified" \
			"host ""upload verified" \
			"Bambu Studio support ""verified" \
			"OrcaSlicer support ""verified" \
			"upstream import ""verified" \
			"sync automation ""verified"; do
			reject_text "${checked_file}" "${checked_label}" "${forbidden_claim}"
		done
	done
}

verify_gcode_file() {
	require_ascii_lf "${gcode_file}" "arc-fitting-observations.gcode"
	require_line_count "${gcode_file}" "arc-fitting-observations.gcode" "2"
	require_size "${gcode_file}" "arc-fitting-observations.gcode" "${EXPECTED_SIZE}"
	require_sha256 "${gcode_file}" "arc-fitting-observations.gcode" "${EXPECTED_SHA}"
	require_exact_line "${gcode_file}" "arc-fitting-observations.gcode" "${GCODE_LINE_1}" "line 1 G2 observation"
	require_exact_line "${gcode_file}" "arc-fitting-observations.gcode" "${GCODE_LINE_2}" "line 2 G3 observation"
}

verify_provenance() {
	require_ascii_lf "${provenance_file}" "fixture-provenance.tsv"
	require_exact_header "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_HEADER}"
	require_tsv_column_count "${provenance_file}" "fixture-provenance.tsv" "17"
	require_exact_line "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_ROW}" "${FIXTURE_ID} provenance"
	require_line_count "${provenance_file}" "fixture-provenance.tsv" "2"
}

require_arc_allowed_fields() {
	awk -F '\t' -v label="expected-arc-summary.tsv" '
		NR == 1 { next }
		$3 != "source_ref" &&
			$3 != "inventory_source_paths" &&
			$3 != "source_anchor" &&
			$3 != "fixture_id" &&
			$3 != "fixture_path" &&
			$3 != "arc_command_counts" &&
			$3 != "arc_direction_counts" &&
			$3 != "center_offset_observations" &&
			$3 != "coordinate_bounds" &&
			$3 != "extrusion_observations" &&
			$3 != "feedrate_observations" &&
			$3 != "evidence_boundary" {
			printf "error: %s: unsupported arc field: %s\n", label, $3 > "/dev/stderr"
			exit 1
		}
	' "${arc_summary_file}"
}

require_arc_field_counts() {
	awk -F '\t' \
		-v label="expected-arc-summary.tsv" \
		-v required_fields="${ARC_REQUIRED_FIELDS}" '
		BEGIN {
			required_count = split(required_fields, required, " ")
		}
		NR == 1 { next }
		{
			counts[$3]++
		}
		END {
			failed = 0
			for (i = 1; i <= required_count; i++) {
				field = required[i]
				actual = counts[field] + 0
				if (actual == 1) {
					continue
				}
				if (actual > 1) {
					printf "error: %s: duplicate arc field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
				} else {
					printf "error: %s: missing arc field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
				}
				failed = 1
			}
			exit failed
		}
	' "${arc_summary_file}"
}

require_arc_provenance_alignment() {
	awk -F '\t' \
		-v label="expected-arc-summary.tsv" \
		-v source_ref="${SOURCE_REF}" \
		-v fixture_path="${FIXTURE_PATH}" '
		NR == 1 { next }
		$1 != source_ref || $2 != fixture_path {
			printf "error: %s: provenance mismatch for %s\n", label, $3 > "/dev/stderr"
			exit 1
		}
	' "${arc_summary_file}"
}

require_arc_value() {
	local field="$1"
	local expected_value="$2"
	local actual_value
	actual_value="$(awk -F '\t' -v field="${field}" '$3 == field { print $5; exit }' "${arc_summary_file}")"
	if [[ "${actual_value}" != "${expected_value}" ]]; then
		error "expected-arc-summary.tsv: arc value mismatch for ${field}: expected ${expected_value}, got ${actual_value}"
	fi
}

require_arc_exact_rows() {
	local actual_row
	local actual_field
	local expected_field
	local expected_row
	local row_number

	row_number=2
	while IFS= read -r expected_row; do
		actual_row="$(awk -v row_number="${row_number}" 'NR == row_number { print; exit }' "${arc_summary_file}")"
		if [[ "${actual_row}" == "${expected_row}" ]]; then
			row_number=$((row_number + 1))
			continue
		fi

		expected_field="$(printf '%s\n' "${expected_row}" | awk -F '\t' '{ print $3 }')"
		actual_field="$(printf '%s\n' "${actual_row}" | awk -F '\t' '{ print $3 }')"
		if [[ -n "${actual_field}" && "${actual_field}" != "${expected_field}" ]]; then
			error "expected-arc-summary.tsv: arc rows out of order near ${actual_field}"
		fi
		error "expected-arc-summary.tsv: missing required row for ${expected_field}"
	done <<<"${ARC_EXPECTED_ROWS}"
}

verify_arc_summary() {
	require_ascii_lf "${arc_summary_file}" "expected-arc-summary.tsv"
	require_exact_header "${arc_summary_file}" "expected-arc-summary.tsv" "${ARC_SUMMARY_HEADER}"
	require_tsv_column_count "${arc_summary_file}" "expected-arc-summary.tsv" "6"
	require_arc_allowed_fields
	require_arc_field_counts
	require_arc_provenance_alignment
	require_arc_value "source_ref" "${SOURCE_REF}"
	require_arc_value "inventory_source_paths" "packages/fork-inventories/prusaslicer.tsv;${SOURCE_PATH}"
	require_arc_value "source_anchor" "${SOURCE_ANCHOR}"
	require_arc_value "fixture_id" "${FIXTURE_ID}"
	require_arc_value "fixture_path" "${FIXTURE_PATH}"
	require_arc_value "arc_command_counts" "G2:1;G3:1;total_arc_commands:2"
	require_arc_value "arc_direction_counts" "clockwise_g2:1;counterclockwise_g3:1"
	require_arc_value "center_offset_observations" "i_values:5.000,-5.000;j_values:0.000,0.000"
	require_arc_value "coordinate_bounds" "x_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000"
	require_arc_value "extrusion_observations" "e_values:0.50000,1.00000;e_axis_observed:true"
	require_arc_value "feedrate_observations" "F1800:2"
	require_arc_value "evidence_boundary" "checked-in-arc-summary-only"
	require_arc_exact_rows
	require_line_count "${arc_summary_file}" "expected-arc-summary.tsv" "${ARC_SUMMARY_ROW_COUNT}"
}

verify_namespace_readme() {
	require_text "${fixture_readme}" "fixture README" "# PrusaSlicer Arc-Fitting Fixture"
	require_text "${fixture_readme}" "fixture README" "This namespace is \`prusaslicer.arc-fitting\`."
	require_text "${fixture_readme}" "fixture README" "${SOURCE_REF}"
	require_text "${fixture_readme}" "fixture README" "\`arc-fitting-observations.gcode\` is the small reviewed G2/G3 observation"
	require_text "${fixture_readme}" "fixture README" "\`fixture-provenance.tsv\` pins the fixture to"
	require_text "${fixture_readme}" "fixture README" "\`expected-arc-summary.tsv\` records exactly the Phase 57 approved arc fields"
	require_text "${fixture_readme}" "fixture README" "\`packages/prusa-arc-fitting-scope/arc-fitting-scope.md\` remains the reviewed"
	require_text "${fixture_readme}" "fixture README" "Update this namespace only after a reviewed intake change updates"
	require_text "${fixture_readme}" "fixture README" "\`packages/fork-vendors/forks.tsv\`"
	require_text "${fixture_readme}" "fixture README" "\`packages/fork-inventories/prusaslicer.tsv\`"
	require_text "${fixture_readme}" "fixture README" "\`packages/prusa-arc-fitting-scope/arc-fitting-scope.md\`"
	require_text "${fixture_readme}" "fixture README" "Phase 58 owns only the checked-in \`prusaslicer.arc-fitting\` fixture namespace"
	require_text "${fixture_readme}" "fixture README" "Phase 59 owns future"
	require_text "${fixture_readme}" "fixture README" "\`slic3r_flavors::prusa_arc_fitting\` Rust parser/readiness work"
	require_text "${fixture_readme}" "fixture README" "Phase 60 owns"
	require_text "${fixture_readme}" "fixture README" "\`bazel run //packages/parity:prusaslicer_arc_fitting_parity\` evidence"
	require_text "${fixture_readme}" "fixture README" "future \`fork.prusaslicer.arc-fitting\` status row"
}

verify_package_readme() {
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "Phase 58 adds the Prusa arc-fitting fixture namespace"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "arc-fitting-observations.gcode"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "fixture-provenance.tsv"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "expected-arc-summary.tsv"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "//packages/parity-fixtures:prusa_arc_fitting_bundle"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "${SOURCE_REF}"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "${SOURCE_PATH}"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "Phase 59 owns \`slic3r_flavors::prusa_arc_fitting\`"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "Phase 60 owns \`bazel run //packages/parity:prusaslicer_arc_fitting_parity\`"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "Phase 58 does not update \`packages/parity/status.tsv\`"
}

verify_status_boundaries() {
	local generated_outputs_count

	require_exact_line "${status_file}" "packages/parity/status.tsv" "${ARC_FITTING_STATUS_ROW}" "fork.prusaslicer.arc-fitting status"
	require_first_field_count "${status_file}" "packages/parity/status.tsv" "fork.prusaslicer.arc-fitting" "1"

	generated_outputs_count="$(awk -F '\t' '$1 == "generated-outputs" && $2 == "in progress" { count++ } END { print count + 0 }' "${status_file}")"
	if [[ "${generated_outputs_count}" != "1" ]]; then
		error "packages/parity/status.tsv: expected one generated-outputs in progress row, got ${generated_outputs_count}"
	fi
	require_first_field_count "${status_file}" "packages/parity/status.tsv" "generated-outputs" "1"

	require_exact_line "${status_file}" "packages/parity/status.tsv" "${GCODE_OUTPUT_STATUS_ROW}" "fork.prusaslicer.gcode-output status"
	require_first_field_count "${status_file}" "packages/parity/status.tsv" "fork.prusaslicer.gcode-output" "1"
}

for required_file in \
	"${fixture_readme}" \
	"${provenance_file}" \
	"${arc_summary_file}" \
	"${gcode_file}" \
	"${status_file}" \
	"${package_readme}"; do
	require_file "${required_file}" "input"
done

reject_verifier_behavior_terms
reject_overclaiming_text
verify_gcode_file
verify_provenance
verify_arc_summary
verify_namespace_readme
verify_package_readme
verify_status_boundaries

printf 'ok: Prusa arc-fitting fixture verification passed\n'
