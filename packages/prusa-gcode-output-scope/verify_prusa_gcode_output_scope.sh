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
	scope_file="${script_dir}/gcode-output-scope.md"
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
	error "usage: verify_prusa_gcode_output_scope.sh [README gcode-output-scope inventory category-map parity-status [checkout-root]]"
fi

readonly ACCEPTED_SOURCE_IDENTITY="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PLANNED_PARITY_COMMAND="bazel run //packages/parity:prusaslicer""_gcode_output_parity"
readonly INVENTORY_ROW=$'prusaslicer.gcode-output\tprusaslicer\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tsrc/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp\tgcode-output\tgcode-output\tshared-downstream\thigh\tgenerated-outputs\tfuture-candidate\tnone\tSource-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed.'
readonly CATEGORY_MAP_ROW=$'gcode.shared\tgcode-output\tshared-downstream\tfuture-candidate\tprusaslicer.gcode-output\tPrusa G-code output row needs reviewed source-pinned summary evidence before generated-output behavior is claimed.'
readonly GCODE_OUTPUT_STATUS_ROW=$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tShared fixture comparison proves the narrow summary-only Prusa G-code evidence slice backed by the Phase 46 fixture and Phase 47 Rust summary boundary only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'
readonly STRUCTURAL_SCOPE_SECTION="## v1.13 Structural Evidence Scope"
readonly STRUCTURAL_TRACEABILITY_SECTION="## v1.13 Structural Traceability"
readonly STRUCTURAL_FIELD_ROW_COUNT="16"

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
		error "${label}: forbidden Prusa G-code scope claim: ${pattern}"
	fi
}

require_section_table_row() {
	local file="$1"
	local label="$2"
	local section="$3"
	local field="$4"
	local value="$5"
	local row="| ${field} | ${value} |"

	if ! awk -v section="${section}" -v row="${row}" '
		$0 == section { in_section = 1; next }
		in_section && /^## / { exit }
		in_section && $0 == row { found = 1; exit }
		END { exit found ? 0 : 1 }
	' "${file}"; then
		error "${label}: missing required table row in ${section}: ${row}"
	fi
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
		in_section && /^## / { in_section = 0 }
		in_section && /^\| [a-z0-9_]+ \|/ { count++ }
		END { print count + 0 }
	' "${file}")"

	if [[ "${count}" != "${expected_count}" ]]; then
		error "${label}: ${section}: expected exactly ${expected_count} structural field rows, found ${count}; required fields include source_ref"
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
	local count
	count="$(awk -F '\t' -v id="${id}" '$1 == id { count++ } END { print count + 0 }' "${file}")"
	if [[ "${count}" != "1" ]]; then
		error "${label}: expected exactly one row with first field ${id}, found ${count}"
	fi
}

require_category_reference_count() {
	local file="$1"
	local label="$2"
	local id="$3"
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
	if [[ "${count}" != "1" ]]; then
		error "${label}: expected exactly one category-map reference to ${id}, found ${count}"
	fi
}

verify_status_published() {
	if ! grep -Fxq -- "${GCODE_OUTPUT_STATUS_ROW}" "${status_file}"; then
		error "packages/parity/status.tsv: missing required row for fork.prusaslicer.gcode-output status/evidence/notes"
	fi

	local status_count
	status_count="$(awk -F '\t' '$1 == "fork.prusaslicer.gcode-output" { count++ } END { print count + 0 }' "${status_file}")"
	if [[ "${status_count}" != "1" ]]; then
		error "packages/parity/status.tsv: fork.prusaslicer.gcode-output status: duplicate rows: ${status_count}"
	fi
}

verify_parity_target_published() {
	local parity_build="${checkout_root}/packages/parity/BUILD.bazel"
	local parity_target_pattern
	if [[ ! -r "${parity_build}" ]]; then
		error "packages/parity/BUILD.bazel: missing parity build file"
	fi

	parity_target_pattern="name[[:space:]]*=[[:space:]]*['\"]prusaslicer_gcode_output_parity['\"]"
	if ! grep -Eq -- "${parity_target_pattern}" "${parity_build}"; then
		error "packages/parity/BUILD.bazel: missing parity target: prusaslicer_gcode_output_parity"
	fi
}

verify_phase48_publication() {
	verify_status_published
	verify_parity_target_published
}

