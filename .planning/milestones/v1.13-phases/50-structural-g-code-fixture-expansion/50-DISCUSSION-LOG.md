# Phase 50: Structural G-code Fixture Expansion - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in CONTEXT.md - this log preserves
> the alternatives considered.

**Date:** 2026-06-17T16:19:36.990Z
**Phase:** 50-structural-g-code-fixture-expansion
**Mode:** Yolo
**Areas discussed:** Structural summary schema shape, Bazel fixture verifier
and update rules, Mutation guard coverage

---

## Structural Summary Schema Shape

| Option | Description | Selected |
| --- | --- | --- |
| Replace `expected-gcode-summary.tsv` with structural schema | One canonical artifact, but breaks the current summary-only parser/verifier/parity path and weakens the additive Phase 49 framing. | no |
| Add separate `expected-gcode-structural-summary.tsv` | Preserves the existing summary-only TSV and verified parity path while giving Phase 50 an exact structural artifact for Phase 51. | yes |
| Extend existing TSV with additional structural rows | Keeps one file path, but overloads current `metadata_key`/`marker_key` semantics and creates compatibility churn. | no |
| Extend existing TSV with structural columns | Makes structural fields visible in one wide schema, but breaks header/column-count assumptions and weakens row-level duplicate checks. | no |

**User's choice:** Yolo auto-selected the advisor recommendation:
add a separate `expected-gcode-structural-summary.tsv`.
**Notes:** This keeps the v1.12/Phase 48 evidence path stable while Phase 50
adds fixture-owned structural evidence.

---

## Bazel Fixture Verifier and Update Rules

| Option | Description | Selected |
| --- | --- | --- |
| Extend `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` with a sidecar structural TSV | Preserves fixture ownership, existing Bazel shell verifier style, and validates fixture bytes, old summary, structural summary, provenance, README, status, and update route together. | yes |
| Add a sibling `verify_prusa_gcode_output_structural_fixture` target | Isolates structural checks, but risks split ownership and missed commands. | no |
| Move structural fixture validation into `packages/prusa-gcode-output-scope:verify` | Ties checks to the closed field list, but blurs the metadata-only scope package with fixture ownership. | no |
| Replace/expand `expected-gcode-summary.tsv` and rely on Rust/parity updates | One eventual artifact, but collapses Phase 50 into Phase 51/52 and risks current parity regressions. | no |

**User's choice:** Yolo auto-selected the advisor recommendation: extend the
existing G-code fixture verifier in `packages/parity-fixtures`.
**Notes:** The verifier should fail closed on exact structural schema/rows,
duplicate or missing fields, provenance/source-ref mismatch, broad-claim text,
update-route weakening, exact narrow status drift, and broad `generated-outputs`
promotion.

---

## Mutation Guard Coverage

| Option | Description | Selected |
| --- | --- | --- |
| Balanced fixture-verifier mutation set | Covers every named GCFIX-03 failure with one-behavior tests and avoids duplicating Phase 51 parser coverage. | yes |
| Exhaustive negative matrix | Maximum fail-closed confidence, but brittle and duplicates later typed parser tests. | no |
| Minimal smoke guards | Smallest surface, but undercovers explicit GCFIX-03 requirements. | no |
| Generated/table-driven mutations | Scales for many fixtures, but adds abstraction before there is more than one structural fixture. | no |

**User's choice:** Yolo auto-selected the advisor recommendation: use the
balanced mutation set.
**Notes:** Required negative cases are structural value drift, missing row,
duplicate row, unsupported structural field, broad-behavior overclaim text, and
provenance mismatch.

---

## the agent's Discretion

- Exact Bash helper names and constant layout.
- Exact README wording as long as it preserves the narrow Phase 50 fixture
  boundary.
- Exact assertion wording in mutation tests, provided diagnostics identify the
  failed structural field or artifact.

## Deferred Ideas

- Rust structural parsing is Phase 51.
- Public executable structural evidence and docs/status publication are Phase
  52.
- Broad generated-output, byte parity, geometry/toolpath, runtime/printability,
  support, wall seam, arc, GUI, release, network/device, non-Prusa fork,
  upstream import, and sync claims remain out of scope.
