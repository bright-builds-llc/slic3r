#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

verifier="${workspace_root}/packages/parity-fixtures/verify_prusa_project_file_fixture.sh"
source_fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file"
source_status_file="${workspace_root}/packages/parity/status.tsv"
source_parity_build="${workspace_root}/packages/parity/BUILD.bazel"
source_package_readme="${workspace_root}/packages/parity-fixtures/README.md"
source_rust_src_root="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/src"
source_rust_tests_root="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/tests"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-project-file-fixture-test.XXXXXX")"
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

assert_file_equals() {
	local file="$1"
	local expected="$2"
	local actual
	actual="$(cat "${file}")"
	if [[ "${actual}" != "${expected}" ]]; then
		printf 'expected: %s\nactual: %s\n' "${expected}" "${actual}" >&2
		exit 1
	fi
}

copy_tree() {
	local source_dir="$1"
	local dest_dir="$2"
	mkdir -p "${dest_dir}"
	cp -R "${source_dir}/." "${dest_dir}/"
}

remove_line_containing() {
	local file="$1"
	local pattern="$2"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -v pattern="${pattern}" 'index($0, pattern) == 0 { print }' "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

write_valid_fixture_copy() {
	local dir="$1"
	local fixture_dir="${dir}/forks/prusaslicer/prusaslicer.project-file"

	mkdir -p "${fixture_dir}"
	cp "${source_fixture_dir}/.gitattributes" "${fixture_dir}/.gitattributes"
	cp "${source_fixture_dir}/README.md" "${fixture_dir}/README.md"
	cp "${source_fixture_dir}/expected-project-summary.tsv" "${fixture_dir}/expected-project-summary.tsv"
	cp "${source_fixture_dir}/fixture-provenance.tsv" "${fixture_dir}/fixture-provenance.tsv"
	cp "${source_fixture_dir}/seam_test_object.3mf" "${fixture_dir}/seam_test_object.3mf"
	cp "${source_status_file}" "${dir}/status.tsv"
	cp "${source_parity_build}" "${dir}/parity.BUILD.bazel"
	cp "${source_package_readme}" "${dir}/parity-fixtures-README.md"
	copy_tree "${source_rust_src_root}" "${dir}/rust-src"
	copy_tree "${source_rust_tests_root}" "${dir}/rust-tests"
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"
	local fixture_dir="${dir}/forks/prusaslicer/prusaslicer.project-file"

	set +e
	"${verifier}" \
		"${fixture_dir}/README.md" \
		"${fixture_dir}/fixture-provenance.tsv" \
		"${fixture_dir}/expected-project-summary.tsv" \
		"${fixture_dir}/seam_test_object.3mf" \
		"${dir}/status.tsv" \
		"${dir}/parity.BUILD.bazel" \
		"${dir}/parity-fixtures-README.md" \
		"${dir}/rust-src" \
		"${dir}/rust-tests" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

if [[ ! -x "${verifier}" ]]; then
	fail "verifier is not executable: ${verifier}"
fi

test_complete_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture_copy "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,160p' "${tmp_dir}/valid.err" >&2
		fail "complete project-file fixture failed"
	fi

	# Assert
	assert_file_equals "${tmp_dir}/valid.out" "ok: Prusa project-file fixture verification passed"
}

test_wrong_project_file_checksum_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-project-file-checksum"
	write_valid_fixture_copy "${dir}"
	printf 'x' | dd of="${dir}/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf" bs=1 seek=10 count=1 conv=notrunc >/dev/null 2>&1

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-checksum.out" "${tmp_dir}/wrong-checksum.err"; then
		fail "wrong project-file checksum fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-checksum.err" "9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2"
}

test_missing_expected_header_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-header"
	local expected_file="${dir}/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${expected_file}" $'source_ref\tfixture_path\tarchive_member\tproject_marker\tdeferred_semantics\tnotes'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-header.out" "${tmp_dir}/missing-header.err"; then
		fail "missing expected-project-summary header fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-header.err" "expected-project-summary.tsv"
}

