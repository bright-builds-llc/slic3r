# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.9 Fork Vendor Intake and Module Architecture** - Phases 32-36
  (planned)
- Future: **v1.10 PrusaSlicer Parity Port** - Modular Rust parity for
  PrusaSlicer-specific behavior
- Future: **v1.11 Bambu Studio Parity Port** - Modular Rust parity for Bambu
  Studio-specific behavior
- Future: **v1.12 OrcaSlicer Parity Port** - Modular Rust parity for
  OrcaSlicer-specific behavior
- Future: **v1.13 Fork Feature Documentation and Checklists** - Cross-fork
  feature catalogs, parity checklists, and gap docs
- Future: **v1.14 Cross-Flavor Build Automation** - GitHub Actions build matrix
  for every supported Slic3r-family flavor and platform
- Future: **v1.15 Nightly Vendor Sync and Codex-Assisted Porting** -
  review-gated automation for upstream fork refreshes and Rust feature merges
- Shipped: **v1.8 Cross-Platform Release Build Automation** - Phase 31
  (shipped 2026-05-24)
  Archive: [.planning/milestones/v1.8-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-ROADMAP.md)
- Shipped: **v1.7 Cross-Platform Packaging-Visible Parity** - Phases 27-30
  (shipped 2026-05-23)
  Archive: [.planning/milestones/v1.7-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.7-ROADMAP.md)
- Shipped: **v1.6 Windows Parity Foundation** - Phases 24-26 (shipped
  2026-05-21)
  Archive: [.planning/milestones/v1.6-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.6-ROADMAP.md)
- Shipped: **v1.4 Linux Parity Foundation** - Phases 21-23 (shipped
  2026-04-11)
  Archive: [.planning/milestones/v1.4-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.4-ROADMAP.md)
- Shipped: **v1.3 Packaging-Visible Parity** - Phases 18-20 (shipped
  2026-04-11)
  Archive: [.planning/milestones/v1.3-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.3-ROADMAP.md)
- Shipped: **v1.2 Export and Transform Parity** - Phases 12-17 (shipped
  2026-04-11)
  Archive: [.planning/milestones/v1.2-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.2-ROADMAP.md)
- Shipped: **v1.1 CLI Parity Expansion** - Phases 9-11 (shipped 2026-04-08)
  Archive: [.planning/milestones/v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)
- Shipped: **v1.0 Rust Port Foundations** - Phases 1-8 (shipped 2026-04-08)
  Archive: [.planning/milestones/v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)

## Current Status

v1.9 is active. Phases 32, 33, 34, and 35 are complete, and Phase 36 is ready
to plan. The roadmap continues from the last shipped phase, Phase 31, and
covers only the v1.9 active requirements.

## Overview

v1.9 establishes a maintainer-facing intake and architecture layer for
PrusaSlicer, Bambu Studio, and OrcaSlicer. The milestone pins official vendor
source references, inventories downstream feature ownership, defines typed Rust
flavor boundaries, and creates parity templates for later fork-port milestones
without importing upstream source trees or claiming runtime fork support.

## Phases

**Phase Numbering:**

- Integer phases (32, 33, 34): Planned milestone work

- Decimal phases (32.1, 32.2): Urgent insertions, if needed later

- This milestone starts at Phase 32 because Phase 31 shipped in v1.8

- [x] **Phase 32: Vendor Source Manifest and License Baseline** - Maintainers (completed 2026-05-26)
  can inspect and verify pinned official fork source refs, lineage, and
  license/provenance notes.

- [x] **Phase 33: Inventory Templates and Source-Pinned Fork Inventories** -
  Maintainers can use source-pinned inventory templates and inspect initial
  PrusaSlicer, Bambu Studio, OrcaSlicer, and cross-fork classifications.
  (completed 2026-05-26)

- [x] **Phase 34: Rust Flavor Contracts** - Developers can use typed Rust
  contracts for fork identity, vendor source identity, feature origins, parity
  surfaces, and checklist status. (completed 2026-05-26)

