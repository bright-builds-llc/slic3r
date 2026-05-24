---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 31-2026-05-24T13-42-03
generated_at: 2026-05-24T13:42:03Z
---

# Phase 31: Cross-Platform Release Build Workflow - Context

**Gathered:** 2026-05-24
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Create a GitHub Actions workflow that builds base Slic3r release build
artifacts for macOS, Linux, and Windows from the existing Rust/Bazel package
and parity surfaces. This phase should turn the scoped packaged launcher trees
into downloadable CI artifacts with provenance, not introduce installer-grade
packaging, signing, notarization, AppImage, MSI, DMG, GUI packaging,
release-channel publishing, fork-flavor builds, native/cross-compiled release
binaries, or new CLI behavior.

</domain>

<decisions>
## Implementation Decisions

### Artifact Shape

- **D-01:** Treat GitHub Actions uploaded artifacts as the release build
  surface for v1.8. The uploaded payload may contain archive files and
  manifests, but it is not a release-channel publication.
- **D-02:** Reuse the existing scoped packaged launcher builders:
  `//packages/launcher:macos_packaged_launcher_bundle`,
  `//packages/launcher:linux_packaged_launcher_tree`, and
  `//packages/launcher:windows_packaged_launcher_tree`.
- **D-03:** Keep artifacts scoped to the base Slic3r package and the already
  verified help/version/config/export/transform slice.
- **D-04:** Include release provenance beside the package tree before upload,
  including platform, commit, ref, build mode, package scope, package target,
  evidence target, and explicit out-of-scope distribution surfaces.

### Evidence Reuse

- **D-05:** The workflow must run the matching packaged launcher parity target
  for each platform before uploading artifacts:
  `//packages/parity:macos_packaged_launcher_parity`,
  `//packages/parity:linux_packaged_launcher_parity`, and
  `//packages/parity:windows_packaged_launcher_parity`.
- **D-06:** Do not add a second release-only test path that duplicates or
  weakens the existing parity evidence. CI release builds should depend on the
  verified package/evidence labels.

### GitHub Actions Boundary

- **D-07:** Use a matrix workflow over `macos-latest`, `ubuntu-latest`, and
  `windows-latest` with Bash as the step shell so one repo-owned script owns
  the release artifact logic.
- **D-08:** Keep third-party workflow dependencies minimal: checkout,
  Bazelisk setup, and artifact upload only.
- **D-09:** Trigger release artifacts manually and on version tags. Do not
  publish GitHub Releases automatically in this phase.

### Documentation Scope

- **D-10:** Add a focused release-build automation doc and link it from the
  port docs index and package map.
- **D-11:** Update launcher/package docs to distinguish release build
  artifacts from installers, signing, notarization, AppImage, MSI, DMG, GUI
  packaging, and release channels.

### the agent's Discretion

- Prefer a small repo-owned shell script over embedding long release logic in
  YAML.
- Keep generated artifacts under `.planning/.tmp/` locally.
- Use `--compilation_mode=opt` for the release build script while preserving
  the existing Bazel package targets.
- Use exact existing Bazel labels in workflow, scripts, and docs.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 31 goal and success criteria.
- `.planning/REQUIREMENTS.md` - `REL-03`, `REL-04`, `REL-05`, and `REL-06`.
- `.planning/STATE.md` - active v1.8 milestone state.
- `.planning/milestones/v1.7-phases/30-packaging-visibility-and-docs/30-VERIFICATION.md`
  - confirms the packaged launcher evidence this phase must reuse.

### Package and Evidence Targets

- `packages/launcher/BUILD.bazel` - existing macOS, Linux, and Windows package
  builder labels.
- `packages/parity/BUILD.bazel` - existing macOS, Linux, and Windows packaged
  launcher parity labels.
- `packages/launcher/package/osx/build_bundle.sh` - macOS bundle builder.
- `packages/launcher/package/linux/build_packaged_launcher.sh` - Linux package
  tree builder.
- `packages/launcher/package/win/build_packaged_launcher.sh` - Windows package
  tree builder.
- `packages/parity/compare_packaged_launcher.sh` - shared Linux/Windows
  packaged launcher evidence comparator.

### Documentation

- `docs/port/README.md` - port docs index.
- `docs/port/package-map.md` - package ownership and root-owned automation
  surfaces.
- `docs/port/migration-guidance.md` - scope-now-versus-deferred rules.
- `packages/launcher/README.md` - launcher package current state.

</canonical_refs>

<deferred_ideas>

- Signed or notarized artifacts.
- GitHub Release publishing.
- Installer-grade formats such as AppImage, MSI, DMG, deb, rpm, Flatpak, Snap,
  or native installers.
- GUI package behavior.
- Fork-flavor release builds.
- Native/cross-compiled release binaries beyond the current scoped package
  trees.

</deferred_ideas>
