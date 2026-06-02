---
phase: 40-executable-prusa-profile-parity
verified: 2026-06-02T16:02:26Z
status: passed
score: 7/7 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 40-2026-06-02T12-10-38
generated_at: 2026-06-02T16:02:26Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 40: Executable Prusa Profile Parity Verification Report

**Phase Goal:** Maintainers can run and trust the first executable PrusaSlicer parity command while docs and status clearly limit what was verified.
**Verified:** 2026-06-02T16:02:26Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

Project guidance applied: `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, Bright Builds architecture/code-shape/verification/testing/Rust standards, verifier overrides, verifier gates, verifier thinking models, and verifier calibration examples. No project-local `.claude/skills/` or `.agents/skills/` directory exists. No previous `*-VERIFICATION.md` existed for Phase 40.

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Maintainer can run a repo-owned Bazel parity command for the Prusa profile/config evidence slice. | VERIFIED | `packages/parity/BUILD.bazel` defines `sh_binary(name = "prusaslicer_profile_schema_parity")` and passes the Rust summary binary, `PrusaResearch.ini`, `expected-summary.tsv`, and fixture provenance. `bazel run //packages/parity:prusaslicer_profile_schema_parity` passed and printed `ok: fork.prusaslicer.profile-schema parity passed`, source ref, fixture, expected artifact, `sections: 6976`, and `entries: 27340`. |
| 2 | The command compares Rust-backed PrusaResearch.ini summary output to a checked-in deterministic expected artifact. | VERIFIED | `prusa_profile_schema_summary_lines` calls `parse_prusa_profile_bundle`, emits metadata/count/sample TSV lines, and is re-exported through `src/lib.rs`. The binary reads the explicit fixture path and prints those lines. The comparator runs the binary into a temp actual summary and executes `diff -u` against `expected-summary.tsv`. |
| 3 | Maintainer can see the command fail when Rust-backed parsed or normalized output diverges from checked-in expectations. | VERIFIED | `compare_prusaslicer_profile_schema_test.sh` mutates a temp copy from `section_count\t6976` to `section_count\t6975`, expects non-zero comparator exit, and asserts stderr contains `section_count` and `expected-summary.tsv`. `bazel test //packages/parity:prusaslicer_profile_schema_parity_failure_test` passed. |
| 4 | Maintainer can inspect exactly one verified status row for `fork.prusaslicer.profile-schema`. | VERIFIED | `packages/parity/status.tsv` has exactly one row for `fork.prusaslicer.profile-schema`, status `verified`, and evidence `//packages/parity:prusaslicer_profile_schema_parity`; exact awk guard passed. |
| 5 | Fixture verification requires the exact narrow Prusa status row and evidence command. | VERIFIED | `verify_status_published` in `verify_prusa_profile_schema_fixture.sh` checks status, evidence, narrow-scope notes, runtime-deferral notes, missing row, and duplicate rows. `verify_prusa_profile_schema_fixture_test.sh` covers missing, wrong status, wrong evidence, duplicate, missing narrow notes, and missing runtime deferral. Fixture verifier and tests passed. |
| 6 | Maintainer can inspect docs and parity status updates that name the exact verified Prusa profile/config evidence slice. | VERIFIED | `packages/parity/README.md`, fixture READMEs, `packages/slic3r-rust/README.md`, and `docs/port/*` name `fork.prusaslicer.profile-schema`, `//packages/parity:prusaslicer_profile_schema_parity`, `expected-summary.tsv`, `PrusaResearch.ini`, and source ref `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. `mdformat --check` passed on the docs list. |
| 7 | Full PrusaSlicer runtime support, GUI support, generated-output parity, fork release builds, profile auto-update execution, network/cloud/credential behavior, non-free plugin ingestion, and sync automation remain deferred. | VERIFIED | Scope wording is present across status/docs. Overclaim scan found no blocking verified claims for broader Prusa runtime, GUI, generated output, release, auto-update, network/cloud/credential, plugin, or sync surfaces. Matches were deferral statements such as "full PrusaSlicer runtime support remains deferred" or "do not prove full PrusaSlicer support." |

**Score:** 7/7 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` | Pure parser-backed summary line builder | VERIFIED | Exists, substantive, tested. `prusa_profile_schema_summary_lines` calls the parser, emits counts, metadata, and sample rows. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs` | Thin explicit-path Rust summary adapter | VERIFIED | Reads exactly one fixture path argument, calls summary function, prints lines, and reports `error:` diagnostics. |
| `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs` | Parser and summary tests | VERIFIED | 12 Cargo tests passed, including real fixture counts, exact metadata/sample summary, and invalid input parse-error propagation. |
| `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` | Rust summary binary/test wiring | VERIFIED | Defines `rust_binary(name = "prusa_profile_schema_summary")` and includes it in clippy/rustfmt targets. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv` | Checked-in deterministic expected summary | VERIFIED | Contains source identity, 6976 sections, 27340 entries, kind counts, and representative sample rows. |
| `packages/parity/BUILD.bazel` | Public command and failure test targets | VERIFIED | Defines `prusaslicer_profile_schema_parity` and `prusaslicer_profile_schema_parity_failure_test` with required data deps. |
| `packages/parity/compare_prusaslicer_profile_schema.sh` | Fail-closed comparator | VERIFIED | Verifies files, runs Rust summary binary, diffs expected/actual, prints first mismatch label, and prints concise pass summary. |
| `packages/parity/compare_prusaslicer_profile_schema_test.sh` | Divergence failure guard | VERIFIED | Mutates temp expected summary only and asserts non-zero failure plus diagnostic text. |
| `packages/parity/status.tsv` | Single narrow verified status row | VERIFIED | Exact `fork.prusaslicer.profile-schema` row exists once and points to the public command. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | Fixture/status verifier | VERIFIED | Requires fixture integrity, provenance, docs text, namespace boundaries, and exact status row publication. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` | Fixture/status failure tests | VERIFIED | Covers fixture checksum/provenance/namespace plus status-row missing/wrong/duplicate/overclaim failures. |
| Docs under `packages/*/README.md` and `docs/port/*` | Narrow evidence docs and deferrals | VERIFIED | Docs name the exact evidence slice and preserve broad deferrals; `mdformat --check` passed. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `packages/parity/BUILD.bazel` | `packages/parity/compare_prusaslicer_profile_schema.sh` | `sh_binary(name = "prusaslicer_profile_schema_parity")` | VERIFIED | Target uses comparator script as `srcs`. |
| `packages/parity/BUILD.bazel` | `packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_schema_summary` | Bazel `$(location ...)` argument | VERIFIED | Target data and args include the Rust summary binary. The generic key-link helper missed this because the script uses `summary_binary` as the variable name, but manual wiring is present. |
| `packages/parity/compare_prusaslicer_profile_schema.sh` | `expected-summary.tsv` | `diff -u` expected vs actual summary | VERIFIED | Comparator creates `actual-summary.tsv` from Rust binary output and diffs it against the checked-in expected file. |
| `packages/parity/status.tsv` | `packages/parity/BUILD.bazel` | Evidence column references public command | VERIFIED | Exact row guard passed for `fork.prusaslicer.profile-schema`, `verified`, and `//packages/parity:prusaslicer_profile_schema_parity`. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | `packages/parity/status.tsv` | `awk` exact row validation | VERIFIED | `verify_status_published` checks status, evidence, notes, missing, and duplicate row cases. |
| `docs/port/migration-guidance.md` | `packages/parity/status.tsv` | Docs name status token, command, expected artifact, and deferrals | VERIFIED | Manual `rg` confirms the exact token and evidence command. The generic key-link helper missed this due escaped-pattern matching. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| `prusa_profile.rs` | `bundle.sections`, `entry_count`, kind counts, sample rows | `parse_prusa_profile_bundle(input)` over `PrusaResearch.ini` text | Yes - Cargo tests assert 6976 sections, 27340 entries, kind counts, and exact sample rows. | FLOWING |
| `prusa_profile_schema_summary.rs` | `lines` | Explicit file argument read via `fs::read_to_string`, then `prusa_profile_schema_summary_lines` | Yes - command prints deterministic TSV lines from the checked-in fixture. | FLOWING |
| `compare_prusaslicer_profile_schema.sh` | `actual_summary`, `sections`, `entries` | Rust summary binary output and field extraction from actual TSV | Yes - `bazel run` prints 6976 sections and 27340 entries after successful diff. | FLOWING |
| `expected-summary.tsv` | Expected source/count/sample rows | Checked-in fixture artifact under Prusa fixture provenance directory | Yes - comparator and failure test prove expected data is used and drift fails. | FLOWING |
| `verify_prusa_profile_schema_fixture.sh` | Status row fields | `packages/parity/status.tsv` parsed with `awk -F '\t'` | Yes - verifier passes on current row and tests fail invalid copies. | FLOWING |
| Docs/status | Narrow evidence wording | Status row plus docs references to command/source/fixture/expected artifact | Yes - docs are static but directly name the command and paths; formatter and grep checks passed. | FLOWING |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Schema drift clean | `node "$HOME/.codex/get-shit-done/bin/gsd-tools.cjs" verify schema-drift 40` | `drift_detected: false`, `blocking: false` | PASS |
| Rust parser/summary tests | `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_profile` | 12 passed | PASS |
| Bazel Rust verification | `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_test //packages/slic3r-rust:verify` | 11 passed | PASS |
| Main Prusa parity command | `bazel run //packages/parity:prusaslicer_profile_schema_parity` | Passed; printed source ref, fixture, expected artifact, `sections: 6976`, `entries: 27340` | PASS |
| Divergence failure guard | `bazel test //packages/parity:prusaslicer_profile_schema_parity_failure_test` | Passed | PASS |
| Fixture/status verifier | `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` | Passed; printed `ok: Prusa profile-schema fixture verification passed` | PASS |
| Fixture/status failure tests | `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` | Passed | PASS |
| Public status output | `bazel run //packages/parity:status \| rg "fork\\.prusaslicer\\.profile-schema\|prusaslicer_profile_schema_parity"` | Printed verified Prusa row and evidence command | PASS |
| Exact status row | `awk -F '\t' ... packages/parity/status.tsv` | Passed | PASS |
| Docs formatting | `mdformat --check ...` | Passed | PASS |
| Whitespace | `git diff --check` | Passed | PASS |
| UAT queue | `node "$HOME/.codex/get-shit-done/bin/gsd-tools.cjs" audit-uat --raw` | Zero items | PASS |

Orchestrator-provided corroboration also reports the full Rust suite passed: `cargo fmt`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features`; plus `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test`, `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture`, `mdformat --check`, `git diff --check`, schema drift, UAT audit, and a clean 21-file code review.

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| PPAR-01 | `40-01-PLAN.md`, `40-02-PLAN.md` | Maintainer can run a repo-owned Bazel parity command for the Prusa profile/config evidence slice. | SATISFIED | Public `//packages/parity:prusaslicer_profile_schema_parity` target exists, is wired to Rust summary output and fixtures, and passed. |
| PPAR-02 | `40-01-PLAN.md`, `40-02-PLAN.md` | Maintainer can see the Prusa parity command fail when Rust-backed output diverges from checked-in fixture expectations. | SATISFIED | `//packages/parity:prusaslicer_profile_schema_parity_failure_test` mutates `section_count` and passed. |
| PPAR-03 | `40-02-PLAN.md` | Maintainer can inspect docs and parity status updates that name the exact verified slice and keep broad support deferred. | SATISFIED | Status row, fixture verifier, package docs, and port docs name the exact command/source/fixture/expected artifact and preserve deferrals. |

No additional Phase 40 requirement IDs were found in `.planning/REQUIREMENTS.md` beyond PPAR-01, PPAR-02, and PPAR-03.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| None | - | No blocker TODO/FIXME/placeholder/stub/empty implementation patterns found | - | The only scan hits were `XXXXXX` in `mktemp` templates, which are normal temp-directory placeholders controlled by `mktemp`, not implementation stubs. |

### Human Verification Required

None. Phase 40 produces deterministic command/script/docs behavior with no visual UI, real-time behavior, external service integration, or human-only UX judgment required.

### Gaps Summary

No gaps found. The phase goal is achieved: maintainers can run and trust the first executable PrusaSlicer profile-schema parity command, divergence is guarded, docs/status publish only the narrow verified parser/config evidence slice, and broader PrusaSlicer runtime, GUI, generated-output, release, network/cloud/credential, plugin, and sync surfaces remain deferred.

---

_Verified: 2026-06-02T16:02:26Z_
_Verifier: the agent (gsd-verifier)_
