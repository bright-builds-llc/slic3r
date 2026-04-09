# Roadmap: Slic3r Rust Port

## Milestones

- ✅ **v1.0 Rust Port Foundations** — Phases 1-8 (shipped 2026-04-08)
  Archive: [v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)
- ✅ **v1.1 CLI Parity Expansion** — Phases 9-11 (shipped 2026-04-08)
  Archive: [v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)
- 🚧 **v1.2 Export and Transform Parity** — Phases 12-14 (planned)

## Current Milestone

**v1.2 Export and Transform Parity** expands the preferred Rust-backed macOS
CLI path into export workflows and the next non-slicing transform/info actions,
then verifies those supported slices through shared fixtures and parity
visibility.

## Phase Details

### Phase 12: Export Workflow Slice

**Goal**: Deliver Rust-backed export workflows through the preferred launcher
path on macOS for the next supported output slices.
**Depends on**: Phase 11
**Requirements**: EXP-01, EXP-02, EXP-03, EXP-04
**Success Criteria** (what must be TRUE):

1. User can export G-code through the preferred Rust-backed launcher path on
   macOS.
1. User can export the scoped mesh/package formats through the preferred
   Rust-backed launcher path on macOS: STL, OBJ, AMF, and 3MF.
1. User can export the scoped SVG-oriented outputs through the preferred
   Rust-backed launcher path on macOS: `--export-svg`, `--export-sla-svg`, and
   `--sla`.
1. Supported export slices preserve explicit `--output` behavior.

**Plans**: 3 plans

Plans:

- [x] 12-01: Model export workflow contracts and output naming rules in the launcher contract layer
- [x] 12-02: Implement the scoped Rust-backed export workflows and `--output` behavior
- [x] 12-03: Document the supported export slice and the remaining legacy-owned export/packaging behavior

### Phase 13: Transform and Info Slice

**Goal**: Deliver Rust-backed `--info`, `--repair`, and `--split` through the
preferred launcher path on macOS.
**Depends on**: Phase 12
**Requirements**: TRN-01, TRN-02, TRN-03
**Success Criteria** (what must be TRUE):

1. User can run `--info` on supported model inputs through the preferred
   Rust-backed launcher path.
1. User can run `--repair` for supported STL inputs through the preferred
   Rust-backed launcher path.
1. User can run `--split` for supported STL inputs through the preferred
   Rust-backed launcher path.

**Plans**: 3 plans

Plans:

- [x] 13-01: Model the scoped transform/info contracts in Rust launcher types
- [x] 13-02: Implement the Rust-backed info/repair/split behaviors on macOS
- [x] 13-03: Document the supported transform/info slice and the still-deferred merge/cut/layout actions

### Phase 14: Export and Transform Fixture Expansion

**Goal**: Verify the supported export and transform slices through shared
fixtures and publish their parity state cleanly.
**Depends on**: Phase 13
**Requirements**: PEX-01, PEX-02
**Success Criteria** (what must be TRUE):

1. Maintainer can execute shared fixture comparisons for the supported export
   and non-slicing transform slices.
1. The parity status command reports the verified, Rust-backed, and legacy-only
   state of those supported export and transform slices accurately.
1. The migration docs and fixture package make the supported export/transform
   parity scope reviewable without reading the legacy tree first.

**Plans**: 2 plans

Plans:

- [x] 14-01: Seed fixtures and comparison commands for supported export and transform slices
- [x] 14-02: Publish expanded parity visibility and migration docs for the verified export/transform slices

## Progress

**Execution Order:**
Phases execute in numeric order: 12 → 13 → 14

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 12. Export Workflow Slice | v1.2 | 3/3 | Complete | 2026-04-08 |
| 13. Transform and Info Slice | v1.2 | 3/3 | Complete | 2026-04-09 |
| 14. Export and Transform Fixture Expansion | v1.2 | 2/2 | Complete | 2026-04-09 |
