# Phase 08: Differential Parity Harness - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

The seeded `--version` slice from Phase 6 and the checked-in status source from
Phase 7 make the final harness straightforward:

1. seed a shared fixture directory under `packages/parity-fixtures`
1. run the retained legacy oracle for `--version`
1. run the Rust launcher for `--version`
1. compare both against the fixture and each other
1. mark `cli.version` as `verified` only after the comparison passes

______________________________________________________________________

*Phase: 08-differential-parity-harness*
*Research completed: 2026-04-08*
