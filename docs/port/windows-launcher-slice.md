# Windows Launcher Slice

This document defines the scoped Windows runtime and package-shaped launcher
surfaces for the Rust port.

## Supported Now

- Run the preferred Windows runtime path:
  - `bazel run //packages/launcher:windows_slic3r -- --help`
  - `bazel run //packages/launcher:windows_slic3r -- --version`
  - `bazel run //packages/launcher:windows_slic3r -- --save cfg.ini`
  - `bazel run //packages/launcher:windows_slic3r -- --load cfg.ini`
  - `bazel run //packages/launcher:windows_slic3r -- --export-gcode model.stl`
  - `bazel run //packages/launcher:windows_slic3r -- --info model.stl`
  - `bazel run //packages/launcher:windows_slic3r -- --repair model.stl`
  - `bazel run //packages/launcher:windows_slic3r -- --split model.stl`
- Verify the Windows launcher/runtime smoke surface:
  - `bazel test //packages/launcher:windows_launcher_smoke`
- Build the bounded Windows runtime target:
  - `bazel build //packages/launcher:windows_slic3r`
- Build the scoped Windows packaged launcher tree:
  - `bazel run //packages/launcher:windows_packaged_launcher_tree`
- Smoke the scoped Windows packaged launcher startup path:
  - `bazel test //packages/launcher:windows_packaged_launcher_smoke`

## Scope Boundary

- The Windows launcher slice is intentionally bounded to the already verified
  help/version/config/export/transform runtime surface.
- The preferred Windows runtime path is a direct Rust console entrypoint
  exposed through `packages/launcher`, not a PowerShell bootstrap or packaged
  wrapper executable.
- The scoped packaged launcher tree is
  `.planning/.tmp/windows-packaged-launcher/Slic3r-windows`. Its startup
  executable is `Slic3r-windows/Slic3r-console.exe`, a direct copy of the Rust
  console runtime for the verified slice.
- This phase does not claim parity for packaged `Slic3r.exe` GUI behavior,
  MSI, signing, release-channel automation, release archives, broad bundled
  DLL layout, native Windows installer output, or installer behavior.
- Shared Windows parity evidence now exists for the bounded runtime slice, and
  the published Windows validation state now flows through the parity status
  surface. Shared cross-platform packaged parity evidence remains later work.

## Relationship To Legacy Windows Packaging

- The retained Windows wrapper and packaging sources still document packaged
  executable names, argument forwarding expectations, and archive layout.
- Phase 24 only establishes the bounded runtime handoff for the already
  verified Rust-backed slice.
- Phase 28 adds a scoped package-shaped `Slic3r-console.exe` tree for the same
  verified slice. The broader legacy Windows package remains the reference for
  future GUI, installer, archive, and bundled dependency layout work.

## Verification Status

- Phase 24 adds the preferred Windows runtime target and the repo-native smoke
  surface for that target.
- Phase 25 adds shared Windows parity evidence through
  `bazel run //packages/parity:windows_runtime_parity`.
- Phase 26 publishes Windows validation state through
  `bazel run //packages/parity:status`, `packages/parity/status.tsv`, and the
  migration documentation surfaces.
- Phase 28 adds the scoped Windows packaged launcher build and smoke targets.
  Shared cross-platform packaged parity evidence remains Phase 29 scope.
