# CLI Slice

This document defines the first supported Rust-backed macOS CLI workflow.

## Supported Now

- Preferred invocation:
  - `bazel run //packages/launcher:slic3r -- --version`
- Supported arguments:
  - `--version`
- Current owner:
  - Rust implementation under `packages/slic3r-rust/crates/slic3r_cli`

## Unsupported In This Slice

- Any argument other than `--version`
- Direct migration of broader CLI, config, slicing, export, or launcher behavior

Unsupported behavior remains legacy-owned until later phases expand the slice.

## Verification Status

- Phase 6 makes the `--version` slice Rust-backed.
- Phase 8 adds shared-fixture comparison so this slice can move from
  implementation-only to verified parity.
