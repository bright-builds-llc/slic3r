---
phase: 42-prusa-project-file-fixture-surface
reviewed: 2026-06-03T21:42:13Z
depth: standard
files_reviewed: 15
files_reviewed_list:
  - packages/parity-fixtures/BUILD.bazel
  - packages/parity-fixtures/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/.gitattributes
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf
  - packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
  - packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh
  - packages/parity-fixtures/verify_prusa_project_file_fixture.sh
  - packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
  - docs/port/README.md
  - docs/port/package-map.md
  - docs/port/migration-guidance.md
  - docs/port/parity-matrix.md
findings:
  critical: 0
  warning: 1
  info: 0
  total: 1
status: issues_found
---

# Phase 42: Code Review Report

**Reviewed:** 2026-06-03T21:42:13Z
**Depth:** standard
**Files Reviewed:** 15
**Status:** issues_found

## Summary

Reviewed the Phase 42 Prusa project-file fixture surface, including the Bazel exports, fixture README/provenance/expected TSVs, binary fixture metadata, shell verifier, shell tests, and port documentation boundary updates. Repo-local guidance from `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md` was applied; the requested local `standards/` pages were not present in this checkout.

Verification evidence checked:

- `seam_test_object.3mf` is a zip archive with byte count `2514963` and SHA-256 `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`, matching the provenance.
- `bash -n` passed for the four fixture verifier/test scripts.
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` passed against the checked-in fixture surface.
- `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` passed.
- The Bazel target shape includes the project-file bundle and verifier/test data needed for the Phase 42 guard surface.

One false-positive gap remains in the project-file verifier: it accepts extra TSV rows beyond the allowed fixture-surface contract.

## Warnings

### WR-01: Project-file TSV verifier accepts extra semantic/provenance rows

**File:** `packages/parity-fixtures/verify_prusa_project_file_fixture.sh:145`

**Issue:** `verify_provenance` validates the required provenance row, and `verify_expected_summary` validates the required expected-summary rows at lines 194-218, but neither function rejects additional rows. A negative-control copy with an injected `expected-project-summary.tsv` row claiming unsupported `full-import-export-parity` plus an extra fake provenance row still exited successfully with `ok: Prusa project-file fixture verification passed`. That leaves the Phase 42 guard open to documentation/artifact overclaims while the verifier reports success.

**Fix:** After checking the required rows, assert exact row counts and reject unknown rows. For example:

```bash
require_line_count() {
	local file="$1"
	local label="$2"
	local expected_count="$3"
	local actual_count
	actual_count="$(wc -l <"${file}" | tr -d ' ')"
	if [[ "${actual_count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} rows, got ${actual_count}"
	fi
}

verify_provenance() {
	require_exact_header "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_HEADER}"
	require_line_count "${provenance_file}" "fixture-provenance.tsv" "2"
	# existing exact-row check...
}

verify_expected_summary() {
	require_exact_header "${expected_summary_file}" "expected-project-summary.tsv" "${EXPECTED_SUMMARY_HEADER}"
	require_line_count "${expected_summary_file}" "expected-project-summary.tsv" "8"
	# existing required row checks...
}
```

Add regression tests that append an extra expected-summary row and an extra provenance row, then assert the verifier fails.

---

_Reviewed: 2026-06-03T21:42:13Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
