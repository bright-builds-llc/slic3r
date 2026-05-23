# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.7 Cross-Platform Packaging-Visible Parity** - Phases 27-30
- Shipped: **v1.6 Windows Parity Foundation** - Phases 24-26 (shipped 2026-05-21)
  Archive: [.planning/milestones/v1.6-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.6-ROADMAP.md)
- Shipped: **v1.4 Linux Parity Foundation** - Phases 21-23 (shipped 2026-04-11)
  Archive: [.planning/milestones/v1.4-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.4-ROADMAP.md)
- Shipped: **v1.3 Packaging-Visible Parity** - Phases 18-20 (shipped 2026-04-11)
  Archive: [.planning/milestones/v1.3-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.3-ROADMAP.md)
- Shipped: **v1.2 Export and Transform Parity** - Phases 12-17 (shipped 2026-04-11)
  Archive: [.planning/milestones/v1.2-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.2-ROADMAP.md)
- Shipped: **v1.1 CLI Parity Expansion** - Phases 9-11 (shipped 2026-04-08)
  Archive: [.planning/milestones/v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)
- Shipped: **v1.0 Rust Port Foundations** - Phases 1-8 (shipped 2026-04-08)
  Archive: [.planning/milestones/v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)

## Overview

Milestone v1.7 extends the already verified Rust-backed
help/version/config/export/transform slice into scoped Linux and Windows
packaging-visible launcher behavior. The milestone keeps launcher startup
logic thin, proves the packaged paths through shared evidence, and updates the
status and docs surfaces without expanding into GUI work, signing,
notarization, AppImage/MSI/DMG packaging, installer parity, release-channel
automation, or new CLI behavior.

## Current Milestone

**v1.7 Cross-Platform Packaging-Visible Parity**

**Milestone goal:** Maintainers can build, smoke, verify, and describe scoped
Linux and Windows packaging-visible launcher surfaces for the already verified
Rust-backed slice.

**Scope boundaries:**

- No GUI rewrite or GUI migration planning
- No signing, notarization, AppImage, MSI, DMG, installer parity, or
  release-channel automation
- No new CLI behavior beyond the verified help/version/config/export/transform
  slice
- No business logic moved into shell or packaging bootstrap code

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work

- Decimal phases (2.1, 2.2): Urgent insertions

- v1.7 continues from the previous shipped milestone, starting at Phase 27

- [ ] **Phase 27: Linux Packaged Launcher Slice** - Maintainer can build and smoke a scoped Linux packaging-visible launcher path.

- [ ] **Phase 28: Windows Packaged Launcher Slice** - Maintainer can build and smoke a scoped Windows packaging-visible launcher path.

- [ ] **Phase 29: Cross-Platform Packaging Evidence** - Maintainer can verify Linux and Windows packaged launcher behavior through shared evidence.

- [ ] **Phase 30: Packaging Visibility and Docs** - Maintainer can see accurate packaging validation state and docs scope for v1.7.

## Phase Details

### Phase 27: Linux Packaged Launcher Slice

**Goal**: Maintainer can build and smoke a scoped Linux packaging-visible launcher/startup path for the already verified Rust-backed slice.
**Depends on**: Phase 26; Linux runtime foundation from Phase 23
**Requirements**: LPKG-01, LPKG-02, LPKG-03
**Success Criteria** (what must be TRUE):

1. Maintainer can build a scoped Linux packaging-visible launcher artifact for the verified help/version/config/export/transform slice.
1. Maintainer can run the Linux packaged startup path through Bazel smoke coverage without ad hoc local setup.
1. Maintainer can inspect the Linux packaged launcher startup path and find only thin bootstrap handoff logic, with business behavior still owned by Rust/Bazel-backed code.

**Plans**: TBD

### Phase 28: Windows Packaged Launcher Slice

**Goal**: Maintainer can build and smoke a scoped Windows packaging-visible launcher/startup path for the already verified Rust-backed slice.
**Depends on**: Phase 26
**Requirements**: WPKG-01, WPKG-02, WPKG-03
**Success Criteria** (what must be TRUE):

1. Maintainer can build a scoped Windows packaging-visible launcher artifact for the verified help/version/config/export/transform slice.
1. Maintainer can run the Windows packaged startup path through Bazel smoke coverage without relying on Linux or macOS launcher shims.
1. Maintainer can inspect the Windows packaged launcher startup path and find only thin bootstrap handoff logic.
1. Maintainer can distinguish the Windows launcher artifact from installer, signing, or release-channel support.

**Plans**: TBD

### Phase 29: Cross-Platform Packaging Evidence

**Goal**: Maintainer can verify Linux and Windows packaged launcher behavior through shared checked-in evidence.
**Depends on**: Phase 27, Phase 28
**Requirements**: PKGE-01, PKGE-02, PKGE-03
**Success Criteria** (what must be TRUE):

1. Maintainer can execute Linux packaged launcher parity evidence that proves artifact layout, startup handoff, `--help`, `--version`, and representative config behavior.
1. Maintainer can execute Windows packaged launcher parity evidence that proves artifact layout, startup handoff, `--help`, `--version`, and representative config behavior.
1. Maintainer can inspect the shared packaged evidence through checked-in fixtures and commands instead of manual spot checks.
1. Shared evidence remains scoped to the already verified slice and does not introduce new CLI behavior.

**Plans**: TBD

### Phase 30: Packaging Visibility and Docs

**Goal**: Maintainer can see accurate Linux and Windows packaging-visible launcher validation state and scope boundaries.
**Depends on**: Phase 29
**Requirements**: PVIS-01, PVIS-02, PVIS-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run parity status and see accurate Linux and Windows packaging-visible launcher validation state.
1. Maintainer can read migration docs and package docs that describe supported Linux and Windows packaged launcher scope and remaining gaps.
1. Docs explicitly avoid overclaiming signing, installers, AppImage/MSI/DMG support, or release channels.
1. The roadmap and requirements traceability map every v1.7 requirement to exactly one phase.

**Plans**: TBD

## Requirement Coverage

| Requirement | Phase |
| --- | --- |
| LPKG-01 | Phase 27 |
| LPKG-02 | Phase 27 |
| LPKG-03 | Phase 27 |
| WPKG-01 | Phase 28 |
| WPKG-02 | Phase 28 |
| WPKG-03 | Phase 28 |
| PKGE-01 | Phase 29 |
| PKGE-02 | Phase 29 |
| PKGE-03 | Phase 29 |
| PVIS-01 | Phase 30 |
| PVIS-02 | Phase 30 |
| PVIS-03 | Phase 30 |

Coverage: 12/12 v1.7 requirements mapped.

## Progress

**Execution Order:**
Phases execute in numeric order: 27 -> 28 -> 29 -> 30

| Phase | Milestone | Plans Complete | Status | Completed |
| --- | --- | --- | --- | --- |
| 27. Linux Packaged Launcher Slice | v1.7 | 0/TBD | Not started | - |
| 28. Windows Packaged Launcher Slice | v1.7 | 0/TBD | Not started | - |
| 29. Cross-Platform Packaging Evidence | v1.7 | 0/TBD | Not started | - |
| 30. Packaging Visibility and Docs | v1.7 | 0/TBD | Not started | - |
