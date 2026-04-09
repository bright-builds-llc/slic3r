# Transform Workflow Fixtures

These fixtures cover the bounded Phase 13 transform and info slice.

## Provenance

- Legacy contract anchors:
  - `packages/legacy-slic3r/slic3r.pl`
  - `docs/port/contract-inventory.md`
- Rust implementation anchor:
  - `packages/slic3r-rust/crates/slic3r_cli/src/transform.rs`

## Covered Scenarios

- `--info` for:
  - `stl`
  - `obj`
  - `amf`
  - `3mf`
  - `xml`
- `--repair`
- `--split`
