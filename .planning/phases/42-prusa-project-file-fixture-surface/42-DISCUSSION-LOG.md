# Phase 42: Prusa Project-File Fixture Surface - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-06-03T20:35:51.198Z
**Phase:** 42-Prusa Project-File Fixture Surface
**Mode:** Yolo
**Areas discussed:** Fixture namespace and provenance, Expected artifact
contract, Fail-closed fixture verifier and docs routing

______________________________________________________________________

## Fixture Namespace and Provenance

| Option | Description | Selected |
| --- | --- | --- |
| Profile-schema-aligned flat namespace | Mirrors the existing `prusaslicer.profile-schema` fixture shape and honors the exact Phase 41 reserved path. | yes |
| Nested scenario namespace | Scales to multiple project-file scenarios but deviates from the Phase 41 expected artifact path without extra aggregate wiring. | no |
| Archive-member-expanded provenance | Captures ZIP internals in provenance but risks overclaiming semantic parity and adds update burden. | no |
| Manifest-only source pin with fetch-on-verify | Small repo footprint but does not satisfy checked-in fixture and local verification goals. | no |

**User's choice:** Auto-selected recommendation: profile-schema-aligned flat
namespace.

**Notes:** The recommended path keeps `seam_test_object.3mf`, `.gitattributes`,
README, provenance TSV, and expected artifact inspectable in
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`.

______________________________________________________________________

## Expected Artifact Contract

| Option | Description | Selected |
| --- | --- | --- |
| Minimal metadata-only TSV | Easy to verify but duplicates provenance and gives Phase 43 too little target surface. | no |
| Project-marker/archive-member TSV | Matches the Phase 41 contract and verifies shallow package shape without full 3MF semantics. | yes |
| Full 3MF/project semantic summary TSV | More informative eventually but pulls Phase 43 parser work into Phase 42. | no |

**User's choice:** Auto-selected recommendation: project-marker/archive-member
TSV.

**Notes:** `expected-project-summary.tsv` should use only `source_ref`,
`fixture_path`, `archive_member`, `project_marker`, `deferred_semantics`, and
`notes`. It should not include geometry counts, config key counts, printer
semantics, generated outputs, status rows, or import/export claims.

______________________________________________________________________

## Fail-Closed Fixture Verifier and Docs Routing

| Option | Description | Selected |
| --- | --- | --- |
| Exact-string Bash verifier | Matches Phase 41 and Phase 38 style, has no new dependency, and supports precise failure-mode tests. | yes |
| Data-driven Bash verifier | Reduces duplication but risks overgeneralization for a single fixture. | no |
| Premature Rust/Bazel parity verifier | Eventually useful but violates Phase 42 by creating Phase 43/44 surfaces early. | no |

**User's choice:** Auto-selected recommendation: exact-string Bash verifier
with targeted TSV checks.

**Notes:** The verifier should fail closed on missing fixture bytes,
provenance, expected artifact columns, update route, scope traceability, and
non-overclaiming text. It should also guard against early Rust parser, parity
target, or status-row creation.

## the agent's Discretion

- Exact row wording in `expected-project-summary.tsv`, provided the Phase 41
  columns and non-semantic boundary are preserved.
- Whether Bash helper logic is shared with the profile-schema verifier or kept
  separate for clarity.
- Minimum docs route needed to expose the verifier and preserve the Phase 42
  boundary.

## Deferred Ideas

- Full PrusaSlicer runtime support, GUI project behavior, full 3MF
  import/export, generated-output parity, STEP import, support generation, arc
  fitting, wall seam behavior, network/device integration, profile auto-update
  execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source
  imports, and sync automation remain future work.
