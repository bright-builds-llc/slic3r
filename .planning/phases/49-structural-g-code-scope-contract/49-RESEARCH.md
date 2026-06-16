# Phase 49: Structural G-code Scope Contract - Research

**Researched:** 2026-06-16 [VERIFIED: system date and phase init]
**Domain:** Internal Prusa G-code evidence contract, Bash verifier, Bazel test target, Markdown/TSV traceability [VERIFIED: .planning/ROADMAP.md, packages/prusa-gcode-output-scope/BUILD.bazel]
**Confidence:** HIGH [VERIFIED: current scope verifier and mutation test passed locally]

<user_constraints>

## User Constraints (from CONTEXT.md)

All bullets in this section are copied verbatim from `.planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md`. [VERIFIED: .planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md]

### Locked Decisions

#### Contract placement

- **D-01:** Extend the existing `packages/prusa-gcode-output-scope` package
  instead of creating a new structural-scope package. This keeps the v1.13
  contract on the same reviewed evidence chain as Phases 45 through 48.
- **D-02:** Keep `packages/prusa-gcode-output-scope/gcode-output-scope.md` as
  the human-readable source of truth, with a new v1.13 structural section that
  is visibly additive over the v1.12 summary-only contract.
- **D-03:** Update `packages/prusa-gcode-output-scope/README.md` only enough to
  describe the reviewed structural scope expansion and the verification
  command. Avoid broad doc rewrites.

#### Allowed structural evidence fields

- **D-04:** The contract must explicitly allow command counts, section counts,
  ordered markers, movement/extrusion indicators, temperature/tool-change
  markers, source identity, and fixture identity.
- **D-05:** Allowed fields should be expressed as a closed set in both the
  scope record and verifier logic. The verifier should fail on unsupported
  structural fields instead of treating unknown columns or terms as harmless.
- **D-06:** The structural field names should be chosen so Phase 50 can produce
  a checked-in expected structural summary without reinterpreting the scope
  contract. Prefer stable, TSV-friendly names over prose-only labels.

#### Fail-closed forbidden claims

- **D-07:** Preserve all v1.12 no-overclaiming prohibitions: no byte-for-byte
  G-code parity, geometry/toolpath parity, printability, printer-runtime
  behavior, support generation, wall seam behavior, arc fitting, GUI
  export/viewer behavior, release behavior, network/device behavior, non-Prusa
  fork behavior, upstream source imports, or sync automation.
- **D-08:** Expand mutation coverage so unsupported structural fields and
  unsupported broad-behavior claim text fail closed. The mutation suite should
  prove both missing required structural contract text and forbidden claim
  insertion paths.
- **D-09:** Keep the broad `generated-outputs` row in progress. Phase 49 may
  reference the existing verified `fork.prusaslicer.gcode-output` row only as
  the narrow v1.12 evidence path that the structural expansion builds on.

#### Traceability

- **D-10:** The updated scope contract must trace back to the accepted
  `prusaslicer.gcode-output` inventory row, `gcode.shared` category-map row,
  the v1.12 fixture namespace, the expected summary artifact, and the published
  narrow parity status row.
- **D-11:** The verifier should continue requiring the existing exact inventory
  and category-map rows so the v1.13 structural contract cannot drift to a
  branch-head observation, another Prusa feature, or a non-Prusa fork.
- **D-12:** Docs and status wording should continue to say that structural
  evidence is narrow evidence, not broad generated-output parity.

### the agent's Discretion

- Choose the exact helper function boundaries inside
  `verify_prusa_gcode_output_scope.sh`, as long as they stay readable,
  fail-closed, and follow the existing Bash style.
- Choose the exact mutation-test helper names in
  `verify_prusa_gcode_output_scope_test.sh`, as long as each new case proves
  one behavior and is easy to diagnose.
- Decide whether to add one new scope-record table section or extend existing
  rows, provided the resulting contract is inspectable and does not blur
  v1.12 summary-only evidence with v1.13 structural evidence.

