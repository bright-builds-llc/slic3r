---
phase: 32-vendor-source-manifest-and-license-baseline
plan: "01"
subsystem: vendor-source-intake
tags: [bazel, bash, git-ls-remote, tsv, license-provenance]

requires:
  - phase: 32-vendor-source-manifest-and-license-baseline
    provides: "Phase context and research for fork vendor source pins"
provides:
  - "Metadata-only fork vendor registry for PrusaSlicer, Bambu Studio, and OrcaSlicer"
  - "Bazel-owned verifier for selected tag refs and peeled commits"
  - "Maintainer-facing docs boundary for vendor intake evidence and deferred fork parity"
affects: [phase-33-fork-inventories, phase-36-parity-templates, docs-port]

tech-stack:
  added: []
  patterns:
    - "Fixed-column TSV registry validated by Bash before Git network checks"
    - "Branch heads reported as warning-only drift observations"
    - "SPDX license identifiers kept separate from provenance and non-free plugin cautions"

key-files:
  created:
    - packages/fork-vendors/BUILD.bazel
    - packages/fork-vendors/forks.tsv
    - packages/fork-vendors/verify_forks.sh
    - packages/fork-vendors/verify_forks_test.sh
    - packages/fork-vendors/README.md
  modified:
    - docs/port/README.md
    - docs/port/package-map.md

key-decisions:
  - "Keep fork vendor intake metadata separate from packages/parity so source pins do not imply verified runtime parity."
  - "Use git ls-remote for tag and HEAD observation without cloning or importing upstream source trees."
  - "Treat refresh_command as display-only and construct verifier Git calls from validated fields."

patterns-established:
  - "Fork vendor rows use 21 literal-tab-delimited columns with semicolon multi-value fields and - for empty optional scalars."
  - "Verifier tests mock git ls-remote through PATH to prove validation, mismatch, branch-drift, and refresh-command behavior without network calls."

requirements-completed: [VEND-01, VEND-02, VEND-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 32-2026-05-26T16-14-55
generated_at: 2026-05-26T16:58:07Z

duration: 11min
completed: 2026-05-26
---

# Phase 32 Plan 01: Vendor Source Manifest and License Baseline Summary

**Metadata-only fork vendor registry with Git ref verification and license/provenance caution boundaries**

## Performance

- **Duration:** 11 min
- **Started:** 2026-05-26T16:47:21Z
- **Completed:** 2026-05-26T16:58:07Z
- **Tasks:** 3
- **Files modified:** 7

## Accomplishments

- Added `packages/fork-vendors/forks.tsv` with one source, branch, lineage,
  source path, refresh, SPDX, license source, attribution, provenance, and
  caution row each for PrusaSlicer, Bambu Studio, and OrcaSlicer.
- Added `bazel run //packages/fork-vendors:verify`, backed by
  `verify_forks.sh`, to validate selected tag refs and peeled commits through
  `git ls-remote` without cloning or vendoring upstream source trees.
- Published the docs boundary in `docs/port/README.md`,
  `docs/port/package-map.md`, and `packages/fork-vendors/README.md`, preserving
  the intake-only, branch-drift-only, not-legal-review, and no fork parity scope.

## Task Commits

1. **Task 1: Create the fork vendor registry package boundary** - `af16d4373` (feat)
2. **Task 2 RED: Add failing verifier behavior tests** - `a610b32cd` (test)
3. **Task 2 GREEN: Implement the Git ref verifier** - `72a6fbb58` (feat)
4. **Task 3: Publish the maintainer-facing docs boundary** - `b41c954b4` (docs)

## Files Created/Modified

- `packages/fork-vendors/BUILD.bazel` - Bazel package boundary, verifier target,
  test target, and package filegroup.
- `packages/fork-vendors/forks.tsv` - 21-column vendor source and
  license/provenance registry.
- `packages/fork-vendors/verify_forks.sh` - Bash verifier for TSV validation,
  selected tag refs, peeled commits, and warning-only branch drift.
- `packages/fork-vendors/verify_forks_test.sh` - Mocked Git behavior tests for
  validation, mismatch, drift, and display-only refresh commands.
- `packages/fork-vendors/README.md` - Package-local maintainer command,
  delimiter rules, display-only refresh note, and scope cautions.
- `docs/port/README.md` - Port-level fork vendor intake state.
- `docs/port/package-map.md` - Package ownership row and deferred scope note.

## Decisions Made

- Kept `packages/BUILD.bazel` and `packages/parity/status.tsv` unchanged so
  vendor intake remains separate from parity evidence.
- Added a package-local `sh_test` target for verifier behavior because Task 2
  was explicitly TDD and needed a repeatable RED/GREEN proof.
- Used warning-only branch drift output while keeping selected tag and peeled
  commit mismatches as failing conditions.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Corrected fake Git argument parsing in verifier tests**
- **Found during:** Task 2 (Implement the Git ref verifier)
- **Issue:** The RED test harness shifted fake `git` arguments before checking
  the command and mode, so valid verifier behavior could fail for the wrong
  reason.
- **Fix:** Captured the command before shifting and read `mode`/`repo` from the
  corrected positions.
- **Files modified:** `packages/fork-vendors/verify_forks_test.sh`
- **Verification:** `bash packages/fork-vendors/verify_forks_test.sh` and
  `bazel test //packages/fork-vendors:verify_forks_test` passed.
- **Committed in:** `72a6fbb58`

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** The fix kept the TDD guard accurate and did not expand the
production scope.

## Issues Encountered

- A shell temp-file spot check initially used a zsh read-only variable name and
  left generated root-level `.out`, `.err`, and `forks.tsv` files. Those
  generated files were removed before continuing.

## Known Stubs

None.

## Threat Flags

None - the new TSV-to-shell, Git remote, metadata interpretation, and
non-free/network-plugin caution surfaces were all covered by the plan threat
model.

## Verification

- `bash -n packages/fork-vendors/verify_forks.sh`
- `bash -n packages/fork-vendors/verify_forks_test.sh`
- `bazel test //packages/fork-vendors:verify_forks_test`
- `bazel run //packages/fork-vendors:verify`
- `awk -F '\t' 'BEGIN { bad=0 } /^#/ || NF == 0 { next } NF != 21 { print "bad column count " NR ":" NF; bad=1 } END { exit bad }' packages/fork-vendors/forks.tsv`
- `rg -n 'packages/fork-vendors/forks.tsv|//packages/fork-vendors:verify|metadata-only-not-legal-review|do not mark fork parity as verified' packages/fork-vendors/README.md docs/port/README.md docs/port/package-map.md`
- `git diff --check -- packages/fork-vendors/BUILD.bazel packages/fork-vendors/README.md packages/fork-vendors/forks.tsv packages/fork-vendors/verify_forks.sh docs/port/README.md docs/port/package-map.md`

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 33 can consume the checked-in source registry and release-pin verifier as
the vendor source baseline for fork feature inventories. Runtime fork parity,
fork-flavor builds, online integrations, non-free plugin ingestion, and full
drift-refresh templates remain deferred to later phases.

## Self-Check: PASSED

- Created files verified on disk.
- Task commits verified in git history: `af16d4373`, `a610b32cd`,
  `72a6fbb58`, and `b41c954b4`.
- `summary-extract` reads `requirements-completed` as `VEND-01`, `VEND-02`,
  and `VEND-03`.

*Phase: 32-vendor-source-manifest-and-license-baseline*
*Completed: 2026-05-26*
