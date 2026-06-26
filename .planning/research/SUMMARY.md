# Project Research Summary

**Project:** Slic3r Rust Port
**Domain:** v1.16 PrusaSlicer Wall-Seam G-code Evidence Slice
**Researched:** 2026-06-26
**Confidence:** HIGH for roadmap shape and stack; MEDIUM for exact fixture
bytes and final summary fields until Phase 62 closes the scope contract.

## Executive Summary

v1.16 should prove one narrow, source-pinned PrusaSlicer wall-seam G-code
evidence slice. The right shape is the same evidence ladder used by v1.12
through v1.15: reviewed scope contract, source-pinned fixture corpus, pure Rust
parser/readiness boundary, public Bazel parity command, fail-closed mutation
guards, exact status/docs wording, and no broad runtime claim.

The stack should not expand. Use Bazel, checked-in TSV/G-code artifacts, Bash
verifiers, `packages/parity-fixtures`, `packages/parity`, and the existing
`slic3r_flavors` Rust boundary pattern. Do not add live PrusaSlicer
generation, upstream imports, network access, third-party G-code parsers,
geometry libraries, runtime/printer checks, or GUI behavior.

The accepted planning row is `prusaslicer.wall-seam` in
`packages/fork-inventories/prusaslicer.tsv`, with source identity
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` and
source path `src/libslic3r/GCode/SeamAligned.cpp`. The category-map row is
`seam.shared`.

## Key Findings

### Stack Additions

- Scope contract and fail-closed verifier for `prusaslicer.wall-seam`.
- Fixture namespace under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/`.
- Checked-in `expected-wall-seam-summary.tsv`.
- Pure `slic3r_flavors::prusa_wall_seam` parser/readiness boundary.
- Public `//packages/parity:prusaslicer_wall_seam_parity` command.
- Exact `fork.prusaslicer.wall-seam` status row and docs after evidence passes.

### Feature Table Stakes

- Reviewed scope contract with source identity, inventory row, source anchors,
  planned fixture/Rust/parity/status/docs surfaces, security note, deferred
  scope, and reviewer signoff.
- Source-pinned fixture corpus with provenance, update rules, expected summary,
  and explicit runtime/generator/printability/GUI exclusions.
- Pure Rust boundary over caller-supplied checked-in summaries only.
- Public executable evidence with mutation guards and exact status/docs wording.
- Broad `generated-outputs` remains `in progress`; existing
  `fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting` rows stay
  separate.

### Watch Out For

- Do not treat seam observations as geometry, printability, or runtime proof.
- Do not widen existing Prusa generated-output status rows.
- Do not let unknown TSV fields or row-order drift pass.
- Do not run PrusaSlicer, clone/fetch upstream, generate fresh G-code, upload
  to a host, or probe printer behavior.
- Keep requirements, traceability, and phase-summary frontmatter aligned during
  execution so the milestone does not repeat the v1.15 ledger drift.

## Implications For Roadmap

Use four phases:

1. Phase 62: Wall-Seam Scope Contract.
2. Phase 63: Wall-Seam Fixture Corpus.
3. Phase 64: Rust Wall-Seam Evidence Boundary.
4. Phase 65: Executable Wall-Seam Evidence.

Each requirement should map to exactly one phase. The public status row and
docs should wait until Phase 65, after scope, fixture, Rust, and mutation
guards are in place.
