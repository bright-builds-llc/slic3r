# Phase 8: Differential Parity Harness - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (direct execution fallback)

<domain>
## Phase Boundary

Compare the legacy and Rust implementations on a shared fixture corpus for the
initial supported macOS CLI workflow.

</domain>

<decisions>
## Implementation Decisions

- The initial shared fixture corpus is the `--version` slice only.
- The parity harness should compare legacy output, Rust output, and the shared
  expected fixture.
- Status reporting should move the `cli.version` slice from `rust-backed` to
  `verified` only after that harness passes.

</decisions>

______________________________________________________________________

*Phase: 08-differential-parity-harness*
*Context gathered: 2026-04-08*
