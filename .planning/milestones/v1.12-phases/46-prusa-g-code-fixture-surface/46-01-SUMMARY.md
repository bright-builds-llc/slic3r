---
phase: 46-prusa-g-code-fixture-surface
plan: "01"
subsystem: parity-fixtures
tags: [prusaslicer, gcode-output, fixtures, provenance, expected-artifact]
requires:
  - phase: 45-prusa-g-code-output-scope-gate
    provides: "Reviewed `prusaslicer.gcode-output` scope gate and exact expected-summary contract"
provides:
  - "Source-pinned Prusa G-code fixture namespace"
  - "Four-line ASCII LF `gcodewriter-set-speed.gcode` fixture with byte count and SHA-256 provenance"
  - "Summary-only `expected-gcode-summary.tsv` artifact for Phase 47 parsing"
affects: [46-prusa-g-code-fixture-surface, 47-rust-prusa-g-code-summary-boundary, 48-executable-prusa-g-code-evidence]
tech-stack:
  added: []
  patterns:
    - "Source-controlled upstream test-literal G-code fixture with exact byte/hash provenance"
    - "Seven-column summary-only expected artifact separated from provenance metadata"
key-files:
  created:
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/.gitattributes
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv
  modified: []
key-decisions:
  - "Used the accepted PrusaSlicer set_speed expected-output literals because the accepted upstream tree has no checked-in `.gcode` blob."
  - "Kept byte count, SHA-256, upstream URL, and update-route facts in provenance rather than the expected summary."
  - "Kept the expected artifact to the exact Phase 45 seven-column metadata and marker schema with no broad G-code parity claims."
patterns-established:
  - "G-code fixture provenance records source identity, update route, privacy/post-processing exclusions, and broad deferrals before Rust parsing consumes the artifact."
  - "Expected G-code summary rows name only stable source and feedrate markers while deferring motion, extrusion, timing, and printability semantics."
requirements-completed: [PGFIX-01]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 46-2026-06-13T16-58-19
generated_at: 2026-06-13T18:04:23Z
duration: "13 min"
completed: 2026-06-13
---

# Phase 46 Plan 01: Prusa G-code Fixture Surface Summary

**Source-pinned Prusa G-code fixture namespace with provenance and a summary-only expected marker artifact**

## Performance

- **Duration:** 13 min
- **Started:** 2026-06-13T17:50:49Z
- **Completed:** 2026-06-13T18:04:23Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments

- Created `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` with LF-enforced text handling for `.gcode`, TSV, and README files.
- Added the exact four-line ASCII LF `gcodewriter-set-speed.gcode` fixture with byte count `42` and SHA-256 `dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb`.
- Added source-pinned provenance tracing the fixture to `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, upstream `tests/fff_print/test_gcodewriter.cpp#L20-L35`, the Phase 45 scope record, and the reviewed intake update route.
- Added `expected-gcode-summary.tsv` with the exact seven Phase 45 columns, one source-identity row, four feedrate marker rows, and no provenance-only or broad parity fields.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create source-pinned fixture namespace and provenance** - `aae5bb873` (`feat`)
2. **Task 2: Add summary-only expected G-code artifact** - `68a2dd6a2` (`feat`)

## Files Created/Modified

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/.gitattributes` - Enforces LF text handling for G-code, TSV, and README files in the namespace.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md` - Documents provenance, update route, Phase 46-only boundary, and deferred scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode` - Four-line source-controlled `GCodeWriter::set_speed` expected-output fixture.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv` - Records source identity, byte count, SHA-256, update route, privacy/post-processing exclusions, and broad deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` - Records summary-only source and feedrate marker rows for Phase 47 parsing.

## Decisions Made

- Used the derived upstream test-literal fixture rather than a copied upstream `.gcode` blob because the accepted source tree has no checked-in `.gcode` files.
- Preserved the Phase 45 `expected-gcode-summary.tsv` schema exactly: `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`, `marker_key`, `marker_value`, and `notes`.
- Kept executable parity, Rust parsing, status publication, generated-output parity, geometry, extrusion, timing, support, wall seam, arc, runtime, firmware, GUI, host upload, network/device, Bambu Studio, OrcaSlicer, upstream source import, and sync claims deferred.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## Known Stubs

None - stub scan found no TODO/FIXME/placeholder text or hardcoded empty UI-data patterns in files created by this plan.

## Auth Gates

None.

## Verification

- `test "$(wc -c < packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode | tr -d ' ')" = "42"`
- `test "$(shasum -a 256 packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode | awk '{ print $1 }')" = "dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb"`
- `LC_ALL=C awk 'index($0, "\r") || $0 !~ /^[ -~]*$/ { exit 1 }' packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`
- `head -n 1 packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv | grep -Fx $'source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes'`
- `test "$(wc -l < packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv | tr -d ' ')" = "2"`
- `test "$(wc -l < packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv | tr -d ' ')" = "6"`
- `awk -F '\t' 'NF != 7 { exit 1 }' packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
- `! rg -n 'bytes|sha256|status row|prusaslicer_gcode_output_parity|geometry count|extrusion total|print duration' packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
- `mdformat --check packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
- `git diff --check -- packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output`
- `git diff --check HEAD~2..HEAD -- packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output`
- Before each task commit: `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- Before each task commit: `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- Before each task commit: `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- Before each task commit: `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`

## User Setup Required

None - all evidence uses checked-in files and local CLI verification.

## Next Phase Readiness

Plan 46-02 can add the repo-owned fixture verifier, mutation tests, Bazel wiring, and Phase 45 scope-verifier reconciliation around this checked-in fixture namespace. Phase 47 Rust summary parsing and Phase 48 executable parity/status publication remain intentionally unavailable.

## Self-Check: PASSED

- Created summary file found: `.planning/phases/46-prusa-g-code-fixture-surface/46-01-SUMMARY.md`.
- Created fixture files found under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
- Task commits found in git history: `aae5bb873` and `68a2dd6a2`.
- Summary frontmatter includes `requirements-completed: [PGFIX-01]`, `lifecycle_mode: yolo`, and `phase_lifecycle_id: 46-2026-06-13T16-58-19`.
- Summary `git diff --check` passed.

---
*Phase: 46-prusa-g-code-fixture-surface*
*Completed: 2026-06-13*
