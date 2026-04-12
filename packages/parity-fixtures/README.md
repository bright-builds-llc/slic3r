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
- Phase 14 expands the shared fixture corpus to cover the scoped export
  workflows and the scoped transform/info workflows.
- Phase 19 expands the shared fixture corpus to cover the scoped macOS packaged
  launcher slice.
- Phase 20 extends the packaged launcher fixtures to cover representative
  packaged config persistence through the startup shim.
- Phase 22 adds a Linux runtime parity bundle that reuses the verified
  help/version/config/export/transform fixtures for the preferred Linux launcher path.
- Phase 25 adds a Windows runtime parity bundle that reuses the verified
  help/version/config/export/transform fixtures for the preferred Windows
  runtime path.
