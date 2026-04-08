---
phase: 02-legacy-oracle
plan: "02"
subsystem: legacy-oracle
tags: [legacy-oracle, smoke-test, bazel, macos, deferred-test-surface]
requires:
  - phase: 02-01
    provides: Bazel-visible legacy oracle build path and prerequisite gate
provides:
  - Trusted macOS oracle smoke target through Bazel
  - Stable Bazel labels for legacy smoke and broader legacy test wrappers
  - Explicit distinction between trusted oracle checks and deferred retained test surfaces
affects: [02-03, 04-contract-inventory, 07-parity-visibility]
tech-stack:
  added: [absolute xs blib loading in wrappers, xspp include-block compatibility normalization]
  patterns: [smoke-first trusted oracle set, broader legacy tests documented as deferred when still unstable]
key-files:
  created: []
  modified:
    [
      tools/bazel/legacy/build_legacy_oracle.sh,
      tools/bazel/legacy/test_legacy_smoke.sh,
      tools/bazel/legacy/test_legacy_oracle.sh,
      packages/legacy-slic3r/xs/xsp/SupportMaterial.xsp,
      packages/legacy-slic3r/xs/xsp/GUI_3DScene.xsp,
    ]
key-decisions:
  - "Treat `//:legacy_oracle_smoke` as the trusted macOS oracle set for Phase 2."
  - "Keep `//:legacy_oracle_test` present but explicitly deferred until the retained XS loader issues are resolved."
patterns-established:
  - "Trusted oracle coverage may be narrower than the full retained historical test tree when that improves reliability and clarity."
  - "Docs and later planning must distinguish working oracle checks from merely exposed legacy wrapper paths."
requirements-completed: [MONO-03, LEGA-02]
duration: 1 session
completed: 2026-04-07
---

# Phase 02: Legacy Oracle Summary

**Trusted macOS legacy oracle smoke path established through Bazel, with broader retained tests explicitly deferred**

## Performance

- **Duration:** 1 session
- **Tasks:** 2 plus wrapper and XS-generation blocker fixes
- **Files modified:** legacy oracle wrapper/test scripts and minimal retained XS++ compatibility files

## Accomplishments

- Verified that `//:legacy_oracle_build` can drive the retained legacy XS build path on this macOS machine through Bazel
- Fixed the oracle smoke wrapper so it loads the built XS bundle through absolute `xs/blib` paths
- Normalized two retained XS++ files so the generated XS C source is no longer empty
- Established `//:legacy_oracle_smoke` as the trusted macOS oracle surface for Phase 2
- Kept `//:legacy_oracle_test` exposed as a stable Bazel label, but confirmed it is not yet part of the trusted oracle set

## Task Commits

Each task was completed or unblocked with atomic commits:

1. **Task 1: Implement trusted legacy oracle smoke and test wrappers** - `b4a6d9465` (`test`)
2. **Blocker fixes: stabilize the smoke path and XS generation** - `3ee980a52` (`fix`)

**Plan metadata:** pending

## Files Created/Modified

- `tools/bazel/legacy/test_legacy_smoke.sh` - trusted smoke wrapper using absolute local-lib and `xs/blib` paths
- `tools/bazel/legacy/test_legacy_oracle.sh` - retained broader test wrapper using absolute local-lib and `xs/blib` paths
- `tools/bazel/legacy/build_legacy_oracle.sh` - wrapper cleanup to regenerate XS intermediates reliably during oracle runs
- `packages/legacy-slic3r/xs/xsp/SupportMaterial.xsp`
- `packages/legacy-slic3r/xs/xsp/GUI_3DScene.xsp` - retained XS++ include-block compatibility fixes needed for generated XS C output

## Decisions Made

- The trusted macOS oracle set for this phase is currently the smoke path, not the broader retained Perl test path
- The broader `legacy_oracle_test` wrapper remains valuable as an exposed label, but it should be documented as deferred until the retained XS loader issue is solved

## Deviations from Plan

- Phase 2 required a small amount of retained XS++ compatibility normalization so the smoke path could work on a modern macOS toolchain
- The broader retained Perl test surface did not become trustworthy in this phase; instead of overfitting more legacy fixes immediately, the plan now treats it as a deferred oracle surface

## Issues Encountered

- The retained XS++ generation path needed explicit compatibility fixes before it would emit a real `XS.c`
- The retained broad Perl test surface still fails through `//:legacy_oracle_test` because the built XS bundle is not yet loading cleanly for those tests
- This means Phase 2’s trusted oracle set is intentionally narrower than the full retained test tree

## User Setup Required

- None beyond the documented macOS prerequisite set already surfaced by the legacy oracle wrappers

---

*Plan: 02-02*
*Summary created: 2026-04-07*
