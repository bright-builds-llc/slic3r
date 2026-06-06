# Phase 41: Prusa Project-File Scope Gate - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-03T01:43:25.461Z
**Phase:** 41-Prusa Project-File Scope Gate
**Mode:** Yolo
**Areas discussed:** Scope package contents, source identity and inventory,
fixture and expected-artifact contract, downstream handoff, deferred scope and
non-overclaiming

---

## Scope Package Contents

| Option | Description | Selected |
|--------|-------------|----------|
| Mandatory field record | Capture every PSEL-01 field as an inspectable scope record. | yes |
| Narrative-only docs | Describe intent in prose and let downstream phases infer fields. | |
| Fixture-first implementation | Start by creating fixture files before a reviewed scope package. | |

**User's choice:** Auto-selected mandatory field record.
**Notes:** This matches Phase 41's purpose as a gate before fixtures, parser
work, parity commands, or status claims.

---

## Source Identity and Inventory

| Option | Description | Selected |
|--------|-------------|----------|
| Existing Prusa project-file row | Use `packages/fork-inventories/prusaslicer.tsv` and the current `version_2.9.5` source pin. | yes |
| New source import | Add upstream source tree integration or a new external repo dependency. | |
| Defer source identity | Let Phase 42 choose the source while creating fixtures. | |

**User's choice:** Auto-selected existing Prusa project-file row.
**Notes:** This keeps the phase tied to the existing trusted fork inventory and
avoids importing upstream source trees.

---

## Fixture and Expected-Artifact Contract

| Option | Description | Selected |
|--------|-------------|----------|
| Contract now, fixture later | Lock fixture source and expected-artifact shape in Phase 41, then create artifacts in Phase 42. | yes |
| Fixture now | Create concrete fixture files during the scope gate. | |
| Parser-first | Let Rust parsing determine the expected artifact shape. | |

**User's choice:** Auto-selected contract now, fixture later.
**Notes:** This preserves the roadmap order and gives Phase 42 a concrete
contract to verify fail-closed.

---

## Downstream Handoff

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit handoff fields | Name candidate Rust boundary, planned evidence command, status token, and docs touched. | yes |
| Planner discretion only | Let later plans invent handoff details from general requirements. | |
| Status publication now | Publish a verified status row before executable parity exists. | |

**User's choice:** Auto-selected explicit handoff fields.
**Notes:** The handoff must support Phases 42-44 without overclaiming Phase 41.

---

## Deferred Scope and Non-Overclaiming

| Option | Description | Selected |
|--------|-------------|----------|
| Exhaustive deferral list | Explicitly list adjacent Prusa/runtime/GUI/generated-output/release/sync surfaces as out of scope. | yes |
| Short deferral note | State generally that broad runtime support is deferred. | |
| Broad parity language | Use wider Prusa project-file wording to leave room for future claims. | |

**User's choice:** Auto-selected exhaustive deferral list.
**Notes:** This aligns with PSEL-02 and the v1.10 status/docs precedent.

---

## the agent's Discretion

- Exact file name and shape for the Phase 41 scope record.
- Whether a lightweight verifier is useful for the scope record itself.
- Minimal docs updates needed for discoverability.

## Deferred Ideas

- Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
  generated-output parity, STEP import, support generation, arc fitting, wall
  seam behavior, network/device integration, profile auto-update execution,
  fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, and
  sync automation remain outside Phase 41.
