#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	template_file="${script_dir}/inventory-template.tsv"
	prusa_file="${script_dir}/prusaslicer.tsv"
	bambu_file="${script_dir}/bambustudio.tsv"
	orca_file="${script_dir}/orcaslicer.tsv"
	category_file="${script_dir}/category-map.tsv"
	forks_file="${script_dir}/../fork-vendors/forks.tsv"
	parity_file="${script_dir}/../parity/status.tsv"
elif [[ "$#" -eq 7 ]]; then
	template_file="$1"
	prusa_file="$2"
	bambu_file="$3"
	orca_file="$4"
	category_file="$5"
	forks_file="$6"
	parity_file="$7"
else
	error "usage: verify_inventories.sh template prusa bambu orca category-map forks parity-status"
fi

inventory_header=$'# inventory_id\tvendor_id\tsource_ref\tsource_paths\tfeature_surface\tfeature_category\townership\tcomplexity\tparity_dependency\tv1_9_decision\tcaution_flags\tfuture_parity_notes'
category_header=$'# map_id\tfeature_category\townership\tv1_9_decision\tinventory_ids\tnotes'

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-inventories.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

vendor_refs_file="${tmp_dir}/vendor-refs.tsv"
parity_values_file="${tmp_dir}/parity-values.txt"
inventory_ids_file="${tmp_dir}/inventory-ids.txt"
inventory_meta_file="${tmp_dir}/inventory-meta.tsv"
map_refs_file="${tmp_dir}/map-refs.txt"
map_ids_file="${tmp_dir}/map-ids.txt"

: >"${inventory_ids_file}"
: >"${inventory_meta_file}"
: >"${map_refs_file}"
: >"${map_ids_file}"

ensure_file() {
	local file="$1"
	local label="$2"
	if [[ ! -f "${file}" ]]; then
		error "${label} file not found: ${file}"
	fi
}

read_first_line() {
	local file="$1"
	sed -n '1p' "${file}"
}

validate_header() {
	local file="$1"
	local label="$2"
	local expected="$3"
	local actual
	actual="$(read_first_line "${file}")"
	if [[ "${actual}" != "${expected}" ]]; then
		error "${label}: header mismatch"
	fi
}

field_count() {
	local line="$1"
	printf '%s\n' "${line}" | awk -F '\t' '{ print NF }'
}

validate_required_fields() {
	local label="$1"
	local value
	shift
	for value in "$@"; do
		if [[ -z "${value}" ]]; then
			error "${label}: required field is empty"
		fi
	done
}

validate_no_spaced_semicolons() {
	local label="$1"
	local value
	shift
	for value in "$@"; do
		if [[ "${value}" == *"; "* || "${value}" == *" ;"* ]]; then
			error "${label}: semicolon delimiters must not have surrounding spaces"
		fi
	done
}

validate_enum() {
	local value="$1"
	local allowed="$2"
	local label="$3"
	case ";${allowed};" in
		*";${value};"*) ;;
		*) error "${label}: invalid value ${value}" ;;
	esac
}

list_contains() {
	local values="$1"
	local needle="$2"
	case ";${values};" in
		*";${needle};"*) return 0 ;;
		*) return 1 ;;
	esac
}

validate_semicolon_syntax() {
	local value="$1"
	local label="$2"
	if [[ "${value}" == *";;"* || "${value}" == ";"* || "${value}" == *";" ]]; then
		error "${label}: empty semicolon-delimited item"
	fi
}

validate_allowed_list() {
	local value="$1"
	local allowed="$2"
	local label="$3"
	local old_ifs
	local item

	if [[ "${value}" == "none" ]]; then
		return
	fi

	validate_semicolon_syntax "${value}" "${label}"
	old_ifs="${IFS}"
	IFS=';'
	set -- ${value}
	IFS="${old_ifs}"
	for item in "$@"; do
		validate_enum "${item}" "${allowed}" "${label}"
	done
}

validate_file_list() {
	local value="$1"
	local valid_file="$2"
	local label="$3"
	local old_ifs
	local item

	if [[ "${value}" == "none" ]]; then
		return
	fi

	validate_semicolon_syntax "${value}" "${label}"
	old_ifs="${IFS}"
	IFS=';'
	set -- ${value}
	IFS="${old_ifs}"
	for item in "$@"; do
		if ! grep -Fxq "${item}" "${valid_file}"; then
			error "${label}: unknown value ${item}"
		fi
	done
}