### Deferred Ideas (OUT OF SCOPE)

- Phase 50 owns the checked-in structural fixture artifact and structural
  fixture drift guards.
- Phase 51 owns the typed Rust structural summary parser and registry readiness.
- Phase 52 owns public executable structural evidence and public docs/status
  updates.
- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, GUI export/viewer behavior, release behavior, network/device
  behavior, non-Prusa fork behavior, upstream source imports, and sync
  automation remain out of scope.
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| GCSCOPE-01 | Maintainer can inspect a reviewed structural G-code scope contract that enumerates the allowed evidence fields for command counts, section counts, ordered markers, movement/extrusion indicators, temperature/tool-change markers, source identity, and fixture identity. [VERIFIED: .planning/REQUIREMENTS.md] | Add a dedicated v1.13 allowed-structural-fields table in `gcode-output-scope.md`, verify exact rows and row count, and keep `README.md` narrow. [VERIFIED: 49-CONTEXT.md, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| GCSCOPE-02 | Maintainer can run a scope verifier that fails closed when v1.13 artifacts claim broad generated-output, runtime, fork, import, or sync surfaces. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `reject_overclaiming_text`, require deferred terms, and add mutation cases for forbidden structural/broad claim insertion. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh] |
| GCSCOPE-03 | Maintainer can trace the structural G-code evidence scope to the accepted `prusaslicer.gcode-output` inventory row and v1.12 fixture/status path while keeping broad `generated-outputs` in progress. [VERIFIED: .planning/REQUIREMENTS.md] | Preserve exact inventory/category/status checks and add structural text that references the existing fixture namespace and expected summary without promoting `generated-outputs`. [VERIFIED: packages/fork-inventories/prusaslicer.tsv, packages/fork-inventories/category-map.tsv, packages/parity/status.tsv] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo instruction entrypoint, and `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant canonical Bright Builds standards must be read before planning, review, implementation, or audit work. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/index.md]
- Do not edit the Bright Builds managed block in `AGENTS.md` or edit `AGENTS.bright-builds.md` directly. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md]
- Repo-local phase summary files require `requirements-completed` frontmatter and must not be run through `mdformat`; this phase writes research, not a summary, so that constraint is informational for downstream summary work. [VERIFIED: AGENTS.md]
- Bright Builds requires functional-core/imperative-shell separation where business logic exists, parsing raw input at boundaries, shallow control flow, focused tests, and relevant repo-native verification before commit. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md]
- Existing global instructions prefer `rg` for searches, `set -euo pipefail` for Bash scripts, no hidden ignored failures, Arrange/Act/Assert test structure, and verification evidence before done. [VERIFIED: user-provided AGENTS instructions, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh]
- No project-local `.claude/skills/` or `.agents/skills/` directory exists in this checkout. [VERIFIED: `rg --files standards .claude/skills .agents/skills` returned missing-directory diagnostics]

## Summary

Phase 49 is an internal contract expansion, not an ecosystem or library selection phase. [VERIFIED: 49-CONTEXT.md, .planning/STATE.md] The correct implementation path is to extend `packages/prusa-gcode-output-scope` in place, add a visibly additive v1.13 structural section to `gcode-output-scope.md`, and keep `README.md` updates minimal. [VERIFIED: 49-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md, packages/prusa-gcode-output-scope/README.md]

The existing verifier already provides the needed primitives: required text checks, required Markdown table row checks, exact TSV row checks, category-map reference counting, status publication checks, parity target publication checks, and forbidden overclaim rejection. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] The current verifier and mutation suite pass locally, so the planner can treat the baseline as green. [VERIFIED: `bash -n packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`, `bazel run //packages/prusa-gcode-output-scope:verify`, `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`]

