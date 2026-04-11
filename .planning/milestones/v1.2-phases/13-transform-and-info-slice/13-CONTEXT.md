---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 13-2026-04-09T06-45-37
generated_at: 2026-04-09T06:45:37Z
---

# Phase 13: Transform and Info Slice - Context

**Gathered:** 2026-04-09
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver Rust-backed `--info`, `--repair`, and `--split` through the preferred
launcher path on macOS for a bounded single-input slice. This phase covers
command routing, deterministic stdout or artifact creation, and legacy-shaped
filename conventions for repair and split. It does not claim geometric parity
with the retained slicer yet.

</domain>

<decisions>
## Implementation Decisions

### Action scope

- Support single-input `--info`, `--repair`, and `--split` only.
- Keep `--merge`, `--cut`, `--cut-grid`, positioning/layout, and broader
  multi-input orchestration out of scope for this phase.
- Keep explicit `--output` unsupported for the transform/info slice because the
  retained CLI does not expose it for these actions.

### Behavior shape

- `--info` should produce a deterministic, model-summary-style stdout payload
  for the bounded supported input formats.
- `--repair` and `--split` should preserve the legacy filename conventions:
  `*_fixed.obj` and appended numbered `*.stl_01.stl` style outputs.
- `--repair` and `--split` remain STL-only in the Rust-backed slice, matching
  the retained CLI constraints.

### Evidence posture

- Treat this as a Rust-backed implementation milestone, not a verified parity
  milestone.
- Mark the scoped transform/info slice as Rust-backed or in progress in docs
  and parity status, not verified.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Legacy contract anchors

- `packages/legacy-slic3r/slic3r.pl` — retained `--info`, `--repair`, and
  `--split` flow and naming semantics
- `docs/port/contract-inventory.md` — geometry/repair/split and output naming
  inventory rows

### Migration control plane

- `docs/port/cli-slice.md` — current Rust-backed launcher slice
- `packages/parity/status.tsv` — checked-in parity visibility source

</canonical_refs>
