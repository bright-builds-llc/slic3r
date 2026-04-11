---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 14-2026-04-09T06-59-41
generated_at: 2026-04-09T06:59:41Z
---

# Phase 14: Export and Transform Fixture Expansion - Context

**Gathered:** 2026-04-09
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Verify the supported export and transform/info slices through shared fixtures
and publish their parity state cleanly. This phase does not expand the
supported launcher behavior; it proves the bounded Phase 12 and Phase 13
surfaces that already exist.

</domain>

<decisions>
## Implementation Decisions

### Verification shape

- Add one shared fixture comparison command for the supported export workflows.
- Add one shared fixture comparison command for the supported transform/info
  workflows.
- Keep those commands fixture-driven and deterministic rather than attempting a
  broader direct-retained-oracle comparison for every slice in this phase.

### Fixture scope

- Export fixtures must cover the currently supported export families:
  G-code, STL, OBJ, AMF, 3MF, layered SVG, and SLA SVG.
- Transform fixtures must cover the currently supported transform/info slice:
  `--info`, `--repair`, and `--split`.
- Preserve and verify the currently supported filename conventions for export,
  repair, and split.

### Visibility

- Move the scoped `export.workflows` and `transform.workflows` parity rows to
  `verified` once their comparison commands pass.
- Keep broader `file-formats`, `generated-outputs`, and `cli.other` rows
  conservative where the surface still exceeds the verified slice.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing parity infrastructure

- `packages/parity/compare_cli_version.sh` — current comparison pattern
- `packages/parity/compare_cli_help.sh` — current fixture-driven CLI comparison
- `packages/parity/compare_cli_config_persistence.sh` — current fixture-driven
  config comparison
- `packages/parity-fixtures/README.md` — fixture workflow rules

### Supported slices to verify

- `docs/port/cli-slice.md` — supported export and transform/info slice
- `packages/parity/status.tsv` — checked-in parity status data
- `.planning/phases/12-export-workflow-slice/12-VERIFICATION.md` — export slice
  evidence
- `.planning/phases/13-transform-and-info-slice/13-VERIFICATION.md` — transform
  slice evidence

</canonical_refs>
