---
phase: 52-executable-structural-g-code-evidence
plan: "01"
subsystem: rust
tags: [rust, bazel, prusaslicer, gcode, structural-summary]

requires:
  - phase: 51-rust-structural-g-code-summary-boundary
    provides: Pure typed structural parser and readiness metadata for the Phase 50 structural sidecar
provides:
  - Rust structural summary-lines helper over the typed Prusa G-code structural parser
  - Compatibility-preserving `--structural` mode for the existing `prusa_gcode_output_summary` binary
  - Cargo and Bazel coverage for structural helper output and CLI mode behavior
affects:
  - 52-executable-structural-g-code-evidence
  - packages/parity

tech-stack:
  added: []
  patterns:
    - Pure Rust fact projection from typed structural parser output into stable tab-delimited lines
    - Thin CLI adapter dispatching summary versus structural parse modes over caller-supplied files

key-files:
  created:
    - .planning/phases/52-executable-structural-g-code-evidence/52-01-SUMMARY.md
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs
    - packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs

key-decisions:
  - "Extended the existing G-code summary binary with explicit `--structural` mode instead of adding a second binary."
  - "Kept structural CLI behavior limited to caller-supplied local file reads through the Rust parser boundary."

patterns-established:
  - "Structural sidecar facts are projected through `prusa_gcode_output_structural_summary_lines` before public parity command integration."
  - "The summary binary keeps one-path summary mode and uses an explicit mode flag for structural evidence."

requirements-completed: [GCEV-01]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 52-2026-06-18T01-09-43
generated_at: 2026-06-18T02:09:13Z

duration: 6min
completed: 2026-06-18
---

# Phase 52 Plan 01: Rust Structural Summary Adapter Summary

**Rust structural G-code sidecar facts now flow through a tested helper and an explicit summary-binary mode**

## Performance

- **Duration:** 6 min
- **Started:** 2026-06-18T02:02:29Z
- **Completed:** 2026-06-18T02:09:13Z
- **Tasks:** 2
- **Files modified:** 4 implementation/test files plus this summary

## Accomplishments

- Added `prusa_gcode_output_structural_summary_lines`, which parses the structural TSV through `parse_prusa_gcode_output_structural_summary` and emits stable maintainer-facing facts.
- Re-exported the structural summary-lines helper from `slic3r_flavors`.
- Added an explicit `--structural expected-gcode-structural-summary.tsv` mode to the existing Rust summary binary while preserving one-argument summary behavior.
- Added TDD coverage for exact structural summary output, malformed `command_count_g1` rejection, summary-mode binary behavior, structural-mode binary behavior, and invalid argument usage text.

## Task Commits

1. **Task 1 RED: Add failing structural summary lines tests** - `f6a723404` (test)
2. **Task 1 GREEN: Add structural summary lines helper** - `4f1ce0f83` (feat)
3. **Task 2 RED: Add failing tests for structural CLI mode** - `084ed18de` (test)
4. **Task 2 GREEN: Add structural mode to G-code summary binary** - `2a4e6bf16` (feat)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - Structural summary-lines helper over typed structural facts.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - Public re-export for the helper.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs` - Summary/structural mode dispatch and usage text.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` - Helper and binary behavior coverage.

## Verification

- `cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml`
- `bazel test --cache_test_results=no //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test`
- `rg -n "pub fn prusa_gcode_output_structural_summary_lines" packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`
- `rg -n "prusa_gcode_output_structural_summary_lines" packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`
- `rg -n "structural_row_count|command_count_g1|ordered_marker_4|temperature_marker_count|tool_change_marker_count" packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`
- `rg -n -- "--structural|expected-gcode-structural-summary.tsv|prusa_gcode_output_structural_summary_lines" packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
- `bazel run //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary -- $(pwd)/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
- `bazel run //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary -- --structural $(pwd)/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
- `bazel test --cache_test_results=no //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check`
- `cargo +1.94.1 fmt --all`
- `cargo +1.94.1 clippy --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --all-targets --all-features`
- `cargo +1.94.1 test --all-features`
- `git diff --check`

## Decisions Made

- Extended the existing binary with `--structural` to preserve the public integration point for later parity command wiring with minimal Bazel churn.
- Kept filesystem access only in the thin CLI adapter; structural validation remains in pure Rust parser/fact projection code.

## Deviations from Plan

None - plan executed exactly as written.

## Known Stubs

None.

## Issues Encountered

None. TDD RED failures occurred as expected before implementation and passed after the GREEN changes.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 52-02 can wire the public `//packages/parity:prusaslicer_gcode_output_parity` command to call summary mode and `--structural` mode, then add the structural mutation guard for `command_count_g1`.

---
*Phase: 52-executable-structural-g-code-evidence*
*Completed: 2026-06-18*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/52-executable-structural-g-code-evidence/52-01-SUMMARY.md`.
- Task commits exist in git history: `f6a723404`, `4f1ce0f83`, `084ed18de`, and `2a4e6bf16`.
- `summary-extract` parsed the frontmatter and returned `requirements_completed: ["GCEV-01"]`.
- `git diff --check` passes for this summary.
