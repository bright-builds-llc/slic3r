---
phase: 38-prusa-fixture-and-status-evidence-surface
verified: 2026-06-01T01:40:53Z
status: passed
score: "6/6 must-haves verified"
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 38-2026-06-01T00-33-46
generated_at: 2026-06-01T01:40:53Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 38: Prusa Fixture and Status Evidence Surface Verification Report

**Phase Goal:** Maintainers have a real fixture/status surface for Prusa profile/config evidence before Rust parsing or parity commands rely on it.
**Verified:** 2026-06-01T01:40:53Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Maintainer can inspect the Prusa fixture namespace and update rules in the parity fixture package. | VERIFIED | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` contains `.gitattributes`, `README.md`, `fixture-provenance.tsv`, `PrusaResearch.ini`, and `PrusaResearch.idx`; package README lines 23-29 name the namespace, source ref, update route, drift-only rule, and static verifier boundary. |
| 2 | Maintainer can inspect raw checked-in PrusaResearch fixture inputs from the accepted source pin. | VERIFIED | `PrusaResearch.ini` is 1,543,688 bytes with SHA-256 `a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839`; `PrusaResearch.idx` is 31,543 bytes with SHA-256 `65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1`; provenance rows 2-3 bind both to `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |
| 3 | Maintainer can verify provenance, sizes, SHA-256 values, source paths, update route, status non-publication, and forbidden namespace absence with a rerunnable static command. | VERIFIED | `verify_prusa_profile_schema_fixture.sh` checks file presence/sizes/checksums at lines 83-90, provenance rows at lines 118-177, scope wording at lines 180-208, namespace boundaries at lines 211-248, and status non-publication at line 255; `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` passed and printed `ok: Prusa profile-schema fixture verification passed`. |
| 4 | Maintainer can run Bazel bundle, verifier, and failure-mode test targets. | VERIFIED | `BUILD.bazel` defines aliases, `prusa_profile_schema_bundle`, `verify_prusa_profile_schema_fixture`, and `verify_prusa_profile_schema_fixture_test` at lines 333-392; `bazel query //packages/parity-fixtures:prusa_profile_schema_bundle` resolved and `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` passed. |
| 5 | Maintainer can inspect docs/status vocabulary reserving `fork.prusaslicer.profile-schema` for Phase 40 only while `packages/parity/status.tsv` remains free of a Prusa row. | VERIFIED | `packages/parity/README.md` lines 47-61 reserve the token and require the Phase 40 command before `verified`; docs/port files contain the token and Phase 40 boundary; `rg -n "fork\\.prusaslicer|prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv` returned no matches. |
| 6 | Maintainer can confirm no forbidden fork/network/cloud/credential/plugin scope or executable Prusa parity target was introduced, and code-review warnings were fixed. | VERIFIED | `find packages/parity-fixtures/forks -print` shows only the Prusa namespace; the forbidden namespace scan passed; `bazel query //packages/parity:prusaslicer_profile_schema_parity` failed with no such target; review fixes are present via `verify_provenance_row`, relative namespace scanning, `test_swapped_provenance_rows_fail`, and `test_parent_directory_forbidden_token_passes`. |

**Score:** 6/6 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|---|---|---|---|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md` | Fixture scope, provenance, update route, exclusions | VERIFIED | Contains Phase 38-only/static input wording, source ref, update route, Phase 39/40 boundary, and explicit exclusions. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv` | Fixture-local provenance and checksums | VERIFIED | Literal TSV with expected columns and row-level metadata for both raw files. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes` | Raw byte preservation | VERIFIED | Contains `PrusaResearch.ini -text` and `PrusaResearch.idx -text`. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini` | Raw vendor bundle fixture | VERIFIED | Size and SHA-256 match plan. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx` | Matching raw vendor bundle index | VERIFIED | Size and SHA-256 match plan. |
| `packages/parity-fixtures/BUILD.bazel` | Bazel exports, filegroup, verifier, sh_test | VERIFIED | Bundle, binary, and test targets exist and analyze/run. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | Static verifier | VERIFIED | Static local checks only; no `curl`, `git ls-remote`, `eval`, or `bash -c` matches. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` | Failure-mode tests | VERIFIED | Includes missing file/checksum/source/scope/status/forbidden namespace tests plus review-fix regression tests. |
| `packages/parity-fixtures/README.md` | Package-level fixture/update/status-prep rules | VERIFIED | Names namespace, source ref, update route, drift-only branch wording, no-fetch/no-auto-update/no-plugin/no-parity-command boundary, and exclusions. |
| `packages/parity/README.md` | Reserved status vocabulary without status row | VERIFIED | Reserves `fork.prusaslicer.profile-schema` and requires Phase 40 command before verified status. |
| `docs/port/README.md` | Control-plane Phase 38 state | VERIFIED | Names fixture namespace, bundle/verifier targets, raw files, docs-only token, and Phase 39/40 boundary. |
| `docs/port/package-map.md` | Package-map routing | VERIFIED | Maps Phase 38 fixture namespace and says `packages/parity/status.tsv` remains unchanged. |
| `docs/port/migration-guidance.md` | Update/status publication rules | VERIFIED | Reserves token for Phase 40 only and requires `bazel run //packages/parity:prusaslicer_profile_schema_parity`. |
| `docs/port/parity-matrix.md` | Human-facing non-overclaiming status | VERIFIED | States the token is reserved vocabulary only and static fixtures do not create `verified` status. |

