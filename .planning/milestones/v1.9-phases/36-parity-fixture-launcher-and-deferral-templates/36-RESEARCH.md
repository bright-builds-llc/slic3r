# Phase 36: Parity, Fixture, Launcher, and Deferral Templates - Research

**Researched:** 2026-05-27 [VERIFIED: current_date]
**Domain:** Maintainer-facing fork parity templates, Bazel shell verification, parity fixture namespace policy, and v1.9 deferral documentation [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: repo-local package patterns and locked Phase 36 context]

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

## Implementation Decisions

### Fork Parity Checklist Template

- **D-01:** Create a dedicated Phase 36 template package for fork parity
  templates instead of placing the checklist under `packages/fork-inventories`,
  `packages/parity`, or docs-only surfaces.
- **D-02:** The checklist template must be Markdown with a fixed required-field
  table covering inventory row ID, source pin, candidate Rust module, fixture
  need, evidence command, docs touched, license or security note, deferred
  scope, and reviewer signoff.
- **D-03:** Add a repo-owned verification target for the template package so
  required checklist fields and reserved wording are mechanically checked, while
  making clear that template verification does not prove any fork parity.

### Fork Fixture Namespace and Parity Status Vocabulary

- **D-04:** Reserve future fork fixtures inside the existing parity fixture
  package namespace, using a path shaped like
  `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/`.
- **D-05:** Do not add fork rows to `packages/parity/status.tsv` in v1.9.
  Future fork status rows are reserved for executable parity targets only.
- **D-06:** Future fork status tokens should be traceable to inventory evidence,
  such as `fork.<inventory_id>` or an equivalent inventory-derived stable slug,
  and should require a real `//packages/parity:*_parity` evidence command before
  reaching `verified`.

### v1.9 Deferral Documentation

- **D-07:** Add one central v1.9 fork-parity deferral block to
  `docs/port/README.md`, then link to it from the Phase 36 template docs and
  parity guidance instead of duplicating the full list everywhere.
- **D-08:** The deferral block must explicitly name full fork parity ports, GUI
  migration, fork-flavor release builds, signing, installers, release channels,
  nightly vendor sync, cloud or network device integrations, profile
  auto-update execution, and non-free plugin ingestion as out of scope for
  v1.9.

### Manual Drift-Refresh Protocol

- **D-09:** Keep the drift-refresh protocol manual for Phase 36. It should be a
  pre-milestone runbook that uses the existing vendor registry verification and
  records reviewer decisions without cloning, fetching, building, importing, or
  vendoring upstream fork source trees.
- **D-10:** The protocol must distinguish selected stable tags and peeled
  commits from drift-only branch head observations. Drift observations do not
  change accepted source pins by themselves.
- **D-11:** A future manual report target is allowed only if planning finds it
  necessary, but it must not become nightly sync automation or update vendor
  refs automatically.

### the agent's Discretion

- Exact file names inside the new template package.
- Whether the verifier is a shell script or another repo-local script type,
  provided it is rerunnable and wired through Bazel.
- Exact wording of examples in checklist and runbook docs, as long as the v1.9
  non-overclaiming boundary is explicit.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

- Full PrusaSlicer, Bambu Studio, or OrcaSlicer runtime parity.
- GUI migration and GUI feature parity.
- Fork-flavor release builds, signing, notarization, installers, AppImage, MSI,
  DMG, release channels, and cross-flavor GitHub Actions build matrices.
- Nightly vendor sync or automated source refresh.
- Cloud, network printer, credential, remote-device, profile auto-update, or
  non-free plugin ingestion.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PAR-01 | Maintainer can use a fork parity checklist template that requires inventory row ID, source pin, candidate Rust module, fixture need, evidence command, docs touched, license or security note, deferred scope, and reviewer signoff before a future fork feature can be marked verified. [VERIFIED: .planning/REQUIREMENTS.md] | Use `packages/fork-templates/fork-parity-checklist-template.md` and verify the required Markdown field labels through `bazel run //packages/fork-templates:verify`. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/fork-inventories/BUILD.bazel] |
| PAR-02 | Maintainer can inspect documented fork fixture namespace and parity-status conventions that reserve verified fork status for future executable parity evidence, not source pins or inventories. [VERIFIED: .planning/REQUIREMENTS.md] | Update `packages/parity-fixtures/README.md`, `packages/parity/README.md`, `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md`; do not edit `packages/parity/status.tsv`. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/parity/status.tsv; packages/parity/README.md] |
| PAR-03 | Maintainer can inspect v1.9 documentation that explicitly defers full fork parity ports, GUI migration, fork-flavor release builds, signing, installers, release channels, nightly vendor sync, cloud or network device integrations, profile auto-update execution, and non-free plugin ingestion. [VERIFIED: .planning/REQUIREMENTS.md] | Add the canonical deferral block to `docs/port/README.md` and link to it from package and parity docs instead of duplicating the complete list. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
| PAR-04 | Maintainer can run or follow a manual drift-refresh protocol that compares pinned vendor refs with current upstream heads before any later fork parity milestone begins. [VERIFIED: .planning/REQUIREMENTS.md] | Add `packages/fork-templates/manual-drift-refresh-protocol.md` that uses `bazel run //packages/fork-vendors:verify` as the current manual comparison entrypoint and records reviewer decisions without updating refs automatically. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
</phase_requirements>

