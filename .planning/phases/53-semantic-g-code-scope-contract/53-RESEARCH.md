# Phase 53: Semantic G-code Scope Contract - Research

**Researched:** 2026-06-21 [VERIFIED: system date]
**Domain:** Internal Prusa G-code semantic scope contract, Bash verifier, Bazel `sh_binary`/`sh_test` package [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel]
**Confidence:** HIGH [VERIFIED: local scope verifier and mutation test passed with Bazel]

<user_constraints>
## User Constraints (from CONTEXT.md)

All bullets in this section are copied from `.planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md`; this section is the source of locked phase constraints for planning. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Contract placement

- **D-01:** Extend the existing `packages/prusa-gcode-output-scope` package
  instead of creating a new semantic-scope package. This preserves the Phase
  45 -> Phase 49 -> Phase 52 evidence chain for `prusaslicer.gcode-output`.
- **D-02:** Keep `packages/prusa-gcode-output-scope/gcode-output-scope.md` as
  the human-readable source of truth, with a new v1.14 semantic section that is
  visibly additive over the v1.13 structural contract.
- **D-03:** Update `packages/prusa-gcode-output-scope/README.md` only enough to
  describe the semantic scope contract and the verification command. Avoid
  broad doc rewrites or status wording changes outside the scope package.

### Allowed semantic evidence fields

- **D-04:** The semantic contract must explicitly allow only this closed field
  set for Phase 54 fixture expectations and Phase 55 typed parsing:
  `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`,
  `movement_class_counts`, `coordinate_bounds`, `extrusion_total`,
  `feedrate_observations`, and `layer_marker_relationships`.
- **D-05:** Each allowed semantic field must state its evidence boundary in the
  scope record. Coordinate bounds are bounded observations only, extrusion
  totals are summary totals only, feedrate observations are metadata only, and
  layer/marker relationships are fixture-summary relationships only.
- **D-06:** Field names should be stable and TSV-friendly so Phase 54 can
  create `expected-gcode-semantic-summary.tsv` without reinterpreting the
  contract. Unknown semantic fields must fail closed.

### Fail-closed forbidden claims

- **D-07:** Preserve all v1.12/v1.13 no-overclaiming prohibitions: no
  byte-for-byte G-code parity, broad generated-output verification, toolpath
  geometry parity, printability, printer-runtime behavior, support generation,
  wall seam behavior, arc fitting, GUI export/viewer behavior, release
  behavior, network/device behavior, non-Prusa fork behavior, upstream source
  imports, or sync automation.
- **D-08:** Add semantic mutation coverage that proves missing required
  semantic fields, unsupported semantic fields, duplicate semantic rows,
  missing semantic traceability, missing reviewer signoff, and semantic
  overclaim text fail closed.
- **D-09:** Keep `generated-outputs` exactly `in progress`. Phase 53 may plan
  a future semantic update to the existing `fork.prusaslicer.gcode-output`
  row, but it must not change status wording or claim semantic executable
  evidence before Phase 56.

### Traceability

- **D-10:** The updated scope contract must trace to the accepted
  `prusaslicer.gcode-output` inventory row, `gcode.shared` category-map row,
  accepted PrusaSlicer source identity, existing fixture namespace, current
  summary and structural artifacts, planned semantic summary artifact,
  existing Rust boundary path, planned Phase 56 public command, and deferred
  status boundary.
- **D-11:** The planned semantic summary artifact should be
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`.
- **D-12:** The planned Rust boundary should extend the existing
  `slic3r_flavors::prusa_gcode_output` module in Phase 55, keeping it pure and
  data-in/data-out over caller-supplied checked-in artifacts.
- **D-13:** The planned public evidence command should remain
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` unless Phase
  56 planning records a deliberate companion-command decision that preserves
  the existing status-token contract.

### the agent's Discretion

- Choose exact Bash helper names and table-count helper reuse inside
  `verify_prusa_gcode_output_scope.sh`, provided the verifier stays
  fail-closed, readable, and consistent with the existing package style.
- Choose the exact mutation-test helper names in
  `verify_prusa_gcode_output_scope_test.sh`, provided each case proves one
  behavior and reports a useful diagnostic.
