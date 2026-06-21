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

assert_contains_all() {
	local file="$1"
	shift
	local pattern
	for pattern in "$@"; do
		assert_contains "${file}" "${pattern}"
	done
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

move_semantic_row_before() {
	local file="$1"
	local moved_field="$2"
	local before_field="$3"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -F '\t' -v moved_field="${moved_field}" -v before_field="${before_field}" '
		NR == 1 { print; next }
		$3 == moved_field { moved_row = $0; next }
		$3 == before_field && moved_row != "" { print moved_row; moved_row = ""; print; next }
		{ print }
		END {
			if (moved_row != "") {
				print moved_row
			}
		}
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
	cp "${source_fixture_dir}/expected-gcode-structural-summary.tsv" "${fixture_dir}/expected-gcode-structural-summary.tsv"
	cp "${source_fixture_dir}/expected-gcode-semantic-summary.tsv" "${fixture_dir}/expected-gcode-semantic-summary.tsv"
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
		"${fixture_dir}/expected-gcode-structural-summary.tsv" \
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

test_structural_value_drift_fails() {
	# Arrange
	local dir="${tmp_dir}/structural-value-drift"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${structural_file}" \
		$'\tcommand_count_g1\tcommand counts\t4\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tcommand_count_g1\tcommand counts\t3\tCount of `G1` command rows in the selected fixture only; no toolpath geometry claimed.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/structural-value-drift.out" "${tmp_dir}/structural-value-drift.err"; then
		fail "structural value drift fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/structural-value-drift.err" \
		"expected-gcode-structural-summary.tsv" \
		"command_count_g1"
}

test_missing_structural_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-structural-row"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${structural_file}" $'\tordered_marker_3\tordered markers\tG1 F203.2\t'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-structural-row.out" "${tmp_dir}/missing-structural-row.err"; then
		fail "missing structural row fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/missing-structural-row.err" \
		"ordered_marker_3" \
		"expected-gcode-structural-summary.tsv"
}

test_duplicate_structural_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-structural-row"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	local duplicate_row
	write_valid_fixture_copy "${dir}"
	duplicate_row="$(awk -F '\t' '$3 == "command_count_total" { print; exit }' "${structural_file}")"
	printf '%s\n' "${duplicate_row}" >>"${structural_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-structural-row.out" "${tmp_dir}/duplicate-structural-row.err"; then
		fail "duplicate structural row fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/duplicate-structural-row.err" \
		"command_count_total" \
		"duplicate" \
		"expected-gcode-structural-summary.tsv"
}

test_unsupported_structural_field_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-structural-field"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tgeometry_count\tunsupported generated-output semantics\t999\tUnsupported generated-output field that must fail closed.' >>"${structural_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-structural-field.out" "${tmp_dir}/unsupported-structural-field.err"; then
		fail "unsupported structural field fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/unsupported-structural-field.err" \
		"unsupported structural field" \
		"geometry_count" \
		"expected-gcode-structural-summary.tsv"
}

test_structural_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/structural-overclaim"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${structural_file}" \
		$'\tcommand_count_total\tcommand counts\t4\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tcommand_count_total\tcommand counts\t4\tverified Prusa G-code output parity'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/structural-overclaim.out" "${tmp_dir}/structural-overclaim.err"; then
		fail "structural overclaim fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/structural-overclaim.err" \
		"forbidden" \
		"verified Prusa G-code output parity" \
		"expected-gcode-structural-summary.tsv"
}

test_structural_provenance_mismatch_fails() {
	# Arrange
	local dir="${tmp_dir}/structural-provenance-mismatch"
	local structural_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${structural_file}" \
		$'\tsource_ref\tsource identity\t' \
		$'prusaslicer:version_2.9.4@0000000000000000000000000000000000000000\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tsource_ref\tsource identity\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tAccepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/structural-provenance-mismatch.out" "${tmp_dir}/structural-provenance-mismatch.err"; then
		fail "structural provenance mismatch fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/structural-provenance-mismatch.err" \
		"provenance mismatch" \
		"source_ref" \
		"expected-gcode-structural-summary.tsv"
}

test_missing_semantic_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-semantic-row"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${semantic_file}" $'\tcoordinate_bounds\t'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-semantic-row.out" "${tmp_dir}/missing-semantic-row.err"; then
		fail "missing semantic row fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/missing-semantic-row.err" \
		"missing semantic field" \
		"coordinate_bounds" \
		"expected-gcode-semantic-summary.tsv"
}

