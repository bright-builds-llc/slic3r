---
phase: 36-parity-fixture-launcher-and-deferral-templates
plan: "01"
subsystem: docs
tags: [fork-parity, templates, bazel, shell, drift-refresh]

# Dependency graph
requires:
  - phase: 32-vendor-source-manifest-and-license-baseline
    provides: fork vendor source pins and verifier command
  - phase: 33-inventory-templates-and-source-pinned-fork-inventories
    provides: source-pinned inventory row vocabulary
  - phase: 35-flavor-registry-boundary
    provides: metadata-only fork/flavor boundary
provides:
  - Dedicated fork template package with checklist, launcher-shape, and drift protocol docs
  - Local Bazel verifier for required template labels and non-overclaiming wording
  - Shell tests for verifier success and failure modes
affects: [phase-36, fork-parity, fork-templates, future-fork-milestones]

# Tech tracking
tech-stack:
  added: [bazel-sh-binary, bazel-sh-test, bash-template-verifier]
  patterns: [package-local verify target, exact template wording checks]

key-files:
  created:
    - packages/fork-templates/BUILD.bazel
    - packages/fork-templates/README.md
    - packages/fork-templates/fork-parity-checklist-template.md
    - packages/fork-templates/fork-launcher-shape-template.md
    - packages/fork-templates/manual-drift-refresh-protocol.md
    - packages/fork-templates/verify_templates.sh
    - packages/fork-templates/verify_templates_test.sh
  modified: []

key-decisions:
  - "Kept Phase 36 fork template verification local-only and wording-based; it does not prove fork parity."
  - "Kept drift refresh manual and reviewer-gated by referencing the existing fork vendor verifier instead of adding sync automation."
  - "Kept fork status rows and fork fixture files out of v1.9; future verified fork status requires executable parity evidence."

patterns-established:
  - "Package-local Bazel verify target for Markdown template contracts."
  - "Focused shell tests generate temporary complete and incomplete template fixtures."

requirements-completed: [PAR-01, PAR-04]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 36-2026-05-27T13-38-25
generated_at: 2026-05-27T14:14:57Z

# Metrics
duration: 4min
completed: 2026-05-27
---

# Phase 36 Plan 01: Fork Template Package Summary

**Fork parity checklist, launcher-shape template, manual drift protocol, and local Bazel verifier for Phase 36 template contracts**

## Performance

- **Duration:** 4 min
- **Started:** 2026-05-27T14:10:07Z
- **Completed:** 2026-05-27T14:14:57Z
- **Tasks:** 3
- **Files modified:** 7

## Accomplishments

- Created `packages/fork-templates` as the dedicated Phase 36 template package.
- Added a fixed-field fork parity checklist covering every PAR-01 required label.
- Added manual drift-refresh documentation that uses `bazel run //packages/fork-vendors:verify` and keeps branch drift separate from accepted source pins.
- Added `//packages/fork-templates:verify` and `//packages/fork-templates:verify_templates_test`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create fork template package docs** - `eadaeb8fc` (docs)
2. **Task 2 RED: Add failing tests for template verifier** - `c8a8d85bc` (test)
3. **Task 2 GREEN: Implement fork template verifier** - `2e48e2395` (feat)
4. **Task 3: Verify package boundary and summary metadata expectations** - `b783429cd` (fix)

## Files Created/Modified

- `packages/fork-templates/BUILD.bazel` - Bazel package boundary, verify target, and shell test target.
- `packages/fork-templates/README.md` - Package entrypoint, verifier command, central deferral link, and non-overclaiming boundary.
- `packages/fork-templates/fork-parity-checklist-template.md` - Fixed PAR-01 checklist template.
- `packages/fork-templates/fork-launcher-shape-template.md` - Future launcher-shape planning template with v1.9 release and launcher deferrals.
- `packages/fork-templates/manual-drift-refresh-protocol.md` - Manual PAR-04 runbook using the existing fork vendor verifier.
- `packages/fork-templates/verify_templates.sh` - Local-only template contract verifier.
- `packages/fork-templates/verify_templates_test.sh` - Shell tests for verifier success and failure modes.

## Decisions Made

- Kept the verifier as exact text checks because Phase 36 defines fixed labels and boundary phrases, not a general Markdown schema.
- Kept drift refresh as documentation plus the existing vendor verifier command, with no new source fetch, clone, build, import, vendor, scheduler, or automatic ref update path.
- Kept `packages/parity/status.tsv` and `packages/parity-fixtures/forks/` untouched because v1.9 has no executable fork parity evidence.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed exact README wording required by the verifier**
- **Found during:** Task 3 (Verify package boundary and summary metadata expectations)
- **Issue:** `bazel run //packages/fork-templates:verify` failed because required README phrases were split across line breaks or capitalized differently than the exact verifier contract.
- **Fix:** Made the required source-pin, executable-evidence, and no-status-row phrases contiguous and exact in `packages/fork-templates/README.md`.
- **Files modified:** `packages/fork-templates/README.md`
- **Verification:** `bazel run //packages/fork-templates:verify`, `bazel test //packages/fork-templates:verify_templates_test`, `shfmt -d packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh`, no-status-row/no-fork-fixture guard, and `git diff --check` all passed after the fix.
- **Committed in:** `b783429cd`

**Total deviations:** 1 auto-fixed (1 Rule 1 bug)
**Impact on plan:** The fix aligned the documentation with the planned verifier contract. No scope was added.

## Issues Encountered

- Task 3 initially failed on an exact README wording check. The failure was fixed and verified in `b783429cd`.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Verification

- `bazel run //packages/fork-templates:verify` - passed
- `bazel test //packages/fork-templates:verify_templates_test` - passed
- `shfmt -d packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh` - passed
- `test -z "$(git status --porcelain -- packages/parity/status.tsv packages/parity-fixtures/forks)"` - passed
- `git diff --check` - passed

## Next Phase Readiness

Ready for Plan 36-02 to add the central deferral block and parity/fixture
documentation links. Plan 36-01 intentionally completed only PAR-01 and PAR-04
material requirements.

## Self-Check: PASSED

- Confirmed all seven `packages/fork-templates` files exist.
- Confirmed `36-01-SUMMARY.md` exists.
- Confirmed task commits `eadaeb8fc`, `c8a8d85bc`, `2e48e2395`, and
  `b783429cd` exist in git history.

---
*Phase: 36-parity-fixture-launcher-and-deferral-templates*
*Completed: 2026-05-27*
