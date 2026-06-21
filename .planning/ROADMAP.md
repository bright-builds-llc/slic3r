# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.14 PrusaSlicer G-code Semantic Evidence Foundation** - Phases
  53-56 (planned)
- Shipped: **v1.13 PrusaSlicer G-code Structural Evidence Expansion** -
  Phases 49-52 (shipped 2026-06-19)
  Archive: [.planning/milestones/v1.13-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.13-ROADMAP.md)
  Requirements: [.planning/milestones/v1.13-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.13-REQUIREMENTS.md)
  Audit: [.planning/milestones/v1.13-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.13-MILESTONE-AUDIT.md)
  Phases: [.planning/milestones/v1.13-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.13-phases/)
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

v1.14 is active. The milestone starts at Phase 53 because v1.13 ended at Phase
52, and it deepens the verified narrow `fork.prusaslicer.gcode-output`
evidence path from structural facts into semantic toolpath evidence.

The broad `generated-outputs` status row remains `in progress`. This milestone
does not claim byte-for-byte G-code parity, printability, printer-runtime
behavior, support generation, wall seam behavior, arc fitting, GUI
export/viewer behavior, release behavior, network/device behavior, non-Prusa
fork behavior, upstream source imports, sync automation, or broad
generated-output verification. Active downstream-fork port planning remains
limited to PrusaSlicer.

External ecosystem research was skipped for this milestone because v1.14 is an
internal evidence-contract expansion over existing repo artifacts, not a new
domain feature.

## Overview

v1.14 strengthens the existing PrusaSlicer G-code evidence chain in four
steps: a reviewed semantic scope contract, a source-pinned semantic fixture
corpus, a typed Rust semantic summary boundary, and executable semantic
evidence with public status/docs updates. Each phase preserves the v1.12 and
v1.13 narrow evidence ladder while making the checked-in summaries more useful
through stable movement classes, command classes, coordinate bounds, extrusion
totals, feedrate observations, layer or marker relationships, source identity,
and fixture identity.

## Phases

**Phase Numbering:**

- Integer phases (53, 54, 55, 56): Planned milestone work
- Decimal phases (53.1, 53.2): Urgent insertions, if needed later
- This milestone starts at Phase 53 because Phase 52 shipped in v1.13

- [x] **Phase 53: Semantic G-code Scope Contract** - Maintainers can inspect (completed 2026-06-21)
  and verify the allowed semantic G-code evidence contract before the fixture
  corpus, Rust semantic parser, or executable semantic evidence expands.

- [x] **Phase 54: Semantic G-code Fixture Corpus** - Maintainers can inspect (completed 2026-06-21)
  and verify source-pinned Prusa semantic summary fixtures with fail-closed
  drift guards.

- [x] **Phase 55: Rust Semantic G-code Summary Boundary** - Developers can (completed 2026-06-21)
  parse, test, and trace semantic Prusa G-code summaries through a pure typed
  Rust boundary.

- [x] **Phase 56: Executable Semantic G-code Evidence** - Maintainers can run (completed 2026-06-21)
  public fail-closed semantic evidence and inspect exact narrow status/docs
  for the Prusa G-code slice.

## Phase Details

### Phase 53: Semantic G-code Scope Contract

**Goal**: Maintainers have a reviewed semantic Prusa G-code scope contract
that allows only the v1.14 evidence fields and keeps broader generated-output
claims forbidden.
**Depends on**: Phase 52
**Requirements**: GSSCOPE-01, GSSCOPE-02, GSSCOPE-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect the semantic G-code scope contract with allowed
   evidence fields for command classes, movement classes, coordinate bounds,
   extrusion totals, feedrate observations, layer or marker relationships,
   source identity, and fixture identity.
1. Maintainer can run the scope verifier and see it fail closed when v1.14
   artifacts claim byte-for-byte G-code parity, printability,
   printer-runtime behavior, support generation, wall seam behavior, arc
   fitting, GUI export/viewer behavior, release behavior, network/device
   behavior, non-Prusa fork behavior, upstream source imports, sync
   automation, or broad generated-output verification.
1. Maintainer can trace the semantic evidence scope to the accepted
   `prusaslicer.gcode-output` inventory row and the v1.12/v1.13 fixture,
   Rust, parity, and status path while the broad `generated-outputs` status
   row remains in progress.

**Plans**: 2 plans

Plans:

- [x] 53-01-PLAN.md - Add the reviewed semantic field contract and
  traceability surface.
- [x] 53-02-PLAN.md - Enforce the semantic scope contract through fail-closed
  verifier and mutation coverage.

### Phase 54: Semantic G-code Fixture Corpus

**Goal**: Maintainers have source-pinned Prusa semantic G-code fixture
expectations that are verifiable before Rust semantic parsing or parity
commands rely on them.
**Depends on**: Phase 53
**Requirements**: GSFIX-01, GSFIX-02, GSFIX-03
**Success Criteria** (what must be TRUE):

1. Maintainer can inspect a small reviewed Prusa G-code semantic fixture corpus
   with checked-in expected semantic summary artifacts and explicit source,
   fixture, and update-route provenance.
1. Maintainer can run a Bazel-owned fixture verifier that checks the exact
   semantic summary schema, required rows, approved fields, provenance, docs,
   and update rules.
1. Maintainer can see fixture mutation tests fail closed for semantic summary
   drift, missing rows, duplicate rows, out-of-order rows, unsupported fields,
   unsupported broad-behavior claims, and provenance mismatch.

