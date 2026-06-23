# Roadmap: Slic3r Rust Port

## Milestones

- Active: **v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice** -
  Phases 57-60 (ready to plan)
- Shipped: **v1.14 PrusaSlicer G-code Semantic Evidence Foundation** -
  Phases 53-56 (shipped 2026-06-22)
  Archive: [.planning/milestones/v1.14-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.14-ROADMAP.md)
  Requirements: [.planning/milestones/v1.14-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.14-REQUIREMENTS.md)
  Audit: [.planning/milestones/v1.14-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.14-MILESTONE-AUDIT.md)
  Phases: [.planning/milestones/v1.14-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.14-phases/)
- Shipped: **v1.13 PrusaSlicer G-code Structural Evidence Expansion** -
  Phases 49-52 (shipped 2026-06-19)
  Archive: [.planning/milestones/v1.13-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.13-ROADMAP.md)
- Shipped: **v1.12 PrusaSlicer G-code Output Evidence Foundation** -
  Phases 45-48 (shipped 2026-06-15)
  Archive: [.planning/milestones/v1.12-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.12-ROADMAP.md)
- Shipped: **v1.11 PrusaSlicer Broader Parity Port** - Phases 41-44
  (shipped 2026-06-06)
  Archive: [.planning/milestones/v1.11-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.11-ROADMAP.md)
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

v1.15 is the active milestone. It proves one narrow, source-pinned
PrusaSlicer arc-fitting G-code evidence slice through a reviewed scope
contract, fixture corpus, pure Rust evidence boundary, public executable
evidence, fail-closed mutation guards, exact status wording, and
non-overclaiming docs.

The milestone keeps broad `generated-outputs`, byte-for-byte G-code parity,
printability, printer-runtime behavior, support generation, wall seam
behavior, GUI behavior, release behavior, upstream imports, sync automation,
and non-Prusa fork behavior deferred.

**Granularity:** fine
**Coverage:** 12/12 v1.15 requirements mapped

## Phases

**Phase Numbering:**

- Integer phases (57, 58, 59, 60): Planned milestone work
- Decimal phases (57.1, 57.2): Urgent insertions after planning

- [x] **Phase 57: Arc-Fitting Scope Contract** - Close the reviewed (completed 2026-06-23)
  `prusaslicer.arc-fitting` scope and fail-closed verifier before any evidence
  artifacts are published.
- [ ] **Phase 58: Arc-Fitting Fixture Corpus** - Add the source-pinned fixture
  namespace, expected arc summaries, provenance, and fixture drift guards.
- [ ] **Phase 59: Rust Arc-Fitting Evidence Boundary** - Parse checked-in arc
  summaries through a pure typed Rust boundary with static readiness metadata.
- [ ] **Phase 60: Executable Arc-Fitting Evidence** - Publish public
  arc-fitting parity evidence, mutation guards, exact status, and docs for the
  narrow evidence slice.

## Phase Details

### Phase 57: Arc-Fitting Scope Contract
**Goal**: Maintainers have a reviewed, fail-closed arc-fitting scope contract
that authorizes fixture, Rust, parity, status, and docs work without widening
generated-output claims.
**Depends on**: Phase 56
**Requirements**: ARCSCOPE-01, ARCSCOPE-02, ARCSCOPE-03
**Success Criteria** (what must be TRUE):
  1. Maintainer can inspect the accepted `prusaslicer.arc-fitting` source
     identity, inventory row, source anchors, artifact paths, planned status
     wording, deferred scope, security note, and reviewer signoff in one scope
     contract.
  2. Maintainer can run the arc-fitting scope verifier and see unsupported arc
     fields, duplicate or missing rows, traceability drift, broad
     generated-output claims, runtime or printability claims, and missing
     deferred-scope wording fail closed.
  3. Maintainer can confirm broad `generated-outputs` remains `in progress`,
     the existing `fork.prusaslicer.gcode-output` wording is preserved, and
     the planned `fork.prusaslicer.arc-fitting` wording stays limited to the
     narrow v1.15 evidence slice.
**Plans**: TBD

### Phase 58: Arc-Fitting Fixture Corpus
**Goal**: Maintainers have a source-pinned arc-fitting fixture corpus and
checked-in expected summaries constrained to the Phase 57 approved fields.
**Depends on**: Phase 57
**Requirements**: ARCFIX-01, ARCFIX-02, ARCFIX-03
**Success Criteria** (what must be TRUE):
  1. Maintainer can inspect a `prusaslicer.arc-fitting` fixture namespace with
     source-pinned provenance, update rules, fixture identity, expected arc
     summary paths, and explicit exclusions for generator, runtime, network,
     sync, host-upload, post-processing, thumbnail, printability, and GUI
     behavior.
  2. Maintainer can inspect checked-in expected arc summaries that cover only
     the Phase 57 approved fields, such as G2/G3 command observations, arc
     direction, center-offset evidence, coordinate bounds, extrusion or
     feedrate observations, source identity, fixture identity, and
     evidence-boundary text.
  3. Maintainer can run fixture verification that rejects missing rows,
     duplicate rows, out-of-order rows, unsupported arc fields, unsupported
     claim text, wrong source refs, wrong fixture identities, and stale
     documentation references.
