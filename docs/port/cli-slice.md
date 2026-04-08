# CLI Slice

This document defines the first supported Rust-backed macOS CLI workflow.

## Supported Now

- Preferred invocation:
  - `bazel run //packages/launcher:slic3r -- --version`
  - `bazel run //packages/launcher:slic3r -- --help`
  - `bazel run //packages/launcher:slic3r -- --save cfg.ini`
  - `bazel run //packages/launcher:slic3r -- --load cfg.ini`
- Supported arguments:
  - `--version`
  - `--help`
  - `--save`
  - `--load`
  - `--datadir`
- Current owner:
  - Rust implementation under `packages/slic3r-rust/crates/slic3r_cli`

## Unsupported In This Slice

- Any argument other than `--version`
- Direct migration of broader slicing, export, transform, or packaging-visible
  launcher behavior

Unsupported behavior remains legacy-owned until later phases expand the slice.

## Verification Status

- Phase 6 makes the `--version` slice Rust-backed.
- Phase 9 makes the `--help` slice Rust-backed.
- Phase 10 makes the save/load/datadir config slice Rust-backed.
- Phase 8 verifies the slice through
  `bazel run //packages/parity:cli_version_parity`.
- Help and config fixture verification land in Phase 11.
