# Phase 51: Rust Structural G-code Summary Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in CONTEXT.md - this log preserves
> the alternatives considered.

**Date:** 2026-06-17T22:55:52.222Z
**Phase:** 51-Rust Structural G-code Summary Boundary
**Mode:** Yolo
**Areas discussed:** Structural parser model, Validation and regression
coverage, Registry readiness boundary

---

## Structural Parser Model

| Option | Description | Selected |
| --- | --- | --- |
| Closed structural row model + typed projection | Mirrors the Phase 50 TSV and existing parser pattern, gives precise GCRUST-02 diagnostics, preserves `evidence_boundary`, and avoids new dependencies. | yes |
| Aggregated structural summary struct | Gives callers an ergonomic API but can hide the row-order contract and imply stronger semantics than the artifact proves. | |
| Generic field map over typed field enum | Compact and extensible but weaker for typed values and exact ordering. | |
| CSV/Serde row deserializer | Reuses mature parsing libraries but adds dependencies and coarser diagnostics for this narrow artifact. | |

**User's choice:** Auto-selected closed structural row model plus typed
projection.

**Notes:** This matches the existing dependency-free
`prusa_gcode_output` parser style and keeps the Phase 50 structural TSV as the
oracle. A projection is acceptable as convenience, but the row-first contract
must remain visible.

---

## Validation and Regression Coverage

| Option | Description | Selected |
| --- | --- | --- |
| Focused Rust mutation tests, one rejection class per test | Matches existing `prusa_gcode_output.rs` tests, keeps Arrange/Act/Assert clear, and maps directly to every GCRUST-02 rejection class. | yes |
| Macro-generated Rust mutation tests | Reduces boilerplate but makes failures less direct to scan. | |
| Table-driven Rust mutation matrix | Compact but bundles failure concerns and weakens one-concern-per-test diagnostics. | |
| CLI/temp-fixture mutation harness | Exercises real artifact loading and Bazel wiring but adds process/filesystem evidence that belongs in Phase 52. | |

**User's choice:** Auto-selected focused Rust mutation tests.

**Notes:** The tests should cover invalid headers, wrong column counts, missing
rows, duplicate rows, out-of-order rows, unsupported structural fields,
unsupported claim text, wrong source refs, and wrong fixture identities through
Cargo and Bazel.

---

## Registry Readiness Boundary

| Option | Description | Selected |
| --- | --- | --- |
| Add typed readiness metadata to `FlavorCapability` | Makes readiness discoverable through normal registry traversal while keeping data pure and static. | yes |
| Add a narrow Prusa G-code readiness accessor | Smaller API surface but less discoverable and more one-off. | |
| Encode readiness in existing notes or caution flags | Lowest churn but stringly typed and weak for GCRUST-03. | |

**User's choice:** Auto-selected typed readiness metadata reachable from the
existing registry/capability path.

**Notes:** Structural readiness metadata must preserve
`ChecklistStatus::FutureCandidate`, `ParitySurface::generated_outputs()`, and
the reserved future status token. It must not touch status TSVs, public parity
commands, release/sync behavior, or runtime discovery.

---

## the agent's Discretion

- Exact Rust helper boundaries, enum names, and projection method names.
- Whether the structural projection is a method or separate public function.
- Test helper shape, as long as each rejection class remains easy to diagnose.

## Deferred Ideas

- Public executable structural evidence and status/docs publication stay in
  Phase 52.
- CLI/temp-fixture mutation proof stays in Phase 52.
