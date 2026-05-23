---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 30-2026-05-23T13-19-23
generated_at: 2026-05-23T13:21:45.967Z
---

# Phase 30: Packaging Visibility and Docs - Context

**Gathered:** 2026-05-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Publish the scoped Linux and Windows packaging-visible launcher validation
state that Phase 29 made runnable, and align the migration, package, parity,
and planning docs with the v1.7 traceability story. This phase is a visibility
and documentation closeout pass for v1.7. It does not add new runtime behavior,
new parity fixture commands, installer formats, signing, AppImage, MSI, DMG,
GUI packaging, release-grade archives, native/cross-compiled release binaries,
release-channel automation, or downstream fork work.

</domain>

<decisions>
## Implementation Decisions

### Parity Status Publication

- **D-01:** Add separate platform-specific status rows for the scoped packaged
  launcher surfaces: `linux.packaged-launcher` and
  `windows.packaged-launcher`.
- **D-02:** Point those rows at the exact Phase 29 evidence commands:
  `//packages/parity:linux_packaged_launcher_parity` and
  `//packages/parity:windows_packaged_launcher_parity`.
- **D-03:** Keep `bazel run //packages/parity:status` as a checked-in status
  dashboard. Do not make the status script run evidence commands live.
- **D-04:** Preserve the existing macOS packaged launcher claim and avoid a
  single broad aggregate row that could imply all packaging or release formats
  are verified.

### Documentation Scope

- **D-05:** Run a scoped cross-doc publication pass over parity status docs,
  migration docs, platform launcher docs, package docs, and fixture docs so the
  public documentation no longer says Linux or Windows packaged launcher parity
  evidence is deferred.
- **D-06:** Use conservative wording everywhere: the verified scope is the
  package-shaped Linux and Windows launcher trees, startup handoff, layout,
  scope notes, help/version/config/export/transform evidence for the existing
  Rust-backed slice.
- **D-07:** Explicitly state what remains out of scope anywhere a reader could
  infer broader packaging support: signing, installers, AppImage, MSI, DMG,
  GUI packaging, release archives, native/cross-compiled release binaries,
  broad bundled dependency layout, and release-channel automation remain
  deferred.
- **D-08:** Prefer updating existing docs and status surfaces over creating a
  new cross-platform packaged-launcher hub in this phase.

### Traceability and Closeout

- **D-09:** Treat `PVIS-03` as phase-level requirement traceability:
  `.planning/ROADMAP.md` and `.planning/REQUIREMENTS.md` must show every v1.7
  requirement mapped to exactly one phase, with `PVIS-01`, `PVIS-02`, and
  `PVIS-03` assigned to Phase 30.
- **D-10:** Do not retroactively rewrite Phase 27-29 summary bodies. If summary
  metadata is touched, edit only the affected YAML frontmatter and preserve the
  exact `requirements-completed` key.
- **D-11:** Phase 30 summary frontmatter should claim only `PVIS-01`,
  `PVIS-02`, and `PVIS-03`.
- **D-12:** Verification should include an explicit traceability check proving
  12/12 v1.7 requirements map to exactly one phase, plus frontmatter/parser
  health checks and `git diff --check`.

### the agent's Discretion

- Choose the smallest coherent set of doc files needed to remove stale deferred
  claims and make the Phase 29 evidence discoverable.
- Use exact strings and command labels from the current Bazel targets rather
  than introducing alternate terminology.
- Keep documentation edits narrow and reviewable; avoid broad prose rewrites
  unrelated to v1.7 packaging visibility.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope and Traceability

- `.planning/ROADMAP.md` - Phase 30 goal, success criteria, v1.7 requirement
  coverage table, and future roadmap boundaries.
- `.planning/REQUIREMENTS.md` - `PVIS-01`, `PVIS-02`, `PVIS-03`, and v1.7
  traceability status.
- `.planning/STATE.md` - current phase state and accumulated v1.7 context.
- `AGENTS.md` - repo-local summary metadata guidance, especially the
  `requirements-completed` frontmatter rule and `mdformat` restriction for
  phase summaries.
- `AGENTS.bright-builds.md` - Bright Builds verification and documentation
  discipline used by this repo.

### Prior v1.7 Phase Context

- `.planning/phases/27-linux-packaged-launcher-slice/27-CONTEXT.md` - Linux
  packaged launcher boundary and deferred release-format work.
