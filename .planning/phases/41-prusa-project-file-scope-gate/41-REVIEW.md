---
phase: 41-prusa-project-file-scope-gate
reviewed: 2026-06-03T12:47:21Z
depth: standard
files_reviewed: 9
files_reviewed_list:
  - docs/port/README.md
  - docs/port/migration-guidance.md
  - docs/port/package-map.md
  - docs/port/parity-matrix.md
  - packages/prusa-project-file-scope/BUILD.bazel
  - packages/prusa-project-file-scope/README.md
  - packages/prusa-project-file-scope/project-file-scope.md
  - packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh
  - packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh
findings:
  critical: 0
  warning: 2
  info: 0
  total: 2
status: issues_found
---

# Phase 41: Code Review Report

**Reviewed:** 2026-06-03T12:47:21Z
**Depth:** standard
**Files Reviewed:** 9
**Status:** issues_found

## Summary

Reviewed the Phase 41 Prusa project-file scope gate docs, Bazel package, verifier, and shell tests. Local repo guidance from `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the pinned Bright Builds standards pages for code shape, verification, testing, and architecture materially informed this review.

The docs avoid the main overclaiming hazards: the local inventory row exists, the Prusa source paths resolve at the pinned commit, and `packages/parity/status.tsv` does not publish `fork.prusaslicer.project-file`. The remaining issues are warning-level verification gaps that can let future drift pass with a false green.

Verification run during review:

- `bazel run //packages/prusa-project-file-scope:verify` passed.
- `bazel test //packages/prusa-project-file-scope:verify_prusa_project_file_scope_test` passed.

## Warnings

### WR-01: Bazel Test Target Does Not Verify The Checked-In Scope Documents

**File:** `packages/prusa-project-file-scope/BUILD.bazel:21`

**Issue:** The only `sh_test` target runs `verify_prusa_project_file_scope_test.sh`, which builds synthetic README and scope fixtures. That checks the verifier's behavior, but it does not run the verifier against the checked-in `README.md` and `project-file-scope.md`. A normal `bazel test //packages/prusa-project-file-scope:verify_prusa_project_file_scope_test` can stay green after the real scope documents lose required claims, unless maintainers also remember to run `bazel run //packages/prusa-project-file-scope:verify`.

**Fix:** Add a test target that runs the verifier against the checked-in documents, and keep the existing synthetic fixture test for negative cases.

```python
sh_test(
    name = "verify_prusa_project_file_scope_docs",
    srcs = ["verify_prusa_project_file_scope.sh"],
    data = [
        "README.md",
        "project-file-scope.md",
    ],
    args = [
        "$(location README.md)",
        "$(location project-file-scope.md)",
    ],
)
```

### WR-02: Verifier Checks No-Artifact Claims As Text, Not Repository State

**File:** `packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh:71`

**Issue:** The verifier requires the README and scope record to say Phase 41 creates no fixture bytes, expected artifacts, parity command, or status row, but it never checks the actual repository state for those forbidden outputs. The gate would still pass if `packages/parity/status.tsv` gained `fork.prusaslicer.project-file`, if a parity target named `prusaslicer_project_file_parity` appeared, or if fixture files were added under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/` while the docs kept the current no-artifact wording.

**Fix:** Extend the verifier to assert the absence of the Phase 41-forbidden outputs, and add the needed paths as Bazel data or derive them from the repository root in a documented way.

```bash
require_absent_path() {
	local path="$1"
	local label="$2"
	if [[ -e "${path}" ]]; then
		error "${label} must not exist in Phase 41: ${path}"
	fi
}

require_absent_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if grep -Fq -- "${pattern}" "${file}"; then
		error "${label}: forbidden Phase 41 text found: ${pattern}"
	fi
}

verify_no_phase_41_artifacts() {
	require_absent_path "${fixture_dir}" "Prusa project-file fixture namespace"
	require_absent_text "${status_file}" "packages/parity/status.tsv" $'fork.prusaslicer.project-file\t'
	require_absent_text "${parity_build_file}" "packages/parity/BUILD.bazel" "prusaslicer_project_file_parity"
}
```

---

_Reviewed: 2026-06-03T12:47:21Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