- Choose whether semantic traceability is one table or several small tables,
  provided maintainers can inspect source identity, fixture namespace, planned
  semantic artifact, Rust boundary, public command, status boundary, deferred
  scope, and reviewer signoff without ambiguity.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

- Phase 54 owns the semantic fixture corpus, source-pinned provenance, update
  rules, `expected-gcode-semantic-summary.tsv`, and fixture-level semantic
  drift guards.
- Phase 55 owns the pure typed Rust semantic parser/readiness boundary and
  Cargo/Bazel parser coverage.
- Phase 56 owns public semantic parity evidence, semantic mutation guards,
  exact status wording, and public docs.
- Byte-for-byte G-code parity, broad generated-output verification,
  geometry/toolpath parity, printability, printer-runtime behavior, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, GUI behavior, binary G-code, thumbnails, post-processing, host
  upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, release
  behavior, and sync automation remain out of scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| GSSCOPE-01 | Maintainer can inspect a reviewed Prusa G-code semantic evidence scope contract that names the accepted source identity, inventory row, fixture namespace, expected semantic summary artifacts, Rust boundary, public evidence command, planned status wording, docs touched, security note, deferred scope, and reviewer signoff. [VERIFIED: .planning/REQUIREMENTS.md] | Add a v1.14 semantic field table and semantic traceability/signoff table to `packages/prusa-gcode-output-scope/gcode-output-scope.md`, following the v1.13 structural table and traceability layout. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md:42] |
| GSSCOPE-02 | Maintainer can run a fail-closed semantic scope verifier that rejects unsupported semantic fields, duplicate or missing field rows, traceability drift, unsupported generated-output claims, unsupported runtime or printability claims, and missing deferred-scope language. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `verify_prusa_gcode_output_scope.sh` exact-row, row-count, status-row, deferred-term, and overclaim helpers for semantic rows and semantic traceability. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:80] |
| GSSCOPE-03 | Maintainer can confirm the broad `generated-outputs` status row remains `in progress` and the narrow `fork.prusaslicer.gcode-output` status remains limited to the exact semantic evidence slice planned by this milestone. [VERIFIED: .planning/REQUIREMENTS.md] | Keep the existing status verifier requirement for exactly one `generated-outputs` `in progress` row and do not edit public status wording in Phase 53. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:390] |
</phase_requirements>

## Summary

Phase 53 should be planned as an internal contract-and-verifier extension of `packages/prusa-gcode-output-scope`, not as fixture, Rust parser, parity-command, or public status work. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] The current package already has the right shape: Markdown scope record, README boundary text, Bazel `verify` target, fail-closed Bash verifier, and focused mutation suite. [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel]

The planner should split work into two plans matching the roadmap: first add the inspectable v1.14 semantic contract and traceability surface, then extend the verifier and mutation tests. [VERIFIED: .planning/ROADMAP.md] The semantic contract should have exactly 9 allowed fields: `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`, `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, and `layer_marker_relationships`. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

**Primary recommendation:** Add `## v1.14 Semantic Evidence Scope` and `## v1.14 Semantic Traceability` sections to `gcode-output-scope.md`, then enforce those exact rows in `verify_prusa_gcode_output_scope.sh` with mutation tests for missing, duplicate, unsupported, traceability, signoff, status, and overclaim failures. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md:42] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:507]

## Project Constraints (from AGENTS.md)

- Root `AGENTS.md` exists and requires reading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds canonical standards before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md]
- `standards-overrides.md` exists but contains only placeholder override rows; no active local exception changes Phase 53 planning. [VERIFIED: standards-overrides.md]
- Repo-local guidance forbids running `mdformat` over phase `*-SUMMARY.md` files and requires `requirements-completed` frontmatter synchronization for summaries; Phase 53 research is not a `*-SUMMARY.md` file. [VERIFIED: AGENTS.md]
- `AGENTS.bright-builds.md` says repo-specific recurring facts belong in `AGENTS.md`, deliberate standards deviations belong in `standards-overrides.md`, and relevant canonical standards should be acknowledged in plan/review/audit outputs. [VERIFIED: AGENTS.bright-builds.md]
- Bright Builds canonical architecture guidance favors functional core / imperative shell and parsing boundary data into domain types; this supports keeping Phase 53 as shell/Markdown contract work while deferring typed semantic parsing to Phase 55. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Bright Builds canonical testing guidance requires pure/business logic tests and focused tests with Arrange/Act/Assert structure; the existing shell mutation tests already use Arrange/Act/Assert comments. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:233]
- Bright Builds canonical verification guidance requires relevant repo-native verification before commit; for Phase 53 this means the package verifier/test plus changed-file checks such as `git diff --check`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]

