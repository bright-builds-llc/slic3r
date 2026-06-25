---
phase: 60-executable-arc-fitting-evidence
verified: 2026-06-24T17:37:50Z
status: passed
score: 4/4 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T17:37:50Z
lifecycle_validated: true
overrides_applied: 0
re_verification:
  previous_status: gaps_found
  previous_score: 2/4
  gaps_closed:
    - "WR-01: fixture/scope docs verifiers allowed `full generated-output parity verified`."
  gaps_remaining: []
  regressions: []
---

# Phase 60: Executable Arc-Fitting Evidence Verification Report

**Phase Goal:** Maintainers can run public executable arc-fitting evidence and inspect exact public status/docs for the narrow PrusaSlicer arc-fitting slice.
**Verified:** 2026-06-24T17:37:50Z
**Status:** passed
**Re-verification:** Yes - after blocker fix commit `f40925aca`

Verification followed `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, `bright-builds-rules.audit.md`, and the GSD verifier override/gate references. The repo-local `standards/index.md` file is not present, so local Bright Builds page loading was unavailable; the managed sidecar and audit manifest were used for applicable verification rules.

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|---|---|---|
| 1 | Maintainer can run public Prusa arc-fitting parity evidence that validates the checked-in arc summary artifact through the Rust boundary while preserving the existing public Prusa G-code output command contract. | VERIFIED | `bazel run //packages/parity:prusaslicer_arc_fitting_parity` passed and printed the approved source, fixture, G2/G3, direction, offset, bounds, extrusion, feedrate, and `checked-in-arc-summary-only` facts. `bazel run //packages/parity:prusaslicer_gcode_output_parity` still passed. |
| 2 | Maintainer can see fail-closed mutation guards for G2/G3 command-count changes, arc direction changes, center-offset changes, coordinate-bound changes, extrusion or feedrate observation changes, source identity drift, fixture identity drift, and unsupported deferred-behavior claims. | VERIFIED | `bazel test --cache_test_results=no //packages/parity:prusaslicer_arc_fitting_parity_failure_test --test_output=errors` passed. `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh:343` and `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh:557` now add mutation cases for `full generated-output parity verified`. |
| 3 | Maintainer can inspect parity status, package docs, and port docs that describe only the exact narrow `fork.prusaslicer.arc-fitting` evidence slice while broad `generated-outputs` remains `in progress` and all generated-output, runtime, GUI, release, sync, and non-Prusa fork deferrals remain explicit. | VERIFIED | Status counts are exact: one `fork.prusaslicer.arc-fitting` row targeting `//packages/parity:prusaslicer_arc_fitting_parity`, one `generated-outputs` row with status `in progress`, and one existing `fork.prusaslicer.gcode-output` row. Docs grep found narrow arc-fitting wording and deferrals across package, fixture, scope, and port docs. Direct temp-copy mutations with `full generated-output parity verified` now fail both docs verifier paths. |
| 4 | Maintainer can confirm the existing `fork.prusaslicer.gcode-output` meaning is not widened by arc-fitting evidence publication. | VERIFIED | `packages/parity/status.tsv:18` remains the existing semantic G-code row, `packages/parity/status.tsv:19` is the separate arc-fitting row, and the existing G-code public command passed. |

