---
phase: 44-executable-prusa-project-file-parity
reviewed: 2026-06-06T00:01:20Z
depth: standard
files_reviewed: 15
files_reviewed_list:
  - docs/port/README.md
  - docs/port/migration-guidance.md
  - docs/port/package-map.md
  - docs/port/parity-matrix.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md
  - packages/parity-fixtures/verify_prusa_project_file_fixture.sh
  - packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
  - packages/parity/BUILD.bazel
  - packages/parity/README.md
  - packages/parity/compare_prusaslicer_project_file.sh
  - packages/parity/compare_prusaslicer_project_file_test.sh
  - packages/parity/status.tsv
  - packages/slic3r-rust/README.md
  - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
  - packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs
findings:
  critical: 0
  warning: 3
  info: 0
  total: 3
status: issues_found
---

# Phase 44: Code Review Report

**Reviewed:** 2026-06-06T00:01:20Z
**Depth:** standard
**Files Reviewed:** 15
**Status:** issues_found

## Summary

Reviewed the Phase 44 docs, status TSV, Bazel wiring, shell comparators/verifiers,
mutation tests, and Rust summary adapter. The Rust adapter and shell path
quoting are generally narrow and explicit, but the new publication checks still
have fail-open paths around expected-artifact drift and overclaiming status/docs
wording.

Review context included `AGENTS.md`, `AGENTS.bright-builds.md`,
`standards-overrides.md`, and the pinned Bright Builds architecture, code-shape,
verification, testing, and Rust standards.

## Warnings

### WR-01: Parity Target Accepts Parseable Expected-Artifact Drift

**File:** `packages/parity/BUILD.bazel:132`
**Issue:** The public `prusaslicer_project_file_parity` target passes the same
`prusa_project_file_expected_project_summary` file as both the Rust summary input
and the expected artifact. `compare_prusaslicer_project_file.sh` then generates
both sides with the same `summary_binary` (`packages/parity/compare_prusaslicer_project_file.sh:93`
and `packages/parity/compare_prusaslicer_project_file.sh:99`). That means a
committed expected TSV drift that is still accepted by the Rust parser can pass
the parity command. I confirmed this with a temporary row-order mutation: when
both comparator inputs pointed at the same mutated TSV, the comparator still
printed `ok: fork.prusaslicer.project-file parity passed`.
**Fix:** Compare actual Rust output against an independent checked-in expected
summary-lines fixture, or make the Rust parser enforce the canonical row order
from its expected rows before summary generation. For the fixture approach:

```python
sh_binary(
    name = "prusaslicer_project_file_parity",
    srcs = ["compare_prusaslicer_project_file.sh"],
    data = [
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_summary",
        "//packages/parity-fixtures:prusa_project_file_expected_project_summary",
        "//packages/parity-fixtures:prusa_project_file_expected_summary_lines",
        "//packages/parity-fixtures:prusa_project_file_provenance",
    ],
    args = [
        "$(location //packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_summary)",
        "$(location //packages/parity-fixtures:prusa_project_file_expected_project_summary)",
        "$(location //packages/parity-fixtures:prusa_project_file_expected_summary_lines)",
        "$(location //packages/parity-fixtures:prusa_project_file_provenance)",
    ],
)
```

Then have the comparator diff `actual_summary` directly against that independent
expected summary-lines file.

### WR-02: Fixture Verifier Still Accepts Stale Phase 44-Unavailable README Wording

**File:** `packages/parity-fixtures/verify_prusa_project_file_fixture.sh:64`
**Issue:** `require_project_file_parity_scope_text` returns success if the
fixture README contains `Executable project-file parity remains unavailable until
Phase 44.` After Phase 44 publishes the parity command and status row, that
fallback lets stale pre-publication README wording pass verification. I confirmed
with a temporary README copy containing the old sentence; the verifier still
reported `ok: Prusa project-file fixture verification passed`.
**Fix:** Remove the legacy branch and require the current publication wording:

```bash
require_project_file_parity_scope_text() {
	require_text "${fixture_readme}" "fixture README" "Executable project-file parity is provided by"
	require_text "${fixture_readme}" "fixture README" "bazel run //packages/parity:prusaslicer_project_file_parity"
	require_text "${fixture_readme}" "fixture README" "for the narrow"
	require_text "${fixture_readme}" "fixture README" "expected-summary evidence slice"
}
```

Add a regression test that rewrites the README to the stale Phase 44-unavailable
sentence and asserts the verifier fails.

### WR-03: Status Verifier Allows Explicit Overclaims If Required Substrings Remain

**File:** `packages/parity-fixtures/verify_prusa_project_file_fixture.sh:300`
**Issue:** `verify_status_published` checks that the project-file status notes
contain required substrings, but it does not reject contradictory positive
claims. A note can include all required fragments while also saying, for example,
`full 3MF import/export verified`; the verifier still passes. I confirmed this
with a temporary `status.tsv` row that inserted that overclaim while preserving
the required substrings.
**Fix:** Require the exact status row for this phase, or add explicit forbidden
overclaim checks. The exact-row approach is simplest and matches the test's
existing `valid_project_file_status_row` constant:

```bash
readonly PROJECT_FILE_STATUS_ROW=$'fork.prusaslicer.project-file\tverified\t//packages/parity:prusaslicer_project_file_parity\tShared fixture comparison proves the narrow Prusa project-file expected-summary evidence slice backed by the Phase 42 fixture and Phase 43 Rust summary boundary only; full 3MF import/export, PrusaSlicer runtime, GUI, generated-output, STEP, support generation, arc fitting, wall seam, network/device, profile auto-update, fork release, and sync surfaces remain deferred'

require_exact_line \
	"${status_file}" \
	"packages/parity/status.tsv" \
	"${PROJECT_FILE_STATUS_ROW}" \
	"fork.prusaslicer.project-file"
```

Keep the duplicate-row check, and add a mutation test where the note preserves
all required terms but adds an explicit `verified` claim for a deferred surface.

---

_Reviewed: 2026-06-06T00:01:20Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
