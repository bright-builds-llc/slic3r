---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 27-2026-05-23T01-40-54
generated_at: 2026-05-23T01:40:54.843Z
---

# Phase 27: Linux Packaged Launcher Slice - Context

**Gathered:** 2026-05-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Build the first scoped Linux packaging-visible launcher artifact for the
already verified Rust-backed help/version/config/export/transform slice. This
phase turns the existing Linux runtime shim into a package-shaped startup tree
that maintainers can build and smoke through Bazel. It does not add AppImage,
distro package, installer, signing, release-channel, GUI, or new CLI behavior.

</domain>

<decisions>
## Implementation Decisions

### Packaged Artifact Shape

- Create a checked-in Bazel-facing builder for a deterministic Linux packaged
  launcher tree under `.planning/.tmp/linux-packaged-launcher`.
- Keep the artifact scoped and package-shaped, not installer-shaped: include
  the startup command, the Rust CLI binary, and scope notes that make the
  supported slice explicit.
- Reuse the existing `packages/launcher/package/linux/startup_script.sh`
  handoff rather than adding a second launcher behavior path.

### Startup and Business Logic Boundary

- The Linux packaged startup path must remain thin shell bootstrap. It may copy
  files and exec the bundled Rust CLI binary, but it must not parse or
  implement CLI business behavior.
- The Rust-backed CLI continues to own help/version/config/export/transform
  behavior through `packages/slic3r-rust` and the existing Bazel launcher
  boundary.
- Any notes added for maintainers must say this is scoped packaging-visible
  launcher behavior, not AppImage, distro packaging, shared library bundling,
  or release automation.

### Smoke Coverage

- Add Bazel smoke coverage for the packaged startup path so maintainers can run
  it without ad hoc setup.
- The smoke test should prove artifact layout, executable startup handoff,
  packaged `--help`, packaged `--version`, representative config persistence,
  and representative export/transform flows through the bundled startup
  command.
- Keep shared fixture parity for Linux and Windows packaged launchers in later
  phases; this phase owns the Linux build/smoke slice only.

### the agent's Discretion

- Use the clearest Linux tree layout that fits existing package conventions and
  is easy to verify with shell tests.
- Update nearby package-local docs only where needed to keep the new target
  discoverable and avoid stale "Linux packaging remains deferred" wording.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 27 goal, success criteria, and requirement
  IDs.
- `.planning/REQUIREMENTS.md` - LPKG-01, LPKG-02, and LPKG-03 definitions.
- `.planning/STATE.md` - current milestone state and non-goals.

### Existing Launcher and Packaging Surfaces

- `packages/launcher/BUILD.bazel` - existing Linux runtime, Windows runtime,
  and macOS packaged launcher Bazel target patterns.
- `packages/launcher/package/linux/startup_script.sh` - thin Linux runtime
  handoff shim that packaged startup should reuse.
- `packages/launcher/package/linux/test_linux_launcher.sh` - existing Linux
  runtime smoke coverage for the verified slice.
- `packages/launcher/package/osx/build_bundle.sh` - existing scoped packaged
  artifact builder pattern.
- `packages/launcher/package/osx/test_packaged_launcher.sh` - existing package
  layout and startup smoke test pattern.
- `packages/launcher/README.md` - package-local ownership and discoverability
  surface.

### Parity and Docs Boundaries

- `docs/port/linux-launcher-slice.md` - Linux runtime slice scope and current
  deferred packaging language.
- `docs/port/entrypoint-architecture.md` - launcher boundary documentation.
- `docs/port/package-map.md` - package ownership and phase history notes.
- `docs/port/parity-matrix.md` - current parity claims and deferred packaging
  state.
- `packages/parity/compare_linux_runtime.sh` - existing Linux runtime evidence
  surface that must remain separate from this phase's smoke target.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/launcher/package/linux/startup_script.sh`: already implements the
  desired thin shell handoff into `slic3r_cli`.
- `packages/launcher/package/osx/build_bundle.sh`: useful pattern for a
  Bazel-run builder that materializes a scoped package artifact in
  `.planning/.tmp`.
- `packages/launcher/package/linux/test_linux_launcher.sh`: existing smoke
  proves Linux runtime help/version/config/export/transform flows through the
  startup script.

### Established Patterns

- Bazel `sh_binary` targets expose buildable launcher artifacts.
- Bazel `sh_test` targets use `$(location ...)` arguments, resolve runfiles or
  workspace paths, copy files into a temp root, and make assertions with
  `set -euo pipefail`.
- Package-local docs explicitly separate runtime, packaged launcher, shared
  parity evidence, and release/installer scope.

### Integration Points

- New targets belong in `packages/launcher/BUILD.bazel`.
- Linux packaged files belong under `packages/launcher/package/linux/`.
- Nearby discoverability should be updated in `packages/launcher/README.md` and
  Linux launcher docs without claiming Phase 29 shared evidence or Phase 30
  final visibility.

</code_context>

<specifics>
## Specific Ideas

- Prefer a package-shaped directory such as `Slic3r-linux/` containing
  executable startup files and scoped notes, rather than an AppImage or distro
  package.
- Keep all checks executable through Bazel from a clean checkout.

</specifics>

<deferred>
## Deferred Ideas

- AppImage, distro package, installer, signing, notarization, and
  release-channel automation remain future work.
- Shared Linux packaged parity evidence belongs in Phase 29.
- Cross-platform validation status and broader packaging docs belong in
  Phase 30.

</deferred>

---

*Phase: 27-linux-packaged-launcher-slice*
*Context gathered: 2026-05-23*
