# Project Milestones: Slic3r Rust Port

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
