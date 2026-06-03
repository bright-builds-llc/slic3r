# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.11 PrusaSlicer Broader Parity Port** - Phases 41-44
  (planned)
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

v1.11 is active. The milestone starts at Phase 41 because v1.10 ended at Phase
40, and it focuses on proving a narrow PrusaSlicer project-file evidence slice
after the profile/config evidence path is trusted.

## Overview

v1.11 promotes `prusaslicer.project-file` from source-observed future candidate
to executable evidence. It reuses the v1.10 trust chain: reviewed source and
scope gate, source-pinned fixtures, typed Rust boundary, checked-in expected
artifact, public Bazel parity command, divergence guard, exact status row, and
non-overclaiming docs.

The milestone intentionally avoids full PrusaSlicer runtime parity, GUI
project behavior, full 3MF import/export, generated-output parity, STEP import,
support generation, arc fitting, wall seam behavior, network/device surfaces,
fork release builds, non-Prusa Slicer-family ports such as Bambu Studio or
OrcaSlicer, and vendor sync automation.

## Phases

**Phase Numbering:**

- Integer phases (41, 42, 43, 44): Planned milestone work

- Decimal phases (41.1, 41.2): Urgent insertions, if needed later

- This milestone starts at Phase 41 because Phase 40 shipped in v1.10

- [x] **Phase 41: Prusa Project-File Scope Gate** - Maintainers can review and (completed 2026-06-03)
  lock the exact `prusaslicer.project-file` evidence contract before fixtures,
  parser work, or status claims are created.

- [ ] **Phase 42: Prusa Project-File Fixture Surface** - Maintainers can
  inspect checked-in project-file fixtures, provenance, expected artifacts, and
  fail-closed fixture verification for the selected evidence contract.

- [ ] **Phase 43: Rust Prusa Project-File Boundary** - Developers can parse or
  summarize the selected project-file evidence into typed, side-effect-free
  Rust domain values that trace back to the source and fixture metadata.

- [ ] **Phase 44: Executable Prusa Project-File Parity** - Maintainers can run
  and trust the public project-file parity command while docs and status limit
  the verified claim to the exact evidence slice.

## Phase Details

### Phase 41: Prusa Project-File Scope Gate

**Goal**: Maintainers have a reviewed Prusa project-file scope package for the
narrow v1.11 evidence contract before implementation begins.
**Depends on**: Phase 40
**Requirements**: PSEL-01, PSEL-02
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect the `prusaslicer.project-file` scope record with the
   accepted source identity, inventory row, fixture source decision,
   expected-artifact contract, candidate Rust boundary, planned evidence
   command, docs touched, license or security note, deferred scope, and
   reviewer signoff.
1. Maintainer can distinguish the narrow v1.11 project-file evidence contract
   from full 3MF import/export, full PrusaSlicer runtime support, GUI project
   behavior, generated-output parity, STEP import, support generation, arc
   fitting, wall seam behavior, network/device integration, profile
   auto-update execution, fork release builds, and sync automation.

**Plans**: 1 plan

Plans:

- [x] 41-01-PLAN.md - Create the checked-in Prusa project-file scope record,
  fail-closed verifier, and non-overclaiming docs route.

### Phase 42: Prusa Project-File Fixture Surface

**Goal**: Maintainers have a real fixture and expected-artifact surface for the
selected Prusa project-file evidence contract before Rust parsing or parity
commands rely on it.
**Depends on**: Phase 41
**Requirements**: PFIX-01, PFIX-02
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect a Prusa project-file fixture namespace, provenance
   manifest, update rules, and checked-in expected artifact that trace to the
   Phase 41 scope gate and accepted source decision.
1. Maintainer can run a repo-owned fixture verifier that fails when required
   project-file fixture provenance, expected artifacts, update rules, or
   non-overclaiming scope text are missing or inconsistent.

**Plans**: 0 plans yet

### Phase 43: Rust Prusa Project-File Boundary

**Goal**: Developers can parse or summarize the v1.11 Prusa project-file
evidence into typed, side-effect-free Rust domain values that trace back to
source metadata.
**Depends on**: Phase 42
**Requirements**: PPROJ-01, PPROJ-02, PPROJ-03
**Success Criteria** (what must be TRUE):

1. Developer can parse or summarize the selected Prusa project-file fixture
   evidence into typed Rust domain values before data reaches shared core
   profile, file-format, or config logic.
1. Developer can trace the Prusa project-file capability from Rust metadata
   back to the Prusa inventory row, accepted vendor source identity, source
   path or reviewed sample source, fixture path, checklist path, and planned
   status token.
1. Developer can verify Prusa project-file summary or parsing logic with
   focused Rust unit tests.
1. Developer can confirm the new Rust logic performs no Git, network,
   filesystem discovery, process, release, or vendor sync operations.

**Plans**: 0 plans yet

### Phase 44: Executable Prusa Project-File Parity

**Goal**: Maintainers can run and trust the project-file parity command while
docs and status clearly limit what was verified.
**Depends on**: Phase 43
**Requirements**: PPEV-01, PPEV-02, PPEV-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run a repo-owned Bazel parity command for the selected Prusa
   project-file evidence slice.
1. Maintainer can see the project-file parity command fail when the
   Rust-backed summary or checked-in expected artifact diverges from fixture
   expectations.
1. Maintainer can inspect docs and parity status updates that name the exact
   verified project-file evidence slice.
1. Maintainer can confirm full PrusaSlicer runtime support, GUI support,
   generated-output parity, STEP import, support generation, arc fitting, wall
   seam behavior, fork release builds, network/device integration, profile
   auto-update execution, and sync automation remain deferred.

**Plans**: 0 plans yet

## Coverage

| Requirement | Phase |
|-------------|-------|
| PSEL-01 | Phase 41 |
| PSEL-02 | Phase 41 |
| PFIX-01 | Phase 42 |
| PFIX-02 | Phase 42 |
| PPROJ-01 | Phase 43 |
| PPROJ-02 | Phase 43 |
| PPROJ-03 | Phase 43 |
| PPEV-01 | Phase 44 |
| PPEV-02 | Phase 44 |
| PPEV-03 | Phase 44 |

Mapped: 10/10 v1.11 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 41 -> 42 -> 43 -> 44

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 41. Prusa Project-File Scope Gate | 1/1 | Complete | 2026-06-03 |
| 42. Prusa Project-File Fixture Surface | 0/0 | Pending | - |
| 43. Rust Prusa Project-File Boundary | 0/0 | Pending | - |
| 44. Executable Prusa Project-File Parity | 0/0 | Pending | - |

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
