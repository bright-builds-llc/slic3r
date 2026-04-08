# Slic3r Rust Port

## What This Is

This project modernizes the legacy Slic3r codebase by reorganizing it into a Bazel-driven monorepo and building a new Rust implementation alongside the preserved legacy implementation. The goal is to preserve the existing user-facing and exported contracts with full parity over time while improving readability, reliability, contributor experience, and long-term platform support for maintainers, contributors, and end users.

The legacy codebase remains in the repository as the reference implementation and parity oracle. New Rust work will live beside it under a `packages/`-style layout, with macOS as the first supported platform and the GUI rewrite deferred until the core and CLI migration are credible.

## Core Value

Deliver a trustworthy Rust successor to Slic3r that matches the legacy behavior and interfaces closely enough that the old implementation can eventually be retired without breaking the contracts users and integrators depend on.

## Current State

v1.1 shipped the CLI parity expansion milestone:

- the preferred Rust-backed macOS CLI path now supports `--help`, `--version`,
  `--save`, `--load`, and `--datadir`
- `cli.version`, `cli.help`, and `config.persistence` are all verified through
  shared fixture comparison commands
- parity visibility now reports those supported CLI slices as `verified`

## Current Milestone: v1.2 Export and Transform Parity

**Goal:** Expand Rust-backed macOS CLI parity into export workflows and selected
non-slicing transform actions while keeping the supported slice explicitly
bounded and verifiable.

**Target features:**

- Rust-backed export workflows for the next supported output slices
- Rust-backed non-slicing transform and info actions for the next supported CLI
  surface
- Shared fixtures and parity visibility for those export/transform slices

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

- Improve packaging-visible launcher parity beyond the current in-progress state
- Start Linux and Windows parity work in a dedicated follow-up milestone
- Decide the GUI migration strategy once CLI/core parity has broader coverage

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

### Active

- [ ] Deliver Rust-backed export workflows through the preferred launcher path
  on macOS
- [ ] Deliver Rust-backed non-slicing transform and info actions through the
  preferred launcher path on macOS
- [ ] Expand shared fixtures and parity visibility for the supported
  export/transform slices
- [ ] Keep broader packaging-visible, Linux/Windows, and GUI parity scoped to
  later milestones

### Out of Scope

- New GUI parity in the initial milestone — defer until the core, CLI, build, and parity foundations are stable
- Linux and Windows parity in the initial milestone — macOS is the first implementation and validation target
- Broad feature redesign or behavior changes that intentionally diverge from legacy Slic3r — this effort is parity-first, not a product reinvention
- Treating the legacy package as an active feature-development surface — it should remain the reference implementation except for minimal integration work needed to keep it buildable and usable as an oracle
- CI-enforced documentation gates in the initial milestone — documentation and checklist updates are required by process first, with automation to be considered later

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

*Last updated: 2026-04-08 after starting v1.2 Export and Transform Parity*
