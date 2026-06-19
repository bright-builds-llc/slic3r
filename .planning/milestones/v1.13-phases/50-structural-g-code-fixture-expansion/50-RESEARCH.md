# Phase 50: Structural G-code Fixture Expansion - Research

**Researched:** 2026-06-17 [VERIFIED: system date and phase init]
**Domain:** Internal Prusa G-code fixture expansion, structural TSV contract, Bash verifier, Bazel sh_test mutation coverage [VERIFIED: .planning/ROADMAP.md, .planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md, packages/parity-fixtures/BUILD.bazel]
**Confidence:** HIGH [VERIFIED: current fixture verifier, fixture mutation test, and Phase 49 scope mutation test passed locally]

<user_constraints>

## User Constraints (from CONTEXT.md)

All bullets in this section are copied verbatim from `.planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md`. [VERIFIED: .planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md]

### Locked Decisions

#### Structural summary artifact

- **D-01:** Add a separate checked-in sidecar artifact named
  `expected-gcode-structural-summary.tsv` under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
  Keep the existing `expected-gcode-summary.tsv` unchanged so the v1.12
  summary-only Rust parser and Phase 48 parity command remain stable.
- **D-02:** Use an exact structural TSV schema:
  `source_ref`, `fixture_path`, `structural_field`, `structural_category`,
  `structural_value`, and `evidence_boundary`.
- **D-03:** Represent the Phase 49 closed structural field set as exactly 16
  required rows. The field names must be:
  `source_ref`, `inventory_source_paths`, `fixture_source_literal`,
  `fixture_id`, `fixture_path`, `command_count_total`, `command_count_g1`,
  `section_count_total`, `ordered_marker_1`, `ordered_marker_2`,
  `ordered_marker_3`, `ordered_marker_4`, `movement_axis_present`,
  `extrusion_axis_present`, `temperature_marker_count`, and
  `tool_change_marker_count`.
- **D-04:** Use concrete structural values for the selected fixture:
  source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source paths `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`, source
  literal `tests/fff_print/test_gcodewriter.cpp#L20-L35`, fixture ID
  `gcodewriter-set-speed.gcode`, four total commands, four `G1` commands, one
  selected fixture section, the four ordered `G1 F...` markers from the
  checked-in fixture, `false` movement and extrusion axis indicators, and zero
  temperature/tool-change markers.
- **D-05:** Keep bytes, SHA-256, update route, and source provenance in
  `fixture-provenance.tsv` and README text, not in the structural summary
  artifact. The structural summary should describe allowed structural evidence,
  not file integrity metadata or public status publication.

#### Fixture verifier ownership

- **D-06:** Extend the existing
  `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` target and
  `verify_prusa_gcode_output_fixture.sh` instead of creating a new structural
  fixture verifier or moving checks into `packages/prusa-gcode-output-scope`.
  The fixture package owns fixture bytes and expected artifacts; the scope
  package remains the metadata-only contract source.
- **D-07:** The verifier must check the structural summary header, exact 16
  rows, required field names, row count, duplicate field rejection,
  source_ref/fixture_path alignment, provenance/update-route alignment, and
  the existing no-overclaiming boundaries.
- **D-08:** Wire the new structural TSV into `packages/parity-fixtures/BUILD.bazel`
  exports, the `prusa_gcode_output_bundle`, the verifier data, and the package
  boundary filegroup so Bazel owns the artifact.
- **D-09:** Update the fixture README and package README only enough to make the
  Phase 50 structural artifact and verification command inspectable. Avoid
  broad doc rewrites and do not update public parity/status wording beyond
  preserving the existing narrow status boundary.

#### Mutation coverage

- **D-10:** Use a balanced mutation suite in
  `verify_prusa_gcode_output_fixture_test.sh`: valid fixture passes, then one
  focused negative case for each GCFIX-03 failure class.
- **D-11:** Required negative cases are structural value drift, missing
  required structural row, duplicate structural row, unsupported structural
  field, unsupported broad-behavior claim in fixture-owned text or structural
  notes, and provenance mismatch between the structural summary and
  `fixture-provenance.tsv`.
- **D-12:** Keep mutation tests in the existing temp-checkout style, with each
  test proving one behavior and asserting a diagnostic that points at the
  failing artifact or structural field.

#### Scope and status boundaries

- **D-13:** Carry forward Phase 49's additive structural scope contract without
  re-litigating field names or broad deferrals.
- **D-14:** Preserve the current `fork.prusaslicer.gcode-output` status row as
  the narrow summary-only Prusa G-code evidence slice. Phase 50 may strengthen
  fixture evidence but must not promote `generated-outputs` or claim structural
  executable parity.

### the agent's Discretion

- Choose exact Bash helper names and constant layout inside
  `verify_prusa_gcode_output_fixture.sh`, as long as the verifier remains
  readable, exact, and fail-closed.
- Choose whether the structural expected rows are represented as individual
  constants or a compact loop-friendly list, provided failure diagnostics stay
  clear.
- Choose exact README phrasing for Phase 50, provided it keeps the structural
  fixture expansion narrow and does not blur Phase 51 or Phase 52 ownership.

### Deferred Ideas (OUT OF SCOPE)

- Phase 51 owns parsing `expected-gcode-structural-summary.tsv` through a pure
  typed Rust boundary and deciding the internal Rust data model.
