---
phase: 27-linux-packaged-launcher-slice
generated_by: gsd-phase-researcher
lifecycle_mode: yolo
phase_lifecycle_id: 27-2026-05-23T01-40-54
generated_at: 2026-05-23T01:40:54.843Z
---

# Phase 27: Linux Packaged Launcher Slice - Research

## RESEARCH COMPLETE

## Goal

Plan a scoped Linux packaging-visible launcher artifact that builds and smokes
through Bazel while preserving the existing Rust-backed business logic
boundary.

## Relevant Existing Surfaces

- `packages/launcher:linux_slic3r` already exposes the preferred Linux runtime
  path through `packages/launcher/package/linux/startup_script.sh`.
- `packages/launcher:linux_launcher_smoke` already proves Linux runtime
  help/version/config/export/transform behavior through the startup script.
- `packages/launcher:macos_packaged_launcher_bundle` shows the repo pattern for
  a Bazel-run packaged artifact builder that writes to `.planning/.tmp`.
- `packages/launcher:macos_packaged_launcher_smoke` shows the repo pattern for
  layout and startup smoke coverage on a scoped package artifact.

## Recommended Approach

Add a Linux packaged launcher tree builder under
`packages/launcher/package/linux/`. The builder should accept the Rust
launcher, Linux startup script, scope notes, and optional output root, then
materialize:

- `Slic3r-linux/bin/slic3r` - executable startup shim
- `Slic3r-linux/bin/slic3r_cli` - bundled Rust CLI binary
- `Slic3r-linux/share/slic3r/packaged-slice.txt` - maintainer-facing scope
  notes

Expose it through a Bazel `sh_binary` target and add a `sh_test` target that
creates the tree in a temp root, verifies layout, then runs the bundled
`bin/slic3r` through representative commands.

## Constraints and Risks

- Do not add AppImage, distro package, installer, signing, notarization, or
  release-channel behavior.
- Do not add CLI parsing or config behavior to shell scripts.
- Keep smoke assertions deterministic and fixture-light; Phase 29 owns shared
  packaged parity evidence.
- The existing macOS builder writes into `.planning/.tmp`; use the same pattern
  so maintainers can inspect output after a Bazel run.

## Verification Plan

- `bazel test //packages/launcher:linux_packaged_launcher_smoke`
- `bazel run //packages/launcher:linux_packaged_launcher_tree`
- `git diff --check`
- Shell syntax check for new Linux shell scripts when available.
