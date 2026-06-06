# Slic3r Rust Port

## What This Is

This project modernizes the legacy Slic3r codebase by reorganizing it into a Bazel-driven monorepo and building a new Rust implementation alongside the preserved legacy implementation. The goal is to preserve the existing user-facing and exported contracts with full parity over time while improving readability, reliability, contributor experience, and long-term platform support for maintainers, contributors, and end users.

The legacy codebase remains in the repository as the reference implementation and parity oracle. New Rust work will live beside it under a `packages/`-style layout, with macOS as the first supported platform and the GUI rewrite deferred until the core and CLI migration are credible.

## Core Value

Deliver a trustworthy Rust successor to Slic3r that matches the legacy behavior and interfaces closely enough that the old implementation can eventually be retired without breaking the contracts users and integrators depend on.

## Current Milestone: v1.12 PrusaSlicer G-code Output Evidence Foundation

**Goal:** Prove one narrow PrusaSlicer G-code output evidence path without
claiming broad generated-output, printer-runtime, geometry, or GUI parity.

**Target features:**

- Select one small reviewed Prusa-generated G-code fixture with explicit
  provenance and deferred-scope language.
- Define a summary-only expected artifact for stable G-code metadata and marker
  evidence.
- Add a typed Rust summary boundary, fail-closed Bazel parity command,
  mutation guard, exact status row, and non-overclaiming docs.

## Last Shipped Milestone: v1.11 PrusaSlicer Broader Parity Port

**Shipped:** 2026-06-06

**Goal achieved:** Broadened PrusaSlicer parity beyond the v1.10
profile/config evidence slice by proving a narrow `prusaslicer.project-file`
evidence path with the same evidence discipline: source-pinned fixtures, typed
Rust boundaries, fail-closed parity commands, exact status rows, and
non-overclaiming docs.

## Current State

v1.12 is defining requirements. The milestone should reuse the v1.10/v1.11
trust chain for one deliberately narrow PrusaSlicer generated-output evidence
slice: reviewed scope, source-pinned fixture, checked-in expected summary,
typed Rust summary boundary, public Bazel parity command, failure guard, exact
status row, and non-overclaiming docs.

v1.11 is archived. Maintainers can now run
`bazel run //packages/parity:prusaslicer_project_file_parity`, inspect the
single `fork.prusaslicer.project-file` verified status row, and review docs
that keep the claim limited to the narrow Prusa project-file expected-summary
evidence slice. The milestone archive records the reviewed scope gate,
source-pinned fixture surface, pure Rust parser boundary, mutation failure
guard, exact status publication, and milestone audit.

v1.10 is archived. Maintainers can still run
`bazel run //packages/parity:prusaslicer_profile_schema_parity`, inspect the
single `fork.prusaslicer.profile-schema` verified status row, and review docs
that keep the claim limited to the narrow Prusa parser/config evidence slice.
The milestone also records reviewer-gated Prusa baseline signoff, checked-in
Prusa profile-schema fixtures, a pure Rust parser/summary boundary, a mutation
failure guard, UAT, and security verification with `threats_open: 0`.

Broader PrusaSlicer runtime support, GUI support, generated-output parity,
fork release builds, profile auto-update execution, network/cloud/credential
behavior, non-free plugin ingestion, and sync automation remain deferred.
Active downstream-fork port planning is limited to PrusaSlicer for now.
Non-Prusa Slicer-family ports, including Bambu Studio and OrcaSlicer, are
speculative parking-lot candidates and are not scheduled roadmap milestones.

v1.11 Phase 41 is complete. Maintainers can inspect the checked-in
`packages/prusa-project-file-scope` scope package, run
`bazel run //packages/prusa-project-file-scope:verify`, and trace
`prusaslicer.project-file` back to the accepted PrusaSlicer source identity and
inventory row before fixtures, parser work, parity targets, or status rows are
introduced. The scope gate completes PSEL-01 and PSEL-02 while keeping broad
3MF import/export, runtime, GUI, generated-output, release, network, plugin,
profile-update, and sync claims deferred.

