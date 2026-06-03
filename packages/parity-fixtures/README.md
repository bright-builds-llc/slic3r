# Parity Fixtures Package

`packages/parity-fixtures` is the home for shared legacy-versus-Rust fixture
corpora.

## Fixture Rules

- Group fixtures by contract surface first, then by scenario.
- Record provenance for every fixture: the legacy command, source file, or other
  contract anchor that produced it.
- Update the relevant `docs/port/` surfaces whenever a fixture-backed parity
  workflow is added or changed.

## Fork Fixture Namespace

Fork parity fixtures are reserved under:

```text
packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/
```

Phase 38 creates the first real fork fixture namespace at
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`.
It contains raw static `PrusaResearch.ini` and `PrusaResearch.idx` inputs from
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
Phase 40 adds `expected-summary.tsv` as the checked-in expected artifact for the
narrow Prusa profile-schema parser/config evidence slice only, verified by
`bazel run //packages/parity:prusaslicer_profile_schema_parity`.

Phase 42 adds the Prusa project-file fixture namespace at
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`. It
contains the checked-in `seam_test_object.3mf` fixture,
`fixture-provenance.tsv`, and `expected-project-summary.tsv` for the fixture
surface only. The fixture bundle target is
`//packages/parity-fixtures:prusa_project_file_bundle`, and maintainers can
verify the fixture surface with
`bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture`.
Executable project-file parity remains unavailable until Phase 44.

Update route: update only after a reviewed intake change updates packages/fork-vendors/forks.tsv and the Prusa checklist/baseline gate.
Branch-head observations remain drift-only.
Fixture verification does not fetch upstream source, run profile auto-update execution, or ingest plugins.

This fixture package does not introduce Bambu Studio fixtures, OrcaSlicer fixtures, network/device integration, cloud behavior, credentials, profile auto-update execution, non-free plugin ingestion, full PrusaSlicer runtime support, GUI support, sync automation, or fork release packaging. The narrow parser/config evidence is verified, and full PrusaSlicer runtime support remains deferred.

The fixture provenance cites the accepted upstream source URLs and
`metadata-only-not-legal-review`; it is provenance for static fixture inputs,
not legal-review completion.

Other fork fixture namespaces remain future-only until a fork feature has an
executable parity command, a reviewed checklist, and a matching future status
row. Source pins, inventories, templates, and registry metadata do not justify
additional fixture files by themselves.

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
- Phase 29 adds Linux and Windows packaged launcher fixture bundles:
  `linux-packaged-launcher` is verified by
  `//packages/parity:linux_packaged_launcher_parity`, and
  `windows-packaged-launcher` is verified by
  `//packages/parity:windows_packaged_launcher_parity`.
- Phase 38 adds the Prusa profile-schema fixture bundle under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`,
  exported as `//packages/parity-fixtures:prusa_profile_schema_bundle` and
  checked by `//packages/parity-fixtures:verify_prusa_profile_schema_fixture`.
- Phase 40 adds `expected-summary.tsv` to that bundle and verifies it through
  `bazel run //packages/parity:prusaslicer_profile_schema_parity`.
- Phase 42 adds the Prusa project-file fixture namespace under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`,
  exported as `//packages/parity-fixtures:prusa_project_file_bundle` and
  checked by
  `bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture`.