## Summary

Phase 36 should add a new `packages/fork-templates` package containing Markdown-only maintainer templates plus a local shell verifier exposed as `bazel run //packages/fork-templates:verify`. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/fork-inventories/BUILD.bazel] The package should not add fork parity commands, fork runtime code, fork fixture files, fork status rows, upstream source imports, or vendor refresh automation. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv; packages/fork-vendors/README.md]

The implementation should mirror the existing package-local Bazel pattern used by `packages/fork-vendors` and `packages/fork-inventories`: `BUILD.bazel` exports package docs/templates, `sh_binary(name = "verify")` runs a rerunnable shell script, `sh_test` covers verifier failures, and `filegroup(name = "package_boundary")` makes the package discoverable. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel] The verifier should check fixed required field labels and boundary phrases in the templates; it should not parse upstream repositories or make network calls. [VERIFIED: packages/fork-inventories/verify_inventories.sh; packages/fork-vendors/verify_forks.sh; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

The documentation work should centralize v1.9 deferrals in `docs/port/README.md`, then link from `packages/fork-templates/README.md`, `packages/parity/README.md`, `packages/parity-fixtures/README.md`, `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`, `docs/port/package-map.md`, `packages/fork-vendors/README.md`, and `packages/fork-inventories/README.md` where those docs own discoverability or policy context. [VERIFIED: docs/port/README.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md; docs/port/package-map.md; packages/fork-vendors/README.md; packages/fork-inventories/README.md; packages/parity/README.md; packages/parity-fixtures/README.md]

**Primary recommendation:** implement `packages/fork-templates` as a documentation/template package with local-only Bazel verification, reserve future fork fixtures by documentation only, and keep all executable parity/status/vendor-sync behavior deferred. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo-local instruction entrypoint, and `AGENTS.bright-builds.md` plus `standards-overrides.md` must be read before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md]
- Managed Bright Builds text in `AGENTS.md` and the managed `AGENTS.bright-builds.md` file should not be edited directly. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Relevant Bright Builds standards require functional core / imperative shell separation, parsing at boundaries, making invalid states unrepresentable when practical, shallow control flow, small scripts with rerunnable behavior, repo-owned verification, and focused tests with Arrange/Act/Assert sections. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- For shell scripts, use `#!/usr/bin/env bash`, `set -euo pipefail`, early returns, functions, visible errors, and avoid swallowing failures. [VERIFIED: AGENTS.md; VERIFIED: packages/fork-vendors/verify_forks.sh; VERIFIED: packages/fork-inventories/verify_inventories.sh]
- Before declaring work complete, run relevant repo-native verification and review the diff for unintended side effects. [VERIFIED: AGENTS.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Phase summary YAML rules are repo-local, but this research artifact is not a `*-SUMMARY.md` file. [VERIFIED: AGENTS.md]
- No repo-local `.claude/skills/` or `.agents/skills/` directory exists in this checkout. [VERIFIED: `ls -la .claude`; VERIFIED: `ls -la .agents`]

## Standard Stack

### Core

| Component | Version | Purpose | Why Standard |
|-----------|---------|---------|--------------|
| Bazel / Bazelisk | Bazel `8.6.0`; `.bazelversion` pins `8.6.0` [VERIFIED: `bazel --version`; VERIFIED: .bazelversion] | Expose the package-local verifier through the existing monorepo build graph. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel] | Existing structured metadata packages already publish `sh_binary(name = "verify")` targets through Bazel. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel] |
| Bash shell verifier | GNU bash `3.2.57(1)-release` on this host [VERIFIED: `bash --version`] | Validate fixed Markdown template labels and boundary phrases without adding dependencies. [VERIFIED: packages/fork-inventories/verify_inventories.sh; AGENTS.md] | Existing package verifiers are shell scripts with `set -euo pipefail`, functions, explicit errors, and Bazel wiring. [VERIFIED: packages/fork-vendors/verify_forks.sh; packages/fork-inventories/verify_inventories.sh] |
| Markdown templates | No package version applies. [VERIFIED: Phase 36 D-02] | Store maintainer-facing checklist, launcher-shape, and drift-refresh runbook text. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] | PAR-01 requires a Markdown checklist template. [VERIFIED: .planning/REQUIREMENTS.md] |
| Existing vendor verifier | Repo target `//packages/fork-vendors:verify` [VERIFIED: packages/fork-vendors/BUILD.bazel] | Manual drift-refresh protocol entrypoint for tag and branch-head comparison. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh] | The script validates selected tags and peeled commits through `git ls-remote` and warns on branch drift without cloning or building upstream forks. [VERIFIED: packages/fork-vendors/verify_forks.sh] |

### Supporting

