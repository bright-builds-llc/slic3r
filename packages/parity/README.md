# Parity Package

`packages/parity` owns migration visibility surfaces.

## Current Surface

- `bazel run //packages/parity:status` prints the current parity status table.
- `bazel run //packages/parity:cli_version_parity` runs the shared fixture
  comparison for the supported `--version` slice.
- `bazel run //packages/parity:cli_help_parity` runs the shared fixture
  comparison for the supported `--help` slice.
- `bazel run //packages/parity:cli_config_persistence_parity` runs the shared
  fixture comparison for the scoped config persistence slice.
- `bazel run //packages/parity:export_workflows_parity` runs the shared fixture
  comparison for the scoped export workflows.
- `bazel run //packages/parity:transform_workflows_parity` runs the shared
  fixture comparison for the scoped transform/info workflows.
- `bazel run //packages/parity:macos_packaged_launcher_parity` runs the shared
  parity evidence for the scoped macOS packaged launcher slice, including one
  representative packaged config persistence flow.
- `status.tsv` is the checked-in data source for that command.

## Scope

- Keep status reporting conservative.
- Do not mark a slice `verified` until the shared fixture comparison exists.
