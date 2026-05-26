# Phase 33: Inventory Templates and Source-Pinned Fork Inventories - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-05-26T17:24:45.822Z
**Phase:** 33-inventory-templates-and-source-pinned-fork-inventories
**Mode:** Yolo
**Areas discussed:** Inventory package and data shape, required inventory
fields, classification taxonomy, inventory coverage, verification and
documentation

---

## Inventory Package and Data Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Dedicated `packages/fork-inventories` package | Keep feature inventories and cross-fork maps separate from vendor-source ref metadata. | yes |
| Extend `packages/fork-vendors` | Keep all fork intake data together, but risk conflating source refs with feature inventories. | |
| Markdown-only inventories | Easy to read, but harder to validate and reuse for later typed contracts. | |

**User's choice:** Auto-selected dedicated `packages/fork-inventories`.
**Notes:** This keeps Phase 32 source refs authoritative while giving Phase 33 a
clear package boundary for templates, inventory rows, cross-fork maps, and
verification.

---

## Required Inventory Fields

| Option | Description | Selected |
|--------|-------------|----------|
| TSV schema with required enum-like fields | Easy to validate from shell and later parse into Rust contracts. | yes |
| Freeform Markdown table | Human-friendly but weaker as a source of truth. | |
| JSON/TOML schema | Structured, but adds parser and schema decisions beyond this phase. | |

**User's choice:** Auto-selected TSV schema with required fields.
**Notes:** Required fields are inventory ID, vendor ID, feature surface,
ownership classification, source reference, source paths, complexity, existing
parity-surface dependency, v1.9 decision, and future parity notes.

---

## Classification Taxonomy

| Option | Description | Selected |
|--------|-------------|----------|
| `base-slic3r`, `shared-downstream`, `fork-specific`, `unknown-needs-review` | Covers the requirement language and keeps uncertainty explicit. | yes |
| Per-vendor ad hoc labels | Flexible but hard to compare across forks. | |
| Implementation-ready only | Hides deferred and unknown rows that maintainers still need to inspect. | |

**User's choice:** Auto-selected the four-way ownership taxonomy.
**Notes:** v1.9 decisions should separately identify future candidates,
deferred rows, no-action/base rows, and needs-review rows.

---

## Inventory Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Bounded initial inventories for named requirement surfaces | Satisfies INV-02 through INV-05 without pretending to exhaust every upstream feature. | yes |
| Exhaustive upstream feature archaeology | More complete, but too broad for this template-and-baseline phase. | |
| Template only, no initial rows | Easier, but fails the per-fork inventory requirements. | |

**User's choice:** Auto-selected bounded initial inventories.
**Notes:** Required coverage includes Prusa base/shared/Prusa-specific rows,
Bambu project/profile/network/support/STEP/arc/assembly rows, Orca
calibration/wall-seam/support/adaptive-mesh/profile-library/community-profile
rows, and a cross-fork category map.

---

## Verification and Documentation

| Option | Description | Selected |
|--------|-------------|----------|
| Repo-owned shell verifier under Bazel | Matches existing package validation style and avoids upstream network dependency. | yes |
| Documentation-only review | Easier to write but weak against malformed inventories. | |
| Remote source inspection during verify | Stronger source validation, but introduces slow network behavior and drifts beyond Phase 33 scope. | |

**User's choice:** Auto-selected repo-owned shell verifier under Bazel.
**Notes:** Verification should check TSV shape, required fields, enum values,
vendor IDs against `packages/fork-vendors/forks.tsv`, pinned source-reference
form, required coverage, and cross-map row references. It should not fetch,
clone, or inspect upstream remotes.

---

## the agent's Discretion

- Exact column names are flexible if every INV requirement remains directly
  represented and shell-verifiable.
- The cross-fork map may reference row IDs directly or use category-to-row
  references, provided stale references fail verification.
- The planner may add verifier tests or package-local docs needed to make the
  inventory contract maintainable.

## Deferred Ideas

- Exhaustive upstream feature archaeology beyond the named requirement surfaces.
- Rust flavor contracts and typed parsers.
- Executable fork parity, fork-flavor release builds, GUI migration, full
  drift-refresh protocol templates, online/cloud integrations, credentials, and
  non-free plugin ingestion.
