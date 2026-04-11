# Linux Launcher Slice

This document defines the first scoped Linux runtime surface for the Rust port.

## Supported Now

- Run the preferred Linux launcher/runtime path:
  - `bazel run //packages/launcher:linux_slic3r -- --help`
- Verify the Linux launcher/runtime smoke surface:
  - `bazel test //packages/launcher:linux_launcher_smoke`

## Runtime Shape

- `packages/launcher:linux_slic3r`
  - thin Linux startup shim that hands off directly to the Rust CLI binary
- `packages/slic3r-rust:slic3r_cli`
  - existing Rust CLI binary for the verified help/version/config/export/transform slice

## Scope

- The Linux launcher slice is intentionally bounded to the already verified
  help/version/config/export/transform runtime surface.
- The startup shim is runtime-only and does not claim Linux packaging-visible
  behavior such as AppImage, distro packaging, or shared library bundling.
- Linux packaging-visible parity remains later work after the Linux runtime
  slice is verified through shared parity evidence.

## Verification Status

- Phase 21 adds the preferred Linux launcher/runtime path and smoke surface.
- Shared Linux parity evidence is still deferred to Phase 22.
