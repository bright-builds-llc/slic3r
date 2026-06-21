# Phase 56: Executable Semantic G-code Evidence - Research

**Researched:** 2026-06-21 [VERIFIED: current_date]
**Domain:** Rust/Bash/Bazel public parity evidence, semantic TSV validation, and conservative status/docs publication [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; .planning/ROADMAP.md]
**Confidence:** HIGH [VERIFIED: local code, focused commands, and phase artifacts cited throughout]

<user_constraints>

## User Constraints (from CONTEXT.md)

All bullets in this section are copied verbatim from `.planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md`; the source of the copied decisions, discretion area, and deferred scope is that context artifact. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Public command integration

- **D-01:** Keep the public evidence command as
  `bazel run //packages/parity:prusaslicer_gcode_output_parity`. Phase 56
  should extend this existing command instead of creating a companion command,
  preserving the Phase 48/52 public contract.
- **D-02:** Extend
  `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  with a `--semantic expected-gcode-semantic-summary.tsv` mode that calls the
  existing pure Rust semantic parser/summary surface. Keep the existing
  one-path marker mode and `--structural` mode stable.
- **D-03:** Extend
  `packages/parity/compare_prusaslicer_gcode_output.sh` to accept the semantic
  Rust input and expected semantic artifact after the structural arguments,
  validate both through the Rust binary, diff Rust output against expected
  semantic summary lines, and print semantic facts in the success output.
- **D-04:** Update `packages/parity/BUILD.bazel` so
  `prusaslicer_gcode_output_parity` and its failure test include
  `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_semantic_summary`.
  Keep the target name unchanged.

### Semantic mutation guards

- **D-05:** Extend `packages/parity/compare_prusaslicer_gcode_output_test.sh`
  with focused semantic mutation cases that prove public evidence fails closed
  for movement class changes, coordinate-bound changes, extrusion-total
  changes, feedrate observation changes, fixture identity drift, and unsupported
  deferred-behavior claims.
- **D-06:** Each mutation test should alter only a copied temp artifact and
  assert a useful diagnostic mentioning `expected-gcode-semantic-summary.tsv`
  and the specific semantic field, such as `movement_class_counts`,
  `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, or
  `fixture_id`.
- **D-07:** Keep marker and structural mutation guards intact. The semantic
  guards are additive; they should not weaken the existing `line_4` marker
  drift guard or `command_count_g1` structural drift guard.

### Status publication

- **D-08:** Update `packages/parity/status.tsv` only after public semantic
  evidence and mutation guards pass. The existing
  `fork.prusaslicer.gcode-output` row may remain `verified`, but its note must
  name the narrow semantic evidence slice backed by Phase 53 scope, Phase 54
  semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary,
  and Phase 56 public parity command.
- **D-09:** Keep the broad `generated-outputs` row exactly `in progress`.
  Phase 56 strengthens a single fork-specific G-code evidence slice, not the
  broad generated-output surface.
- **D-10:** Reconcile fixture and scope verifier enforcement so stale
  structural-only status/docs wording fails closed where package verifiers own
  that boundary, without causing the semantic artifact itself to overclaim.

### Documentation publication

- **D-11:** Update `packages/parity/README.md` to describe the public Prusa
  G-code parity command as marker + structural + semantic expected-summary
  evidence, backed by the existing Rust summary binary.
- **D-12:** Update `packages/prusa-gcode-output-scope/gcode-output-scope.md`
  and `packages/prusa-gcode-output-scope/README.md` from planned semantic
  publication wording to actual Phase 56 semantic publication wording while
  preserving all deferred surfaces.
- **D-13:** Update fixture and package docs only where necessary to point to
  the public semantic command and status row. Avoid reworking fixture
  provenance values or changing the Phase 54 expected semantic artifact.
- **D-14:** Update public port docs, especially `docs/port/package-map.md`,
  `docs/port/parity-matrix.md`, and `docs/port/migration-guidance.md`, so they
  describe the exact narrow semantic evidence slice and keep broad
  `generated-outputs` in progress.

### Verification and phase closeout

- **D-15:** Plan verification should include the focused public parity command,
  the parity failure test, the fixture verifier, the scope verifier, relevant
  Rust parser/binary tests, package/doc drift checks, summary extraction, and
  `git diff --check` over changed files.
- **D-16:** Because this is a Rust-touching phase, commits must follow the
  repo's Rust pre-commit gate where applicable: `cargo fmt --all`, clippy,
  build, and tests through the repo's Rust manifest, plus the relevant Bazel
  targets.

### the agent's Discretion

- Choose the exact semantic summary-line field names printed by the Rust
  binary, provided they are narrow, stable, and easy for the public comparator
  to assert.
- Choose whether the comparator shares structural helper functions for semantic
  mismatch labels or adds semantic-specific helpers, provided diagnostics stay
  specific and Bash remains readable.
- Choose the exact plan split across the five roadmap plans, provided the
  sequence preserves command integration, mutation guards, status publication,
  package/scope docs, and public port docs as separate reviewable steps.

### Deferred Ideas (OUT OF SCOPE)

- Byte-for-byte G-code parity, broad generated-output verification,
  geometry/toolpath parity, printability, printer-runtime behavior, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, GUI behavior, binary G-code, thumbnails, post-processing,
  host upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, release
  behavior, and sync automation remain out of scope.
