---
phase: 42-prusa-project-file-fixture-surface
plan: "02"
subsystem: parity-fixtures
tags: [prusaslicer, project-file, bazel, bash, verifier, fixtures]
requires:
  - phase: 42-prusa-project-file-fixture-surface
    provides: Plan 42-01 source-pinned project-file fixture namespace, provenance, and expected project summary.
provides:
  - Bazel-visible project-file fixture aliases and `prusa_project_file_bundle`.
  - Repo-owned `verify_prusa_project_file_fixture` Bash verifier.
  - Failure-mode `verify_prusa_project_file_fixture_test` shell test.
  - Negative guards against premature Phase 43 parser and Phase 44 parity/status artifacts.
affects: [phase-42, phase-43, phase-44, prusa-project-file, parity-fixtures]
tech-stack:
  added: []
  patterns:
    - Bash fail-closed fixture verification with exact TSV, archive, marker, and negative-surface checks.
    - Bazel `sh_binary` and `sh_test` wrapper around project-file fixture verification.
key-files:
  created:
    - packages/parity-fixtures/verify_prusa_project_file_fixture.sh
    - packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
    - .planning/phases/42-prusa-project-file-fixture-surface/42-02-SUMMARY.md
  modified:
    - packages/parity-fixtures/BUILD.bazel
key-decisions:
  - "Kept project-file fixture verification local and fail-closed with exact byte, SHA-256, provenance, TSV, archive-member, and marker checks."
  - "Preserved Phase 43/44 boundaries by rejecting `prusa_project_file`, `prusaslicer_project_file_parity`, and `fork.prusaslicer.project-file` surfaces."
  - "Used explicit verifier arguments for isolated failure-mode tests while allowing normal Bash/Bazel runs to infer repo paths."
patterns-established:
  - "Project-file fixture bundles expose stable Bazel aliases before parser or parity targets consume them."
  - "Verifier tests mutate temp fixture copies instead of checked-in files."
requirements-completed: [PFIX-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 42-2026-06-03T20-35-51
generated_at: 2026-06-03T21:23:03Z
duration: 9m 40s
completed: 2026-06-03
---

# Phase 42 Plan 02: Prusa Project-File Fixture Surface Summary

**Fail-closed Prusa project-file fixture verification through Bash and Bazel**

## Performance

- **Duration:** 9m 40s
- **Started:** 2026-06-03T21:13:23Z
- **Completed:** 2026-06-03T21:23:03Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments

- Exported the project-file fixture namespace through stable Bazel aliases and
  `prusa_project_file_bundle`.
- Added `verify_prusa_project_file_fixture.sh` to validate fixture bytes,
  SHA-256, provenance row fields, expected-project-summary rows, ZIP members,
  marker strings, README scope text, and future-phase absence guards.
- Added failure-mode shell tests covering checksum drift, missing TSV header
  and member rows, missing Phase 41 scope traceability, premature status rows,
  premature parity targets, and premature Rust parser-surface text.

## Task Commits

1. **Task 1: Export project-file fixture aliases and bundle** - `508aedc73` (`feat`)
2. **Task 2 RED: Add failing verifier tests** - `3747c12f1` (`test`)
3. **Task 2 GREEN: Implement verifier and Bazel targets** - `68bf1a0d3` (`feat`)

## Evidence Commands

All required final verification commands passed:

```bash
bash packages/parity-fixtures/verify_prusa_project_file_fixture.sh
bash packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture
bazel test //packages/parity-fixtures:verify_prusa_project_file_fixture_test
shfmt -d packages/parity-fixtures/verify_prusa_project_file_fixture.sh packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
bazel query //packages/parity-fixtures:prusa_project_file_bundle
bazel query //packages/parity-fixtures:prusa_project_file_expected_project_summary
bazel query //packages/parity-fixtures:prusa_project_file_seam_test_object
bash -lc '! bazel query //packages/parity:prusaslicer_project_file_parity >/tmp/phase42-prusa-project-file-target.out 2>&1'
bash -lc '! rg -n "fork\\.prusaslicer\\.project-file|prusaslicer_project_file_parity" packages/parity/status.tsv'
bash -lc '! rg -n "prusa_project_file" packages/slic3r-rust/crates/slic3r_flavors/src packages/slic3r-rust/crates/slic3r_flavors/tests'
git diff -- packages/parity/status.tsv packages/parity/BUILD.bazel packages/slic3r-rust
git diff --check
```

## Files Created/Modified

- `packages/parity-fixtures/BUILD.bazel` - Adds project-file fixture exports,
  aliases, `prusa_project_file_bundle`, verifier binary/test targets, and
  package-boundary entries.
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` - Local
  fail-closed verifier for project-file fixture integrity and scope boundaries.
- `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` -
  Failure-mode shell tests for verifier drift and future-phase guards.

## Decisions Made

- Kept the verifier in Bash to match the existing fixture verifier pattern and
  avoid introducing a Phase 42 parser framework.
- Made fixture tests operate on temp copies so negative cases do not mutate the
  checked-in project-file fixture namespace.
- Kept `packages/parity/status.tsv`, `packages/parity/BUILD.bazel`, and Rust
  project-file parser surfaces unchanged except for read-only negative guards.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- During GREEN, the initial archive marker helper used a `grep -q` pipeline
  under `pipefail`; it was changed to read the archive member once and search
  the captured text so successful early matches do not look like pipe errors.
- During GREEN, two README checks were narrowed to the exact line-wrapped text
  in the checked-in fixture README.

## Known Stubs

- `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh:231` -
  `placeholder.sh` is written only into a temp `parity.BUILD.bazel` to prove
  the verifier rejects a premature project-file parity target. It is not a
  checked-in target or unfinished product stub.

## Auth Gates

None.

## User Setup Required

None - verification uses checked-in files and local CLI tooling only.

## Next Phase Readiness

Plan 42-03 can document the fixture surface and verifier route. Phase 43 parser
work, Phase 44 executable parity, and the `fork.prusaslicer.project-file`
status row remain intentionally unavailable.

## Self-Check: PASSED

- Created summary file found:
  `.planning/phases/42-prusa-project-file-fixture-surface/42-02-SUMMARY.md`.
- Created verifier files found:
  `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` and
  `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh`.
- Task commits found: `508aedc73`, `3747c12f1`, `68bf1a0d3`.
- Frontmatter extraction found `requirements-completed: [PFIX-02]`,
  `lifecycle_mode: yolo`, and
  `phase_lifecycle_id: 42-2026-06-03T20-35-51`.
- Summary `git diff --check` passed.

---

*Phase: 42-prusa-project-file-fixture-surface*
*Completed: 2026-06-03*
