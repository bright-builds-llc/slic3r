# Phase 63: Wall-Seam Fixture Corpus - Research

**Researched:** 2026-06-26
**Domain:** Source-pinned PrusaSlicer fixture artifacts, TSV evidence contracts, Bash/Bazel verification
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for all copied constraints in this block: [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Fixture namespace and provenance

- **D-01:** Use the Phase 62 planned flat namespace
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/` instead
  of adding subdirectories or broad generated-output fixture intake. This
  matches the existing Prusa fixture namespace pattern and keeps Phase 63
  reviewable.
- **D-02:** Add one tiny checked-in ASCII/LF wall-seam observation fixture,
  expected as `wall-seam-observations.gcode`, unless implementation discovers
  a narrow reason to rename the file and records that reason in the plan
  summary. The fixture should be small enough for exact byte/SHA review and
  should contain only static observation data.
- **D-03:** Shape `fixture-provenance.tsv` after the Phase 58 arc-fitting
  precedent with one row containing fixture identity, vendor, inventory ID,
  accepted source ref, accepted tag, peeled commit, source path, source
  anchors, byte count, SHA-256, line-ending/encoding, role, Phase 62 scope
  record path, update route, status scope, privacy/post-processing exclusions,
  and broad deferrals.
- **D-04:** The update route should require a reviewed intake change that
  updates `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/prusaslicer.tsv`, and
  `packages/prusa-wall-seam-scope/wall-seam-scope.md`. Branch-head
  observation, upstream import, live generation, network access, and sync
  behavior must not update checked-in fixture bytes or expected-summary rows.

### Expected wall-seam summary

- **D-05:** Use an arc-style long-row TSV named
  `expected-wall-seam-summary.tsv` with header:
  `source_ref`, `fixture_path`, `wall_seam_field`,
  `wall_seam_category`, `wall_seam_value`, and `evidence_boundary`.
- **D-06:** Include exactly the 12 Phase 62 approved fields in approved order:
  `source_ref`, `inventory_source_paths`, `source_anchor`,
  `fixture_id`, `fixture_path`, `seam_transition_observations`,
  `layer_context_observations`, `travel_context_observations`,
  `coordinate_bounds`, `extrusion_observations`,
  `retraction_observations`, and `evidence_boundary`.
- **D-07:** Keep summary values deterministic ASCII/LF `key:value` style
  facts that are easy to verify exactly in Bash and easy for Phase 64 to parse
  into typed Rust values. Do not use JSON or a wide one-row fixture table in
  Phase 63.
- **D-08:** Every summary row must carry explicit evidence-boundary text. The
  final boundary value should remain a narrow phrase such as
  `checked-in-wall-seam-summary-only`; rows must not imply byte parity, full
  wall-seam algorithm equivalence, seam visibility, printability, runtime,
  firmware, GUI, or generated-output status evidence.

### Fixture verifier and mutation coverage

- **D-09:** Add `verify_prusa_wall_seam_fixture.sh` as a local-file-only Bash
  verifier in `packages/parity-fixtures`, following the arc-fitting fixture
  verifier pattern: `set -euo pipefail`, deterministic `error:` diagnostics,
  package-local defaults, Bazel-compatible argument mode, and final
  `ok: Prusa wall-seam fixture verification passed` output.
- **D-10:** The verifier must check fixture bytes, SHA-256, ASCII/LF encoding,
  provenance header and exact row, expected-summary header, exact row count,
  supported field set, required field counts, provenance alignment, exact
  approved row order, package README text, namespace README text, current
  status boundaries, and no overclaiming text.
- **D-11:** Add `verify_prusa_wall_seam_fixture_test.sh` with isolated temp
  fixture copies and focused mutation cases. Required failure classes include
  missing rows, duplicate rows, out-of-order rows, unsupported seam fields,
  unsupported claim text, wrong source refs, wrong fixture identities,
  checksum drift, stale package documentation references, generated-output
  status promotion, sibling status-row widening, and premature
  `fork.prusaslicer.wall-seam` publication.
- **D-12:** Wire Bazel aliases, a `prusa_wall_seam_bundle` filegroup,
  `verify_prusa_wall_seam_fixture` sh_binary, and
  `verify_prusa_wall_seam_fixture_test` sh_test in
  `packages/parity-fixtures/BUILD.bazel`. The bundle should include
  `.gitattributes`, namespace README, fixture bytes, provenance TSV, and
  expected summary TSV.

### Phase handoff boundaries

- **D-13:** Phase 63 may update `packages/parity-fixtures/README.md` and
  package-local fixture docs to describe the fixture namespace and verifier,
  but it must not update public parity status, add the Phase 65 public command,
  or publish public port docs as verified wall-seam evidence.
- **D-14:** Phase 64 owns the pure typed Rust boundary
  `slic3r_flavors::prusa_wall_seam` and parser/readiness tests over the
  checked-in summary artifact. Phase 63 should make that handoff easy by
  keeping field names, categories, values, and evidence boundaries stable and
  exact.
- **D-15:** Phase 65 owns `bazel run
  //packages/parity:prusaslicer_wall_seam_parity`, the
  `fork.prusaslicer.wall-seam` status row, public mutation guards, and public
  port/package docs. Phase 63 verifier status checks should keep that row
  absent until Phase 65.

### the agent's Discretion

- Choose the exact static G-code observation lines, provided they are small,
  deterministic, ASCII/LF, reviewed as checked-in observation input only, and
  support all 12 approved summary fields without claiming generated-output
  parity.
- Choose exact `key:value` summary value grammar, provided the grammar is
  deterministic, readable, and suitable for exact Bash checks plus later typed
  Rust parsing.
- Choose helper names and mutation test names, provided the verifier remains
  local-file-only, fail-closed, and each mutation test proves one clear
  failure mode.

### Deferred Ideas (OUT OF SCOPE)

- Multiple wall-seam fixture files or a subdirectory-based fixture family are
  deferred until a future phase explicitly needs broader wall-seam corpus
  growth.
- JSON-valued summary rows and wide one-row fixture summaries are deferred; the
  long-row TSV shape is preferred for exact Bash verification and Phase 64
  Rust parsing.
- Phase 64 owns typed Rust parsing, readiness metadata, and Cargo/Bazel parser
  tests.
- Phase 65 owns public executable evidence, public status/docs publication,
  and public wall-seam mutation guards.
- Broad generated-output parity, byte-for-byte G-code parity, full wall-seam
  algorithm or geometry equivalence, seam visibility, printability, runtime,
  GUI, release, sync, non-Prusa forks, upstream imports, and external device
  behavior remain out of scope.
</user_constraints>

## Project Constraints (from AGENTS.md)

- Planning and implementation must read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant `standards/` pages before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards/index.md]
- The managed Bright Builds block in `AGENTS.md` and the managed `AGENTS.bright-builds.md` file must not be edited downstream. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Phase `*-SUMMARY.md` files must keep `requirements-completed` frontmatter in sync, must use the exact hyphenated key, and must not be processed with `mdformat`; Phase 63 research does not edit summaries, but the planner must preserve this rule for later summaries. [VERIFIED: AGENTS.md]
- Non-trivial work needs a short checkable plan with verification steps, and verification evidence is required before done. [VERIFIED: AGENTS.md]
- Bash scripts should use `#!/usr/bin/env bash`, `set -euo pipefail`, fail fast, reduce nesting with guard-style flow, and avoid swallowed failures. [VERIFIED: AGENTS.md; standards/core/code-shape.md]
- Checked-in scripts should be rerunnable and easy to diagnose, with clear diagnostics and thin orchestration. [VERIFIED: standards/core/code-shape.md]
- Tests should cover one concern per test and use Arrange, Act, Assert when useful. [VERIFIED: AGENTS.md; standards/core/testing.md]
- Before commit, run repo-relevant verification for changed paths; repo-owned Bazel verifier targets are preferred when available. [VERIFIED: AGENTS.bright-builds.md; standards/core/verification.md]
- The user specifically instructed not to read agent definition files and not to use generic agents for this research. [VERIFIED: user prompt]

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| SEAMFIX-01 | Maintainer can inspect a small reviewed Prusa wall-seam fixture corpus with source-pinned provenance, update rules, fixture identity, expected wall-seam summary paths, and explicit exclusion of generator, runtime, network, sync, host-upload, post-processing, thumbnail, printability, and GUI behavior. | Use the flat namespace, `.gitattributes`, README, one checked-in `.gcode`, and one-row `fixture-provenance.tsv` pattern from Phase 58 arc-fitting. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| SEAMFIX-02 | Maintainer can inspect checked-in wall-seam expected summaries that cover only the Phase 62 approved fields. | Use `expected-wall-seam-summary.tsv` with the six-column long-row header and the 12 approved fields in Phase 62 order. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| SEAMFIX-03 | Maintainer can run fail-closed fixture verification that rejects row drift, unsupported fields or claim text, wrong source/fixture identity, checksum drift, and stale docs. | Adapt `verify_prusa_arc_fitting_fixture.sh` and `verify_prusa_arc_fitting_fixture_test.sh` to wall-seam constants, row order, status absence, and doc text. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] |
</phase_requirements>

