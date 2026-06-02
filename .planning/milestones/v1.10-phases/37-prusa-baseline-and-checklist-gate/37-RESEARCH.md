# Phase 37: Prusa Baseline and Checklist Gate - Research

**Researched:** 2026-05-31\
**Domain:** Documentation-only fork baseline/checklist gate with Bazel shell verification. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Confidence:** HIGH for repository patterns and Prusa pin/checklist values; MEDIUM for recommended future target names because those names are not locked yet. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv; .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

<user_constraints>

## User Constraints (from CONTEXT.md)

Source: [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

### Locked Decisions

### Prusa Baseline Package

- **D-01:** Add a dedicated package under `packages/` for the Phase 37 Prusa
  baseline/checklist review records instead of rewriting the Phase 36 template
  package or mixing completed Prusa records into future fixture/status packages.
- **D-02:** The package must be review-gated documentation plus a local verifier
  only. Verification proves record completeness and boundary wording; it does
  not prove Prusa runtime support or executable fork parity.
- **D-03:** The package should be discoverable from the port control-plane docs
  and package map so later Prusa phases can find the accepted baseline inputs.

### Drift-Refresh Record

- **D-04:** Record the accepted Prusa source baseline from
  `packages/fork-vendors/forks.tsv`: selected tag `version_2.9.5`, peeled
  commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`, and upstream repo
  `https://github.com/prusa3d/PrusaSlicer`.
- **D-05:** Include a maintainer review record shaped by
  `packages/fork-templates/manual-drift-refresh-protocol.md`, with explicit
  fields for selected stable tag confirmation, peeled commit confirmation,
  branch drift observation, reviewer decision, and reviewer signoff.
- **D-06:** Treat branch-head data as drift-only observation. The Phase 37
  record must state that accepted source pins remain unchanged unless a future
  reviewed intake update modifies `packages/fork-vendors/forks.tsv`.

### Checklist Gate

- **D-07:** Complete the checklist for the first v1.10 Prusa candidate row:
  `prusaslicer.profile-schema` from `packages/fork-inventories/prusaslicer.tsv`.
- **D-08:** The checklist record must include the inventory row ID, source pin,
  candidate Rust module, fixture need, evidence command, docs touched, license
  or security note, deferred scope, and reviewer signoff, matching the Phase 36
  checklist template fields.
- **D-09:** Candidate Rust module should point to the shared Rust profile/config
  boundary planned for later phases, not to a Prusa-only workspace or copied
  upstream source tree.
- **D-10:** Fixture need and evidence command should be future-oriented and
  explicit: Phase 37 may name the intended future fixture namespace and parity
  command shape, but must not create the fixtures or command yet.

### Scope-Control Wording

- **D-11:** Add human-readable boundary text that distinguishes the selected
  v1.10 Prusa profile/config evidence scope from deferred Prusa project files,
  STEP import, support generation, arc fitting, wall seam behavior,
  network/device integration, full fork runtime support, GUI support, fork
  release builds, and sync automation.
- **D-12:** The verifier should fail closed when required review fields,
  accepted pin values, checklist field labels, or non-overclaiming phrases are
  missing.

### the agent's Discretion

- Exact package name and record file names, provided they are discoverable and
  scoped to Prusa baseline/checklist evidence.
- Whether the verifier is one shell script or split into helper/test scripts,
  provided it is rerunnable directly and through Bazel.
- Exact reviewer placeholders, as long as the record keeps reviewer decision
  and signoff visibly incomplete until a human fills them.

### Deferred Ideas (OUT OF SCOPE)

- Prusa fixture files and fixture update rules are Phase 38 scope.
- Rust profile/config parsing and normalization logic is Phase 39 scope.
- Executable Prusa profile/config parity command, docs/status update, and
  verified evidence are Phase 40 scope.
- Prusa project files, STEP import, support generation, arc fitting, wall seam
  behavior, network/device integration, profile auto-update execution, full fork
  runtime support, GUI support, fork release builds, and vendor sync automation
  remain deferred beyond v1.10 unless future roadmap work pulls them forward.

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PRUSA-01 | Maintainer can run the manual PrusaSlicer drift-refresh protocol against the accepted v1.9 source pin and record selected stable tag confirmation, peeled commit confirmation, branch drift observation, reviewer decision, and reviewer signoff without automatically changing accepted source pins. [VERIFIED: .planning/REQUIREMENTS.md] | Use the existing `bazel run //packages/fork-vendors:verify` command in the drift record and verify exact Prusa selected tag, peeled commit, repo URL, branch-drift-only wording, reviewer decision, and reviewer signoff placeholders. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh; packages/fork-templates/manual-drift-refresh-protocol.md] |
| PRUSA-02 | Maintainer can inspect completed Prusa checklist records for the v1.10 profile schema/config evidence slice, including inventory row ID, source pin, candidate Rust module, fixture need, evidence command, docs touched, license or security note, deferred scope, and reviewer signoff. [VERIFIED: .planning/REQUIREMENTS.md] | Populate one checklist record for `prusaslicer.profile-schema` using the exact inventory row and Phase 36 checklist labels, with future-oriented fixture and parity command entries. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; packages/fork-templates/fork-parity-checklist-template.md] |
| PRUSA-03 | Maintainer can distinguish the narrow v1.10 Prusa profile/config evidence scope from deferred Prusa project files, STEP import, support generation, arc fitting, wall seam behavior, network/device integration, full fork runtime support, and fork release builds. [VERIFIED: .planning/REQUIREMENTS.md] | Add explicit boundary wording in the package README, checklist, verifier required text, and port docs; do not add fork parity status rows, fixtures, upstream source imports, or runtime targets. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md] |

