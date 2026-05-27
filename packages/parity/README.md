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
- `bazel run //packages/parity:linux_runtime_parity` runs the shared parity
  evidence for the supported Linux launcher/runtime slice.
- `bazel run //packages/parity:windows_runtime_parity` runs the shared parity
  evidence for the supported Windows runtime slice.
- `bazel run //packages/parity:linux_packaged_launcher_parity` runs the shared
  parity evidence for the scoped Linux packaged launcher tree.
- `bazel run //packages/parity:windows_packaged_launcher_parity` runs the
  shared parity evidence for the scoped Windows packaged launcher tree.
- `status.tsv` is the checked-in data source for that command.

Linux and Windows runtime validation now publish as their own status rows.
Linux and Windows packaged launcher parity now has runnable shared evidence and
checked-in status rows:

- `linux.packaged-launcher` ->
  `//packages/parity:linux_packaged_launcher_parity`
- `windows.packaged-launcher` ->
  `//packages/parity:windows_packaged_launcher_parity`

## Scope

- Keep status reporting conservative.
- Do not mark a slice `verified` until the shared fixture comparison exists.

## Future Fork Status Rows

Phase 36 does not add fork rows to `packages/parity/status.tsv`. Future fork
status rows are reserved for executable parity targets only.

Future fork status tokens should use `fork.<inventory_id>` or an
inventory-derived stable slug that traces back to `packages/fork-inventories`.
A fork row may become `verified` only when maintainers can rerun a real
`//packages/parity:*_parity` evidence command for that fork slice.

Source pins, inventories, templates, checklist completion, and flavor registry
metadata are planning inputs only. They do not prove fork runtime support and
must not be used as status evidence.
