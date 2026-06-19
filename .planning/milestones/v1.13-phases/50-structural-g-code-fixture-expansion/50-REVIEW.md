---
phase: 50-structural-g-code-fixture-expansion
reviewed: 2026-06-17T17:25:43Z
depth: standard
files_reviewed: 6
files_reviewed_list:
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv
  - packages/parity-fixtures/BUILD.bazel
  - packages/parity-fixtures/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md
  - packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
  - packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
findings:
  critical: 0
  warning: 1
  info: 0
  total: 1
status: issues_found
---

# Phase 50: Code Review Report

**Reviewed:** 2026-06-17T17:25:43Z
**Depth:** standard
**Files Reviewed:** 6
**Status:** issues_found

## Summary

Reviewed the Phase 50 structural G-code fixture sidecar, Bazel ownership wiring, fixture/package README boundary text, Bash verifier, and mutation test harness against the Phase 50 context/plan/summary artifacts. Material guidance used: repo `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and pinned Bright Builds standards pages for architecture, code shape, verification, and testing.

No implementation bug, security issue, Bazel wiring regression, or structural TSV drift was found. The checked-in sidecar matches the locked 16-field structural shape, Bazel exposes it through the expected alias and bundle, and the verifier/test entrypoints pass. One actionable test reliability gap remains: several structural mutation assertions do not actually require all diagnostic fragments they are meant to guard.

## Warnings

### WR-01: Structural Mutation Diagnostic Assertions Are Too Broad

**File:** `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh:277-365`
**Issue:** The six structural negative tests use one `grep -E` pattern with `|` alternation, for example `expected-gcode-structural-summary.tsv|command_count_g1`. That means the assertion passes when stderr contains the sidecar filename **or** the field name, not both. This weakens the GCFIX-03/D-12 diagnostic guarantee because a future verifier regression could stop naming the affected field, provenance mismatch, or forbidden claim while these tests still pass.
**Fix:** Require each expected diagnostic fragment separately. For example:

```bash
assert_contains_all() {
	local file="$1"
	shift
	local pattern
	for pattern in "$@"; do
		assert_contains "${file}" "${pattern}"
	done
}

assert_contains_all \
	"${tmp_dir}/structural-value-drift.err" \
	"expected-gcode-structural-summary.tsv" \
	"command_count_g1"

assert_contains_all \
	"${tmp_dir}/structural-overclaim.err" \
	"expected-gcode-structural-summary.tsv" \
	"forbidden" \
	"verified Prusa G-code output parity"
```

Apply the same shape to the missing-row, duplicate-row, unsupported-field, and provenance-mismatch assertions.

## Verification Performed

- `bash -n packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `shfmt -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `shellcheck packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`
- `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`
- `mdformat --check packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
- `bazel query //packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary`
- `bazel query 'labels(srcs, //packages/parity-fixtures:prusa_gcode_output_bundle)'`
- TSV header, row-count, source/fixture alignment, required-field uniqueness, and forbidden metadata checks for `expected-gcode-structural-summary.tsv`
- `git diff --check` for the scoped Phase 50 source files
- `git diff --name-only -- packages/parity packages/slic3r-rust`

All verification commands passed. The forbidden-metadata `rg` check intentionally returned no matches.

---

_Reviewed: 2026-06-17T17:25:43Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
