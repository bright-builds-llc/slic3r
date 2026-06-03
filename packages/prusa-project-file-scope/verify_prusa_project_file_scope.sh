#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	readme_file="${script_dir}/README.md"
	scope_file="${script_dir}/project-file-scope.md"
elif [[ "$#" -eq 2 ]]; then
	readme_file="$1"
	scope_file="$2"
else
	error "usage: verify_prusa_project_file_scope.sh [README project-file-scope]"
fi

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

require_count_at_least() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	local minimum="$4"
	local count
	count="$(awk -v pattern="${pattern}" 'index($0, pattern) { count++ } END { print count + 0 }' "${file}")"
	if [[ "${count}" -lt "${minimum}" ]]; then
		error "${label}: expected at least ${minimum} occurrences of required text: ${pattern}"
	fi
}

readonly ACCEPTED_SOURCE_IDENTITY="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PLANNED_PARITY_COMMAND="bazel run //packages/parity:prusaslicer""_project_file_parity"

verify_readme() {
	require_text "${readme_file}" "README.md" \
		"bazel run //packages/prusa-project-file-scope:verify"
	require_text "${readme_file}" "README.md" \
		"Phase 41 verification does not prove executable Prusa project-file parity."
	require_text "${readme_file}" "README.md" \
		"Phase 41 verification does not prove full 3MF import/export, full PrusaSlicer runtime support, or GUI project behavior."
	require_text "${readme_file}" "README.md" \
		"This package creates no fixture bytes, expected artifacts, Rust parser, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build."
}

verify_scope_record() {
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Inventory row ID" "\`prusaslicer.project-file\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Accepted source identity" "\`${ACCEPTED_SOURCE_IDENTITY}\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Inventory row source" "\`packages/fork-inventories/prusaslicer.tsv\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Source path" "\`src/libslic3r/Format/3mf.cpp\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Companion API evidence" "\`src/libslic3r/Format/3mf.hpp\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Fixture source decision" "Phase 42 source-pinned upstream \`tests/data/seam_test_object.3mf\`; no fixture bytes are checked in during Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Expected-artifact contract" "Phase 42 \`packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv\` with \`source_ref\`, \`fixture_path\`, \`archive_member\`, \`project_marker\`, \`deferred_semantics\`, and \`notes\` columns; no expected artifact is checked in during Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Candidate Rust boundary" "Phase 43 \`slic3r_flavors::prusa_project_file\` data-in/data-out project summary boundary; no Rust parser is created in Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Planned evidence command" "Phase 44 command text \`${PLANNED_PARITY_COMMAND}\`; the target is not created in Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Planned status token" "Phase 44 token \`fork.prusaslicer.project-file\` after executable evidence passes; no \`packages/parity/status.tsv\` row is published in Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Docs touched" "\`docs/port/README.md\`; \`docs/port/package-map.md\`; \`docs/port/migration-guidance.md\`; \`docs/port/parity-matrix.md\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "License or security note" "\`AGPL-3.0-only\`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, credential, cloud, or network/device behavior in Phase 41."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Deferred scope" "Full PrusaSlicer runtime support; GUI project behavior; full 3MF import/export; generated-output parity; STEP import; support generation; arc fitting; wall seam behavior; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation."
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Scope Record" "Reviewer signoff" "Peter Ryszkiewicz, 2026-06-03 UTC"
	require_count_at_least "${scope_file}" "project-file-scope.md" "Phase 41" 2
}

verify_source_row_details() {
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Source path" "\`src/libslic3r/Format/3mf.cpp\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Feature surface" "\`project-file\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Feature category" "\`project-file\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Ownership" "\`shared-downstream\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Complexity" "\`medium\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Parity dependency" "\`file-formats\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Inventory decision" "\`future-candidate\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Caution flags" "\`none\`"
	require_section_table_row "${scope_file}" "project-file-scope.md" \
		"## Source Row Details" "Inventory note" "Source-observed project file planning row; future parity requires fixture-backed load/save evidence."
}

verify_deferred_scope_terms() {
	local scope_term
	for scope_term in \
		"Full PrusaSlicer runtime support" \
		"GUI project behavior" \
		"full 3MF import/export" \
		"generated-output parity" \
		"STEP import" \
		"support generation" \
		"arc fitting" \
		"wall seam behavior" \
		"network/device integration" \
		"profile auto-update execution" \
		"fork release builds" \
		"Bambu Studio" \
		"OrcaSlicer" \
		"upstream source imports" \
		"sync automation"; do
		require_text "${scope_file}" "project-file-scope.md" "${scope_term}"
	done
}

for required_file in \
	"${readme_file}" \
	"${scope_file}"; do
	require_file "${required_file}" "input"
done

verify_readme
verify_scope_record
verify_source_row_details
verify_deferred_scope_terms

printf 'ok: Prusa project-file scope verification passed\n'