v1.11 Phase 42 is complete. Maintainers can inspect the checked-in
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file` fixture
namespace, provenance manifest, update rules, and presence-level
`expected-project-summary.tsv`, then run
`bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture` to
validate the source-pinned fixture surface. The fixture surface completes
PFIX-01 and PFIX-02 while keeping Phase 43 Rust parser work and Phase 44
executable parity/status publication unavailable.

v1.11 Phase 43 is complete. Developers can use the pure
`slic3r_flavors::prusa_project_file` boundary to parse and summarize the
Phase 42 expected project summary into typed Rust metadata and presence-level
evidence rows. Registry metadata now traces the project-file surface through
shared typed constants, the fixture verifier allows the reviewed Rust surface,
and docs publish parser readiness without adding the Phase 44 executable
parity target or `fork.prusaslicer.project-file` status row. The boundary
completes PPROJ-01, PPROJ-02, and PPROJ-03.

v1.11 Phase 44 is complete. Maintainers can run
`bazel run //packages/parity:prusaslicer_project_file_parity`, see the command
fail closed on expected-artifact drift, inspect the exact
`fork.prusaslicer.project-file` status row, and read docs that keep full
PrusaSlicer runtime, GUI, generated-output, release, network/device,
profile-update, and sync surfaces deferred. The executable parity slice
completes PPEV-01, PPEV-02, and PPEV-03.

<details>
<summary>v1.9 shipped fork vendor intake and module architecture</summary>

v1.9 delivered:

- `packages/fork-vendors/forks.tsv` and
  `bazel run //packages/fork-vendors:verify`, giving maintainers pinned
  PrusaSlicer, Bambu Studio, and OrcaSlicer source refs, branch observations,
  lineage, source paths, refresh commands, SPDX metadata, provenance notes, and
  caution flags without cloning, fetching, building, or vendoring upstream fork
  repositories
- `packages/fork-inventories`, source-pinned per-fork inventory TSVs, and an
  exact-once cross-fork category map that classify base, shared downstream,
  fork-specific, and deferred source-observed planning inputs without treating
  them as executable fork parity
- typed Rust contracts in `slic3r_contracts` for downstream fork identity,
  flavor identity, vendor source identity, feature origin, parity surface, and
  checklist status
- a pure `slic3r_flavors` registry crate with hand-curated static metadata,
  lookup helpers, provenance tests, Cargo/Bazel verification, and no runtime
  Git, filesystem, network, process, release, sync, or TSV parsing side
  effects
- fork parity checklist, fixture namespace, launcher-shape, manual drift
  refresh, and deferral templates that reserve verified fork status for future
  executable evidence

The first recommended executable slice is Prusa profile schema/config parity
because it is fork-specific, medium complexity, and can build on the already
verified config/config-persistence evidence instead of jumping directly to
high-risk generated-output or network/cloud surfaces.

</details>

<details>
<summary>v1.8 shipped cross-platform release build automation</summary>

- the `Release Build Artifacts` workflow now builds scoped base package
  archives for macOS, Linux, and Windows
- each hosted runner job invokes the repo-owned release artifact builder after
  running the matching packaged launcher parity target
- each package tree carries `release-provenance.txt`, and each platform output
  includes an archive, checksum, and `release-manifest.txt`
- release automation docs describe the supported artifact boundary and keep
  signing, notarization, installers, AppImage/MSI/DMG support, GUI packaging,
  fork-flavor builds, and release channels deferred
- the final hosted workflow run passed on macOS, Linux, and Windows
- the v1.8 roadmap, requirements, audit, and Phase 31 history are archived
  under `.planning/milestones/`

</details>

<details>
<summary>v1.7 shipped the cross-platform packaging-visible parity milestone</summary>

- scoped Linux and Windows packaged launcher/startup surfaces now exist for
  the verified help/version/config/export/transform slice
- shared packaged launcher parity evidence now proves layout, startup handoff,
  help/version, and representative config behavior for Linux and Windows
- `linux.packaged-launcher` and `windows.packaged-launcher` are now `verified`
  in the parity status source
