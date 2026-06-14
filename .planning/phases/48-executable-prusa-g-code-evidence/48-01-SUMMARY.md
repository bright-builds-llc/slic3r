---
phase: 48-executable-prusa-g-code-evidence
plan: "01"
subsystem: parity
tags: [bash, bazel, rust, prusaslicer, gcode, parity]
requires:
  - phase: 47-rust-prusa-g-code-summary-boundary
    provides: Pure Rust Prusa G-code summary parser and stable summary-line boundary
provides:
  - Public `//packages/parity:prusaslicer_gcode_output_parity` command
  - Thin `prusa_gcode_output_summary` Rust binary over `prusa_gcode_output_summary_lines`
  - `line_4` mutation failure guard for expected-summary drift
affects: [phase-48, prusaslicer-gcode-output, parity]
tech-stack:
  added: []
  patterns: [thin Rust summary binary, package-local Bash comparator, Bazel sh_binary mutation guard]
key-files:
  created:
    - packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs
    - packages/parity/compare_prusaslicer_gcode_output.sh
    - packages/parity/compare_prusaslicer_gcode_output_test.sh
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
    - packages/parity/BUILD.bazel
key-decisions:
  - "Kept Plan 48-01 limited to runnable command and failure evidence; status publication remains Plan 48-02."
  - "Used the checked-in expected G-code summary as both Rust input and expected artifact, with exact summary field assertions to prevent self-comparison drift."
  - "Selected the final `line_4` marker mutation from `G1 F203.201` to `G1 F203.200` for the public failure guard."
patterns-established:
  - "Summary-only Prusa G-code parity commands should assert stable summary fields after the Rust-backed diff passes."
requirements-completed: [PGEV-01, PGEV-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 48-2026-06-14T18-49-25
generated_at: 2026-06-14T20:05:45Z
duration: 10min
completed: 2026-06-14
---

# Phase 48 Plan 01: Executable Prusa G-code Command Summary

**Rust-backed Bazel parity command for the narrow Prusa G-code expected-summary slice, with a `line_4` mutation guard and no status publication yet**

## Performance

- **Duration:** 10 min
- **Started:** 2026-06-14T19:55:48Z
- **Completed:** 2026-06-14T20:05:45Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments

- Added `prusa_gcode_output_summary`, a thin Rust executable that reads one caller-provided `expected-gcode-summary.tsv` path and prints `prusa_gcode_output_summary_lines`.
- Added `bazel run //packages/parity:prusaslicer_gcode_output_parity`, which validates the checked-in expected summary, asserts exact source/fixture/row-count facts, and prints only the five approved evidence lines.
- Added `//packages/parity:prusaslicer_gcode_output_parity_failure_test`, which mutates only a temp `line_4` marker copy and proves the public comparator exits non-zero with `line_4` and a unified diff.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add the Rust G-code summary binary** - `b09885a51` (feat)
2. **Task 2: Add the public G-code parity comparator target** - `a97dd0f13` (feat)
3. **Task 3: Add the line_4 parity failure mutation test** - `bc0a943fe` (test)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs` - Thin CLI adapter over the Phase 47 pure summary boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Adds the summary binary and includes it in clippy and rustfmt aggregate surfaces.
- `packages/parity/compare_prusaslicer_gcode_output.sh` - Public fail-closed comparator for the summary-only G-code evidence slice.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh` - Mutation guard for `line_4` expected-summary drift.
- `packages/parity/BUILD.bazel` - Adds the public parity `sh_binary` and mutation `sh_test`.

## Decisions Made

- Followed the existing project-file parity command shape instead of introducing a new comparator framework.
- Kept `packages/parity/status.tsv` unchanged; `fork.prusaslicer.gcode-output` publication belongs to Plan 48-02.
- Added exact shell assertions for `surface`, `inventory_id`, `vendor_id`, `source_ref`, `fixture_path`, `expected_summary_path`, reserved status token, row count, and the representative `line_4` evidence row.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## Known Stubs

None. Stub scan found only Bash non-empty guard expressions in the comparator, not placeholder data flowing to output.

## Verification

- `bazel build //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary`
- `bazel test //packages/slic3r-rust:verify`
- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check`
- `bash -n packages/parity/compare_prusaslicer_gcode_output.sh`
- `shfmt -d packages/parity/compare_prusaslicer_gcode_output.sh`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel query //packages/parity:prusaslicer_gcode_output_parity`
- `bash -n packages/parity/compare_prusaslicer_gcode_output_test.sh`
- `shfmt -d packages/parity/compare_prusaslicer_gcode_output_test.sh`
- `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test`
- `bash packages/parity/compare_prusaslicer_gcode_output_test.sh`
- `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `git diff --check`

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 48-02 can publish the exact `fork.prusaslicer.gcode-output` status row and reconcile prior absence guards. The broad `generated-outputs` status row remains in progress, and this plan makes no byte-for-byte G-code, runtime/printer, geometry, support, seam, arc, STEP, GUI, release, network, or sync claim.

## Self-Check: PASSED

- Created files exist: `prusa_gcode_output_summary.rs`, `compare_prusaslicer_gcode_output.sh`, `compare_prusaslicer_gcode_output_test.sh`, and this summary.
- Task commits found: `b09885a51`, `a97dd0f13`, `bc0a943fe`.
- `summary-extract` parsed frontmatter, including `requirements-completed: [PGEV-01, PGEV-02]`.
- `git diff --check` passed after summary creation.

---
*Phase: 48-executable-prusa-g-code-evidence*
*Completed: 2026-06-14*
