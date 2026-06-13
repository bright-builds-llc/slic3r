# Phase 46: Prusa G-code Fixture Surface - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-13T16:58:19.738Z
**Phase:** 46-Prusa G-code Fixture Surface
**Mode:** Yolo
**Areas discussed:** Fixture Namespace and Provenance, Expected G-code Summary, Fail-Closed Verifier, Docs and Handoff

---

## Fixture Namespace and Provenance

| Option | Description | Selected |
| --- | --- | --- |
| Mirror Phase 42 project-file fixture namespace | Use `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`, source-pinned fixture bytes, provenance TSV, and `.gitattributes` policy. | yes |
| Create a new package outside `packages/parity-fixtures` | Separates G-code fixtures from existing parity fixtures, but breaks the established fork fixture pattern. | |
| Defer fixture bytes again | Keeps Phase 45 absence boundary but fails Phase 46 PGFIX-01. | |

**User's choice:** Yolo-selected the recommended existing fixture namespace pattern.
**Notes:** The phase requires actual fixture bytes, provenance, byte count, SHA-256, and line-ending/encoding policy. The fixture must trace to the accepted PrusaSlicer source identity and not be generated locally during verification.

---

## Expected G-code Summary

| Option | Description | Selected |
| --- | --- | --- |
| Summary-only marker TSV | Create `expected-gcode-summary.tsv` with stable metadata/marker rows useful to Phase 47 typed parsing while deferring runtime semantics. | yes |
| Full G-code comparison artifact | Broader content parity would exceed Phase 46 and pull Phase 48 work forward. | |
| Provenance-only artifact | Would leave Phase 47 without a checked-in expected summary boundary. | |

**User's choice:** Yolo-selected the summary-only marker TSV.
**Notes:** Use the exact Phase 45 reserved columns: `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`, `marker_key`, `marker_value`, and `notes`. Byte counts and hashes belong in provenance, not the expected summary.

---

## Fail-Closed Verifier

| Option | Description | Selected |
| --- | --- | --- |
| Bash verifier plus Bazel `sh_test` mutation coverage | Reuses local Prusa fixture patterns and checks fixture bytes, provenance, expected summary, docs, and premature Phase 47/48 artifacts. | yes |
| Add a Rust verifier now | Strong typing, but it belongs with Phase 47 Rust summary work and increases scope. | |
| Manual review only | Too weak for PGFIX-02. | |

**User's choice:** Yolo-selected the Bash verifier plus Bazel mutation test pattern.
**Notes:** The verifier must be local and hermetic, with no Git, network, upstream source import, G-code generation, printer-runtime behavior, plugin ingestion, or credential processing.

---

## Docs and Handoff

| Option | Description | Selected |
| --- | --- | --- |
| Update fixture package README and minimal port docs | Makes the fixture verifier discoverable while preserving Phase 47/48 deferrals. | yes |
| Publish parity/status docs now | Prematurely implies executable evidence and violates the roadmap boundary. | |
| Keep docs unchanged | Makes the maintainer-facing fixture surface hard to inspect. | |

**User's choice:** Yolo-selected minimal docs and handoff updates.
**Notes:** Docs should expose the Phase 46 fixture surface and verifier while continuing to defer byte parity, broad generated-output parity, runtime/printer, GUI, post-processing, network/device, release, Bambu Studio, OrcaSlicer, upstream import, and sync claims.

---

## the agent's Discretion

- Choose the exact small Prusa-controlled ASCII `.gcode` fixture from the accepted source commit.
- Choose exact expected-summary marker rows when they are stable, summary-only, and useful for Phase 47.
- Decide whether the verifier shares helper structure with existing fixture verifiers or remains a separate script.
- Choose the minimum docs set needed to expose the fixture surface without overclaiming.

## Deferred Ideas

- Phase 47 Rust summary boundary and tests.
- Phase 48 executable parity command, mutation guard, exact status row, and final docs/status publication.
- Broader generated-output, geometry, runtime/printer, GUI, binary, post-processing, network/device, release, non-Prusa fork, upstream import, and sync surfaces.
