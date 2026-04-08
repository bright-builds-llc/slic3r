#![forbid(unsafe_code)]
//! Core Rust workspace crate for the Slic3r migration.
//!
//! Phase 3 only establishes a real Bazel- and Cargo-addressable crate boundary.

/// Returns the crate marker used by the initial smoke tests.
pub fn workspace_marker() -> &'static str {
    "slic3r-core"
}
