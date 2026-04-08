# Rust Workspace

`packages/slic3r-rust` is the new Bazel-backed Rust implementation package for the Slic3r migration.

Phase 3 establishes the workspace, toolchain, and verification surface only.
Phase 5 adds contract-oriented crate boundaries and the first launcher-facing
Rust CLI scaffold. Phase 6 makes the `--version` path the first supported
Rust-backed macOS CLI slice. Phase 9 adds the `--help` path. Broader CLI, GUI,
and output parity remain later work. Phase 10 adds the scoped config
persistence path.

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
- Run the first supported Rust-backed CLI slice:
  - `bazel run //packages/launcher:slic3r -- --version`
- Run the Rust-backed help slice:
  - `bazel run //packages/launcher:slic3r -- --help`
- Run the Rust-backed config persistence slice:
  - `bazel run //packages/launcher:slic3r -- --save cfg.ini`
  - `bazel run //packages/launcher:slic3r -- --load cfg.ini`
- Run the package verification suite:
  - `//packages/slic3r-rust:verify`
- Run write-mode formatting with the pinned Rust toolchain:
  - `bazel run @rules_rust//:rustfmt`

## Notes

- The current supported Rust-backed CLI workflows are `--version`, `--help`,
  `--save`, `--load`, and `--datadir`.
- The package follows the Bright Builds coding and architecture requirements for Rust work.
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion).