| Component | Version | Purpose | When to Use |
|-----------|---------|---------|-------------|
| Git | `2.53.0` [VERIFIED: `git --version`] | Used indirectly by `//packages/fork-vendors:verify` for `git ls-remote` checks. [VERIFIED: packages/fork-vendors/verify_forks.sh] | Only when following the manual drift-refresh protocol; not from `packages/fork-templates:verify`. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
| shfmt | `3.12.0` [VERIFIED: `shfmt --version`] | Optional formatter check for new shell verifier files. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; VERIFIED: local PATH] | Use `shfmt -d packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh` if those files are added. [VERIFIED: local PATH] |
| `git diff --check` | Git-provided command [VERIFIED: `git --version`] | Whitespace sanity check for Markdown, BUILD, and shell edits. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] | Run after implementing Phase 36 docs/templates. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `packages/fork-templates` package | Docs-only file under `docs/port/` | Rejected by locked D-01; it would reduce package-level discoverability and skip the required repo-owned verifier. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
| Local shell verifier | Extend `packages/fork-inventories/verify_inventories.sh` | Rejected by locked D-01 because fork parity templates are intentionally separate from inventory TSV contracts. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/fork-inventories/README.md] |
| Manual drift protocol | Nightly or automatic vendor sync | Rejected by PAR-03 and D-09 through D-11; v1.9 forbids nightly sync and automatic source refresh. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
| Existing parity status file | Separate fork status system | Rejected by D-04 through D-06; future fork statuses should use the existing parity vocabulary only after executable evidence exists. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/parity/README.md] |

**Installation:** no dependency installation is recommended for Phase 36. [VERIFIED: package patterns use repo-owned shell and Bazel only]

**Version verification:** no npm package versions apply; local tool versions were checked with `bazel --version`, `bash --version`, `git --version`, and `shfmt --version`. [VERIFIED: command outputs]

## Architecture Patterns

### Recommended Project Structure

```text
packages/fork-templates/
├── BUILD.bazel                         # Bazel verify/test/filegroup wiring [VERIFIED: packages/fork-inventories/BUILD.bazel]
├── README.md                           # Package entrypoint and links to central deferral block [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
├── fork-parity-checklist-template.md   # PAR-01 fixed-field checklist [VERIFIED: .planning/REQUIREMENTS.md]
├── fork-launcher-shape-template.md     # Future launcher-shape planning template with v1.9 deferral language [VERIFIED: Phase 36 goal in .planning/ROADMAP.md]
├── manual-drift-refresh-protocol.md    # PAR-04 runbook using existing vendor verification [VERIFIED: packages/fork-vendors/README.md]
├── verify_templates.sh                 # Local-only verifier for required labels and reserved wording [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
└── verify_templates_test.sh            # Focused shell tests for verifier failure modes [VERIFIED: packages/fork-inventories/verify_inventories_test.sh]
```

Add `//packages/fork-templates:package_boundary` to `packages/BUILD.bazel` through a `fork_templates` alias only if the implementation wants root package discoverability matching `parity_fixtures`. [VERIFIED: packages/BUILD.bazel] Do not add a root-level alias unless the planner wants a root-facing target; existing `fork-vendors` and `fork-inventories` do not currently have root aliases. [VERIFIED: packages/BUILD.bazel; packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel]

### Pattern 1: Package-Local Verify Target

**What:** Create a `sh_binary(name = "verify")` that receives every template path through Bazel `data` and `args`. [VERIFIED: packages/fork-inventories/BUILD.bazel]

**When to use:** Use this for fixed-file Markdown contract checks where the verifier should be rerunnable, local, and dependency-free. [VERIFIED: packages/fork-inventories/verify_inventories.sh; AGENTS.md]

**Example:**

```python
# Source: packages/fork-inventories/BUILD.bazel pattern
sh_binary(
    name = "verify",
    srcs = ["verify_templates.sh"],
    data = [
        "README.md",
        "fork-parity-checklist-template.md",
        "fork-launcher-shape-template.md",
        "manual-drift-refresh-protocol.md",
    ],
    args = [
        "$(location README.md)",
        "$(location fork-parity-checklist-template.md)",
        "$(location fork-launcher-shape-template.md)",
        "$(location manual-drift-refresh-protocol.md)",
    ],
)
```

### Pattern 2: Fixed Labels Instead of Markdown Parsing

**What:** Check exact field labels and required boundary phrases with small shell helpers such as `require_text file label pattern`. [VERIFIED: packages/fork-inventories/verify_inventories.sh]

**When to use:** Use exact text checks because PAR-01 and D-02 define fixed required field names rather than a general Markdown schema. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

**Checklist labels to require:** `Inventory row ID`, `Source pin`, `Candidate Rust module`, `Fixture need`, `Evidence command`, `Docs touched`, `License or security note`, `Deferred scope`, and `Reviewer signoff`. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

**Boundary phrases to require:** `template verification does not prove fork parity`, `source pins and inventories are planning inputs only`, `future executable parity evidence`, `do not add fork rows to packages/parity/status.tsv in v1.9`, and `drift observations do not change accepted source pins by themselves`. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/fork-vendors/README.md; packages/fork-inventories/README.md]

