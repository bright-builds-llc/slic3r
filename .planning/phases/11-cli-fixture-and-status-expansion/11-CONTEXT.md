---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 11-2026-04-08T22-09-48
generated_at: 2026-04-08T22:09:48Z
---

# Phase 11: CLI Fixture and Status Expansion - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Verify the supported help, version, and config persistence CLI slices through
shared fixtures and publish their parity state cleanly.

</domain>

<decisions>
## Implementation Decisions

### Verification scope

- `cli.version` remains verified through the existing comparison command.
- `cli.help` becomes verified through a dedicated shared fixture comparison.
- `config.persistence` becomes verified for the scoped Rust-backed
  save/load/datadir slice through dedicated shared fixtures.

### Fixture strategy

- Group fixtures by supported CLI surface:
  - `cli-version`
  - `cli-help`
  - `config-persistence`
- Keep help and config fixtures deterministic and explicitly scoped to the
  Rust-backed supported slice.
- Do not overclaim broader legacy config parity beyond the supported
  save/load/datadir slice.

### Status publishing

- Update `packages/parity/status.tsv` so help and config persistence become
  `verified`.
- Keep broader CLI behavior and broader config semantics non-verified.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Supported slices

- `docs/port/cli-slice.md` — current supported CLI scope
- `packages/parity/status.tsv` — checked-in status data

### Existing parity infrastructure

- `packages/parity/compare_cli_version.sh` — existing comparison pattern
- `packages/parity-fixtures/README.md` — fixture workflow rules

</canonical_refs>