**Primary recommendation:** Add one exact-row-counted `## v1.13 Structural Evidence Scope` table in `gcode-output-scope.md`, encode the same allowed field set as Bash constants, and expand mutation tests for missing required fields, unsupported structural fields, and broad behavior claim insertion. [VERIFIED: 49-CONTEXT.md] [ASSUMED: recommended implementation shape]

## Standard Stack

### Core

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Bash | GNU bash 3.2.57 | Scope verifier and mutation test scripts. [VERIFIED: environment audit] | Existing scope and fixture verifiers are Bash scripts with `set -euo pipefail`. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Bazel | 8.6.0 | Public verifier and mutation test execution. [VERIFIED: environment audit] | The package exposes `sh_binary(name = "verify")` and `sh_test(name = "verify_prusa_gcode_output_scope_test")`. [VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel] |
| Markdown | repo text format | Human-readable scope source of truth. [VERIFIED: 49-CONTEXT.md] | The existing scope record is `gcode-output-scope.md`, and decisions require keeping it as the human-readable source of truth. [VERIFIED: 49-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md] |
| TSV | repo text data format | Inventory, category-map, status, provenance, and expected-summary traceability. [VERIFIED: packages/fork-inventories/prusaslicer.tsv, packages/fork-inventories/category-map.tsv, packages/parity/status.tsv, packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv] | Existing verifier helpers already enforce exact TSV rows and duplicate-row guards. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| shfmt | 3.12.0 | Shell formatting check. [VERIFIED: environment audit] | Run `shfmt -d` for touched scope verifier/test shell paths before commit. [CITED: Bright Builds verification standard] |
| shellcheck | 0.11.0 | Shell static analysis. [VERIFIED: `shellcheck --version`] | Run on touched Bash scripts when Phase 49 changes verifier/test logic. [VERIFIED: Phase 45-48 plan and summary verification patterns] |
| mdformat | 1.0.0 | Markdown formatting check. [VERIFIED: environment audit] | Use check mode only for touched non-summary Markdown if formatting is needed; do not run on `*-SUMMARY.md`. [VERIFIED: AGENTS.md] |
| ripgrep | 15.1.0 | Fast repo text search. [VERIFIED: environment audit] | Use to verify no forbidden claims or broad status drift after edits. [VERIFIED: user-provided AGENTS instructions] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Extending `packages/prusa-gcode-output-scope` | New structural scope package | Do not use; locked decision D-01 requires extending the existing package. [VERIFIED: 49-CONTEXT.md] |
| Exact Markdown/TSV checks | General Markdown parser or schema framework | Do not add; existing exact checks are sufficient and avoid a new dependency for a contract-only phase. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh, AGENTS.md dependency guidance] |
| Bash verifier only | Rust parser implementation | Do not implement here; Phase 51 owns typed Rust structural parsing. [VERIFIED: 49-CONTEXT.md, .planning/ROADMAP.md] |
| Broad status/docs rewrite | Minimal README/scope update | Do not rewrite broadly; D-03 requires minimal README changes and D-09 keeps broad `generated-outputs` in progress. [VERIFIED: 49-CONTEXT.md] |

**Installation:**

```bash
# No new packages are required for Phase 49.
```

**Version verification:**

```bash
bash --version
bazel --version
shfmt --version
shellcheck --version
mdformat --version
rg --version
```

