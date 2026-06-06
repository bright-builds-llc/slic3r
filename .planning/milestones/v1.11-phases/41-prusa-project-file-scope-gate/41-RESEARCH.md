# Phase 41: Prusa Project-File Scope Gate - Research

**Researched:** 2026-06-03\
**Domain:** PrusaSlicer project-file evidence scoping, fork parity gate documentation, Bazel/Bash verification\
**Confidence:** HIGH

<user_constraints>

## User Constraints (from CONTEXT.md)

The following locked decisions, discretion areas, and deferred ideas are copied from `.planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md`; they constrain planning for this phase. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Scope Package Contents

- **D-01:** Create a maintainer-readable `prusaslicer.project-file` scope record
  that is specific enough for later phases to implement without re-deciding the
  evidence contract.
- **D-02:** Treat the required record fields from PSEL-01 as mandatory:
  accepted source identity, inventory row ID, fixture source decision,
  expected-artifact contract, candidate Rust boundary, planned evidence command,
  docs touched, license or security note, deferred scope, and reviewer signoff.
- **D-03:** Keep the scope package reviewable as checked-in documentation or
  data, not as generated prose that downstream phases must infer.

### Source Identity and Inventory

- **D-04:** Start from the existing `packages/fork-inventories/prusaslicer.tsv`
  row for `prusaslicer.project-file`.
- **D-05:** Preserve the current accepted source pin
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` unless
  the plan finds a concrete reason that a reviewed sample source needs a
  narrower or different source identity.
- **D-06:** Anchor the source path decision on
  `src/libslic3r/Format/3mf.cpp` and keep it distinct from full 3MF
  import/export or generated-output parity.

### Fixture and Expected-Artifact Contract

- **D-07:** Phase 41 should choose the fixture source strategy and expected
  artifact shape only at the contract level; actual checked-in fixtures belong
  in Phase 42.
- **D-08:** The selected contract should be easy to verify fail-closed in Phase
  42, with provenance, update rules, and expected artifacts tracing directly
  back to the Phase 41 scope record.
- **D-09:** Prefer the same evidence discipline used by the v1.10 Prusa
  profile-schema path: source-pinned fixture inputs, an explicit expected
  artifact, a verifier, typed Rust metadata, a public Bazel parity command, and
  exact status/docs wording.

### Downstream Handoff

- **D-10:** Name the candidate Rust boundary and planned evidence command before
  implementation, but do not create the Rust parser or command in this phase.
- **D-11:** Downstream Phases 42-44 must be able to trace fixture paths, Rust
  metadata, status token, and evidence command back to this scope record.
- **D-12:** The planned status token should remain narrow and evidence-backed,
  matching the existing `fork.prusaslicer.profile-schema` precedent without
  claiming full PrusaSlicer runtime behavior.

### Deferred Scope and Non-Overclaiming

- **D-13:** Explicitly defer full PrusaSlicer runtime support, GUI project
  behavior, full 3MF import/export, generated-output parity, STEP import,
  support generation, arc fitting, wall seam behavior, network/device
  integration, profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, and sync automation.
- **D-14:** Docs touched in this phase should clarify the evidence contract and
  deferred scope, not imply executable parity before Phases 42-44 are complete.

### the agent's Discretion

- The agent may decide the exact file name and tabular or Markdown shape for
  the scope record, provided the mandatory fields are inspectable and easy to
  verify in later phases.
- The agent may decide whether to add a lightweight verifier for the Phase 41
  scope record if it reduces risk and stays within the scope-gate boundary.
- The agent may choose the most concise docs updates needed to make the scope
  package discoverable without rewriting unrelated milestone history.

### Deferred Ideas (OUT OF SCOPE)

- Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
  generated-output parity, STEP import, support generation, arc fitting, wall
  seam behavior, network/device integration, profile auto-update execution,
  fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, and
  sync automation all remain outside Phase 41.

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PSEL-01 | Maintainer can inspect a reviewed Prusa project-file scope record for `prusaslicer.project-file`, including accepted source identity, inventory row ID, fixture source decision, expected-artifact contract, candidate Rust boundary, planned evidence command, docs touched, license or security note, deferred scope, and reviewer signoff. | Use a checked-in scope package with an exact Markdown table plus a Bazel/Bash verifier modeled on Phase 37. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-baseline/profile-schema-checklist.md; packages/prusa-baseline/verify_prusa_baseline.sh] |
| PSEL-02 | Maintainer can distinguish the narrow v1.11 Prusa project-file evidence contract from full 3MF import/export, full PrusaSlicer runtime support, GUI project behavior, generated-output parity, STEP import, support generation, arc fitting, wall seam behavior, network/device integration, profile auto-update execution, fork release builds, and sync automation. | Require exact non-overclaiming wording in the scope record and docs, and scope the expected artifact to project-file archive/metadata summary only. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |

</phase_requirements>

## Summary

Phase 41 should create a new checked-in scope gate package for `prusaslicer.project-file`, not fixtures, parser code, status rows, or executable parity commands. [VERIFIED: .planning/ROADMAP.md; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md] The strongest local precedent is Phase 37, where `packages/prusa-baseline` exposed a maintainer-readable record plus `//packages/prusa-baseline:verify` and verifier tests before later phases added fixtures, Rust code, parity commands, and status publication. [VERIFIED: packages/prusa-baseline/README.md; packages/prusa-baseline/BUILD.bazel; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md]

