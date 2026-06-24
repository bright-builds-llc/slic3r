# Phase 60: Executable Arc-Fitting Evidence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-24T15:09:13.299Z
**Phase:** 60-Executable Arc-Fitting Evidence
**Mode:** Yolo
**Areas discussed:** Public executable evidence, Fail-closed mutation guards, Status and docs publication, Verification gate

---

## Public executable evidence

| Option | Description | Selected |
|--------|-------------|----------|
| New public arc-fitting parity command | Add `//packages/parity:prusaslicer_arc_fitting_parity` and validate the checked-in arc summary through `slic3r_flavors::prusa_arc_fitting`. | yes |
| Fold into existing G-code output command | Extend `//packages/parity:prusaslicer_gcode_output_parity` to include arc-fitting evidence. | no |
| Keep parser-only | Do not publish a public command in Phase 60. | no |

**User's choice:** Auto-selected the new public arc-fitting parity command because Phase 57 planned it and ARCEV-01 requires public executable evidence.
**Notes:** The command must preserve the existing public Prusa G-code output command contract and avoid broad generated-output claims.

---

## Fail-closed mutation guards

| Option | Description | Selected |
|--------|-------------|----------|
| Field-specific public mutation coverage | Add one-behavior mutation tests for G2/G3 counts, direction, center offsets, bounds, extrusion/feedrate observations, source and fixture identity, and forbidden claims. | yes |
| Minimal smoke mutation | Add one generic summary drift test only. | no |
| Trust fixture/Rust tests only | Rely on Phase 58 and Phase 59 coverage without public-command mutation tests. | no |

**User's choice:** Auto-selected field-specific public mutation coverage because ARCEV-02 names each drift class.
**Notes:** Tests should use temp copies and assert diagnostics from the public command or Rust-backed validation path.

---

## Status and docs publication

| Option | Description | Selected |
|--------|-------------|----------|
| Publish one narrow arc-fitting row | Add one `fork.prusaslicer.arc-fitting` verified row and update docs with exact Phase 57-60 evidence-chain wording while keeping `generated-outputs` in progress. | yes |
| Promote broad generated outputs | Mark broad `generated-outputs` verified because another generated-output slice exists. | no |
| Widen existing G-code row | Treat arc-fitting evidence as part of `fork.prusaslicer.gcode-output`. | no |

**User's choice:** Auto-selected one narrow arc-fitting row because ARCEV-03 requires exact public status/docs without widening broader rows.
**Notes:** The existing semantic Prusa G-code output evidence remains separate and unchanged.

---

## Verification gate

| Option | Description | Selected |
|--------|-------------|----------|
| Full affected evidence chain | Verify new public command/test, existing G-code output parity command/test, arc fixture verifier, arc scope verifier, aggregate Rust verification, status/docs guards, and diff checks. | yes |
| New target only | Verify only the new public arc-fitting target. | no |
| Defer broad verification to CI | Skip local verification after implementation. | no |

**User's choice:** Auto-selected full affected evidence chain because the phase publishes status/docs and must prove it did not widen existing generated-output claims.
**Notes:** If absence checks in earlier verifiers become stale after legitimate Phase 60 publication, update them narrowly and rerun the affected chain.

---

## the agent's Discretion

- Exact shell helper names and output line ordering.
- Whether to reuse an existing Rust binary mode or add a narrowly named helper, as long as `slic3r_flavors::prusa_arc_fitting` remains the validation authority.
- Exact docs wording and placement, as long as the public boundary remains narrow and explicit.

## Deferred Ideas

- Byte-for-byte G-code parity, broad generated-output verification, full ArcWelder algorithm equivalence, tolerance/geometry parity, printability, runtime behavior, GUI behavior, support generation, wall seam behavior, release behavior, sync automation, upstream imports, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior.
- Richer arc-fitting geometry, tolerance, algorithm-equivalence, or printability evidence for future ARC-02 work.
