---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 19-2026-04-11T15-18-40
generated_at: 2026-04-11T15:18:40Z
---

# Phase 19: macOS Packaging Parity Evidence - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Verify the scoped macOS packaged launcher behavior and bundle layout through
shared parity evidence, then publish that verified packaging slice cleanly in
the parity status and migration docs. This phase does not attempt DMG,
signing, notarization, or Linux/Windows packaging parity.

</domain>

<decisions>
## Implementation Decisions

### Evidence shape

- Add one packaging parity command that runs the scoped bundle builder,
  inspects the resulting bundle layout, and verifies the packaged startup
  behavior against shared fixtures.
- Reuse the existing CLI help/version fixtures where they already prove the
  packaged launcher handoff behavior.
- Add a packaging-specific fixture corpus for expected bundle files, bundle
  notes, and scoped Info.plist values.

### Visibility

- Promote the scoped macOS packaged launcher slice to `verified` in the parity
  status command once the packaging parity command passes.
- Keep broader packaging-visible behavior in docs as scoped and still deferred
  beyond the currently verified macOS launcher slice.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/launcher/package/osx/build_bundle.sh`
- `packages/launcher/package/osx/test_packaged_launcher.sh`
- `docs/port/packaged-launcher-slice.md`
- `packages/parity/README.md`
- `packages/parity-fixtures/README.md`
- `packages/parity/status.tsv`

</canonical_refs>