test_duplicate_semantic_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-semantic-row"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	local duplicate_row
	write_valid_fixture_copy "${dir}"
	duplicate_row="$(awk -F '\t' '$3 == "feedrate_observations" { print; exit }' "${semantic_file}")"
	printf '%s\n' "${duplicate_row}" >>"${semantic_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-semantic-row.out" "${tmp_dir}/duplicate-semantic-row.err"; then
		fail "duplicate semantic row fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/duplicate-semantic-row.err" \
		"duplicate semantic field" \
		"feedrate_observations" \
		"expected-gcode-semantic-summary.tsv"
}

test_out_of_order_semantic_row_fails() {
	# Arrange
	local dir="${tmp_dir}/out-of-order-semantic-row"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	move_semantic_row_before "${semantic_file}" "feedrate_observations" "extrusion_total"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/out-of-order-semantic-row.out" "${tmp_dir}/out-of-order-semantic-row.err"; then
		fail "out-of-order semantic row fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/out-of-order-semantic-row.err" \
		"semantic rows out of order" \
		"feedrate_observations" \
		"expected-gcode-semantic-summary.tsv"
}

test_unsupported_semantic_field_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-semantic-field"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\ttoolpath_geometry\tunsupported generated-output semantics\tverified\tUnsupported semantic field that must fail closed.' >>"${semantic_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-semantic-field.out" "${tmp_dir}/unsupported-semantic-field.err"; then
		fail "unsupported semantic field fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/unsupported-semantic-field.err" \
		"unsupported semantic field" \
		"toolpath_geometry" \
		"expected-gcode-semantic-summary.tsv"
}

test_semantic_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/semantic-overclaim"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${semantic_file}" \
		$'\tcommand_class_counts\tcommand classes\tG1:4;feedrate_only:4\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tcommand_class_counts\tcommand classes\tG1:4;feedrate_only:4\tverified Prusa G-code output parity'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/semantic-overclaim.out" "${tmp_dir}/semantic-overclaim.err"; then
		fail "semantic overclaim fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/semantic-overclaim.err" \
		"forbidden" \
		"verified Prusa G-code output parity" \
		"expected-gcode-semantic-summary.tsv"
}

test_semantic_provenance_mismatch_fails() {
	# Arrange
	local dir="${tmp_dir}/semantic-provenance-mismatch"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${semantic_file}" \
		$'\tfeedrate_observations\tfeedrate observations\t' \
		$'prusaslicer:version_2.9.4@0000000000000000000000000000000000000000\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfeedrate_observations\tfeedrate observations\tF99999.123;F1;F203.2;F203.201\tFeedrate metadata only from the selected fixture summary; no timing, firmware, or printer-runtime behavior claim.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/semantic-provenance-mismatch.out" "${tmp_dir}/semantic-provenance-mismatch.err"; then
		fail "semantic provenance mismatch fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/semantic-provenance-mismatch.err" \
		"provenance mismatch" \
		"feedrate_observations" \
		"expected-gcode-semantic-summary.tsv"
}

test_semantic_fixture_identity_mismatch_fails() {
	# Arrange
	local dir="${tmp_dir}/semantic-fixture-identity-mismatch"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${semantic_file}" \
		$'\tfixture_id\tfixture identity\tgcodewriter-set-speed.gcode\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfixture_id\tfixture identity\tother-fixture.gcode\tFixture identity only: `other-fixture.gcode`.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/semantic-fixture-identity-mismatch.out" "${tmp_dir}/semantic-fixture-identity-mismatch.err"; then
		fail "semantic fixture identity mismatch fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/semantic-fixture-identity-mismatch.err" \
		"fixture_id" \
		"other-fixture.gcode" \
		"expected-gcode-semantic-summary.tsv"
}

test_missing_semantic_readme_reference_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-semantic-readme-reference"
	local readme_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "Semantic expected artifact"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-semantic-readme-reference.out" "${tmp_dir}/missing-semantic-readme-reference.err"; then
		fail "missing semantic README reference fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/missing-semantic-readme-reference.err" \
		"Semantic expected artifact" \
		"fixture README"
}