- migration docs, package docs, fixture docs, and traceability describe the
  exact cross-platform packaged launcher scope without overclaiming signing,
  installers, AppImage/MSI/DMG support, GUI packaging, or release channels
- the v1.7 phase history and milestone requirements are archived under
  `.planning/milestones/`

</details>

<details>
<summary>v1.6 shipped the Windows parity foundation milestone</summary>

- the preferred Rust-backed Windows launcher/runtime path now exists for the
  verified help/version/config/export/transform slice
- shared Windows runtime parity evidence now proves representative
  help/version/config/export/transform flows through the Windows runtime path
- `windows.runtime` is now `verified` in the parity status source, and the
  migration docs publish Windows runtime validation without overclaiming
  Windows packaging parity
- the v1.6 phase history and milestone requirements are archived under
  `.planning/milestones/`

</details>

<details>
<summary>v1.4 shipped the Linux parity foundation milestone</summary>

- the preferred Rust-backed Linux launcher/runtime path now exists for the
  verified help/version/config/export/transform slice
- shared Linux parity evidence now proves representative help/version/config/
  export/transform flows through the Linux launcher path
- `linux.runtime` is now `verified` in the parity status source, and the
  migration docs publish Linux runtime validation without overclaiming Linux
  packaging parity
- the v1.4 phase history, requirements, and audit are archived under
  `.planning/milestones/`

</details>

<details>
<summary>v1.3 shipped the packaging-visible parity milestone</summary>

- the preferred Rust-backed macOS path now includes a scoped packaged launcher
  bundle and startup shim for the verified CLI/export/transform slice
- shared packaged parity evidence now proves bundle layout, startup handoff,
  packaged `--help`, packaged `--version`, and representative packaged config
  persistence
- `launcher-packaging` is now `verified` in the parity status source, and the
  packaged launcher docs and notes match that exact evidence scope
- the v1.3 phase history, requirements, and audit are archived under
  `.planning/milestones/`

</details>

<details>
<summary>v1.2 shipped the export and transform parity milestone</summary>

- the preferred Rust-backed macOS CLI path now supports verified export
  workflows for G-code, STL, OBJ, AMF, 3MF, layered SVG, and explicit SLA SVG
- the preferred Rust-backed macOS CLI path now supports verified non-slicing
  `--info`, `--repair`, and `--split` behavior on macOS
- shared parity commands now verify help, version, config persistence, export
  workflows, and transform workflows
- milestone summaries now carry `requirements-completed` metadata, and the
  `docs/port/` overview docs now match the verified parity surface

</details>

<details>
<summary>v1.1 shipped the CLI parity expansion milestone</summary>

- the preferred Rust-backed macOS CLI path now supports `--help`, `--version`,
  `--save`, `--load`, and `--datadir`
- `cli.version`, `cli.help`, and `config.persistence` are all verified through
  shared fixture comparison commands
- parity visibility now reports those supported CLI slices as `verified`

</details>

<details>
<summary>v1.0 shipped the migration foundation milestone</summary>

- the repo is now a Bazel-driven monorepo with `packages/legacy-slic3r`,
  `packages/slic3r-rust`, `packages/launcher`, `packages/parity`, and
  `packages/parity-fixtures`
- the retained legacy implementation remains the macOS parity oracle through
  Bazel
- the Rust side has contract, CLI, and core crate boundaries
- the first supported Rust-backed macOS CLI slice is
  `bazel run //packages/launcher:slic3r -- --version`
- parity visibility and the first verified shared fixture comparison exist for
  `cli.version`

</details>

## Next Milestone Goals

- Start v1.12 with fresh requirements for a single PrusaSlicer G-code output
  evidence slice.
- Keep the expected artifact summary-only so the milestone proves stable G-code
  metadata and markers instead of byte-for-byte output parity.
- Keep support generation, arc fitting, wall seam behavior, STEP import, full
  3MF import/export, printer runtime behavior, and other generated-output
  evidence slices as future Prusa candidates.
- Limit active downstream-fork porting consideration to PrusaSlicer for now;
  Bambu Studio, OrcaSlicer, cross-flavor build automation, and nightly vendor
  sync are paused and may be revisited only after an explicit new planning
  decision.

