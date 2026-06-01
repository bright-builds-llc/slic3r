# Phase 39: Rust Prusa Profile Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-01T02:49:54.027Z
**Phase:** 39-rust-prusa-profile-boundary
**Mode:** Yolo
**Areas discussed:** Rust boundary placement, Profile fixture parsing and normalization, Provenance and capability traceability, Verification shape, Documentation and scope control

---

## Rust Boundary Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Shared Rust flavor boundary | Add the Phase 39 boundary to the existing shared Rust migration workspace, likely `slic3r_flavors`, reusing typed contract patterns. | x |
| Prusa-only Rust workspace | Create a vendor-specific Rust workspace for Prusa profile parsing. | |
| Direct parity package parser | Put parser logic under `packages/parity` beside shell parity scripts. | |

**User's choice:** Auto-selected shared Rust flavor boundary.
**Notes:** This follows Phase 37's checklist decision: no Prusa-only Rust workspace and no copied upstream source tree.

---

## Profile Fixture Parsing and Normalization

| Option | Description | Selected |
|--------|-------------|----------|
| Narrow fixture-backed parser | Parse the checked-in `PrusaResearch.ini` fixture into typed, conservative Rust values needed for Phase 40 evidence. | x |
| Full Prusa config engine | Implement broad Prusa runtime configuration behavior now. | |
| Metadata-only marker | Add static metadata only without parsing fixture content. | |

**User's choice:** Auto-selected narrow fixture-backed parser.
**Notes:** This satisfies PROF-01 while keeping full runtime behavior and executable parity out of Phase 39.

---

## Provenance and Capability Traceability

| Option | Description | Selected |
|--------|-------------|----------|
| Typed provenance reuse | Reuse `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus` while adding only meaningful newtypes/enums. | x |
| Raw string propagation | Pass source refs, inventory ids, and paths around as untyped strings. | |
| TSV runtime parsing | Load inventory/provenance TSV files at runtime from Rust. | |

**User's choice:** Auto-selected typed provenance reuse.
**Notes:** This follows Bright Builds parse-at-boundaries guidance and the existing Rust contract registry shape.

---

## Verification Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Rust unit/integration tests | Add behavior-focused Rust tests for parser, normalization, provenance, malformed input, and side-effect boundaries, wired through Cargo and Bazel. | x |
| Shell-only verification | Verify the Rust boundary only through shell scripts. | |
| Phase 40-only verification | Defer parser verification until the executable parity command exists. | |

**User's choice:** Auto-selected focused Rust tests.
**Notes:** This satisfies PROF-03 and keeps Phase 40 free to consume the boundary instead of discovering parser gaps.

---

## Documentation and Scope Control

| Option | Description | Selected |
|--------|-------------|----------|
| Parser-boundary docs only | Update docs to name the Phase 39 Rust boundary while explicitly deferring parity command/status publication to Phase 40. | x |
| Publish verified Prusa status now | Add `fork.prusaslicer.profile-schema` as verified in `status.tsv`. | |
| No docs update | Keep all Phase 39 state implicit in Rust code. | |

**User's choice:** Auto-selected parser-boundary docs only.
**Notes:** This preserves Phase 38's status boundary and prevents overclaiming.

---

## the agent's Discretion

- Exact Rust module and file names.
- Exact parser error type names and display text.
- Whether parser tests use small inline fixtures, `include_str!`, or both.
- Exact doc placement, provided Phase 40 parity/status claims remain deferred.

## Deferred Ideas

- Phase 40 executable parity command.
- Phase 40 parity status publication.
- Broader PrusaSlicer runtime behavior and all v1.10 out-of-scope fork work.
