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
	readme_file="${script_dir}/README.md"
	scope_file="${script_dir}/arc-fitting-scope.md"
	inventory_file="${checkout_root}/packages/fork-inventories/prusaslicer.tsv"
	category_map_file="${checkout_root}/packages/fork-inventories/category-map.tsv"
	status_file="${checkout_root}/packages/parity/status.tsv"
elif [[ "$#" -eq 5 ]]; then
	readme_file="$1"
	scope_file="$2"
	inventory_file="$3"
	category_map_file="$4"
	status_file="$5"
elif [[ "$#" -eq 6 ]]; then
	readme_file="$1"
	scope_file="$2"
	inventory_file="$3"
	category_map_file="$4"
	status_file="$5"
	checkout_root="$6"
else
	error "usage: verify_prusa_arc_fitting_scope.sh [README arc-fitting-scope inventory category-map parity-status [checkout-root]]"
fi

readonly ACCEPTED_SOURCE_IDENTITY="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly ARC_FITTING_INVENTORY_ROW=$'prusaslicer.arc-fitting\tprusaslicer\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tsrc/libslic3r/Geometry/ArcWelder.cpp\tarc-fitting\tarc-fitting\tshared-downstream\tmedium\tgenerated-outputs\tfuture-candidate\tnone\tArc fitting planning row; future parity requires G-code output comparison evidence.'
readonly ARC_CATEGORY_MAP_ID="arc.shared"
readonly GCODE_OUTPUT_STATUS_ROW=$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tShared fixture comparison proves the narrow semantic Prusa G-code evidence slice backed by the Phase 53 closed semantic scope contract, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion behavior, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'
readonly SCOPE_RECORD_SECTION="## Scope Record"
readonly SOURCE_ROW_SECTION="## Source Row Details"
readonly ARC_FIELD_SECTION="## Approved Arc Evidence Fields"
readonly TRACEABILITY_SECTION="## Arc-Fitting Traceability"

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
		error "${label}: forbidden Prusa arc-fitting scope claim: ${pattern}"
	fi
}

require_section_table_row() {
	local file="$1"
	local label="$2"
	local section="$3"
	local field="$4"
	local value="$5"
	local row="| ${field} | ${value} |"

	require_section_table_exact_row "${file}" "${label}" "${section}" "${row}"
}

require_section_table_exact_row() {
	local file="$1"
	local label="$2"
	local section="$3"
	local row="$4"

	if ! awk -v section="${section}" -v row="${row}" '
		$0 == section { in_section = 1; next }
		in_section && /^## / { exit }
		in_section && $0 == row { found = 1; exit }
		END { exit found ? 0 : 1 }
	' "${file}"; then
		error "${label}: missing required table row in ${section}: ${row}"
	fi
}

require_section_table_body_row_count() {
	local file="$1"
	local label="$2"
	local section="$3"
	local expected_count="$4"
	local count

	count="$(awk -v section="${section}" '
		$0 == section { in_section = 1; next }
		in_section && /^## / { exit }
		in_section && /^[[:space:]]*\|[[:space:]]*Arc Field[[:space:]]*\|/ { next }
		in_section && /^[[:space:]]*\|[[:space:]]*---[[:space:]]*\|/ { next }
		in_section && /^[[:space:]]*\|/ { count++ }
		END { print count + 0 }
	' "${file}")"

	if [[ "${count}" != "${expected_count}" ]]; then
		error "${label}: ${section}: expected exactly 12 arc evidence field rows, found ${count}; required fields include arc_command_counts"
	fi
}

