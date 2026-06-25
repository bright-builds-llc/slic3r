# Phase 58: Arc-Fitting Fixture Corpus - Research

**Researched:** 2026-06-23
**Domain:** Source-pinned fixture corpus, TSV expected summaries, Bash/Bazel fail-closed verification
**Confidence:** HIGH for package structure and verifier pattern; MEDIUM for exact fixture-byte recommendation

<user_constraints>
## User Constraints (from CONTEXT.md)

All bullets in this section are copied verbatim from `.planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md`. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

### Locked Decisions

### Fixture namespace and provenance

- **D-01:** Create a new fixture namespace at
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`, as
  planned by Phase 57. Do not place arc evidence inside the existing
  `prusaslicer.gcode-output` namespace, because the current
  `fork.prusaslicer.gcode-output` status meaning must remain limited to the
  Phase 53 through Phase 56 semantic evidence slice.
- **D-02:** Add namespace-local fixture documentation, a `.gitattributes`
  boundary, `fixture-provenance.tsv`, one or more checked-in source-pinned
  fixture artifacts if needed, and the expected arc summary artifact named
  `expected-arc-summary.tsv`.
- **D-03:** Keep provenance tied to the accepted source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, the
  inventory row `prusaslicer.arc-fitting`, and the source path
  `src/libslic3r/Geometry/ArcWelder.cpp`. Fixture update rules must route
  through reviewed intake changes to fork vendors, fork inventories, and the
  Phase 57 scope record, not branch-head observation or live generation.

### Expected arc summary schema

- **D-04:** Use `expected-arc-summary.tsv` as the exact Phase 58 handoff
  artifact for Phase 59. Its field set must mirror the Phase 57 closed
  contract: `source_ref`, `inventory_source_paths`, `source_anchor`,
  `fixture_id`, `fixture_path`, `arc_command_counts`,
  `arc_direction_counts`, `center_offset_observations`,
  `coordinate_bounds`, `extrusion_observations`, `feedrate_observations`,
  and `evidence_boundary`.
- **D-05:** Use one reviewed row per approved arc field. Missing rows,
  duplicate rows, out-of-order rows, unsupported fields, wrong source refs,
  wrong fixture identities, unsupported claim text, and stale documentation
  references must fail closed.
- **D-06:** Keep every row observational. G2/G3 counts are command facts only;
  clockwise/counterclockwise counts are direction observations only; I/J center
  offsets are summary facts only; bounds, extrusion, and feedrate rows are
  checked-in fixture observations only. None of the row values or evidence
  boundaries may claim byte-for-byte G-code parity, ArcWelder algorithm
  equivalence, tolerance/geometry parity, printability, firmware behavior,
  printer-runtime behavior, GUI behavior, support generation, wall seam
  behavior, release behavior, upstream import, sync behavior, or non-Prusa
  fork behavior.

### Verifier ownership and mutation coverage

- **D-07:** Extend `packages/parity-fixtures` with an arc-fitting fixture
  verifier target rather than adding checks to `packages/prusa-arc-fitting-scope`.
  The scope package owns the Phase 57 contract; the fixture package owns
  checked-in fixture bytes, provenance, expected summaries, and fixture drift
  guards.
- **D-08:** Use the existing Bash/Bazel fixture-verifier style: package-local
  paths, `set -euo pipefail`, exact header checks, exact row counts, exact
  required fields, duplicate-field rejection, provenance/source alignment,
  fixture identity checks, README/package-boundary checks, and forbidden-claim
  scanning.
- **D-09:** Add focused mutation tests for the ARCFIX-03 drift classes:
  missing row, duplicate row, out-of-order row, unsupported arc field,
  unsupported broad claim text, wrong source ref, wrong fixture identity, stale
  README/package reference, and provenance mismatch. Keep temp checkouts
  isolated and assert diagnostics that name the failing artifact or field.

### Documentation and publication boundary

- **D-10:** Update `packages/parity-fixtures/README.md`,
  `packages/parity-fixtures/BUILD.bazel`, and the new namespace README only
  enough to expose the Phase 58 fixture corpus, bundle, and verification
  command.
- **D-11:** Do not update `packages/parity/status.tsv`, `packages/parity`
  public command behavior, `packages/slic3r-rust`, or public `docs/port/*`
  publication surfaces in this phase. Those belong to Phase 59 and Phase 60.
- **D-12:** Preserve broad `generated-outputs` as `in progress` and preserve
  the existing `fork.prusaslicer.gcode-output` row wording and meaning.

### the agent's Discretion

- Choose the exact fixture ID and fixture bytes/source excerpt strategy,
  provided the artifact is source-pinned, small, reviewable, and constrained to
  Phase 57 approved arc evidence fields.
- Choose exact Bash helper names, constants, and target names, provided the
  verifier remains readable, exact, Bash 3.2-compatible where practical, and
  fail-closed.
- Choose whether `expected-arc-summary.tsv` validates rows through exact
  multiline constants or field-specific expected values, provided order,
  missing, duplicate, unsupported, provenance, identity, stale-doc, and
  overclaim mutations are covered.

### Deferred Ideas (OUT OF SCOPE)

- Phase 59 owns the pure typed Rust `slic3r_flavors::prusa_arc_fitting`
  parser/readiness boundary and Cargo/Bazel coverage.
- Phase 60 owns public `bazel run //packages/parity:prusaslicer_arc_fitting_parity`,
  fail-closed public mutation guards, exact `fork.prusaslicer.arc-fitting`
  status wording, and public docs.
- Byte-for-byte G-code parity, broad generated-output verification, full
  ArcWelder algorithm equivalence, tolerance/geometry parity, printability,
  firmware behavior, printer-runtime behavior, GUI behavior, support
  generation, wall seam behavior, release behavior, upstream imports, sync
  automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior remain out
  of scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| ARCFIX-01 | Maintainer can inspect a small reviewed Prusa arc-fitting fixture corpus with source-pinned provenance, update rules, fixture identity, expected arc summary paths, and explicit exclusion of generator, runtime, network, sync, host-upload, post-processing, thumbnail, printability, and GUI behavior. [VERIFIED: .planning/REQUIREMENTS.md] | Use the new namespace, namespace README, `.gitattributes`, `fixture-provenance.tsv`, and package README pattern already used by `prusaslicer.gcode-output`. [VERIFIED: packages/parity-fixtures/README.md; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] |
| ARCFIX-02 | Maintainer can inspect checked-in arc-fitting expected summaries that cover only the Phase 57 approved fields. [VERIFIED: .planning/REQUIREMENTS.md] | Use a six-column expected-summary TSV sidecar with one ordered row per Phase 57-approved arc field, mirroring the semantic G-code summary precedent. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv] |
| ARCFIX-03 | Maintainer can run fail-closed fixture verification rejecting missing rows, duplicate rows, out-of-order rows, unsupported arc fields, unsupported claim text, wrong source refs, wrong fixture identities, and stale documentation references. [VERIFIED: .planning/REQUIREMENTS.md] | Extend the existing Bash/Bazel fixture verifier and mutation-test pattern in `packages/parity-fixtures`. The closest precedent test passed locally with `bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; VERIFIED: local bazel test 2026-06-23] |
</phase_requirements>

## Summary

Phase 58 should be planned as a local fixture-package extension, not as Rust parser work or public parity publication. The existing `packages/parity-fixtures` pattern already covers the required mechanics: Bazel-exported fixture bundles, namespace-local provenance, checked-in TSV summaries, Bash exact validators, README boundary checks, and mutation tests against isolated temp copies. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: packages/parity-fixtures/README.md; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

The Phase 57 contract is the closed authority for the arc summary field set and status boundary. It names the accepted source identity, `prusaslicer.arc-fitting` inventory row, `src/libslic3r/Geometry/ArcWelder.cpp` source path, planned fixture namespace, planned `expected-arc-summary.tsv`, and deferrals. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] Phase 57 verification passed and found the scope contract ready for fixture work. [VERIFIED: .planning/phases/57-arc-fitting-scope-contract/57-VERIFICATION.md]

**Primary recommendation:** Add `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` with one tiny reviewed arc observation fixture, `expected-arc-summary.tsv`, provenance, namespace docs, a `verify_prusa_arc_fitting_fixture` Bazel target, and a focused mutation suite; do not touch status rows, public parity targets, Rust crates, or public port docs in Phase 58. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; ASSUMED: exact two-line fixture sufficiency]

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo-local instruction entrypoint and requires reading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant Bright Builds standards before planning or implementation. [VERIFIED: AGENTS.md]
- `AGENTS.bright-builds.md` pins Bright Builds Rules to commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`; the local `standards/` directory was absent, so the pinned GitHub raw files were used for `standards/index.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/verification.md`, `standards/core/testing.md`, and `standards/core/operability.md`. [VERIFIED: AGENTS.bright-builds.md; VERIFIED: local `cat standards/index.md` failed; CITED: https://github.com/bright-builds-llc/bright-builds-rules/tree/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards]
- Repo-local guidance specifically constrains `.planning/phases/*/*-SUMMARY.md` metadata and says not to run `mdformat` over phase summary files; Phase 58 research does not create or edit a summary file. [VERIFIED: AGENTS.md]
- Bright Builds verification requires repo-native verification for changed paths before commit and prefers repo-owned verification entrypoints when available. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Bright Builds test rules require focused tests and Arrange/Act/Assert structure for unit-style tests; the existing Bash mutation tests in this repo already follow that structure in their focused test functions. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]
- No `.claude/skills/` or `.agents/skills/` project-local directories were present, so no project-local skills need to influence this phase. [VERIFIED: local `find .claude/skills` and `find .agents/skills` checks returned no directories]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Bazel | 8.6.0 locally | Expose fixture bundles, `sh_binary` verifier, and `sh_test` mutation suite. [VERIFIED: local `bazel --version`; VERIFIED: packages/parity-fixtures/BUILD.bazel] | This repo already uses Bazel as the top-level build/test entrypoint and the fixture package already wires verifier targets through Bazel. [VERIFIED: .planning/PROJECT.md; VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| Bash verifier scripts | `/bin/bash` 3.2.57 locally | Implement exact fail-closed artifact checks with `set -euo pipefail`. [VERIFIED: local `/bin/bash --version`; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] | Phase 58 locked decisions require the existing Bash/Bazel fixture-verifier style and Bash 3.2-compatible readability where practical. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| TSV sidecars | Repo convention, no external version | Store provenance and expected arc summary rows as checked-in text artifacts. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv] | Existing fixture phases use exact TSV headers, exact rows, row counts, and source/fixture identity checks instead of generated state. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| POSIX/BSD tools | `awk`, `grep`, `sed`, `wc`, `tr`, `mktemp`, `cp`, `mv` available locally | Implement line, field, row-count, temp-copy, and diagnostic assertions in Bash tests. [VERIFIED: local command probes; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] | The existing verifier and tests rely on these tools and passed locally. [VERIFIED: local bazel test 2026-06-23] |
| `shasum` | 6.02 locally | Pin fixture bytes by SHA-256 when a checked-in fixture artifact is added. [VERIFIED: local `shasum --version`; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] | Existing fixture provenance and verifier check byte count plus SHA for checked-in fixture bytes. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| `rg` | 15.1.0 locally | Search codebase and docs during planning and verification review. [VERIFIED: local `rg --version`] | Use for codebase search; do not make runtime verifier behavior depend on `rg` because existing checked-in verifier scripts use portable `grep`/`awk`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| GitHub pinned source URLs | Commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` | Source-anchor references only. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp] | Use in README/provenance as reviewed source identity and source anchors; do not fetch during fixture verification. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Marlin G2/G3 documentation | Current docs page fetched 2026-06-23 | Cross-check G2/G3 direction and I/J center-offset semantics. [CITED: https://marlinfw.org/docs/gcode/G002-G003.html] | Use only to justify observational labels such as `G2` clockwise, `G3` counter-clockwise, and `I`/`J` center offsets; do not claim printer firmware behavior. [CITED: https://marlinfw.org/docs/gcode/G002-G003.html; VERIFIED: .planning/REQUIREMENTS.md out-of-scope boundary] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `packages/parity-fixtures` verifier | Extend `packages/prusa-arc-fitting-scope` verifier | Rejected by locked decision D-07 because Phase 57 owns the scope contract and Phase 58 owns checked-in fixture bytes, provenance, expected summaries, and drift guards. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Checked-in fixture bytes and TSV rows | Live generation from PrusaSlicer or branch-head source | Rejected by locked decisions and requirements because fixture updates must route through reviewed intake changes and the phase excludes generator, runtime, network, sync, and upstream import behavior. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; VERIFIED: .planning/REQUIREMENTS.md] |
| Bash exact verifier | Rust parser in Phase 58 | Rejected by phase boundary because Phase 59 owns the pure typed Rust `slic3r_flavors::prusa_arc_fitting` parser/readiness boundary. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Public parity command/status/docs | Publish in Phase 58 | Rejected by D-11 and D-12 because Phase 60 owns public parity, status, and public docs publication. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |

**Installation:**

No new dependency installation is recommended for Phase 58; use the repo's existing Bazel, Bash, and POSIX toolchain. [VERIFIED: local environment probe; VERIFIED: packages/parity-fixtures/BUILD.bazel]

**Version verification:**

```bash
bazel --version
/bin/bash --version | head -1
shasum --version | head -1
rg --version | head -1
```

These commands were run locally on 2026-06-23 and found Bazel 8.6.0, Bash 3.2.57, `shasum` 6.02, and ripgrep 15.1.0. [VERIFIED: local environment probe]

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity-fixtures/
|-- BUILD.bazel
|-- README.md
|-- verify_prusa_arc_fitting_fixture.sh
|-- verify_prusa_arc_fitting_fixture_test.sh
`-- forks/prusaslicer/prusaslicer.arc-fitting/
    |-- .gitattributes
    |-- README.md
    |-- fixture-provenance.tsv
    |-- arc-fitting-observations.gcode
    `-- expected-arc-summary.tsv
```

This structure mirrors the existing `prusaslicer.gcode-output` fixture namespace and keeps all Phase 58 implementation inside `packages/parity-fixtures`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] The concrete fixture ID `arc-fitting-observations.gcode` is a recommended small reviewed observation artifact, not an upstream-generated output. [ASSUMED]

### Pattern 1: Namespace-Local Fixture Bundle

**What:** Add aliases/filegroups for the new README, provenance TSV, expected arc summary, checked-in fixture artifact, bundle, verifier, verifier test, and package boundary entries. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

**When to use:** Use this for every Phase 58 artifact because the locked namespace is under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Example:**

```python
# Source pattern: packages/parity-fixtures/BUILD.bazel
alias(
    name = "prusa_arc_fitting_expected_arc_summary",
    actual = "forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv",
)

filegroup(
    name = "prusa_arc_fitting_bundle",
    srcs = [
        "forks/prusaslicer/prusaslicer.arc-fitting/.gitattributes",
        "forks/prusaslicer/prusaslicer.arc-fitting/README.md",
        "forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv",
        "forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv",
        "forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode",
    ],
)
```

The exact target names above are recommended to match existing naming style such as `prusa_gcode_output_bundle` and `verify_prusa_gcode_output_fixture`. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

### Pattern 2: Six-Column Expected Summary With Closed Field Rows

**What:** Use a six-column TSV shape analogous to `expected-gcode-semantic-summary.tsv`: `source_ref`, `fixture_path`, `<field_name>`, `<category>`, `<value>`, and `evidence_boundary`. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

**When to use:** Use it for `expected-arc-summary.tsv` so Phase 59 can parse one reviewed row per approved arc field. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Recommended header and ordered field list:**

```text
source_ref	fixture_path	arc_field	arc_category	arc_value	evidence_boundary
source_ref
inventory_source_paths
source_anchor
fixture_id
fixture_path
arc_command_counts
arc_direction_counts
center_offset_observations
coordinate_bounds
extrusion_observations
feedrate_observations
evidence_boundary
```

The field list above is the Phase 57 closed contract and must be checked in that order. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

### Pattern 3: Source-Pinned Fixture Byte Strategy

**What:** Use one tiny checked-in artifact with one `G2` row and one `G3` row, then summarize only the approved Phase 57 fields. [ASSUMED] A candidate fixture payload is:

```gcode
G2 X10.000 Y0.000 I5.000 J0.000 E0.50000 F1800
G3 X0.000 Y0.000 I-5.000 J0.000 E1.00000 F1800
```

**Why this candidate works for planning:** It gives deterministic observations for command counts, direction labels, I/J center-offset fields, coordinate bounds, extrusion values, and feedrates without needing generation or runtime execution. [ASSUMED] `G2`/`G3` direction and `I`/`J` center-offset semantics are documented by Marlin's G-code reference; Phase 58 should cite those only as notation semantics, not as printer-runtime support. [CITED: https://marlinfw.org/docs/gcode/G002-G003.html; VERIFIED: .planning/REQUIREMENTS.md]

**Candidate byte facts:** The payload above is 2 LF-terminated lines, 94 bytes, and SHA-256 `b1db8e3ef28d47f045f1eec852e4f83675da920b312abeeb3f3e40a5927f796f` when encoded as ASCII LF. [VERIFIED: local `printf | wc -c | shasum -a 256 | wc -l` probe]

**Required source anchors:** Provenance should cite `ArcWelder.cpp` comments that name G2/G3 arc output, orientation code that distinguishes CCW/CW, and fit-path code that adds an arc segment with endpoint, radius, and direction. [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp#L4-L7; CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp#L400-L404; CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp#L630-L634]

### Pattern 4: Fail-Closed Bash Verifier

**What:** Validate file presence, ASCII/LF encoding, exact headers, exact row counts, allowed fields, field uniqueness, ordered exact rows, source/fixture alignment, provenance row, README references, package README references, forbidden claims, and forbidden verifier behavior terms. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**When to use:** Use this for `verify_prusa_arc_fitting_fixture.sh`; do not add a generic parser or broad G-code semantics in Phase 58. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Example:**

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
readonly ARC_REQUIRED_FIELDS="source_ref inventory_source_paths source_anchor fixture_id fixture_path arc_command_counts arc_direction_counts center_offset_observations coordinate_bounds extrusion_observations feedrate_observations evidence_boundary"

require_arc_allowed_fields() {
	awk -F '\t' -v label="expected-arc-summary.tsv" '
		NR == 1 { next }
		$3 != "source_ref" &&
			$3 != "inventory_source_paths" &&
			$3 != "source_anchor" &&
			$3 != "fixture_id" &&
			$3 != "fixture_path" &&
			$3 != "arc_command_counts" &&
			$3 != "arc_direction_counts" &&
			$3 != "center_offset_observations" &&
			$3 != "coordinate_bounds" &&
			$3 != "extrusion_observations" &&
			$3 != "feedrate_observations" &&
			$3 != "evidence_boundary" {
			printf "error: %s: unsupported arc field: %s\n", label, $3 > "/dev/stderr"
			exit 1
		}
	' "${arc_summary_file}"
}
```

The existing semantic verifier also checks ordered exact rows and reports "rows out of order" diagnostics, which directly matches ARCFIX-03. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

### Pattern 5: Mutation Tests Use Temp Copies

**What:** Copy a valid fixture namespace into `mktemp`, mutate one artifact per test, run the verifier against explicit file arguments, and assert diagnostics that name the artifact or field. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**When to use:** Use one test per ARCFIX-03 drift class. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; VERIFIED: .planning/REQUIREMENTS.md]

