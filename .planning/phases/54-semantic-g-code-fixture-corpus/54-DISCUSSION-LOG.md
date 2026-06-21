# Phase 54: Semantic G-code Fixture Corpus - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-21T12:41:13.487Z
**Phase:** 54-Semantic G-code Fixture Corpus
**Mode:** Yolo
**Areas discussed:** Fixture corpus shape, Semantic summary schema and values, Verifier and mutation coverage, Documentation and boundaries

---

## Fixture Corpus Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Extend the existing Prusa G-code fixture namespace | Add `expected-gcode-semantic-summary.tsv` beside the marker and structural artifacts for the same source-pinned fixture. | yes |
| Create a new semantic fixture namespace | Separate semantic files into a new package or directory, increasing traceability and verifier duplication. | |
| Add a new generated fixture | Generate or import richer G-code data now, expanding source and runtime surface. | |

**User's choice:** Auto-selected existing namespace extension as the recommended default.
**Notes:** This preserves the Phase 46 -> 50 -> 54 fixture ladder and avoids new source/runtime surfaces.

---

## Semantic Summary Schema and Values

| Option | Description | Selected |
|--------|-------------|----------|
| Closed Phase 53 field set with one row per field | Use the nine approved fields exactly, with evidence-boundary text per row and exact verifier checks. | yes |
| Broader semantic table | Add richer movement, timing, or geometry fields now for future convenience. | |
| Minimal provenance-only semantic table | Add source/fixture rows only and defer semantic values to Rust parsing. | |

**User's choice:** Auto-selected closed Phase 53 field set as the recommended default.
**Notes:** The selected speed fixture has four feedrate-only `G1 F...` rows and no axes, so values should stay narrow.

---

## Verifier and Mutation Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Extend the existing fixture verifier and mutation harness | Add semantic checks to the current Bash/Bazel fixture verifier and focused sh_test mutation cases. | yes |
| Create a separate semantic verifier | Add a second verifier package for semantic rows. | |
| Defer mutation coverage to Rust parser phase | Check the semantic artifact only once Rust parsing exists. | |

**User's choice:** Auto-selected existing verifier extension as the recommended default.
**Notes:** Phase 54 success requires Bazel-owned fixture verification and fail-closed mutation coverage before Rust consumes the artifact.

---

## Documentation and Boundaries

| Option | Description | Selected |
|--------|-------------|----------|
| Fixture-local documentation only | Update the fixture README and package-level fixture boundary without changing public parity status/docs. | yes |
| Public parity/status publication now | Update status row and public docs in the same phase. | |
| No documentation changes | Rely on the TSV and verifier only. | |

**User's choice:** Auto-selected fixture-local documentation as the recommended default.
**Notes:** Public Rust parser/status/docs work is deferred to Phase 55 and Phase 56.

## the agent's Discretion

- Exact Bash helper and constant names in the fixture verifier.
- Exact semantic row wording, provided fields remain closed and narrow.
- Whether semantic verification uses exact row constants, field-specific expected values, or both.

## Deferred Ideas

- Phase 55 Rust semantic parsing/readiness.
- Phase 56 public semantic parity evidence, status wording, and public docs.
- Broad generated-output, runtime, printability, GUI, release, sync, and non-Prusa fork behavior.