### Key Link Verification

| From | To | Via | Status | Details |
|---|---|---|---|---|
| `packages/parity-fixtures/BUILD.bazel` | Raw fixture files and provenance docs | `prusa_profile_schema_bundle` | VERIFIED | `bazel query //packages/parity-fixtures:prusa_profile_schema_bundle` resolved. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | Fixture bundle/provenance | Size, SHA-256, source ref, source path, row-level TSV checks | VERIFIED | Verifier script checks all expected values and Bazel run passed. |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | `packages/parity/status.tsv` | Negative Prusa status row guard | VERIFIED | Verifier checks forbidden status tokens; direct `rg` found no matches. |
| `packages/parity/README.md` and `docs/port/*` | `packages/parity/status.tsv` | Docs-only reserved token, no row | VERIFIED | Docs reserve token; status table remains free of Prusa token/row. |
| `docs/port/migration-guidance.md` | Fixture README | Shared update route and Phase 39/40 boundary wording | VERIFIED | Both surfaces preserve Phase 38 static-only and Phase 40 publication boundaries. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|---|---|---|---|---|
| Static fixture/docs/verifier surface | N/A | Checked-in files and local shell/Bazel checks | N/A | Not applicable - no dynamic rendering or API data flow in this phase. |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|---|---|---|---|
| Bundle target resolves | `bazel query //packages/parity-fixtures:prusa_profile_schema_bundle` | Returned `//packages/parity-fixtures:prusa_profile_schema_bundle` | PASS |
| Static verifier passes | `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` | Printed `ok: Prusa profile-schema fixture verification passed` | PASS |
| Failure-mode tests pass | `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` | Bazel reported test passed | PASS |
| Shell formatting is stable | `shfmt -d packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` | Exit 0, no diff | PASS |
| Shell static analysis passes | `shellcheck packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` | Exit 0 | PASS |
| Phase 40 parity target absent | `bazel query //packages/parity:prusaslicer_profile_schema_parity` | Failed with `no such target` | PASS |
| Status table has no Prusa token | `rg -n "fork\\.prusaslicer|prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv` | Exit 1, no matches | PASS |
| Forbidden fixture namespace absence | `find packages/parity-fixtures/forks` plus forbidden-token path scan | Only Prusa namespace present; scan exit 0 | PASS |
| Whitespace check | `git diff --check` | Exit 0 | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|---|---|---|---|---|
| EVID-01 | 38-01-PLAN.md | Inspect Prusa fixture namespace/update rules with no forbidden fork/network/cloud/credential/plugin fixtures. | SATISFIED | Namespace exists, package and fixture READMEs document update rules, verifier enforces namespace boundary, forbidden path scan passed. |
| EVID-02 | 38-01-PLAN.md | Inspect checked-in Prusa profile/config fixtures traceable to accepted Prusa source pin and suitable for rerunnable executable parity checks. | SATISFIED | Raw `.ini` and `.idx` files are checked in with exact sizes/SHA-256 values, provenance rows, and Bazel bundle export. |
| EVID-03 | 38-01-PLAN.md | Inspect status vocabulary/rows that reserve verified Prusa status for v1.10 executable evidence only without marking full support verified. | SATISFIED | Docs reserve `fork.prusaslicer.profile-schema` for Phase 40 only; `status.tsv` has no Prusa row/token; Phase 40 parity target is absent. |

All requirement IDs declared in PLAN frontmatter (`EVID-01`, `EVID-02`, `EVID-03`) are present in `.planning/REQUIREMENTS.md` and mapped to Phase 38. No additional Phase 38 requirement IDs were found orphaned in `.planning/REQUIREMENTS.md`.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|---|---|---|---|---|
| None | N/A | N/A | N/A | No blocker or warning anti-patterns found. The only scan hit was normal `mktemp` temp-directory setup in the shell test, not a stub. |

### Review-Fix Closure

The two code-review warnings in `38-REVIEW.md` are closed in actual code:

| Review Item | Status | Evidence |
|---|---|---|
| WR-01 row-level provenance binding | CLOSED | `verify_provenance_row` validates every TSV column for each fixture row; `test_swapped_provenance_rows_fail` proves swapped metadata fails. |
| WR-02 relative namespace checking | CLOSED | `verify_forbidden_namespaces` normalizes `forks_root` and checks relative paths only; `test_parent_directory_forbidden_token_passes` proves parent directory names do not false-fail. |

### Human Verification Required

None. This phase is a static fixture/docs/Bazel verifier surface and all goal-critical behavior was verified with local file, grep, checksum, and Bazel commands.

### Gaps Summary

No gaps found. Phase 38 achieved the roadmap goal and plan must-haves without publishing a Prusa status row, creating the Phase 40 parity target, adding Rust profile parsing, importing upstream source trees, or introducing Bambu Studio, OrcaSlicer, network, cloud, credential, non-free plugin, GUI, sync, runtime, or release fixture/support scope.

---

_Verified: 2026-06-01T01:40:53Z_
_Verifier: the agent (gsd-verifier)_
