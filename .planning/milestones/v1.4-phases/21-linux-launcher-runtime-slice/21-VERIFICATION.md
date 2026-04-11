---
phase: 21-linux-launcher-runtime-slice
verified: 2026-04-11T19:05:00Z
status: passed
score: 3/3 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 21-2026-04-11T19-05-00
generated_at: 2026-04-11T19:05:00Z
lifecycle_validated: true
---

# Phase 21: Linux Launcher Runtime Slice Verification Report

**Phase Goal:** Deliver the preferred Rust-backed Linux launcher/runtime path
for the already verified help/version/config/export/transform slice.
**Verified:** 2026-04-11T19:05:00Z
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
| --- | --- | --- | --- |
| 1 | User can run the preferred Rust-backed Linux launcher path for `--help` and `--version`. | ✓ VERIFIED | `bazel run //packages/launcher:linux_slic3r -- --help` and `--version` both pass through the new Linux runtime shim. |
| 2 | User can run the currently verified config persistence, export, and non-slicing transform workflows through the preferred Rust-backed Linux launcher path. | ✓ VERIFIED | `linux_launcher_smoke` exercises representative `--save`, `--load`, `--export-gcode`, `--info`, `--repair`, and `--split` flows through the Linux shim. |
| 3 | Maintainer can build and invoke the Linux Rust-backed runtime path from Bazel without relying on macOS-specific packaging surfaces. | ✓ VERIFIED | `bazel build //packages/launcher:linux_slic3r //packages/launcher:linux_launcher_smoke` passes and the runtime surface lives under `packages/launcher/package/linux` instead of the macOS packaged bundle path. |

## Evidence

- `shfmt -l -d packages/launcher/package/linux/startup_script.sh packages/launcher/package/linux/test_linux_launcher.sh` passed
- `mdformat --check docs/port/linux-launcher-slice.md docs/port/entrypoint-architecture.md docs/port/package-map.md docs/port/parity-matrix.md docs/port/README.md packages/launcher/README.md docs/port/contract-inventory.md` passed
- `cargo +1.94.1 fmt --all --check` passed
- `cargo +1.94.1 clippy --all-targets --all-features -- -D warnings` passed
- `cargo +1.94.1 build --all-targets --all-features` passed
- `cargo +1.94.1 test --all-features` passed
- `./.planning/.tmp/bin/bazelisk build //packages/launcher:linux_slic3r //packages/launcher:linux_launcher_smoke //packages/slic3r-rust/...` passed
- `./.planning/.tmp/bin/bazelisk test //packages/launcher:linux_launcher_smoke //packages/slic3r-rust:verify` passed
- `./.planning/.tmp/bin/bazelisk run //packages/launcher:linux_slic3r -- --help` passed
- `./.planning/.tmp/bin/bazelisk run //packages/launcher:linux_slic3r -- --version` passed

## Gaps

None.
