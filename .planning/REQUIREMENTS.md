# Requirements: Slic3r Rust Port v1.9

**Defined:** 2026-05-26
**Milestone:** v1.9 Fork Vendor Intake and Module Architecture
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

Requirements for the v1.9 milestone. Each maps to one roadmap phase.

### Vendor Source Intake

- [x] **VEND-01**: Maintainer can inspect one checked-in vendor source registry
  for PrusaSlicer, Bambu Studio, and OrcaSlicer that records official
  repository URL, selected stable tag, peeled commit, observed default branch
  head, capture date, lineage, source paths, and refresh command.
- [x] **VEND-02**: Maintainer can run a repo-owned verification target that
  validates every vendor registry row resolves to the recorded upstream tag and
  commit without cloning or building the full upstream fork repositories.
- [x] **VEND-03**: Maintainer can inspect license and provenance metadata for
  each tracked fork, including SPDX identifier, license source, attribution
  notes, and explicit non-free or network-plugin cautions.

### Fork Feature Inventories

- [x] **INV-01**: Maintainer can use a checked-in fork feature inventory
  template that requires source reference, ownership classification, feature
  surface, complexity, dependency on existing parity surfaces, v1.9 decision,
  and future parity notes for every row.
- [x] **INV-02**: Maintainer can inspect a PrusaSlicer feature inventory that
  separates base Slic3r behavior, shared downstream behavior, and
  Prusa-specific behavior from the pinned PrusaSlicer source baseline.
- [x] **INV-03**: Maintainer can inspect a Bambu Studio feature inventory that
  separates inherited Prusa-family behavior, shared downstream behavior, and
  Bambu-specific project, profile, network, support, STEP, arc, and assembly
  behavior from the pinned Bambu Studio source baseline.
- [x] **INV-04**: Maintainer can inspect an OrcaSlicer feature inventory that
  separates inherited Prusa/Bambu-family behavior, shared downstream behavior,
  and Orca-specific calibration, wall/seam, support, adaptive mesh, profile
  library, and community-profile behavior from the pinned OrcaSlicer source
  baseline.
- [x] **INV-05**: Maintainer can inspect a cross-fork category map that shows
  which inventory rows are base Slic3r, shared downstream, fork-specific, or
  unknown-needs-review, with deferred rows clearly separated from future
  implementation candidates.

### Modular Rust Flavor Architecture

- [x] **ARCH-01**: Developer can use typed Rust contracts for downstream fork
  identity, flavor identity, vendor source identity, feature origin, parity
  surface, and checklist status instead of passing raw vendor strings through
  core logic.
- [x] **ARCH-02**: Developer can inspect a documented module boundary that
  keeps base Slic3r behavior in shared core packages while future fork behavior
  plugs in through capability-oriented flavor metadata rather than copied Rust
  workspaces.
- [x] **ARCH-03**: Developer can use or inspect a pure flavor registry boundary
  that maps base, shared downstream, and fork-specific metadata without
  performing Git, filesystem, network, process, or release operations.

### Parity Checklist and Scope Templates

- [x] **PAR-01**: Maintainer can use a fork parity checklist template that
  requires inventory row ID, source pin, candidate Rust module, fixture need,
  evidence command, docs touched, license or security note, deferred scope, and
  reviewer signoff before a future fork feature can be marked verified.
- [ ] **PAR-02**: Maintainer can inspect documented fork fixture namespace and
  parity-status conventions that reserve verified fork status for future
  executable parity evidence, not source pins or inventories.
- [ ] **PAR-03**: Maintainer can inspect v1.9 documentation that explicitly
  defers full fork parity ports, GUI migration, fork-flavor release builds,
  signing, installers, release channels, nightly vendor sync, cloud or network
  device integrations, profile auto-update execution, and non-free plugin
  ingestion.
- [x] **PAR-04**: Maintainer can run or follow a manual drift-refresh protocol
  that compares pinned vendor refs with current upstream heads before any
  later fork parity milestone begins.

## v2 Requirements

Deferred to future milestones. Tracked but not in the current roadmap.

### Fork Parity Ports

- **FORK-01**: Maintainer can build and verify a modular Rust-backed
  PrusaSlicer flavor with parity for the accepted PrusaSlicer inventory.
- **FORK-02**: Maintainer can build and verify a modular Rust-backed Bambu
  Studio flavor with parity for the accepted Bambu Studio inventory.
- **FORK-03**: Maintainer can build and verify a modular Rust-backed
  OrcaSlicer flavor with parity for the accepted OrcaSlicer inventory.
- **FORK-04**: Maintainer can use fork-specific profile loaders and fixtures
  for Prusa INI/IDX bundles and Bambu/Orca JSON profile trees.
- **FORK-05**: Maintainer can use cross-flavor build automation for supported
  Slic3r-family flavors after fork behavior has executable parity evidence.
- **FORK-06**: Maintainer can use review-gated vendor refresh automation after
  fork modules, fixtures, and parity evidence exist.

## Out of Scope

Explicitly excluded from v1.9. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Full PrusaSlicer, Bambu Studio, or OrcaSlicer runtime parity | v1.9 prepares source pins, inventories, and architecture; runtime parity belongs to later fork-port milestones. |
| Git submodules, Git subtree imports, vendored source trees, or Bzlmod external repos for upstream fork code | The milestone needs reproducible references and inventories, not large C++ source trees as build inputs. |
| Building upstream C++ fork repositories in Bazel | This would expand into toolchain, GUI, dependency, and platform build work unrelated to v1.9 intake. |
| Vendor-specific Rust core workspaces or copied base behavior | The architecture goal is one shared Rust port with capability-oriented flavor boundaries. |
| Fork-flavor release packages, signing, notarization, installers, AppImage, MSI, DMG, or release channels | v1.8 only established base release artifacts; fork release engineering requires verified fork behavior first. |
| GitHub Actions fork-flavor matrices | Cross-flavor build automation is a future milestone after fork parity modules exist. |
| GUI migration or GUI feature parity | GUI work remains deferred until the core and CLI migration surfaces are credible. |
| Network printer, cloud, real-credential, or remote-device implementation | These surfaces need separate licensing, privacy, credential, and threat-model review. |
| Optional non-free Bambu or Orca networking plugin ingestion | v1.9 may record caution notes only; non-free components require explicit future review. |
| Profile update/download execution | v1.9 inventories profile schema families but does not implement online update channels. |
| Nightly vendor sync or Codex-assisted merge automation | Automated refresh is unsafe before stable source pins, inventories, fork modules, and parity evidence exist. |

## Traceability

Which phases cover which requirements. Updated as phases complete.

| Requirement | Phase | Status |
|-------------|-------|--------|
| VEND-01 | Phase 32 | Complete |
| VEND-02 | Phase 32 | Complete |
| VEND-03 | Phase 32 | Complete |
| INV-01 | Phase 33 | Complete |
| INV-02 | Phase 33 | Complete |
| INV-03 | Phase 33 | Complete |
| INV-04 | Phase 33 | Complete |
| INV-05 | Phase 33 | Complete |
| ARCH-01 | Phase 34 | Complete |
| ARCH-02 | Phase 35 | Complete |
| ARCH-03 | Phase 35 | Complete |
| PAR-01 | Phase 36 | Complete |
| PAR-02 | Phase 36 | Pending |
| PAR-03 | Phase 36 | Pending |
| PAR-04 | Phase 36 | Complete |

**Coverage:**

- v1 requirements: 15 total
- Mapped to phases: 15
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-05-26*
*Last updated: 2026-05-26 after Phase 34 completion*
