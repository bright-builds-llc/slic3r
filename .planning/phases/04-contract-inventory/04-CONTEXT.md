# Phase 4: Contract Inventory - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (yolo discuss)

<domain>
## Phase Boundary

Define the exact parity surfaces and migration guidance so implementation work is driven by contracts instead of assumptions. This phase should inventory externally observable legacy contracts, map them to concrete source-of-truth evidence, and document how the migration preserves or defers them. It should not implement new Rust parity behavior yet.

</domain>

<decisions>
## Implementation Decisions

### Contract taxonomy

- The primary parity surfaces for this phase are externally observable ones only: CLI behavior, config semantics, supported file formats, generated outputs, launcher path, and packaging-visible behavior.
- Internal build plumbing, Bazel scaffolding, and temporary migration mechanics are evidence sources, not parity surfaces in their own right.
- The inventory should be organized by user- or integrator-visible contract surface, not by implementation language or directory.

### Evidence standard

- Every inventory claim should point to concrete source-of-truth evidence in the repo: files, commands, or retained oracle labels.
- The contract inventory should distinguish between “currently trusted oracle evidence” and “legacy surface exists but evidence is weaker or deferred.”
- Broad claims without concrete file or command anchors should be avoided.

### Deferred and unsupported handling

- Deferred or unstable surfaces must be stated plainly rather than hidden behind optimistic language.
- The broader retained legacy test wrapper should remain documented as deferred evidence, not as a trusted parity signal.
- Phase 4 should explain which surfaces are in scope for upcoming migration work versus later milestones.

### Migration guidance shape

- The migration guidance should emphasize preserving user-visible contracts, not preserving the old Perl or legacy implementation mechanics.
- Launcher guidance should explicitly describe that the user-facing contract matters more than the Perl implementation path.
- The docs should remain conservative: do not imply Rust-backed parity for any surface that is still legacy-only.

### the agent's Discretion

- Exact filenames for the new contract inventory and migration guidance docs
- Exact table schema or section ordering, as long as the contract surfaces, evidence model, and deferred-state guidance remain explicit
- Whether to update existing `docs/port/*` files in place or introduce one or two new docs under `docs/port/` to hold the richer inventory and guidance

</decisions>

<specifics>
## Specific Ideas

- The parity inventory should likely become the main bridge between the current `docs/port/parity-matrix.md` and later implementation phases.
- The strongest evidence model is probably “surface → current source of truth → trusted check/evidence → deferred notes → future owner.”
- This phase should leave the repo with something a planner can use to scope later CLI, launcher, and output-parity work without rereading the entire legacy tree.

</specifics>

<deferred>
## Deferred Ideas

- Do not implement new Rust parity behavior in this phase.
- Do not broaden the parity matrix to claim verified Rust-backed surfaces before later implementation phases land.

</deferred>

---

*Phase: 04-contract-inventory*
*Context gathered: 2026-04-08*
