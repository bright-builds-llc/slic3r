---
phase: 52-executable-structural-g-code-evidence
plan: "02"
subsystem: parity
tags: [bazel, bash, prusaslicer, gcode, structural-summary]

requires:
  - phase: 52-executable-structural-g-code-evidence
    provides: Plan 52-01 Rust `--structural` summary-binary mode over the typed structural parser
provides:
  - Public `//packages/parity:prusaslicer_gcode_output_parity` command validation for both summary and structural sidecar evidence through Rust
  - Maintainer-readable structural evidence output for row count, command counts, markers, movement/extrusion flags, and temperature/tool-change counts
  - Command-level `command_count_g1` structural mutation guard for the public comparator
affects:
  - 52-executable-structural-g-code-evidence
  - packages/parity

tech-stack:
  added: []
  patterns:
    - Bash comparator validates original and expected summary/structural artifacts through the same Rust summary binary
    - Bazel public parity command passes separate Rust input and expected artifact paths so mutation tests can fail closed

key-files:
  created:
    - .planning/phases/52-executable-structural-g-code-evidence/52-02-SUMMARY.md
  modified:
    - packages/parity/BUILD.bazel
    - packages/parity/compare_prusaslicer_gcode_output.sh
    - packages/parity/compare_prusaslicer_gcode_output_test.sh

key-decisions:
  - "Kept the existing public Prusa G-code parity target while adding structural sidecar validation."
  - "Used the existing Rust summary binary's `--structural` mode for public structural validation instead of adding a new comparator binary."
  - "Added exactly one command-level structural mutation guard for `command_count_g1` drift."

patterns-established:
  - "Public G-code parity evidence now compares Rust-generated summary lines for both checked-in summary and structural artifacts."
  - "Structural mismatch diagnostics label the raw structural field from TSV column 3 so command-level failures name fields such as `command_count_g1`."

requirements-completed: [GCEV-01, GCEV-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 52-2026-06-18T01-09-43
generated_at: 2026-06-18T02:23:24Z

duration: 8min
completed: 2026-06-18
---

# Phase 52 Plan 02: Public Structural G-code Evidence Summary

**Public Prusa G-code parity now validates the structural sidecar through Rust and fails closed on `command_count_g1` drift**

## Performance

- **Duration:** 8 min
- **Started:** 2026-06-18T02:14:41Z
- **Completed:** 2026-06-18T02:23:24Z
- **Tasks:** 2
- **Files modified:** 3 implementation/test files plus this summary

## Accomplishments

- Extended `//packages/parity:prusaslicer_gcode_output_parity` to pass the checked-in structural sidecar into the comparator.
- Updated the public comparator to validate both `expected-gcode-summary.tsv` and `expected-gcode-structural-summary.tsv` through the Rust summary binary.
- Added structural success output for the sidecar path, row count, command counts, ordered markers, movement/extrusion indicators, and temperature/tool-change marker counts.
- Added TDD coverage proving a `command_count_g1` mutation fails the public comparator with diagnostics naming the structural artifact and field.

## Task Commits

1. **Task 1: Wire structural sidecar into the public comparator target** - `dc2b906a3` (feat)
2. **Task 2 RED: Add failing structural G-code drift guard** - `476649595` (test)
3. **Task 2 GREEN: Wire structural G-code drift guard** - `5748eefdf` (test)

## Files Created/Modified

- `packages/parity/BUILD.bazel` - Added structural sidecar data and six-argument public comparator wiring.
- `packages/parity/compare_prusaslicer_gcode_output.sh` - Added structural Rust validation, structural diffing, exact structural assertions, and maintainer-readable structural output.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh` - Added the `command_count_g1` mutation guard while preserving the existing `line_4` summary mutation guard.

## Verification

- `bash -n packages/parity/compare_prusaslicer_gcode_output.sh`
- `bash -n packages/parity/compare_prusaslicer_gcode_output_test.sh`
- `shfmt -l -d packages/parity/compare_prusaslicer_gcode_output.sh`
- `shfmt -l -d packages/parity/compare_prusaslicer_gcode_output_test.sh`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test`
- `bazel test --cache_test_results=no //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test //packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check`
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel run //packages/prusa-gcode-output-scope:verify`
- `cargo +1.94.1 fmt --all`
- `cargo +1.94.1 clippy --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --all-targets --all-features`
- `cargo +1.94.1 test --all-features`
- `git diff --check`

## Decisions Made

- Kept the public evidence surface on `//packages/parity:prusaslicer_gcode_output_parity` per D-01.
- Kept public evidence checked-in only: the comparator invokes the Rust summary binary over checked-in TSV artifacts and does not generate G-code or run PrusaSlicer.
- Added only the planned `command_count_g1` command-level structural mutation guard, leaving broader parser and fixture rejection matrices to Phase 50 and Phase 51 coverage.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None.

## Issues Encountered

None. Task 2 RED failed as expected with `FAIL: mutated expected-gcode-structural-summary.tsv passed` before the GREEN harness change passed the mutated structural artifact into the comparator.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 52-03 can publish the structural status wording and reconcile fixture verifier enforcement using the now-executable public structural command and mutation guard.

---
*Phase: 52-executable-structural-g-code-evidence*
*Completed: 2026-06-18*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/52-executable-structural-g-code-evidence/52-02-SUMMARY.md`.
- Task commits exist in git history: `dc2b906a3`, `476649595`, and `5748eefdf`.
- `summary-extract` parsed the frontmatter and returned `requirements_completed: ["GCEV-01", "GCEV-02"]`.
- `git diff --check` passes for this summary.
