---
phase: 37-prusa-baseline-and-checklist-gate
reviewed: 2026-05-31T23:47:19Z
depth: standard
files_reviewed: 10
files_reviewed_list:
  - docs/port/README.md
  - docs/port/package-map.md
  - docs/port/migration-guidance.md
  - docs/port/parity-matrix.md
  - packages/prusa-baseline/BUILD.bazel
  - packages/prusa-baseline/README.md
  - packages/prusa-baseline/drift-refresh-record.md
  - packages/prusa-baseline/profile-schema-checklist.md
  - packages/prusa-baseline/verify_prusa_baseline.sh
  - packages/prusa-baseline/verify_prusa_baseline_test.sh
findings:
  critical: 0
  warning: 1
  info: 0
  total: 1
status: issues_found
---

# Phase 37: Code Review Report

**Reviewed:** 2026-05-31T23:47:19Z
**Depth:** standard
**Files Reviewed:** 10
**Status:** issues_found

## Summary

Reviewed the Phase 37 Prusa baseline/checklist documentation, Bazel package
surface, verifier script, and verifier tests. The package verifier and test
suite pass, and no security issue was found. One verifier gap remains: several
required baseline fields are checked as loose substrings instead of being bound
to their markdown table rows.

Material repo guidance used: `AGENTS.md`, `AGENTS.bright-builds.md`,
`standards-overrides.md`, and the pinned Bright Builds code-shape,
verification, and testing standards.

Verification run:

- `bazel run //packages/prusa-baseline:verify` passed.
- `bazel test --cache_test_results=no //packages/prusa-baseline:verify_prusa_baseline_test` passed.
- `git diff --check -- <reviewed files>` passed.
- `shellcheck packages/prusa-baseline/verify_prusa_baseline.sh packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.
- `shfmt -d packages/prusa-baseline/verify_prusa_baseline.sh packages/prusa-baseline/verify_prusa_baseline_test.sh` passed.

## Warnings

### WR-01: Verifier Does Not Bind Required Values To Their Table Fields

**File:** `packages/prusa-baseline/verify_prusa_baseline.sh:52-91`

**Issue:** `verify_accepted_baseline` and `verify_drift_record` validate the
Prusa baseline by searching for required substrings anywhere in
`drift-refresh-record.md`. That can let the verifier pass if the actual table
field is wrong but the expected text still appears elsewhere in the file. For
example, the accepted source-baseline `Selected stable tag` row could be changed
while `version_2.9.5` remains in the reviewer record or source pin, and the
`Reviewer decision` row is only checked for the label, not the required pending
decision text. That weakens the checklist gate because the script does not
prove the specific fields it claims to guard.

**Fix:** Require exact table rows, or parse the markdown tables and assert field
values by key. Add regression tests that replace only one target row value while
leaving the expected token elsewhere in the fixture.

```bash
require_text "${drift_file}" "drift-refresh-record.md" \
	"| Selected stable tag | \`version_2.9.5\` |"
require_text "${drift_file}" "drift-refresh-record.md" \
	"| Peeled commit | \`9a583bd438b195856f3bcf7ea99b69ba4003a961\` |"
require_text "${drift_file}" "drift-refresh-record.md" \
	"| Reviewer decision | PENDING - human reviewer must choose keep accepted source pin, plan future intake update, or defer before implementation consumes this gate. |"
```

---

_Reviewed: 2026-05-31T23:47:19Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