**Example:**

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
test_duplicate_arc_row_fails() {
	# Arrange
	local dir="${tmp_dir}/duplicate-arc-row"
	local summary_file="${dir}/packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
	local duplicate_row
	write_valid_fixture_copy "${dir}"
	duplicate_row="$(awk -F '\t' '$3 == "arc_command_counts" { print; exit }' "${summary_file}")"
	printf '%s\n' "${duplicate_row}" >>"${summary_file}"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/duplicate-arc-row.out" "${tmp_dir}/duplicate-arc-row.err"; then
		fail "duplicate arc row fixture passed"
	fi

	# Assert
	assert_contains_all "${tmp_dir}/duplicate-arc-row.err" "duplicate arc field" "arc_command_counts" "expected-arc-summary.tsv"
}
```

## Anti-Patterns to Avoid

- **Placing arc evidence under `prusaslicer.gcode-output`:** This contradicts D-01 and would widen the existing `fork.prusaslicer.gcode-output` meaning. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]
- **Adding `fork.prusaslicer.arc-fitting` to `packages/parity/status.tsv`:** Phase 60 owns that public status row; Phase 58 must preserve `generated-outputs` and the existing G-code row. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; VERIFIED: packages/parity/status.tsv]
- **Fetching upstream source or generating fixtures in the verifier:** Existing fixture verification checks checked-in artifacts only, and Phase 58 excludes live generation, network, upstream import, and sync behavior. [VERIFIED: packages/parity-fixtures/README.md; VERIFIED: .planning/REQUIREMENTS.md]
- **Presence-only TSV checks:** ARCFIX-03 requires failures for missing, duplicate, out-of-order, unsupported, wrong-source, wrong-identity, overclaim, and stale-doc mutations. [VERIFIED: .planning/REQUIREMENTS.md]
- **Embedding a Rust parser early:** Phase 59 owns the Rust boundary, and Phase 58 should leave `packages/slic3r-rust` untouched. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| ArcWelder behavior proof | A custom arc-fitting algorithm, geometry comparator, tolerance verifier, or printer simulator | Checked-in fixture observations plus Phase 57-approved fields | The milestone explicitly defers full ArcWelder algorithm equivalence, tolerance/geometry parity, printability, firmware behavior, and runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| Public evidence path | A new public `//packages/parity:prusaslicer_arc_fitting_parity` target | Package-local `//packages/parity-fixtures:verify_prusa_arc_fitting_fixture` | Phase 60 owns public parity command behavior. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Source refresh | Git clone/fetch, GitHub API calls, branch-head observation, or source import in verifier | Static provenance rows and reviewed intake update route | Fixture update rules must route through reviewed intake changes, not live generation or branch heads. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| TSV validation | A general-purpose permissive TSV parser that accepts unknown fields | Exact headers, exact row counts, allowed fields, unique field counts, exact ordered rows | Existing fixture verifier pattern is fail-closed and ARCFIX-03 requires unsupported fields and stale rows to fail. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: .planning/REQUIREMENTS.md] |
| Documentation publication | Public `docs/port/*` updates | Minimal `packages/parity-fixtures/README.md` and namespace README updates | D-10 permits only package/namespace docs for Phase 58; D-11 defers public docs. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |

