# Phase 28: Windows Packaged Launcher Slice - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-05-23
**Phase:** 28-Windows Packaged Launcher Slice
**Mode:** Yolo
**Areas discussed:** Packaged Artifact Shape, Startup and Business Logic
Boundary, Smoke Coverage, Scope and Naming

---

## Packaged Artifact Shape

| Option | Description | Selected |
| --- | --- | --- |
| Scoped package-shaped tree | Build a deterministic `Slic3r-windows` tree under `.planning/.tmp` with executable and notes. | yes |
| Release archive or installer | Produce zip/MSI/release-grade packaging now. | |
| Runtime target only | Keep only `//packages/launcher:windows_slic3r` and skip packaged layout. | |

**User's choice:** Scoped package-shaped tree.
**Notes:** Selected automatically in yolo mode because it matches Phase 28
requirements while preserving installer and release-channel non-goals.

---

## Startup and Business Logic Boundary

| Option | Description | Selected |
| --- | --- | --- |
| Direct Rust console executable | Use the existing Windows runtime target as the packaged startup path. | yes |
| Shell or PowerShell wrapper | Add a platform script that forwards to the Rust binary. | |
| Legacy Perl/PAR wrapper | Recreate the legacy Windows package bootstrap. | |

**User's choice:** Direct Rust console executable.
**Notes:** Selected automatically in yolo mode because Phase 24 already made
the Windows runtime path a direct Rust console entrypoint and Phase 28 must not
depend on Linux or macOS launcher shims.

---

## Smoke Coverage

| Option | Description | Selected |
| --- | --- | --- |
| Bazel packaged smoke | Verify layout plus help/version/config/export/transform flows through the packaged executable. | yes |
| Manual spot check | Build the tree and inspect/run it manually. | |
| Defer all package smoke | Leave behavior proof to Phase 29 shared evidence only. | |

**User's choice:** Bazel packaged smoke.
**Notes:** Selected automatically in yolo mode because WPKG-02 requires Bazel
smoke coverage without ad hoc setup. Shared cross-platform parity remains Phase
29 scope.

---

## Scope and Naming

| Option | Description | Selected |
| --- | --- | --- |
| Windows-facing console naming with strict scope notes | Reference `Slic3r-console.exe` naming and document installer/signing/release non-goals. | yes |
| Full legacy executable set | Include GUI/debug executables and bundled runtime layout. | |
| Generic Unix-style naming | Reuse Linux-style names such as `slic3r_cli` only. | |

**User's choice:** Windows-facing console naming with strict scope notes.
**Notes:** Selected automatically in yolo mode because legacy Windows sources
define visible executable names, but this phase should not imply GUI,
installer, or release-grade packaging support.

## the agent's Discretion

- Keep the tree layout minimal and easy to verify.
- Keep documentation precise if host-built Bazel artifacts are used for smoke
  coverage.

## Deferred Ideas

- MSI, zip release archives, signing, release-channel automation, GUI
  packaging behavior, and broad bundled dependency layout.
- Shared Windows packaged parity evidence for Phase 29.
- Cross-platform packaging validation status and broader docs for Phase 30.
