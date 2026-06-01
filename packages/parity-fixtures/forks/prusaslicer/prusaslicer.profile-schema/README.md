# PrusaSlicer Profile Schema Fixture

Phase 38 fixture/status preparation only.
Static fixture input only.

## Provenance

- Vendor ID: `prusaslicer`
- Inventory ID: prusaslicer.profile-schema
- Source ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961
- Accepted tag: version_2.9.5
- Peeled commit: 9a583bd438b195856f3bcf7ea99b69ba4003a961
- Source path: `resources/profiles/PrusaResearch.ini`
- Matching index source path: `resources/profiles/PrusaResearch.idx`
- Phase 37 checklist source: packages/prusa-baseline/profile-schema-checklist.md
- License/provenance note: `AGPL-3.0-only`; `metadata-only-not-legal-review`.

## Update Route

Update route: update this fixture only after a reviewed intake change updates packages/fork-vendors/forks.tsv and the Prusa checklist/baseline gate.
Branch-head observations remain drift-only and do not update this fixture.

## Status Boundary

Phase 39 creates Rust parsing; Phase 40 creates executable parity evidence and any verified status publication.
The planned Phase 40 command shape is bazel run //packages/parity:prusaslicer_profile_schema_parity; Phase 38 must not create that target.

## Exclusions

This fixture package does not introduce Bambu Studio fixtures, OrcaSlicer fixtures, network/device integration, cloud behavior, credentials, profile auto-update execution, non-free plugin ingestion, full Prusa runtime support, GUI support, sync automation, or fork release packaging.
