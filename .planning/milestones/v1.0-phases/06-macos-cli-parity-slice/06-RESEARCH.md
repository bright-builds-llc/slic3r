# Phase 06: macOS CLI Parity Slice - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

Phase 5 already created the needed boundaries. The smallest credible Rust-backed
CLI slice is `--version` because:

- the legacy contract is stable and easy to observe
- the output is a single line from the retained legacy implementation
- the launcher package already points at the Rust CLI target
- later parity tooling can compare this slice mechanically without inventing a
  large fixture corpus first

That makes `--version` the right Phase 6 workflow and leaves help, config,
slicing, and export behavior to later phases.

______________________________________________________________________

*Phase: 06-macos-cli-parity-slice*
*Research completed: 2026-04-08*
