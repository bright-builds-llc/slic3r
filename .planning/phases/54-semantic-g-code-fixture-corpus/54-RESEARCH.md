# Phase 54: Semantic G-code Fixture Corpus - Research

**Researched:** 2026-06-21 [VERIFIED: environment current date]
**Domain:** Static Prusa G-code semantic fixture corpus, TSV schema, Bash/Bazel fail-closed verification [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture; bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test]

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

## Implementation Decisions

### Fixture corpus shape

- **D-01:** Keep the Phase 54 corpus inside the existing
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`
  namespace. This preserves the Phase 46 marker summary and Phase 50
  structural sidecar chain for the same source-pinned fixture.
- **D-02:** Add the semantic expected summary as
  `expected-gcode-semantic-summary.tsv`, matching the Phase 53 planned artifact
  name exactly.
- **D-03:** Use the existing `gcodewriter-set-speed.gcode` fixture and accepted
  PrusaSlicer source identity:
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
  Do not add generated fixtures, downloaded fixtures, imported upstream trees,
  or new fixture sources.

### Semantic summary schema and values

- **D-04:** The semantic summary must be TSV-friendly, source-pinned, and
  restricted to the Phase 53 closed field set: `source_ref`, `fixture_id`,
  `fixture_path`, `command_class_counts`, `movement_class_counts`,
  `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, and
  `layer_marker_relationships`.
- **D-05:** The semantic artifact should include exactly one reviewed row for
  each approved semantic field. Missing, duplicate, unsupported, and
  out-of-order rows should fail closed.
- **D-06:** Semantic values should stay narrow for the selected speed-command
  fixture: command and movement class counts, absent coordinate/extrusion
  observations when the fixture has no axes, feedrate observations derived from
  the four checked-in `G1 F...` lines, and explicit layer/marker relationship
  absence. Avoid names or notes that imply toolpath geometry, timing,
  material-use, runtime, firmware, printability, GUI, support, seam, arc, or
  byte-for-byte parity.
- **D-07:** Each row must carry an evidence boundary that explains the
  observation as fixture-summary evidence only, not broad generated-output or
  printer-runtime behavior.

### Verifier and mutation coverage

- **D-08:** Extend `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`
  instead of creating a new verifier package. The verifier should read the
  semantic summary alongside the existing marker and structural summaries.
- **D-09:** The verifier must check the exact semantic header, exact row count,
  allowed field set, required field counts, source/fixture provenance alignment,
  exact expected rows or exact expected values, README provenance text, and
  forbidden broad-claim text.
