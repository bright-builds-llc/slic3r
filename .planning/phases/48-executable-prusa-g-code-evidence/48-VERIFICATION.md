---
phase: 48-executable-prusa-g-code-evidence
verified: 2026-06-14T21:10:12Z
status: passed
score: "10/10 must-haves verified"
requirements_verified: [PGEV-01, PGEV-02, PGEV-03]
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 48-2026-06-14T18-49-25
generated_at: 2026-06-14T21:10:12Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 48: Executable Prusa G-code Evidence Verification Report

**Phase Goal:** Maintainers can run and trust the summary-only Prusa G-code evidence command while docs and status clearly limit what was verified.  
**Verified:** 2026-06-14T21:10:12Z  
**Status:** passed  
**Re-verification:** No - initial verification

Material guidance loaded: repo `AGENTS.md`, `AGENTS.bright-builds.md`,
`standards-overrides.md`, pinned Bright Builds standards for architecture,
code shape, verification, testing, and Rust, plus GSD verifier override,
gate, thinking-model, and few-shot references. No repo-local `.claude/skills`
or `.agents/skills` directories were present.

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|---|---|---|
| 1 | Maintainer can run `bazel run //packages/parity:prusaslicer_gcode_output_parity` for the selected summary-only Prusa G-code evidence slice. | VERIFIED | Fresh `bazel run` passed and printed `ok: fork.prusaslicer.gcode-output parity passed`, source ref, fixture path, expected summary path, and `rows: 5`. |
| 2 | The command is backed by a repo-owned Bazel parity target and checked-in fixture artifact. | VERIFIED | `packages/parity/BUILD.bazel:141-153` declares `prusaslicer_gcode_output_parity`, wires `:prusa_gcode_output_summary`, `:prusa_gcode_output_expected_gcode_summary`, and provenance through `data` and args. |
| 3 | The command output stays narrow and does not claim runtime or byte-for-byte G-code support. | VERIFIED | `compare_prusaslicer_gcode_output.sh:183-197` asserts exact surface/source/fixture/expected/row-count fields and prints only the approved five-line summary. |
| 4 | Maintainer can see expected-summary drift fail closed. | VERIFIED | `compare_prusaslicer_gcode_output_test.sh:58-117` mutates only `line_4` from `G1 F203.201` to `G1 F203.200` and asserts non-zero failure with `line_4`, `diff`, `@@`, and mutated value. Bazel and direct shell runs passed. |
| 5 | Exactly one `fork.prusaslicer.gcode-output` status row is published with verified evidence. | VERIFIED | `packages/parity/status.tsv:18` has the sole row, status `verified`, evidence `//packages/parity:prusaslicer_gcode_output_parity`; awk exact-count check returned `count=1`. |
| 6 | Broad `generated-outputs` remains `in progress`. | VERIFIED | `packages/parity/status.tsv:14` remains `generated-outputs	in progress	...`; awk check passed. |
| 7 | Prior Phase 45-47 absence boundaries are reconciled with publication without loosening current verifiers. | VERIFIED | Fixture and scope verifier scripts now call `verify_status_published` and `verify_parity_target_published`; stale `reject_status_row`, `reject_parity_target`, and forbidden publication strings have no matches. |
| 8 | Current fixture, scope, inventory, and Rust verifier surfaces still pass. | VERIFIED | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`, `bazel run //packages/prusa-gcode-output-scope:verify`, `bazel run //packages/fork-inventories:verify`, and `bazel test --cache_test_results=no //packages/slic3r-rust:verify` all passed. |
| 9 | Package and port docs name the exact command, row, fixture namespace, expected artifact, and Rust boundary. | VERIFIED | Docs grep found `prusaslicer_gcode_output_parity`, `fork.prusaslicer.gcode-output`, `expected-gcode-summary.tsv`, and `prusa_gcode_output_summary` across `packages/parity/README.md`, `packages/parity-fixtures/README.md`, `packages/slic3r-rust/README.md`, and `docs/port/*.md`. |
| 10 | Docs/status clearly defer byte-for-byte G-code parity, broad generated-output parity, runtime/printer, geometry, support, seam, arc, STEP, GUI, release, network, Bambu, Orca, upstream import, and sync surfaces. | VERIFIED | `packages/parity/status.tsv:18`, `docs/port/README.md:342-349`, `docs/port/parity-matrix.md:84-104`, `docs/port/migration-guidance.md:90-111`, and `docs/port/package-map.md:167-186` preserve the deferred-scope wording. |

