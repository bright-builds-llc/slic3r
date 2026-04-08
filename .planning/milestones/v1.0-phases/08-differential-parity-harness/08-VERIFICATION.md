# Phase 08: Differential Parity Harness - Verification

**Verified:** 2026-04-08
**Status:** passed
**Phase Goal:** Compare the legacy and Rust implementations on a shared fixture corpus for the initial macOS CLI/core workflows.

## Must-Haves Checked

- ✓ Maintainers can execute the shared fixture corpus against both legacy and Rust implementations for the supported `--version` workflow.
- ✓ Comparison results prove pass/fail from the shared fixture rather than manual spot checks.
- ✓ The fixture corpus and comparison command are structured so later phases can expand coverage safely.

## Evidence

- `shfmt -l -d packages/parity/parity_status.sh packages/parity/compare_cli_version.sh` passed
- `./.planning/.tmp/bin/bazelisk run //packages/parity:cli_version_parity` printed `verified cli.version fixture: 1.3.1-dev`
- `./.planning/.tmp/bin/bazelisk run //packages/parity:status` reports `cli.version` as `verified`
- `mdformat --check docs/port/README.md docs/port/checklist.md docs/port/cli-slice.md docs/port/package-map.md docs/port/parity-matrix.md packages/parity/README.md packages/parity-fixtures/README.md` passed

______________________________________________________________________

*Phase: 08-differential-parity-harness*
*Verification completed: 2026-04-08*