**Plans**: 2 plans

Plans:
- [ ] 58-01-PLAN.md — Create source-pinned arc-fitting fixture namespace,
      expected summary, provenance, and Bazel bundle.
- [ ] 58-02-PLAN.md — Add fail-closed arc-fitting fixture verifier, mutation
      coverage, and package-level command docs.

### Phase 59: Rust Arc-Fitting Evidence Boundary
**Goal**: Developers can parse checked-in arc summaries through a pure typed
Rust boundary and inspect readiness metadata without public status publication
or side effects.
**Depends on**: Phase 58
**Requirements**: ARCRUST-01, ARCRUST-02, ARCRUST-03
**Success Criteria** (what must be TRUE):
  1. Developer can parse caller-supplied checked-in arc summary artifacts into
     typed Rust domain values without Git, network, filesystem discovery,
     process, generator, printer-runtime, release, or sync side effects.
  2. Developer can inspect static registry or readiness metadata tracing the
     arc-fitting boundary to the accepted Prusa source identity, fixture
     corpus, expected arc summaries, planned command, planned status wording,
     and deferred generated-output surfaces.
  3. Developer can run Cargo and Bazel coverage proving valid arc fixture rows
     parse and invalid rows fail closed.
  4. Developer can confirm public helper names and Rust internals do not claim
     byte parity, printability, runtime, support, seam, GUI, or non-Prusa fork
     behavior, and optional or nullable internals are named clearly.
**Plans**: TBD

### Phase 60: Executable Arc-Fitting Evidence
**Goal**: Maintainers can run public executable arc-fitting evidence and
inspect exact public status/docs for the narrow PrusaSlicer arc-fitting slice.
**Depends on**: Phase 59
**Requirements**: ARCEV-01, ARCEV-02, ARCEV-03
**Success Criteria** (what must be TRUE):
  1. Maintainer can run public Prusa arc-fitting parity evidence that validates
     the checked-in arc summary artifact through the Rust boundary while
     preserving the existing public Prusa G-code output command contract.
  2. Maintainer can see fail-closed mutation guards for G2/G3 command-count
     changes, arc direction changes, center-offset changes, coordinate-bound
     changes, extrusion or feedrate observation changes, source identity
     drift, fixture identity drift, and unsupported deferred-behavior claims.
  3. Maintainer can inspect parity status, package docs, and port docs that
     describe only the exact narrow `fork.prusaslicer.arc-fitting` evidence
     slice while broad `generated-outputs` remains `in progress` and all
     generated-output, runtime, GUI, release, sync, and non-Prusa fork
     deferrals remain explicit.
  4. Maintainer can confirm the existing `fork.prusaslicer.gcode-output`
     meaning is not widened by arc-fitting evidence publication.
**Plans**: TBD

## Coverage

| Requirement | Phase |
|-------------|-------|
| ARCSCOPE-01 | Phase 57 |
| ARCSCOPE-02 | Phase 57 |
| ARCSCOPE-03 | Phase 57 |
| ARCFIX-01 | Phase 58 |
| ARCFIX-02 | Phase 58 |
| ARCFIX-03 | Phase 58 |
| ARCRUST-01 | Phase 59 |
| ARCRUST-02 | Phase 59 |
| ARCRUST-03 | Phase 59 |
| ARCEV-01 | Phase 60 |
| ARCEV-02 | Phase 60 |
| ARCEV-03 | Phase 60 |

Mapped: 12/12 v1.15 requirements
Orphans: 0
Duplicates: 0

## Progress

**Execution Order:**
Phases execute in numeric order: 57 -> 58 -> 59 -> 60

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 57. Arc-Fitting Scope Contract | 3/3 | Complete    | 2026-06-23 |
| 58. Arc-Fitting Fixture Corpus | 0/2 | Not started | - |
| 59. Rust Arc-Fitting Evidence Boundary | 0/TBD | Not started | - |
| 60. Executable Arc-Fitting Evidence | 0/TBD | Not started | - |

## Planning Notes

- Phase 57 owns final allowed arc fields, source anchors, fixture derivation
  route, status wording, and package-boundary confirmation.
- Phase 58 must prove selected fixture bytes and expected rows are
  source-pinned and arc-specific without live generation or broad runtime
  claims.
- Phase 59 should reuse the existing `slic3r_flavors` parser/readiness
  patterns while keeping the Rust boundary pure and closed.
- Phase 60 publishes status/docs only after scope, fixture, Rust boundary,
  public comparator, mutation guards, and existing Prusa G-code output command
  regression checks pass.
