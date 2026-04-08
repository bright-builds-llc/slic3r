# Phase 06: macOS CLI Parity Slice Summary

**Plan 06-01:** the Rust CLI now serves the `--version` slice and preserves the retained legacy version string.

## Verification

- `cargo +1.94.1 clippy --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --all-targets --all-features`
- `cargo +1.94.1 test --all-features`
- `./.planning/.tmp/bin/bazelisk test //packages/slic3r-rust:verify`
