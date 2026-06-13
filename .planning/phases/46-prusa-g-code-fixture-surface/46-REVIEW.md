---
phase: 46-prusa-g-code-fixture-surface
reviewed: 2026-06-13T18:57:01Z
depth: standard
files_reviewed: 15
files_reviewed_list:
  - docs/port/README.md
  - docs/port/migration-guidance.md
  - docs/port/package-map.md
  - docs/port/parity-matrix.md
  - packages/parity-fixtures/BUILD.bazel
  - packages/parity-fixtures/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/.gitattributes
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode
  - packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
  - packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
  - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
  - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
findings:
  critical: 0
  warning: 1
  info: 0
  total: 1
status: issues_found
---

# Phase 46: Code Review Report

**Reviewed:** 2026-06-13T18:57:01Z
**Depth:** standard
**Files Reviewed:** 15
**Status:** issues_found

## Summary

Reviewed the Phase 46 Prusa G-code fixture surface, including fixture bytes,
provenance/expected-summary TSVs, Bazel exports, fixture and scope verifiers,
mutation tests, and port/package documentation. Local guidance from `AGENTS.md`,
`AGENTS.bright-builds.md`, `standards-overrides.md`, and the Bright Builds code
shape, verification, and testing standards materially informed this review.

The fixture data matches the pinned PrusaSlicer `GCodeWriter::set_speed`
expected-output literals, the docs preserve the Phase 47/48 boundary, and the
focused verifier/test commands pass. One warning remains: both absence verifiers
detect the future parity target with an overly exact string match, so valid
Starlark formatting can bypass the guard.

## Warnings

### WR-01: Parity Target Absence Check Misses Valid Starlark Formatting

**File:** `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh:160`; `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:152`

**Issue:** Both verifiers reject the Phase 48 parity target by grepping only for
the exact text `name = "prusaslicer_gcode_output_parity"`. A valid BUILD target
formatted as `sh_binary(name="prusaslicer_gcode_output_parity", ...)` or using
single quotes is not detected. I confirmed this with temporary checkout copies:
both verifiers returned success with a compact `sh_binary(name="prusaslicer_gcode_output_parity", ...)`
in `packages/parity/BUILD.bazel`. That weakens the Phase 46 fail-closed boundary
and can let premature parity publication slip past the current tests.

**Fix:** Make both `reject_parity_target` checks whitespace/quote tolerant, or
prefer a Bazel query when the verifier is running from a real checkout. Also add
mutation tests for compact and single-quoted target formatting.

```bash
reject_parity_target() {
	local parity_target_pattern
	parity_target_pattern="name[[:space:]]*=[[:space:]]*['\"]prusaslicer_gcode_output_parity['\"]"
	if grep -Eq -- "${parity_target_pattern}" "${parity_build_file}"; then
		error "packages/parity/BUILD.bazel: forbidden parity target exists: prusaslicer_gcode_output_parity"
	fi
}
```

## Verification

Passed:

- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`
- `bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`
- `bazel run //packages/prusa-gcode-output-scope:verify`
- `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`
- `shfmt -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `shellcheck packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `mdformat --check packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md`
- `git diff --check f7d30cdc3227f4260fbefaa76466d7f4a9e7e60a..HEAD -- <reviewed files>`
- Fixture byte count and SHA-256 checks for `gcodewriter-set-speed.gcode`

---

_Reviewed: 2026-06-13T18:57:01Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