Local versions were verified on 2026-06-16. [VERIFIED: environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
+-- prusa-gcode-output-scope/
|   +-- README.md                              # minimal package boundary update
|   +-- gcode-output-scope.md                  # v1.12 record plus v1.13 structural section
|   +-- verify_prusa_gcode_output_scope.sh     # exact contract verifier
|   +-- verify_prusa_gcode_output_scope_test.sh # mutation tests
|   +-- BUILD.bazel                            # existing sh_binary/sh_test targets
+-- fork-inventories/
|   +-- prusaslicer.tsv                        # accepted inventory row remains exact
|   +-- category-map.tsv                       # gcode.shared reference remains exact
+-- parity/
|   +-- status.tsv                             # generated-outputs remains in progress
```

This structure matches the locked package placement and existing Bazel package boundary. [VERIFIED: 49-CONTEXT.md, packages/prusa-gcode-output-scope/BUILD.bazel]

### Pattern 1: Dedicated v1.13 Allowed-Field Table

**What:** Add a new `## v1.13 Structural Evidence Scope` section with one table whose first column is the exact allowed field name and whose row count is enforced by the verifier. [ASSUMED: recommended implementation shape]\
**When to use:** Use this instead of extending a prose-only `Deferred scope` or semicolon list because D-05 requires unsupported structural fields to fail closed. [VERIFIED: 49-CONTEXT.md]\
**Recommended allowed field names:** [ASSUMED: researcher recommendation from D-04/D-06]

| Field | Category | Why It Is Allowed |
|-------|----------|-------------------|
| `source_ref` | source identity | Carries the accepted PrusaSlicer source identity already used by v1.12 artifacts. [VERIFIED: expected-gcode-summary.tsv, fixture-provenance.tsv] |
| `inventory_source_paths` | source identity | Ties structural evidence to the exact inventory source paths `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`. [VERIFIED: packages/fork-inventories/prusaslicer.tsv] |
| `fixture_source_literal` | source identity | Ties the set-speed fixture to `tests/fff_print/test_gcodewriter.cpp#L20-L35`. [VERIFIED: fixture README, expected-gcode-summary.tsv] |
| `fixture_id` | fixture identity | Names `gcodewriter-set-speed.gcode` without claiming byte parity. [VERIFIED: fixture-provenance.tsv] |
| `fixture_path` | fixture identity | Reuses the checked-in fixture path already parsed by the v1.12 Rust boundary. [VERIFIED: expected-gcode-summary.tsv, prusa_gcode_output.rs] |
| `command_count_total` | command counts | Counts commands structurally without claiming generated-output semantics. [VERIFIED: .planning/REQUIREMENTS.md] |
| `command_count_g1` | command counts | The checked-in fixture contains four `G1` lines. [VERIFIED: gcodewriter-set-speed.gcode] |
| `section_count_total` | section counts | Allows explicit section-count evidence without implying slicer GUI sections or print behavior. [VERIFIED: .planning/REQUIREMENTS.md] |
| `ordered_marker_1` | ordered markers | Preserves first ordered marker evidence. [VERIFIED: expected-gcode-summary.tsv] |
| `ordered_marker_2` | ordered markers | Preserves second ordered marker evidence. [VERIFIED: expected-gcode-summary.tsv] |
| `ordered_marker_3` | ordered markers | Preserves third ordered marker evidence. [VERIFIED: expected-gcode-summary.tsv] |
| `ordered_marker_4` | ordered markers | Preserves fourth ordered marker evidence. [VERIFIED: expected-gcode-summary.tsv] |
| `movement_axis_present` | movement/extrusion indicators | Allows a boolean structural indicator without claiming toolpath geometry. [VERIFIED: .planning/REQUIREMENTS.md] |
| `extrusion_axis_present` | movement/extrusion indicators | Allows a boolean structural indicator without claiming extrusion semantics. [VERIFIED: .planning/REQUIREMENTS.md] |
| `temperature_marker_count` | temperature/tool-change markers | Allows marker-count evidence without claiming printer-runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md] |
| `tool_change_marker_count` | temperature/tool-change markers | Allows marker-count evidence without claiming multi-tool runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md] |

### Pattern 2: Closed-Set Verification

**What:** Mirror the allowed field list as Bash constants and enforce both exact required rows and the exact row count for the section. [ASSUMED: recommended implementation shape]\
**When to use:** Use for `gcode-output-scope.md` because the existing `require_section_table_row` helper proves presence but does not reject extra rows by itself. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

