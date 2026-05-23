---
phase: 29-cross-platform-packaging-evidence
plan: "01"
subsystem: parity
tags:
  - bazel
  - launcher
  - packaging
  - parity
requires:
  - phase: 27-linux-packaged-launcher-slice
    provides: Scoped Linux packaged launcher tree and smoke target.
  - phase: 28-windows-packaged-launcher-slice
    provides: Scoped Windows packaged launcher tree and smoke target.
provides:
  - Shared Linux packaged launcher parity command.
  - Shared Windows packaged launcher parity command.
  - Checked-in packaged launcher layout and scope-note fixtures.
affects:
  - packages/parity
  - packages/parity-fixtures
tech-stack:
  added: []
  patterns:
    - Bazel sh_binary parity command comparing temp package trees against checked-in fixtures.
    - Shared package comparator reusing existing behavior fixture corpora.
key-files:
  created:
    - packages/parity/compare_packaged_launcher.sh
    - packages/parity-fixtures/linux-packaged-launcher/README.md
    - packages/parity-fixtures/linux-packaged-launcher/expected-files.txt
    - packages/parity-fixtures/linux-packaged-launcher/expected-packaged-slice.txt
    - packages/parity-fixtures/windows-packaged-launcher/README.md
    - packages/parity-fixtures/windows-packaged-launcher/expected-files.txt
    - packages/parity-fixtures/windows-packaged-launcher/expected-packaged-slice.txt
  modified:
    - packages/parity/BUILD.bazel
    - packages/parity/README.md
    - packages/parity-fixtures/BUILD.bazel
key-decisions:
  - "Packaged Linux and Windows parity evidence uses exact layout and scope-note fixtures plus existing shared behavior fixtures."
  - "The new parity commands execute the packaged startup commands, not only raw runtime targets."
  - "Parity status publication remains deferred to Phase 30."
patterns-established:
  - "Cross-platform packaged launcher parity comparator with platform-specific builder invocation and shared behavior checks."
requirements-completed:
  - PKGE-01
  - PKGE-02
  - PKGE-03
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 29-2026-05-23T11-45-16
generated_at: 2026-05-23T12:09:00Z
duration: 24min
completed: 2026-05-23
---

# Phase 29 Plan 01: Cross-Platform Packaged Launcher Evidence Summary

Shared packaged launcher evidence now exists for Linux and Windows.

## Performance

- **Duration:** 24 min
- **Started:** 2026-05-23T11:45:16Z
- **Completed:** 2026-05-23T12:09:00Z
- **Tasks:** 3 completed
- **Files modified:** 10

## Accomplishments

- Added `packages/parity/compare_packaged_launcher.sh`, a shared comparator
  that builds a temporary platform package tree, checks layout and scope notes,
  and executes the packaged startup command for help/version/config/export/
  transform fixture comparisons.
- Added `//packages/parity:linux_packaged_launcher_parity`, which verifies the
  `Slic3r-linux` package tree through `bin/slic3r`.
- Added `//packages/parity:windows_packaged_launcher_parity`, which verifies
  the `Slic3r-windows` package tree through `Slic3r-console.exe`.
- Added reviewable Linux and Windows packaged launcher fixture bundles under
  `packages/parity-fixtures`.
- Updated `packages/parity/README.md` with the two new evidence commands while
  leaving `packages/parity/status.tsv` unchanged for Phase 30.

## Task Commits

Final wrapper commit pending clean phase verification.

## Files Created/Modified

- `packages/parity/compare_packaged_launcher.sh` - shared packaged launcher
  parity comparator.
- `packages/parity/BUILD.bazel` - wires the Linux and Windows packaged parity
  labels.
- `packages/parity/README.md` - documents the new commands and keeps status
  publication deferred.
- `packages/parity-fixtures/BUILD.bazel` - exports packaged launcher fixture
  aliases and filegroups.
- `packages/parity-fixtures/linux-packaged-launcher/*` - Linux package layout,
  scope-note, and README fixtures.
- `packages/parity-fixtures/windows-packaged-launcher/*` - Windows package
  layout, scope-note, and README fixtures.

## Decisions Made

- A single comparator is clearer than duplicating the existing runtime parity
  scripts because only the builder invocation and package startup path differ
  by platform.
- The package layout fixtures stay platform-specific because Linux and Windows
  intentionally expose different package shapes.
- Existing shared help/version/config/export/transform fixtures remain the
  behavior source of truth.

## Deviations from Plan

None - plan executed as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 30 can publish packaging visibility and docs using the new Linux and
Windows packaged launcher parity commands as the evidence source.

---

*Phase: 29-cross-platform-packaging-evidence*
*Completed: 2026-05-23*