## Summary

Phase 63 should be planned as a narrow internal evidence-artifact phase, not as a parser, public parity command, public status publication, or runtime generation phase. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; .planning/ROADMAP.md]

The strongest precedent is Phase 58 `prusaslicer.arc-fitting`: it uses a flat namespace with `.gitattributes`, namespace README, one tiny ASCII/LF observation `.gcode`, one-row provenance TSV, long-row expected summary TSV, package README text, Bazel filegroup, local Bash verifier, and isolated mutation suite. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md; packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Primary recommendation:** Mirror the arc-fitting fixture implementation shape exactly, replacing arc constants with the Phase 62 wall-seam source identity, planned namespace, 12 approved wall-seam fields, absent `fork.prusaslicer.wall-seam` status guard, and Phase 64/65 handoff wording. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

## Standard Stack

### Core

| Tool or Format | Version | Purpose | Why Standard | Source |
|----------------|---------|---------|--------------|--------|
| Bash | 3.2.57 | Implement local fixture verifier and mutation suite. | Existing fixture verifiers are Bash scripts with `set -euo pipefail`, deterministic `error:` diagnostics, package-local defaults, and Bazel-compatible argument mode. | [VERIFIED: local `bash --version`; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Bazel | 8.6.0 | Export fixture files, run verifier, and run mutation test target. | `packages/parity-fixtures/BUILD.bazel` already exposes Prusa fixture bundles with `filegroup`, `sh_binary`, and `sh_test`. | [VERIFIED: local `bazel --version`; packages/parity-fixtures/BUILD.bazel] |
| TSV | repo-local exact text format | Store provenance and expected wall-seam summary rows. | Arc-fitting provenance and expected summaries are TSV with exact headers, exact rows, and exact row counts. | [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv] |
| ASCII/LF `.gcode` fixture text | repo-local exact text format | Store static wall-seam observation input. | Arc-fitting verifies ASCII/LF encoding, byte count, SHA-256, and exact lines for its checked-in `.gcode` fixture. | [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/.gitattributes; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |

### Supporting

| Tool | Version | Purpose | When to Use | Source |
|------|---------|---------|-------------|--------|
| ShellCheck | 0.11.0 | Static analysis for changed Bash verifier and mutation test scripts. | Run before commit for new or changed shell scripts when available. | [VERIFIED: local `shellcheck --version`; .planning/phases/62-wall-seam-scope-contract/62-VERIFICATION.md] |
| `shasum -a 256` | system tool | Compute and verify fixture SHA-256. | Use after `wall-seam-observations.gcode` is created, then lock exact SHA in provenance and verifier constants. | [VERIFIED: local `command -v shasum`; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| `awk`, `grep`, `sed`, `wc`, `tr`, `mktemp`, `cp`, `mv`, `chmod` | system tools | Exact row checks and isolated temp fixture mutation tests. | Use inside local Bash verifier/test; these tools are already used by the arc fixture verifier and are locally available. | [VERIFIED: local command availability audit; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Long-row TSV summary | JSON or one wide row | Rejected for Phase 63 by user decision; Bash exact checks and Phase 64 parser handoff expect deterministic long-row TSV. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Local Bash verifier | Rust parser or public comparator | Rejected for Phase 63 by phase boundary; Phase 64 owns Rust parsing and Phase 65 owns public evidence. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; .planning/ROADMAP.md] |
| One flat namespace | Multiple fixture subdirectories | Rejected for Phase 63 by user decision; broader fixture families are deferred. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Checked-in static fixture | Upstream clone, live PrusaSlicer generation, or network fetch | Rejected by scope and fixture rules; update route is reviewed intake, not branch-head or live generation. [VERIFIED: packages/parity-fixtures/README.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |

**Installation:**

No package installation is needed for planning; all required local tools are present. [VERIFIED: local environment availability audit]

**Version verification:**

```bash
bash --version | head -1
bazel --version
shellcheck --version
command -v shasum awk grep sed wc tr mktemp cp mv chmod git
```

The npm registry does not apply because Phase 63 adds local Bash, Bazel, Markdown, TSV, and static fixture artifacts only. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/BUILD.bazel]

## Architecture Patterns

### Recommended Project Structure

Use this flat structure under the existing package. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting]

```text
packages/parity-fixtures/
|-- BUILD.bazel
|-- README.md
|-- verify_prusa_wall_seam_fixture.sh
|-- verify_prusa_wall_seam_fixture_test.sh
`-- forks/prusaslicer/prusaslicer.wall-seam/
    |-- .gitattributes
    |-- README.md
    |-- wall-seam-observations.gcode
    |-- fixture-provenance.tsv
    `-- expected-wall-seam-summary.tsv
```

### Pattern 1: Flat Source-Pinned Namespace

**What:** Create one flat `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/` namespace with `.gitattributes`, README, fixture bytes, provenance TSV, and expected-summary TSV. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting]

**When to use:** Use for Phase 63 because the phase owns only one tiny checked-in wall-seam observation fixture and not a corpus family. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**Example:**

```text
*.gcode text eol=lf
*.tsv text eol=lf
README.md text eol=lf
```

Source: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/.gitattributes`. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/.gitattributes]

### Pattern 2: Long-Row Expected Summary

**What:** Use six TSV columns: `source_ref`, `fixture_path`, `wall_seam_field`, `wall_seam_category`, `wall_seam_value`, and `evidence_boundary`. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**When to use:** Use for all expected wall-seam rows so each approved field has one exact row and one explicit evidence boundary. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**Recommended row order:** `source_ref`, `inventory_source_paths`, `source_anchor`, `fixture_id`, `fixture_path`, `seam_transition_observations`, `layer_context_observations`, `travel_context_observations`, `coordinate_bounds`, `extrusion_observations`, `retraction_observations`, `evidence_boundary`. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Pattern 3: One-Row Provenance Manifest

**What:** Use the arc-fitting provenance header shape, with the scope-record column renamed to `phase62_scope_record`, and lock exact fixture bytes and SHA-256 after the fixture file is created. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**When to use:** Use for `fixture-provenance.tsv` so fixture identity, vendor, inventory ID, source ref, tag, peeled commit, source path, anchors, bytes, SHA, encoding, role, update route, status scope, exclusions, and deferrals are inspectable in one row. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**Important planning note:** Do not guess byte count or SHA before creating the final fixture file; compute them from the checked-in bytes and then freeze them in provenance and verifier constants. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

### Pattern 4: Exact Bash Verifier

**What:** Adapt the arc verifier structure: resolve package-local defaults, accept Bazel-provided explicit paths, define readonly constants for approved headers/rows/paths/status rows, validate files, reject forbidden behavior and claim terms, and print one final ok line. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**When to use:** Use for `verify_prusa_wall_seam_fixture.sh` because Phase 63 verification is local-file-only and must fail closed on drift. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**Example:**

```bash
#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}
```

Source: `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh`. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

### Pattern 5: Isolated Mutation Tests

**What:** Copy the valid namespace, status file, and package README into a temp tree, mutate one concern, run the verifier against explicit paths, and assert the expected diagnostic text. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**When to use:** Use for every SEAMFIX-03 failure class so negative tests never mutate checked-in sources. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Example:**

```bash
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-wall-seam-fixture-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT
```

Source pattern: `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh`. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

### Pattern 6: Bazel Bundle and Verifier Targets

**What:** Add aliases for wall-seam README, provenance, expected summary, and `.gcode`; add `prusa_wall_seam_bundle`; add `verify_prusa_wall_seam_fixture` as `sh_binary`; add `verify_prusa_wall_seam_fixture_test` as `sh_test`; include all new files in `package_boundary`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**When to use:** Use in Plan 63-01 for artifacts and Plan 63-02 for executable verification wiring. [VERIFIED: .planning/ROADMAP.md]

### Anti-Patterns to Avoid

- **Flexible summary parsing:** Do not accept unknown fields, duplicate rows, missing rows, or out-of-order rows because Phase 62 defines a closed ordered field contract. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]
- **Runtime generation:** Do not run PrusaSlicer, clone upstream, fetch source, call network tools, upload G-code, or sync sources in the fixture verifier because Phase 63 is local-file-only checked-in evidence. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]
- **Public status publication:** Do not add `fork.prusaslicer.wall-seam` to `packages/parity/status.tsv` in Phase 63; the Phase 63 verifier should require that row to be absent until Phase 65. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/prusa-wall-seam-scope/wall-seam-scope.md]
- **Sibling row widening:** Do not change the meanings of `fork.prusaslicer.gcode-output` or `fork.prusaslicer.arc-fitting`; exact row preservation should be verified. [VERIFIED: packages/parity/status.tsv; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Fixture provenance | Ad hoc README-only provenance | One-row `fixture-provenance.tsv` with exact header and exact row. | Existing fixture verifiers lock provenance with exact TSV rows and fail on mismatches. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Summary schema | JSON parser, wide table, or permissive field map | Long-row TSV with exact approved fields and row order. | User decisions reject JSON/wide table and require exact Bash checks plus Phase 64 Rust parsing handoff. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Drift verification | Loose grep-only presence checks | Exact header, exact row count, allowed-field whitelist, required-field counts, exact value checks, exact order checks, byte count, and SHA-256. | Arc verifier uses these patterns to catch missing, duplicate, unsupported, mismatched, and out-of-order rows. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Negative coverage | Manual QA checklist | `verify_prusa_wall_seam_fixture_test.sh` with temp copies and one concern per mutation test. | Arc mutation tests prove verifier failure modes without mutating repo sources. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh; standards/core/testing.md] |
| Runtime source refresh | Git/network/import/sync automation | Reviewed intake changes updating vendor, inventory, and scope files. | Phase 63 update route explicitly rejects branch-head, upstream import, live generation, network access, and sync updates. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Public evidence | New public parity command or status row | Keep public command/status/docs deferred to Phase 65. | Phase 63 may document the fixture namespace but must not publish public evidence. [VERIFIED: .planning/ROADMAP.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |

**Key insight:** Phase 63 is valuable because it makes the checked-in evidence artifact exact and boring before Rust parsing or public parity consumes it; custom generation, permissive parsing, or public wording would weaken that boundary. [VERIFIED: .planning/PROJECT.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Accidentally Publishing Wall-Seam Status Early

**What goes wrong:** A planner or implementer adds `fork.prusaslicer.wall-seam` to `packages/parity/status.tsv` during fixture work. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**Why it happens:** The fixture is real, but public executable evidence is still owned by Phase 65. [VERIFIED: .planning/ROADMAP.md]

**How to avoid:** The Phase 63 verifier should require exactly zero `fork.prusaslicer.wall-seam` rows while still preserving exact `generated-outputs`, `fork.prusaslicer.gcode-output`, and `fork.prusaslicer.arc-fitting` rows. [VERIFIED: packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh; packages/parity/status.tsv]

**Warning signs:** A diff touches `packages/parity/status.tsv` or public `docs/port/` status pages during Phase 63. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Pitfall 2: Summary Rows Drift From Phase 62

**What goes wrong:** The expected summary gains unsupported fields, loses required fields, changes row order, or uses broad claim values. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/REQUIREMENTS.md]

**Why it happens:** Wall seam is algorithmically tempting, but Phase 63 only records checked-in observation facts. [VERIFIED: .planning/PROJECT.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**How to avoid:** Hard-code the 12 approved fields, one row per field, exact order, exact values, exact categories, and explicit evidence boundaries. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/prusa-wall-seam-scope/wall-seam-scope.md]

**Warning signs:** Values include terms like geometry equivalence, seam visibility, printability, byte parity, runtime, firmware, GUI, or generated-output status evidence. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Pitfall 3: Fixture Checksum Is Not Locked Everywhere

**What goes wrong:** The `.gcode` fixture bytes change but provenance or verifier constants do not catch the drift. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Why it happens:** The byte count and SHA are easy to forget when editing small text fixtures. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**How to avoid:** Compute byte count and SHA after finalizing `wall-seam-observations.gcode`, then require both in provenance and verifier; add a checksum-drift mutation test. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Warning signs:** `wall-seam-observations.gcode` changes without matching updates to `fixture-provenance.tsv` and `verify_prusa_wall_seam_fixture.sh`. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

### Pitfall 4: Forbidden Runtime Behavior Sneaks Into the Verifier

**What goes wrong:** A verifier starts cloning, fetching, running slicer commands, uploading G-code, or otherwise observing live systems. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

**Why it happens:** Source-pinned provenance can be mistaken for a mandate to re-fetch or regenerate source outputs. [VERIFIED: packages/parity-fixtures/README.md]

**How to avoid:** Include a self-scan for split forbidden terms and keep the verifier local-file-only. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**Warning signs:** New script text contains `curl`, `git`, `clone`, `fetch`, `PrusaSlicer --`, `slic3r --`, `send-gcode`, or host upload behavior terms. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

### Pitfall 5: Documentation References Go Stale

**What goes wrong:** The namespace README or package README omits the new fixture, expected summary, verifier target, source ref, source path, or phase boundary. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Why it happens:** Fixture artifacts and docs are updated in separate files. [VERIFIED: packages/parity-fixtures/README.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md]

**How to avoid:** The verifier should require exact package README and namespace README text for artifacts, commands, source identity, update route, Phase 64/65 ownership, and no-overclaiming terms. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**Warning signs:** A new artifact appears in `BUILD.bazel` but not in `packages/parity-fixtures/README.md` or namespace README. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

## Code Examples

Verified patterns from local sources.

### Exact Header and Row Count Check

```bash
require_exact_header "${summary_file}" "expected-wall-seam-summary.tsv" "${WALL_SEAM_SUMMARY_HEADER}"
require_tsv_column_count "${summary_file}" "expected-wall-seam-summary.tsv" "6"
require_line_count "${summary_file}" "expected-wall-seam-summary.tsv" "13"
```

This pattern should be adapted from the arc summary checks, with 12 data rows plus one header row. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Approved Field Whitelist

```bash
awk -F '\t' '
	NR == 1 { next }
	$3 != "source_ref" &&
		$3 != "inventory_source_paths" &&
		$3 != "source_anchor" &&
		$3 != "fixture_id" &&
		$3 != "fixture_path" &&
		$3 != "seam_transition_observations" &&
		$3 != "layer_context_observations" &&
		$3 != "travel_context_observations" &&
		$3 != "coordinate_bounds" &&
		$3 != "extrusion_observations" &&
		$3 != "retraction_observations" &&
		$3 != "evidence_boundary" {
		printf "error: expected-wall-seam-summary.tsv: unsupported wall-seam field: %s\n", $3 > "/dev/stderr"
		exit 1
	}
' "${summary_file}"
```

This is the wall-seam adaptation of the arc allowed-field pattern. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/prusa-wall-seam-scope/wall-seam-scope.md]

### Provenance Alignment Check

```bash
awk -F '\t' \
	-v source_ref="${SOURCE_REF}" \
	-v fixture_path="${FIXTURE_PATH}" '
	NR == 1 { next }
	$1 != source_ref || $2 != fixture_path {
		printf "error: expected-wall-seam-summary.tsv: provenance mismatch for %s\n", $3 > "/dev/stderr"
		exit 1
	}
' "${summary_file}"
```

This should be used so every summary row points at the one approved source ref and checked-in fixture path. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

### Status Absence Guard

```bash
wall_seam_status_count="$(awk -F '\t' '$1 == "fork.prusaslicer.wall-seam" { count++ } END { print count + 0 }' "${status_file}")"
if [[ "${wall_seam_status_count}" != "0" ]]; then
	error "packages/parity/status.tsv: no verified fork.prusaslicer.wall-seam status row may be published in Phase 63"
fi
```

This adapts the Phase 62 status absence guard to the Phase 63 fixture verifier. [VERIFIED: packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source pins and inventories as planning-only records | Fixture namespaces with exact checked-in static artifacts, provenance, expected summaries, and local verifiers | Existing ladder from v1.12 through v1.15, reused by v1.16 | Phase 63 should create artifacts that later Rust/public phases consume, not public evidence by itself. [VERIFIED: .planning/PROJECT.md; packages/parity-fixtures/README.md] |
| Broad `generated-outputs` as one status bucket | Separate narrow fork evidence rows for semantic G-code output and arc-fitting, with wall-seam planned as a separate future row | v1.12 through v1.16 | Phase 63 must preserve current rows and keep wall-seam unpublished. [VERIFIED: packages/parity/status.tsv; .planning/PROJECT.md] |
| Runtime or generated comparisons before stable contracts | Scope contract, fixture corpus, Rust boundary, then public evidence | v1.12 through v1.16 evidence ladder | The planner should split Phase 63 into artifact creation and verifier/mutation coverage, matching the roadmap's two plans. [VERIFIED: .planning/ROADMAP.md; .planning/STATE.md] |
| Older ASVS 4 category labels in some templates | OWASP ASVS 5.0.0 is the current official project version, with security checks mapped to the actual local script surface instead of irrelevant web-app auth/session controls | ASVS 5.0.0 official project state | Security planning should focus on input validation, command injection avoidance, checksum integrity, and no secrets/network behavior for this phase. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://github.com/OWASP/ASVS] |

**Deprecated/outdated:**

- Treating Phase 63 fixture verification as proof of byte-for-byte G-code parity is outdated for this milestone; the current scope says checked-in summary evidence only. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-wall-seam-scope/wall-seam-scope.md]
- Treating `fork.prusaslicer.gcode-output` as covering wall-seam behavior is outdated; current status text keeps wall seam deferred from the semantic G-code output row. [VERIFIED: packages/parity/status.tsv]
- Treating arc-fitting publication as precedent for Phase 63 status publication is wrong; Phase 60 published arc-fitting after Rust/public evidence, while Phase 63 owns fixture artifacts only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md; .planning/ROADMAP.md]

## Assumptions Log

All claims in this research were verified against local repo files, local command output, the user prompt, or official OWASP sources; no user-confirmation assumptions are required before planning. [VERIFIED: all cited sources in this file]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | No `[ASSUMED]` claims were used. | All sections | None. [VERIFIED: all cited sources in this file] |

## Open Questions

1. **Exact fixture line contents**
   - What we know: The context delegates exact static G-code observation lines to the implementer as long as they are small, deterministic, ASCII/LF, checked-in observation input only, and support all 12 approved fields. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]
   - What's unclear: The final byte count and SHA-256 cannot be known until the file is authored. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]
   - Recommendation: Plan 63-01 should create the tiny fixture first, compute byte count and SHA-256, then update provenance and verifier constants in the same plan. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

No blocking open questions require user input before planning. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bash | Verifier and mutation tests | yes | 3.2.57 | None needed. [VERIFIED: local `bash --version`] |
| Bazel | `sh_binary`, `sh_test`, and bundle verification | yes | 8.6.0 | Direct Bash runs are a partial fallback, but Bazel wiring is required before done. [VERIFIED: local `bazel --version`; packages/parity-fixtures/BUILD.bazel] |
| ShellCheck | Script verification before commit | yes | 0.11.0 | If unavailable in another environment, Bash syntax plus Bazel tests still cover execution, but this machine has ShellCheck. [VERIFIED: local `shellcheck --version`] |
| `shasum` | Fixture checksum validation | yes | system `/usr/bin/shasum` | Use another SHA-256 tool only if verifier constants and docs are updated consistently. [VERIFIED: local command availability audit; packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| `awk`, `grep`, `sed`, `wc`, `tr`, `mktemp`, `cp`, `mv`, `chmod` | Exact TSV checks and mutation fixtures | yes | system tools | None needed on this machine. [VERIFIED: local command availability audit] |
| Git | Commit research and inspect diffs | yes | Codex runtime git on PATH | None needed. [VERIFIED: local command availability audit] |

**Missing dependencies with no fallback:**

- None found for Phase 63 planning and local fixture verification. [VERIFIED: local environment availability audit]

**Missing dependencies with fallback:**

- None found for Phase 63 planning and local fixture verification. [VERIFIED: local environment availability audit]

## Security Domain

Security enforcement is enabled because `.planning/config.json` does not explicitly set `security_enforcement` to `false`. [VERIFIED: .planning/config.json; GSD researcher instructions]

### Applicable ASVS Categories

| ASVS Area | Applies | Standard Control |
|-----------|---------|------------------|
| Authentication and session controls | no | Phase 63 has no users, sessions, cookies, tokens, login, or remote service. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Access control | no | Phase 63 reads local repo files and writes checked-in artifacts only; it does not introduce authorization decisions. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |
| Input validation and encoding | yes | Validate ASCII/LF, exact TSV column counts, exact headers, allowed fields, required field counts, exact rows, and no unsupported claim text. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; CITED: https://github.com/OWASP/ASVS] |
| Command injection avoidance | yes | Do not construct dynamic shell commands from untrusted TSV values; use fixed local file paths, quoted variables, no `eval`, and no runtime network/Git/source generation. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; CITED: https://github.com/OWASP/ASVS] |
| Cryptography | yes, limited | Use system SHA-256 checksum verification for fixture integrity; do not implement custom cryptography. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Secrets and sensitive data | no | Phase 63 introduces no secrets, credentials, private data, network/device behavior, host upload, release, sync, upstream import, or printer-runtime behavior. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md] |

### Known Threat Patterns for Local Bash Fixture Verification

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Tampered fixture bytes | Tampering | Verify exact byte count and SHA-256, and add checksum-drift mutation coverage. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] |
| Unsupported TSV fields or reordered rows | Tampering | Enforce closed field whitelist, one row per required field, exact row order, and exact row count. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Overclaiming documentation or summary text | Spoofing | Reject forbidden claim text in README, provenance, summary, and verifier text. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Runtime/network behavior added to local verifier | Elevation of privilege / information disclosure | Self-scan for forbidden behavior terms and keep verifier local-file-only. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Premature public status publication | Spoofing | Require `generated-outputs` remains `in progress`, preserve sibling rows exactly, and require zero `fork.prusaslicer.wall-seam` rows in Phase 63. [VERIFIED: packages/parity/status.tsv; packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md` - locked Phase 63 user decisions, scope, deferrals, and canonical references. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - SEAMFIX-01, SEAMFIX-02, SEAMFIX-03, and v1.16 out-of-scope boundaries. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 63 two-plan split, dependencies, success criteria, and Phase 64/65 boundaries. [VERIFIED: local file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - accumulated evidence-ladder decisions and current v1.16 state. [VERIFIED: local file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/verification.md`, and `standards/core/testing.md` - repo and Bright Builds planning, code-shape, testing, and verification constraints. [VERIFIED: local file read]
- `packages/prusa-wall-seam-scope/wall-seam-scope.md` and `packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh` - Phase 62 approved fields, source identity, planned paths, status absence guard, and no-overclaiming contract. [VERIFIED: local file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/*` - nearest completed fixture namespace precedent. [VERIFIED: local file read]
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` and `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh` - exact verifier and mutation-test implementation precedent. [VERIFIED: local file read]
- `packages/parity-fixtures/README.md`, `packages/parity-fixtures/BUILD.bazel`, `packages/fork-inventories/prusaslicer.tsv`, `packages/fork-inventories/category-map.tsv`, and `packages/parity/status.tsv` - package wiring, inventory traceability, and current status boundaries. [VERIFIED: local file read]

### Secondary (MEDIUM confidence)

- OWASP ASVS official project page and GitHub repository - current ASVS project source and security-category reference for local input validation and command-injection mapping. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://github.com/OWASP/ASVS]

### Tertiary (LOW confidence)

- None. [VERIFIED: all research claims are backed by local files, local command output, user prompt, or official OWASP sources]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - tools and versions were verified locally, and stack choices are constrained by existing Bash/Bazel fixture patterns. [VERIFIED: local environment availability audit; packages/parity-fixtures/BUILD.bazel]
- Architecture: HIGH - Phase 63 user decisions and Phase 58 arc-fitting precedent agree on flat namespace, TSV artifacts, exact Bash verification, and Bazel wiring. [VERIFIED: .planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md]
- Pitfalls: HIGH - failure classes come directly from SEAMFIX-03, Phase 63 decisions, Phase 62 scope guards, and arc-fitting mutation tests. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh; packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh]

**Research date:** 2026-06-26
**Valid until:** 2026-07-26 for local repo artifact planning, or earlier if Phase 62 scope fields, `packages/parity/status.tsv`, or `packages/parity-fixtures/BUILD.bazel` change. [VERIFIED: local file state as of research date]