**Plans**: 2 plans

Plans:

- [x] 54-01-PLAN.md - Add the semantic fixture corpus and expected-summary
  artifacts with narrow fixture docs.
- [x] 54-02-PLAN.md - Extend fixture verification and mutation coverage for
  semantic drift.

### Phase 55: Rust Semantic G-code Summary Boundary

**Goal**: Developers can parse and expose the v1.14 semantic Prusa G-code
summary through a pure typed Rust boundary without side effects or premature
status publication.
**Depends on**: Phase 54
**Requirements**: GSRUST-01, GSRUST-02, GSRUST-03
**Success Criteria** (what must be TRUE):

1. Developer can parse the v1.14 expected semantic summary artifacts through a
   pure typed Rust boundary in `slic3r_flavors`.
1. Developer can run Cargo and Bazel tests proving the Rust semantic boundary
   rejects invalid headers, wrong column counts, missing rows, duplicate rows,
   out-of-order rows, unsupported semantic fields, unsupported claim text,
   wrong source refs, and wrong fixture identities.
1. Developer can inspect readiness metadata that exposes semantic Prusa G-code
   evidence readiness without filesystem discovery, Git, network, process
   execution, generator behavior, printer-runtime behavior, release behavior,
   sync behavior, or premature broad generated-output status publication.

**Plans**: 2 plans

Plans:

- [x] 55-01-PLAN.md - Add the pure typed semantic summary parser and
  Cargo/Bazel rejection coverage.
- [x] 55-02-PLAN.md - Expose semantic readiness metadata through the existing
  registry boundary without status publication.

### Phase 56: Executable Semantic G-code Evidence

**Goal**: Maintainers can run semantic Prusa G-code evidence and inspect
status/docs that publish only the exact narrow evidence slice.
**Depends on**: Phase 55
**Requirements**: GSEV-01, GSEV-02, GSEV-03
**Success Criteria** (what must be TRUE):

1. Maintainer can run public Bazel parity evidence that validates marker
   summary, structural summary, and semantic summary artifacts through the
   Rust boundary and checked-in fixture expectations.
1. Maintainer can see public parity evidence fail closed on semantic mutation
   guards for movement class changes, coordinate-bound changes, extrusion
   total changes, feedrate observation changes, fixture identity drift, and
   unsupported deferred-behavior claims.
1. Maintainer can inspect parity status, package docs, and port docs that
   describe the exact narrow `fork.prusaslicer.gcode-output` semantic evidence
   slice while keeping broad `generated-outputs` in progress and all deferred
   generated-output, runtime, GUI, release, sync, and non-Prusa fork surfaces
   explicit.

**Plans**: 5 plans

Plans:

- [x] 56-01-PLAN.md - Extend public parity evidence with semantic summary
  validation through Rust.
- [x] 56-02-PLAN.md - Add focused semantic mutation guards for public evidence
  drift.
- [x] 56-03-PLAN.md - Publish semantic status wording and reconcile fixture
  verifier enforcement.
- [x] 56-04-PLAN.md - Update scope and package docs for the semantic evidence
  chain.
- [x] 56-05-PLAN.md - Update port docs while keeping broad generated outputs
  in progress.

## Coverage

| Requirement | Phase |
|-------------|-------|
| GSSCOPE-01 | Phase 53 |
| GSSCOPE-02 | Phase 53 |
| GSSCOPE-03 | Phase 53 |
| GSFIX-01 | Phase 54 |
| GSFIX-02 | Phase 54 |
| GSFIX-03 | Phase 54 |
| GSRUST-01 | Phase 55 |
| GSRUST-02 | Phase 55 |
| GSRUST-03 | Phase 55 |
| GSEV-01 | Phase 56 |
| GSEV-02 | Phase 56 |
| GSEV-03 | Phase 56 |

Mapped: 12/12 v1.14 requirements.

## Progress

**Execution Order:**
Phases execute in numeric order: 53 -> 54 -> 55 -> 56

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 53. Semantic G-code Scope Contract | 2/2 | Complete   | 2026-06-21 |
| 54. Semantic G-code Fixture Corpus | 2/2 | Complete    | 2026-06-21 |
| 55. Rust Semantic G-code Summary Boundary | 2/2 | Complete    | 2026-06-21 |
| 56. Executable Semantic G-code Evidence | 5/5 | Complete   | 2026-06-21 |

## Future Revisit Candidates

There are no scheduled non-Prusa fork port milestones in the active roadmap.
Only PrusaSlicer porting work is being considered in this repo for now.

- Byte-for-byte Prusa G-code parity remains deferred until a larger reviewed
  fixture corpus and stricter output-generation oracle exist.
- Support generation, wall seam behavior, and arc fitting remain future Prusa
  generated-output slices after semantic comparison machinery exists.
- STEP import remains a future file-format evidence slice and should not be
  mixed into this generated-output milestone.
- Non-Prusa Slicer-family ports, including Bambu Studio and OrcaSlicer, are
  paused parking-lot candidates until an explicit new planning decision moves
  one into the roadmap.
- Cross-flavor build automation is paused until verified fork behavior exists
  and a future planning decision defines supported flavors.
- Nightly vendor sync and Codex-assisted porting are paused until stable fork
  modules, executable evidence, and review-gated refresh policy exist.
