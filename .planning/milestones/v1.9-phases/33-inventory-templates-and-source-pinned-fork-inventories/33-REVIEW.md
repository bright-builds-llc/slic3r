---
phase: 33-inventory-templates-and-source-pinned-fork-inventories
reviewed: 2026-05-26T18:17:48Z
depth: standard
files_reviewed: 11
files_reviewed_list:
  - docs/port/README.md
  - docs/port/package-map.md
  - packages/fork-inventories/BUILD.bazel
  - packages/fork-inventories/README.md
  - packages/fork-inventories/bambustudio.tsv
  - packages/fork-inventories/category-map.tsv
  - packages/fork-inventories/inventory-template.tsv
  - packages/fork-inventories/orcaslicer.tsv
  - packages/fork-inventories/prusaslicer.tsv
  - packages/fork-inventories/verify_inventories.sh
  - packages/fork-inventories/verify_inventories_test.sh
findings:
  critical: 0
  warning: 0
  info: 0
  total: 0
status: clean
---

# Phase 33: Code Review Report

**Reviewed:** 2026-05-26T18:17:48Z
**Depth:** standard
**Files Reviewed:** 11
**Status:** clean

## Summary

Reviewed the fork inventory docs, TSV data, Bazel package boundary, Bash verifier, and verifier tests. The checked-in TSV rows are internally consistent, source refs match the current fork vendor registry, and the docs keep runtime fork support, cloud/network integrations, credentials, and non-free plugin ingestion explicitly out of scope.

This review was informed by `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the pinned Bright Builds standards for architecture, code shape, verification, and testing. No repo-local `.claude/skills/` or `.agents/skills/` skills were present.

Verification run:

- `bash -n packages/fork-inventories/verify_inventories.sh packages/fork-inventories/verify_inventories_test.sh` passed.
- `packages/fork-inventories/verify_inventories.sh` passed.
- `bazel run //packages/fork-inventories:verify` passed.
- `bazel test //packages/fork-inventories:verify_inventories_test` passed from cache.
- `git diff --check -- <reviewed files>` passed.
- `shellcheck -x` reported quoting and unused-variable diagnostics, and `shfmt -d` reported formatting differences. The correctness findings below are the issues that materially affect verifier behavior.

## Warning Findings Resolved

### WR-01: Required coverage is skipped when a canonical fork has no rows - RESOLVED

**File:** `packages/fork-inventories/verify_inventories.sh:493`
**Issue:** `validate_required_surfaces` returns success when `vendor_has_rows` is false. That makes required coverage conditional on already having at least one inventory row, so a canonical fork file can be reduced to only the header and the category map can omit that fork entirely while `verify_inventories.sh` still passes. A focused probe with header-only `bambustudio.tsv` and `orcaslicer.tsv`, a consistent Prusa-only category map, and the real `forks.tsv` passed with `ok: inventory verification passed`.
**Resolution:** `validate_required_surfaces` now gates on canonical vendor refs
from `packages/fork-vendors/forks.tsv`, and
`test_header_only_canonical_vendor_coverage_fails` covers the regression.

### WR-02: Orca network caution coverage is not enforced - RESOLVED

**File:** `packages/fork-inventories/verify_inventories.sh:522`
**Issue:** The Orca required-surface list omits `network-device`. The current `orcaslicer.tsv` includes `orcaslicer.network-device`, but deleting that row and removing only that ID from `network.deferred` still passes verification. This can silently drop the deferred network/cloud/plugin caution for a fork whose vendor registry records `non-free-network-plugin`, `optional-network-plugin`, and `network-device-surface`.
**Resolution:** `network-device` is now required for OrcaSlicer coverage, and
`test_missing_orca_network_device_coverage_fails` covers the regression.

### WR-03: Valid release pins fail when the selected tag equals the observed branch head - RESOLVED

**File:** `packages/fork-inventories/verify_inventories.sh:214`
**Issue:** `validate_pin_ref` rejects any `source_ref` whose commit equals `observed_default_branch_head` before it checks whether the full ref equals the selected stable tag and peeled commit. If a selected stable release tag currently points at the default branch head, the exact accepted ref `<vendor_id>:<selected_stable_tag>@<peeled_commit_sha>` is rejected as branch-head evidence. A focused fixture with `selected_stable_tag=v1.0.0`, `peeled_commit_sha` equal to `observed_default_branch_head`, and a matching `source_ref` failed with `source_ref uses observed default branch head`.
**Resolution:** The verifier now checks exact selected-tag refs before the
observed-branch-head diagnostic, and
`test_selected_tag_can_equal_observed_branch_head` covers the regression.

## Final Status

All warning findings were fixed in `8398f0b49 fix(33-01): harden inventory
verifier`. The review gate is clean after rerunning:

- `bash -n packages/fork-inventories/verify_inventories.sh`
- `bash -n packages/fork-inventories/verify_inventories_test.sh`
- `bash packages/fork-inventories/verify_inventories_test.sh`
- `bazel test //packages/fork-inventories:verify_inventories_test`
- `bazel run //packages/fork-inventories:verify`
- `git diff --check -- packages/fork-inventories/verify_inventories.sh packages/fork-inventories/verify_inventories_test.sh`

---

_Reviewed: 2026-05-26T18:17:48Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_