## Requirements

### Validated

- ✓ Users can load supported 3D model inputs and generate print outputs such as G-code through the existing Slic3r runtime and CLI surfaces — existing
- ✓ Users can transform and convert model assets across supported formats and workflows, including STL, OBJ, AMF, 3MF, SVG, and related print/export operations — existing
- ✓ Slic3r already exposes both command-line and desktop GUI workflows, with the current implementation split across Perl, XS bindings, and C++ — existing
- ✓ The repository already contains build, test, and packaging flows for macOS, Linux, and Windows, even though much of that infrastructure is legacy and inconsistent — existing
- ✓ The current codebase can serve as a behavioral reference implementation for the port, supported by existing tests, native entrypoints, packaging scripts, and the new `.planning/codebase/` map — existing
- ✓ The repository is reorganized into a Bazel-driven monorepo with a retained legacy reference package and a Bright Builds-compliant Rust workspace — v1.0
- ✓ The legacy implementation remains buildable and testable through Bazel on macOS as the parity oracle — v1.0
- ✓ The Rust implementation now owns a verified shared parity slice for `cli.version` on macOS — v1.0
- ✓ Migration docs, contract inventory, parity status reporting, and fixture workflow rules are all visible under `docs/port/` and the package boundaries — v1.0
- ✓ The preferred Rust-backed CLI path now supports verified `--help`,
  `--version`, and scoped config persistence on macOS — v1.1
- ✓ Shared fixture comparison commands now verify the supported help, version,
  and config persistence slices — v1.1
- ✓ The preferred Rust-backed CLI path now supports verified export workflows
  for G-code, STL, OBJ, AMF, 3MF, layered SVG, and explicit SLA SVG — v1.2
- ✓ The preferred Rust-backed CLI path now supports verified non-slicing
  `--info`, `--repair`, and `--split` behavior on macOS — v1.2
- ✓ Shared parity commands now verify the scoped export and transform slices —
  v1.2
- ✓ Current milestone summaries now expose `requirements-completed` metadata
  for audit traceability — v1.2
- ✓ The preferred packaged macOS launcher/startup path now exists for the
  verified Rust-backed slice — v1.3
- ✓ Shared parity evidence now verifies macOS packaging-visible launcher
  behavior and artifact layout for the scoped packaged launcher surface — v1.3
- ✓ Packaging status and migration docs now reflect the scoped packaged macOS
  launcher slice accurately — v1.3
- ✓ The preferred Rust-backed Linux launcher/runtime path now exists for the
  existing verified slice — v1.4
- ✓ Shared parity evidence now verifies the supported Linux runtime slice
  through a dedicated Linux parity command — v1.4
- ✓ Linux validation state is now published in the parity status source and the
  migration docs — v1.4
- ✓ The preferred Rust-backed Windows launcher/runtime path now exists for the
  existing verified slice — v1.6
- ✓ Shared parity evidence now verifies the supported Windows runtime slice
  through a dedicated Windows parity command — v1.6
- ✓ Windows validation state is now published in the parity status source and
  the migration docs — v1.6
- ✓ Linux has a scoped packaging-visible launcher/startup surface for the
  verified Rust-backed help/version/config/export/transform slice — v1.7
- ✓ Windows has a scoped packaging-visible launcher/startup surface for the
  verified Rust-backed help/version/config/export/transform slice — v1.7
- ✓ Shared packaged launcher parity evidence verifies Linux and Windows
  packaging-visible launcher behavior — v1.7
- ✓ Parity status, migration docs, and package docs describe the
  cross-platform packaging-visible launcher scope without overclaiming
  installer, signing, AppImage/MSI/DMG support, GUI packaging, or release
  channels — v1.7
- ✓ Maintainer can use GitHub Actions to produce base Slic3r release build
  artifacts for macOS, Linux, and Windows through the Rust/Bazel workflow —
  v1.8
- ✓ Release build artifacts carry enough provenance to identify platform,
  commit, build mode, and supported package scope — v1.8