## Standard Stack

### Core

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Bazel | 8.6.0 | Runs `//packages/prusa-gcode-output-scope:verify` and `verify_prusa_gcode_output_scope_test`. [VERIFIED: `bazel --version`] | Existing package exposes Bazel `sh_binary` and `sh_test` targets. [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel] |
| Bash | 3.2.57 | Implements fail-closed scope verifier and mutation suite. [VERIFIED: `bash --version`] | Existing verifier/test scripts use `#!/usr/bin/env bash` and `set -euo pipefail`. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:1] |
| awk | 20200816 | Checks exact Markdown table rows, counts rows, and counts TSV status/category rows. [VERIFIED: `awk --version`] | Existing verifier uses `awk` for section-local table checks and TSV counts. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:88] |
| grep | BSD grep 2.6.0-FreeBSD | Checks required/forbidden text and exact status/target patterns. [VERIFIED: `grep --version`] | Existing verifier uses `grep -Fq`, `grep -Fxq`, and `grep -Eq` for text contracts. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:62] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| ShellCheck | 0.11.0 | Static analysis for changed shell scripts. [VERIFIED: `shellcheck --version`] | Use when Phase 53 edits `verify_prusa_gcode_output_scope.sh` or its test. [VERIFIED: local PATH audit] |
| shfmt | 3.12.0 | Check shell formatting for changed shell scripts. [VERIFIED: `shfmt --version`] | Use check/diff mode for changed shell files if planner includes shell formatter verification. [VERIFIED: local PATH audit] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Existing Bash verifier | Python or Rust parser for the scope Markdown | Do not switch; Phase 53 is a contract/verifier extension and existing Bash exact-row checks already pass under Bazel. [VERIFIED: `bazel run //packages/prusa-gcode-output-scope:verify`] |
| Existing scope package | New semantic scope package | Do not create; locked D-01 says extend `packages/prusa-gcode-output-scope`. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| Existing public parity command reference | New public semantic command | Do not decide in Phase 53; D-13 reserves the existing command unless Phase 56 records a companion-command decision. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |

**Installation:** No new package installation is recommended for Phase 53. [VERIFIED: .planning/STATE.md]

**Version verification:** No npm packages are recommended, so `npm view` version verification is not applicable. Local tool versions were verified with `bazel --version`, `bash --version`, `awk --version`, `grep --version`, `shellcheck --version`, and `shfmt --version`. [VERIFIED: local environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/prusa-gcode-output-scope/
|-- README.md                                # package boundary and verification command [VERIFIED: packages/prusa-gcode-output-scope/README.md]
|-- gcode-output-scope.md                    # human-readable scope source of truth [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md]
|-- verify_prusa_gcode_output_scope.sh       # fail-closed verifier [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]
|-- verify_prusa_gcode_output_scope_test.sh  # mutation suite [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh]
`-- BUILD.bazel                              # Bazel verify/test package [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel]
```

### Pattern 1: Additive Versioned Scope Section

**What:** Add a new `## v1.14 Semantic Evidence Scope` table after the v1.13 structural section or traceability section, and keep the v1.13 structural contract intact. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md:42]

**When to use:** Use this when a phase extends the evidence ladder but must not reinterpret older summary or structural evidence. [VERIFIED: .planning/milestones/v1.13-phases/49-structural-g-code-scope-contract/49-CONTEXT.md]

**Recommended semantic rows:** The table should contain exactly these 9 semantic fields and no extras. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

