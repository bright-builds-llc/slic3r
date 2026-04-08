# Phase 7: Parity Visibility - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (direct execution fallback)

<domain>
## Phase Boundary

Make migration progress and fixture discipline visible through a parity status
command and documented update workflow.

</domain>

<decisions>
## Implementation Decisions

- Status output should come from a checked-in data source, not inferred ad hoc at
  runtime.
- The status command should stay conservative and text-first.
- The fixture package should have contributor-facing provenance and update rules
  before the first corpus lands.

</decisions>

______________________________________________________________________

*Phase: 07-parity-visibility*
*Context gathered: 2026-04-08*
