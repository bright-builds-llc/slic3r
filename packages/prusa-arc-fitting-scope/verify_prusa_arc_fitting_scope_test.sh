#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh"
else
	verifier="${script_dir}/verify_prusa_arc_fitting_scope.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-arc-fitting-scope-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

readonly ARC_FITTING_INVENTORY_ROW=$'prusaslicer.arc-fitting\tprusaslicer\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tsrc/libslic3r/Geometry/ArcWelder.cpp\tarc-fitting\tarc-fitting\tshared-downstream\tmedium\tgenerated-outputs\tfuture-candidate\tnone\tArc fitting planning row; future parity requires G-code output comparison evidence.'
readonly GCODE_OUTPUT_STATUS_ROW=$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tShared fixture comparison proves the narrow semantic Prusa G-code evidence slice backed by the Phase 53 closed semantic scope contract, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion behavior, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'
readonly ARC_FITTING_STATUS_ROW=$'fork.prusaslicer.arc-fitting\tverified\t//packages/parity:prusaslicer_arc_fitting_parity\tShared fixture comparison proves the narrow Prusa arc-fitting checked-in summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command only; byte-for-byte G-code parity, full generated-output parity, broad generated-output verification, full ArcWelder algorithm equivalence, tolerance or geometry parity, printability, firmware behavior, printer-runtime behavior, GUI behavior, support generation, wall seam behavior, STEP import, full 3MF import/export, binary G-code, thumbnails, post-processing, host upload, network/device behavior, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, sync automation, and non-Prusa fork behavior remain deferred'

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

