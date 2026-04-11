---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 15-2026-04-09T07-43-35
generated_at: 2026-04-09T07:43:35Z
---

# Phase 15: Fixture Coverage Tightening - Context

**Gathered:** 2026-04-09
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Tighten the shared fixture corpus so it fully covers the already-advertised
verified slice for export and transform/info behavior. This phase does not
change the supported launcher behavior; it aligns the proof surface with the
documented slice.

</domain>

<decisions>
## Implementation Decisions

### Export fixture gap

- Extend the export parity command to verify both the existing `--sla` path and
  the explicit `--export-sla-svg` alias.
- Keep the same expected SVG artifact contents for both paths.

### Transform fixture gap

- Extend the transform parity command to verify `--info` for every documented
  supported input family:
  - `stl`
  - `obj`
  - `amf`
  - `3mf`
  - `xml`
- Keep `--repair` and `--split` fixture scope unchanged.

### Visibility

- Update the fixture READMEs and user-facing docs so the verified slice matches
  the actual fixture corpus exactly after the new cases land.
- Keep broader `file-formats` and `generated-outputs` rows conservative because
  the verified slice is still narrower than full parity.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Current parity proof surface

- `packages/parity/compare_export_workflows.sh`
- `packages/parity/compare_transform_workflows.sh`
- `packages/parity-fixtures/export-workflows/README.md`
- `packages/parity-fixtures/transform-workflows/README.md`

### Supported slice docs

- `docs/port/cli-slice.md`
- `.planning/v1.2-MILESTONE-AUDIT.md`

</canonical_refs>
