# Requirements: Slic3r Rust Port

**Defined:** 2026-06-16
**Milestone:** v1.13 PrusaSlicer G-code Structural Evidence Expansion
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1.13 Requirements

### Structural Scope

- [x] **GCSCOPE-01**: Maintainer can inspect a reviewed structural G-code scope
  contract that enumerates the allowed evidence fields for command counts,
  section counts, ordered markers, movement/extrusion indicators,
  temperature/tool-change markers, source identity, and fixture identity.
- [x] **GCSCOPE-02**: Maintainer can run a scope verifier that fails closed when
  v1.13 artifacts claim byte-for-byte G-code parity, geometry/toolpath parity,
  printability, printer-runtime behavior, support generation, wall seam
  behavior, arc fitting, GUI export/viewer behavior, release behavior,
  network/device behavior, non-Prusa fork behavior, upstream source imports, or
  sync automation.
- [x] **GCSCOPE-03**: Maintainer can trace the structural G-code evidence scope
  to the accepted `prusaslicer.gcode-output` inventory row and the v1.12 fixture
  and status path without promoting the broad `generated-outputs` status row to
  verified.

### Structural Fixture

- [ ] **GCFIX-01**: Maintainer can inspect a source-pinned Prusa G-code fixture
  expansion with a checked-in expected structural summary artifact for the
  accepted Prusa `set_speed` G-code evidence slice.
- [ ] **GCFIX-02**: Maintainer can run a Bazel-owned fixture verifier that
  checks the exact structural summary schema, required rows, provenance, and
  update rules.
- [ ] **GCFIX-03**: Maintainer can see fixture mutation tests fail closed for
  structural summary drift, missing rows, duplicate rows, unsupported fields,
  unsupported broad-behavior claims, and provenance mismatch.

### Rust Structural Boundary

- [x] **GCRUST-01**: Developer can parse the v1.13 expected structural summary
  artifact through a pure typed Rust boundary in `slic3r_flavors`.
- [x] **GCRUST-02**: Developer can run Cargo and Bazel tests proving the Rust
  structural boundary rejects invalid headers, wrong column counts, missing
  rows, duplicate rows, out-of-order rows, unsupported structural fields,
  unsupported claim text, wrong source refs, and wrong fixture identities.
- [x] **GCRUST-03**: Developer can inspect registry metadata that exposes
  structural Prusa G-code evidence readiness without filesystem discovery, Git,
  network, process execution, release behavior, sync behavior, or premature
  broad generated-output status publication.

### Executable Evidence

- [x] **GCEV-01**: Maintainer can run a public Bazel parity command that
  validates the structural Prusa G-code expected summary through the Rust
  boundary and checked-in fixture expectations.
- [x] **GCEV-02**: Maintainer can see the public parity command fail closed on a
  structural-summary mutation guard, not only the v1.12 marker-line drift guard.
- [ ] **GCEV-03**: Maintainer can inspect parity status, package docs, and port
  docs that describe the exact narrow `fork.prusaslicer.gcode-output`
  structural evidence slice while keeping broad `generated-outputs` in
  progress and all deferred generated-output/runtime/fork surfaces explicit.

## Future Requirements

### Generated Output Semantics

- **GOUT-01**: Maintainer can compare byte-for-byte Prusa G-code output for a
  reviewed fixture corpus.
- **GOUT-02**: Maintainer can compare semantic toolpath geometry, extrusion,
  timing, and printability evidence for reviewed generated-output fixtures.
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
  after an explicit planning decision moves a non-Prusa fork out of the parking
  lot.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Byte-for-byte G-code parity | v1.13 strengthens structural evidence only; byte parity needs a broader fixture corpus and stricter output-generation oracle. |
| Geometry, extrusion, timing, and printability parity | Structural summaries are a prerequisite, not proof of semantic toolpath or printer-runtime behavior. |
| Support generation, wall seam behavior, and arc fitting | These generated-output features depend on stronger G-code comparison evidence and should remain future Prusa slices. |
| STEP import and broad file-format parity | STEP is a separate file-format surface and should not be mixed with the G-code structural evidence milestone. |
| Full PrusaSlicer runtime or GUI behavior | v1.13 is an evidence-chain milestone, not a runtime fork port or desktop-app milestone. |
| Binary G-code, thumbnails, post-processing, and host upload | These surfaces require separate fixture, runtime, and integration scopes. |
| Network/device, cloud, credential, or profile auto-update execution | These remain deferred because they introduce external integration, credential, and runtime-support risk. |
| Fork release builds and release-channel publishing | v1.13 does not create distributable PrusaSlicer artifacts or release automation. |
| Bambu Studio and OrcaSlicer support | Active downstream-fork port planning remains limited to PrusaSlicer until a future planning decision says otherwise. |
| Upstream source imports or sync automation | Existing source pins remain planning inputs; automated import/sync needs a later review-gated policy. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| GCSCOPE-01 | Phase 49 | Complete |
| GCSCOPE-02 | Phase 49 | Complete |
| GCSCOPE-03 | Phase 49 | Complete |
| GCFIX-01 | Phase 50 | Pending |
| GCFIX-02 | Phase 50 | Pending |
| GCFIX-03 | Phase 50 | Pending |
| GCRUST-01 | Phase 51 | Complete |
| GCRUST-02 | Phase 51 | Complete |
| GCRUST-03 | Phase 51 | Complete |
| GCEV-01 | Phase 52 | Complete |
| GCEV-02 | Phase 52 | Complete |
| GCEV-03 | Phase 52 | Pending |

**Coverage:**

- v1.13 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-06-16*
*Last updated: 2026-06-16 after roadmap creation*
