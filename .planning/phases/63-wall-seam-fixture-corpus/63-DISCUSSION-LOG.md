# Phase 63: Wall-Seam Fixture Corpus - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-26T23:56:59.810Z
**Phase:** 63-Wall-Seam Fixture Corpus
**Mode:** Yolo
**Areas discussed:** Fixture namespace and provenance shape, Expected wall-seam summary row design, Fail-closed verifier and mutation coverage

---

## Fixture Namespace and Provenance Shape

| Option | Description | Selected |
| --- | --- | --- |
| Flat arc-fitting mirror, one tiny ASCII-LF `wall-seam-observations.gcode` fixture | Matches Phase 58 precedent, small reviewable bytes, simple bundle, one provenance row pins identity, byte count, SHA-256, update route, and no-runtime exclusions. | yes |
| Flat namespace, 2-3 tiny checked-in G-code observation fixtures | Improves coverage of seam transition, layer, travel, extrusion, and retraction contexts but increases row-order and identity drift risk. |  |
| Subdirectory namespace with `fixtures/`, `expected/`, and root provenance | Scales for a larger future corpus but deviates from current Prusa fixture namespace patterns. |  |
| Static full generated PrusaSlicer G-code output fixture | More realistic context but conflicts with the no-generator/no-runtime Phase 63 boundary and invites byte-parity claims. |  |

**User's choice:** Auto-selected the flat Phase 58-style namespace with one tiny checked-in ASCII/LF wall-seam observation fixture.
**Notes:** Phase 62 already fixed the namespace and expected summary path. The selected shape keeps Phase 63 narrow and hands Phase 64 one stable parser contract.

---

## Expected Wall-Seam Summary Row Design

| Option | Description | Selected |
| --- | --- | --- |
| Arc-style long field rows | Mirrors `expected-arc-summary.tsv`, preserves exact Phase 62 row order, includes category and boundary text inline, and supports fail-closed Bash checks plus later Rust enum parsing. | yes |
| Long rows with JSON values | Allows nested seam/layer/travel facts but increases escaping, schema, and Bash verification complexity. |  |
| Wide fixture row | Makes approved fields visible as columns but weakens duplicate-row and row-order checks and diverges from precedent. |  |

**User's choice:** Auto-selected arc-style long field rows.
**Notes:** The chosen header is `source_ref`, `fixture_path`, `wall_seam_field`, `wall_seam_category`, `wall_seam_value`, and `evidence_boundary`, with exactly the 12 Phase 62 approved fields in order.

---

## Fail-Closed Verifier and Mutation Coverage

| Option | Description | Selected |
| --- | --- | --- |
| Arc-fitting-style Phase 63 Bash verifier and mutation suite | Matches repo precedent and covers exact rows, row counts, order, fields, source refs, fixture identity, checksum, docs, status boundaries, and overclaim guards. | yes |
| Minimal fixture verifier only | Small but insufficient for SEAMFIX-03 because it would not prove stale docs, row-order drift, unsupported claims, duplicate rows, or Phase 65 status boundaries. |  |
| Data-driven shared verifier helpers | Reduces repeated Bash helper code but adds abstraction during evidence work and risks existing verifier regressions. |  |
| Rust-backed verifier now | Strong typed validation but pulls Phase 64 parser work into Phase 63. |  |

**User's choice:** Auto-selected an arc-fitting-style Bash verifier and isolated mutation suite.
**Notes:** This satisfies SEAMFIX-03 without encroaching on Phase 64 Rust parsing or Phase 65 public evidence/status publication.

---

## the agent's Discretion

- Exact static G-code observation lines.
- Exact `key:value` summary value grammar.
- Verifier helper names and mutation test names.

## Deferred Ideas

- Larger multi-file wall-seam fixture corpus.
- Subdirectory-based wall-seam fixture family.
- JSON-valued summary rows or a wide one-row summary.
- Rust parser/readiness work.
- Public parity command, public status row, and public docs publication.
