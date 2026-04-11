# Launcher Package

`packages/launcher` is the ownership boundary for the preferred non-legacy
entrypoint path.

## Responsibilities

- Expose the preferred Bazel-facing launcher target for Rust-backed CLI slices.
- Keep any future shell shims thin and limited to argument handoff or
  environment setup.
- Avoid reintroducing Perl implementation logic into the new launcher path.

## Current State

- Phase 5 replaces the empty placeholder with a real package boundary.
- The package currently points at the Rust CLI under
  `packages/slic3r-rust`.
- Phase 6 makes `bazel run //packages/launcher:slic3r -- --version` the first
  supported Rust-backed macOS CLI workflow.
- Phase 9 adds `bazel run //packages/launcher:slic3r -- --help` as a
  Rust-backed help and usage slice.
- Phase 10 adds the scoped config persistence slice.
- Phase 12 adds the scoped Rust-backed export workflows for G-code, STL, OBJ,
  AMF, 3MF, layered SVG, and SLA SVG.
- Phase 13 adds the scoped Rust-backed `--info`, `--repair`, and `--split`
  behaviors.
- Phase 18 adds a scoped macOS packaged launcher surface at
  `bazel run //packages/launcher:macos_packaged_launcher_bundle`, which
  materializes a `Slic3r.app`-style bundle for the already verified CLI slice.
- Phase 21 adds `bazel run //packages/launcher:linux_slic3r -- ...` as the
  preferred Linux runtime path for the existing verified Rust-backed slice.
- Merge/cut/layout, multi-input transforms, geometry/output-content parity, and
  packaging-visible behavior remain legacy-owned until later phases expand the
  supported slice.
