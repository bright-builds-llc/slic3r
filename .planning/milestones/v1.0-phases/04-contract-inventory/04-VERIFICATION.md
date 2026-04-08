# Phase 04: Contract Inventory - Verification

**Verified:** 2026-04-08
**Status:** passed
**Phase Goal:** Define the exact parity surfaces and migration guidance so implementation work is driven by contracts instead of assumptions.

## Standards Inputs

- Repo-local guidance from `AGENTS.md`
- Bright Builds workflow guidance from `AGENTS.bright-builds.md`
- Local override surface from `standards-overrides.md`
- Canonical standards pages used for this phase:
  - `standards/index.md`
  - `standards/core/architecture.md`
  - `standards/core/code-shape.md`
  - `standards/core/verification.md`
  - `standards/core/testing.md`

## Must-Haves Checked

### Observable Truths

- ✓ Maintainer can enumerate the exported contracts to preserve, including CLI
  behavior, config semantics, supported file formats, generated outputs,
  launcher path, and packaging-visible behavior
- ✓ Contributors can find written guidance for launcher replacement, parity
  strategy, and fixture update protocol under `docs/port/`
- ✓ The migration docs explain which surfaces are inventoried now versus
  deferred to later implementation phases

### Supporting Artifacts

- ✓ `docs/port/contract-inventory.md`
- ✓ `docs/port/migration-guidance.md`
- ✓ `docs/port/parity-matrix.md`
- ✓ `docs/port/README.md`
- ✓ `docs/port/checklist.md`
- ✓ `docs/port/package-map.md`
- ✓ `.planning/phases/04-contract-inventory/04-01-SUMMARY.md`
- ✓ `.planning/phases/04-contract-inventory/04-02-SUMMARY.md`

### Key Links

- ✓ `docs/port/parity-matrix.md` routes readers to `docs/port/contract-inventory.md`
- ✓ `docs/port/README.md` routes readers to both `docs/port/contract-inventory.md` and `docs/port/migration-guidance.md`
- ✓ `docs/port/migration-guidance.md` and `docs/port/package-map.md` stay aligned on `packages/launcher` and `packages/parity-fixtures` as future owner boundaries

## Evidence

- `mdformat --check docs/port/contract-inventory.md docs/port/parity-matrix.md docs/port/migration-guidance.md docs/port/README.md docs/port/checklist.md docs/port/package-map.md` passed
- `rg -n "## CLI Behavior|## Config Semantics|## Supported File Formats|## Generated Outputs|## Launcher Path|## Packaging-Visible Behavior" docs/port/contract-inventory.md` passed
- `rg -n "contract-inventory\\.md|legacy-only|//:legacy_oracle_smoke|//:legacy_oracle_test|later phases" docs/port/parity-matrix.md` passed
- `rg -n "^## Launcher Replacement$|^## Parity Strategy$|^## Fixture Update Protocol$|^## Scope Now vs Deferred$|packages/parity-fixtures|legacy-only|deferred" docs/port/migration-guidance.md` passed
- `rg -n "contract-inventory\\.md|migration-guidance\\.md|packages/launcher|packages/parity-fixtures|future|legacy-only" docs/port/README.md docs/port/checklist.md docs/port/package-map.md` passed
- `rg -n "^phase: 04-contract-inventory$|^plan: \"0[12]\"$|^type: execute$" .planning/phases/04-contract-inventory/04-01-PLAN.md .planning/phases/04-contract-inventory/04-02-PLAN.md` passed

## Gaps

None.

______________________________________________________________________

*Phase: 04-contract-inventory*
*Verification completed: 2026-04-08*
