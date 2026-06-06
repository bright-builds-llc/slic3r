# Phase 43: Rust Prusa Project-File Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in CONTEXT.md; this log preserves
> the alternatives considered.

**Date:** 2026-06-05T13:02:42.920Z
**Phase:** 43-Rust Prusa Project-File Boundary
**Mode:** Yolo
**Areas discussed:** Rust boundary placement, Project summary shape, Provenance
and traceability, Verification shape, Documentation and scope control

---

## Rust Boundary Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse `slic3r_flavors` | Add `slic3r_flavors::prusa_project_file`, mirroring the existing pure `prusa_profile` boundary. | yes |
| Create a new Rust crate | Isolate project-file logic in a new crate, increasing Bazel/Cargo wiring for a narrow evidence slice. | |
| Defer Rust surface to Phase 44 | Keep Phase 43 as docs only, leaving no typed boundary for executable parity. | |

**User's choice:** Auto-selected `Reuse slic3r_flavors`.
**Notes:** This matches Phase 39 precedent and keeps the boundary pure and
small.

---

## Project Summary Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Parse Phase 42 expected TSV | Convert `expected-project-summary.tsv` rows into typed Rust values and summary lines. | yes |
| Parse full 3MF ZIP container | Add or build a ZIP/container parser now for archive-level extraction. | |
| Keep raw strings only | Expose unvalidated row strings without typed errors or required-column checks. | |

**User's choice:** Auto-selected `Parse Phase 42 expected TSV`.
**Notes:** This satisfies the phase's "parse or summarize" boundary while
avoiding new runtime/file-format semantics before Phase 44.

---

## Provenance and Traceability

| Option | Description | Selected |
|--------|-------------|----------|
| Full typed metadata | Expose inventory, source ref, source path, fixture path, expected summary path, scope record, and reserved status token. | yes |
| Minimal metadata | Track only source ref and fixture path. | |
| Runtime TSV lookup | Read inventory/provenance TSV files at runtime. | |

**User's choice:** Auto-selected `Full typed metadata`.
**Notes:** The selected metadata shape keeps traceability inspectable without
runtime file discovery or TSV parsing.

---

## Verification Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Focused Rust tests plus Bazel/Cargo wiring | Add one-concern parser, metadata, error, and checked-in fixture summary tests. | yes |
| Only aggregate `//packages/slic3r-rust:verify` | Rely on broad verification with no narrow target coverage. | |
| Shell-only verification | Keep the Rust boundary untested and rely on Phase 42 shell verifier behavior. | |

**User's choice:** Auto-selected `Focused Rust tests plus Bazel/Cargo wiring`.
**Notes:** This follows Bright Builds testing guidance and Phase 39 Rust
verification precedent.

---

## Documentation and Scope Control

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal docs update with deferred scope | Update Rust/package and port docs only enough to describe the boundary and preserve Phase 44 status gating. | yes |
| Broad parity docs | Publish project-file behavior as verified parity before executable evidence exists. | |
| No docs update | Leave maintainers without a discoverable handoff from Phase 43 to Phase 44. | |

**User's choice:** Auto-selected `Minimal docs update with deferred scope`.
**Notes:** The docs must not overclaim full 3MF import/export, GUI behavior,
generated output, or runtime support.

---

## the agent's Discretion

- Exact Rust type names and helper names.
- Whether known archive members use an enum or validated string newtype.
- Minimum doc set to update while preserving the narrow evidence boundary.

## Deferred Ideas

- Full PrusaSlicer runtime support.
- GUI project behavior.
- Full 3MF import/export.
- Generated-output parity.
- STEP import, support generation, arc fitting, and wall seam behavior.
- Network/device integration and profile auto-update execution.
- Fork release builds, non-Prusa ports, upstream source imports, and sync
  automation.
