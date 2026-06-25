# Phase 59: Rust Arc-Fitting Evidence Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-24T13:36:36.611Z
**Phase:** 59-Rust Arc-Fitting Evidence Boundary
**Mode:** Yolo
**Areas discussed:** Rust module and public surface, Arc summary schema and domain facts, Readiness metadata and registry integration, Verification and documentation boundary

---

## Rust Module and Public Surface

| Option | Description | Selected |
|--------|-------------|----------|
| New `slic3r_flavors::prusa_arc_fitting` module | Mirrors existing pure parser modules while keeping arc fitting separate from G-code output. | yes |
| Extend `prusa_gcode_output` | Reuses nearby code but risks widening the existing `fork.prusaslicer.gcode-output` meaning. | |
| Wait for Phase 60 | Avoids intermediate Rust surface but fails ARCRUST-01 and ARCRUST-02. | |

**User's choice:** Auto-selected the new `slic3r_flavors::prusa_arc_fitting` module.
**Notes:** The phase needs a developer-facing parser/readiness boundary without public parity publication.

---

## Arc Summary Schema and Domain Facts

| Option | Description | Selected |
|--------|-------------|----------|
| Strict six-column closed TSV parser | Matches Phase 58 artifact and fails closed on schema, field, order, value, and claim drift. | yes |
| Generic key/value parser | Less code but weakens the Phase 57 closed field contract. | |
| Raw string pass-through | Minimal implementation but does not create typed evidence or invalid-state protection. | |

**User's choice:** Auto-selected the strict closed TSV parser.
**Notes:** The parser should expose typed rows plus extracted facts over caller-supplied text only.

---

## Readiness Metadata and Registry Integration

| Option | Description | Selected |
|--------|-------------|----------|
| Static metadata plus registry capability | Makes Phase 59 inspectable while preserving Phase 60 publication boundaries. | yes |
| Parser-only with no registry update | Proves parsing but leaves ARCRUST-02 traceability incomplete. | |
| Publish status/docs now | Would violate the Phase 59 boundary and belongs to Phase 60. | |

**User's choice:** Auto-selected static metadata plus registry capability.
**Notes:** The new capability remains a future candidate with `generated-outputs` dependency.

---

## Verification and Documentation Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Cargo and Bazel parser tests | Proves valid fixture parsing, fail-closed invalid rows, metadata, registry, and no-overclaiming names. | yes |
| Cargo-only tests | Faster but misses the repo-owned Bazel verification surface. | |
| Public docs/status update | Premature for Phase 59 and reserved for executable evidence in Phase 60. | |

**User's choice:** Auto-selected focused Cargo and Bazel parser tests.
**Notes:** Developer-facing docs or crate docs may be updated only if needed; public parity/status/docs remain deferred.

---

## the agent's Discretion

- Exact Rust type names, helper function names, and parse-error enum shapes.
- Whether to add a crate-local summary-lines helper, provided it stays caller-supplied and non-public-parity.
- Exact mutation helper layout in tests.

## Deferred Ideas

- Phase 60 public parity command, public status row, public docs, and public mutation guards.
- Broad generated-output parity, byte-for-byte parity, algorithm equivalence, printability, runtime, GUI, release, sync, upstream import, and non-Prusa fork behavior.
