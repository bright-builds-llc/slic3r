# Roadmap: Slic3r Rust Port

## Milestones

- Shipped: **v1.12 PrusaSlicer G-code Output Evidence Foundation** - Phases
  45-48 (shipped 2026-06-15)
  Archive: [.planning/milestones/v1.12-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.12-ROADMAP.md)
  Requirements: [.planning/milestones/v1.12-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.12-REQUIREMENTS.md)
  Audit: [.planning/milestones/v1.12-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.12-MILESTONE-AUDIT.md)
  Phases: [.planning/milestones/v1.12-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.12-phases/)
- Shipped: **v1.11 PrusaSlicer Broader Parity Port** - Phases 41-44
  (shipped 2026-06-06)
  Archive: [.planning/milestones/v1.11-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.11-ROADMAP.md)
  Requirements: [.planning/milestones/v1.11-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.11-REQUIREMENTS.md)
  Audit: [.planning/milestones/v1.11-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.11-MILESTONE-AUDIT.md)
  Phases: [.planning/milestones/v1.11-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.11-phases/)
- Speculative revisit: **Non-Prusa Slicer-family ports** - Bambu Studio,
  OrcaSlicer, and other fork ports are paused and may be reconsidered only
  after an explicit new planning decision.
- Speculative revisit: **Cross-Flavor Build Automation and Vendor Sync** -
  paused until a future planning decision establishes verified non-Prusa fork
  behavior and review policy.
- Shipped: **v1.10 PrusaSlicer Parity Evidence Foundation** - Phases 37-40
  (shipped 2026-06-02)
  Archive: [.planning/milestones/v1.10-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.10-ROADMAP.md)
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

No active milestone is open. v1.12 shipped the narrow PrusaSlicer G-code output
evidence foundation: reviewed scope gate, source-pinned fixture, summary-only
expected artifact, typed Rust summary boundary, public Bazel parity command,
mutation guard, exact `fork.prusaslicer.gcode-output` status row, and
non-overclaiming docs.

The broad `generated-outputs` status row remains `in progress`, and
byte-for-byte G-code parity, broad generated-output parity, runtime/printer
behavior, geometry, support, seam, arc, STEP, GUI behavior, release,
network/device behavior, Bambu Studio, OrcaSlicer, upstream source imports,
and sync automation remain deferred.

## Next Milestone

Start the next milestone with `/gsd-new-milestone`. That workflow should define
fresh requirements before new phase work begins.

## Future Revisit Candidates

There are no scheduled non-Prusa fork port milestones in the active roadmap.
Only PrusaSlicer porting work is being considered in this repo for now.

- Non-Prusa Slicer-family ports, including Bambu Studio and OrcaSlicer, are
  paused parking-lot candidates until an explicit new planning decision moves
  one into the roadmap.
- Cross-flavor build automation is paused until verified fork behavior exists
  and a future planning decision defines supported flavors.
- Nightly vendor sync and Codex-assisted porting are paused until stable fork
  modules, executable evidence, and review-gated refresh policy exist.
