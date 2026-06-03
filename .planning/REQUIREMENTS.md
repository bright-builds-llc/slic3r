# Requirements: Slic3r Rust Port v1.11

**Defined:** 2026-06-02
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

Requirements for the v1.11 milestone. Each maps to one roadmap phase.

### Prusa Project-File Scope Gate

- [x] **PSEL-01**: Maintainer can inspect a reviewed Prusa project-file scope
  record for `prusaslicer.project-file`, including accepted source identity,
  inventory row ID, fixture source decision, expected-artifact contract,
  candidate Rust boundary, planned evidence command, docs touched, license or
  security note, deferred scope, and reviewer signoff.
- [x] **PSEL-02**: Maintainer can distinguish the narrow v1.11 Prusa
  project-file evidence contract from full 3MF import/export, full
  PrusaSlicer runtime support, GUI project behavior, generated-output parity,
  STEP import, support generation, arc fitting, wall seam behavior,
  network/device integration, profile auto-update execution, fork release
  builds, and sync automation.

### Prusa Project-File Fixture Surface

- [x] **PFIX-01**: Maintainer can inspect a Prusa project-file fixture
  namespace, provenance manifest, update rules, and checked-in expected
  artifact that trace to the Phase 41 scope gate and accepted source decision.
- [x] **PFIX-02**: Maintainer can run a repo-owned fixture verifier that fails
  when required Prusa project-file fixture provenance, expected artifacts,
  update rules, or non-overclaiming scope text are missing or inconsistent.

### Rust Prusa Project-File Boundary

- [ ] **PPROJ-01**: Developer can parse or summarize the selected Prusa
  project-file fixture evidence into typed Rust domain values before data
  reaches shared core profile, file-format, or config logic.
- [ ] **PPROJ-02**: Developer can trace the Prusa project-file capability from
  Rust metadata back to the Prusa inventory row, accepted vendor source
  identity, source path or reviewed sample source, fixture path, checklist
  path, and planned status token.
- [ ] **PPROJ-03**: Developer can verify Prusa project-file summary or parsing
  logic with focused Rust unit tests that do not perform Git, network,
  filesystem discovery, process, release, or vendor sync operations.

### Executable Prusa Project-File Parity

- [ ] **PPEV-01**: Maintainer can run a repo-owned Bazel parity command for the
  selected Prusa project-file evidence slice.
- [ ] **PPEV-02**: Maintainer can see the Prusa project-file parity command
  fail when the Rust-backed summary or checked-in expected artifact diverges
  from fixture expectations.
- [ ] **PPEV-03**: Maintainer can inspect docs and parity status updates that
  name the exact verified Prusa project-file evidence slice and keep full
  PrusaSlicer runtime support, GUI support, generated-output parity, STEP
  import, support generation, arc fitting, wall seam behavior, fork release
  builds, network/device integration, profile auto-update execution, and sync
  automation deferred.

## v2 Requirements

Deferred or speculative work. Tracked here only as parking-lot context, not as
current roadmap commitments.

### Broader PrusaSlicer Parity

- **PRUSA-FUT-02**: Maintainer can verify Prusa STEP import parity through
  executable file-format fixtures.
- **PRUSA-FUT-03**: Maintainer can verify Prusa support generation parity
  through generated-output fixtures.
- **PRUSA-FUT-04**: Maintainer can verify Prusa arc fitting parity through
  generated G-code comparison fixtures.
- **PRUSA-FUT-05**: Maintainer can verify Prusa wall seam behavior through
  geometry and generated-output fixtures.
- **PRUSA-FUT-06**: Maintainer can build and verify broader Rust-backed
  PrusaSlicer flavor behavior after project-file evidence is trusted.

### Speculative Non-Prusa and Release Parking Lot

- **FORK-FUT-01**: Possible future reconsideration of modular Rust-backed
  Bambu Studio behavior after an explicit new planning decision; not in the
  active roadmap.
- **FORK-FUT-02**: Possible future reconsideration of modular Rust-backed
  OrcaSlicer behavior after an explicit new planning decision; not in the
  active roadmap.
- **FORK-FUT-03**: Possible future reconsideration of cross-flavor build
  automation after verified fork behavior and supported flavor policy exist;
  not in the active roadmap.
- **FORK-FUT-04**: Possible future reconsideration of review-gated vendor
  refresh automation after stable fork modules, fixtures, and parity evidence
  exist; not in the active roadmap.

## Out of Scope

Explicitly excluded from v1.11. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Full PrusaSlicer runtime parity | v1.11 proves one broader project-file evidence slice before broad runtime claims. |
| Full 3MF import/export implementation | Phase 41 must first lock the exact project-file evidence contract; v1.11 should not silently become a full container/parser port. |
| Prusa GUI project behavior | GUI load/save behavior requires separate interaction, state, and visual validation. |
| STEP import, support generation, arc fitting, or wall seam parity | These remain valid future Prusa candidates but require stronger file-format or generated-output evidence. |
| Bambu Studio, OrcaSlicer, or other non-Prusa Slicer-family parity implementation | Only PrusaSlicer porting work is being considered in this repo for now; non-Prusa ports may be revisited only after an explicit new planning decision. |
| Prusa network/device integration, cloud behavior, credentials, profile auto-update execution, or non-free plugin ingestion | These surfaces need separate licensing, privacy, credential, and threat-model review. |
| Git submodules, Git subtree imports, vendored fork source trees, or Bzlmod external repos for upstream fork code | v1.11 should use accepted source pins, inventories, and fixtures, not import upstream source trees. |
| Building upstream PrusaSlicer C++ in Bazel | The milestone verifies a narrow Rust-backed evidence slice and does not expand into upstream fork build integration. |
| Fork release packages, signing, notarization, installers, AppImage, MSI, DMG, or release channels | Release engineering requires broader verified fork behavior first. |
| Nightly vendor sync or Codex-assisted merge automation | Automated refresh is not in the active roadmap and remains unsafe before stable fork modules, fixtures, evidence commands, and an explicit new planning decision exist. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| PSEL-01 | Phase 41 | Complete |
| PSEL-02 | Phase 41 | Complete |
| PFIX-01 | Phase 42 | Complete |
| PFIX-02 | Phase 42 | Complete |
| PPROJ-01 | Phase 43 | Pending |
| PPROJ-02 | Phase 43 | Pending |
| PPROJ-03 | Phase 43 | Pending |
| PPEV-01 | Phase 44 | Pending |
| PPEV-02 | Phase 44 | Pending |
| PPEV-03 | Phase 44 | Pending |

**Coverage:**

- v1 requirements: 10 total
- Mapped to phases: 10
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-06-02*
*Last updated: 2026-06-03 after non-Prusa porting scope clarification*
