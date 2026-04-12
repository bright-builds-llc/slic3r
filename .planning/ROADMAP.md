# Roadmap: Slic3r Rust Port

## Milestones

- ✅ **v1.4 Linux Parity Foundation** — Phases 21-23 (shipped 2026-04-11)
  Archive: [v1.4-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.4-ROADMAP.md)
- ✅ **v1.3 Packaging-Visible Parity** — Phases 18-20 (shipped 2026-04-11)
  Archive: [v1.3-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.3-ROADMAP.md)
- ✅ **v1.2 Export and Transform Parity** — Phases 12-17 (shipped 2026-04-11)
  Archive: [v1.2-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.2-ROADMAP.md)
- ✅ **v1.1 CLI Parity Expansion** — Phases 9-11 (shipped 2026-04-08)
  Archive: [v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)
- ✅ **v1.0 Rust Port Foundations** — Phases 1-8 (shipped 2026-04-08)
  Archive: [v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)
- 🚧 **v1.6 Windows Parity Foundation** — Phases 24-26 (planned)

## Current Milestone

**v1.6 Windows Parity Foundation** establishes a validated Windows runtime path
for the already verified Rust-backed CLI/export/transform slice, then proves
that Windows runtime surface through shared parity evidence and visibility docs.

## Phase Details

### Phase 24: Windows Launcher Runtime Slice

**Goal**: Deliver the preferred Rust-backed Windows launcher/runtime path for
the already verified help/version/config/export/transform slice.
**Depends on**: Phase 23
**Requirements**: WIN-01, WIN-02, WIN-03
**Success Criteria** (what must be TRUE):

1. User can run the preferred Rust-backed Windows launcher path for `--help`
   and `--version`.
1. User can run the currently verified config persistence, export, and
   non-slicing transform workflows through the preferred Rust-backed Windows
   launcher path.
1. Maintainer can build and invoke the Windows Rust-backed runtime path from
   Bazel without relying on macOS or Linux launcher shims.

**Plans**: 3 plans

Plans:

- [ ] 24-01: Model the Windows launcher/runtime contract and entrypoint boundaries for the existing verified slice
- [ ] 24-02: Implement the preferred Windows launcher/runtime path for the supported help/version/config/export/transform workflows
- [ ] 24-03: Document the supported Windows runtime slice and the remaining Windows packaging gaps

### Phase 25: Windows Shared Parity Evidence

**Goal**: Verify the supported Windows Rust-backed runtime slice through shared
parity evidence.
**Depends on**: Phase 24
**Requirements**: WIN-04
**Success Criteria** (what must be TRUE):

1. Maintainer can execute a shared Windows parity command for the supported
   runtime slice.
1. The Windows parity proof covers representative workflows from the currently
   verified help/version/config/export/transform surface.
1. The Windows parity proof is reviewable without relying on ad hoc manual
   setup.

**Plans**: 2 plans

Plans:

- [ ] 25-01: Add Windows parity fixtures and comparison commands for the supported runtime slice
- [ ] 25-02: Verify representative Windows runtime workflows through the shared parity evidence surface

### Phase 26: Windows Parity Visibility

**Goal**: Publish Windows validation state and migration docs cleanly.
**Depends on**: Phase 25
**Requirements**: WIN-05
**Success Criteria** (what must be TRUE):

1. The parity status command reflects Windows validation state accurately for
   the supported Rust-backed runtime slice.
1. The migration docs describe the supported Windows runtime slice and its
   remaining gaps without overclaiming Windows packaging parity.
1. The Windows parity milestone is reviewable without inspecting raw fixture
   files first.

**Plans**: 2 plans

Plans:

- [ ] 26-01: Publish Windows runtime validation state in parity status and package docs
- [ ] 26-02: Align migration docs with the verified Windows runtime slice and remaining platform gaps

## Progress

**Execution Order:**\
Phases execute in numeric order: 24 → 25 → 26

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 24. Windows Launcher Runtime Slice | v1.6 | 0/3 | Not started | - |
| 25. Windows Shared Parity Evidence | v1.6 | 0/2 | Not started | - |
| 26. Windows Parity Visibility | v1.6 | 0/2 | Not started | - |
