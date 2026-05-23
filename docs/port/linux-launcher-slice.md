# Linux Launcher Slice

This document defines the first scoped Linux runtime surface for the Rust port.

## Supported Now

- Run the preferred Linux launcher/runtime path:
  - `bazel run //packages/launcher:linux_slic3r -- --help`
- Verify the Linux launcher/runtime smoke surface:
  - `bazel test //packages/launcher:linux_launcher_smoke`
- Build the scoped Linux packaged launcher tree:
  - `bazel run //packages/launcher:linux_packaged_launcher_tree`
- Smoke the scoped Linux packaged launcher startup path:
  - `bazel test //packages/launcher:linux_packaged_launcher_smoke`

## Runtime Shape

- `packages/launcher:linux_slic3r`
  - thin Linux startup shim that hands off directly to the Rust CLI binary
- `packages/slic3r-rust:slic3r_cli`
  - existing Rust CLI binary for the verified help/version/config/export/transform slice
- `packages/launcher:linux_packaged_launcher_tree`
  - scoped Linux package-shaped launcher tree under
    `.planning/.tmp/linux-packaged-launcher/Slic3r-linux`
  - includes `bin/slic3r`, `bin/slic3r_cli`, and
    `share/slic3r/packaged-slice.txt`

## Scope

- The Linux launcher slice is intentionally bounded to the already verified
  help/version/config/export/transform runtime surface.
- The runtime startup shim stays thin and is reused by the scoped packaged
  launcher tree.
- The packaged launcher tree is packaging-visible but not release-grade
  packaging: it does not claim AppImage, distro packaging, installer, signing,
  release-channel, or shared library bundling support.
- Shared Linux packaged parity evidence remains later work after this packaged
  launcher build/smoke surface exists.

## Verification Status

- Phase 21 adds the preferred Linux launcher/runtime path and smoke surface.
- Phase 22 adds shared Linux parity evidence through
  `bazel run //packages/parity:linux_runtime_parity`.
- Phase 27 adds the scoped Linux packaged launcher tree and Bazel smoke target.
  Shared packaged parity evidence remains later work; the existing verified
  Linux runtime evidence still covers the runtime handoff slice.
