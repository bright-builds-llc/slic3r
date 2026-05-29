# Phase 35: Flavor Registry Boundary - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-05-27T11:29:50.942Z
**Phase:** 35-flavor-registry-boundary
**Mode:** Yolo
**Areas discussed:** Registry package boundary, Registry metadata model,
Side-effect and source-of-truth boundary, Verification and documentation shape

---

## Registry Package Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| New `slic3r_flavors` crate depending on `slic3r_contracts` | Keeps typed contracts separate from composition, gives the registry a pure test surface, and avoids vendor-specific Rust workspaces. | yes |
| `slic3r_contracts::flavor::registry` module | Lowest package churn, but blurs contract parsing with registry composition. | |
| `slic3r_core::flavors` module | Close to future core consumers, but risks leaking vendor metadata into shared core behavior. | |
| Checked-in metadata package with generated Rust facade | Keeps metadata near intake packages, but adds generation/parsing complexity for a pure registry phase. | |

**User's choice:** Auto-selected recommended default: new
`slic3r_flavors` crate depending on `slic3r_contracts`.
**Notes:** Advisor research found that Phase 35 success criteria need a
developer-facing registry composition boundary, not another contract parser or
core behavior module.

---

## Registry Metadata Model

| Option | Description | Selected |
|--------|-------------|----------|
| Flat capability records under `FlavorRegistryEntry` | Capability-oriented, one query/filter path, and reuses existing typed contract values. | yes |
| Layered entry fields: `base`, `shared_downstream`, `fork_specific` | Mirrors the phase wording directly, but duplicates classification and makes aggregation harder. | |
| Tagged enum metadata | Strong type-level separation, but more ceremony than this metadata-only phase needs. | |
| Generated static registry from Phase 32/33 TSVs | Avoids hand transcription, but adds generator and build-system complexity too early. | |

**User's choice:** Auto-selected recommended default: flat capability records
under a registry entry root.
**Notes:** Keep source refs and ownership on records so metadata remains
traceable even when the base flavor itself has no downstream fork identity.

---

## Side-effect and Source-of-Truth Boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Static typed Rust registry | Pure data boundary, no runtime I/O or parser failures, and matches the Phase 34 typed-value pattern. | yes |
| Runtime TSV parsing with embedded `include_str!` data | Keeps TSVs primary but adds parser/error semantics to a pure registry boundary. | |
| Generated Rust code/data from TSVs | Scales better later but adds generator ownership and drift checks now. | |

**User's choice:** Auto-selected recommended default: static typed Rust
registry.
**Notes:** Prior phases already made TSVs checked-in planning inputs. Phase 35
should trace to them without parsing them at runtime.

---

## Verification and Documentation Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Extend `slic3r_contracts` with registry tests | Smallest Rust surface, but weakens the module boundary. | |
| Add pure `slic3r_flavors` crate in the same Rust workspace | Clearest boundary, easy Cargo/Bazel verification, and no fork-specific workspaces. | yes |
| Data-first registry verifier under inventory/vendor packages | Strong traceability, but less useful as a Rust module boundary. | |
| Parity-style launcher/runtime fixture tests | Useful later, but overclaims runtime fork parity now. | |

**User's choice:** Auto-selected recommended default: add a pure
`slic3r_flavors` crate with focused tests and docs.
**Notes:** Verification should use crate-local Rust tests plus the existing
`//packages/slic3r-rust:verify` aggregate target. Docs must preserve the
metadata-only/no-runtime-parity boundary.

---

## the agent's Discretion

- Exact type and accessor names are left to the planner and executor as long as
  the registry API is easy to inspect and stays pure.
- The planner may choose a small representative static registry subset if it
  proves all Phase 35 success criteria without implying exhaustive runtime
  support.

## Deferred Ideas

- Generated registry data from TSVs belongs in a later phase if registry volume
  grows.
- Runtime fork behavior, launcher dispatch, release builds, and executable fork
  parity remain future scope.