- Future generated-output feature slices such as support generation, seam
  behavior, and arc fitting should build on the semantic comparison machinery
  only after explicit future planning decisions.
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| GSEV-01 | Maintainer can run public Prusa G-code parity evidence that validates marker summary, structural summary, and semantic summary artifacts through the Rust boundary while preserving the existing public command contract unless a deliberate roadmap decision introduces a companion command. [VERIFIED: .planning/REQUIREMENTS.md] | Extend the existing `prusaslicer_gcode_output_parity` target, add `--semantic` to the existing Rust summary binary, pass the semantic TSV alias through Bazel, and assert semantic summary lines in the comparator. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_prusaslicer_gcode_output.sh; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| GSEV-02 | Maintainer can see fail-closed mutation guards for semantic drift classes such as movement class changes, coordinate-bound changes, extrusion-total changes, feedrate observation changes, fixture identity drift, and unsupported deferred-behavior claims. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `compare_prusaslicer_gcode_output_test.sh` with temp-copy semantic mutations that assert diagnostics mentioning `expected-gcode-semantic-summary.tsv` and the mutated semantic field. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity/compare_prusaslicer_gcode_output_test.sh] |
| GSEV-03 | Maintainer can inspect parity status, package docs, and port docs that describe the exact narrow `fork.prusaslicer.gcode-output` semantic evidence slice while keeping broad `generated-outputs` in progress and all deferred generated-output, runtime, GUI, release, sync, and non-Prusa fork surfaces explicit. [VERIFIED: .planning/REQUIREMENTS.md] | Update `status.tsv`, package docs, scope docs, fixture/scope verifier constants, and stale port-doc wording after public semantic evidence and mutation guards pass. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; docs/port/package-map.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md; docs/port/README.md] |
</phase_requirements>

## Summary

Phase 56 is a publication and execution phase over existing repo-owned artifacts; it is not an ecosystem-selection phase and should not add new external libraries. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] The current public command already validates marker and structural summaries through the Rust summary binary, and it currently passes with structural-only output. [VERIFIED: `bazel run //packages/parity:prusaslicer_gcode_output_parity`; packages/parity/compare_prusaslicer_gcode_output.sh]

The missing implementation is narrowly defined: expose semantic summary lines through the existing Rust boundary, add `--semantic` to the existing binary, extend the public comparator and Bazel target with the existing semantic fixture alias, add semantic mutation guards, then publish status/docs wording that names the Phase 53-56 semantic evidence chain while keeping broad `generated-outputs` exactly `in progress`. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity/status.tsv]

The main planning risk is stale exact wording in verifiers and docs, not parser uncertainty. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; docs/port/parity-matrix.md; docs/port/migration-guidance.md; docs/port/README.md] Both fixture and scope verifiers currently require structural-only status wording, so Plan 56-03 must update the status row and verifier constants/tests together after the semantic command and mutation guards pass. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Primary recommendation:** Plan the phase as an additive five-step chain: Rust `--semantic` adapter and public comparator wiring, semantic mutation guards, status/verifier reconciliation, package/scope docs, and port docs including `docs/port/README.md` drift checks. [VERIFIED: .planning/ROADMAP.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; docs/port/README.md]

## Project Constraints (from AGENTS.md)

- Use `AGENTS.md` as the repo-local instruction entrypoint, then `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant Bright Builds canonical pages before plan/review/implementation/audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Repo-local phase summaries must keep `requirements-completed` synchronized, use the exact hyphenated key, use `requirements-completed: []` when no milestone requirement is closed, and must not be processed with `mdformat`. [VERIFIED: AGENTS.md]
- Rust-touching commits must run, in order, `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features` before commit, adapted to the repo manifest path and pinned toolchain. [VERIFIED: AGENTS.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
- Rust code should prefer `thiserror` for library errors, `anyhow` for application errors, `tracing` over `println!`, `foo.rs` plus `foo/` over new `foo/mod.rs`, no `unwrap()`, `let...else` for clear guard extraction, and `maybe_` names for optional internals. [VERIFIED: AGENTS.md; cited Bright Builds Rust standard]
- Bash scripts should use `#!/usr/bin/env bash`, `set -euo pipefail`, visible failure behavior, and should not hide failures with `|| true`, `|| echo`, empty catches, or ignored return values. [VERIFIED: AGENTS.md]
- Tests should cover behavior, keep unit tests focused on one concern, and use Arrange/Act/Assert comments when that improves clarity. [VERIFIED: AGENTS.md; cited Bright Builds Testing standard]
- Bright Builds defaults materially relevant here: keep pure parsing in a functional core with thin adapters, parse boundary data into domain types, make illegal states unrepresentable where practical, prefer early returns, avoid oversized functions/files as refactor triggers, and prefer repo-owned verification entrypoints. [VERIFIED: AGENTS.bright-builds.md; cited Bright Builds Architecture, Code Shape, Verification, Testing, and Rust standards]
- `standards-overrides.md` contains only a placeholder row and no substantive local exception for this phase. [VERIFIED: standards-overrides.md]
- No repo-local `.claude/skills/` or `.agents/skills/` directories were present during this research. [VERIFIED: `find .claude/skills -maxdepth 2 -name SKILL.md`; `find .agents/skills -maxdepth 2 -name SKILL.md`]
- The repo-local `standards/` directory referenced by the managed sidecar is not checked in; canonical Bright Builds pages were read from the audited upstream commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`. [VERIFIED: `rg --files | rg '(^|/)standards(/|$)'`; bright-builds-rules.audit.md; CITED: raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

## Standard Stack

### Core

| Tool or Library | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Rust workspace in `packages/slic3r-rust` | `rust-version = "1.94"` in the workspace; local `rustc +1.94.1` is available. [VERIFIED: packages/slic3r-rust/Cargo.toml; `rustc +1.94.1 --version`] | Owns the pure `slic3r_flavors::prusa_gcode_output` parser/readiness boundary and the summary binary. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs] | Existing Phase 55 semantic parser/readiness code is pure Rust and already tested by Cargo/Bazel. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md; `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output`] |
| Bazel | Local `bazel 8.6.0`. [VERIFIED: `bazel --version`] | Publishes public parity commands, shell tests, Rust binaries/tests, and fixture aliases. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Existing public evidence is Bazel-owned and maintainers run `bazel run //packages/parity:prusaslicer_gcode_output_parity`. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; `bazel run //packages/parity:prusaslicer_gcode_output_parity`] |
| Bash comparator and verifier scripts | Local GNU Bash 3.2.57 is available. [VERIFIED: `bash --version`] | Orchestrates public artifact comparisons, mutation tests, fixture verification, and scope verification. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] | Existing scripts use `set -euo pipefail`, temp copies, `awk`, `diff`, and exact diagnostics. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/compare_prusaslicer_gcode_output_test.sh] |
| Checked-in semantic TSV fixture | 10 lines: one header plus nine semantic rows. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md] | Source-pinned expected semantic summary consumed by Rust and public parity evidence. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | It is already exported as `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_semantic_summary`. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| `shfmt` | 3.12.0 [VERIFIED: `shfmt --version`] | Shell formatter/checker for touched Bash scripts. [VERIFIED: Bright Builds Verification standard; local availability] | Use check/diff mode on changed shell scripts before commit when relevant. [VERIFIED: cited Bright Builds Verification standard] |
| ShellCheck | 0.11.0 [VERIFIED: `shellcheck --version`] | Static analysis for touched Bash scripts. [VERIFIED: local availability] | Use on changed comparator/verifier/test scripts when relevant. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |
| `mdformat` | 1.0.0 [VERIFIED: `mdformat --version`] | Markdown check for docs when local guidance does not forbid it. [VERIFIED: local availability; cited Bright Builds Verification standard] | Use on changed docs, but do not run it over phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md] |
| GSD tools | Available through `/Users/peterryszkiewicz/.codex/get-shit-done/bin/gsd-tools.cjs`. [VERIFIED: phase init command output] | Phase metadata, schema drift, summary extraction, and optional docs commit. [VERIFIED: phase init command output; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] | Use for `summary-extract` and phase schema/drift checks where plans require them. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Existing public target `//packages/parity:prusaslicer_gcode_output_parity` [VERIFIED: packages/parity/BUILD.bazel] | New companion semantic parity command | Rejected by locked decision D-01 because Phase 56 must preserve the Phase 48/52 public command contract. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |
| Existing `prusa_gcode_output_summary` binary plus `--semantic` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs] | New Rust binary | Rejected by locked decision D-02 because the existing binary is the public Rust summary adapter for marker and structural modes. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |
| Existing exact Rust semantic parser [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Re-parse semantic TSV fields in Bash | Rejected because Bash should orchestrate and Rust already enforces exact header, order, field, source, fixture, value, and evidence-boundary validation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md] |
| Exact checked-in TSV contract [VERIFIED: expected-gcode-semantic-summary.tsv] | Add a general TSV/CSV dependency | Not needed for this fixed six-column artifact, and no new dependencies are required by the phase. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |

