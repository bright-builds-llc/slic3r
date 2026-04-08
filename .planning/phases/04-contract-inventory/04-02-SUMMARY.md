______________________________________________________________________

phase: 04-contract-inventory
plan: "02"
subsystem: docs
tags: [migration-guidance, docs, launcher, parity, fixtures]
requires:

- phase: 04-01
  provides: Evidence-backed contract registry and updated parity dashboard
  provides:
- `docs/port/migration-guidance.md`
- Updated `docs/port/README.md`
- Updated `docs/port/checklist.md`
- Updated `docs/port/package-map.md`
  affects: [05-entry-surface-architecture, 06-macos-cli-parity-slice, 07-parity-visibility, 08-differential-parity-harness]
  tech-stack:
  added: [Phase 4 migration guidance in docs/port]
  patterns: [launcher contract over implementation, fixture protocol before fixture corpus, placeholder-package conservatism]
  key-files:
  created:
  \[
  docs/port/migration-guidance.md,
  \]
  modified:
  \[
  docs/port/README.md,
  docs/port/checklist.md,
  docs/port/package-map.md,
  \]
  key-decisions:
- "Document launcher replacement in user-visible terms rather than Perl implementation terms."
- "Treat packages/launcher, packages/parity, and packages/parity-fixtures as future owner boundaries until they contain real code."
  patterns-established:
- "Migration guidance and control-plane docs move together."
- "Fixture protocol can be documented before the fixture corpus exists."
  requirements-completed: [DOCS-03]
  duration: 1 wave
  completed: 2026-04-08

______________________________________________________________________

# Phase 04: Contract Inventory Summary

**Migration guidance and control-plane routing added without overstating implementation progress**

## Accomplishments

- Added `docs/port/migration-guidance.md` with explicit sections for launcher
  replacement, parity strategy, fixture update protocol, and scope now versus
  deferred
- Updated `docs/port/README.md` so the contract registry and migration guidance
  are first-class docs in the control-plane index
- Updated `docs/port/checklist.md` to reflect the new contract and guidance
  surfaces while keeping future launcher and parity implementation work
  unchecked
- Updated `docs/port/package-map.md` so placeholder packages are described as
  future owner boundaries rather than implemented parity surfaces

## Verification

- `mdformat --check docs/port/migration-guidance.md docs/port/README.md docs/port/checklist.md docs/port/package-map.md`
- `rg -n "^## Launcher Replacement$|^## Parity Strategy$|^## Fixture Update Protocol$|^## Scope Now vs Deferred$" docs/port/migration-guidance.md`
- `rg -n "contract-inventory\\.md|migration-guidance\\.md|packages/launcher|packages/parity-fixtures" docs/port/README.md docs/port/checklist.md docs/port/package-map.md`

## Notes

- The docs now explain how later phases should use the package boundaries without
  pretending those placeholder packages already deliver user-visible behavior
- The fixture protocol is process-first in this phase; the actual corpus still
  belongs to later phases

______________________________________________________________________

*Plan: 04-02*
*Summary created: 2026-04-08*
