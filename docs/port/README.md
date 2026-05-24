# Rust Port Control Plane

This directory is the source of truth for the Slic3r Rust port during the migration.

Phase 1 establishes the monorepo scaffold, the retained legacy reference
package, and the documentation surfaces reviewers should use to understand
current progress. Phase 2 turns the retained legacy package into a Bazel-wrapped
oracle surface on macOS, but keeps that package explicitly reference-only.
Phase 3 makes `packages/slic3r-rust` a real Bright Builds-compliant Rust
workspace with Bazel-native build and verify surfaces. Phase 4 adds the
contract inventory and migration guidance that later implementation phases must
follow. Until automation exists, any Rust-port or parity-surface change is
expected to update the relevant docs here in the same change.

## Documents

- [`checklist.md`](./checklist.md) - migration-surface checklist for what
  exists, what is pending, and which docs or package boundaries already exist
- [`cli-slice.md`](./cli-slice.md) - currently supported Rust-backed macOS CLI
  workflow and explicitly unsupported arguments
- [`contract-inventory.md`](./contract-inventory.md) - evidence-backed registry
  of the externally visible contracts the Rust port must preserve
- [`entrypoint-architecture.md`](./entrypoint-architecture.md) - Rust, Bazel,
  launcher-package, and future shell-shim responsibilities for the first CLI
  slice
- [`migration-guidance.md`](./migration-guidance.md) - launcher replacement,
  parity evidence, fixture protocol, and scope-now-versus-deferred rules
- [`packaged-launcher-slice.md`](./packaged-launcher-slice.md) - scoped macOS
  packaged launcher bundle and startup layout expectations
- [`release-build-automation.md`](./release-build-automation.md) - scoped
  GitHub Actions release build artifacts, provenance, and evidence gates
- [`windows-launcher-slice.md`](./windows-launcher-slice.md) - scoped Windows
  runtime launcher surface and its deferred packaging boundaries
- [`parity-matrix.md`](./parity-matrix.md) - contract-surface status using the
  shared migration vocabulary
- [`package-map.md`](./package-map.md) - package roles, root-owned areas, and
  future owner boundaries in the monorepo

## Status Vocabulary

- `legacy-only` - only the retained legacy package currently provides the surface
- `in progress` - migration work exists, but the Rust path is not yet the trusted implementation
- `rust-backed` - the Rust implementation provides the surface, but parity still needs deeper proof
- `verified` - parity has been checked and accepted for the tracked scope

## Review Expectation

When a change touches Rust-port behavior, parity surfaces, launcher boundaries,
fixture protocol, or package ownership, reviewers should expect the relevant
file in `docs/port/` to move with it. If the docs do not change, the review
should explicitly explain why.

## Current Legacy Oracle State

- `//:legacy_oracle_build` is the Bazel-wrapped retained legacy build surface on macOS
- `//:legacy_oracle_smoke` is the current trusted oracle check
- `//:legacy_oracle_test` exists, but remains a deferred broader legacy test surface until the retained XS loader issues are fully resolved

This means the retained legacy package is now usable as a buildable oracle on macOS, but the trusted oracle set is intentionally narrower than the full historical test tree.

## Current Rust Workspace State

- `packages/slic3r-rust` now contains a real `slic3r_core` crate
- `//packages:rust_build` is the root-facing Bazel build entrypoint for the Rust package
- `//packages/slic3r-rust:verify` is the package-level verification surface
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in `.bazelversion`

Phase 3 changes the Rust workspace/tooling surface only. User-facing parity surfaces remain legacy-only until later phases.

## Current Entrypoint Architecture State

- `packages/slic3r-rust/crates/slic3r_contracts` is the stable contract-oriented
  launcher crate
- `packages/slic3r-rust/crates/slic3r_cli` is the launcher-facing Rust CLI
  scaffold
- `packages/launcher` is now a real package boundary that points at that Rust
  entrypoint scaffold
- Phase 6 makes `--version` the first supported Rust-backed macOS CLI workflow
  through `bazel run //packages/launcher:slic3r -- --version`
- Phase 21 adds the preferred Linux runtime path through
  `bazel run //packages/launcher:linux_slic3r -- --help`
- Phase 24 adds the preferred Windows runtime path through
  `bazel run //packages/launcher:windows_slic3r -- --help`
- Phase 18 adds a scoped macOS packaged launcher bundle through
  `bazel run //packages/launcher:macos_packaged_launcher_bundle`
- Phase 27 and Phase 28 add scoped Linux and Windows packaged launcher trees;
  Phase 29 verifies those package-shaped launcher trees through
  `//packages/parity:linux_packaged_launcher_parity` and
  `//packages/parity:windows_packaged_launcher_parity`
- Phase 31 adds scoped GitHub Actions release build artifacts for the base
  package through `.github/workflows/release-build-artifacts.yml`, with
  provenance embedded in each uploaded package tree.

## Current Contract Inventory State

- `docs/port/contract-inventory.md` is the detailed Phase 4 registry for CLI
  behavior, config semantics, supported file formats, generated outputs,
  launcher path, and packaging-visible behavior
- `docs/port/migration-guidance.md` explains how later phases should replace the
  launcher, interpret parity evidence, and evolve the future fixture corpus
- Phase 4 does not change any parity status by itself. It documents the contract
  surfaces and defers implementation claims to later phases
- `docs/port/packaged-launcher-slice.md` now documents the scoped macOS package
  bundle layout and startup expectations for the preferred launcher surface
- `docs/port/linux-launcher-slice.md` now documents the scoped Linux runtime
  handoff for the preferred launcher surface
- `docs/port/windows-launcher-slice.md` now documents the scoped Windows
  runtime handoff for the preferred launcher surface without claiming packaging
  parity

## Current Parity Visibility State

- `bazel run //packages/parity:status` is the current parity visibility command
- `bazel run //packages/parity:cli_version_parity` is the current shared fixture
  comparison command for the supported `--version` slice
- `bazel run //packages/parity:cli_help_parity` is the shared fixture
  comparison command for the supported `--help` slice
- `bazel run //packages/parity:cli_config_persistence_parity` is the shared
  fixture comparison command for the scoped config persistence slice
- `bazel run //packages/parity:export_workflows_parity` is the shared fixture
  comparison command for the verified scoped export workflows
- `bazel run //packages/parity:transform_workflows_parity` is the shared
  fixture comparison command for the verified scoped transform/info workflows
- `bazel run //packages/parity:macos_packaged_launcher_parity` is the shared
  parity command for the verified scoped macOS packaged launcher slice
- `bazel run //packages/parity:linux_runtime_parity` is the shared parity
  command for the verified scoped Linux runtime slice
- `bazel run //packages/parity:windows_runtime_parity` is the shared parity
  command for the verified scoped Windows runtime slice
- `bazel run //packages/parity:linux_packaged_launcher_parity` is the shared
  parity command for the verified scoped Linux packaged launcher tree
- `bazel run //packages/parity:windows_packaged_launcher_parity` is the shared
  parity command for the verified scoped Windows packaged launcher tree
- `linux.packaged-launcher` and `windows.packaged-launcher` are checked-in
  status rows in `packages/parity/status.tsv`
- `packages/parity/status.tsv` is the checked-in status data source
- `packages/parity-fixtures/README.md` defines the package-local fixture update
  rules, and the fixture package now contains seeded corpora for:
  - `cli.version`
  - `cli.help`
  - `config.persistence`
  - `linux.runtime`
  - `windows.runtime`
  - `export.workflows`
  - `transform.workflows`
  - `launcher-packaging`
  - `linux.packaged-launcher`
  - `windows.packaged-launcher`