- Phase 52 owns public structural parity/status/docs publication.
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
| GCFIX-01 | Maintainer can inspect a source-pinned Prusa G-code fixture expansion with a checked-in expected structural summary artifact for the accepted Prusa `set_speed` G-code evidence slice. [VERIFIED: .planning/REQUIREMENTS.md] | Add `expected-gcode-structural-summary.tsv` beside the existing fixture artifact, keep `expected-gcode-summary.tsv` unchanged, and populate exactly the 16 locked Phase 49 structural fields. [VERIFIED: 50-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md, packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv] |
| GCFIX-02 | Maintainer can run a Bazel-owned fixture verifier that checks the exact structural summary schema, required rows, provenance, and update rules. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `verify_prusa_gcode_output_fixture.sh` and `//packages/parity-fixtures:verify_prusa_gcode_output_fixture`; wire the new TSV into `exports_files`, aliases, bundle, verifier data, and package boundary filegroup. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/BUILD.bazel, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| GCFIX-03 | Maintainer can see fixture mutation tests fail closed for structural summary drift, missing rows, duplicate rows, unsupported fields, unsupported broad-behavior claims, and provenance mismatch. [VERIFIED: .planning/REQUIREMENTS.md] | Extend the existing temp-checkout mutation suite with one negative case per failure class and diagnostics that name `expected-gcode-structural-summary.tsv` or the affected structural field. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo instruction entrypoint, and `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant canonical Bright Builds standards must be read before planning, review, implementation, or audit work. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Do not edit the Bright Builds managed block in `AGENTS.md` or edit `AGENTS.bright-builds.md` directly. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md]
- Repo-local phase summary files require `requirements-completed` frontmatter, and `mdformat` must not be run over phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md]
- Bright Builds rules materially relevant to this phase require thin orchestration, parsed boundary data, shallow control flow, focused tests, and repo-native verification before commit. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Existing Bash scripts in this package use `#!/usr/bin/env bash` and `set -euo pipefail`, and repo instructions require visible failures instead of ignored return values. [VERIFIED: AGENTS.md, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]
- Existing mutation tests use Arrange/Act/Assert comments for each focused negative case. [VERIFIED: AGENTS.md, packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]
- No project-local `.claude/skills/` or `.agents/skills/` directory exists in this checkout. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md -print` returned no entries]
- `standards-overrides.md` contains only placeholder override rows, so no active local exception changes the Bright Builds defaults for this phase. [VERIFIED: standards-overrides.md]

## Summary

Phase 50 is an internal fixture-contract expansion, not a parser, parity-command, status-publication, or upstream-import phase. [VERIFIED: 50-CONTEXT.md, .planning/ROADMAP.md] The correct plan should add the new structural sidecar TSV under the existing Prusa G-code fixture namespace, keep the v1.12 `expected-gcode-summary.tsv` unchanged, and extend the existing fixture verifier plus mutation suite in `packages/parity-fixtures`. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/BUILD.bazel, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

The most important implementation constraint is exactness: the sidecar artifact must have the locked six-column header, exactly 16 structural data rows, exactly the Phase 49 structural field names, exact source/fixture alignment with `fixture-provenance.tsv`, and no file-integrity metadata or public-status language inside the structural summary. [VERIFIED: 50-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md, packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] The selected fixture is currently four `G1 F...` lines, and a local audit confirmed four total G-code command rows, four `G1` rows, no movement/extrusion axis text, and zero temperature/tool-change markers. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode, local awk audit]

The existing baseline is green: `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`, `bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`, and `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test` all passed locally on 2026-06-17. [VERIFIED: command execution] The planner should run Bazel commands serially in this repo because concurrent Bazel invocations contend on the output-base lock. [VERIFIED: command execution output-base lock diagnostics]

**Primary recommendation:** Implement Phase 50 as two focused plans: first add and wire the exact structural sidecar artifact plus narrow docs, then extend the existing fixture verifier and mutation tests to enforce the schema, closed field set, exact values, provenance/update-route alignment, and no-overclaim boundary. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/BUILD.bazel, packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

## Standard Stack

### Core

| Tool/Format | Version | Purpose | Why Standard |
|-------------|---------|---------|--------------|
| Bash | GNU bash 3.2.57 | Fixture verifier and mutation test scripts. [VERIFIED: environment audit] | Existing Prusa fixture verifiers are Bash scripts with `set -euo pipefail`, exact constants, and fail-fast diagnostics. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh, packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| Bazel | 8.6.0 | Owns verifier execution, fixture data, and mutation tests. [VERIFIED: environment audit, .bazelversion] | `packages/parity-fixtures` already exposes `sh_binary` and `sh_test` targets for the G-code fixture verifier. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| TSV | repo text format | Structural expected sidecar, existing summary artifact, provenance, and status data. [VERIFIED: 50-CONTEXT.md, expected-gcode-summary.tsv, fixture-provenance.tsv, packages/parity/status.tsv] | Existing fixture contracts are exact checked-in text artifacts, and Phase 50 locks the structural schema as TSV. [VERIFIED: 50-CONTEXT.md] |
| Markdown | repo text format | Fixture README and package README inspectability. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/README.md, fixture README] | Locked decisions require minimal README updates instead of broad docs rewrites. [VERIFIED: 50-CONTEXT.md] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| awk | awk 20200816 | Closed-field, duplicate-field, and row-count checks without Bash associative arrays. [VERIFIED: environment audit, existing verifier awk usage] | Use for structural TSV validation because local Bash is 3.2.57 and does not support associative arrays. [VERIFIED: environment audit] |
| shasum | 6.02 | Existing fixture SHA-256 verification. [VERIFIED: environment audit] | Keep existing file-integrity checks in provenance/G-code verification, not in the structural sidecar artifact. [VERIFIED: verify_prusa_gcode_output_fixture.sh, 50-CONTEXT.md D-05] |
| shfmt | 3.12.0 | Shell formatting check. [VERIFIED: environment audit] | Run `shfmt -l -d` on touched fixture verifier/test scripts before commit. [VERIFIED: Phase 49 summary verification pattern, Bright Builds verification standard] |
| shellcheck | 0.11.0 | Shell static analysis. [VERIFIED: environment audit] | Run on touched Bash scripts; literal Markdown/TSV row constants may need narrow, justified directives only when shellcheck flags real literal data. [VERIFIED: Phase 49 summary, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| mdformat | 1.0.0 | Markdown formatting check for non-summary docs. [VERIFIED: environment audit] | Use only when needed for touched README files; do not run on phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md] |
| ripgrep | 15.1.0 | Fast drift and forbidden-claim searches. [VERIFIED: environment audit] | Use for final overclaim/status drift checks and to confirm no accidental structural parser/parity changes. [VERIFIED: AGENTS.md] |
| Node/GSD tools | Node v24.13.0 | Phase init and optional docs commit. [VERIFIED: environment audit] | Use `gsd-tools.cjs` for phase metadata and research commit when `commit_docs` is true. [VERIFIED: phase init output] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Extend existing fixture verifier | New structural verifier target | Do not use; D-06 locks extension of `//packages/parity-fixtures:verify_prusa_gcode_output_fixture`. [VERIFIED: 50-CONTEXT.md] |
| Sidecar structural TSV | Modify `expected-gcode-summary.tsv` | Do not use; D-01 locks `expected-gcode-summary.tsv` as unchanged to preserve v1.12 Rust and Phase 48 parity behavior. [VERIFIED: 50-CONTEXT.md, prusa_gcode_output.rs, packages/parity/BUILD.bazel] |
| Bash associative arrays | `declare -A` for duplicate checks | Do not use; local Bash is 3.2.57, so use `awk` or indexed data instead. [VERIFIED: environment audit] |
| Rust parser validation | Add Rust structural parsing now | Do not use; Phase 51 owns typed Rust parsing of `expected-gcode-structural-summary.tsv`. [VERIFIED: 50-CONTEXT.md, .planning/ROADMAP.md] |
| Public parity/status update | Modify `packages/parity` or `packages/slic3r-rust` now | Do not use; Phase 50 must preserve summary-only status and avoid structural executable parity claims. [VERIFIED: 50-CONTEXT.md, packages/parity/status.tsv] |
| Upstream source generation/import | Generate fixture from PrusaSlicer source or fetch upstream | Do not use; update route remains reviewed intake changes and no Git/network/import behavior. [VERIFIED: fixture README, fixture-provenance.tsv, 50-CONTEXT.md] |

