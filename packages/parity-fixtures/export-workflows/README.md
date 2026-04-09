# Export Workflow Fixtures

These fixtures cover the bounded Phase 12 export slice.

## Provenance

- Legacy contract anchors:
  - `packages/legacy-slic3r/src/test/GUI/test_cli.cpp`
  - `packages/legacy-slic3r/slic3r.pl`
- Rust implementation anchor:
  - `packages/slic3r-rust/crates/slic3r_cli/src/export.rs`

## Covered Scenarios

- `--export-gcode`
- `--export-stl`
- `--export-obj`
- `--export-amf`
- `--export-3mf`
- `--export-svg`
- `--sla`