| Semantic Field | Category | Evidence Boundary |
|----------------|----------|-------------------|
| `source_ref` | source identity | Accepted PrusaSlicer source identity only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `fixture_id` | fixture identity | Fixture identity only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `fixture_path` | fixture identity | Checked-in fixture path only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `command_class_counts` | command classes | Counts of approved command classes only; no byte-for-byte or generator parity. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `movement_class_counts` | movement classes | Counts of approved movement classes only; no toolpath geometry or printability claim. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `coordinate_bounds` | coordinate bounds | Bounded observations only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `extrusion_total` | extrusion total | Summary totals only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `feedrate_observations` | feedrate observations | Metadata only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| `layer_marker_relationships` | layer or marker relationships | Fixture-summary relationships only. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |

### Pattern 2: Exact Markdown Rows plus Exact Row Count

**What:** The existing verifier enforces required Markdown table rows with `require_section_table_exact_row` and rejects unsupported rows with a section body row count. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:98] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:114]

**When to use:** Use this for the semantic field contract so missing fields, duplicate semantic rows, compact unsupported rows, and unsupported semantic fields all fail closed. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:507]

**Implementation note:** Either generalize `require_section_table_body_row_count` so it can skip `Semantic Field` headers, or add a semantic-specific helper; both preserve the current verifier style. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:114]

### Pattern 3: Isolated Mutation Fixtures

**What:** The test script writes a complete temporary checkout fixture, mutates one behavior per test, runs the verifier, and asserts diagnostic text. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:85] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:233]

**When to use:** Use this to add semantic tests for missing semantic field, unsupported semantic field, duplicate semantic row, missing semantic traceability row, missing semantic reviewer signoff, semantic overclaim text, and generated-output status promotion. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

### Anti-Patterns to Avoid

- **Creating semantic fixture artifacts in Phase 53:** Phase 54 owns `expected-gcode-semantic-summary.tsv`; Phase 53 should only name the path as planned traceability. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]
- **Implementing the Rust semantic parser in Phase 53:** Phase 55 owns the pure typed Rust semantic parser/readiness boundary. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]
- **Editing public parity status wording in Phase 53:** D-09 says `generated-outputs` stays exactly `in progress` and Phase 53 must not claim executable semantic evidence. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]
- **Replacing exact checks with loose prose search:** Existing scope enforcement depends on exact rows and exact counts to reject unsupported fields. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:333]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Scope Markdown parsing | A new Markdown parser or AST layer | Existing `awk` section-local table row helpers. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:80] | The current helper pattern already verifies exact section rows and preserves a small Bash-only package. [VERIFIED: `bazel run //packages/prusa-gcode-output-scope:verify`] |
| Semantic field closure | A permissive substring scan | Exact semantic rows plus exact semantic row count. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:114] | Unknown fields must fail closed under D-06. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| Status safety | Manual reviewer inspection only | Existing `verify_generated_outputs_in_progress` and exact narrow status row checks. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:178] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:390] | GSSCOPE-03 requires maintainers to confirm broad `generated-outputs` stays in progress. [VERIFIED: .planning/REQUIREMENTS.md] |
| Overclaim detection | Human-only docs review | Extend `reject_overclaiming_text` for Phase 53 semantic phrases. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:208] | The existing verifier already rejects affirmative structural overclaims. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:593] |
| Public semantic evidence | New parity command or Rust parser | Defer to Phase 56 public evidence and Phase 55 Rust parser. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] | Phase 53 is contract-only and must not claim executable semantic evidence. [VERIFIED: .planning/ROADMAP.md] |

**Key insight:** In this repo, the contract is the boundary: exact allowed rows are safer than a prose-only scope statement because later fixture and Rust phases copy the field vocabulary into TSV and typed parsing work. [VERIFIED: .planning/milestones/v1.13-phases/49-structural-g-code-scope-contract/49-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Semantic Terms Accidentally Sound Like Output Parity

**What goes wrong:** Text about movement classes, coordinate bounds, extrusion totals, or feedrates can read like proof of geometry, printability, timing, or runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md]

**Why it happens:** Semantic evidence is closer to toolpath meaning than the v1.13 structural fields, so overclaiming risk is higher. [VERIFIED: .planning/PROJECT.md]

**How to avoid:** Every semantic field boundary must explicitly say what it is not proving when the field is near a deferred claim. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

**Warning signs:** Phrases like "semantic parity proves printability", "semantic evidence verifies runtime behavior", or "broad generated-output verification" appear in README or scope text. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

