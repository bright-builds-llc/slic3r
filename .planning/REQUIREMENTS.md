# Requirements: Slic3r Rust Port v1.12

**Defined:** 2026-06-06
**Milestone:** v1.12 PrusaSlicer G-code Output Evidence Foundation
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

Requirements for the v1.12 milestone. Each maps to one roadmap phase.

### Prusa G-code Output Scope Gate

- [x] **PGSEL-01**: Maintainer can inspect a reviewed
  `prusaslicer.gcode-output` scope record with accepted source identity,
  fixture source decision, expected-summary contract, candidate Rust boundary,
  planned evidence command, planned status token, docs touched,
  license/security note, deferred scope, and reviewer signoff.
- [x] **PGSEL-02**: Maintainer can distinguish the narrow v1.12
  summary-only Prusa G-code evidence contract from byte-for-byte G-code parity,
  full generated-output parity, toolpath geometry, extrusion, timing, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, printer-runtime behavior, firmware or printability behavior,
  GUI export or viewer behavior, binary G-code, thumbnails, post-processing,
  host upload, network/device integration, profile auto-update execution, fork
  release builds, and sync automation.

### Prusa G-code Fixture Surface

- [ ] **PGFIX-01**: Maintainer can inspect a dedicated Prusa G-code fixture
  namespace containing one small reviewed ASCII `.gcode` fixture, provenance,
  update rules, byte count, SHA-256, line-ending/encoding policy, and a
  summary-only `expected-gcode-summary.tsv` artifact that traces back to the
  scope gate.
- [ ] **PGFIX-02**: Maintainer can run a repo-owned fixture verifier that
  fails when required Prusa G-code fixture provenance, checksums, line-ending
  policy, expected-summary shape, update rules, privacy/post-processing
  exclusions, or non-overclaiming scope text are missing or inconsistent.

### Rust Prusa G-code Summary Boundary

- [ ] **PGSUM-01**: Developer can summarize the selected Prusa G-code fixture
  into typed Rust values for stable metadata and marker evidence before the
  data reaches shared parity or status publication logic.
- [ ] **PGSUM-02**: Developer can trace the Prusa G-code output capability from
  Rust metadata back to the accepted Prusa source identity, fixture namespace,
  raw fixture path, expected summary artifact, planned status token, and broad
  generated-output deferrals.
- [ ] **PGSUM-03**: Developer can verify Prusa G-code summary parsing with
  focused Rust unit tests that reject unsupported evidence kinds,
  overclaiming notes, wrong source refs, wrong fixture paths, missing rows,
  duplicate rows, extra rows, and wrong ordering without performing Git,
  network, filesystem discovery, process execution, upstream source import,
  release, printer-runtime, profile-update, or vendor sync operations.

### Executable Prusa G-code Evidence

- [ ] **PGEV-01**: Maintainer can run a repo-owned Bazel parity command for
  the selected summary-only Prusa G-code output evidence slice.
- [ ] **PGEV-02**: Maintainer can see the Prusa G-code evidence command fail
  when the Rust-backed summary or checked-in expected summary artifact diverges
  from fixture expectations.
- [ ] **PGEV-03**: Maintainer can inspect docs and parity status updates that
  name the exact verified Prusa G-code evidence slice and keep byte-for-byte
  G-code parity, full generated-output parity, toolpath geometry, extrusion,
  timing, support generation, wall seam behavior, arc fitting, STEP import,
  full 3MF import/export, printer-runtime behavior, firmware or printability
  behavior, GUI export or viewer behavior, binary G-code, thumbnails,
  post-processing, host upload, network/device integration, profile
  auto-update execution, fork release builds, and sync automation deferred.

## v2 Requirements

Deferred or speculative work. Tracked here only as parking-lot context, not as
current roadmap commitments.

### Broader PrusaSlicer Generated Output

- **PRUSA-GOUT-FUT-01**: Maintainer can verify a second Prusa-generated G-code
  fixture after the first summary-only evidence path is trusted.
