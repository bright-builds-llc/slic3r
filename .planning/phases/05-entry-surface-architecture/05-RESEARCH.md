# Phase 05: Entry Surface Architecture - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

The existing Rust workspace is still a single implementation crate. The legacy
contract inventory and migration guidance already establish that launcher
behavior must be preserved in user-visible terms, while unsupported flows remain
legacy-owned until later phases. The lowest-risk architecture is therefore:

1. `slic3r_contracts` for pure launcher-facing contract parsing.
1. `slic3r_cli` for the process-facing shell that can later become the preferred
   entrypoint for supported slices.
1. `packages/launcher` as the Bazel-facing entry package, with shell shims still
   documented as future-thin boundaries rather than required implementation in
   this phase.

This gives Phase 6 a clear place to land the first supported Rust-backed CLI
workflow without mixing contract parsing, binary entrypoints, and future shell
handoff responsibilities.

______________________________________________________________________

*Phase: 05-entry-surface-architecture*
*Research completed: 2026-04-08*
