# Rust Workspace

`packages/slic3r-rust` is the new Bazel-backed Rust implementation package for the Slic3r migration.

Phase 3 establishes the workspace, toolchain, and verification surface only. It does **not** yet claim CLI, GUI, or output-parity coverage against the retained legacy implementation.

## Layout

- `Cargo.toml` - virtual workspace root for the Rust package
- `BUILD.bazel` - package-level Bazel surface for build and verify commands
- `crates/slic3r_core/` - first Bright Builds-aligned library crate

## Bazel Commands

- Build the first Rust target:
  - `//packages:rust_build`
- Run the package verification suite:
  - `//packages/slic3r-rust:verify`
- Run write-mode formatting with the pinned Rust toolchain:
  - `bazel run @rules_rust//:rustfmt`

## Notes

- The Rust package is intentionally library-first in this phase.
- The package follows the Bright Builds coding and architecture requirements for Rust work.
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion).
