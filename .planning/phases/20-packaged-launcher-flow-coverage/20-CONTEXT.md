---
generated_by: gsd-plan-phase
lifecycle_mode: direct-fallback
phase_lifecycle_id: 20-2026-04-11T15-54-47
generated_at: 2026-04-11T15:54:47Z
---

# Phase 20: Packaged Launcher Flow Coverage - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Direct fallback

<domain>
## Phase Boundary

Close the Phase 19 audit gap by extending the shared macOS packaged launcher
parity evidence beyond bundle layout plus packaged `--help` and `--version`.
This phase proves one representative packaged config/export/transform subflow
through the shared parity command, then aligns the packaged-slice docs and
planning state to the exact scope that command verifies.

</domain>

<decisions>
## Implementation Decisions

### Evidence scope

- Reuse the existing packaged launcher bundle builder and packaged parity
  command rather than adding a second packaging-specific verification surface.
- Add one representative packaged workflow that exercises the bundled startup
  shim beyond help/version, such as packaged config persistence or one scoped
  export or transform path.
- Keep the chosen packaged workflow aligned with the already verified Rust-owned
  CLI/export/transform slice instead of broadening the runtime surface in this
  phase.

### Documentation scope

- Update the packaged launcher slice docs and `packaged-slice.txt` so they say
  exactly what the shared packaging parity command proves.
- Refresh planning and audit artifacts only as needed to record `PACK-03` as
  satisfied once the shared evidence command covers that representative
  packaged flow.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/parity/compare_macos_packaged_launcher.sh`
- `packages/parity/BUILD.bazel`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/macos-packaged-launcher/README.md`
- `packages/launcher/package/osx/build_bundle.sh`
- `packages/launcher/package/osx/startup_script.sh`
- `packages/launcher/package/osx/packaged_slice.txt`
- `docs/port/packaged-launcher-slice.md`
- `.planning/v1.3-MILESTONE-AUDIT.md`

</canonical_refs>
