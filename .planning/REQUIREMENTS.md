# Requirements: Slic3r Rust Port v1.15

**Defined:** 2026-06-23
**Milestone:** v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1.15 Requirements

Requirements for the current milestone. Each requirement maps to exactly one
roadmap phase and must be verified before milestone archive.

### Arc-Fitting Scope Contract

- [x] **ARCSCOPE-01**: Maintainer can inspect a reviewed Prusa arc-fitting
  evidence scope contract that names the accepted source identity, inventory
  row, source anchors, fixture namespace, expected arc summary artifact, Rust
  boundary, public evidence command, planned status wording, docs touched,
  security note, deferred scope, and reviewer signoff.
- [x] **ARCSCOPE-02**: Maintainer can run a fail-closed arc-fitting scope
  verifier that rejects unsupported arc fields, duplicate or missing field
  rows, traceability drift, unsupported generated-output claims, unsupported
  runtime or printability claims, and missing deferred-scope language.
- [x] **ARCSCOPE-03**: Maintainer can confirm the broad `generated-outputs`
  status row remains `in progress`, the existing
  `fork.prusaslicer.gcode-output` status row is not widened, and the planned
  `fork.prusaslicer.arc-fitting` status row remains limited to the exact narrow
  evidence slice planned by this milestone.

### Arc-Fitting Fixture Corpus

- [ ] **ARCFIX-01**: Maintainer can inspect a small reviewed Prusa arc-fitting
  fixture corpus with source-pinned provenance, update rules, fixture identity,
  expected arc summary paths, and explicit exclusion of generator, runtime,
  network, sync, host-upload, post-processing, thumbnail, printability, and GUI
  behavior.
- [ ] **ARCFIX-02**: Maintainer can inspect checked-in arc-fitting expected
  summaries that cover only the Phase 57 approved fields, such as G2/G3 command
  observations, arc direction, center-offset evidence, coordinate bounds,
  extrusion or feedrate observations, source identity, fixture identity, and
  evidence-boundary text.
- [ ] **ARCFIX-03**: Maintainer can run fail-closed fixture verification that
  rejects missing rows, duplicate rows, out-of-order rows, unsupported arc
  fields, unsupported claim text, wrong source refs, wrong fixture identities,
  and stale documentation references.

### Rust Arc-Fitting Boundary

- [x] **ARCRUST-01**: Developer can use a pure typed Rust arc-fitting summary
  boundary that parses caller-supplied checked-in arc summary artifacts into
  domain values without Git, network, filesystem discovery, process, generator,
  printer-runtime, release, or sync side effects.
- [x] **ARCRUST-02**: Developer can inspect static readiness or registry
  metadata that traces the arc-fitting boundary to the accepted Prusa source
  identity, fixture corpus, expected arc summaries, planned command, planned
  status wording, and deferred generated-output surfaces.
- [x] **ARCRUST-03**: Developer can run Cargo and Bazel coverage that proves the
  valid arc fixture rows parse, invalid rows fail closed, optional or nullable
  Rust internals are named clearly, and no public helper names claim byte
  parity, printability, runtime, support, seam, GUI, or non-Prusa fork behavior.

### Executable Arc-Fitting Evidence

- [x] **ARCEV-01**: Maintainer can run public Prusa arc-fitting parity evidence
  that validates the checked-in arc summary artifact through the Rust boundary
  while preserving the existing public Prusa G-code output command contract.
- [x] **ARCEV-02**: Maintainer can see fail-closed mutation guards for arc drift
  classes such as G2/G3 command-count changes, arc direction changes,
  center-offset changes, coordinate-bound changes, extrusion or feedrate
  observation changes, source identity drift, fixture identity drift, and
  unsupported deferred-behavior claims.
- [x] **ARCEV-03**: Maintainer can inspect parity status, package docs, and port
  docs that describe the exact narrow `fork.prusaslicer.arc-fitting` evidence
  slice while keeping broad `generated-outputs` in progress, preserving the
  existing `fork.prusaslicer.gcode-output` meaning, and keeping all deferred
  generated-output, runtime, GUI, release, sync, and non-Prusa fork surfaces
  explicit.

