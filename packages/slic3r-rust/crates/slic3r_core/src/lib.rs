#![forbid(unsafe_code)]
//! Core Rust workspace crate for the Slic3r migration.
//!
//! Phase 3 only establishes a real Bazel- and Cargo-addressable crate boundary.

/// Returns the crate marker used by the initial smoke tests.
pub fn workspace_marker() -> &'static str {
    "slic3r-core"
}

/// Returns the legacy version string that the first Rust-backed CLI slice must
/// preserve.
pub fn legacy_parity_version() -> &'static str {
    "1.3.1-dev"
}
