#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	readme_file="${script_dir}/README.md"
	drift_file="${script_dir}/drift-refresh-record.md"
	checklist_file="${script_dir}/profile-schema-checklist.md"
elif [[ "$#" -eq 3 ]]; then
	readme_file="$1"
	drift_file="$2"
	checklist_file="$3"
else
	error "usage: verify_prusa_baseline.sh [README drift-refresh-record profile-schema-checklist]"
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
	if ! grep -Fq "${pattern}" "${file}"; then
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

verify_accepted_baseline() {
	require_text "${readme_file}" "README.md" \
		"prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Vendor" "\`prusaslicer\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Display name" "\`PrusaSlicer\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Upstream repo" "\`https://github.com/prusa3d/PrusaSlicer\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Selected stable tag" "\`version_2.9.5\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Tag ref SHA" "\`29bfec81347bd07dc738269d2c010fe4c4a5dc07\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Peeled commit" "\`9a583bd438b195856f3bcf7ea99b69ba4003a961\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Recorded observed branch head" "\`43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Accepted Source Baseline" "Source pin" "\`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\`"
}

verify_drift_record() {
	require_text "${drift_file}" "drift-refresh-record.md" \
		"bazel run //packages/fork-vendors:verify"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Review date" "PENDING - human reviewer UTC date required before implementation consumes this gate."
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Vendor" "\`prusaslicer\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Upstream repo" "\`https://github.com/prusa3d/PrusaSlicer\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Selected stable tag" "\`version_2.9.5\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Selected stable tag confirmation" "confirmed by bazel run //packages/fork-vendors:verify during Phase 37 execution"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Peeled commit" "\`9a583bd438b195856f3bcf7ea99b69ba4003a961\`"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Peeled commit confirmation" "confirmed by bazel run //packages/fork-vendors:verify during Phase 37 execution"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Branch drift observation" "none observed during Phase 37 execution"
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Reviewer decision" "PENDING - human reviewer must choose keep accepted source pin, plan future intake update, or defer before implementation consumes this gate."
	require_section_table_row "${drift_file}" "drift-refresh-record.md" \
		"## Reviewer Record" "Reviewer signoff" "PENDING - human reviewer name and UTC date required before implementation consumes this gate."
	require_text "${drift_file}" "drift-refresh-record.md" \
		"Branch-head data is drift-only observation."
	require_text "${drift_file}" "drift-refresh-record.md" \
		"accepted source pins remain unchanged unless a future reviewed intake update"
	require_text "${drift_file}" "drift-refresh-record.md" \
		"modifies packages/fork-vendors/forks.tsv."
}

verify_checklist_labels() {
	local label
	for label in \
		"Inventory row ID" \
		"Source pin" \
		"Candidate Rust module" \
		"Fixture need" \
		"Evidence command" \
		"Docs touched" \
		"License or security note" \
		"Deferred scope" \
		"Reviewer signoff"; do
		require_text "${checklist_file}" "profile-schema-checklist.md" "| ${label} |"
	done
}

verify_checklist_values() {
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"prusaslicer.profile-schema"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"packages/slic3r-rust"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"resources/profiles/PrusaResearch.ini"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"profile-schema"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"fork-specific"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"medium"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"config;config.persistence"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"future-candidate"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"PENDING - human reviewer name and UTC date required before implementation consumes this gate."
}

verify_non_overclaiming_phrases() {
	require_text "${readme_file}" "README.md" \
		"Phase 37 verification does not prove Prusa runtime support."
	require_text "${readme_file}" "README.md" \
		"Phase 37 verification does not prove executable fork parity."
	require_text "${readme_file}" "README.md" \
		"source pins, inventories, checklist records, and Prusa baseline records are"
	require_text "${readme_file}" "README.md" \
		"planning inputs only."
	require_text "${readme_file}" "README.md" \
		"future executable parity evidence required"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"does not prove Prusa"
	require_text "${checklist_file}" "profile-schema-checklist.md" \
		"runtime support or executable fork parity"
}

verify_future_only_boundaries() {
	local scope_term
	require_count_at_least "${checklist_file}" "profile-schema-checklist.md" \
		"not created in Phase 37" 2

	for scope_term in \
		"Prusa fixture files" \
		"fork parity status rows" \
		"executable Prusa parity targets" \
		"upstream source imports" \
		"vendored fork source trees" \
		"automatic sync" \
		"runtime fork support" \
		"GUI support" \
		"network/device integration" \
		"profile auto-update execution" \
		"fork release packaging"; do
		require_text "${readme_file}" "README.md" "${scope_term}"
	done

	for scope_term in \
		"Prusa project files" \
		"STEP import" \
		"support generation" \
		"arc fitting" \
		"wall seam behavior" \
		"network/device integration" \
		"profile auto-update execution" \
		"full fork runtime support" \
		"GUI support" \
		"fork release builds" \
		"sync automation" \
		"upstream source imports" \
		"Prusa fixtures" \
		"executable Prusa parity commands"; do
		require_text "${checklist_file}" "profile-schema-checklist.md" "${scope_term}"
	done
}

for required_file in \
	"${readme_file}" \
	"${drift_file}" \
	"${checklist_file}"; do
	require_file "${required_file}" "input"
done

verify_accepted_baseline
verify_drift_record
verify_checklist_labels
verify_checklist_values
verify_non_overclaiming_phrases
verify_future_only_boundaries

printf 'ok: Prusa baseline verification passed\n'
