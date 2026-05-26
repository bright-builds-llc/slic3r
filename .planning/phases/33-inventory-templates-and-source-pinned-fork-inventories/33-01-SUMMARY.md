---
phase: 33-inventory-templates-and-source-pinned-fork-inventories
plan: "01"
subsystem: fork-inventory-intake
tags: [bazel, bash, tsv, fork-inventory, source-pins]

requires:
  - phase: 32-vendor-source-manifest-and-license-baseline
    provides: "Selected stable tags, peeled commits, vendor IDs, lineage, and caution metadata for downstream fork intake"
provides:
  - "Reusable fork feature inventory TSV contract"
  - "Source-pinned PrusaSlicer, Bambu Studio, and OrcaSlicer inventory TSVs"
  - "Exact-once cross-fork category map for inventory row grouping"
  - "Bazel-owned verifier and behavior tests for inventory contract validation"
  - "Port documentation links for the Phase 33 inventory boundary"
affects: [phase-34-flavor-contracts, phase-35-flavor-registry, phase-36-parity-templates, docs-port]

tech-stack:
  added: []
  patterns:
    - "Fixed-column TSV inventories validated by Bash and Bazel"
    - "Source refs derived from packages/fork-vendors/forks.tsv selected tags and peeled commits"
    - "Category-map inventory IDs validated as exact-once references"
    - "Network/cloud/credential/non-free caution rows forced to deferred inventory-only metadata"

key-files:
  created:
    - packages/fork-inventories/BUILD.bazel
    - packages/fork-inventories/README.md
    - packages/fork-inventories/inventory-template.tsv
    - packages/fork-inventories/prusaslicer.tsv
    - packages/fork-inventories/bambustudio.tsv
    - packages/fork-inventories/orcaslicer.tsv
    - packages/fork-inventories/category-map.tsv
    - packages/fork-inventories/verify_inventories.sh
    - packages/fork-inventories/verify_inventories_test.sh
  modified:
    - docs/port/README.md
    - docs/port/package-map.md

key-decisions:
  - "Kept fork inventories separate from packages/fork-vendors and packages/parity so source-observed rows do not imply executable parity."
  - "Validated source_ref by deriving the only accepted value from selected_stable_tag and peeled_commit_sha in forks.tsv."
  - "Required every inventory row to appear exactly once in category-map.tsv, with grouped rows sharing category, ownership, and v1.9 decision."
  - "Required restricted network/cloud/credential/non-free caution rows to be deferred and include runtime-parity-not-verified."

patterns-established:
  - "Fork inventory rows use 12 literal-tab-delimited columns with semicolon multi-value fields and no blank required fields."
  - "Verifier behavior tests use temp TSV fixtures to prove pass/fail paths without upstream source access."
  - "Port docs repeat the inventory-only boundary when introducing fork inventory package links."

requirements-completed: [INV-01, INV-02, INV-03, INV-04, INV-05]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 33-2026-05-26T17-23-32
generated_at: 2026-05-26T18:09:24Z

duration: 11min
completed: 2026-05-26
---

# Phase 33 Plan 01: Inventory Templates and Source-Pinned Fork Inventories Summary

**Source-pinned fork inventory TSV package with exact-once category mapping and Bazel verifier**

## Performance

- **Duration:** 11 min
- **Started:** 2026-05-26T17:58:15Z
- **Completed:** 2026-05-26T18:09:24Z
- **Tasks:** 3
- **Files modified:** 11

## Accomplishments

- Added `packages/fork-inventories` with a reusable 12-column inventory
  template, PrusaSlicer/Bambu Studio/OrcaSlicer source-pinned rows, and an
  exact-once cross-fork category map.
- Added `bazel run //packages/fork-inventories:verify` and
  `bazel test //packages/fork-inventories:verify_inventories_test` to validate
  TSV shape, vendor pins, enums, parity dependencies, required coverage,
  category references, and restricted caution rows.
- Updated `docs/port/README.md` and `docs/port/package-map.md` so reviewers can
  find the package and command while preserving the source-observed,
  inventory-only boundary.

## Task Commits

1. **Task 1: Create source-pinned inventory TSVs and package-local contract docs** - `c44d39239` (feat)
2. **Task 2 RED: Add failing verifier behavior tests** - `8d33cc7a3` (test)
3. **Task 2 GREEN: Add Bash verifier, Bazel target, and verifier behavior tests** - `7e31f9367` (feat)
4. **Task 3: Link the inventory boundary from port documentation** - `e8b483b80` (docs)

## Files Created/Modified

- `packages/fork-inventories/BUILD.bazel` - Public package boundary, `verify`
  command, verifier test target, exports, and package filegroup.
- `packages/fork-inventories/README.md` - Maintainer command, schema, enums,
  accepted source-ref rule, category-map contract, and scope cautions.
- `packages/fork-inventories/inventory-template.tsv` - Reusable 12-column
  inventory header contract.
