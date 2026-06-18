---
phase: 52-executable-structural-g-code-evidence
verified: 2026-06-18T03:34:44Z
status: passed
score: "3/3 must-haves verified"
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 52-2026-06-18T01-09-43
generated_at: 2026-06-18T03:34:44Z
lifecycle_validated: true
requirements-verified: [GCEV-01, GCEV-02, GCEV-03]
overrides_applied: 0
---

# Phase 52: Executable Structural G-code Evidence Verification Report

**Phase Goal:** Maintainers can run structural Prusa G-code evidence and inspect status/docs that publish only the exact narrow evidence slice.
**Verified:** 2026-06-18T03:34:44Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

Phase 52 passes. The public `//packages/parity:prusaslicer_gcode_output_parity` command validates the original and structural Prusa G-code expected summaries through the Rust boundary, the command-level mutation guard fails closed on `command_count_g1`, and status/package/port docs publish only the narrow `fork.prusaslicer.gcode-output` structural evidence slice while keeping broad `generated-outputs` in progress.

### Observable Truths

| # | Truth | Status | Evidence |
|---|---|---|---|
| 1 | Maintainer can run a public Bazel parity command that validates the structural Prusa G-code expected summary through the Rust boundary and checked-in fixture expectations. | VERIFIED | `packages/parity/BUILD.bazel:140` keeps the public target and wires `prusa_gcode_output_expected_gcode_structural_summary`; `compare_prusaslicer_gcode_output.sh:229` and `:235` invoke the Rust summary binary with `--structural`; `prusa_gcode_output_summary.rs:14` dispatches `--structural`; `prusa_gcode_output.rs:760` projects parsed structural facts. `bazel run //packages/parity:prusaslicer_gcode_output_parity` passed and printed `structural_rows: 16`, `command_counts: total=4 g1=4`, ordered markers, movement/extrusion flags, and temperature/tool-change counts. |
| 2 | Maintainer can see the public parity command fail closed on a structural-summary mutation guard, not only the v1.12 marker-line drift guard. | VERIFIED | `compare_prusaslicer_gcode_output_test.sh:83` mutates `command_count_g1` from `4` to `3`; lines `152-157` require the comparator to fail and report `expected-gcode-structural-summary.tsv` plus `command_count_g1`. `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test` passed. |
| 3 | Maintainer can inspect parity status, package docs, and port docs that describe only the exact narrow structural slice while keeping broad generated-output/runtime/fork surfaces deferred. | VERIFIED | `packages/parity/status.tsv:18` is exactly one verified `fork.prusaslicer.gcode-output` row naming the Phase 49/50/51/52 structural chain; `packages/parity/status.tsv:14` keeps `generated-outputs` as `in progress`. Package docs name the structural chain in `packages/parity/README.md`, fixture docs, scope docs, and Rust docs. Port docs publish the same boundary in `docs/port/parity-matrix.md:15`, `docs/port/README.md:136`, `docs/port/migration-guidance.md:86`, and `docs/port/package-map.md:173`. Deferred-surface scans found the required byte-for-byte, geometry/toolpath, printability, runtime, GUI, release, non-Prusa fork, upstream import, and sync deferrals. |

