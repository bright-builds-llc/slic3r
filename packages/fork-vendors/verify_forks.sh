#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry_file="${1:-${script_dir}/forks.tsv}"

if [[ ! -f "${registry_file}" ]]; then
	printf 'error: registry file not found: %s\n' "${registry_file}" >&2
	exit 1
fi

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

is_sha() {
	value="$1"
	[[ "${value}" =~ ^[0-9a-f]{40}$ ]]
}

validate_no_spaced_semicolons() {
	row_number="$1"
	shift
	for value in "$@"; do
		if [[ "${value}" == *"; "* || "${value}" == *" ;"* ]]; then
			error "row ${row_number}: semicolon delimiters must not have surrounding spaces"
		fi
	done
}

validate_required_fields() {
	row_number="$1"
	shift
	for value in "$@"; do
		if [[ -z "${value}" ]]; then
			error "row ${row_number}: required field is empty"
		fi
	done
}

validate_row() {
	row_number="$1"

	validate_required_fields "${row_number}" \
		"${vendor_id}" "${display_name}" "${official_repo_url}" \
		"${selected_stable_tag}" "${tag_kind}" "${tag_ref_sha}" \
		"${tag_object_sha}" "${peeled_commit_sha}" "${default_branch}" \
		"${observed_default_branch_head}" "${capture_date_utc}" \
		"${lineage_ids}" "${source_paths}" "${refresh_command}" \
		"${spdx_identifier}" "${observed_license_id}" "${license_source}" \
		"${attribution_notes}" "${provenance_notes}" "${caution_flags}" \
		"${caution_notes}"

	validate_no_spaced_semicolons "${row_number}" \
		"${lineage_ids}" "${source_paths}" "${license_source}" \
		"${attribution_notes}" "${provenance_notes}" "${caution_flags}" \
		"${caution_notes}"

	if [[ "${official_repo_url}" != https://github.com/* ]]; then
		error "row ${row_number} (${vendor_id}): official_repo_url must start with https://github.com/"
	fi

	if [[ "${tag_kind}" != "annotated" && "${tag_kind}" != "lightweight" ]]; then
		error "row ${row_number} (${vendor_id}): tag_kind must be annotated or lightweight"
	fi

	if ! is_sha "${tag_ref_sha}"; then
		error "row ${row_number} (${vendor_id}): tag_ref_sha must be 40 lowercase hex characters"
	fi

	if ! is_sha "${peeled_commit_sha}"; then
		error "row ${row_number} (${vendor_id}): peeled_commit_sha must be 40 lowercase hex characters"
	fi

	if ! is_sha "${observed_default_branch_head}"; then
		error "row ${row_number} (${vendor_id}): observed_default_branch_head must be 40 lowercase hex characters"
	fi

	if [[ "${tag_kind}" == "annotated" ]]; then
		if ! is_sha "${tag_object_sha}"; then
			error "row ${row_number} (${vendor_id}): annotated tag_object_sha must be 40 lowercase hex characters"
		fi
		if [[ "${tag_object_sha}" != "${tag_ref_sha}" ]]; then
			error "row ${row_number} (${vendor_id}): annotated tag_object_sha must match tag_ref_sha"
		fi
	fi

	if [[ "${tag_kind}" == "lightweight" && "${tag_object_sha}" != "-" ]]; then
		error "row ${row_number} (${vendor_id}): lightweight tag_object_sha must be -"
	fi

	if [[ ! "${capture_date_utc}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
		error "row ${row_number} (${vendor_id}): capture_date_utc must be an ISO UTC timestamp"
	fi

	if [[ "${spdx_identifier}" != "AGPL-3.0-only" ]]; then
		error "row ${row_number} (${vendor_id}): spdx_identifier must be AGPL-3.0-only"
	fi
}

verify_tag_ref() {
	tag_ref="refs/tags/${selected_stable_tag}"
	peeled_ref="${tag_ref}^{}"

	if ! tag_output="$(git ls-remote --tags "${official_repo_url}" "${tag_ref}" "${peeled_ref}" 2>&1)"; then
		error "${vendor_id}: git tag lookup failed: ${tag_output}"
	fi

	actual_tag_ref_sha="$(printf '%s\n' "${tag_output}" | awk -v ref="${tag_ref}" '$2 == ref { print $1 }')"
	actual_peeled_commit_sha="$(printf '%s\n' "${tag_output}" | awk -v ref="${peeled_ref}" '$2 == ref { print $1 }')"

	if [[ -z "${actual_tag_ref_sha}" ]]; then
		error "${vendor_id}: missing selected tag ref ${tag_ref}"
	fi

	if [[ "${actual_tag_ref_sha}" != "${tag_ref_sha}" ]]; then
		error "${vendor_id}: tag ref mismatch for ${selected_stable_tag}: recorded ${tag_ref_sha}, current ${actual_tag_ref_sha}"
	fi

	if [[ "${tag_kind}" == "annotated" && -z "${actual_peeled_commit_sha}" ]]; then
		error "${vendor_id}: missing peeled tag ref ${peeled_ref}"
	fi

	if [[ "${tag_kind}" == "lightweight" && -z "${actual_peeled_commit_sha}" ]]; then
		actual_peeled_commit_sha="${actual_tag_ref_sha}"
	fi

	if [[ "${actual_peeled_commit_sha}" != "${peeled_commit_sha}" ]]; then
		error "${vendor_id}: peeled commit mismatch for ${selected_stable_tag}: recorded ${peeled_commit_sha}, current ${actual_peeled_commit_sha}"
	fi
}

warn_on_branch_drift() {
	if ! head_output="$(git ls-remote --symref "${official_repo_url}" HEAD 2>&1)"; then
		error "${vendor_id}: git HEAD lookup failed: ${head_output}"
	fi

	actual_default_branch="$(printf '%s\n' "${head_output}" | awk '$1 == "ref:" && $3 == "HEAD" { sub("^refs/heads/", "", $2); print $2 }')"
	actual_default_branch_head="$(printf '%s\n' "${head_output}" | awk '$2 == "HEAD" { print $1 }')"

	if [[ "${actual_default_branch}" != "${default_branch}" || "${actual_default_branch_head}" != "${observed_default_branch_head}" ]]; then
		printf 'warning: branch drift observed for %s: recorded %s@%s, current %s@%s\n' \
			"${vendor_id}" "${default_branch}" "${observed_default_branch_head}" \
			"${actual_default_branch}" "${actual_default_branch_head}" >&2
	fi
}

row_number=0
while IFS= read -r line || [[ -n "${line}" ]]; do
	row_number=$((row_number + 1))

	if [[ -z "${line}" || "${line}" == \#* ]]; then
		continue
	fi

	field_count="$(printf '%s\n' "${line}" | awk -F '\t' '{ print NF }')"
	if [[ "${field_count}" != "21" ]]; then
		error "row ${row_number}: expected 21 tab-delimited fields, got ${field_count}"
	fi

	IFS=$'\t' read -r \
		vendor_id display_name official_repo_url selected_stable_tag \
		tag_kind tag_ref_sha tag_object_sha peeled_commit_sha \
		default_branch observed_default_branch_head capture_date_utc \
		lineage_ids source_paths refresh_command spdx_identifier \
		observed_license_id license_source attribution_notes \
		provenance_notes caution_flags caution_notes <<<"${line}"

	validate_row "${row_number}"
	verify_tag_ref
	warn_on_branch_drift

	printf 'ok: %s %s -> %s\n' "${vendor_id}" "${selected_stable_tag}" "${peeled_commit_sha}"
done <"${registry_file}"