```bash
# Source pattern: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
require_section_table_row "${scope_file}" "gcode-output-scope.md" \
    "## v1.13 Structural Evidence Scope" \
    "source_ref" \
    "Accepted PrusaSlicer source identity."
```

Add a companion helper such as `require_section_table_body_row_count` so an injected unsupported field fails even if all required rows are still present. [ASSUMED: recommended implementation shape]

### Pattern 3: Mutation Tests Stay One Behavior Each

**What:** Extend `verify_prusa_gcode_output_scope_test.sh` with isolated temp checkout roots and one mutation per test. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh]\
**When to use:** Add tests for missing allowed-field rows, injected unsupported structural rows, missing deferred terms, inserted broad behavior claims, and wrong traceability rows. [VERIFIED: 49-CONTEXT.md]

### Anti-Patterns to Avoid

- **Presence-only allowed-field checks:** Extra fields can pass if the verifier only checks required text presence. [VERIFIED: current helper behavior in verify_prusa_gcode_output_scope.sh]
- **Broad status promotion:** Updating `generated-outputs` from `in progress` would violate GCSCOPE-03. [VERIFIED: .planning/REQUIREMENTS.md, packages/parity/status.tsv]
- **Semantic G-code inference:** Treating `G1` feedrate lines as geometry, extrusion, timing, or printability evidence would violate v1.13 scope. [VERIFIED: expected-gcode-summary.tsv notes, .planning/REQUIREMENTS.md]
- **External source fetching/importing:** Phase 49 must stay contract-only and not fetch upstream source or automate sync. [VERIFIED: 49-CONTEXT.md, fixture verifier self-scan exclusions]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| New structural scope package | A second package beside `packages/prusa-gcode-output-scope` | Extend the existing package | D-01 locks the package placement. [VERIFIED: 49-CONTEXT.md] |
| General Markdown parsing | A custom parser for all Markdown syntax | Existing exact section/table row helpers plus a new row-count helper | Existing package already verifies exact rows; Phase 49 only needs a closed set. [VERIFIED: verify_prusa_gcode_output_scope.sh] |
| G-code semantics | Bash parser for geometry/toolpath/printability | Contract-only allowed field list | Semantics are explicitly out of scope for v1.13. [VERIFIED: .planning/REQUIREMENTS.md] |
| Status framework | New parity status parser | Existing exact `GCODE_OUTPUT_STATUS_ROW` and first-field count checks | Current verifier already requires the narrow published row exactly once. [VERIFIED: verify_prusa_gcode_output_scope.sh] |
| Fixture/parser work | Structural expected summary artifact or Rust parser | Defer to Phases 50 and 51 | Deferred ideas assign those surfaces to later phases. [VERIFIED: 49-CONTEXT.md] |

