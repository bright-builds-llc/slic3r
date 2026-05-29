---
phase: 36-parity-fixture-launcher-and-deferral-templates
verified: 2026-05-27T14:52:48Z
status: passed
score: 8/8 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 36-2026-05-27T13-38-25
generated_at: 2026-05-27T14:52:48Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 36: Parity, Fixture, Launcher, and Deferral Templates Verification Report

**Phase Goal:** Maintainers have repeatable templates and vocabulary for future fork parity work while v1.9 remains intake and architecture only.
**Verified:** 2026-05-27T14:52:48Z
**Status:** passed
**Re-verification:** No - initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
| --- | --- | --- | --- |
| 1 | Maintainer can inspect a dedicated `packages/fork-templates` package for Phase 36 fork parity templates. | VERIFIED | `packages/fork-templates/BUILD.bazel` defines a package boundary, `verify`, `verify_templates_test`, and `package_boundary`; `packages/fork-templates/README.md:3` names the package purpose. |
| 2 | Maintainer can use a fork parity checklist template with the required PAR-01 fields before a future fork feature can be marked verified. | VERIFIED | `packages/fork-templates/fork-parity-checklist-template.md:15`-`25` contains all nine required fields; lines `3`-`10` state planning-only status and future executable parity evidence. |
| 3 | Maintainer can follow a manual drift-refresh protocol that compares pinned vendor refs with current upstream heads while preserving accepted source pins. | VERIFIED | `packages/fork-templates/manual-drift-refresh-protocol.md:9`-`31` uses `bazel run //packages/fork-vendors:verify`, records selected stable tag and peeled commit confirmations, and treats drift observations as non-authoritative; lines `33`-`38` prohibit automation/source ingestion. |
| 4 | Maintainer can run a repo-owned template verifier and focused verifier tests without implying fork parity is implemented. | VERIFIED | `bazel run //packages/fork-templates:verify` printed `ok: fork template verification passed`; `bazel test //packages/fork-templates:verify_templates_test` passed; `verify_templates.sh:60`-`76` checks non-overclaiming phrases and deferral links. |
| 5 | Maintainer can inspect one central v1.9 fork-parity deferral block naming every PAR-03 deferred scope. | VERIFIED | `docs/port/README.md:190`-`205` lists full fork parity ports, GUI migration, fork-flavor release builds, signing, installers, release channels, nightly vendor sync, cloud/network device integrations, profile auto-update execution, and non-free plugin ingestion. |
| 6 | Maintainer can inspect future fork fixture namespace policy without Phase 36 fixture files. | VERIFIED | `packages/parity-fixtures/README.md:14`-`25` reserves `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/` and states Phase 36 creates no fixture files; `find packages/parity-fixtures -path 'packages/parity-fixtures/forks*'` returned no files. |
| 7 | Maintainer can inspect future fork parity-status policy that forbids v1.9 fork rows and reserves `verified` for executable evidence. | VERIFIED | `packages/parity/README.md:45`-`57`, `docs/port/parity-matrix.md:31`-`39`, and `docs/port/migration-guidance.md:65`-`76` require future `fork.<inventory_id>` style tokens and real `//packages/parity:*_parity` evidence; grep found no fork rows in `packages/parity/status.tsv`. |
| 8 | Maintainer can discover the checklist template and manual drift-refresh protocol from port, vendor, and inventory docs. | VERIFIED | `docs/port/README.md:175`-`184` and `docs/port/package-map.md:93`-`98` route to `packages/fork-templates`; `packages/fork-vendors/README.md:17`-`27` links the drift protocol; `packages/fork-inventories/README.md:19`-`23` links the checklist template and executable evidence requirement. |

