# Linux Runtime Fixtures

These fixtures cover the bounded Phase 22 Linux runtime parity slice.

## Provenance

- Linux launcher/runtime anchor:
  - `packages/launcher/package/linux/startup_script.sh`
- Reused verified fixture anchors:
  - `packages/parity-fixtures/cli-help/stdout.txt`
  - `packages/parity-fixtures/cli-version/stdout.txt`
  - `packages/parity-fixtures/config-persistence/*`
  - `packages/parity-fixtures/export-workflows/*`
  - `packages/parity-fixtures/transform-workflows/*`

## Covered Scenarios

- Linux launcher `--version`
- Linux launcher `--help`
- Linux launcher config persistence via `--save`, `--load`, and `--datadir`
- Linux launcher representative G-code export
- Linux launcher representative `--info`, `--repair`, and `--split` flows