**Key insight:** The hard part is not parsing G-code; it is preventing contract drift from becoming a broader generated-output claim. [VERIFIED: .planning/REQUIREMENTS.md, 49-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Unknown Structural Fields Slip Through

**What goes wrong:** A maintainer adds an unsupported row such as `geometry_count` while required rows still exist. [ASSUMED: failure scenario based on current presence-only helper]\
**Why it happens:** `require_section_table_row` checks presence, not exclusivity. [VERIFIED: verify_prusa_gcode_output_scope.sh]\
**How to avoid:** Verify exact row count and exact allowed field names for the v1.13 table. [ASSUMED: recommended mitigation]\
**Warning signs:** Mutation tests remove required rows but do not inject unsupported rows. [VERIFIED: current mutation suite pattern]

### Pitfall 2: Structural G-code Evidence Becomes G-code Parity

**What goes wrong:** README or scope text says structural evidence proves byte-for-byte, geometry/toolpath, extrusion, timing, printability, runtime, or GUI behavior. [VERIFIED: .planning/REQUIREMENTS.md forbidden list]\
**Why it happens:** "Structural" can be misread as a stronger generated-output oracle. [ASSUMED: planning risk]\
**How to avoid:** Preserve and expand forbidden claim checks in both README and scope files. [VERIFIED: 49-CONTEXT.md, reject_overclaiming_text in verify_prusa_gcode_output_scope.sh]\
**Warning signs:** New docs contain words such as "parity verified" without "narrow" and "structural" qualifiers. [VERIFIED: existing forbidden claim patterns]

### Pitfall 3: Traceability Drifts Away From v1.12 Evidence

**What goes wrong:** The structural contract points at a branch-head observation, another Prusa row, or a non-Prusa fork. [VERIFIED: 49-CONTEXT.md D-11]\
**Why it happens:** The new structural section is added without preserving exact inventory/category/status checks. [ASSUMED: planning risk]\
**How to avoid:** Keep `INVENTORY_ROW`, `CATEGORY_MAP_ROW`, `GCODE_OUTPUT_STATUS_ROW`, and parity-target publication checks active. [VERIFIED: verify_prusa_gcode_output_scope.sh]\
**Warning signs:** Diffs touch `packages/fork-inventories/prusaslicer.tsv`, `category-map.tsv`, or `packages/parity/status.tsv` without an explicit traceability reason. [VERIFIED: GCSCOPE-03 scope]

### Pitfall 4: Self-Scan Forbidden Terms Break the Verifier

**What goes wrong:** A verifier scans itself for forbidden terms and matches its own forbidden-term list. [VERIFIED: fixture verifier uses split literals for self-scan terms]\
**Why it happens:** Forbidden behavior terms are written as complete strings in the script being scanned. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]\
**How to avoid:** If Phase 49 adds self-scan behavior checks, use split literals like the fixture verifier. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]\
**Warning signs:** A valid verifier fails immediately after adding new forbidden terms. [ASSUMED: operational symptom]

## Code Examples

### Exact Markdown Table Row Check

```bash
# Source: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
require_section_table_row "${scope_file}" "gcode-output-scope.md" \
    "## Scope Record" "Inventory row ID" "\`prusaslicer.gcode-output\`"
```

This is the established pattern for required contract rows. [VERIFIED: verify_prusa_gcode_output_scope.sh]

### Exact TSV Row and Duplicate Guard

```bash
# Source: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
require_exact_tsv_row_once "${inventory_file}" \
    "packages/fork-inventories/prusaslicer.tsv" \
    "${INVENTORY_ROW}"
```

This is the established pattern for preserving traceability to source data. [VERIFIED: verify_prusa_gcode_output_scope.sh]

### One-Concern Mutation Test Shape

```bash
# Source pattern: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
test_missing_allowed_structural_field_fails() {
    # Arrange
    local dir="${tmp_dir}/missing-allowed-structural-field"
    write_valid_fixture "${dir}"
    remove_line_containing "${dir}/gcode-output-scope.md" "| source_ref |"

    # Act
    if run_verifier "${dir}" "${tmp_dir}/missing-structural.out" "${tmp_dir}/missing-structural.err"; then
        fail "missing structural field fixture passed"
    fi

    # Assert
    assert_contains "${tmp_dir}/missing-structural.err" '^error:'
    assert_contains "${tmp_dir}/missing-structural.err" 'source_ref'
}
```

This follows the existing Arrange/Act/Assert mutation-test style. [VERIFIED: verify_prusa_gcode_output_scope_test.sh] [CITED: Bright Builds testing standard]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| v1.12 summary-only marker metadata | v1.13 structural contract with allowed field list before fixture/parser expansion | Pending Phase 49 on 2026-06-16 | Planner should implement contract/verifier changes before Phase 50 fixture bytes or Phase 51 Rust parser changes. [VERIFIED: .planning/ROADMAP.md, 49-CONTEXT.md] |
| Presence checks for required scope rows | Exact row presence plus exact row count for the new allowed-field table | Recommended for Phase 49 | Prevents unknown structural fields from passing. [ASSUMED: recommended implementation shape] |
| Broad `generated-outputs` status remains in progress | Narrow `fork.prusaslicer.gcode-output` can be referenced as existing v1.12 evidence only | v1.12 Phase 48 shipped; v1.13 continues it | Avoids promoting broad generated-output parity. [VERIFIED: packages/parity/status.tsv, .planning/STATE.md] |

