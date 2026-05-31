# Phase 37: Prusa Baseline and Checklist Gate - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-31T23:02:59.004Z
**Phase:** 37-Prusa Baseline and Checklist Gate
**Mode:** Yolo
**Areas discussed:** Prusa baseline package, drift-refresh record, checklist gate, scope-control wording

---

## Prusa Baseline Package

| Option | Description | Selected |
|--------|-------------|----------|
| Dedicated package | Add a package under `packages/` for completed Prusa baseline records and verification. | yes |
| Fold into templates | Extend `packages/fork-templates` with completed records. | |
| Docs only | Put records only in `docs/port/`. | |

**User's choice:** Auto-selected dedicated package.
**Notes:** This keeps Phase 36 templates reusable and separates completed Prusa review records from future fixture/status packages.

---

## Drift-Refresh Record

| Option | Description | Selected |
|--------|-------------|----------|
| Accepted-pin record with reviewer gate | Record selected tag, peeled commit, drift observation, reviewer decision, and signoff fields without changing pins. | yes |
| Automatic refresh | Update source refs or branch heads automatically. | |
| Clone/build upstream | Fetch or build upstream PrusaSlicer as part of the gate. | |

**User's choice:** Auto-selected accepted-pin record with reviewer gate.
**Notes:** This carries forward the Phase 36 manual drift-refresh boundary and keeps branch heads as drift-only observations.

---

## Checklist Gate

| Option | Description | Selected |
|--------|-------------|----------|
| Complete `prusaslicer.profile-schema` | Fill the Phase 36 checklist fields for the selected v1.10 profile/config evidence slice. | yes |
| Checklist all Prusa rows | Complete checklist records for every Prusa inventory row. | |
| Skip checklist until implementation | Wait for Phase 39/40 implementation before recording review fields. | |

**User's choice:** Auto-selected completed `prusaslicer.profile-schema` checklist.
**Notes:** Phase 37 maps to PRUSA-02 and should prepare the first evidence slice before fixtures, Rust parsing, or executable parity are implemented.

---

## Scope-Control Wording

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit narrow-scope boundary | Name profile/config evidence scope and all deferred Prusa surfaces. | yes |
| Link-only boundary | Link to the v1.9 deferral block without repeating the v1.10 distinction. | |
| Broad fork-ready language | Describe Prusa work as generally ready for implementation. | |

**User's choice:** Auto-selected explicit narrow-scope boundary.
**Notes:** The phase must prevent overclaiming that source pins, inventories, or checklist records prove runtime fork support.

---

## the agent's Discretion

- Exact package name and file names.
- Exact verifier helper shape.
- Exact reviewer placeholder wording.

## Deferred Ideas

- Phase 38 creates the real Prusa fixture/status evidence surface.
- Phase 39 creates Rust parsing and normalization boundaries.
- Phase 40 creates the executable Prusa profile/config parity command and status/docs evidence.
