---
phase: 38-prusa-fixture-and-status-evidence-surface
review: 38-REVIEW.md
fixed_at: 2026-06-01T01:36:42.574Z
fix_scope: warning
findings_in_scope: 2
fixed: 2
skipped: 0
iteration: 1
status: all_fixed
---

# Phase 38: Code Review Fix Report

## Summary

Resolved both code-review warnings in the Prusa profile-schema fixture verifier.
The verifier now binds provenance metadata to each fixture row, and namespace
checks inspect paths relative to the fixture root so unrelated parent directory
names cannot produce false failures.

## Fixes Applied

### WR-01: Provenance Verification Does Not Bind Metadata To Fixture Rows

- Added row-level `fixture-provenance.tsv` validation for `PrusaResearch.ini`
  and `PrusaResearch.idx`.
- Bound each fixture row to its expected source path, upstream URL, byte count,
  SHA-256, line-ending label, role, Phase 37 checklist source, update route,
  status scope, and exclusions.
- Added `test_swapped_provenance_rows_fail` to prove swapped row metadata is
  rejected even when all expected tokens still appear somewhere in the TSV.

### WR-02: Namespace Check Matches Forbidden Tokens In Parent Directories

- Normalized `forks_root` and checked forbidden namespace tokens only against
  paths relative to that root.
- Limited namespace scanning to directories, which avoids treating fixture files
  as namespace paths.
- Added `test_parent_directory_forbidden_token_passes` to prove a valid fixture
  under a parent path containing `cloud` still passes.

## Verification

- `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture`
  passed.
- `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test`
  passed.
- `shellcheck packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh`
  passed.
- `shfmt -d packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh`
  passed.
- `bazel query //packages/parity:prusaslicer_profile_schema_parity` failed as
  expected.
- `rg -n "fork\\.prusaslicer|prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv`
  returned no matches.
- `git diff --check` passed.

## Commit

This report is committed together with `fix(38-01): bind Prusa fixture verifier rows`.
