# v1.11 Architecture Research: PrusaSlicer Broader Parity Port

**Project:** Slic3r Rust Port
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Researched:** 2026-06-02

## Architecture Direction

v1.11 should extend the existing fork evidence architecture instead of adding a
new Prusa subsystem. The architecture should remain fixture-first and
capability-oriented:

1. `packages/prusa-baseline` records the reviewed checklist gate for the
   selected project-file slice.
1. `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`
   owns checked-in fixture inputs, provenance, expected artifacts, and fixture
   verification.
1. `packages/slic3r-rust/crates/slic3r_flavors` owns typed project-file
   summary or parser logic and metadata traceability.
1. `packages/parity` owns the public Bazel parity command and exact status row.
1. `docs/port/*` owns human-readable scope, deferrals, and package routing.

## Boundary Rules

- Keep Prusa source references as accepted metadata and checked-in fixture
  artifacts, not vendored upstream source trees.
- Parse raw fixture/source strings at the flavor boundary before data reaches
  shared core logic.
- Keep `slic3r_core` free of raw Prusa source refs, inventory IDs, branch
  names, and package paths.
- Keep Git, network, filesystem discovery, process execution, release, and
  sync automation out of Rust domain logic.
- Use parity commands for evidence, not planning documents or registry rows.

## Proposed Phase Flow

### Phase 41: Project-File Scope Gate

Create a reviewed Prusa project-file checklist record and select the exact
fixture/expected-artifact contract. This phase prevents the rest of v1.11 from
accidentally becoming a full 3MF parser, GUI project loader, or generated
output milestone.

### Phase 42: Project-File Fixture Surface

Add the Prusa project-file fixture namespace, provenance, update rules, and
fixture verifier. The fixture should be traceable to the accepted Prusa source
pin or to a documented reviewed sample source approved by the Phase 41 gate.

### Phase 43: Rust Project-File Boundary

Add a typed Rust summary/parser boundary for exactly the selected project-file
evidence contract. The parser should be side-effect-free and should include
focused Rust tests for malformed input and traceability metadata.

### Phase 44: Executable Project-File Parity

Add the public Bazel parity command, divergence guard, exact status row, and
port docs. This phase is the only point where the project-file slice may become
`verified`.

## Success Shape

The end state should mirror v1.10:

- One stable status token, likely `fork.prusaslicer.project-file`.
- One public command, likely
  `bazel run //packages/parity:prusaslicer_project_file_parity`.
- One checked-in expected artifact under the Prusa fixture namespace.
- One typed Rust metadata/summary function with tests.
- Docs that describe the verified evidence slice and list all deferred Prusa
  surfaces.