**Key insight:** Phase 58 is about making a small, reviewable artifact impossible to drift silently; it is not about proving slicer output correctness or printer behavior. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Status Widening Through Fixture Docs

**What goes wrong:** README text implies arc fitting is covered by the existing G-code output status row or broad `generated-outputs`. [VERIFIED: packages/parity/status.tsv; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Why it happens:** Arc fitting is generated-output-adjacent, and the existing `prusaslicer.gcode-output` namespace already has semantic evidence. [VERIFIED: packages/parity-fixtures/README.md; VERIFIED: packages/parity/status.tsv]

**How to avoid:** Add explicit verifier checks for "artifact remains checked-in fixture evidence only" language and forbidden public parity/status claims. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Warning signs:** New text mentions `fork.prusaslicer.arc-fitting`, `prusaslicer_arc_fitting_parity`, or "verified arc-fitting parity" outside planned/deferred wording. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

### Pitfall 2: Row Count Without Row Order

**What goes wrong:** A TSV has the right fields but reordered rows, which can make Phase 59 parser expectations unstable. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Why it happens:** Field-count checks catch missing/duplicates but not sequence. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**How to avoid:** Use exact ordered multiline constants or row-number checks, and add an out-of-order mutation test. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Warning signs:** Verifier uses `grep -Fxq` for each row but never compares row number or next expected field. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### Pitfall 3: Unsupported Claim Text Hidden in Evidence Boundary

**What goes wrong:** A row value or boundary text claims byte parity, algorithm equivalence, printability, firmware behavior, runtime behavior, GUI behavior, support, seam, release, sync, or non-Prusa behavior. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Why it happens:** Evidence-boundary columns are prose, and prose can overclaim even when field names are correct. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

**How to avoid:** Scan `packages/parity-fixtures/README.md`, namespace README, provenance, expected summary, and verifier source for forbidden claim phrases, using split literals in the verifier when needed to avoid self-match false positives. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Warning signs:** A forbidden phrase appears in a checked artifact or the verifier fails because it matches its own forbidden list. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### Pitfall 4: Source Anchor Drift

**What goes wrong:** Provenance cites the right source identity but wrong source path, stale source anchors, or companion upstream files not approved by Phase 57. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

**Why it happens:** The upstream tree also contains `tests/libslic3r/test_arc_welder.cpp`, but Phase 58 locked provenance to `src/libslic3r/Geometry/ArcWelder.cpp`. [VERIFIED: GitHub tree API query 2026-06-23; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**How to avoid:** Keep `source_path` exactly `src/libslic3r/Geometry/ArcWelder.cpp` unless a reviewed intake/scope change expands the accepted paths. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]

**Warning signs:** `fixture-provenance.tsv` includes `tests/libslic3r/test_arc_welder.cpp` as the primary accepted source path without a scope update. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

### Pitfall 5: Documentation References Not Guarded

**What goes wrong:** The expected summary is correct, but package or namespace README text points to the old G-code namespace, wrong target, or stale artifact name. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

**Why it happens:** Existing package README has accumulated phase ladder text and can become stale when new sidecars are added. [VERIFIED: packages/parity-fixtures/README.md]

**How to avoid:** Verify exact README snippets for namespace, artifact path, bundle target, verifier target, update route, and phase boundary. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Warning signs:** Mutation tests do not remove README lines or truncate package boundary text. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

## Code Examples

Verified patterns from local sources:

### Exact Header and Line Count

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
require_exact_header "${arc_summary_file}" "expected-arc-summary.tsv" "${ARC_SUMMARY_HEADER}"
require_line_count "${arc_summary_file}" "expected-arc-summary.tsv" "13"
```

The line count should be 13 when the file has one header plus the 12 approved Phase 57 fields. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

### Field Count and Duplicate Rejection

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
require_arc_field_counts() {
	awk -F '\t' \
		-v label="expected-arc-summary.tsv" \
		-v required_fields="${ARC_REQUIRED_FIELDS}" '
		BEGIN { required_count = split(required_fields, required, " ") }
		NR == 1 { next }
		{ counts[$3]++ }
		END {
			failed = 0
			for (i = 1; i <= required_count; i++) {
				field = required[i]
				actual = counts[field] + 0
				if (actual == 1) {
					continue
				}
				if (actual > 1) {
					printf "error: %s: duplicate arc field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
				} else {
					printf "error: %s: missing arc field: %s count %d, expected 1\n", label, field, actual > "/dev/stderr"
				}
				failed = 1
			}
			exit failed
		}
	' "${arc_summary_file}"
}
```

This pattern is adapted from the structural and semantic summary validators that already reject missing and duplicate fields. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

### Provenance Alignment

```bash
# Source pattern: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
require_arc_provenance_alignment() {
	awk -F '\t' \
		-v label="expected-arc-summary.tsv" \
		-v source_ref="${SOURCE_REF}" \
		-v fixture_path="${FIXTURE_PATH}" '
		NR == 1 { next }
		$1 != source_ref || $2 != fixture_path {
			printf "error: %s: provenance mismatch for %s\n", label, $3 > "/dev/stderr"
			exit 1
		}
	' "${arc_summary_file}"
}
```

The existing semantic verifier uses this same source/fixture path alignment pattern. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source pins and inventories as planning inputs only | Checked-in fixture namespaces with provenance, expected summaries, verifier targets, and later Rust/public evidence | v1.10-v1.14 evidence ladder [VERIFIED: .planning/PROJECT.md; VERIFIED: .planning/STATE.md] | Phase 58 should add fixture evidence without treating inventory metadata as executable proof. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; VERIFIED: .planning/REQUIREMENTS.md] |
| Marker-only G-code summary | Structural and semantic checked-in TSV sidecars with fail-closed mutation guards | Phases 50 and 54, published through Phase 56 [VERIFIED: packages/parity-fixtures/README.md; VERIFIED: .planning/STATE.md] | Arc summary should use the same sidecar discipline and exact verifier checks. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Publishing status rows before executable evidence | Scope -> fixture -> Rust boundary -> public evidence/status/docs | v1.12-v1.15 ladder [VERIFIED: .planning/ROADMAP.md; VERIFIED: .planning/STATE.md] | Phase 58 must not publish `fork.prusaslicer.arc-fitting` or public docs. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Runtime/source discovery in validation | Caller-supplied or checked-in artifacts only | Existing fixture package and Phase 57 contract [VERIFIED: packages/parity-fixtures/README.md; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] | The verifier should fail if its own source includes fetch/clone/generator behavior terms. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

