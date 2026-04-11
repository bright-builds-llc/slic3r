---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 12-2026-04-08T23-00-53
generated_at: 2026-04-08T23:00:53Z
---

# Phase 12: Export Workflow Slice - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver Rust-backed export workflows through the preferred launcher path on
macOS for the next bounded output slice: G-code, STL, OBJ, AMF, 3MF, layered
SVG, and SLA SVG. This phase covers command routing, output-file creation, and
scoped naming behavior only; it does not claim output-content parity with the
legacy slicer yet.

</domain>

<decisions>
## Implementation Decisions

### Export scope

- Support the legacy-tested single-input export workflows first:
  - `--export-gcode`
  - `-g`
  - `--export-stl`
  - `--export-obj`
  - `--export-amf`
  - `--export-3mf`
  - `--export-svg`
  - `--export-sla-svg`
  - `--sla`
- Keep merge, cut, cut-grid, repair, split, info, layout, and broader
  multi-input orchestration out of scope for this phase.

### Output behavior

- Default output naming should follow the input stem with the expected export
  extension.
- For the scoped explicit `--output` behavior, treat the supplied path as the
  exact export target for single-file outputs.
- For layered SVG export, preserve numbered `*_0.svg` style output naming and
  derive the numbered base from the explicit `--output` path when present.

### Evidence posture

- Generate deterministic, format-shaped placeholder artifacts in Rust so file
  creation and naming are real and reviewable now.
- Do not claim output-content parity in this phase.
- Mark the supported export slice as Rust-backed or in progress in docs and
  parity status, not verified.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Legacy contract anchors

- `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` — legacy-tested export
  options and file-naming expectations
- `packages/legacy-slic3r/slic3r.pl` — current CLI flags and retained export
  control flow

### Migration control plane

- `docs/port/contract-inventory.md` — export format and output naming inventory
- `docs/port/cli-slice.md` — current supported Rust-backed CLI slice
- `packages/parity/status.tsv` — checked-in parity visibility source

</canonical_refs>
