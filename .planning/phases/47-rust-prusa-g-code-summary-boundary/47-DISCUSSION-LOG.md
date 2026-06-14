# Phase 47: Rust Prusa G-code Summary Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-14T15:07:52.277Z
**Phase:** 47 - Rust Prusa G-code Summary Boundary
**Mode:** Yolo
**Areas discussed:** Rust boundary shape, metadata and traceability, expected summary parsing, verification guardrails

---

## Rust Boundary Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror `prusa_project_file` | Add a dedicated `prusa_gcode_output` module with static metadata, typed rows, parse function, and summary lines. | yes |
| Reuse raw TSV strings | Pass strings through future parity code with minimal typing. | |
| Defer Rust boundary to Phase 48 | Let the executable parity phase own parsing and metadata. | |

**User's choice:** Auto-selected mirror `prusa_project_file`.
**Notes:** This best fits `PGSUM-01` and keeps business logic pure before shared parity/status publication logic consumes it.

---

## Metadata and Traceability

| Option | Description | Selected |
|--------|-------------|----------|
| Exact Phase 45/46 traceability | Expose accepted source ref, source path, fixture path, expected summary path, scope record path, generated-output dependency, and reserved future status token. | yes |
| Minimal metadata only | Expose just inventory ID and fixture path. | |
| Status-publication metadata | Add verified status publication details now. | |

**User's choice:** Auto-selected exact Phase 45/46 traceability.
**Notes:** Phase 47 should prepare data for Phase 48 without publishing status or implying executable evidence.

---

## Expected Summary Parsing

| Option | Description | Selected |
|--------|-------------|----------|
| Exact accepted rows | Parse the seven-column TSV and reject unsupported evidence, wrong source/fixture, bad notes, missing/duplicate/extra rows, and wrong ordering. | yes |
| Flexible parser | Accept any metadata and marker rows with the right header. | |
| Generate expected rows from fixture bytes | Read or derive G-code markers directly from the `.gcode` fixture. | |

**User's choice:** Auto-selected exact accepted rows.
**Notes:** Exact rows preserve the reviewed Phase 46 contract and avoid broad G-code parsing or generation behavior in the Rust core.

---

## Verification Guardrails

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Rust unit tests plus registry tests | Add tests for parsing, metadata, summary lines, registry exposure, and non-overclaiming public API names. | yes |
| Smoke test only | Test only that the checked-in summary parses. | |
| Rely on Phase 46 Bash verifier | Do not add Rust-specific negative tests. | |

**User's choice:** Auto-selected focused Rust unit tests plus registry tests.
**Notes:** This directly covers `PGSUM-03` and preserves the no-side-effect Rust boundary.

---

## the agent's Discretion

- Exact enum names and helper function names may follow local Rust clarity.
- A small summary binary may be added if it mirrors the existing project-file binary and only reads an explicitly provided TSV path.
- Small helper refactors are allowed only when they reduce real duplication without broad churn.

## Deferred Ideas

- Phase 48 owns executable parity, status publication, parity mutation guards, and docs/status alignment.
- Broad generated-output, runtime/printer, geometry, support, seam, arc, STEP, GUI, release, network/device, profile-update, Bambu Studio, OrcaSlicer, and sync behavior remain deferred.