</phase_requirements>

## Summary

Phase 37 should add a small dedicated package named `packages/prusa-baseline` containing review records plus local verification; the name is a recommendation under the phase's package-name discretion. [ASSUMED] The package should mirror the existing fork-package pattern: Markdown artifacts exported from `BUILD.bazel`, a Bash `sh_binary(name = "verify")`, and one `sh_test` that proves important failure modes. [VERIFIED: packages/fork-templates/BUILD.bazel; packages/fork-templates/verify_templates.sh; packages/fork-templates/verify_templates_test.sh]

The record values are already available in checked-in TSVs. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv] The accepted Prusa source baseline is `version_2.9.5` at peeled commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`, and the selected checklist row is `prusaslicer.profile-schema` with source path `resources/profiles/PrusaResearch.ini`, parity dependencies `config;config.persistence`, and `future-candidate` status. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv]

Verification must stay a gate for completeness and non-overclaiming wording. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] It should not create Prusa fixtures, fork status rows, upstream source imports, executable parity commands, Rust profile parsing logic, fork release builds, or runtime support. [VERIFIED: .planning/REQUIREMENTS.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md]

**Primary recommendation:** Create `packages/prusa-baseline` with `README.md`, `drift-refresh-record.md`, `profile-schema-checklist.md`, `verify_prusa_baseline.sh`, `verify_prusa_baseline_test.sh`, and `BUILD.bazel`; route it from `docs/port/README.md` and `docs/port/package-map.md`, with optional one-line guardrails in `docs/port/migration-guidance.md` and `docs/port/parity-matrix.md`. [ASSUMED; VERIFIED: docs/port/README.md; docs/port/package-map.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md]

## Project Constraints (from AGENTS.md)

- Read local `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned canonical standards before planning or implementation work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Do not edit managed Bright Builds blocks in `AGENTS.md` or `AGENTS.bright-builds.md`; downstream customizations belong outside managed blocks or in `standards-overrides.md`. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- There are no meaningful active local standards overrides; `standards-overrides.md` still contains the placeholder table. [VERIFIED: standards-overrides.md]
- Future `.planning/phases/*/*-SUMMARY.md` files must keep `requirements-completed` synchronized, use the exact hyphenated key, use `[]` when no requirements close, and avoid `mdformat` on phase summaries. [VERIFIED: AGENTS.md]
- Prefer repo-owned verification entrypoints and run relevant checks for changed paths before commit. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Keep verifier logic small, rerunnable, and diagnosable; use early exits, shallow control flow, and checked-in scripts rather than hiding substantial shell logic inside another file. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Unit or shell failure-mode tests should test one concern per test and use clear Arrange/Act/Assert sections when the structure is non-trivial. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

## Standard Stack

### Core