remove_line_containing() {
	local file="$1"
	local pattern="$2"
	local tmp_file
	tmp_file="${file}.tmp"
	grep -Fv -- "${pattern}" "${file}" >"${tmp_file}"
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

replace_text() {
	local file="$1"
	local pattern="$2"
	local replacement="$3"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -v pattern="${pattern}" -v replacement="${replacement}" '
		{ gsub(pattern, replacement); print }
	' "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

insert_line_before() {
	local file="$1"
	local pattern="$2"
	local inserted_line="$3"
	local tmp_file
	tmp_file="${file}.tmp"
	awk -v pattern="${pattern}" -v inserted_line="${inserted_line}" '
		!inserted && index($0, pattern) { print inserted_line; inserted = 1 }
		{ print }
		END { exit inserted ? 0 : 1 }
	' "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

write_valid_fixture() {
	local dir="$1"
	mkdir -p \
		"${dir}/packages/fork-inventories" \
		"${dir}/packages/parity"

	cat >"${dir}/README.md" <<'EOF'
# Prusa Arc-Fitting Scope Contract

`packages/prusa-arc-fitting-scope` owns the Phase 57 reviewed scope contract for `prusaslicer.arc-fitting`.
EOF

	cat >"${dir}/arc-fitting-scope.md" <<'EOF'
# Prusa Arc-Fitting Scope Contract

This Phase 57 scope record prepares the narrow `prusaslicer.arc-fitting`
evidence contract. Completing this record does not prove executable
arc-fitting parity, generated-output parity, printability, printer-runtime
behavior, GUI behavior, support generation, wall seam behavior, release
behavior, upstream imports, sync automation, or non-Prusa fork behavior.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.arc-fitting` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Fixture namespace decision | Phase 58 planned namespace `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`; no fixture bytes are checked in during Phase 57. |
| Expected-summary contract | Phase 58 planned `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` with the approved Phase 57 arc evidence fields; no expected arc summary artifact is checked in during Phase 57. |
| Candidate Rust boundary | Phase 59 planned `slic3r_flavors::prusa_arc_fitting` pure data-in/data-out boundary over caller-supplied checked-in arc summaries; no Rust parser implementation is created in Phase 57. |
| Public evidence command | Phase 60 published `bazel run //packages/parity:prusaslicer_arc_fitting_parity`; Phase 57 only planned the target and did not create it. |
| Published narrow status row | Phase 60 published `fork.prusaslicer.arc-fitting` after executable evidence passed; Phase 57 only planned the row and did not publish it. |
| Docs touched | `packages/prusa-arc-fitting-scope/README.md`; `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` |
| Security note | No secrets, credentials, private data, runtime file discovery, Git, network, device, host upload, release, sync, upstream import, or printer-runtime behavior is introduced by the Phase 57 arc-fitting scope contract. |
| Deferred scope | Byte-for-byte G-code parity; broad generated-output verification; full ArcWelder algorithm equivalence; tolerance or geometry parity; printability; printer-runtime behavior; support generation; wall seam behavior; GUI behavior; release behavior; network/device behavior; non-Prusa fork behavior; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-23 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Feature surface | `arc-fitting` |
| Feature category | `arc-fitting` |
| Ownership | `shared-downstream` |
| Complexity | `medium` |
| Parity dependency | `generated-outputs` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Arc fitting planning row; future parity requires G-code output comparison evidence. |

## Approved Arc Evidence Fields

This table is a closed contract for the Phase 58 checked-in arc summary and
the Phase 59 typed Rust boundary. Unknown fields must fail closed.

| Arc Field | Category | Evidence Boundary |
| --- | --- | --- |
| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |
| inventory_source_paths | source identity | Inventory source paths only: `src/libslic3r/Geometry/ArcWelder.cpp`. |
| source_anchor | source identity | Reviewed source anchor text or line reference only; no upstream import, Git access, or runtime source discovery. |
| fixture_id | fixture identity | Fixture identity string only for the Phase 58 checked-in fixture. |
| fixture_path | fixture identity | Checked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` only. |
| arc_command_counts | command observations | Counts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity. |
| arc_direction_counts | command observations | Clockwise/counterclockwise direction observations from the checked-in summary only; no algorithm equivalence or tolerance claim. |
| center_offset_observations | center offset observations | Observed I/J center-offset facts from the checked-in summary only; no geometry, planner, or printer-runtime behavior claim. |
| coordinate_bounds | coordinate bounds | Bounded coordinate observations only; no toolpath geometry or printability claim. |
| extrusion_observations | extrusion observations | Summary extrusion observations only; no material-use, runtime, or printability claim. |
| feedrate_observations | feedrate observations | Feedrate metadata observations only; no timing, firmware, or printer-runtime behavior claim. |
| evidence_boundary | boundary text | Explicit statement of what the summary proves and what remains deferred; no executable public status claim before Phase 60. |

## Arc-Fitting Traceability

| Required Link | Exact Target |
| --- | --- |
| Inventory row | `prusaslicer.arc-fitting` in `packages/fork-inventories/prusaslicer.tsv` |
| Category-map row | `arc.shared` in `packages/fork-inventories/category-map.tsv` references `prusaslicer.arc-fitting` exactly once |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Planned fixture namespace | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` |
| Planned expected summary | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` |
| Planned Rust boundary | `slic3r_flavors::prusa_arc_fitting` |
| Public evidence command | `bazel run //packages/parity:prusaslicer_arc_fitting_parity` |
| Published narrow status row | Phase 60 published `fork.prusaslicer.arc-fitting` as the narrow v1.15 checked-in arc summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command. |
| Existing G-code status row | `fork.prusaslicer.gcode-output` stays limited to the existing semantic Prusa G-code evidence slice backed by Phase 53 through Phase 56 |
| Broad status row | `generated-outputs` stays `in progress` in `packages/parity/status.tsv` |
| Docs touched | `packages/prusa-arc-fitting-scope/arc-fitting-scope.md`; `packages/prusa-arc-fitting-scope/README.md` |

## Published Status Wording

The Phase 60 published status token is `fork.prusaslicer.arc-fitting`.

Phase 60 published `fork.prusaslicer.arc-fitting` as the narrow v1.15
checked-in arc summary evidence slice backed by the Phase 57 scope contract,
Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60
public parity command.

`generated-outputs` stays `in progress`, and `fork.prusaslicer.gcode-output`
stays limited to the existing semantic Prusa G-code evidence slice. Phase 57
only planned the `fork.prusaslicer.arc-fitting` row and did not publish it.

## Boundary

This scope record is consumed by Phase 58 fixture corpus work, Phase 59 Rust
arc-fitting boundary work, and Phase 60 public executable evidence/status/docs
publication. It still does not prove byte-for-byte G-code parity, broad
generated-output verification, full ArcWelder algorithm equivalence, tolerance
or geometry parity, generated-output status promotion, printability,
printer-runtime behavior, firmware behavior, support generation, wall seam
behavior, GUI behavior, release behavior, network/device behavior, non-Prusa
fork behavior, upstream source imports, or sync automation.
EOF

	cat >"${dir}/packages/fork-inventories/prusaslicer.tsv" <<EOF
# inventory_id	vendor_id	source_ref	source_paths	feature_surface	feature_category	ownership	complexity	parity_dependency	v1_9_decision	caution_flags	future_parity_notes
${ARC_FITTING_INVENTORY_ROW}
EOF

	cat >"${dir}/packages/fork-inventories/category-map.tsv" <<'EOF'
# map_id	feature_category	ownership	v1_9_decision	inventory_ids	notes
arc.shared	arc-fitting	shared-downstream	future-candidate	prusaslicer.arc-fitting;bambustudio.arc-fitting	Arc rows need future generated-output comparison evidence.
EOF

	cat >"${dir}/packages/parity/status.tsv" <<EOF
# surface	status	evidence	notes
generated-outputs	in progress	docs/port/cli-slice.md	Scoped export plus repair/split artifact naming are fixture-verified; geometry and output-content parity are deferred
${GCODE_OUTPUT_STATUS_ROW}
${ARC_FITTING_STATUS_ROW}
EOF
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/README.md" \
		"${dir}/arc-fitting-scope.md" \
		"${dir}/packages/fork-inventories/prusaslicer.tsv" \
		"${dir}/packages/fork-inventories/category-map.tsv" \
		"${dir}/packages/parity/status.tsv" \
		"${dir}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

test_valid_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,200p' "${tmp_dir}/valid.err" >&2
		fail "valid fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" '^ok: Prusa arc-fitting scope verification passed$'
}

test_missing_required_scope_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-required-scope-row"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/arc-fitting-scope.md" "| Reviewer signoff |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-scope-row.out" "${tmp_dir}/missing-scope-row.err"; then
		fail "missing required scope row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-scope-row.err" '^error:'
	assert_contains "${tmp_dir}/missing-scope-row.err" 'Reviewer signoff'
}

test_missing_arc_field_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-arc-field"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/arc-fitting-scope.md" "| arc_command_counts |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-field.out" "${tmp_dir}/missing-field.err"; then
		fail "missing arc field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-field.err" '^error:'
	assert_contains "${tmp_dir}/missing-field.err" 'expected exactly 12 arc evidence field rows'
}

test_unsupported_arc_field_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-arc-field"
	write_valid_fixture "${dir}"
	insert_line_before \
		"${dir}/arc-fitting-scope.md" \
		"| evidence_boundary |" \
		"| unsupported_arc_field | unsupported | Unsupported arc field. |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-field.out" "${tmp_dir}/unsupported-field.err"; then
		fail "unsupported arc field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/unsupported-field.err" '^error:'
	assert_contains "${tmp_dir}/unsupported-field.err" 'expected exactly 12 arc evidence field rows'
}

