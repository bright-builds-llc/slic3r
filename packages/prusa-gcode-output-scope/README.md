# Prusa G-code Output Scope Gate

`packages/prusa-gcode-output-scope` owns the Phase 45 reviewed scope gate and the Phase 49 structural evidence scope contract for `prusaslicer.gcode-output`.
It also owns the Phase 53 semantic evidence scope contract for `prusaslicer.gcode-output`.
Run `bazel run //packages/prusa-gcode-output-scope:verify` to check the reviewed Phase 45 scope gate.
Phase 49 structural verification allows only command counts, section counts, ordered markers, movement/extrusion indicators, temperature/tool-change markers, source identity, and fixture identity for the narrow Prusa G-code evidence chain.
Phase 49 structural verification keeps broad generated-outputs in progress and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation.
Phase 52 public evidence consumes this Phase 49 closed structural scope contract for the narrow structural Prusa G-code evidence slice while keeping broad generated-outputs in progress.
Phase 53 semantic verification allows only source identity, fixture identity, command class counts, movement class counts, coordinate bounds, extrusion totals, feedrate observations, and layer/marker relationships for the planned v1.14 semantic Prusa G-code evidence chain.
Phase 53 semantic verification keeps generated-outputs exactly in progress and does not prove byte-for-byte G-code parity, broad generated-output verification, toolpath geometry parity, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation.
Phase 53 only records the planned semantic summary artifact `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`, the planned Phase 55 `slic3r_flavors::prusa_gcode_output` semantic boundary, and the planned Phase 56 `bazel run //packages/parity:prusaslicer_gcode_output_parity` evidence command; it does not create semantic fixture artifacts, Rust semantic parsing, public semantic parity evidence, or status publication.
Phase 45 verification does not prove executable Prusa G-code output parity.
Phase 45 verification does not prove byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, or sync automation.
This package creates no fixture bytes, expected-gcode-summary.tsv, Rust G-code summary implementation, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, printer-runtime behavior, host upload, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.

## Records

- [`gcode-output-scope.md`](gcode-output-scope.md) records the Phase 45 maintainer scope gate, Phase 49 structural evidence field contract, `## v1.14 Semantic Evidence Scope`, and `## v1.14 Semantic Traceability` for `prusaslicer.gcode-output`.

## Boundary

This package is a metadata-only scope gate plus structural and semantic evidence contract. It records the reviewed source identity, existing fixture source, current expected-summary paths, planned semantic summary path, Rust boundary path, evidence command, status token, closed structural and semantic field lists, and deferred scope before later phases consume the contract.
