#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	workspace_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"
else
	workspace_root="$(cd "${script_dir}/../.." && pwd)"
fi

comparator="${workspace_root}/packages/parity/compare_prusaslicer_arc_fitting.sh"
summary_binary="${workspace_root}/packages/slic3r-rust/crates/slic3r_flavors/prusa_arc_fitting_summary"
if [[ ! -x "${summary_binary}" ]]; then
	summary_binary="${workspace_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_arc_fitting_summary"
fi
fixture_dir="${workspace_root}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"
expected_arc_summary="${fixture_dir}/expected-arc-summary.tsv"
fixture_provenance="${fixture_dir}/fixture-provenance.tsv"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/compare-prusaslicer-arc-fitting-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="${1}"
	local pattern="${2}"

	if ! grep -Fq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,160p' "${file}" >&2
		exit 1
	fi
}

assert_executable() {
	local label="${1}"
	local path="${2}"

	if [[ ! -x "${path}" ]]; then
		fail "${label} is not executable: ${path}"
	fi
}

assert_file() {
	local label="${1}"
	local path="${2}"

	if [[ ! -f "${path}" ]]; then
		fail "${label} is missing: ${path}"
	fi
}

mutate_arc_value() {
	local path="${1}"
	local arc_field="${2}"
	local replacement="${3}"
	local tmp_file="${path}.tmp"

	awk -v arc_field="${arc_field}" -v replacement="${replacement}" '
		BEGIN {
			FS = OFS = "\t"
		}
		$3 == arc_field {
			$5 = replacement
			changed++
		}
		{
			print
		}
		END {
			if (changed != 1) {
				exit 1
			}
		}
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}

mutate_arc_boundary() {
	local path="${1}"
	local arc_field="${2}"
	local replacement="${3}"
	local tmp_file="${path}.tmp"

	awk -v arc_field="${arc_field}" -v replacement="${replacement}" '
		BEGIN {
			FS = OFS = "\t"
		}
		$3 == arc_field {
			$6 = replacement
			changed++
		}
		{
			print
		}
		END {
			if (changed != 1) {
				exit 1
			}
		}
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}

run_comparator() {
	local expected_artifact="${1}"
	local stdout_file="${2}"
	local stderr_file="${3}"

	set +e
	"${comparator}" \
		"${summary_binary}" \
		"${expected_arc_summary}" \
		"${expected_artifact}" \
		"${fixture_provenance}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

assert_arc_value_mutation_fails() {
	local arc_field="${1}"
	local replacement="${2}"
	local case_dir="${tmp_dir}/${arc_field}"
	local mutated_arc_expected="${case_dir}/expected-arc-summary.tsv"
	local stdout_file="${case_dir}/mutated-arc.out"
	local stderr_file="${case_dir}/mutated-arc.err"

	mkdir -p "${case_dir}"
	cp "${expected_arc_summary}" "${mutated_arc_expected}"
	mutate_arc_value "${mutated_arc_expected}" "${arc_field}" "${replacement}"

	if run_comparator "${mutated_arc_expected}" "${stdout_file}" "${stderr_file}"; then
		fail "mutated expected-arc-summary.tsv passed for ${arc_field}"
	fi

	assert_contains "${stderr_file}" "expected-arc-summary.tsv"
	assert_contains "${stderr_file}" "${arc_field}"
}

assert_arc_boundary_mutation_fails() {
	local arc_field="${1}"
	local replacement="${2}"
	local required_diagnostic="${3}"
	local case_dir="${tmp_dir}/${arc_field}-boundary"
	local mutated_arc_expected="${case_dir}/expected-arc-summary.tsv"
	local stdout_file="${case_dir}/mutated-arc.out"
	local stderr_file="${case_dir}/mutated-arc.err"

	mkdir -p "${case_dir}"
	cp "${expected_arc_summary}" "${mutated_arc_expected}"
	mutate_arc_boundary "${mutated_arc_expected}" "${arc_field}" "${replacement}"

	if run_comparator "${mutated_arc_expected}" "${stdout_file}" "${stderr_file}"; then
		fail "mutated expected-arc-summary.tsv boundary passed for ${arc_field}"
	fi

	assert_contains "${stderr_file}" "expected-arc-summary.tsv"
	assert_contains "${stderr_file}" "${arc_field}"
	assert_contains "${stderr_file}" "${required_diagnostic}"
}

assert_executable "comparator" "${comparator}"
assert_executable "summary binary" "${summary_binary}"
assert_file "expected-arc-summary.tsv" "${expected_arc_summary}"
assert_file "fixture-provenance.tsv" "${fixture_provenance}"

assert_arc_value_mutation_fails \
	"arc_command_counts" \
	"G2:2;G3:1;total_arc_commands:3"
assert_arc_value_mutation_fails \
	"arc_direction_counts" \
	"clockwise_g2:2;counterclockwise_g3:0"
assert_arc_value_mutation_fails \
	"center_offset_observations" \
	"i_values:5.000,0.000;j_values:0.000,0.000"
assert_arc_value_mutation_fails \
	"coordinate_bounds" \
	"x_min:0.000;x_max:12.000;y_min:0.000;y_max:0.000"
assert_arc_value_mutation_fails \
	"extrusion_observations" \
	"e_values:0.50000,1.50000;e_axis_observed:true"
assert_arc_value_mutation_fails \
	"feedrate_observations" \
	"F1800:1;F1200:1"
assert_arc_value_mutation_fails \
	"source_ref" \
	"prusaslicer:version_2.9.5@0000000000000000000000000000000000000000"
assert_arc_value_mutation_fails \
	"fixture_id" \
	"arc-fitting-unreviewed.gcode"
assert_arc_value_mutation_fails \
	"fixture_path" \
	"packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/unreviewed.gcode"
assert_arc_boundary_mutation_fails \
	"arc_command_counts" \
	"full generated-output parity verified" \
	"full generated-output parity"

assert_contains "${expected_arc_summary}" $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tarc_command_counts\tcommand observations\tG2:1;G3:1;total_arc_commands:2\tCounts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity.'
assert_contains "${expected_arc_summary}" $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfixture_id\tfixture identity\tarc-fitting-observations.gcode\tFixture identity string only for the Phase 58 checked-in fixture.'
assert_contains "${expected_arc_summary}" $'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tfixture_path\tfixture identity\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode\tChecked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` only.'

printf 'ok: prusaslicer_arc_fitting_parity_failure_test\n'
