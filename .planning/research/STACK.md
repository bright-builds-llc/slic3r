# Project Research - Stack

**Project:** Slic3r Rust Port
**Milestone:** v1.16 PrusaSlicer Wall-Seam G-code Evidence Slice
**Researched:** 2026-06-26
**Confidence:** HIGH for stack shape because v1.16 reuses the existing
v1.12-v1.15 Prusa generated-output evidence ladder.

## Recommendation

Do not add a new external stack for v1.16. Wall-seam evidence should stay
inside the repo-owned Bazel, Rust, Bash, and checked-in TSV/G-code tooling
already used for Prusa G-code marker, structural, semantic, and arc-fitting
evidence.

## Existing Stack To Reuse

- Bazel/Bazelisk: top-level build, test, run, verifier, and public evidence
  command surface.
- Rust in `packages/slic3r-rust`: pure typed parser/readiness code for
  caller-supplied checked-in evidence artifacts.
- `slic3r_contracts` and `slic3r_flavors`: typed fork/flavor/source metadata
  and feature-specific Prusa evidence boundaries.
- Bash `sh_binary` and `sh_test`: thin scope, fixture, parity, and mutation
  adapters around checked-in files and Rust binaries.
- Checked-in TSV expected summaries: closed schemas for reviewed evidence
  facts.
- `packages/parity-fixtures`: fixture namespaces, provenance manifests, update
  rules, and fixture verifiers.
- `packages/parity`: public parity command and status publication surface.
- `docs/port`: public migration, package map, parity matrix, and port status
  documentation.

## Stack Additions

The milestone should add only repo-owned artifacts:

- A `prusaslicer.wall-seam` scope package or package-local scope section with a
  fail-closed verifier.
- A fixture namespace under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/`.
- A checked-in `expected-wall-seam-summary.tsv` constrained to approved seam
  observation fields.
- A pure `slic3r_flavors::prusa_wall_seam` Rust boundary and optional summary
  binary over caller-supplied checked-in TSV text.
- A public `//packages/parity:prusaslicer_wall_seam_parity` evidence command.
- An exact `fork.prusaslicer.wall-seam` status row after executable evidence
  passes.

## Do Not Add

- No third-party G-code parser, geometry crate, database, or GUI toolkit.
- No live PrusaSlicer generation during verification.
- No upstream clone, fetch, source import, or sync automation.
- No printer/runtime probing, host upload, firmware integration, cloud/device
  integration, or credential handling.
- No byte-for-byte G-code comparator for this milestone.

## Integration Notes

The accepted planning row is `prusaslicer.wall-seam` in
`packages/fork-inventories/prusaslicer.tsv`. It uses source identity
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` and
source path `src/libslic3r/GCode/SeamAligned.cpp`.

The category map row is `seam.shared` in
`packages/fork-inventories/category-map.tsv`. It references
`prusaslicer.wall-seam` as a shared downstream future candidate with
`generated-outputs` as the parity dependency.

The repo already has legacy seam behavior tests in
`packages/legacy-slic3r/t/perimeters.t`, including `seam_position=random` and
`seam_position=aligned`. Those are local legacy reference signals, not proof of
PrusaSlicer wall-seam parity.
