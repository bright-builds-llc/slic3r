# Phase 5: Entry Surface Architecture - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (direct execution fallback)

<domain>
## Phase Boundary

Carve out contract-oriented Rust modules and define the Rust, Bazel, and
launcher-package boundaries that will support the first preferred non-legacy CLI
slice. This phase defines the architecture and ownership surfaces. It does not
yet claim that the Rust path is the preferred user-facing implementation for any
workflow.

</domain>

<decisions>
## Implementation Decisions

### Contract boundaries

- Separate stable launcher contracts from lower-level implementation code.
- Keep the first stable contract slice intentionally narrow so later parity work
  stays credible.
- Use a contract-oriented crate, a launcher-facing CLI crate, and the existing
  lower-level implementation crate instead of collapsing responsibilities into a
  single binary.

### Launcher ownership

- `packages/launcher` should stop being an empty placeholder in this phase.
- Bazel owns the runnable target surface; future shell shims remain thin and are
  documented as a boundary rather than as an implementation requirement in this
  phase.
- Unsupported CLI behavior remains legacy-owned until later phases migrate it.

### Phase 6 handoff

- The first supported Rust-backed workflow in the next phase will be the
  `--version` slice.
- Phase 5 should make that implementation straightforward without overstating
  current parity.

</decisions>

<specifics>
## Specific Ideas

- Add a new `slic3r_contracts` crate for stable launcher-facing types.
- Add a new `slic3r_cli` crate for the process-facing CLI shell.
- Add a dedicated architecture doc under `docs/port/`.

</specifics>

<deferred>
## Deferred Ideas

- Do not claim a supported Rust-backed CLI workflow yet.
- Do not add parity status or fixture harness behavior in this phase.

</deferred>

______________________________________________________________________

*Phase: 05-entry-surface-architecture*
*Context gathered: 2026-04-08*
