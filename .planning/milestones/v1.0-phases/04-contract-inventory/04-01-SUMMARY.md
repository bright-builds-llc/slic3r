______________________________________________________________________

phase: 04-contract-inventory
plan: "01"
subsystem: docs
tags: [contract-inventory, parity-matrix, docs, parity-evidence]
requires:

- phase: 02-03
  provides: Trusted-versus-deferred oracle vocabulary in docs
- phase: 03-03
  provides: Phase 3 control-plane layout in docs/port
  provides:
- `docs/port/contract-inventory.md`
- Updated `docs/port/parity-matrix.md`
- Evidence-backed inventory for all six external parity surface families
  affects: [05-entry-surface-architecture, 06-macos-cli-parity-slice, 07-parity-visibility, 08-differential-parity-harness]
  tech-stack:
  added: [Phase 4 contract registry in docs/port]
  patterns: [source-of-truth versus trusted-check separation, dashboard versus registry split, conservative parity wording]
  key-files:
  created:
  \[
  docs/port/contract-inventory.md,
  \]
  modified:
  \[
  docs/port/parity-matrix.md,
  \]
  key-decisions:
- "Keep the parity matrix as the short dashboard and move contract detail into a dedicated registry."
- "Separate legacy source of truth from trusted and deferred evidence for every contract row."
  patterns-established:
- "Phase docs may inventory surfaces before any Rust-backed implementation exists."
- "Trusted oracle evidence and broader deferred evidence are documented separately."
  requirements-completed: [PARI-01]
  duration: 1 wave
  completed: 2026-04-08

______________________________________________________________________

# Phase 04: Contract Inventory Summary

**Detailed parity contract inventory added, with the parity matrix retained as a conservative dashboard**

## Accomplishments

- Added `docs/port/contract-inventory.md` as the detailed registry for CLI
  behavior, config semantics, supported file formats, generated outputs,
  launcher path, and packaging-visible behavior
- Gave every contract row separate columns for the legacy source of truth, the
  current trusted check, evidence status, weaker or deferred evidence, and the
  future owner boundary
- Updated `docs/port/parity-matrix.md` to stay a short status dashboard that
  points readers to the detailed registry instead of absorbing that detail
- Kept all surface statuses conservative: Phase 4 inventories the contracts but
  does not claim any Rust-backed parity

## Verification

- `mdformat --check docs/port/contract-inventory.md docs/port/parity-matrix.md`
- `rg -n "## CLI Behavior|## Config Semantics|## Supported File Formats|## Generated Outputs|## Launcher Path|## Packaging-Visible Behavior" docs/port/contract-inventory.md`
- `rg -n "contract-inventory\\.md|//:legacy_oracle_smoke|//:legacy_oracle_test" docs/port/parity-matrix.md`

## Notes

- The trusted macOS oracle remains intentionally narrow: `//:legacy_oracle_smoke`
- Richer legacy evidence stays visible in the inventory, but it is marked as
  weaker or deferred rather than promoted to trusted proof

______________________________________________________________________

*Plan: 04-01*
*Summary created: 2026-04-08*
