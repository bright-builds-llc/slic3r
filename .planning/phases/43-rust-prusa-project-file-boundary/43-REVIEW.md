---
phase: 43-rust-prusa-project-file-boundary
reviewed: 2026-06-05T14:12:57Z
depth: standard
files_reviewed: 17
files_reviewed_list:
  - packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs
  - packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs
  - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
  - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
  - packages/slic3r-rust/BUILD.bazel
  - packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs
  - packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs
  - packages/parity-fixtures/BUILD.bazel
  - packages/parity-fixtures/verify_prusa_project_file_fixture.sh
  - packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
  - packages/slic3r-rust/README.md
  - packages/parity-fixtures/README.md
  - packages/parity/README.md
  - docs/port/README.md
  - docs/port/package-map.md
  - docs/port/migration-guidance.md
  - docs/port/parity-matrix.md
findings:
  critical: 0
  warning: 1
  info: 0
  total: 1
status: issues_found
---

# Phase 43: Code Review Report

**Reviewed:** 2026-06-05T14:12:57Z
**Depth:** standard
**Files Reviewed:** 17
**Status:** issues_found

## Summary

Reviewed the explicit Phase 43 source and documentation scope. The review used repo-local `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the pinned Bright Builds architecture, code-shape, verification, testing, and Rust standards. The docs and shell fixture guards keep Phase 44 parity/status publication absent, and no critical security issues were found.

One parser validation gap remains: the Rust boundary validates the selected row keys but still accepts arbitrary note text.

## Warnings

### WR-01: Project-File Notes Can Carry Unvalidated Semantic Claims

**File:** `/Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs:391`
**Issue:** `parse_summary_row` stores `columns[5]` as `PrusaProjectFileNote` after only the generic non-empty check. The expected row set at lines 26-62 validates source, fixture, archive member, marker, and deferred semantics, but it does not include the expected `notes` value. That means caller-supplied TSV with the same seven row keys but a note like "full import/export parity verified" still parses successfully and exposes the claim through `summary.rows[*].notes`, undercutting the Phase 43 "presence-level evidence only" boundary.
**Fix:** Include the note text in the expected-row invariant and reject mismatches with a typed error. Add a regression test that replaces a valid note with an overclaim and expects the new error.

```rust
struct ExpectedProjectFileRow {
    archive_member: PrusaProjectFileArchiveMember,
    project_marker: PrusaProjectFileMarker,
    deferred_semantics: PrusaProjectFileDeferredSemantics,
    note: &'static str,
}

fn validate_note(
    row_key: PrusaProjectFileRowKey,
    note: &str,
    line_number: usize,
) -> Result<PrusaProjectFileNote, PrusaProjectFileParseError> {
    let expected_note = EXPECTED_ROWS
        .iter()
        .find(|row| PrusaProjectFileRowKey::from_expected(**row) == row_key)
        .map(|row| row.note);

    if expected_note != Some(note) {
        return Err(PrusaProjectFileParseError::UnexpectedNote {
            line_number,
            value: note.to_owned(),
        });
    }

    Ok(PrusaProjectFileNote(note.to_owned()))
}
```

---

_Reviewed: 2026-06-05T14:12:57Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
