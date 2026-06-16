---
phase: 49-structural-g-code-scope-contract
fixed_at: 2026-06-16T16:44:58Z
review_path: .planning/phases/49-structural-g-code-scope-contract/49-REVIEW.md
iteration: 1
findings_in_scope: 3
fixed: 3
skipped: 0
status: all_fixed
---

# Phase 49: Code Review Fix Report

**Fixed at:** 2026-06-16T16:44:58Z
**Source review:** .planning/phases/49-structural-g-code-scope-contract/49-REVIEW.md
**Iteration:** 1

**Summary:**
- Findings in scope: 3
- Fixed: 3
- Skipped: 0

## Fixed Issues

### WR-01: Broad `generated-outputs` Promotion Can Pass Beside the In-Progress Row

**Status:** fixed: requires human verification
**Files modified:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`, `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
**Commit:** 633191c44
**Applied fix:** Count all `generated-outputs` rows and require exactly one total row and exactly one `in progress` row. Added a mutation test that appends a promoted `generated-outputs` row and expects verifier failure.

### WR-02: Unsupported Structural Fields Can Bypass the Closed Field Count

**Status:** fixed: requires human verification
**Files modified:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`, `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
**Commit:** bd81d98d4
**Applied fix:** Count every Markdown table body row in the structural evidence section, excluding only the structural header and separator, so the existing 16 exact-row requirements act as a closed allowlist. Updated the unsupported-field mutant to use a hyphenated field name.

### WR-03: Overclaim Rejection Is Too Exact-String Dependent

**Status:** fixed: requires human verification
**Files modified:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`, `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
**Commit:** e14daafdb
**Applied fix:** Added a regex guard for Phase 49 proof/verification verbs in the same sentence as deferred scope terms, including non-Prusa fork support variants. Added mutation tests for near-identical structural verification parity wording and non-Prusa fork support overclaim wording.

## Skipped Issues

None - all in-scope findings were fixed.

## Verification

- `bash -n packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `shfmt -l -d packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `shellcheck packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `bash packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `bazel run //packages/prusa-gcode-output-scope:verify`
- `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`

---

_Fixed: 2026-06-16T16:44:58Z_
_Fixer: the agent (gsd-code-fixer)_
_Iteration: 1_
