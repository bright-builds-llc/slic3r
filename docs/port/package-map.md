# Package Map

## Root-Owned Areas

| Path | Role |
|------|------|
| `MODULE.bazel`, `.bazelversion`, `.bazelrc`, `BUILD.bazel` | Canonical Bazel root and repo entrypoint |
| `docs/` | Human-readable migration, contract, and project documentation |
| `tools/` | Repo-level helper scripts such as Bazel smoke tests |
| `.planning/` | GSD project memory, research, roadmap, and execution metadata |
| `.github/`, `.travis.yml`, `appveyor.yml`, Bright Builds files | Repo metadata and inherited automation surfaces retained at the root |

## Packages

| Package | Role |
|---------|------|
| `packages/legacy-slic3r` | Retained legacy reference package, behavioral oracle, and Bazel-wrapped macOS legacy build/smoke surface |
| `packages/slic3r-rust` | Bright Builds-compliant Rust workspace package with separate implementation, contract, and CLI crate boundaries plus a Bazel-native verification surface |
| `packages/launcher` | Entry-point package boundary that points at the Rust CLI and now owns the preferred Linux runtime shim, the scoped Linux packaged launcher tree, the preferred Windows runtime target, and the scoped macOS packaged launcher/startup surface |
| `packages/parity` | Parity visibility package with the checked-in status data source, the status command, and shared comparison commands for the verified CLI, Linux runtime, Windows runtime, export, transform, and scoped macOS packaged launcher slices |
| `packages/parity-fixtures` | Fixture package boundary with contributor-facing provenance rules and shared corpora for the verified help/version/config, Linux runtime, Windows runtime, export, transform, and scoped macOS packaged launcher slices |

## Notes

- The legacy package is visible by design. Contributors should be able to compare the old and new implementation paths directly.
- The trusted Phase 2 oracle set is intentionally narrower than the full retained historical test tree. Today the trusted macOS oracle check is the smoke wrapper, while the broader retained legacy test wrapper remains documented but deferred.
- Root-owned areas stay outside `packages/` so the monorepo does not hide shared orchestration and documentation behind package boundaries.
- The Rust side starts as one top-level package in Phase 1. Phase 3 adds the first real internal crate, `crates/slic3r_core`, without exploding the top-level package list.
- The Phase 4 contract registry lives in `docs/port/contract-inventory.md`, and the contributor-facing launcher/parity/fixture rules live in `docs/port/migration-guidance.md`.
- Phase 5 adds `docs/port/entrypoint-architecture.md` and explicit Rust crate boundaries for launcher contracts and the CLI shell.
- Phase 6 adds `docs/port/cli-slice.md` and makes `--version` the first supported Rust-backed launcher workflow on macOS.
- Phase 7 makes `packages/parity` and `packages/parity-fixtures` real package boundaries with a status command and fixture workflow rules.
- Phase 8 seeds the first shared fixture corpus and comparison command for `cli.version`.
- Phase 11 expands that corpus and comparison surface to the supported help and config persistence slices.
- Phase 14 adds verified fixture comparison commands and corpora for the scoped export and transform slices.
- Phase 15 tightens those fixtures so the explicit `--export-sla-svg` alias and the full documented `--info` input matrix are covered.
- Phase 18 adds a scoped macOS packaged launcher bundle under `packages/launcher/package/osx` and documents its bundle layout expectations.
- Phase 19 adds parity evidence and fixture coverage for the scoped macOS packaged launcher slice.
- Phase 21 adds a preferred Linux runtime shim under `packages/launcher/package/linux` for the existing verified Rust-backed slice.
- Phase 24 adds a preferred Windows runtime target through `//packages/launcher:windows_slic3r` for the existing verified Rust-backed slice.
- Phase 27 adds a scoped Linux packaged launcher tree through
  `//packages/launcher:linux_packaged_launcher_tree` and keeps release-grade
  Linux package formats deferred.
- Phase 22 adds a shared Linux runtime parity command that validates the
  preferred Linux launcher path against the existing verified slice.
- Phase 25 adds a shared Windows runtime parity command under `packages/parity`.
- Phase 26 publishes the bounded Windows runtime validation state through
  `packages/parity/status.tsv` and the migration docs.