- **PRUSA-GOUT-FUT-02**: Maintainer can verify Prusa arc fitting parity through
  generated G-code comparison fixtures.
- **PRUSA-GOUT-FUT-03**: Maintainer can verify Prusa wall seam behavior through
  geometry and generated-output fixtures.
- **PRUSA-GOUT-FUT-04**: Maintainer can verify Prusa support generation parity
  through generated-output fixtures.
- **PRUSA-GOUT-FUT-05**: Maintainer can compare broader G-code content or byte
  parity after runtime, fixture, profile, and printer-safety scope is reviewed.

### Adjacent File, GUI, Runtime, and Release Surfaces

- **PRUSA-FILE-FUT-01**: Maintainer can verify Prusa STEP import parity through
  executable file-format fixtures.
- **PRUSA-GUI-FUT-01**: Maintainer can verify Prusa GUI export or G-code viewer
  behavior through dedicated UI evidence.
- **PRUSA-RT-FUT-01**: Maintainer can verify printer-runtime, firmware,
  printability, host upload, or network/device behavior through dedicated
  runtime evidence.
- **PRUSA-REL-FUT-01**: Maintainer can build and verify broader Rust-backed
  PrusaSlicer flavor behavior after summary-only generated-output evidence is
  trusted.

### Speculative Non-Prusa and Automation Parking Lot

- **FORK-FUT-01**: Possible future reconsideration of modular Rust-backed
  Bambu Studio behavior after an explicit new planning decision; not in the
  active roadmap.
- **FORK-FUT-02**: Possible future reconsideration of modular Rust-backed
  OrcaSlicer behavior after an explicit new planning decision; not in the
  active roadmap.
- **FORK-FUT-03**: Possible future reconsideration of cross-flavor build
  automation after verified fork behavior and supported flavor policy exist;
  not in the active roadmap.
- **FORK-FUT-04**: Possible future reconsideration of nightly vendor sync and
  Codex-assisted porting after stable fork modules, executable evidence, and
  review-gated refresh policy exist; not in the active roadmap.

## Out of Scope

Explicitly excluded from v1.12. Documented to prevent scope creep.

| Feature | Reason |
| --- | --- |
| Byte-for-byte G-code output parity | Too broad and brittle for the first generated-output evidence milestone. |
| Broad `generated-outputs` verification | v1.12 proves one fork-specific summary-only evidence slice, not global generated-output parity. |
| Toolpath geometry, extrusion, timing, printability, firmware, or printer-runtime validation | Requires dedicated runtime and safety evidence outside this fixture-summary milestone. |
| Support generation, wall seam behavior, and arc fitting | High-value future Prusa generated-output slices that need their own fixtures and semantic contracts. |
| STEP import and full 3MF import/export | Adjacent file-format surfaces, not G-code output summary evidence. |
| GUI export, G-code viewer, thumbnails, binary G-code, post-processing, host upload, network/device behavior, profile auto-update execution, release builds, and sync automation | Separate UI, binary, runtime, credential, release, or automation surfaces with different risk and verification needs. |
| Bambu Studio, OrcaSlicer, and other non-Prusa Slicer-family ports | Paused parking-lot candidates until an explicit future planning decision moves one into the roadmap. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
| --- | --- | --- |
| PGSEL-01 | Phase 45 | Complete |
| PGSEL-02 | Phase 45 | Complete |
| PGFIX-01 | Phase 46 | Pending |
| PGFIX-02 | Phase 46 | Pending |
| PGSUM-01 | Phase 47 | Pending |
| PGSUM-02 | Phase 47 | Pending |
| PGSUM-03 | Phase 47 | Pending |
| PGEV-01 | Phase 48 | Pending |
| PGEV-02 | Phase 48 | Pending |
| PGEV-03 | Phase 48 | Pending |

**Coverage:**

- v1 requirements: 10 total
- Mapped to phases: 10
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-06-06*
*Last updated: 2026-06-06 after v1.12 roadmap creation*
