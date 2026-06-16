---
phase: 49-structural-g-code-scope-contract
reviewed: 2026-06-16T16:35:19Z
depth: standard
files_reviewed: 4
files_reviewed_list:
  - packages/prusa-gcode-output-scope/README.md
  - packages/prusa-gcode-output-scope/gcode-output-scope.md
  - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
  - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
findings:
  critical: 0
  warning: 3
  info: 0
  total: 3
status: issues_found
---

# Phase 49: Code Review Report

**Reviewed:** 2026-06-16T16:35:19Z
**Depth:** standard
**Files Reviewed:** 4
**Status:** issues_found

## Summary

Reviewed the Phase 49 Prusa G-code output scope contract, verifier, and mutation tests against the repo-local AGENTS guidance, AGENTS.bright-builds.md, standards-overrides.md, and the pinned Bright Builds standards for architecture, code shape, verification, and testing.

The repo-owned happy-path checks pass:

- `bazel run //packages/prusa-gcode-output-scope:verify`
- `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`

However, targeted fail-closed mutants exposed three verifier gaps. Each mutant exited 0 and printed `ok: Prusa G-code output scope verification passed`.

## Warnings

### WR-01: Broad `generated-outputs` Promotion Can Pass Beside the In-Progress Row

**File:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:378`

**Issue:** `verify_generated_outputs_in_progress` counts only rows where field 1 is `generated-outputs` and field 2 is `in progress`. If `packages/parity/status.tsv` keeps that row but also adds a second `generated-outputs` row with `verified`, the count still equals 1 and the verifier passes. That fails open against the Phase 49 contract that broad `generated-outputs` must remain unpromoted.

**Fix:**

```bash
verify_generated_outputs_in_progress() {
	local total_count
	local in_progress_count
	total_count="$(awk -F '\t' '$1 == "generated-outputs" { count++ } END { print count + 0 }' "${status_file}")"
	in_progress_count="$(awk -F '\t' '$1 == "generated-outputs" && $2 == "in progress" { count++ } END { print count + 0 }' "${status_file}")"

	if [[ "${total_count}" != "1" || "${in_progress_count}" != "1" ]]; then
		error "packages/parity/status.tsv: generated-outputs must be exactly one in progress row, found ${total_count} total and ${in_progress_count} in progress"
	fi
}
```

Add a mutation test that appends a `generated-outputs	verified	...` row and expects the verifier to fail.

### WR-02: Unsupported Structural Fields Can Bypass the Closed Field Count

**File:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:120`

**Issue:** `require_section_table_body_row_count` only counts rows matching `^\| [a-z0-9_]+ \|`. An added structural row such as `| geometry-count | unsupported generated-output semantics | ... |` is still a Markdown table row in the structural scope section, but it is not counted. Because all 16 required exact rows remain present, the verifier passes with an unsupported field in the closed contract.

**Fix:**

```bash
count="$(awk -v section="${section}" '
	$0 == section { in_section = 1; next }
	in_section && /^## / { exit }
	in_section && /^\| Structural Field \|/ { next }
	in_section && /^\| --- \|/ { next }
	in_section && /^\| / { count++ }
	END { print count + 0 }
' "${file}")"
```

Prefer an allowlist check that rejects any table row in the section that is not one of the 16 exact allowed rows. Add a mutation test with a hyphenated or spaced unsupported field name, not only `geometry_count`.

### WR-03: Overclaim Rejection Is Too Exact-String Dependent

**File:** `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:206`

**Issue:** `reject_overclaiming_text` rejects a fixed list of exact strings. A contradictory line such as `Phase 49 structural verification proves byte-for-byte G-code parity.` passes because the blacklist only includes `Phase 49 structural evidence proves byte-for-byte G-code parity`. This leaves the docs vulnerable to near-identical overclaims that the Phase 49 verifier is supposed to block.

**Fix:** Replace or supplement the exact-string list with a regex-based guard for Phase 49 proof/verification claims near deferred terms, while preserving the required negative wording.

```bash
local overclaim_pattern='Phase 49[^.]*\b(proves|verified|verifies)\b[^.]*\b(byte-for-byte G-code parity|full generated-output parity|broad generated-output parity|toolpath geometry|printability|printer-runtime behavior|support generation|wall seam behavior|arc fitting|GUI export/viewer behavior|release behavior|network/device behavior|non-Prusa fork behavior|Bambu Studio support|OrcaSlicer support|upstream source imports|sync automation)\b'
if grep -Eiq -- "${overclaim_pattern}" "${checked_file}"; then
	error "${checked_label}: forbidden Prusa G-code scope overclaim"
fi
```

Add mutation tests for at least one `Phase 49 structural verification proves ...` sentence and one non-Prusa fork support overclaim variant.

---

_Reviewed: 2026-06-16T16:35:19Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
