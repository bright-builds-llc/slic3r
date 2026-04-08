# Parity Package

`packages/parity` owns migration visibility surfaces.

## Current Surface

- `bazel run //packages/parity:status` prints the current parity status table.
- `bazel run //packages/parity:cli_version_parity` runs the shared fixture
  comparison for the supported `--version` slice.
- `status.tsv` is the checked-in data source for that command.

## Scope

- Keep status reporting conservative.
- Do not mark a slice `verified` until the shared fixture comparison exists.