**Installation:** No package installation is required for this phase because the repo already contains the Rust/Bazel/Bash surfaces and the semantic fixture alias. [VERIFIED: package files cited in Standard Stack; environment commands above]

**Version verification:** No npm packages or third-party Rust crates should be added for this phase. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/slic3r-rust/Cargo.toml]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
  parity/
    BUILD.bazel
    compare_prusaslicer_gcode_output.sh
    compare_prusaslicer_gcode_output_test.sh
    README.md
    status.tsv
  parity-fixtures/
    BUILD.bazel
    verify_prusa_gcode_output_fixture.sh
    verify_prusa_gcode_output_fixture_test.sh
    forks/prusaslicer/prusaslicer.gcode-output/
      expected-gcode-summary.tsv
      expected-gcode-structural-summary.tsv
      expected-gcode-semantic-summary.tsv
  prusa-gcode-output-scope/
    gcode-output-scope.md
    README.md
    verify_prusa_gcode_output_scope.sh
    verify_prusa_gcode_output_scope_test.sh
  slic3r-rust/crates/slic3r_flavors/
    src/prusa_gcode_output.rs
    src/bin/prusa_gcode_output_summary.rs
    tests/prusa_gcode_output.rs
docs/port/
  README.md
  package-map.md
  parity-matrix.md
  migration-guidance.md
