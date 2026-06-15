---
phase: 46-prusa-g-code-fixture-surface
verified: 2026-06-13T19:12:26Z
status: passed
score: "7/7 must-haves verified"
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 46-2026-06-13T16-58-19
generated_at: 2026-06-13T19:12:26Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 46: Prusa G-code Fixture Surface Verification Report

**Phase Goal:** Maintainers have a source-pinned Prusa G-code fixture and summary-only expected artifact before Rust summary or parity commands rely on it.
**Verified:** 2026-06-13T19:12:26Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|---|---|---|
| 1 | Maintainer can inspect the dedicated Prusa G-code fixture namespace. | VERIFIED | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` contains `.gitattributes`, README, fixture, provenance TSV, and expected-summary TSV. |
| 2 | The fixture is one small reviewed ASCII LF `.gcode` file. | VERIFIED | `wc -c` is `42`, SHA-256 is `dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb`, ASCII/LF awk check passed. |
| 3 | Provenance records source pin, update route, byte count, SHA-256, and Phase 45 scope trace. | VERIFIED | `fixture-provenance.tsv` has 2 rows, 17 fields per row, accepted source identity, upstream URL, scope record path, update route, exclusions, and deferrals. |
| 4 | `expected-gcode-summary.tsv` is summary-only with the exact Phase 45 seven-column shape. | VERIFIED | Header matches `source_ref fixture_path metadata_key metadata_value marker_key marker_value notes`; file has 6 rows, 7 fields per row, and no byte/hash/status/parity/geometry/extrusion/duration fields. |
| 5 | Maintainer can run a repo-owned fail-closed fixture verifier and mutation tests. | VERIFIED | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`, Bazel test, and direct Bash mutation test all passed. |
| 6 | Phase 45 scope verifier is reconciled while Phase 47/48 artifacts remain absent. | VERIFIED | `bazel run //packages/prusa-gcode-output-scope:verify` and its tests passed; no `fork.prusaslicer.gcode-output` status row, no parity target, and no Rust markers were found. |
| 7 | Docs expose the fixture surface and exclusions without broad parity claims. | VERIFIED | Package and port docs route to namespace, bundle, verifier, Phase 47/48 boundaries, and exclusions for base-export reuse, live generation, fetching/importing, binary G-code, thumbnails, post-processing, and host upload. |

