#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh"
else
	verifier="${script_dir}/verify_prusa_project_file_scope.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-project-file-scope-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="$1"
	local pattern="$2"
	if ! grep -Eq "${pattern}" "${file}"; then
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
	planned_command="bazel run //packages/parity:prusaslicer""_project_file_parity"
	mkdir -p "${dir}"

	cat >"${dir}/README.md" <<'EOF'
# Prusa Project-File Scope Gate

`packages/prusa-project-file-scope` owns the Phase 41 reviewed scope gate for
`prusaslicer.project-file`.

Run the package verifier with:

```bash
bazel run //packages/prusa-project-file-scope:verify
```

Phase 41 verification does not prove executable Prusa project-file parity.
Phase 41 verification does not prove full 3MF import/export, full PrusaSlicer runtime support, or GUI project behavior.

This package creates no fixture bytes, expected artifacts, Rust parser, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.
EOF

	cat >"${dir}/project-file-scope.md" <<'EOF'
# Prusa Project-File Scope Gate

This Phase 41 scope record prepares the narrow `prusaslicer.project-file`
evidence contract. Completing this record does not prove executable Prusa
project-file parity.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.project-file` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/Format/3mf.cpp` |
| Companion API evidence | `src/libslic3r/Format/3mf.hpp` |
| Fixture source decision | Phase 42 source-pinned upstream `tests/data/seam_test_object.3mf`; no fixture bytes are checked in during Phase 41. |
| Expected-artifact contract | Phase 42 `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv` with `source_ref`, `fixture_path`, `archive_member`, `project_marker`, `deferred_semantics`, and `notes` columns; no expected artifact is checked in during Phase 41. |
| Candidate Rust boundary | Phase 43 `slic3r_flavors::prusa_project_file` data-in/data-out project summary boundary; no Rust parser is created in Phase 41. |
| Planned evidence command | Phase 44 command text `__PLANNED_COMMAND__`; the target is not created in Phase 41. |
| Planned status token | Phase 44 token `fork.prusaslicer.project-file` after executable evidence passes; no `packages/parity/status.tsv` row is published in Phase 41. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, credential, cloud, or network/device behavior in Phase 41. |
| Deferred scope | Full PrusaSlicer runtime support; GUI project behavior; full 3MF import/export; generated-output parity; STEP import; support generation; arc fitting; wall seam behavior; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-03 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/Format/3mf.cpp` |
| Feature surface | `project-file` |
| Feature category | `project-file` |
| Ownership | `shared-downstream` |
| Complexity | `medium` |
| Parity dependency | `file-formats` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Source-observed project file planning row; future parity requires fixture-backed load/save evidence. |
EOF

	replace_text "${dir}/project-file-scope.md" "__PLANNED_COMMAND__" "${planned_command}"
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/README.md" \
		"${dir}/project-file-scope.md" >"${stdout_file}" 2>"${stderr_file}"
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
	assert_contains "${tmp_dir}/valid.out" '^ok: Prusa project-file scope verification passed$'
}

test_wrong_inventory_row_id_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-inventory-row-id"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/project-file-scope.md" \
		'| Inventory row ID | `prusaslicer.project-file` |' \
		'| Inventory row ID | `wrong.project-file` |'

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
		"${dir}/project-file-scope.md" \
		'| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |' \
		'| Accepted source identity | `prusaslicer:version_2.9.4@wrong` |'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-source.out" "${tmp_dir}/wrong-source.err"; then
		fail "wrong source identity fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-source.err" '^error:'
	assert_contains "${tmp_dir}/wrong-source.err" 'prusaslicer:version_2\.9\.5@9a583bd438b195856f3bcf7ea99b69ba4003a961'
}

test_missing_expected_artifact_contract_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-artifact"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/project-file-scope.md" "| Expected-artifact contract |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-expected.out" "${tmp_dir}/missing-expected.err"; then
		fail "missing expected artifact fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-expected.err" '^error:'
	assert_contains "${tmp_dir}/missing-expected.err" 'Expected-artifact contract'
}

test_missing_planned_command_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-planned-command"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/project-file-scope.md" "| Planned evidence command |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-command.out" "${tmp_dir}/missing-command.err"; then
		fail "missing planned command fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-command.err" '^error:'
	assert_contains "${tmp_dir}/missing-command.err" 'Planned evidence command'
}

test_missing_status_token_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-status-token"
	write_valid_fixture "${dir}"
	replace_first_line_containing \
		"${dir}/project-file-scope.md" \
		'| Planned status token | Phase 44 token `fork.prusaslicer.project-file` after executable evidence passes; no `packages/parity/status.tsv` row is published in Phase 41. |' \
		'| Planned status token | Phase 44 token omitted. |'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-status.out" "${tmp_dir}/missing-status.err"; then
		fail "missing status token fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-status.err" '^error:'
	assert_contains "${tmp_dir}/missing-status.err" 'Planned status token'
}

test_missing_deferred_scope_term_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-deferred-term"
	write_valid_fixture "${dir}"
	replace_text "${dir}/project-file-scope.md" "Bambu Studio; " ""

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-deferred.out" "${tmp_dir}/missing-deferred.err"; then
		fail "missing deferred scope term fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-deferred.err" '^error:'
	assert_contains "${tmp_dir}/missing-deferred.err" 'Bambu Studio'
}

test_missing_readme_no_created_artifacts_sentence_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-readme-no-created"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/README.md" "This package creates no fixture bytes"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-readme.out" "${tmp_dir}/missing-readme.err"; then
		fail "missing README no-created-artifacts sentence fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-readme.err" '^error:'
	assert_contains "${tmp_dir}/missing-readme.err" 'fixture bytes'
}

test_complete_fixture_passes
test_wrong_inventory_row_id_fails
test_wrong_source_identity_fails
test_missing_expected_artifact_contract_fails
test_missing_planned_command_fails
test_missing_status_token_fails
test_missing_deferred_scope_term_fails
test_missing_readme_no_created_artifacts_sentence_fails

printf 'ok: verify_prusa_project_file_scope_test\n'
