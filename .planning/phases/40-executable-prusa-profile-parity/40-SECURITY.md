---
phase: 40
slug: executable-prusa-profile-parity
status: verified
threats_open: 0
asvs_level: 1
created: 2026-06-02
---

# Phase 40 - Security

Per-phase security contract: threat register, accepted risks, and audit trail.

---

## Trust Boundaries

| Boundary | Description | Data Crossing |
|----------|-------------|---------------|
| Bazel locations to shell comparator | Explicit Bazel `$(location)` file paths enter the comparator; uncontrolled discovery must not be accepted. | Repo-built binary path, fixture path, expected TSV path, provenance path |
| Shell comparator to Rust summary binary | The comparator executes the repo-built Rust summary binary with an explicit fixture path and compares stdout to checked-in expectations. | Parsed Prusa profile summary TSV |
| Checked-in expected artifact to status evidence | Maintainers rely on the expected artifact to prove divergence detection; drift must fail closed. | `expected-summary.tsv` summary rows |
| Evidence command to status row | The checked-in status table turns executable evidence into a maintainer-visible claim. | `fork.prusaslicer.profile-schema` status row |
| Status row to fixture verifier | The fixture verifier must reject stale, missing, duplicate, or overbroad status claims. | `packages/parity/status.tsv` row fields |
| Docs to maintainer interpretation | Docs must not let a narrow parser/config proof read as full PrusaSlicer runtime support. | Package and port documentation wording |

---

## Threat Register

| Threat ID | Category | Component | Disposition | Mitigation | Status |
|-----------|----------|-----------|-------------|------------|--------|
| T-40-01 | Tampering | `expected-summary.tsv` and comparator | mitigate | `compare_prusaslicer_profile_schema.sh` compares Rust output to checked-in `expected-summary.tsv` with `diff -u`; `//packages/parity:prusaslicer_profile_schema_parity_failure_test` mutates `section_count` and requires non-zero failure. | closed |
| T-40-02 | Tampering / Information Disclosure | Rust summary adapter and shell comparator | mitigate | `//packages/parity:prusaslicer_profile_schema_parity` passes explicit Bazel fixture and expected paths; the Rust adapter requires exactly one fixture path; the comparator does not perform Git, network, profile auto-update, vendor sync, or release packaging behavior. | closed |
| T-40-03 | Repudiation | Failure diagnostics | mitigate | `first_mismatch_label` reports the first mismatched TSV field label, and the mutation failure test asserts diagnostics include `section_count` and `expected-summary.tsv`. | closed |
| T-40-04 | Spoofing | Public command label | mitigate | The maintainer-facing evidence command is narrowly named `//packages/parity:prusaslicer_profile_schema_parity`; docs and status describe only the profile-schema parser/config evidence slice. | closed |
| T-40-05 | Spoofing / Repudiation | `packages/parity/status.tsv` | mitigate | `packages/parity/status.tsv` contains exactly one `fork.prusaslicer.profile-schema` row with `verified` status and evidence `//packages/parity:prusaslicer_profile_schema_parity`; the exact awk row guard passed. | closed |
| T-40-06 | Tampering | `verify_prusa_profile_schema_fixture.sh` | mitigate | `verify_status_published` rejects missing, duplicate, wrong-status, wrong-evidence, missing narrow-scope notes, and missing runtime-deferral notes; `//packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` covers those negative cases. | closed |
| T-40-07 | Repudiation | Package and port docs | mitigate | Parity, fixture, Rust, and port docs name `fork.prusaslicer.profile-schema`, the public parity command, `expected-summary.tsv`, `PrusaResearch.ini`, and the accepted source ref while preserving broad deferrals. | closed |
| T-40-08 | Information Disclosure / Tampering | Network/profile auto-update wording | mitigate | Fixture verification and docs keep profile auto-update execution, network/cloud/credential behavior, non-free plugin ingestion, sync automation, fork release packaging, GUI, generated-output parity, and full runtime support deferred. | closed |

---

## Verification Evidence

| Evidence | Result |
|----------|--------|
| `bazel run //packages/parity:prusaslicer_profile_schema_parity` | Passed; printed `ok: fork.prusaslicer.profile-schema parity passed`, source ref, `PrusaResearch.ini`, `expected-summary.tsv`, `sections: 6976`, and `entries: 27340`. |
| `bazel test //packages/parity:prusaslicer_profile_schema_parity_failure_test` | Passed; mutation of `section_count` fails non-zero with required diagnostics. |
| `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` | Passed; printed `ok: Prusa profile-schema fixture verification passed`. |
| `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` | Passed; negative status and scope tests passed. |
| `bazel run //packages/parity:status \| rg "fork\\.prusaslicer\\.profile-schema\|prusaslicer_profile_schema_parity"` | Passed; printed the verified Prusa row and evidence command. |
| Exact `awk` status-row guard over `packages/parity/status.tsv` | Passed; one row, status `verified`, evidence `//packages/parity:prusaslicer_profile_schema_parity`. |
| `mdformat --check` on Phase 40 package and port docs | Passed. |
| `git diff --check` | Passed. |

---

## Accepted Risks Log

No accepted risks.

---

## Security Audit Trail

| Audit Date | Threats Total | Closed | Open | Run By |
|------------|---------------|--------|------|--------|
| 2026-06-02 | 8 | 8 | 0 | Codex |

---

## Sign-Off

- [x] All threats have a disposition (mitigate / accept / transfer)
- [x] Accepted risks documented in Accepted Risks Log
- [x] `threats_open: 0` confirmed
- [x] `status: verified` set in frontmatter

**Approval:** verified 2026-06-02
