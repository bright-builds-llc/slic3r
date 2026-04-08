---
phase: 02-legacy-oracle
plan: "03"
subsystem: docs
tags: [legacy-oracle, docs, prerequisites, trusted-oracle-set, deferred-surfaces]
requires:
  - phase: 02-01
    provides: Bazel-wrapped legacy oracle build path and prerequisite gate
  - phase: 02-02
    provides: trusted macOS smoke oracle surface and explicit deferred broader tests
provides:
  - Updated legacy package README with oracle labels and prerequisite guidance
  - `docs/port/` updates describing the trusted oracle set and deferred retained legacy surfaces
  - Aligned control-plane docs for reviewers and contributors
affects: [04-contract-inventory, 07-parity-visibility, 08-differential-parity-harness]
tech-stack:
  added: [phase-2 oracle terminology in docs]
  patterns: [trusted-vs-deferred oracle documentation, reference-only package messaging, prerequisite transparency]
key-files:
  created: []
  modified:
    [
      packages/legacy-slic3r/README.md,
      docs/port/README.md,
      docs/port/checklist.md,
      docs/port/package-map.md,
      docs/port/parity-matrix.md,
    ]
key-decisions:
  - "The trusted macOS oracle set is documented as the smoke path, not the full retained test tree."
  - "Legacy Bazel support is documented as oracle preservation, not renewed legacy investment."
patterns-established:
  - "Port docs explicitly separate trusted retained oracle checks from deferred legacy surfaces."
  - "macOS prerequisites and oracle caveats are visible in both the package README and the port control plane."
requirements-completed: [LEGA-03]
duration: 1 session
completed: 2026-04-07
---

# Phase 02: Legacy Oracle Summary

**Reference-only oracle docs updated to reflect the working macOS smoke path, prerequisites, and deferred broader retained tests**

## Performance

- **Duration:** 1 session
- **Tasks:** 2 documentation tasks
- **Files modified:** package README plus the `docs/port/` control-plane files

## Accomplishments

- Updated the retained legacy package README to document the Bazel oracle surface and the current macOS prerequisites
- Updated `docs/port/README.md` to describe the current Legacy Oracle state and the trusted-vs-deferred distinction
- Updated the checklist, package map, and parity matrix to reflect the actual Phase 2 oracle boundary
- Made the current trusted oracle set explicit: `//:legacy_oracle_smoke` is trusted on macOS, while `//:legacy_oracle_test` is exposed but deferred

## Task Commits

Each task was completed as part of this doc update wave:

1. **Task 1: Document the reference-only oracle boundary and prerequisites** - pending in this summary wave
2. **Task 2: Publish the trusted oracle test set and deferred legacy surfaces** - pending in this summary wave

**Plan metadata:** pending

## Files Created/Modified

- `packages/legacy-slic3r/README.md` - oracle labels, Bazel surfaces, and macOS prerequisite notes
- `docs/port/README.md` - current Legacy Oracle state and trusted/deferred distinction
- `docs/port/checklist.md` - legacy oracle checklist items updated to match reality
- `docs/port/package-map.md` - package role updated with Bazel-wrapped oracle wording
- `docs/port/parity-matrix.md` - retained CLI/launcher oracle notes updated for the trusted smoke path

## Decisions Made

- The docs should describe the actual working oracle set, not the aspirational full retained test tree
- The broader retained legacy test wrapper remains visible but clearly deferred until the XS loader path is stabilized

## Deviations from Plan

- None. The docs now reflect the real Phase 2 oracle state without implying broader coverage than the repo actually has.

## Issues Encountered

- The package and port docs had to distinguish between “Bazel-wrapped” and “trusted oracle” because those are no longer the same thing for the full retained legacy test tree

## User Setup Required

- None beyond the documented macOS prerequisite set already described in the updated docs

---

*Plan: 02-03*
*Summary created: 2026-04-07*
