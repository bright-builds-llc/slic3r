---
phase: 50-structural-g-code-fixture-expansion
verified: 2026-06-17T17:36:49Z
status: passed
score: "3/3 must-haves verified"
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 50-2026-06-17T16-13-19
generated_at: 2026-06-17T17:36:49Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 50: Structural G-code Fixture Expansion Verification Report

**Phase Goal:** Maintainers have source-pinned Prusa structural G-code fixture expectations that are verifiable before Rust structural parsing or parity commands rely on them.
**Verified:** 2026-06-17T17:36:49Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Maintainer can inspect the expanded Prusa G-code fixture surface with a checked-in expected structural summary artifact for the accepted Prusa `set_speed` evidence slice. | VERIFIED | `expected-gcode-structural-summary.tsv` exists with the exact six-column header, 16 data rows, one row per allowed Phase 49 field, locked source ref, fixture path, fixture ID, source literal, counts, ordered markers, booleans, and marker counts. Independent fixture audit returned total=4, g1=4, movement/extrusion=false, temperature/tool-change=0. |
| 2 | Maintainer can run a Bazel-owned fixture verifier that checks the exact structural summary schema, required rows, provenance, and update rules. | VERIFIED | `packages/parity-fixtures/BUILD.bazel` exports the sidecar, defines `prusa_gcode_output_expected_gcode_structural_summary`, includes it in `prusa_gcode_output_bundle`, verifier/test data, and `package_boundary`. Direct `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` passed. Bazel query confirms the alias and bundle membership. |
| 3 | Maintainer can see fixture mutation tests fail closed for structural summary drift, missing rows, duplicate rows, unsupported fields, unsupported broad-behavior claims, and provenance mismatch. | VERIFIED | `verify_prusa_gcode_output_fixture_test.sh` contains six structural mutation tests and post-review `assert_contains_all` diagnostics. Direct mutation suite passed. Orchestrator also reported `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test` passed after fix commit `1261ca920`. |

**Score:** 3/3 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv` | Source-pinned structural expected summary sidecar | VERIFIED | Exists, exact 17-line TSV shape, exact closed field set, no forbidden `sha256`, `bytes`, status, or parity target metadata. |
| `packages/parity-fixtures/BUILD.bazel` | Bazel ownership for the structural TSV | VERIFIED | Sidecar appears in `exports_files`, alias, `prusa_gcode_output_bundle`, verifier/test runfiles through the bundle, and `package_boundary`. |
| `packages/parity-fixtures/README.md` | Package-level sidecar route without status ownership changes | VERIFIED | Documents Phase 50 sidecar as fixture-owned and explicitly says it does not update `packages/parity/status.tsv`, `packages/parity/BUILD.bazel`, or Rust structural parsing. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md` | Fixture-local provenance and deferred ownership docs | VERIFIED | Names the structural artifact, source ref, source literal, update route, and keeps Rust structural parsing Phase 51-owned and public structural parity/status Phase 52-owned. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` | Fail-closed structural sidecar verifier | VERIFIED | Checks header, column count, exact rows, allowed fields, duplicate/missing fields, provenance alignment, structural values, update route, forbidden metadata, and overclaims. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | Mutation coverage for GCFIX-03 | VERIFIED | Covers structural value drift, missing row, duplicate row, unsupported field, structural overclaim, and provenance mismatch with exact diagnostic-fragment assertions. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `BUILD.bazel` | `expected-gcode-structural-summary.tsv` | Export, alias, bundle, verifier/test data, package boundary | WIRED | `bazel query //packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary`, bundle query, and package-boundary query all include the sidecar. |
| `verify_prusa_gcode_output_fixture.sh` | `expected-gcode-structural-summary.tsv` | Default path and explicit argument mode | WIRED | `structural_summary_file` is set in zero-arg mode, accepted as arg 4 in explicit mode, included in required files, and passed by the mutation harness. |
| `verify_prusa_gcode_output_fixture.sh` | `fixture-provenance.tsv` | Exact provenance row plus structural source/fixture checks | WIRED | Verifier checks the exact provenance row and fails structural rows whose `source_ref`, `fixture_path`, `fixture_id`, or source literal diverge from the locked values. |
| Fixture/package docs | Status/Rust ownership | Explicit deferral text | WIRED | Docs expose the sidecar while preserving Phase 51 Rust parser ownership and Phase 52 public structural parity/status ownership. |

