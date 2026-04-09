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

### Phase 15: Fixture Coverage Tightening

**Goal**: Close the regression-proofing gaps between the advertised supported
slice and the current shared fixture corpus.
**Depends on**: Phase 14
**Requirements**: Hardening only
**Gap Closure**: Closes milestone tech debt around `--export-sla-svg` fixture
coverage and the broader supported `--info` input matrix.
**Success Criteria** (what must be TRUE):

1. The shared export fixture corpus verifies both `--sla` and the explicit
   `--export-sla-svg` alias.
1. The shared transform fixture corpus verifies every documented supported
   `--info` input family, or the docs are narrowed to the actual verified set.
1. The parity fixture package and parity commands describe the full verified
   export/transform slice without hidden gaps.

**Plans**: 2 plans

Plans:

- [x] 15-01: Expand the export and transform fixture corpora for the remaining supported alias and input cases
- [x] 15-02: Update parity docs and status notes so the verified slice matches the fixture corpus exactly

### Phase 16: Audit Metadata Hygiene

**Goal**: Restore a stronger milestone audit trail by carrying machine-readable
requirement completion metadata alongside phase summaries.
**Depends on**: Phase 15
**Requirements**: Hardening only
**Gap Closure**: Closes milestone tech debt around missing
`requirements_completed` summary metadata.
**Success Criteria** (what must be TRUE):

1. The repo has a durable, machine-readable per-phase requirement-completion
   metadata surface for the current milestone summaries.
1. The milestone audit process can cross-check requirement completion from more
   than REQUIREMENTS.md and VERIFICATION.md alone.
1. The local planning docs explain the metadata convention clearly enough for
   future phases to keep the audit trail consistent.

**Plans**: 2 plans

Plans:

- [x] 16-01: Define and backfill the local requirement-completion metadata surface for current phase summaries
- [x] 16-02: Update the local audit/planning guidance so future phases preserve that metadata

## Progress

**Execution Order:**
Phases execute in numeric order: 12 → 13 → 14 → 15 → 16

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 12. Export Workflow Slice | v1.2 | 3/3 | Complete | 2026-04-08 |
| 13. Transform and Info Slice | v1.2 | 3/3 | Complete | 2026-04-09 |
| 14. Export and Transform Fixture Expansion | v1.2 | 2/2 | Complete | 2026-04-09 |
| 15. Fixture Coverage Tightening | v1.2 | 2/2 | Complete | 2026-04-09 |
| 16. Audit Metadata Hygiene | v1.2 | 2/2 | Complete | 2026-04-09 |
