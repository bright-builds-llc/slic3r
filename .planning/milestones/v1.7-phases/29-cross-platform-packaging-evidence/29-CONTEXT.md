---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 29-2026-05-23T11-45-16
generated_at: 2026-05-23T11:45:16.382Z
---

# Phase 29: Cross-Platform Packaging Evidence - Context

**Gathered:** 2026-05-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Create shared checked-in evidence that verifies the scoped Linux and Windows
packaged launcher trees built in Phases 27 and 28. This phase proves layout,
startup handoff, `--help`, `--version`, and representative config behavior
through reusable parity fixtures and Bazel commands. It may reuse the existing
export and transform fixture checks where they are already part of the scoped
launcher slice, but it must not add new CLI behavior, status publication,
installer support, signing, AppImage/MSI/DMG work, GUI packaging, or release
automation.

</domain>

<decisions>
## Implementation Decisions

### Shared Evidence Shape

- Add checked-in parity fixtures for Linux and Windows packaged launcher tree
  layout and in-artifact scope notes.
- Add Bazel-runnable parity commands under `packages/parity` for the Linux and
  Windows packaged launcher trees.
- Keep the commands evidence-oriented rather than broad status updates. Phase
  30 owns publishing final validation state and wider docs visibility.

### Platform Coverage

- Linux evidence should build a temporary scoped package tree with
  `packages/launcher/package/linux/build_packaged_launcher.sh`, then verify
  `Slic3r-linux/bin/slic3r`, `Slic3r-linux/bin/slic3r_cli`, and
  `Slic3r-linux/share/slic3r/packaged-slice.txt`.
- Windows evidence should build a temporary scoped package tree with
  `packages/launcher/package/win/build_packaged_launcher.sh`, then verify
  `Slic3r-windows/Slic3r-console.exe` and
  `Slic3r-windows/share/slic3r/packaged-slice.txt`.
- Both evidence paths should execute the packaged startup command itself, not
  the raw runtime target, so startup handoff is actually covered.

### Fixture Coverage

- Reuse the existing shared `--help`, `--version`, config persistence, export,
  and transform fixtures where possible instead of creating duplicate expected
  outputs.
- Add only the missing platform-specific packaged launcher fixtures: expected
  package file lists, expected scope notes, and small README files explaining
  what each fixture bundle covers.
- Keep assertions exact for checked-in fixture content so reviewers can inspect
  what the parity command proves.

### Scope Boundaries

- Do not mark parity status rows verified in this phase unless Phase 30 scope
  is explicitly brought forward.
- Do not edit the phase summary body through `mdformat`; preserve parseable
  YAML frontmatter and the exact `requirements-completed` key.
- Do not turn the package trees into release artifacts. The evidence remains
  scoped to maintainer-inspectable launcher trees.

### the agent's Discretion

- Use one shared Bash helper or a pair of small platform scripts, whichever
  keeps the evidence easiest to review and closest to existing parity script
  patterns.
- If adding documentation, keep it narrow to command/fixture discoverability
  inside `packages/parity` and `packages/parity-fixtures`; leave broad docs and
  status visibility for Phase 30.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 29 goal, success criteria, and PKGE
  requirement mapping.
- `.planning/REQUIREMENTS.md` - PKGE-01, PKGE-02, and PKGE-03 definitions.
- `.planning/STATE.md` - current milestone state and non-goals.

### Prior Packaged Launcher Slices

- `.planning/phases/27-linux-packaged-launcher-slice/27-CONTEXT.md` - Linux
  package tree scope, deferred work, and evidence handoff to Phase 29.
- `.planning/phases/27-linux-packaged-launcher-slice/27-01-SUMMARY.md` -
  Linux package builder, smoke target, and generated artifact shape.
- `.planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md` -
  Windows package tree scope, deferred work, and evidence handoff to Phase 29.
- `.planning/phases/28-windows-packaged-launcher-slice/28-01-SUMMARY.md` -
  Windows package builder, smoke target, and generated artifact shape.
- `.planning/phases/28-windows-packaged-launcher-slice/28-VERIFICATION.md` -
  verified Windows package commands and direct startup boundary evidence.

### Launcher and Parity Surfaces

- `packages/launcher/BUILD.bazel` - Linux and Windows packaged launcher
  builder/smoke targets and raw runtime aliases.
- `packages/launcher/package/linux/build_packaged_launcher.sh` - Linux package
  tree builder used by shared evidence.
- `packages/launcher/package/linux/packaged_slice.txt` - Linux in-artifact
  scope note to fixture exactly.
- `packages/launcher/package/linux/startup_script.sh` - Linux packaged startup
  handoff that evidence must execute.
- `packages/launcher/package/win/build_packaged_launcher.sh` - Windows package
  tree builder used by shared evidence.
- `packages/launcher/package/win/packaged_slice.txt` - Windows in-artifact
  scope note to fixture exactly.
- `packages/parity/BUILD.bazel` - existing parity command patterns.
- `packages/parity/compare_linux_runtime.sh` - Linux runtime fixture comparison
  pattern for help/version/config/export/transform.
- `packages/parity/compare_windows_runtime.sh` - Windows runtime fixture
  comparison pattern for help/version/config/export/transform.
- `packages/parity/compare_macos_packaged_launcher.sh` - packaged launcher
  layout and config fixture comparison pattern.
- `packages/parity-fixtures/BUILD.bazel` - fixture exports and filegroups.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/launcher/package/linux/build_packaged_launcher.sh` and
  `packages/launcher/package/win/build_packaged_launcher.sh` already create
  temporary package trees from Bazel-provided runtime inputs.
- `packages/parity/compare_linux_runtime.sh` and
  `packages/parity/compare_windows_runtime.sh` already compare the verified
  help/version/config/export/transform fixtures for the raw platform runtime
  paths.
- `packages/parity/compare_macos_packaged_launcher.sh` already compares a
  packaged layout and packaged config behavior against checked-in fixtures.

### Established Patterns

- Bazel `sh_binary` targets in `packages/parity/BUILD.bazel` expose
  maintainer-runnable parity commands.
- Fixture bundles in `packages/parity-fixtures/BUILD.bazel` gather README
  files plus expected output files for reviewable evidence.
- Shell parity scripts use `set -euo pipefail`, `resolve_input`, temp roots,
  exact fixture comparison, and high-signal mismatch output.

### Integration Points

- New parity commands belong in `packages/parity/BUILD.bazel`.
- New packaged launcher fixtures belong under
  `packages/parity-fixtures/linux-packaged-launcher/` and
  `packages/parity-fixtures/windows-packaged-launcher/`.
- Phase artifacts belong under
  `.planning/phases/29-cross-platform-packaging-evidence/`.

</code_context>

<specifics>
## Specific Ideas

- Prefer command names such as `linux_packaged_launcher_parity` and
  `windows_packaged_launcher_parity` to mirror the existing runtime and macOS
  packaged parity command naming.
- Keep expected file-list fixtures platform-specific because the package tree
  shapes intentionally differ.
- Reuse existing shared config, export, and transform fixtures so Phase 29
  proves cross-platform packaged startup through the same behavior evidence as
  earlier runtime paths.

</specifics>

<deferred>
## Deferred Ideas

- Parity status publication and broad docs updates remain Phase 30 scope.
- AppImage, MSI, DMG, installer, signing, GUI packaging, native Windows
  release output, cross-compiled release output, and release-channel
  automation remain future work.

</deferred>

---

*Phase: 29-cross-platform-packaging-evidence*
*Context gathered: 2026-05-23*
