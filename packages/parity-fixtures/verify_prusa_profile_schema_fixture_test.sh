#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

verifier="${workspace_root}/packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh"
source_fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema"
source_status_file="${workspace_root}/packages/parity/status.tsv"
source_package_readme="${workspace_root}/packages/parity-fixtures/README.md"
valid_prusa_status_row=$'fork.prusaslicer.profile-schema\tverified\t//packages/parity:prusaslicer_profile_schema_parity\tShared fixture comparison proves the narrow Prusa profile-schema parser/config evidence slice only; full PrusaSlicer runtime support remains deferred'

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-profile-schema-fixture-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="$1"
	local pattern="$2"
	if ! grep -Fq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,160p' "${file}" >&2
		exit 1
	fi
}

remove_line_containing() {
	local file="$1"
	local pattern="$2"
	local tmp_file
	tmp_file="${file}.tmp"
	grep -Fv "${pattern}" "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

replace_first_line_containing() {
	local file="$1"
	local pattern="$2"
	local replacement="$3"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -v pattern="${pattern}" -v replacement="${replacement}" '
		!replaced && index($0, pattern) { print replacement; replaced = 1; next }
		{ print }
	' "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/README.md" \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv" \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini" \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx" \
		"${dir}/status.tsv" \
		"${dir}/parity-fixtures-README.md" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

write_valid_fixture_copy() {
	local dir="$1"
	local fixture_dir="${dir}/forks/prusaslicer/prusaslicer.profile-schema"

	mkdir -p "${fixture_dir}"
	cp "${source_fixture_dir}/.gitattributes" "${fixture_dir}/.gitattributes"
	cp "${source_fixture_dir}/README.md" "${fixture_dir}/README.md"
	cp "${source_fixture_dir}/expected-summary.tsv" "${fixture_dir}/expected-summary.tsv"
	cp "${source_fixture_dir}/fixture-provenance.tsv" "${fixture_dir}/fixture-provenance.tsv"
	cp "${source_fixture_dir}/PrusaResearch.ini" "${fixture_dir}/PrusaResearch.ini"
	cp "${source_fixture_dir}/PrusaResearch.idx" "${fixture_dir}/PrusaResearch.idx"
	cp "${source_status_file}" "${dir}/status.tsv"
	cp "${source_package_readme}" "${dir}/parity-fixtures-README.md"
}

if [[ ! -x "${verifier}" ]]; then
	fail "verifier is not executable: ${verifier}"
fi

test_complete_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture_copy "${dir}"

	# Act
	if ! PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,160p' "${tmp_dir}/valid.err" >&2
		fail "complete fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" "ok: Prusa profile-schema fixture verification passed"
}

test_missing_prusa_research_ini_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-ini"
	write_valid_fixture_copy "${dir}"
	rm "${dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-ini.out" "${tmp_dir}/missing-ini.err"; then
		fail "missing PrusaResearch.ini fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-ini.err" "PrusaResearch.ini"
}

test_wrong_ini_checksum_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-ini-checksum"
	write_valid_fixture_copy "${dir}"
	perl -0pi -e 's/Prusa/Prusb/' "${dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/wrong-ini-checksum.out" "${tmp_dir}/wrong-ini-checksum.err"; then
		fail "wrong PrusaResearch.ini checksum fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-ini-checksum.err" "a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839"
}

test_missing_source_ref_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-source-ref"
	write_valid_fixture_copy "${dir}"
	perl -0pi -e 's/prusaslicer:version_2\.9\.5\@9a583bd438b195856f3bcf7ea99b69ba4003a961/prusaslicer:version_2.9.4@9a583bd438b195856f3bcf7ea99b69ba4003a961/g' \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-source-ref.out" "${tmp_dir}/missing-source-ref.err"; then
		fail "missing source ref fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-source-ref.err" "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
}