### Pattern 3: Manual Drift Refresh as a Runbook

**What:** The runbook should instruct maintainers to run `bazel run //packages/fork-vendors:verify`, inspect selected tag/peeled commit confirmations and branch drift warnings, and record a human decision before any later fork parity milestone begins. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh]

**When to use:** Use before future PrusaSlicer, Bambu Studio, or OrcaSlicer parity milestones, not during v1.9 template creation. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]

**Required distinction:** Selected stable tags and peeled commits are accepted source baselines, while observed default branch heads are drift-only observations. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/forks.tsv]

### Pattern 4: Documentation-Only Fixture Reservation

**What:** Reserve the future path shape `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/` in documentation without creating placeholder fixture directories in v1.9. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/parity-fixtures/README.md]

**When to use:** Use when documenting future fork parity work, because empty fixture placeholders would not provide executable evidence and may overstate support. [VERIFIED: packages/parity-fixtures/README.md; packages/parity/README.md]

**Recommended concrete vocabulary:** Use the existing inventory ID as the default path segment and status token suffix, for example `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/profile-load-basic/` and future status token `fork.prusaslicer.profile-schema`. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

### Anti-Patterns to Avoid

- **Adding fork rows to `packages/parity/status.tsv`:** v1.9 has no executable fork parity evidence, and D-05 explicitly forbids fork rows in this phase. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md; packages/parity/status.tsv]
- **Creating empty `packages/parity-fixtures/forks/` placeholders:** placeholder files are not fixture evidence and can make future support look more real than it is. [VERIFIED: packages/parity-fixtures/README.md; packages/parity/README.md]
- **Duplicating the full deferral list in many docs:** D-07 requires one central `docs/port/README.md` deferral block with links from other surfaces. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
- **Running clone/fetch/build/vendor workflows in drift refresh:** D-09 forbids cloning, fetching, building, importing, or vendoring upstream fork source trees in the Phase 36 protocol. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
- **Treating `packages/fork-templates:verify` as parity proof:** D-03 says template verification checks required wording only and does not prove fork parity. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

## Exact Docs to Update

| File | Required Update | Requirement |
|------|-----------------|-------------|
| `packages/fork-templates/README.md` | New package entrypoint that links checklist, launcher-shape template, drift protocol, central deferral block, and the verifier command while stating template verification does not prove fork parity. [VERIFIED: Phase 36 D-01 through D-03] | PAR-01, PAR-03, PAR-04 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/fork-templates/fork-parity-checklist-template.md` | New fixed-field checklist table with the nine required PAR-01 fields and reviewer signoff language. [VERIFIED: .planning/REQUIREMENTS.md] | PAR-01 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/fork-templates/fork-launcher-shape-template.md` | New future launcher-shape template that keeps fork launcher targets, release builds, signing, installers, and release channels deferred until executable fork parity exists. [VERIFIED: Phase 36 goal in .planning/ROADMAP.md; .planning/REQUIREMENTS.md] | PAR-03 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/fork-templates/manual-drift-refresh-protocol.md` | New manual runbook using `bazel run //packages/fork-vendors:verify`; it must distinguish selected tags/peeled commits from drift-only branch heads and require reviewer decisions. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh] | PAR-04 [VERIFIED: .planning/REQUIREMENTS.md] |
| `docs/port/README.md` | Add the central v1.9 fork-parity deferral block and a current Phase 36 template-package state section. [VERIFIED: Phase 36 D-07 and D-08; docs/port/README.md] | PAR-03 [VERIFIED: .planning/REQUIREMENTS.md] |
| `docs/port/migration-guidance.md` | Add a link to the central deferral block, reserve the fork fixture namespace in the fixture protocol, and clarify that fork status requires future executable parity evidence. [VERIFIED: docs/port/migration-guidance.md; Phase 36 D-04 through D-08] | PAR-02, PAR-03 [VERIFIED: .planning/REQUIREMENTS.md] |
| `docs/port/parity-matrix.md` | Add a fork-parity note under oracle/status interpretation saying there are no v1.9 fork rows and future `fork.<inventory_id>` tokens require `//packages/parity:*_parity` evidence before `verified`. [VERIFIED: docs/port/parity-matrix.md; packages/parity/status.tsv; Phase 36 D-05 and D-06] | PAR-02 [VERIFIED: .planning/REQUIREMENTS.md] |
| `docs/port/package-map.md` | Add `packages/fork-templates` to the package table and add a Phase 36 note tying it to templates, deferrals, and manual drift protocol. [VERIFIED: docs/port/package-map.md; Phase 36 D-01] | Discoverability for PAR-01 through PAR-04 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/parity-fixtures/README.md` | Add `Future Fork Fixture Namespace` with the reserved path shape and provenance expectations; do not add fixture files. [VERIFIED: packages/parity-fixtures/README.md; Phase 36 D-04] | PAR-02 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/parity/README.md` | Add `Future Fork Status Rows` policy: no v1.9 rows, future `fork.<inventory_id>` or stable inventory-derived tokens only with real parity targets. [VERIFIED: packages/parity/README.md; Phase 36 D-05 and D-06] | PAR-02 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/fork-vendors/README.md` | Link to the new manual drift-refresh protocol and clarify the existing verifier remains the manual comparison tool, not automatic source refresh. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/verify_forks.sh] | PAR-04 [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/fork-inventories/README.md` | Link future inventory rows to the fork parity checklist template and clarify that checklist completion is required before future verified fork parity. [VERIFIED: packages/fork-inventories/README.md; Phase 36 D-02] | PAR-01, PAR-02 [VERIFIED: .planning/REQUIREMENTS.md] |

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Vendor drift comparison | A new automatic sync or updater. [VERIFIED: Phase 36 D-09 through D-11] | Existing `bazel run //packages/fork-vendors:verify` plus a manual runbook. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-vendors/verify_forks.sh] | The existing verifier already checks selected tags/peeled commits and warns on default branch drift without cloning/building upstream forks. [VERIFIED: packages/fork-vendors/verify_forks.sh] |
| Fork parity visibility | A separate fork status file or reserved rows in `packages/parity/status.tsv`. [VERIFIED: Phase 36 D-05] | Existing `packages/parity` vocabulary, with future `fork.<inventory_id>` rows only after executable evidence exists. [VERIFIED: packages/parity/README.md; Phase 36 D-06] | Current status rows represent executable parity evidence or documented status, and `verified` is reserved for proof-backed scopes. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md] |
| Template validation | A Markdown parser or new runtime dependency. [VERIFIED: no package manager needed for existing shell verifiers] | Shell checks for exact required labels and phrases. [VERIFIED: packages/fork-inventories/verify_inventories.sh] | PAR-01 defines fixed fields, so exact text checks are sufficient and easier to maintain. [VERIFIED: .planning/REQUIREMENTS.md] |
| Fixture namespace reservation | Placeholder fixture trees or sample fork fixtures. [VERIFIED: Phase 36 D-04; D-05] | Documentation-only reservation in `packages/parity-fixtures/README.md`. [VERIFIED: packages/parity-fixtures/README.md] | Fixtures are meant to support verified parity workflows; placeholders would not provide executable evidence. [VERIFIED: packages/parity-fixtures/README.md; packages/parity/README.md] |
| Fork launcher scope | Fork-specific launcher targets, release packaging, or dispatch code. [VERIFIED: .planning/REQUIREMENTS.md] | A Markdown launcher-shape template that records future intent and deferrals. [VERIFIED: Phase 36 goal in .planning/ROADMAP.md] | v1.9 is intake and architecture only, and fork-flavor release builds remain out of scope. [VERIFIED: .planning/REQUIREMENTS.md] |

