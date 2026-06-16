#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh"
else
	verifier="${script_dir}/verify_prusa_gcode_output_scope.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-gcode-output-scope-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

readonly GCODE_OUTPUT_STATUS_ROW=$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tShared fixture comparison proves the narrow summary-only Prusa G-code evidence slice backed by the Phase 46 fixture and Phase 47 Rust summary boundary only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'

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
	local planned_command
	planned_command="bazel run //packages/parity:prusaslicer""_gcode_output_parity"
	mkdir -p \
		"${dir}/packages/fork-inventories" \
		"${dir}/packages/parity"

	cat >"${dir}/README.md" <<'EOF'
# Prusa G-code Output Scope Gate

`packages/prusa-gcode-output-scope` owns the Phase 45 reviewed scope gate and the Phase 49 structural evidence scope contract for `prusaslicer.gcode-output`.
Run `bazel run //packages/prusa-gcode-output-scope:verify` to check the reviewed Phase 45 scope gate.
Phase 49 structural verification allows only command counts, section counts, ordered markers, movement/extrusion indicators, temperature/tool-change markers, source identity, and fixture identity for the narrow Prusa G-code evidence chain.
Phase 49 structural verification keeps broad generated-outputs in progress and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation.
Phase 45 verification does not prove executable Prusa G-code output parity.
Phase 45 verification does not prove byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, or sync automation.
This package creates no fixture bytes, expected-gcode-summary.tsv, Rust G-code summary implementation, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, printer-runtime behavior, host upload, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.
EOF

	cat >"${dir}/gcode-output-scope.md" <<'EOF'
# Prusa G-code Output Scope Gate

This Phase 45 scope record prepares the narrow summary-only
`prusaslicer.gcode-output` evidence contract. Completing this record does not
prove executable Prusa G-code output parity.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.gcode-output` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/GCode.cpp` |
| Companion API evidence | `src/libslic3r/GCode.hpp` |
| Fixture source decision | Phase 46 source-pinned ASCII `.gcode` fixture under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`; no fixture bytes are checked in during Phase 45. |
| Expected-summary contract | Phase 46 `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` with `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`, `marker_key`, `marker_value`, and `notes` columns; no expected summary artifact is checked in during Phase 45. |
| Candidate Rust boundary | Phase 47 `slic3r_flavors::prusa_gcode_output` pure data-in/data-out G-code summary boundary; no Rust summary implementation is created in Phase 45. |
| Planned evidence command | Phase 48 command text `__PLANNED_COMMAND__`; the target is not created in Phase 45. |
| Planned status token | Phase 48 token `fork.prusaslicer.gcode-output` after executable evidence passes; no `packages/parity/status.tsv` row is published in Phase 45. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, host upload, credential, cloud, network/device, release, or printer-runtime behavior in Phase 45. |
| Deferred scope | Byte-for-byte G-code parity; full generated-output parity; toolpath geometry; extrusion; timing; support generation; wall seam behavior; arc fitting; STEP import; full 3MF import/export; printer-runtime behavior; firmware or printability behavior; GUI export or viewer behavior; binary G-code; thumbnails; post-processing; host upload; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-06 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/GCode.cpp` |
| Companion API evidence | `src/libslic3r/GCode.hpp` |
| Feature surface | `gcode-output` |
| Feature category | `gcode-output` |
| Ownership | `shared-downstream` |
| Complexity | `high` |
| Parity dependency | `generated-outputs` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Source-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed. |

## v1.13 Structural Evidence Scope

This section is an additive structural contract for the existing narrow `prusaslicer.gcode-output` evidence chain. It allows only the fields listed below for Phase 50 structural fixture expectations and Phase 51 typed parsing. It does not promote broad `generated-outputs` status and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, non-Prusa fork behavior, upstream source imports, or sync automation.

