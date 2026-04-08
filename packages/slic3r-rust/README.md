# Rust Workspace

`packages/slic3r-rust` is the new Bazel-backed Rust implementation package for the Slic3r migration.

Phase 3 establishes the workspace, toolchain, and verification surface only.
Phase 5 adds contract-oriented crate boundaries and the first launcher-facing
Rust CLI scaffold. It still does **not** claim user-facing CLI, GUI, or
output-parity coverage against the retained legacy implementation.

## Layout

- `Cargo.toml` - virtual workspace root for the Rust package
- `BUILD.bazel` - package-level Bazel surface for build and verify commands
- `crates/slic3r_core/` - lower-level Rust implementation crate
- `crates/slic3r_contracts/` - stable contract-oriented launcher types
- `crates/slic3r_cli/` - launcher-facing CLI scaffold

## Bazel Commands

- Build the first Rust target:
  - `//packages:rust_build`
- Build the launcher-facing Rust entrypoint scaffold:
  - `//packages:rust_entrypoint_scaffold`
- Run the package verification suite:
  - `//packages/slic3r-rust:verify`
- Run write-mode formatting with the pinned Rust toolchain:
  - `bazel run @rules_rust//:rustfmt`

## Notes

- The Rust package is intentionally architecture-first in this phase.
- The package follows the Bright Builds coding and architecture requirements for Rust work.
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion).
