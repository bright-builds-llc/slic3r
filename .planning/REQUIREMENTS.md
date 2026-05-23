# Requirements: Slic3r Rust Port

**Defined:** 2026-05-22
**Milestone:** v1.7 Cross-Platform Packaging-Visible Parity
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1.7 Requirements

Requirements for the current milestone. Each maps to exactly one roadmap phase.

### Linux Packaging

- [x] **LPKG-01**: Maintainer can build a scoped Linux packaging-visible
  launcher artifact for the already verified Rust-backed
  help/version/config/export/transform slice.
- [x] **LPKG-02**: Maintainer can run the Linux packaged startup path through
  Bazel smoke coverage without relying on ad hoc local setup.
- [x] **LPKG-03**: The Linux packaged launcher surface keeps startup/bootstrap
  logic thin and does not move business logic into shell packaging code.

### Windows Packaging

- [ ] **WPKG-01**: Maintainer can build a scoped Windows packaging-visible
  launcher artifact for the already verified Rust-backed
  help/version/config/export/transform slice.
- [ ] **WPKG-02**: Maintainer can run the Windows packaged startup path through
  Bazel smoke coverage without relying on Linux or macOS launcher shims.
- [ ] **WPKG-03**: The Windows packaged launcher surface keeps
  startup/bootstrap logic thin and does not overclaim installer or
  release-channel support.

### Shared Evidence

- [ ] **PKGE-01**: Maintainer can execute shared Linux packaged launcher parity
  evidence that proves artifact layout, startup handoff, help/version, and
  representative config behavior.
- [ ] **PKGE-02**: Maintainer can execute shared Windows packaged launcher
  parity evidence that proves artifact layout, startup handoff, help/version,
  and representative config behavior.
- [ ] **PKGE-03**: The shared packaged evidence is reviewable through
  checked-in fixtures and commands rather than manual spot checks.

### Visibility

- [ ] **PVIS-01**: Parity status reports Linux and Windows packaging-visible
  launcher validation state accurately.
- [ ] **PVIS-02**: Migration docs and package docs describe the supported Linux
  and Windows packaged launcher scope and remaining gaps without overclaiming
  signing, installers, AppImage/MSI/DMG, or release channels.
- [ ] **PVIS-03**: The milestone roadmap and traceability map every v1.7
  requirement to exactly one phase.

## Future Requirements

Deferred to future milestones.

### GUI Migration

- **GUI-01**: Maintainer has a concrete GUI migration strategy after
  cross-platform packaging-visible launcher evidence exists.
- **GUI-02**: User can run a Rust-backed GUI workflow with parity against the
  retained legacy GUI surface.

### Release Automation

- **REL-01**: Maintainer can produce signed or notarized platform artifacts
  through a documented release-channel workflow.
- **REL-02**: Maintainer can generate installer-grade packages such as AppImage,
  MSI, DMG, or platform-specific release bundles.

## Out of Scope

Explicit exclusions for this milestone.

| Feature | Reason |
| --- | --- |
| GUI rewrite or GUI migration planning | The packaging-visible launcher surface should be broader and more stable before GUI strategy becomes actionable. |
| Signing, notarization, and release-channel automation | This milestone verifies scoped packaged launcher behavior, not release-grade distribution. |
| AppImage, MSI, DMG, or installer parity | Installer formats are higher-level packaging/release concerns beyond the scoped launcher artifact. |
| New CLI behavior beyond the verified help/version/config/export/transform slice | The goal is packaging parity for the verified slice, not expansion of the Rust-backed behavioral surface. |
| Legacy package feature development | The legacy package remains the parity oracle except for minimal upkeep needed to preserve comparison value. |

## Traceability

Which phases cover which requirements. Populated during roadmap creation.

| Requirement | Phase | Status |
| --- | --- | --- |
| LPKG-01 | Phase 27 | Complete |
| LPKG-02 | Phase 27 | Complete |
| LPKG-03 | Phase 27 | Complete |
| WPKG-01 | Phase 28 | Pending |
| WPKG-02 | Phase 28 | Pending |
| WPKG-03 | Phase 28 | Pending |
| PKGE-01 | Phase 29 | Pending |
| PKGE-02 | Phase 29 | Pending |
| PKGE-03 | Phase 29 | Pending |
| PVIS-01 | Phase 30 | Pending |
| PVIS-02 | Phase 30 | Pending |
| PVIS-03 | Phase 30 | Pending |

**Coverage:**

- v1.7 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0

______________________________________________________________________

*Requirements defined: 2026-05-22*
*Last updated: 2026-05-22 after v1.7 roadmap creation*
