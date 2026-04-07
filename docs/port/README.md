# Rust Port Control Plane

This directory is the source of truth for the Slic3r Rust port during the migration.

Phase 1 establishes the monorepo scaffold, the retained legacy reference package, and the documentation surfaces reviewers should use to understand current progress. Until automation exists, any Rust-port or parity-surface change is expected to update the relevant docs here in the same change.

## Documents

- [`checklist.md`](./checklist.md) - migration-surface checklist for what exists, what is pending, and what Phase 1 is responsible for
- [`parity-matrix.md`](./parity-matrix.md) - contract-surface status using the shared migration vocabulary
- [`package-map.md`](./package-map.md) - package roles and root-owned areas in the monorepo

## Status Vocabulary

- `legacy-only` - only the retained legacy package currently provides the surface
- `in progress` - migration work exists, but the Rust path is not yet the trusted implementation
- `rust-backed` - the Rust implementation provides the surface, but parity still needs deeper proof
- `verified` - parity has been checked and accepted for the tracked scope

## Review Expectation

When a change touches Rust-port behavior, parity surfaces, or package boundaries, reviewers should expect the relevant file in `docs/port/` to move with it. If the docs do not change, the review should explicitly explain why.
