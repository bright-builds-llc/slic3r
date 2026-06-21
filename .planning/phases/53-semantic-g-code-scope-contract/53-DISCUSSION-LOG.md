# Phase 53: Semantic G-code Scope Contract - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-21T00:17:18.367Z
**Phase:** 53-Semantic G-code Scope Contract
**Mode:** Yolo
**Areas discussed:** Contract placement, Semantic field closure, Fail-closed verification, Traceability and publication boundary

---

## Contract Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Extend existing scope package | Add v1.14 semantic scope to `packages/prusa-gcode-output-scope`, preserving Phase 45/49/52 continuity. | yes |
| Create new semantic scope package | Separate semantic scope from prior summary/structural scope, increasing package and traceability surface. | |
| Let the agent decide | Choose package placement during planning. | |

**User's choice:** Extend existing scope package.
**Notes:** This follows Phase 49's decision to keep additive G-code evidence contracts in one reviewed package.

---

## Semantic Field Closure

| Option | Description | Selected |
|--------|-------------|----------|
| Closed small field set | Allow only source/fixture identity, command classes, movement classes, coordinate bounds, extrusion totals, feedrate observations, and layer/marker relationships. | yes |
| Broad semantic schema | Leave room for geometry, timing, printability, or richer generated-output semantics now. | |
| Let the agent decide | Let Phase 54 infer semantic fields from fixture data. | |

**User's choice:** Closed small field set.
**Notes:** Unknown semantic fields must fail closed so later phases cannot smuggle broad generated-output claims through fixture or parser expansion.

---

## Fail-Closed Verification

| Option | Description | Selected |
|--------|-------------|----------|
| Exact semantic row and traceability checks | Extend the existing verifier with exact semantic rows, row counts, traceability rows, and focused mutation tests. | yes |
| Documentation-only scope | Record the semantic field list but rely on later fixture/Rust phases for enforcement. | |
| Let the agent decide | Add only whichever checks are convenient during implementation. | |

**User's choice:** Exact semantic row and traceability checks.
**Notes:** The verifier should catch missing fields, unsupported fields, duplicate rows, missing signoff, generated-output promotion, and semantic overclaims.

---

## Traceability and Publication Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Plan semantic artifacts without publication | Trace planned semantic summary, Rust boundary, and future public command/status wording while leaving status/docs publication to Phase 56. | yes |
| Publish semantic status now | Change `fork.prusaslicer.gcode-output` from structural to semantic evidence in Phase 53. | |
| Let the agent decide | Decide publication timing during execution. | |

**User's choice:** Plan semantic artifacts without publication.
**Notes:** Phase 53 should keep `generated-outputs` in progress and leave executable semantic evidence/status wording to Phase 56.

---

## the agent's Discretion

- Exact Bash helper names and table-count helper reuse inside the scope verifier.
- Exact mutation-test helper names, provided every test proves one behavior.
- Semantic traceability table shape, provided downstream phases have explicit paths and boundaries.

## Deferred Ideas

- Phase 54 owns checked-in semantic fixture artifacts.
- Phase 55 owns Rust semantic parsing/readiness.
- Phase 56 owns public semantic evidence/status/docs.
- Broad generated-output, runtime, GUI, release, sync, and non-Prusa fork claims remain deferred.
