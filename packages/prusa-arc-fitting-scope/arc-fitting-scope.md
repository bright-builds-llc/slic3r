# Prusa Arc-Fitting Scope Contract

This Phase 57 scope record prepares the narrow `prusaslicer.arc-fitting`
evidence contract. Completing this record does not prove executable
arc-fitting parity, generated-output parity, printability, printer-runtime
behavior, GUI behavior, support generation, wall seam behavior, release
behavior, upstream imports, sync automation, or non-Prusa fork behavior.

## Scope Record

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.arc-fitting` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Inventory row source | `packages/fork-inventories/prusaslicer.tsv` |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Fixture namespace decision | Phase 58 planned namespace `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`; no fixture bytes are checked in during Phase 57. |
| Expected-summary contract | Phase 58 planned `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` with the approved Phase 57 arc evidence fields; no expected arc summary artifact is checked in during Phase 57. |
| Candidate Rust boundary | Phase 59 planned `slic3r_flavors::prusa_arc_fitting` pure data-in/data-out boundary over caller-supplied checked-in arc summaries; no Rust parser implementation is created in Phase 57. |
| Planned evidence command | Phase 60 planned `bazel run //packages/parity:prusaslicer_arc_fitting_parity`; the target is not created in Phase 57. |
| Planned status token | Phase 60 planned `fork.prusaslicer.arc-fitting` after executable evidence passes; no verified `packages/parity/status.tsv` row is published in Phase 57. |
| Docs touched | `packages/prusa-arc-fitting-scope/README.md`; `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` |
| Security note | No secrets, credentials, private data, runtime file discovery, Git, network, device, host upload, release, sync, upstream import, or printer-runtime behavior is introduced by the Phase 57 arc-fitting scope contract. |
| Deferred scope | Byte-for-byte G-code parity; broad generated-output verification; full ArcWelder algorithm equivalence; tolerance or geometry parity; printability; printer-runtime behavior; support generation; wall seam behavior; GUI behavior; release behavior; network/device behavior; non-Prusa fork behavior; upstream source imports; sync automation. |
| Reviewer signoff | Peter Ryszkiewicz, 2026-06-23 UTC |

## Source Row Details

| Field | Value |
| --- | --- |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Feature surface | `arc-fitting` |
| Feature category | `arc-fitting` |
| Ownership | `shared-downstream` |
| Complexity | `medium` |
| Parity dependency | `generated-outputs` |
| Inventory decision | `future-candidate` |
| Caution flags | `none` |
| Inventory note | Arc fitting planning row; future parity requires G-code output comparison evidence. |

## Approved Arc Evidence Fields

This table is a closed contract for the Phase 58 checked-in arc summary and
the Phase 59 typed Rust boundary. Unknown fields must fail closed.

| Arc Field | Category | Evidence Boundary |
| --- | --- | --- |
| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |
| inventory_source_paths | source identity | Inventory source paths only: `src/libslic3r/Geometry/ArcWelder.cpp`. |
| source_anchor | source identity | Reviewed source anchor text or line reference only; no upstream import, Git access, or runtime source discovery. |
| fixture_id | fixture identity | Fixture identity string only for the Phase 58 checked-in fixture. |
| fixture_path | fixture identity | Checked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` only. |
| arc_command_counts | command observations | Counts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity. |
| arc_direction_counts | command observations | Clockwise/counterclockwise direction observations from the checked-in summary only; no algorithm equivalence or tolerance claim. |
| center_offset_observations | center offset observations | Observed I/J center-offset facts from the checked-in summary only; no geometry, planner, or printer-runtime behavior claim. |
| coordinate_bounds | coordinate bounds | Bounded coordinate observations only; no toolpath geometry or printability claim. |
| extrusion_observations | extrusion observations | Summary extrusion observations only; no material-use, runtime, or printability claim. |
| feedrate_observations | feedrate observations | Feedrate metadata observations only; no timing, firmware, or printer-runtime behavior claim. |
| evidence_boundary | boundary text | Explicit statement of what the summary proves and what remains deferred; no executable public status claim before Phase 60. |

## Arc-Fitting Traceability

| Required Link | Exact Target |
| --- | --- |
| Inventory row | `prusaslicer.arc-fitting` in `packages/fork-inventories/prusaslicer.tsv` |
| Category-map row | `arc.shared` in `packages/fork-inventories/category-map.tsv` references `prusaslicer.arc-fitting` exactly once |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Planned fixture namespace | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` |
| Planned expected summary | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` |
| Planned Rust boundary | `slic3r_flavors::prusa_arc_fitting` |
| Planned public evidence command | `bazel run //packages/parity:prusaslicer_arc_fitting_parity` |
| Planned narrow status row | Phase 60 planned `fork.prusaslicer.arc-fitting` remains limited to the narrow v1.15 checked-in arc summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command |
| Existing G-code status row | `fork.prusaslicer.gcode-output` stays limited to the existing semantic Prusa G-code evidence slice backed by Phase 53 through Phase 56 |
| Broad status row | `generated-outputs` stays `in progress` in `packages/parity/status.tsv` |
| Docs touched | `packages/prusa-arc-fitting-scope/arc-fitting-scope.md`; `packages/prusa-arc-fitting-scope/README.md` |

## Planned Status Wording

The planned Phase 60 status token is `fork.prusaslicer.arc-fitting`.

When Phase 60 publishes executable evidence, the planned status wording must
remain limited to the narrow Prusa arc-fitting checked-in summary evidence
slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59
Rust parser/readiness boundary, and Phase 60 public parity command.

`generated-outputs` stays `in progress`, and `fork.prusaslicer.gcode-output`
stays limited to the existing semantic Prusa G-code evidence slice. Phase 57
does not publish a verified `fork.prusaslicer.arc-fitting` row.

## Boundary

This scope record is consumed by Phase 58 fixture corpus work, Phase 59 Rust
arc-fitting boundary work, and Phase 60 public executable evidence/status/docs
publication. It still does not prove byte-for-byte G-code parity, broad
generated-output verification, full ArcWelder algorithm equivalence, tolerance
or geometry parity, generated-output status promotion, printability,
printer-runtime behavior, firmware behavior, support generation, wall seam
behavior, GUI behavior, release behavior, network/device behavior, non-Prusa
fork behavior, upstream source imports, or sync automation.
