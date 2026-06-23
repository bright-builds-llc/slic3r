#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

verifier="${workspace_root}/packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh"
source_fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"
source_status_file="${workspace_root}/packages/parity/status.tsv"
source_package_readme="${workspace_root}/packages/parity-fixtures/README.md"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-arc-fitting-fixture-test.XXXXXX")"
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

move_arc_row_before() {
	local file="$1"
	local moved_field="$2"
	local before_field="$3"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -F '\t' -v moved_field="${moved_field}" -v before_field="${before_field}" '
		NR == 1 { header = $0; next }
		$3 == moved_field { moved_row = $0; next }
		$3 == before_field { before_row = $0; before_seen = 1; next }
		!before_seen { prefix = prefix $0 "\n"; next }
		{ suffix = suffix $0 "\n" }
		END {
			print header
			printf "%s", prefix
			if (moved_row != "") {
				print moved_row
			}
			if (before_row != "") {
				print before_row
			}
			printf "%s", suffix
		}
	' "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

write_valid_fixture_copy() {
	local dir="$1"
	local fixture_dir="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"

	mkdir -p \
		"${fixture_dir}" \
		"${dir}/packages/parity"
	cp "${source_fixture_dir}/.gitattributes" "${fixture_dir}/.gitattributes"
	cp "${source_fixture_dir}/README.md" "${fixture_dir}/README.md"
	cp "${source_fixture_dir}/arc-fitting-observations.gcode" "${fixture_dir}/arc-fitting-observations.gcode"
	cp "${source_fixture_dir}/expected-arc-summary.tsv" "${fixture_dir}/expected-arc-summary.tsv"
	cp "${source_fixture_dir}/fixture-provenance.tsv" "${fixture_dir}/fixture-provenance.tsv"
	cp "${source_status_file}" "${dir}/packages/parity/status.tsv"
	cp "${source_package_readme}" "${dir}/packages/parity-fixtures/README.md"
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"
	local maybe_verifier="${4:-${verifier}}"
	local fixture_dir="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"

	set +e
	"${maybe_verifier}" \
		"${fixture_dir}/README.md" \
		"${fixture_dir}/fixture-provenance.tsv" \
		"${fixture_dir}/expected-arc-summary.tsv" \
		"${fixture_dir}/arc-fitting-observations.gcode" \
		"${dir}/packages/parity/status.tsv" \
		"${dir}/packages/parity-fixtures/README.md" \
		"${dir}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

if [[ ! -x "${verifier}" ]]; then
	fail "verifier is not executable: ${verifier}"
fi

test_valid_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture_copy "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,200p' "${tmp_dir}/valid.err" >&2
		fail "valid arc-fitting fixture failed"
	fi

	# Assert
	assert_file_equals "${tmp_dir}/valid.out" "ok: Prusa arc-fitting fixture verification passed"
}

test_missing_arc_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-arc-row"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${summary_file}" $'\tcoordinate_bounds\t'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-arc-row.out" "${tmp_dir}/missing-arc-row.err"; then
		fail "missing arc row fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/missing-arc-row.err" "expected-arc-summary.tsv" "coordinate_bounds"
}

test_duplicate_arc_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-arc-row"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	local duplicate_row
	write_valid_fixture_copy "${dir}"
	duplicate_row="$(awk -F '\t' '$3 == "arc_command_counts" { print; exit }' "${summary_file}")"
	printf '%s\n' "${duplicate_row}" >>"${summary_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-arc-row.out" "${tmp_dir}/duplicate-arc-row.err"; then
		fail "duplicate arc row fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/duplicate-arc-row.err" "expected-arc-summary.tsv" "duplicate arc field" "arc_command_counts"
}

test_out_of_order_arc_row_fails() {
	# Arrange
	local dir="${tmp_dir}/out-of-order-arc-row"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	move_arc_row_before "${summary_file}" "feedrate_observations" "extrusion_observations"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/out-of-order-arc-row.out" "${tmp_dir}/out-of-order-arc-row.err"; then
		fail "out-of-order arc row fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/out-of-order-arc-row.err" "expected-arc-summary.tsv" "arc rows out of order" "feedrate_observations"
}

test_unsupported_arc_field_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-arc-field"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '%s\n' $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tarc_algorithm_equivalence\tunsupported\tverified\tUnsupported arc field must fail closed.' >>"${summary_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-arc-field.out" "${tmp_dir}/unsupported-arc-field.err"; then
		fail "unsupported arc field fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/unsupported-arc-field.err" "expected-arc-summary.tsv" "unsupported arc field" "arc_algorithm_equivalence"
}

test_unsupported_broad_claim_text_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-broad-claim-text"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	printf '\nbyte-for-byte G-code parity verified\n' >>"${summary_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-broad-claim.out" "${tmp_dir}/unsupported-broad-claim.err"; then
		fail "unsupported broad claim fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/unsupported-broad-claim.err" "expected-arc-summary.tsv" "forbidden"
}

