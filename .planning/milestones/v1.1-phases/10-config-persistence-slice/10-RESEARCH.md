# Phase 10: Config Persistence Slice - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

The legacy config flow is centered on `new_from_cli`, `load`, `save`, and
ordered application of external configs on top of defaults. The safest next
slice is:

1. parse explicit save/load/datadir commands in the launcher contract layer
2. implement deterministic file-based persistence in the Rust CLI shell
3. keep the file format intentionally simple and reviewable in this phase
4. defer broader option parity and full config semantics verification to the
   fixture/status expansion phase
