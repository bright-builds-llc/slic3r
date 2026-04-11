# Packaged Launcher Slice

This document defines the first scoped macOS packaging-visible launcher surface
for the Rust port.

## Supported Now

- Build the scoped macOS packaged launcher bundle:
  - `bazel run //packages/launcher:macos_packaged_launcher_bundle`
- Verify the packaged startup path:
  - `bazel test //packages/launcher:macos_packaged_launcher_smoke`
- Verify the packaged launcher slice through shared parity evidence:
  - `bazel run //packages/parity:macos_packaged_launcher_parity`
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
- Shared packaged parity evidence currently proves bundle layout, startup
  handoff, packaged `--help`, packaged `--version`, and one representative
  packaged config persistence flow through `--save`, `--load`, and `--datadir`.
- Scoped export and transform/info behavior remains verified at the bundled CLI
  layer, but this packaged-evidence surface does not claim separate fixture
  proof for every packaged subflow yet.
- Signing, notarization, DMG generation, and broader packaged feature parity
  remain later work.

## Verification Status

- Phase 18 makes the scoped macOS packaged launcher bundle available.
- Phase 19 verifies the bundle layout and packaged startup behavior through
  `bazel run //packages/parity:macos_packaged_launcher_parity`.
- Phase 20 extends that shared packaging parity command to verify representative
  packaged config persistence through the startup shim.