require_exact_tsv_row_once() {
	local file="$1"
	local label="$2"
	local expected_row="$3"
	local count

	count="$(awk -v expected_row="${expected_row}" '$0 == expected_row { count++ } END { print count + 0 }' "${file}")"
	if [[ "${count}" != "1" ]]; then
		error "${label}: expected exact row once: ${expected_row}"
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

require_category_reference_count() {
	local file="$1"
	local label="$2"
	local id="$3"
	local expected_count="$4"
	local count

	count="$(awk -F '\t' -v id="${id}" '
		/^#/ || NF == 0 { next }
		{
			split($5, inventory_ids, ";")
			for (idx in inventory_ids) {
				if (inventory_ids[idx] == id) {
					count++
				}
			}
		}
		END { print count + 0 }
	' "${file}")"

	if [[ "${count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} category-map reference(s) to ${id}, found ${count}"
	fi
}

verify_readme() {
	require_text "${readme_file}" "README.md" \
		"\`packages/prusa-arc-fitting-scope\` owns the Phase 57 reviewed scope contract for \`prusaslicer.arc-fitting\`."
}

verify_scope_record() {
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Inventory row ID" "\`prusaslicer.arc-fitting\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Accepted source identity" "\`${ACCEPTED_SOURCE_IDENTITY}\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Inventory row source" "\`packages/fork-inventories/prusaslicer.tsv\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Source path" "\`src/libslic3r/Geometry/ArcWelder.cpp\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Fixture namespace decision" "Phase 58 planned namespace \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/\`; no fixture bytes are checked in during Phase 57."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Expected-summary contract" "Phase 58 planned \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv\` with the approved Phase 57 arc evidence fields; no expected arc summary artifact is checked in during Phase 57."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Candidate Rust boundary" "Phase 59 planned \`slic3r_flavors::prusa_arc_fitting\` pure data-in/data-out boundary over caller-supplied checked-in arc summaries; no Rust parser implementation is created in Phase 57."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Planned evidence command" "Phase 60 planned \`bazel run //packages/parity:prusaslicer_arc_fitting_parity\`; the target is not created in Phase 57."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Planned status token" "Phase 60 planned \`fork.prusaslicer.arc-fitting\` after executable evidence passes; no verified \`packages/parity/status.tsv\` row is published in Phase 57."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Docs touched" "\`packages/prusa-arc-fitting-scope/README.md\`; \`packages/prusa-arc-fitting-scope/arc-fitting-scope.md\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Security note" "No secrets, credentials, private data, runtime file discovery, Git, network, device, host upload, release, sync, upstream import, or printer-runtime behavior is introduced by the Phase 57 arc-fitting scope contract."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Deferred scope" "Byte-for-byte G-code parity; broad generated-output verification; full ArcWelder algorithm equivalence; tolerance or geometry parity; printability; printer-runtime behavior; support generation; wall seam behavior; GUI behavior; release behavior; network/device behavior; non-Prusa fork behavior; upstream source imports; sync automation."
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SCOPE_RECORD_SECTION}" "Reviewer signoff" "Peter Ryszkiewicz, 2026-06-23 UTC"
}

verify_source_row_details() {
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Source path" "\`src/libslic3r/Geometry/ArcWelder.cpp\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Feature surface" "\`arc-fitting\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Feature category" "\`arc-fitting\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Ownership" "\`shared-downstream\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Complexity" "\`medium\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Parity dependency" "\`generated-outputs\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Inventory decision" "\`future-candidate\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Caution flags" "\`none\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${SOURCE_ROW_SECTION}" "Inventory note" "Arc fitting planning row; future parity requires G-code output comparison evidence."
}

verify_arc_field_contract() {
	require_section_table_body_row_count "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" "12"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| source_ref | source identity | Accepted PrusaSlicer source identity only: \`${ACCEPTED_SOURCE_IDENTITY}\`. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| inventory_source_paths | source identity | Inventory source paths only: \`src/libslic3r/Geometry/ArcWelder.cpp\`. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| source_anchor | source identity | Reviewed source anchor text or line reference only; no upstream import, Git access, or runtime source discovery. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| fixture_id | fixture identity | Fixture identity string only for the Phase 58 checked-in fixture. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| fixture_path | fixture identity | Checked-in fixture path under \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/\` only. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| arc_command_counts | command observations | Counts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| arc_direction_counts | command observations | Clockwise/counterclockwise direction observations from the checked-in summary only; no algorithm equivalence or tolerance claim. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| center_offset_observations | center offset observations | Observed I/J center-offset facts from the checked-in summary only; no geometry, planner, or printer-runtime behavior claim. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| coordinate_bounds | coordinate bounds | Bounded coordinate observations only; no toolpath geometry or printability claim. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| extrusion_observations | extrusion observations | Summary extrusion observations only; no material-use, runtime, or printability claim. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| feedrate_observations | feedrate observations | Feedrate metadata observations only; no timing, firmware, or printer-runtime behavior claim. |"
	require_section_table_exact_row "${scope_file}" "arc-fitting-scope.md" "${ARC_FIELD_SECTION}" \
		"| evidence_boundary | boundary text | Explicit statement of what the summary proves and what remains deferred; no executable public status claim before Phase 60. |"
}

verify_traceability_record() {
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Inventory row" "\`prusaslicer.arc-fitting\` in \`packages/fork-inventories/prusaslicer.tsv\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Category-map row" "\`${ARC_CATEGORY_MAP_ID}\` in \`packages/fork-inventories/category-map.tsv\` references \`prusaslicer.arc-fitting\` exactly once"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Accepted source identity" "\`${ACCEPTED_SOURCE_IDENTITY}\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Source path" "\`src/libslic3r/Geometry/ArcWelder.cpp\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Planned fixture namespace" "\`packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Planned expected summary" "\`packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Planned Rust boundary" "\`slic3r_flavors::prusa_arc_fitting\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Planned public evidence command" "\`bazel run //packages/parity:prusaslicer_arc_fitting_parity\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Planned narrow status row" "Phase 60 planned \`fork.prusaslicer.arc-fitting\` remains limited to the narrow v1.15 checked-in arc summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Existing G-code status row" "\`fork.prusaslicer.gcode-output\` stays limited to the existing semantic Prusa G-code evidence slice backed by Phase 53 through Phase 56"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Broad status row" "\`generated-outputs\` stays \`in progress\` in \`packages/parity/status.tsv\`"
	require_section_table_row "${scope_file}" "arc-fitting-scope.md" \
		"${TRACEABILITY_SECTION}" "Docs touched" "\`packages/prusa-arc-fitting-scope/arc-fitting-scope.md\`; \`packages/prusa-arc-fitting-scope/README.md\`"
}

verify_inventory_row() {
	require_exact_tsv_row_once "${inventory_file}" "packages/fork-inventories/prusaslicer.tsv" "${ARC_FITTING_INVENTORY_ROW}"
	require_first_field_count "${inventory_file}" "packages/fork-inventories/prusaslicer.tsv" "prusaslicer.arc-fitting" "1"
	require_category_reference_count "${category_map_file}" "packages/fork-inventories/category-map.tsv" "prusaslicer.arc-fitting" "1"

	local category_row_count
	category_row_count="$(awk -F '\t' -v map_id="${ARC_CATEGORY_MAP_ID}" '$1 == map_id { count++ } END { print count + 0 }' "${category_map_file}")"
	if [[ "${category_row_count}" != "1" ]]; then
		error "packages/fork-inventories/category-map.tsv: expected exactly one ${ARC_CATEGORY_MAP_ID} row, found ${category_row_count}"
	fi
}

verify_status_boundaries() {
	local generated_count
	local arc_status_count

	generated_count="$(awk -F '\t' '$1 == "generated-outputs" && $2 == "in progress" { count++ } END { print count + 0 }' "${status_file}")"
	if [[ "${generated_count}" != "1" ]]; then
		error "packages/parity/status.tsv: expected generated-outputs to remain in progress"
	fi

	require_exact_tsv_row_once "${status_file}" "packages/parity/status.tsv" "${GCODE_OUTPUT_STATUS_ROW}"
	require_first_field_count "${status_file}" "packages/parity/status.tsv" "fork.prusaslicer.gcode-output" "1"

	arc_status_count="$(awk -F '\t' '$1 == "fork.prusaslicer.arc-fitting" { count++ } END { print count + 0 }' "${status_file}")"
	if [[ "${arc_status_count}" != "0" ]]; then
		error "packages/parity/status.tsv: no verified fork.prusaslicer.arc-fitting status row may be published in Phase 57"
	fi
}

reject_overclaiming_text() {
	local checked_file
	local checked_label
	local forbidden_claim
	local overclaim_term_then_verb_pattern
	local overclaim_terms
	local overclaim_verbs
	local overclaim_verb_then_term_pattern

	overclaim_terms='byte-for-byte G-code parity|broad generated-output parity|broad generated-output verification|full ArcWelder algorithm equivalence|tolerance parity|geometry parity|printability|printer-runtime behavior|firmware behavior|support generation|wall seam behavior|GUI behavior|release behavior|network/device behavior|non-Prusa fork behavior|Bambu Studio support|OrcaSlicer support|upstream source imports|sync automation'
	overclaim_verbs='proves|verified|verifies|validates?|confirms?|claims?|establishes?|demonstrates?|certifies?'
	overclaim_verb_then_term_pattern="Phase 57[^.]*[^[:alnum:]_](${overclaim_verbs})[^[:alnum:]_][^.]*(${overclaim_terms})"
	overclaim_term_then_verb_pattern="Phase 57[^.]*(${overclaim_terms})[^.]*[^[:alnum:]_](${overclaim_verbs})[^[:alnum:]_]"

	for checked_file in "${readme_file}" "${scope_file}"; do
		checked_label="$(basename "${checked_file}")"
		for forbidden_claim in \
			"Phase 57 proves byte-for-byte G-code parity" \
			"Phase 57 proves broad generated-output parity" \
			"Phase 57 verifies broad generated-output verification" \
			"Phase 57 verifies full ArcWelder algorithm equivalence" \
			"Phase 57 validates tolerance parity" \
			"Phase 57 validates geometry parity" \
			"Phase 57 confirms printability" \
			"Phase 57 claims printer-runtime behavior" \
			"Phase 57 establishes firmware behavior" \
			"Phase 57 demonstrates support generation" \
			"Phase 57 certifies wall seam behavior" \
			"Phase 57 proves GUI behavior" \
			"Phase 57 proves release behavior" \
			"Phase 57 proves network/device behavior" \
			"Phase 57 proves non-Prusa fork behavior" \
			"Phase 57 proves Bambu Studio support" \
			"Phase 57 proves OrcaSlicer support" \
			"Phase 57 proves upstream source imports" \
			"Phase 57 proves sync automation" \
			"byte-for-byte G-code parity verified by Phase 57" \
			"broad generated-output parity verified by Phase 57" \
			"full ArcWelder algorithm equivalence certified by Phase 57" \
			"Bambu Studio support verified by Phase 57" \
			"OrcaSlicer support verified by Phase 57"; do
			reject_text "${checked_file}" "${checked_label}" "${forbidden_claim}"
		done
		if grep -Eiq -- "${overclaim_verb_then_term_pattern}|${overclaim_term_then_verb_pattern}" "${checked_file}"; then
			error "${checked_label}: forbidden Prusa arc-fitting scope overclaim"
		fi
	done
}

verify_deferred_scope_terms() {
	for deferred_term in \
		"Byte-for-byte G-code parity" \
		"broad generated-output verification" \
		"full ArcWelder algorithm equivalence" \
		"tolerance or geometry parity" \
		"printability" \
		"printer-runtime behavior" \
		"support generation" \
		"wall seam behavior" \
		"GUI behavior" \
		"release behavior" \
		"network/device behavior" \
		"non-Prusa fork behavior" \
		"upstream source imports" \
		"sync automation"; do
		require_text "${scope_file}" "arc-fitting-scope.md" "${deferred_term}"
	done
}

main() {
	require_file "${readme_file}" "README.md"
	require_file "${scope_file}" "arc-fitting-scope.md"
	require_file "${inventory_file}" "packages/fork-inventories/prusaslicer.tsv"
	require_file "${category_map_file}" "packages/fork-inventories/category-map.tsv"
	require_file "${status_file}" "packages/parity/status.tsv"

	verify_readme
	verify_scope_record
	verify_source_row_details
	verify_arc_field_contract
	verify_traceability_record
	verify_inventory_row
	verify_status_boundaries
	reject_overclaiming_text
	verify_deferred_scope_terms

	printf 'ok: Prusa arc-fitting scope verification passed\n'
}

main "$@"
