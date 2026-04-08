# Phase 11: CLI Fixture and Status Expansion - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

The safest Phase 11 expansion is to keep one comparison command per supported
slice:

1. keep `cli_version_parity` for the already verified version slice
2. add `cli_help_parity` for the supported help slice
3. add `cli_config_persistence_parity` for the scoped save/load/datadir slice

That makes every verified status row in `status.tsv` point to one explicit
evidence command.