test_missing_expected_archive_member_rows_fail() {
	local member
	for member in \
		"[Content_Types].xml" \
		"_rels/.rels" \
		"3D/3dmodel.model" \
		"Metadata/thumbnail.png" \
		"Metadata/Slic3r_PE.config" \
		"Metadata/Slic3r_PE_model.config"; do
		# Arrange
		local dir="${tmp_dir}/missing-member-${member//\//-}"
		local expected_file="${dir}/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv"
		write_valid_fixture_copy "${dir}"
		remove_line_containing "${expected_file}" $'\t'"${member}"$'\t'

		# Act
		if run_verifier "${dir}" "${tmp_dir}/missing-${member//\//-}.out" "${tmp_dir}/missing-${member//\//-}.err"; then
			fail "missing ${member} expected row fixture passed"
		fi

		# Assert
		assert_contains "${tmp_dir}/missing-${member//\//-}.err" "${member}"
	done
}

test_extra_expected_summary_row_fails() {
	# Arrange
	local dir="${tmp_dir}/extra-expected-summary-row"
	local expected_file="${dir}/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\t3D/3dmodel.model\tfull-import-export-parity\tunsupported-semantic-claim\tInjected overclaim row must fail.' >>"${expected_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/extra-expected-row.out" "${tmp_dir}/extra-expected-row.err"; then
		fail "extra expected-project-summary row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/extra-expected-row.err" "expected-project-summary.tsv: expected 8 rows"
}

test_missing_scope_path_in_provenance_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-scope-path-provenance"
	local provenance_file="${dir}/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${provenance_file}" "packages/prusa-project-file-scope/project-file-scope.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-scope-provenance.out" "${tmp_dir}/missing-scope-provenance.err"; then
		fail "missing provenance scope path fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-scope-provenance.err" "packages/prusa-project-file-scope/project-file-scope.md"
}

test_extra_provenance_row_fails() {
	# Arrange
	local dir="${tmp_dir}/extra-provenance-row"
	local provenance_file="${dir}/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'extra_semantic_fixture\tprusaslicer\tprusaslicer.project-file\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tversion_2.9.5\t9a583bd438b195856f3bcf7ea99b69ba4003a961\ttests/data/extra.3mf\thttps://example.invalid/extra.3mf\t1\t0\tbinary\tunsupported-semantic-fixture\tpackages/prusa-project-file-scope/project-file-scope.md\tmanual\tPhase-42-fixture-surface-only-no-parity-status\tunsupported-extra-row' >>"${provenance_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/extra-provenance-row.out" "${tmp_dir}/extra-provenance-row.err"; then
		fail "extra provenance row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/extra-provenance-row.err" "fixture-provenance.tsv: expected 2 rows"
}

test_missing_scope_path_in_readme_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-scope-path-readme"
	local readme_file="${dir}/forks/prusaslicer/prusaslicer.project-file/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "packages/prusa-project-file-scope/project-file-scope.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-scope-readme.out" "${tmp_dir}/missing-scope-readme.err"; then
		fail "missing README scope path fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-scope-readme.err" "packages/prusa-project-file-scope/project-file-scope.md"
}

test_premature_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-status-row"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'fork.prusaslicer.project-file\tverified\t//packages/parity:prusaslicer_project_file_parity\tpremature project-file row' >>"${dir}/status.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-status.out" "${tmp_dir}/premature-status.err"; then
		fail "premature project-file status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-status.err" "fork.prusaslicer.project-file"
}

test_premature_parity_target_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-parity-target"
	write_valid_fixture_copy "${dir}"
	printf '\nsh_binary(name = "prusaslicer_project_file_parity", srcs = ["placeholder.sh"])\n' >>"${dir}/parity.BUILD.bazel"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-target.out" "${tmp_dir}/premature-target.err"; then
		fail "premature project-file parity target fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-target.err" "prusaslicer_project_file_parity"
}

test_premature_rust_surface_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-rust-surface"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' "pub mod prusa_project_file;" >"${dir}/rust-src/prusa_project_file.rs"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-rust.out" "${tmp_dir}/premature-rust.err"; then
		fail "premature project-file Rust surface fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-rust.err" "prusa_project_file"
}

test_complete_fixture_passes
test_wrong_project_file_checksum_fails
test_missing_expected_header_fails
test_missing_expected_archive_member_rows_fail
test_extra_expected_summary_row_fails
test_missing_scope_path_in_provenance_fails
test_extra_provenance_row_fails
test_missing_scope_path_in_readme_fails
test_premature_status_row_fails
test_premature_parity_target_fails
test_premature_rust_surface_fails

printf 'ok: verify_prusa_project_file_fixture_test\n'
