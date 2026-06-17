---
phase: 51-rust-structural-g-code-summary-boundary
plan: "01"
subsystem: rust
tags: [rust, bazel, prusaslicer, gcode, tsv]

requires:
  - phase: 50-structural-g-code-fixture-expansion
    provides: Source-pinned structural G-code sidecar and fail-closed fixture verifier
provides:
  - Pure typed Rust parser for the Phase 50 Prusa structural G-code summary TSV
  - Row-preserving structural summary and typed facts projection for the checked-in fixture contract
  - Cargo and Bazel coverage for structural parser acceptance and malformed-input rejection
affects:
  - 51-rust-structural-g-code-summary-boundary
  - 52-executable-structural-g-code-evidence

tech-stack:
  added: []
  patterns:
    - Dependency-free caller-supplied TSV parsing with closed structural row keys
    - Exact evidence-boundary text validation before typed structural facts projection

key-files:
  created:
    - .planning/phases/51-rust-structural-g-code-summary-boundary/51-01-SUMMARY.md
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
    - packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs
    - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel

key-decisions:
  - "Extended the existing prusa_gcode_output Rust module instead of creating a new crate or public parity command."
  - "Validated exact structural rows and evidence-boundary text before exposing typed facts."
  - "Kept Bazel wiring limited to prusa_gcode_output_test compile_data and left packages/parity untouched."

patterns-established:
  - "Structural G-code sidecars are parsed through a pure row-first Rust boundary."
  - "Malformed structural TSV inputs fail closed by header, column count, row key, source/fixture identity, value, and boundary text."

requirements-completed:
  - GCRUST-01
  - GCRUST-02
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 51-2026-06-17T22-55-52
generated_at: 2026-06-17T23:51:47Z

duration: 15min
completed: 2026-06-17
---

# Phase 51 Plan 01: Rust Structural G-code Summary Boundary Summary

**Pure typed Rust parser for the Prusa structural G-code sidecar with Cargo and Bazel fail-closed coverage**

## Performance

- **Duration:** 15 min
- **Started:** 2026-06-17T23:36:38Z
- **Completed:** 2026-06-17T23:51:47Z
- **Tasks:** 2
- **Files modified:** 4 implementation/test files plus this summary

## Accomplishments

- Added `parse_prusa_gcode_output_structural_summary` with exact six-column header validation, 16 ordered structural fields, duplicate/missing/order checks, exact source/fixture identity checks, exact value checks, and exact evidence-boundary text checks.
- Added typed structural rows, field/category/value enums, structural parse errors, evidence-boundary wrapper, and a typed facts projection.
- Re-exported the structural parser boundary from `slic3r_flavors`.
- Added Cargo and Bazel tests for acceptance plus invalid header, wrong columns, missing row, duplicate row, out-of-order rows, unsupported field, unsupported boundary claim, wrong source ref, wrong fixture path, and wrong fixture ID.
- Wired the structural TSV alias into `prusa_gcode_output_test` `compile_data`.

## Task Commits

1. **Task 1: Add the structural parser contract** - `86a59ac01` (feat)
2. **Task 2: Add structural parser rejection coverage and Bazel data wiring** - `9ebb26252` (test)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - Pure structural TSV parser, typed row/facts surface, structural value parsing, and fail-closed parse errors.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - Public re-exports for the structural parser boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` - Structural acceptance and malformed-input rejection coverage.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Structural TSV compile data for the existing Bazel Rust test.

## Verification

- `cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml`
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test`
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check`
- `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check`
- `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features`
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-features`
- `git diff --check -- packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`
- `test -z "$(git diff --name-only -- packages/parity packages/parity/status.tsv)"`

## Decisions Made

- Kept the parser dependency-free and caller-supplied string only, with no filesystem, Git, network, process, status, release, or sync behavior.
- Used the Phase 50 structural TSV values as a closed typed contract, not as generic TSV data.
- Left registry structural readiness metadata to 51-02 and public structural parity/status publication to Phase 52.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Narrowed the no-overclaiming test allowlist for the required structural indicator**
- **Found during:** Task 1 (Add the structural parser contract)
- **Issue:** The existing public declaration guard rejected any public declaration containing `extrusion`, while the Phase 51 plan explicitly requires the typed facts field `extrusion_axis_present`.
- **Fix:** Added a one-line allowlist for the exact `pub extrusion_axis_present: bool,` declaration while preserving all broad no-overclaiming risky-word checks.
- **Files modified:** `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`
- **Verification:** Task 1 and plan-level Cargo gates passed, including `cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml`.
- **Committed in:** `86a59ac01`

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The adjustment preserved the planned structural public API and kept the existing no-overclaiming guard active for all other risky public declarations.

## Known Stubs

None.

## Issues Encountered

None. `.planning/STATE.md` and `.planning/config.json` were already modified by orchestration and were intentionally left uncommitted.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 51-02 can expose structural readiness metadata through the existing registry boundary using the parser and exact structural artifact path from this plan. Phase 52 remains responsible for public structural parity/status/docs publication.

*Phase: 51-rust-structural-g-code-summary-boundary*
*Completed: 2026-06-17*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/51-rust-structural-g-code-summary-boundary/51-01-SUMMARY.md`.
- Task commits exist in git history: `86a59ac01` and `9ebb26252`.
- Summary frontmatter includes `requirements-completed` with `GCRUST-01` and `GCRUST-02`.
- `git diff --check` passes for this summary.
