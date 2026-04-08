---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 10-2026-04-08T22-01-40
generated_at: 2026-04-08T22:01:40Z
---

# Phase 10: Config Persistence Slice - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver Rust-backed config save/load/datadir behavior for the scoped CLI path on
macOS. This phase only covers save/load/datadir for the supported CLI path and
does not claim broader config, slicing, or export parity.

</domain>

<decisions>
## Implementation Decisions

### Persistence scope

- Implement `--save`, `--load`, and `--datadir` only.
- Keep the Rust-backed persistence slice intentionally text-first and
  metadata-focused: a simple INI-like file is acceptable for this phase if it
  is stable and explicit.
- Multiple `--load` arguments must remain supported.

### Contract and state handling

- Extend `slic3r_contracts` with explicit config persistence command modeling
  instead of shoving these flags into an unsupported bucket.
- Keep process-facing file I/O and error handling in `slic3r_cli`.
- `--datadir` should scope the default configuration path for supported save/load
  flows.

### Visibility

- Mark config as `rust-backed` in parity status once the launcher path serves
  save/load/datadir.
- Do not mark config `verified` until fixture comparison lands in Phase 11.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Legacy config behavior

- `packages/legacy-slic3r/slic3r.pl` — current `--save`, `--load`, and
  `--datadir` CLI flow
- `packages/legacy-slic3r/lib/Slic3r/Config.pm` — current load/save/merge
  semantics

### Migration control plane

- `docs/port/contract-inventory.md` — config semantics registry
- `docs/port/cli-slice.md` — supported CLI slice documentation
- `packages/parity/status.tsv` — current checked-in parity status data

</canonical_refs>