validate_path_list() {
	local value="$1"
	local label="$2"
	local old_ifs
	local item
	validate_semicolon_syntax "${value}" "${label}"
	old_ifs="${IFS}"
	IFS=';'
	set -- ${value}
	IFS="${old_ifs}"
	for item in "$@"; do
		if [[ -z "${item}" ]]; then
			error "${label}: empty path item"
		fi
	done
}

vendor_row_for() {
	local vendor_id="$1"
	awk -F '\t' -v vendor_id="${vendor_id}" '$1 == vendor_id { print; found=1; exit } END { if (!found) exit 1 }' "${vendor_refs_file}"
}

validate_pin_ref() {
	local label="$1"
	local vendor_id="$2"
	local source_ref="$3"
	local vendor_row
	local ref_vendor
	local selected_tag
	local peeled_commit
	local observed_head
	local expected_ref
	local ref_commit

	if ! vendor_row="$(vendor_row_for "${vendor_id}")"; then
		error "${label}: unknown vendor_id ${vendor_id}"
	fi

	IFS=$'\t' read -r ref_vendor selected_tag peeled_commit observed_head expected_ref <<<"${vendor_row}"
	if [[ "${ref_vendor}" != "${vendor_id}" ]]; then
		error "${label}: vendor lookup mismatch"
	fi

	if [[ "${source_ref}" != "${expected_ref}" ]]; then
		ref_commit="${source_ref##*@}"
		if [[ "${ref_commit}" == "${observed_head}" ]]; then
			error "${label}: source_ref uses observed default branch head"
		fi
		error "${label}: source_ref must equal ${expected_ref}"
	fi
}

has_restricted_caution() {
	local flags="$1"
	local flag
	for flag in network-scope cloud-scope credential-scope non-free-plugin-scope; do
		if list_contains "${flags}" "${flag}"; then
			return 0
		fi
	done
	return 1
}

validate_caution_policy() {
	local label="$1"
	local decision="$2"
	local flags="$3"

	if ! has_restricted_caution "${flags}"; then
		return
	fi

	if [[ "${decision}" != "deferred" ]]; then
		error "${label}: restricted caution rows must be deferred"
	fi

	if ! list_contains "${flags}" "runtime-parity-not-verified"; then
		error "${label}: restricted caution rows must include runtime-parity-not-verified"
	fi
}

load_vendor_refs() {
	awk -F '\t' '
		/^#/ || NF == 0 { next }
		NF != 21 {
			printf "error: forks.tsv row %d: expected 21 fields, got %d\n", NR, NF > "/dev/stderr"
			bad = 1
			next
		}
		{
			printf "%s\t%s\t%s\t%s\t%s:%s@%s\n", $1, $4, $8, $10, $1, $4, $8
		}
		END { exit bad }
	' "${forks_file}" >"${vendor_refs_file}" || exit 1
}

load_parity_values() {
	awk -F '\t' '
		/^#/ || NF == 0 { next }
		NF != 4 {
			printf "error: parity status row %d: expected 4 fields, got %d\n", NR, NF > "/dev/stderr"
			bad = 1
			next
		}
		{ print $1 }
		END { exit bad }
	' "${parity_file}" >"${parity_values_file}" || exit 1
}