| Structural Field | Category | Evidence Boundary |
| --- | --- | --- |
| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |
| inventory_source_paths | source identity | Inventory source paths only: `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`. |
| fixture_source_literal | source identity | Source literal only: `tests/fff_print/test_gcodewriter.cpp#L20-L35`. |
| fixture_id | fixture identity | Fixture identity only: `gcodewriter-set-speed.gcode`. |
| fixture_path | fixture identity | Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`. |
| command_count_total | command counts | Count of G-code command rows in the selected fixture only; no generated-output behavior claimed. |
| command_count_g1 | command counts | Count of `G1` command rows in the selected fixture only; no toolpath geometry claimed. |
| section_count_total | section counts | Count of structural sections in the selected summary only; no GUI, print, or runtime section behavior claimed. |
| ordered_marker_1 | ordered markers | First ordered marker value from the selected fixture summary only. |
| ordered_marker_2 | ordered markers | Second ordered marker value from the selected fixture summary only. |
| ordered_marker_3 | ordered markers | Third ordered marker value from the selected fixture summary only. |
| ordered_marker_4 | ordered markers | Fourth ordered marker value from the selected fixture summary only. |
| movement_axis_present | movement/extrusion indicators | Boolean structural indicator for movement-axis text presence only; no toolpath geometry, travel, or printability claim. |
| extrusion_axis_present | movement/extrusion indicators | Boolean structural indicator for extrusion-axis text presence only; no extrusion amount, material, or printability claim. |
| temperature_marker_count | temperature/tool-change markers | Count of temperature marker commands in the selected fixture only; no printer-runtime behavior claimed. |
| tool_change_marker_count | temperature/tool-change markers | Count of tool-change marker commands in the selected fixture only; no multi-tool runtime behavior claimed. |

## v1.13 Structural Traceability

| Required Link | Exact Target |
| --- | --- |
| Inventory row | `prusaslicer.gcode-output` in `packages/fork-inventories/prusaslicer.tsv` |
| Category-map row | `gcode.shared` in `packages/fork-inventories/category-map.tsv` references `prusaslicer.gcode-output` exactly once |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Fixture namespace | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` |
| Current expected summary | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` |
| Fixture provenance | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv` |
| Published narrow status row | `fork.prusaslicer.gcode-output` stays verified only for the narrow summary-only Prusa G-code evidence slice in `packages/parity/status.tsv` |
| Broad status row | `generated-outputs` stays `in progress` in `packages/parity/status.tsv` |
| Structural reviewer signoff | Peter Ryszkiewicz, 2026-06-16 UTC |
EOF

	replace_text "${dir}/gcode-output-scope.md" "__PLANNED_COMMAND__" "${planned_command}"

	cat >"${dir}/packages/fork-inventories/prusaslicer.tsv" <<'EOF'
# inventory_id	vendor_id	source_ref	source_paths	feature_surface	feature_category	ownership	complexity	parity_dependency	v1_9_decision	caution_flags	future_parity_notes
prusaslicer.gcode-output	prusaslicer	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp	gcode-output	gcode-output	shared-downstream	high	generated-outputs	future-candidate	none	Source-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed.
EOF

	cat >"${dir}/packages/fork-inventories/category-map.tsv" <<'EOF'
# map_id	feature_category	ownership	v1_9_decision	inventory_ids	notes
gcode.shared	gcode-output	shared-downstream	future-candidate	prusaslicer.gcode-output	Prusa G-code output row needs reviewed source-pinned summary evidence before generated-output behavior is claimed.
EOF

	cat >"${dir}/packages/parity/status.tsv" <<'EOF'
# surface	status	evidence	notes
generated-outputs	in progress	docs/port/cli-slice.md	Scoped export plus repair/split artifact naming are fixture-verified; geometry and output-content parity are deferred
EOF
	printf '%s\n' "${GCODE_OUTPUT_STATUS_ROW}" >>"${dir}/packages/parity/status.tsv"

	cat >"${dir}/packages/parity/BUILD.bazel" <<'EOF'
package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "prusaslicer_gcode_output_parity",
    srcs = ["compare_prusaslicer_gcode_output.sh"],
)
EOF
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/README.md" \
		"${dir}/gcode-output-scope.md" \
		"${dir}/packages/fork-inventories/prusaslicer.tsv" \
		"${dir}/packages/fork-inventories/category-map.tsv" \
		"${dir}/packages/parity/status.tsv" \
		"${dir}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

test_complete_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,200p' "${tmp_dir}/valid.err" >&2
		fail "valid fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" '^ok: Prusa G-code output scope verification passed$'
}

test_wrong_inventory_row_id_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-inventory-row-id"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/gcode-output-scope.md" \
		"| Inventory row ID | \`prusaslicer.gcode-output\` |" \
		"| Inventory row ID | \`wrong.gcode-output\` |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-inventory.out" "${tmp_dir}/wrong-inventory.err"; then
		fail "wrong inventory row ID fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-inventory.err" '^error:'
	assert_contains "${tmp_dir}/wrong-inventory.err" 'Inventory row ID'
}

test_wrong_source_identity_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-source-identity"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/gcode-output-scope.md" \
		"| Accepted source identity | \`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\` |" \
		"| Accepted source identity | \`prusaslicer:version_2.9.4@wrong\` |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-source.out" "${tmp_dir}/wrong-source.err"; then
		fail "wrong source identity fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-source.err" '^error:'
	assert_contains "${tmp_dir}/wrong-source.err" 'prusaslicer:version_2\.9\.5@9a583bd438b195856f3bcf7ea99b69ba4003a961'
}

test_missing_expected_summary_contract_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-summary"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| Expected-summary contract |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-expected.out" "${tmp_dir}/missing-expected.err"; then
		fail "missing expected summary contract fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-expected.err" '^error:'
	assert_contains "${tmp_dir}/missing-expected.err" 'Expected-summary contract'
}

