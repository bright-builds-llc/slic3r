# Prusa Project-File Scope Gate

This Phase 41 scope record prepares the narrow `prusaslicer.project-file`
evidence contract. Completing this record does not prove executable Prusa
project-file parity.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.project-file` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/Format/3mf.cpp` |
| Companion API evidence | `src/libslic3r/Format/3mf.hpp` |
| Fixture source decision | Phase 42 source-pinned upstream `tests/data/seam_test_object.3mf`; no fixture bytes are checked in during Phase 41. |
| Expected-artifact contract | Phase 42 `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv` with `source_ref`, `fixture_path`, `archive_member`, `project_marker`, `deferred_semantics`, and `notes` columns; no expected artifact is checked in during Phase 41. |
| Candidate Rust boundary | Phase 43 `slic3r_flavors::prusa_project_file` data-in/data-out project summary boundary; no Rust parser is created in Phase 41. |
| Planned evidence command | Phase 44 command text `bazel run //packages/parity:prusaslicer_project_file_parity`; the target is not created in Phase 41. |
| Planned status token | Phase 44 token `fork.prusaslicer.project-file` after executable evidence passes; no `packages/parity/status.tsv` row is published in Phase 41. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, credential, cloud, or network/device behavior in Phase 41. |
| Deferred scope | Full PrusaSlicer runtime support; GUI project behavior; full 3MF import/export; generated-output parity; STEP import; support generation; arc fitting; wall seam behavior; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-03 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/Format/3mf.cpp` |
| Feature surface | `project-file` |
| Feature category | `project-file` |
| Ownership | `shared-downstream` |
| Complexity | `medium` |
| Parity dependency | `file-formats` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Source-observed project file planning row; future parity requires fixture-backed load/save evidence. |

## Boundary

This record is a Phase 41 scope gate only. It must not be treated as fixture
evidence, Rust parser readiness, status publication, or executable parity.
