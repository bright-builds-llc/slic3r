# Packaged Launcher Slice

This document defines the first scoped macOS packaging-visible launcher surface
for the Rust port.

## Supported Now

- Build the scoped macOS packaged launcher bundle:
  - `bazel run //packages/launcher:macos_packaged_launcher_bundle`
- Verify the packaged startup path:
  - `bazel test //packages/launcher:macos_packaged_launcher_smoke`
- Bundle output:
  - `.planning/.tmp/macos-packaged-launcher/Slic3r.app`

## Bundle Layout

- `Contents/MacOS/Slic3r`
  - thin packaged startup shim that execs the bundled Rust CLI
- `Contents/MacOS/slic3r_cli`
  - bundled Rust CLI binary for the currently verified slice
- `Contents/Resources/Slic3r.icns`
  - bundle icon reused from the retained macOS package surface
- `Contents/Resources/packaged-slice.txt`
  - scoped packaged-launcher notes for maintainers
- `Contents/Info.plist`
  - scoped bundle metadata for the packaged launcher slice
- `Contents/PkgInfo`
  - minimal app-bundle package marker

## Scope

- The packaged launcher slice is intentionally bounded to the already verified
  macOS CLI/export/transform surface.
- The startup shim is packaging-visible only; it does not own business logic.
- Signing, notarization, DMG generation, and broader packaged feature parity
  remain later work.
