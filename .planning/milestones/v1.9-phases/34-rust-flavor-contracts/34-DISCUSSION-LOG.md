# Phase 34: Rust Flavor Contracts - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-26T21:34:27.138Z
**Phase:** 34-Rust Flavor Contracts
**Mode:** Yolo
**Areas discussed:** contract package boundary, typed vocabulary, parsing and errors, verification shape

---

## Contract Package Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Extend `slic3r_contracts` | Add pure domain contracts to the existing Rust contract crate so callers can reuse them without side effects. | yes |
| Create a new crate | Split fork/flavor contracts into a new crate immediately. | |
| Put types in core | Add fork/flavor concepts directly to `slic3r_core`. | |

**User's choice:** Auto-selected `Extend slic3r_contracts`.
**Notes:** The existing crate already owns stable boundary types and parser tests. Keeping Phase 34 there avoids premature crate splits and keeps side effects out of core logic.

---

## Typed Vocabulary

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror Phase 32/33 tokens | Use the checked-in TSV vocabularies as canonical Rust tokens. | yes |
| Invent Rust-only names | Use more idiomatic Rust enum variants and leave mapping to later phases. | |
| Keep strings for now | Avoid typed vocabularies until the registry phase. | |

**User's choice:** Auto-selected `Mirror Phase 32/33 tokens`.
**Notes:** ARCH-01 exists to stop raw vendor strings from entering core logic. The source TSVs already establish the accepted vocabulary for vendors, ownership, decisions, and parity surfaces.

---

## Parsing and Errors

| Option | Description | Selected |
|--------|-------------|----------|
| Strict boundary parsers | Add `FromStr`/`TryFrom<&str>` style parsers with structured errors and canonical display tokens. | yes |
| Loose parser with fallback | Convert unknown strings to an `Unsupported` or `Unknown` value. | |
| Defer parsing | Add types only and leave parsing to callers. | |

**User's choice:** Auto-selected `Strict boundary parsers`.
**Notes:** The requirement explicitly calls for parsing raw values at the boundary. Unknown values should fail clearly before they reach core migration logic.

---

## Verification Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Rust contract tests | Add parser/display tests for every ARCH-01 concept and keep existing Bazel/Cargo verification. | yes |
| Docs-only examples | Document the concepts without executable tests. | |
| Broad registry tests | Start modeling registry composition and side-effect boundaries now. | |

**User's choice:** Auto-selected `Focused Rust contract tests`.
**Notes:** Phase 34 should prove the contracts directly and leave registry composition to Phase 35.

---

## the agent's Discretion

- Planner may choose exact Rust type names.
- Planner may choose enum vs validated-newtype representation where the type still blocks raw string leakage.
- Planner may choose docs updates if needed to make the contract boundary discoverable.

## Deferred Ideas

- Side-effect-free flavor registry composition belongs to Phase 35.
- Fork parity checklist templates and drift-refresh protocol details belong to Phase 36.
- Runtime fork behavior, online/cloud integration, credential handling, non-free plugin ingestion, and fork-flavor releases remain future work.
