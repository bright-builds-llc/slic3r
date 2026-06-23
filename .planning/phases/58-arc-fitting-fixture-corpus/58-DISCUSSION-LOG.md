# Phase 58: Arc-Fitting Fixture Corpus - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-23T19:52:01.042Z
**Phase:** 58-Arc-Fitting Fixture Corpus
**Mode:** Yolo
**Areas discussed:** Fixture namespace and provenance, Expected arc summary schema, Verifier ownership and mutation coverage, Documentation and publication boundary

---

## Fixture namespace and provenance

| Option | Description | Selected |
|--------|-------------|----------|
| New `prusaslicer.arc-fitting` namespace | Matches the Phase 57 planned namespace and keeps arc evidence separate from the existing G-code output status row. | yes |
| Extend `prusaslicer.gcode-output` namespace | Reuses existing fixture folders but risks widening the current `fork.prusaslicer.gcode-output` meaning. | no |
| Delay fixture namespace until Rust boundary | Avoids new fixture files now but blocks ARCFIX-01 and ARCFIX-02. | no |

**User's choice:** Auto-selected the new `prusaslicer.arc-fitting` namespace.
**Notes:** Phase 57 explicitly planned `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` and the expected summary path.

---

## Expected arc summary schema

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror the Phase 57 closed 12-field contract exactly | Gives Phase 59 a stable typed parsing handoff and makes unsupported fields fail closed. | yes |
| Use a smaller fixture-only schema | Simpler initial artifact, but diverges from the approved scope contract. | no |
| Use a broader geometry/tolerance schema | Captures richer arc behavior but violates v1.15's narrow evidence boundary. | no |

**User's choice:** Auto-selected the exact Phase 57 closed field set.
**Notes:** The summary must stay observational: command counts, direction counts, center offsets, coordinate bounds, extrusion/feedrate facts, source/fixture identity, and evidence-boundary text only.

---

## Verifier ownership and mutation coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Extend `packages/parity-fixtures` with arc fixture verifier coverage | Matches prior fixture phases and keeps fixture drift checks with checked-in artifacts. | yes |
| Add checks to `packages/prusa-arc-fitting-scope` | Reuses the scope package but mixes contract validation with fixture artifact ownership. | no |
| Wait for Rust parser tests to validate fixtures | Defers ARCFIX-03 and lets malformed fixture summaries reach Phase 59. | no |

**User's choice:** Auto-selected fixture-package ownership.
**Notes:** Required mutation classes are missing, duplicate, out-of-order, unsupported field, broad claim, wrong source ref, wrong fixture identity, stale docs, and provenance mismatch.

---

## Documentation and publication boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Update only fixture package docs and Bazel wiring | Makes the corpus inspectable while keeping public status/docs for Phase 60. | yes |
| Publish status/docs in Phase 58 | Prematurely claims public evidence before Rust parser and executable parity exist. | no |
| Skip documentation until Phase 60 | Leaves ARCFIX-01 provenance/update rules hard to inspect. | no |

**User's choice:** Auto-selected fixture-package documentation only.
**Notes:** `packages/parity/status.tsv`, public parity commands, Rust parser crates, and public `docs/port/*` surfaces stay unchanged in Phase 58.

---

## the agent's Discretion

- Exact fixture ID and source excerpt strategy, constrained to a small reviewed source-pinned artifact.
- Exact Bash helper names, constants, and Bazel target names.
- Whether the verifier uses exact multiline rows or field-specific expected values.

## Deferred Ideas

- Rust parser/readiness boundary in Phase 59.
- Public executable parity, status, docs, and mutation guards in Phase 60.
- Broad generated-output parity, byte-for-byte parity, full ArcWelder equivalence, geometry/tolerance parity, printability, runtime, GUI, support, seam, release, upstream import, sync, and non-Prusa fork behavior.