**Key insight:** Phase 36 is a vocabulary and process phase, so the only new executable code should be a local verifier for template completeness; all fork behavior remains future work. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]

## Common Pitfalls

### Pitfall 1: Template Verification Overclaims Parity

**What goes wrong:** A reviewer sees `bazel run //packages/fork-templates:verify` pass and interprets it as fork behavior evidence. [VERIFIED: Phase 36 D-03]

**Why it happens:** The repo uses Bazel parity commands for real verified slices, so a new Bazel target can look like evidence unless its docs say otherwise. [VERIFIED: packages/parity/README.md; packages/parity/status.tsv]

**How to avoid:** Require the phrase `template verification does not prove fork parity` in `packages/fork-templates/README.md` and the checklist template. [VERIFIED: Phase 36 D-03]

**Warning signs:** New docs use `verified fork parity`, `supported fork behavior`, or `fork runtime support` without naming an executable `//packages/parity:*_parity` command. [VERIFIED: packages/parity/README.md; Phase 36 D-06]

### Pitfall 2: Branch Drift Becomes a Source Pin

**What goes wrong:** A branch-head warning from `verify_forks.sh` is treated as an accepted source baseline. [VERIFIED: packages/fork-vendors/verify_forks.sh; packages/fork-vendors/README.md]

**Why it happens:** `forks.tsv` records observed default branch heads next to selected stable tags and peeled commits. [VERIFIED: packages/fork-vendors/forks.tsv]

**How to avoid:** The drift runbook must say that selected stable tags and peeled commits are accepted source baselines, while branch heads are drift-only observations. [VERIFIED: packages/fork-vendors/README.md; Phase 36 D-10]

**Warning signs:** A future checklist uses a source ref ending in the observed branch head instead of `<vendor_id>:<selected_stable_tag>@<peeled_commit_sha>`. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/verify_inventories.sh]

### Pitfall 3: Deferral Language Drifts Across Docs

**What goes wrong:** Different docs list slightly different v1.9 deferrals. [VERIFIED: Phase 36 D-07]

**Why it happens:** Existing docs already mention deferred release, GUI, fork, network, and plugin surfaces in multiple locations. [VERIFIED: docs/port/README.md; docs/port/migration-guidance.md; docs/port/package-map.md; .planning/REQUIREMENTS.md]

