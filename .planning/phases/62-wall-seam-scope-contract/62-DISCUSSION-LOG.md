# Phase 62: Wall-Seam Scope Contract - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-06-26T23:04:21.788Z
**Phase:** 62-Wall-Seam Scope Contract
**Mode:** Yolo
**Areas discussed:** Contract placement, Approved wall-seam evidence fields,
Traceability and planned downstream artifacts, Status and no-overclaiming
constraints

---

## Contract placement

| Option | Description | Selected |
| --- | --- | --- |
| New wall-seam scope package | Create `packages/prusa-wall-seam-scope` following the Phase 57 arc-fitting pattern. | yes |
| Extend G-code output scope package | Add wall-seam contract data to `packages/prusa-gcode-output-scope`. | no |
| Extend arc-fitting scope package | Reuse `packages/prusa-arc-fitting-scope` for another generated-output feature. | no |

**User's choice:** Yolo selected the recommended default: create a separate
wall-seam-specific package.
**Notes:** A separate package keeps the planned `fork.prusaslicer.wall-seam`
status row from widening existing semantic G-code output or arc-fitting rows.

---

## Approved wall-seam evidence fields

| Option | Description | Selected |
| --- | --- | --- |
| Closed seam-observation field set | Approve a small closed table of source, fixture, seam-transition, layer/travel context, coordinate, extrusion, retraction, and boundary fields. | yes |
| Open-ended seam summary fields | Let Phase 63 add fields as fixture evidence is discovered. | no |
| Geometry-equivalence field set | Include seam geometry, tolerance, visibility, or algorithm-equivalence fields now. | no |

**User's choice:** Yolo selected the recommended default: use a closed
seam-observation field set.
**Notes:** The selected fields are evidence inputs only and must not claim byte
parity, wall-seam algorithm equivalence, seam visibility, printability,
runtime, or GUI behavior.

---

## Traceability and planned downstream artifacts

| Option | Description | Selected |
| --- | --- | --- |
| Mirror the established evidence ladder | Trace to `prusaslicer.wall-seam`, `seam.shared`, planned fixture namespace, planned Rust boundary, planned parity command, and planned status token. | yes |
| Scope only the immediate verifier | Record only the current package contract and leave downstream artifact names undecided. | no |
| Publish downstream artifacts during scope | Create fixture, Rust, public command, or status artifacts in Phase 62. | no |

**User's choice:** Yolo selected the recommended default: mirror the established
four-step evidence ladder while keeping downstream artifacts planned only.
**Notes:** Phase 63 owns fixtures, Phase 64 owns Rust parsing, and Phase 65
owns public command/status/docs publication.

---

## Status and no-overclaiming constraints

| Option | Description | Selected |
| --- | --- | --- |
| Preserve existing rows and keep wall-seam planned | Keep `generated-outputs` in progress and preserve existing G-code and arc-fitting row meanings. | yes |
| Widen the semantic G-code row | Treat wall-seam as covered by the existing `fork.prusaslicer.gcode-output` row. | no |
| Promote broad generated outputs | Mark generated output parity verified because another feature slice is planned. | no |

**User's choice:** Yolo selected the recommended default: preserve existing
rows and keep wall-seam publication planned until executable evidence passes.
**Notes:** The planned status wording must stay narrow and explicit about
deferred generated-output, geometry, visibility, printability, runtime, GUI,
release, sync, and non-Prusa surfaces.

---

## the agent's Discretion

- Verifier helper function names.
- Exact scope-record table organization.
- Exact mutation test names, provided each test proves one failure mode and
  uses isolated temp copies.

## Deferred Ideas

- Phase 63 fixture corpus and expected wall-seam summary artifact.
- Phase 64 pure Rust wall-seam parser/readiness boundary.
- Phase 65 public wall-seam parity command, mutation guards, status row, and
  docs.
