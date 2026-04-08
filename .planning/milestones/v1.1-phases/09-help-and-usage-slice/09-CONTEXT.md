---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 9-2026-04-08T21-45-14
generated_at: 2026-04-08T21:45:14Z
---

# Phase 9: Help and Usage Slice - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver Rust-backed `--help` and top-level usage output through the preferred
launcher path on macOS, while keeping the supported Rust-backed slice explicit
and leaving broader CLI behavior legacy-owned.

</domain>

<decisions>
## Implementation Decisions

### Help slice scope

- Rust-backed help in this phase means `--help` only. No implicit no-argument
  mode is added here.
- The help output should preserve the legacy banner and usage framing so the new
  launcher still feels like Slic3r.
- The help output must explicitly distinguish supported Rust-backed slices from
  still-legacy-owned CLI behavior.

### Contract and routing

- Extend `slic3r_contracts` with a dedicated help command variant instead of
  folding help into a generic fallback path.
- Keep the process-facing help rendering in `slic3r_cli`.
- Preserve the already verified `--version` slice unchanged.

### Visibility

- Update the CLI-slice docs and parity status data to reflect that help is now
  Rust-backed but not yet fixture-verified.
- Keep broader CLI behavior legacy-only in status reporting.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Legacy CLI contract

- `packages/legacy-slic3r/slic3r.pl` — canonical legacy `--help` banner and
  usage text
- `packages/legacy-slic3r/utils/zsh/functions/_slic3r` — cross-check of visible
  top-level CLI options

### Migration control plane

- `docs/port/contract-inventory.md` — Phase 4 contract registry for CLI
  behavior
- `docs/port/cli-slice.md` — current supported Rust-backed CLI slice
- `docs/port/parity-matrix.md` — current parity vocabulary and status surface

</canonical_refs>
