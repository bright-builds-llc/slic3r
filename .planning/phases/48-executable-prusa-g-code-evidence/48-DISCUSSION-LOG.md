# Phase 48: Executable Prusa G-code Evidence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-14T18:49:25.281Z
**Phase:** 48-executable-prusa-g-code-evidence
**Mode:** Yolo
**Areas discussed:** Executable parity command, Fail-closed drift guard, Status publication, Public documentation, Verification scope

---

## Executable Parity Command

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror project-file parity | Add `compare_prusaslicer_gcode_output.sh`, a Bazel `sh_binary`, and a thin Rust summary binary matching the project-file evidence pattern. | yes |
| Extend fixture verifier only | Treat the fixture verifier as the public evidence command without a new parity target. | |
| Generate or parse raw G-code at parity time | Run broader generated-output behavior from raw G-code or PrusaSlicer execution. | |

**User's choice:** Auto-selected the existing project-file parity shape because Phase 48 requires a real `//packages/parity:*_parity` command and the G-code slice is summary-only.
**Notes:** The command must use the Phase 47 Rust summary boundary and checked-in expected summary artifact, not raw G-code generation or broad runtime behavior.

---

## Fail-Closed Drift Guard

| Option | Description | Selected |
|--------|-------------|----------|
| Mutation-style parity failure test | Add a focused `sh_test` that mutates G-code expected-summary evidence and proves the public parity comparator fails with a useful diff. | yes |
| Rely on Rust parser tests only | Trust Phase 47 parser tests without a public command failure guard. | |
| Rely on manual review | Document expected failure behavior but do not automate it. | |

**User's choice:** Auto-selected a mutation-style parity failure test because `PGEV-02` requires maintainers to see divergence fail through the executable evidence path.
**Notes:** The mutation should be tied to accepted G-code marker rows or source identity so it proves the Phase 48 command guards real evidence drift.

---

## Status Publication

| Option | Description | Selected |
|--------|-------------|----------|
| Add exact fork row only | Add `fork.prusaslicer.gcode-output` as `verified` while keeping broad `generated-outputs` in progress. | yes |
| Promote broad generated outputs | Mark the broad `generated-outputs` row verified. | |
| Leave status unpublished | Ship the command without a checked-in status row. | |

**User's choice:** Auto-selected the exact fork row only.
**Notes:** This carries forward the Phase 45-47 boundary: executable evidence verifies one summary-only Prusa slice, not generated-output parity generally.

---

## Public Documentation

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal docs alignment | Update parity README, parity matrix, control-plane README, and any directly affected package/migration guidance. | yes |
| Code-only publication | Add command/status without docs. | |
| Broad generated-output rewrite | Reframe generated-output docs around the new G-code slice. | |

**User's choice:** Auto-selected minimal docs alignment.
**Notes:** Docs must name the command, status token, fixture namespace, expected summary, Rust boundary, and deferred surfaces without expanding scope.

---

## Verification Scope

| Option | Description | Selected |
|--------|-------------|----------|
| Full relevant Phase 48 surface | Run new parity command/test, existing fixture/scope verifiers, relevant Rust checks, aggregate Bazel verification where practical, and `git diff --check`. | yes |
| New command only | Verify only the new `prusaslicer_gcode_output_parity` command. | |
| Docs/status only | Verify docs and status changes without rerunning code checks. | |

**User's choice:** Auto-selected full relevant Phase 48 surface.
**Notes:** The verification set should include any guard reconciliation needed in Phase 45/46 verifier scripts.

---

## the agent's Discretion

- Exact Rust summary-binary name and comparator helper names may follow local convention.
- Exact mutation case may be chosen during planning and execution, provided it proves real G-code summary drift.
- Additional docs may be updated only when directly required for consistency.

## Deferred Ideas

- Byte-for-byte G-code parity, full generated-output parity, geometry, printer/runtime behavior, GUI behavior, release behavior, network/device behavior, profile auto-update, Bambu Studio, OrcaSlicer, upstream source imports, and sync automation remain future work.
