# Package Map

## Root-Owned Areas

| Path | Role |
|------|------|
| `MODULE.bazel`, `.bazelversion`, `.bazelrc`, `BUILD.bazel` | Canonical Bazel root and repo entrypoint |
| `docs/` | Human-readable migration and project documentation |
| `tools/` | Repo-level helper scripts such as Bazel smoke tests |
| `.planning/` | GSD project memory, research, roadmap, and execution metadata |
| `.github/`, `.travis.yml`, `appveyor.yml`, Bright Builds files | Repo metadata and inherited automation surfaces retained at the root |

## Packages

| Package | Role |
|---------|------|
| `packages/legacy-slic3r` | Retained legacy reference package, behavioral oracle, and Bazel-wrapped macOS legacy build/smoke surface |
| `packages/slic3r-rust` | Bright Builds-compliant Rust workspace package with a real `slic3r_core` crate and Bazel-native verification surface |
| `packages/launcher` | Thin boundary for the future Rust/Bazel/shell entrypoint strategy |
| `packages/parity` | Future parity status and comparison tooling |
| `packages/parity-fixtures` | Future shared fixture corpus for parity checks |

## Notes

- The legacy package is visible by design. Contributors should be able to compare the old and new implementation paths directly.
- The trusted Phase 2 oracle set is intentionally narrower than the full retained historical test tree. Today the trusted macOS oracle check is the smoke wrapper, while the broader retained legacy test wrapper remains documented but deferred.
- Root-owned areas stay outside `packages/` so the monorepo does not hide shared orchestration and documentation behind package boundaries.
- The Rust side starts as one top-level package in Phase 1. Phase 3 adds the first real internal crate, `crates/slic3r_core`, without exploding the top-level package list.
