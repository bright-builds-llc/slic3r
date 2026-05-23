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
| Windows runtime entrypoint | `packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs`, `packages/launcher/BUILD.bazel` | Expose the preferred Windows console-style runtime target for the supported slice without adding platform shell shims |
| Windows packaged launcher startup | `packages/launcher/package/win`, `packages/launcher/BUILD.bazel` | Copy the direct `Slic3r-console.exe` runtime into a scoped package tree with metadata only; no Perl, PowerShell/PAR, or shell shim business logic moves here |
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

## Phase 27 Linux Packaged Launcher Slice

- `bazel run //packages/launcher:linux_packaged_launcher_tree` now materializes
  a scoped Linux package-shaped launcher tree for the already verified
  Rust-backed slice.
- The packaged startup command reuses the thin Linux shell handoff and execs the
  bundled Rust CLI binary; no business behavior moves into packaging shell code.
- This surface is not AppImage, distro package, installer, signing, GUI, or
  release-channel support. Shared packaged parity evidence remains later work.

## Phase 24 Windows Runtime Slice

- `bazel run //packages/launcher:windows_slic3r -- ...` now exposes the
  preferred Windows runtime path for the already verified Rust-backed slice.
- The Windows runtime path is a direct Rust console entrypoint instead of a
  PowerShell or shell wrapper, so Bazel can build and invoke it without
  depending on macOS or Linux launcher shims.
- Windows packaging-visible behavior remains deferred; this phase only
  establishes the bounded runtime handoff boundary.

## Phase 28 Windows Packaged Launcher Slice

- `bazel run //packages/launcher:windows_packaged_launcher_tree` now
  materializes a scoped Windows package-shaped launcher tree under
  `.planning/.tmp/windows-packaged-launcher/Slic3r-windows`.
- `bazel test //packages/launcher:windows_packaged_launcher_smoke` executes
  `Slic3r-console.exe` directly through representative help/version/config/
  export/transform startup flows.
- This packaged startup path is a direct Rust executable handoff. It introduces
  no Linux/macOS shell shim, PowerShell/PAR bundle, MSI, signing, GUI, or
  release-channel support.