**Score:** 3/3 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| Rust structural boundary and CLI adapter | `prusa_gcode_output_structural_summary_lines`, re-export, `--structural` mode, focused tests | VERIFIED | Artifact helper passed Plan 52-01 4/4. Manual inspection confirmed parser flow at `prusa_gcode_output.rs:648`, structural summary lines at `:760`, and CLI mode at `prusa_gcode_output_summary.rs:14`. |
| Public parity target and mutation guard | Bazel data/args, comparator structural validation, `command_count_g1` guard | VERIFIED | Artifact helper passed Plan 52-02 3/3. `BUILD.bazel:140-158` wires both TSVs; comparator validates both through Rust; mutation test covers summary and structural drift. |
| Status and verifier enforcement | Structural status row, fixture verifier status contract, scope verifier status contract | VERIFIED | Artifact helper passed Plans 52-03 and 52-04. Direct awk check found `generated_outputs_total=1 generated_outputs_in_progress=1 fork_rows=1 fork_verified_target=1`. Fixture and scope verifiers both passed. |
| Package docs | Parity, fixture, fixture-local, and Rust README wording | VERIFIED | Artifact helper passed Plan 52-05 4/4. Docs describe the Phase 49 closed structural scope contract, Phase 50 sidecar, Phase 51 Rust parser/readiness, and Phase 52 public command while preserving deferrals. |
| Port docs | README, parity matrix, migration guidance, package map | VERIFIED | Artifact helper passed 3/4 and produced one literal false positive: `docs/port/package-map.md` says `Phase 49 owns the closed structural scope contract` rather than the exact substring `Phase 49 closed structural scope contract`. Manual check verified the required ownership/chain wording at `package-map.md:173-185`; this is not a goal gap. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `BUILD.bazel` | Structural sidecar fixture target | Bazel `data` and args | VERIFIED | Key-link helper passed Plan 52-02. Public target includes `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary`. |
| Comparator | Rust summary binary | `--structural` invocation | VERIFIED | `compare_prusaslicer_gcode_output.sh:229` and `:235` call the Rust binary in structural mode and fail on parse/diff errors. |
| Mutation test | Structural sidecar | Temp-copy mutation of `command_count_g1` | VERIFIED | `compare_prusaslicer_gcode_output_test.sh:148-157` mutates only the structural expected artifact and asserts structural diagnostics. |
| Fixture/scope verifiers | `packages/parity/status.tsv` | Exact structural `GCODE_OUTPUT_STATUS_ROW` | VERIFIED | Plan 52-03/52-04 key-link helpers verified status-row enforcement. |
| Port docs | `packages/parity/status.tsv` | Status wording for narrow fork row and broad row | VERIFIED | Key-link helper missed escaped regex text; manual `rg` found `fork.prusaslicer.gcode-output` and `generated-outputs` in both `status.tsv` and `docs/port/parity-matrix.md`. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| `prusaslicer_gcode_output_parity` | Bazel runfiles args | `expected-gcode-summary.tsv`, `expected-gcode-structural-summary.tsv`, provenance, Rust binary | Yes | VERIFIED - public target passes both checked-in summary artifacts separately as Rust input and expected artifact. |
| `compare_prusaslicer_gcode_output.sh` | `actual_structural_summary` | `summary_binary --structural rust_structural_input` | Yes | VERIFIED - structural output is generated by Rust, diffed against Rust output for the expected artifact, and exact fields are asserted before success output. |
| `prusa_gcode_output_structural_summary_lines` | `facts` | `parse_prusa_gcode_output_structural_summary(input)?` over caller-supplied TSV | Yes | VERIFIED - parser validates header, row order, duplicates, missing/extra rows, source/fixture identity, values, and boundaries before facts are projected. |
| `packages/parity/status.tsv` | `fork.prusaslicer.gcode-output`, `generated-outputs` rows | Checked-in TSV consumed by `bazel run //packages/parity:status` and verifiers | Yes | VERIFIED - one narrow verified fork row and one broad in-progress row. |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Public structural parity command runs | `bazel run //packages/parity:prusaslicer_gcode_output_parity` | Printed `ok: fork.prusaslicer.gcode-output structural parity passed`, `structural_rows: 16`, and `command_counts: total=4 g1=4` | PASS |
| Command-level mutation guard fails closed | `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test` | 1/1 test passed | PASS |
| Fixture verifier accepts current structural sidecar/status contract | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` | `ok: Prusa G-code output fixture verification passed` | PASS |
| Scope verifier accepts current structural publication boundary | `bazel run //packages/prusa-gcode-output-scope:verify` | `ok: Prusa G-code output scope verification passed` | PASS |
| Status command publishes expected rows | `bazel run //packages/parity:status` | Shows `generated-outputs in progress` and `fork.prusaslicer.gcode-output verified` on the structural command | PASS |
| Requested regression gate | `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test //packages/parity:prusaslicer_gcode_output_parity_failure_test` | 4/4 tests passed | PASS |
| Schema drift gate | `gsd-tools verify schema-drift 52` | `drift_detected: false`, `blocking: false` | PASS |
| Lifecycle provenance | `gsd-tools verify lifecycle 52 --require-plans --raw` | `valid` | PASS |
| Shell syntax | `bash -n ...` over Phase 52 shell scripts | Exit 0 | PASS |
| Whitespace | `git diff --check` | Exit 0 | PASS |

