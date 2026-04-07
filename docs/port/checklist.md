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
- [ ] Legacy build surfaces are wrapped through Bazel
- [ ] Legacy test surfaces are wrapped through Bazel

## Rust Workspace

- [x] `packages/slic3r-rust` exists as a top-level package
- [x] The Rust side starts as one package with an internal Cargo workspace root
- [x] The package skeleton is visible from the repo root
- [ ] Rust toolchain integration exists in Bazel
- [ ] Rust format/lint/test targets exist in Bazel

## Launcher

- [x] `packages/launcher` exists as a named package boundary
- [ ] Launcher responsibilities are implemented beyond a placeholder
- [ ] The preferred CLI entrypoint is documented and backed by Rust/Bazel instead of Perl

## Parity Tooling

- [x] `packages/parity` exists as a named package boundary
- [x] `packages/parity-fixtures` exists as a named package boundary
- [ ] The parity status command exists
- [ ] The shared fixture corpus is seeded
- [ ] Differential legacy-vs-Rust comparisons run on the fixture corpus

## Docs

- [x] `docs/port/README.md` exists as the control-plane entrypoint
- [x] `docs/port/checklist.md` is organized by migration surface
- [x] `docs/port/parity-matrix.md` uses the shared status vocabulary
- [x] `docs/port/package-map.md` explains package and root-area roles
- [x] Process expectation is documented: Rust-port and parity-surface changes update docs in the same change
- [ ] Docs/checklist updates are enforced automatically