validate_inventory_file() {
	local file="$1"
	local label="$2"
	local row_number=0
	local line
	local count
	local inventory_id
	local vendor_id
	local source_ref
	local source_paths
	local feature_surface
	local feature_category
	local ownership
	local complexity
	local parity_dependency
	local v1_9_decision
	local caution_flags
	local future_parity_notes
	local row_label

	validate_header "${file}" "${label}" "${inventory_header}"

	while IFS= read -r line || [[ -n "${line}" ]]; do
		row_number=$((row_number + 1))

		if [[ "${line}" == *$'\r'* ]]; then
			error "${label} row ${row_number}: rows must use LF delimiters"
		fi

		if [[ -z "${line}" || "${line}" == \#* ]]; then
			continue
		fi

		count="$(field_count "${line}")"
		if [[ "${count}" != "12" ]]; then
			error "${label} row ${row_number}: expected 12 fields, got ${count}"
		fi

		IFS=$'\t' read -r \
			inventory_id vendor_id source_ref source_paths feature_surface \
			feature_category ownership complexity parity_dependency \
			v1_9_decision caution_flags future_parity_notes <<<"${line}"

		row_label="${label} row ${row_number} (${inventory_id})"

		validate_required_fields "${row_label}" \
			"${inventory_id}" "${vendor_id}" "${source_ref}" "${source_paths}" \
			"${feature_surface}" "${feature_category}" "${ownership}" \
			"${complexity}" "${parity_dependency}" "${v1_9_decision}" \
			"${caution_flags}" "${future_parity_notes}"
		validate_no_spaced_semicolons "${row_label}" \
			"${source_paths}" "${parity_dependency}" "${caution_flags}"
		validate_path_list "${source_paths}" "${row_label}: source_paths"
		validate_enum "${ownership}" \
			"base-slic3r;shared-downstream;fork-specific;unknown-needs-review" \
			"${row_label}: ownership"
		validate_enum "${complexity}" \
			"none;low;medium;high;unknown-needs-review" \
			"${row_label}: complexity"
		validate_enum "${v1_9_decision}" \
			"future-candidate;deferred;no-action-base;needs-review" \
			"${row_label}: v1_9_decision"
		validate_file_list "${parity_dependency}" "${parity_values_file}" \
			"${row_label}: parity_dependency"
		validate_allowed_list "${caution_flags}" \
			"network-scope;cloud-scope;credential-scope;non-free-plugin-scope;license-provenance;runtime-parity-not-verified" \
			"${row_label}: caution_flags"
		validate_caution_policy "${row_label}" "${v1_9_decision}" "${caution_flags}"
		validate_pin_ref "${row_label}" "${vendor_id}" "${source_ref}"

		case "${inventory_id}" in
			"${vendor_id}."*) ;;
			*) error "${row_label}: inventory_id must start with ${vendor_id}." ;;
		esac

		if grep -Fxq "${inventory_id}" "${inventory_ids_file}"; then
			error "${row_label}: duplicate inventory_id"
		fi

		printf '%s\n' "${inventory_id}" >>"${inventory_ids_file}"
		printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
			"${inventory_id}" "${vendor_id}" "${source_ref}" \
			"${feature_surface}" "${feature_category}" "${ownership}" \
			"${v1_9_decision}" >>"${inventory_meta_file}"
	done <"${file}"
}

meta_for_inventory_id() {
	local inventory_id="$1"
	awk -F '\t' -v inventory_id="${inventory_id}" '$1 == inventory_id { print; found=1; exit } END { if (!found) exit 1 }' "${inventory_meta_file}"
}