### Review And Fix Gates

| Gate | Status | Evidence |
|---|---|---|
| WR-01 fixed | VERIFIED | `52-REVIEW-FIX.md` records fix commit `20de1b3ce`; `git show --stat --oneline 20de1b3ce` shows the fixture-local README and fixture verifier were updated. |
| Latest review clean | VERIFIED | `52-REVIEW.md` frontmatter reports `critical: 0`, `warning: 0`, `info: 0`, `total: 0`, `status: clean`; body states the stale fixture-local summary-only wording warning is no longer present. |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| GCEV-01 | 52-01, 52-02 | Public Bazel parity command validates structural expected summary through Rust and checked-in fixture expectations. | SATISFIED | Public target remains `//packages/parity:prusaslicer_gcode_output_parity`, structural sidecar is runfile data, comparator invokes `--structural`, and public command passed with structural facts. |
| GCEV-02 | 52-02 | Public parity command has a fail-closed structural-summary mutation guard. | SATISFIED | `command_count_g1` mutation guard exists and the Bazel failure test passed. |
| GCEV-03 | 52-03 through 52-06 | Status/package/port docs publish only the exact narrow structural slice and keep broad/deferred surfaces explicit. | SATISFIED | `status.tsv`, package READMEs, scope docs, and port docs all describe narrow structural evidence; broad `generated-outputs` remains exactly one `in progress` row; deferred-surface scans passed. |

No orphaned Phase 52 requirements were found. `.planning/REQUIREMENTS.md` maps GCEV-01, GCEV-02, and GCEV-03 to Phase 52, and Phase 52 summaries carry matching `requirements-completed` metadata.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| Shell test/comparator scripts | 16-21 / 196 | `mktemp` templates containing `XXXXXX` | Info | Legitimate `mktemp` syntax, not placeholder implementation. |

No TODO/FIXME/HACK, placeholder implementation, empty return, hardcoded empty visible output, console-log-only implementation, stale summary-only publication wording, or broad generated-output promotion was found in the Phase 52 scope.

### Disconfirmation Pass

- Possible hollow command: checked that the public target does not trust TSV bytes alone; it calls the Rust binary for both summary and structural artifacts before printing success.
- Possible misleading mutation coverage: checked that the test still covers legacy `line_4` drift and adds a separate structural `command_count_g1` drift path.
- Possible docs overclaim: checked status/docs for exact `generated-outputs in progress` wording and explicit deferred surfaces.

### Human Verification Required

None. Phase 52 produces file-based CLI, Bash, Rust, TSV, and documentation evidence; the goal-critical behaviors are programmatically checkable and passed.

### Gaps Summary

No blocking gaps found. Two GSD helper checks produced literal false positives: one exact substring mismatch in `docs/port/package-map.md` and two escaped-regex key-link misses. Manual checks and executable gates verified the intended artifacts and links, so these are recorded as verifier-tool limitations rather than phase gaps.

### Provenance And Standards

Lifecycle provenance is valid: `52-CONTEXT.md`, all six plans, all six summaries, and this verification use `lifecycle_mode: yolo` and `phase_lifecycle_id: 52-2026-06-18T01-09-43`.

Repo guidance and standards consulted: `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` with no active exceptions, Bright Builds canonical `standards/index.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/verification.md`, `standards/core/testing.md`, and `standards/languages/rust.md` at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`. No project-local `.claude/skills/` or `.agents/skills/` directory exists in this checkout.

---

_Verified: 2026-06-18T03:34:44Z_
_Verifier: the agent (gsd-verifier)_
