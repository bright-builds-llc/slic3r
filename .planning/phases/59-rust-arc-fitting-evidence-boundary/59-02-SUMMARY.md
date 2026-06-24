---
phase: 59-rust-arc-fitting-evidence-boundary
plan: "02"
subsystem: rust-registry
tags: [rust, arc-fitting, prusaslicer, readiness, registry, bazel]

requires:
  - phase: 58-arc-fitting-fixture-corpus
    provides: "Checked-in Prusa arc-fitting fixture corpus and expected summary"
  - phase: 59-rust-arc-fitting-evidence-boundary
    plan: "01"
    provides: "Pure Rust Prusa arc-fitting summary parser"
provides:
  - "Developer-facing arc-fitting readiness metadata"
  - "Registry future-candidate row for prusaslicer.arc-fitting"
  - "Root Rust Bazel verify coverage for the arc-fitting boundary tests"
affects: [phase-59, phase-60, slic3r_flavors, prusaslicer.arc-fitting]

tech-stack:
  added: []
  patterns:
    - "Static readiness metadata tied to source, fixture, generated-output dependency, and parity dependency"
    - "FutureCandidate registry capability with explicit pre-publication deferral notes"
    - "Root Bazel verify target includes boundary tests before public parity publication"

key-files:
  created: []
  modified:
    - packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
    - packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs
    - packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs
    - packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs
    - packages/slic3r-rust/BUILD.bazel

key-decisions:
  - "Represented arc fitting as developer-facing readiness metadata and a FutureCandidate registry row, not as a public parity/status/documentation claim."
  - "Kept the registry row dependent on generated outputs and blocked on the prusaslicer_arc_fitting_parity parity target so Phase 60 owns public parity activation."
  - "Wired the arc-fitting boundary tests into the root Rust verify target while leaving parity package status/docs untouched."

patterns-established:
  - "Future capability rows can expose source and fixture evidence while explicitly naming deferred public surfaces."
  - "Readiness APIs can be exact, static, and test-covered without creating runtime discovery or parity publication behavior."

requirements-completed: [ARCRUST-02, ARCRUST-03]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 59-2026-06-24T13-36-08
generated_at: 2026-06-24T14:38:24Z

duration: 10 min
completed: 2026-06-24
---

# Phase 59 Plan 02: Prusa Arc-Fitting Readiness Registry Summary

**Arc-fitting readiness metadata and registry future-candidate wiring with root Rust verify coverage, while keeping Phase 60 publication surfaces deferred.**

## Performance

- **Duration:** 10 min
- **Started:** 2026-06-24T14:28:31Z
- **Completed:** 2026-06-24T14:38:24Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments

- Added `PrusaArcFittingMetadata`, `PrusaArcFittingReadiness`, `prusa_arc_fitting_metadata`, and `prusa_arc_fitting_readiness` to expose exact developer-facing source, fixture, generated-output dependency, and parity-blocker metadata.
- Re-exported the arc-fitting readiness symbols from `slic3r_flavors` for downstream Rust callers.
- Registered `prusaslicer.arc-fitting` as a `FutureCandidate` capability row with exact source provenance, generated-output dependency, and pre-publication deferral notes.
- Added flavor registry coverage proving the arc-fitting row is queryable by ID, included in future-candidate and shared-downstream filters, and explicit about deferred public surfaces.
- Wired `prusa_arc_fitting_test` into `//packages/slic3r-rust:verify` without adding a parity target, status row, parity docs, or package-map/migration-guide entries.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add arc-fitting readiness metadata** - `3723c24d4` (feat)
2. **Task 2: Register arc-fitting future candidate** - `6e25d7f0c` (feat)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs` - Added static readiness metadata, readiness helper, and tests for exact source/fixture/parity boundary evidence.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - Re-exported the readiness metadata types and helpers.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Added the `prusaslicer.arc-fitting` future-candidate registry row and provenance constant.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` - Added registry, filter, provenance, readiness, and no-overclaim coverage.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs` - Narrowed the public declaration overclaim scan to declarations instead of metadata fields.
- `packages/slic3r-rust/BUILD.bazel` - Added `prusa_arc_fitting_test` to the root Rust `verify` suite.

## Decisions Made

- Kept the readiness boundary static and metadata-only. It names the source evidence, checked-in fixture, generated output dependency, and blocking parity target without creating executable parity behavior.
- Registered arc fitting as `CapabilityStatus::FutureCandidate` because Phase 60 still owns parity target creation, status publication, and documentation updates.
- Preserved the publication boundary by verifying that `packages/parity/status.tsv`, `packages/parity/README.md`, `packages/parity/BUILD.bazel`, and `docs/port` remained unchanged.

## Verification

- `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check` - passed.
- `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features -- -D warnings` - passed.
- `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features` - passed.
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-features` - passed.
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test flavor_registry` - passed.
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_arc_fitting` - passed.
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_test --test_output=errors` - passed.
- `bazel test //packages/slic3r-rust:verify --test_output=errors` - passed.
- `git diff --check -- packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs packages/slic3r-rust/BUILD.bazel` - passed.
- `test -z "$(git diff --name-only -- packages/parity/status.tsv packages/parity/README.md packages/parity/BUILD.bazel docs/port)"` - passed.
- `! bazel query //packages/parity:prusaslicer_arc_fitting_parity` - passed; the public parity target remains absent.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Repo Instruction] Applied repo pre-commit rules over failing RED commits**
- **Found during:** Task 1
- **Issue:** The GSD TDD flow calls for committing a failing RED state, but repo Rust rules require fmt, clippy, build, and tests to pass before any commit.
- **Fix:** Ran RED tests to observe the expected missing-API and missing-registry failures, then committed only passing task states after required verification.
- **Files modified:** Commit structure only; no extra source changes.
- **Verification:** Both task commits were made after the repo-required Rust pre-commit sequence passed.
- **Committed in:** `3723c24d4`, `6e25d7f0c`

**2. [Rule 1 - Bug] Narrowed arc-fitting declaration scan to public entrypoints**
- **Found during:** Task 1
- **Issue:** The existing no-overclaim scan matched required metadata field names such as `parity_dependency`, even though those fields document deferred surfaces instead of publishing them.
- **Fix:** Restricted the scan to public type and function declarations so it continues guarding the public executable surface without rejecting required metadata fields.
- **Files modified:** `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs`
- **Verification:** `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_arc_fitting`
- **Committed in:** `3723c24d4`

**3. [Rule 3 - Blocking] Applied rustfmt after aggregate Bazel verify caught formatting drift**
- **Found during:** Task 2
- **Issue:** The first aggregate `bazel test //packages/slic3r-rust:verify --test_output=errors` run failed on rustfmt formatting drift in the new registry test assertions.
- **Fix:** Ran `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all` and reran the aggregate verify target.
- **Files modified:** `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs`
- **Verification:** `bazel test //packages/slic3r-rust:verify --test_output=errors`
- **Committed in:** `6e25d7f0c`

**Total deviations:** 3 auto-handled (1 repo-instruction adjustment, 1 test bug, 1 blocking format fix)

## Known Stubs

None. The modified Rust and Bazel files were scanned for `TODO`, `FIXME`, placeholder wording, "coming soon", "not available", and hardcoded empty/null UI-style values.

## Threat Flags

None. The plan added static metadata, registry rows, and tests only; it introduced no new network endpoints, auth paths, file access paths, schema changes, or trust-boundary behavior.

## Self-Check: PASSED

- Summary file exists at `.planning/phases/59-rust-arc-fitting-evidence-boundary/59-02-SUMMARY.md`.
- Task commits exist in git history: `3723c24d4`, `6e25d7f0c`.
- `summary-extract` parsed the frontmatter and reported `requirements_completed` as `ARCRUST-02` and `ARCRUST-03`.
- `git diff --check -- .planning/phases/59-rust-arc-fitting-evidence-boundary/59-02-SUMMARY.md` passed.
