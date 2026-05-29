# Roadmap: Slic3r Rust Port

## Milestones

- Shipped: **v1.9 Fork Vendor Intake and Module Architecture** - Phases 32-36
  (shipped 2026-05-29)
  Archive: [.planning/milestones/v1.9-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-ROADMAP.md)
- Future: **v1.10 PrusaSlicer Parity Port** - Modular Rust parity for
  PrusaSlicer-specific behavior
- Future: **v1.11 Bambu Studio Parity Port** - Modular Rust parity for Bambu
  Studio-specific behavior
- Future: **v1.12 OrcaSlicer Parity Port** - Modular Rust parity for
  OrcaSlicer-specific behavior
- Future: **v1.13 Fork Feature Documentation and Checklists** - Cross-fork
  feature catalogs, parity checklists, and gap docs
- Future: **v1.14 Cross-Flavor Build Automation** - GitHub Actions build
  matrix for every supported Slic3r-family flavor and platform
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

v1.9 shipped on 2026-05-29. The full v1.9 roadmap, requirements, audit, and
phase history are archived under `.planning/milestones/`, and the live
`.planning/phases/` directory no longer owns v1.9 phase work.

No active phases are currently planned. Start the next milestone with
`/gsd-new-milestone` so the next live requirements and roadmap are created from
fresh scope instead of carrying forward shipped v1.9 details.

## Overview

v1.9 established a maintainer-facing intake and architecture layer for
PrusaSlicer, Bambu Studio, and OrcaSlicer. The milestone pinned official vendor
source references, inventoried downstream feature ownership, defined typed Rust
flavor boundaries, created a pure shared flavor registry, and published parity
templates for later fork-port milestones without importing upstream source
trees or claiming runtime fork support.

## Archived Milestone Scope

<details>
<summary>v1.9 Fork Vendor Intake and Module Architecture (Phases 32-36) - shipped 2026-05-29</summary>

- [x] **Phase 32: Vendor Source Manifest and License Baseline** - Maintainers
  can inspect and verify pinned official fork source refs, lineage, and
  license/provenance notes.
- [x] **Phase 33: Inventory Templates and Source-Pinned Fork Inventories** -
  Maintainers can use source-pinned inventory templates and inspect initial
  PrusaSlicer, Bambu Studio, OrcaSlicer, and cross-fork classifications.
- [x] **Phase 34: Rust Flavor Contracts** - Developers can use typed Rust
  contracts for fork identity, vendor source identity, feature origins, parity
  surfaces, and checklist status.
- [x] **Phase 35: Flavor Registry Boundary** - Developers can inspect a pure
  flavor registry boundary that maps base, shared downstream, and fork-specific
  metadata without copied Rust workspaces.
- [x] **Phase 36: Parity, Fixture, Launcher, and Deferral Templates** -
  Maintainers can use fork parity, fixture namespace, launcher-shape, drift
  refresh, and deferral templates without overclaiming fork support.

Archive files:

- Roadmap: [.planning/milestones/v1.9-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-ROADMAP.md)
- Requirements: [.planning/milestones/v1.9-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-REQUIREMENTS.md)
- Audit: [.planning/milestones/v1.9-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-MILESTONE-AUDIT.md)
- Phase history: [.planning/milestones/v1.9-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-phases/)

</details>

## Future Roadmap

Future milestones depend on the v1.9 intake and architecture baseline:

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