The selected source identity should stay `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, with source path `src/libslic3r/Format/3mf.cpp` and companion API evidence from `src/libslic3r/Format/3mf.hpp`. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.hpp] Upstream `3mf.cpp` has project detection, load, and store boundaries, but Phase 41 should document only the narrow evidence contract and planned handoff, not implement those boundaries in Rust. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp; VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

**Primary recommendation:** Create `packages/prusa-project-file-scope/` with `project-file-scope.md`, `README.md`, `verify_prusa_project_file_scope.sh`, verifier tests, and `BUILD.bazel`; make Phase 42 consume the source-pinned upstream `tests/data/seam_test_object.3mf` project-shaped fixture only for archive/project-marker summary evidence, while explicitly excluding seam, arc-fitting, geometry, generated-output, GUI, and runtime claims. [VERIFIED: upstream tree API for commit 9a583bd438b195856f3bcf7ea99b69ba4003a961; VERIFIED: packages/prusa-baseline/BUILD.bazel; VERIFIED: .planning/REQUIREMENTS.md]

## Project Constraints (from AGENTS.md and Bright Builds)

- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned standards pages before planning or implementation work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Do not edit the managed Bright Builds block in `AGENTS.md`, the managed `AGENTS.bright-builds.md`, or the managed audit trail directly. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; bright-builds-rules.audit.md]
- Keep repo-local workflow facts in `AGENTS.md` and deliberate standards deviations in `standards-overrides.md`; `standards-overrides.md` currently contains no real active override beyond placeholder text. [VERIFIED: AGENTS.bright-builds.md; standards-overrides.md]
- Prefer functional-core/imperative-shell structure, parse raw inputs into domain values at boundaries, and make illegal states unrepresentable when the language makes that practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Prefer early returns, language-native guard constructs, `maybe`/`maybe_` naming for optional values, checked-in scripts instead of substantial foreign code in strings, and repo-owned verification entrypoints. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Unit tests for pure/business logic must be focused on one concern and delineate Arrange, Act, and Assert unless the structure is trivial. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- For Rust work, prefer `foo.rs` plus `foo/` over `foo/mod.rs`, encode invariants with newtypes/enums, keep adapters thin around a pure core, and use repo-native Rust verification. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- For `.planning/phases/*/*-SUMMARY.md`, preserve `requirements-completed` frontmatter and avoid `mdformat`; Phase 41 research is not a summary file, but planners must preserve this rule for later summaries. [VERIFIED: AGENTS.md]
- No project-local `.claude/skills/` or `.agents/skills/` directories exist in this checkout. [VERIFIED: filesystem probe]

## Standard Stack

### Core

| Tool or Surface | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Checked-in Markdown scope record | N/A | Stores the exact Phase 41 maintainer contract fields for `prusaslicer.project-file`. | Phase 37 used checked-in Markdown records for the Prusa profile-schema gate before fixture and parity implementation. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |
| Bazel/Bazelisk | 8.6.0 | Exposes a repo-native `//packages/prusa-project-file-scope:verify` command and verifier test target. | Existing packages expose verification through `sh_binary` and `sh_test` targets. [VERIFIED: .bazelversion; packages/prusa-baseline/BUILD.bazel; packages/fork-inventories/BUILD.bazel] |
| Bash verifier | GNU bash 3.2.57 on this host | Performs exact row/text checks without adding dependencies. | Phase 37, Phase 38, and Phase 40 use Bash comparators/verifiers for Markdown, TSV, fixture, and status boundaries. [VERIFIED: local command probe; packages/prusa-baseline/verify_prusa_baseline.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity/compare_prusaslicer_profile_schema.sh] |
| `awk`, `grep -F`, `shasum` | awk 20200816, shasum 6.02 on this host | Validates table rows, fixed text, counts, and future fixture hashes. | Existing verifiers use exact text, awk row validation, byte counts, and SHA-256 checks. [VERIFIED: local command probe; packages/prusa-baseline/verify_prusa_baseline.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |

### Supporting

| Tool or Surface | Version | Purpose | When to Use |
|-----------------|---------|---------|-------------|
| `bsdtar` or `unzip` | bsdtar 3.5.3, unzip 6.00 on this host | Inspects `.3mf` ZIP archive members for fixture-source research and later Phase 42 verification. | Use in Phase 42 if the verifier checks project-file archive member lists; Phase 41 can document the contract without checking in fixture bytes. [VERIFIED: local command probe; VERIFIED: upstream fixture archive inspection] |
| `mdformat --check` | 1.0.0 on this host | Verifies Markdown formatting for non-summary docs. | Use for touched docs when local guidance does not exclude the file type. [VERIFIED: local command probe; AGENTS.md] |
| `shfmt -d` | 3.12.0 on this host | Verifies Bash formatting without rewriting unrelated files. | Use for new verifier scripts and tests. [VERIFIED: local command probe; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| New `packages/prusa-project-file-scope` package | Add `project-file-scope.md` under `packages/prusa-baseline` | Reusing `packages/prusa-baseline` reduces package count, but its documented role is the Phase 37/v1.10 profile-schema baseline and checklist gate; a new package keeps v1.11 project-file scope ownership clear. [VERIFIED: docs/port/package-map.md; packages/prusa-baseline/README.md] |
| Exact Bash verifier | Markdown-only review | Markdown-only review is inspectable, but Phase 37 already proved fail-closed shell checks catch missing labels, missing signoff text, and overclaiming wording before downstream phases consume the gate. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline_test.sh; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |
| Source-pinned upstream `tests/data/seam_test_object.3mf` as primary Phase 42 fixture | Tiny upstream `tests/data/test_3mf/Geräte/Büchse.3mf` | `Büchse.3mf` is small and used by upstream `load_3mf` tests, but archive inspection found no `Metadata/Slic3r_PE.config` and no PrusaSlicer application stamp, so it is not the best primary project-file fixture. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_3mf.cpp; VERIFIED: upstream fixture archive inspection] |

**Installation:**

```bash
# No new package installation is required for Phase 41. [VERIFIED: packages/prusa-baseline/BUILD.bazel; local command probe]
```

**Version verification:**

```bash
cat .bazelversion
bazelisk --version
bash --version | head -1
awk --version 2>&1 | head -1
shasum --version 2>&1 | head -1
bsdtar --version
mdformat --version
shfmt --version
```

The current host reports Bazel/Bazelisk 8.6.0, Bash 3.2.57, awk 20200816, shasum 6.02, bsdtar 3.5.3, mdformat 1.0.0, and shfmt 3.12.0. [VERIFIED: local command probe]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
└── prusa-project-file-scope/
    ├── BUILD.bazel
    ├── README.md
    ├── project-file-scope.md
    ├── verify_prusa_project_file_scope.sh
    └── verify_prusa_project_file_scope_test.sh
docs/port/
├── README.md
└── package-map.md
```

This structure mirrors the Phase 37 gate package shape while keeping the v1.11 project-file contract separate from the v1.10 profile-schema baseline package. [VERIFIED: packages/prusa-baseline/BUILD.bazel; packages/prusa-baseline/README.md; docs/port/package-map.md]

### Pattern 1: Scope Gate Package Before Implementation

**What:** Store `prusaslicer.project-file` scope decisions in one maintainer-readable Markdown table with mandatory PSEL-01 fields, source row details, downstream handoff fields, and explicit deferred scope. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-baseline/profile-schema-checklist.md]

**When to use:** Use this for Phase 41 because the roadmap requires the contract to be locked before fixtures, Rust parser work, or status claims. [VERIFIED: .planning/ROADMAP.md; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

**Recommended record fields:** `Inventory row ID`, `Accepted source identity`, `Source path`, `Fixture source decision`, `Expected-artifact contract`, `Candidate Rust boundary`, `Planned evidence command`, `Planned status token`, `Docs touched`, `License or security note`, `Deferred scope`, and `Reviewer signoff`. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

**Example:**

```markdown
| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.project-file` |
| Accepted source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Fixture source decision | Phase 42 source-pinned fixture from upstream `tests/data/seam_test_object.3mf`; summarize project markers only. |
| Expected-artifact contract | `expected-project-summary.tsv` with source, fixture, archive members, Prusa project markers, and explicit deferred semantics. |
| Candidate Rust boundary | `slic3r_flavors::prusa_project_file` in Phase 43; no Prusa-only workspace. |
| Planned evidence command | `bazel run //packages/parity:prusaslicer_project_file_parity` in Phase 44; not created in Phase 41. |
| Planned status token | `fork.prusaslicer.project-file` in Phase 44 after executable evidence passes. |
```

The example is an implementation-ready inference from the Phase 37 checklist and Phase 40 status token pattern, not an already existing file. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md; packages/parity/status.tsv; INFERENCE]

### Pattern 2: Fail-Closed Verifier For Review Records

**What:** Add a package-local Bash verifier that checks exact source pins, required table labels, source row values, future-only wording, non-overclaiming exclusions, and reviewer signoff text without executing the planned evidence command. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh]

**When to use:** Use in Phase 41 because the agent's discretion permits a lightweight verifier and Phase 37 showed this reduces downstream ambiguity. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md]

**Example:**

```bash
require_section_table_row "${scope_file}" "project-file-scope.md" \
  "## Scope Record" "Inventory row ID" "\`prusaslicer.project-file\`"
require_section_table_row "${scope_file}" "project-file-scope.md" \
  "## Scope Record" "Planned evidence command" \
  "Planned Phase 44 command \`bazel run //packages/parity:prusaslicer_project_file_parity\`; not created in Phase 41."
```

This verifier style is adapted from the existing Phase 37 `require_section_table_row` pattern. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh]

### Pattern 3: Source-Pinned Fixture Contract With Narrow Summary Artifact

**What:** Define the Phase 42 fixture source and expected artifact shape now, but do not check in fixture bytes or summary artifacts in Phase 41. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

**Recommended primary fixture source:** Use upstream `tests/data/seam_test_object.3mf` from the accepted Prusa commit as the primary project-shaped fixture source, with source URL `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/data/seam_test_object.3mf`, size `2514963` bytes, SHA-256 `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`, archive members `[Content_Types].xml`, `Metadata/thumbnail.png`, `_rels/.rels`, `3D/3dmodel.model`, `Metadata/Slic3r_PE.config`, and `Metadata/Slic3r_PE_model.config`. [VERIFIED: upstream GitHub tree API; VERIFIED: local curl/shasum/bsdtar probe]

**Why this fixture:** It carries Prusa project markers through `Metadata/Slic3r_PE.config`, `Metadata/Slic3r_PE_model.config`, and model metadata containing `Application` with `PrusaSlicer-2.8.0-alpha3`; those markers align with the upstream `is_project_3mf` logic that treats config presence or PrusaSlicer application stamp as project evidence. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp; VERIFIED: local bsdtar extraction]

**Important caveat:** The fixture name includes `seam`, and its config text includes settings such as `arc_fitting`, so Phase 41 and Phase 42 wording must say those values are inert fixture content and do not create wall seam, arc-fitting, generated-output, geometry, or GUI behavior claims. [VERIFIED: local bsdtar extraction of Metadata/Slic3r_PE.config; .planning/REQUIREMENTS.md]

**Non-primary contrast sample:** Upstream `tests/data/test_3mf/Geräte/Büchse.3mf` is used by Prusa's own `load_3mf` test and is 1416 bytes with SHA-256 `de20508dff06f8faf8ca992c00238d4affc916ba4b812e8ff9ec1571fec533a1`, but archive inspection found only `3D/`, `3D/3dmodel.model`, `[Content_Types].xml`, `_rels/`, and `_rels/.rels`, so it must stay out of Phase 41 and out of the primary Phase 42 contract; treat it only as an optional future contrast fixture if a later phase explicitly needs negative project-marker coverage. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_3mf.cpp; VERIFIED: local curl/shasum/bsdtar probe; VERIFIED: 2026-06-03 revision resolution]

**Expected artifact shape:** Phase 42 should create a checked-in `expected-project-summary.tsv` that records source identity, fixture identity, fixture hash, archive member list, project marker summary, status token, and exclusions, while avoiding mesh geometry, slicing output, GUI state, seam behavior, arc fitting, STEP, support generation, networking, credentials, and profile auto-update execution. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv; .planning/REQUIREMENTS.md; INFERENCE]

### Anti-Patterns to Avoid

- **Adding fixtures in Phase 41:** Actual fixture files belong to Phase 42, and Phase 41 should only choose the source and expected-artifact contract. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]
- **Publishing `packages/parity/status.tsv` in Phase 41:** Status publication belongs to Phase 44 after executable evidence exists. [VERIFIED: .planning/ROADMAP.md; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]
- **Creating a Rust parser in Phase 41:** Phase 43 owns Rust project-file parsing or summary logic. [VERIFIED: .planning/ROADMAP.md]
- **Executing planned command text in the verifier:** Phase 37 verifier precedent treats planned evidence command text as display-only and checks text rather than executing it. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md]
- **Broad 3MF or runtime claims:** The milestone explicitly excludes full 3MF import/export, runtime support, GUI behavior, generated-output parity, STEP, support generation, arc fitting, seam behavior, network/device integration, profile auto-update execution, fork release builds, and sync automation. [VERIFIED: .planning/REQUIREMENTS.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Source and scope review gate | Ad hoc prose spread across docs | One package-local scope record plus `//packages/prusa-project-file-scope:verify` | Phase 37 proves a local record plus verifier gives maintainers a clear gate before later implementation. [VERIFIED: packages/prusa-baseline/README.md; packages/prusa-baseline/BUILD.bazel] |
| 3MF parser implementation in Phase 41 | Rust ZIP/XML parser, C++ port, or generic 3MF engine | Contract-only expected summary fields for Phase 42-44 | Phase 41 scope excludes parser, fixture, parity, and status implementation. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md] |
| Upstream source intake | Git submodule, subtree, vendored fork source, Bzlmod external repo, or C++ build integration | Accepted source pin plus raw source URLs and future fixture provenance | v1.11 explicitly excludes upstream source imports and upstream PrusaSlicer C++ builds. [VERIFIED: .planning/REQUIREMENTS.md] |
| Reviewer signoff | Auto-generated "approved" text without maintainer identity and UTC date | Explicit Phase 41 reviewer field `Peter Ryszkiewicz, 2026-06-03 UTC` | Phase 37 used `Peter Ryszkiewicz, YYYY-MM-DD UTC` reviewer fields, and this yolo workflow was invoked by Peter in this repo. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md; VERIFIED: 2026-06-03 revision resolution] |
| Security-sensitive config/network surfaces | Fixture or docs that exercise cloud, credentials, plugins, network devices, or profile auto-update | License/security note plus deferred-scope text | Fork vendor docs keep network, credential, plugin, and profile auto-update cautions out of runtime support. [VERIFIED: packages/fork-vendors/README.md; .planning/REQUIREMENTS.md] |

**Key insight:** The scope package is a decision and traceability artifact, so custom parser logic, runtime behavior, upstream imports, and broad status publication are worse than a narrow checked record with fail-closed verification. [VERIFIED: .planning/ROADMAP.md; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md; INFERENCE]

## Common Pitfalls

### Pitfall 1: Confusing Project-File Scope With Full 3MF Import/Export

**What goes wrong:** A plan starts implementing generic archive parsing, geometry handling, save/load roundtrips, or full 3MF parity. [VERIFIED: .planning/REQUIREMENTS.md; upstream 3mf.cpp API inspection]

**Why it happens:** Upstream `3mf.cpp` contains project detection, import, and export logic in the same source file. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp]

**How to avoid:** The scope record should name only archive/project-marker summary evidence and explicitly defer full 3MF import/export. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md]

**Warning signs:** New fixtures, parser files, parity targets, status rows, or Rust crate dependencies appear in the Phase 41 diff. [VERIFIED: .planning/ROADMAP.md; INFERENCE]

### Pitfall 2: Selecting The Tiny Upstream 3MF As The Primary Project Fixture

**What goes wrong:** The plan picks `tests/data/test_3mf/Geräte/Büchse.3mf` because it is small, but the archive lacks Prusa project markers found by `is_project_3mf`. [VERIFIED: local bsdtar extraction; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp]

**Why it happens:** The upstream test uses that file to prove `load_3mf` can read a path with umlauts, not to prove Prusa project-file metadata. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_3mf.cpp]

**How to avoid:** Use it only as an optional future negative/non-project contrast, and make `seam_test_object.3mf` the primary source-pinned project fixture contract. [VERIFIED: local upstream fixture inspection; INFERENCE]

**Warning signs:** Expected artifact rows omit `Metadata/Slic3r_PE.config`, `Metadata/Slic3r_PE_model.config`, and PrusaSlicer application metadata. [VERIFIED: local bsdtar extraction; upstream 3mf.cpp inspection]

### Pitfall 3: Letting Fixture Contents Imply Deferred Behavior

**What goes wrong:** The selected project fixture's seam-related name or config keys create accidental claims about wall seam behavior, arc fitting, generated outputs, or geometry parity. \[VERIFIED: local bsdtar extraction of `Metadata/Slic3r_PE.config`; .planning/REQUIREMENTS.md\]

**Why it happens:** A real upstream project fixture can contain many settings unrelated to the narrow evidence contract. [VERIFIED: local bsdtar extraction; INFERENCE]

**How to avoid:** Scope the expected artifact to project-marker/archive summary only and require exclusions in the scope record, fixture README, and future status notes. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; .planning/REQUIREMENTS.md]

**Warning signs:** Status text says "project-file parity" without "narrow" or without deferred scope terms. [VERIFIED: packages/parity/status.tsv; .planning/REQUIREMENTS.md; INFERENCE]

### Pitfall 4: Verifier Executes Display-Only Commands

**What goes wrong:** A verifier shells out to the planned Phase 44 command or evaluates text from the scope record. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md]

**Why it happens:** The scope record contains command text by design. [VERIFIED: .planning/REQUIREMENTS.md]

**How to avoid:** Verify command text with `grep -F` or exact table-row checks only, and add a test that proves the command remains "not created in Phase 41". [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; packages/prusa-baseline/verify_prusa_baseline_test.sh]

**Warning signs:** `eval`, `bash -c`, dynamic command assembly, or Bazel query/run against the planned Phase 44 command appears in `verify_prusa_project_file_scope.sh`. [VERIFIED: Bright Builds code-shape standard; INFERENCE]

## Code Examples

Verified patterns from existing sources:

### Bazel Gate Package

```python
sh_binary(
    name = "verify",
    srcs = ["verify_prusa_project_file_scope.sh"],
    data = [
        "README.md",
        "project-file-scope.md",
    ],
    args = [
        "$(location README.md)",
        "$(location project-file-scope.md)",
    ],
)

sh_test(
    name = "verify_prusa_project_file_scope_test",
    srcs = ["verify_prusa_project_file_scope_test.sh"],
    data = ["verify_prusa_project_file_scope.sh"],
)
```

This is adapted from `packages/prusa-baseline/BUILD.bazel`, which uses a public `sh_binary` verifier and `sh_test` failure-mode coverage. [VERIFIED: packages/prusa-baseline/BUILD.bazel]

### Exact Markdown Table Row Verification

```bash
require_section_table_row() {
	local file="$1"
	local label="$2"
	local section="$3"
	local field="$4"
	local value="$5"
	local row="| ${field} | ${value} |"

	if ! awk -v section="${section}" -v row="${row}" '
		$0 == section { in_section = 1; next }
		in_section && /^## / { exit }
		in_section && $0 == row { found = 1; exit }
		END { exit found ? 0 : 1 }
	' "${file}"; then
		error "${label}: missing required table row in ${section}: ${row}"
	fi
}
```

This helper exists in the Phase 37 verifier and should be reused or copied narrowly for the Phase 41 scope record verifier. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh]

### Future Rust Boundary Shape

```rust
pub const fn prusa_project_file_metadata() -> PrusaProjectFileMetadata {
    PrusaProjectFileMetadata {
        inventory_id: "prusaslicer.project-file",
        source_path: "src/libslic3r/Format/3mf.cpp",
        fixture_path: "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf",
        expected_artifact_path: "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv",
        reserved_future_status_token: "fork.prusaslicer.project-file",
    }
}
```

This is a Phase 43-oriented shape inferred from `prusa_profile_schema_metadata`, not a Phase 41 implementation task. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; INFERENCE]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source-observed inventory rows only | Reviewed gate package before fixtures and executable evidence | Phase 37 for `prusaslicer.profile-schema` | Phase 41 should repeat the gate package pattern for `prusaslicer.project-file`. [VERIFIED: packages/fork-inventories/README.md; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |
| Fixture namespace without status publication | Static source-pinned fixture plus provenance and docs-only status reservation | Phase 38 | Phase 42 should consume the Phase 41 scope record and create fixture/provenance artifacts without publishing status early. [VERIFIED: .planning/milestones/v1.10-phases/38-prusa-fixture-and-status-evidence-surface/38-01-SUMMARY.md] |
| Parser readiness treated as evidence | Pure Rust boundary documented as readiness only until parity command passes | Phase 39 | Phase 43 should keep Rust project-file parsing side-effect-free and not publish status by itself. [VERIFIED: .planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; .planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md] |
| Status row before rerunnable command | Status row tied to public `//packages/parity:*_parity` command and failure guard | Phase 40 | Phase 44 should publish `fork.prusaslicer.project-file` only after a project-file parity command and divergence guard pass. [VERIFIED: .planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-01-SUMMARY.md; .planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-02-SUMMARY.md] |

**Deprecated/outdated:**

- Treating `prusaslicer.project-file` as a broad runtime capability is outdated for v1.11 planning because the current roadmap requires one narrow evidence slice with explicit deferrals. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]
- Treating branch heads as fixture anchors is outdated for this project because fork inventory docs state accepted source refs come from selected stable tags and peeled commits, while branch heads are drift-only observations. [VERIFIED: packages/fork-inventories/README.md; packages/fork-vendors/README.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| - | Reviewer signoff source resolved during plan revision: prior v1.10 scope/checklist gates use `Peter Ryszkiewicz, YYYY-MM-DD UTC`, and this yolo workflow was invoked by Peter in this repo. | Open Questions (RESOLVED) | Phase 41 may use `Peter Ryszkiewicz, 2026-06-03 UTC` as the review-gate signoff string. [VERIFIED: .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md; VERIFIED: 2026-06-03 revision resolution] |

## Open Questions (RESOLVED)

1. **Reviewer signoff source**

   - What we know: PSEL-01 requires a reviewer signoff field, and Phase 37 used explicit reviewer fields. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-baseline/profile-schema-checklist.md]
   - Resolution: Prior v1.10 scope/checklist gates use `Peter Ryszkiewicz, YYYY-MM-DD UTC`; because this yolo workflow was invoked by Peter in this repo, Phase 41 may use `Peter Ryszkiewicz, 2026-06-03 UTC` as the review-gate signoff string. [VERIFIED: .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md; VERIFIED: 2026-06-03 revision resolution]
   - Plan impact: `41-01-PLAN.md` already uses `Reviewer signoff | Peter Ryszkiewicz, 2026-06-03 UTC |`, so no plan wording change is required. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-01-PLAN.md]

1. **Whether to include the tiny upstream non-project `.3mf` as a future negative fixture**

   - What we know: `Büchse.3mf` is source-pinned, tiny, and used by upstream `load_3mf`, but it lacks the project markers needed for primary project-file evidence. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_3mf.cpp; VERIFIED: local bsdtar extraction]
   - Resolution: Do not include it in Phase 41 or in the primary Phase 42 contract. Treat it as an optional future contrast fixture only if a later phase explicitly needs negative project-marker coverage. [VERIFIED: 2026-06-03 revision resolution]
   - Plan impact: `41-01-PLAN.md` already keeps Phase 41 contract-only and uses upstream `tests/data/seam_test_object.3mf` as the primary Phase 42 fixture source contract, so no plan wording change is required. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-01-PLAN.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazelisk/Bazel | Scope verifier target and tests | Yes | 8.6.0 | Use `bazel` directly if Bazelisk is unavailable and `.bazelversion` is honored. [VERIFIED: local command probe; .bazelversion] |
| Bash | Scope verifier script and test script | Yes | GNU bash 3.2.57 | Keep scripts compatible with the existing Bash style. [VERIFIED: local command probe; packages/prusa-baseline/verify_prusa_baseline.sh] |
| `awk` | Exact table row checks | Yes | 20200816 | Use grep-only checks for simple text if no table row validation is required. [VERIFIED: local command probe; packages/prusa-baseline/verify_prusa_baseline.sh] |
| `shasum` | Future fixture hash checks | Yes | 6.02 | Use `openssl dgst -sha256` only if `shasum` is absent. [VERIFIED: local command probe; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| `bsdtar` | Future archive member inspection | Yes | 3.5.3 | Use `unzip -l`/`unzip -p`, which is also available. [VERIFIED: local command probe] |
| `mdformat` | Markdown checks for touched docs | Yes | 1.0.0 | Skip only where repo-local guidance forbids it, such as phase summary files. [VERIFIED: local command probe; AGENTS.md] |
| `shfmt` | Shell script formatting check | Yes | 3.12.0 | Manual review if unavailable. [VERIFIED: local command probe; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |

**Missing dependencies with no fallback:**

- None found for the Phase 41 scope gate workflow. [VERIFIED: local command probe]

**Missing dependencies with fallback:**

- None found for the Phase 41 scope gate workflow. [VERIFIED: local command probe]

## Security Domain

OWASP ASVS 5.0.0 is the latest stable ASVS release according to the OWASP ASVS project page, and OWASP recommends versioned requirement identifiers because identifiers can change between versions. [CITED: https://owasp.org/www-project-application-security-verification-standard/] The table below uses the GSD template's broad category labels while applying them to this documentation/verifier phase. [VERIFIED: GSD output_format instructions; CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | No | No auth boundary is touched by Phase 41. [VERIFIED: .planning/REQUIREMENTS.md] |
| V3 Session Management | No | No session state is touched by Phase 41. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | No | Phase 41 changes checked-in docs/data only and does not create runtime access decisions. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md] |
| V5 Input Validation | Yes | Verifier must validate exact record fields and must not execute command strings from Markdown. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; .planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] |
| V6 Cryptography | No | Phase 41 does not introduce cryptographic algorithms or key handling; later fixture hashes should use SHA-256 as integrity metadata only. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; .planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md] |

### Known Threat Patterns For Scope Gate Documentation

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Scope overclaiming | Spoofing / Repudiation | Require exact deferred-scope terms in `project-file-scope.md`, package README, and port docs. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; .planning/REQUIREMENTS.md] |
| Tampered source identity | Tampering | Verify the exact `prusaslicer.project-file` inventory row values, accepted source ref, source path, and planned fixture URL/hash fields. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; packages/prusa-baseline/verify_prusa_baseline.sh] |
| Fake reviewer approval | Repudiation | Require the resolved explicit Phase 41 reviewer string `Peter Ryszkiewicz, 2026-06-03 UTC` before downstream phases consume the gate. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md; VERIFIED: 2026-06-03 revision resolution] |
| Command injection through planned evidence command text | Elevation of Privilege | Treat command text as display-only and verify with fixed-text checks; do not use `eval`, dynamic `bash -c`, or execution of Markdown field values. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md] |
| Accidental network or upstream import | Information Disclosure / Tampering | Keep Phase 41 verification local-only and rely on accepted source refs, raw URLs, and checked-in scope records; do not clone, vendor, or fetch upstream during verification. [VERIFIED: packages/fork-vendors/README.md; packages/prusa-baseline/README.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md` - locked decisions, discretion, deferred scope, and canonical refs. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 41-44 sequence, goals, success criteria, and dependency mapping. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - PSEL-01, PSEL-02, and explicit v1.11 exclusions. [VERIFIED: file read]
- `packages/fork-inventories/prusaslicer.tsv` and `packages/fork-inventories/category-map.tsv` - project-file inventory row and shared downstream categorization. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` and tests - existing `prusaslicer.project-file` static metadata and test coverage. [VERIFIED: file read]
- `packages/prusa-baseline/*` - Phase 37 scope gate package, verifier, and tests. [VERIFIED: file read]
- `packages/parity-fixtures/*` and `packages/parity/*` - Phase 38-40 fixture, expected artifact, verifier, parity command, and status-row precedent. [VERIFIED: file read]
- v1.10 Phase 37-40 summaries - execution precedent and verification evidence. [VERIFIED: file read]

### Primary External (HIGH confidence)

- `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.cpp` - upstream project detection, load, store, and archive member constants. [CITED: official GitHub raw]
- `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Format/3mf.hpp` - upstream public API declarations for project detection, load, and store. [CITED: official GitHub raw]
- `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_3mf.cpp` - upstream `.3mf` test references. [CITED: official GitHub raw]
- `https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1` - upstream tree paths for `.3mf` candidate discovery. [CITED: official GitHub API]
- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code-shape, verification, testing, and Rust standards. [CITED: official GitHub raw]
- `https://owasp.org/www-project-application-security-verification-standard/` - ASVS purpose, latest stable 5.0.0, and versioned requirement ID guidance. [CITED: OWASP official]

### Secondary (MEDIUM confidence)

- None used. [VERIFIED: source audit]

### Tertiary (LOW confidence)

- None used. [VERIFIED: source audit]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - all recommended tools are existing repo patterns or locally available commands. [VERIFIED: local command probe; packages/prusa-baseline/BUILD.bazel]
- Architecture: HIGH - Phase 37-40 provide direct local precedent for a scope gate, fixture surface, Rust boundary, and parity/status publication chain. [VERIFIED: v1.10 phase summaries]
- Fixture-source recommendation: HIGH - upstream tree, raw fixture bytes, archive members, hashes, and upstream test references were verified at the accepted commit. [VERIFIED: upstream GitHub API; local curl/shasum/bsdtar probe]
- Pitfalls: HIGH - each pitfall maps to explicit v1.11 exclusions or observed upstream/local precedent. [VERIFIED: .planning/REQUIREMENTS.md; upstream 3mf.cpp inspection; packages/prusa-baseline/verify_prusa_baseline.sh]
- Security: MEDIUM - threat patterns are derived from local verifier precedent and ASVS guidance, but no dedicated security review has been performed for Phase 41. [CITED: OWASP official; VERIFIED: local verifier precedent; INFERENCE]

**Research date:** 2026-06-03\
**Valid until:** 2026-07-03 for local codebase patterns; re-check upstream Prusa source and ASVS release guidance if source pins or security standards change. [VERIFIED: AGENTS.bright-builds.md; CITED: OWASP official; INFERENCE]
