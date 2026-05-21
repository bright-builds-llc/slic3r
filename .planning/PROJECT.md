# Slic3r Rust Port

## What This Is

This project modernizes the legacy Slic3r codebase by reorganizing it into a Bazel-driven monorepo and building a new Rust implementation alongside the preserved legacy implementation. The goal is to preserve the existing user-facing and exported contracts with full parity over time while improving readability, reliability, contributor experience, and long-term platform support for maintainers, contributors, and end users.

The legacy codebase remains in the repository as the reference implementation and parity oracle. New Rust work will live beside it under a `packages/`-style layout, with macOS as the first supported platform and the GUI rewrite deferred until the core and CLI migration are credible.

## Core Value

Deliver a trustworthy Rust successor to Slic3r that matches the legacy behavior and interfaces closely enough that the old implementation can eventually be retired without breaking the contracts users and integrators depend on.

## Current State

v1.6 shipped the Windows parity foundation milestone:

- the preferred Rust-backed Windows launcher/runtime path now exists for the
  verified help/version/config/export/transform slice
- shared Windows runtime parity evidence now proves representative
  help/version/config/export/transform flows through the Windows runtime path
- `windows.runtime` is now `verified` in the parity status source, and the
  migration docs publish Windows runtime validation without overclaiming
  Windows packaging parity
- the v1.6 phase history and milestone requirements are archived under
  `.planning/milestones/`

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

- Extend packaging-visible launcher parity to Linux and Windows now that both
  non-macOS runtime slices are verified
- Define the GUI migration strategy once packaging-visible parity has broader
  cross-platform coverage
- Revisit cross-platform packaging and release-channel automation after the
  launcher-packaging evidence surface expands beyond macOS

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

### Active

- [ ] Maintainer can verify packaging-visible launcher behavior for Linux and
  Windows through shared parity evidence
- [ ] Maintainer has a concrete milestone and acceptance strategy for the
  future GUI migration
- [ ] Cross-platform packaging and release-channel automation can move onto a
  shared modern path once non-macOS launcher-packaging evidence exists

### Out of Scope

- Packaging-visible Linux and Windows parity remain future milestone work even
  though the runtime slices are now both verified
- GUI migration planning and implementation remain out of scope until the
  launcher-packaging story is broader and more stable
- Broad feature redesign or new CLI slices beyond the currently verified
  surface remain secondary to packaging parity and GUI strategy decisions
- Treating the legacy package as an active feature-development surface — it
  remains the reference implementation except for minimal oracle upkeep

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

______________________________________________________________________

*Last updated: 2026-05-21 after v1.6 milestone*
