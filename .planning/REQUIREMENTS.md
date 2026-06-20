# Requirements: Slic3r Rust Port v1.14

**Defined:** 2026-06-20
**Milestone:** v1.14 PrusaSlicer G-code Semantic Evidence Foundation
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1.14 Requirements

Requirements for the current milestone. Each requirement maps to exactly one
roadmap phase and must be verified before milestone archive.

### Semantic Scope Contract

- [ ] **GSSCOPE-01**: Maintainer can inspect a reviewed Prusa G-code semantic
  evidence scope contract that names the accepted source identity, inventory
  row, fixture namespace, expected semantic summary artifacts, Rust boundary,
  public evidence command, planned status wording, docs touched, security
  note, deferred scope, and reviewer signoff.
- [ ] **GSSCOPE-02**: Maintainer can run a fail-closed semantic scope verifier
  that rejects unsupported semantic fields, duplicate or missing field rows,
  traceability drift, unsupported generated-output claims, unsupported runtime
  or printability claims, and missing deferred-scope language.
- [ ] **GSSCOPE-03**: Maintainer can confirm the broad `generated-outputs`
  status row remains `in progress` and the narrow
  `fork.prusaslicer.gcode-output` status remains limited to the exact semantic
  evidence slice planned by this milestone.

### Semantic Fixture Corpus

- [ ] **GSFIX-01**: Maintainer can inspect a small reviewed Prusa G-code
  semantic fixture corpus with source-pinned provenance, update rules, fixture
  identity, expected semantic summary paths, and explicit exclusion of
  generator, runtime, network, sync, host-upload, post-processing, thumbnail,
  printability, and GUI behavior.
- [ ] **GSFIX-02**: Maintainer can inspect checked-in semantic expected
  summaries that cover only the Phase 53 approved fields, such as command
  classes, movement classes, coordinate bounds, extrusion totals, feedrate
  observations, layer or marker relationships, and fixture/source identities.
- [ ] **GSFIX-03**: Maintainer can run fail-closed fixture verification that
  rejects missing rows, duplicate rows, out-of-order rows, unsupported
  semantic fields, unsupported claim text, wrong source refs, wrong fixture
  identities, and stale documentation references.

### Rust Semantic Boundary

- [ ] **GSRUST-01**: Developer can use a pure typed Rust semantic G-code
  summary boundary that parses caller-supplied checked-in semantic artifacts
  into domain values without Git, network, filesystem discovery, process,
  generator, printer-runtime, release, or sync side effects.
- [ ] **GSRUST-02**: Developer can inspect static readiness or registry
  metadata that traces the semantic G-code boundary to the accepted Prusa
  source identity, fixture corpus, expected semantic summaries, planned
  command, planned status wording, and deferred generated-output surfaces.
- [ ] **GSRUST-03**: Developer can run Cargo and Bazel coverage that proves the
  valid semantic fixture rows parse, invalid rows fail closed, optional or
  nullable Rust internals are named clearly, and no public helper names claim
  byte parity, printability, runtime, support, seam, arc, GUI, or non-Prusa
  fork behavior.

### Executable Semantic Evidence

- [ ] **GSEV-01**: Maintainer can run public Prusa G-code parity evidence that
  validates marker summary, structural summary, and semantic summary artifacts
  through the Rust boundary while preserving the existing public command
  contract unless a deliberate roadmap decision introduces a companion command.
- [ ] **GSEV-02**: Maintainer can see fail-closed mutation guards for semantic
  drift classes such as movement class changes, coordinate-bound changes,
  extrusion-total changes, feedrate observation changes, fixture identity
  drift, and unsupported deferred-behavior claims.
- [ ] **GSEV-03**: Maintainer can inspect parity status, package docs, and port
  docs that describe the exact narrow `fork.prusaslicer.gcode-output` semantic
  evidence slice while keeping broad `generated-outputs` in progress and all
  deferred generated-output, runtime, GUI, release, sync, and non-Prusa fork
  surfaces explicit.

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
- **ARC-01**: Maintainer can verify Prusa arc-fitting behavior through reviewed
  G-code comparison evidence.

### Input Format and Fork Expansion

- **STEP-01**: Maintainer can verify Prusa STEP import evidence through
  reviewed file-format fixtures and parser evidence.
- **FORK-01**: Maintainer can plan Bambu Studio or OrcaSlicer evidence only
  after an explicit planning decision moves a non-Prusa fork out of the
  parking lot.

## Out of Scope

Explicitly excluded from v1.14 to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Byte-for-byte Prusa G-code parity | v1.14 proves semantic summaries, not exact generated text equality across a broad corpus. |
| Broad `generated-outputs` verification | One additional semantic G-code milestone is still too narrow to mark the whole generated-output surface verified. |
| Printability, firmware behavior, printer-runtime behavior, and timing guarantees | Semantic summaries are evidence inputs, not proof that a printer accepts or prints the output correctly. |
| Support generation, wall seam behavior, and arc fitting | These are downstream generated-output feature slices that should use the semantic comparison machinery after it exists. |
| Full PrusaSlicer runtime or GUI behavior | v1.14 is an evidence-chain milestone, not a runtime fork port or desktop-app milestone. |
| Binary G-code, thumbnails, post-processing, and host upload | These surfaces require separate fixture, runtime, and integration scopes. |
| Network/device, cloud, credential, or profile auto-update execution | These remain deferred because they introduce external integration, credential, and runtime-support risk. |
| Fork release builds and release-channel publishing | v1.14 does not create distributable PrusaSlicer artifacts or release automation. |
| Bambu Studio and OrcaSlicer support | Active downstream-fork port planning remains limited to PrusaSlicer until a future planning decision says otherwise. |
| Upstream source imports or sync automation | Existing source pins remain planning inputs; automated import/sync needs a later review-gated policy. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| GSSCOPE-01 | Phase 53 | Pending |
| GSSCOPE-02 | Phase 53 | Pending |
| GSSCOPE-03 | Phase 53 | Pending |
| GSFIX-01 | Phase 54 | Pending |
| GSFIX-02 | Phase 54 | Pending |
| GSFIX-03 | Phase 54 | Pending |
| GSRUST-01 | Phase 55 | Pending |
| GSRUST-02 | Phase 55 | Pending |
| GSRUST-03 | Phase 55 | Pending |
| GSEV-01 | Phase 56 | Pending |
| GSEV-02 | Phase 56 | Pending |
| GSEV-03 | Phase 56 | Pending |

**Coverage:**

- v1.14 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0

---

*Requirements defined: 2026-06-20*
*Last updated: 2026-06-20 after roadmap creation*