**Score:** 7/7 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/.gitattributes` | LF text policy | VERIFIED | Exact `.gcode`, `.tsv`, and README LF policy present. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode` | Four-line ASCII LF fixture | VERIFIED | Exact lines present; byte/hash checks passed. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv` | Source-pinned provenance | VERIFIED | Header/row shape, source identity, hash, update route, scope trace, exclusions, and deferrals verified. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv` | Summary-only expected artifact | VERIFIED | Exact seven-column header and five expected rows verified manually. `gsd-tools` had a false negative because the plan stored `\t` while the file uses real tabs. |
| `packages/parity-fixtures/BUILD.bazel` | Bundle, aliases, verifier targets | VERIFIED | Fixture bundle and aliases query successfully; no Phase 48 parity target exists. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` | Fail-closed verifier | VERIFIED | Verifies bytes, checksum, ASCII/LF, provenance, summary shape, docs text, exclusions, and future-artifact absence. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | Mutation tests | VERIFIED | Covers checksum, CRLF, non-ASCII, TSV drift, update/exclusion drift, overclaims, premature status/parity/Rust, forbidden verifier behavior, compact target form, and single-quoted target form. |
| `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` | Reconciled scope verifier | VERIFIED | Allows Phase 46 fixture namespace and expected-summary while rejecting status, parity target, and Rust markers. |
| `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` | Scope mutation tests | VERIFIED | Covers Phase 46 allowance plus compact/single-quoted parity target rejection. |
| `packages/parity-fixtures/README.md` and `docs/port/*.md` | Maintainer routing and boundaries | VERIFIED | Namespace, bundle, verifier, source derivation, Phase 47/48 ownership, status boundary, and deferrals are documented. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `fixture-provenance.tsv` | `packages/prusa-gcode-output-scope/gcode-output-scope.md` | `phase45_scope_record` | WIRED | Manual `rg` found the scope record path in provenance row and README. |
| `expected-gcode-summary.tsv` | `gcodewriter-set-speed.gcode` | `fixture_path` | WIRED | All five expected rows reference the checked-in fixture path. |
| `verify_prusa_gcode_output_fixture.sh` | fixture/provenance/summary/status/parity/Rust files | Exact checks and absence guards | WIRED | Bazel and direct Bash verifier runs passed. |
| `verify_prusa_gcode_output_scope.sh` | Phase 46 namespace and future-artifact boundaries | Allowance tests and rejection guards | WIRED | Scope verifier/tests pass after fixture files exist. |
| Docs | Fixture namespace, verifier, status boundary | Fixed path/command references | WIRED | Manual docs grep found namespace, `prusa_gcode_output_bundle`, verifier command, and `fork.prusaslicer.gcode-output` boundary. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| Static fixture TSV/G-code artifacts | N/A | Checked-in files | Yes | VERIFIED - static fixture phase, no dynamic UI/API data flow. |
| Bash verifier | Input file paths | Real checkout defaults or explicit test temp copies | Yes | VERIFIED - direct and Bazel runs validate real files; mutation tests validate fail-closed behavior. |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Fixture verifier passes real checkout | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` | `ok: Prusa G-code output fixture verification passed` | PASS |
| Fixture mutation suite passes | `bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test` | PASSED | PASS |
| Fixture mutation suite passes directly | `bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | `ok: verify_prusa_gcode_output_fixture_test` | PASS |
| Scope verifier still passes after Phase 46 files | `bazel run //packages/prusa-gcode-output-scope:verify` | `ok: Prusa G-code output scope verification passed` | PASS |
| Scope mutation suite passes | `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test` | PASSED | PASS |
| Scope mutation suite passes directly | `bash packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` | `ok: verify_prusa_gcode_output_scope_test` | PASS |
| Fork inventory remains coherent | `bazel run //packages/fork-inventories:verify` | `ok: inventory verification passed` | PASS |
| Shell formatting | `shfmt -d ...` | No diff | PASS |
| Shell lint | `shellcheck ...` | No diagnostics | PASS |
| Markdown formatting | `mdformat --check ...` | Passed | PASS |
| Parity package loads | `bazel query //packages/parity:all` | Listed existing targets, no G-code parity target | PASS |
| Phase 48 parity target absent | `! bazel query //packages/parity:prusaslicer_gcode_output_parity` | Target not declared | PASS |
| Status row absent | `! rg -n '^fork\.prusaslicer\.gcode-output\t' packages/parity/status.tsv` | No matches | PASS |
| Rust markers absent | `! rg -n 'slic3r_flavors::prusa_gcode_output|pub mod prusa_gcode_output|prusa_gcode_output_summary|parse_prusa_gcode_output_summary' packages/slic3r-rust` | No matches | PASS |
| Whitespace cleanliness | `git diff --check` | Passed | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| PGFIX-01 | 46-01, 46-03 | Inspectable namespace with small ASCII fixture, provenance, update rules, byte count, SHA-256, line-ending policy, and summary-only expected artifact tracing to scope gate. | SATISFIED | Fixture namespace, exact byte/hash checks, provenance TSV, expected summary TSV, docs routing, and scope trace verified. |
| PGFIX-02 | 46-02, 46-03 | Repo-owned fixture verifier fails on missing or inconsistent provenance, checksums, line-ending policy, expected-summary shape, update rules, privacy/post-processing exclusions, or non-overclaiming text. | SATISFIED | Verifier and mutation tests pass through Bazel and direct Bash; mutation coverage includes checksum, CRLF, non-ASCII, TSV, update/exclusion, overclaim, status/parity/Rust, and forbidden behavior drift. |

No orphaned Phase 46 requirements were found in `.planning/REQUIREMENTS.md`; Phase 46 maps only PGFIX-01 and PGFIX-02.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` | 344-346 | `placeholder.sh` in injected Bazel snippets | INFO | Intentional temp mutation fixture proving parity target rejection. |
| `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` | 375-377 | `placeholder.sh` in injected Bazel snippets | INFO | Intentional temp mutation fixture proving parity target rejection. |
| Shell test files | temp-dir lines | `XXXXXX` matched broad `XXX` scan | INFO | `mktemp` template, not a TODO/stub. |

No blocker anti-patterns were found. The raw forbidden-term scan sees `host upload` in exclusion text; the executable fixture verifier self-scan and mutation test are the relevant behavior guard and both passed.

### Code Review

Code review is clean at `.planning/phases/46-prusa-g-code-fixture-surface/46-REVIEW.md` with `status: clean`, zero findings, and 15 files reviewed.

The prior parity-target guard warning is fixed by `bbae6839a fix(46): harden G-code parity target guards`. Both verifier scripts now use the whitespace- and quote-tolerant pattern `name[[:space:]]*=[[:space:]]*['"]prusaslicer_gcode_output_parity['"]`, and both mutation suites cover compact and single-quoted Starlark forms.

### Human Verification Required

None. Phase 46 is static fixture, shell verifier, Bazel target, and documentation work; all goal-critical behavior is covered by file checks and executable commands.

### Gaps Summary

No gaps found. Phase 46 achieved the roadmap goal: maintainers have a source-pinned Prusa G-code fixture surface and summary-only expected artifact before Phase 47 Rust summary parsing or Phase 48 parity/status publication can rely on it.

---

_Verified: 2026-06-13T19:12:26Z_
_Verifier: the agent (gsd-verifier)_
