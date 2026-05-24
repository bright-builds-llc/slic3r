# Phase 31: Cross-Platform Release Build Workflow - Research

**Researched:** 2026-05-24
**Domain:** GitHub Actions release artifact automation for existing
Rust/Bazel package targets
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

- Build base Slic3r release artifacts for macOS, Linux, and Windows through
  GitHub Actions.
- Keep the output scoped to the existing Rust/Bazel packaged launcher trees.
- Include provenance with platform, commit, build mode, and supported package
  scope.
- Reuse existing packaged launcher parity evidence before artifact upload.
- Do not claim signing, notarization, installers, AppImage, MSI, DMG, GUI
  packaging, fork-flavor builds, release channels, or new CLI behavior.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
| --- | --- | --- |
| REL-03 | Maintainer can use GitHub Actions to produce base Slic3r release build artifacts for macOS, Linux, and Windows through the Rust/Bazel workflow. | Add a matrix workflow under `.github/workflows/` that invokes a repo-owned release artifact script on macOS, Linux, and Windows runners. |
| REL-04 | Release build artifacts carry enough provenance to identify platform, commit, build mode, and supported package scope. | Add provenance files to every generated package tree and upload a manifest beside archive outputs. |
| REL-05 | Release build automation reuses verified packaged launcher evidence instead of inventing parallel release logic. | Run platform-specific `//packages/parity:*_packaged_launcher_parity` targets before packaging/upload. |
| REL-06 | Docs describe supported release-build outputs and remaining exclusions. | Add focused docs and link them from existing port/package documentation. |
</phase_requirements>

## Summary

The repo already has the package and parity primitives needed for release build
automation:

- macOS package builder: `//packages/launcher:macos_packaged_launcher_bundle`
- Linux package builder: `//packages/launcher:linux_packaged_launcher_tree`
- Windows package builder: `//packages/launcher:windows_packaged_launcher_tree`
- macOS evidence: `//packages/parity:macos_packaged_launcher_parity`
- Linux evidence: `//packages/parity:linux_packaged_launcher_parity`
- Windows evidence: `//packages/parity:windows_packaged_launcher_parity`

The missing layer is orchestration and provenance. A small shell script can run
the matching parity target, materialize the package tree in a stable output
directory, write provenance into the tree, create a tar archive, and leave a
manifest for GitHub Actions to upload. The workflow should run that script in a
matrix so maintainers can inspect per-platform output without reading YAML
internals.

## Implementation Notes

- Use `--compilation_mode=opt` for the release artifact script to distinguish
  release-build automation from normal fastbuild developer loops.
- Store local outputs under `.planning/.tmp/release-builds/<platform>/`, which
  is already ignored through the repo's local exclude.
- Name uploaded artifacts with the platform and commit SHA. The artifact
  payload should include both archive and manifest/provenance files.
- Keep workflow permissions at `contents: read`; this phase uploads workflow
  artifacts and does not publish releases.
- Use manual and tag triggers: `workflow_dispatch` plus `push` tags matching
  `v*`.

## Verification Recommendations

- Run the release artifact script locally for at least the host-supported
  platform.
- Run the existing packaged launcher parity target for at least one platform.
- Parse the workflow YAML for the expected matrix platforms, evidence labels,
  and upload artifact step.
- Check that generated provenance includes platform, commit, build mode,
  package target, evidence target, and scope fields.
- Run `git diff --check`.

## Risks

- Windows GitHub-hosted runner shell behavior can differ from macOS/Linux.
  Mitigate by setting `defaults.run.shell: bash` and keeping release logic in a
  Bash script already aligned with existing package scripts.
- Adding a workflow without docs would meet automation mechanically but leave
  maintainers unclear about artifact scope. Mitigate with a focused docs page.
- Release artifacts may be mistaken for signed installers. Mitigate with
  explicit provenance and docs exclusions.
