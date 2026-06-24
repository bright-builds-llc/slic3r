---
phase: 60-executable-arc-fitting-evidence
plan: "04"
subsystem: parity
tags: [markdown, bash, bazel, prusaslicer, arc-fitting, docs]

requires:
  - phase: 60-executable-arc-fitting-evidence
    provides: Public arc-fitting command, mutation guards, and exact status row from Plans 60-01 through 60-03
provides:
  - Package-local parity docs for the public arc-fitting command and `fork.prusaslicer.arc-fitting` status row
  - Fixture package docs replacing stale future wording with Phase 60 publication wording
  - Fixture verifier exact-text enforcement for the published Phase 60 command/status sentence
  - Mutation coverage proving stale future-status wording fails closed
affects:
  - 60-executable-arc-fitting-evidence
  - packages/parity
  - packages/parity-fixtures

tech-stack:
  added: []
  patterns:
    - Package docs publish the narrow arc-fitting evidence slice while keeping broad generated-output status in progress
    - Fixture verifier docs checks enforce the published Phase 60 command/status wording
    - Stale future-status documentation is covered by an isolated README mutation case

key-files:
  created:
    - .planning/phases/60-executable-arc-fitting-evidence/60-04-SUMMARY.md
  modified:
    - packages/parity/README.md
    - packages/parity-fixtures/README.md
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md
    - packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh
    - packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh

key-decisions:
  - "Published package and fixture docs against the new public arc-fitting command and exact `fork.prusaslicer.arc-fitting` status row."
  - "Kept the existing semantic `fork.prusaslicer.gcode-output` evidence explicitly separate from the arc-fitting evidence slice."
  - "Updated fixture verifier exact-text checks to require Phase 60 publication wording and reject stale future-status wording."

patterns-established:
  - "Arc-fitting package docs must name the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public command/status/docs chain."
  - "Fixture docs use the exact sentence `Phase 60 publishes bazel run //packages/parity:prusaslicer_arc_fitting_parity and the fork.prusaslicer.arc-fitting status row for checked-in arc summary evidence only.`"

requirements-completed: [ARCEV-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T16:42:43Z

duration: 7 min
completed: 2026-06-24
---

# Phase 60 Plan 04: Package And Fixture Docs Summary

**Package and fixture docs now publish the narrow Prusa arc-fitting command/status slice with verifier-enforced Phase 60 wording**

## Performance

- **Duration:** 7 min
- **Started:** 2026-06-24T16:35:27Z
- **Completed:** 2026-06-24T16:42:43Z
- **Tasks:** 2
- **Files modified:** 5 implementation/docs files plus this summary

## Accomplishments

- Updated `packages/parity/README.md` to list `bazel run //packages/parity:prusaslicer_arc_fitting_parity`, document the checked `expected-arc-summary.tsv` artifact, name `slic3r_flavors::prusa_arc_fitting` and `prusa_arc_fitting_summary_lines`, and publish the Phase 57 through Phase 60 evidence chain.
- Updated `packages/parity-fixtures/README.md` and the fixture-local arc-fitting README to replace future Phase 60 wording with the exact published command/status sentence.
- Preserved the broad `generated-outputs` row as `in progress`, kept existing semantic Prusa G-code output evidence separate, and retained explicit deferrals for byte parity, full generated-output parity, runtime, GUI, release, sync, non-Prusa fork, and related generated-output surfaces.
- Updated `verify_prusa_arc_fitting_fixture.sh` and its mutation suite so fixture docs must contain the published Phase 60 wording and stale future-status wording fails closed.

## Task Commits

Each task was committed atomically:

1. **Task 1: Publish parity and fixture package docs for arc-fitting** - `b263a6ea0` (docs)
2. **Task 2: Align fixture verifier exact-text checks with published package docs** - `ef317158f` (test)

## Files Created/Modified

- `packages/parity/README.md` - Adds the public arc-fitting command and `fork.prusaslicer.arc-fitting` docs while preserving existing G-code output separation.
- `packages/parity-fixtures/README.md` - Publishes the Phase 60 arc-fitting command/status sentence for the fixture package.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md` - Publishes the fixture-local Phase 60 command/status sentence and explicit deferrals.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - Requires the published Phase 60 docs wording and removes stale future-status requirements.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh` - Adds stale Phase 60 wording mutation coverage.
- `.planning/phases/60-executable-arc-fitting-evidence/60-04-SUMMARY.md` - Records plan execution and verification evidence.

## Verification

- RED Task 2: `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture` failed before verifier updates with `fixture README: missing required text: Phase 59 owns future`.
- `mdformat --check packages/parity/README.md packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md`
- `bazel run //packages/parity:prusaslicer_arc_fitting_parity`
- `bazel run //packages/parity:status`
- Task 1 acceptance scans for the public arc-fitting command, `fork.prusaslicer.arc-fitting`, the Phase 57 through Phase 60 chain, separate existing semantic G-code evidence, and `generated-outputs` in-progress wording passed.
- `bash -n packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh`
- `shfmt -l -d packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh`
- `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture`
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test --test_output=errors`
- Task 2 acceptance scans for the exact published Phase 60 sentence in verifier/test sources and absence of stale future-status requirements in the verifier passed.
- `bazel test //packages/parity:prusaslicer_arc_fitting_parity_failure_test --test_output=errors`
- `git diff --check -- packages/parity/README.md packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh`

## Decisions Made

- Published package-local docs in `packages/parity` and `packages/parity-fixtures` only, leaving public port docs for the later Phase 60 plans.
- Kept the arc-fitting docs tied to checked-in summary evidence only, not generated-output parity or runtime behavior.
- Used one shared exact Phase 60 sentence for fixture README and package README verification so stale future-status wording has a single verifier contract.

## Deviations from Plan

None - product scope executed exactly as written.

### Process Adjustments

**1. TDD RED was captured without a failing commit**
- **Found during:** Task 2
- **Reason:** The plan marked Task 2 as TDD, but repo policy and the user request require atomic passing task commits.
- **Adjustment:** Captured the RED failure with the existing fixture verifier, then committed Task 2 only after the verifier and mutation tests passed.
- **Files modified:** None beyond planned task files.
- **Verification:** `ef317158f` was created after syntax, shfmt, fixture verifier, no-cache mutation test, and acceptance scans passed.

**Total deviations:** 0 auto-fixed.
**Impact on plan:** No product scope changed; the adjustment preserved repo policy and the intended TDD evidence.

## Known Stubs

None.

## Threat Flags

None - this plan changed documentation and local verifier exact-text checks only; it introduced no network endpoint, auth path, schema change, runtime file discovery, upstream import, host upload behavior, or external-service surface.

## Issues Encountered

- Exact docs checks had to account for Markdown line wrapping by checking wrapped prerequisite facts separately while keeping the required Phase 60 publication sentence exact.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 60-05 can publish arc-fitting scope docs against package and fixture docs that now use the actual Phase 60 command/status wording. The public arc command, public mutation suite, fixture verifier, and parity status command are green.

*Phase: 60-executable-arc-fitting-evidence*
*Completed: 2026-06-24*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/60-executable-arc-fitting-evidence/60-04-SUMMARY.md`.
- Task commits exist: `b263a6ea0` and `ef317158f`.
- Summary frontmatter parses with `requirements_completed: [ARCEV-03]`.
- Summary closeout checks passed: `summary-extract` and `git diff --check` on this summary.
