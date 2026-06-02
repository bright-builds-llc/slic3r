---
phase: 38-prusa-fixture-and-status-evidence-surface
plan: "01"
subsystem: parity-fixtures
tags: [prusa, fork-parity, fixtures, bazel, shell, status-vocabulary]
requires:
  - phase: 37-prusa-baseline-and-checklist-gate
    provides: accepted PrusaSlicer source pin and profile-schema checklist gate
  - phase: 36-parity-fixture-launcher-and-deferral-templates
    provides: fork fixture namespace and non-overclaiming conventions
provides:
  - Static Prusa profile-schema fixture namespace with raw PrusaResearch.ini and PrusaResearch.idx inputs.
  - Fixture-local provenance manifest with accepted source pin, source paths, sizes, and SHA-256 values.
  - Bazel fixture bundle, verifier target, and failure-mode shell tests.
  - Docs-only fork.prusaslicer.profile-schema status vocabulary reserved for Phase 40.
affects: [phase-39-prusa-profile-boundary, phase-40-prusa-profile-parity, fork-parity, parity-status]
tech-stack:
  added: []
  patterns: [raw vendor fixture provenance, static shell verifier, Bazel fixture filegroup, docs-only status token]
key-files:
  created:
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx
    - packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
    - packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh
  modified:
    - packages/parity-fixtures/BUILD.bazel
    - packages/parity-fixtures/README.md
    - packages/parity/README.md
    - docs/port/README.md
    - docs/port/package-map.md
    - docs/port/migration-guidance.md
    - docs/port/parity-matrix.md
key-decisions:
  - "Keep Phase 38 as static fixture/status preparation only; no Rust parser, Prusa parity command, or status.tsv row."
  - "Preserve raw Prusa fixture bytes and verify exact sizes and SHA-256 values locally."
  - "Reserve fork.prusaslicer.profile-schema in docs only until Phase 40 executable evidence exists."
patterns-established:
  - "Fork fixture bundles should expose raw files, local provenance, and static verification through packages/parity-fixtures."
  - "Fork status vocabulary can be reserved in docs without publishing packages/parity/status.tsv rows."
requirements-completed: [EVID-01, EVID-02, EVID-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 38-2026-06-01T00-33-46
generated_at: 2026-06-01T01:24:24Z
duration: 11min
completed: 2026-06-01
---

# Phase 38 Plan 01: Prusa Fixture and Status Evidence Surface Summary

**Static Prusa profile-schema fixture bundle with provenance, fail-closed Bazel verification, and docs-only status reservation**

## Performance

- **Duration:** 11 min
- **Started:** 2026-06-01T01:13:17Z
- **Completed:** 2026-06-01T01:24:24Z
- **Tasks:** 3
- **Files modified:** 14

## Accomplishments

- Created `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` with raw `PrusaResearch.ini` and `PrusaResearch.idx` files from `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- Added fixture-local provenance with source paths, upstream URLs, byte sizes, SHA-256 values, update route, Phase 37 checklist source, and scope exclusions.
- Added `//packages/parity-fixtures:prusa_profile_schema_bundle`, `//packages/parity-fixtures:verify_prusa_profile_schema_fixture`, and `//packages/parity-fixtures:verify_prusa_profile_schema_fixture_test`.
- Updated package and port docs to reserve `fork.prusaslicer.profile-schema` for Phase 40 while keeping `packages/parity/status.tsv` free of Prusa rows.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create static Prusa fixture namespace and provenance** - `077a04202` (feat)
2. **Task 2 RED: Add failing verifier tests** - `cd8522334` (test)
3. **Task 2 GREEN: Export fixtures and add static verifier** - `4719ceb40` (feat)
4. **Task 3: Publish fixture/update/status vocabulary without status rows** - `f820e1f75` (docs)

## Files Created/Modified

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes` - preserves raw fixture bytes for the `.ini` and CRLF `.idx` inputs.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md` - fixture scope, provenance, update route, Phase 39/40 boundary, and exclusions.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv` - grep-verifiable accepted source pin, paths, sizes, checksums, and status scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini` - raw Prusa profile/config fixture input.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx` - matching raw Prusa profile bundle index fixture input.
- `packages/parity-fixtures/BUILD.bazel` - exports aliases, bundle filegroup, verifier binary, verifier test, and package boundary entries.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` - local-only verifier for fixture bytes, provenance, namespace boundaries, and status non-publication.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` - failure-mode tests for missing files, checksum drift, missing provenance/scope wording, forbidden namespace, and status row publication.
- `packages/parity-fixtures/README.md`, `packages/parity/README.md`, and `docs/port/*` - Phase 38 fixture/update/status-vocabulary docs without verified Prusa publication.

## Decisions Made

- Used direct raw files under `prusaslicer.profile-schema/` rather than a subdirectory so maintainers can inspect the bundle and manifest together.
- Kept the verifier static and local-only; it checks checked-in files and status boundaries without fetching upstream, running profile auto-update, ingesting plugins, or executing a Prusa parity command.
- Left `packages/parity/status.tsv` unchanged and reserved `fork.prusaslicer.profile-schema` in docs only.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- The RED shell test for a missing source ref initially removed whole provenance rows, causing a broader missing-file-label failure. It was corrected before the GREEN commit to mutate only the source-ref value and prove the intended diagnostic.

## Verification

- `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` passed.
- `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` passed.
- `shfmt -d packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` passed with no diff.
- `bazel query //packages/parity-fixtures:prusa_profile_schema_bundle` resolved.
- `bazel query //packages/parity:prusaslicer_profile_schema_parity` failed as expected; Phase 38 did not create the Phase 40 target.
- `rg -n "fork\\.prusaslicer|prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv` returned no matches.
- Forbidden namespace scan under `packages/parity-fixtures/forks` found no Bambu Studio, OrcaSlicer, network, cloud, credential, credentials, plugin, or non-free paths.
- `git diff --check` passed.
- Stub-pattern scan on created/modified source docs and scripts found no tracked stubs.

## Authentication Gates

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 39 can consume `//packages/parity-fixtures:prusa_profile_schema_bundle` and the fixture-local provenance as stable static inputs for Rust parsing. Phase 40 remains responsible for creating `//packages/parity:prusaslicer_profile_schema_parity` and any verified status publication.

## Self-Check: PASSED

- Created files exist on disk.
- Task commits `077a04202`, `cd8522334`, `4719ceb40`, and `f820e1f75` exist in git history.
- Summary frontmatter includes `requirements-completed: [EVID-01, EVID-02, EVID-03]`.
- `git diff --check` passed for the summary file.

---
*Phase: 38-prusa-fixture-and-status-evidence-surface*
*Completed: 2026-06-01*