test_missing_category_map_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-category-map-row"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/packages/fork-inventories/category-map.tsv" "gcode.shared"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-category.out" "${tmp_dir}/missing-category.err"; then
		fail "missing category-map row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-category.err" '^error:'
	assert_contains "${tmp_dir}/missing-category.err" 'category-map'
}

test_missing_deferred_scope_term_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-deferred-term"
	write_valid_fixture "${dir}"
	replace_text "${dir}/gcode-output-scope.md" "arc fitting; " ""

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-deferred.out" "${tmp_dir}/missing-deferred.err"; then
		fail "missing deferred scope term fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-deferred.err" '^error:'
	assert_contains "${tmp_dir}/missing-deferred.err" 'arc fitting'
}

test_missing_reviewer_signoff_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-reviewer-signoff"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| Reviewer signoff |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-signoff.out" "${tmp_dir}/missing-signoff.err"; then
		fail "missing reviewer signoff fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-signoff.err" '^error:'
	assert_contains "${tmp_dir}/missing-signoff.err" 'Reviewer signoff'
}

test_readme_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/readme-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 45 verifies Prusa G-code output parity.\n' >>"${dir}/README.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/overclaim.out" "${tmp_dir}/overclaim.err"; then
		fail "README overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/overclaim.err" '^error:'
	assert_contains "${tmp_dir}/overclaim.err" 'forbidden Prusa G-code scope claim'
}

test_missing_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-status-row"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/packages/parity/status.tsv" "fork.prusaslicer.gcode-output"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-status.out" "${tmp_dir}/missing-status.err"; then
		fail "missing status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-status.err" '^error:'
	assert_contains "${tmp_dir}/missing-status.err" 'fork\.prusaslicer\.gcode-output'
}

test_phase46_fixture_namespace_is_allowed() {
	# Arrange
	local dir="${tmp_dir}/phase46-fixture-namespace"
	write_valid_fixture "${dir}"
	mkdir -p "${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/phase46-fixture.out" "${tmp_dir}/phase46-fixture.err"; then
		sed -n '1,200p' "${tmp_dir}/phase46-fixture.err" >&2
		fail "Phase 46 fixture namespace failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/phase46-fixture.out" '^ok: Prusa G-code output scope verification passed$'
}

test_phase46_expected_summary_artifact_is_allowed() {
	# Arrange
	local dir="${tmp_dir}/phase46-expected-summary"
	write_valid_fixture "${dir}"
	mkdir -p "${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
	: >"${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/phase46-expected.out" "${tmp_dir}/phase46-expected.err"; then
		sed -n '1,200p' "${tmp_dir}/phase46-expected.err" >&2
		fail "Phase 46 expected summary artifact failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/phase46-expected.out" '^ok: Prusa G-code output scope verification passed$'
}

test_wrong_status_evidence_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-status-evidence"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/packages/parity/status.tsv" \
		"fork.prusaslicer.gcode-output" \
		$'fork.prusaslicer.gcode-output\tverified\t//packages/parity:wrong_gcode_output_parity\tShared fixture comparison proves the narrow summary-only Prusa G-code evidence slice backed by the Phase 46 fixture and Phase 47 Rust summary boundary only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-evidence.out" "${tmp_dir}/wrong-evidence.err"; then
		fail "wrong status evidence fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-evidence.err" '^error:'
	assert_contains "${tmp_dir}/wrong-evidence.err" 'fork\.prusaslicer\.gcode-output'
}

test_duplicate_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-status-row"
	local status_file="${dir}/packages/parity/status.tsv"
	write_valid_fixture "${dir}"
	local status_row
	status_row="$(awk -F '\t' '$1 == "fork.prusaslicer.gcode-output" { print; exit }' "${status_file}")"
	printf '%s\n' "${status_row}" >>"${status_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-status.out" "${tmp_dir}/duplicate-status.err"; then
		fail "duplicate status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/duplicate-status.err" '^error:'
	assert_contains "${tmp_dir}/duplicate-status.err" 'duplicate rows: 2'
}

test_promoted_generated_outputs_row_fails() {
	# Arrange
	local dir="${tmp_dir}/promoted-generated-outputs-row"
	local status_file="${dir}/packages/parity/status.tsv"
	write_valid_fixture "${dir}"
	printf '%s\n' $'generated-outputs\tverified\t//packages/parity:unsupported_broad_generated_outputs\tUnsupported broad generated-output promotion that must fail closed.' >>"${status_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/promoted-generated-outputs.out" "${tmp_dir}/promoted-generated-outputs.err"; then
		fail "promoted generated-outputs row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/promoted-generated-outputs.err" '^error:'
	assert_contains "${tmp_dir}/promoted-generated-outputs.err" 'generated-outputs must be exactly one in progress row'
}

