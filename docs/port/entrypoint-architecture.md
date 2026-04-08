# Entrypoint Architecture

This document defines the ownership boundaries for the first non-legacy CLI
slice.

## Responsibilities

| Surface | Owner | Responsibility |
| --- | --- | --- |
| Bazel entrypoints | `packages/BUILD.bazel`, `packages/launcher/BUILD.bazel` | Expose the preferred runnable targets without owning business logic |
| Stable launcher contracts | `packages/slic3r-rust/crates/slic3r_contracts` | Parse and model the supported CLI slice in pure Rust types |
| Launcher-facing CLI shell | `packages/slic3r-rust/crates/slic3r_cli` | Translate process arguments into contract routing and user-visible exit behavior |
| Lower-level Rust implementation | `packages/slic3r-rust/crates/slic3r_core` | Hold reusable implementation details that are not themselves the stable launcher contract |
| Future shell shims | `packages/launcher` | Stay thin if introduced later; no Perl business logic moves here |
| Retained reference behavior | `packages/legacy-slic3r` | Remain the parity oracle for unsupported CLI behavior until later phases migrate it |

## Phase 5 Scope

- The Rust side now has separate crates for stable launcher contracts and the
  CLI shell.
- `packages/launcher` is no longer an empty placeholder. It is the package
  boundary that points at the Rust CLI scaffold.
- No user-facing workflow is supported through the Rust launcher yet. This phase
  only makes the architecture explicit enough for Phase 6 implementation.
