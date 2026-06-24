---
phase: 60-executable-arc-fitting-evidence
plan: "05"
subsystem: parity
tags: [markdown, bash, bazel, prusaslicer, arc-fitting, scope]

requires:
  - phase: 60-executable-arc-fitting-evidence
    provides: Public arc-fitting command, mutation guards, status row, and package/fixture docs from Plans 60-01 through 60-04
provides:
  - Published arc-fitting scope README and scope contract wording for the Phase 60 public command/status row
  - Scope verifier exact checks for published command/status wording and the `## Published Status Wording` section
  - Scope mutation coverage rejecting stale planned status row labels and section headings
affects:
  - 60-executable-arc-fitting-evidence
  - packages/prusa-arc-fitting-scope

tech-stack:
  added: []
  patterns:
    - Scope docs keep Phase 57 historical planning boundaries while publishing Phase 60 command/status evidence
    - Scope verifier uses exact positive checks plus split-literal stale wording rejection guards

key-files:
  created:
    - .planning/phases/60-executable-arc-fitting-evidence/60-05-SUMMARY.md
  modified:
    - packages/prusa-arc-fitting-scope/README.md
    - packages/prusa-arc-fitting-scope/arc-fitting-scope.md
    - packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh
    - packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh

key-decisions:
  - "Published scope documentation against the actual Phase 60 arc-fitting public command and exact `fork.prusaslicer.arc-fitting` status row."
  - "Kept Phase 57 as the historical scope-contract boundary while documenting that Phase 60 published only checked-in arc summary evidence."
  - "Preserved broad `generated-outputs` as `in progress` and kept the existing semantic `fork.prusaslicer.gcode-output` evidence separate."
  - "Used split Bash literals for stale planned wording rejection so source scans do not contain the forbidden stale strings contiguously."

patterns-established:
  - "Scope publication updates must pair exact docs wording with verifier positive checks and stale wording mutation coverage."
  - "Published scope wording names the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command/status row."

