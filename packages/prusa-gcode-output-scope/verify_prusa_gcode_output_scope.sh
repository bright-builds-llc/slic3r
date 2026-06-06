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
		error "${label}: forbidden Phase 45 claim: ${pattern}"
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

reject_existing_path() {
	local label="$1"
	local path="$2"
	if [[ -e "${path}" ]]; then
		error "${label}: forbidden Phase 45 artifact exists: ${path}"
	fi
}

reject_status_row() {
	local id="$1"
	local file="$2"
	if awk -F '\t' -v id="${id}" '$1 == id { found = 1 } END { exit found ? 0 : 1 }' "${file}"; then
		error "packages/parity/status.tsv: forbidden Phase 45 status row exists: ${id}"
	fi
}

reject_parity_target() {
	local parity_build="${checkout_root}/packages/parity/BUILD.bazel"
	if [[ ! -r "${parity_build}" ]]; then
		return
	fi

	if grep -Fq -- 'name = "prusaslicer_gcode_output_parity"' "${parity_build}"; then
		error "packages/parity/BUILD.bazel: forbidden Phase 45 parity target exists"
	fi
}

reject_rust_implementation_markers() {
	local rust_dir="${checkout_root}/packages/slic3r-rust"
	local marker
	local maybe_match
	local rust_file

	if [[ ! -d "${rust_dir}" || ! -r "${rust_dir}" ]]; then
		return
	fi

	for marker in \
		"pub mod prusa_gcode_output" \
		"prusa_gcode_output_summary" \
		"parse_prusa_gcode_output_summary"; do
		maybe_match=""
		while IFS= read -r rust_file; do
			if grep -Fq -- "${marker}" "${rust_file}"; then
				maybe_match="${rust_file}"
				break
			fi
		done < <(find "${rust_dir}" -path "${rust_dir}/target" -prune -o -type f -print)
		if [[ -n "${maybe_match}" ]]; then
			error "packages/slic3r-rust: forbidden Phase 45 Rust G-code summary marker ${marker} in ${maybe_match}"
		fi
	done
}

verify_readme() {
	require_text "${readme_file}" "README.md" \
		"\`packages/prusa-gcode-output-scope\` owns the Phase 45 reviewed scope gate for \`prusaslicer.gcode-output\`."
	require_text "${readme_file}" "README.md" \
		"bazel run //packages/prusa-gcode-output-scope:verify"
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
			"OrcaSlicer support verified"; do
			reject_text "${checked_file}" "${checked_label}" "${forbidden_claim}"
		done
	done
}

reject_later_phase_artifacts() {
	reject_existing_path "expected summary artifact" \
		"${checkout_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
	reject_existing_path "fixture namespace" \
		"${checkout_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
	reject_status_row "fork.prusaslicer.gcode-output" "${status_file}"
	reject_parity_target
	reject_rust_implementation_markers
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
verify_deferred_scope_terms
verify_inventory_inputs
reject_overclaiming_text
reject_later_phase_artifacts

printf 'ok: Prusa G-code output scope verification passed\n'
