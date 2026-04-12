# Windows Launcher Slice

This document defines the first scoped Windows runtime surface for the Rust
port.

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

## Scope Boundary

- The Windows launcher slice is intentionally bounded to the already verified
  help/version/config/export/transform runtime surface.
- The preferred Windows runtime path is a direct Rust console entrypoint
  exposed through `packages/launcher`, not a PowerShell bootstrap or packaged
  wrapper executable.
- This phase does not claim parity for packaged `Slic3r.exe`,
  `Slic3r-console.exe`, bundled DLL layout, archive naming, or installer
  behavior.
- Shared Windows parity evidence and published Windows validation status remain
  later work in Phases 25 and 26.

## Relationship To Legacy Windows Packaging

- The retained Windows wrapper and packaging sources still document packaged
  executable names, argument forwarding expectations, and archive layout.
- Phase 24 only establishes the bounded runtime handoff for the already
  verified Rust-backed slice.
- Windows packaging-visible parity remains deferred even though the runtime
  target now exists.

## Verification Status

- Phase 24 adds the preferred Windows runtime target and the repo-native smoke
  surface for that target.
- Phase 25 adds shared Windows parity evidence through
  `bazel run //packages/parity:windows_runtime_parity`.
- Phase 26 will publish Windows validation state through the parity status and
  migration documentation surfaces.
