# Prusa G-code Output Scope Gate

`packages/prusa-gcode-output-scope` owns the Phase 45 reviewed scope gate for `prusaslicer.gcode-output`.
Run `bazel run //packages/prusa-gcode-output-scope:verify` to check the reviewed Phase 45 scope gate.
Phase 45 verification does not prove executable Prusa G-code output parity.
Phase 45 verification does not prove byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, or sync automation.
This package creates no fixture bytes, expected-gcode-summary.tsv, Rust G-code summary implementation, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, printer-runtime behavior, host upload, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.

## Records

- [`gcode-output-scope.md`](gcode-output-scope.md) records the Phase 45
  maintainer scope gate for `prusaslicer.gcode-output`.

## Boundary

This package is a metadata-only scope gate. It records the reviewed source
identity, future fixture source decision, expected-summary contract, planned
Rust boundary, planned evidence command, planned status token, and deferred
scope before later phases consume them.