```

This structure is the current repo layout for the Phase 56 work surfaces. [VERIFIED: `wc -l` and file reads over listed paths; packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel]

### Pattern 1: Additive Evidence Ladder

**What:** Preserve marker summary validation, preserve structural summary validation, and add semantic summary validation as the third rung for the same `prusaslicer.gcode-output` fixture. [VERIFIED: .planning/ROADMAP.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**When to use:** Use this pattern in Plan 56-01 before status/docs publication so public command output is executable evidence, not doc-only wording. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Example:**

```bash
# Source pattern: packages/parity/compare_prusaslicer_gcode_output.sh
"${summary_binary}" "${rust_summary_input}" >"${actual_summary}"
"${summary_binary}" --structural "${rust_structural_input}" >"${actual_structural_summary}"
"${summary_binary}" --semantic "${rust_semantic_input}" >"${actual_semantic_summary}"
```

The first two calls are the existing pattern, and the third call is the Phase 56 additive semantic branch. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

### Pattern 2: Thin Binary Adapter Over Pure Rust Parser

**What:** Add a `prusa_gcode_output_semantic_summary_lines(input: &str)` helper in `prusa_gcode_output.rs`, export it from `lib.rs`, and call it from a new binary `--semantic` branch. [VERIFIED: existing structural helper pattern in packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs]

**When to use:** Use when adding public semantic execution because the parser already returns typed facts and the binary already owns file I/O. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs]

**Example:**

```rust
// Source pattern: prusa_gcode_output_structural_summary_lines in
// packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
pub fn prusa_gcode_output_semantic_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaGcodeOutputSemanticParseError> {
    let summary = parse_prusa_gcode_output_semantic_summary(input)?;
    let readiness = prusa_gcode_output_semantic_readiness();
    let facts = summary.facts();

    Ok(vec![
        summary_line(
            "semantic_summary_path",
            readiness.expected_semantic_summary_path,
        ),
        format!("semantic_row_count\t{}", summary.rows().len()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("fixture_id", facts.fixture_id),
        summary_line("fixture_path", facts.fixture_path),
        summary_line("command_class_counts", facts.command_class_counts),
        summary_line("movement_class_counts", facts.movement_class_counts),
        summary_line("coordinate_bounds", facts.coordinate_bounds),
        summary_line("extrusion_total", facts.extrusion_total),
        summary_line("feedrate_observations", facts.feedrate_observations),
        summary_line(
            "layer_marker_relationships",
            facts.layer_marker_relationships,
        ),
    ])
}
```

The proposed line keys are stable `key<TAB>value` facts that mirror structural output while staying limited to existing semantic facts. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

### Pattern 3: Comparator Round-Trips Expected Artifacts Through Rust

**What:** Validate both the Rust semantic input and the expected semantic artifact through the Rust binary, diff their generated summary lines, and assert selected facts in the actual semantic output. [VERIFIED: existing marker/structural comparator pattern in packages/parity/compare_prusaslicer_gcode_output.sh; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**When to use:** Use in Plan 56-01 so the public command proves Rust-boundary validation and checked-in expectation agreement. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Example:**

```bash
# Source pattern: marker and structural diff blocks in compare_prusaslicer_gcode_output.sh
if ! "${summary_binary}" --semantic "${expected_semantic_artifact}" >"${expected_semantic_summary_lines}"; then
    mismatch_label="$(first_semantic_raw_mismatch_label "${rust_semantic_input}" "${expected_semantic_artifact}")"
    printf 'error: expected-gcode-semantic-summary.tsv failed Rust semantic validation at %s in %s\n' \
        "${mismatch_label}" "${expected_semantic_artifact}" >&2
    exit 1
fi
```

The comparator should mention `expected-gcode-semantic-summary.tsv` and a semantic field label in diagnostics. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

### Pattern 4: Public Mutation Tests Mutate Temp Copies Only

**What:** Copy the semantic TSV into a temp directory, mutate one semantic field per test, run the public comparator, and assert nonzero exit plus a field-specific diagnostic. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**When to use:** Use in Plan 56-02 for movement class, coordinate bounds, extrusion total, feedrate observations, fixture identity, and unsupported deferred-behavior claims. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Example:**

```bash
# Source pattern: mutate_command_count_g1_value in compare_prusaslicer_gcode_output_test.sh
mutate_semantic_value() {
    local path="${1}"
    local field="${2}"
    local replacement="${3}"
    local tmp_file="${path}.tmp"

    awk -v field="${field}" -v replacement="${replacement}" '
        BEGIN { FS = OFS = "\t" }
        $3 == field { $5 = replacement; changed++ }
        { print }
        END { if (changed != 1) exit 1 }
    ' "${path}" >"${tmp_file}"
    mv "${tmp_file}" "${path}"
}
```

This helper follows the current temp-copy mutation style and should be used only on copied artifacts. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

### Pattern 5: Status Publication After Evidence

**What:** Update `packages/parity/status.tsv` and exact verifier constants only after the public parity command and semantic mutation guards pass. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**When to use:** Use in Plan 56-03 because fixture and scope verifiers currently enforce the structural-only status row. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

**Example status wording target:**

```text
Shared fixture comparison proves the narrow semantic Prusa G-code evidence slice backed by the Phase 53 closed semantic scope contract, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command only; ...
```

The note should also retain the existing deferral list and keep broad `generated-outputs` in progress. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity/status.tsv]

### Anti-Patterns to Avoid

- **Companion command drift:** Do not create a new semantic-only Bazel command; extend `//packages/parity:prusaslicer_gcode_output_parity`. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
- **Bash semantic parser:** Do not reimplement semantic TSV validation in Bash beyond mismatch-label extraction and fact assertions; Rust already owns exact semantic validation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]
- **Docs-first publication:** Do not update `status.tsv` or docs before the public command and semantic mutation guards pass. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
- **Broad generated-output wording:** Do not claim byte parity, geometry/toolpath parity, printability, runtime behavior, support, seam, arc, GUI, release, sync, or non-Prusa fork behavior. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
- **Fixture provenance churn:** Do not change Phase 54 semantic artifact values or fixture provenance unless a reviewed intake change exists. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Semantic TSV validation | Bash parser for semantic field/category/value/boundary correctness | Existing `parse_prusa_gcode_output_semantic_summary` and a new summary-lines helper. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Rust already validates exact header, column count, missing/duplicate/out-of-order rows, allowed fields, source/fixture identity, semantic values, and evidence-boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; tests/prusa_gcode_output.rs] |
| Public semantic evidence command | New semantic-only public target | Existing `//packages/parity:prusaslicer_gcode_output_parity`. [VERIFIED: packages/parity/BUILD.bazel; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] | The public command contract is locked and must preserve Phase 48/52 behavior. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |
| G-code generation or runtime validation | Slicer execution, upstream fetch, Git discovery, printer/runtime assertions | Checked-in marker, structural, and semantic summary artifacts validated through Rust. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv] | The phase explicitly excludes generated-output, runtime, GUI, release, sync, and non-Prusa behavior. [VERIFIED: .planning/REQUIREMENTS.md] |
| Status drift checks | Manual-only review of status/doc wording | Existing fixture and scope verifiers plus exact mutation tests. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] | The verifiers already fail closed on status rows, duplicate rows, broad status promotion, and forbidden claim text. [VERIFIED: package verifier scripts and tests] |
| Broad docs sweep | Rewrite unrelated docs or fixture provenance | Targeted status/docs updates for parity, fixture/package docs where necessary, scope docs, and port docs. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] | The phase is a narrow evidence publication and should avoid unrelated metadata churn. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; AGENTS.md] |

**Key insight:** The semantic facts are already known and typed; the hard part is making public execution, mutation failure, status wording, and docs all point to the same narrow evidence slice without widening `generated-outputs`. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Comparator Argument Order Drift

**What goes wrong:** The Bazel target, shell comparator, and test harness disagree about the new semantic input and expected artifact argument positions. [VERIFIED: current six-argument comparator in packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/BUILD.bazel]