**Score:** 4/4 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_arc_fitting_summary.rs` | Thin Rust CLI over `prusa_arc_fitting_summary_lines` | VERIFIED | Exists, substantive, Bazel-wired as `:prusa_arc_fitting_summary`, reads the summary file, delegates to Rust parser, and reports errors without `unwrap`. |
| `packages/parity/compare_prusaslicer_arc_fitting.sh` | Public comparator for checked-in arc summary evidence | VERIFIED | Validates checked-in summary through Rust, diffs expected and actual summary lines, asserts exact approved arc facts, and prints narrow public output. |
| `packages/parity/compare_prusaslicer_arc_fitting_test.sh` | Public mutation suite for ARCEV-02 drift classes | VERIFIED | Public target passed; tests mutate temp copies and cover command counts, direction, offsets, bounds, extrusion, feedrate, source, fixture, and deferred-claim boundary. |
| `packages/parity/status.tsv` | Exact narrow status row plus preserved broad/G-code rows | VERIFIED | Manual awk check found `arc_count=1`, `generated_count=1`, `generated_status=in progress`, `gcode_count=1`; GSD pattern checks had false negatives where plan frontmatter escaped tabs/regexes literally. |
| `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` | Fixture/status/docs verifier with overclaim deny-list | VERIFIED | Line 245 contains the split deny-list term for `full generated-output parity verified`; direct mutation now fails with `README.md: forbidden text`. |
| `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh` | Fixture verifier mutation coverage | VERIFIED | Lines 343-357 append `full generated-output parity verified` to a temp README and require verifier failure. Focused Bazel test passed uncached. |
| `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` | Scope/status/docs verifier with overclaim deny-list | VERIFIED | Lines 337 and 365 include `full generated-output parity` coverage; direct mutation now fails with `forbidden Prusa arc-fitting scope claim`. |
| `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh` | Scope verifier mutation coverage | VERIFIED | Lines 557-570 append `full generated-output parity verified` to a temp README and require verifier failure. Focused Bazel test passed uncached. |
| `packages/parity/README.md`, `packages/parity-fixtures/*README.md`, `packages/prusa-arc-fitting-scope/*`, `docs/port/*` | Public narrow arc-fitting docs | VERIFIED | Docs name the command/status row, keep `generated-outputs` in progress, keep G-code output separate, and do not contain the forbidden overclaim phrase outside verifier/test coverage. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `packages/parity/BUILD.bazel` | `//packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary` | `sh_binary` data and args | WIRED | `prusaslicer_arc_fitting_parity` passes the Rust summary binary and expected arc summary runfiles. |
| `compare_prusaslicer_arc_fitting.sh` | `expected-arc-summary.tsv` | Explicit Bazel runfile argument and Rust validation | WIRED | The public command passed and printed approved summary facts. |
| `compare_prusaslicer_arc_fitting_test.sh` | public comparator | Mutation harness invocation | WIRED | Public mutation target passed through the public comparator, not duplicated Bash validation. |
| `status.tsv` | `//packages/parity:prusaslicer_arc_fitting_parity` | Status evidence column | WIRED | Exact row present at `packages/parity/status.tsv:19`; `bazel run //packages/parity:status` shows the row. |
| Fixture verifier | status/docs/files | Exact row constants and docs checks | WIRED | Current verifier passes on live repo and rejects the WR-01 temp mutation. |
| Scope verifier | status/docs/files | Exact row constants, regex deny-list, and docs checks | WIRED | Current verifier passes on live repo and rejects the WR-01 temp mutation. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| `prusa_arc_fitting_summary.rs` | summary lines | `fs::read_to_string(path)` -> `prusa_arc_fitting_summary_lines(&input)` | Yes | FLOWING |
| `compare_prusaslicer_arc_fitting.sh` | `actual_summary`, `expected_summary_lines` | Bazel args -> Rust summary binary -> `diff` and `assert_field` | Yes | FLOWING |
| `compare_prusaslicer_arc_fitting_test.sh` | mutated expected summary fields | temp copies of checked-in `expected-arc-summary.tsv` -> public comparator | Yes | FLOWING |
| Fixture docs verifier | forbidden claim strings | deny-list -> `reject_text` over README/provenance/summary/verifier source | Yes | FLOWING |
| Scope docs verifier | forbidden claim strings and regex terms | explicit deny-list plus `overclaim_terms` regex -> `reject_text`/grep over scope docs | Yes | FLOWING |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Public arc command runs | `bazel run //packages/parity:prusaslicer_arc_fitting_parity` | Printed `ok: fork.prusaslicer.arc-fitting checked-in summary evidence passed` and approved arc facts | PASS |
| Existing G-code command preserved | `bazel run //packages/parity:prusaslicer_gcode_output_parity` | Printed `ok: fork.prusaslicer.gcode-output semantic evidence passed` | PASS |
| Public arc mutation target runs | `bazel test --cache_test_results=no //packages/parity:prusaslicer_arc_fitting_parity_failure_test --test_output=errors` | 1/1 tests passed | PASS |
| Fixture/scope overclaim mutation suites run | `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test --test_output=errors` | 2/2 tests passed | PASS |
| Live fixture/scope verifiers pass | `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh && packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` | Both printed `ok` | PASS |
| Fixture verifier rejects WR-01 mutation | Temp README append + fixture verifier | Exited nonzero with `README.md: forbidden text: full generated-output parity verified` | PASS |
| Scope verifier rejects WR-01 mutation | Temp README append + scope verifier | Exited nonzero with `README.md: forbidden Prusa arc-fitting scope claim: full generated-output parity verified` | PASS |
| Status command exposes exact rows | `bazel run //packages/parity:status` | Shows `generated-outputs in progress`, `fork.prusaslicer.gcode-output verified`, and `fork.prusaslicer.arc-fitting verified` | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| ARCEV-01 | 60-01 | Public Prusa arc-fitting evidence through Rust while preserving G-code command | SATISFIED | Public arc command and existing G-code command both pass; Rust CLI delegates to `prusa_arc_fitting_summary_lines`. |
| ARCEV-02 | 60-02 | Fail-closed mutation guards for arc drift and unsupported deferred-behavior claims | SATISFIED | Public arc mutation target passes; fixture and scope verifier tests now include the WR-01 generated-output overclaim case. |
| ARCEV-03 | 60-03 through 60-06 | Status/docs describe exact narrow slice, preserve broad deferrals, and preserve G-code row meaning | SATISFIED | Status row counts are exact, docs are narrow, current verifiers pass, and WR-01 temp mutations fail closed. |

No orphaned Phase 60 requirements were found. `.planning/REQUIREMENTS.md` maps ARCEV-01, ARCEV-02, and ARCEV-03 to Phase 60, and Phase 60 plans/summaries claim those IDs.

### Anti-Patterns Found

None blocking. Stub/placeholder scan found only legitimate Bash temp-directory initializations in test/comparator files. A forbidden-overclaim scan across public docs and `status.tsv` found no `full generated-output parity verified` claim; the phrase exists only in verifier/test guard coverage.

### Human Verification Required

None. The Phase 60 goal is fully checkable through CLI targets, exact status/docs text checks, and temp-copy mutation tests.

### Gaps Summary

No gaps remain. The previous WR-01 blocker is closed: both verifier implementations now deny `full generated-output parity verified`, both mutation suites cover that exact phrase, the focused Bazel verifier tests pass, and direct temp-copy mutations fail closed in both fixture and scope verification paths.

---

_Verified: 2026-06-24T17:37:50Z_
_Verifier: the agent (gsd-verifier)_
