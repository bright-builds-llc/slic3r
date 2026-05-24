---
phase: 31-create-github-actions-workflows-that-create-release-builds-f
verified: 2026-05-24T13:48:44Z
status: passed
score: 7/7 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 31-2026-05-24T13-42-03
generated_at: 2026-05-24T13:48:44Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 31: Cross-Platform Release Build Workflow Verification Report

**Phase Goal:** Maintainers can use GitHub Actions to produce release build
artifacts for the base Rust-backed Slic3r package on every supported platform.
**Verified:** 2026-05-24T13:48:44Z
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
| --- | --- | --- | --- |
| 1 | GitHub Actions can build base Slic3r release artifacts for macOS, Linux, and Windows. | VERIFIED | `.github/workflows/release-build-artifacts.yml` defines a matrix with `macos-latest`, `ubuntu-latest`, and `windows-latest`, then invokes `tools/release/build_release_artifact.sh`. |
| 2 | Release artifacts reuse existing Rust/Bazel package builders. | VERIFIED | `tools/release/build_release_artifact.sh` maps platforms to `//packages/launcher:macos_packaged_launcher_bundle`, `//packages/launcher:linux_packaged_launcher_tree`, and `//packages/launcher:windows_packaged_launcher_tree`. |
| 3 | Release builds reuse verified packaged launcher evidence. | VERIFIED | The script runs `//packages/parity:macos_packaged_launcher_parity`, `//packages/parity:linux_packaged_launcher_parity`, or `//packages/parity:windows_packaged_launcher_parity` before packaging. |
| 4 | Artifacts carry provenance. | VERIFIED | Local macOS, Linux, and Windows smoke outputs contain `release-provenance.txt` with platform, commit, ref, build mode, package scope, package target, and evidence target. |
| 5 | Workflow uploads non-hidden artifact outputs. | VERIFIED | CI output root is `release-artifacts/`, and upload-artifact paths include archives plus `release-manifest.txt`. |
| 6 | Docs describe supported outputs and exclusions. | VERIFIED | `docs/port/release-build-automation.md`, `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and `packages/launcher/README.md` all publish the scoped release-build boundary. |
| 7 | Phase 31 planning traceability is complete. | VERIFIED | `.planning/REQUIREMENTS.md` marks `REL-03` through `REL-06` complete and `.planning/ROADMAP.md` marks Phase 31 complete. |

**Score:** 7/7 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
| --- | --- | --- | --- |
| `.github/workflows/release-build-artifacts.yml` | Matrix release artifact workflow | VERIFIED | Uses macOS, Linux, and Windows hosted runners, Bazelisk, repo-owned script, and upload-artifact. |
| `tools/release/build_release_artifact.sh` | Release artifact builder | VERIFIED | Builds scoped package archives with provenance after running packaged launcher parity evidence. |
| `docs/port/release-build-automation.md` | Maintainer docs | VERIFIED | Documents workflow triggers, local command, artifact contents, provenance, evidence gates, and exclusions. |
| `.planning/ROADMAP.md` | Phase 31 completion | VERIFIED | Phase 31 is complete with one plan. |
| `.planning/REQUIREMENTS.md` | REL traceability | VERIFIED | `REL-03`, `REL-04`, `REL-05`, and `REL-06` are complete and mapped to Phase 31. |

### Requirements Coverage

| Requirement | Status | Evidence |
| --- | --- | --- |
| REL-03 | VERIFIED | GitHub Actions matrix workflow plus local script path for macOS, Linux, and Windows artifacts. |
| REL-04 | VERIFIED | `release-provenance.txt` and `release-manifest.txt` record platform, commit, build mode, package scope, package target, and evidence target. |
| REL-05 | VERIFIED | Each platform build runs the matching packaged launcher parity target before packaging. |
| REL-06 | VERIFIED | Release-build docs and package docs state supported outputs and deferred signing, notarization, installers, AppImage, MSI, DMG, GUI packaging, fork-flavor builds, and release channels. |

## Evidence

- `bash -n tools/release/build_release_artifact.sh` passed.
- Workflow structural assertion passed for all three hosted runners,
  `workflow_dispatch`, the repo-owned script, upload-artifact, and read-only
  contents permission.
- Documentation assertions passed for the new release automation doc, docs
  index, package map, and launcher package docs.
- `bash tools/release/build_release_artifact.sh macos .planning/.tmp/phase31-release-smoke` passed.
- `bash tools/release/build_release_artifact.sh linux .planning/.tmp/phase31-release-smoke` passed.
- `bash tools/release/build_release_artifact.sh windows .planning/.tmp/phase31-release-smoke` passed.
- Local archive inspection confirmed macOS archive includes
  `Slic3r.app/Contents/Resources/release-provenance.txt`; Linux and Windows
  script runs created matching archives, manifests, and provenance paths.
- `git diff --check` passed during implementation.

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
| --- | --- | --- | --- | --- |
| None | - | - | - | No workflow or docs claim signing, installers, GitHub Release publishing, or release-channel support. |

## Human Verification Required

None. The phase target is checked-in automation plus local/script evidence; the
GitHub-hosted workflow will run when triggered manually or by a version tag.

## Provenance

All formal Phase 31 artifacts use lifecycle mode `yolo` and lifecycle id
`31-2026-05-24T13-42-03`: `31-CONTEXT.md`, `31-01-PLAN.md`,
`31-01-SUMMARY.md`, and this verification report.

This verification was informed by `AGENTS.md`, `AGENTS.bright-builds.md`,
`standards-overrides.md`, and the pinned Bright Builds architecture,
code-shape, verification, testing, and shell guidance.

## Gaps

None for Phase 31. Signing, notarization, installer-grade formats, GitHub
Release publishing, GUI packaging, fork-flavor release builds, release
channels, and new CLI behavior remain outside this phase.

---

_Verified: 2026-05-24T13:48:44Z_
_Verifier: the agent (gsd-verifier)_
