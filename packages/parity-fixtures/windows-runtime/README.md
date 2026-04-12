# Windows Runtime Fixtures

These fixtures cover the bounded Phase 25 Windows runtime parity slice.

## Provenance

- Windows launcher/runtime anchor:
  - `packages/launcher:windows_slic3r`
- Reused verified fixture anchors:
  - `packages/parity-fixtures/cli-help/stdout.txt`
  - `packages/parity-fixtures/cli-version/stdout.txt`
  - `packages/parity-fixtures/config-persistence/*`
  - `packages/parity-fixtures/export-workflows/*`
  - `packages/parity-fixtures/transform-workflows/*`

## Covered Scenarios

- Windows runtime `--version`
- Windows runtime `--help`
- Windows runtime config persistence via `--save`, `--load`, and `--datadir`
- Windows runtime representative G-code export
- Windows runtime representative `--info`, `--repair`, and `--split` flows