test_duplicate_arc_field_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-arc-field"
	write_valid_fixture "${dir}"
	insert_line_before \
		"${dir}/arc-fitting-scope.md" \
		"| arc_direction_counts |" \
		"| arc_command_counts | command observations | Counts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity. |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-field.out" "${tmp_dir}/duplicate-field.err"; then
		fail "duplicate arc field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-field.err" '^error:'
	assert_contains "${tmp_dir}/duplicate-field.err" 'expected exactly 12 arc evidence field rows'
}

test_inventory_row_drift_fails() {
	# Arrange
	local dir="${tmp_dir}/inventory-row-drift"
	write_valid_fixture "${dir}"
	replace_text "${dir}/packages/fork-inventories/prusaslicer.tsv" "src/libslic3r/Geometry/ArcWelder.cpp" "src/libslic3r/Geometry/WrongArcWelder.cpp"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/inventory-drift.out" "${tmp_dir}/inventory-drift.err"; then
		fail "inventory row drift fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/inventory-drift.err" '^error:'
	assert_contains "${tmp_dir}/inventory-drift.err" 'expected exact row once'
}

test_duplicate_inventory_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-inventory-row"
	write_valid_fixture "${dir}"
	printf '%s\n' "${ARC_FITTING_INVENTORY_ROW}" >>"${dir}/packages/fork-inventories/prusaslicer.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-inventory.out" "${tmp_dir}/duplicate-inventory.err"; then
		fail "duplicate inventory row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-inventory.err" '^error:'
	assert_contains "${tmp_dir}/duplicate-inventory.err" 'expected exact row once'
}

test_missing_arc_category_reference_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-arc-category-reference"
	write_valid_fixture "${dir}"
	replace_text "${dir}/packages/fork-inventories/category-map.tsv" "prusaslicer.arc-fitting;bambustudio.arc-fitting" "bambustudio.arc-fitting"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-category-reference.out" "${tmp_dir}/missing-category-reference.err"; then
		fail "missing arc category reference fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-category-reference.err" '^error:'
	assert_contains "${tmp_dir}/missing-category-reference.err" 'category-map reference'
}

test_generated_outputs_promotion_fails() {
	# Arrange
	local dir="${tmp_dir}/generated-outputs-promotion"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/packages/parity/status.tsv" \
		"generated-outputs" \
		$'generated-outputs\tverified\t//packages/parity:generated_outputs_parity\tOverbroad generated-output status.'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/generated-promotion.out" "${tmp_dir}/generated-promotion.err"; then
		fail "generated-outputs promotion fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/generated-promotion.err" '^error:'
	assert_contains "${tmp_dir}/generated-promotion.err" 'expected generated-outputs to remain in progress'
}

