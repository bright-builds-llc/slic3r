# Phase 1: Foundation - Context

**Gathered:** 2026-04-06
**Status:** Ready for planning

<domain>
## Phase Boundary

Establish the Bazel root, `packages/` monorepo layout, and initial migration docs/checklists so the repository has one coherent modernization surface. This phase defines the foundational repo shape and contributor-facing migration surface; it does not add new product capabilities, GUI work, or non-macOS parity work.

</domain>

<decisions>
## Implementation Decisions

### Package layout

- The initial `packages/` set is exactly: `packages/legacy-slic3r`, `packages/slic3r-rust`, `packages/launcher`, `packages/parity`, and `packages/parity-fixtures`.
- Shared repo-level assets stay at the root: Bazel root files, `docs/`, `tools/`, and normal repo metadata should not be turned into packages.
- The Rust side starts as one top-level package, `packages/slic3r-rust`, with an internal Cargo workspace rather than multiple top-level Rust packages in Phase 1.
- The legacy source tree should move mostly as-is into `packages/legacy-slic3r/` during Phase 1 rather than being cleaned up or reshaped.

### Legacy package presentation

- The retained legacy implementation should be named exactly `packages/legacy-slic3r` and consistently described as the legacy reference package.
- Phase 1 should add a package-local README and a top-level migration note that clearly state the legacy package is the retained behavioral oracle and that new feature work targets the Rust implementation unless explicitly noted.
- Legacy code may only receive minimal relocation or integration changes needed to keep it buildable under Bazel, and those changes should be documented as parity-preserving.
- The legacy package should remain visible in the repo tree and fenced by naming and docs, not hidden or treated like dead code.

### Bazel entrypoint surface

- Phase 1 should establish a small but real top-level Bazel surface: `bazel build //...`, `bazel test //...`, and a small set of named package targets that make the monorepo structure discoverable.
- Bazelisk plus `.bazelversion` should be the default contributor path on macOS.
- The repo should document explicit preferred top-level targets for legacy build/test, Rust sanity checks, a launcher placeholder, and a parity placeholder or status target, even if some are thin wrappers at first.
- Phase 1 should not attempt to wrap every legacy script perfectly; it should establish the canonical Bazel interface and enough working targets to anchor later phases.

### Migration docs shape

- `docs/port/` should start with exactly four files: `README.md`, `checklist.md`, `parity-matrix.md`, and `package-map.md`.
- The checklist should be organized by migration surface, not by generic tasks. The expected surfaces are Bazel root, legacy package, Rust workspace, launcher, parity tooling, and docs.
- The parity matrix should explicitly track contract surfaces such as CLI behavior, config semantics, file formats, generated outputs, launcher path, and packaging-visible behavior.
- The default parity-matrix statuses are `legacy-only`, `in progress`, `rust-backed`, and `verified`.
- The review expectation for Phase 1 is that any Rust-port or parity-surface change updates the relevant `docs/port/` files in the same change, but there is no automated enforcement yet.

### Claude's Discretion

- Exact Bazel target names and how they are grouped across root and package-level `BUILD` files
- Exact formatting, wording, and visual structure of the `docs/port/` pages and checklists
- Exact internal crate names and folder decomposition inside `packages/slic3r-rust`, as long as the one-package-with-internal-workspace decision is preserved

</decisions>

<specifics>
## Specific Ideas

- The recommended initial package set should be used as the visible monorepo skeleton from the start: `packages/legacy-slic3r`, `packages/slic3r-rust`, `packages/launcher`, `packages/parity`, and `packages/parity-fixtures`.
- The legacy package should be described in human-readable docs as the retained behavioral oracle rather than merely an archive.
- Phase 1 should make Bazel feel real quickly through a small canonical surface rather than waiting for complete legacy-script coverage.
- `docs/port/` should act as the visible migration control center, with a migration-surface checklist and an explicit parity matrix.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

______________________________________________________________________

*Phase: 01-foundation*
*Context gathered: 2026-04-06*