**Installation:**

```bash
# No new packages are required for Phase 50. [VERIFIED: current repo stack and 50-CONTEXT.md]
```

**Version verification:**

```bash
bash --version
bazel --version
awk --version
shasum --version
shfmt --version
shellcheck --version
mdformat --version
rg --version
node --version
```

Local versions were verified on 2026-06-17. [VERIFIED: environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
+-- parity-fixtures/
|   +-- BUILD.bazel
|   +-- README.md
|   +-- verify_prusa_gcode_output_fixture.sh
|   +-- verify_prusa_gcode_output_fixture_test.sh
|   +-- forks/prusaslicer/prusaslicer.gcode-output/
|       +-- .gitattributes
|       +-- README.md
|       +-- expected-gcode-summary.tsv
|       +-- expected-gcode-structural-summary.tsv
|       +-- fixture-provenance.tsv
|       +-- gcodewriter-set-speed.gcode
+-- prusa-gcode-output-scope/
|   +-- gcode-output-scope.md
+-- parity/
    +-- status.tsv
```

This structure keeps fixture bytes and expected artifacts in `packages/parity-fixtures`, keeps the structural scope contract in `packages/prusa-gcode-output-scope`, and leaves public parity/status work to later phases. [VERIFIED: 50-CONTEXT.md, packages/parity-fixtures/BUILD.bazel, packages/prusa-gcode-output-scope/gcode-output-scope.md, packages/parity/status.tsv]

### Pattern 1: Separate Structural Sidecar TSV

**What:** Add `expected-gcode-structural-summary.tsv` as a new checked-in sibling artifact and leave `expected-gcode-summary.tsv` untouched. [VERIFIED: 50-CONTEXT.md]
**When to use:** Use for Phase 50 because the structural contract is new v1.13 evidence and the existing summary-only Rust boundary still expects the seven-column v1.12 schema. [VERIFIED: 50-CONTEXT.md, packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

Recommended artifact content:

```text
source_ref	fixture_path	structural_field	structural_category	structural_value	evidence_boundary
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	source_ref	source identity	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	inventory_source_paths	source identity	src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp	Inventory source paths only: `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_source_literal	source identity	tests/fff_print/test_gcodewriter.cpp#L20-L35	Source literal only: `tests/fff_print/test_gcodewriter.cpp#L20-L35`.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_id	fixture identity	gcodewriter-set-speed.gcode	Fixture identity only: `gcodewriter-set-speed.gcode`.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_path	fixture identity	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	command_count_total	command counts	4	Count of G-code command rows in the selected fixture only; no generated-output behavior claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	command_count_g1	command counts	4	Count of `G1` command rows in the selected fixture only; no toolpath geometry claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	section_count_total	section counts	1	Count of structural sections in the selected summary only; no GUI, print, or runtime section behavior claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	ordered_marker_1	ordered markers	G1 F99999.123	First ordered marker value from the selected fixture summary only.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	ordered_marker_2	ordered markers	G1 F1	Second ordered marker value from the selected fixture summary only.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	ordered_marker_3	ordered markers	G1 F203.2	Third ordered marker value from the selected fixture summary only.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	ordered_marker_4	ordered markers	G1 F203.201	Fourth ordered marker value from the selected fixture summary only.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	movement_axis_present	movement/extrusion indicators	false	Boolean structural indicator for movement-axis text presence only; no toolpath geometry, travel, or printability claim.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	extrusion_axis_present	movement/extrusion indicators	false	Boolean structural indicator for extrusion-axis text presence only; no extrusion amount, material, or printability claim.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	temperature_marker_count	temperature/tool-change markers	0	Count of temperature marker commands in the selected fixture only; no printer-runtime behavior claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	tool_change_marker_count	temperature/tool-change markers	0	Count of tool-change marker commands in the selected fixture only; no multi-tool runtime behavior claimed.
```

The field names, values, and evidence-boundary text above use the locked Phase 50 values and the verbatim Phase 49 structural scope boundary sentences. [VERIFIED: 50-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md, local fixture audit]

### Pattern 2: Exact Structural Summary Verification

**What:** Add a `verify_structural_summary` step to the existing fixture verifier that enforces header, six-column rows, exact 16 data rows, exact required row values, one row per structural field, allowed field names only, source/fixture alignment, provenance alignment, and forbidden claim rejection. [VERIFIED: 50-CONTEXT.md, existing verifier helper patterns]
**When to use:** Use this inside `verify_prusa_gcode_output_fixture.sh` after `verify_expected_summary` and before README/status checks so structural failures stop before downstream docs/status assertions. [VERIFIED: current verifier order in verify_prusa_gcode_output_fixture.sh]

Use `awk` for closed-set and duplicate checks because local Bash is 3.2.57. [VERIFIED: environment audit]

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
readonly STRUCTURAL_SUMMARY_HEADER=$'source_ref\tfixture_path\tstructural_field\tstructural_category\tstructural_value\tevidence_boundary'
readonly STRUCTURAL_ROW_COUNT="17"

verify_structural_summary_shape() {
	require_exact_header \
		"${structural_summary_file}" \
		"expected-gcode-structural-summary.tsv" \
		"${STRUCTURAL_SUMMARY_HEADER}"
	require_line_count \
		"${structural_summary_file}" \
		"expected-gcode-structural-summary.tsv" \
		"${STRUCTURAL_ROW_COUNT}"

	awk -F '\t' \
		-v source_ref="${SOURCE_REF}" \
		-v fixture_path="${FIXTURE_PATH}" '
			BEGIN {
				required["source_ref"] = 1
				required["inventory_source_paths"] = 1
				required["fixture_source_literal"] = 1
				required["fixture_id"] = 1
				required["fixture_path"] = 1
				required["command_count_total"] = 1
				required["command_count_g1"] = 1
				required["section_count_total"] = 1
				required["ordered_marker_1"] = 1
				required["ordered_marker_2"] = 1
				required["ordered_marker_3"] = 1
				required["ordered_marker_4"] = 1
				required["movement_axis_present"] = 1
				required["extrusion_axis_present"] = 1
				required["temperature_marker_count"] = 1
				required["tool_change_marker_count"] = 1
			}
			NR == 1 { next }
			NF != 6 {
				printf "error: expected-gcode-structural-summary.tsv: row %d has %d fields, expected 6\n", NR, NF > "/dev/stderr"
				exit 1
			}
			$1 != source_ref || $2 != fixture_path {
				printf "error: expected-gcode-structural-summary.tsv: provenance mismatch for %s\n", $3 > "/dev/stderr"
				exit 1
			}
			!($3 in required) {
				printf "error: expected-gcode-structural-summary.tsv: unsupported structural field: %s\n", $3 > "/dev/stderr"
				exit 1
			}
			{
				count[$3]++
			}
			END {
				for (field in required) {
					if (count[field] != 1) {
						printf "error: expected-gcode-structural-summary.tsv: structural field %s count %d, expected 1\n", field, count[field] + 0 > "/dev/stderr"
						exit 1
					}
				}
			}
		' "${structural_summary_file}" || exit 1
}
```

This example uses existing script helpers and standard `awk` instead of a new parser dependency. [VERIFIED: verify_prusa_gcode_output_fixture.sh, environment audit]

### Pattern 3: Bazel Ownership Wiring

**What:** Add the structural summary to every existing Bazel ownership surface for Prusa G-code fixture artifacts. [VERIFIED: 50-CONTEXT.md D-08]
**When to use:** Use when editing `packages/parity-fixtures/BUILD.bazel`; do not touch `packages/parity/BUILD.bazel` for Phase 50. [VERIFIED: 50-CONTEXT.md, packages/parity/BUILD.bazel]

Required BUILD.bazel touch points:

| Location | Required Change |
|----------|-----------------|
| `exports_files([...])` | Add `forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`. [VERIFIED: BUILD.bazel exports_files pattern] |
| aliases near `prusa_gcode_output_expected_gcode_summary` | Add an alias such as `prusa_gcode_output_expected_gcode_structural_summary`. [VERIFIED: BUILD.bazel alias pattern] |
| `prusa_gcode_output_bundle` | Include the new structural TSV in `srcs`. [VERIFIED: BUILD.bazel filegroup pattern] |
| `verify_prusa_gcode_output_fixture` data | Ensure the bundle or explicit file makes the structural TSV available to Bazel. [VERIFIED: BUILD.bazel sh_binary data pattern] |
| `verify_prusa_gcode_output_fixture_test` data | Ensure the mutation test can copy the structural TSV from runfiles. [VERIFIED: BUILD.bazel sh_test data pattern] |
| `package_boundary` | Include the new structural TSV so package boundary ownership is inspectable. [VERIFIED: BUILD.bazel package_boundary pattern] |

`buildifier` is not installed locally, so the planner should preserve existing BUILD formatting manually and verify with Bazel query/test. [VERIFIED: environment audit]

### Pattern 4: Temp-Checkout Mutation Tests

**What:** Extend `write_valid_fixture_copy` to copy `expected-gcode-structural-summary.tsv`, extend `run_verifier` to pass it in argument mode, and add one test per GCFIX-03 failure class. [VERIFIED: 50-CONTEXT.md, verify_prusa_gcode_output_fixture_test.sh]
**When to use:** Use the existing mutation harness so tests do not mutate the real checkout and each failure has one clear diagnostic. [VERIFIED: verify_prusa_gcode_output_fixture_test.sh]

Required test cases:

| Case | Mutation | Expected Diagnostic |
|------|----------|---------------------|
| valid fixture passes | Copy unchanged fixture, summary, structural summary, provenance, status, BUILD, package README. [VERIFIED: existing test style] | `ok: Prusa G-code output fixture verification passed`. [VERIFIED: existing verifier output] |
| structural value drift | Change `command_count_g1` from `4` to `3` or `ordered_marker_4` to another value. [VERIFIED: GCFIX-03] | Mentions `expected-gcode-structural-summary.tsv` and the drifted field. [VERIFIED: 50-CONTEXT.md D-12] |
| missing required structural row | Remove the `source_ref` or `ordered_marker_3` row. [VERIFIED: GCFIX-03] | Mentions missing structural field. [VERIFIED: 50-CONTEXT.md D-12] |
| duplicate structural row | Append a duplicate `command_count_total` row while keeping all required rows. [VERIFIED: GCFIX-03] | Mentions duplicate/count for `command_count_total`. [VERIFIED: 50-CONTEXT.md D-12] |
| unsupported structural field | Append `geometry_count` or replace a required field name with unsupported text. [VERIFIED: GCFIX-03 and forbidden scope] | Mentions unsupported structural field. [VERIFIED: 50-CONTEXT.md D-12] |
| unsupported broad-behavior claim | Add a forbidden claim to fixture README or structural `evidence_boundary`. [VERIFIED: GCFIX-03] | Mentions forbidden text or broad-behavior claim. [VERIFIED: 50-CONTEXT.md D-11] |
| provenance mismatch | Change structural `source_ref` or `fixture_path` so it diverges from `fixture-provenance.tsv`. [VERIFIED: GCFIX-03] | Mentions provenance mismatch and artifact/field. [VERIFIED: 50-CONTEXT.md D-12] |

### Anti-Patterns to Avoid

- **Editing `expected-gcode-summary.tsv`:** This can break the v1.12 Rust parser and Phase 48 parity command that still consume the seven-column summary-only artifact. [VERIFIED: 50-CONTEXT.md, prusa_gcode_output.rs, packages/parity/compare_prusaslicer_gcode_output.sh]
- **Creating a new verifier target:** Phase 50 explicitly extends `//packages/parity-fixtures:verify_prusa_gcode_output_fixture`. [VERIFIED: 50-CONTEXT.md]
- **Checking only exact row count:** A duplicate row can replace another row while keeping 16 data rows, so duplicate and required-field checks must both exist. [VERIFIED: GCFIX-03, existing row-count helper behavior]
- **Putting bytes or SHA-256 in structural TSV:** File integrity metadata stays in `fixture-provenance.tsv` and README text. [VERIFIED: 50-CONTEXT.md D-05, fixture-provenance.tsv]
- **Using Bash associative arrays:** Local Bash is 3.2.57, so associative arrays are not portable in this repo. [VERIFIED: environment audit]
- **Changing `packages/parity/status.tsv` to publish structural evidence:** Phase 50 preserves the narrow summary-only status row and defers public structural parity/status to Phase 52. [VERIFIED: 50-CONTEXT.md, packages/parity/status.tsv]
- **Running Bazel commands in parallel:** Bazel serializes on the output-base lock in this environment, which produced lock-wait diagnostics during research. [VERIFIED: command execution]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Structural fixture verifier | New `verify_prusa_gcode_output_structural_fixture` target | Extend `verify_prusa_gcode_output_fixture.sh` and `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` | Ownership is locked to the existing fixture package and verifier target. [VERIFIED: 50-CONTEXT.md] |
| Structural G-code parser | Bash or Rust parser that derives fields from arbitrary G-code | Exact checked-in structural sidecar plus exact fixture-line/provenance checks | Phase 50 writes fixture expectations; Phase 51 owns typed parsing. [VERIFIED: 50-CONTEXT.md, .planning/ROADMAP.md] |
| Fixture regeneration | Git fetch, upstream source import, source compile, or live generation | Reviewed intake update route recorded in README/provenance | Existing fixture provenance and README explicitly forbid upstream fetch/import/generation behavior. [VERIFIED: fixture README, fixture-provenance.tsv, verify_prusa_gcode_output_fixture.sh] |
| General TSV schema framework | New dependency or cross-repo parser | Existing Bash helpers plus `awk` closed-set checks | The repository already uses exact local verifier scripts and no new packages are required. [VERIFIED: verify_prusa_gcode_output_fixture.sh, AGENTS.md dependency guidance] |
| Public structural parity command | Modify `packages/parity:prusaslicer_gcode_output_parity` | Defer to Phase 52 after Phase 51 Rust structural boundary | Phase 50 must not claim executable structural parity. [VERIFIED: 50-CONTEXT.md, .planning/ROADMAP.md] |
| Broad generated-output status handling | New status publication or broad status parser | Preserve exact `fork.prusaslicer.gcode-output` and `generated-outputs` boundaries | Phase 50 strengthens fixture evidence only. [VERIFIED: 50-CONTEXT.md, packages/parity/status.tsv] |

**Key insight:** The hard part is not discovering G-code semantics; the hard part is making the checked-in structural expectations fail closed without turning them into byte-for-byte, geometry, printability, runtime, or public parity claims. [VERIFIED: .planning/REQUIREMENTS.md, 50-CONTEXT.md, packages/prusa-gcode-output-scope/gcode-output-scope.md]

## Common Pitfalls

### Pitfall 1: Structural Sidecar Accidentally Breaks v1.12 Consumers

**What goes wrong:** The planner edits `expected-gcode-summary.tsv` or `packages/parity:prusaslicer_gcode_output_parity` while adding structural evidence. [VERIFIED: 50-CONTEXT.md D-01 and D-14]
**Why it happens:** The existing summary artifact and new structural sidecar both describe the same fixture. [VERIFIED: expected-gcode-summary.tsv, planned structural sidecar path in 50-CONTEXT.md]
**How to avoid:** Add only `expected-gcode-structural-summary.tsv` and verifier/Bazel/docs references in `packages/parity-fixtures`; leave `packages/parity` and `packages/slic3r-rust` unchanged except for verification reads. [VERIFIED: 50-CONTEXT.md]
**Warning signs:** Diffs touch `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` or `packages/parity/BUILD.bazel` during Phase 50 implementation. [VERIFIED: phase boundary in 50-CONTEXT.md]

### Pitfall 2: Row Count Passes but Duplicate Fields Slip Through

**What goes wrong:** The structural TSV still has 16 data rows, but one required field is missing and another field is duplicated. [VERIFIED: GCFIX-03 duplicate and missing row requirements]
**Why it happens:** Exact row count alone cannot prove one row per structural field. [VERIFIED: existing `require_line_count` behavior in verify_prusa_gcode_output_fixture.sh]
**How to avoid:** Validate required field names, unsupported fields, and per-field count in one closed-set pass. [VERIFIED: 50-CONTEXT.md D-07]
**Warning signs:** Tests include missing-row drift but no duplicate-row mutation. [VERIFIED: GCFIX-03]

### Pitfall 3: Structural Evidence Boundary Becomes a Broad Behavior Claim

**What goes wrong:** README text or structural `evidence_boundary` says the fixture proves byte-for-byte G-code parity, toolpath geometry, extrusion, timing, printability, support behavior, GUI behavior, fork support, upstream imports, or sync automation. [VERIFIED: .planning/REQUIREMENTS.md, 50-CONTEXT.md]
**Why it happens:** Counts and ordered markers can be misread as generated-output semantics. [VERIFIED: Phase 49 scope table boundaries]
**How to avoid:** Reuse Phase 49 boundary phrasing and reject forbidden broad claims in both fixture-owned text and structural evidence-boundary fields. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md, 50-CONTEXT.md D-11]
**Warning signs:** New text says "verified parity" without "narrow", "summary-only", or "structural fixture" qualifiers. [VERIFIED: existing verifier forbidden claim patterns]