test_duplicate_generated_outputs_status_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-generated-outputs-status"
	write_valid_fixture "${dir}"
	printf '%s\n' $'generated-outputs\tverified\t//packages/parity:generated_outputs_parity\tDuplicate broad status row.' >>"${dir}/packages/parity/status.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-generated-status.out" "${tmp_dir}/duplicate-generated-status.err"; then
		fail "duplicate generated-outputs status fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-generated-status.err" '^error:'
	assert_contains "${tmp_dir}/duplicate-generated-status.err" 'expected 1 row\(s\) with first field generated-outputs'
}

test_gcode_output_status_drift_fails() {
	# Arrange
	local dir="${tmp_dir}/gcode-output-status-drift"
	write_valid_fixture "${dir}"
	replace_text \
		"${dir}/packages/parity/status.tsv" \
		"narrow semantic Prusa G-code evidence slice" \
		"narrow semantic and arc-fitting Prusa G-code evidence slice"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/gcode-status-drift.out" "${tmp_dir}/gcode-status-drift.err"; then
		fail "G-code output status drift fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/gcode-status-drift.err" '^error:'
	assert_contains "${tmp_dir}/gcode-status-drift.err" 'fork\.prusaslicer\.gcode-output'
}

test_missing_arc_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-arc-status"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/packages/parity/status.tsv" "fork.prusaslicer.arc-fitting"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-arc-status.out" "${tmp_dir}/missing-arc-status.err"; then
		fail "missing fork.prusaslicer.arc-fitting status row passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-arc-status.err" '^error:'
	assert_contains "${tmp_dir}/missing-arc-status.err" 'fork\.prusaslicer\.arc-fitting'
}

test_duplicate_arc_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-arc-status"
	write_valid_fixture "${dir}"
	printf '%s\n' "${ARC_FITTING_STATUS_ROW}" >>"${dir}/packages/parity/status.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-arc-status.out" "${tmp_dir}/duplicate-arc-status.err"; then
		fail "duplicate fork.prusaslicer.arc-fitting status row passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-arc-status.err" '^error:'
	assert_contains "${tmp_dir}/duplicate-arc-status.err" 'fork\.prusaslicer\.arc-fitting'
}

test_wrong_arc_status_target_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-arc-status-target"
	write_valid_fixture "${dir}"
	replace_text \
		"${dir}/packages/parity/status.tsv" \
		"//packages/parity:prusaslicer_arc_fitting_parity" \
		"//packages/parity:prusaslicer_gcode_output_parity"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-arc-status-target.out" "${tmp_dir}/wrong-arc-status-target.err"; then
		fail "wrong fork.prusaslicer.arc-fitting evidence target passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-arc-status-target.err" '^error:'
	assert_contains "${tmp_dir}/wrong-arc-status-target.err" '//packages/parity:prusaslicer_arc_fitting_parity'
}

test_missing_deferred_scope_term_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-deferred-scope-term"
	write_valid_fixture "${dir}"
	replace_text "${dir}/arc-fitting-scope.md" "sync automation" "sync process"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-deferred-term.out" "${tmp_dir}/missing-deferred-term.err"; then
		fail "missing deferred scope term fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-deferred-term.err" '^error:'
	assert_contains "${tmp_dir}/missing-deferred-term.err" 'sync automation'
}

test_runtime_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/runtime-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 57 claims printer-runtime behavior.\n' >>"${dir}/README.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/runtime-overclaim.out" "${tmp_dir}/runtime-overclaim.err"; then
		fail "runtime overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/runtime-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/runtime-overclaim.err" 'forbidden Prusa arc-fitting scope claim'
}

test_printability_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/printability-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 57 confirms printability.\n' >>"${dir}/README.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/printability-overclaim.out" "${tmp_dir}/printability-overclaim.err"; then
		fail "printability overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/printability-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/printability-overclaim.err" 'forbidden Prusa arc-fitting scope claim'
}

test_algorithm_equivalence_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/algorithm-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 57 verifies full ArcWelder algorithm equivalence.\n' >>"${dir}/README.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/algorithm-overclaim.out" "${tmp_dir}/algorithm-overclaim.err"; then
		fail "algorithm equivalence overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/algorithm-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/algorithm-overclaim.err" 'full ArcWelder algorithm equivalence'
}

test_valid_fixture_passes
test_missing_required_scope_row_fails
test_missing_arc_field_fails
test_unsupported_arc_field_fails
test_duplicate_arc_field_fails
test_inventory_row_drift_fails
test_duplicate_inventory_row_fails
test_missing_arc_category_reference_fails
test_generated_outputs_promotion_fails
test_duplicate_generated_outputs_status_fails
test_gcode_output_status_drift_fails
test_missing_arc_status_row_fails
test_duplicate_arc_status_row_fails
test_wrong_arc_status_target_fails
test_missing_deferred_scope_term_fails
test_runtime_overclaim_fails
test_printability_overclaim_fails
test_algorithm_equivalence_overclaim_fails

printf 'ok: verify_prusa_arc_fitting_scope_test\n'