**How to avoid:** Put the complete Phase 36 deferral list once in `docs/port/README.md`, then link to it from template and parity docs. [VERIFIED: Phase 36 D-07; D-08]

**Warning signs:** A package README repeats only part of the required deferral list instead of linking to the central block. [VERIFIED: Phase 36 D-07]

### Pitfall 4: Fixture Namespace Reservation Becomes Fixture Evidence

**What goes wrong:** The implementation adds empty or example fork fixture directories under `packages/parity-fixtures/forks/`. [VERIFIED: Phase 36 D-04]

**Why it happens:** The required future path shape can be mistaken for a request to create files now. [VERIFIED: Phase 36 D-04; D-05]

**How to avoid:** Document the reserved path shape only and keep `packages/parity-fixtures` free of fork fixture files until a future executable parity command exists. [VERIFIED: packages/parity-fixtures/README.md; packages/parity/README.md]

**Warning signs:** `git status` shows new files under `packages/parity-fixtures/forks/` during Phase 36. [VERIFIED: Phase 36 D-05]

### Pitfall 5: The Drift Protocol Becomes Automation

**What goes wrong:** A new report target updates vendor refs or encourages nightly sync. [VERIFIED: Phase 36 D-11]

**Why it happens:** PAR-04 says maintainers can run or follow a drift-refresh protocol, but D-09 through D-11 constrain it to manual review. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

**How to avoid:** Ship a runbook only; if a future report target is ever planned, it must be read-only and must not update vendor refs automatically. [VERIFIED: Phase 36 D-11]

**Warning signs:** New code writes `forks.tsv`, schedules sync, clones upstream repos, fetches worktrees, or changes accepted source pins without a human review step. [VERIFIED: .planning/REQUIREMENTS.md; Phase 36 D-09 through D-11]

## Code Examples

Verified patterns from local sources:

### Build File Shape

```python
# Source: packages/fork-inventories/BUILD.bazel pattern
package(default_visibility = ["//visibility:public"])

exports_files([
    "README.md",
    "fork-parity-checklist-template.md",
    "fork-launcher-shape-template.md",
    "manual-drift-refresh-protocol.md",
])

sh_binary(
    name = "verify",
    srcs = ["verify_templates.sh"],
    data = [
        "README.md",
        "fork-parity-checklist-template.md",
        "fork-launcher-shape-template.md",
        "manual-drift-refresh-protocol.md",
    ],
    args = [
        "$(location README.md)",
        "$(location fork-parity-checklist-template.md)",
        "$(location fork-launcher-shape-template.md)",
        "$(location manual-drift-refresh-protocol.md)",
    ],
)

sh_test(
    name = "verify_templates_test",
    srcs = ["verify_templates_test.sh"],
    data = ["verify_templates.sh"],
)

filegroup(
    name = "package_boundary",
    srcs = [
        "README.md",
        "fork-parity-checklist-template.md",
        "fork-launcher-shape-template.md",
        "manual-drift-refresh-protocol.md",
        "verify_templates.sh",
        "verify_templates_test.sh",
    ],
)
```

### Shell Verifier Shape

```bash
# Source: packages/fork-inventories/verify_inventories.sh and packages/fork-vendors/verify_forks.sh
#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

require_file() {
	local file="$1"
	local label="$2"
	if [[ ! -f "${file}" ]]; then
		error "${label} file not found: ${file}"
	fi
}

require_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if ! grep -Fq "${pattern}" "${file}"; then
		error "${label}: missing required text: ${pattern}"
	fi
}
```

### Checklist Table Shape

```markdown
<!-- Source: PAR-01 and Phase 36 D-02 -->
| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `vendor.inventory-row` |
| Source pin | `vendor:tag@peeled_commit` |
| Candidate Rust module | `packages/slic3r-rust/...` or deferred |
| Fixture need | Required fixture namespace or `none-yet` |
| Evidence command | Future `//packages/parity:*_parity` command or deferred |
| Docs touched | Docs that must move with the future change |
| License or security note | License, network, credential, cloud, or plugin caution |
| Deferred scope | Explicitly deferred behavior |
| Reviewer signoff | Reviewer and date |
```

### Manual Drift Protocol Core

```markdown
<!-- Source: packages/fork-vendors/README.md and Phase 36 D-09 through D-11 -->
1. Run `bazel run //packages/fork-vendors:verify`.
2. Record selected stable tag and peeled commit confirmations.
3. Record branch drift warnings as observations only.
4. Do not change accepted source pins unless a future reviewed intake change updates `forks.tsv`.
5. Do not clone, fetch, build, import, or vendor upstream fork source trees.
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Fork source state as informal notes. [VERIFIED: Phase 32 roadmap context] | `packages/fork-vendors/forks.tsv` plus `//packages/fork-vendors:verify`. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/BUILD.bazel] | Phase 32. [VERIFIED: .planning/ROADMAP.md] | Drift protocol should reuse the vendor verifier instead of creating a second source registry. [VERIFIED: packages/fork-vendors/README.md] |
| Fork features without source-pinned planning rows. [VERIFIED: Phase 33 roadmap context] | `packages/fork-inventories` records source-pinned inventory rows and category maps. [VERIFIED: packages/fork-inventories/README.md] | Phase 33. [VERIFIED: .planning/ROADMAP.md] | PAR-01 checklist rows should trace back to `inventory_id` and source refs from the inventories. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-inventories/README.md] |
| Base parity surfaces as mixed docs. [VERIFIED: docs/port/README.md] | `packages/parity/status.tsv` plus evidence commands and fixture packages publish verified base slices. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md] | Phases 7 through 30. [VERIFIED: docs/port/package-map.md] | Fork status rows must wait for future executable evidence, not v1.9 templates. [VERIFIED: Phase 36 D-05; D-06] |
| Fork behavior as possible future architecture. [VERIFIED: .planning/ROADMAP.md] | `slic3r_contracts` and `slic3r_flavors` model fork/flavor metadata without side effects. [VERIFIED: docs/port/README.md; docs/port/package-map.md] | Phases 34 and 35. [VERIFIED: .planning/ROADMAP.md; .planning/STATE.md] | Phase 36 templates should reference future candidate modules without adding runtime fork dispatch or vendor-specific Rust workspaces. [VERIFIED: .planning/REQUIREMENTS.md; .planning/STATE.md] |

