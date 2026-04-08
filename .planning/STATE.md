______________________________________________________________________

## gsd_state_version: 1.0 milestone: v1.1 milestone_name: CLI Parity Expansion status: defining_requirements stopped_at: v1.1 requirements definition last_updated: "2026-04-08T21:25:45.922Z" last_activity: 2026-04-08 progress: total_phases: 0 completed_phases: 0 total_plans: 0 completed_plans: 0 percent: 0

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-06)

**Core value:** Deliver a trustworthy Rust successor to Slic3r that matches the legacy behavior and interfaces closely enough that the old implementation can eventually be retired without breaking the contracts users and integrators depend on.
**Current focus:** Milestone v1.1 CLI Parity Expansion

## Current Position

Phase: Not started (defining requirements)
Plan: —
Status: Defining requirements
Last activity: 2026-04-08 — Milestone v1.1 CLI Parity Expansion started

Progress: [░░░░░░░░░░] 0%

## Performance Metrics

**Velocity:**

- Total plans completed: 22
- Average duration: 1 min
- Total execution time: 0.0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1 | 3 | 3 min | 1 min |
| 2 | 3 | 3 min | 1 min |
| 3 | 3 | 3 min | 1 min |
| 4 | 2 | 2 min | 1 min |
| 5 | 3 | 3 min | 1 min |
| 6 | 3 | 3 min | 1 min |
| 7 | 2 | 2 min | 1 min |
| 8 | 3 | 3 min | 1 min |

**Recent Trend:**

- Last 5 plans: 1 min, 1 min, 1 min, 1 min, 1 min
- Trend: Stable

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Initialization: Bazel is the top-level build/test entrypoint for the migration
- Initialization: Legacy Slic3r remains the parity oracle and retained reference package
- Initialization: macOS is the first implementation target; GUI and other platforms come later
- Phase 1: Bazel 8.6.0 is pinned through `.bazelversion` and verified with a scaffold smoke test
- Phase 1: The legacy implementation now lives in `packages/legacy-slic3r` as the visible reference package
- Phase 1: `docs/port/` is now the migration control-plane surface with checklist, parity matrix, and package map
- Phase 2: `//:legacy_oracle_build` is the retained legacy build surface through Bazel on macOS
- Phase 2: `//:legacy_oracle_smoke` is the trusted macOS retained oracle check
- Phase 2: broader retained legacy tests remain exposed but deferred until the XS loader path is stabilized
- Phase 3: `rules_rust` and a pinned Rust 1.94.1 toolchain now back the new Rust workspace
- Phase 3: `//packages/slic3r-rust:verify` is the package-local Bazel verification surface
- Phase 3: `packages/slic3r-rust/crates/slic3r_core` is the first real Rust crate in the repo
- Phase 4: `docs/port/contract-inventory.md` is now the detailed registry for all six externally visible parity surface families
- Phase 4: `docs/port/migration-guidance.md` now defines launcher replacement rules, the parity evidence ladder, and the future fixture protocol
- Phase 5: `packages/slic3r-rust/crates/slic3r_contracts` is now the contract-oriented launcher crate
- Phase 5: `packages/launcher` is now a real package boundary that points at the Rust CLI scaffold
- Phase 6: `bazel run //packages/launcher:slic3r -- --version` is now the preferred Rust-backed macOS CLI invocation for the supported slice
- Phase 6: broader CLI behavior remains explicitly unsupported in the Rust launcher
- Phase 7: `bazel run //packages/parity:status` is now the parity visibility command
- Phase 7: `packages/parity-fixtures/README.md` now defines the package-local fixture workflow rules
- Phase 8: `bazel run //packages/parity:cli_version_parity` now verifies the shared `cli.version` slice against legacy and fixture output
- Phase 8: `cli.version` is now marked `verified` in the checked-in parity status source

### Pending Todos

None yet.

### Blockers/Concerns

None yet.

## Session Continuity

Last session: 2026-04-08 16:24
Stopped at: Defining requirements for v1.1 CLI Parity Expansion
Resume file: None
