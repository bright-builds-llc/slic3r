# Roadmap: Slic3r Rust Port

## Milestones

- Next: **v1.9 Fork Vendor Intake and Module Architecture** - PrusaSlicer,
  Bambu Studio, and OrcaSlicer vendor references, feature inventories, and
  modular port boundaries
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

No active milestone is open. v1.8 is archived, and the next step is to start
the v1.9 milestone cycle with fresh requirements.

## Shipped Milestone Details

<details>
<summary>v1.8 Cross-Platform Release Build Automation (Phase 31) - shipped 2026-05-24</summary>

- [x] Phase 31: Cross-Platform Release Build Workflow (1/1 plans) - completed
  2026-05-24
- Archive: [.planning/milestones/v1.8-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-ROADMAP.md)
- Requirements archive:
  [.planning/milestones/v1.8-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-REQUIREMENTS.md)
- Audit:
  [.planning/milestones/v1.8-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-MILESTONE-AUDIT.md)

</details>

## Future Roadmap

These entries are future milestone candidates after the shipped v1.8 release
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

## Progress

| Milestone | Phases | Plans | Status | Shipped |
| --- | --- | --- | --- | --- |
| v1.8 Cross-Platform Release Build Automation | 31 | 1/1 | Shipped | 2026-05-24 |

## Next Step

Run `/gsd-new-milestone v1.9 Fork Vendor Intake and Module Architecture` to
create fresh requirements and an active roadmap for the next milestone.