**Score:** 8/8 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
| --- | --- | --- | --- |
| `packages/fork-templates/BUILD.bazel` | Bazel `verify`, `verify_templates_test`, and package boundary wiring | VERIFIED | 44 lines; `sh_binary(name = "verify")`, `sh_test`, exports, and `package_boundary` are present. |
| `packages/fork-templates/README.md` | Template package entrypoint and non-overclaiming boundary | VERIFIED | Names package, verifier command, central deferral link, and says template verification does not prove fork parity. |
| `packages/fork-templates/fork-parity-checklist-template.md` | Fixed-field PAR-01 checklist | VERIFIED | Required field table present with inventory row ID, source pin, candidate Rust module, fixture need, evidence command, docs touched, license/security note, deferred scope, and reviewer signoff. |
| `packages/fork-templates/fork-launcher-shape-template.md` | Launcher-shape planning template with v1.9 deferrals | VERIFIED | Records future launcher intent while deferring launcher targets, release builds, signing, installers, release channels, GUI/cloud/profile/plugin scope. |
| `packages/fork-templates/manual-drift-refresh-protocol.md` | Manual PAR-04 drift-refresh runbook | VERIFIED | Uses existing vendor verifier, records stable tag and peeled commit confirmations, requires reviewer decision, and forbids clone/fetch/build/import/vendor/nightly sync/ref-update automation. |
| `packages/fork-templates/verify_templates.sh` | Local template contract verifier | VERIFIED | 110-line bash script with `set -euo pipefail`, explicit `error:` failures, file checks, required label checks, and no Git/network/Bazel calls. |
| `packages/fork-templates/verify_templates_test.sh` | Focused shell tests for verifier failure modes | VERIFIED | 220-line bash test with Arrange/Act/Assert sections covering valid fixture, missing checklist label, missing non-overclaiming text, missing checklist warning, missing launcher warning, and missing drift distinction. |
| `docs/port/README.md` | Central deferral block and current template package state | VERIFIED | `## v1.9 Fork Parity Deferrals` anchor and current template-package state are present. |
| `docs/port/package-map.md` | Discoverable package-map entry for `packages/fork-templates` | VERIFIED | Package table row plus Phase 36 note link to central deferrals and verifier boundary. |
| `packages/parity-fixtures/README.md` | Future fork fixture namespace policy | VERIFIED | Reserved path shape and no Phase 36 fixture-file boundary are present. |
| `packages/parity/README.md` | Future fork status row policy | VERIFIED | No v1.9 rows, `fork.<inventory_id>` vocabulary, and future executable parity evidence requirement are present. |
| `docs/port/migration-guidance.md` | Cross-linked fixture/status/deferral guidance | VERIFIED | Contains reserved fixture namespace, central deferral link, no-status-row rule, future status token policy, and executable evidence requirement. The plan artifact's exact `packages/fork-templates` contains check is satisfied elsewhere in port docs by `docs/port/README.md` and `docs/port/package-map.md`; migration guidance satisfies its policy-routing intent without duplicating the package name. |
| `docs/port/parity-matrix.md` | Human-facing fork parity status interpretation | VERIFIED | States no v1.9 fork rows and future `fork.<inventory_id>` rows require executable parity evidence. |
| `packages/fork-vendors/README.md` | Manual drift-refresh protocol link | VERIFIED | Links `../fork-templates/manual-drift-refresh-protocol.md`, keeps verifier as manual comparison tool, and states drift observations do not update source pins automatically. |
| `packages/fork-inventories/README.md` | Checklist template link for future inventory rows | VERIFIED | Links `../fork-templates/fork-parity-checklist-template.md` and states future verified fork parity needs checklist review plus executable parity evidence. |

### Key Link Verification

| From | To | Via | Status | Details |
| --- | --- | --- | --- | --- |
| `packages/fork-templates/BUILD.bazel` | `packages/fork-templates/verify_templates.sh` | `sh_binary(name = "verify")` | VERIFIED | `BUILD.bazel:10`-`24` wires the verifier source and Markdown data/args. |
| `packages/fork-templates/verify_templates.sh` | `fork-parity-checklist-template.md` | Required checklist label checks | VERIFIED | `verify_templates.sh:45`-`56` requires all checklist table labels. |
| `packages/fork-templates/README.md` | `docs/port/README.md#v19-fork-parity-deferrals` | Central deferral link | VERIFIED | `README.md:35`-`38` links the anchor; `docs/port/README.md:190` defines it. |
| `packages/fork-templates/manual-drift-refresh-protocol.md` | `packages/fork-vendors:verify` | Existing vendor verification command | VERIFIED | Protocol lines `9`-`13` call the Bazel verifier; `packages/fork-vendors/README.md:17`-`27` links back to the manual protocol. |
| `packages/parity-fixtures/README.md` | `packages/parity/README.md` | Future fixture namespace requires future parity evidence before status publication | VERIFIED | Fixture README lines `22`-`25` require executable parity/status evidence; parity README lines `45`-`57` defines the future row policy. |
| `packages/fork-vendors/README.md` | `packages/fork-templates/manual-drift-refresh-protocol.md` | Manual drift-refresh link | VERIFIED | `packages/fork-vendors/README.md:19`-`20` links the protocol. |
| `packages/fork-inventories/README.md` | `packages/fork-templates/fork-parity-checklist-template.md` | Future inventory review link | VERIFIED | `packages/fork-inventories/README.md:19`-`23` links the checklist and executable evidence requirement. |

