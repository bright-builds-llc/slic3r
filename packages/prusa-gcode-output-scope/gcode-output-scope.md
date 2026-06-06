# Prusa G-code Output Scope Gate

This Phase 45 scope record prepares the narrow summary-only
`prusaslicer.gcode-output` evidence contract. Completing this record does not
prove executable Prusa G-code output parity.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.gcode-output` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/GCode.cpp` |
| Companion API evidence | `src/libslic3r/GCode.hpp` |
| Fixture source decision | Phase 46 source-pinned ASCII `.gcode` fixture under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`; no fixture bytes are checked in during Phase 45. |
| Expected-summary contract | Phase 46 `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` with `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`, `marker_key`, `marker_value`, and `notes` columns; no expected summary artifact is checked in during Phase 45. |
| Candidate Rust boundary | Phase 47 `slic3r_flavors::prusa_gcode_output` pure data-in/data-out G-code summary boundary; no Rust summary implementation is created in Phase 45. |
| Planned evidence command | Phase 48 command text `bazel run //packages/parity:prusaslicer_gcode_output_parity`; the target is not created in Phase 45. |
| Planned status token | Phase 48 token `fork.prusaslicer.gcode-output` after executable evidence passes; no `packages/parity/status.tsv` row is published in Phase 45. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no upstream source import; no Git, network, vendor sync, profile auto-update execution, host upload, credential, cloud, network/device, release, or printer-runtime behavior in Phase 45. |
| Deferred scope | Byte-for-byte G-code parity; full generated-output parity; toolpath geometry; extrusion; timing; support generation; wall seam behavior; arc fitting; STEP import; full 3MF import/export; printer-runtime behavior; firmware or printability behavior; GUI export or viewer behavior; binary G-code; thumbnails; post-processing; host upload; network/device integration; profile auto-update execution; fork release builds; Bambu Studio; OrcaSlicer; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-06 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/GCode.cpp` |
| Companion API evidence | `src/libslic3r/GCode.hpp` |
| Feature surface | `gcode-output` |
| Feature category | `gcode-output` |
| Ownership | `shared-downstream` |
| Complexity | `high` |
| Parity dependency | `generated-outputs` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Source-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed. |

## Boundary

This record is a Phase 45 metadata-only scope gate. It must not be treated as
fixture evidence, Rust summary readiness, status publication, executable
parity, or broad generated-output parity.