Note: `gsd-tools verify key-links` could not resolve shortened plan-frontmatter source names such as `verify_prusa_gcode_output_fixture.sh`; the actual file paths were verified manually.

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| `expected-gcode-structural-summary.tsv` | Structural rows | Checked-in Prusa `gcodewriter-set-speed.gcode` fixture plus locked Phase 49 field contract | Yes - exact source/fixture/count/marker rows | VERIFIED |
| `verify_prusa_gcode_output_fixture.sh` | `structural_summary_file` | Bazel runfiles/default checkout path or explicit temp-checkout argument | Yes - reads the checked-in sidecar and validates all rows | VERIFIED |
| `verify_prusa_gcode_output_fixture_test.sh` | Mutated structural sidecar copies | Temp checkout fixture copies | Yes - each mutation changes one real sidecar row or boundary claim and must fail | VERIFIED |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Structural TSV has exact closed field shape | `awk -F '\t' ... expected-gcode-structural-summary.tsv` | `ok structural rows=16` | PASS |
| Verifier shell syntax is valid | `bash -n packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | exit 0 | PASS |
| Fixture verifier accepts valid checkout | `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` | `ok: Prusa G-code output fixture verification passed` | PASS |
| Mutation suite enforces fail-closed cases | `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | `ok: verify_prusa_gcode_output_fixture_test` | PASS |
| Bazel owns sidecar alias | `bazel query //packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary` | Label returned | PASS |
| Bazel bundle owns sidecar | `bazel query 'labels(srcs, //packages/parity-fixtures:prusa_gcode_output_bundle)'` | Sidecar label returned | PASS |
| Bazel package boundary owns sidecar | `bazel query labels(srcs, //packages/parity-fixtures:package_boundary)` with `rg expected-gcode-structural-summary.tsv` | Sidecar label returned | PASS |
| Shell and Markdown formatting/static checks | `shfmt -d`, `shellcheck`, `mdformat --check`, `git diff --check` | exit 0 | PASS |

Orchestrator-provided post-review evidence also passed: Bazel fixture verifier/test, scope verifier/test, `git diff --check`, and GSD schema drift check with `drift_detected: false`.

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| GCFIX-01 | 50-01 | Structural sidecar exists, is source-pinned, scoped to selected fixture, and contains only allowed structural handoff fields. | SATISFIED | Sidecar exact schema/rows verified; source ref, fixture path, source literal, fixture ID, and structural values match the accepted Prusa `set_speed` slice; forbidden metadata/status terms absent. |
| GCFIX-02 | 50-01, 50-02 | Bazel/package/docs expose and explain the sidecar without changing parity status ownership. | SATISFIED | BUILD wiring verified by Bazel query; docs expose sidecar and defer Rust/public status ownership; `packages/parity/status.tsv` still has broad `generated-outputs` in progress and narrow summary-only `fork.prusaslicer.gcode-output`. |
| GCFIX-03 | 50-02 | Verifier/test coverage fails closed for structural drift, missing/duplicate rows, unsupported fields, overclaims, and provenance mismatch. | SATISFIED | Mutation tests cover all six failure classes; direct Bash mutation suite passed; review warning about broad diagnostic assertions was fixed in commit `1261ca920`. |

No orphaned Phase 50 requirements were found in `.planning/REQUIREMENTS.md`.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| None | - | - | - | No blocker or warning anti-patterns found. The only broad scan hit was `tmp_dir` in the test harness, which is normal temp-checkout setup, not a stub. |

### Human Verification Required

None. Phase 50 produces checked-in fixture data, Bash verifier behavior, Bazel ownership, and docs; all goal-critical behavior is programmatically checkable and passed.

### Gaps Summary

No gaps found. The phase achieved its goal: the Prusa G-code structural fixture sidecar is inspectable, source-pinned, narrowly scoped, Bazel-owned, verifier-enforced, mutation-tested, and does not widen parity claims or status ownership.

---

_Verified: 2026-06-17T17:36:49Z_
_Verifier: the agent (gsd-verifier)_