- [x] **Phase 35: Flavor Registry Boundary** - Developers can inspect a pure (completed 2026-05-27)
  flavor registry boundary that maps base, shared downstream, and fork-specific
  metadata without copied Rust workspaces.

- [x] **Phase 36: Parity, Fixture, Launcher, and Deferral Templates** - (completed 2026-05-27)
  Maintainers can use fork parity, fixture namespace, launcher-shape, drift
  refresh, and deferral templates without overclaiming fork support.

## Phase Details

### Phase 32: Vendor Source Manifest and License Baseline

**Goal**: Maintainers have a reproducible vendor-source and license baseline
for PrusaSlicer, Bambu Studio, and OrcaSlicer.
**Depends on**: Phase 31
**Requirements**: VEND-01, VEND-02, VEND-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect one checked-in vendor source registry for
   PrusaSlicer, Bambu Studio, and OrcaSlicer with official URL, stable tag,
   peeled commit, observed branch head, capture date, lineage, source paths,
   and refresh command.
1. Maintainer can run a repo-owned verification target that confirms each
   registry row resolves to the recorded upstream tag and commit without
   cloning or building the full upstream fork repositories.
1. Maintainer can inspect per-fork SPDX identifier, license source,
   attribution, provenance, and explicit non-free or network-plugin caution
   notes.
1. Maintainer can distinguish canonical release tags and peeled commits from
   drift-only branch-head observations.

**Plans**: 1 plan

Plans:
- [x] 32-01-PLAN.md — Create the fork vendor source registry, Git ref verifier, and maintainer documentation boundary.

### Phase 33: Inventory Templates and Source-Pinned Fork Inventories

**Goal**: Maintainers can classify fork features from pinned source baselines
before any downstream behavior becomes implementation scope.
**Depends on**: Phase 32
**Requirements**: INV-01, INV-02, INV-03, INV-04, INV-05
**Success Criteria** (what must be TRUE):

1. Maintainer can use a checked-in feature inventory template that requires
   source reference, ownership classification, feature surface, complexity,
   existing parity-surface dependency, v1.9 decision, and future parity notes
   for every row.
1. Maintainer can inspect source-pinned PrusaSlicer, Bambu Studio, and
   OrcaSlicer inventories that separate inherited base behavior, shared
   downstream behavior, and fork-specific behavior.
1. Maintainer can inspect Bambu and Orca inventory rows for project, profile,
   network, support, STEP, arc, assembly, calibration, wall/seam, adaptive
   mesh, library, and community-profile surfaces without treating them as
   verified runtime support.
1. Maintainer can inspect a cross-fork category map that classifies rows as
   base Slic3r, shared downstream, fork-specific, or unknown-needs-review,
   with deferred rows separated from future implementation candidates.

**Plans**: 1 plan

Plans:
- [x] 33-01-PLAN.md — Create the fork inventory package, source-pinned TSVs, verifier, tests, and port-doc links.

### Phase 34: Rust Flavor Contracts

**Goal**: Developers can model fork and flavor concepts as typed Rust domain
values before they reach core migration logic.
**Depends on**: Phase 33
**Requirements**: ARCH-01
**Success Criteria** (what must be TRUE):

1. Developer can use typed Rust contracts for downstream fork identity,
   flavor identity, vendor source identity, feature origin, parity surface,
   and checklist status.
1. Developer can parse raw vendor, flavor, source, feature, parity, and
   checklist strings into typed values at the boundary before they enter core
   logic.
1. Developer can rely on focused contract tests or examples that distinguish
   base Slic3r, shared downstream, and fork-specific values without raw
   vendor strings.

**Plans**: TBD

### Phase 35: Flavor Registry Boundary

**Goal**: Developers can inspect a single metadata boundary for flavor
composition without fork-specific core copies or side-effecting registry code.
**Depends on**: Phase 34
**Requirements**: ARCH-02, ARCH-03
**Success Criteria** (what must be TRUE):

1. Developer can inspect a documented module boundary that keeps base Slic3r
   behavior in shared core packages while future fork behavior plugs in
   through capability-oriented flavor metadata.