| Stack Item | Version | Purpose | Why Standard |
|------------|---------|---------|--------------|
| Bazel `sh_binary` and `sh_test` | Bazel 8.6.0 from `.bazelversion` and local `bazel --version`. [VERIFIED: .bazelversion; local command `bazel --version`] | Expose `//packages/prusa-baseline:verify` and a package-local failure-mode test. [ASSUMED] | Existing fork packages use `sh_binary(name = "verify")`, package-local data files, and focused `sh_test` targets. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel; packages/fork-templates/BUILD.bazel] |
| Bash verifier | GNU Bash 3.2.57 on this macOS environment. [VERIFIED: local command `bash --version`] | Check required files, exact values, labels, and non-overclaiming phrases. [VERIFIED: packages/fork-templates/verify_templates.sh] | Existing fork verifiers are Bash scripts using `set -euo pipefail`, file checks, exact text checks, TSV validation, and explicit errors. [VERIFIED: packages/fork-vendors/verify_forks.sh; packages/fork-inventories/verify_inventories.sh; packages/fork-templates/verify_templates.sh] |
| Markdown review records | Not versioned as a runtime dependency. [VERIFIED: packages/fork-templates/README.md] | Store maintainer-readable drift and checklist records. [VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md; packages/fork-templates/fork-parity-checklist-template.md] | Phase 36 already uses Markdown templates for drift protocol and checklist review fields. [VERIFIED: packages/fork-templates/README.md] |

### Supporting

