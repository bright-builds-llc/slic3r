---
phase: 60-executable-arc-fitting-evidence
plan: "01"
subsystem: parity
tags: [rust, bash, bazel, prusaslicer, arc-fitting, evidence]

requires:
  - phase: 59-rust-arc-fitting-evidence-boundary
    provides: Pure Rust arc-fitting parser, summary-line helper, and readiness metadata
provides:
  - Rust `prusa_arc_fitting_summary` binary over `prusa_arc_fitting_summary_lines`
  - Public `//packages/parity:prusaslicer_arc_fitting_parity` command
  - Rust-backed shell comparator for checked-in arc summary evidence
affects:
  - 60-executable-arc-fitting-evidence
  - packages/parity
  - packages/slic3r-rust/crates/slic3r_flavors

tech-stack:
  added: []
  patterns:
    - Thin Rust binary adapter over pure parser summary-line helpers
    - Bazel-owned public parity command that round-trips checked-in arc summary artifacts through Rust
    - Bash comparator assertions over exact approved arc-fitting evidence facts

key-files:
  created:
    - .planning/phases/60-executable-arc-fitting-evidence/60-01-SUMMARY.md
    - packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_arc_fitting_summary.rs
    - packages/parity/compare_prusaslicer_arc_fitting.sh
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
    - packages/parity/BUILD.bazel

key-decisions:
  - "Added a new arc-specific Rust summary binary instead of widening the existing Prusa G-code output summary binary."
  - "Kept public arc-fitting validation inside the Rust `slic3r_flavors` boundary and used Bash only for runfile orchestration, diffs, field assertions, and approved output text."
  - "Published a separate public arc-fitting parity command while preserving the existing Prusa G-code output parity contract."

patterns-established:
  - "Arc-fitting public command uses explicit Bazel runfile arguments for the summary binary, expected summary, and provenance file."
  - "Arc-fitting public output is limited to source, fixture, G2/G3, direction, offset, bounds, extrusion, feedrate, and checked-in-summary boundary facts."

requirements-completed:
  - ARCEV-01
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T16:01:52Z

duration: 7 min
completed: 2026-06-24
---

# Phase 60 Plan 01: Rust-Backed Public Arc-Fitting Evidence Command Summary

**Public Prusa arc-fitting evidence now runs as a Rust-backed Bazel command over the checked-in expected summary**

## Performance

- **Duration:** 7 min
- **Started:** 2026-06-24T15:54:48Z
- **Completed:** 2026-06-24T16:01:52Z
- **Tasks:** 2
- **Files modified:** 4 implementation files plus this summary

## Accomplishments

- Added `prusa_arc_fitting_summary`, a thin Rust CLI that reads one caller-supplied `expected-arc-summary.tsv`, delegates to `prusa_arc_fitting_summary_lines`, prints deterministic summary rows, and rejects wrong arity.
- Wired the Rust binary into Bazel build, clippy, and rustfmt coverage for `slic3r_flavors`.
- Added `compare_prusaslicer_arc_fitting.sh`, a public comparator that validates the checked-in arc summary through Rust, diffs Rust-produced summary lines, asserts the approved arc facts, and prints the exact public command output.
- Added `//packages/parity:prusaslicer_arc_fitting_parity` without modifying the existing Prusa G-code output parity command.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add the prusa_arc_fitting_summary Rust binary** - `4b9d502f3` (feat)
2. **Task 2: Add the public arc-fitting parity command** - `429994605` (feat)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_arc_fitting_summary.rs` - Rust CLI adapter over `prusa_arc_fitting_summary_lines`.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - New Rust binary target plus clippy/rustfmt wiring.
- `packages/parity/compare_prusaslicer_arc_fitting.sh` - Public shell comparator and approved arc-fitting output surface.
- `packages/parity/BUILD.bazel` - New `prusaslicer_arc_fitting_parity` `sh_binary` target and runfile args.

## Verification

- RED Task 1: `bazel query //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary` failed before the target existed.
- RED Task 2: `bazel query //packages/parity:prusaslicer_arc_fitting_parity` failed before the target existed.
- `bazel query //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary`
- `bazel build //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary`
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check --test_output=errors`
- `bazel build //packages/slic3r-rust/crates/slic3r_flavors:clippy`
- `./bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_arc_fitting_summary packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
- `./bazel-bin/packages/slic3r-rust/crates/slic3r_flavors/prusa_arc_fitting_summary` exited nonzero with `error: expected expected-arc-summary.tsv`.
- `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `bash -n packages/parity/compare_prusaslicer_arc_fitting.sh`
- `shfmt -l -d packages/parity/compare_prusaslicer_arc_fitting.sh`
- `shellcheck packages/parity/compare_prusaslicer_arc_fitting.sh`
- `bazel query //packages/parity:prusaslicer_arc_fitting_parity`
- `bazel run //packages/parity:prusaslicer_arc_fitting_parity`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel test //packages/slic3r-rust:verify --test_output=errors`
- `git diff --check -- packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_arc_fitting_summary.rs packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel packages/parity/compare_prusaslicer_arc_fitting.sh packages/parity/BUILD.bazel`
- `git diff --check HEAD~2..HEAD -- packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_arc_fitting_summary.rs packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel packages/parity/compare_prusaslicer_arc_fitting.sh packages/parity/BUILD.bazel`