### Pitfall 4: Provenance and Structural Summary Diverge

**What goes wrong:** The structural sidecar references a different `source_ref`, fixture path, fixture ID, or update route than `fixture-provenance.tsv` and README text. [VERIFIED: GCFIX-02 and GCFIX-03]
**Why it happens:** The new artifact duplicates source/fixture identity fields already present in provenance. [VERIFIED: fixture-provenance.tsv, structural schema in 50-CONTEXT.md]
**How to avoid:** Cross-check structural `source_ref` and `fixture_path` against verifier constants that already come from provenance, and verify README update-route text remains aligned. [VERIFIED: 50-CONTEXT.md D-07, verify_prusa_gcode_output_fixture.sh]
**Warning signs:** The structural sidecar changes without a corresponding verifier constant/test update. [VERIFIED: current exact-row verifier pattern]

### Pitfall 5: Bazel Does Not Own the New Artifact

**What goes wrong:** The file exists in the checkout, but Bazel runfiles, bundles, exports, or package boundary omit it. [VERIFIED: 50-CONTEXT.md D-08]
**Why it happens:** The current `prusa_gcode_output_bundle` and `package_boundary` explicitly enumerate fixture files. [VERIFIED: packages/parity-fixtures/BUILD.bazel]
**How to avoid:** Add the structural TSV to `exports_files`, alias, `prusa_gcode_output_bundle`, verifier/test data path, and `package_boundary`. [VERIFIED: 50-CONTEXT.md D-08]
**Warning signs:** `bazel query 'kind("(sh_binary|sh_test) rule", //packages/parity-fixtures:*)'` still works but the new TSV is absent from `prusa_gcode_output_bundle` or `package_boundary`. [VERIFIED: BUILD.bazel query and filegroup structure]