test_missing_package_semantic_boundary_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-package-semantic-boundary"
	local package_readme="${dir}/packages/parity-fixtures/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${package_readme}" "Fixture verification checks checked-in artifacts only"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-package-semantic-boundary.out" "${tmp_dir}/missing-package-semantic-boundary.err"; then
		fail "missing package semantic boundary fixture passed"
	fi

	# Assert
	assert_contains_all \
		"${tmp_dir}/missing-package-semantic-boundary.err" \
		"Fixture verification checks checked-in artifacts only" \
		"packages/parity-fixtures/README.md"
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

test_missing_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-status-row"
	local status_file="${dir}/packages/parity/status.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${status_file}" "fork.prusaslicer.gcode-output"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-status.out" "${tmp_dir}/missing-status.err"; then
		fail "missing status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-status.err" "fork\\.prusaslicer\\.gcode-output"
}

test_wrong_status_evidence_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-status-evidence"
	local status_file="${dir}/packages/parity/status.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${status_file}" \
		"fork.prusaslicer.gcode-output" \
		$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:wrong_gcode_output_parity\tShared fixture comparison proves the narrow structural Prusa G-code evidence slice backed by the Phase 49 closed structural scope contract, Phase 50 structural fixture summary, Phase 51 Rust structural parser/readiness boundary, and Phase 52 public parity command only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-evidence.out" "${tmp_dir}/wrong-evidence.err"; then
		fail "wrong status evidence fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-evidence.err" "fork\\.prusaslicer\\.gcode-output"
}

test_duplicate_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-status-row"
	local status_file="${dir}/packages/parity/status.tsv"
	write_valid_fixture_copy "${dir}"
	local status_row
	status_row="$(awk -F '\t' '$1 == "fork.prusaslicer.gcode-output" { print; exit }' "${status_file}")"
	printf '%s\n' "${status_row}" >>"${status_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-status.out" "${tmp_dir}/duplicate-status.err"; then
		fail "duplicate status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-status.err" "duplicate rows: 2"
}

test_missing_parity_target_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-parity-target"
	local build_file="${dir}/packages/parity/BUILD.bazel"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${build_file}" "prusaslicer_gcode_output_parity"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-parity.out" "${tmp_dir}/missing-parity.err"; then
		fail "missing parity target fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-parity.err" "prusaslicer_gcode_output_parity"
}

test_phase47_rust_summary_boundary_is_allowed() {
	# Arrange
	local dir="${tmp_dir}/phase47-rust-summary-boundary"
	write_valid_fixture_copy "${dir}"
	mkdir -p "${dir}/packages/slic3r-rust/crates/slic3r_flavors/src"
	printf '%s\n' "const SURFACE: &str = \"slic3r_flavors::prusa_gcode_output\";" \
		"pub mod prusa_gcode_output;" \
		>"${dir}/packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs"
	printf '%s\n' "pub fn parse_prusa_gcode_output_summary(input: &str) -> usize { input.len() }" \
		>"${dir}/packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/phase47-rust-boundary.out" "${tmp_dir}/phase47-rust-boundary.err"; then
		sed -n '1,200p' "${tmp_dir}/phase47-rust-boundary.err" >&2
		fail "Phase 47 Rust summary boundary fixture failed"
	fi

	# Assert
	assert_file_equals "${tmp_dir}/phase47-rust-boundary.out" "ok: Prusa G-code output fixture verification passed"
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
test_structural_value_drift_fails
test_missing_structural_row_fails
test_duplicate_structural_row_fails
test_unsupported_structural_field_fails
test_structural_overclaim_fails
test_structural_provenance_mismatch_fails
test_missing_semantic_row_fails
test_duplicate_semantic_row_fails
test_out_of_order_semantic_row_fails
test_unsupported_semantic_field_fails
test_semantic_overclaim_fails
test_semantic_provenance_mismatch_fails
test_semantic_fixture_identity_mismatch_fails
test_missing_semantic_readme_reference_fails
test_missing_package_semantic_boundary_fails
test_missing_update_route_fails
test_missing_privacy_exclusions_fails
test_readme_overclaim_fails
test_missing_status_row_fails
test_wrong_status_evidence_fails
test_duplicate_status_row_fails
test_missing_parity_target_fails
test_phase47_rust_summary_boundary_is_allowed
test_forbidden_verifier_behavior_fails

printf 'ok: verify_prusa_gcode_output_fixture_test\n'
