---
phase: 28-windows-packaged-launcher-slice
plan: "01"
subsystem: packaging
tags:
  - bazel
  - windows
  - launcher
  - packaging
requires:
  - phase: 26-windows-parity-visibility
    provides: Verified Windows runtime target and published validation state.
  - phase: 27-linux-packaged-launcher-slice
    provides: Scoped packaged launcher tree builder and smoke pattern.
provides:
  - Scoped Windows packaged launcher tree builder.
  - Bazel smoke coverage for the packaged Windows console startup path.
  - In-artifact scope notes distinguishing the launcher tree from installer and release-channel support.
affects:
  - packages/launcher
  - packages/slic3r-rust
  - docs/port
tech-stack:
  added: []
  patterns:
    - Bazel sh_binary package tree builder writing to .planning/.tmp.
    - Bazel sh_test packaged startup smoke using a temporary artifact root.
key-files:
  created:
    - packages/launcher/package/win/build_packaged_launcher.sh
    - packages/launcher/package/win/packaged_slice.txt
    - packages/launcher/package/win/test_packaged_launcher.sh
  modified:
    - packages/launcher/BUILD.bazel
key-decisions:
  - "Windows packaged artifact is a scoped maintainer-inspectable tree, not MSI, zip release, installer, signed artifact, or release-channel build."
  - "The packaged startup path executes the copied Rust console runtime directly as Slic3r-console.exe."
  - "Shared cross-platform packaged parity evidence remains deferred to Phase 29."
patterns-established:
  - "Scoped packaged launcher tree: Slic3r-console.exe and share/slic3r/packaged-slice.txt."
  - "Package smoke target verifies layout and representative startup behavior through the packaged executable."
requirements-completed:
  - WPKG-01
  - WPKG-02
  - WPKG-03
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 28-2026-05-23T02-35-56
generated_at: 2026-05-23T03:03:33Z
duration: 12min
completed: 2026-05-23
---

# Phase 28 Plan 01: Windows Packaged Launcher Tree Summary

**Scoped Windows package tree with direct `Slic3r-console.exe` startup and Bazel smoke coverage**

## Performance

- **Duration:** 12 min
- **Started:** 2026-05-23T02:51:00Z
- **Completed:** 2026-05-23T03:03:33Z
- **Tasks:** 3 completed
- **Files modified:** 4

## Accomplishments

- Added `//packages/launcher:windows_packaged_launcher_tree`, which
  materializes `.planning/.tmp/windows-packaged-launcher/Slic3r-windows`.
- Added `//packages/launcher:windows_packaged_launcher_smoke`, which verifies
  the packaged tree layout and runs help/version/config/export/transform flows
  through `Slic3r-windows/Slic3r-console.exe`.
- Added `packaged-slice.txt` inside the artifact so maintainers can inspect the
  supported Windows packaged launcher scope and deferred installer/release
  surfaces.

## Task Commits

1. **Task 1: Add Windows packaged tree builder and scope note** - `61c455b5d`
2. **Task 2: Expose Windows packaged build and smoke targets in Bazel** - `866399149`
3. **Task 3: Add Windows packaged startup smoke coverage** - `0e6ec324c`

## Files Created/Modified

- `packages/launcher/package/win/build_packaged_launcher.sh` - builds the
  scoped Windows package-shaped tree.
- `packages/launcher/package/win/packaged_slice.txt` - records supported and
  deferred scope inside the artifact.
- `packages/launcher/package/win/test_packaged_launcher.sh` - smokes package
  layout and startup behavior through `Slic3r-console.exe`.
- `packages/launcher/BUILD.bazel` - exposes the build and smoke targets.

## Decisions Made

- The Windows packaged artifact is a deterministic tree under `.planning/.tmp`,
  matching the Linux package-tree pattern without creating an MSI, release zip,
  installer, signing flow, GUI package, or release-channel artifact.
- The Windows package startup surface is the copied Rust console runtime named
  `Slic3r-console.exe`; no Linux/macOS shell shim or PowerShell/PAR bundle is
  introduced.
- The smoke target covers representative existing slice behavior, while shared
  cross-platform packaged parity remains Phase 29 scope.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Marked launcher scripts executable**
- **Found during:** Task 3 (Add Windows packaged startup smoke coverage)
- **Issue:** Bazel rejected `sh_binary` and `sh_test` targets because the new
  Bash scripts were not executable.
- **Fix:** Marked `build_packaged_launcher.sh` and
  `test_packaged_launcher.sh` executable.
- **Files modified:** `packages/launcher/package/win/build_packaged_launcher.sh`,
  `packages/launcher/package/win/test_packaged_launcher.sh`
- **Verification:** `bazel test //packages/launcher:windows_packaged_launcher_smoke`
  and `bazel run //packages/launcher:windows_packaged_launcher_tree` both pass.
- **Committed in:** `0e6ec324c`

---

**Total deviations:** 1 auto-fixed (Rule 3 - Blocking)
**Impact on plan:** Required for Bazel shell targets; no scope change.

## Issues Encountered

None beyond the auto-fixed executable-bit issue documented above.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 28-02 can update the Rust help text, help test, and help fixture to name
the scoped Windows packaged launcher tree without expanding CLI behavior.

---

*Phase: 28-windows-packaged-launcher-slice*
*Completed: 2026-05-23*
