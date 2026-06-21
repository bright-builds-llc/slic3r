# PrusaSlicer G-code Output Fixture

Phase 46 supplies fixture bytes and the original summary expected artifact.
Phase 50 adds `expected-gcode-structural-summary.tsv` as a structural sidecar
for the same source-pinned fixture. Phase 52 publishes only the narrow
structural Prusa G-code evidence slice.
Phase 54 adds `expected-gcode-semantic-summary.tsv` as a semantic sidecar for the same source-pinned fixture.

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
- Structural expected artifact: `expected-gcode-structural-summary.tsv`
- Semantic expected artifact: `expected-gcode-semantic-summary.tsv`
- Byte count: `42`
- SHA-256:
  `dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb`
- Phase 45 scope record:
  `packages/prusa-gcode-output-scope/gcode-output-scope.md`

The accepted upstream tree has no checked-in `.gcode` blob.
This fixture is derived from source-controlled `GCodeWriter::set_speed` expected-output literals under the accepted commit.
Phase 50 adds `expected-gcode-structural-summary.tsv` as a structural sidecar for the same selected fixture. It records only source identity, fixture identity, command counts, section counts, ordered markers, movement/extrusion indicators, and temperature/tool-change marker counts.
Phase 54 adds `expected-gcode-semantic-summary.tsv` as a semantic sidecar for the same selected fixture. It records only source identity, fixture identity, command class counts, movement class counts, coordinate-bound absence, extrusion-axis absence, feedrate observations, and layer/marker absence from the checked-in `G1 F...` lines.

## Update Route

Update route: update this fixture only after a reviewed intake change updates
`packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
and `packages/prusa-gcode-output-scope/gcode-output-scope.md`.
Branch-head observations remain drift-only and do not update this fixture.

## Status Boundary

Rust summary parsing remains Phase 47-owned; executable parity and
`fork.prusaslicer.gcode-output` status publication remain Phase 48-owned for
the Phase 48 summary evidence path.
Phase 52 public structural parity/status publication consumes the Phase 49 closed structural scope contract and Phase 50 structural sidecar through the Phase 51 Rust structural parser/readiness boundary.
Phase 55 owns Rust semantic parsing/readiness, and Phase 56 owns public semantic parity/status/docs publication.
Phase 54 does not update `packages/parity/status.tsv`, public parity command behavior, Rust parser crates, or public `docs/port/*` files.

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