**Why it happens:** The current comparator accepts six arguments and both marker and structural expected artifacts are passed twice as Rust input and expected artifact. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/BUILD.bazel]

**How to avoid:** Add semantic arguments after the structural pair exactly as locked by D-03, update the usage string, update `run_comparator` in the failure test, and update both `sh_binary` and `sh_test` data lists. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity/compare_prusaslicer_gcode_output_test.sh]

**Warning signs:** `bazel run //packages/parity:prusaslicer_gcode_output_parity` exits with usage error, or the failure test reports missing semantic fixture paths. [VERIFIED: current usage behavior in comparator script]

### Pitfall 2: Semantic Mode Without Summary-Line Helper

**What goes wrong:** The binary gains `--semantic`, but semantic output is ad hoc or cannot be tested through the library. [VERIFIED: current binary imports only marker and structural summary-line helpers]

**Why it happens:** `parse_prusa_gcode_output_semantic_summary` exists, but no `prusa_gcode_output_semantic_summary_lines` helper is currently exported. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs]

**How to avoid:** Add and test the helper in `prusa_gcode_output.rs`, re-export it in `lib.rs`, then call it from `src/bin/prusa_gcode_output_summary.rs`. [VERIFIED: structural helper/export pattern in source files]

**Warning signs:** Rust tests only exercise binary stdout and do not assert semantic summary-line construction as pure code. [VERIFIED: existing structural summary-line test pattern in tests/prusa_gcode_output.rs]

### Pitfall 3: Weak Semantic Mutation Diagnostics

**What goes wrong:** The public failure test fails, but diagnostics do not mention `expected-gcode-semantic-summary.tsv` or the specific changed field. [VERIFIED: D-06 in 56-CONTEXT.md]

**Why it happens:** Existing mismatch labels know marker and structural field layouts; semantic rows use `semantic_field` in column 3. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; expected-gcode-semantic-summary.tsv]

**How to avoid:** Add a semantic mismatch label helper or generalize the structural helper so labels such as `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, and `fixture_id` reach stderr. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Warning signs:** Test assertions only check for generic `diff` or `line_count` text. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

### Pitfall 4: Exact Verifiers Still Pin Structural-Only Status

**What goes wrong:** `status.tsv` gets semantic wording, but fixture or scope verification fails because constants still require the Phase 52 structural row. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

**Why it happens:** Both verifiers define `GCODE_OUTPUT_STATUS_ROW` with `narrow structural Prusa G-code evidence slice`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

**How to avoid:** In Plan 56-03, update `status.tsv`, fixture verifier constant/test rows, and scope verifier constant/test rows together after the semantic command and failure tests pass. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Warning signs:** `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` or `bazel run //packages/prusa-gcode-output-scope:verify` fails immediately after a status wording change. [VERIFIED: focused verifier commands run during research]

### Pitfall 5: Leaving Port Docs Internally Inconsistent

**What goes wrong:** The three especially named port docs are updated, but `docs/port/README.md` still says the public G-code evidence slice is structural-only. [VERIFIED: docs/port/README.md]

**Why it happens:** Phase context names `docs/port/package-map.md`, `docs/port/parity-matrix.md`, and `docs/port/migration-guidance.md` especially, but not exclusively. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**How to avoid:** Plan 56-05 should include a drift scan over `docs/port/README.md` and update it if semantic publication makes the existing structural-only wording stale. [VERIFIED: docs/port/README.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md]

**Warning signs:** `rg -n "narrow structural Prusa G-code|Phase 52 public structural" docs/port` still finds current-state wording after Plan 56-05. [VERIFIED: docs/port/README.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md]

### Pitfall 6: Overclaiming the Fixture's Semantics

**What goes wrong:** Success output or docs imply toolpath geometry, extrusion behavior, timing, runtime printability, or generated-output parity. [VERIFIED: deferred scope in .planning/REQUIREMENTS.md and 56-CONTEXT.md]

**Why it happens:** The word "semantic" can sound broader than the actual fixture, which has four feedrate-only `G1 F...` rows and no coordinate axes, extrusion axis, or layer markers. [VERIFIED: gcodewriter-set-speed.gcode; expected-gcode-semantic-summary.tsv]

**How to avoid:** Print and document only exact facts: `semantic_rows: 9`, `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, `layer_marker_relationships`, source ref, fixture id, and fixture path. [VERIFIED: expected-gcode-semantic-summary.tsv; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

**Warning signs:** New text contains "full generated-output", "toolpath geometry", "printability", "runtime", "support", "seam", or "arc" outside deferred-scope language. [VERIFIED: verifier forbidden-claim patterns in fixture/scope verifier scripts]

## Code Examples

### Binary Mode Dispatch

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs
use slic3r_flavors::{
    prusa_gcode_output_semantic_summary_lines,
    prusa_gcode_output_structural_summary_lines,
    prusa_gcode_output_summary_lines,
};

const USAGE_ERROR: &str = "expected expected-gcode-summary.tsv, --structural expected-gcode-structural-summary.tsv, or --semantic expected-gcode-semantic-summary.tsv";

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    let result = match args.as_slice() {
        [_, fixture_path] => run_summary(fixture_path),
        [_, mode, fixture_path] if mode == OsStr::new("--structural") => {
            run_structural_summary(fixture_path)
        }
        [_, mode, fixture_path] if mode == OsStr::new("--semantic") => {
            run_semantic_summary(fixture_path)
        }
        _ => Err(USAGE_ERROR.to_owned()),
    };
    // Existing result handling remains unchanged.
}
```

This follows the existing binary adapter shape while adding only the `--semantic` branch. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

### Comparator Fact Assertions

