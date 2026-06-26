# Project Research - Architecture

**Project:** Slic3r Rust Port
**Milestone:** v1.16 PrusaSlicer Wall-Seam G-code Evidence Slice
**Researched:** 2026-06-26
**Confidence:** HIGH for phase order and component boundaries.

## Architecture Approach

Use the established four-step Prusa evidence ladder:

1. Scope contract closes allowed fields, traceability, planned paths, status
   wording, deferrals, and verifier rules.
1. Fixture corpus adds source-pinned checked-in evidence bytes and expected
   wall-seam summaries.
1. Rust boundary parses the checked-in summary into closed domain values and
   exposes readiness metadata without side effects.
1. Public evidence publishes a Bazel command, mutation guards, exact status
   row, and docs only after the previous steps pass.

This keeps the functional core in Rust and the imperative shell in Bash/Bazel.

## Proposed Components

### Scope Contract

Ownership should mirror the arc-fitting pattern unless Phase 62 finds a better
repo-local boundary. A likely package is `packages/prusa-wall-seam-scope`.

The scope contract owns:

- `prusaslicer.wall-seam` inventory row and `seam.shared` category-map
  traceability.
- Accepted source identity and source anchors.
- Closed wall-seam field table.
- Planned fixture, expected summary, Rust boundary, public command, and status
  row names.
- Deferred scope and forbidden wording.
- Fail-closed scope verifier and mutation coverage.

### Fixture Corpus

`packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/` owns:

- checked-in fixture bytes or a checked-in expected observation source approved
  by Phase 62,
- `fixture-provenance.tsv`,
- `expected-wall-seam-summary.tsv`,
- update rules,
- README boundary wording,
- fixture verifier and mutation tests.

The fixture verifier should reject missing rows, duplicate rows, out-of-order
rows, unsupported seam fields, unsupported broad claims, wrong source refs,
wrong fixture identities, checksum drift, and stale docs.

### Rust Boundary

`slic3r_flavors::prusa_wall_seam` should parse caller-supplied TSV text into
typed values. It should not discover files, run Git, run PrusaSlicer, generate
G-code, read the network, mutate status, or publish docs.

The boundary should use closed enums/newtypes for seam fields and evidence
rows, and tests should cover valid parse, unknown field, missing row, duplicate
row, row-order drift, wrong source identity, wrong fixture identity, and
unsupported claim text.

### Public Evidence

`packages/parity` should add `prusaslicer_wall_seam_parity` only after the Rust
boundary and fixture verifier are ready. The command validates the checked-in
wall-seam summary through Rust and prints only narrow evidence facts.

Status and docs must publish `fork.prusaslicer.wall-seam` as a separate row.
The existing `fork.prusaslicer.gcode-output` and
`fork.prusaslicer.arc-fitting` rows remain separate verified slices, and broad
`generated-outputs` remains `in progress`.

## Build Order

- Phase 62: scope contract and fail-closed scope verifier.
- Phase 63: fixture corpus and fixture verifier.
- Phase 64: Rust wall-seam summary parser and readiness metadata.
- Phase 65: public parity command, mutation guards, status row, and docs.

## Architecture Constraints

- Keep parser logic pure and testable.
- Keep shell code as path orchestration, temp-file mutation, and command
  invocation only.
- Keep public status/docs publication last.
- Keep broad generated-output, runtime, printability, GUI, release, upstream
  import, sync, and non-Prusa fork claims out of all achieved wording.
