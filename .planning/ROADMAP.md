# Roadmap: Slic3r Rust Port

## Milestones

- Shipped: **v1.10 PrusaSlicer Parity Evidence Foundation** - Phases 37-40
  (shipped 2026-06-02)
  Archive: [.planning/milestones/v1.10-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.10-ROADMAP.md)
- Future: **v1.11 PrusaSlicer Broader Parity Port** - Broaden Prusa parity
  after the first profile/config evidence slice is trusted
- Future: **v1.12 Bambu Studio Parity Port** - Modular Rust parity for Bambu
  Studio-specific behavior
- Future: **v1.13 OrcaSlicer Parity Port** - Modular Rust parity for
  OrcaSlicer-specific behavior
- Future: **v1.14 Fork Feature Documentation and Checklists** - Cross-fork
  feature catalogs, parity checklists, and gap docs
- Future: **v1.15 Cross-Flavor Build Automation** - GitHub Actions build
  matrix for every supported Slic3r-family flavor and platform
- Future: **v1.16 Nightly Vendor Sync and Codex-Assisted Porting** -
  review-gated automation for upstream fork refreshes and Rust feature merges
- Shipped: **v1.9 Fork Vendor Intake and Module Architecture** - Phases 32-36
  (shipped 2026-05-29)
  Archive: [.planning/milestones/v1.9-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-ROADMAP.md)
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

v1.10 is shipped and archived. There is no active phase in the live roadmap.
Start the next milestone with `/gsd-new-milestone` to create fresh
requirements and a new phase plan.

## Future Roadmap

Future milestones depend on the v1.10 evidence foundation:

- **v1.11 PrusaSlicer Broader Parity Port** depends on a trusted profile/config
  evidence path from v1.10.
- **v1.12 Bambu Studio Parity Port** depends on Prusa-family shared downstream
  evidence and any broader Prusa modules proven in v1.11.
- **v1.13 OrcaSlicer Parity Port** depends on Prusa/Bambu-family evidence and
  shared downstream modules from earlier fork ports.
- **v1.14 Fork Feature Documentation and Checklists** depends on completed fork
  parity ports.
- **v1.15 Cross-Flavor Build Automation** depends on verified fork behavior.
- **v1.16 Nightly Vendor Sync and Codex-Assisted Porting** depends on stable
  cross-flavor builds and review-gated refresh policy.
