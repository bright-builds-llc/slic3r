# Phase 6: macOS CLI Parity Slice - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (direct execution fallback)

<domain>
## Phase Boundary

Deliver the first supported Rust-backed macOS CLI workflow and make it the
preferred invocation for that slice. The supported slice is intentionally narrow
in this phase: `--version`.

</domain>

<decisions>
## Implementation Decisions

### Scope

- The first supported Rust-backed workflow is `--version`.
- Broader CLI behavior remains legacy-owned and explicitly out of scope.
- The preferred invocation for the supported slice is
  `bazel run //packages/launcher:slic3r -- --version`.

### Boundary handling

- Keep contract parsing in `slic3r_contracts`.
- Keep the process-facing output and exit behavior in `slic3r_cli`.
- Keep the launcher package pointing at the Rust path for the supported slice.

</decisions>

<deferred>
## Deferred Ideas

- Do not broaden the supported CLI slice beyond `--version`.
- Do not claim verified parity yet; fixture comparison is Phase 8 work.

</deferred>

______________________________________________________________________

*Phase: 06-macos-cli-parity-slice*
*Context gathered: 2026-04-08*