## Decisions Made

- Added a new arc-specific Rust summary binary instead of extending `prusa_gcode_output_summary`, keeping the arc-fitting evidence command separate from the existing G-code output command.
- Kept Rust as the validation authority for parsed arc facts; Bash only checks files, invokes Rust, diffs summary-line output, asserts exact fields, and prints public facts.
- Preserved `//packages/parity:prusaslicer_gcode_output_parity` unchanged and proved it still passes after adding the separate arc-fitting command.

## Deviations from Plan

### Auto-fixed Issues

None - no implementation deviations were needed.

### Process Adjustments

**1. AGENTS.md pre-commit requirements superseded RED-only TDD commits**
- **Found during:** Task 1 and Task 2
- **Issue:** The plan marked both tasks as TDD, but repo instructions require passing verification before commits, which conflicts with committing failing RED states.
- **Adjustment:** Captured RED failures with the planned `bazel query` commands, then committed each task only after GREEN implementation and required verification passed.
- **Files modified:** None beyond planned task files.
- **Verification:** Both task commits were created only after their target checks passed.

**2. Used the workspace-required Rust toolchain for pre-commit verification**
- **Found during:** Task 1 verification
- **Issue:** Default `cargo clippy` used `rustc 1.91.1`, while the workspace packages require Rust 1.94.
- **Adjustment:** Reran the Rust pre-commit gate with installed toolchain `+1.94.1`.
- **Files modified:** None.
- **Verification:** `cargo +1.94.1 fmt`, `clippy`, `build`, and `test` all passed.

**Total deviations:** 0 auto-fixed, 2 process adjustments.
**Impact on plan:** The shipped code matches the planned command surface and keeps verification compliant with repo instructions.

## Known Stubs

None.

## Issues Encountered

- `rustfmt_check` initially reported formatting in the new Rust binary; the formatting was applied before Task 1 commit and the check passed.
- A direct `bazel run` of the Rust binary with a repo-relative TSV path could not see that path from Bazel's runfiles context. Direct execution from the repo root proved caller-supplied local-file behavior, and the public parity target proved the intended Bazel runfile path.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 60-02 can add fail-closed public arc-fitting mutation guards against the new Rust-backed parity command. The public command path and existing G-code output regression are both green.

*Phase: 60-executable-arc-fitting-evidence*
*Completed: 2026-06-24*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/60-executable-arc-fitting-evidence/60-01-SUMMARY.md`.
- Task commits exist: `4b9d502f3` and `429994605`.
- Summary frontmatter parses with `requirements_completed: [ARCEV-01]`.
- Summary closeout checks passed: `summary-extract` and `git diff --check` on this summary.