### Pitfall 2: Unknown Semantic Fields Pass Through

**What goes wrong:** A future artifact could add `toolpath_geometry`, `seam_behavior`, `support_generation`, or another unsupported field without failing. [VERIFIED: .planning/REQUIREMENTS.md]

**Why it happens:** Presence-only checks prove required fields exist but do not reject extras. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:114]

**How to avoid:** Require exact semantic field row count plus exact rows for all nine fields. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:523]

**Warning signs:** New semantic rows are added without a matching row-count constant or mutation test. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:542]

### Pitfall 3: Status Wording Changes Too Early

**What goes wrong:** Phase 53 could update `packages/parity/status.tsv` or public docs as if semantic executable evidence already exists. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

**Why it happens:** The narrow `fork.prusaslicer.gcode-output` row is already verified for structural evidence, so semantic status wording may look like a small doc change. [VERIFIED: packages/parity/status.tsv:18]

**How to avoid:** Keep Phase 53 changes inside the scope package and require `generated-outputs` to remain exactly one `in progress` row. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:390]

**Warning signs:** A diff touches `packages/parity/status.tsv`, `packages/parity/README.md`, or `docs/port/*` with semantic publication language during Phase 53. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

### Pitfall 4: Traceability Omits a Future Boundary

**What goes wrong:** Maintainers can inspect fields but cannot trace source identity, fixture namespace, semantic artifact path, Rust boundary, public command, status boundary, deferred scope, or reviewer signoff. [VERIFIED: .planning/REQUIREMENTS.md]

**Why it happens:** The v1.13 table traces current structural artifacts but does not yet name the planned semantic summary artifact. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md:65]

**How to avoid:** Add `## v1.14 Semantic Traceability` and require exact rows for planned semantic summary, planned Rust semantic boundary, planned public command, and broad status boundary. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]

**Warning signs:** The semantic section names fields but has no reviewer signoff or planned artifact path. [VERIFIED: .planning/REQUIREMENTS.md]

### Pitfall 5: Test File Growth Gets Harder to Maintain

**What goes wrong:** `verify_prusa_gcode_output_scope_test.sh` is already 700 lines, so adding many semantic cases can make the mutation harness harder to review. [VERIFIED: `wc -l packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`]

**Why it happens:** The valid fixture is embedded once and every mutation is explicit. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:85]

**How to avoid:** Keep each new semantic test focused on one behavior, use existing mutation helpers, and avoid broad fixture rewrites outside the new semantic rows. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

**Warning signs:** One semantic test mutates multiple fields or asserts unrelated failures. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

## Code Examples

Verified patterns from local sources:

### Semantic Row Count and Exact Row Checks

```bash
# Source: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh [VERIFIED: local file]
readonly SEMANTIC_SCOPE_SECTION="## v1.14 Semantic Evidence Scope"
readonly SEMANTIC_FIELD_ROW_COUNT="9"

verify_semantic_scope_contract() {
	require_section_table_body_row_count "${scope_file}" "gcode-output-scope.md" \
		"${SEMANTIC_SCOPE_SECTION}" "${SEMANTIC_FIELD_ROW_COUNT}"
	require_section_table_exact_row "${scope_file}" "gcode-output-scope.md" \
		"${SEMANTIC_SCOPE_SECTION}" '| source_ref | source identity | Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. |'
}
```

Planner note: the existing body-row-count helper currently skips a `Structural Field` header, so implementation should generalize it or add a semantic-specific helper before using it on a `Semantic Field` table. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:123]

### Semantic Traceability Rows

```bash
# Source: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh [VERIFIED: local file]
readonly SEMANTIC_TRACEABILITY_SECTION="## v1.14 Semantic Traceability"

verify_semantic_traceability() {
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${SEMANTIC_TRACEABILITY_SECTION}" "Planned semantic summary" \
		'`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`'
	require_section_table_row "${scope_file}" "gcode-output-scope.md" \
		"${SEMANTIC_TRACEABILITY_SECTION}" "Broad status row" \
		'`generated-outputs` stays `in progress` in `packages/parity/status.tsv`'
}
```

Planner note: Markdown backticks in expected row strings should be single-quoted or otherwise protected, matching the existing structural verifier comment. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:330]