```bash
# Source pattern: assert_field calls in packages/parity/compare_prusaslicer_gcode_output.sh
assert_field "semantic_summary_path" \
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv" \
    "${actual_semantic_summary}"
assert_field "semantic_row_count" "9" "${actual_semantic_summary}"
assert_field "fixture_id" "gcodewriter-set-speed.gcode" "${actual_semantic_summary}"
assert_field "movement_class_counts" "travel:0;extrusion:0;coordinate_motion:0;feedrate_only:4" "${actual_semantic_summary}"
assert_field "coordinate_bounds" "x:none;y:none;z:none" "${actual_semantic_summary}"
assert_field "extrusion_total" "e_axis_observed:false;extrusion_total:not_observed" "${actual_semantic_summary}"
assert_field "feedrate_observations" "F99999.123;F1;F203.2;F203.201" "${actual_semantic_summary}"
```

These fields are all present in the Phase 54 semantic TSV and Phase 55 typed facts. [VERIFIED: expected-gcode-semantic-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

### Status Row Check

```bash
# Source pattern: exact status checks in Phase 55 summaries and verifier scripts
awk -F '\t' '
    $1 == "generated-outputs" && $2 == "in progress" { generated_outputs++ }
    $1 == "fork.prusaslicer.gcode-output" &&
        $2 == "verified" &&
        $3 == "//packages/parity:prusaslicer_gcode_output_parity" &&
        $4 ~ /narrow semantic Prusa G-code evidence slice/ { fork_row++ }
    END { exit generated_outputs == 1 && fork_row == 1 ? 0 : 1 }
' packages/parity/status.tsv
```

The exact final note text should name Phase 53 scope, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Marker-only Prusa G-code fixture summary. [VERIFIED: expected-gcode-summary.tsv; .planning/STATE.md] | Marker + structural public evidence through the existing parity command. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/status.tsv] | Phase 52 in v1.13. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md] | Public command currently passes and prints structural-only evidence. [VERIFIED: `bazel run //packages/parity:prusaslicer_gcode_output_parity`] |
| Structural-only status/docs for `fork.prusaslicer.gcode-output`. [VERIFIED: packages/parity/status.tsv; docs/port/parity-matrix.md] | Semantic parser/readiness exists, but public status/docs are not yet published semantically. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md; packages/parity/status.tsv] | Phase 55 in v1.14. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md] | Phase 56 is the publication and executable evidence step. [VERIFIED: .planning/ROADMAP.md] |
| Planned semantic summary references in scope docs. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; README.md] | Actual Phase 54 semantic TSV and Phase 55 Rust parser/readiness artifacts exist. [VERIFIED: expected-gcode-semantic-summary.tsv; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md] | Phase 54 and Phase 55 in v1.14. [VERIFIED: .planning/STATE.md] | Scope docs must move from "planned" to "published through Phase 56 public parity evidence" wording. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md] |

**Deprecated/outdated for Phase 56:**

- Structural-only success wording in `compare_prusaslicer_gcode_output.sh` will become stale once semantic validation is added. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
- Structural-only `fork.prusaslicer.gcode-output` notes in `status.tsv`, fixture verifier constants, scope verifier constants, and public docs will become stale after semantic publication. [VERIFIED: packages/parity/status.tsv; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; docs/port/README.md]

## Assumptions Log

All claims in this research are sourced from current repo files, local command output, or cited official documentation; no `[ASSUMED]` claims are intentionally used. [VERIFIED: source tags throughout]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | No assumed claims recorded. [VERIFIED: source tags throughout] | All sections | None. [VERIFIED: source tags throughout] |

## Open Questions (RESOLVED)

1. **Exact final status note wording**

   - What we know: The status row may remain `verified`, the evidence target must remain `//packages/parity:prusaslicer_gcode_output_parity`, and the note must name Phase 53, Phase 54, Phase 55, and Phase 56 while retaining deferrals. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
   - What's unclear: The exact sentence is left to implementation discretion. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md]
   - Recommendation: Use a single exact note shared by `status.tsv`, fixture verifier constants, scope verifier constants, and tests. [VERIFIED: existing exact-row verifier pattern in package verifier scripts]
   - RESOLVED: Plan 56-03 chooses this exact status note for `packages/parity/status.tsv`, fixture verifier constants, scope verifier constants, and tests:

     ```text
     Shared fixture comparison proves the narrow semantic Prusa G-code evidence slice backed by the Phase 53 closed semantic scope contract, Phase 54 semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary, and Phase 56 public parity command only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion behavior, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, release behavior, and sync automation remain deferred
     ```

1. **Whether to update `docs/port/README.md` in Plan 56-05**

   - What we know: The context especially names `package-map.md`, `parity-matrix.md`, and `migration-guidance.md`, and `docs/port/README.md` currently contains structural-only G-code evidence wording. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; docs/port/README.md]
   - What's unclear: The roadmap plan title says "port docs" rather than an exhaustive file list. [VERIFIED: .planning/ROADMAP.md]
   - Recommendation: Include `docs/port/README.md` in the Plan 56-05 drift scan and update it if semantic publication makes it stale. [VERIFIED: docs/port/README.md]
   - RESOLVED: Plan 56-05 includes `docs/port/README.md` in `files_modified`, `<context>`, Task 2 `<files>` and `<read_first>`, Task 2 action/acceptance criteria, and final verification so the stale structural-only README wording is closed with the rest of the public port docs.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Public parity command, sh tests, fixture/scope verifiers, Rust Bazel tests. [VERIFIED: BUILD.bazel files; 56-CONTEXT.md] | yes [VERIFIED: `bazel --version`] | 8.6.0 [VERIFIED: `bazel --version`] | None needed. [VERIFIED: local command availability] |