1. Developer can use or inspect a pure flavor registry boundary that maps
   base, shared downstream, and fork-specific metadata without performing
   Git, filesystem, network, process, or release operations.
1. Developer can trace registry metadata back to vendor source identities and
   inventory ownership labels without claiming runtime fork parity.
1. Developer can confirm future fork work does not require vendor-specific
   Rust workspaces or copied base behavior.

**Plans**: 3 plans

Plans:
- [x] 35-01-PLAN.md — Add static parity-surface constructors for registry data.
- [x] 35-02-PLAN.md — Create the pure `slic3r_flavors` crate, static registry metadata, lookup helpers, and verification wiring.
- [x] 35-03-PLAN.md — Document the flavor registry module boundary and metadata-only scope.

### Phase 36: Parity, Fixture, Launcher, and Deferral Templates

**Goal**: Maintainers have repeatable templates and vocabulary for future fork
parity work while v1.9 remains intake and architecture only.
**Depends on**: Phase 35
**Requirements**: PAR-01, PAR-02, PAR-03, PAR-04
**Success Criteria** (what must be TRUE):

1. Maintainer can use a fork parity checklist template that requires
   inventory row ID, source pin, candidate Rust module, fixture need,
   evidence command, docs touched, license or security note, deferred scope,
   and reviewer signoff before a future fork feature can be marked verified.
1. Maintainer can inspect documented fork fixture namespace and parity-status
   conventions that reserve verified fork status for future executable parity
   evidence, not source pins or inventories.
1. Maintainer can inspect v1.9 documentation that explicitly defers full fork
   parity ports, GUI migration, fork-flavor release builds, signing,
   installers, release channels, nightly vendor sync, cloud or network device
   integrations, profile auto-update execution, and non-free plugin
   ingestion.
1. Maintainer can run or follow a manual drift-refresh protocol that compares
   pinned vendor refs with current upstream heads before any later fork
   parity milestone begins.

**Plans**: TBD

## Coverage

| Requirement | Phase |
|-------------|-------|
| VEND-01 | Phase 32 |
| VEND-02 | Phase 32 |
| VEND-03 | Phase 32 |
| INV-01 | Phase 33 |
| INV-02 | Phase 33 |
| INV-03 | Phase 33 |
| INV-04 | Phase 33 |
| INV-05 | Phase 33 |
| ARCH-01 | Phase 34 |
| ARCH-02 | Phase 35 |
| ARCH-03 | Phase 35 |
| PAR-01 | Phase 36 |
| PAR-02 | Phase 36 |
| PAR-03 | Phase 36 |
| PAR-04 | Phase 36 |

Mapped: 15/15 v1 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 32 -> 33 -> 34 -> 35 -> 36

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 32. Vendor Source Manifest and License Baseline | 1/1 | Complete    | 2026-05-26 |
| 33. Inventory Templates and Source-Pinned Fork Inventories | 1/1 | Complete    | 2026-05-26 |
| 34. Rust Flavor Contracts | 1/1 | Complete    | 2026-05-26 |
| 35. Flavor Registry Boundary | 3/3 | Complete    | 2026-05-27 |
| 36. Parity, Fixture, Launcher, and Deferral Templates | 2/2 | Complete   | 2026-05-27 |

## Future Roadmap

Future milestones remain dependent on v1.9 intake and architecture:

- **v1.10 PrusaSlicer Parity Port** depends on v1.9 vendor intake,
  inventories, contracts, registry boundaries, and parity templates.
- **v1.11 Bambu Studio Parity Port** depends on v1.9 and any shared downstream
  modules proven during the PrusaSlicer port.
- **v1.12 OrcaSlicer Parity Port** depends on v1.9 and shared downstream
  modules proven during earlier fork ports.
- **v1.13 Fork Feature Documentation and Checklists** depends on completed
  fork parity ports.
- **v1.14 Cross-Flavor Build Automation** depends on verified fork behavior.
- **v1.15 Nightly Vendor Sync and Codex-Assisted Porting** depends on stable
  cross-flavor builds and review-gated refresh policy.
