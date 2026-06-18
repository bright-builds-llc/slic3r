---
phase: 52-executable-structural-g-code-evidence
plan: "03"
subsystem: parity
tags: [bazel, bash, prusaslicer, gcode, status]

requires:
  - phase: 52-executable-structural-g-code-evidence
    provides: Plan 52-02 public `//packages/parity:prusaslicer_gcode_output_parity` structural sidecar validation and mutation guard
provides:
  - Exact narrow structural `fork.prusaslicer.gcode-output` status publication
  - Fixture verifier enforcement for the structural status row and preserved public parity command
  - Mutation coverage proving a wrong status evidence target fails against the structural status wording
affects:
  - 52-executable-structural-g-code-evidence
  - packages/parity
  - packages/parity-fixtures

tech-stack:
  added: []
  patterns:
    - Checked-in status publication is enforced by the fixture verifier as an exact row contract
    - Broad `generated-outputs` status remains a separate in-progress row while narrow fork evidence advances

key-files:
  created:
    - .planning/phases/52-executable-structural-g-code-evidence/52-03-SUMMARY.md
  modified:
    - packages/parity/status.tsv
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh

key-decisions:
  - "Published the existing `fork.prusaslicer.gcode-output` row as narrow structural evidence without changing its status token or public parity command."
  - "Kept the broad `generated-outputs` row exactly `in progress`."
  - "Preserved the verifier's split literal around `host upload` so forbidden-term self-scanning remains fail-closed."

patterns-established:
  - "The fixture verifier now treats the structural status row as an exact publication contract tied to Phase 49, Phase 50, Phase 51, and Phase 52 evidence."
  - "Wrong-evidence mutation coverage uses the same structural notes text as the published row while changing only the evidence target."

requirements-completed: [GCEV-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 52-2026-06-18T01-09-43
generated_at: 2026-06-18T02:32:52Z

duration: 3 min
completed: 2026-06-18
---

# Phase 52 Plan 03: Structural G-code Status Publication Summary

**Narrow Prusa G-code status now publishes structural evidence and fixture verification enforces the exact row**

## Performance

- **Duration:** 3 min
- **Started:** 2026-06-18T02:29:26Z
- **Completed:** 2026-06-18T02:32:52Z
- **Tasks:** 2
- **Files modified:** 3 implementation/test files plus this summary

## Accomplishments

- Updated `packages/parity/status.tsv` so `fork.prusaslicer.gcode-output` names the narrow structural Prusa G-code evidence slice.
- Preserved the broad `generated-outputs` row as exactly one `in progress` row.
- Updated fixture verifier enforcement and wrong-evidence mutation coverage to require the structural status wording.

## Task Commits

Each task was committed atomically:

1. **Task 1: Publish exact structural status wording** - `408e764f0` (feat)
2. **Task 2: Reconcile fixture verifier status enforcement** - `a8ddd0d15` (fix)

## Files Created/Modified

- `packages/parity/status.tsv` - Replaced the summary-only Prusa G-code notes with the exact structural evidence wording.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - Updated `GCODE_OUTPUT_STATUS_ROW` to enforce the structural publication contract.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` - Updated wrong-evidence mutation coverage to use the structural status row text.

## Verification

- `awk -F '\t' '$1=="fork.prusaslicer.gcode-output" && $2=="verified" && $3=="//packages/parity:prusaslicer_gcode_output_parity" && index($4, "narrow structural Prusa G-code evidence slice") && index($4, "Phase 49 closed structural scope contract") && index($4, "Phase 50 structural fixture summary") && index($4, "Phase 51 Rust structural parser/readiness boundary") && index($4, "Phase 52 public parity command") { count++ } END { exit count == 1 ? 0 : 1 }' packages/parity/status.tsv`
- `awk -F '\t' '$1=="generated-outputs" && $2=="in progress" { count++ } END { exit count == 1 ? 0 : 1 }' packages/parity/status.tsv`
- `rg -n "narrow structural Prusa G-code evidence slice|Phase 49 closed structural scope contract|Phase 50 structural fixture summary|Phase 51 Rust structural parser/readiness boundary|Phase 52 public parity command" packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `rg -n "Phase 49 closed structural scope contract" packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `rg -n "narrow summary-only Prusa G-code evidence slice" packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` found no matches.
- `bash -n packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `shfmt -l -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bazel run //packages/parity:status`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`
- `git diff --check`

## Decisions Made

- Kept status publication scoped to the existing `fork.prusaslicer.gcode-output` row and `//packages/parity:prusaslicer_gcode_output_parity` command.
- Kept `generated-outputs` unchanged and in progress.
- Followed repo-local summary metadata guidance and Bright Builds verification guidance; no active `standards-overrides.md` exception changed the task path.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 52-04 can update scope traceability and verifier publication checks using the exact structural status row now published and enforced.

---
*Phase: 52-executable-structural-g-code-evidence*
*Completed: 2026-06-18*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/52-executable-structural-g-code-evidence/52-03-SUMMARY.md`.
- Task commits exist in git history: `408e764f0` and `a8ddd0d15`.
- `summary-extract` parsed the frontmatter and returned `requirements_completed: ["GCEV-03"]`.
- `git diff --check` passes for this summary.
