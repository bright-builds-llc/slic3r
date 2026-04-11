# macOS Packaged Launcher Fixtures

These fixtures cover the bounded Phase 18 macOS packaged launcher slice.

## Provenance

- Legacy contract anchors:
  - `packages/legacy-slic3r/package/osx/startup_script.sh`
  - `packages/legacy-slic3r/package/osx/make_dmg.sh`
- Rust implementation anchors:
  - `packages/launcher/package/osx/build_bundle.sh`
  - `packages/launcher/package/osx/startup_script.sh`

## Covered Scenarios

- scoped `Slic3r.app` bundle file layout
- packaged startup handoff through `Contents/MacOS/Slic3r`
- packaged `--version`
- packaged `--help`
- representative packaged config persistence via `--save`, `--load`, and
  `--datadir`