### Focused Mutation Test Shape

```bash
# Source: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh [VERIFIED: local file]
test_missing_allowed_semantic_field_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-allowed-semantic-field"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/gcode-output-scope.md" "| source_ref |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-semantic.out" "${tmp_dir}/missing-semantic.err"; then
		fail "missing allowed semantic field fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-semantic.err" '^error:'
	assert_contains "${tmp_dir}/missing-semantic.err" 'source_ref'
}
```

Planner note: add semantic rows to `write_valid_fixture` first so each semantic mutation starts from a valid Phase 53 fixture. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:85]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Summary-only G-code evidence with marker rows | Structural rows plus public structural parity command | v1.13 / Phase 52 [VERIFIED: .planning/STATE.md] | Current status row is structural-only and must not be rewritten as semantic in Phase 53. [VERIFIED: packages/parity/status.tsv:18] |
| v1.13 structural contract with 16 allowed fields | v1.14 semantic contract should add a 9-field semantic scope before fixture/parser work | v1.14 / Phase 53 [VERIFIED: .planning/ROADMAP.md] | Phase 54 and Phase 55 can consume stable TSV-friendly field names. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |
| Broad `generated-outputs` in progress | Broad `generated-outputs` remains in progress | unchanged in v1.14 [VERIFIED: .planning/REQUIREMENTS.md] | Semantic evidence deepens one narrow Prusa row but does not graduate the broad surface. [VERIFIED: packages/parity/status.tsv:14] |

**Deprecated/outdated:**

- Creating a new semantic scope package is out of date for this phase because D-01 requires extending `packages/prusa-gcode-output-scope`. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]
- Treating semantic G-code evidence as byte-for-byte G-code parity is forbidden by v1.14 out-of-scope requirements. [VERIFIED: .planning/REQUIREMENTS.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| none | No assumptions were needed; recommendations are based on locked phase context, local code, executed Bazel checks, local tool availability, or cited official docs. [VERIFIED: local research protocol] | none | none |

## Open Questions

1. **Exact semantic reviewer signoff value**
   - What we know: Phase 53 requires reviewer signoff and existing structural signoff uses `Peter Ryszkiewicz, 2026-06-16 UTC`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md:77]
   - What's unclear: The exact v1.14 semantic signoff date should match the actual review/implementation date. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md]
   - Recommendation: Planner should require a `Semantic reviewer signoff` row and let implementation use the actual UTC review date. [VERIFIED: .planning/REQUIREMENTS.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Scope verifier/test targets | yes [VERIFIED: `command -v bazel`] | 8.6.0 [VERIFIED: `bazel --version`] | None needed. [VERIFIED: existing Bazel targets passed] |
| Bash | Verifier and mutation scripts | yes [VERIFIED: `command -v bash`] | 3.2.57 [VERIFIED: `bash --version`] | None needed. [VERIFIED: existing scripts use Bash] |
| awk | Exact table/TSV checks | yes [VERIFIED: `command -v awk`] | 20200816 [VERIFIED: `awk --version`] | None needed. [VERIFIED: existing verifier uses awk] |
| grep | Required/forbidden text checks | yes [VERIFIED: `command -v grep`] | BSD grep 2.6.0-FreeBSD [VERIFIED: `grep --version`] | None needed. [VERIFIED: existing verifier uses grep] |
| ShellCheck | Optional shell static check | yes [VERIFIED: `command -v shellcheck`] | 0.11.0 [VERIFIED: `shellcheck --version`] | If omitted, rely on Bazel tests and `shfmt -d`; ShellCheck is available locally. [VERIFIED: local PATH audit] |
| shfmt | Optional shell format diff | yes [VERIFIED: `command -v shfmt`] | 3.12.0 [VERIFIED: `shfmt --version`] | If omitted, run existing Bazel tests and `git diff --check`; shfmt is available locally. [VERIFIED: local PATH audit] |

**Missing dependencies with no fallback:** None found for Phase 53. [VERIFIED: local environment audit]

**Missing dependencies with fallback:** None found for Phase 53. [VERIFIED: local environment audit]

## Security Domain

OWASP ASVS is a web application security verification standard, and the official OWASP project page identifies latest stable ASVS 5.0.0 as of May 2025. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS] Phase 53 is local docs plus Bash/Bazel verification, not a web auth/session/API feature. [VERIFIED: .planning/ROADMAP.md]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no [VERIFIED: Phase 53 has no auth surface] | No new auth controls; keep no credential/network/device claims in deferred scope. [VERIFIED: .planning/REQUIREMENTS.md] |
| V3 Session Management | no [VERIFIED: Phase 53 has no session surface] | No session controls needed. [VERIFIED: .planning/ROADMAP.md] |
| V4 Access Control | no [VERIFIED: Phase 53 has no runtime access-control surface] | Use repository review and Bazel verification, not runtime authorization. [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel] |
| V5 Input Validation | yes [VERIFIED: verifier validates Markdown/TSV inputs] | Fail closed on exact rows, row counts, status rows, forbidden text, and missing files. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:439] |
| V6 Cryptography | no [VERIFIED: Phase 53 has no cryptographic operation] | Do not introduce cryptographic code; fixture hashes remain Phase 54 or existing provenance concerns. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] |

