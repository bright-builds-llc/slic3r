# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.13 PrusaSlicer G-code Structural Evidence Expansion** - Phases
  49-52 (planned)
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

v1.13 is active. The milestone starts at Phase 49 because v1.12 ended at Phase
48, and it expands the narrow `fork.prusaslicer.gcode-output` evidence path
from marker-level summary metadata into structural G-code evidence.

The broad `generated-outputs` status row remains `in progress`. This milestone
does not claim byte-for-byte G-code parity, geometry/toolpath parity,
printability, printer-runtime behavior, support generation, wall seam behavior,
arc fitting, GUI export/viewer behavior, release behavior, network/device
behavior, non-Prusa fork behavior, upstream source imports, or sync automation.
Active downstream-fork port planning remains limited to PrusaSlicer.

## Overview

v1.13 strengthens the existing PrusaSlicer G-code evidence chain in four
steps: a reviewed structural scope contract, a source-pinned fixture expansion,
a typed Rust structural summary boundary, and executable structural evidence
with public status/docs updates. Each phase preserves the v1.12 narrow
evidence ladder while making the summary more meaningful through stable
command/section counts, ordered markers, movement/extrusion indicators,
temperature/tool-change markers, source identity, and fixture identity.

## Phases

**Phase Numbering:**

- Integer phases (49, 50, 51, 52): Planned milestone work

- Decimal phases (49.1, 49.2): Urgent insertions, if needed later

- This milestone starts at Phase 49 because Phase 48 shipped in v1.12

- [x] **Phase 49: Structural G-code Scope Contract** - Maintainers can inspect (completed 2026-06-16)
  and verify the allowed structural G-code evidence contract before fixtures,
  Rust boundaries, or executable evidence expand.

- [ ] **Phase 50: Structural G-code Fixture Expansion** - Maintainers can
  inspect and verify source-pinned Prusa structural summary fixtures with
  fail-closed drift guards.

- [ ] **Phase 51: Rust Structural G-code Summary Boundary** - Developers can
  parse, test, and trace the structural Prusa G-code summary through a pure
  typed Rust boundary.

- [ ] **Phase 52: Executable Structural G-code Evidence** - Maintainers can
  run public fail-closed structural evidence and inspect exact narrow
  status/docs for the Prusa G-code slice.

## Phase Details

### Phase 49: Structural G-code Scope Contract

**Goal**: Maintainers have a reviewed structural Prusa G-code scope contract
that allows only the v1.13 evidence fields and keeps broader generated-output
claims forbidden.
**Depends on**: Phase 48
**Requirements**: GCSCOPE-01, GCSCOPE-02, GCSCOPE-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect the structural G-code scope contract with allowed
   evidence fields for command counts, section counts, ordered markers,
   movement/extrusion indicators, temperature/tool-change markers, source
   identity, and fixture identity.
1. Maintainer can run the scope verifier and see it fail closed when v1.13
   artifacts claim byte-for-byte G-code parity, geometry/toolpath parity,
   printability, printer-runtime behavior, support generation, wall seam
   behavior, arc fitting, GUI export/viewer behavior, release behavior,
   network/device behavior, non-Prusa fork behavior, upstream source imports,
   or sync automation.
1. Maintainer can trace the structural evidence scope to the accepted
   `prusaslicer.gcode-output` inventory row and the v1.12 fixture/status path
   while the broad `generated-outputs` status row remains in progress.

**Plans**: 2 plans

Plans:

- [x] 49-01-PLAN.md — Add the reviewed structural field contract and traceability surface.
- [x] 49-02-PLAN.md — Enforce the structural scope contract through fail-closed verifier and mutation coverage.

### Phase 50: Structural G-code Fixture Expansion

**Goal**: Maintainers have source-pinned Prusa structural G-code fixture
expectations that are verifiable before Rust structural parsing or parity
commands rely on them.
**Depends on**: Phase 49
**Requirements**: GCFIX-01, GCFIX-02, GCFIX-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect the expanded Prusa G-code fixture surface with a
   checked-in expected structural summary artifact for the accepted Prusa
   `set_speed` evidence slice.
1. Maintainer can run a Bazel-owned fixture verifier that checks the exact
   structural summary schema, required rows, provenance, and update rules.
1. Maintainer can see fixture mutation tests fail closed for structural
   summary drift, missing rows, duplicate rows, unsupported fields,
   unsupported broad-behavior claims, and provenance mismatch.

**Plans**: TBD

### Phase 51: Rust Structural G-code Summary Boundary

**Goal**: Developers can parse and expose the v1.13 structural Prusa G-code
summary through a pure typed Rust boundary without side effects or premature
status publication.
**Depends on**: Phase 50
**Requirements**: GCRUST-01, GCRUST-02, GCRUST-03
**Success Criteria** (what must be TRUE):

1. Developer can parse the v1.13 expected structural summary artifact through
   a pure typed Rust boundary in `slic3r_flavors`.
1. Developer can run Cargo and Bazel tests proving the Rust structural
   boundary rejects invalid headers, wrong column counts, missing rows,
   duplicate rows, out-of-order rows, unsupported structural fields,
   unsupported claim text, wrong source refs, and wrong fixture identities.
1. Developer can inspect registry metadata that exposes structural Prusa
   G-code evidence readiness without filesystem discovery, Git, network,
   process execution, release behavior, sync behavior, or premature broad
   generated-output status publication.

**Plans**: TBD

### Phase 52: Executable Structural G-code Evidence

**Goal**: Maintainers can run structural Prusa G-code evidence and inspect
status/docs that publish only the exact narrow evidence slice.
**Depends on**: Phase 51
**Requirements**: GCEV-01, GCEV-02, GCEV-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run a public Bazel parity command that validates the
   structural Prusa G-code expected summary through the Rust boundary and
   checked-in fixture expectations.
1. Maintainer can see the public parity command fail closed on a
   structural-summary mutation guard, not only the v1.12 marker-line drift
   guard.
1. Maintainer can inspect parity status, package docs, and port docs that
   describe the exact narrow `fork.prusaslicer.gcode-output` structural
   evidence slice while keeping broad `generated-outputs` in progress and all
   deferred generated-output, runtime, and fork surfaces explicit.

**Plans**: TBD

## Coverage

| Requirement | Phase |
|-------------|-------|
| GCSCOPE-01 | Phase 49 |
| GCSCOPE-02 | Phase 49 |
| GCSCOPE-03 | Phase 49 |
| GCFIX-01 | Phase 50 |
| GCFIX-02 | Phase 50 |
| GCFIX-03 | Phase 50 |
| GCRUST-01 | Phase 51 |
| GCRUST-02 | Phase 51 |
| GCRUST-03 | Phase 51 |
| GCEV-01 | Phase 52 |
| GCEV-02 | Phase 52 |
| GCEV-03 | Phase 52 |

Mapped: 12/12 v1.13 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 49 -> 50 -> 51 -> 52

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 49. Structural G-code Scope Contract | 2/2 | Complete   | 2026-06-16 |
| 50. Structural G-code Fixture Expansion | 0/TBD | Not started | - |
| 51. Rust Structural G-code Summary Boundary | 0/TBD | Not started | - |
| 52. Executable Structural G-code Evidence | 0/TBD | Not started | - |

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
