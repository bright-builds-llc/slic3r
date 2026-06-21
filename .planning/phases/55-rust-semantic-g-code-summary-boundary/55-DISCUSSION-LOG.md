# Phase 55: Rust Semantic G-code Summary Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-06-21T14:58:10.950Z
**Phase:** 55-Rust Semantic G-code Summary Boundary
**Mode:** Yolo
**Areas discussed:** Rust boundary placement, Semantic row model, Rejection coverage, Readiness metadata, No-overclaiming boundary

---

## Rust Boundary Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Extend `slic3r_flavors::prusa_gcode_output` | Reuse the existing marker/structural parser and readiness boundary. | ✓ |
| Create a new semantic crate | Separate semantic parser from existing Prusa G-code output module. | |
| Add filesystem-backed loader | Let Rust discover and read the semantic fixture directly. | |

**User's choice:** Auto-selected recommended option: extend `slic3r_flavors::prusa_gcode_output`.
**Notes:** Existing Phase 53 and Phase 54 context both point Phase 55 at the current pure Rust boundary.

---

## Semantic Row Model

| Option | Description | Selected |
|--------|-------------|----------|
| Exact Phase 54 TSV schema | Parse `source_ref`, `fixture_path`, `semantic_field`, `semantic_category`, `semantic_value`, and `evidence_boundary`. | ✓ |
| Reinterpret semantic rows into a broader generated-output model | Expand the Rust surface beyond the checked-in fixture summary. | |
| Delay typing until Phase 56 | Keep semantic rows as untyped strings until public parity evidence. | |

**User's choice:** Auto-selected recommended option: exact Phase 54 TSV schema.
**Notes:** Closed semantic field names are locked by Phase 53 and the checked-in artifact was created in Phase 54.

---

## Rejection Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Cargo/Bazel fail-closed coverage | Add one-concern tests for valid rows and each invalid semantic drift class. | ✓ |
| Single broad parser test | Use one large test that bundles all failure cases. | |
| Rely on Bash fixture verifier only | Skip Rust semantic parser rejection tests. | |

**User's choice:** Auto-selected recommended option: focused Cargo/Bazel fail-closed coverage.
**Notes:** Required by GSRUST-03 and Bright Builds testing guidance.

---

## Readiness Metadata

| Option | Description | Selected |
|--------|-------------|----------|
| Static semantic readiness in existing registry boundary | Trace semantic readiness without filesystem discovery or status publication. | ✓ |
| Public status/docs update now | Publish semantic status in Phase 55. | |
| Runtime readiness probe | Compute readiness by discovering files or invoking commands. | |

**User's choice:** Auto-selected recommended option: static semantic readiness in the existing registry boundary.
**Notes:** Phase 55 owns developer-visible readiness metadata only. Phase 56 owns public evidence/status/docs.

---

## No-Overclaiming Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Preserve strict no-overclaiming terms | Reject helper names or evidence text that claim broad generated-output behavior. | ✓ |
| Allow broader semantic wording | Accept broad terms if the parser itself stays pure. | |
| Move all wording checks to Phase 56 | Skip semantic claim checks in Rust tests. | |

**User's choice:** Auto-selected recommended option: preserve strict no-overclaiming terms.
**Notes:** This carries forward the Phase 53 scope contract and Phase 54 fixture verifier boundary.

---

## the agent's Discretion

- Exact Rust type and helper names.
- Whether semantic parsing shares marker/structural helper functions or uses new small helpers.
- Exact static readiness metadata shape, provided it stays non-publication and side-effect free.

## Deferred Ideas

- Phase 56 public semantic parity evidence, status wording, docs, and command integration.
- Broad generated-output, runtime, GUI, release, sync, support, seam, arc, and non-Prusa fork behavior.
