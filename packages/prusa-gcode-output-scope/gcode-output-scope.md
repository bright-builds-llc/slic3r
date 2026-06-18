# Prusa G-code Output Scope Gate

This Phase 45 scope record prepares the narrow Prusa G-code evidence contract
that starts with the Phase 49 closed structural scope contract and is extended
by v1.13 structural evidence. Completing this record does not prove executable
Prusa G-code output parity.

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

## v1.13 Structural Evidence Scope

This section is an additive structural contract for the existing narrow `prusaslicer.gcode-output` evidence chain. It allows only the fields listed below for Phase 50 structural fixture expectations and Phase 51 typed parsing. It does not promote broad `generated-outputs` status and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, non-Prusa fork behavior, upstream source imports, or sync automation.

| Structural Field | Category | Evidence Boundary |
| --- | --- | --- |
| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |
| inventory_source_paths | source identity | Inventory source paths only: `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`. |
| fixture_source_literal | source identity | Source literal only: `tests/fff_print/test_gcodewriter.cpp#L20-L35`. |
| fixture_id | fixture identity | Fixture identity only: `gcodewriter-set-speed.gcode`. |
| fixture_path | fixture identity | Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`. |
| command_count_total | command counts | Count of G-code command rows in the selected fixture only; no generated-output behavior claimed. |
| command_count_g1 | command counts | Count of `G1` command rows in the selected fixture only; no toolpath geometry claimed. |
| section_count_total | section counts | Count of structural sections in the selected summary only; no GUI, print, or runtime section behavior claimed. |
| ordered_marker_1 | ordered markers | First ordered marker value from the selected fixture summary only. |
| ordered_marker_2 | ordered markers | Second ordered marker value from the selected fixture summary only. |
| ordered_marker_3 | ordered markers | Third ordered marker value from the selected fixture summary only. |
| ordered_marker_4 | ordered markers | Fourth ordered marker value from the selected fixture summary only. |
| movement_axis_present | movement/extrusion indicators | Boolean structural indicator for movement-axis text presence only; no toolpath geometry, travel, or printability claim. |
| extrusion_axis_present | movement/extrusion indicators | Boolean structural indicator for extrusion-axis text presence only; no extrusion amount, material, or printability claim. |
| temperature_marker_count | temperature/tool-change markers | Count of temperature marker commands in the selected fixture only; no printer-runtime behavior claimed. |
| tool_change_marker_count | temperature/tool-change markers | Count of tool-change marker commands in the selected fixture only; no multi-tool runtime behavior claimed. |

## v1.13 Structural Traceability

| Required Link | Exact Target |
| --- | --- |
| Inventory row | `prusaslicer.gcode-output` in `packages/fork-inventories/prusaslicer.tsv` |
| Category-map row | `gcode.shared` in `packages/fork-inventories/category-map.tsv` references `prusaslicer.gcode-output` exactly once |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Fixture namespace | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` |
| Current expected summary | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` |
| Fixture provenance | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv` |
| Published narrow status row | `fork.prusaslicer.gcode-output` stays verified only for the narrow structural Prusa G-code evidence slice in `packages/parity/status.tsv`, backed by the Phase 49 closed structural scope contract, Phase 50 structural fixture summary, Phase 51 Rust structural parser/readiness boundary, and Phase 52 public parity command |
| Broad status row | `generated-outputs` stays `in progress` in `packages/parity/status.tsv` |
| Structural reviewer signoff | Peter Ryszkiewicz, 2026-06-16 UTC |

## Boundary

This scope record is consumed by Phase 49 closed structural scope enforcement,
Phase 50 fixture expansion, Phase 51 Rust structural parser/readiness, and
Phase 52 public structural evidence, while still not proving byte-for-byte
G-code parity, broad generated-output parity, generated-output status
promotion, runtime behavior, release behavior, network/device behavior,
non-Prusa fork behavior, upstream imports, or sync automation.
