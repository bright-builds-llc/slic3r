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

write_valid_fixture() {
	local dir="$1"
	local planned_command
	planned_command="bazel run //packages/parity:prusaslicer""_gcode_output_parity"
	mkdir -p \
		"${dir}/packages/fork-inventories" \
		"${dir}/packages/parity"

	cat >"${dir}/README.md" <<'EOF'
# Prusa G-code Output Scope Gate

`packages/prusa-gcode-output-scope` owns the Phase 45 reviewed scope gate for `prusaslicer.gcode-output`.
Run `bazel run //packages/prusa-gcode-output-scope:verify` to check the reviewed Phase 45 scope gate.
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
	assert_contains "${tmp_dir}/overclaim.err" 'forbidden Phase 45 claim'
}

test_premature_status_row_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-status-row"
	write_valid_fixture "${dir}"
	printf 'fork.prusaslicer.gcode-output\tverified\t//packages/parity:prusaslicer_gcode_output_parity\tpremature\n' \
		>>"${dir}/packages/parity/status.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-status.out" "${tmp_dir}/premature-status.err"; then
		fail "premature status row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-status.err" '^error:'
	assert_contains "${tmp_dir}/premature-status.err" 'fork\.prusaslicer\.gcode-output'
}

test_premature_fixture_namespace_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-fixture-namespace"
	write_valid_fixture "${dir}"
	mkdir -p "${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-fixture.out" "${tmp_dir}/premature-fixture.err"; then
		fail "premature fixture namespace passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-fixture.err" '^error:'
	assert_contains "${tmp_dir}/premature-fixture.err" 'fixture namespace'
}

test_premature_expected_summary_artifact_fails() {
	# Arrange
	local dir="${tmp_dir}/premature-expected-summary"
	write_valid_fixture "${dir}"
	mkdir -p "${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
	: >"${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/premature-expected.out" "${tmp_dir}/premature-expected.err"; then
		fail "premature expected summary artifact passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/premature-expected.err" '^error:'
	assert_contains "${tmp_dir}/premature-expected.err" 'expected summary artifact'
}

test_complete_fixture_passes
test_wrong_inventory_row_id_fails
test_wrong_source_identity_fails
test_missing_expected_summary_contract_fails
test_missing_category_map_row_fails
test_missing_deferred_scope_term_fails
test_missing_reviewer_signoff_fails
test_readme_overclaim_fails
test_premature_status_row_fails
test_premature_fixture_namespace_fails
test_premature_expected_summary_artifact_fails

printf 'ok: verify_prusa_gcode_output_scope_test\n'