**Score:** 10/10 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs` | Thin executable adapter over `prusa_gcode_output_summary_lines` | VERIFIED | Exists, uses `#![forbid(unsafe_code)]`, accepts one argument, reads caller-supplied TSV, and calls the Phase 47 pure summary boundary. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` | Typed summary parser and stable summary-line source | VERIFIED | Exposes metadata, parser, summary lines, exact row validation, and no filesystem/network/process behavior in the core module. Side-effect grep returned no matches. |
| `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` | Binary plus clippy/rustfmt aggregate wiring | VERIFIED | `prusa_gcode_output_summary` target exists at line 35 and is included in clippy/rustfmt lists at lines 95 and 109. |
| `packages/parity/compare_prusaslicer_gcode_output.sh` | Public comparator shell | VERIFIED | Exists, substantive, executable, ShellCheck/shfmt clean, asserts exact stable fields and `line_4` evidence row. |
| `packages/parity/compare_prusaslicer_gcode_output_test.sh` | Fail-closed mutation guard | VERIFIED | Exists, executable, mutates temp `line_4` value only, and validates failure output. |
| `packages/parity/BUILD.bazel` | Public command and failure `sh_test` | VERIFIED | `sh_binary` and `sh_test` are declared and wired to the Rust binary and fixture aliases. |
| `packages/parity/status.tsv` | Exact fork-specific verified row; broad row unchanged | VERIFIED | Manual awk exact-count checks passed. GSD artifact helper false-negative was due escaped `\t` pattern handling; the real TSV row is present. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` | Publication-aware fixture verifier | VERIFIED | Requires exact status row and parity target while preserving fixture, provenance, summary, exclusion, and overclaim checks. |
| `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` | Publication-aware scope verifier | VERIFIED | Requires exact Phase 48 status and target while preserving source, inventory, category-map, deferred-scope, and overclaim checks. |
| `packages/parity/README.md`, `packages/parity-fixtures/README.md`, `packages/slic3r-rust/README.md`, `docs/port/*.md` | Public docs/status interpretation | VERIFIED | Docs expose the command/status and maintain Phase 46/47/48 distinction and deferred surfaces. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `packages/parity/BUILD.bazel` | `//packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary` | `sh_binary` data and `$(location)` arg | WIRED | Lines 145 and 150 include the Rust summary binary. |
| `packages/parity/BUILD.bazel` | `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary` | `sh_binary` data and args | WIRED | Lines 146, 151, and 152 include the expected summary alias. |
| `packages/parity/BUILD.bazel` | `//packages/parity-fixtures:prusa_gcode_output_provenance` | `sh_binary` data and arg | WIRED | Lines 147 and 153 include provenance. |
| `compare_prusaslicer_gcode_output.sh` | Rust summary binary | Explicit first argument | WIRED | Script verifies executable path, invokes it for actual and expected summaries, and fails on parse or diff drift. |
| `prusa_gcode_output_summary.rs` | `prusa_gcode_output_summary_lines` | Rust import and call | WIRED | Lines 5 and 27 call the Phase 47 pure summary function. |
| `packages/parity/status.tsv` | `//packages/parity:prusaslicer_gcode_output_parity` | Evidence field | WIRED | Exact row present once at line 18. |
| Fixture and scope verifiers | Status row and parity target | Publication checks | WIRED | Both verifiers require exact row and target; mutation suites prove missing/wrong/duplicate row and missing target fail. |
| Public docs | Status and command | Fixed command/status text | WIRED | Docs grep found command, token, expected artifact, fixture namespace, and Rust boundary references. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| `prusaslicer_gcode_output_parity` | `actual_summary`, `expected_summary_lines` | Bazel runfiles for `expected-gcode-summary.tsv` and Rust summary binary | Yes | FLOWING - public command executed and printed accepted row count 5. |
| `compare_prusaslicer_gcode_output.sh` | Summary field assertions | Output of `prusa_gcode_output_summary` | Yes | FLOWING - asserts surface, inventory, vendor, source, fixture, expected path, status token, row count, and `line_4` evidence row. |
| `prusa_gcode_output_summary.rs` | `lines` | Caller-supplied TSV parsed by `prusa_gcode_output_summary_lines` | Yes | FLOWING - thin adapter around typed parser; no hardcoded empty output. |
| `prusa_gcode_output_summary_lines` | `summary.rows` | Parsed checked-in `expected-gcode-summary.tsv` | Yes | FLOWING - parser validates exact header, five rows, notes, marker values, ordering, missing/duplicate/extra rows. |
| Fixture/scope verifiers | Published status/target | `packages/parity/status.tsv` and `packages/parity/BUILD.bazel` | Yes | FLOWING - real checkout verifiers passed and mutation suites cover invalid publication states. |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Public G-code parity command | `bazel run //packages/parity:prusaslicer_gcode_output_parity` | Printed `ok: fork.prusaslicer.gcode-output parity passed` and `rows: 5` | PASS |
| `line_4` mutation guard | `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test` | Executed 1/1, PASSED | PASS |
| Direct mutation guard | `bash packages/parity/compare_prusaslicer_gcode_output_test.sh` | `ok: prusaslicer_gcode_output_parity_failure_test` | PASS |
| Fixture verifier | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` | `ok: Prusa G-code output fixture verification passed` | PASS |
| Fixture mutation suite | `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test` | Executed 1/1, PASSED | PASS |
| Scope verifier | `bazel run //packages/prusa-gcode-output-scope:verify` | `ok: Prusa G-code output scope verification passed` | PASS |
| Scope mutation suite | `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test` | Executed 1/1, PASSED | PASS |
| Inventory verifier | `bazel run //packages/fork-inventories:verify` | `ok: inventory verification passed` | PASS |
| Rust aggregate verification | `bazel test --cache_test_results=no //packages/slic3r-rust:verify` | 13/13 targets passed | PASS |
| Cargo format | `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check` | Exit 0 | PASS |
| Cargo clippy | `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings` | Finished successfully | PASS |
| Cargo build | `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features` | Finished successfully | PASS |
| Cargo tests | `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features` | All tests passed, including 18/18 `prusa_gcode_output` tests | PASS |
| Shell lint | `shellcheck ...gcode scripts...` | Exit 0 | PASS |
| Shell format | `shfmt -d ...gcode scripts...` | No diff, exit 0 | PASS |
| Markdown format | `mdformat --check ...` | Exit 0 | PASS |
| Whitespace | `git diff --check` | Exit 0 | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| PGEV-01 | 48-01 | Maintainer can run a repo-owned Bazel parity command for the selected summary-only Prusa G-code output evidence slice. | SATISFIED | Public `sh_binary` exists, wires Rust summary and fixture aliases, and fresh `bazel run` passed with exact approved output. |
| PGEV-02 | 48-01, 48-02 | Maintainer can see the Prusa G-code evidence command fail when the Rust-backed summary or checked-in expected summary artifact diverges from fixture expectations. | SATISFIED | `line_4` mutation failure test passed uncached and directly; fixture/scope mutation suites also cover missing/wrong/duplicate publication states. Fixed comparator assertions cover Rust summary label/value drift despite self-comparison shape. |
| PGEV-03 | 48-02, 48-03 | Maintainer can inspect docs and parity status updates that name the exact verified Prusa G-code evidence slice and keep deferred surfaces deferred. | SATISFIED | Exact status row exists once, broad `generated-outputs` remains `in progress`, and package/port docs name the command, token, source, fixture namespace, expected artifact, Rust boundary, and deferrals. |

No orphaned Phase 48 requirements were found. PLAN frontmatter claims PGEV-01,
PGEV-02, and PGEV-03 across the three plans; SUMMARY frontmatter completes all
three IDs. `.planning/REQUIREMENTS.md` maps only PGEV-01, PGEV-02, and PGEV-03
to Phase 48, though that file still carries milestone-level `Pending` status.

### Prior Boundary Reconciliation

| Prior Boundary | Phase 48 Publication Result | Status |
|---|---|---|
| Phase 45 expected parity target/status row to remain absent | Superseded intentionally by Phase 48; current scope verifier now requires exact publication. | RECONCILED |
| Phase 46 fixture verifier expected parity target/status row to remain absent | Superseded intentionally by Phase 48; current fixture verifier now requires exact publication. | RECONCILED |
| Phase 47 expected summary binary, parity target, and status row to remain absent | Superseded intentionally by Phase 48; Rust aggregate and parser tests still pass. | RECONCILED |
| Fixture/scope/inventory/Rust integrity | All current verifier commands pass after publication. | VERIFIED |

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| Shell scripts | various `mktemp` lines | `XXXXXX` matched broad `XXX` scan | INFO | Intentional `mktemp` templates, not TODO/stub content. |

No blocker anti-patterns were found. No TODO/FIXME/placeholders, hardcoded
empty data, stale Phase 46 absence docs, stale Phase 48 absence guards, or
side-effect calls in the Rust summary core were found.

### Disconfirmation Pass

- Partial requirement check: no partial Phase 48 requirement was found. PGEV-02
  is covered by the `line_4` mutation guard plus exact comparator assertions
  for Rust summary output shape.
- Misleading-test check: the failure test does not only check exit status; it
  asserts `expected-gcode-summary.tsv`, `line_4`, `diff`, `@@`, and the mutated
  `G1 F203.200` value in stderr.
- Uncovered error-path check: fixture and scope mutation suites cover missing,
  wrong, duplicate status rows and missing parity target; Rust tests cover
  unsupported keys/values, overclaiming notes, wrong source/fixture, missing,
  duplicate, extra, and wrong-order rows.

### Human Verification Required

None. Phase 48 is static CLI/Bazel, Rust, shell verifier, TSV, and docs work;
goal-critical behavior is covered by deterministic local commands.

### Gaps Summary

No gaps found. Phase 48 achieved the roadmap goal: maintainers can run and
trust the public summary-only Prusa G-code evidence command, see fail-closed
drift behavior, inspect exact status/docs for `fork.prusaslicer.gcode-output`,
and confirm broad generated-output and runtime surfaces remain deferred.

---

_Verified: 2026-06-14T21:10:12Z_  
_Verifier: the agent (gsd-verifier)_
