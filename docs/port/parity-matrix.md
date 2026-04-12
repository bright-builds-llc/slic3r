# Parity Matrix

Use this file as the high-level status dashboard. Use
[`contract-inventory.md`](./contract-inventory.md) for the detailed contract
rows and [`migration-guidance.md`](./migration-guidance.md) for launcher,
parity, and fixture rules.

| Surface | Current Source of Truth | Status | Detailed Inventory | Notes |
| --- | --- | --- | --- | --- |
| CLI behavior | Mixed: retained legacy CLI plus the preferred Rust-backed launcher slice | `in progress` | [`contract-inventory.md#cli-behavior`](./contract-inventory.md#cli-behavior) | `--version`, `--help`, config persistence, scoped export workflows, and the scoped info/repair/split slice are now verified through shared fixtures; broader CLI behavior remains legacy-owned |
| Linux runtime path | Preferred Linux launcher/runtime shim plus the existing Rust-backed CLI slice | `verified` | [`contract-inventory.md#launcher-path`](./contract-inventory.md#launcher-path) | The preferred Linux launcher path is now verified for representative help/version/config/export/transform flows through shared parity evidence; Linux packaging parity remains deferred |
| Windows runtime path | Preferred Windows runtime target plus the existing Rust-backed CLI slice | `verified` | [`contract-inventory.md#launcher-path`](./contract-inventory.md#launcher-path) | The preferred Windows runtime target is now verified for representative help/version/config/export/transform flows through `//packages/parity:windows_runtime_parity`, and `windows.runtime` publishes that bounded claim in `packages/parity/status.tsv`; packaging-visible Windows behavior remains deferred |
| Config semantics | `packages/legacy-slic3r/lib/Slic3r/Config.pm` and related legacy config code | `in progress` | [`contract-inventory.md#config-semantics`](./contract-inventory.md#config-semantics) | The scoped save/load/datadir slice is verified through shared fixtures; broader config semantics remain legacy-only |
| Supported file formats | Mixed: retained legacy runtime plus the scoped Rust-backed export slice | `in progress` | [`contract-inventory.md#supported-file-formats`](./contract-inventory.md#supported-file-formats) | The preferred launcher now verifies the scoped export families for G-code, STL, OBJ, AMF, 3MF, and SVG outputs; broader format parity remains legacy-only |
| Generated outputs | Mixed: retained legacy output pipeline plus the scoped Rust-backed export and transform slice | `in progress` | [`contract-inventory.md#generated-outputs`](./contract-inventory.md#generated-outputs) | The preferred launcher now verifies scoped output naming and artifact creation for supported exports plus repair/split utilities, but geometry/content parity is still deferred |
| Launcher path | Mixed: retained legacy launcher plus the preferred Rust-backed launcher package | `in progress` | [`contract-inventory.md#launcher-path`](./contract-inventory.md#launcher-path) | `packages/launcher` now serves the supported Rust-backed CLI slice, the verified Linux runtime shim, the verified Windows runtime target, and the scoped macOS packaged launcher surface; packaging-visible Linux and Windows parity remain separate deferred surfaces |
| Packaging-visible behavior | Mixed: retained legacy packaging scripts plus the scoped macOS packaged launcher slice | `in progress` | [`contract-inventory.md#packaging-visible-behavior`](./contract-inventory.md#packaging-visible-behavior) | The scoped macOS packaged launcher bundle is now parity-verified for the supported slice, while broader packaging behavior remains deferred |

## Oracle Interpretation

- `//:legacy_oracle_smoke` is the current trusted macOS oracle check. It proves
  the retained CLI entry path is buildable and that `slic3r.pl --help` runs.
- `//:legacy_oracle_test` exists as broader retained legacy evidence, but it is
  still weaker or deferred evidence until the retained XS loader path is fully
  stabilized.
- `bazel run //packages/parity:status` is the current parity visibility command,
  and `packages/parity/status.tsv` is its checked-in data source.
- Phase 4 inventories all six parity surface families now. Later phases are
  responsible for moving individual surfaces from `legacy-only` to `in progress`, `rust-backed`, and eventually `verified`.
