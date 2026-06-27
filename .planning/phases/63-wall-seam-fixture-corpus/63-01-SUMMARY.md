---
phase: 63-wall-seam-fixture-corpus
plan: "01"
subsystem: parity-fixtures
tags: [bazel, fixtures, prusaslicer, wall-seam, tsv, gcode]

# Dependency graph
requires:
  - phase: 62-wall-seam-scope-contract
    provides: Reviewed PrusaSlicer wall-seam scope contract and approved summary fields
provides:
  - Source-pinned `prusaslicer.wall-seam` fixture namespace
  - Ordered checked-in wall-seam expected summary TSV
  - Bazel aliases and `prusa_wall_seam_bundle` ownership
affects: [64-wall-seam-rust-boundary, 65-wall-seam-executable-evidence]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Flat Prusa fixture namespace with exact ASCII/LF fixture bytes
    - Long-row expected wall-seam summary TSV with explicit evidence boundaries
    - Bazel file aliases plus bundle ownership before verifier/public status work

key-files:
  created:
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/.gitattributes
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/README.md
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv
  modified:
    - packages/parity-fixtures/BUILD.bazel

key-decisions:
  - "Used the dedicated `prusaslicer.wall-seam` fixture namespace so wall-seam evidence stays separate from existing G-code output and arc-fitting rows."
  - "Kept Phase 63 to checked-in fixture artifacts and Bazel ownership only; verifier, Rust parser, public parity command, status row, and public docs remain Phase 63 plan 02 or later work."
  - "Exposed wall-seam artifacts through aliases and `prusa_wall_seam_bundle` without adding forbidden public parity or status labels."

patterns-established:
  - "Wall-seam summary rows follow the Phase 62 field order exactly with one long-row TSV entry per approved field."
  - "Fixture provenance pins source ref, source path, source anchors, bytes, SHA-256, update route, exclusions, and broad deferrals in one inspectable row."

requirements-completed: [SEAMFIX-01, SEAMFIX-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 63-2026-06-26T23-55-59
generated_at: 2026-06-27T00:41:39Z

# Metrics
duration: 5 min
completed: 2026-06-27
---

# Phase 63 Plan 01: Wall-Seam Fixture Corpus Summary

**Source-pinned PrusaSlicer wall-seam fixture namespace with ordered checked-in summary rows and Bazel bundle ownership**

## Performance

- **Duration:** 5 min
- **Started:** 2026-06-27T00:36:05Z
- **Completed:** 2026-06-27T00:41:39Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments

- Created `prusaslicer.wall-seam` as a separate source-pinned fixture namespace with LF policy, README, fixture bytes, provenance, and expected summary.
- Added the exact 360-byte `wall-seam-observations.gcode` fixture and locked it to SHA-256 `9a6306f382e64365ec6e11952f360195bca37fa442f29c7c7f616e1705a6bdad`.
- Added `expected-wall-seam-summary.tsv` with exactly the twelve Phase 62 approved wall-seam fields in order.
- Exposed the wall-seam artifacts through Bazel exports, public aliases, `package_boundary`, and `prusa_wall_seam_bundle`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create source-pinned wall-seam namespace artifacts** - `b5ffa5e0f` (feat)
2. **Task 2: Add Bazel aliases and bundle ownership for wall-seam artifacts** - `d5224cac1` (feat)

## Files Created/Modified

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/.gitattributes` - LF policy for wall-seam fixture artifacts.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/README.md` - Namespace-local documentation, update route, Phase 64/65 handoff, and deferral boundary.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode` - Small checked-in wall-seam observation fixture.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv` - Ordered Phase 62 wall-seam summary handoff artifact.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv` - Source-pinned fixture provenance, checksum, exclusions, and deferrals.
- `packages/parity-fixtures/BUILD.bazel` - Bazel exports, aliases, package boundary entries, and `prusa_wall_seam_bundle`.

## Decisions Made

- Used a new `prusaslicer.wall-seam` namespace instead of widening `prusaslicer.gcode-output` or `prusaslicer.arc-fitting`.
- Kept public parity status, public parity command, Rust parser references, and verifier targets out of this plan, matching the Phase 63 plan 01 boundary.
- Mirrored the established Prusa fixture bundle pattern with source-specific aliases and one public filegroup.

## Automated Checks

- `wc -c` verified `wall-seam-observations.gcode` is exactly `360` bytes.
- `shasum -a 256` verified fixture SHA-256 `9a6306f382e64365ec6e11952f360195bca37fa442f29c7c7f616e1705a6bdad`.
- `wc -l` verified `expected-wall-seam-summary.tsv` has exactly `13` lines and `fixture-provenance.tsv` has exactly `2` lines.
- `awk` verified the twelve approved wall-seam fields are in the required Phase 62 order.
- `bazel query //packages/parity-fixtures:prusa_wall_seam_bundle` passed.
- `bazel query //packages/parity-fixtures:prusa_wall_seam_expected_wall_seam_summary` passed.
- `git diff --check -- packages/parity-fixtures` passed.
- `awk` verified `packages/parity/status.tsv` still has zero `fork.prusaslicer.wall-seam` rows.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Ready for plan 63-02 to add fail-closed wall-seam fixture verification and mutation coverage over the checked-in namespace and Bazel bundle.

## Self-Check: PASSED

- Confirmed all key files exist on disk.
- Confirmed task commits `b5ffa5e0f` and `d5224cac1` are present in git history.
- Confirmed summary whitespace check passes.

---
*Phase: 63-wall-seam-fixture-corpus*
*Completed: 2026-06-27*
