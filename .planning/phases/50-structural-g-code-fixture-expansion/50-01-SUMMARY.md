---
phase: 50-structural-g-code-fixture-expansion
plan: "01"
subsystem: parity-fixtures
tags: [bazel, tsv, markdown, prusaslicer, gcode]

requires:
  - phase: 49-structural-g-code-scope-contract
    provides: Closed 16-field structural G-code scope contract
provides:
  - Source-pinned structural expected-summary sidecar for the accepted Prusa set_speed fixture
  - Bazel ownership label, bundle membership, export, and package-boundary wiring for the structural TSV
  - Narrow fixture/package README discoverability for the Phase 50 sidecar
affects:
  - 51-structural-g-code-rust-boundary
  - 52-structural-g-code-public-evidence

tech-stack:
  added: []
  patterns:
    - Separate structural fixture sidecar beside the existing summary-only artifact
    - Bazel fixture ownership through exports, alias, bundle, verifier data, and package boundary

key-files:
  created:
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv
  modified:
    - packages/parity-fixtures/BUILD.bazel
    - packages/parity-fixtures/README.md
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md

key-decisions:
  - "Kept the Phase 50 structural data in a separate TSV sidecar so v1.12 summary-only consumers remain unchanged."
  - "Wired the sidecar into the existing parity-fixtures Bazel ownership surfaces instead of adding a new verifier target."
  - "Limited README updates to fixture inspectability and explicitly deferred Rust structural parsing and public structural parity/status publication."

patterns-established:
  - "Structural fixture sidecars mirror the Phase 49 closed field set exactly and avoid file-integrity or public-status metadata."
  - "Fixture-level structural evidence is made Bazel-owned before later Rust parsing or public parity/status phases consume it."

requirements-completed:
  - GCFIX-01
  - GCFIX-02
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 50-2026-06-17T16-13-19
generated_at: 2026-06-17T16:59:42Z

duration: 4min
completed: 2026-06-17
---

# Phase 50 Plan 01: Structural G-code Fixture Sidecar Summary

**Source-pinned structural G-code sidecar with Bazel fixture ownership and narrow README discoverability**

## Performance

- **Duration:** 4 min
- **Started:** 2026-06-17T16:55:56Z
- **Completed:** 2026-06-17T16:59:42Z
- **Tasks:** 2
- **Files modified:** 4 implementation files plus this summary

## Accomplishments

- Added `expected-gcode-structural-summary.tsv` with the exact six-column schema and all 16 Phase 49 structural fields.
- Exposed the structural TSV through `packages/parity-fixtures` exports, alias, `prusa_gcode_output_bundle`, verifier/test runfiles, and `package_boundary`.
- Updated the fixture and package READMEs to make the sidecar inspectable while keeping Rust structural parsing Phase 51-owned and public structural parity/status Phase 52-owned.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add the exact structural sidecar TSV** - `03bf95678` (feat)
2. **Task 2: Wire Bazel ownership and narrow docs** - `6d48ff8d2` (feat)

## Files Created/Modified

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv` - Structural expected-summary sidecar for the accepted Prusa set_speed fixture.
- `packages/parity-fixtures/BUILD.bazel` - Bazel export, alias, bundle, verifier data, test data, and package-boundary ownership for the structural TSV.
- `packages/parity-fixtures/README.md` - Package-level note for the Phase 50 structural sidecar and deferred parser/status ownership.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md` - Fixture-local provenance, artifact, and status-boundary notes for the structural sidecar.

## Verification

- `head -n 1 .../expected-gcode-structural-summary.tsv | grep -Fx $'source_ref\tfixture_path\tstructural_field\tstructural_category\tstructural_value\tevidence_boundary'`
- `awk -F '\t' ... expected-gcode-structural-summary.tsv`
- `! rg -n 'sha256|bytes|reviewed-intake|fork\.prusaslicer\.gcode-output|generated-outputs|prusaslicer_gcode_output_parity' expected-gcode-structural-summary.tsv`
- `bazel query //packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary`
- `bazel query 'labels(srcs, //packages/parity-fixtures:prusa_gcode_output_bundle)' | rg 'expected-gcode-structural-summary.tsv'`
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`
- `mdformat --check packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
- `test -z "$(git diff --name-only -- packages/parity packages/slic3r-rust)"`
- `git diff --check -- packages/parity-fixtures/BUILD.bazel packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`

## Decisions Made

- Followed the plan's split-artifact approach so the existing `expected-gcode-summary.tsv`, Phase 48 parity target, public status row, and Rust summary parser stay unchanged.
- Used existing Bazel fixture ownership surfaces instead of adding a new verifier target in this plan.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None.

## Issues Encountered

None in plan execution. `.planning/STATE.md` was already modified before implementation and was intentionally left untouched because orchestration owns state updates.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 51 can consume the checked-in structural TSV through a typed Rust boundary. The public structural parity/status publication remains deferred to Phase 52.

---
*Phase: 50-structural-g-code-fixture-expansion*
*Completed: 2026-06-17*

## Self-Check: PASSED

- Created files exist: structural TSV and `50-01-SUMMARY.md`.
- Task commits exist in git history: `03bf95678` and `6d48ff8d2`.
- Summary frontmatter parses with `frontmatter get`.
- `summary-extract` returns `GCFIX-01,GCFIX-02` for `requirements-completed`.
- `git diff --check` passes for this summary.
