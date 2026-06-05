---
phase: 43-rust-prusa-project-file-boundary
review_path: .planning/phases/43-rust-prusa-project-file-boundary/43-REVIEW.md
status: all_fixed
findings_in_scope: 1
fixed: 1
skipped: 0
iteration: 1
---

# Phase 43: Code Review Fix Report

## Summary

Fixed WR-01 from the Phase 43 review by making project-file TSV notes part of the expected-row invariant. The parser now rejects note text that matches an otherwise expected row but carries an unvalidated semantic claim.

## Fixes

- WR-01: Added exact expected note values to `ExpectedProjectFileRow`, introduced `PrusaProjectFileParseError::UnexpectedNote`, and validated notes before accepting expected project-file rows.
- Added `rejects_unexpected_note_claim` to prove an overclaiming note is rejected.

## Verification

- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --package slic3r_flavors rejects_unexpected_note_claim`