| Rust toolchain `+1.94.1` | Rust summary helper, binary mode, clippy/build/test gates. [VERIFIED: packages/slic3r-rust/Cargo.toml; 56-CONTEXT.md] | yes [VERIFIED: `rustc +1.94.1 --version`; `cargo +1.94.1 --version`] | rustc 1.94.1, cargo 1.94.1 [VERIFIED: local command output] | None needed; default cargo is 1.91.1, so use `+1.94.1` explicitly. [VERIFIED: `cargo --version`; `cargo +1.94.1 --version`] |
| Bash | Comparator, verifier, and mutation scripts. [VERIFIED: packages/parity/*.sh; packages/parity-fixtures/*.sh; packages/prusa-gcode-output-scope/\*.sh] | yes [VERIFIED: `bash --version`] | GNU bash 3.2.57 [VERIFIED: `bash --version`] | None needed. [VERIFIED: local command availability] |
| shfmt | Shell formatting check for changed scripts. [VERIFIED: local command output; Bright Builds Verification standard] | yes [VERIFIED: `shfmt --version`] | 3.12.0 [VERIFIED: `shfmt --version`] | If not used by a plan, use `bash -n` plus ShellCheck; local shfmt is available. [VERIFIED: local command availability] |
| ShellCheck | Shell lint for changed scripts. [VERIFIED: local command output] | yes [VERIFIED: `shellcheck --version`] | 0.11.0 [VERIFIED: `shellcheck --version`] | `bash -n` only catches syntax, not static warnings; no fallback needed because ShellCheck is available. [VERIFIED: local command availability] |
| mdformat | Markdown check for changed docs. [VERIFIED: local command output; AGENTS.md] | yes [VERIFIED: `mdformat --version`] | 1.0.0 [VERIFIED: `mdformat --version`] | Do not run on phase `*-SUMMARY.md`; for those use summary extraction, frontmatter integrity, and `git diff --check`. [VERIFIED: AGENTS.md] |
| Node | GSD tooling for phase init, schema drift, and summary extraction. [VERIFIED: phase init command output; `node --version`] | yes [VERIFIED: `node --version`] | v24.13.0 [VERIFIED: `node --version`] | None needed. [VERIFIED: local command availability] |

**Missing dependencies with no fallback:** None found for the researched phase work. [VERIFIED: environment commands above]

**Missing dependencies with fallback:** None found for the researched phase work. [VERIFIED: environment commands above]

## Verification Surface

`workflow.nyquist_validation` is not explicitly set to `true` in `.planning/config.json`, so the formal Nyquist Validation Architecture section is intentionally omitted by policy. [VERIFIED: .planning/config.json]

### Required Verification Surface

| Scope | Command | Why |
|-------|---------|-----|
| Public command evidence | `bazel run //packages/parity:prusaslicer_gcode_output_parity` | Proves marker, structural, and semantic public evidence after Plan 56-01. [VERIFIED: current command passes structurally; 56-CONTEXT.md] |
| Public failure guards | `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors` | Proves marker, structural, and new semantic mutation guards. [VERIFIED: current failure test passes structurally; 56-CONTEXT.md] |
| Rust parser/binary focused test | `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output` | Covers semantic parser, summary-line helper, and binary `--semantic` tests after Plan 56-01. [VERIFIED: existing test passes 45 tests; tests/prusa_gcode_output.rs] |
| Rust Bazel focused test | `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test --test_output=errors` | Proves Bazel compile data and Rust test target see the semantic fixture. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Fixture package verifier | `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` | Ensures fixture docs/artifacts/status wording stay fail-closed. [VERIFIED: command passed during research; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Fixture mutation tests | `bazel test --cache_test_results=no //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test --test_output=errors` | Ensures fixture verifier mutation coverage remains intact after status/docs reconciliation. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |
| Scope verifier | `bazel run //packages/prusa-gcode-output-scope:verify` | Ensures scope docs/status wording and broad generated-output restraint stay exact. [VERIFIED: command passed during research; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| Scope mutation tests | `bazel test --cache_test_results=no //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test --test_output=errors` | Ensures scope verifier mutation coverage remains intact after publication wording changes. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh] |
| Rust pre-commit gate | `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`; `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features -- -D warnings`; `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features`; `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-features` | Required for Rust-touching commits. [VERIFIED: AGENTS.md; 56-CONTEXT.md; 55 summaries] |
| Shell checks | `bash -n` and ShellCheck on changed `.sh` files; `shfmt -l -d` on changed `.sh` files | Required for changed Bash surfaces under Bright Builds local verification expectations. [VERIFIED: AGENTS.md; cited Bright Builds Verification standard; local tool availability] |
| Docs checks | `mdformat --check` for changed docs except phase summaries; `git diff --check` over changed files | Required for docs and whitespace integrity; phase summaries have repo-local mdformat exception. [VERIFIED: AGENTS.md; cited Bright Builds Verification standard] |
| Phase summaries | `node /Users/peterryszkiewicz/.codex/get-shit-done/bin/gsd-tools.cjs summary-extract <summary-file>` | Required by repo-local summary frontmatter rules when plans create summaries. [VERIFIED: AGENTS.md; 55 summaries] |

### Current Baseline Observed

- `bazel run //packages/parity:prusaslicer_gcode_output_parity` currently passes and prints `ok: fork.prusaslicer.gcode-output structural parity passed`. [VERIFIED: local command output]
- `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors` currently passes. [VERIFIED: local command output]
- `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` currently passes. [VERIFIED: local command output]
- `bazel run //packages/prusa-gcode-output-scope:verify` currently passes. [VERIFIED: local command output]
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output` currently passes 45 tests. [VERIFIED: local command output]
- Running multiple Bazel commands in parallel caused a normal output-base lock wait, so plans should run Bazel commands sequentially unless they use separate output bases. [VERIFIED: local command output from parallel verifier run]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

OWASP ASVS 5.0.0 is the latest stable ASVS version on the OWASP project page, and ASVS is a verification standard for application security controls. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://github.com/OWASP/ASVS] This phase is a local CLI/Bash/Rust evidence workflow with checked-in TSV files, not a web authentication, session, or API feature. [VERIFIED: .planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md; packages/parity/compare_prusaslicer_gcode_output.sh]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| Authentication | no [VERIFIED: phase scope excludes runtime/user auth behavior] | No authentication surface is added; do not introduce credentials or network/device behavior. [VERIFIED: .planning/REQUIREMENTS.md; 56-CONTEXT.md] |
| Session Management | no [VERIFIED: phase scope is local CLI/static files] | No session state is present. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; 56-CONTEXT.md] |
| Access Control | no [VERIFIED: phase scope is repo-local evidence files and Bazel targets] | Preserve repo file boundaries and do not add external service access. [VERIFIED: 56-CONTEXT.md] |
| Input Validation / Injection Prevention | yes [CITED: OWASP ASVS page; VERIFIED: semantic TSV parser and Bash file arguments] | Validate TSV headers, column counts, exact fields, exact source/fixture identity, exact values, and evidence-boundary text through Rust; use quoted Bash variables and no shell-evaluated fixture content. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity/compare_prusaslicer_gcode_output.sh] |
| Cryptography | limited [VERIFIED: fixture verifier uses SHA-256 only for fixture integrity] | Keep existing `shasum -a 256` fixture integrity check; do not add custom cryptography. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| Files and Resources | yes [CITED: OWASP ASVS project page and repository; VERIFIED: comparator accepts file paths] | Require explicit checked-in files, avoid filesystem discovery, avoid Git/network/process generation behavior, and use temp directories for mutation tests. [VERIFIED: 56-CONTEXT.md; packages/parity/compare_prusaslicer_gcode_output_test.sh] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Drifted or malicious semantic TSV rows | Tampering [VERIFIED: parser/test threat surface] | Fail closed in Rust on exact header, columns, fields, values, row order, source ref, fixture path, fixture id, and evidence-boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; tests/prusa_gcode_output.rs] |
| Shell argument or path handling mistakes | Tampering/Information disclosure [VERIFIED: Bash comparator surface] | Quote variables, require files explicitly, use temp directories, and do not evaluate fixture content as code. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; compare_prusaslicer_gcode_output_test.sh] |
| Status/docs overclaiming | Spoofing/Repudiation [VERIFIED: verifier overclaim checks] | Keep exact verifier-enforced status/doc wording and forbidden-claim scans. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| External behavior creep | Elevation of privilege/Information disclosure [VERIFIED: deferred scope] | Do not add Git, network, upstream import, runtime, printer, host upload, credential, release, or sync behavior. [VERIFIED: .planning/REQUIREMENTS.md; 56-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/56-executable-semantic-g-code-evidence/56-CONTEXT.md` - locked decisions, discretion, deferred scope, canonical refs, and verification requirements. [VERIFIED]
- `.planning/REQUIREMENTS.md` - GSEV-01, GSEV-02, GSEV-03, and v1.14 out-of-scope boundaries. [VERIFIED]
- `.planning/ROADMAP.md` - Phase 56 plans, success criteria, and requirement mapping. [VERIFIED]
- `.planning/STATE.md` - accumulated v1.14 decisions and Phase 55 handoff. [VERIFIED]
- `.planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md` - semantic fixture corpus passed and exact artifact properties. [VERIFIED]
- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-01-SUMMARY.md`, `55-02-SUMMARY.md`, and `55-VERIFICATION.md` - semantic parser/readiness implementation and verification. [VERIFIED]
- `packages/parity/BUILD.bazel`, `compare_prusaslicer_gcode_output.sh`, `compare_prusaslicer_gcode_output_test.sh`, `status.tsv`, and `README.md` - public parity command, comparator, failure tests, status, and docs. [VERIFIED]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`, `src/bin/prusa_gcode_output_summary.rs`, `src/lib.rs`, `tests/prusa_gcode_output.rs`, `tests/flavor_registry.rs`, `BUILD.bazel`, and `packages/slic3r-rust/Cargo.toml` - Rust parser, binary, tests, and workspace/toolchain. [VERIFIED]
- `packages/parity-fixtures/BUILD.bazel`, fixture TSVs, fixture README, package README, fixture verifier, and fixture verifier tests - semantic fixture aliases and fail-closed package enforcement. [VERIFIED]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`, `README.md`, verifier, and verifier tests - scope contract and exact status/doc enforcement. [VERIFIED]
- `docs/port/package-map.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and `docs/port/README.md` - public port-doc wording and stale structural-only references. [VERIFIED]
- Local focused command outputs: `bazel run //packages/parity:prusaslicer_gcode_output_parity`, `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors`, `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture`, `bazel run //packages/prusa-gcode-output-scope:verify`, and `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output`. [VERIFIED]

### Primary Standards and Security References

- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and `bright-builds-rules.audit.md` - repo-local and managed Bright Builds instructions. [VERIFIED]
- Bright Builds canonical standards at audited commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/verification.md`, `standards/core/testing.md`, and `standards/languages/rust.md`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- OWASP ASVS project and OWASP ASVS repository - latest stable ASVS 5.0.0 and ASVS purpose. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://github.com/OWASP/ASVS]

### Secondary (MEDIUM confidence)

- None used. [VERIFIED: source list above]

### Tertiary (LOW confidence)

- None used. [VERIFIED: source list above]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - based on current repo manifests, Bazel files, phase context, and local command version output. [VERIFIED: sources above]
- Architecture: HIGH - based on existing marker/structural comparator patterns, Phase 55 semantic parser/readiness implementation, and Phase 56 locked decisions. [VERIFIED: sources above]
- Pitfalls: HIGH - based on exact current structural-only status/doc/verifier state and focused baseline commands. [VERIFIED: sources above]
- Security scope: MEDIUM-HIGH - ASVS applicability is mapped to a local CLI/static-file workflow and uses official OWASP project docs for ASVS currency. [CITED: OWASP ASVS URLs; VERIFIED: local phase scope]

**Research date:** 2026-06-21 [VERIFIED: current_date]
**Valid until:** 2026-07-21 for repo-internal patterns and 2026-06-28 for external ASVS currency. [VERIFIED: research date; CITED: OWASP ASVS page]
