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

test_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/status-row"
	write_valid_fixture_copy "${dir}"
	printf 'fork.prusaslicer.profile-schema\tverified\t//packages/parity:prusaslicer_profile_schema_parity\tinvalid Phase 38 row\n' >>"${dir}/status.tsv"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/status-row.out" "${tmp_dir}/status-row.err"; then
		fail "Prusa status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/status-row.err" "packages/parity/status.tsv"
	assert_contains "${tmp_dir}/status-row.err" "fork.prusaslicer.profile-schema"
}

test_complete_fixture_passes
test_missing_prusa_research_ini_fails
test_wrong_ini_checksum_fails
test_missing_source_ref_fails
test_missing_static_input_boundary_fails
test_forbidden_bambu_namespace_fails
test_status_row_fails

printf 'ok: verify_prusa_profile_schema_fixture_test\n'