- **D-10:** Extend `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
  with focused mutation cases for semantic drift: missing rows, duplicate rows,
  out-of-order rows, unsupported fields, unsupported broad-behavior claims, and
  provenance mismatch. Keep each test focused on one behavior with Arrange,
  Act, Assert sections.
- **D-11:** Wire the new semantic summary into `packages/parity-fixtures/BUILD.bazel`
  as a checked-in exported fixture and into the existing fixture verifier target.

### Documentation and boundaries

- **D-12:** Update the fixture README to name the semantic expected artifact,
  explain that Phase 54 adds semantic fixture expectations, and keep the
  update route tied to reviewed intake changes through fork vendor, inventory,
  and scope records.
- **D-13:** Keep `packages/parity-fixtures/README.md` package-level wording
  narrow: fixture verification checks checked-in artifacts and must not fetch,
  generate, upload, or execute runtime behavior.
- **D-14:** Do not update `packages/parity/status.tsv`, public parity command
  behavior, Rust parser crates, or public port docs in this phase. Those belong
  to Phase 55 and Phase 56.

### the agent's Discretion

- Choose exact Bash helper names and constant organization in the existing
  fixture verifier, provided the verifier remains readable, exact, and
  fail-closed.
- Choose the exact semantic row wording and category names, provided every row
  maps cleanly to a Phase 53 allowed field and avoids broad behavior claims.
- Choose whether semantic expected rows are validated by one exact multiline
  constant or field-specific expected values, provided unsupported, duplicate,
  missing, out-of-order, and provenance-drift cases are covered.

### Deferred Ideas (OUT OF SCOPE)

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
| GSFIX-01 | Maintainer can inspect a small reviewed Prusa G-code semantic fixture corpus with source-pinned provenance, update rules, fixture identity, expected semantic summary paths, and explicit exclusion of generator, runtime, network, sync, host-upload, post-processing, thumbnail, printability, and GUI behavior. [VERIFIED: .planning/REQUIREMENTS.md] | Add one semantic TSV beside existing fixture artifacts, update fixture README and package README narrowly, and preserve reviewed intake/update-route wording. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; packages/parity-fixtures/README.md] |
| GSFIX-02 | Maintainer can inspect checked-in semantic expected summaries that cover only the Phase 53 approved fields, such as command classes, movement classes, coordinate bounds, extrusion totals, feedrate observations, layer or marker relationships, and fixture/source identities. [VERIFIED: .planning/REQUIREMENTS.md] | Use exactly the nine Phase 53 semantic fields and one reviewed row per field in `expected-gcode-semantic-summary.tsv`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/53-semantic-g-code-scope-contract/53-VERIFICATION.md] |
| GSFIX-03 | Maintainer can run fail-closed fixture verification that rejects missing rows, duplicate rows, out-of-order rows, unsupported semantic fields, unsupported claim text, wrong source refs, wrong fixture identities, and stale documentation references. [VERIFIED: .planning/REQUIREMENTS.md] | Extend the existing `verify_prusa_gcode_output_fixture.sh` and isolated mutation harness rather than adding a new verifier. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and pinned Bright Builds standards before planning, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Keep `.planning/phases/*/*-SUMMARY.md` YAML frontmatter field `requirements-completed` exact when editing summaries; Phase 54 research does not edit summaries. [VERIFIED: AGENTS.md]
- Do not run `mdformat` over phase `*-SUMMARY.md` files; Phase 54 research writes `54-RESEARCH.md`, not a summary. [VERIFIED: AGENTS.md]
- Prefer exact repo-owned verification entrypoints before low-level commands. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Tests should focus on one concern and clearly delineate Arrange, Act, Assert. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Prefer early returns, small helpers, and language-native guard constructs in script edits. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- The pinned Bright Builds index at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` lists Rust and TypeScript/JavaScript language pages, but no Bash language-specific page was available at `standards/languages/bash.md`; use repo/global Bash guidance plus core standards for Bash changes. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md; VERIFIED: curl returned 404 for standards/languages/bash.md]
- Bash/Zsh scripts should use `#!/usr/bin/env bash`, `set -euo pipefail`, early returns, and functions for clarity. [VERIFIED: AGENTS.md]
- Rust pre-commit rules apply to Rust implementation commits, but Phase 54 is scoped to TSV, Markdown, Bash, and Bazel fixture work with no Rust parser changes. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; rg --files -g Cargo.toml]
- No repo-local `.claude/skills/` or `.agents/skills/` skill files were found. [VERIFIED: find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md -print]

## Summary

Phase 54 is a codebase-internal fixture-corpus phase, not an ecosystem/library selection phase. The planner should keep the work inside the existing Prusa G-code output fixture namespace, add one checked-in semantic sidecar named `expected-gcode-semantic-summary.tsv`, and extend the existing Bash/Bazel verifier and mutation test rather than introducing Rust parsing or public parity/status publication. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; .planning/ROADMAP.md]

The approved semantic field set is already closed by Phase 53 and has exactly nine rows: `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`, `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, and `layer_marker_relationships`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/53-semantic-g-code-scope-contract/53-VERIFICATION.md] The selected fixture contains exactly four feedrate-only `G1 F...` lines and no movement or extrusion axes, so semantic rows should record feedrate command observations and explicit absence of coordinate, extrusion, and layer-marker relationships without implying toolpath geometry, timing, material-use, runtime, firmware, printability, GUI, support, seam, arc, or byte parity. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

The implementation should preserve the existing evidence ladder: marker summary from Phase 46, structural sidecar from Phase 50, semantic sidecar in Phase 54, Rust semantic boundary in Phase 55, and public semantic evidence/status/docs in Phase 56. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md; packages/parity-fixtures/README.md] The current fixture verifier and mutation suite pass before Phase 54 changes, giving the planner a clean baseline. [VERIFIED: bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture; bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test]

**Primary recommendation:** Add the semantic TSV and README/Bazel wiring first, then extend the existing fixture verifier with exact semantic header, exact ordered rows, allowed-field and one-row-per-field checks, provenance alignment, README/package text checks, forbidden broad-claim rejection, and focused mutation tests. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

## Standard Stack

### Core

| Tool/Format | Version | Purpose | Why Standard |
|-------------|---------|---------|--------------|
| Bash verifier script | GNU bash 3.2.57 on this host | Validate checked-in fixture docs, TSVs, G-code bytes, provenance, status boundary, and forbidden text. [VERIFIED: bash --version; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] | Existing fixture verification package is Bash/Bazel-owned and already enforces marker and structural artifacts exactly. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/BUILD.bazel] |
| Bazel | 8.6.0 | Own runnable verifier and mutation test targets. [VERIFIED: bazel --version; packages/parity-fixtures/BUILD.bazel] | Existing Prusa G-code fixture verifier is already wired as `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` and test target. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| TSV sidecar artifacts | repo-local static text | Carry reviewed source-pinned expected summaries. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv] | Existing marker and structural expected artifacts are TSVs under the same fixture namespace. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md] |
| Markdown README boundaries | repo-local static text | Expose provenance, update route, status boundary, and deferred scope. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; packages/parity-fixtures/README.md] | Existing fixture verifier already checks required README text and overclaim absence. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| awk | available at `/usr/bin/awk`; GNU `-W version` unsupported | TSV column, field, provenance, and row-count checks. [VERIFIED: command -v awk; awk -W version] | Use for exact tab-delimited checks already present in structural verifier helpers. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| grep | BSD grep 2.6.0-FreeBSD | Required/forbidden text checks and exact-row presence. [VERIFIED: grep --version] | Use existing `grep -Fq`, `grep -Fxq`, and `grep -Eq` patterns for portability. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| shasum | 6.02 | SHA-256 fixture byte guard. [VERIFIED: shasum --version] | Keep existing checksum verification for the G-code fixture; do not implement hashing logic. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| mktemp/cp/sed/chmod | macOS system tools available | Isolated mutation-test fixture trees and targeted file edits inside tests. [VERIFIED: command -v mktemp cp sed chmod] | Use existing mutation harness helpers instead of mutating source artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Existing Bash fixture verifier | New verifier package | Rejected because Phase 54 explicitly requires extending `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| Static TSV sidecar | Generated semantic summary | Rejected because Phase 54 must not add generated fixtures, downloaded fixtures, runtime generation, network, or sync behavior. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; .planning/REQUIREMENTS.md] |
| Bash exact checks | Rust semantic parser | Deferred because Phase 55 owns pure typed Rust semantic parsing/readiness. [VERIFIED: .planning/ROADMAP.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| Current parity command/status docs | Public semantic evidence publication | Deferred because Phase 56 owns public semantic parity evidence, status wording, and docs. [VERIFIED: .planning/ROADMAP.md; packages/parity/status.tsv] |

**Installation:** No package installation is needed for Phase 54; use the existing repo and host tools. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; command -v awk sed wc mktemp cp chmod printf sort comm cut tr basename dirname shasum bazel bash node rg grep]

**Version verification:** No npm package versions apply. Host versions verified were Bash 3.2.57, Bazel 8.6.0, Node v24.13.0, ripgrep 15.1.0, BSD grep 2.6.0-FreeBSD, and shasum 6.02. [VERIFIED: bash --version; bazel --version; node --version; rg --version; grep --version; shasum --version]

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity-fixtures/
|-- BUILD.bazel
|-- README.md
|-- verify_prusa_gcode_output_fixture.sh
|-- verify_prusa_gcode_output_fixture_test.sh
`-- forks/prusaslicer/prusaslicer.gcode-output/
    |-- README.md
    |-- fixture-provenance.tsv
    |-- gcodewriter-set-speed.gcode
    |-- expected-gcode-summary.tsv
    |-- expected-gcode-structural-summary.tsv
    `-- expected-gcode-semantic-summary.tsv
```

This structure keeps Phase 54 inside the existing Prusa G-code output fixture namespace and adds only the semantic sidecar artifact. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

### Pattern 1: Additive Sidecar TSV

**What:** Add `expected-gcode-semantic-summary.tsv` beside the marker and structural summaries with a six-column schema aligned to the structural sidecar shape: `source_ref`, `fixture_path`, `semantic_field`, `semantic_category`, `semantic_value`, `evidence_boundary`. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**When to use:** Use this shape for Phase 54 because the structural sidecar already uses source ref, fixture path, field name, category, value, and evidence boundary columns, and Phase 54 requires source-pinned TSV-friendly rows with evidence boundaries. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Recommended row ordering:** `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`, `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, `layer_marker_relationships`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Example:**

```text
source_ref	fixture_path	semantic_field	semantic_category	semantic_value	evidence_boundary
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	feedrate_observations	feedrate observations	F99999.123;F1;F203.2;F203.201	Feedrate metadata only from the selected fixture summary; no timing, firmware, or printer-runtime behavior claim.
```

Source for the schema pattern is the structural sidecar; source for allowed field names is the Phase 53 semantic scope. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv; packages/prusa-gcode-output-scope/gcode-output-scope.md]

### Pattern 2: Exact Bash Verification

**What:** Add semantic constants near existing structural constants, then mirror the structural verification flow with exact header, column count, allowed field set, field counts, provenance alignment, exact values/rows, line count, README text, and overclaim rejection. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**When to use:** Use this pattern because the current verifier already applies it to structural rows and the Phase 54 context requires missing, duplicate, unsupported, out-of-order, provenance-drift, doc-drift, and broad-claim cases to fail closed. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Example:**

```bash
readonly SEMANTIC_SUMMARY_HEADER=$'source_ref\tfixture_path\tsemantic_field\tsemantic_category\tsemantic_value\tevidence_boundary'
readonly SEMANTIC_REQUIRED_FIELDS="source_ref fixture_id fixture_path command_class_counts movement_class_counts coordinate_bounds extrusion_total feedrate_observations layer_marker_relationships"

verify_semantic_summary() {
	require_exact_header "${semantic_summary_file}" "expected-gcode-semantic-summary.tsv" "${SEMANTIC_SUMMARY_HEADER}"
	require_semantic_column_count
	require_semantic_allowed_fields
	require_semantic_field_counts
	require_semantic_provenance_alignment
	require_semantic_exact_rows
	require_line_count "${semantic_summary_file}" "expected-gcode-semantic-summary.tsv" "10"
}
```

This example is a recommended adaptation of the existing structural helper pattern, not an existing implementation. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

### Pattern 3: Isolated Mutation Tests

**What:** Extend `write_valid_fixture_copy` to copy the semantic TSV and extend `run_verifier` to pass it to the verifier, then add one focused test per semantic failure mode. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**When to use:** Use isolated temp fixture trees because existing tests prove negative cases without mutating checked-in source artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Example:**

```bash
test_duplicate_semantic_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-semantic-row"
	local semantic_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
	write_valid_fixture_copy "${dir}"
	local duplicate_row
	duplicate_row="$(awk -F '\t' '$3 == "feedrate_observations" { print; exit }' "${semantic_file}")"
	printf '%s\n' "${duplicate_row}" >>"${semantic_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-semantic-row.out" "${tmp_dir}/duplicate-semantic-row.err"; then
		fail "duplicate semantic row fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/duplicate-semantic-row.err" "feedrate_observations" "duplicate" "expected-gcode-semantic-summary.tsv"
}
```

This example follows the existing mutation-test helper style and Arrange/Act/Assert requirement. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

### Anti-Patterns to Avoid

- **Creating a new verifier package:** Phase 54 explicitly says to extend the existing fixture verifier. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
- **Adding Rust parsing in Phase 54:** Phase 55 owns the Rust semantic parser/readiness boundary. [VERIFIED: .planning/ROADMAP.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
- **Publishing public parity/status/docs now:** Phase 56 owns public semantic parity evidence and status/docs publication. [VERIFIED: .planning/ROADMAP.md; packages/parity/status.tsv]
- **Inferring geometry or print behavior from feedrate-only lines:** The fixture has four `G1 F...` feedrate lines and no coordinate or extrusion axes. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode]
- **Relying on presence-only checks:** Existing structural verification uses exact rows, allowed fields, field counts, provenance alignment, and exact line counts. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Semantic parsing | A Rust or Bash G-code parser | Static reviewed TSV rows for this phase | Phase 54 only creates fixture expectations; Phase 55 owns Rust semantic parsing. [VERIFIED: .planning/ROADMAP.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| Fixture generation | A generator that emits expected summaries from G-code | Checked-in reviewed `expected-gcode-semantic-summary.tsv` | Phase 54 forbids generated/downloaded fixtures and runtime/generator behavior. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; .planning/REQUIREMENTS.md] |
| External source refresh | Git/network/downloader logic | Existing reviewed intake/update route text | Current fixture provenance ties updates to reviewed intake changes and branch-head observations remain drift-only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] |
| New verification surface | Separate verifier binary/package | Existing `verify_prusa_gcode_output_fixture.sh` and Bazel target | Existing target already owns marker and structural fixture checks. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Public status promotion | Direct edits to `packages/parity/status.tsv` | No status/doc publication in Phase 54 | Current status row remains structural-only and semantic publication is Phase 56-owned. [VERIFIED: packages/parity/status.tsv; .planning/ROADMAP.md] |
| Hashing/checksum logic | Custom checksum implementation | Existing `shasum -a 256` helper | The current verifier already checks SHA-256 via `shasum`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

**Key insight:** The hard part is not computing semantics; it is preventing a small static fixture from becoming an accidental broad generated-output claim. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/prusa-gcode-output-scope/gcode-output-scope.md]

## Common Pitfalls

### Pitfall 1: Schema Drift Hidden by Loose Checks

**What goes wrong:** A semantic TSV with a wrong header, extra column, unsupported field, missing row, duplicate row, or reordered row can still look human-readable. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Why it happens:** Presence checks catch a field somewhere in the file but do not prove the closed contract or order. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**How to avoid:** Require exact header, six-column rows, exact line count of 10, one row per required field, no unsupported fields, and exact ordered rows or an exact multiline constant. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Warning signs:** A test appends a semantic row and the verifier still passes, or a row swap does not fail. [VERIFIED: .planning/REQUIREMENTS.md]

### Pitfall 2: Provenance Mismatch

**What goes wrong:** The semantic rows can use the right field names but the wrong `source_ref`, fixture path, fixture ID, or source identity value. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv]

**Why it happens:** TSV rows duplicate provenance across every row, so one drifted row can sever the evidence chain. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv]

**How to avoid:** Add `require_semantic_provenance_alignment` and exact value checks for `source_ref`, `fixture_id`, and `fixture_path`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Warning signs:** A mutation that changes only the first column or the `fixture_id` semantic value passes. [VERIFIED: .planning/REQUIREMENTS.md]

### Pitfall 3: Broad Semantic Overclaims

**What goes wrong:** README or TSV evidence text can imply byte parity, generated-output parity, geometry/toolpath correctness, timing, runtime, firmware, printability, GUI, support, seam, or arc behavior. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/prusa-gcode-output-scope/gcode-output-scope.md]

**Why it happens:** Semantic field names are closer to real toolpath behavior than structural marker counts, so wording can accidentally overstate the evidence. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/PROJECT.md]

**How to avoid:** Keep evidence boundaries explicit and add semantic summary to the overclaim scan. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

**Warning signs:** Text says "verified", "parity", "toolpath", "printability", or "runtime" near semantic observations without a deferred-scope qualifier. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/gcode-output-scope.md]

### Pitfall 4: Forgetting Bazel Data Wiring

**What goes wrong:** The semantic TSV exists in the source tree but is absent from `exports_files`, the `prusa_gcode_output_bundle`, or verifier/test `data`. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

**Why it happens:** Existing G-code fixture files are listed in multiple Bazel sections. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

**How to avoid:** Add `expected-gcode-semantic-summary.tsv` to `exports_files`, an alias, `prusa_gcode_output_bundle`, the verifier `data`, the test `data`, and `package_boundary`. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

**Warning signs:** `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` works locally by default path but fails or cannot find the semantic file under Bazel runfiles. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### Pitfall 5: Mutation Harness Not Passing the New File

**What goes wrong:** The valid temp fixture copy omits the semantic TSV, or `run_verifier` passes old positional arguments, so tests do not exercise the new file. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Why it happens:** The verifier currently accepts either default paths or an explicit argument list that includes marker and structural summaries but not a semantic summary. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**How to avoid:** Update usage text, default path setup, explicit argument count, `write_valid_fixture_copy`, and `run_verifier` together. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Warning signs:** New semantic mutation tests fail with file-not-found or usage errors rather than semantic diagnostics. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

### Pitfall 6: GNU-Only Shell Assumptions on macOS

**What goes wrong:** A verifier edit uses GNU-only `sed`, `awk`, or `grep` behavior and fails on the current macOS toolchain. [VERIFIED: sed --version output; awk -W version output; grep --version output]

**Why it happens:** The current host has BSD/macOS `sed`, BSD-compatible `grep`, and an `awk` that does not accept GNU `-W version`. [VERIFIED: sed --version output; grep --version; awk -W version]

**How to avoid:** Reuse existing portable `awk -F '\t'`, `grep -Fq`, `grep -Fxq`, `grep -Eq`, `wc`, `tr`, and `shasum` patterns. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Warning signs:** A command works manually with GNU tools but fails under Bazel on this host. [VERIFIED: bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test]

## Code Examples

Verified patterns from existing repo sources:

### Exact Header and Row Count

```bash
require_exact_header "${semantic_summary_file}" "expected-gcode-semantic-summary.tsv" "${SEMANTIC_SUMMARY_HEADER}"
require_line_count "${semantic_summary_file}" "expected-gcode-semantic-summary.tsv" "10"
```

Use the existing `require_exact_header` and `require_line_count` helper style for the semantic summary. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### Allowed Semantic Fields

```bash
awk -F '\t' -v label="expected-gcode-semantic-summary.tsv" '
	NR == 1 { next }
	$3 != "source_ref" &&
		$3 != "fixture_id" &&
		$3 != "fixture_path" &&
		$3 != "command_class_counts" &&
		$3 != "movement_class_counts" &&
		$3 != "coordinate_bounds" &&
		$3 != "extrusion_total" &&
		$3 != "feedrate_observations" &&
		$3 != "layer_marker_relationships" {
		printf "error: %s: unsupported semantic field: %s\n", label, $3 > "/dev/stderr"
		exit 1
	}
' "${semantic_summary_file}"
```

This is a recommended semantic adaptation of the existing structural allowed-field helper. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/gcode-output-scope.md]

### Field Count Guard

```bash
awk -F '\t' \
	-v label="expected-gcode-semantic-summary.tsv" \
	-v required_fields="${SEMANTIC_REQUIRED_FIELDS}" '
	BEGIN { required_count = split(required_fields, required, " ") }
	NR == 1 { next }
	{ counts[$3]++ }
	END {
		failed = 0
		for (i = 1; i <= required_count; i++) {
			field = required[i]
			actual = counts[field] + 0
			if (actual == 1) { continue }
			if (actual > 1) {
				printf "error: %s: duplicate semantic field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
			} else {
				printf "error: %s: missing semantic field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
			}
			failed = 1
		}
		exit failed
	}
' "${semantic_summary_file}"
```

This is a recommended semantic adaptation of the existing structural field-count helper. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### README Required Text

```bash
require_text "${fixture_readme}" "fixture README" "Semantic expected artifact: \`expected-gcode-semantic-summary.tsv\`"
require_text "${fixture_readme}" "fixture README" "Phase 54 adds \`expected-gcode-semantic-summary.tsv\` as a semantic sidecar"
require_text "${package_readme}" "packages/parity-fixtures/README.md" "Fixture verification does not fetch upstream source"
```

The exact README wording can differ, but the verifier must require semantic artifact discoverability and keep the package no-fetch boundary. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/parity-fixtures/README.md; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Marker-only G-code expected summary | Marker summary plus structural sidecar | Phase 50, shipped in v1.13 | Phase 54 should extend the sidecar chain rather than reinterpret marker rows. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; .planning/STATE.md] |
| Structural evidence only for public fork row | Planned semantic sidecar before Rust semantic parsing and public semantic evidence | Phase 54 in v1.14 | Phase 54 should not change `packages/parity/status.tsv`; the current fork row remains structural-only. [VERIFIED: packages/parity/status.tsv; .planning/ROADMAP.md] |
| Scope contract only for semantic fields | Checked-in semantic fixture corpus with fail-closed drift guards | Phase 54 | The planner must turn the Phase 53 nine-field contract into a source-pinned TSV artifact and verifier coverage. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/REQUIREMENTS.md] |

**Deprecated/outdated:**

- Treating `expected-gcode-summary.tsv` as sufficient semantic evidence is outdated for v1.14 because Phase 54 specifically adds `expected-gcode-semantic-summary.tsv`. [VERIFIED: .planning/ROADMAP.md; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
- Treating `fork.prusaslicer.gcode-output` as semantic public evidence is premature because the current status row publishes only the narrow structural evidence slice. [VERIFIED: packages/parity/status.tsv; .planning/ROADMAP.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | All substantive claims in this research were verified from repo files, command output, or pinned Bright Builds standards. [VERIFIED: Sources section] | N/A | N/A |

## Open Questions

1. **Exact semantic value wording**
   - What we know: The field set, artifact name, fixture source, and no-overclaiming boundaries are locked. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
   - What's unclear: The exact `semantic_value` and `evidence_boundary` prose is intentionally left to the agent's discretion. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
   - Recommendation: Use the structural sidecar's six-column schema and keep values narrow: `G1:4;feedrate_only:4`, no movement classes, no coordinate axes, no extrusion axis, feedrates `F99999.123;F1;F203.2;F203.201`, and no layer markers. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bash | Verifier and mutation scripts | yes | 3.2.57 | None needed. [VERIFIED: bash --version] |
| Bazel | Verifier/test targets | yes | 8.6.0 | None needed. [VERIFIED: bazel --version] |
| awk | TSV validation helpers | yes | version flag unsupported | Use existing POSIX-style awk patterns. [VERIFIED: command -v awk; awk -W version; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| sed | Mutation-test text edits | yes | version flag unsupported | Use existing simple `sed -n` diagnostics and prefer existing awk helpers for rewrites. [VERIFIED: command -v sed; sed --version output; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |
| grep | Required/forbidden text checks | yes | BSD grep 2.6.0-FreeBSD | None needed. [VERIFIED: grep --version] |
| shasum | Fixture checksum guard | yes | 6.02 | None needed. [VERIFIED: shasum --version] |
| mktemp/cp/chmod/wc/tr/basename/dirname | Mutation harness and verifier plumbing | yes | system tools | None needed. [VERIFIED: command -v awk sed wc mktemp cp chmod printf sort comm cut tr basename dirname shasum bazel bash node rg grep] |
| Node | GSD tooling and phase metadata | yes | v24.13.0 | None needed. [VERIFIED: node --version; node /Users/peterryszkiewicz/.codex/get-shit-done/bin/gsd-tools.cjs init phase-op 54] |

**Missing dependencies with no fallback:** None found. [VERIFIED: command -v awk sed wc mktemp cp chmod printf sort comm cut tr basename dirname shasum bazel bash node rg grep]

**Missing dependencies with fallback:** None found. [VERIFIED: command -v awk sed wc mktemp cp chmod printf sort comm cut tr basename dirname shasum bazel bash node rg grep]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | Phase 54 adds static fixture artifacts and local verifier checks only, with no authentication surface. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| V3 Session Management | no | Phase 54 adds no session or runtime service behavior. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| V4 Access Control | no | Phase 54 adds no user/role authorization surface. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| V5 Input Validation | yes | Use exact TSV header, column count, allowed field set, row count, provenance alignment, and forbidden-text checks. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/REQUIREMENTS.md] |
| V6 Cryptography | limited | Use existing SHA-256 verification through `shasum -a 256`; do not hand-roll hashes. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

### Known Threat Patterns for Static Fixture Verification

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Fixture/provenance tampering | Tampering | Exact checksum, byte count, source ref, fixture path, and TSV row checks. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] |
| Unsupported broad claims entering docs or TSVs | Tampering/Repudiation | Add semantic TSV to forbidden-claim scanning and require deferred-scope README text. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |
| Runtime/network behavior sneaking into fixture verification | Elevation of privilege/Information disclosure | Preserve verifier self-scan for forbidden behavior terms and keep package README no-fetch/no-runtime boundary. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/README.md] |
| Stale public status publication | Repudiation | Do not update `packages/parity/status.tsv` in Phase 54; keep current row structural-only. [VERIFIED: packages/parity/status.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md` - locked Phase 54 decisions, boundaries, and discretion areas. [VERIFIED: cat]
- `.planning/ROADMAP.md` - Phase 54 goal, success criteria, dependencies, and Phase 55/56 boundaries. [VERIFIED: cat]
- `.planning/REQUIREMENTS.md` - GSFIX-01, GSFIX-02, GSFIX-03, and v1.14 out-of-scope boundaries. [VERIFIED: cat]
- `.planning/STATE.md` and `.planning/PROJECT.md` - current milestone state and accumulated Prusa G-code evidence-chain decisions. [VERIFIED: cat]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - Phase 53 approved nine semantic fields and traceability. [VERIFIED: cat]
- `.planning/phases/53-semantic-g-code-scope-contract/53-VERIFICATION.md` - evidence that Phase 53 semantic scope passed with exactly nine approved rows. [VERIFIED: cat]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` - existing fixture, provenance, marker summary, structural sidecar, README, and line-ending attributes. [VERIFIED: cat]
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` and `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` - existing verifier and mutation-test patterns. [VERIFIED: cat]
- `packages/parity-fixtures/BUILD.bazel` - fixture exports, bundle, verifier, test, and package boundary wiring. [VERIFIED: cat]
- `packages/parity/status.tsv` - current structural-only public fork row and broad `generated-outputs` in-progress row. [VERIFIED: cat]
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` - baseline fixture verifier passed. [VERIFIED: command output]
- `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test` - baseline mutation suite passed. [VERIFIED: command output]

### Secondary (MEDIUM confidence)

- Bright Builds standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`, `standards/core/verification.md`, `standards/core/testing.md`, and `standards/core/code-shape.md`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Host tool availability and versions from `bash --version`, `bazel --version`, `node --version`, `rg --version`, `grep --version`, `shasum --version`, and `command -v ...`. [VERIFIED: command output]

### Tertiary (LOW confidence)

- None. [VERIFIED: all research inputs came from repo files, pinned standards, or local command output]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - Phase 54 uses existing repo-owned Bash/Bazel/TSV patterns and no new external libraries. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]
- Architecture: HIGH - The target namespace, artifact name, verifier extension point, and out-of-scope boundaries are locked in Phase 54 context. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md]
- Pitfalls: HIGH - Existing structural verifier and mutation tests show the exact failure modes Phase 54 should mirror. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]
- Security: MEDIUM - Static artifact threat patterns are clear, but formal ASVS mapping is inferred from the absence of runtime/auth/network surfaces and the presence of TSV/input validation checks. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Research date:** 2026-06-21 [VERIFIED: environment current date]
**Valid until:** 2026-07-21 for this repo-internal phase, unless Phase 54 context or Phase 53 semantic scope changes first. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md; packages/prusa-gcode-output-scope/gcode-output-scope.md]
