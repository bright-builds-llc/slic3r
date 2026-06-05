# PrusaSlicer Project-File Fixture

Phase 42 supplies fixture bytes and presence-level expected artifacts only.
Executable project-file parity is provided by
`bazel run //packages/parity:prusaslicer_project_file_parity` for the narrow
expected-summary evidence slice.

## Provenance

- Vendor ID: `prusaslicer`
- Inventory ID: `prusaslicer.project-file`
- Source ref: prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961
- Accepted tag: `version_2.9.5`
- Peeled commit: `9a583bd438b195856f3bcf7ea99b69ba4003a961`
- Source path: tests/data/seam_test_object.3mf
- Fixture: `seam_test_object.3mf`
- Expected artifact: `expected-project-summary.tsv`
- Byte count: `2514963`
- SHA-256:
  `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`
- Phase 41 scope record: packages/prusa-project-file-scope/project-file-scope.md
- License/provenance note: `AGPL-3.0-only`;
  `metadata-only-not-legal-review`.

## Update Route

Update route: update this fixture only after a reviewed intake change updates packages/fork-vendors/forks.tsv, packages/fork-inventories/prusaslicer.tsv, and packages/prusa-project-file-scope/project-file-scope.md.
Branch-head observations remain drift-only and do not update this fixture.

## Status Boundary

Phase 42 supplies fixture bytes and presence-level expected artifacts only.
Executable project-file parity is provided by
`bazel run //packages/parity:prusaslicer_project_file_parity` for the narrow
expected-summary evidence slice.
This namespace does not publish executable parity, parser readiness, generated
output, or runtime support.
No generated output is introduced or verified by this namespace.

Verifier command:
`bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture`.

## Exclusions

This fixture package does not introduce full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export, generated-output parity, STEP import, support generation, arc fitting, wall seam behavior, network/device integration, profile auto-update execution, fork release builds, Bambu Studio support, OrcaSlicer support, upstream source imports, or sync automation.
