# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.10 PrusaSlicer Parity Evidence Foundation** - Phases 37-40
  (planned)
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

v1.10 is active. The milestone starts at Phase 37 because v1.9 ended at Phase
36, and it focuses on proving one narrow PrusaSlicer profile/config evidence
path before broader fork runtime support.

## Overview

v1.10 turns the v1.9 PrusaSlicer source pins, inventory rows, typed contracts,
flavor registry metadata, checklist template, fixture vocabulary, and drift
protocol into the first executable fork parity evidence. It intentionally
avoids full PrusaSlicer runtime parity, generated-output features, network
surfaces, fork release builds, Bambu Studio, OrcaSlicer, and vendor sync.

## Phases

**Phase Numbering:**

- Integer phases (37, 38, 39, 40): Planned milestone work

- Decimal phases (37.1, 37.2): Urgent insertions, if needed later

- This milestone starts at Phase 37 because Phase 36 shipped in v1.9

- [x] **Phase 37: Prusa Baseline and Checklist Gate** - Maintainers can (completed 2026-05-31)
  refresh the accepted Prusa source baseline manually, record reviewer-gated
  checklist decisions, and lock the narrow v1.10 scope before implementation.

- [x] **Phase 38: Prusa Fixture and Status Evidence Surface** - Maintainers can (completed 2026-06-01)
  inspect Prusa profile/config fixtures, fixture update rules, and status
  vocabulary that reserve verified claims for executable evidence.

- [ ] **Phase 39: Rust Prusa Profile Boundary** - Developers can parse and
  normalize Prusa profile/config fixtures into typed Rust domain values that
  trace back to v1.9 inventory and source metadata.

- [ ] **Phase 40: Executable Prusa Profile Parity** - Maintainers can run a
  repo-owned Bazel parity command that compares Rust-backed Prusa
  profile/config behavior against checked-in fixture expectations and publishes
  exact docs/status scope.

## Phase Details

### Phase 37: Prusa Baseline and Checklist Gate

**Goal**: Maintainers have a reviewed PrusaSlicer source/checklist package for
the narrow v1.10 profile/config evidence slice before implementation begins.
**Depends on**: Phase 36
**Requirements**: PRUSA-01, PRUSA-02, PRUSA-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run the manual PrusaSlicer drift-refresh protocol against the
   accepted v1.9 source pin and record selected stable tag confirmation, peeled
   commit confirmation, branch drift observation, reviewer decision, and
   reviewer signoff.
1. Maintainer can inspect completed checklist records for the selected Prusa
   profile schema/config evidence slice, including inventory row ID, source
   pin, candidate Rust module, fixture need, evidence command, docs touched,
   license or security note, deferred scope, and reviewer signoff.
1. Maintainer can distinguish the selected v1.10 profile/config evidence scope
   from deferred Prusa project files, STEP import, support generation, arc
   fitting, wall seam behavior, network/device integration, full fork runtime
   support, and fork release builds.

**Plans**: 1 plan

Plans:

- [x] 37-01-PLAN.md — Create the Prusa baseline records, fail-closed
  verifier, failure-mode tests, and port docs routing for the Phase 37 gate.

### Phase 38: Prusa Fixture and Status Evidence Surface

**Goal**: Maintainers have a real fixture/status surface for Prusa
profile/config evidence before Rust parsing or parity commands rely on it.
**Depends on**: Phase 37
**Requirements**: EVID-01, EVID-02, EVID-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect a Prusa fixture namespace and update rules in the
   parity fixture package for the profile/config evidence slice.
1. Maintainer can inspect checked-in Prusa profile/config fixtures that trace
   to the accepted Prusa source pin and are suitable for rerunnable executable
   parity checks.
1. Maintainer can inspect parity status vocabulary or status rows that reserve
   verified Prusa status for the v1.10 executable evidence command only.
1. Maintainer can confirm no Bambu Studio, OrcaSlicer, network, cloud,
   credential, or non-free plugin fixtures were introduced by this milestone.

**Plans**: 1 plan

Plans:

- [x] 38-01-PLAN.md — Create the static Prusa profile-schema fixture bundle,
  provenance manifest, Bazel verifier, failure-mode tests, and docs/status
  vocabulary guards without publishing a Prusa status row.

### Phase 39: Rust Prusa Profile Boundary

**Goal**: Developers can parse the v1.10 Prusa profile/config evidence into
typed, side-effect-free Rust domain values that trace back to source metadata.
**Depends on**: Phase 38
**Requirements**: PROF-01, PROF-02, PROF-03
**Success Criteria** (what must be TRUE):

1. Developer can parse the v1.10 Prusa profile/config fixtures into typed Rust
   domain values before the data reaches core profile or config logic.
1. Developer can trace the Prusa profile schema/config capability from Rust
   metadata back to the Prusa inventory row, accepted vendor source identity,
   source path, and checklist status.
1. Developer can verify Prusa profile/config parsing and normalization logic
   with focused Rust unit tests.
1. Developer can confirm the new Rust logic performs no Git, network,
   filesystem discovery, process, release, or vendor sync operations.

**Plans**: TBD

### Phase 40: Executable Prusa Profile Parity

**Goal**: Maintainers can run and trust the first executable PrusaSlicer parity
command while docs and status clearly limit what was verified.
**Depends on**: Phase 39
**Requirements**: PPAR-01, PPAR-02, PPAR-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run a repo-owned Bazel parity command for the Prusa
   profile/config evidence slice.
1. Maintainer can see the Prusa parity command fail when Rust-backed parsed or
   normalized profile/config output diverges from checked-in Prusa fixture
   expectations.
1. Maintainer can inspect docs and parity status updates that name the exact
   verified Prusa profile/config evidence slice.
1. Maintainer can confirm full PrusaSlicer runtime support, GUI support,
   generated-output parity, fork release builds, and sync automation remain
   deferred.

**Plans**: TBD

## Coverage

| Requirement | Phase |
|-------------|-------|
| PRUSA-01 | Phase 37 |
| PRUSA-02 | Phase 37 |
| PRUSA-03 | Phase 37 |
| EVID-01 | Phase 38 |
| EVID-02 | Phase 38 |
| EVID-03 | Phase 38 |
| PROF-01 | Phase 39 |
| PROF-02 | Phase 39 |
| PROF-03 | Phase 39 |
| PPAR-01 | Phase 40 |
| PPAR-02 | Phase 40 |
| PPAR-03 | Phase 40 |

Mapped: 12/12 v1.10 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 37 -> 38 -> 39 -> 40

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 37. Prusa Baseline and Checklist Gate | 1/1 | Complete    | 2026-06-01 |
| 38. Prusa Fixture and Status Evidence Surface | 1/1 | Complete    | 2026-06-01 |
| 39. Rust Prusa Profile Boundary | 0/TBD | Not Started | - |
| 40. Executable Prusa Profile Parity | 0/TBD | Not Started | - |

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
