#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	if [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
		package_dir="${BUILD_WORKSPACE_DIRECTORY}/packages/parity-fixtures"
		status_file="${BUILD_WORKSPACE_DIRECTORY}/packages/parity/status.tsv"
	else
		package_dir="${script_dir}"
		status_file="${script_dir}/../parity/status.tsv"
	fi
	fixture_readme="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/README.md"
	provenance_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv"
	expected_summary_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv"
	ini_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"
	idx_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx"
	package_readme="${package_dir}/README.md"
elif [[ "$#" -eq 6 ]]; then
	fixture_readme="$1"
	provenance_file="$2"
	expected_summary_file="$(dirname "${fixture_readme}")/expected-summary.tsv"
	ini_file="$3"
	idx_file="$4"
	status_file="$5"
	package_readme="$6"
else
	error "usage: verify_prusa_profile_schema_fixture.sh [fixture-README fixture-provenance PrusaResearch.ini PrusaResearch.idx parity-status parity-fixtures-README]"
fi

if [[ -n "${PRUSA_FIXTURE_FORKS_ROOT:-}" ]]; then
	forks_root="${PRUSA_FIXTURE_FORKS_ROOT}"
elif [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
	forks_root="${BUILD_WORKSPACE_DIRECTORY}/packages/parity-fixtures/forks"
else
	forks_root="${script_dir}/forks"
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

verify_fixture_files() {
	require_file "${ini_file}" "PrusaResearch.ini"
	require_file "${idx_file}" "PrusaResearch.idx"
	require_size "${ini_file}" "PrusaResearch.ini" "1543688"
	require_size "${idx_file}" "PrusaResearch.idx" "31543"
	require_sha256 "${ini_file}" "PrusaResearch.ini" \
		"a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839"
	require_sha256 "${idx_file}" "PrusaResearch.idx" \
		"65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1"
}

verify_provenance() {
	local required_text
	for required_text in \
		"PrusaResearch.ini" \
		"PrusaResearch.idx" \
		"prusaslicer.profile-schema" \
		"prusaslicer" \
		"prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" \
		"version_2.9.5" \
		"9a583bd438b195856f3bcf7ea99b69ba4003a961" \
		"resources/profiles/PrusaResearch.ini" \
		"resources/profiles/PrusaResearch.idx" \
		"https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini" \
		"https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx" \
		"1543688" \
		"31543" \
		"a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839" \
		"65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1" \
		"packages/prusa-baseline/profile-schema-checklist.md" \
		"reviewed-intake-change-updates-packages/fork-vendors/forks.tsv-and-prusa-baseline-gate" \
		"Phase-38-fixture-status-preparation-only" \
		"no-bambu-no-orca-no-network-no-cloud-no-credentials-no-profile-auto-update-no-non-free-plugin-no-runtime-no-gui-no-sync-no-release"; do
		require_text "${provenance_file}" "fixture-provenance.tsv" "${required_text}"
	done

	verify_provenance_row \
		"PrusaResearch.ini" \
		"resources/profiles/PrusaResearch.ini" \
		"https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini" \
		"1543688" \
		"a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839" \
		"lf" \
		"raw-vendor-bundle-input"
	verify_provenance_row \
		"PrusaResearch.idx" \
		"resources/profiles/PrusaResearch.idx" \
		"https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx" \
		"31543" \
		"65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1" \
		"crlf" \
		"raw-vendor-bundle-index"
}

verify_provenance_row() {
	local fixture_id="$1"
	local source_path="$2"
	local upstream_url="$3"
	local bytes="$4"
	local sha256="$5"
	local line_endings="$6"
	local role="$7"

	awk -F '\t' \
		-v fixture_id="${fixture_id}" \
		-v vendor_id="prusaslicer" \
		-v inventory_id="prusaslicer.profile-schema" \
		-v source_ref="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" \
		-v accepted_tag="version_2.9.5" \
		-v peeled_commit="9a583bd438b195856f3bcf7ea99b69ba4003a961" \
		-v source_path="${source_path}" \
		-v upstream_url="${upstream_url}" \
		-v bytes="${bytes}" \
		-v sha256="${sha256}" \
		-v line_endings="${line_endings}" \
		-v role="${role}" \
		-v phase37_checklist="packages/prusa-baseline/profile-schema-checklist.md" \
		-v update_route="reviewed-intake-change-updates-packages/fork-vendors/forks.tsv-and-prusa-baseline-gate" \
		-v status_scope="Phase-38-fixture-status-preparation-only" \
		-v exclusions="no-bambu-no-orca-no-network-no-cloud-no-credentials-no-profile-auto-update-no-non-free-plugin-no-runtime-no-gui-no-sync-no-release" '
		$1 == fixture_id {
			found = 1
			if ($2 != vendor_id ||
			    $3 != inventory_id ||
			    $4 != source_ref ||
			    $5 != accepted_tag ||
			    $6 != peeled_commit ||
			    $7 != source_path ||
			    $8 != upstream_url ||
			    $9 != bytes ||
			    $10 != sha256 ||
			    $11 != line_endings ||
			    $12 != role ||
			    $13 != phase37_checklist ||
			    $14 != update_route ||
			    $15 != status_scope ||
			    $16 != exclusions) {
				exit 2
			}
		}
		END {
			if (!found) {
				exit 1
			}
		}
	' "${provenance_file}" || error "fixture-provenance.tsv: invalid row for ${fixture_id}"
}

verify_scope_wording() {
	local exclusion_sentence
	exclusion_sentence="This fixture package does not introduce Bambu Studio fixtures, OrcaSlicer fixtures, network/device integration, cloud behavior, credentials, profile auto-update execution, non-free plugin ingestion, full PrusaSlicer runtime support, GUI support, sync automation, or fork release packaging."

	require_text "${fixture_readme}" "fixture README" "# PrusaSlicer Profile Schema Fixture"
	require_text "${fixture_readme}" "fixture README" "Phase 38 supplies the static fixture inputs."
	require_text "${fixture_readme}" "fixture README" "Static fixture input only."
	require_text "${fixture_readme}" "fixture README" "expected-summary.tsv"
	require_text "${fixture_readme}" "fixture README" "narrow Prusa profile-schema parser/config evidence slice only"
	require_text "${fixture_readme}" "fixture README" "Source ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_text "${fixture_readme}" "fixture README" "Accepted tag: version_2.9.5"
	require_text "${fixture_readme}" "fixture README" "Peeled commit: 9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_text "${fixture_readme}" "fixture README" "Inventory ID: prusaslicer.profile-schema"
	require_text "${fixture_readme}" "fixture README" "Phase 37 checklist source: packages/prusa-baseline/profile-schema-checklist.md"
	require_text "${fixture_readme}" "fixture README" "metadata-only-not-legal-review"
	require_text "${fixture_readme}" "fixture README" "Update route: update this fixture only after a reviewed intake change updates packages/fork-vendors/forks.tsv and the Prusa checklist/baseline gate."
	require_text "${fixture_readme}" "fixture README" "Branch-head observations remain drift-only and do not update this fixture."
	require_text "${fixture_readme}" "fixture README" "bazel run //packages/parity:prusaslicer_profile_schema_parity"
	require_text "${fixture_readme}" "fixture README" "full PrusaSlicer runtime support remains deferred"
	require_text "${fixture_readme}" "fixture README" "${exclusion_sentence}"
	require_file "${package_readme}" "packages/parity-fixtures/README.md"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "expected-summary.tsv"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "bazel run //packages/parity:prusaslicer_profile_schema_parity"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "full PrusaSlicer runtime support remains deferred"
}

verify_forbidden_namespaces() {
	local allowed_namespace
	local allowed_project_file_namespace
	local forbidden_token
	local lower_path
	local namespace_path

	if [[ ! -d "${forks_root}" ]]; then
		return
	fi

	forks_root="$(cd "${forks_root}" && pwd -P)"
	allowed_namespace="${forks_root}/prusaslicer/prusaslicer.profile-schema"
	allowed_project_file_namespace="${forks_root}/prusaslicer/prusaslicer.project-file"

	while IFS= read -r namespace_path; do
		namespace_path="$(cd "${namespace_path}" && pwd -P)"
		relative_path="${namespace_path#"${forks_root}"/}"
		lower_path="$(printf '%s' "${relative_path}" | tr '[:upper:]' '[:lower:]')"
		for forbidden_token in \
			bambustudio \
			orca \
			orcaslicer \
			network \
			cloud \
			credential \
			credentials \
			plugin \
			non-free; do
			if [[ "/${lower_path}/" == *"/${forbidden_token}/"* ]]; then
				error "forbidden Prusa fixture namespace path contains ${forbidden_token}: ${namespace_path}"
			fi
		done

		if [[ "${namespace_path}" == "${forks_root}/prusaslicer" ]]; then
			continue
		fi
		case "${namespace_path}" in
		"${allowed_namespace}" | "${allowed_namespace}"/*) ;;
		"${allowed_project_file_namespace}" | "${allowed_project_file_namespace}"/*) ;;
		*) error "unexpected Prusa fork fixture namespace path: ${namespace_path}" ;;
		esac
	done < <(find "${forks_root}" -mindepth 1 -type d -print)
}

verify_status_published() {
	local status_errors
	status_errors="$(awk -F '\t' \
		-v surface="fork.prusaslicer.profile-schema" \
		-v required_status="verified" \
		-v required_evidence="//packages/parity:prusaslicer_profile_schema_parity" \
		-v required_narrow="narrow Prusa profile-schema parser/config evidence slice only" \
		-v required_runtime="full PrusaSlicer runtime support remains deferred" '
		$1 == surface {
			count++
			if ($2 != required_status) {
				printf "%s status: expected %s, got %s\n", surface, required_status, $2
				failed = 1
			}
			if ($3 != required_evidence) {
				printf "%s evidence: expected %s, got %s\n", surface, required_evidence, $3
				failed = 1
			}
			if (index($4, required_narrow) == 0) {
				printf "%s notes: missing %s\n", surface, required_narrow
				failed = 1
			}
			if (index($4, required_runtime) == 0) {
				printf "%s notes: missing %s\n", surface, required_runtime
				failed = 1
			}
		}
		END {
			if (count == 0) {
				printf "%s status: missing row\n", surface
				failed = 1
			}
			if (count > 1) {
				printf "%s status: duplicate rows: %d\n", surface, count
				failed = 1
			}
			exit failed ? 1 : 0
		}
	' "${status_file}")" || error "packages/parity/status.tsv: ${status_errors}"
}

for required_file in \
	"${fixture_readme}" \
	"${provenance_file}" \
	"${expected_summary_file}" \
	"${status_file}" \
	"${package_readme}"; do
	require_file "${required_file}" "input"
done

verify_fixture_files
verify_provenance
verify_scope_wording
verify_forbidden_namespaces
verify_status_published

printf 'ok: Prusa profile-schema fixture verification passed\n'
