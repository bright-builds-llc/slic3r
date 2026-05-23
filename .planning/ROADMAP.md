# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.7 Cross-Platform Packaging-Visible Parity** - Phases 27-30
- Planned: **v1.8 Cross-Platform Release Build Automation** - Phase 31
- Future: **v1.9 Fork Vendor Intake and Module Architecture** - PrusaSlicer, Bambu Studio, and OrcaSlicer vendor references, feature inventories, and modular port boundaries
- Future: **v1.10 PrusaSlicer Parity Port** - Modular Rust parity for PrusaSlicer-specific behavior
- Future: **v1.11 Bambu Studio Parity Port** - Modular Rust parity for Bambu Studio-specific behavior
- Future: **v1.12 OrcaSlicer Parity Port** - Modular Rust parity for OrcaSlicer-specific behavior
- Future: **v1.13 Fork Feature Documentation and Checklists** - Cross-fork feature catalogs, parity checklists, and gap docs
- Future: **v1.14 Cross-Flavor Build Automation** - GitHub Actions build matrix for every supported Slic3r-family flavor and platform
- Future: **v1.15 Nightly Vendor Sync and Codex-Assisted Porting** - Review-gated automation for upstream fork refreshes and Rust feature merges
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

Future roadmap work now tracks downstream Slic3r-family fork support as
separate milestones: vendor intake and module architecture, one full-parity
port milestone each for PrusaSlicer, Bambu Studio, and OrcaSlicer, then
cross-flavor build automation, nightly vendor-sync automation, and
comprehensive feature documentation/checklists.

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
- No downstream fork vendoring, fork parity porting, fork-flavor builds, or
  nightly vendor-sync automation in v1.7; those are tracked as future
  milestones below

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work

- Decimal phases (2.1, 2.2): Urgent insertions

- v1.7 continues from the previous shipped milestone, starting at Phase 27

- [x] **Phase 27: Linux Packaged Launcher Slice** - Maintainer can build and smoke a scoped Linux packaging-visible launcher path. (completed 2026-05-23)

- [x] **Phase 28: Windows Packaged Launcher Slice** - Maintainer can build and smoke a scoped Windows packaging-visible launcher path. (completed 2026-05-23)

- [x] **Phase 29: Cross-Platform Packaging Evidence** - Maintainer can verify Linux and Windows packaged launcher behavior through shared evidence. (completed 2026-05-23)

- [x] **Phase 30: Packaging Visibility and Docs** - Maintainer can see accurate packaging validation state and docs scope for v1.7. (completed 2026-05-23)

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

**Plans**: 3 plans

Plans:

- [x] 28-01-PLAN.md — Build and smoke the scoped Windows package tree.
- [x] 28-02-PLAN.md — Align Rust help text and help parity fixtures.
- [x] 28-03-PLAN.md — Document package-local Windows launcher discoverability.

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

**Plans**: 3 plans

Plans:

- [x] 30-01-PLAN.md — Publish packaged launcher status rows and package-local evidence docs.
- [x] 30-02-PLAN.md — Publish scoped packaged launcher evidence across porting and launcher docs.
- [x] 30-03-PLAN.md — Verify v1.7 traceability and final parity evidence.

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
| 27. Linux Packaged Launcher Slice | v1.7 | 1/1 | Complete | 2026-05-23 |
| 28. Windows Packaged Launcher Slice | v1.7 | 3/3 | Complete | 2026-05-23 |
| 29. Cross-Platform Packaging Evidence | v1.7 | 1/1 | Complete | 2026-05-23 |
| 30. Packaging Visibility and Docs | v1.7 | 3/3 | Complete | 2026-05-23 |

## Future Roadmap

These entries are future milestone candidates after the active v1.7 packaging
visibility milestone. They should be converted into active milestone
requirements and phase directories when the project is ready to plan them.

### v1.8 Cross-Platform Release Build Automation

**Seed phase:** Phase 31
**Goal:** Maintainer can use GitHub Actions to produce release build artifacts
for the base Rust-backed Slic3r package on every supported platform.
**Depends on:** Phase 30
**Scope:** Base Slic3r package only; fork-flavor builds start after the fork
parity milestones.
**Success Criteria** (what must be TRUE):

1. GitHub Actions can build base Slic3r release artifacts for macOS, Linux, and
   Windows from the Rust/Bazel workflow.
1. Artifacts carry enough provenance to identify platform, commit, build mode,
   and supported package scope.
1. Release-build automation reuses verified packaging evidence instead of
   inventing parallel release logic.
1. Docs describe supported release-build outputs and remaining exclusions such
   as signing, notarization, installers, or release channels if those are still
   deferred.

**Plans:** 0 plans

Plans:

- [ ] TBD (run `/gsd-plan-phase 31` or start the v1.8 milestone plan to break down)

### v1.9 Fork Vendor Intake and Module Architecture

**Goal:** Maintainer can track PrusaSlicer, Bambu Studio, and OrcaSlicer as
pinned vendor sources and can see how their downstream features map into
modular Rust packages.
**Depends on:** v1.8 release-build automation, or an explicit decision to
prioritize fork intake first.
**Success Criteria** (what must be TRUE):