- `.planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md` -
  Windows packaged launcher boundary and deferred release-format work.
- `.planning/phases/29-cross-platform-packaging-evidence/29-CONTEXT.md` -
  Phase 29 evidence commands, fixture scope, and handoff to Phase 30.
- `.planning/phases/29-cross-platform-packaging-evidence/29-01-SUMMARY.md` -
  completed Phase 29 implementation and verification evidence.

### Status and Parity Surfaces

- `packages/parity/status.tsv` - checked-in data source for the parity status
  command.
- `packages/parity/parity_status.sh` - status command renderer.
- `packages/parity/README.md` - package-local parity command discoverability.
- `packages/parity/BUILD.bazel` - authoritative target names for Linux and
  Windows packaged launcher parity commands.
- `packages/parity/compare_packaged_launcher.sh` - shared evidence command used
  by both Linux and Windows packaged launcher parity targets.
- `packages/parity-fixtures/README.md` - fixture package history and workflow
  rules.
- `packages/parity-fixtures/linux-packaged-launcher/README.md` - Linux packaged
  launcher fixture boundary.
- `packages/parity-fixtures/windows-packaged-launcher/README.md` - Windows
  packaged launcher fixture boundary.

### Migration and Package Docs

- `docs/port/parity-matrix.md` - high-level parity dashboard that must publish
  accurate packaged launcher state.
- `docs/port/contract-inventory.md` - detailed launcher and
  packaging-visible behavior inventory.
- `docs/port/migration-guidance.md` - conservative parity evidence and fixture
  update rules.
- `docs/port/linux-launcher-slice.md` - Linux launcher and packaged launcher
  scope.
- `docs/port/windows-launcher-slice.md` - Windows runtime and packaged launcher
  scope.
- `docs/port/entrypoint-architecture.md` - launcher boundary documentation.
- `docs/port/package-map.md` - package ownership and phase history.
- `docs/port/packaged-launcher-slice.md` - macOS packaged launcher baseline to
  preserve.
- `packages/launcher/README.md` - launcher package ownership and current state.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity/status.tsv` already stores tab-separated status rows and can
  publish new platform-specific packaged launcher validation rows without
  changing `packages/parity/parity_status.sh`.
- `packages/parity/README.md` already lists both
  `linux_packaged_launcher_parity` and `windows_packaged_launcher_parity` but
  still says status publication is deferred.
- `docs/port/parity-matrix.md`, `docs/port/contract-inventory.md`, and the
  platform launcher docs contain stale wording that still underclaims Linux and
  Windows packaged launcher evidence.

### Established Patterns

- Status rows use stable surface IDs such as `linux.runtime` and
  `windows.runtime`, an evidence target, and conservative bounded notes.
- Docs should distinguish runtime slices, package-shaped launcher trees,
  shared parity evidence, and release-grade packaging.
- Planning summaries must keep YAML frontmatter parseable and use the exact
  `requirements-completed` key.

### Integration Points

- The main implementation edits should touch status data and docs only.
- Verification should run the affected parity evidence commands, status
  command, traceability checks, frontmatter checks, and whitespace checks.
- Phase artifacts belong under
  `.planning/phases/30-packaging-visibility-and-docs/`.

</code_context>

<specifics>
## Specific Ideas

- Preferred status row names: `linux.packaged-launcher` and
  `windows.packaged-launcher`.
- Preferred evidence targets:
  `//packages/parity:linux_packaged_launcher_parity` and
  `//packages/parity:windows_packaged_launcher_parity`.
- Preferred scope phrase: "scoped packaged launcher tree" or
  "package-shaped launcher tree" for the verified Linux and Windows surfaces.
- Avoid bare phrases like "Linux packaging parity is verified" unless the same
  sentence narrows the scope to the package-shaped launcher tree and existing
  verified Rust-backed slice.

</specifics>

<deferred>
## Deferred Ideas

- A new central cross-platform packaged-launcher documentation hub can be
  considered before v1.8 release automation, but Phase 30 should not introduce
  that restructure.
- Signing, notarization, installers, AppImage, MSI, DMG, GUI packaging,
  release-grade archives, native/cross-compiled release binaries,
  release-channel automation, broad bundled dependency layout, downstream fork
  vendoring, fork parity ports, and fork-flavor builds remain future work.

</deferred>

---

*Phase: 30-packaging-visibility-and-docs*
*Context gathered: 2026-05-23*
