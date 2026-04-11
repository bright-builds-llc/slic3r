# Roadmap: Slic3r Rust Port

## Milestones

- ✅ **v1.2 Export and Transform Parity** — Phases 12-17 (shipped 2026-04-11)
  Archive: [v1.2-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.2-ROADMAP.md)
- ✅ **v1.1 CLI Parity Expansion** — Phases 9-11 (shipped 2026-04-08)
  Archive: [v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)
- ✅ **v1.0 Rust Port Foundations** — Phases 1-8 (shipped 2026-04-08)
  Archive: [v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)
- 🚧 **v1.3 Packaging-Visible Parity** — Phases 18-19 (planned)

## Current Milestone

**v1.3 Packaging-Visible Parity** moves the preferred Rust-backed macOS path
from verified CLI/export/transform slices into packaging-visible launcher
behavior, then verifies that packaged launcher surface through shared parity
evidence and migration docs.

## Phase Details

### Phase 18: macOS Packaged Launcher Slice

**Goal**: Deliver the preferred packaged macOS launcher/startup path for the
currently supported Rust-backed CLI slice.
**Depends on**: Phase 17
**Requirements**: PACK-01, PACK-02
**Success Criteria** (what must be TRUE):

1. User can launch the preferred packaged macOS startup path for the currently
   supported Rust-backed CLI slice.
1. Maintainer can inspect the scoped macOS packaging-visible launcher layout
   with the expected startup scripts, bundle-local resources, and handoff
   behavior.
1. The packaged launcher slice stays explicitly bounded to the currently
   verified macOS CLI/export/transform surface.

**Plans**: 2 plans

Plans:

- [ ] 18-01: Model the macOS packaging launcher contract and bundle/startup boundaries
- [ ] 18-02: Implement the packaged launcher/startup surface and document the bundle layout expectations for the scoped macOS slice

### Phase 19: macOS Packaging Parity Evidence

**Goal**: Verify macOS packaging-visible launcher behavior and publish its
parity state cleanly.
**Depends on**: Phase 18
**Requirements**: PACK-03, PACK-04
**Success Criteria** (what must be TRUE):

1. Maintainer can execute shared parity evidence for the macOS packaging-visible
   launcher behavior and artifact layout.
1. The parity status command and migration docs reflect the scoped macOS
   packaging-visible launcher slice accurately.
1. The macOS packaging parity proof is reviewable without depending on ad hoc
   local knowledge.

**Plans**: 2 plans

Plans:

- [x] 19-01: Seed packaging parity evidence and verification commands for the scoped macOS launcher surface
- [x] 19-02: Publish macOS packaging-visible parity status and migration docs

## Progress

**Execution Order:**\
Phases execute in numeric order: 18 → 19

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 18. macOS Packaged Launcher Slice | v1.3 | 2/2 | Complete | 2026-04-11 |
| 19. macOS Packaging Parity Evidence | v1.3 | 2/2 | Complete | 2026-04-11 |
