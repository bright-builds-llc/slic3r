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

## Current Contract Inventory State

- `docs/port/contract-inventory.md` is the detailed Phase 4 registry for CLI
  behavior, config semantics, supported file formats, generated outputs,
  launcher path, and packaging-visible behavior
- `docs/port/migration-guidance.md` explains how later phases should replace the
  launcher, interpret parity evidence, and evolve the future fixture corpus
- Phase 4 does not change any parity status by itself. It documents the contract
  surfaces and defers implementation claims to later phases
