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

Phase 39 documents parser/metadata readiness for `prusaslicer.profile-schema`
through `slic3r_flavors::prusa_profile`, `parse_prusa_profile_bundle`, and
`prusa_profile_schema_metadata`; it does not add a Prusa row to
`packages/parity/status.tsv`.

That Rust boundary traces to
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
source path `resources/profiles/PrusaResearch.ini`, fixture path
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`,
checklist path `packages/prusa-baseline/profile-schema-checklist.md`, and
checklist status `future-candidate`.

The docs-only token `fork.prusaslicer.profile-schema` is reserved for the
future Prusa profile/config evidence slice.

Future fork status tokens should use `fork.<inventory_id>` or an
inventory-derived stable slug that traces back to `packages/fork-inventories`.
A fork row may become `verified` only when maintainers can rerun a real
`//packages/parity:*_parity` evidence command for that fork slice.

Phase 40 owns `//packages/parity:prusaslicer_profile_schema_parity`.
That target must have a rerunnable
`bazel run //packages/parity:prusaslicer_profile_schema_parity` command that
exists and passes before `fork.prusaslicer.profile-schema` can be verified.

Source pins, inventories, checklist records, flavor metadata, and static
fixtures are planning inputs only. They do not prove full PrusaSlicer support,
fork runtime support, GUI support, network/device/cloud/credential behavior,
profile auto-update execution, non-free plugin ingestion, vendor sync
automation, fork release packaging, or status evidence by themselves.
