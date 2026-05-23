---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 28-2026-05-23T02-35-56
generated_at: 2026-05-23T02:36:01.531Z
---

# Phase 28: Windows Packaged Launcher Slice - Context

**Gathered:** 2026-05-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Build the first scoped Windows packaging-visible launcher artifact for the
already verified Rust-backed help/version/config/export/transform slice. This
phase turns the existing Windows runtime target into a package-shaped startup
tree that maintainers can build and smoke through Bazel. It does not add MSI,
installer, signing, release-channel, GUI, broad DLL bundling, or new CLI
behavior.

</domain>

<decisions>
## Implementation Decisions

### Packaged Artifact Shape

- Create a checked-in Bazel-facing builder for a deterministic Windows
  packaged launcher tree under `.planning/.tmp/windows-packaged-launcher`.
- Keep the artifact scoped and package-shaped, not installer-shaped: include
  the Windows runtime executable with Windows-facing naming and a scope note
  that makes the supported slice explicit.
- Mirror the Phase 27 Linux packaged tree pattern where it helps
  maintainability, but do not add a Linux or macOS shell startup shim for
  Windows.

### Startup and Business Logic Boundary

- The Windows packaged startup path should be the direct Rust console runtime
  executable from `//packages/launcher:windows_slic3r`.
- The package builder may copy files and write scope metadata, but it must not
  parse or implement CLI business behavior.
- The Rust-backed CLI continues to own help/version/config/export/transform
  behavior through `packages/slic3r-rust` and the existing Windows runtime
  entrypoint.

### Smoke Coverage

- Add Bazel smoke coverage for the Windows packaged startup path so
  maintainers can run it without ad hoc local setup.
- The smoke test should prove artifact layout, direct executable startup
  handoff, packaged `--help`, packaged `--version`, representative config
  persistence, and representative export/transform flows through the packaged
  executable.
- Keep shared cross-platform packaged parity evidence in Phase 29; this phase
  owns the Windows build/smoke slice only.

### Scope and Naming

- Use legacy Windows packaging sources only as naming and scope references,
  especially `Slic3r-console.exe`; do not recreate the legacy Perl/PAR bundle.
- Avoid claiming `Slic3r.exe` GUI behavior, MSI support, signing,
  release-channel automation, or release-grade archives.
- Update nearby package-local docs only where needed to make the new target
  discoverable and to remove stale "Windows packaging remains deferred"
  wording for this scoped tree.

### the agent's Discretion

- Choose the simplest package tree layout that is easy to inspect and smoke
  through Bazel from the current development host.
- If host-built Bazel artifacts are used for smoke coverage, keep the docs
  precise: this proves the scoped Windows packaged launcher surface and naming
  path, not native Windows installer or cross-compiled release output.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 28 goal, success criteria, and requirement
  IDs.
- `.planning/REQUIREMENTS.md` - WPKG-01, WPKG-02, and WPKG-03 definitions.
- `.planning/STATE.md` - current milestone state and non-goals.

### Existing Launcher and Packaging Surfaces

- `packages/launcher/BUILD.bazel` - existing Linux packaged launcher, Windows
  runtime, and macOS packaged launcher Bazel target patterns.
- `packages/launcher/package/win/test_windows_launcher.sh` - existing Windows
  runtime smoke coverage for the verified slice.
- `packages/launcher/package/linux/build_packaged_launcher.sh` - package-tree
  builder pattern from the immediately preceding Linux phase.
- `packages/launcher/package/linux/test_packaged_launcher.sh` - packaged
  layout and startup smoke pattern to adapt for Windows.
- `packages/launcher/package/linux/packaged_slice.txt` - scoped artifact note
  pattern to mirror with Windows-specific wording.
- `packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs`
  - direct Rust console entrypoint for the Windows runtime path.
- `packages/launcher/README.md` - package-local ownership and discoverability
  surface.

### Legacy Windows References and Docs

- `packages/legacy-slic3r/package/win/package_win32.ps1` - legacy packaged
  executable names and bundled archive scope to reference without copying its
  Perl/PAR behavior.
- `packages/legacy-slic3r/package/common/shell.cpp` - retained Windows wrapper
  behavior that remains legacy/deferred outside the scoped Rust-backed slice.
- `docs/port/windows-launcher-slice.md` - current Windows runtime scope and
  deferred packaging language.
- `docs/port/entrypoint-architecture.md` - launcher boundary documentation.
- `docs/port/contract-inventory.md` - Windows packaging-visible contract row.
- `docs/port/package-map.md` - package ownership and phase history notes.
- `docs/port/parity-matrix.md` - current parity claims and deferred Windows
  packaging state.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `//packages/launcher:windows_slic3r`: already exposes the preferred direct
  Rust console runtime target for the verified help/version/config/export/
  transform slice.
- `packages/launcher/package/win/test_windows_launcher.sh`: already contains
  representative Windows runtime smoke assertions that can be reused through a
  packaged tree.
- `packages/launcher/package/linux/build_packaged_launcher.sh`: provides the
  current package-tree builder shape, including deterministic output under
  `.planning/.tmp`.

### Established Patterns

- Bazel `sh_binary` targets expose buildable launcher artifacts.
- Bazel `sh_test` targets use `$(location ...)` arguments, resolve runfiles or
  workspace paths, copy files into a temp root, and make assertions with
  `set -euo pipefail`.
- Package-local docs explicitly separate runtime, packaged launcher, shared
  parity evidence, and release/installer scope.

### Integration Points

- New targets belong in `packages/launcher/BUILD.bazel`.
- Windows packaged files belong under `packages/launcher/package/win/`.
- Nearby discoverability should be updated in `packages/launcher/README.md`
  and Windows launcher docs without claiming Phase 29 shared evidence or Phase
  30 final visibility.

</code_context>

<specifics>
## Specific Ideas

- Prefer a package-shaped directory such as `Slic3r-windows/` containing a
  Windows-facing console executable name and scoped notes, rather than an MSI,
  zip release, or full legacy PAR bundle.
- Keep all checks executable through Bazel from a clean checkout.

</specifics>

<deferred>
## Deferred Ideas

- MSI, zip release archives, signing, release-channel automation, GUI
  packaging behavior, and broad bundled dependency layout remain future work.
- Shared Windows packaged parity evidence belongs in Phase 29.
- Cross-platform validation status and broader packaging docs belong in Phase
  30.

</deferred>

---

*Phase: 28-windows-packaged-launcher-slice*
*Context gathered: 2026-05-23*