**Deprecated/outdated:**

- Treating a source inventory row as proof of behavior is outdated in this repo; verified fork status is reserved for executable evidence chains. [VERIFIED: .planning/PROJECT.md; VERIFIED: packages/fork-inventories/prusaslicer.tsv]
- Treating the existing `fork.prusaslicer.gcode-output` row as covering arc fitting is explicitly forbidden by Phase 58. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; VERIFIED: packages/parity/status.tsv]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | A two-line reviewed `arc-fitting-observations.gcode` fixture with one `G2` row and one `G3` row is sufficient for ARCFIX-01/02 when paired with source-pinned provenance and strict no-runtime boundaries. | Architecture Patterns / Pattern 3 | Maintainers may require the fixture artifact to be derived from a source-controlled upstream test or source excerpt instead of a hand-reviewed observation sample; planner should either confirm this strategy or choose a stricter source-excerpt artifact while keeping the same summary/verifier design. |

## Open Questions (RESOLVED)

1. **RESOLVED: Use the two-line reviewed observation fixture.**
   - What we know: Phase 58 gives the agent discretion to choose fixture ID and fixture bytes/source excerpt strategy, and the artifact must be source-pinned, small, reviewable, and constrained to Phase 57 fields. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md]
   - Resolution basis: The upstream `ArcWelder.cpp` source path has source anchors for arc behavior, but it does not contain checked-in G-code fixture lines; the upstream tree also contains `tests/libslic3r/test_arc_welder.cpp`, which is not the locked Phase 58 source path. [VERIFIED: GitHub raw/source tree queries 2026-06-23; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md]
   - Resolution: Plan 58-01 uses the two-line reviewed `arc-fitting-observations.gcode` fixture embodied by the existing plan, paired with source-pinned provenance and `expected-arc-summary.tsv`; no source-excerpt artifact is added. [RESOLVED]

