# Project Milestones: Slic3r Rust Port

## v1.10 PrusaSlicer Parity Evidence Foundation (Shipped: 2026-06-02)

**Delivered:** Proved the first narrow executable PrusaSlicer profile/config
evidence slice, from reviewer-gated baseline and fixtures through Rust parser
boundary, parity command, exact status row, UAT, and security verification.

**Phases completed:** 37-40 (6 plans total, 15 plan tasks)

**Key accomplishments:**

- PrusaSlicer profile-schema baseline gate with checked records, fail-closed verification, and port-doc routing
- Static Prusa profile-schema fixture bundle with provenance, fail-closed Bazel verification, and docs-only status reservation
- Std-only Prusa profile parser with typed fixture metadata and Cargo/Bazel verification for the profile-schema boundary
- Prusa profile-schema parser documentation with exact fixture traceability and Phase 40 status deferral
- Rust-backed PrusaResearch.ini profile-schema parity command with checked-in TSV expectations and a mutation failure guard
- Verified Prusa profile-schema status publication with exact-row fixture enforcement and narrow-scope docs

**Stats:**

- 4 phases, 6 plans, 15 plan tasks
- Requirements: 12/12 complete
- Milestone audit: passed
- Security: `threats_open: 0`
- UAT: 3 passed, 0 issues, 1 skipped by user acceptance
- Milestone archive: [v1.10-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.10-ROADMAP.md)
- Requirements archive: [v1.10-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.10-REQUIREMENTS.md)
- Audit: [v1.10-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.10-MILESTONE-AUDIT.md)

**What's next:** start v1.11 with fresh requirements for broader PrusaSlicer
parity, using the v1.10 profile/config evidence path as the trust foundation.

______________________________________________________________________

## v1.9 Fork Vendor Intake and Module Architecture (Shipped: 2026-05-29)

**Delivered:** Established pinned downstream fork references, source-pinned
feature inventories, typed Rust flavor contracts, a pure shared flavor
registry boundary, and fork parity templates for PrusaSlicer, Bambu Studio,
and OrcaSlicer without importing upstream source trees or claiming runtime fork
support.

**Phases completed:** 32-36 (8 plans total)

**Key accomplishments:**

- Added a metadata-only fork vendor registry with Git ref verification and
  license/provenance caution boundaries

- Added a source-pinned fork inventory TSV package with exact-once category
  mapping and a Bazel verifier

- Added strict Rust flavor metadata contracts with source-pin validation,
  typed taxonomy parsers, Bazel coverage, and metadata-only port docs

- Added public const constructors for canonical parity surfaces, with
  parser-drift tests and no registry side effects

- Added the pure `slic3r_flavors` registry crate with static typed capability
  metadata, provenance tests, and Cargo/Bazel verification coverage

- Documented the `slic3r_flavors` registry boundary with metadata-only scope,
  API names, and source-evidence traceability

- Added fork parity checklist, launcher-shape template, manual drift protocol,
  and local Bazel verifier coverage for Phase 36 template contracts

- Centralized fork-parity deferrals, future fixture/status vocabulary, and
  cross-package links for fork template usage

**Stats:**

- 5 phases, 8 plans, 21 plan tasks

- Milestone audit passed before archive

- Milestone archive: [v1.9-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-ROADMAP.md)

- Requirements archive: [v1.9-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-REQUIREMENTS.md)

- Audit: [v1.9-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-MILESTONE-AUDIT.md)

- Phase archive: [v1.9-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.9-phases/)

**What's next:** start the next milestone with fresh requirements, likely
v1.10 PrusaSlicer parity if the current future roadmap remains valid, and
require executable evidence before any fork behavior is marked verified

______________________________________________________________________

## v1.8 Cross-Platform Release Build Automation (Shipped: 2026-05-24)

**Delivered:** Added repeatable GitHub Actions release build automation for
base Slic3r artifacts across macOS, Linux, and Windows, with packaged launcher
parity gates and embedded provenance in every package tree.

**Phases completed:** Phase 31 (1 plan total)

**Key accomplishments:**

- Added the `Release Build Artifacts` GitHub Actions workflow with manual and
  version-tag triggers for macOS, Linux, and Windows hosted runners

- Added `tools/release/build_release_artifact.sh`, a repo-owned release
  artifact builder that runs packaged launcher parity evidence before packaging

- Embedded `release-provenance.txt` in each platform package tree and wrote
  manifests/checksums beside uploaded archives

- Documented supported outputs and explicit exclusions for signing,
  notarization, installers, AppImage, MSI, DMG, GUI packaging, fork-flavor
  builds, and release-channel publishing

