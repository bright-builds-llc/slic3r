# Requirements: Slic3r Rust Port

**Defined:** 2026-05-24
**Milestone:** v1.8 Cross-Platform Release Build Automation
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1.8 Requirements

Requirements for the current milestone. Each maps to the release build
automation phase.

### Release Build Automation

- [ ] **REL-03**: Maintainer can use GitHub Actions to produce base Slic3r
  release build artifacts for macOS, Linux, and Windows through the Rust/Bazel
  workflow.
- [ ] **REL-04**: Release build artifacts carry enough provenance to identify
  platform, commit, build mode, and supported package scope.
- [ ] **REL-05**: Release build automation reuses the verified packaged
  launcher evidence instead of inventing parallel release logic.
- [ ] **REL-06**: Docs describe supported release-build outputs and remaining
  exclusions such as signing, notarization, installers, or release channels.

## Future Requirements

Deferred to future milestones.

### GUI Migration

- **GUI-01**: Maintainer has a concrete GUI migration strategy after
  cross-platform packaging-visible launcher evidence exists.
- **GUI-02**: User can run a Rust-backed GUI workflow with parity against the
  retained legacy GUI surface.

### Release Distribution

- **REL-01**: Maintainer can produce signed or notarized platform artifacts
  through a documented release-channel workflow.
- **REL-02**: Maintainer can generate installer-grade packages such as AppImage,
  MSI, DMG, or platform-specific release bundles.

### Downstream Fork Vendor Maintenance

- **FORK-01**: Maintainer can track PrusaSlicer, Bambu Studio, and OrcaSlicer
  through pinned vendor references such as submodules or explicitly documented
  mirrors, with licensing and update rules recorded.
- **FORK-02**: Maintainer has a feature inventory for each fork that separates
  base Slic3r behavior, shared downstream behavior, and fork-specific behavior.
- **FORK-03**: Maintainer can port each fork as a modular Rust-backed flavor
  without forking the Rust codebase wholesale.
- **FORK-04**: Maintainer can verify full parity for PrusaSlicer-specific
  features through checked-in evidence, tests, docs, and checklists.
- **FORK-05**: Maintainer can verify full parity for Bambu Studio-specific
  features through checked-in evidence, tests, docs, and checklists.
- **FORK-06**: Maintainer can verify full parity for OrcaSlicer-specific
  features through checked-in evidence, tests, docs, and checklists.
- **FORK-07**: Maintainer can build every supported Slic3r-family flavor for
  every supported platform through GitHub Actions.
- **FORK-08**: Maintainer can run nightly review-gated vendor sync automation
  that detects new upstream fork behavior and uses Codex to prepare Rust port
  updates, parity evidence, and documentation updates as pull requests.
- **FORK-09**: Maintainers and contributors can inspect comprehensive
  extra-feature documentation and parity checklists for PrusaSlicer, Bambu
  Studio, and OrcaSlicer.

## Out of Scope

Explicit exclusions for this milestone.

| Feature | Reason |
| --- | --- |
| Signing, notarization, and release-channel publishing | v1.8 creates release build artifacts with provenance; release-grade distribution remains future work. |
| AppImage, MSI, DMG, or installer parity | Installer formats are higher-level packaging/release concerns beyond the scoped base release-build workflow. |
| Cross-flavor fork builds | Fork-flavor builds start after vendor intake and fork parity milestones. |
| GUI rewrite or GUI migration planning | Base release automation should stabilize before GUI strategy becomes actionable. |
| New CLI behavior beyond the verified help/version/config/export/transform slice | The goal is release build automation for the verified base package, not expansion of the Rust-backed behavioral surface. |
| Legacy package feature development | The legacy package remains the parity oracle except for minimal upkeep needed to preserve comparison value. |
| Nightly vendor sync and Codex-assisted merge automation | This requires full fork parity, stable vendor references, and review-gated automation before it is safe to enable. |

## Traceability

Which phases cover which requirements.

| Requirement | Phase | Status |
| --- | --- | --- |
| REL-03 | Phase 31 | Pending |
| REL-04 | Phase 31 | Pending |
| REL-05 | Phase 31 | Pending |
| REL-06 | Phase 31 | Pending |

**Coverage:**

- v1.8 requirements: 4 total
- Mapped to phases: 4
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-05-24*
*Last updated: 2026-05-24 after v1.8 milestone activation*