test_missing_parity_target_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-parity-target"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/packages/parity/BUILD.bazel" "prusaslicer_gcode_output_parity"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-parity.out" "${tmp_dir}/missing-parity.err"; then
		fail "missing parity target fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-parity.err" '^error:'
	assert_contains "${tmp_dir}/missing-parity.err" 'parity target'
}

test_phase47_rust_summary_boundary_is_allowed() {
	# Arrange
	local dir="${tmp_dir}/phase47-rust-summary-boundary"
	write_valid_fixture "${dir}"
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
	assert_contains "${tmp_dir}/phase47-rust-boundary.out" '^ok: Prusa G-code output scope verification passed$'
}

test_missing_allowed_structural_field_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-allowed-structural-field"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| source_ref |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-allowed-structural.out" "${tmp_dir}/missing-allowed-structural.err"; then
		fail "missing allowed structural field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-allowed-structural.err" '^error:'
	assert_contains "${tmp_dir}/missing-allowed-structural.err" 'source_ref'
}

test_unsupported_structural_field_fails() {
	# Arrange
	local dir="${tmp_dir}/unsupported-structural-field"
	write_valid_fixture "${dir}"
	insert_line_before \
		"${dir}/gcode-output-scope.md" \
		"## v1.13 Structural Traceability" \
		"| geometry_count | unsupported generated-output semantics | Unsupported field that must fail closed. |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unsupported-structural.out" "${tmp_dir}/unsupported-structural.err"; then
		fail "unsupported structural field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/unsupported-structural.err" '^error:'
	assert_contains "${tmp_dir}/unsupported-structural.err" 'expected exactly 16 structural field rows'
}

test_missing_structural_traceability_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-structural-traceability"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| Broad status row |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-structural-traceability.out" "${tmp_dir}/missing-structural-traceability.err"; then
		fail "missing structural traceability fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-structural-traceability.err" '^error:'
	assert_contains "${tmp_dir}/missing-structural-traceability.err" 'Broad status row'
}

test_missing_structural_reviewer_signoff_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-structural-reviewer-signoff"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| Structural reviewer signoff |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-structural-reviewer-signoff.out" "${tmp_dir}/missing-structural-reviewer-signoff.err"; then
		fail "missing structural reviewer signoff fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-structural-reviewer-signoff.err" '^error:'
	assert_contains "${tmp_dir}/missing-structural-reviewer-signoff.err" 'Structural reviewer signoff'
}

test_scope_structural_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/scope-structural-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 49 structural evidence proves toolpath geometry.\n' >>"${dir}/gcode-output-scope.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/scope-structural-overclaim.out" "${tmp_dir}/scope-structural-overclaim.err"; then
		fail "scope structural overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/scope-structural-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/scope-structural-overclaim.err" 'forbidden Prusa G-code scope claim'
}

test_scope_full_generated_output_parity_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/scope-full-generated-output-parity-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 49 structural evidence proves full generated-output parity.\n' >>"${dir}/gcode-output-scope.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/scope-full-generated-output-parity-overclaim.out" "${tmp_dir}/scope-full-generated-output-parity-overclaim.err"; then
		fail "scope full generated-output parity overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/scope-full-generated-output-parity-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/scope-full-generated-output-parity-overclaim.err" 'forbidden Prusa G-code scope claim'
}

test_readme_structural_overclaim_fails() {
	# Arrange
	local dir="${tmp_dir}/readme-structural-overclaim"
	write_valid_fixture "${dir}"
	printf '\nPhase 49 verifies printer-runtime behavior.\n' >>"${dir}/README.md"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/readme-structural-overclaim.out" "${tmp_dir}/readme-structural-overclaim.err"; then
		fail "README structural overclaim fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/readme-structural-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/readme-structural-overclaim.err" 'forbidden Prusa G-code scope claim'
}

test_complete_fixture_passes
test_wrong_inventory_row_id_fails
test_wrong_source_identity_fails
test_missing_expected_summary_contract_fails
test_missing_category_map_row_fails
test_missing_deferred_scope_term_fails
test_missing_reviewer_signoff_fails
test_readme_overclaim_fails
test_missing_status_row_fails
test_phase46_fixture_namespace_is_allowed
test_phase46_expected_summary_artifact_is_allowed
test_wrong_status_evidence_fails
test_duplicate_status_row_fails
test_promoted_generated_outputs_row_fails
test_missing_parity_target_fails
test_phase47_rust_summary_boundary_is_allowed
test_missing_allowed_structural_field_fails
test_unsupported_structural_field_fails
test_missing_structural_traceability_fails
test_missing_structural_reviewer_signoff_fails
test_scope_structural_overclaim_fails
test_scope_full_generated_output_parity_overclaim_fails
test_readme_structural_overclaim_fails

printf 'ok: verify_prusa_gcode_output_scope_test\n'