- Verified the hosted workflow matrix after CI hardening; the final run passed
  on macOS, Linux, and Windows

**Stats:**

- 1 phase, 1 plan

- 7 shipped commits after v1.7, including workflow creation and hosted-runner
  hardening fixes

- Milestone archive: [v1.8-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-ROADMAP.md)

- Requirements archive: [v1.8-REQUIREMENTS.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-REQUIREMENTS.md)

- Audit: [v1.8-MILESTONE-AUDIT.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-MILESTONE-AUDIT.md)

- Phase archive: [v1.8-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.8-phases/)

**What's next:** start v1.9 fork vendor intake and module architecture, using
the now-stable base release automation as the foundation for later fork-flavor
builds

______________________________________________________________________

## v1.7 Cross-Platform Packaging-Visible Parity (Shipped: 2026-05-23)

**Delivered:** Extended scoped packaging-visible launcher parity to Linux and
Windows, proved both packaged startup paths through shared evidence, and
published the exact verified scope in parity status and migration docs.

**Phases completed:** 27-30 (8 plans total)

**Key accomplishments:**

- Delivered scoped Linux and Windows packaged launcher/startup surfaces for the
  verified Rust-backed help/version/config/export/transform slice

- Added shared Linux and Windows packaged launcher parity commands backed by
  checked-in layout, scope-note, and behavior fixtures

- Published `linux.packaged-launcher` and `windows.packaged-launcher` as
  verified rows in the parity status source

- Aligned migration, launcher, package, parity, and fixture docs with the
  scoped packaged launcher evidence without overclaiming signing, installers,
  GUI packaging, or release channels

- Verified v1.7 traceability across roadmap, requirements, summary metadata,
  and final packaged launcher parity evidence

**Stats:**

- 4 phases, 8 plans

- 4 shipped phase commits for phases 27-30, plus phase planning and closeout
  commits

- Milestone archive: [v1.7-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.7-ROADMAP.md)

- Phase archive: [v1.7-phases/](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.7-phases/)

**What's next:** automate base Slic3r release builds for macOS, Linux, and
Windows through GitHub Actions while keeping signing, installers, release
channels, GUI work, and fork-flavor builds deferred

______________________________________________________________________

## v1.6 Windows Parity Foundation (Shipped: 2026-05-21)

**Delivered:** Established the preferred Rust-backed Windows runtime path for
the existing verified slice, proved it through a dedicated shared parity
command, and published Windows validation state in the checked-in parity and
migration surfaces.

**Phases completed:** 24-26 (7 plans total)

**Key accomplishments:**

- Delivered a preferred Windows runtime target and Bazel smoke surface for the
  existing verified Rust-backed slice

- Added shared Windows runtime parity evidence backed by a dedicated fixture
  bundle that reuses the verified slice fixtures

- Published `windows.runtime` as `verified` in the checked-in parity status
  data source and aligned the migration docs to that exact scope

- Closed the milestone with phase UAT and security verification artifacts for
  the Windows visibility phase

**Stats:**

- 3 phases, 7 plans

- 3 shipped phase commits for phases 24-26, plus milestone-init and closeout
  validation/security commits

- Milestone archive: [v1.6-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.6-ROADMAP.md)

**What's next:** extend packaging-visible launcher parity cross-platform,
define the GUI migration strategy, and revisit release-channel automation now
that both non-macOS runtime slices are verified

______________________________________________________________________

## v1.4 Linux Parity Foundation (Shipped: 2026-04-11)

**Delivered:** Established the preferred Rust-backed Linux runtime path for the
existing verified slice, proved it through a dedicated shared parity command,
and published Linux validation state in the checked-in parity and migration
surfaces.

**Phases completed:** 21-23 (7 plans total)

**Key accomplishments:**

- Delivered a preferred Linux launcher/runtime shim and Bazel smoke surface for
  the existing verified Rust-backed slice

- Added shared Linux runtime parity evidence for representative
  help/version/config/export/transform flows

- Published `linux.runtime` as `verified` in the checked-in parity status data
  source and aligned the migration docs to that exact scope

- Archived the v1.4 phase history, milestone audit, and milestone requirements
  into the milestone archive set

**Stats:**

- 3 phases, 7 plans
- 3 shipped phase commits for phases 21-23, plus milestone-init commits
- Milestone archive: [v1.4-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.4-ROADMAP.md)

**What's next:** start validated Windows runtime parity, extend
packaging-visible launcher parity cross-platform, and decide the GUI migration
strategy

______________________________________________________________________

## v1.3 Packaging-Visible Parity (Shipped: 2026-04-11)

**Delivered:** Extended the preferred Rust-backed macOS path into
packaging-visible launcher behavior, then verified the packaged startup surface
through shared bundle and representative config-persistence evidence.