- ✓ Release build automation reuses verified packaged launcher evidence
  instead of inventing parallel release logic — v1.8
- ✓ Docs describe supported release-build outputs and remaining exclusions
  such as signing, notarization, installers, or release channels — v1.8
- ✓ v1.9 requirements define a vendor-source strategy for PrusaSlicer,
  Bambu Studio, and OrcaSlicer — Phase 32
- ✓ v1.9 requirements define fork feature inventories that distinguish base
  Slic3r behavior, shared downstream behavior, fork-specific behavior, and
  deferred source-observed planning inputs — Phase 33
- ✓ v1.9 requirements define typed Rust contracts for downstream fork
  identity, flavor identity, vendor source identity, feature origin, parity
  surface, and checklist status — Phase 34
- ✓ v1.9 requirements define modular Rust package boundaries for
  fork-specific behavior without forking the Rust codebase wholesale — Phase 35
- ✓ v1.9 requirements define parity checklist and documentation templates
  for downstream fork work without overclaiming runtime fork support — Phase 36
- ✓ v1.10 requirements define a reviewer-gated PrusaSlicer source baseline
  refresh and checklist record before implementation claims — Phase 37
- ✓ v1.10 requirements define fork fixture namespace and parity status
  conventions that can carry real Prusa executable evidence — Phase 38
- ✓ v1.10 requirements define a Rust-backed Prusa profile schema/config
  boundary using typed fork/flavor contracts and shared registry metadata —
  Phase 39
- ✓ v1.10 requirements define an executable Prusa profile/config parity
  command with fixtures, docs, and non-overclaiming status updates — Phase 40
- ✓ v1.11 requirements define a reviewed `prusaslicer.project-file` scope
  record with accepted source identity, inventory row ID, fixture source
  decision, expected-artifact contract, candidate Rust boundary, planned
  evidence command, docs touched, license/security note, deferred scope, and
  reviewer signoff — Phase 41
- ✓ v1.11 requirements distinguish the narrow project-file evidence contract
  from broad Prusa runtime, GUI, generated-output, release, network/cloud,
  credential, plugin, profile-update, and sync claims — Phase 41
- ✓ v1.11 creates the `prusaslicer.project-file` fixture surface and
  expected-artifact contract from the Phase 41 scope record — Phase 42
- ✓ v1.11 extends the typed Rust fork/flavor boundary only where the selected
  project-file evidence slice needs parsing, normalization, or summary
  behavior — Phase 43
- ✓ v1.11 publishes fail-closed parity commands, exact status rows, and
  non-overclaiming docs for the verified project-file evidence slice — Phase
  44
- ✓ v1.11 avoids broad Prusa runtime, GUI, generated-output, release,
  network/cloud, credential, plugin, and sync claims unless a deliberately
  scoped executable evidence chain exists for that surface — Phase 44

### Active

- [ ] v1.12 selects one reviewed Prusa-generated G-code fixture with explicit
  provenance and update rules.
- [ ] v1.12 defines a summary-only expected artifact for stable G-code metadata
  and marker evidence.
- [ ] v1.12 adds a typed Rust summary boundary for the selected G-code evidence
  without adding printer-runtime, geometry, support, seam, arc-fitting, or GUI
  claims.
- [ ] v1.12 publishes a fail-closed parity command, mutation guard, exact
  status row, and docs for the narrow G-code evidence slice.

### Out of Scope

- GUI migration planning and implementation remain out of scope until the
  fork-parity evidence path is credible enough not to destabilize the base
  migration track
- Signing, notarization, AppImage, MSI, DMG, installer parity, and
  release-channel publishing remain future packaging/release work beyond the
  current base artifact automation
- Broad feature redesign or new CLI slices beyond the currently verified
  surface remain secondary to release automation and GUI strategy decisions
- Treating the legacy package as an active feature-development surface — it
  remains the reference implementation except for minimal oracle upkeep
- Full PrusaSlicer parity remains outside the current milestone beyond the
  narrow evidence slices it explicitly implements.
- Non-Prusa Slicer-family ports, including Bambu Studio and OrcaSlicer, are
  paused parking-lot candidates; v1.9 artifacts remain historical planning and
  architecture inputs, not active roadmap commitments.
