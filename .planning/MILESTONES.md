# Project Milestones: Slic3r Rust Port

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
