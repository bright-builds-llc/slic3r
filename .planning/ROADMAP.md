# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.8 Cross-Platform Release Build Automation** - Phase 31
- Future: **v1.9 Fork Vendor Intake and Module Architecture** - PrusaSlicer, Bambu Studio, and OrcaSlicer vendor references, feature inventories, and modular port boundaries
- Future: **v1.10 PrusaSlicer Parity Port** - Modular Rust parity for PrusaSlicer-specific behavior
- Future: **v1.11 Bambu Studio Parity Port** - Modular Rust parity for Bambu Studio-specific behavior
- Future: **v1.12 OrcaSlicer Parity Port** - Modular Rust parity for OrcaSlicer-specific behavior
- Future: **v1.13 Fork Feature Documentation and Checklists** - Cross-fork feature catalogs, parity checklists, and gap docs
- Future: **v1.14 Cross-Flavor Build Automation** - GitHub Actions build matrix for every supported Slic3r-family flavor and platform
- Future: **v1.15 Nightly Vendor Sync and Codex-Assisted Porting** - Review-gated automation for upstream fork refreshes and Rust feature merges
- Shipped: **v1.7 Cross-Platform Packaging-Visible Parity** - Phases 27-30 (shipped 2026-05-23)
  Archive: [.planning/milestones/v1.7-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.7-ROADMAP.md)
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

Milestone v1.8 turns the scoped macOS, Linux, and Windows packaged launcher
evidence into repeatable cross-platform release build automation for the base
Rust-backed Slic3r package. The milestone keeps release logic tied to the
existing Rust/Bazel and parity surfaces, records provenance on artifacts, and
documents exactly what the outputs do and do not claim.

Future roadmap work tracks downstream Slic3r-family fork support as separate
milestones: vendor intake and module architecture, one full-parity port
milestone each for PrusaSlicer, Bambu Studio, and OrcaSlicer, then cross-flavor
build automation, nightly vendor-sync automation, and comprehensive feature
documentation/checklists.

## Current Milestone

### v1.8 Cross-Platform Release Build Automation

**Milestone goal:** Maintainers can use GitHub Actions to produce release build
artifacts for the base Rust-backed Slic3r package on macOS, Linux, and Windows.

**Scope boundaries:**

- Base Slic3r package only; fork-flavor builds start after fork parity
  milestones
- No signing, notarization, AppImage, MSI, DMG, installer parity, or
  release-channel publishing
- No new CLI behavior beyond the verified help/version/config/export/transform
  slice
- No GUI rewrite or GUI migration planning
- No downstream fork vendoring, fork parity porting, fork-flavor builds, or
  nightly vendor-sync automation in v1.8

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work

- Decimal phases (2.1, 2.2): Urgent insertions

- v1.8 continues from the previous shipped milestone, starting at Phase 31

- [x] **Phase 31: Cross-Platform Release Build Workflow** - Maintainer can
  build base Slic3r release artifacts for macOS, Linux, and Windows through
  GitHub Actions. (completed 2026-05-24)

## Phase Details

### Phase 31: Cross-Platform Release Build Workflow

**Goal**: Maintainer can use GitHub Actions to produce release build artifacts for the base Rust-backed Slic3r package on every supported platform.
**Depends on**: Phase 30
**Requirements**: REL-03, REL-04, REL-05, REL-06
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

**Plans**: 1 plan

Plans:

- [x] 31-01-PLAN.md - Create the release artifact workflow, provenance script,
  and docs.

## Requirement Coverage

| Requirement | Phase |
| --- | --- |
| REL-03 | Phase 31 |
| REL-04 | Phase 31 |
| REL-05 | Phase 31 |
| REL-06 | Phase 31 |

Coverage: 4/4 v1.8 requirements mapped.

## Progress

**Execution Order:**
Phases execute in numeric order: 31

| Phase | Milestone | Plans Complete | Status | Completed |
| --- | --- | --- | --- | --- |
| 31. Cross-Platform Release Build Workflow | v1.8 | 1/1 | Complete | 2026-05-24 |

## Future Roadmap

These entries are future milestone candidates after the active v1.8 release
build automation milestone. They should be converted into active milestone
requirements and phase directories when the project is ready to plan them.

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

### v1.11 Bambu Studio Parity Port

**Goal:** Maintainer can build and verify a modular Rust-backed Bambu Studio
flavor with full parity for the Bambu Studio-specific feature inventory.
**Depends on:** v1.9 fork vendor intake and module architecture, plus any
shared downstream modules proven during the PrusaSlicer port.

### v1.12 OrcaSlicer Parity Port

**Goal:** Maintainer can build and verify a modular Rust-backed OrcaSlicer
flavor with full parity for the OrcaSlicer-specific feature inventory.
**Depends on:** v1.9 fork vendor intake and module architecture, plus shared
downstream modules proven during earlier fork ports.

### v1.13 Fork Feature Documentation and Checklists

**Goal:** Maintainers and contributors can inspect a comprehensive feature
catalog for every downstream fork and understand parity status, implementation
ownership, evidence commands, and remaining gaps.
**Depends on:** v1.10, v1.11, and v1.12 parity ports.

### v1.14 Cross-Flavor Build Automation

**Goal:** Maintainer can use GitHub Actions to build every supported
Slic3r-family flavor for every supported platform.
**Depends on:** v1.10, v1.11, v1.12, and v1.13.

### v1.15 Nightly Vendor Sync and Codex-Assisted Porting

**Goal:** Maintainer can run review-gated nightly automation that refreshes
vendor fork code, detects newly added upstream features, and uses Codex to
prepare Rust port updates with tests and documentation.
**Depends on:** v1.14 cross-flavor build automation and full parity for each
tracked fork.