reject_overclaiming_text() {
	local checked_file
	local checked_label
	local forbidden_claim

	for checked_file in "${readme_file}" "${scope_file}"; do
		checked_label="$(basename "${checked_file}")"
		for forbidden_claim in \
			"Phase 45 verifies Prusa G-code output parity" \
			"verified Prusa G-code output parity" \
			"byte-for-byte G-code parity verified" \
			"full generated-output parity verified" \
			"Phase 45 verifies Bambu Studio support" \
			"verified Bambu Studio support" \
			"Bambu Studio support verified" \
			"Phase 45 verifies OrcaSlicer support" \
			"verified OrcaSlicer support" \
			"OrcaSlicer support verified" \
			"Phase 49 structural evidence proves byte-for-byte G-code parity" \
			"Phase 49 structural evidence proves full generated-output parity" \
			"Phase 49 structural evidence proves broad generated-output parity" \
			"Phase 49 structural evidence proves toolpath geometry" \
			"Phase 49 structural evidence proves printability" \
			"Phase 49 structural evidence proves printer-runtime behavior" \
			"Phase 49 structural evidence proves support generation" \
			"Phase 49 structural evidence proves wall seam behavior" \
			"Phase 49 structural evidence proves arc fitting" \
			"Phase 49 structural evidence proves GUI export/viewer behavior" \
			"Phase 49 structural evidence proves release behavior" \
			"Phase 49 structural evidence proves network/device behavior" \
			"Phase 49 structural evidence proves non-Prusa fork behavior" \
			"Phase 49 structural evidence proves Bambu Studio support" \
			"Phase 49 structural evidence proves OrcaSlicer support" \
			"Phase 49 structural evidence proves upstream source imports" \
			"Phase 49 structural evidence proves sync automation" \
			"Phase 49 verifies printer-runtime behavior"; do
			reject_text "${checked_file}" "${checked_label}" "${forbidden_claim}"
		done
	done
}

verify_readme() {
	require_text "${readme_file}" "README.md" \
		"\`packages/prusa-gcode-output-scope\` owns the Phase 45 reviewed scope gate and the Phase 49 structural evidence scope contract for \`prusaslicer.gcode-output\`."
	require_text "${readme_file}" "README.md" \
		"bazel run //packages/prusa-gcode-output-scope:verify"
	require_text "${readme_file}" "README.md" \
		"Phase 49 structural verification allows only command counts, section counts, ordered markers, movement/extrusion indicators, temperature/tool-change markers, source identity, and fixture identity for the narrow Prusa G-code evidence chain."
	require_text "${readme_file}" "README.md" \
		"Phase 49 structural verification keeps broad generated-outputs in progress and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation."
	require_text "${readme_file}" "README.md" \
		"Phase 45 verification does not prove executable Prusa G-code output parity."
	require_text "${readme_file}" "README.md" \
		"Phase 45 verification does not prove byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, or sync automation."
	require_text "${readme_file}" "README.md" \
		"This package creates no fixture bytes, expected-gcode-summary.tsv, Rust G-code summary implementation, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, printer-runtime behavior, host upload, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build."
}

verify_scope_record() {
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Inventory row ID" "\`prusaslicer.gcode-output\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Accepted source identity" "\`${ACCEPTED_SOURCE_IDENTITY}\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Inventory row source" "\`packages/fork-inventories/prusaslicer.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Source path" "\`src/libslic3r/GCode.cpp\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Companion API evidence" "\`src/libslic3r/GCode.hpp\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Fixture source decision" "Phase 46 source-pinned ASCII \`.gcode\` fixture under \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/\`; no fixture bytes are checked in during Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Expected-summary contract" "Phase 46 \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv\` with \`source_ref\`, \`fixture_path\`, \`metadata_key\`, \`metadata_value\`, \`marker_key\`, \`marker_value\`, and \`notes\` columns; no expected summary artifact is checked in during Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Candidate Rust boundary" "Phase 47 \`slic3r_flavors::prusa_gcode_output\` pure data-in/data-out G-code summary boundary; no Rust summary implementation is created in Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Planned evidence command" "Phase 48 command text \`${PLANNED_PARITY_COMMAND}\`; the target is not created in Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Planned status token" "Phase 48 token \`fork.prusaslicer.gcode-output\` after executable evidence passes; no \`packages/parity/status.tsv\` row is published in Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Docs touched" "\`docs/port/README.md\`; \`docs/port/package-map.md\`; \`docs/port/migration-guidance.md\`; \`docs/port/parity-matrix.md\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "License or security note" "\`AGPL-3.0-only\`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, host upload, credential, cloud, network/device, release, or printer-runtime behavior in Phase 45."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Deferred scope" "Byte-for-byte G-code parity; full generated-output parity; toolpath geometry; extrusion; timing; support generation; wall seam behavior; arc fitting; STEP import; full 3MF import/export; printer-runtime behavior; firmware or printability behavior; GUI export or viewer behavior; binary G-code; thumbnails; post-processing; host upload; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation."
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Scope Record" "Reviewer signoff" "Peter Ryszkiewicz, 2026-06-06 UTC"
}

verify_source_row_details() {
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Source path" "\`src/libslic3r/GCode.cpp\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Companion API evidence" "\`src/libslic3r/GCode.hpp\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Feature surface" "\`gcode-output\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Feature category" "\`gcode-output\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Ownership" "\`shared-downstream\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Complexity" "\`high\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Parity dependency" "\`generated-outputs\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Inventory decision" "\`future-candidate\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Caution flags" "\`none\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"## Source Row Details" "Inventory note" "Source-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed."
}

# Literal Markdown row strings contain backticks, not command substitutions.
# shellcheck disable=SC2016
verify_structural_scope_contract() {
	require_section_table_body_row_count "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" "${STRUCTURAL_FIELD_ROW_COUNT}"
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| inventory_source_paths | source identity | Inventory source paths only: `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| fixture_source_literal | source identity | Source literal only: `tests/fff_print/test_gcodewriter.cpp#L20-L35`. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| fixture_id | fixture identity | Fixture identity only: `gcodewriter-set-speed.gcode`. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| fixture_path | fixture identity | Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| command_count_total | command counts | Count of G-code command rows in the selected fixture only; no generated-output behavior claimed. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| command_count_g1 | command counts | Count of `G1` command rows in the selected fixture only; no toolpath geometry claimed. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| section_count_total | section counts | Count of structural sections in the selected summary only; no GUI, print, or runtime section behavior claimed. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| ordered_marker_1 | ordered markers | First ordered marker value from the selected fixture summary only. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| ordered_marker_2 | ordered markers | Second ordered marker value from the selected fixture summary only. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| ordered_marker_3 | ordered markers | Third ordered marker value from the selected fixture summary only. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| ordered_marker_4 | ordered markers | Fourth ordered marker value from the selected fixture summary only. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| movement_axis_present | movement/extrusion indicators | Boolean structural indicator for movement-axis text presence only; no toolpath geometry, travel, or printability claim. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| extrusion_axis_present | movement/extrusion indicators | Boolean structural indicator for extrusion-axis text presence only; no extrusion amount, material, or printability claim. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| temperature_marker_count | temperature/tool-change markers | Count of temperature marker commands in the selected fixture only; no printer-runtime behavior claimed. |'
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_SCOPE_SECTION}" '| tool_change_marker_count | temperature/tool-change markers | Count of tool-change marker commands in the selected fixture only; no multi-tool runtime behavior claimed. |'
}