### Pitfall 6: Bash 3.2 Portability Is Forgotten

**What goes wrong:** The verifier uses `declare -A` or other Bash 4+ features and works on a newer shell but fails on macOS system Bash. [VERIFIED: environment audit]
**Why it happens:** Duplicate/allowlist checks naturally invite associative arrays. [VERIFIED: GCFIX-03 duplicate/unsupported field requirements]
**How to avoid:** Implement closed-set checks with `awk` or Bash 3-compatible indexed data. [VERIFIED: existing verifier awk usage, environment audit]
**Warning signs:** `bash -n` passes under Homebrew Bash but the shebang resolves to `/bin/bash` in Bazel/macOS runfiles. [VERIFIED: fixture scripts shebang and environment audit]

### Pitfall 7: Bazel Commands Are Parallelized

**What goes wrong:** Multiple Bazel invocations wait on the same output-base lock and slow the workflow. [VERIFIED: command execution lock diagnostics]
**Why it happens:** Bazel serializes access to the output base. [VERIFIED: command execution lock diagnostics]
**How to avoid:** Run Bazel verifier/test commands serially in implementation and verification steps. [VERIFIED: command execution]
**Warning signs:** Output includes "Another command holds the output base lock." [VERIFIED: command execution]

## Code Examples

Verified patterns from local sources:

