# Rust Workspace

`packages/slic3r-rust` is the new Bazel-backed Rust implementation package for the Slic3r migration.

Phase 3 establishes the workspace, toolchain, and verification surface only.
Phase 5 adds contract-oriented crate boundaries and the first launcher-facing
Rust CLI scaffold. Phase 6 makes the `--version` path the first supported
Rust-backed macOS CLI slice. Phase 9 adds the `--help` path. Broader CLI, GUI,
and output parity remain later work. Phase 10 adds the scoped config
persistence path. Phase 12 adds the scoped Rust-backed export workflows. Phase
13 adds the scoped Rust-backed transform/info workflows.

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
- Run the scoped Rust-backed export slice:
  - `bazel run //packages/launcher:slic3r -- --export-gcode model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-stl model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-obj model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-amf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-3mf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-svg model.stl`
  - `bazel run //packages/launcher:slic3r -- --sla model.stl`
  - `bazel run //packages/launcher:slic3r -- --info model.obj`
  - `bazel run //packages/launcher:slic3r -- --repair model.stl`
  - `bazel run //packages/launcher:slic3r -- --split model.stl`
- Run the package verification suite:
  - `//packages/slic3r-rust:verify`
- Run write-mode formatting with the pinned Rust toolchain:
  - `bazel run @rules_rust//:rustfmt`

## Notes

- The current supported Rust-backed CLI workflows are `--version`, `--help`,
  `--save`, `--load`, `--datadir`, the scoped export flags, and the scoped
  transform/info flags.
- Phase 12 only claims export routing, file creation, and scoped output naming.
  Phase 13 only claims transform/info routing, deterministic stdout, and
  legacy-shaped repair/split artifact naming. Geometry and output-content parity
  remain later work.
- The package follows the Bright Builds coding and architecture requirements for Rust work.
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion).
