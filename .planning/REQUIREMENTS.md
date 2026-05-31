# Requirements: Slic3r Rust Port v1.10

**Defined:** 2026-05-31
**Milestone:** v1.10 PrusaSlicer Parity Evidence Foundation
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

Requirements for the v1.10 milestone. Each maps to one roadmap phase.

### Prusa Baseline and Scope Control

- [ ] **PRUSA-01**: Maintainer can run the manual PrusaSlicer drift-refresh
  protocol against the accepted v1.9 source pin and record selected stable tag
  confirmation, peeled commit confirmation, branch drift observation, reviewer
  decision, and reviewer signoff without automatically changing accepted source
  pins.
- [ ] **PRUSA-02**: Maintainer can inspect completed Prusa checklist records
  for the v1.10 profile schema/config evidence slice, including inventory row
  ID, source pin, candidate Rust module, fixture need, evidence command, docs
  touched, license or security note, deferred scope, and reviewer signoff.
- [ ] **PRUSA-03**: Maintainer can distinguish the narrow v1.10 Prusa
  profile/config evidence scope from deferred Prusa project files, STEP import,
  support generation, arc fitting, wall seam behavior, network/device
  integration, full fork runtime support, and fork release builds.

### Fork Evidence Surfaces

- [ ] **EVID-01**: Maintainer can inspect a Prusa fixture namespace and update
  rules in the parity fixture package for the profile/config evidence slice,
  with no Bambu Studio, OrcaSlicer, network, cloud, credential, or non-free
  plugin fixtures introduced by this milestone.
- [ ] **EVID-02**: Maintainer can inspect checked-in Prusa profile/config
  fixtures that are traceable to the accepted Prusa source pin and are suitable
  for rerunnable executable parity checks.
- [ ] **EVID-03**: Maintainer can inspect parity status vocabulary or status
  rows that reserve verified Prusa status for the v1.10 executable evidence
  command only, without marking full PrusaSlicer support verified.

### Rust Prusa Profile Boundary

- [ ] **PROF-01**: Developer can parse the v1.10 Prusa profile/config fixtures
  into typed Rust domain values before the data reaches core profile or config
  logic.
- [ ] **PROF-02**: Developer can trace the Prusa profile schema/config
  capability from Rust metadata back to the Prusa inventory row, accepted
  vendor source identity, source path, and checklist status.
- [ ] **PROF-03**: Developer can verify Prusa profile/config parsing and
  normalization logic with focused Rust unit tests that do not perform Git,
  network, filesystem discovery, process, release, or vendor sync operations.

### Executable Prusa Parity

- [ ] **PPAR-01**: Maintainer can run a repo-owned Bazel parity command for the
  Prusa profile/config evidence slice.
- [ ] **PPAR-02**: Maintainer can see the Prusa parity command fail when the
  Rust-backed parsed or normalized profile/config output diverges from the
  checked-in Prusa fixture expectations.
- [ ] **PPAR-03**: Maintainer can inspect docs and parity status updates that
  name the exact verified Prusa profile/config evidence slice and keep full
  PrusaSlicer runtime support, GUI support, generated-output parity, fork
  release builds, and sync automation deferred.

## v2 Requirements

Deferred to future milestones. Tracked but not in the current roadmap.

### Broader PrusaSlicer Parity

- **PRUSA-FUT-01**: Maintainer can verify Prusa project file load/save parity
  through executable fixtures.
- **PRUSA-FUT-02**: Maintainer can verify Prusa STEP import parity through
  executable file-format fixtures.
- **PRUSA-FUT-03**: Maintainer can verify Prusa support generation parity
  through generated-output fixtures.
- **PRUSA-FUT-04**: Maintainer can verify Prusa arc fitting parity through
  generated G-code comparison fixtures.
- **PRUSA-FUT-05**: Maintainer can verify Prusa wall seam behavior through
  geometry and generated-output fixtures.
- **PRUSA-FUT-06**: Maintainer can build and verify broader Rust-backed
  PrusaSlicer flavor behavior after the first evidence slice is trusted.

### Later Fork and Release Work

- **FORK-FUT-01**: Maintainer can build and verify modular Rust-backed Bambu
  Studio behavior after Prusa-family shared downstream evidence exists.
- **FORK-FUT-02**: Maintainer can build and verify modular Rust-backed
  OrcaSlicer behavior after shared Prusa/Bambu-family evidence exists.
- **FORK-FUT-03**: Maintainer can use cross-flavor build automation for
  supported Slic3r-family flavors after fork behavior has executable parity
  evidence.
- **FORK-FUT-04**: Maintainer can use review-gated vendor refresh automation
  after fork modules, fixtures, and parity evidence exist.

## Out of Scope

Explicitly excluded from v1.10. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Full PrusaSlicer runtime parity | v1.10 proves one narrow executable evidence slice before broadening fork behavior claims. |
| Bambu Studio or OrcaSlicer parity implementation | These depend on the Prusa-family evidence path and should not be mixed into the first fork evidence milestone. |
| Prusa project files, STEP import, support generation, arc fitting, or wall seam parity | These are valid future Prusa candidates but are higher-risk than profile/config evidence for the first fork slice. |
| Prusa network/device integration, cloud behavior, credentials, profile auto-update execution, or non-free plugin ingestion | These surfaces need separate licensing, privacy, credential, and threat-model review. |
| Git submodules, Git subtree imports, vendored fork source trees, or Bzlmod external repos for upstream fork code | v1.10 should use accepted source pins, inventories, and fixtures, not import upstream source trees. |
| Building upstream PrusaSlicer C++ in Bazel | The milestone verifies a narrow Rust-backed evidence slice and does not expand into upstream fork build integration. |
| Fork release packages, signing, notarization, installers, AppImage, MSI, DMG, or release channels | Release engineering requires broader verified fork behavior first. |
| Nightly vendor sync or Codex-assisted merge automation | Automated refresh remains unsafe before stable fork modules, fixtures, and evidence commands exist. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| PRUSA-01 | Phase 37 | Pending |
| PRUSA-02 | Phase 37 | Pending |
| PRUSA-03 | Phase 37 | Pending |
| EVID-01 | Phase 38 | Pending |
| EVID-02 | Phase 38 | Pending |
| EVID-03 | Phase 38 | Pending |
| PROF-01 | Phase 39 | Pending |
| PROF-02 | Phase 39 | Pending |
| PROF-03 | Phase 39 | Pending |
| PPAR-01 | Phase 40 | Pending |
| PPAR-02 | Phase 40 | Pending |
| PPAR-03 | Phase 40 | Pending |

**Coverage:**

- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-05-31*
*Last updated: 2026-05-31 after v1.10 roadmap creation*