Note: `gsd-tools verify key-links` reported false negatives for escaped Markdown/regex patterns and for the `BUILD.bazel` source reference. Manual line-level checks above verified the actual links and wiring.

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
| --- | --- | --- | --- | --- |
| `packages/fork-templates/verify_templates.sh` | `readme_file`, `checklist_file`, `launcher_file`, `drift_file` | Four Bazel `args` from `packages/fork-templates/BUILD.bazel:18`-`23`, or package-local defaults when run directly | Yes - both `bazel run //packages/fork-templates:verify` and `bash packages/fork-templates/verify_templates.sh` read the real checked-in Markdown files and passed. | VERIFIED |
| `packages/fork-templates/verify_templates_test.sh` | Temporary fixture directory paths | `mktemp -d` fixtures populated by test helpers, then passed to the verifier | Yes - direct `bash packages/fork-templates/verify_templates_test.sh` passed and prints `ok: verify_templates_test`; Bazel test also passed. | VERIFIED |
| Markdown docs/templates | Static maintainer guidance | Checked-in files | Yes - not dynamic renderers; required content was verified by exact text and line-level inspection. | N/A - static docs |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
| --- | --- | --- | --- |
| Template verifier accepts the real package and prints success | `bazel run //packages/fork-templates:verify` | Printed `ok: fork template verification passed` | PASS |
| Verifier failure-mode tests run through Bazel | `bazel test //packages/fork-templates:verify_templates_test` | Target passed | PASS |
| Verifier direct shell entrypoint works without Bazel | `bash packages/fork-templates/verify_templates.sh` | Printed `ok: fork template verification passed` | PASS |
| Direct shell tests exercise success and failure fixtures | `bash packages/fork-templates/verify_templates_test.sh` | Printed `ok: verify_templates_test` | PASS |
| Markdown formatting remains clean for scoped Phase 36 docs | `mdformat --check packages/fork-templates/fork-parity-checklist-template.md packages/fork-templates/fork-launcher-shape-template.md packages/fork-templates/manual-drift-refresh-protocol.md docs/port/package-map.md` | No output, exit 0 | PASS |
| Shell formatting remains clean | `shfmt -d packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh` | No diff, exit 0 | PASS |
| Shell diagnostics remain clean | `shellcheck packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh` | No diagnostics, exit 0 | PASS |
| Existing inventory verifier still accepts source/status vocabulary | `bazel run //packages/fork-inventories:verify` | Printed `ok: inventory verification passed` | PASS |
| Existing vendor verifier still supports manual drift protocol | `bazel run //packages/fork-vendors:verify` | Passed; reported the known non-fatal OrcaSlicer branch drift warning | PASS |
| Phase 36 did not add fork rows or fixture files | `test -z "$(git status --porcelain -- packages/parity/status.tsv packages/parity-fixtures/forks)"`; `find packages/parity-fixtures -path 'packages/parity-fixtures/forks*' -maxdepth 5 -print`; `rg -n '^(fork\.|prusaslicer|bambustudio|orcaslicer)' packages/parity/status.tsv` | No status output, no fork fixture paths, no fork rows | PASS |
| Whitespace check is clean | `git diff --check` | No output, exit 0 | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
| --- | --- | --- | --- | --- |
| PAR-01 | 36-01, 36-02 | Maintainer can use a fork parity checklist template with inventory row ID, source pin, candidate Rust module, fixture need, evidence command, docs touched, license/security note, deferred scope, and reviewer signoff before verified status. | SATISFIED | Checklist table lines `15`-`25`; verifier checks labels; inventory docs link the checklist. |
| PAR-02 | 36-02 | Maintainer can inspect documented fork fixture namespace and parity-status conventions that reserve verified fork status for future executable evidence, not source pins or inventories. | SATISFIED | Fixture README lines `14`-`25`; parity README lines `45`-`57`; parity matrix lines `31`-`39`; no fork rows or fixture files found. |
| PAR-03 | 36-01, 36-02 | Maintainer can inspect v1.9 documentation explicitly deferring full fork parity ports, GUI migration, fork-flavor release builds, signing, installers, release channels, nightly vendor sync, cloud/network integrations, profile auto-update execution, and non-free plugin ingestion. | SATISFIED | Central deferral block at `docs/port/README.md:190`-`205`; launcher template and package docs link the central block. |
| PAR-04 | 36-01, 36-02 | Maintainer can run or follow a manual drift-refresh protocol that compares pinned vendor refs with current upstream heads before later fork parity milestones. | SATISFIED | Manual protocol lines `9`-`31`; vendor README lines `17`-`27`; `bazel run //packages/fork-vendors:verify` passed with expected drift warning. |

No orphaned Phase 36 requirements were found: `.planning/REQUIREMENTS.md` maps PAR-01 through PAR-04 to Phase 36, and both plan frontmatter blocks together claim those same IDs.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
| --- | --- | --- | --- | --- |
| `packages/fork-templates/verify_templates_test.sh` | 16 | `XXXXXX` in `mktemp` template matched the generic `XXX` scan | Info | False positive only. This is the standard `mktemp` suffix pattern for safe temporary directories, not a placeholder or stub. |

No TODO/FIXME placeholders, empty implementations, console-log-only handlers, hardcoded empty rendered data, fork status rows, fork fixture files, or automation/source-ingestion behavior were found in the Phase 36 scope.

### Human Verification Required

None. Phase 36 produces Markdown templates/docs plus local shell/Bazel verification. The relevant behavior is checkable through file inspection and repo-native commands.

### Deferred Items

No Phase 36 gaps were deferred. The later roadmap explicitly keeps real fork parity ports, cross-flavor build automation, and nightly vendor sync in future milestones, but Phase 36 only promised templates, vocabulary, manual protocol, deferral labels, and verifier guardrails.

### Gaps Summary

No blocking gaps found. The phase materially delivered the planned parity fixture templates, launcher-shape template, manual drift-refresh protocol, documentation routing, deferral labeling, and executable verifier/test guardrails while preserving the v1.9 boundary that source pins, inventories, templates, registry metadata, and template verification do not prove fork runtime parity.

---

_Verified: 2026-05-27T14:52:48Z_
_Verifier: the agent (gsd-verifier)_