### Existing Exact Header and Row Checks

```bash
# Source: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
require_exact_header "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_SUMMARY_HEADER}"
require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_LINE_4_ROW}" "line_4"
require_line_count "${expected_summary_file}" "expected-gcode-summary.tsv" "6"
```

Use the same pattern for exact structural rows, with a companion closed-set/duplicate check for the `structural_field` column. [VERIFIED: verify_prusa_gcode_output_fixture.sh, 50-CONTEXT.md]

### Existing Verifier Data Flow

```bash
# Source: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"
	local maybe_verifier="${4:-${verifier}}"
	local fixture_dir="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

	set +e
	"${maybe_verifier}" \
		"${fixture_dir}/README.md" \
		"${fixture_dir}/fixture-provenance.tsv" \
		"${fixture_dir}/expected-gcode-summary.tsv" \
		"${fixture_dir}/gcodewriter-set-speed.gcode" \
		"${dir}/packages/parity/status.tsv" \
		"${dir}/packages/parity/BUILD.bazel" \
		"${dir}/packages/parity-fixtures/README.md" \
		"${dir}" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}
```

Phase 50 should add the structural summary argument between `expected-gcode-summary.tsv` and `gcodewriter-set-speed.gcode` in the test harness, then update the script usage text and arity check. [VERIFIED: existing argument order in verify_prusa_gcode_output_fixture.sh, 50-CONTEXT.md]

