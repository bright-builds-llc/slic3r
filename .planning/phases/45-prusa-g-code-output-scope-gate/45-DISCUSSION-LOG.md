# Phase 45: Prusa G-code Output Scope Gate - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in CONTEXT.md; this log preserves
> the alternatives considered.

**Date:** 2026-06-06T13:53:22.503Z
**Phase:** 45-prusa-g-code-output-scope-gate
**Mode:** Yolo
**Areas discussed:** Scope Record Contract, Verification Guardrails,
Downstream Handoff

______________________________________________________________________

## Scope Record Contract

| Option | Description | Selected |
| --- | --- | --- |
| Mirror Phase 41 scope gate | Use a dedicated package with README, scope record, verifier, verifier test, and Bazel target. | yes |
| Inline scope in docs only | Avoid a package and document the decision only in port docs. | |
| Start with fixture/Rust work | Collapse scope, fixture, Rust, and parity preparation into one phase. | |

**User's choice:** Auto-selected recommended default: mirror the Phase 41
scope gate.
**Notes:** This keeps Phase 45 reviewed and inspectable without introducing
fixture bytes, Rust summary code, parity commands, or status rows.

______________________________________________________________________

## Verification Guardrails

| Option | Description | Selected |
| --- | --- | --- |
| Strict fail-closed verifier | Require exact scope fields, deferred terms, non-overclaiming README language, and absence-boundary text. | yes |
| Presence-only verifier | Check that files exist, but leave detailed claims to review. | |
| Manual review only | Rely on maintainer review without executable verifier coverage. | |

**User's choice:** Auto-selected recommended default: strict fail-closed
verifier.
**Notes:** The prior v1.10/v1.11 trust chain depends on executable gates that
catch claim drift before downstream phases consume the record.

______________________________________________________________________

## Downstream Handoff

| Option | Description | Selected |
| --- | --- | --- |
| Reserve later-phase names only | Name future fixture, Rust, command, docs, and status handoffs but do not create them. | yes |
| Create placeholder targets/files | Add empty or placeholder fixture/Rust/parity/status artifacts now. | |
| Defer all naming | Avoid future names until later phases. | |

**User's choice:** Auto-selected recommended default: reserve later-phase names
only.
**Notes:** This gives Phase 46-48 agents enough direction while preserving the
scope-only boundary.

______________________________________________________________________

## the agent's Discretion

- Choose exact package and file names that match local Bazel/package
  conventions.
- Choose targeted shell test mutations for the highest-risk scope fields and
  overclaiming claims.

## Deferred Ideas

- Fixture bytes and expected summaries belong to Phase 46.
- Rust summary types and tests belong to Phase 47.
- Executable parity, mutation guard, status publication, and public docs
  alignment belong to Phase 48.
