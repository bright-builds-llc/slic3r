# Prusa G-code Output Scope Gate

`packages/prusa-gcode-output-scope` owns the Phase 45 reviewed scope gate and the Phase 49 structural evidence scope contract for `prusaslicer.gcode-output`.
Run `bazel run //packages/prusa-gcode-output-scope:verify` to check the reviewed Phase 45 scope gate.
Phase 49 structural verification allows only command counts, section counts, ordered markers, movement/extrusion indicators, temperature/tool-change markers, source identity, and fixture identity for the narrow Prusa G-code evidence chain.
Phase 49 structural verification keeps broad generated-outputs in progress and does not prove byte-for-byte G-code parity, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, arc fitting, GUI export/viewer behavior, release behavior, network/device behavior, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation.
Phase 45 verification does not prove executable Prusa G-code output parity.
Phase 45 verification does not prove byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, or sync automation.
This package creates no fixture bytes, expected-gcode-summary.tsv, Rust G-code summary implementation, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, printer-runtime behavior, host upload, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.

## Records

- [`gcode-output-scope.md`](gcode-output-scope.md) records the Phase 45 maintainer scope gate and Phase 49 structural evidence field contract for `prusaslicer.gcode-output`.

## Boundary

This package is a metadata-only scope gate and structural evidence contract. It records the reviewed source identity, existing fixture source, expected-summary path, Rust boundary path, evidence command, status token, closed structural field list, and deferred scope before later phases consume the contract.