- `packages/fork-inventories/prusaslicer.tsv` - PrusaSlicer source-pinned
  inventory rows, including the deferred Prusa Connect caution row.
- `packages/fork-inventories/bambustudio.tsv` - Bambu Studio source-pinned
  rows for project, profile, network, support, STEP, arc, and assembly surfaces.
- `packages/fork-inventories/orcaslicer.tsv` - OrcaSlicer source-pinned rows
  for calibration, wall/seam, support, adaptive mesh, profile library,
  community-profile, and inherited network/plugin caution metadata.
- `packages/fork-inventories/category-map.tsv` - Cross-fork exact-once mapping
  for every per-fork inventory row.
- `packages/fork-inventories/verify_inventories.sh` - Bash 3.2-compatible TSV
  verifier with local file parsing only.
- `packages/fork-inventories/verify_inventories_test.sh` - Temp-fixture
  behavior tests for valid and invalid inventory cases.
- `docs/port/README.md` - Current fork feature inventory state and verifier
  command.
- `docs/port/package-map.md` - Package ownership row and Phase 33 boundary note.

## Decisions Made

- Used `source_ref` strings in the exact `<vendor_id>:<selected_stable_tag>@<peeled_commit_sha>` form derived from `packages/fork-vendors/forks.tsv`.
- Kept `packages/parity/status.tsv` unchanged; parity dependencies are read as vocabulary, not changed by inventory intake.
- Made the category map stricter than prose by validating unknown, duplicate,
  missing, and mismatched row references.
- Kept non-free/network/plugin/credential surfaces as deferred caution rows
  only, with no runtime fork behavior or upstream source-tree access.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed Bash helper variable leakage and note delimiter validation**
- **Found during:** Task 2 (Add Bash verifier, Bazel target, and verifier behavior tests)
- **Issue:** `bazel run //packages/fork-inventories:verify` exposed that helper
  functions reused global variable names in Bash, producing misleading row
  labels, and the verifier treated prose notes as semicolon-delimited fields.
- **Fix:** Localized helper variables and limited no-spaced-semicolon checks to
  actual list fields (`source_paths`, `parity_dependency`, `caution_flags`, and
  `inventory_ids`).
- **Files modified:** `packages/fork-inventories/verify_inventories.sh`
- **Verification:** Re-ran `bash packages/fork-inventories/verify_inventories_test.sh`,
  `bazel test //packages/fork-inventories:verify_inventories_test`,
  `bazel run //packages/fork-inventories:verify`, and the forbidden-command scan.
- **Committed in:** `7e31f9367`

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** The fix made the planned verifier correctly validate the
checked-in TSVs without changing scope.

## Issues Encountered

- The RED test proof wrapper initially used `status`, a read-only zsh variable
  name. The command was rerun with `exit_code`; no repo files changed for this.

## Known Stubs

None.

## Threat Flags

None - the new TSV parsing, source-ref validation, local shell verifier,
category-map references, documentation interpretation, and
network/cloud/plugin/credential caution surfaces were covered by the plan
threat model.

## Verification

- `bash -n packages/fork-inventories/verify_inventories.sh`
- `bash -n packages/fork-inventories/verify_inventories_test.sh`
- `bash packages/fork-inventories/verify_inventories_test.sh`
- `bazel test //packages/fork-inventories:verify_inventories_test`
- `bazel run //packages/fork-inventories:verify`
- `rg -n "packages/fork-inventories|//packages/fork-inventories:verify|Inventories are source-observed planning inputs only|without fetching, cloning, building, or importing upstream fork source trees" packages/fork-inventories/README.md docs/port/README.md docs/port/package-map.md`
- `git diff --check -- packages/fork-inventories/BUILD.bazel packages/fork-inventories/README.md packages/fork-inventories/inventory-template.tsv packages/fork-inventories/prusaslicer.tsv packages/fork-inventories/bambustudio.tsv packages/fork-inventories/orcaslicer.tsv packages/fork-inventories/category-map.tsv packages/fork-inventories/verify_inventories.sh packages/fork-inventories/verify_inventories_test.sh docs/port/README.md docs/port/package-map.md`

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 34 can consume the checked-in inventory row contract, ownership taxonomy,
source-ref pins, caution flags, and category mapping as maintainer data for
future Rust flavor contracts. Executable fork parity, online/cloud integration,
credential handling, non-free plugin ingestion, and fork-flavor release builds
remain deferred.

## Self-Check: PASSED

- Created and modified files verified on disk.
- Task commits verified in git history: `c44d39239`, `8d33cc7a3`,
  `7e31f9367`, and `e8b483b80`.
- `summary-extract` reads `requirements-completed` as `INV-01`, `INV-02`,
  `INV-03`, `INV-04`, and `INV-05`.
- `git diff --check` passed for `33-01-SUMMARY.md`.

*Phase: 33-inventory-templates-and-source-pinned-fork-inventories*
*Completed: 2026-05-26*
