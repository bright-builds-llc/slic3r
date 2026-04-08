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
- The package currently points at the Rust CLI scaffold under
  `packages/slic3r-rust`.
- No user-facing CLI workflow is supported by the Rust launcher yet. That lands
  in Phase 6.