### Existing One-Concern Mutation Shape

```bash
# Source: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
test_missing_expected_marker_row_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-expected-marker-row"
	local expected_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
	write_valid_fixture_copy "${dir}"
	remove_line_containing "${expected_file}" $'\tline_3\tG1 F203.2\t'

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-marker-row.out" "${tmp_dir}/missing-marker-row.err"; then
		fail "missing expected marker row fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-marker-row.err" "line_3"
}
```

Use this exact Arrange/Act/Assert style for each GCFIX-03 mutation case. [VERIFIED: verify_prusa_gcode_output_fixture_test.sh, AGENTS.md]

### Current Fixture Structural Audit

```bash
awk 'BEGIN{total=0;g1=0;move=0;extrude=0;temp=0;tool=0}
  /^G[0-9]/{total++}
  /^G1([[:space:]]|$)/{g1++}
  /[[:space:]]+[XYZ][+-]?[0-9]/{move=1}
  /[[:space:]]+E[+-]?[0-9]/{extrude=1}
  /(^|[[:space:]])M10[49]([[:space:]]|$)|(^|[[:space:]])M19[02]([[:space:]]|$)/{temp++}
  /^T[0-9]+/{tool++}
  END{
    printf "total=%d\ng1=%d\nmovement_axis_present=%s\nextrusion_axis_present=%s\ntemperature_marker_count=%d\ntool_change_marker_count=%d\n",
      total,g1,move?"true":"false",extrude?"true":"false",temp,tool
  }' packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode
```

This audit returned total `4`, `G1` count `4`, movement and extrusion axis indicators `false`, and temperature/tool-change marker counts `0`. [VERIFIED: local command execution]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| v1.12 summary-only `expected-gcode-summary.tsv` | v1.13 adds separate `expected-gcode-structural-summary.tsv` while preserving the old artifact | Phase 50 on 2026-06-17 planning cycle [VERIFIED: .planning/ROADMAP.md, 50-CONTEXT.md] | Planner must add a sidecar, not alter the old summary consumed by Rust and parity. [VERIFIED: 50-CONTEXT.md, prusa_gcode_output.rs] |
| Phase 49 structural scope contract in Markdown | Phase 50 executable fixture verifier checks the same closed field set in TSV form | Phase 50 depends on completed Phase 49 [VERIFIED: .planning/STATE.md, Phase 49 summaries] | Planner should copy the exact 16 fields and evidence boundaries from Phase 49 rather than inventing fields. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md] |
| Fixture verifier checks bytes/provenance/summary-only rows | Fixture verifier also checks structural schema, exact rows, duplicates, unsupported fields, and provenance mismatch | Phase 50 target behavior [VERIFIED: GCFIX-02, GCFIX-03] | Verification must fail closed on structural drift before Phase 51 relies on the artifact. [VERIFIED: .planning/REQUIREMENTS.md] |
| Broad generated-output status remains in progress | Narrow `fork.prusaslicer.gcode-output` remains verified only for summary-only evidence | Existing Phase 48 status preserved through Phase 50 [VERIFIED: packages/parity/status.tsv, 50-CONTEXT.md] | Do not publish structural executable parity or promote `generated-outputs` in Phase 50. [VERIFIED: 50-CONTEXT.md] |

**Deprecated/outdated:**

- Treating `fork.prusaslicer.gcode-output` as unpublished is outdated because the current status row is verified for the narrow summary-only slice. [VERIFIED: packages/parity/status.tsv]
- Treating the verified row as structural executable evidence is premature because Phase 52 owns public structural parity/status publication. [VERIFIED: 50-CONTEXT.md, .planning/ROADMAP.md]
- Treating `expected-gcode-summary.tsv` as the right place for v1.13 structural rows is forbidden by D-01. [VERIFIED: 50-CONTEXT.md]

## Assumptions Log

All claims in this research were verified against local project files, command output, or official documentation pages. [VERIFIED: Sources section]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | No assumed claims recorded. [VERIFIED: Sources section] | All | No user confirmation needed before planning. [VERIFIED: Sources section] |

## Open Questions

