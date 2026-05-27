#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	readme_file="${script_dir}/README.md"
	checklist_file="${script_dir}/fork-parity-checklist-template.md"
	launcher_file="${script_dir}/fork-launcher-shape-template.md"
	drift_file="${script_dir}/manual-drift-refresh-protocol.md"
elif [[ "$#" -eq 4 ]]; then
	readme_file="$1"
	checklist_file="$2"
	launcher_file="$3"
	drift_file="$4"
else
	error "usage: verify_templates.sh [README checklist launcher drift-protocol]"
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
		require_text "${checklist_file}" "fork-parity-checklist-template.md" "| ${label} |"
	done
}

verify_non_overclaiming_phrases() {
	require_text "${readme_file}" "README.md" \
		"template verification does not prove fork parity"
	require_text "${readme_file}" "README.md" \
		"source pins and inventories are planning inputs only"
	require_text "${readme_file}" "README.md" \
		"future executable parity evidence"
	require_text "${readme_file}" "README.md" \
		"do not add fork rows to packages/parity/status.tsv in v1.9"
	require_text "${checklist_file}" "fork-parity-checklist-template.md" \
		"Completing this checklist also does not prove fork parity"
	require_text "${launcher_file}" "fork-launcher-shape-template.md" \
		"real fork parity evidence before any user-facing fork launcher"
	require_text "${drift_file}" "manual-drift-refresh-protocol.md" \
		"drift observations do not change accepted source pins by themselves"
}

verify_deferral_links() {
	require_text "${readme_file}" "README.md" \
		"docs/port/README.md#v19-fork-parity-deferrals"
	require_text "${launcher_file}" "fork-launcher-shape-template.md" \
		"docs/port/README.md#v19-fork-parity-deferrals"
}

verify_launcher_boundary() {
	require_text "${launcher_file}" "fork-launcher-shape-template.md" \
		"fork-flavor release builds"
}

verify_drift_protocol() {
	require_text "${drift_file}" "manual-drift-refresh-protocol.md" \
		"bazel run //packages/fork-vendors:verify"
	require_text "${drift_file}" "manual-drift-refresh-protocol.md" \
		"selected stable tag"
	require_text "${drift_file}" "manual-drift-refresh-protocol.md" \
		"peeled commit"
}

for required_file in \
	"${readme_file}" \
	"${checklist_file}" \
	"${launcher_file}" \
	"${drift_file}"; do
	require_file "${required_file}" "input"
done

verify_checklist_labels
verify_non_overclaiming_phrases
verify_deferral_links
verify_launcher_boundary
verify_drift_protocol

printf 'ok: fork template verification passed\n'
