---
phase: 50-structural-g-code-fixture-expansion
plan: "02"
subsystem: parity-fixtures
tags: [bash, bazel, tsv, prusaslicer, gcode]

requires:
  - phase: 50-01
    provides: Source-pinned structural sidecar TSV with Bazel fixture ownership
provides:
  - Existing G-code fixture verifier now validates the structural sidecar schema, rows, values, provenance, and update boundary
  - Mutation suite covers structural value drift, missing rows, duplicate rows, unsupported fields, broad overclaims, and provenance mismatch
  - RED evidence proving the prior verifier ignored structural summary drift
affects:
  - 51-structural-g-code-rust-boundary
  - 52-structural-g-code-public-evidence

tech-stack:
  added: []
  patterns:
    - Bash 3.2-compatible structural TSV checks using awk for closed field and duplicate-count validation
    - Temp-checkout mutation tests pass the structural sidecar through the existing verifier entrypoint

key-files:
  created: []
  modified:
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh

key-decisions:
  - "Extended the existing fixture verifier and Bazel target instead of adding a new structural verifier target."
  - "Kept structural verification file-based and local to packages/parity-fixtures with no Rust parser, status, or public parity publication changes."
  - "Used awk-backed closed-field checks instead of Bash associative arrays to preserve Bash 3.2 compatibility."

patterns-established:
  - "Structural sidecar verification runs before README/status/parity publication checks and fails with sidecar/field diagnostics."
  - "Structural mutation tests remain isolated in temp checkouts and do not mutate repo fixture artifacts."

requirements-completed:
  - GCFIX-02
  - GCFIX-03
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 50-2026-06-17T16-13-19
generated_at: 2026-06-17T17:14:21Z

duration: 11min
completed: 2026-06-17
---

# Phase 50 Plan 02: Structural G-code Fixture Verifier Summary

**Fail-closed structural G-code sidecar verifier with one mutation guard per structural drift class**

## Performance

- **Duration:** 11 min
- **Started:** 2026-06-17T17:03:37Z
- **Completed:** 2026-06-17T17:14:21Z
- **Tasks:** 2
- **Files modified:** 2 implementation files plus this summary

## Accomplishments

- Added RED mutation coverage for structural value drift, missing structural rows, duplicate rows, unsupported fields, structural overclaims, and provenance mismatch.
- Extended `verify_prusa_gcode_output_fixture.sh` to accept `expected-gcode-structural-summary.tsv` in default and explicit temp-checkout modes.
- Added fail-closed structural checks for the sidecar header, six-column shape, exact 17-line file shape, closed 16-field set, duplicate/missing field counts, exact rows, source/fixture alignment, fixture identity/source literal values, README update route, and forbidden publication/file-integrity metadata.
- Preserved Phase 50 boundaries: no new verifier target, no `packages/parity` edits, no Rust parser edits, no status publication changes.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add RED structural mutation coverage** - `752e9df16` (test)
2. **Task 2: Implement GREEN structural verifier checks** - `91c285c4c` (feat)

## Files Created/Modified

- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` - Copies the structural sidecar into temp checkouts, passes it to the verifier, and covers the six required GCFIX-03 structural mutation classes.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - Verifies the structural TSV schema, exact rows, field counts, provenance alignment, fixture identity values, README/update boundary, and overclaim/file-integrity exclusions.

## TDD Evidence

- **RED:** `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` exited `1` before verifier implementation and wrote `FAIL: structural value drift fixture passed` to `/tmp/phase50-structural-red.err`.
- **GREEN:** The same Bash mutation suite prints `ok: verify_prusa_gcode_output_fixture_test` after structural verifier enforcement was added.

## Validation Commands

- `rg -n 'structural_summary_file|STRUCTURAL_SUMMARY_HEADER|STRUCTURAL_SUMMARY_ROW_COUNT|verify_structural_summary|expected-gcode-structural-summary.tsv|unsupported structural field|provenance mismatch' packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bash -n packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `shfmt -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `shellcheck packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`
- `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`
- `test -z "$(git diff --name-only -- packages/parity packages/slic3r-rust)"`
- `git diff --check -- packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`

## Decisions Made

- Followed D-06 by keeping the existing `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` owner instead of adding a structural verifier target.
- Kept structural enforcement in Bash with `awk` for duplicate/missing field counts because local Bash remains 3.2-compatible.
- Rejected structural broad claims before exact-row comparison so the overclaim mutation reports a forbidden structural sidecar claim instead of only row drift.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Made structural field counting portable across the local awk**
- **Found during:** Task 2 (Implement GREEN structural verifier checks)
- **Issue:** The first implementation passed a newline-delimited required-field list through `awk -v`, which this awk rejected with `newline in string`.
- **Fix:** Switched the internal required-field list to a space-delimited value and consumed `INVENTORY_SOURCE_PATHS` through a structural value check so shell verification stayed clean.
- **Files modified:** `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`
- **Verification:** `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`, `shellcheck`, and both Bazel tests passed.
- **Committed in:** `91c285c4c`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The fix preserved the planned behavior and Bash 3.2 compatibility without expanding scope.

## Known Stubs

None.

## Issues Encountered

- The first RED command wrapper used zsh's read-only `status` variable. The RED run was repeated with `red_status`, producing valid evidence in `/tmp/phase50-structural-red.err`.
- `.planning/STATE.md` and `.planning/ROADMAP.md` were already modified by orchestration and were intentionally left untouched and unstaged.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 51 can consume `expected-gcode-structural-summary.tsv` through a typed Rust boundary with fail-closed fixture evidence already enforced by the existing Bazel-owned fixture verifier. Phase 52 remains responsible for public structural parity/status publication.

*Phase: 50-structural-g-code-fixture-expansion*
*Completed: 2026-06-17*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/50-structural-g-code-fixture-expansion/50-02-SUMMARY.md`.
- Task commits exist in git history: `752e9df16` and `91c285c4c`.
- Summary frontmatter includes `requirements-completed` with `GCFIX-02` and `GCFIX-03`.
- `git diff --check` passes for this summary.