**Deprecated/outdated:**

- Treating `fork.prusaslicer.gcode-output` as unpublished is outdated after Phase 48 because the current status row is verified. [VERIFIED: packages/parity/status.tsv, verify_prusa_gcode_output_scope.sh]
- Treating the verified row as broad generated-output parity remains forbidden. [VERIFIED: packages/parity/status.tsv, .planning/REQUIREMENTS.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The recommended exact field names in the v1.13 allowed-field table are a research recommendation, not a pre-existing contract. | Architecture Patterns | Phase 50/51 may need field renames if maintainers prefer different stable TSV names. |
| A2 | Adding a dedicated exact-row-counted section is the cleanest way to satisfy D-05. | Summary, Architecture Patterns | Planner could instead extend existing rows, but must still add an exclusivity check. |
| A3 | The final reviewer signoff value should follow existing scope-record style but is not locked in CONTEXT.md. | Open Questions | Implementation may need maintainer confirmation before finalizing reviewer/date text. |

## Open Questions

1. **What exact reviewer signoff should the v1.13 scope section carry?**

   - What we know: Existing scope records use maintainer/date signoff rows. [VERIFIED: gcode-output-scope.md, project-file-scope.md]
   - What's unclear: CONTEXT.md does not lock the Phase 49 reviewer/date text. [VERIFIED: 49-CONTEXT.md]
   - Recommendation: Preserve the existing reviewer signoff row and add a v1.13 structural review row only when the maintainer-approved value is known. [ASSUMED: recommended planning step]

1. **Should Phase 49 lock artifact column names or only allowed evidence-field names?**

   - What we know: Phase 50 owns the checked-in structural fixture artifact. [VERIFIED: 49-CONTEXT.md]
   - What's unclear: The future TSV schema is not already present in the repo. [VERIFIED: expected-gcode-summary.tsv, prusa_gcode_output.rs]
   - Recommendation: Phase 49 should lock allowed evidence-field names, not implement the Phase 50 artifact schema. [ASSUMED: recommended boundary]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bash | Scope verifier/test scripts | yes | GNU bash 3.2.57 | none needed [VERIFIED: environment audit] |
| Bazel | `//packages/prusa-gcode-output-scope:verify` and mutation test | yes | 8.6.0 | none needed [VERIFIED: environment audit] |
| shfmt | Shell formatting check | yes | 3.12.0 | use `bash -n` plus review if unavailable [VERIFIED: environment audit] |
| shellcheck | Shell static analysis | yes | 0.11.0 | use `bash -n` plus Bazel tests if unavailable [VERIFIED: shellcheck --version] |
| mdformat | Markdown formatting check | yes | 1.0.0 | use `git diff --check` if unavailable [VERIFIED: environment audit] |
| ripgrep | Search and drift checks | yes | 15.1.0 | use `grep` if unavailable [VERIFIED: environment audit] |
| Node/GSD tools | Phase init and optional docs commit | yes | v24.13.0 | manual git commands if unavailable [VERIFIED: environment audit] |

**Missing dependencies with no fallback:** None found. [VERIFIED: environment audit]

**Missing dependencies with fallback:** None found. [VERIFIED: environment audit]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement: false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

This table uses the GSD planning taxonomy while noting that OWASP ASVS 5.0.0 is the latest stable ASVS release referenced during research. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS]

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | No authentication surface exists in this phase. [VERIFIED: .planning/ROADMAP.md, 49-CONTEXT.md] |
| V3 Session Management | no | No session surface exists in this phase. [VERIFIED: .planning/ROADMAP.md, 49-CONTEXT.md] |
| V4 Access Control | no | No authorization surface exists in this phase. [VERIFIED: .planning/ROADMAP.md, 49-CONTEXT.md] |
| V5 Input Validation | yes | Use positive allowlists for structural field names, exact TSV rows, exact row counts, and forbidden claim rejection. [VERIFIED: verify_prusa_gcode_output_scope.sh, 49-CONTEXT.md] |
| V6 Cryptography | no | Phase 49 should not add cryptographic behavior; existing checksum provenance belongs to fixture identity and Phase 50 fixture validation. [VERIFIED: fixture-provenance.tsv, 49-CONTEXT.md] |

