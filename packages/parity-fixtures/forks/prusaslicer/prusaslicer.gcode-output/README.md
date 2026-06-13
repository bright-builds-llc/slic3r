# PrusaSlicer G-code Output Fixture

Phase 46 supplies fixture bytes and summary-only expected artifacts only. This
namespace publishes only the Phase 46 fixture surface and summary-only expected
artifact.

## Provenance

- Vendor ID: `prusaslicer`
- Inventory ID: `prusaslicer.gcode-output`
- Source ref:
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`
- Accepted tag: `version_2.9.5`
- Peeled commit: `9a583bd438b195856f3bcf7ea99b69ba4003a961`
- Source path: `tests/fff_print/test_gcodewriter.cpp#L20-L35`
- Fixture: `gcodewriter-set-speed.gcode`
- Expected artifact: `expected-gcode-summary.tsv`
- Byte count: `42`
- SHA-256:
  `dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb`
- Phase 45 scope record:
  `packages/prusa-gcode-output-scope/gcode-output-scope.md`

The accepted upstream tree has no checked-in `.gcode` blob.
This fixture is derived from source-controlled `GCodeWriter::set_speed` expected-output literals under the accepted commit.

## Update Route

Update route: update this fixture only after a reviewed intake change updates
`packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
and `packages/prusa-gcode-output-scope/gcode-output-scope.md`.
Branch-head observations remain drift-only and do not update this fixture.

## Status Boundary

Rust summary parsing remains Phase 47-owned; executable parity and
`fork.prusaslicer.gcode-output` status publication remain Phase 48-owned.

No base export fixture reuse, live generation, upstream fetching/importing,
binary G-code, thumbnails, post-processing, host upload, printer-runtime
behavior, network/device behavior, credential handling, Bambu Studio support,
OrcaSlicer support, upstream source imports, or sync automation is introduced
by this namespace.

## Deferred Scope

Byte-for-byte G-code parity, full generated-output parity, toolpath geometry,
extrusion, timing, support generation, wall seam behavior, arc fitting, STEP
import, full 3MF import/export, firmware or printability behavior, GUI export
or viewer behavior, fork release builds, and broad PrusaSlicer runtime support
remain deferred.
