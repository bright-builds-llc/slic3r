---
phase: 37-prusa-baseline-and-checklist-gate
review: 37-REVIEW.md
fixed_at: 2026-05-31T23:58:44Z
fix_scope: critical_warning
findings_in_scope: 2
fixed: 2
skipped: 0
iteration: 2
status: all_fixed
---

# Phase 37: Code Review Fix Report

## Summary

Resolved both code-review warnings in the verifier: required drift-record values
and required checklist values are now bound to their Markdown sections and table
rows instead of being accepted as loose substrings.

## Fixes Applied

### WR-01: Verifier Does Not Bind Required Values To Their Table Fields

- Added `require_section_table_row` to `verify_prusa_baseline.sh`.
- Bound accepted baseline values to the `## Accepted Source Baseline` table.
- Bound reviewer-gated values, including reviewer decision and signoff, to the
  `## Reviewer Record` table.
- Expanded verifier tests with regression cases where `version_2.9.5` still
  appears elsewhere but the accepted stable tag row is wrong, and where the
  reviewer decision label remains but the pending decision text is wrong.

### WR-02: Checklist Values Are Not Bound To Checklist Rows

- Bound checklist expectations to the `## Checklist` table.
- Bound source row detail expectations to the `## Source Row Details` table.
- Expanded verifier tests with regression cases where the expected inventory ID
  still appears elsewhere but the `Inventory row ID` row is wrong, and where the
  `Source path` row is wrong.

## Verification

- `bash packages/prusa-baseline/verify_prusa_baseline.sh` passed.
- `bash packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.
- `bazel run //packages/prusa-baseline:verify` passed.
- `bazel test --cache_test_results=no //packages/prusa-baseline:verify_prusa_baseline_test` passed.
- `shellcheck packages/prusa-baseline/verify_prusa_baseline.sh packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.
- `shfmt -d packages/prusa-baseline/verify_prusa_baseline.sh packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.
- `git diff --check -- packages/prusa-baseline/verify_prusa_baseline.sh packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.

## Commits

- `b3f106265` - `fix(37-01): bind Prusa baseline verifier rows`
- `a7a690b43` - `fix(37-01): bind Prusa checklist verifier rows`