verify_structural_traceability() {
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Inventory row" "\`prusaslicer.gcode-output\` in \`packages/fork-inventories/prusaslicer.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Category-map row" "\`gcode.shared\` in \`packages/fork-inventories/category-map.tsv\` references \`prusaslicer.gcode-output\` exactly once"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Accepted source identity" "\`${ACCEPTED_SOURCE_IDENTITY}\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Fixture namespace" "\`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Current expected summary" "\`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Fixture provenance" "\`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Published narrow status row" "\`fork.prusaslicer.gcode-output\` stays verified only for the narrow summary-only Prusa G-code evidence slice in \`packages/parity/status.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Broad status row" "\`generated-outputs\` stays \`in progress\` in \`packages/parity/status.tsv\`"
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${STRUCTURAL_TRACEABILITY_SECTION}" "Structural reviewer signoff" "Peter Ryszkiewicz, 2026-06-16 UTC"
}

verify_generated_outputs_in_progress() {
	local total_count
	local in_progress_count
	total_count="$(awk -F '\t' '$1 == "generated-outputs" { count++ } END { print count + 0 }' "${status_file}")"
	in_progress_count="$(awk -F '\t' '$1 == "generated-outputs" && $2 == "in progress" { count++ } END { print count + 0 }' "${status_file}")"

	if [[ "${total_count}" != "1" || "${in_progress_count}" != "1" ]]; then
		error "packages/parity/status.tsv: generated-outputs must be exactly one in progress row, found ${total_count} total and ${in_progress_count} in progress"
	fi
}

verify_deferred_scope_terms() {
	local scope_term
	for scope_term in \
		"Byte-for-byte G-code parity" \
		"full generated-output parity" \
		"toolpath geometry" \
		"extrusion" \
		"timing" \
		"support generation" \
		"wall seam behavior" \
		"arc fitting" \
		"STEP import" \
		"full 3MF import/export" \
		"printer-runtime behavior" \
		"firmware or printability behavior" \
		"GUI export or viewer behavior" \
		"binary G-code" \
		"thumbnails" \
		"post-processing" \
		"host upload" \
		"network/device integration" \
		"profile auto-update execution" \
		"fork release builds" \
		"Bambu Studio" \
		"OrcaSlicer" \
		"upstream source imports" \
		"sync automation"; do
		require_text "${scope_file}" "gcode-output-scope.md" "${scope_term}"
	done
}

verify_inventory_inputs() {
	require_first_field_count "${inventory_file}" "packages/fork-inventories/prusaslicer.tsv" "prusaslicer.gcode-output"
	require_exact_tsv_row_once "${inventory_file}" "packages/fork-inventories/prusaslicer.tsv" "${INVENTORY_ROW}"
	require_category_reference_count "${category_map_file}" "packages/fork-inventories/category-map.tsv" "prusaslicer.gcode-output"
	require_exact_tsv_row_once "${category_map_file}" "packages/fork-inventories/category-map.tsv" "${CATEGORY_MAP_ROW}"
}

for required_file in \
	"${readme_file}" \
	"${scope_file}" \
	"${inventory_file}" \
	"${category_map_file}" \
	"${status_file}"; do
	require_file "${required_file}" "input"
done

verify_readme
verify_scope_record
verify_source_row_details
verify_structural_scope_contract
verify_structural_traceability
verify_generated_outputs_in_progress
verify_deferred_scope_terms
verify_inventory_inputs
reject_overclaiming_text
verify_phase48_publication

printf 'ok: Prusa G-code output scope verification passed\n'
