# Parity Fixtures Package

`packages/parity-fixtures` is the home for shared legacy-versus-Rust fixture
corpora.

## Fixture Rules

- Group fixtures by contract surface first, then by scenario.
- Record provenance for every fixture: the legacy command, source file, or other
  contract anchor that produced it.
- Update the relevant `docs/port/` surfaces whenever a fixture-backed parity
  workflow is added or changed.

## Current State

- Phase 7 defines the package and workflow rules.
- Phase 8 seeds the first shared CLI fixture corpus for `--version`.
- Phase 11 expands the shared fixture corpus to cover `--help` and scoped
  config persistence behavior.
