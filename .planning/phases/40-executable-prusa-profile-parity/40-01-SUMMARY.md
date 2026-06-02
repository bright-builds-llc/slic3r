---
phase: 40-executable-prusa-profile-parity
plan: "01"
subsystem: parity
tags: [rust, bazel, prusaslicer, profile-schema, parity-fixtures]
requires:
  - phase: 38-prusa-fixture-and-status-evidence-surface
    provides: Checked-in PrusaResearch.ini fixture and fixture provenance.
  - phase: 39-rust-prusa-profile-boundary
    provides: Pure Rust Prusa profile parser and source metadata.
provides:
  - Public //packages/parity:prusaslicer_profile_schema_parity command.
  - Deterministic Rust-backed expected-summary.tsv fixture artifact.
  - Negative failure guard for mutated expected summary drift.
affects: [phase-40, prusa-profile-schema, parity-status-publication]
tech-stack:
  added: []
  patterns:
    - Pure Rust summary builder with explicit-path binary adapter.
    - Bash fail-closed comparator using checked-in expected TSV.
key-files:
  created:
    - packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs
    - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv
    - packages/parity/compare_prusaslicer_profile_schema.sh
    - packages/parity/compare_prusaslicer_profile_schema_test.sh
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
    - packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs
    - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
    - packages/parity-fixtures/BUILD.bazel
    - packages/parity/BUILD.bazel
key-decisions:
  - "Kept Prusa profile summary generation as pure Rust data-in/data-out logic."
  - "Kept filesystem reads in a thin explicit-path Rust binary and the public maintainer command in packages/parity."
  - "Stored the expected summary beside the Prusa fixture provenance so drift is reviewable in git."
patterns-established:
  - "Prusa profile-schema parity uses a narrow TSV snapshot rather than broad runtime output."
  - "Comparator failure diagnostics identify the first mismatched TSV field before diff output."
requirements-completed: [PPAR-01, PPAR-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 40-2026-06-02T12-10-38
generated_at: 2026-06-02T12:54:46Z
duration: 9m 7s
completed: 2026-06-02
---

# Phase 40 Plan 01: Executable Prusa Profile Parity Summary

**Rust-backed PrusaResearch.ini profile-schema parity command with checked-in TSV expectations and a mutation failure guard**

## Performance

- **Duration:** 9m 7s
- **Started:** 2026-06-02T12:45:39Z
- **Completed:** 2026-06-02T12:54:46Z
- **Tasks:** 3
- **Files modified:** 10

## Accomplishments

- Added `prusa_profile_schema_summary_lines` to summarize parsed Prusa profile sections, entries, kind counts, metadata, and representative samples deterministically.
- Added `bazel run //packages/parity:prusaslicer_profile_schema_parity`, which compares Rust summary output against checked-in `expected-summary.tsv`.
- Added `//packages/parity:prusaslicer_profile_schema_parity_failure_test`, which mutates `section_count` in a temp expected file and requires a non-zero comparator failure with a `section_count` diagnostic.

## Task Commits

1. **Task 1: Add deterministic Rust-backed Prusa profile summary output** - `23fdb64b9` (`feat`)
2. **Task 2: Add checked-in expected summary and public parity command** - `01357b87f` (`feat`)
3. **Task 3: Add negative failure guard for mutated expected artifacts** - `9c5e0f91f` (`test`)

## Verification Evidence

All required plan commands passed:

- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_profile` - 12 tests passed.
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_test //packages/slic3r-rust:verify` - 11 Bazel Rust tests passed.
- `bazel query //packages/parity:prusaslicer_profile_schema_parity` - returned `//packages/parity:prusaslicer_profile_schema_parity`.
- `bazel run //packages/parity:prusaslicer_profile_schema_parity` - printed `ok: fork.prusaslicer.profile-schema parity passed`, the accepted source ref, `PrusaResearch.ini`, `expected-summary.tsv`, `sections: 6976`, and `entries: 27340`.
- `bazel test //packages/parity:prusaslicer_profile_schema_parity_failure_test` - passed.
- `git diff --check` - passed.

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` - Added pure deterministic summary line generation over parsed Prusa profile bundles.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - Re-exported the summary function.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs` - Added explicit-path summary binary with `error:` diagnostics.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs` - Added exact summary, metadata/sample, and parse-error tests.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Added the Rust summary binary and included it in clippy/rustfmt targets.
- `packages/parity-fixtures/BUILD.bazel` - Exported and aliased the expected summary artifact and added it to the Prusa profile-schema bundle.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv` - Added checked-in deterministic expected summary lines.
- `packages/parity/BUILD.bazel` - Added the public parity command and negative failure test target.
- `packages/parity/compare_prusaslicer_profile_schema.sh` - Added fail-closed comparator with first-field mismatch diagnostics.
- `packages/parity/compare_prusaslicer_profile_schema_test.sh` - Added temp mutation failure guard for expected summary drift.

## Decisions Made

- Followed the Phase 40 ownership split: Rust owns the pure parser-backed summary, fixtures own checked-in expected data, and `packages/parity` owns maintainer-facing evidence commands.
- Used TSV because it gives stable, reviewable diffs without adding serialization dependencies.

## Deviations from Plan

### Execution-Flow Adjustments

**1. AGENTS.md pre-commit rule overrode the TDD RED commit step**

- **Found during:** Task 1
- **Issue:** The plan's TDD flow calls for committing the failing RED test state, but repo Rust instructions require `cargo fmt`, `cargo clippy`, `cargo build`, and `cargo test` to pass before every commit.
- **Adjustment:** Added the RED tests and ran the focused Rust test to capture the expected unresolved-import failure, then committed tests plus implementation only after all required verification passed.
- **Impact:** No behavior scope change. This preserved the repo's hard pre-commit rule.

**Total deviations:** 1 execution-flow adjustment.

## Issues Encountered

- The worktree started with pre-existing `.planning/STATE.md` and `.planning/config.json` modifications. `.planning/config.json` was left untouched and unstaged per the user instruction.

## Known Stubs

None - stub scan found no TODO/FIXME/placeholder or hardcoded empty UI-data patterns in created or modified plan files.

## Auth Gates

None.

## User Setup Required

None - all evidence commands consume checked-in fixtures and local Bazel/Rust targets.

## Next Phase Readiness

Plan 40-02 can publish the narrow Prusa profile-schema status/docs evidence using the passing `//packages/parity:prusaslicer_profile_schema_parity` command and the failure guard from this plan.

## Self-Check: PASSED

- Created files exist: `prusa_profile_schema_summary.rs`, `expected-summary.tsv`, `compare_prusaslicer_profile_schema.sh`, `compare_prusaslicer_profile_schema_test.sh`, and this summary.
- Task commits found: `23fdb64b9`, `01357b87f`, `9c5e0f91f`.

---

*Phase: 40-executable-prusa-profile-parity*
*Completed: 2026-06-02*
