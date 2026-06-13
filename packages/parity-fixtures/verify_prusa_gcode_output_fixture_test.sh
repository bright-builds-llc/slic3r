#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

verifier="${workspace_root}/packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh"
source_fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
source_status_file="${workspace_root}/packages/parity/status.tsv"
source_parity_build="${workspace_root}/packages/parity/BUILD.bazel"
source_package_readme="${workspace_root}/packages/parity-fixtures/README.md"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-gcode-output-fixture-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="$1"
	local pattern="$2"
	if ! grep -Eq -- "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,200p' "${file}" >&2
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

remove_line_containing() {
	local file="$1"
	local pattern="$2"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -v pattern="${pattern}" 'index($0, pattern) == 0 { print }' "${file}" >"${tmp_file}"
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

write_valid_fixture_copy() {
	local dir="$1"
	local fixture_dir="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

	mkdir -p \
		"${fixture_dir}" \
		"${dir}/packages/parity" \
		"${dir}/packages/slic3r-rust"
	cp "${source_fixture_dir}/.gitattributes" "${fixture_dir}/.gitattributes"
	cp "${source_fixture_dir}/README.md" "${fixture_dir}/README.md"
	cp "${source_fixture_dir}/expected-gcode-summary.tsv" "${fixture_dir}/expected-gcode-summary.tsv"
	cp "${source_fixture_dir}/fixture-provenance.tsv" "${fixture_dir}/fixture-provenance.tsv"
	cp "${source_fixture_dir}/gcodewriter-set-speed.gcode" "${fixture_dir}/gcodewriter-set-speed.gcode"
	cp "${source_status_file}" "${dir}/packages/parity/status.tsv"
	cp "${source_parity_build}" "${dir}/packages/parity/BUILD.bazel"
	cp "${source_package_readme}" "${dir}/packages/parity-fixtures/README.md"
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"
	local maybe_verifier="${4:-${verifier}}"
	local fixture_dir="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

	set +e
	"${maybe_verifier}" \
		"${fixture_dir}/README.md" \
		"${fixture_dir}/fixture-provenance.tsv" \
		"${fixture_dir}/expected-gcode-summary.tsv" \
		"${fixture_dir}/gcodewriter-set-speed.gcode" \
		"${dir}/packages/parity/status.tsv" \
		"${dir}/packages/parity/BUILD.bazel" \
		"${dir}/packages/parity-fixtures/README.md" \
		"${dir}" >"${stdout_file}" 2>"${stderr_file}"
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
		sed -n '1,200p' "${tmp_dir}/valid.err" >&2
		fail "complete G-code fixture failed"
	fi

	# Assert
	assert_file_equals "${tmp_dir}/valid.out" "ok: Prusa G-code output fixture verification passed"
}

test_wrong_gcode_checksum_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-gcode-checksum"
	local gcode_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing "${gcode_file}" "G1 F1" "G1 F2"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-checksum.out" "${tmp_dir}/wrong-checksum.err"; then
		fail "wrong G-code checksum fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-checksum.err" "SHA-256"
}

test_crlf_gcode_fails() {
	# Arrange
	local dir="${tmp_dir}/crlf-gcode"
	local gcode_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
	local tmp_file="${gcode_file}.tmp"
	write_valid_fixture_copy "${dir}"
	awk '{ printf "%s\r\n", $0 }' "${gcode_file}" >"${tmp_file}"
	mv "${tmp_file}" "${gcode_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/crlf.out" "${tmp_dir}/crlf.err"; then
		fail "CRLF G-code fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/crlf.err" "US-ASCII text with LF line endings"
}

test_non_ascii_gcode_fails() {
	# Arrange
	local dir="${tmp_dir}/non-ascii-gcode"
	local gcode_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
	write_valid_fixture_copy "${dir}"
	printf 'G1 Fé\n' >>"${gcode_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/non-ascii.out" "${tmp_dir}/non-ascii.err"; then
		fail "non-ASCII G-code fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/non-ascii.err" "US-ASCII text with LF line endings"
}

test_missing_provenance_header_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-provenance-header"
	local provenance_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${provenance_file}" $'fixture_id\tvendor_id\tinventory_id'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-provenance-header.out" "${tmp_dir}/missing-provenance-header.err"; then
		fail "missing provenance header fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-provenance-header.err" "fixture-provenance.tsv"
}

test_wrong_provenance_row_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-provenance-row"
	local provenance_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing "${provenance_file}" "ascii-lf" "ascii-crlf"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-provenance-row.out" "${tmp_dir}/wrong-provenance-row.err"; then
		fail "wrong provenance row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-provenance-row.err" "fixture-provenance.tsv"
}

test_missing_expected_header_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-header"
	local expected_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${expected_file}" $'source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-expected-header.out" "${tmp_dir}/missing-expected-header.err"; then
		fail "missing expected-gcode-summary header fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-expected-header.err" "expected-gcode-summary.tsv"
}

test_missing_expected_marker_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-marker-row"
	local expected_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${expected_file}" $'\tline_3\tG1 F203.2\t'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-marker-row.out" "${tmp_dir}/missing-marker-row.err"; then
		fail "missing expected marker row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-marker-row.err" "line_3"
}