**Deprecated/outdated:** Adding fork parity status based on source pins or inventory rows is not valid for v1.9; verified fork status is reserved for future executable parity evidence. [VERIFIED: .planning/REQUIREMENTS.md; Phase 36 D-05]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The STRIDE labels in the Security Domain threat table are review-oriented classifications rather than repo-verified facts. [ASSUMED] | Security Domain | Low; mitigations still come from verified Phase 36 boundaries. |
| A2 | The research validity window of 30 days is an estimated planning freshness window. [ASSUMED] | Metadata | Low; stale planning docs could make the research need refresh sooner. |

## Open Questions

1. **None blocking planning.** The user already locked the package location, checklist format, fixture namespace, no-status-row rule, deferral location, and manual drift-refresh boundary. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel / Bazelisk | `//packages/fork-templates:verify` and `sh_test` targets. [VERIFIED: package BUILD patterns] | yes [VERIFIED: `command -v bazel`; VERIFIED: `command -v bazelisk`] | Bazel `8.6.0` [VERIFIED: `bazel --version`; VERIFIED: .bazelversion] | None needed. [VERIFIED: local tool availability] |
| Bash | `verify_templates.sh` and `verify_templates_test.sh`. [VERIFIED: shell verifier patterns] | yes [VERIFIED: `bash --version`] | GNU bash `3.2.57(1)-release` [VERIFIED: `bash --version`] | None needed. [VERIFIED: local tool availability] |
| Git | Manual drift protocol via `//packages/fork-vendors:verify`. [VERIFIED: packages/fork-vendors/verify_forks.sh] | yes [VERIFIED: `git --version`] | `2.53.0` [VERIFIED: `git --version`] | If network is unavailable later, record drift refresh as blocked rather than accepting stale branch observations. [VERIFIED: packages/fork-vendors/verify_forks.sh behavior depends on `git ls-remote`] |
| shfmt | Optional shell formatter check. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] | yes [VERIFIED: `command -v shfmt`] | `3.12.0` [VERIFIED: `shfmt --version`] | Skip formatter check only if unavailable; here it is available. [VERIFIED: local PATH] |

**Missing dependencies with no fallback:** none found for the recommended implementation. [VERIFIED: environment probes]

**Missing dependencies with fallback:** none found. [VERIFIED: environment probes]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no [VERIFIED: Phase 36 creates templates/docs/verifier only] | No auth surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V3 Session Management | no [VERIFIED: Phase 36 creates templates/docs/verifier only] | No session surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | no [VERIFIED: Phase 36 creates templates/docs/verifier only] | No access-control surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | yes [VERIFIED: shell verifier validates template files] | Validate required files, exact labels, and required boundary phrases; fail closed on missing inputs. [VERIFIED: packages/fork-inventories/verify_inventories.sh; packages/fork-vendors/verify_forks.sh] |
| V6 Cryptography | no [VERIFIED: Phase 36 does not add signing, credentials, or crypto behavior] | Keep signing, credentials, cloud/network integrations, and non-free plugin ingestion deferred. [VERIFIED: .planning/REQUIREMENTS.md] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Overclaiming support through misleading status or templates. [VERIFIED: Phase 36 D-03; D-05] | Spoofing / Repudiation [ASSUMED: STRIDE mapping] | Require explicit non-overclaiming wording and avoid fork status rows without executable evidence. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |
| Shell verifier path confusion under Bazel. [VERIFIED: existing sh_tests account for `TEST_SRCDIR` and input args] | Tampering [ASSUMED: STRIDE mapping] | Pass files through Bazel `data`/`args`, require files to exist, and avoid implicit repo-root writes. [VERIFIED: packages/fork-inventories/BUILD.bazel; packages/fork-inventories/verify_inventories_test.sh] |
| Accidental network or upstream source ingestion. [VERIFIED: Phase 36 D-09; .planning/REQUIREMENTS.md] | Information Disclosure / Tampering [ASSUMED: STRIDE mapping] | Keep `packages/fork-templates:verify` local-only; only the manual drift protocol references existing `git ls-remote` vendor verification. [VERIFIED: packages/fork-vendors/verify_forks.sh; .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md] |