validate_category_map() {
	local row_number=0
	local line
	local count
	local map_id
	local feature_category
	local ownership
	local v1_9_decision
	local inventory_ids
	local notes
	local row_label
	local old_ifs
	local inventory_id
	local meta_row
	local meta_id
	local meta_vendor
	local meta_ref
	local meta_surface
	local meta_category
	local meta_ownership
	local meta_decision
	validate_header "${category_file}" "category-map.tsv" "${category_header}"

	while IFS= read -r line || [[ -n "${line}" ]]; do
		row_number=$((row_number + 1))

		if [[ "${line}" == *$'\r'* ]]; then
			error "category-map row ${row_number}: rows must use LF delimiters"
		fi

		if [[ -z "${line}" || "${line}" == \#* ]]; then
			continue
		fi

		count="$(field_count "${line}")"
		if [[ "${count}" != "6" ]]; then
			error "category-map row ${row_number}: expected 6 fields, got ${count}"
		fi

		IFS=$'\t' read -r \
			map_id feature_category ownership v1_9_decision inventory_ids notes \
			<<<"${line}"
		row_label="category-map row ${row_number} (${map_id})"

		validate_required_fields "${row_label}" \
			"${map_id}" "${feature_category}" "${ownership}" \
			"${v1_9_decision}" "${inventory_ids}" "${notes}"
		validate_no_spaced_semicolons "${row_label}" "${inventory_ids}"
		validate_path_list "${inventory_ids}" "${row_label}: inventory_ids"
		validate_enum "${ownership}" \
			"base-slic3r;shared-downstream;fork-specific;unknown-needs-review" \
			"${row_label}: ownership"
		validate_enum "${v1_9_decision}" \
			"future-candidate;deferred;no-action-base;needs-review" \
			"${row_label}: v1_9_decision"

		if grep -Fxq "${map_id}" "${map_ids_file}"; then
			error "${row_label}: duplicate map_id"
		fi
		printf '%s\n' "${map_id}" >>"${map_ids_file}"

		old_ifs="${IFS}"
		IFS=';'
		set -- ${inventory_ids}
		IFS="${old_ifs}"
		for inventory_id in "$@"; do
			if ! grep -Fxq "${inventory_id}" "${inventory_ids_file}"; then
				error "${row_label}: category-map references unknown inventory_id ${inventory_id}"
			fi
			if grep -Fxq "${inventory_id}" "${map_refs_file}"; then
				error "${row_label}: category-map duplicate inventory_id ${inventory_id}"
			fi
			if ! meta_row="$(meta_for_inventory_id "${inventory_id}")"; then
				error "${row_label}: category-map metadata lookup failed for ${inventory_id}"
			fi

			IFS=$'\t' read -r \
				meta_id meta_vendor meta_ref meta_surface meta_category \
				meta_ownership meta_decision <<<"${meta_row}"
			if [[ "${meta_id}" != "${inventory_id}" ]]; then
				error "${row_label}: category-map metadata mismatch"
			fi
			if [[ "${meta_category}" != "${feature_category}" ]]; then
				error "${row_label}: category-map feature_category mismatch for ${inventory_id}"
			fi
			if [[ "${meta_ownership}" != "${ownership}" ]]; then
				error "${row_label}: category-map ownership mismatch for ${inventory_id}"
			fi
			if [[ "${meta_decision}" != "${v1_9_decision}" ]]; then
				error "${row_label}: category-map v1_9_decision mismatch for ${inventory_id}"
			fi
			printf '%s\n' "${inventory_id}" >>"${map_refs_file}"
		done
	done <"${category_file}"

	while IFS= read -r inventory_id; do
		if ! grep -Fxq "${inventory_id}" "${map_refs_file}"; then
			error "category-map missing inventory_id ${inventory_id}"
		fi
	done <"${inventory_ids_file}"
}

vendor_ref_exists() {
	local vendor_id="$1"
	awk -F '\t' -v vendor_id="${vendor_id}" '$1 == vendor_id { found=1 } END { exit found ? 0 : 1 }' "${vendor_refs_file}"
}

vendor_has_surface() {
	local vendor_id="$1"
	local feature_surface="$2"
	awk -F '\t' -v vendor_id="${vendor_id}" -v feature_surface="${feature_surface}" \
		'$2 == vendor_id && $4 == feature_surface { found=1 } END { exit found ? 0 : 1 }' \
		"${inventory_meta_file}"
}

validate_required_surfaces() {
	local vendor_id="$1"
	local required_surfaces="$2"
	local feature_surface

	if ! vendor_ref_exists "${vendor_id}"; then
		return
	fi

	for feature_surface in ${required_surfaces}; do
		if ! vendor_has_surface "${vendor_id}" "${feature_surface}"; then
			error "${vendor_id}: missing required feature_surface ${feature_surface}"
		fi
	done
}

for required_file in \
	"${template_file}" "${prusa_file}" "${bambu_file}" "${orca_file}" \
	"${category_file}" "${forks_file}" "${parity_file}"; do
	ensure_file "${required_file}" "input"
done

load_vendor_refs
load_parity_values

validate_inventory_file "${template_file}" "inventory-template.tsv"
validate_inventory_file "${prusa_file}" "prusaslicer.tsv"
validate_inventory_file "${bambu_file}" "bambustudio.tsv"
validate_inventory_file "${orca_file}" "orcaslicer.tsv"

validate_required_surfaces "prusaslicer" \
	"base-core project-file profile-schema network-device"
validate_required_surfaces "bambustudio" \
	"base-core project-file profile-schema network-device support-generation step-import arc-fitting assembly-workflow"
validate_required_surfaces "orcaslicer" \
	"base-core calibration-flow wall-seam support-generation adaptive-mesh profile-library community-profile network-device"

validate_category_map

printf 'ok: inventory verification passed\n'
