# CLI Slice

This document defines the first supported Rust-backed macOS CLI workflow.

## Supported Now

- Preferred invocation:
  - `bazel run //packages/launcher:slic3r -- --version`
  - `bazel run //packages/launcher:slic3r -- --help`
  - `bazel run //packages/launcher:slic3r -- --save cfg.ini`
  - `bazel run //packages/launcher:slic3r -- --load cfg.ini`
  - `bazel run //packages/launcher:slic3r -- --export-gcode model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-stl model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-obj model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-amf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-3mf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-svg model.stl`
  - `bazel run //packages/launcher:slic3r -- --sla model.stl`
- Supported arguments:
  - `--version`
  - `--help`
  - `--save`
  - `--load`
  - `--datadir`
  - `--export-gcode`
  - `-g`
  - `--export-stl`
  - `--export-obj`
  - `--export-amf`
  - `--export-3mf`
  - `--export-svg`
  - `--export-sla-svg`
  - `--sla`
  - `--output`
- Current owner:
  - Rust implementation under `packages/slic3r-rust/crates/slic3r_cli`

## Export Scope

- The supported export slice is intentionally bounded to a single input model.
- Default output naming follows the input stem:
  - `box.stl` -> `box.gcode`
  - `box.stl` -> `box.stl`
  - `box.stl` -> `box.obj`
  - `box.stl` -> `box.amf`
  - `box.stl` -> `box.3mf`
  - `box.stl` -> `box.svg`
  - `box.stl` -> `box_0.svg` through `box_4.svg` for layered SVG export
- The scoped explicit `--output <file>` path is preserved for supported
  single-file exports and used as the base name for layered SVG export.
- Phase 12 only claims Rust-backed export routing, file creation, and output
  naming. Output-content parity remains later work.

## Unsupported In This Slice

- Any argument outside the supported set above
- Multi-input export orchestration and merge-driven export flows
- Direct migration of transform, merge/cut/layout, or packaging-visible launcher
  behavior
- Output-filename-format semantics and full output-content parity

Unsupported behavior remains legacy-owned until later phases expand the slice.

## Verification Status

- Phase 6 makes the `--version` slice Rust-backed.
- Phase 9 makes the `--help` slice Rust-backed.
- Phase 10 makes the save/load/datadir config slice Rust-backed.
- Phase 12 makes the scoped export slice Rust-backed.
- Phase 8 verifies the slice through
  `bazel run //packages/parity:cli_version_parity`.
- Phase 11 verifies help through `bazel run //packages/parity:cli_help_parity`.
- Phase 11 verifies scoped config persistence through
  `bazel run //packages/parity:cli_config_persistence_parity`.
- Phase 14 is responsible for fixture-verifying the supported export slice.
