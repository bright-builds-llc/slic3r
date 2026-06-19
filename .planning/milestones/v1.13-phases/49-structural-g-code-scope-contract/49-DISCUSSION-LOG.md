# Phase 49: Structural G-code Scope Contract - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-06-16T14:43:39.375Z
**Phase:** 49-Structural G-code Scope Contract
**Mode:** Yolo
**Areas discussed:** Contract placement, Allowed structural evidence fields,
Fail-closed forbidden claims, Traceability

______________________________________________________________________

## Contract placement

| Option | Description | Selected |
|--------|-------------|----------|
| Extend existing scope package | Add the v1.13 structural contract to `packages/prusa-gcode-output-scope` so the evidence chain stays continuous. | yes |
| Create new structural scope package | Add a separate package for structural evidence, then cross-link it to the old scope package. | |
| Docs-only update | Describe structural scope only in roadmap/docs without verifier-backed package changes. | |

**User's choice:** Auto-selected extend existing scope package.
**Notes:** This matches the existing Phase 45 through Phase 48 chain and avoids
splitting the canonical scope record.

______________________________________________________________________

## Allowed structural evidence fields

| Option | Description | Selected |
|--------|-------------|----------|
| Closed field set | Name exact allowed structural fields and fail on unsupported fields. | yes |
| Open structural prose | Describe allowed evidence in prose and let later phases decide exact schema details. | |
| Fixture-first field discovery | Let Phase 50 define fields while Phase 49 only states general intent. | |

**User's choice:** Auto-selected closed field set.
**Notes:** The roadmap and requirements already enumerate command counts,
section counts, ordered markers, movement/extrusion indicators,
temperature/tool-change markers, source identity, and fixture identity.

______________________________________________________________________

## Fail-closed forbidden claims

| Option | Description | Selected |
|--------|-------------|----------|
| Preserve and expand fail-closed checks | Keep v1.12 forbidden-scope checks and add structural unsupported-field mutation coverage. | yes |
| Preserve existing checks only | Avoid changing mutation coverage until Phase 50 creates the structural fixture. | |
| Human review only | Rely on the written scope record and omit new verifier/test enforcement. | |

**User's choice:** Auto-selected preserve and expand fail-closed checks.
**Notes:** GCSCOPE-02 requires a runnable verifier that fails closed for broad
generated-output claims.

______________________________________________________________________

## Traceability

| Option | Description | Selected |
|--------|-------------|----------|
| Require exact existing source/status chain | Keep exact checks for inventory, category map, fixture/status path, and broad generated-output boundary. | yes |
| Reference source/status chain in docs only | Keep traceability human-readable but not verifier-enforced. | |
| Re-resolve source identity | Treat v1.13 as an opportunity to refresh Prusa source refs. | |

**User's choice:** Auto-selected require exact existing source/status chain.
**Notes:** Phase 49 builds on accepted v1.12 evidence and must not drift to a
branch-head observation, another feature row, or a non-Prusa fork.

______________________________________________________________________

## the agent's Discretion

- Exact Bash helper boundaries in the scope verifier.
- Exact mutation-test helper names and arrangement.
- Whether the scope record gets a new table section or targeted row additions.

## Deferred Ideas

- Phase 50 structural fixture artifact.
- Phase 51 Rust structural summary boundary.
- Phase 52 executable structural parity command and public status/docs updates.
- Broad generated-output, runtime, GUI, geometry, printability, non-Prusa fork,
  upstream import, and sync automation claims.