## Future Requirements

### Generated Output Semantics

- **GOUT-01**: Maintainer can compare byte-for-byte Prusa G-code output for a
  larger reviewed fixture corpus.
- **GOUT-02**: Maintainer can compare richer semantic toolpath geometry,
  extrusion, timing, and printability evidence for reviewed generated-output
  fixtures.
- **GOUT-03**: Maintainer can graduate the broad `generated-outputs` status row
  only after multiple generated-output surfaces have executable evidence.

### Downstream Generated-Output Features

- **SUPP-01**: Maintainer can verify Prusa support-generation evidence through
  reviewed fixtures and executable parity.
- **SEAM-01**: Maintainer can verify Prusa wall-seam behavior through reviewed
  geometry/output fixtures and executable parity.
- **ARC-02**: Maintainer can verify richer arc-fitting geometry, tolerance,
  algorithm-equivalence, or printability evidence beyond the narrow v1.15
  command-shape evidence slice.

### Input Format and Fork Expansion

- **STEP-01**: Maintainer can verify Prusa STEP import evidence through
  reviewed file-format fixtures and parser evidence.
- **FORK-01**: Maintainer can plan Bambu Studio or OrcaSlicer evidence only
  after an explicit planning decision moves a non-Prusa fork out of the
  parking lot.

## Out of Scope

Explicitly excluded from v1.15 to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Byte-for-byte Prusa G-code parity | v1.15 proves narrow arc-fitting evidence summaries, not exact generated text equality across a broad corpus. |
| Broad `generated-outputs` verification | One additional feature-specific generated-output milestone is still too narrow to mark the whole generated-output surface verified. |
| Full ArcWelder algorithm equivalence, tolerance, geometry, timing, or printability | The milestone validates checked-in evidence facts, not mathematical or printer-runtime equivalence. |
| Printability, firmware behavior, printer-runtime behavior, host upload, and timing guarantees | Arc summaries are evidence inputs, not proof that a printer accepts or prints the output correctly. |
| Support generation and wall seam behavior | These remain separate generated-output feature slices that can use the evidence machinery after explicit future planning. |
| Full PrusaSlicer runtime or GUI behavior | v1.15 is an evidence-chain milestone, not a runtime fork port or desktop-app milestone. |
| Binary G-code, thumbnails, post-processing, and host upload | These surfaces require separate fixture, runtime, and integration scopes. |
| Network/device, cloud, credential, or profile auto-update execution | These remain deferred because they introduce external integration, credential, and runtime-support risk. |
| Fork release builds and release-channel publishing | v1.15 does not create distributable PrusaSlicer artifacts or release automation. |
| Bambu Studio and OrcaSlicer support | Active downstream-fork port planning remains limited to PrusaSlicer until a future planning decision says otherwise. |
| Upstream source imports or sync automation | Existing source pins remain planning inputs; automated import/sync needs a later review-gated policy. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| ARCSCOPE-01 | Phase 57 | Complete |
| ARCSCOPE-02 | Phase 57 | Complete |
| ARCSCOPE-03 | Phase 57 | Complete |
| ARCFIX-01 | Phase 58 | Pending |
| ARCFIX-02 | Phase 58 | Pending |
| ARCFIX-03 | Phase 58 | Pending |
| ARCRUST-01 | Phase 59 | Complete |
| ARCRUST-02 | Phase 59 | Complete |
| ARCRUST-03 | Phase 59 | Complete |
| ARCEV-01 | Phase 60 | Complete |
| ARCEV-02 | Phase 60 | Complete |
| ARCEV-03 | Phase 60 | Complete |

**Coverage:**

- v1.15 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0

---

*Requirements defined: 2026-06-23*
*Last updated: 2026-06-23 after roadmap creation*