1. The repo has a documented vendor-source strategy for PrusaSlicer, Bambu
   Studio, and OrcaSlicer, using submodules or another pinned mirror approach
   with explicit update and licensing rules.
1. Each fork has a checked-in feature inventory that separates base Slic3r
   behavior, shared downstream behavior, and fork-specific behavior.
1. The Rust module/package architecture defines how fork-specific features plug
   into the base implementation without forking the Rust codebase wholesale.
1. Parity checklists and documentation templates exist for downstream fork
   feature work.

### v1.10 PrusaSlicer Parity Port

**Goal:** Maintainer can build and verify a modular Rust-backed PrusaSlicer
flavor with full parity for the PrusaSlicer-specific feature inventory.
**Depends on:** v1.9 fork vendor intake and module architecture.
**Success Criteria** (what must be TRUE):

1. PrusaSlicer-specific features are implemented as modular Rust code that
   reuses the base Slic3r core where behavior overlaps.
1. PrusaSlicer parity evidence covers representative CLI, slicing, profile,
   configuration, UI-facing, and output-format behavior introduced by that
   fork.
1. PrusaSlicer extra-feature docs and checklists are complete enough for a
   maintainer to audit shipped parity and known gaps.

### v1.11 Bambu Studio Parity Port

**Goal:** Maintainer can build and verify a modular Rust-backed Bambu Studio
flavor with full parity for the Bambu Studio-specific feature inventory.
**Depends on:** v1.9 fork vendor intake and module architecture, plus any
shared downstream modules proven during the PrusaSlicer port.
**Success Criteria** (what must be TRUE):

1. Bambu Studio-specific features are implemented as modular Rust code that
   reuses base and shared downstream modules where behavior overlaps.
1. Bambu Studio parity evidence covers representative CLI, slicing, profile,
   configuration, device/cloud-adjacent, UI-facing, and output-format behavior
   introduced by that fork.
1. Bambu Studio extra-feature docs and checklists are complete enough for a
   maintainer to audit shipped parity and known gaps.

### v1.12 OrcaSlicer Parity Port

**Goal:** Maintainer can build and verify a modular Rust-backed OrcaSlicer
flavor with full parity for the OrcaSlicer-specific feature inventory.
**Depends on:** v1.9 fork vendor intake and module architecture, plus shared
downstream modules proven during earlier fork ports.
**Success Criteria** (what must be TRUE):

1. OrcaSlicer-specific features are implemented as modular Rust code that
   reuses base and shared downstream modules where behavior overlaps.
1. OrcaSlicer parity evidence covers representative CLI, slicing, profile,
   calibration, configuration, UI-facing, and output-format behavior introduced
   by that fork.
1. OrcaSlicer extra-feature docs and checklists are complete enough for a
   maintainer to audit shipped parity and known gaps.

### v1.13 Fork Feature Documentation and Checklists

**Goal:** Maintainers and contributors can inspect a comprehensive feature
catalog for every downstream fork and understand parity status, implementation
ownership, evidence commands, and remaining gaps.
**Depends on:** v1.10, v1.11, and v1.12 parity ports.
**Success Criteria** (what must be TRUE):

1. Documentation compares base Slic3r, PrusaSlicer, Bambu Studio, and
   OrcaSlicer feature surfaces in one reviewable matrix.
1. Every extra feature from each fork has a checklist entry with parity status,
   Rust module ownership, evidence command, docs link, and known gaps.
1. Docs distinguish user-facing behavior, build/release behavior, profile
   data, device/vendor integrations, and UI-facing features.

### v1.14 Cross-Flavor Build Automation

**Goal:** Maintainer can use GitHub Actions to build every supported
Slic3r-family flavor for every supported platform.
**Depends on:** v1.10, v1.11, v1.12, and v1.13.
**Success Criteria** (what must be TRUE):

1. GitHub Actions can build base Slic3r, PrusaSlicer, Bambu Studio, and
   OrcaSlicer flavors for macOS, Linux, and Windows.
1. Build artifacts clearly identify flavor, platform, commit, vendor source
   revision, and supported feature scope.
1. The build matrix runs shared checks plus flavor-specific parity/evidence
   jobs before artifacts are published.

### v1.15 Nightly Vendor Sync and Codex-Assisted Porting

**Goal:** Maintainer can run review-gated nightly automation that refreshes
vendor fork code, detects newly added upstream features, and uses Codex to
prepare Rust port updates with tests and documentation.
**Depends on:** v1.14 cross-flavor build automation and full parity for each
tracked fork.
**Success Criteria** (what must be TRUE):

1. Nightly jobs refresh the pinned vendor references for PrusaSlicer, Bambu
   Studio, and OrcaSlicer without silently changing shipped Rust behavior.
1. Automation compares vendor deltas against the feature inventories and opens
   reviewable change proposals when new behavior appears.
1. Codex-assisted jobs generate bounded Rust port changes, parity evidence,
   checklist updates, and documentation updates as reviewed pull requests
   rather than unreviewed direct merges.
1. Maintainers can see which upstream fork changes are ported, pending, blocked,
   or intentionally out of scope.
