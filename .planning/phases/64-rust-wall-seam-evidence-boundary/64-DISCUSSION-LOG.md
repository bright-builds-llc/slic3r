# Phase 64: Rust Wall-Seam Evidence Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in `64-CONTEXT.md`; this log
> preserves the alternatives considered.

**Date:** 2026-06-30T22:34:45.280Z
**Phase:** 64-Rust Wall-Seam Evidence Boundary
**Mode:** Yolo
**Areas discussed:** Rust boundary placement, Parser contract and typed values, Readiness and registry metadata, Verification and guards, Phase 65 handoff

## Rust boundary placement

| Option | Description | Selected |
|--------|-------------|----------|
| New `prusa_wall_seam` module | Keep wall seam in a separate `slic3r_flavors` module with its own parser/readiness surface. | yes |
| Extend `prusa_gcode_output.rs` | Treat wall seam as another G-code output parser branch. |  |
| Extend `prusa_arc_fitting.rs` | Reuse the closest feature-specific generated-output parser directly. |  |

**User's choice:** Auto-selected the new `prusa_wall_seam` module.
**Notes:** This follows Phase 62/63 separation and avoids widening existing
G-code output or arc-fitting evidence rows.

## Parser contract and typed values

| Option | Description | Selected |
|--------|-------------|----------|
| Closed typed TSV parser | Parse the Phase 63 six-column long-row TSV with closed enums and exact fail-closed checks. | yes |
| Loose string map | Keep values as ad hoc strings keyed by field name. |  |
| JSON conversion | Convert the TSV into a JSON-like intermediate before typing. |  |

**User's choice:** Auto-selected the closed typed TSV parser.
**Notes:** The accepted approach matches existing `slic3r_flavors` parser
patterns and makes unsupported fields, wrong order, and unsupported boundary
claims fail clearly.

## Readiness and registry metadata

| Option | Description | Selected |
|--------|-------------|----------|
| Developer-facing readiness only | Add static metadata and registry visibility without public status publication. | yes |
| Publish public status now | Add `fork.prusaslicer.wall-seam` as verified in Phase 64. |  |
| Keep metadata private | Add parser code only and defer all registry visibility. |  |

**User's choice:** Auto-selected developer-facing readiness only.
**Notes:** This preserves the Phase 65 publication gate while letting
developers inspect source, fixture, expected summary, planned command, planned
status token, and deferred surfaces.

## Verification and guards

| Option | Description | Selected |
|--------|-------------|----------|
| Cargo plus Bazel focused coverage | Add crate integration tests, Bazel `rust_test` wiring, registry tests, and aggregate verify coverage. | yes |
| Cargo-only coverage | Add Rust tests but leave Bazel aggregate wiring for later. |  |
| Verifier-only coverage | Rely on the Phase 63 Bash verifier and skip Rust invalid-row tests. |  |

**User's choice:** Auto-selected Cargo plus Bazel focused coverage.
**Notes:** Phase 64 requirements explicitly require Cargo and Bazel coverage
for valid wall-seam fixture rows, invalid fail-closed rows, naming clarity,
and no-overclaiming public helper names.

## Phase 65 handoff

| Option | Description | Selected |
|--------|-------------|----------|
| Strict Phase 65 handoff | Keep public command, mutation guards, status row, and public docs deferred to Phase 65. | yes |
| Partial publication | Add some public docs or status wording during Phase 64. |  |
| Merge with executable evidence | Collapse Phase 64 and Phase 65 into one implementation phase. |  |

**User's choice:** Auto-selected strict Phase 65 handoff.
**Notes:** The roadmap fixes Phase 64 as Rust boundary/readiness work and
Phase 65 as executable evidence/status/docs publication.

## the agent's Discretion

- Exact enum, struct, parser error, and helper names are delegated to the
  planner/executor, with the no-overclaiming naming constraints in
  `64-CONTEXT.md`.
- A developer-facing summary binary is optional and should be added only if it
  materially helps Phase 64 acceptance criteria without creating the public
  Phase 65 parity command.

## Deferred Ideas

- Public wall-seam parity command, public mutation guards, exact public status
  row, and public docs remain Phase 65 work.
- Broader wall-seam behavior, byte parity, geometry equivalence,
  printability, runtime, GUI, support generation, non-Prusa fork behavior, and
  upstream import/sync behavior remain outside v1.16 Phase 64 scope.
