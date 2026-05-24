# Phase 30: Packaging Visibility and Docs - Research

**Researched:** 2026-05-23
**Domain:** Packaging visibility, parity status data, and migration docs
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

- Publish Linux and Windows packaged launcher validation as separate
  platform-specific status rows.
- Keep `bazel run //packages/parity:status` as a checked-in dashboard, not a
  live verifier.
- Update status, migration, package, platform, parity, and fixture docs so they
  no longer underclaim the Phase 29 Linux and Windows packaged launcher
  evidence.
- Keep every status and docs claim scoped to package-shaped launcher trees,
  startup handoff, layout, scope notes, and the already verified
  help/version/config/export/transform slice.
- Do not claim signing, installers, AppImage, MSI, DMG, GUI packaging, release
  archives, native/cross-compiled release binaries, broad bundled dependency
  layout, downstream fork work, or release-channel automation.
- Treat `PVIS-03` as phase-level v1.7 traceability and preserve summary
  frontmatter rules.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
| --- | --- | --- |
| PVIS-01 | Parity status reports Linux and Windows packaging-visible launcher validation state accurately. | Add `linux.packaged-launcher` and `windows.packaged-launcher` rows to `packages/parity/status.tsv`, each pointing to the matching Phase 29 evidence target. |
| PVIS-02 | Migration docs and package docs describe supported Linux and Windows packaged launcher scope and remaining gaps without overclaiming release formats. | Update `docs/port/*`, `packages/launcher/README.md`, `packages/parity/README.md`, and package fixture docs to replace stale deferred wording with scoped verified wording plus explicit exclusions. |
| PVIS-03 | The milestone roadmap and traceability map every v1.7 requirement to exactly one phase. | Verify `.planning/ROADMAP.md` and `.planning/REQUIREMENTS.md` map all 12 v1.7 requirements to Phases 27-30 exactly once and create Phase 30 closeout artifacts claiming only PVIS IDs. |
</phase_requirements>

## Summary

Phase 29 already added the Linux and Windows packaged launcher parity commands:

- `//packages/parity:linux_packaged_launcher_parity`
- `//packages/parity:windows_packaged_launcher_parity`

The remaining work is publication, not new runtime behavior. The status table
currently has runtime rows for Linux and Windows plus one macOS-oriented
`launcher-packaging` row. That shape underreports the Phase 29 evidence and can
make the packaging-visible surface look less complete than it is. The safest
visibility model is to keep the existing checked-in status dashboard and add two
bounded platform-specific rows.

The docs need a scoped publication pass because several surfaces still say
Linux or Windows packaging evidence is deferred even though the Phase 29
commands now exist. Update only the stale claims and nearby discoverability
language. Avoid creating a new docs hub in this phase.

## Status Model

| Surface ID | Status | Evidence | Notes |
| --- | --- | --- | --- |
| `linux.packaged-launcher` | `verified` | `//packages/parity:linux_packaged_launcher_parity` | Shared evidence proves the scoped Linux package-shaped launcher tree, startup handoff, layout, scope notes, and supported behavior slice. |
| `windows.packaged-launcher` | `verified` | `//packages/parity:windows_packaged_launcher_parity` | Shared evidence proves the scoped Windows package-shaped launcher tree, direct console startup, layout, scope notes, and supported behavior slice. |

Keep `launcher-packaging` only if its notes remain clearly macOS-scoped or are
rewritten to avoid implying release-grade packaging parity. Separate Linux and
Windows rows are clearer than one aggregate packaging row.

## Documentation Targets

### Must update

- `packages/parity/status.tsv` - status rows for Linux and Windows packaged
  launcher evidence.
- `packages/parity/README.md` - remove "status publication remains deferred"
  for Linux/Windows packaged launcher parity.
- `docs/port/parity-matrix.md` - high-level dashboard should report scoped
  Linux and Windows packaged launcher evidence as verified.
- `docs/port/contract-inventory.md` - launcher and packaging-visible rows
  should reflect the Phase 29 evidence while preserving deferred release-format
  wording.
- `docs/port/migration-guidance.md` - update the "Scope Now vs Deferred" and
  fixture workflow language so Linux/Windows packaged launcher evidence is no
  longer listed as deferred.
- `docs/port/linux-launcher-slice.md` - shared packaged parity evidence is now
  present; AppImage/distro/installer/signing/release-channel work remains
  deferred.
- `docs/port/windows-launcher-slice.md` - shared packaged parity evidence is
  now present; MSI/signing/release/archive/native/cross-compiled output remains
  deferred.
- `docs/port/package-map.md` - package ownership and phase history should
  mention Phase 29 evidence and Phase 30 status publication.
- `packages/launcher/README.md` - current state should mention that Linux and
  Windows packaged launcher entrypoints now have shared parity evidence and
  status publication.

### Update if stale after the main pass

- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/linux-packaged-launcher/README.md`
- `packages/parity-fixtures/windows-packaged-launcher/README.md`
- `docs/port/README.md`
- `docs/port/entrypoint-architecture.md`
- `docs/port/packaged-launcher-slice.md`

## Traceability Notes

The v1.7 phase mapping should remain:

- Phase 27: `LPKG-01`, `LPKG-02`, `LPKG-03`
- Phase 28: `WPKG-01`, `WPKG-02`, `WPKG-03`
- Phase 29: `PKGE-01`, `PKGE-02`, `PKGE-03`
- Phase 30: `PVIS-01`, `PVIS-02`, `PVIS-03`

Do not retroactively rewrite Phase 27-29 summary bodies. Phase 30 summary
frontmatter should use:

```yaml
requirements-completed:
  - PVIS-01
  - PVIS-02
  - PVIS-03
```

Use `summary-extract` and `frontmatter get` for parser checks, and avoid
`mdformat` on phase `*-SUMMARY.md` files.

## Verification Recommendations

- `bazel run //packages/parity:status`
- `bazel run //packages/parity:linux_packaged_launcher_parity`
- `bazel run //packages/parity:windows_packaged_launcher_parity`
- `node "$HOME/.codex/get-shit-done/bin/gsd-tools.cjs" frontmatter get .planning/phases/30-packaging-visibility-and-docs/30-CONTEXT.md`
- `node "$HOME/.codex/get-shit-done/bin/gsd-tools.cjs" summary-extract .planning/phases/30-packaging-visibility-and-docs/30-01-SUMMARY.md --fields requirements_completed --pick requirements_completed`
- A traceability script or shell check that proves exactly these 12 mappings:
  `LPKG-01..03 -> Phase 27`, `WPKG-01..03 -> Phase 28`,
  `PKGE-01..03 -> Phase 29`, and `PVIS-01..03 -> Phase 30`.
- `git diff --check`

## Research Complete

The implementation should be a focused docs/status publication pass with
traceability verification. No new dependency, runtime code, or parity comparator
is needed.
