# Prusa Profile Schema Checklist

This Phase 37 checklist record prepares the first v1.10 Prusa profile
schema/config evidence slice. Completing this checklist does not prove Prusa
runtime support or executable fork parity.

## Checklist

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.profile-schema` |
| Source pin | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Candidate Rust module | `packages/slic3r-rust` shared profile/config boundary for Phase 39; exact crate or module name deferred by the roadmap. No Prusa-only Rust workspace and no copied upstream source tree. |
| Fixture need | Planned Phase 38 namespace `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/...`; not created in Phase 37. |
| Evidence command | Planned Phase 40 command `bazel run //packages/parity:prusaslicer_profile_schema_parity`; not created in Phase 37. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no network, cloud, credential, profile auto-update, plugin ingestion, or runtime support scope in Phase 37. |
| Deferred scope | Prusa project files; STEP import; support generation; arc fitting; wall seam behavior; network/device integration; profile auto-update execution; full fork runtime support; GUI support; fork release builds; sync automation; upstream source imports; Prusa fixtures; executable Prusa parity commands. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-02 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `resources/profiles/PrusaResearch.ini` |
| Feature surface | `profile-schema` |
| Feature category | `profile-schema` |
| Ownership | `fork-specific` |
| Complexity | `medium` |
| Parity dependency | `config;config.persistence` |
| v1.9 decision | `future-candidate` |
| Caution flags | `none` |

Future note from the source inventory: Prusa profile schema planning row; future
parity requires loader fixtures and config comparison evidence.

## Boundary

The fixture need and evidence command are future-oriented planning entries only.
They are not created in Phase 37 and must not be used as status evidence.