## Verification Recommendations

Run verification proportional to the likely Phase 36 changed paths. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]

| Changed Paths | Command | Why |
|---------------|---------|-----|
| `packages/fork-templates/**` | `bazel run //packages/fork-templates:verify` [VERIFIED: recommended package target pattern] | Validates required template fields and boundary wording. [VERIFIED: Phase 36 D-02 and D-03] |
| `packages/fork-templates/verify_templates*.sh` | `bazel test //packages/fork-templates:verify_templates_test` [VERIFIED: package sh_test pattern] | Exercises missing-field and missing-boundary-wording failure modes. [VERIFIED: packages/fork-inventories/verify_inventories_test.sh] |
| `packages/fork-templates/verify_templates*.sh` | `shfmt -d packages/fork-templates/verify_templates.sh packages/fork-templates/verify_templates_test.sh` [VERIFIED: local shfmt availability] | Checks shell formatting without writing unrelated files. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] |
| `packages/fork-vendors/README.md` or drift protocol links | `bazel run //packages/fork-vendors:verify` [VERIFIED: packages/fork-vendors/BUILD.bazel] | Confirms the existing manual drift comparison entrypoint still runs; this command may warn on branch drift. [VERIFIED: packages/fork-vendors/verify_forks.sh] |
| `packages/fork-inventories/README.md` or inventory traceability docs | `bazel run //packages/fork-inventories:verify` [VERIFIED: packages/fork-inventories/BUILD.bazel] | Confirms source refs and parity dependency vocabulary remain valid. [VERIFIED: packages/fork-inventories/verify_inventories.sh] |
| `docs/port/**`, package READMEs, BUILD files | `git diff --check` [VERIFIED: Git availability] | Catches whitespace errors across Markdown, BUILD, and shell edits. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] |
| `packages/parity/status.tsv` | Do not edit for Phase 36; if changed accidentally, revert the Phase 36 change before verification. [VERIFIED: Phase 36 D-05] | v1.9 must not add fork status rows. [VERIFIED: .planning/REQUIREMENTS.md] |

Do not run broad Rust workspace checks unless the implementation touches Rust files, because Phase 36 should be templates/docs/shell/Bazel only. [VERIFIED: .planning/REQUIREMENTS.md; docs/port/package-map.md]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md` - locked Phase 36 decisions, discretion, and deferred scope. [VERIFIED: local file]
- `.planning/REQUIREMENTS.md` - PAR-01 through PAR-04 and v1.9 out-of-scope boundaries. [VERIFIED: local file]
- `.planning/ROADMAP.md` - Phase 36 goal, dependency, success criteria, and milestone boundaries. [VERIFIED: local file]
- `.planning/STATE.md` - current phase state and prior Phase 35 metadata-only decisions. [VERIFIED: local file]
- `packages/fork-vendors/README.md`, `forks.tsv`, and `verify_forks.sh` - accepted source pin and drift-only branch-head behavior. [VERIFIED: local files]
- `packages/fork-inventories/README.md`, inventory TSVs, `category-map.tsv`, and `verify_inventories.sh` - inventory ID/source-ref/parity-dependency contracts. [VERIFIED: local files]
- `packages/parity/README.md` and `packages/parity/status.tsv` - current parity evidence and conservative status vocabulary. [VERIFIED: local files]
- `packages/parity-fixtures/README.md` and package fixture directories - current fixture provenance and namespace style. [VERIFIED: local files]
- `docs/port/README.md`, `migration-guidance.md`, `parity-matrix.md`, and `package-map.md` - docs discoverability and current fork intake state. [VERIFIED: local files]
- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: local files]

### Secondary (MEDIUM confidence)

- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` for architecture, code shape, verification, and testing. [CITED: AGENTS.bright-builds.md; CITED: raw.githubusercontent.com Bright Builds standards URLs]

### Tertiary (LOW confidence)

- None. [VERIFIED: no unverified web search findings used]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - existing packages use Bazel `sh_binary`/`sh_test` shell verifiers and local tool versions were checked. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/fork-inventories/BUILD.bazel; command outputs]
- Architecture: HIGH - Phase 36 locked the dedicated package, Markdown checklist, fixture namespace, no-status-row rule, central deferral block, and manual drift protocol. [VERIFIED: .planning/phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md]
- Pitfalls: HIGH - pitfalls come directly from the v1.9 out-of-scope list and existing package docs that separate source pins/inventories from executable parity. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-vendors/README.md; packages/fork-inventories/README.md; packages/parity/README.md]

**Research date:** 2026-05-27 [VERIFIED: current_date]
**Valid until:** 2026-06-26, unless Phase 36 context or the v1.9 roadmap changes earlier. [VERIFIED: stable repo-local planning docs; ASSUMED risk window for planning freshness]