### Known Threat Patterns for Local Scope-Verifier Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Scope drift by unsupported semantic row | Tampering [VERIFIED: semantic field closure requirement] | Exact row count plus exact allowed rows. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:114] |
| Public overclaim by affirmative docs text | Tampering/Repudiation [VERIFIED: GSSCOPE-02] | Extend forbidden-claim scanning for Phase 53 semantic phrases. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:208] |
| Status promotion of broad generated outputs | Tampering [VERIFIED: GSSCOPE-03] | Require exactly one `generated-outputs` row with status `in progress`. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh:390] |
| Traceability loss to source/fixture/Rust/public command | Repudiation [VERIFIED: GSSCOPE-01] | Require semantic traceability rows and reviewer signoff. [VERIFIED: .planning/REQUIREMENTS.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md` - locked implementation decisions, allowed semantic fields, deferred scope, and downstream boundaries. [VERIFIED: mandatory initial read]
- `.planning/REQUIREMENTS.md` - GSSCOPE-01, GSSCOPE-02, GSSCOPE-03, and v1.14 out-of-scope boundary. [VERIFIED: mandatory initial read]
- `.planning/ROADMAP.md` - Phase 53 goal, success criteria, and two-plan structure. [VERIFIED: mandatory initial read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - accumulated v1.12/v1.13/v1.14 decisions and evidence ladder. [VERIFIED: mandatory initial read]
- `packages/prusa-gcode-output-scope/*` - current scope record, README, verifier, mutation suite, and Bazel package. [VERIFIED: local file audit]
- `packages/fork-inventories/prusaslicer.tsv` and `packages/fork-inventories/category-map.tsv` - accepted inventory and category-map traceability rows. [VERIFIED: local file audit]
- `packages/parity/status.tsv` - current `generated-outputs` and `fork.prusaslicer.gcode-output` status rows. [VERIFIED: local file audit]
- `bazel run //packages/prusa-gcode-output-scope:verify` - existing verifier passed. [VERIFIED: command execution]
- `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test` - existing mutation suite passed. [VERIFIED: command execution]

### Secondary (MEDIUM confidence)

- Bright Builds canonical architecture, code-shape, verification, and testing pages at pinned commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- OWASP ASVS project and repository pages for security-domain framing. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS]

### Tertiary (LOW confidence)

- None. [VERIFIED: no tertiary sources used]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - no new libraries are needed, local tools are available, and existing Bazel verifier/test targets pass. [VERIFIED: local environment audit] [VERIFIED: command execution]
- Architecture: HIGH - locked decisions explicitly require extending the current scope package and current package patterns are present. [VERIFIED: .planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md] [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel]
- Pitfalls: HIGH - overclaiming, status promotion, unsupported fields, and missing traceability are named in requirements/context and already have v1.13 verifier patterns. [VERIFIED: .planning/REQUIREMENTS.md] [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh]

**Research date:** 2026-06-21 [VERIFIED: system date]
**Valid until:** 2026-07-21 for this internal repo pattern unless Phase 54-56 changes the semantic field contract earlier. [VERIFIED: .planning/ROADMAP.md]
