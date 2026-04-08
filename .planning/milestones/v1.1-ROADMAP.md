# Roadmap: Slic3r Rust Port

## Milestones

- ✅ **v1.0 Rust Port Foundations** — Phases 1-8 (shipped 2026-04-08)
  Archive: [v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)
- 🚧 **v1.1 CLI Parity Expansion** — Phases 9-11 (planned)

## Current Milestone

**v1.1 CLI Parity Expansion** expands Rust-backed macOS CLI parity beyond
`--version` by adding help and config persistence slices, then verifying those
supported CLI flows through shared fixtures and parity visibility.

## Phase Details

### Phase 9: Help and Usage Slice

**Goal**: Deliver Rust-backed `--help` and top-level usage output through the
preferred launcher path on macOS.
**Depends on**: Phase 8
**Requirements**: CLI-01, CLI-02
**Success Criteria** (what must be TRUE):

1. User can run `bazel run //packages/launcher:slic3r -- --help` on macOS and
   receive a Rust-backed usage screen.
1. The usage screen clearly distinguishes supported Rust-backed slices from
   still-legacy-owned CLI behavior.
1. The preferred launcher path serves both `--version` and `--help` without
   regressing the already verified `--version` slice.

**Plans**: 3 plans

Plans:

- [x] 09-01-PLAN.md — Extend launcher contracts and CLI routing for help and top-level usage
- [x] 09-02-PLAN.md — Implement the Rust-backed help output and top-level usage behavior
- [x] 09-03-PLAN.md — Document the supported help slice and update parity visibility

### Phase 10: Config Persistence Slice

**Goal**: Deliver Rust-backed config save/load/datadir behavior for the scoped
CLI path on macOS.
**Depends on**: Phase 9
**Requirements**: CFG-01, CFG-02, CFG-03
**Success Criteria** (what must be TRUE):

1. User can save configuration to an INI file through the preferred Rust-backed
   CLI path on macOS.
1. User can load one or more configuration files through the preferred
   Rust-backed CLI path on macOS.
1. `--datadir` scopes configuration state for the supported Rust-backed CLI
   flows on macOS.

**Plans**: 3 plans

Plans:

- [x] 10-01-PLAN.md — Model config persistence and load semantics in contract-oriented Rust types
- [x] 10-02-PLAN.md — Implement Rust-backed save/load/datadir behavior on the launcher path
- [x] 10-03-PLAN.md — Document the supported config slice and unsupported config/export behavior

### Phase 11: CLI Fixture and Status Expansion

**Goal**: Verify the expanded help/version/config slices through shared fixtures
and publish their parity state cleanly.
**Depends on**: Phase 10
**Requirements**: PCLI-01, PCLI-02
**Success Criteria** (what must be TRUE):

1. Maintainer can run shared fixture comparisons for the supported help,
   version, and config CLI slices.
1. The parity status command reports the verified, Rust-backed, and legacy-only
   state of those supported CLI slices accurately.
1. The migration docs and fixture package make the supported CLI parity scope
   reviewable without reading the legacy tree first.

**Plans**: 2 plans

Plans:

- [x] 11-01-PLAN.md — Seed fixtures and comparison commands for help/version/config CLI slices
- [x] 11-02-PLAN.md — Publish expanded parity visibility and migration docs for the verified CLI slices

## Progress

**Execution Order:**
Phases execute in numeric order: 9 → 10 → 11

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 9. Help and Usage Slice | v1.1 | 3/3 | Complete | 2026-04-08 |
| 10. Config Persistence Slice | v1.1 | 3/3 | Complete | 2026-04-08 |
| 11. CLI Fixture and Status Expansion | v1.1 | 2/2 | Complete | 2026-04-08 |
