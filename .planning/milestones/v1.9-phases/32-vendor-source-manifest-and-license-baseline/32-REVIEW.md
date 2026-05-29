---
phase: 32-vendor-source-manifest-and-license-baseline
reviewed: 2026-05-26T17:05:09Z
depth: standard
files_reviewed: 7
files_reviewed_list:
  - docs/port/README.md
  - docs/port/package-map.md
  - packages/fork-vendors/BUILD.bazel
  - packages/fork-vendors/README.md
  - packages/fork-vendors/forks.tsv
  - packages/fork-vendors/verify_forks.sh
  - packages/fork-vendors/verify_forks_test.sh
findings:
  critical: 0
  warning: 0
  info: 0
  total: 0
status: clean
resolved_findings:
  warning: 2
resolution_commit: 06093b870
---

# Phase 32: Code Review Report

**Reviewed:** 2026-05-26T17:05:09Z
**Depth:** standard
**Files Reviewed:** 7
**Status:** clean after fixes

## Summary

Reviewed the fork vendor registry docs, Bazel target, TSV data, verifier, and verifier tests with focus on Bash 3.2 compatibility, TSV parsing edge cases, command-injection risk, false-positive verifier behavior, and parity/legal overclaiming.

Material guidance consulted: `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the pinned Bright Builds standards pages for [standards index](https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md), [code shape](https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md), [verification](https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md), and [testing](https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md). No repo-local skills were present under `.claude/skills/` or `.agents/skills/`.

No command-injection issue was found: registry fields are passed to `git ls-remote` as quoted arguments, and `refresh_command` is not executed. The docs consistently describe Phase 32 as intake metadata only and avoid claiming fork parity or legal review. The remaining issues are verifier false positives for malformed or misclassified registry data.

Verification run during review:

- `/bin/bash --version` reported Bash 3.2.57.
- `/bin/bash -n packages/fork-vendors/verify_forks.sh`
- `/bin/bash -n packages/fork-vendors/verify_forks_test.sh`
- `/bin/bash packages/fork-vendors/verify_forks_test.sh`
- `bazel test //packages/fork-vendors:verify_forks_test` passed from cache.
- `shellcheck -s bash packages/fork-vendors/verify_forks.sh packages/fork-vendors/verify_forks_test.sh`
- `git diff --check -- ...`
- `awk -F '\t' 'NF != 21 { print FNR ":" NF }' packages/fork-vendors/forks.tsv`

## Resolved Warnings

### WR-01: Lightweight tag rows can pass even when the remote tag is annotated

**File:** `packages/fork-vendors/verify_forks.sh:125`

**Issue:** `verify_tag_ref` only handles the lightweight case when the peeled ref is absent. If a registry row labels a tag as `lightweight` but records the remote annotated tag object in `tag_ref_sha` and the peeled commit in `peeled_commit_sha`, `git ls-remote --tags` returns both refs and the verifier accepts the row. That is a false positive for the `tag_kind` metadata and lets the source baseline misrepresent the upstream tag type.

**Fix:**

```bash
if [[ "${tag_kind}" == "lightweight" ]]; then
	if [[ -n "${actual_peeled_commit_sha}" ]]; then
		error "${vendor_id}: recorded lightweight tag ${selected_stable_tag}, but remote exposes peeled annotated tag ${peeled_ref}"
	fi
	actual_peeled_commit_sha="${actual_tag_ref_sha}"
fi
```

Add a verifier test where the fake `Annotated` repo is recorded with `tag_kind=lightweight`, `tag_object_sha=-`, the annotated tag object as `tag_ref_sha`, and the peeled commit as `peeled_commit_sha`; it should fail before reporting `ok:`.

**Resolution:** Fixed in `06093b870` by failing lightweight rows when the remote
exposes a peeled annotated tag and adding a regression test for the
misclassified-row case.

### WR-02: CRLF registry rows pass despite the LF-only TSV contract

**File:** `packages/fork-vendors/verify_forks.sh:153`

**Issue:** The README requires LF row delimiters and no field newlines, but the verifier never rejects carriage returns. A CRLF registry can pass when the `\r` lands in the final `caution_notes` field, and a CRLF header is skipped as a comment. That creates a false-positive verification result for a registry that violates the documented fixed-column format and leaves hidden `\r` bytes in parsed metadata.

**Fix:**

```bash
if [[ "${line}" == *$'\r'* ]]; then
	error "row ${row_number}: registry must use LF row delimiters and fields must not contain carriage returns"
fi

if [[ -z "${line}" || "${line}" == \#* ]]; then
	continue
fi
```

Add a test fixture that writes at least one otherwise-valid row with CRLF endings and asserts the verifier fails before any `git` lookup.

**Resolution:** Fixed in `06093b870` by rejecting carriage returns before blank
or comment handling and adding a CRLF regression test that confirms no Git lookup
runs.

## Final Status

All review warnings were addressed. Follow-up verification passed:

- `bash -n packages/fork-vendors/verify_forks.sh`
- `bash -n packages/fork-vendors/verify_forks_test.sh`
- `bash packages/fork-vendors/verify_forks_test.sh`
- `bazel test //packages/fork-vendors:verify_forks_test`
- `bazel run //packages/fork-vendors:verify`
- `git diff --check -- packages/fork-vendors/verify_forks.sh packages/fork-vendors/verify_forks_test.sh`

---

_Reviewed: 2026-05-26T17:05:09Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
