# Port Checklist

## Bazel Root

- [x] `.bazelversion` pins the repository Bazel version
- [x] `MODULE.bazel` exists at the repo root and enables the Bzlmod-first path
- [x] Root `BUILD.bazel` exposes a canonical repo scaffold target
- [x] `bazel build //...` resolves on macOS for the scaffolded repository
- [x] `bazel test //...` resolves on macOS with at least one real scaffold smoke test

## Legacy Package

- [x] The retained legacy source tree lives in `packages/legacy-slic3r`
- [x] The legacy package is documented as the visible reference package and behavioral oracle
- [x] The legacy relocation was structural rather than cleanup-driven
- [x] Legacy build surfaces are wrapped through Bazel
- [x] A trusted macOS legacy oracle check is wrapped through Bazel
- [ ] Broader retained legacy tests are fully trustworthy through Bazel
- [x] The trusted oracle set vs deferred retained legacy surfaces is documented explicitly

## Rust Workspace

- [x] `packages/slic3r-rust` exists as a top-level package
- [x] The Rust side starts as one package with an internal Cargo workspace root
- [x] The package skeleton is visible from the repo root
- [x] Rust toolchain integration exists in Bazel
- [x] Rust format/lint/test targets exist in Bazel
- [x] `//packages/slic3r-rust:verify` runs the package-local verification suite
- [x] The first real crate exists under `packages/slic3r-rust/crates/slic3r_core`

## Entrypoint Architecture

- [x] Contract-oriented Rust modules exist separately from lower-level
  implementation code
- [x] `docs/port/entrypoint-architecture.md` explains which responsibilities
  belong to Bazel, Rust, and future shell shims
- [x] `packages/launcher` is a real package boundary instead of an empty
  placeholder

## Contract Inventory

- [x] `docs/port/contract-inventory.md` enumerates CLI behavior, config
  semantics, supported file formats, generated outputs, launcher path, and
  packaging-visible behavior
- [x] Contract rows separate legacy source of truth, the current trusted check,
  and weaker or deferred evidence
- [x] `docs/port/parity-matrix.md` routes readers to the contract registry while
  preserving the shared status vocabulary

## Launcher

- [x] `packages/launcher` exists as a named package boundary
- [x] Launcher responsibilities are implemented beyond a placeholder
- [x] The preferred CLI entrypoint is documented and backed by Rust/Bazel instead of Perl for the current supported slice

## CLI Slice

- [x] `docs/port/cli-slice.md` documents the currently supported Rust-backed CLI workflow
- [x] `bazel run //packages/launcher:slic3r -- --version` is the preferred Rust-backed macOS invocation for the supported slice
- [ ] Broader CLI workflows are supported through the Rust launcher

## Parity Tooling

- [x] `packages/parity` exists as a named package boundary
- [x] `packages/parity-fixtures` exists as a named package boundary
- [x] The parity evidence model and future fixture location are documented
- [ ] The parity status command exists
- [ ] The shared fixture corpus is seeded
- [ ] Differential legacy-vs-Rust comparisons run on the fixture corpus

## Docs

- [x] `docs/port/README.md` exists as the control-plane entrypoint
- [x] `docs/port/checklist.md` is organized by migration surface
- [x] `docs/port/contract-inventory.md` exists as the evidence-backed contract registry
- [x] `docs/port/migration-guidance.md` explains launcher replacement, parity strategy, fixture update protocol, and deferred scope
- [x] `docs/port/parity-matrix.md` uses the shared status vocabulary
- [x] `docs/port/package-map.md` explains package and root-area roles
- [x] Process expectation is documented: Rust-port and parity-surface changes update docs in the same change
- [ ] Docs/checklist updates are enforced automatically