requirements-completed: [ARCEV-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T16:55:54Z

duration: 7 min
completed: 2026-06-24
---

# Phase 60 Plan 05: Arc-Fitting Scope Docs Publication Summary

**Arc-fitting scope docs and verifier now enforce Phase 60 published command/status wording while preserving the Phase 57 boundary**

## Performance

- **Duration:** 7 min
- **Started:** 2026-06-24T16:48:16Z
- **Completed:** 2026-06-24T16:55:54Z
- **Tasks:** 2
- **Files modified:** 4 implementation/docs files plus this summary

## Accomplishments

- Updated `packages/prusa-arc-fitting-scope/README.md` so the package overview says Phase 57 recorded the scope contract and Phase 60 publishes `bazel run //packages/parity:prusaslicer_arc_fitting_parity` plus `fork.prusaslicer.arc-fitting` for checked-in arc summary evidence only.
- Updated `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` from stale Phase 60 planned wording to published `Public evidence command`, `Published narrow status row`, and `## Published Status Wording` text.
- Aligned the scope verifier exact-text checks with the published scope docs and added fail-closed stale planned wording rejection.
- Added mutation coverage for stale status row labels and stale planned status section headings.

## Task Commits

Each task was committed atomically:

1. **Task 1: Publish scope docs for the Phase 60 arc-fitting evidence row** - `a54fbdf18` (docs)
2. **Task 2: Align scope verifier exact-text checks with published scope docs** - `700233d03` (test)

## Files Created/Modified

- `packages/prusa-arc-fitting-scope/README.md` - Publishes the Phase 60 command/status row while keeping Phase 57 as the historical scope contract.
- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - Replaces Phase 60 planned labels with published command/status wording and keeps generated-output/G-code deferrals intact.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` - Requires published scope rows/section text and rejects stale planned wording.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh` - Updates valid fixtures and adds stale published-row and stale published-section mutation cases.
- `.planning/phases/60-executable-arc-fitting-evidence/60-05-SUMMARY.md` - Records plan execution and verification evidence.

## Verification

- RED Task 2: `bazel test --cache_test_results=no //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test --test_output=errors` failed with `FAIL: stale published status section heading passed` before the verifier required `## Published Status Wording`.
- `mdformat --check packages/prusa-arc-fitting-scope/README.md packages/prusa-arc-fitting-scope/arc-fitting-scope.md`
- `bash -n packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh`
- `shfmt -l -d packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh`
- `bazel run //packages/prusa-arc-fitting-scope:verify`
- `bazel test --cache_test_results=no //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test --test_output=errors`
- Task acceptance scans for published labels, exact published status wording, README/scope command/status references, and absence of stale Phase 60 planned docs wording passed.
- `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `bazel run //packages/parity:prusaslicer_arc_fitting_parity`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture`
- `bazel run //packages/prusa-arc-fitting-scope:verify`
- `git diff --check -- packages/prusa-arc-fitting-scope/README.md packages/prusa-arc-fitting-scope/arc-fitting-scope.md packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh`

## Decisions Made

- Kept the scope docs focused on checked-in arc summary evidence only; no byte parity, generated-output parity, runtime, GUI, release, sync, upstream import, host upload, printer-runtime, or non-Prusa support claim was added.
- Kept `generated-outputs` explicitly `in progress` and preserved `fork.prusaslicer.gcode-output` as the existing semantic Prusa G-code evidence slice.
- Split stale planned wording literals inside the verifier so final source scans prove those stale phrases are not present contiguously while runtime rejection still checks the exact stale text.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Aligned positive verifier rows during Task 1**
- **Found during:** Task 1 (Publish scope docs for the Phase 60 arc-fitting evidence row)
- **Issue:** The Task 1 doc update made `bazel run //packages/prusa-arc-fitting-scope:verify` fail because the verifier still required the old `Planned evidence command` and `Planned status token` rows.
- **Fix:** Moved the positive verifier row and valid-fixture alignment into the Task 1 commit, then left the new stale-wording rejection and mutation coverage for Task 2.
- **Files modified:** `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh`, `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh`
- **Verification:** `bazel run //packages/prusa-arc-fitting-scope:verify` and `bazel test --cache_test_results=no //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test --test_output=errors`
- **Committed in:** `a54fbdf18`

**Total deviations:** 1 auto-fixed (1 blocking).
**Impact on plan:** The final product scope matches the plan; the adjustment kept the intermediate task commit verifiable despite the planned verifier update being listed after the doc verifier command.

### Process Adjustments

**1. TDD RED was captured without a failing commit**
- **Found during:** Task 2
- **Reason:** Repo policy and the user request require atomic passing commits.
- **Adjustment:** Added the stale-section mutation test, captured the expected failing Bazel test output, then committed Task 2 only after the verifier implementation and mutation suite passed.
- **Files modified:** None beyond planned files.

## Known Stubs

None.

## Threat Flags

None - this plan changed documentation and local exact-text verifier checks only; it introduced no network endpoint, auth path, schema change, runtime file discovery, upstream import, host upload behavior, or external-service surface.

## Issues Encountered

- The verifier's README exact-text check required the package ownership sentence to remain on one line. The README was adjusted to preserve that exact check while leaving the new Phase 60 publication wording separate.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 60-06 can publish public port docs against scope, package, fixture, status, and command surfaces that now all use Phase 60 published command/status wording. The arc-fitting command, existing G-code command, fixture verifier, scope verifier, and scope mutation tests are green.

*Phase: 60-executable-arc-fitting-evidence*
*Completed: 2026-06-24*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/60-executable-arc-fitting-evidence/60-05-SUMMARY.md`.
- Task commits exist: `a54fbdf18` and `700233d03`.
- Summary frontmatter parses with `requirements_completed: [ARCEV-03]`.
- Summary closeout checks passed: `summary-extract` and `git diff --check` on this summary.
