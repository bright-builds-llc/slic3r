---
phase: 31-create-github-actions-workflows-that-create-release-builds-f
plan: "01"
subsystem: release-automation
tags:
  - github-actions
  - bazel
  - release-builds
  - packaging
requires:
  - phase: 30-packaging-visibility-and-docs
    provides: Published macOS, Linux, and Windows packaged launcher evidence.
provides:
  - GitHub Actions release artifact workflow for macOS, Linux, and Windows.
  - Repo-owned release artifact builder with provenance.
  - Release build automation docs and package-map links.
affects:
  - .github/workflows
  - tools/release
  - docs/port
  - packages/launcher
tech-stack:
  added: []
  patterns:
    - Matrix GitHub Actions workflow over hosted macOS, Linux, and Windows runners.
    - Repo-owned Bash release artifact builder reusing Bazel package and parity labels.
    - Provenance file embedded inside each scoped package tree before upload.
key-files:
  created:
    - .github/workflows/release-build-artifacts.yml
    - tools/release/build_release_artifact.sh
    - docs/port/release-build-automation.md
    - .planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-01-SUMMARY.md
  modified:
    - .gitignore
    - docs/port/README.md
    - docs/port/package-map.md
    - docs/port/migration-guidance.md
    - packages/launcher/README.md
    - .planning/PROJECT.md
    - .planning/ROADMAP.md
    - .planning/REQUIREMENTS.md
    - .planning/STATE.md
key-decisions:
  - "GitHub Actions uploaded artifacts are the v1.8 release build surface; GitHub Release publishing remains deferred."
  - "Release artifact builds run existing packaged launcher parity targets before packaging and upload."
  - "Each package tree carries release-provenance.txt with platform, commit, build mode, package scope, package target, and evidence target."
patterns-established:
  - "Release artifact automation stays in a small repo-owned Bash script, with workflow YAML limited to matrix orchestration and upload."
requirements-completed:
  - REL-03
  - REL-04
  - REL-05
  - REL-06
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 31-2026-05-24T13-42-03
generated_at: 2026-05-24T13:48:44Z
duration: 7min
completed: 2026-05-24
---

# Phase 31 Plan 01: Cross-Platform Release Build Workflow Summary

The repo now has scoped GitHub Actions release build automation for the base
Rust-backed Slic3r package across macOS, Linux, and Windows.

## Performance

- **Duration:** 7 min
- **Completed:** 2026-05-24T13:48:44Z
- **Tasks:** 4 completed
- **Files modified:** 14

## Accomplishments

- Added `.github/workflows/release-build-artifacts.yml`, a matrix workflow for
  `macos-latest`, `ubuntu-latest`, and `windows-latest`.
- Added `tools/release/build_release_artifact.sh`, which runs the matching
  packaged launcher parity target, builds the scoped package tree with Bazel
  opt mode, embeds `release-provenance.txt`, and creates an uploadable
  `.tar.gz` archive plus checksum and manifest.
- Added `docs/port/release-build-automation.md` and linked it from the port
  docs, package map, migration guidance, and launcher package docs.
- Verified the release artifact script locally for macOS, Linux, and Windows
  package-shaped outputs.
- Updated v1.8 roadmap, requirements, and state to mark Phase 31 complete.

## Task Commits

Final wrapper commit pending clean phase verification.

## Files Created/Modified

- `.github/workflows/release-build-artifacts.yml`
- `tools/release/build_release_artifact.sh`
- `docs/port/release-build-automation.md`
- `.gitignore`
- `docs/port/README.md`
- `docs/port/package-map.md`
- `docs/port/migration-guidance.md`
- `packages/launcher/README.md`
- `.planning/PROJECT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `.planning/STATE.md`
- `.planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-CONTEXT.md`
- `.planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-DISCUSSION-LOG.md`
- `.planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-RESEARCH.md`
- `.planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-01-PLAN.md`
- `.planning/phases/31-create-github-actions-workflows-that-create-release-builds-f/31-01-SUMMARY.md`

## Decisions Made

- Kept release automation scoped to uploaded workflow artifacts rather than
  GitHub Release publishing.
- Used existing packaged launcher parity labels as the release-build evidence
  gate.
- Wrote CI outputs to `release-artifacts/` to avoid hidden-path upload
  behavior while keeping local defaults under `.planning/.tmp/release-builds/`.

## Deviations from Plan

None.

## Issues Encountered

- The first workflow draft uploaded from `.planning/.tmp`; it was revised to
  use a non-hidden CI output directory before verification.

## User Setup Required

None for local checks. Maintainers can run the workflow manually from GitHub
Actions or by pushing a version tag.

## Self-Check: PASSED

- `bash -n tools/release/build_release_artifact.sh` passed.
- Workflow and docs structural assertions passed.
- `bash tools/release/build_release_artifact.sh macos .planning/.tmp/phase31-release-smoke` passed.
- `bash tools/release/build_release_artifact.sh linux .planning/.tmp/phase31-release-smoke` passed.
- `bash tools/release/build_release_artifact.sh windows .planning/.tmp/phase31-release-smoke` passed.

---

*Phase: 31-create-github-actions-workflows-that-create-release-builds-f*
*Completed: 2026-05-24*