- Fork-flavor build automation is a paused parking-lot candidate until
  executable fork evidence and an explicit future planning decision define
  supported flavors.
- Nightly vendor sync and Codex-assisted merge automation are paused
  parking-lot candidates until stable fork modules, executable evidence, and
  review-gated refresh policy exist.

## Context

The current Slic3r codebase is a hybrid desktop and CLI application built from Perl, XS bindings, vendored C/C++, and a wxWidgets GUI. It already performs valuable work and exposes the contracts that matter, but the codebase is increasingly hard to maintain and is drifting toward effective unmaintainability.

The motivation for this port is modernization rather than novelty. The new implementation needs to improve readability, reliability, contributor experience, and long-term platform support without losing the behavior, formats, and workflows that existing users and integrators rely on.

The repo now has a fresh brownfield codebase map under `.planning/codebase/`, which documents the current architecture, stack, integrations, conventions, testing patterns, and known concerns. That map should be treated as the baseline reference for migration planning.

The current codebase still contains a split between newer native test/build flows and older Perl/XS/bootstrap flows, plus legacy CI and packaging scripts. Bazel is intended to become the top-level organizing build system that can orchestrate both the retained legacy package and the new Rust packages from one coherent entrypoint.

The audience for this work is broad:

- internal maintainers who need a sustainable modernization strategy
- contributors who need a readable, well-documented path to help with the port
- end users who need confidence that the Rust rewrite preserves the behavior they depend on

## Constraints