test_extra_expected_summary_row_fails() {
	# Arrange
	local dir="${tmp_dir}/extra-expected-summary-row"
	local expected_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tunsupported\tbyte-for-byte\tline_5\tG1 F999\tInjected overclaim row must fail.' >>"${expected_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/extra-expected-row.out" "${tmp_dir}/extra-expected-row.err"; then
		fail "extra expected-gcode-summary row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/extra-expected-row.err" "expected-gcode-summary.tsv: expected 6 rows"
}

test_missing_update_route_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-update-route"
	local readme_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "Update route:"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-update-route.out" "${tmp_dir}/missing-update-route.err"; then
		fail "missing update route fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-update-route.err" "Update route"
}

test_missing_privacy_exclusions_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-privacy-exclusions"
	local readme_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "No base export fixture reuse"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-privacy.out" "${tmp_dir}/missing-privacy.err"; then
		fail "missing privacy exclusions fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-privacy.err" "No base export fixture reuse"
}

test_readme_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/readme-overclaim"
	local readme_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md"
	write_valid_fixture_copy "${dir}"
	printf '\nverified Prusa G-code output parity\n' >>"${readme_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/readme-overclaim.out" "${tmp_dir}/readme-overclaim.err"; then
		fail "README overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/readme-overclaim.err" "forbidden"
}

test_premature_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-status-row"
	write_valid_fixture_copy "${dir}"
	printf 'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tpremature\n' \
		>>"${dir}/packages/parity/status.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-status.out" "${tmp_dir}/premature-status.err"; then
		fail "premature status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-status.err" "fork\\.prusaslicer\\.gcode-output"
}

assert_premature_parity_target_form_fails() {
	local case_name="$1"
	local build_snippet="$2"
	local dir="${tmp_dir}/premature-parity-target-${case_name}"
	local stdout_file="${tmp_dir}/premature-parity-${case_name}.out"
	local stderr_file="${tmp_dir}/premature-parity-${case_name}.err"

	# Arrange
	write_valid_fixture_copy "${dir}"
	printf '\n%s\n' "${build_snippet}" >>"${dir}/packages/parity/BUILD.bazel"

	# Act
	if run_verifier "${dir}" "${stdout_file}" "${stderr_file}"; then
		fail "premature parity target fixture passed for ${case_name}"
	fi

	# Assert
	assert_contains "${stderr_file}" "prusaslicer_gcode_output_parity"
}

test_premature_parity_target_fails() {
	assert_premature_parity_target_form_fails "spaced" $'sh_binary(\n    name = "prusaslicer_gcode_output_parity",\n    srcs = ["placeholder.sh"],\n)'
	assert_premature_parity_target_form_fails "compact" 'sh_binary(name="prusaslicer_gcode_output_parity", srcs=["placeholder.sh"])'
	assert_premature_parity_target_form_fails "single-quoted" "sh_binary(name='prusaslicer_gcode_output_parity', srcs=['placeholder.sh'])"
}

test_premature_slic3r_flavors_marker_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-slic3r-flavors-marker"
	write_valid_fixture_copy "${dir}"
	mkdir -p "${dir}/packages/slic3r-rust/crates/slic3r_flavors/src"
	printf '%s\n' "const SURFACE: &str = \"slic3r_flavors::prusa_gcode_output\";" \
		>"${dir}/packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-slic3r-flavors.out" "${tmp_dir}/premature-slic3r-flavors.err"; then
		fail "premature slic3r_flavors marker fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-slic3r-flavors.err" "slic3r_flavors::prusa_gcode_output"
}

test_premature_rust_marker_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-rust-marker"
	write_valid_fixture_copy "${dir}"
	mkdir -p "${dir}/packages/slic3r-rust/crates/slic3r_flavors/src"
	printf '%s\n' "pub mod prusa_gcode_output;" \
		"pub fn parse_prusa_gcode_output_summary() {}" \
		>"${dir}/packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-rust-marker.out" "${tmp_dir}/premature-rust-marker.err"; then
		fail "premature Rust marker fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-rust-marker.err" "pub mod prusa_gcode_output|parse_prusa_gcode_output_summary"
}

test_forbidden_verifier_behavior_fails() {
	# Arrange
	local dir="${tmp_dir}/forbidden-verifier-behavior"
	local verifier_copy="${dir}/verify_prusa_gcode_output_fixture.sh"
	write_valid_fixture_copy "${dir}"
	cp "${verifier}" "${verifier_copy}"
	chmod +x "${verifier_copy}"
	printf '\n# curl https://example.invalid\n' >>"${verifier_copy}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/forbidden-verifier.out" "${tmp_dir}/forbidden-verifier.err" "${verifier_copy}"; then
		fail "forbidden verifier behavior fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/forbidden-verifier.err" "forbidden verifier behavior"
}

test_complete_fixture_passes
test_wrong_gcode_checksum_fails
test_crlf_gcode_fails
test_non_ascii_gcode_fails
test_missing_provenance_header_fails
test_wrong_provenance_row_fails
test_missing_expected_header_fails
test_missing_expected_marker_row_fails
test_extra_expected_summary_row_fails
test_missing_update_route_fails
test_missing_privacy_exclusions_fails
test_readme_overclaim_fails
test_premature_status_row_fails
test_premature_parity_target_fails
test_premature_slic3r_flavors_marker_fails
test_premature_rust_marker_fails
test_forbidden_verifier_behavior_fails

printf 'ok: verify_prusa_gcode_output_fixture_test\n'