**Phases completed:** 18-20 (6 plans total)

**Key accomplishments:**

- Delivered a scoped macOS packaged launcher bundle and startup shim for the
  verified Rust-backed slice

- Added shared packaging parity evidence for bundle layout, startup handoff,
  packaged `--help`, packaged `--version`, and representative config
  persistence

- Promoted `launcher-packaging` to `verified` with an explicit evidence command
  and aligned the packaged launcher docs and notes to that exact scope

- Archived the v1.3 phase history, milestone audit, and milestone requirements
  into the milestone archive set

**Stats:**

- 3 phases, 6 plans

- 3 shipped phase commits for phases 18-20, plus milestone-init and gap-phase
  planning commits

- Milestone archive: [v1.3-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.3-ROADMAP.md)

**What's next:** start validated Linux and Windows parity work, extend
packaging-visible parity cross-platform, and decide the GUI migration strategy

______________________________________________________________________

## v1.2 Export and Transform Parity (Shipped: 2026-04-11)

**Delivered:** Expanded the preferred Rust-backed macOS CLI path into verified
export and non-slicing transform parity slices, tightened fixture coverage for
those slices, and hardened the milestone audit trail with machine-readable
summary metadata.

**Phases completed:** 12-17 (14 plans total)

**Key accomplishments:**

- Delivered Rust-backed export workflows for G-code, STL, OBJ, AMF, 3MF,
  layered SVG, and explicit `--export-sla-svg`

- Delivered Rust-backed `--info`, `--repair`, and `--split` behavior with
  legacy-shaped repair and split filenames

- Added shared fixture comparison commands for export and transform workflows
  and promoted both parity rows to `verified`

- Tightened fixture coverage for the explicit SLA SVG alias and the full
  documented `--info` input matrix

- Added `requirements-completed` summary metadata and aligned the control-plane
  docs with the verified parity surface

**Stats:**

- 6 phases, 14 plans

- 6 shipped phase commits for phases 12-17, plus milestone-init and audit-gap
  planning commits

- Milestone archive: [v1.2-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.2-ROADMAP.md)

**What's next:** improve packaging-visible launcher parity, begin validated
Linux and Windows parity work, and decide the GUI migration strategy

______________________________________________________________________

## v1.1 CLI Parity Expansion (Shipped: 2026-04-08)

**Delivered:** Expanded the preferred Rust-backed macOS CLI path from
`--version` to a verified help/version/config persistence slice with shared
fixture coverage and parity visibility.

**Phases completed:** 9-11 (8 plans total)

**Key accomplishments:**

- Delivered a Rust-backed `--help` and usage screen through the preferred
  launcher path

- Delivered Rust-backed `--save`, `--load`, and `--datadir` support for the
  scoped CLI slice

- Added shared fixture comparison commands for help and config persistence

- Promoted `cli.help` and `config.persistence` to `verified` in the checked-in
  parity status source

**Stats:**

- 3 phases, 8 plans
- 3 shipped feature commits for phases 9-11
- Milestone archive: [v1.1-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.1-ROADMAP.md)

**What's next:** broaden CLI parity into export/transform flows, improve
packaging-visible parity, and decide the next platform and GUI milestones

______________________________________________________________________

## v1.0 Rust Port Foundations (Shipped: 2026-04-08)

**Delivered:** Bazel monorepo foundations, retained legacy oracle preservation,
the first Rust-backed macOS CLI slice, and a verified shared parity workflow for
`cli.version`.

**Phases completed:** 1-8 (22 plans total)

**Key accomplishments:**

- Established the Bazel root, `packages/` monorepo layout, and migration
  control-plane documentation

- Preserved the legacy Slic3r implementation as a buildable and testable Bazel
  parity oracle on macOS

- Added a Bright Builds-compliant Rust workspace with contract, CLI, and core
  crate boundaries

- Made `bazel run //packages/launcher:slic3r -- --version` the preferred
  Rust-backed macOS CLI workflow for the first supported slice

- Added parity visibility via `bazel run //packages/parity:status`

- Verified the shared `cli.version` slice against legacy and fixture output via
  `bazel run //packages/parity:cli_version_parity`

**Stats:**

- 8 phases, 22 plans

- 4 shipped feature commits for phases 5-8 after the pushed phase-completion
  workflow stabilized

- Milestone archive: [v1.0-ROADMAP.md](/Users/peterryszkiewicz/Repos/Slic3r/.planning/milestones/v1.0-ROADMAP.md)

**What's next:** expand Rust-backed parity beyond `--version`, grow shared
fixtures, and define the next milestone for broader CLI and platform coverage

______________________________________________________________________
