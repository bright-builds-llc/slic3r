# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.12 PrusaSlicer G-code Output Evidence Foundation** - Phases
  45-48 (planned)
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

v1.12 is active. The milestone starts at Phase 45 because v1.11 ended at Phase
44, and it focuses on one summary-only PrusaSlicer G-code output evidence
path. The broad `generated-outputs` status row remains in progress; this
milestone may only publish the exact `fork.prusaslicer.gcode-output` row after
executable evidence passes.

## Overview

v1.12 proves the foundation for a narrow PrusaSlicer G-code output evidence
slice. It follows the v1.10 and v1.11 evidence ladder: reviewed scope gate,
source-pinned fixture, summary-only expected artifact, typed Rust summary
boundary, public Bazel parity command, mutation guard, exact status row, and
non-overclaiming docs.

The milestone intentionally avoids byte-for-byte G-code parity, broad
generated-output verification, toolpath geometry, extrusion, timing, support
generation, wall seam behavior, arc fitting, STEP import, full 3MF
import/export, printer-runtime behavior, firmware or printability behavior,
desktop app behavior, binary G-code, thumbnails, post-processing, host upload,
network/device integration, profile auto-update execution, fork release
builds, and sync automation.

## Phases

**Phase Numbering:**

- Integer phases (45, 46, 47, 48): Planned milestone work

- Decimal phases (45.1, 45.2): Urgent insertions, if needed later

- This milestone starts at Phase 45 because Phase 44 shipped in v1.11

- [ ] **Phase 45: Prusa G-code Output Scope Gate** - Maintainers can inspect
  and verify the reviewed `prusaslicer.gcode-output` scope contract before
  fixture, Rust, parity, or status work lands.

- [ ] **Phase 46: Prusa G-code Fixture Surface** - Maintainers can inspect and
  verify the source-pinned Prusa `.gcode` fixture surface and summary-only
  expected artifact.

- [ ] **Phase 47: Rust Prusa G-code Summary Boundary** - Developers can use
  and test the typed Rust boundary that summarizes stable G-code metadata and
  markers without side effects or broad claims.

- [ ] **Phase 48: Executable Prusa G-code Evidence** - Maintainers can run
  fail-closed Bazel evidence and inspect exact status/docs for the narrow
  Prusa G-code slice.

## Phase Details

### Phase 45: Prusa G-code Output Scope Gate

**Goal**: Maintainers have a reviewed Prusa G-code output scope package for
the narrow v1.12 summary-only evidence contract before implementation begins.
**Depends on**: Phase 44
**Requirements**: PGSEL-01, PGSEL-02
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect the `prusaslicer.gcode-output` scope record with the
   accepted source identity, fixture source decision, expected-summary
   contract, candidate Rust boundary, planned evidence command, planned status
   token, docs touched, license/security note, deferred scope, and reviewer
   signoff.
1. Maintainer can run the scope verifier and see it pass only while fixture
   bytes, Rust summary work, parity command, and verified status publication
   remain absent ahead of scope approval.
1. Maintainer can distinguish the v1.12 contract from byte-for-byte G-code
   parity, broad generated-output verification, runtime/printer behavior,
   geometry, support, seam, arc, STEP, release, network, and sync claims.

**Plans**: TBD

### Phase 46: Prusa G-code Fixture Surface

**Goal**: Maintainers have a source-pinned Prusa G-code fixture and
summary-only expected artifact before Rust summary or parity commands rely on
it.
**Depends on**: Phase 45
**Requirements**: PGFIX-01, PGFIX-02
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect a dedicated Prusa fixture namespace containing one
   small reviewed ASCII `.gcode` fixture, provenance, update rules, byte
   count, SHA-256, line-ending/encoding policy, and
   `expected-gcode-summary.tsv` traced to the Phase 45 scope gate.
1. Maintainer can run a repo-owned fixture verifier that fails when required
   fixture provenance, checksums, line-ending policy, expected-summary shape,
   update rules, privacy/post-processing exclusions, or non-overclaiming scope
   text are missing or inconsistent.
1. Maintainer can confirm the fixture surface excludes base export fixture
   reuse, live generation, upstream fetching/importing, binary G-code,
   thumbnails, post-processing, and host upload behavior.

**Plans**: TBD

### Phase 47: Rust Prusa G-code Summary Boundary

**Goal**: Developers can summarize the selected Prusa G-code evidence into
typed, side-effect-free Rust values that trace back to source and fixture
metadata.
**Depends on**: Phase 46
**Requirements**: PGSUM-01, PGSUM-02, PGSUM-03
**Success Criteria** (what must be TRUE):

1. Developer can summarize the selected Prusa G-code fixture into typed Rust
   values for stable metadata and marker evidence before data reaches shared
   parity or status publication logic.
1. Developer can trace the Prusa G-code output capability from Rust metadata
   back to the accepted source identity, fixture namespace, raw fixture path,
   expected summary artifact, planned status token, and broad
   generated-output deferrals.
1. Developer can run focused Rust unit tests that reject unsupported evidence
   kinds, overclaiming notes, wrong source refs, wrong fixture paths, missing
   rows, duplicate rows, extra rows, and wrong ordering.
1. Developer can confirm the Rust core performs no Git, network, filesystem
   discovery, process execution, upstream source import, release,
   printer-runtime, profile-update, or vendor sync operations.

**Plans**: TBD

### Phase 48: Executable Prusa G-code Evidence

**Goal**: Maintainers can run and trust the summary-only Prusa G-code evidence
command while docs and status clearly limit what was verified.
**Depends on**: Phase 47
**Requirements**: PGEV-01, PGEV-02, PGEV-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run `bazel run //packages/parity:prusaslicer_gcode_output_parity`
   for the selected summary-only Prusa G-code output evidence slice.
1. Maintainer can see the evidence command or mutation guard fail when the
   Rust-backed summary or checked-in expected summary artifact diverges from
   fixture expectations.
1. Maintainer can inspect the exact `fork.prusaslicer.gcode-output` status row
   and related docs while the broad `generated-outputs` status row remains in
   progress.
1. Maintainer can read docs that name the exact verified slice while keeping
   byte-for-byte G-code parity, full generated-output parity, runtime/printer
   behavior, geometry, support, seam, arc, STEP, desktop app behavior,
   release, network, and sync surfaces deferred.

**Plans**: TBD

## Coverage

| Requirement | Phase |
|-------------|-------|
| PGSEL-01 | Phase 45 |
| PGSEL-02 | Phase 45 |
| PGFIX-01 | Phase 46 |
| PGFIX-02 | Phase 46 |
| PGSUM-01 | Phase 47 |
| PGSUM-02 | Phase 47 |
| PGSUM-03 | Phase 47 |
| PGEV-01 | Phase 48 |
| PGEV-02 | Phase 48 |
| PGEV-03 | Phase 48 |

Mapped: 10/10 v1.12 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 45 -> 46 -> 47 -> 48

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 45. Prusa G-code Output Scope Gate | 0/TBD | Not started | - |
| 46. Prusa G-code Fixture Surface | 0/TBD | Not started | - |
| 47. Rust Prusa G-code Summary Boundary | 0/TBD | Not started | - |
| 48. Executable Prusa G-code Evidence | 0/TBD | Not started | - |

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