test_wrong_source_ref_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-source-ref"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${summary_file}" \
		$'\tsource_ref\tsource identity\t' \
		$'prusaslicer:version_2.9.4@0000000000000000000000000000000000000000\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tsource_ref\tsource identity\tprusaslicer:version_2.9.4@0000000000000000000000000000000000000000\tAccepted PrusaSlicer source identity only.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-source-ref.out" "${tmp_dir}/wrong-source-ref.err"; then
		fail "wrong source ref fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/wrong-source-ref.err" "expected-arc-summary.tsv" "source_ref"
}

test_wrong_fixture_identity_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-fixture-identity"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${summary_file}" \
		$'\tfixture_id\tfixture identity\tarc-fitting-observations.gcode\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfixture_id\tfixture identity\twrong-arc-fixture.gcode\tFixture identity string only for the Phase 58 checked-in fixture.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-fixture-identity.out" "${tmp_dir}/wrong-fixture-identity.err"; then
		fail "wrong fixture identity passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/wrong-fixture-identity.err" "expected-arc-summary.tsv" "fixture_id" "wrong-arc-fixture.gcode"
}

test_wrong_fixture_path_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-fixture-path"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing \
		"${summary_file}" \
		$'\tfixture_path\tfixture identity\t' \
		$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/wrong.gcode\tfixture_path\tfixture identity\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/wrong.gcode\tChecked-in fixture path only.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-fixture-path.out" "${tmp_dir}/wrong-fixture-path.err"; then
		fail "wrong fixture path fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/wrong-fixture-path.err" "expected-arc-summary.tsv" "fixture_path"
}

test_stale_namespace_readme_reference_fails() {
	# Arrange
	local dir="${tmp_dir}/stale-namespace-readme-reference"
	local readme_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "expected-arc-summary.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/stale-namespace-readme.out" "${tmp_dir}/stale-namespace-readme.err"; then
		fail "stale namespace README fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/stale-namespace-readme.err" "fixture README" "expected-arc-summary.tsv"
}

test_stale_package_readme_reference_fails() {
	# Arrange
	local dir="${tmp_dir}/stale-package-readme-reference"
	local readme_file="${dir}/packages/parity-fixtures/README.md"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${readme_file}" "Phase 58 adds the Prusa arc-fitting fixture namespace"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/stale-package-readme.out" "${tmp_dir}/stale-package-readme.err"; then
		fail "stale package README fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/stale-package-readme.err" "packages/parity-fixtures/README.md" "Phase 58 adds the Prusa arc-fitting fixture namespace"
}

test_provenance_mismatch_fails() {
	# Arrange
	local dir="${tmp_dir}/provenance-mismatch"
	local provenance_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing "${provenance_file}" "prusaslicer.arc-fitting" "arc-fitting-observations.gcode\tprusaslicer\twrong.arc-fitting"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/provenance-mismatch.out" "${tmp_dir}/provenance-mismatch.err"; then
		fail "provenance mismatch fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/provenance-mismatch.err" "fixture-provenance.tsv" "provenance"
}

test_fixture_checksum_drift_fails() {
	# Arrange
	local dir="${tmp_dir}/fixture-checksum-drift"
	local gcode_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode"
	write_valid_fixture_copy "${dir}"
	replace_first_line_containing "${gcode_file}" "G2 X10.000" "G2 X11.000 Y0.000 I5.000 J0.000 E0.50000 F1800"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/fixture-checksum-drift.out" "${tmp_dir}/fixture-checksum-drift.err"; then
		fail "fixture checksum drift passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/fixture-checksum-drift.err" "arc-fitting-observations.gcode" "SHA-256"
}

test_forbidden_verifier_behavior_fails() {
	# Arrange
	local dir="${tmp_dir}/forbidden-verifier-behavior"
	local verifier_copy="${dir}/verify_prusa_arc_fitting_fixture.sh"
	write_valid_fixture_copy "${dir}"
	cp "${verifier}" "${verifier_copy}"
	chmod +x "${verifier_copy}"
	printf '\n# curl should never appear in verifier behavior\n' >>"${verifier_copy}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/forbidden-verifier-behavior.out" "${tmp_dir}/forbidden-verifier-behavior.err" "${verifier_copy}"; then
		fail "forbidden verifier behavior passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/forbidden-verifier-behavior.err" "verify_prusa_arc_fitting_fixture.sh" "forbidden verifier behavior term"
}

for test_name in \
	test_valid_fixture_passes \
	test_missing_arc_row_fails \
	test_duplicate_arc_row_fails \
	test_out_of_order_arc_row_fails \
	test_unsupported_arc_field_fails \
	test_unsupported_broad_claim_text_fails \
	test_wrong_source_ref_fails \
	test_wrong_fixture_identity_fails \
	test_wrong_fixture_path_fails \
	test_stale_namespace_readme_reference_fails \
	test_stale_package_readme_reference_fails \
	test_provenance_mismatch_fails \
	test_fixture_checksum_drift_fails \
	test_forbidden_verifier_behavior_fails; do
	"${test_name}"
done

printf 'ok: Prusa arc-fitting fixture mutation tests passed\n'
