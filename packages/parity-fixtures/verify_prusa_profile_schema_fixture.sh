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
	ini_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"
	idx_file="${package_dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx"
	package_readme="${package_dir}/README.md"
elif [[ "$#" -eq 6 ]]; then
	fixture_readme="$1"
	provenance_file="$2"
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
}

verify_scope_wording() {
	local exclusion_sentence
	exclusion_sentence="This fixture package does not introduce Bambu Studio fixtures, OrcaSlicer fixtures, network/device integration, cloud behavior, credentials, profile auto-update execution, non-free plugin ingestion, full Prusa runtime support, GUI support, sync automation, or fork release packaging."

	require_text "${fixture_readme}" "fixture README" "# PrusaSlicer Profile Schema Fixture"
	require_text "${fixture_readme}" "fixture README" "Phase 38 fixture/status preparation only."
	require_text "${fixture_readme}" "fixture README" "Static fixture input only."
	require_text "${fixture_readme}" "fixture README" "Source ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_text "${fixture_readme}" "fixture README" "Accepted tag: version_2.9.5"
	require_text "${fixture_readme}" "fixture README" "Peeled commit: 9a583bd438b195856f3bcf7ea99b69ba4003a961"
	require_text "${fixture_readme}" "fixture README" "Inventory ID: prusaslicer.profile-schema"
	require_text "${fixture_readme}" "fixture README" "Phase 37 checklist source: packages/prusa-baseline/profile-schema-checklist.md"
	require_text "${fixture_readme}" "fixture README" "metadata-only-not-legal-review"
	require_text "${fixture_readme}" "fixture README" "Update route: update this fixture only after a reviewed intake change updates packages/fork-vendors/forks.tsv and the Prusa checklist/baseline gate."
	require_text "${fixture_readme}" "fixture README" "Branch-head observations remain drift-only and do not update this fixture."
	require_text "${fixture_readme}" "fixture README" "Phase 39 creates Rust parsing; Phase 40 creates executable parity evidence and any verified status publication."
	require_text "${fixture_readme}" "fixture README" "${exclusion_sentence}"
	require_text "${fixture_readme}" "fixture README" "The planned Phase 40 command shape is bazel run //packages/parity:prusaslicer_profile_schema_parity; Phase 38 must not create that target."
	require_file "${package_readme}" "packages/parity-fixtures/README.md"
}

verify_forbidden_namespaces() {
	local allowed_namespace
	local forbidden_token
	local lower_path
	local namespace_path

	if [[ ! -d "${forks_root}" ]]; then
		return
	fi

	allowed_namespace="${forks_root}/prusaslicer/prusaslicer.profile-schema"

	while IFS= read -r namespace_path; do
		lower_path="$(printf '%s' "${namespace_path}" | tr '[:upper:]' '[:lower:]')"
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
		*) error "unexpected Phase 38 fork fixture namespace path: ${namespace_path}" ;;
		esac
	done < <(find "${forks_root}" -mindepth 1 -print)
}

verify_status_not_published() {
	local maybe_match
	maybe_match="$(awk '/fork\.prusaslicer|prusaslicer\.profile-schema|prusaslicer_profile_schema_parity/ { print; exit }' "${status_file}")"
	if [[ -n "${maybe_match}" ]]; then
		error "packages/parity/status.tsv must not publish Prusa profile-schema status in Phase 38: ${maybe_match}"
	fi
}

for required_file in \
	"${fixture_readme}" \
	"${provenance_file}" \
	"${status_file}" \
	"${package_readme}"; do
	require_file "${required_file}" "input"
done

verify_fixture_files
verify_provenance
verify_scope_wording
verify_forbidden_namespaces
verify_status_not_published

printf 'ok: Prusa profile-schema fixture verification passed\n'
