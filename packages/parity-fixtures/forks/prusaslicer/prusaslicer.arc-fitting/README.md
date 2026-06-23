# PrusaSlicer Arc-Fitting Fixture

This namespace is `prusaslicer.arc-fitting`. It contains the Phase 58
checked-in arc-fitting observation fixture and expected arc summary for the
accepted source ref
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.

## Artifacts

- `arc-fitting-observations.gcode` is the small reviewed G2/G3 observation
  fixture.
- `fixture-provenance.tsv` pins the fixture to
  `src/libslic3r/Geometry/ArcWelder.cpp`, accepted tag `version_2.9.5`, and
  peeled commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- `expected-arc-summary.tsv` records exactly the Phase 57 approved arc fields
  for this checked-in fixture.
- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` remains the reviewed
  scope contract for this fixture surface.

## Update Route

Update this namespace only after a reviewed intake change updates
`packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
and `packages/prusa-arc-fitting-scope/arc-fitting-scope.md`.
Branch-head observation, upstream import, live generation, network access, and
sync behavior do not update these checked-in fixture bytes or summary rows.

## Phase Boundary

Phase 58 owns only the checked-in `prusaslicer.arc-fitting` fixture namespace,
provenance, and expected summary. Phase 59 owns future
`slic3r_flavors::prusa_arc_fitting` Rust parser/readiness work. Phase 60 owns
future `bazel run //packages/parity:prusaslicer_arc_fitting_parity` evidence
and the future `fork.prusaslicer.arc-fitting` status row.

This namespace does not add public status rows, public docs, Rust parser files,
live generation, network behavior, host upload, post-processing, thumbnails,
printability, GUI behavior, printer-runtime behavior, Bambu Studio behavior,
OrcaSlicer behavior, release behavior, upstream source import, or sync
behavior. The generated-output status promotion boundary remains outside this
checked-in fixture corpus.
