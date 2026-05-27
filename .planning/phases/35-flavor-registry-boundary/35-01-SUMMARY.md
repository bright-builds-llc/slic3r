---
phase: 35-flavor-registry-boundary
plan: "01"
subsystem: rust-contracts
tags: [rust, contracts, parity-surface, const-fn, flavor-registry]

# Dependency graph
requires:
  - phase: 34-rust-flavor-contracts
    provides: strict ParitySurface private-field newtype and parser/display contract
provides:
  - public const constructors for every canonical parity-surface token
  - constructor/parser drift test coverage for packages/parity/status.tsv tokens
  - side-effect-free contract prerequisite for static flavor registry metadata
affects: [35-flavor-registry-boundary, slic3r_flavors, ARCH-03]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - public associated const constructors on strict private-field newtypes
    - constructor values verified against fallible parser output

key-files:
  created:
    - .planning/phases/35-flavor-registry-boundary/35-01-SUMMARY.md
  modified:
    - packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs
    - packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs

key-decisions:
  - "Added named ParitySurface const constructors instead of exposing the tuple field or adding arbitrary string conversion."
  - "Routed successful ParitySurface parser branches through the new constructors so parser and constructor values stay coupled."
  - "Kept registry composition, runtime parsing, and side-effecting APIs deferred to later Phase 35 plans."

patterns-established:
  - "Canonical contract newtypes can expose named const constructors while keeping arbitrary construction private."
  - "Parity-surface constructor tests compare both as_str output and TryFrom output for every status token."

requirements-completed: []
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 35-2026-05-27T11-24-13
generated_at: 2026-05-27T12:21:59Z

# Metrics
duration: 5 min
completed: 2026-05-27
---

# Phase 35 Plan 01: Parity Surface Constructors Summary

**Public const constructors for canonical parity surfaces, with parser-drift tests and no registry side effects**

## Performance

- **Duration:** 5 min
- **Started:** 2026-05-27T12:16:46Z
- **Completed:** 2026-05-27T12:21:59Z
- **Tasks:** 1
- **Files modified:** 2

## Accomplishments

- Added all 14 public `ParitySurface` constructors for the tokens in `packages/parity/status.tsv`.
- Kept `ParitySurface(&'static str)` private, so callers still cannot construct arbitrary parity-surface tokens.
- Added `parity_surface_constructors_return_canonical_tokens`, which checks each constructor's `as_str()` output and compares it to `ParitySurface::try_from(token)`.
- Verified no filesystem, process, environment, clock, lazy runtime initialization, build-script, `expect()`, or `unwrap()` behavior was introduced in `flavor.rs`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add static parity-surface constructors** - `f6d257f5a` (feat)

## Files Created/Modified

- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - Added named const constructors and routed parser successes through them.
- `packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs` - Added constructor/parser drift coverage for every canonical parity-surface token.
- `.planning/phases/35-flavor-registry-boundary/35-01-SUMMARY.md` - Captures execution results and verification evidence.

## Decisions Made

- Added named constructors on `ParitySurface` instead of making the tuple field public or adding `From<&'static str>`.
- Preserved the existing strict parser and reused constructors from parser success branches.
- Kept this plan limited to the contract crate prerequisite; registry composition remains for Plan 35-02.

## Deviations from Plan

### Instruction-Driven Adjustments

**1. TDD RED commit not created**
- **Found during:** Task 1 (Add static parity-surface constructors)
- **Issue:** The plan's TDD flow asks for a separate failing RED commit, but repo-local Rust rules require `cargo fmt`, `cargo clippy`, `cargo build`, and `cargo test` to pass before any commit.
- **Adjustment:** Wrote the constructor test first, verified the expected RED failure on missing constructors, then implemented the constructors and committed only the passing task state.
- **Files modified:** `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs`, `packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs`
- **Verification:** RED failed with missing associated function errors; GREEN passed the targeted constructor test and full Rust pre-commit sequence.
- **Committed in:** `f6d257f5a`

**Total deviations:** 1 instruction-driven process adjustment, 0 auto-fixed code issues.
**Impact on plan:** No product-scope change. The test was still written before implementation, and the committed state satisfies repo passing-commit rules.

## Issues Encountered

None unresolved. The initial RED failure was expected and confirmed the new test guarded missing constructor APIs.

## Verification

- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_contracts --test flavor_contracts parity_surface_constructors_return_canonical_tokens` failed before implementation with missing constructor errors.
- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_contracts --test flavor_contracts`
- `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test //packages/slic3r-rust/crates/slic3r_contracts:rustfmt_check //packages/slic3r-rust/crates/slic3r_contracts:clippy`
- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check`
- `rg -n "pub struct ParitySurface\\(&'static str\\);|pub const fn cli_version\\(\\) -> Self|pub const fn config_persistence\\(\\) -> Self|pub const fn generated_outputs\\(\\) -> Self|parity_surface_constructors_return_canonical_tokens" packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs`
- `rg -n "pub const fn (cli_version|cli_help|cli_other|export_workflows|transform_workflows|linux_runtime|windows_runtime|linux_packaged_launcher|windows_packaged_launcher|config|config_persistence|file_formats|generated_outputs|launcher_packaging)\\(\\) -> Self" packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs`
- `bash -lc '! rg -n "\\.unwrap\\(|expect\\(|LazyLock|std::fs|std::process|std::env|SystemTime|Instant|include_str!|build.rs" packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs'`
- `bash -lc 'missing=$(comm -23 <(awk "NR > 1 { print \\$1 }" packages/parity/status.tsv | sort) <(rg -o "\\"[^\\"]+\\"" packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs | tr -d "\\"" | sort -u)); if [[ -n "$missing" ]]; then printf "%s\\n" "$missing"; exit 1; fi'`
- `git diff --check -- packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs`

## Known Stubs

None. Stub-pattern scan found no hardcoded empty UI values, placeholder text, `TODO`, or `FIXME` markers in the files changed by this plan.

## Threat Flags

None. The changed Rust contract files add no new network endpoints, auth paths, file access patterns, schema changes, or side-effecting trust boundaries beyond the plan's declared parity-surface constructor boundary.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 35-02 can now build static typed flavor registry metadata using `ParitySurface` constructors without runtime parsing or panicking initialization. No blockers remain from this plan.

## Self-Check: PASSED

- Summary file exists at `.planning/phases/35-flavor-registry-boundary/35-01-SUMMARY.md`.
- Task commit found: `f6d257f5a`.
- `frontmatter get` parsed summary metadata successfully.
- `summary-extract` returned an empty `requirements_completed` array as intended for this prerequisite plan.
- `git diff --check` passed for the summary file.

---
*Phase: 35-flavor-registry-boundary*
*Completed: 2026-05-27*