2. **RESOLVED: Do not include an explicit source file SHA.**
   - What we know: Existing G-code fixture provenance records fixture byte count/SHA and upstream URL, not source-file SHA. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv]
   - Resolution basis: Arc-fitting provenance could record `ArcWelder.cpp` SHA-256 `cfab5acd9ea364086a42a3aa62a226b278d8779d00479c573547ffb42daf7443`, which was verified from the pinned raw source, but the existing plan does not add that column or value. [VERIFIED: local `curl | shasum -a 256` probe]
   - Resolution: Keep Plan 58-01 aligned with existing fixture provenance precedent: pin accepted source identity, inventory ID, source path, source anchors, fixture bytes, update route, and exclusions; do not add a source-file SHA unless a future reviewed plan explicitly expands the provenance schema. [RESOLVED]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `sh_binary`/`sh_test` fixture verification | yes | 8.6.0 | Direct script execution with explicit file args can diagnose locally, but Bazel target wiring is required for repo verification. [VERIFIED: local `bazel --version`; VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| `/bin/bash` | Verifier and mutation scripts | yes | 3.2.57 | None needed; write Bash 3.2-compatible scripts. [VERIFIED: local `/bin/bash --version`; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| `shasum` | Fixture byte integrity | yes | 6.02 | Could use platform-specific SHA tools, but existing repo pattern uses `shasum -a 256`. [VERIFIED: local `shasum --version`; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| `awk`/`grep`/`sed`/`wc`/`tr`/`mktemp` | TSV checks and mutation tests | yes | system tools | None needed; existing tests already use these tools and pass. [VERIFIED: local command probes; VERIFIED: local bazel test 2026-06-23] |
| `rg` | Planning/code review search | yes | 15.1.0 | Use `grep` if absent; do not depend on `rg` in checked-in verifier. [VERIFIED: local `rg --version`; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

**Missing dependencies with no fallback:**

- None found for Phase 58 fixture research and planned implementation. [VERIFIED: local environment probe]

**Missing dependencies with fallback:**

- None found. [VERIFIED: local environment probe]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | No authentication, credentials, accounts, or secrets are introduced by Phase 58. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| V3 Session Management | no | No sessions or stateful user flows are introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | no | No authorization boundary is introduced; artifacts are checked-in local files. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | yes | Exact TSV headers, column counts, allowed fields, required-field counts, exact rows, source/fixture alignment, and forbidden-claim scanning. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| V6 Cryptography | limited | Use SHA-256 only as artifact integrity/provenance checking, not as a security protocol or secret. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] |

### Known Threat Patterns for Bash/TSV Fixture Verification

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Artifact tampering or stale fixture bytes | Tampering | Exact byte count, SHA-256, ASCII/LF, exact row, and source/provenance checks. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Overclaiming generated-output/runtime behavior | Spoofing / Repudiation | Forbidden claim scanning across package README, namespace README, provenance, and expected summary. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |
| Wrong source reference or fixture identity | Tampering | Enforce exact `SOURCE_REF`, `FIXTURE_PATH`, `FIXTURE_ID`, inventory ID, source path, and provenance row. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| Shell injection through verifier inputs | Tampering / Elevation of privilege | Quote variable expansions, avoid `eval`, avoid executing fixture content, and keep verifier behavior to local file reads and POSIX text tools. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Network or upstream import during verification | Information Disclosure / Tampering | Self-scan verifier source for fetch/clone/curl-style behavior terms and keep update route in reviewed intake docs only. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md` - locked Phase 58 decisions, discretion, and deferred scope. [VERIFIED]
- `.planning/ROADMAP.md` - Phase 58 goal, success criteria, dependency, and requirement IDs. [VERIFIED]
- `.planning/REQUIREMENTS.md` - ARCFIX-01, ARCFIX-02, ARCFIX-03, and v1.15 out-of-scope table. [VERIFIED]
- `.planning/STATE.md` and `.planning/PROJECT.md` - evidence-ladder history and current milestone constraints. [VERIFIED]
- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - approved Phase 57 field contract, source identity, traceability, planned paths, and boundaries. [VERIFIED]
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` and `_test.sh` - scope verifier and mutation precedent. [VERIFIED]
- `packages/parity-fixtures/BUILD.bazel` - fixture export, bundle, verifier, test, and package boundary pattern. [VERIFIED]
- `packages/parity-fixtures/README.md` - package-level fixture rules and no-runtime/no-fetch boundary. [VERIFIED]
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` and `_test.sh` - closest fixture verifier and mutation harness. [VERIFIED]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` - namespace README, `.gitattributes`, provenance, and expected semantic TSV precedent. [VERIFIED]
- `packages/fork-inventories/prusaslicer.tsv`, `packages/fork-inventories/category-map.tsv`, and `packages/parity/status.tsv` - source inventory, category map, and status boundaries. [VERIFIED]
- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape, verification, testing, and operability. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/tree/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards]
- PrusaSlicer `ArcWelder.cpp` at commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` - source anchors and source SHA. [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp]

### Secondary (MEDIUM confidence)

- Marlin G2/G3 G-code documentation - direction and I/J notation semantics for fixture labels only. [CITED: https://marlinfw.org/docs/gcode/G002-G003.html]
- GitHub tree API query for PrusaSlicer pinned commit - confirmed `tests/libslic3r/test_arc_welder.cpp` exists, but Phase 58 source path remains locked to `ArcWelder.cpp`. [VERIFIED: local `curl` query 2026-06-23]

### Tertiary (LOW confidence)

- None used as authoritative sources. [VERIFIED: research source log]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - all recommended tools and patterns are already present locally or in repo fixtures, and closest tests passed. [VERIFIED: local environment probe; VERIFIED: local bazel tests 2026-06-23]
- Architecture: HIGH for namespace/verifier/Bazel wiring because it directly mirrors existing package patterns; MEDIUM for exact fixture bytes because the two-line observation artifact is a new recommended design. [VERIFIED: packages/parity-fixtures/BUILD.bazel; ASSUMED: exact fixture-byte sufficiency]
- Pitfalls: HIGH - pitfalls map directly to locked decisions and existing mutation coverage. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]
- Security: MEDIUM - the phase has no auth/session surfaces, but shell/text validators still need careful quoting and no-network guards. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh]

**Research date:** 2026-06-23
**Valid until:** 2026-07-23
