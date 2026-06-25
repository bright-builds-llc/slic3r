# Phase 57: Arc-Fitting Scope Contract - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md; this log preserves the alternatives considered.

**Date:** 2026-06-23T18:45:58.288Z
**Phase:** 57-Arc-Fitting Scope Contract
**Mode:** Yolo
**Areas discussed:** Contract placement, Approved arc evidence fields, Traceability and planned artifacts, Status and no-overclaiming constraints

---

## Contract Placement

| Option | Description | Selected |
|--------|-------------|----------|
| New arc-fitting scope package | Create `packages/prusa-arc-fitting-scope` for the feature-specific `prusaslicer.arc-fitting` contract and verifier. | yes |
| Extend G-code output scope package | Add arc fitting to `packages/prusa-gcode-output-scope`, risking accidental widening of `prusaslicer.gcode-output`. | |
| Defer package decision | Let planning decide without a locked package boundary. | |

**User's choice:** New arc-fitting scope package (yolo recommended default).
**Notes:** Arc fitting has its own inventory row, category-map row, planned fixture namespace, Rust boundary, public command, and status token.

---

## Approved Arc Evidence Fields

| Option | Description | Selected |
|--------|-------------|----------|
| Closed small field set | Approve only source, fixture, command, direction, center-offset, bounds, extrusion/feedrate observation, and boundary fields. | yes |
| Broad generated-output facts | Include richer geometry, tolerance, algorithm, timing, and printability facts in the first scope. | |
| Agent discretion with no field table | Let fixture/Rust phases infer approved fields later. | |

**User's choice:** Closed small field set (yolo recommended default).
**Notes:** Unknown fields, missing rows, duplicate rows, unsupported claim text, and traceability drift must fail closed.

---

## Traceability and Planned Artifacts

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit planned artifact chain | Name the inventory row, source identity, source path, fixture namespace, expected summary, Rust boundary, public command, and planned status token. | yes |
| Minimal traceability only | Record inventory and source identity, leaving downstream paths for later phases. | |
| Reuse current G-code output artifacts | Route arc-fitting through existing `prusaslicer.gcode-output` fixture and status surfaces. | |

**User's choice:** Explicit planned artifact chain (yolo recommended default).
**Notes:** Phase 57 records planned downstream paths only; Phases 58-60 create or publish those artifacts.

---

## Status and No-Overclaiming Constraints

| Option | Description | Selected |
|--------|-------------|----------|
| Preserve existing status rows | Keep `generated-outputs` in progress and preserve `fork.prusaslicer.gcode-output` exactly while planning a future `fork.prusaslicer.arc-fitting` row. | yes |
| Publish arc status early | Add or update public status before executable evidence exists. | |
| Widen G-code output wording | Treat existing semantic G-code output evidence as covering arc fitting. | |

**User's choice:** Preserve existing status rows (yolo recommended default).
**Notes:** Planned arc-fitting wording must defer broad generated-output, byte parity, runtime, printability, GUI, support, seam, release, sync, upstream import, and non-Prusa fork behavior.

---

## the agent's Discretion

- Exact Bash helper names and mutation-test function names.
- Whether traceability is one table or several smaller tables.
- Exact reviewer-signoff and deferred-scope table layout.

## Deferred Ideas

- Fixture corpus and expected arc summaries belong to Phase 58.
- Pure Rust arc-fitting parser/readiness belongs to Phase 59.
- Public parity command, mutation guards, status, and docs belong to Phase 60.