- **Build System**: Bazel is the top-level build and test entrypoint for the repository — to unify the monorepo and standardize how legacy and Rust packages are built
- **Reference Preservation**: The legacy codebase must stay buildable and usable as the parity oracle — to reduce migration risk and preserve a trustworthy comparison target
- **Parity**: Public and exported contracts must be preserved with full-parity intent across all externally visible surfaces — to avoid regressions for users and integrators
- **Platform Priority**: macOS comes first for the new implementation — because that is the active development platform and the fastest path to validated progress
- **Migration Shape**: The migration is phased coexistence, not big-bang replacement — because the legacy implementation is the reference and the Rust implementation will mature beside it
- **Implementation Standards**: The Rust codebase must comply with the Bright Builds Coding and Architecture Requirements — to improve readability, reliability, and maintainability from the start
- **Launcher Strategy**: The active implementation should move away from Perl, using Rust, Bazel, shell scripts, or thin shims where they provide the clearest replacement path — to reduce dependence on the legacy runtime model
- **Documentation Discipline**: Port-progress docs and checklists in `docs/` must be updated alongside Rust changes by process — to keep parity status and migration intent visible as the code evolves

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Adopt a Bazel-driven monorepo with a `packages/` layout | The migration needs one top-level build/test system that can host both legacy and Rust implementations coherently | ✓ Shipped in v1.0 |
| Retain the legacy Slic3r implementation as a reference package instead of rewriting in place | The old code should remain the oracle for parity and reduce migration risk | ✓ Shipped in v1.0 |
| Build the new implementation in Rust under Bright Builds standards | The port exists to improve readability, reliability, contributor experience, and long-term maintainability | ✓ Shipped in v1.0 |
| Target full parity across exported contracts, but defer GUI rewrite from the initial milestone | Core behavior and contract preservation matter first; GUI replacement can follow once the foundations are trustworthy | ✓ v1.0 foundation shipped, broader parity still active |
| Prioritize macOS first and defer Linux/Windows parity work | Current development happens on macOS, so that is the most practical first validation target | ✓ Shipped in v1.0 |
| Replace the active Perl launcher path with a documented Rust/Bazel/shell strategy | The migration should remove Perl from the preferred path without losing the current user-facing behavior | ✓ First Rust-backed slice shipped in v1.0 |
| Add a parity-check command that covers both status reporting and behavior comparison over time | The project needs both visible progress tracking and evidence-based parity validation | ✓ Shipped in v1.0 |
| Require migration docs and checklists under `docs/` by process before adding automation | Documentation discipline is important immediately, but hard enforcement can follow once the workflow settles | ✓ Process shipped in v1.0 |
| Treat GitHub Actions uploaded artifacts as the v1.8 release build surface | The project needed repeatable downloadable artifacts before release-channel publishing, signing, or installers | ✓ Shipped in v1.8 |
| Reuse packaged launcher parity as the release build evidence gate | Release automation should rely on the same checked-in evidence as the packaging-visible parity surface | ✓ Shipped in v1.8 |
| Embed release provenance inside each package tree | Maintainers need platform, commit, build mode, scope, package target, and evidence target visible in every artifact | ✓ Shipped in v1.8 |
| Treat source-pinned fork inventories as planning inputs, not runtime parity evidence | v1.9 needs feature ownership and scope metadata before fork behavior becomes implementation work | ✓ Shipped in Phase 33 |
| Model downstream fork and flavor metadata as typed Rust contracts before registry or core logic | Raw vendor strings, source pins, feature origins, parity surfaces, and checklist status labels should not leak across Rust boundaries | ✓ Shipped in Phase 34 |
| Use one shared `slic3r_flavors` crate instead of vendor-specific Rust workspaces | Future fork behavior should plug into shared capability metadata without copying base Rust workspace structure per vendor | ✓ Shipped in Phase 35 |
| Keep the flavor registry metadata-only and side-effect free | v1.9 registry data should be inspectable and testable without Git, filesystem, network, process, release, sync, or runtime parsing side effects | ✓ Shipped in Phase 35 |
| Reserve verified fork status for future executable evidence | Source pins, inventories, docs, and templates are necessary planning inputs but do not prove runtime fork behavior | ✓ Shipped in Phase 36 |
| Keep drift refresh manual and reviewer-gated until fork modules and fixtures exist | Automated vendor sync is unsafe before stable executable evidence and review boundaries exist | ✓ Shipped in Phase 36 |
| Keep the Prusa profile boundary pure and caller-supplied until executable parity owns status publication | Phase 39 needs typed parser and provenance data without Git, network, filesystem discovery, process, release, sync, or premature status-row side effects | ✓ Shipped in Phase 39 |
| Start fork implementation with a narrow PrusaSlicer evidence foundation instead of a full fork port | Prusa is the cleanest first downstream fork, and a profile/config slice proves the evidence workflow without high-risk generated-output or network/cloud scope | ✓ Shipped in v1.10 |
| Gate Prusa project-file parity behind a checked-in scope package before fixtures, parser work, parity targets, or status rows | Project-file support is close enough to broad 3MF/runtime behavior that maintainers need a reviewed evidence contract before implementation can make claims | ✓ Shipped in Phase 41 |
| Keep Prusa project-file fixture TSVs exact instead of append-only | Phase 42 fixture artifacts are a narrow evidence surface, so extra provenance or expected-summary rows could overclaim parser or parity behavior while the verifier still passed | ✓ Shipped in Phase 42 |
| Publish project-file parity only as a narrow expected-summary evidence slice | Phase 44 proves command/status wiring without claiming full 3MF import/export, GUI project behavior, runtime semantics, or generated-output parity | ✓ Shipped in Phase 44 |
| Start generated-output work with summary-only G-code evidence | G-code is closer to real port value than another static input slice, but byte-for-byte output parity and printer-runtime claims are too broad for the first generated-output milestone | — Pending in v1.12 |
| Limit active downstream-fork porting consideration to PrusaSlicer for now | Non-Prusa Slicer-family ports need an explicit new planning decision before moving from parking lot into the roadmap | ✓ Adopted 2026-06-03 |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):

1. Requirements invalidated? → Move to Out of Scope with reason
1. Requirements validated? → Move to Validated with phase reference
1. New requirements emerged? → Add to Active
1. Decisions to log? → Add to Key Decisions
1. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):

1. Full review of all sections
1. Core Value check — still the right priority?
1. Audit Out of Scope — reasons still valid?
1. Update Context with current state

______________________________________________________________________

*Last updated: 2026-06-06 after starting v1.12 milestone*
