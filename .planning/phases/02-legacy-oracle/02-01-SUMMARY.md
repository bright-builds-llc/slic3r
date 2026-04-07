---
phase: 02-legacy-oracle
plan: "01"
subsystem: legacy-oracle
tags: [legacy-oracle, bazel, macos, boost-compat, perl-bootstrap]
requires: []
provides:
  - Bazel-visible legacy oracle prerequisite and build labels
  - macOS prerequisite gate with repo-local `cpanm` fallback and modern Boost compatibility handling
  - Retained XS build path compatibility patches for modern Homebrew Boost and Asio
affects: [02-02, 02-03, 04-contract-inventory, 07-parity-visibility]
tech-stack:
  added: [repo-local bazelisk usage, repo-local cpanm bootstrap, boost compatibility shim path]
  patterns: [honest prerequisite gate, wrapper-first oracle build surface, minimal parity-preserving legacy compatibility fixes]
key-files:
  created:
    [
      tools/bazel/legacy/check_legacy_prereqs.sh,
      tools/bazel/legacy/build_legacy_oracle.sh,
      tools/bazel/legacy/BUILD.bazel,
    ]
  modified:
    [
      BUILD.bazel,
      packages/BUILD.bazel,
      packages/legacy-slic3r/BUILD.bazel,
      packages/legacy-slic3r/xs/Build.PL,
      packages/legacy-slic3r/xs/src/exprtk/exprtk.hpp,
      packages/legacy-slic3r/xs/src/libslic3r/GCodeSender.hpp,
      packages/legacy-slic3r/xs/src/libslic3r/GCodeSender.cpp,
    ]
key-decisions:
  - "Kept the oracle build wrapper rooted in the retained Perl/XS build path and made Bazel an honest wrapper around it."
  - "Treated Homebrew Boost 1.90 as a modern compatibility target and applied minimal retained-source fixes instead of declaring the machine unsupported."
patterns-established:
  - "Phase 2 oracle wrappers may use repo-local bootstrap tools under `.planning/.tmp` when machine-global tools are unavailable."
  - "Minimal legacy compatibility edits are allowed when they preserve the oracle role and unblock the retained build path on macOS."
requirements-completed: [MONO-03, LEGA-01]
duration: 1 session
completed: 2026-04-07
---

# Phase 02: Legacy Oracle Summary

**Legacy oracle build surfaced through Bazel with a prerequisite gate, retained XS build wrapper, and modern macOS compatibility fixes**

## Performance

- **Duration:** 1 session
- **Tasks:** 2 plus blocker fixes
- **Files modified:** Bazel wrappers, legacy XS compatibility files, and build-surface aliases

## Accomplishments

- Added a real prerequisite gate and build wrapper for the retained legacy oracle path under `tools/bazel/legacy/`
- Exposed stable root and package-level Bazel labels for the legacy oracle build surface
- Bootstrapped repo-local `bazelisk` and `cpanm` paths during execution when machine-global tools were unavailable
- Fixed modern Homebrew Boost and Asio compatibility issues in the retained XS build so the oracle build can progress on this macOS machine
- Produced the retained XS bundle at `packages/legacy-slic3r/xs/blib/arch/auto/Slic3r/XS/XS.bundle`

## Task Commits

Each task was committed atomically or completed through direct blocker-fix follow-ups:

1. **Task 1: Add prerequisite gate and legacy build wrapper** - `0ff9c14db` (`feat`)
2. **Task 2: Expose stable Bazel labels for the legacy build surface** - `f983a0af6` (`feat`)
3. **Blocker fixes: modern macOS oracle build compatibility** - `a3277dc63` (`fix`)

## Files Created/Modified

- `tools/bazel/legacy/check_legacy_prereqs.sh` - prerequisite gate for Perl, Xcode CLT, `cpanm`, and modern Boost handling
- `tools/bazel/legacy/build_legacy_oracle.sh` - Bazel-run wrapper for the retained Perl/XS build path
- `tools/bazel/legacy/BUILD.bazel` - Bazel wrapper targets for the legacy oracle build and tests
- `BUILD.bazel`, `packages/BUILD.bazel`, `packages/legacy-slic3r/BUILD.bazel` - stable legacy oracle labels
- `packages/legacy-slic3r/xs/Build.PL` - modern Boost compatibility guard for the retained XS build
- `packages/legacy-slic3r/xs/src/exprtk/exprtk.hpp` - Clang compatibility fix for vendored exprtk
- `packages/legacy-slic3r/xs/src/libslic3r/GCodeSender.hpp`
- `packages/legacy-slic3r/xs/src/libslic3r/GCodeSender.cpp` - Boost.Asio compatibility fixes for the retained native sender path

## Decisions Made

- Chose to preserve the retained `Build.PL` / XS path as the first-class oracle build entrypoint instead of pivoting immediately to the CMake surface
- Accepted wrapper-level and minimal retained-source compatibility fixes as in-scope because they preserve the oracle role on modern macOS rather than changing product behavior

## Deviations from Plan

- The wrapper had to absorb more compatibility work than originally planned because the retained build assumed an older Boost layout and older Asio/exprtk compatibility surface
- The execution environment required repo-local tool bootstrapping because machine-global `bazelisk` and `cpanm` were not present or writable

## Issues Encountered

- Homebrew Boost 1.90 does not ship a standalone `libboost_system`, so the prerequisite gate needed a header-only compatibility path
- The retained XS build assumed older Boost/Clang behavior in `exprtk` and `GCodeSender`, which required compatibility fixes
- The oracle smoke/test surface still needs follow-up work to load the built XS bundle and define the trusted legacy test set cleanly, which is handled in Plan `02-02`

## User Setup Required

- None beyond the documented macOS prerequisites now surfaced by the wrapper scripts

---

*Plan: 02-01*
*Summary created: 2026-04-07*
