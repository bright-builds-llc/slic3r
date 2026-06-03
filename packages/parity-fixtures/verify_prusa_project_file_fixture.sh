#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -eq 0 ]]; then
	if [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
		workspace_root="${BUILD_WORKSPACE_DIRECTORY}"
	else
		workspace_root="$(cd "${script_dir}/../.." && pwd)"
	fi

	package_dir="${workspace_root}/packages/parity-fixtures"
	fixture_dir="${package_dir}/forks/prusaslicer/prusaslicer.project-file"
	fixture_readme="${fixture_dir}/README.md"
	provenance_file="${fixture_dir}/fixture-provenance.tsv"
	expected_summary_file="${fixture_dir}/expected-project-summary.tsv"
	project_file="${fixture_dir}/seam_test_object.3mf"
	status_file="${workspace_root}/packages/parity/status.tsv"
	parity_build_file="${workspace_root}/packages/parity/BUILD.bazel"
	package_readme="${package_dir}/README.md"
	rust_src_root="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/src"
	rust_tests_root="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/tests"
elif [[ "$#" -eq 9 ]]; then
	fixture_readme="$1"
	provenance_file="$2"
	expected_summary_file="$3"
	project_file="$4"
	status_file="$5"
	parity_build_file="$6"
	package_readme="$7"
	rust_src_root="$8"
	rust_tests_root="$9"
else
	error "usage: verify_prusa_project_file_fixture.sh [fixture-README fixture-provenance expected-project-summary seam_test_object.3mf parity-status parity-BUILD parity-fixtures-README rust-src-root rust-tests-root]"
fi

readonly SOURCE_REF="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PEELED_COMMIT="9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PROJECT_FILE_PATH="packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf"
readonly EXPECTED_SHA="9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2"
readonly PHASE41_SCOPE_RECORD="packages/prusa-project-file-scope/project-file-scope.md"
readonly EXPECTED_SUMMARY_HEADER=$'source_ref\tfixture_path\tarchive_member\tproject_marker\tdeferred_semantics\tnotes'
readonly PROVENANCE_HEADER=$'fixture_id\tvendor_id\tinventory_id\tsource_ref\taccepted_tag\tpeeled_commit\tsource_path\tupstream_url\tbytes\tsha256\tline_endings\trole\tphase41_scope_record\tupdate_route\tstatus_scope\texclusions'

require_file() {
	local file="$1"
	local label="$2"
	if [[ ! -f "${file}" ]]; then
		error "${label} file not found: ${file}"
	fi
}

require_dir() {
	local dir="$1"
	local label="$2"
	if [[ ! -d "${dir}" ]]; then
		error "${label} directory not found: ${dir}"
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

require_exact_header() {
	local file="$1"
	local label="$2"
	local expected_header="$3"
	local actual_header
	IFS= read -r actual_header <"${file}" || error "${label}: missing header"
	if [[ "${actual_header}" != "${expected_header}" ]]; then
		error "${label}: expected header ${expected_header}"
	fi
}

require_line_count() {
	local file="$1"
	local label="$2"
	local expected_count="$3"
	local actual_count
	actual_count="$(wc -l <"${file}" | tr -d ' ')"
	if [[ "${actual_count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} rows, got ${actual_count}"
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

require_exact_line() {
	local file="$1"
	local label="$2"
	local expected_line="$3"
	local description="$4"
	if ! grep -Fxq -- "${expected_line}" "${file}"; then
		error "${label}: missing required row for ${description}"
	fi
}

list_archive_members() {
	local file="$1"
	if command -v zipinfo >/dev/null 2>&1; then
		zipinfo -1 "${file}"
	else
		unzip -Z -1 "${file}"
	fi
}

require_archive_text() {
	local file="$1"
	local member="$2"
	local pattern="$3"
	local member_contents
	member_contents="$(unzip -p "${file}" "${member}")"
	if ! grep -Fq -- "${pattern}" <<<"${member_contents}"; then
		error "${member}: missing required marker: ${pattern}"
	fi
}

verify_fixture_file() {
	require_file "${project_file}" "seam_test_object.3mf"
	require_size "${project_file}" "seam_test_object.3mf" "2514963"
	require_sha256 "${project_file}" "seam_test_object.3mf" "${EXPECTED_SHA}"
}

verify_provenance() {
	require_exact_header "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_HEADER}"
	require_text "${provenance_file}" "fixture-provenance.tsv" "${PHASE41_SCOPE_RECORD}"

	awk -F '\t' \
		-v fixture_id="seam_test_object.3mf" \
		-v vendor_id="prusaslicer" \
		-v inventory_id="prusaslicer.project-file" \
		-v source_ref="${SOURCE_REF}" \
		-v accepted_tag="version_2.9.5" \
		-v peeled_commit="${PEELED_COMMIT}" \
		-v source_path="tests/data/seam_test_object.3mf" \
		-v upstream_url="https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/data/seam_test_object.3mf" \
		-v bytes="2514963" \
		-v sha256="${EXPECTED_SHA}" \
		-v line_endings="binary" \
		-v role="raw-project-file-fixture" \
		-v phase41_scope_record="${PHASE41_SCOPE_RECORD}" \
		-v update_route="reviewed-intake-change-updates-packages/fork-vendors/forks.tsv-packages/fork-inventories/prusaslicer.tsv-and-packages/prusa-project-file-scope/project-file-scope.md" \
		-v status_scope="Phase-42-fixture-surface-only-no-parity-status" \
		-v exclusions="no-full-3mf-import-export-no-runtime-no-gui-no-generated-output-no-step-no-support-no-arc-no-wall-seam-no-network-device-no-profile-auto-update-no-release-no-bambu-no-orca-no-upstream-source-import-no-sync" '
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
			    $13 != phase41_scope_record ||
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
	' "${provenance_file}" || error "fixture-provenance.tsv: invalid row for seam_test_object.3mf; expected ${PHASE41_SCOPE_RECORD}"

	require_line_count "${provenance_file}" "fixture-provenance.tsv" "2"
}

verify_expected_summary() {
	require_exact_header "${expected_summary_file}" "expected-project-summary.tsv" "${EXPECTED_SUMMARY_HEADER}"

	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\t[Content_Types].xml\topc-content-types\tmember-presence-only\tContent type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.' \
		"[Content_Types].xml"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\t_rels/.rels\tstart-part-relationship\tmember-presence-only\tRelationship target /3D/3dmodel.model is present; no load/save behavior claimed.' \
		"_rels/.rels"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\t3D/3dmodel.model\tslic3rpe:Version3mf\tmember-marker-only\t3MF model carries Prusa/Slic3r version marker; no mesh details or semantics claimed.' \
		"3D/3dmodel.model slic3rpe:Version3mf"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\t3D/3dmodel.model\tApplication=PrusaSlicer-2.8.0-alpha3\tmember-marker-only\tApplication marker only; no runtime version parity claimed.' \
		"3D/3dmodel.model Application=PrusaSlicer-2.8.0-alpha3"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\tMetadata/thumbnail.png\tthumbnail-member-present\tmember-presence-only\tThumbnail archive member is present; no image decoding semantics claimed.' \
		"Metadata/thumbnail.png"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\tMetadata/Slic3r_PE.config\tSlic3r_PE.config-member-present\tmember-presence-only\tProject metadata config file is present; no profile semantics claimed.' \
		"Metadata/Slic3r_PE.config"
	require_exact_line "${expected_summary_file}" "expected-project-summary.tsv" \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\tMetadata/Slic3r_PE_model.config\tSlic3r_PE_model.config-member-present\tmember-presence-only\tModel metadata config file is present; no model/geometry semantics claimed.' \
		"Metadata/Slic3r_PE_model.config"

	require_line_count "${expected_summary_file}" "expected-project-summary.tsv" "8"
}

verify_archive_members() {
	local actual_members
	local expected_members
	actual_members="$(list_archive_members "${project_file}")"
	expected_members=$'[Content_Types].xml\nMetadata/thumbnail.png\n_rels/.rels\n3D/3dmodel.model\nMetadata/Slic3r_PE.config\nMetadata/Slic3r_PE_model.config'

	if [[ "${actual_members}" != "${expected_members}" ]]; then
		error "seam_test_object.3mf: archive members differ from expected project-file fixture surface"
	fi
}

verify_project_markers() {
	require_archive_text "${project_file}" "3D/3dmodel.model" "slic3rpe:Version3mf"
	require_archive_text "${project_file}" "3D/3dmodel.model" "PrusaSlicer-2.8.0-alpha3"
	require_archive_text "${project_file}" "Metadata/Slic3r_PE.config" "; generated by PrusaSlicer 2.8.0-alpha3"
	require_archive_text "${project_file}" "Metadata/Slic3r_PE_model.config" "<config>"
}

verify_readme_scope() {
	local profile_update_text
	local plugin_ingestion_text
	profile_update_text="profile auto-""update execution"
	plugin_ingestion_text="non-free plugin ""ingestion"

	require_text "${fixture_readme}" "fixture README" "# PrusaSlicer Project-File Fixture"
	require_text "${fixture_readme}" "fixture README" "Phase 42 supplies fixture bytes and presence-level expected artifacts only."
	require_text "${fixture_readme}" "fixture README" "Executable project-file parity remains unavailable until Phase 44."
	require_text "${fixture_readme}" "fixture README" "Vendor ID: \`prusaslicer\`"
	require_text "${fixture_readme}" "fixture README" "Inventory ID: \`prusaslicer.project-file\`"
	require_text "${fixture_readme}" "fixture README" "Source ref: ${SOURCE_REF}"
	require_text "${fixture_readme}" "fixture README" "Source path: tests/data/seam_test_object.3mf"
	require_text "${fixture_readme}" "fixture README" "Byte count: \`2514963\`"
	require_text "${fixture_readme}" "fixture README" "${EXPECTED_SHA}"
	require_text "${fixture_readme}" "fixture README" "Phase 41 scope record: ${PHASE41_SCOPE_RECORD}"
	require_text "${fixture_readme}" "fixture README" "Update route: update this fixture only after a reviewed intake change updates packages/fork-vendors/forks.tsv, packages/fork-inventories/prusaslicer.tsv, and packages/prusa-project-file-scope/project-file-scope.md."
	require_text "${fixture_readme}" "fixture README" "Branch-head observations remain drift-only and do not update this fixture."
	require_text "${fixture_readme}" "fixture README" "This namespace does not publish executable parity, parser readiness, generated"
	require_text "${fixture_readme}" "fixture README" "output, or runtime support."

	for required_term in \
		"full 3MF import/export" \
		"runtime support" \
		"GUI project behavior" \
		"generated-output parity" \
		"STEP import" \
		"support generation" \
		"arc fitting" \
		"wall seam behavior" \
		"network/device" \
		"${profile_update_text}" \
		"fork release builds" \
		"Bambu Studio" \
		"OrcaSlicer" \
		"upstream source imports" \
		"sync automation" \
		"generated output"; do
		require_text "${fixture_readme}" "fixture README" "${required_term}"
	done

	require_text "${package_readme}" "packages/parity-fixtures/README.md" "Fixture verification does not fetch upstream source"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "${profile_update_text}"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "${plugin_ingestion_text}"
}

verify_status_row_absent() {
	if grep -Fq -- "fork.prusaslicer.project-file" "${status_file}"; then
		error "packages/parity/status.tsv: forbidden premature row fork.prusaslicer.project-file"
	fi
}

verify_parity_target_absent() {
	if grep -Fq -- "prusaslicer_project_file_parity" "${parity_build_file}"; then
		error "packages/parity/BUILD.bazel: forbidden premature target prusaslicer_project_file_parity"
	fi
}

verify_rust_surface_absent() {
	local root
	local file
	for root in "${rust_src_root}" "${rust_tests_root}"; do
		require_dir "${root}" "Rust flavor guard"
		while IFS= read -r file; do
			if grep -Fq -- "prusa_project_file" "${file}"; then
				error "${file}: forbidden premature Rust project-file surface prusa_project_file"
			fi
		done < <(find "${root}" -type f -print)
	done
}

for required_file in \
	"${fixture_readme}" \
	"${provenance_file}" \
	"${expected_summary_file}" \
	"${project_file}" \
	"${status_file}" \
	"${parity_build_file}" \
	"${package_readme}"; do
	require_file "${required_file}" "input"
done

verify_fixture_file
verify_provenance
verify_expected_summary
verify_archive_members
verify_project_markers
verify_readme_scope
verify_status_row_absent
verify_parity_target_absent
verify_rust_surface_absent

printf 'ok: Prusa project-file fixture verification passed\n'