| Tool or Input | Version | Purpose | When to Use |
|---------------|---------|---------|-------------|
| Git remote lookup through existing verifier | Git 2.53.0 locally. [VERIFIED: local command `git --version`] | Run `bazel run //packages/fork-vendors:verify` for selected tag and peeled commit confirmation. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh] | Use manually for PRUSA-01 drift refresh; do not reimplement remote probing inside the new Phase 37 verifier. [VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md] |
| `packages/fork-vendors/forks.tsv` | Checked-in TSV, no package version. [VERIFIED: packages/fork-vendors/forks.tsv] | Source of accepted Prusa pin values. [VERIFIED: packages/fork-vendors/README.md] | Use to populate and verify `drift-refresh-record.md`. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| `packages/fork-inventories/prusaslicer.tsv` | Checked-in TSV, no package version. [VERIFIED: packages/fork-inventories/prusaslicer.tsv] | Source of the `prusaslicer.profile-schema` checklist row. [VERIFIED: packages/fork-inventories/README.md] | Use to populate and verify `profile-schema-checklist.md`. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| `shfmt` | 3.12.0 locally. [VERIFIED: local command `shfmt --version`] | Optional shell formatting check for the new verifier/test scripts. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] | Use if implementation changes shell scripts; it is available on this machine. [VERIFIED: local command `command -v shfmt`] |
| `mdformat` | 1.0.0 locally. [VERIFIED: local command `mdformat --version`] | Optional Markdown formatting check for package docs. [CITED: Bright Builds verification standard URL above] | Do not run it on phase `*-SUMMARY.md`; Phase 37 docs are not summaries. [VERIFIED: AGENTS.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `packages/prusa-baseline` [ASSUMED] | `packages/prusa-baseline-checklist` [ASSUMED] | The longer name is more literal, but the shorter name still fits the locked scope and keeps labels concise. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| Bash verifier [VERIFIED: existing package pattern] | Python or Node verifier [ASSUMED] | Python/Node would add an unnecessary implementation surface for exact-text checks already handled by existing Bash verifiers. [VERIFIED: packages/fork-templates/verify_templates.sh] |
| Dedicated baseline package [VERIFIED: locked decision] | Rewriting `packages/fork-templates` [VERIFIED: rejected by context] | Rewriting templates would mix completed Prusa records into Phase 36 template artifacts, contradicting D-01. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |

**Installation:** No new packages should be installed for Phase 37. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

**Version verification:** Local checks already run were `bazel --version`, `git --version`, `bash --version`, `shfmt --version`, and `mdformat --version`. [VERIFIED: local command output]

## Accepted Prusa Baseline Values

| Field | Value | Source |
|-------|-------|--------|
| Vendor ID | `prusaslicer` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Display name | `PrusaSlicer` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Upstream repo | `https://github.com/prusa3d/PrusaSlicer` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Selected stable tag | `version_2.9.5` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Tag kind | `annotated` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Tag ref SHA | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Tag object SHA | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Peeled commit SHA | `9a583bd438b195856f3bcf7ea99b69ba4003a961` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Default branch | `master` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Recorded observed branch head | `43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Capture date | `2026-05-26T16:23:36Z` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Source paths | `src;resources;doc;tests;version.inc` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| SPDX identifier | `AGPL-3.0-only` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Provenance notes | `metadata-only-not-legal-review;upstream-readme-and-license-observed` | [VERIFIED: packages/fork-vendors/forks.tsv] |
| Caution flags | `none` | [VERIFIED: packages/fork-vendors/forks.tsv] |

The existing vendor verifier succeeded for Prusa on 2026-05-31 and printed `ok: prusaslicer version_2.9.5 -> 9a583bd438b195856f3bcf7ea99b69ba4003a961`; that run did not emit a Prusa branch-drift warning. [VERIFIED: local command `bazel run //packages/fork-vendors:verify`] The implementation should still keep the branch drift field editable because the manual protocol requires recording the current run's warning text or `none observed`. [VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md]

## Checklist Values

| Required Field | Recommended Maintainer Entry | Source |
|----------------|------------------------------|--------|
| Inventory row ID | `prusaslicer.profile-schema` | [VERIFIED: packages/fork-inventories/prusaslicer.tsv] |
| Source pin | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | [VERIFIED: packages/fork-inventories/prusaslicer.tsv; packages/fork-vendors/forks.tsv] |
| Candidate Rust module | `packages/slic3r-rust` shared profile/config boundary for Phase 39; exact crate/module name deferred. | [VERIFIED: .planning/ROADMAP.md; docs/port/contract-inventory.md] |
| Fixture need | Future `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/...`; not created in Phase 37. | [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; docs/port/migration-guidance.md] |
| Evidence command | Future `bazel run //packages/parity:prusaslicer_profile_schema_parity`; not created in Phase 37. | [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; docs/port/migration-guidance.md] |
| Docs touched | `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md`. | [VERIFIED: docs/port/README.md; docs/port/package-map.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md] |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no Prusa non-free/network-plugin caution in selected README evidence; no network, cloud, credential, profile auto-update, plugin ingestion, or runtime support scope. | [VERIFIED: packages/fork-vendors/forks.tsv; .planning/REQUIREMENTS.md] |
| Deferred scope | Prusa project files, STEP import, support generation, arc fitting, wall seam behavior, network/device integration, profile auto-update execution, full fork runtime support, GUI support, fork release builds, sync automation, upstream source imports, fixtures, and executable parity commands. | [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; .planning/REQUIREMENTS.md] |
| Reviewer signoff | `PENDING - human reviewer name and UTC date required before implementation consumes this gate.` | [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |

Additional row values to include in checklist prose: source path `resources/profiles/PrusaResearch.ini`, feature surface `profile-schema`, feature category `profile-schema`, ownership `fork-specific`, complexity `medium`, parity dependencies `config;config.persistence`, v1.9 decision `future-candidate`, caution flags `none`, and future note `Prusa profile schema planning row; future parity requires loader fixtures and config comparison evidence.` [VERIFIED: packages/fork-inventories/prusaslicer.tsv]

## Architecture Patterns

### Recommended Project Structure

```text
packages/prusa-baseline/
├── BUILD.bazel                       # Bazel exports, verify binary, and verifier test. [ASSUMED]
├── README.md                         # Package boundary, commands, source links, and no-parity wording. [ASSUMED]
├── drift-refresh-record.md           # Completed Prusa-specific drift protocol record. [ASSUMED]
├── profile-schema-checklist.md       # Completed Prusa profile-schema checklist record. [ASSUMED]
├── verify_prusa_baseline.sh          # Fail-closed exact-value/text verifier. [ASSUMED]
└── verify_prusa_baseline_test.sh     # Failure-mode tests for missing labels/phrases/values. [ASSUMED]
```

The structure follows the existing `packages/fork-templates` pattern of Markdown artifacts plus `BUILD.bazel`, `verify_*.sh`, and `verify_*_test.sh`. [VERIFIED: packages/fork-templates/BUILD.bazel; packages/fork-templates/verify_templates.sh; packages/fork-templates/verify_templates_test.sh]

### Pattern 1: Documentation Package With Bazel Verify Target

**What:** Export review records, run the verifier through `sh_binary(name = "verify")`, include all checked Markdown as `data`, and add one `sh_test` target for failure fixtures. [VERIFIED: packages/fork-templates/BUILD.bazel]\
**When to use:** Use this for Phase 37 because the phase is review-gated documentation plus a local verifier only. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Example:**

```python
# Source: packages/fork-templates/BUILD.bazel
sh_binary(
    name = "verify",
    srcs = ["verify_prusa_baseline.sh"],
    data = [
        "README.md",
        "drift-refresh-record.md",
        "profile-schema-checklist.md",
    ],
)
```

### Pattern 2: Fail Closed On Exact Required Text

**What:** Use small shell helpers such as `require_file` and `require_text`, and fail with `error:` when a required value, field label, or boundary phrase is absent. [VERIFIED: packages/fork-templates/verify_templates.sh]\
**When to use:** Use this for required Prusa pin values, checklist labels, reviewer placeholders, and non-overclaiming phrases. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Example:**

```bash
# Source: packages/fork-templates/verify_templates.sh
require_text "${checklist_file}" "profile-schema-checklist.md" "| Inventory row ID |"
require_text "${checklist_file}" "profile-schema-checklist.md" "prusaslicer.profile-schema"
```

### Pattern 3: Keep Drift Remote Lookup In Existing Vendor Verifier

**What:** The drift record should instruct maintainers to run `bazel run //packages/fork-vendors:verify`; the new Phase 37 verifier should check that instruction and recorded fields exist. [VERIFIED: packages/fork-vendors/README.md; packages/fork-templates/manual-drift-refresh-protocol.md]\
**When to use:** Use this to avoid duplicating `git ls-remote` logic and to keep branch-head observations from changing accepted pins automatically. [VERIFIED: packages/fork-vendors/verify_forks.sh; packages/fork-vendors/verify_forks_test.sh]\
**Example:**

```bash
# Source: packages/fork-templates/manual-drift-refresh-protocol.md
bazel run //packages/fork-vendors:verify
```

### Pattern 4: Failure-Mode Shell Tests

**What:** Create temporary valid fixtures, mutate one required line or phrase away, run the verifier, and assert an `error:` message. [VERIFIED: packages/fork-templates/verify_templates_test.sh; packages/fork-vendors/verify_forks_test.sh]\
**When to use:** Use this to test missing accepted Prusa pin, missing checklist label, missing deferred-scope phrase, missing reviewer signoff, and overclaiming wording. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

### Anti-Patterns to Avoid

- **Treating the checklist as parity evidence:** Checklist completion prepares later executable evidence; it does not prove fork parity. [VERIFIED: packages/fork-templates/fork-parity-checklist-template.md]
- **Creating Prusa fixtures or parity targets in Phase 37:** Fixture files are Phase 38 and executable Prusa parity is Phase 40. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; .planning/ROADMAP.md]
- **Updating source pins from branch drift:** Branch heads are drift-only observations and accepted pins change only through future reviewed intake updates. [VERIFIED: packages/fork-vendors/README.md; packages/fork-templates/manual-drift-refresh-protocol.md]
- **Creating a Prusa-only Rust workspace:** Existing decisions require a shared Rust flavor/profile boundary, not vendor-specific workspaces or copied upstream source trees. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md; .planning/STATE.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Stable tag and peeled commit confirmation | New git remote probing in `packages/prusa-baseline` | Existing `bazel run //packages/fork-vendors:verify` | It already validates selected tag refs and peeled commits and treats branch drift as warnings. [VERIFIED: packages/fork-vendors/verify_forks.sh; packages/fork-vendors/verify_forks_test.sh] |
| Inventory source-ref validation | New TSV validator inside Phase 37 | Existing `bazel run //packages/fork-inventories:verify` plus exact record checks | Inventory verifier already validates accepted source refs, enum values, category-map coverage, and parity dependencies. [VERIFIED: packages/fork-inventories/verify_inventories.sh] |
| Fork parity evidence | Fake or placeholder executable parity command | Future Phase 40 `//packages/parity:*_parity` target | Existing docs reserve `verified` fork status for real executable evidence. [VERIFIED: docs/port/parity-matrix.md; docs/port/migration-guidance.md] |
| Prusa fixture corpus | Empty directories or placeholder fixture files | Future Phase 38 fixture namespace and update rules | Phase 37 may name the future namespace but must not create fixtures. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| Upstream source intake | Git submodule, subtree, vendor tree, Bzlmod external repo, or clone step | Checked-in source pins, inventory rows, and review records | v1.10 explicitly excludes importing or building upstream fork source trees. [VERIFIED: .planning/REQUIREMENTS.md] |

**Key insight:** Phase 37 is a gate that makes later implementation safer by freezing the reviewed inputs and deferred boundaries; it is not an implementation or evidence-production phase. [VERIFIED: .planning/ROADMAP.md; .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Overclaiming Fork Support

**What goes wrong:** Docs imply Prusa runtime support, GUI support, release builds, or verified parity because baseline records exist. [VERIFIED: docs/port/parity-matrix.md; packages/fork-templates/fork-parity-checklist-template.md]\
**Why it happens:** Source pins, inventories, templates, and checklists look authoritative even though they are planning inputs. [VERIFIED: docs/port/README.md; packages/fork-inventories/README.md]\
**How to avoid:** Require phrases such as `does not prove Prusa runtime support`, `does not prove executable fork parity`, and `future executable parity evidence required`. [VERIFIED: packages/fork-templates/verify_templates.sh]\
**Warning signs:** New rows in `packages/parity/status.tsv`, fixture files, or docs saying `verified` for Prusa before Phase 40. [VERIFIED: docs/port/parity-matrix.md; .planning/ROADMAP.md]

### Pitfall 2: Branch Drift Changes Accepted Pins

**What goes wrong:** A branch-head warning is treated as a reason to update `forks.tsv` during Phase 37. [VERIFIED: packages/fork-vendors/README.md]\
**Why it happens:** The vendor verifier emits branch drift warnings while still exiting successfully for stable tag checks. [VERIFIED: packages/fork-vendors/verify_forks.sh; local command `bazel run //packages/fork-vendors:verify`]\
**How to avoid:** The record must say accepted source pins remain unchanged unless a future reviewed intake update modifies `packages/fork-vendors/forks.tsv`. [VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md]\
**Warning signs:** Checklist source pin uses a branch name or observed branch head instead of `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. [VERIFIED: packages/fork-inventories/verify_inventories.sh]

### Pitfall 3: Future Values Look Current

**What goes wrong:** Future fixture path or parity command text reads like an existing target. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Why it happens:** The checklist requires `Fixture need` and `Evidence command`, but Phase 37 must only name future-oriented shapes. [VERIFIED: packages/fork-templates/fork-parity-checklist-template.md; .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**How to avoid:** Prefix future entries with `Future` or `planned`, and make the verifier require `not created in Phase 37`. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Warning signs:** `bazel query //packages/parity:prusaslicer_profile_schema_parity` succeeds during Phase 37. [ASSUMED; VERIFIED: .planning/ROADMAP.md]

### Pitfall 4: Checklist Omits Human Review State

**What goes wrong:** Reviewer decision or signoff fields appear completed by the agent. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Why it happens:** The phase asks for completed records but also requires human reviewer placeholders to remain visibly incomplete. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**How to avoid:** Use explicit `PENDING - human reviewer ... required` values and require them in the verifier. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
**Warning signs:** Reviewer signoff has an agent name, no date, or no `PENDING` marker. [ASSUMED]

## Code Examples

Verified patterns from existing repository sources follow. [VERIFIED: packages/fork-templates/verify_templates.sh; packages/fork-templates/BUILD.bazel]

### Exact Text Requirement

```bash
# Source: packages/fork-templates/verify_templates.sh
require_text "${readme_file}" "README.md" \
    "template verification does not prove fork parity"
```

Use the same pattern with Prusa-specific phrases such as `Phase 37 verification does not prove Prusa runtime support` and `accepted source pins remain unchanged unless a future reviewed intake update modifies packages/fork-vendors/forks.tsv`. [ASSUMED; VERIFIED: packages/fork-templates/verify_templates.sh; packages/fork-templates/manual-drift-refresh-protocol.md]

### Checklist Label Loop

```bash
# Source: packages/fork-templates/verify_templates.sh
for label in \
    "Inventory row ID" \
    "Source pin" \
    "Reviewer signoff"; do
    require_text "${checklist_file}" "profile-schema-checklist.md" "| ${label} |"
done
```

The implementation should include all nine Phase 36 checklist labels, not only the three shown above. [VERIFIED: packages/fork-templates/fork-parity-checklist-template.md]

### Bazel Package Shape

```python
# Source: packages/fork-templates/BUILD.bazel
sh_test(
    name = "verify_prusa_baseline_test",
    srcs = ["verify_prusa_baseline_test.sh"],
    data = ["verify_prusa_baseline.sh"],
)
```

The new package should also expose a `filegroup(name = "package_boundary")` because existing fork packages do that for package-owned files. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel; packages/fork-templates/BUILD.bazel]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source pins only in `packages/fork-vendors`. [VERIFIED: packages/fork-vendors/README.md] | Phase 37 should add a Prusa-specific review package that records how the accepted pin and checklist are consumed. [ASSUMED; VERIFIED: .planning/ROADMAP.md] | v1.10 Phase 37 begins after v1.9 Phase 36. [VERIFIED: .planning/ROADMAP.md] | Later implementation phases can consume reviewed baseline inputs instead of reinterpreting TSVs ad hoc. [ASSUMED] |
| Phase 36 templates describe generic future fork review. [VERIFIED: packages/fork-templates/README.md] | Phase 37 should create completed Prusa records for `prusaslicer.profile-schema`. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | Phase 37 scope is the first v1.10 gate. [VERIFIED: .planning/ROADMAP.md] | The planner can make concrete tasks for Prusa profile/config evidence without broadening fork runtime scope. [VERIFIED: .planning/REQUIREMENTS.md] |
| Fork rows are absent from `packages/parity/status.tsv` in v1.9. [VERIFIED: docs/port/parity-matrix.md] | Keep fork status absent until executable evidence exists in a later phase. [VERIFIED: docs/port/migration-guidance.md] | Phase 40 is the first executable Prusa profile parity phase. [VERIFIED: .planning/ROADMAP.md] | Phase 37 verification should prove records and wording only. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |

**Deprecated/outdated:** Treating source pins, inventory rows, templates, or checklist completion as verified fork parity is explicitly rejected by current docs. [VERIFIED: docs/port/README.md; docs/port/parity-matrix.md; packages/fork-templates/fork-parity-checklist-template.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `packages/prusa-baseline` is the recommended package name. [ASSUMED] | Summary; Standard Stack; Architecture Patterns | Low: the phase gives the agent discretion on exact package name, but docs and Bazel labels would need corresponding edits. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| A2 | `bazel run //packages/parity:prusaslicer_profile_schema_parity` is the recommended future evidence command text for the checklist. [ASSUMED] | Checklist Values; Common Pitfalls | Medium: Phase 40 may choose a different target name; Phase 37 should phrase it as planned/future and not create the target. [VERIFIED: .planning/ROADMAP.md; .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| A3 | `PENDING - human reviewer ... required` is the recommended visible placeholder style. [ASSUMED] | Checklist Values; Common Pitfalls | Low: exact placeholder wording is discretionary, but the record must keep reviewer decision/signoff visibly incomplete until a human fills them. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |

## Open Questions (RESOLVED)

1. **Should Phase 37 implementation rerun `bazel run //packages/fork-vendors:verify` immediately before writing `drift-refresh-record.md`?**\
   What we know: The command ran successfully on 2026-05-31 and emitted no Prusa branch-drift warning. [VERIFIED: local command `bazel run //packages/fork-vendors:verify`]\
   What's unclear: Branch heads can change after this research run. [VERIFIED: packages/fork-vendors/README.md]\
   RESOLVED: Yes. The execution plan should rerun `bazel run //packages/fork-vendors:verify` before writing `drift-refresh-record.md`, then record the current Prusa selected-tag confirmation, peeled-commit confirmation, and branch drift observation as `none observed` or the current Prusa warning text. Reviewer decision and reviewer signoff remain explicitly human-gated and pending until a human fills them. [ASSUMED; VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md]

1. **Should docs routing include `packages/fork-vendors/README.md` and `packages/fork-inventories/README.md` cross-links?**\
   What we know: Context lists those cross-links as optional integration points. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]\
   What's unclear: The smallest robust route may be only `docs/port/README.md` plus `docs/port/package-map.md`. [ASSUMED]\
   RESOLVED: Require `docs/port/README.md` and `docs/port/package-map.md`. Keep `docs/port/migration-guidance.md` and `docs/port/parity-matrix.md` as short scope-guard updates because the plan already modifies them; do not require extra cross-links from `packages/fork-vendors/README.md` or `packages/fork-inventories/README.md` in Phase 37. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `bazel run/test //packages/prusa-baseline:*` | Yes. [VERIFIED: local command `command -v bazel`] | 8.6.0. [VERIFIED: `.bazelversion`; local command `bazel --version`] | None needed. [VERIFIED: existing Bazel package pattern] |
| Git | Manual drift refresh through `//packages/fork-vendors:verify` | Yes. [VERIFIED: local command `command -v git`] | 2.53.0. [VERIFIED: local command `git --version`] | If network is unavailable, record verifier blockage instead of updating pins. [VERIFIED: packages/fork-vendors/verify_forks.sh] |
| Bash | New verifier and verifier test | Yes. [VERIFIED: local command `command -v bash`] | GNU Bash 3.2.57. [VERIFIED: local command `bash --version`] | Keep script Bash 3.2-compatible. [ASSUMED] |
| `shfmt` | Optional shell formatting check | Yes. [VERIFIED: local command `command -v shfmt`] | 3.12.0. [VERIFIED: local command `shfmt --version`] | Skip formatter if not required by repo-local command. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] |
| `mdformat` | Optional Markdown formatting check for package docs | Yes. [VERIFIED: local command `command -v mdformat`] | 1.0.0. [VERIFIED: local command `mdformat --version`] | Do not use on phase summaries. [VERIFIED: AGENTS.md] |
| `buildifier` | Optional BUILD formatting | No. [VERIFIED: local command `command -v buildifier`] | N/A | Rely on existing BUILD style and `bazel` analysis/test. [ASSUMED; VERIFIED: packages/fork-templates/BUILD.bazel] |

**Missing dependencies with no fallback:** None for Phase 37 planning and implementation. [VERIFIED: local dependency audit]

**Missing dependencies with fallback:** `buildifier` is missing, but Bazel can analyze/test the package and existing BUILD style is simple. [VERIFIED: local command `command -v buildifier`; packages/fork-templates/BUILD.bazel]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | No authentication surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V3 Session Management | No. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | No session state is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | No. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | No authorization boundary is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | Yes. [VERIFIED: packages/fork-templates/verify_templates.sh] | Verify local Markdown records using exact required fields, exact accepted pin values, and fail-closed required phrases. [VERIFIED: packages/fork-templates/verify_templates.sh; .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |
| V6 Cryptography | No. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | Do not add crypto, signing, release packaging, or source ingestion. [VERIFIED: .planning/REQUIREMENTS.md] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Tampered review record omits accepted pin or deferred-scope language. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | Tampering | Fail closed on exact Prusa pin values, required labels, and non-overclaiming phrases. [VERIFIED: packages/fork-templates/verify_templates.sh] |
| Branch-head drift is represented as accepted source truth. [VERIFIED: packages/fork-vendors/README.md] | Tampering | Require accepted source pin wording and branch-drift-only wording. [VERIFIED: packages/fork-templates/manual-drift-refresh-protocol.md] |
| Shell verifier accidentally executes display-only commands from records. [VERIFIED: packages/fork-vendors/verify_forks_test.sh] | Elevation of Privilege | Treat record values as text and avoid evaluating checklist command strings. [VERIFIED: packages/fork-vendors/verify_forks_test.sh] |
| Human reviewer state is falsely represented as signed off. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] | Repudiation | Keep explicit `PENDING` reviewer placeholders until human review fills them. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md` - locked Phase 37 decisions, discretion, and deferred scope. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - PRUSA-01 through PRUSA-03 and v1.10 out-of-scope table. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 37 goal, dependency, success criteria, and Phase 38-40 boundaries. [VERIFIED: local file read]
- `.planning/STATE.md` - current milestone decisions about narrow Prusa profile/config evidence and shared Rust flavor boundary. [VERIFIED: local file read]
- `packages/fork-vendors/forks.tsv`, `README.md`, `BUILD.bazel`, `verify_forks.sh`, and `verify_forks_test.sh` - accepted pin values and drift verifier behavior. [VERIFIED: local file read; local Bazel run/test]
- `packages/fork-inventories/prusaslicer.tsv`, `category-map.tsv`, `README.md`, `BUILD.bazel`, `verify_inventories.sh`, and `verify_inventories_test.sh` - selected checklist row, category mapping, and inventory verifier behavior. [VERIFIED: local file read; local Bazel run/test]
- `packages/fork-templates/README.md`, `manual-drift-refresh-protocol.md`, `fork-parity-checklist-template.md`, `BUILD.bazel`, `verify_templates.sh`, and `verify_templates_test.sh` - package/verifier pattern, required labels, and non-overclaiming phrase checks. [VERIFIED: local file read; local Bazel run/test]
- `docs/port/README.md`, `package-map.md`, `migration-guidance.md`, `parity-matrix.md`, and `contract-inventory.md` - docs routing, fixture namespace policy, no-fork-row boundary, and shared Rust flavor metadata boundary. [VERIFIED: local file read]
- Bright Builds canonical standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code-shape, verification, and testing standards. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

### Secondary (MEDIUM confidence)

- None. [VERIFIED: no secondary sources used]

### Tertiary (LOW confidence)

- None. [VERIFIED: no unverified web search findings used]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - stack is entirely repo-local and verified by existing package patterns plus local tool versions. [VERIFIED: packages/fork-templates/BUILD.bazel; local commands]
- Architecture: HIGH - package layout and verifier/test shapes follow existing fork packages. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel; packages/fork-templates/BUILD.bazel]
- Prusa data values: HIGH - values come directly from checked-in TSVs and existing verifiers passed. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv; local Bazel run/test]
- Future names: MEDIUM - package name and future parity target are recommended under discretion, not locked. [ASSUMED; VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md]
- Pitfalls: HIGH - pitfalls are explicitly stated in Phase 37 context, v1.10 requirements, and current port docs. [VERIFIED: .planning/REQUIREMENTS.md; docs/port/parity-matrix.md]

**Research date:** 2026-05-31. [VERIFIED: environment current date]\
**Valid until:** 2026-06-30 for repo-local package patterns; rerun `bazel run //packages/fork-vendors:verify` at implementation time because branch drift observations can change. [ASSUMED; VERIFIED: packages/fork-vendors/README.md]
