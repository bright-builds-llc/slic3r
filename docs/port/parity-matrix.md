# Parity Matrix

Use this file as the high-level status dashboard. Use
[`contract-inventory.md`](./contract-inventory.md) for the detailed contract
rows and [`migration-guidance.md`](./migration-guidance.md) for launcher,
parity, and fixture rules.

| Surface | Current Source of Truth | Status | Detailed Inventory | Notes |
| --- | --- | --- | --- | --- |
| CLI behavior | `packages/legacy-slic3r/slic3r.pl` and related legacy native surfaces | `in progress` | [`contract-inventory.md#cli-behavior`](./contract-inventory.md#cli-behavior) | The `--version` slice is now Rust-backed through `//packages/launcher:slic3r`; broader CLI behavior remains legacy-only and parity verification lands in Phase 8 |
| Config semantics | `packages/legacy-slic3r/lib/Slic3r/Config.pm` and related legacy config code | `legacy-only` | [`contract-inventory.md#config-semantics`](./contract-inventory.md#config-semantics) | The source of truth is documented now; contract-oriented Rust modules come in later phases |
| Supported file formats | Legacy Perl/C++/XS pipeline under `packages/legacy-slic3r/` | `legacy-only` | [`contract-inventory.md#supported-file-formats`](./contract-inventory.md#supported-file-formats) | Input and export format families are inventoried now without claiming any Rust-backed coverage |
| Generated outputs | Legacy slicing and export pipeline under `packages/legacy-slic3r/` | `legacy-only` | [`contract-inventory.md#generated-outputs`](./contract-inventory.md#generated-outputs) | Output naming and artifact expectations are inventoried now; output parity is deferred to later phases |
| Launcher path | Legacy launcher path retained under `packages/legacy-slic3r/slic3r.pl` and packaged startup wrappers | `legacy-only` | [`contract-inventory.md#launcher-path`](./contract-inventory.md#launcher-path) | `packages/launcher` is still a future owner boundary rather than an implemented replacement |
| Packaging-visible behavior | Legacy packaging scripts under `packages/legacy-slic3r/package/` | `legacy-only` | [`contract-inventory.md#packaging-visible-behavior`](./contract-inventory.md#packaging-visible-behavior) | Packaging contracts are tracked now even though macOS, Linux, and Windows packaging work land in later phases |

## Oracle Interpretation

- `//:legacy_oracle_smoke` is the current trusted macOS oracle check. It proves
  the retained CLI entry path is buildable and that `slic3r.pl --help` runs.
- `//:legacy_oracle_test` exists as broader retained legacy evidence, but it is
  still weaker or deferred evidence until the retained XS loader path is fully
  stabilized.
- Phase 4 inventories all six parity surface families now. Later phases are
  responsible for moving individual surfaces from `legacy-only` to `in progress`, `rust-backed`, and eventually `verified`.