test_swapped_provenance_rows_fail() {
	# Arrange
	local dir="${tmp_dir}/swapped-provenance"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv" \
		"PrusaResearch.ini	prusaslicer" \
		"PrusaResearch.ini	prusaslicer	prusaslicer.profile-schema	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	version_2.9.5	9a583bd438b195856f3bcf7ea99b69ba4003a961	resources/profiles/PrusaResearch.ini	https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini	31543	65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1	crlf	raw-vendor-bundle-index	packages/prusa-baseline/profile-schema-checklist.md	reviewed-intake-change-updates-packages/fork-vendors/forks.tsv-and-prusa-baseline-gate	Phase-38-fixture-status-preparation-only	no-bambu-no-orca-no-network-no-cloud-no-credentials-no-profile-auto-update-no-non-free-plugin-no-runtime-no-gui-no-sync-no-release"
	replace_first_line_containing \
		"${dir}/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv" \
		"PrusaResearch.idx	prusaslicer" \
		"PrusaResearch.idx	prusaslicer	prusaslicer.profile-schema	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	version_2.9.5	9a583bd438b195856f3bcf7ea99b69ba4003a961	resources/profiles/PrusaResearch.idx	https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx	1543688	a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839	lf	raw-vendor-bundle-input	packages/prusa-baseline/profile-schema-checklist.md	reviewed-intake-change-updates-packages/fork-vendors/forks.tsv-and-prusa-baseline-gate	Phase-38-fixture-status-preparation-only	no-bambu-no-orca-no-network-no-cloud-no-credentials-no-profile-auto-update-no-non-free-plugin-no-runtime-no-gui-no-sync-no-release"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/swapped-provenance.out" "${tmp_dir}/swapped-provenance.err"; then
		fail "swapped provenance row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/swapped-provenance.err" "fixture-provenance.tsv: invalid row for PrusaResearch.ini"
}

test_missing_static_input_boundary_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-static-boundary"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${dir}/forks/prusaslicer/prusaslicer.profile-schema/README.md" "Static fixture input only."

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-static-boundary.out" "${tmp_dir}/missing-static-boundary.err"; then
		fail "missing static input boundary fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-static-boundary.err" "Static fixture input only."
}

test_forbidden_bambu_namespace_fails() {
	# Arrange
	local dir="${tmp_dir}/forbidden-bambu"
	write_valid_fixture_copy "${dir}"
	mkdir -p "${dir}/forks/bambustudio"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/forbidden-bambu.out" "${tmp_dir}/forbidden-bambu.err"; then
		fail "forbidden Bambu namespace fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/forbidden-bambu.err" "bambustudio"
}

test_parent_directory_forbidden_token_passes() {
	# Arrange
	local dir="${tmp_dir}/cloud/valid"
	write_valid_fixture_copy "${dir}"

	# Act
	if ! PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/parent-cloud.out" "${tmp_dir}/parent-cloud.err"; then
		sed -n '1,160p' "${tmp_dir}/parent-cloud.err" >&2
		fail "parent directory forbidden token caused valid fixture failure"
	fi

	# Assert
	assert_contains "${tmp_dir}/parent-cloud.out" "ok: Prusa profile-schema fixture verification passed"
}

test_project_file_namespace_passes() {
	# Arrange
	local dir="${tmp_dir}/project-file-namespace"
	write_valid_fixture_copy "${dir}"
	mkdir -p "${dir}/forks/prusaslicer/prusaslicer.project-file"

	# Act
	if ! PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/project-file-namespace.out" "${tmp_dir}/project-file-namespace.err"; then
		sed -n '1,160p' "${tmp_dir}/project-file-namespace.err" >&2
		fail "project-file namespace caused valid fixture failure"
	fi

	# Assert
	assert_contains "${tmp_dir}/project-file-namespace.out" "ok: Prusa profile-schema fixture verification passed"
}

