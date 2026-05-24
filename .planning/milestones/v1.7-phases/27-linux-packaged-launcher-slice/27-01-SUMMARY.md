---
phase: 27-linux-packaged-launcher-slice
plan: "01"
subsystem: packaging
tags:
  - bazel
  - linux
  - launcher
  - packaging
requires:
  - phase: 23-linux-parity-visibility
    provides: Verified Linux runtime launcher path and shared runtime parity evidence.
provides:
  - Scoped Linux packaged launcher tree builder.
  - Bazel smoke coverage for the packaged Linux startup path.
  - Nearby docs describing the scoped Linux packaged launcher target without release-grade claims.
affects:
  - packages/launcher
  - docs/port
tech-stack:
  added: []
  patterns:
    - Bazel sh_binary packaged artifact builder writing to .planning/.tmp.
    - Bazel sh_test packaged startup smoke using a temporary artifact root.
key-files:
  created:
    - packages/launcher/package/linux/build_packaged_launcher.sh
    - packages/launcher/package/linux/packaged_slice.txt
    - packages/launcher/package/linux/test_packaged_launcher.sh
  modified:
    - packages/launcher/BUILD.bazel
    - packages/launcher/README.md
    - packages/slic3r-rust/crates/slic3r_cli/src/lib.rs
    - packages/slic3r-rust/crates/slic3r_cli/tests/version.rs
    - packages/parity-fixtures/cli-help/stdout.txt
    - docs/port/linux-launcher-slice.md
    - docs/port/contract-inventory.md
    - docs/port/entrypoint-architecture.md
    - docs/port/package-map.md
    - docs/port/parity-matrix.md
key-decisions:
  - "Linux packaged artifact is a scoped maintainer-inspectable tree, not AppImage, distro package, installer, or release artifact."
  - "The packaged startup command reuses the existing thin Linux handoff into the bundled Rust CLI."
  - "Shared Linux packaged parity evidence remains deferred to the cross-platform packaging evidence phase."
patterns-established:
  - "Scoped packaged launcher tree: bin/slic3r, bin/slic3r_cli, and share/slic3r/packaged-slice.txt."
  - "Package smoke target verifies layout and representative startup behavior through the packaged command."
requirements-completed:
  - LPKG-01
  - LPKG-02
  - LPKG-03
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 27-2026-05-23T01-40-54
generated_at: 2026-05-23T01:47:13.943Z
duration: 7min
completed: 2026-05-23
---

# Phase 27: Linux Packaged Launcher Slice Summary

The repo now has a scoped Linux packaged launcher tree that maintainers can
build and smoke through Bazel without moving CLI behavior into shell packaging
code.

## Performance

- **Duration:** 7 min
- **Started:** 2026-05-23T01:40:54.843Z
- **Completed:** 2026-05-23T01:47:13.943Z
- **Tasks:** 3 completed
- **Files modified:** 13

## Accomplishments

- Added `//packages/launcher:linux_packaged_launcher_tree`, which materializes
  `.planning/.tmp/linux-packaged-launcher/Slic3r-linux`.
- Added `//packages/launcher:linux_packaged_launcher_smoke`, which verifies the
  packaged tree layout and runs help/version/config/export/transform startup
  flows through `Slic3r-linux/bin/slic3r`.
- Updated package-local and port docs so maintainers can find the scoped Linux
  packaged launcher surface without confusing it for AppImage, distro package,
  installer, signing, GUI, or release-channel support.
- Updated the Rust help text and help fixture so packaged `--help` no longer
  says packaged launcher behavior is wholly legacy-owned.

## Task Commits

Final wrapper commit pending clean phase verification.

## Files Created/Modified

- `packages/launcher/package/linux/build_packaged_launcher.sh` - builds the
  scoped Linux package-shaped tree.
- `packages/launcher/package/linux/packaged_slice.txt` - records the supported
  and deferred scope inside the artifact.
- `packages/launcher/package/linux/test_packaged_launcher.sh` - smokes package
  layout and startup behavior through the packaged command.
- `packages/launcher/BUILD.bazel` - exposes the build and smoke targets.
- `packages/launcher/README.md` - documents the new Linux packaged launcher
  target and remaining deferred package formats.
- `packages/slic3r-rust/crates/slic3r_cli/src/lib.rs` - updates help scope
  text for scoped launcher/package paths.
- `packages/slic3r-rust/crates/slic3r_cli/tests/version.rs` - asserts the
  updated help scope and stale packaged-launcher wording removal.
- `packages/parity-fixtures/cli-help/stdout.txt` - keeps help parity fixtures
  aligned with the Rust CLI output.
- `docs/port/linux-launcher-slice.md` - adds supported build/smoke commands and
  scoped package shape.
- `docs/port/contract-inventory.md` - records scoped Linux packaged tree smoke
  coverage while keeping release-grade packaging deferred.
- `docs/port/entrypoint-architecture.md` - records the Phase 27 package-shaped
  Linux startup boundary.
- `docs/port/package-map.md` - adds the Phase 27 package ownership note.
- `docs/port/parity-matrix.md` - distinguishes build/smoke-visible Linux
  packaged behavior from later shared parity evidence.

## Decisions Made

- The Linux packaged artifact is a deterministic tree under `.planning/.tmp`,
  matching the existing macOS packaged builder pattern while avoiding
  release-grade package claims.
- The startup path stays shell-thin: it copies executable files for packaging
  and then the packaged `bin/slic3r` execs `bin/slic3r_cli`.
- The smoke target covers representative existing slice behavior, while
  cross-platform shared packaged parity remains Phase 29 scope.

## Deviations from Plan

None - plan executed as written.

## Issues Encountered

- `mdformat` was unsafe for GSD XML/frontmatter artifacts because it rewrote
  the YAML delimiters and escaped XML-style tags. The affected planning files
  were restored and verified with GSD frontmatter parsing instead.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 28 can follow the same scoped package-builder pattern for Windows while
keeping Windows installer, signing, and release-channel support deferred.

---

*Phase: 27-linux-packaged-launcher-slice*
*Completed: 2026-05-23*