### Known Threat Patterns for Structural Scope Contracts

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Unsupported structural field injection | Tampering | Exact allowed-field table plus row-count verification. [ASSUMED: recommended mitigation] |
| Broad generated-output overclaim | Spoofing/Repudiation | Forbidden claim rejection in README and scope plus mutation tests. [VERIFIED: reject_overclaiming_text, 49-CONTEXT.md] |
| Traceability drift to wrong source row | Tampering | Preserve exact inventory and category-map row checks. [VERIFIED: verify_inventory_inputs in verify_prusa_gcode_output_scope.sh] |
| Premature broad status promotion | Tampering/Repudiation | Keep `generated-outputs` exact `in progress` row and only reference the narrow verified fork row. [VERIFIED: packages/parity/status.tsv, .planning/REQUIREMENTS.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md` - locked decisions, discretion, deferred scope, canonical refs. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - GCSCOPE-01, GCSCOPE-02, GCSCOPE-03 and v1.13 out-of-scope boundaries. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 49 goal, dependencies, and success criteria. [VERIFIED: file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - v1.12/v1.13 state and key decisions. [VERIFIED: file read]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`, `README.md`, `verify_prusa_gcode_output_scope.sh`, `verify_prusa_gcode_output_scope_test.sh`, `BUILD.bazel` - current contract/verifier/test/package pattern. [VERIFIED: file read]
- `packages/fork-inventories/prusaslicer.tsv`, `packages/fork-inventories/category-map.tsv`, `packages/parity/status.tsv` - traceability rows. [VERIFIED: file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` - v1.12 fixture, expected summary, and provenance. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - existing pure Rust summary boundary and current expected schema. [VERIFIED: file read]
- Local verification commands: `bash -n`, `bazel run //packages/prusa-gcode-output-scope:verify`, `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`. [VERIFIED: command execution]

### Secondary (MEDIUM confidence)

- Bright Builds standards entrypoint and pages: architecture, code shape, verification, testing, Rust. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/index.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md]
- OWASP ASVS project pages for current ASVS context. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS]

### Tertiary (LOW confidence)

- Recommended exact field names are not yet repo-verified because Phase 49 owns creating the contract. [ASSUMED: researcher recommendation]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - no new dependencies; current tools and package targets are verified locally. [VERIFIED: environment audit, BUILD.bazel]
- Architecture: HIGH for package placement and verifier/test style because locked decisions and existing code agree; MEDIUM for exact new helper names because they are implementation recommendations. [VERIFIED: 49-CONTEXT.md, verify_prusa_gcode_output_scope.sh] [ASSUMED: helper boundaries]
- Pitfalls: HIGH for overclaiming and traceability drift because requirements and existing verifier checks directly encode them; MEDIUM for exact unsupported-field failure shape until Phase 49 implements the closed table. [VERIFIED: .planning/REQUIREMENTS.md, verify_prusa_gcode_output_scope.sh] [ASSUMED: row-count mitigation]

**Research date:** 2026-06-16 [VERIFIED: system date]
**Valid until:** 2026-07-16 for internal repo patterns; re-check external standards pages if security taxonomy matters after that date. [ASSUMED: stability estimate]