test_missing_prusa_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-status-row"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${dir}/status.tsv" "fork.prusaslicer.profile-schema"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-status-row.out" "${tmp_dir}/missing-status-row.err"; then
		fail "missing Prusa status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-status-row.err" "packages/parity/status.tsv"
	assert_contains "${tmp_dir}/missing-status-row.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/missing-status-row.err" "status"
}

test_wrong_prusa_status_evidence_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-status-evidence"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${dir}/status.tsv" \
		"fork.prusaslicer.profile-schema" \
		$'fork.prusaslicer.profile-schema\tverified\t//packages/parity:wrong_prusa_profile_schema_parity\tShared fixture comparison proves the narrow Prusa profile-schema parser/config evidence slice only; full PrusaSlicer runtime support remains deferred'

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/wrong-status-evidence.out" "${tmp_dir}/wrong-status-evidence.err"; then
		fail "wrong Prusa status evidence fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-status-evidence.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/wrong-status-evidence.err" "evidence"
}

test_wrong_prusa_status_value_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-status-value"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${dir}/status.tsv" \
		"fork.prusaslicer.profile-schema" \
		$'fork.prusaslicer.profile-schema\tin progress\t//packages/parity:prusaslicer_profile_schema_parity\tShared fixture comparison proves the narrow Prusa profile-schema parser/config evidence slice only; full PrusaSlicer runtime support remains deferred'

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/wrong-status-value.out" "${tmp_dir}/wrong-status-value.err"; then
		fail "wrong Prusa status value fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-status-value.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/wrong-status-value.err" "status"
}

test_duplicate_prusa_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-status-row"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' "${valid_prusa_status_row}" >>"${dir}/status.tsv"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/duplicate-status-row.out" "${tmp_dir}/duplicate-status-row.err"; then
		fail "duplicate Prusa status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-status-row.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/duplicate-status-row.err" "status"
}

test_prusa_status_notes_missing_narrow_scope_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-narrow-status-notes"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${dir}/status.tsv" \
		"fork.prusaslicer.profile-schema" \
		$'fork.prusaslicer.profile-schema\tverified\t//packages/parity:prusaslicer_profile_schema_parity\tShared fixture comparison proves broad Prusa profile evidence; full PrusaSlicer runtime support remains deferred'

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-narrow-status-notes.out" "${tmp_dir}/missing-narrow-status-notes.err"; then
		fail "Prusa status notes missing narrow scope passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-narrow-status-notes.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/missing-narrow-status-notes.err" "notes"
}

test_prusa_status_notes_missing_runtime_deferral_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-runtime-status-notes"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${dir}/status.tsv" \
		"fork.prusaslicer.profile-schema" \
		$'fork.prusaslicer.profile-schema\tverified\t//packages/parity:prusaslicer_profile_schema_parity\tShared fixture comparison proves the narrow Prusa profile-schema parser/config evidence slice only'

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/missing-runtime-status-notes.out" "${tmp_dir}/missing-runtime-status-notes.err"; then
		fail "Prusa status notes missing runtime deferral passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-runtime-status-notes.err" "fork.prusaslicer.profile-schema"
	assert_contains "${tmp_dir}/missing-runtime-status-notes.err" "notes"
}

test_complete_fixture_passes
test_missing_prusa_research_ini_fails
test_wrong_ini_checksum_fails
test_missing_source_ref_fails
test_swapped_provenance_rows_fail
test_missing_static_input_boundary_fails
test_forbidden_bambu_namespace_fails
test_parent_directory_forbidden_token_passes
test_project_file_namespace_passes
test_missing_prusa_status_row_fails
test_wrong_prusa_status_evidence_fails
test_wrong_prusa_status_value_fails
test_duplicate_prusa_status_row_fails
test_prusa_status_notes_missing_narrow_scope_fails
test_prusa_status_notes_missing_runtime_deferral_fails

printf 'ok: verify_prusa_profile_schema_fixture_test\n'