None. The artifact name, schema, field set, concrete values, verifier ownership, Bazel wiring surfaces, and mutation failure classes are locked by Phase 50 context. [VERIFIED: 50-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bash | Fixture verifier/test scripts | yes | GNU bash 3.2.57 | none needed; avoid Bash 4+ features. [VERIFIED: environment audit] |
| Bazel | `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` and mutation test | yes | 8.6.0 | none needed; run commands serially. [VERIFIED: environment audit, command execution] |
| awk | TSV field/row checks | yes | awk 20200816 | none needed. [VERIFIED: environment audit] |
| shasum | Existing SHA-256 verification | yes | 6.02 | none needed for existing verifier. [VERIFIED: environment audit] |
| shfmt | Shell formatter check | yes | 3.12.0 | If unavailable, use `bash -n`, shellcheck, and focused review. [VERIFIED: environment audit] |
| shellcheck | Shell static analysis | yes | 0.11.0 | If unavailable, use `bash -n`, shfmt, and Bazel tests. [VERIFIED: environment audit] |
| mdformat | Non-summary Markdown formatting check | yes | 1.0.0 | Use `git diff --check` if unavailable; do not run on phase `*-SUMMARY.md`. [VERIFIED: environment audit, AGENTS.md] |
| ripgrep | Drift/forbidden-claim search | yes | 15.1.0 | Use `grep` if unavailable. [VERIFIED: environment audit] |
| Node/GSD tools | Phase metadata and optional research commit | yes | v24.13.0 | Manual git commands if unavailable. [VERIFIED: environment audit] |
| buildifier | BUILD formatting | no | unavailable | Preserve existing BUILD style manually and verify with Bazel query/test. [VERIFIED: environment audit] |

**Missing dependencies with no fallback:** None found. [VERIFIED: environment audit]

**Missing dependencies with fallback:** `buildifier` is missing; manual BUILD formatting plus Bazel verification is viable because this phase only adds file labels to existing BUILD patterns. [VERIFIED: environment audit, packages/parity-fixtures/BUILD.bazel]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement: false`. [VERIFIED: .planning/config.json] OWASP ASVS remains an official application security verification standard maintained by OWASP; current category names should be checked against the official ASVS project before citing exact control IDs. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | Phase 50 has no authentication surface. [VERIFIED: .planning/ROADMAP.md, 50-CONTEXT.md] |
| V3 Session Management | no | Phase 50 has no session surface. [VERIFIED: .planning/ROADMAP.md, 50-CONTEXT.md] |
| V4 Access Control | no | Phase 50 has no authorization surface. [VERIFIED: .planning/ROADMAP.md, 50-CONTEXT.md] |
| V5 Input Validation | yes | Use positive allowlists, exact headers, exact row counts, per-field duplicate rejection, source/fixture alignment, and forbidden claim rejection for structural TSV input. [VERIFIED: 50-CONTEXT.md, verify_prusa_gcode_output_fixture.sh] |
| V6 Cryptography | no new crypto | Existing SHA-256 fixture integrity remains in `fixture-provenance.tsv`; Phase 50 should not add cryptographic behavior to the structural summary. [VERIFIED: fixture-provenance.tsv, 50-CONTEXT.md D-05] |

### Known Threat Patterns for Structural Fixture Contracts

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Unsupported structural field injection | Tampering | Closed structural field allowlist and unsupported-field mutation test. [VERIFIED: GCFIX-03, 50-CONTEXT.md D-07] |
| Duplicate structural field masking a missing row | Tampering | Per-field count checks plus explicit duplicate-row mutation test. [VERIFIED: GCFIX-03] |
| Provenance mismatch between sidecar and source fixture | Tampering/Repudiation | Cross-check `source_ref` and `fixture_path` against verifier/provenance constants and mutation-test mismatches. [VERIFIED: GCFIX-02, GCFIX-03] |
| Broad parity overclaim in fixture-owned text | Spoofing/Repudiation | Reject forbidden broad-behavior claim text in README and structural `evidence_boundary` fields. [VERIFIED: 50-CONTEXT.md D-11, existing `reject_overclaiming_text`] |
| External behavior sneaks into verifier | Denial of Service/Tampering | Preserve self-scan forbidden behavior checks for Git/network/generation/host-upload behavior and keep verifier file-based. [VERIFIED: verify_prusa_gcode_output_fixture.sh] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md` - locked decisions, discretion, deferred scope, canonical refs, and exact structural artifact requirements. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - GCFIX-01, GCFIX-02, GCFIX-03, and v1.13 out-of-scope boundaries. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 50 goal, dependencies, and success criteria. [VERIFIED: file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - current milestone state and accumulated decisions. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: file read]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - Phase 49 closed structural field contract and evidence boundaries. [VERIFIED: file read]
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` and test - current exact structural contract verifier and mutation patterns. [VERIFIED: file read]
- `packages/parity-fixtures/BUILD.bazel` - fixture bundle, alias, verifier, test, and package boundary wiring. [VERIFIED: file read]
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` and test - current fixture verifier/helper style and mutation harness. [VERIFIED: file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` - current fixture README, expected summary, provenance, gcode bytes, and `.gitattributes`. [VERIFIED: file read]
- `packages/parity/status.tsv`, `packages/parity/BUILD.bazel`, `packages/parity/compare_prusaslicer_gcode_output.sh` - current summary-only parity/status boundary that Phase 50 must not repurpose. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - current v1.12 seven-column summary-only Rust boundary. [VERIFIED: file read]
- Local verification commands: `bash -n`, `shfmt -l -d`, `shellcheck`, `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`, `bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`, and `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`. [VERIFIED: command execution]

### Secondary (MEDIUM confidence)

- Bright Builds canonical standards pages at pinned commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: index, architecture, code shape, verification, and testing. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- OWASP ASVS project pages for security-domain context. [CITED: https://owasp.org/www-project-application-security-verification-standard/] [CITED: https://github.com/OWASP/ASVS]

### Tertiary (LOW confidence)

- None. [VERIFIED: all phase-critical claims were checked against local project files or official project/standards pages]

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - existing Bash/Bazel/TSV/Markdown patterns and local versions were verified. [VERIFIED: environment audit, package files]
- Architecture: HIGH - locked Phase 50 decisions specify artifact name, schema, required fields, values, verifier ownership, Bazel wiring, and mutation failure classes. [VERIFIED: 50-CONTEXT.md]
- Pitfalls: HIGH - each main pitfall maps to a locked requirement, existing exact-check pattern, or observed environment behavior. [VERIFIED: .planning/REQUIREMENTS.md, verifier scripts, command execution]

**Research date:** 2026-06-17 [VERIFIED: system date]
**Valid until:** 2026-07-17 for local codebase planning, or sooner if Phase 50 context changes. [VERIFIED: internal phase state is current on 2026-06-17]
