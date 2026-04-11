# Entrypoint Architecture

This document defines the ownership boundaries for the first non-legacy CLI
slice.

## Responsibilities

| Surface | Owner | Responsibility |
| --- | --- | --- |
| Bazel entrypoints | `packages/BUILD.bazel`, `packages/launcher/BUILD.bazel` | Expose the preferred runnable targets without owning business logic |
| Stable launcher contracts | `packages/slic3r-rust/crates/slic3r_contracts` | Parse and model the supported CLI slice in pure Rust types |
| Launcher-facing CLI shell | `packages/slic3r-rust/crates/slic3r_cli` | Translate process arguments into contract routing and user-visible exit behavior |
| Lower-level Rust implementation | `packages/slic3r-rust/crates/slic3r_core` | Hold reusable implementation details that are not themselves the stable launcher contract |
| Runtime and packaged startup shims | `packages/launcher/package/osx`, `packages/launcher/package/linux` | Stay thin and limited to runtime or packaged handoff into the Rust CLI binary; no Perl business logic moves here |
| Retained reference behavior | `packages/legacy-slic3r` | Remain the parity oracle for unsupported CLI behavior until later phases migrate it |

## Phase 5 Scope

- The Rust side now has separate crates for stable launcher contracts and the
  CLI shell.
- `packages/launcher` is no longer an empty placeholder. It is the package
  boundary that points at the Rust CLI scaffold.
- No user-facing workflow is supported through the Rust launcher yet. This phase
  only makes the architecture explicit enough for Phase 6 implementation.

## Phase 18 Packaging Slice

- `bazel run //packages/launcher:macos_packaged_launcher_bundle` now
  materializes a scoped `Slic3r.app`-style bundle under `.planning/.tmp/`.
- The packaged startup script remains a thin shell shim that execs the bundled
  Rust CLI binary from `Contents/MacOS/`.
- This packaged slice is intentionally bounded to the already verified macOS
  CLI/export/transform surface. DMG/signing/notarization parity remains later
  work.

## Phase 21 Linux Runtime Slice

- `bazel run //packages/launcher:linux_slic3r -- ...` now exposes the preferred
  Linux launcher/runtime path for the already verified Rust-backed slice.
- The Linux startup script is intentionally thinner than the retained legacy
  Linux launcher because the Rust CLI does not need the Perl or
  `LD_LIBRARY_PATH` bootstrap that the legacy package carries.
- Linux packaging-visible behavior remains deferred; this phase only establishes
  the runtime handoff boundary.
