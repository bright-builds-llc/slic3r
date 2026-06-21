# Phase 55: Rust Semantic G-code Summary Boundary - Research

**Researched:** 2026-06-21 [VERIFIED: system date]
**Domain:** Rust 2024 typed parser/readiness boundary over checked-in Prusa G-code semantic TSV artifacts [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/slic3r-rust/Cargo.toml]
**Confidence:** HIGH [VERIFIED: codebase inspection, focused Cargo+Bazel probes, Phase 53/54 artifacts]

<user_constraints>
## User Constraints (from CONTEXT.md)

The following user constraints are copied verbatim from `55-CONTEXT.md`. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

### Locked Decisions

### Rust boundary placement

- **D-01:** Extend the existing
  `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`
  module instead of creating a new crate or vendor-specific workspace. This
  preserves the marker summary, structural summary, and semantic summary
  evidence chain for `prusaslicer.gcode-output`.
- **D-02:** Add semantic parsing as a pure data-in/data-out API over
  caller-supplied TSV text. The boundary must not read files, discover fixture
  paths, invoke generators, shell out, fetch network resources, inspect Git
  state, or publish runtime/parity status.
- **D-03:** Keep the existing marker and structural parser APIs stable while
  adding semantic types and helpers. Phase 55 should be additive unless a local
  rename is required by Rust tests and can be kept internal.

### Semantic row model

- **D-04:** Model the Phase 54 semantic header exactly:
  `source_ref`, `fixture_path`, `semantic_field`, `semantic_category`,
  `semantic_value`, and `evidence_boundary`.
- **D-05:** Accept exactly the Phase 53/54 closed semantic field set:
  `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`,
  `movement_class_counts`, `coordinate_bounds`, `extrusion_total`,
  `feedrate_observations`, and `layer_marker_relationships`.
- **D-06:** Preserve source and fixture identity as typed values where existing
  contracts support that, especially
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  `gcodewriter-set-speed.gcode`, and the checked-in semantic fixture path.
- **D-07:** Semantic values may remain narrow string-backed domain values when
  wrapping them in richer enums would add ceremony without preventing a real
  invalid state. The closed semantic field and category identities should be
  typed because downstream code depends on fail-closed recognition.

### Rejection coverage

- **D-08:** Add focused Cargo/Bazel tests proving valid semantic fixture rows
  parse and invalid semantic summaries fail closed for invalid headers, wrong
  column counts, missing rows, duplicate rows, out-of-order rows, unsupported
  semantic fields, unsupported claim text, wrong source refs, and wrong fixture
  identities.
- **D-09:** Keep each new Rust unit or integration test focused on one concern,
  with explicit Arrange, Act, Assert comments when setup is non-trivial.
- **D-10:** Reuse the existing `prusa_gcode_output_test` Bazel target and
  compile-data pattern, adding the Phase 54 semantic expected summary artifact
  as compile data instead of inventing a separate test surface.

### Readiness metadata

- **D-11:** Expose semantic readiness through the existing registry/readiness
  boundary in `slic3r_flavors`, tracing the accepted Prusa source identity,
  fixture corpus, semantic expected summary path, planned public command,
  planned status token, and deferred generated-output surfaces.
- **D-12:** Readiness wording must stay explicitly pre-publication: semantic
  parser/readiness metadata exists for Phase 55 developers, while public
  semantic parity evidence and status/docs publication remain Phase 56 work.
- **D-13:** Keep the broad `generated-outputs` surface in progress and keep
  `fork.prusaslicer.gcode-output` status publication unchanged in Phase 55.

### No-overclaiming boundary

- **D-14:** Public and internal helper names must not imply byte-for-byte
  G-code parity, printability, printer-runtime behavior, support generation,
  seam behavior, arc fitting, GUI behavior, release behavior, upstream source
  imports, sync automation, or non-Prusa fork behavior.
- **D-15:** Evidence-boundary text should be parsed or checked narrowly enough
  that broad semantic claim text fails closed without requiring Phase 55 to
  understand printer runtime semantics.

### the agent's Discretion

- Choose exact Rust type names for semantic rows, fields, categories, and
  values, provided optional internals use `maybe_` names and public names stay
  narrow.
- Choose whether the semantic parser shares helper functions with the marker
  and structural parsers or uses new small helpers, provided control flow stays
  shallow and tests remain focused.
- Choose exact readiness metadata structure inside the existing registry
  boundary, provided downstream agents can inspect semantic readiness without
  filesystem discovery, Git, network, process execution, status publication, or
  broad generated-output claims.

### Deferred Ideas (OUT OF SCOPE)

- Phase 56 owns public semantic parity evidence, semantic mutation guards,
  exact status wording, public docs, and any public command integration.
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
| GSRUST-01 | Developer can use a pure typed Rust semantic G-code summary boundary that parses caller-supplied checked-in semantic artifacts into domain values without Git, network, filesystem discovery, process, generator, printer-runtime, release, or sync side effects. [VERIFIED: .planning/REQUIREMENTS.md] | Use additive `slic3r_flavors::prusa_gcode_output` parser types/functions over `&str`, mirroring existing marker/structural parsers. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| GSRUST-02 | Developer can inspect static readiness or registry metadata that traces the semantic G-code boundary to the accepted Prusa source identity, fixture corpus, expected semantic summaries, planned command, planned status wording, and deferred generated-output surfaces. [VERIFIED: .planning/REQUIREMENTS.md] | Add semantic readiness metadata next to `prusa_gcode_output_structural_readiness()` and update registry notes/tests without touching `packages/parity/status.tsv`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/parity/status.tsv] |
| GSRUST-03 | Developer can run Cargo and Bazel coverage proving valid semantic rows parse, invalid rows fail closed, optional/nullable internals are named clearly, and public helpers avoid broad behavior claims. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `tests/prusa_gcode_output.rs`, `tests/flavor_registry.rs`, and the existing Bazel `prusa_gcode_output_test` compile-data list with the semantic TSV alias. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
</phase_requirements>

## Summary

Phase 55 is an internal Rust boundary phase, not an ecosystem-selection phase. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md] The implementation should extend `slic3r_flavors::prusa_gcode_output` with a third evidence rung: marker summary already exists, structural summary already exists, and semantic summary should now parse the Phase 54 TSV with exact header, exact row order, typed closed fields/categories, exact source/fixture identities, and exact evidence-boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

The planner should keep the parser pure over caller-supplied `&str` and should not add filesystem discovery, generator execution, Git/network/process access, public command behavior, or status/docs publication in this phase. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] The existing binary reads files and is the likely Phase 56 adapter surface, but Phase 55 should expose parser/readiness functions rather than add a public `--semantic` mode. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

**Primary recommendation:** Add a semantic parser/readiness API inside the existing `prusa_gcode_output` module, re-export it from `lib.rs`, wire the semantic TSV into the existing Bazel test compile data, update focused Cargo/Bazel tests, and leave public parity/status/docs publication to Phase 56. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

## Project Constraints (from AGENTS.md)

- Follow `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant Bright Builds standards before planning work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Repo-local summary rules apply only to phase `*-SUMMARY.md` files; do not run `mdformat` over summary files, and keep `requirements-completed` frontmatter intact when summaries are touched. [VERIFIED: AGENTS.md]
- Bright Builds standards require functional-core/imperative-shell architecture and parsing raw boundary input into domain types early. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md]
- Bright Builds standards require illegal states to be unrepresentable when practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md]
- Bright Builds code-shape guidance prefers early returns, Rust `let...else` for guard extraction, `maybe_` for internal optional names, and treats functions over roughly 161 lines and files over roughly 628 lines as refactor triggers rather than hard caps. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md]
- Bright Builds testing standards require pure/business logic unit coverage, one concern per unit test, and clear Arrange/Act/Assert structure unless a trivial test is already obvious. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md]
- Bright Builds Rust guidance requires `foo.rs` plus `foo/` over `foo/mod.rs` for new multi-file modules, `let...else` where it improves guard extraction, `maybe_` for optional internal Rust names, and newtypes/enums/fallible constructors for meaningful invariants. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md]
- Rust project pre-commit guidance requires format, clippy, build, and tests before commits; in this repo the relevant commands must use Rust 1.94.1 because the workspace declares `rust-version = "1.94"` and the default local `rustc` is 1.91.1. [VERIFIED: user-provided AGENTS.md; packages/slic3r-rust/Cargo.toml; rustc --version; cargo test probe]
- No `.claude/skills/` or `.agents/skills/` directories exist in this checkout, so there are no repo-local skills to apply. [VERIFIED: find .claude/.agents probes]
- The local `standards/` directory referenced by the managed Bright Builds sidecar is not checked in; the relevant canonical pages were loaded from the pinned upstream repository URLs. [VERIFIED: rg --files probe; AGENTS.bright-builds.md; web fetch of Bright Builds raw URLs]

## Standard Stack

### Core

| Library/Tool | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| Rust workspace under `packages/slic3r-rust` | edition 2024, `rust-version = "1.94"` [VERIFIED: packages/slic3r-rust/Cargo.toml] | Hosts the Rust crates used by the Slic3r port. [VERIFIED: packages/slic3r-rust/Cargo.toml] | Existing crate boundary for this phase; no new language/runtime needed. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] |
| `slic3r_flavors` crate | `0.1.0` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Owns pure flavor metadata, `prusa_gcode_output` parsers, and registry/readiness helpers. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Locked placement for semantic parser/readiness work. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] |
| `slic3r_contracts` crate | `0.1.0` [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml] | Provides typed `VendorSourceRef`, `FlavorId`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Existing typed identity source; use it for source refs and registry metadata instead of raw string propagation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| Bazel + `rules_rust` | Bazel 8.6.0 local; `rules_rust` 0.69.0; Rust toolchain 1.94.1 configured. [VERIFIED: bazel --version; MODULE.bazel] | Builds and tests Rust package boundaries. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Required by success criteria for Bazel coverage and already runs the existing `prusa_gcode_output_test`. [VERIFIED: .planning/ROADMAP.md; bazel test probe] |

### Supporting

| Library/Tool | Version | Purpose | When to Use |
|--------------|---------|---------|-------------|
| Phase 54 semantic TSV | 10 lines, 6 columns, 9 semantic rows. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv; .planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md] | Parser input fixture and exact expected semantic row source. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] | Include through Cargo `include_str!` and Bazel compile data in the existing test target. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| `rustup` | 1.29.0; installed toolchain `1.94.1-aarch64-apple-darwin`. [VERIFIED: rustup --version; rustup toolchain list] | Selects the matching Cargo toolchain for local tests. [VERIFIED: cargo +1.94.1 test probe] | Use `cargo +1.94.1 ...` unless the default toolchain is updated. [VERIFIED: cargo default failure probe; cargo +1.94.1 success probe] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Existing `prusa_gcode_output.rs` module | New crate or vendor-specific workspace | Rejected by locked D-01 and would split the evidence chain. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] |
| Exact in-module TSV parsing over `&str` | `csv` crate or generalized TSV framework | Existing marker/structural parsers use exact `split('\t')`, header, row, and boundary matching; adding a dependency would not improve this fixed, checked-in six-column artifact. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv] |
| Parser/readiness-only API | Public binary `--semantic` mode in Phase 55 | Rejected for this phase because public command integration is deferred to Phase 56. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; .planning/ROADMAP.md] |

**Installation:** No new package installation is required for implementation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/Cargo.lock]

```bash
# Use the installed matching Rust toolchain for Cargo verification in this checkout.
cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output
```

**Version verification:** This phase uses local Cargo/Bazel manifests rather than npm packages. [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel] The focused Cargo test fails with the default `rustc 1.91.1` because `slic3r_contracts` and `slic3r_flavors` require Rust 1.94, and passes with `cargo +1.94.1`. [VERIFIED: cargo test probe; cargo +1.94.1 test probe]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
├── src/
│   ├── prusa_gcode_output.rs      # Add semantic constants, types, parser, summary lines, readiness metadata. [VERIFIED]
│   ├── registry.rs                # Update Prusa G-code capability notes/readiness trace. [VERIFIED]
│   └── lib.rs                     # Re-export semantic public types/helpers. [VERIFIED]
├── tests/
│   ├── prusa_gcode_output.rs      # Add valid semantic parsing and fail-closed mutation tests. [VERIFIED]
│   └── flavor_registry.rs         # Add readiness/registry/no-overclaiming tests. [VERIFIED]
└── BUILD.bazel                    # Add semantic TSV compile_data to existing prusa_gcode_output_test. [VERIFIED]
```

### Pattern 1: Exact Typed Boundary Parser

**What:** Parse caller-supplied TSV text into semantic rows and facts, using exact header validation, exact column count, required-value checks, typed closed field/category enums, typed source ref, exact fixture path/id values, exact evidence-boundary text, duplicate detection, order validation, and missing-row validation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

**When to use:** Use for Phase 55 semantic summaries only; do not generalize it into a runtime G-code parser. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
pub fn parse_prusa_gcode_output_structural_summary(
    input: &str,
) -> PrusaGcodeOutputStructuralParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaGcodeOutputStructuralParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_structural_header(header)?;
    // Semantic parser should mirror this shape with semantic-specific types.
}
```

### Pattern 2: Facts Object from Validated Rows

**What:** Build a compact facts object only after row validation, so downstream callers inspect typed facts instead of re-parsing row strings. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

**When to use:** Use for semantic values such as source ref, fixture id/path, command class counts, movement class counts, coordinate-bound absence, extrusion absence, feedrate observations, and layer marker absence. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
impl PrusaGcodeOutputStructuralSummary {
    fn from_validated_rows(rows: Vec<PrusaGcodeOutputStructuralSummaryRow>) -> Self {
        let facts = PrusaGcodeOutputStructuralFacts::from_validated_rows(&rows);
        Self { rows, facts }
    }

    pub fn rows(&self) -> &[PrusaGcodeOutputStructuralSummaryRow] {
        &self.rows
    }
}
```

### Pattern 3: Static Readiness Metadata, Not Publication

**What:** Add a semantic readiness struct/function that returns static values for source identity, fixture corpus, semantic summary path, parser boundary, planned Phase 56 command, reserved status token, and deferred surfaces. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

**When to use:** Use when planner needs GSRUST-02 without changing `packages/parity/status.tsv` or public docs. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
pub const fn prusa_gcode_output_structural_readiness() -> PrusaGcodeOutputStructuralReadiness {
    PrusaGcodeOutputStructuralReadiness {
        inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
        source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
        fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        expected_structural_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_STRUCTURAL_SUMMARY_PATH,
        parser_boundary: "slic3r_flavors::prusa_gcode_output::parse_prusa_gcode_output_structural_summary",
        parity_dependency: ParitySurface::generated_outputs(),
        checklist_status: ChecklistStatus::FutureCandidate,
        reserved_future_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
        inventory_source_paths: &PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS,
    }
}
```

### Anti-Patterns to Avoid

- **Adding a public semantic CLI mode in Phase 55:** Public semantic evidence and command integration are Phase 56 responsibilities. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; .planning/ROADMAP.md]
- **Accepting semantic rows by field presence only:** Phase 54 verification requires exact rows/order, and Phase 55 tests must reject missing, duplicate, out-of-order, unsupported, and broad-claim rows. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]
- **Publishing status or docs in registry work:** Registry/readiness metadata can mention planned command/status token, but `generated-outputs` and `fork.prusaslicer.gcode-output` status publication must not change in Phase 55. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/parity/status.tsv]
- **Large opportunistic refactor of `prusa_gcode_output.rs`:** The file already exceeds the Bright Builds file-size trigger, but locked D-01 requires preserving the existing module boundary, so Phase 55 should keep changes localized unless a small helper extraction is explicitly scoped. [VERIFIED: wc -l probe; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Fixture discovery | Recursive filesystem search or Git-aware path discovery | Caller-supplied TSV `&str` plus static readiness paths. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] | Phase 55 must avoid filesystem discovery and Git/process behavior. [VERIFIED: .planning/REQUIREMENTS.md] |
| G-code semantic interpretation | Runtime parser that infers broad toolpath/print semantics | Phase 54 exact semantic rows and narrow string-backed values. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv] | The approved fixture records only feedrate-only observations and explicit absences. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode; expected-gcode-semantic-summary.tsv] |
| Status publication | Code or docs that update `generated-outputs` or semantic status text | Static readiness metadata and existing registry note update only. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] | Phase 56 owns public semantic status/docs publication. [VERIFIED: .planning/ROADMAP.md] |
| New test surface | Separate Bazel test target for semantic parser only | Existing `prusa_gcode_output_test` target with semantic compile data. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | D-10 explicitly locks reuse of the existing target pattern. [VERIFIED: 55-CONTEXT.md] |
| New identity model | Raw string identities or duplicated vendor enums | `VendorSourceRef`, `FlavorId`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus` from `slic3r_contracts`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Existing contracts already encode canonical source/status tokens. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |

**Key insight:** The hard part is not parsing TSV syntax; it is preserving the narrow evidence contract so broad generated-output, runtime, printability, support, seam, arc, GUI, release, sync, and non-Prusa claims cannot sneak in through names or evidence-boundary text. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

## Common Pitfalls

### Pitfall 1: Treating Semantic Readiness as Public Evidence

**What goes wrong:** A helper, registry note, binary mode, status row, or docs wording implies semantic parity has already shipped. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/parity/status.tsv]

**Why it happens:** Existing structural evidence is already public, while semantic evidence is still pre-publication until Phase 56. [VERIFIED: packages/parity/status.tsv; .planning/ROADMAP.md]

**How to avoid:** Keep semantic readiness wording explicitly pre-publication and do not edit `packages/parity/status.tsv`, `packages/parity/README.md`, or `docs/port/*` for semantic publication in Phase 55. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

**Warning signs:** New text says semantic evidence is `verified`, generated-output status is complete, or public command behavior validates semantic rows. [VERIFIED: packages/parity/status.tsv; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

### Pitfall 2: Forgetting Bazel Compile Data

**What goes wrong:** Cargo tests pass through `include_str!`, but Bazel tests cannot see the semantic TSV. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**Why it happens:** The fixture alias `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_semantic_summary` already exists, but `prusa_gcode_output_test` does not yet list it in `compile_data`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**How to avoid:** Add the semantic alias to the existing `prusa_gcode_output_test` compile-data list in Plan 55-01. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

**Warning signs:** Cargo semantic test compiles, while Bazel reports a missing included fixture path. [VERIFIED: existing test include_str pattern and Bazel compile_data pattern]

### Pitfall 3: Default Cargo Toolchain Mismatch

**What goes wrong:** Cargo verification fails before tests compile. [VERIFIED: cargo test probe]

**Why it happens:** The default local `rustc` is 1.91.1, while the workspace requires Rust 1.94 and rustup has 1.94.1 installed but not active by default. [VERIFIED: rustc --version; packages/slic3r-rust/Cargo.toml; rustup toolchain list]

**How to avoid:** Use `cargo +1.94.1 ...` in Phase 55 Cargo commands, or update the default rustup toolchain before verification. [VERIFIED: cargo +1.94.1 test probe]

**Warning signs:** Error text says `slic3r_contracts` or `slic3r_flavors` requires `rustc 1.94`. [VERIFIED: cargo test probe]

### Pitfall 4: Value Typing Without Real Invariants

**What goes wrong:** Planner adds many one-off enums for exact semantic values and increases ceremony without making invalid states less representable. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]

**Why it happens:** Semantic fields/categories need closed typing, but D-07 explicitly allows narrow string-backed semantic values where richer enums do not prevent a real invalid state. [VERIFIED: 55-CONTEXT.md]

**How to avoid:** Use enums for `semantic_field` and `semantic_category`; use typed wrappers or exact string-backed enum variants for source/fixture identities; keep broad semantic values exact and narrow. [VERIFIED: 55-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv]

**Warning signs:** The implementation duplicates the entire TSV row value matrix in many tiny value enums while still exact-matching strings elsewhere. [VERIFIED: existing structural parser pattern]

### Pitfall 5: No-Overclaiming Tests Blocking Approved Semantic Words

**What goes wrong:** Existing no-overclaiming tests reject new public declarations containing approved semantic terms such as `extrusion_total` if fields are exposed with lowercase public names. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

**Why it happens:** The current test scans public source declarations for risky lower-case words and only whitelists `pub extrusion_axis_present: bool,`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

**How to avoid:** Either expose semantic facts in names that remain narrow and safe, or update the whitelist for Phase 53-approved semantic surfaces with a precise comment/test assertion. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

**Warning signs:** New parser code compiles, but `public_declarations_do_not_claim_deferred_behavior` fails on an approved field name. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

## Code Examples

Verified patterns from local sources:

### Exact Header And Row Validation

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
fn validate_structural_header(line: &str) -> Result<(), PrusaGcodeOutputStructuralParseError> {
    if line != STRUCTURAL_EXPECTED_HEADER {
        return Err(PrusaGcodeOutputStructuralParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}
```

### Typed Source Ref Preservation

```rust
// Source: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs
pub const fn prusa_slicer_version_2_9_5() -> Self {
    Self {
        value: "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
        vendor: DownstreamFork::PrusaSlicer,
        selected_tag: "version_2.9.5",
        peeled_commit: "9a583bd438b195856f3bcf7ea99b69ba4003a961",
    }
}
```

### Focused Fail-Closed Test Shape

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs
#[test]
fn rejects_structural_wrong_column_count() {
    // Arrange
    let input = replace_first_structural_data_row("only\tfive\tcolumns\tin\trow");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::WrongColumnCount {
            line_number: 2,
            expected: 6,
            actual: 5,
        })
    ));
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Marker-only expected summary | Marker + structural + semantic sidecars for the same Prusa fixture | v1.14 Phase 54 added `expected-gcode-semantic-summary.tsv`. [VERIFIED: .planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md] | Phase 55 can consume semantic facts without generating G-code. [VERIFIED: .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md] |
| Public structural evidence wording only | Semantic readiness remains internal until Phase 56 | Phase 55 boundary is explicitly pre-publication. [VERIFIED: .planning/ROADMAP.md; 55-CONTEXT.md] | Avoid status/docs promotion in this phase. [VERIFIED: packages/parity/status.tsv] |
| Registry note says structural readiness/public structural work | Registry/readiness should now name semantic parser readiness and Phase 56 public semantic publication as future work | Phase 55 Plan 55-02 scope. [VERIFIED: 55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] | Prevent stale Phase 52 wording from confusing downstream planning. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] |

**Deprecated/outdated:**

- Treating `fork.prusaslicer.gcode-output` as unpublished is outdated for structural evidence; the row is currently `verified` for the narrow structural slice, but Phase 55 must not broaden it to semantic evidence. [VERIFIED: packages/parity/status.tsv; .planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md]
- Registry note text that says structural publication remains Phase 52 work is stale relative to current status and should be replaced with semantic pre-publication wording. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/parity/status.tsv]

## Assumptions Log

> List all claims tagged `[ASSUMED]` in this research. The planner and discuss-phase use this section to identify decisions that need user confirmation before execution.

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

**This table is empty:** all claims in this research were verified in the repo, by local command probes, or cited from official/current standards sources. [VERIFIED: full research session sources]

## Open Questions (RESOLVED)

1. **RESOLVED: Use explicit `cargo +1.94.1` commands in Phase 55 plans and do not add checked-in toolchain config in this phase.** [VERIFIED: rustup toolchain list; cargo default failure probe; 55-01-PLAN.md; 55-02-PLAN.md]
   - What we know: `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output` passed. [VERIFIED: cargo +1.94.1 test probe]
   - Decision: Phase 55 will standardize on explicit `+1.94.1` Cargo commands and avoid adding `rust-toolchain.toml` or changing the local default toolchain because the phase scope is the semantic parser/readiness boundary, not repository toolchain policy. [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel; 55-01-PLAN.md; 55-02-PLAN.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Bazel test coverage for `prusa_gcode_output_test`. [VERIFIED: .planning/ROADMAP.md] | yes [VERIFIED: bazel --version] | 8.6.0 [VERIFIED: bazel --version] | none needed; focused test passed. [VERIFIED: bazel test probe] |
| `rules_rust` | Bazel Rust toolchain/package rules. [VERIFIED: MODULE.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | yes [VERIFIED: MODULE.bazel] | 0.69.0 [VERIFIED: MODULE.bazel] | none needed. [VERIFIED: bazel test probe] |
| Rust toolchain for Bazel | Rust 2024 Bazel builds/tests. [VERIFIED: MODULE.bazel] | yes [VERIFIED: MODULE.bazel; bazel test probe] | 1.94.1 configured [VERIFIED: MODULE.bazel] | none needed. [VERIFIED: bazel test probe] |
| Cargo default toolchain | Cargo test coverage. [VERIFIED: .planning/ROADMAP.md] | partial [VERIFIED: cargo --version; rustc --version] | cargo 1.91.1 / rustc 1.91.1 default [VERIFIED: cargo --version; rustc --version] | Use `cargo +1.94.1`. [VERIFIED: cargo +1.94.1 test probe] |
| Rustup 1.94.1 toolchain | Matching Cargo verification. [VERIFIED: packages/slic3r-rust/Cargo.toml] | yes [VERIFIED: rustup toolchain list] | rustup 1.29.0 with toolchain `1.94.1-aarch64-apple-darwin` installed [VERIFIED: rustup --version; rustup toolchain list] | none needed if commands use `+1.94.1`. [VERIFIED: cargo +1.94.1 test probe] |

**Missing dependencies with no fallback:** None. [VERIFIED: environment probes]

**Missing dependencies with fallback:** Default Cargo/rustc is too old for this workspace, but `cargo +1.94.1` is installed and verified. [VERIFIED: cargo default failure probe; cargo +1.94.1 test probe]

## Security Domain

### Applicable ASVS Categories

OWASP ASVS provides a basis for testing application technical security controls and secure-development requirements. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no [VERIFIED: 55-CONTEXT.md] | No authentication surface is introduced. [VERIFIED: 55-CONTEXT.md] |
| V3 Session Management | no [VERIFIED: 55-CONTEXT.md] | No session surface is introduced. [VERIFIED: 55-CONTEXT.md] |
| V4 Access Control | no [VERIFIED: 55-CONTEXT.md] | No authorization or multi-user access surface is introduced. [VERIFIED: 55-CONTEXT.md] |
| V5 Input Validation | yes [VERIFIED: semantic parser requirements] | Exact header, exact column count, closed fields/categories, exact source/fixture identities, exact evidence-boundary strings, and fail-closed tests. [VERIFIED: 55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| V6 Cryptography | no [VERIFIED: 55-CONTEXT.md] | No secrets, credentials, hashes, encryption, signing, or crypto APIs are introduced. [VERIFIED: 55-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv] |

### Known Threat Patterns for Rust TSV Boundary

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Spoofed source or fixture identity in TSV input | Spoofing/Tampering [VERIFIED: parser error patterns] | Reject any source ref, fixture path, or fixture id that does not match the accepted Prusa source and fixture constants. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; expected-gcode-semantic-summary.tsv] |
| Broad semantic claim text in `evidence_boundary` | Tampering/Repudiation [VERIFIED: Phase 55 requirements] | Exact-match evidence-boundary text per expected row and test unsupported broad claim text. [VERIFIED: 55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs] |
| Runtime side effect added to parser | Elevation of privilege/Information disclosure [VERIFIED: no-side-effect requirement] | Keep parser as pure `&str -> Result<T, E>` and leave file reads to existing adapters outside Phase 55 scope. [VERIFIED: 55-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| Duplicate, missing, or out-of-order semantic rows | Tampering [VERIFIED: Phase 55 success criteria] | Validate row keys against exact expected semantic row order and require all nine rows. [VERIFIED: 55-CONTEXT.md; expected-gcode-semantic-summary.tsv] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md` - locked user decisions, phase scope, canonical refs, and no-overclaiming boundary. [VERIFIED]
- `.planning/REQUIREMENTS.md` - GSRUST-01, GSRUST-02, GSRUST-03 and v1.14 out-of-scope boundary. [VERIFIED]
- `.planning/STATE.md` and `.planning/ROADMAP.md` - milestone state, phase order, and Phase 55/56 boundaries. [VERIFIED]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - existing marker/structural parser, readiness pattern, constants, and fail-closed helpers. [VERIFIED]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` - existing Cargo/Bazel parser tests and no-overclaiming tests. [VERIFIED]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` - registry/readiness expectations and public helper name guard. [VERIFIED]
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` and `packages/parity-fixtures/BUILD.bazel` - Bazel target and semantic fixture alias wiring. [VERIFIED]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv` - exact Phase 54 semantic artifact. [VERIFIED]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - Phase 53 closed semantic field contract and traceability. [VERIFIED]
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_gcode_output` - focused Cargo path passed with installed matching toolchain. [VERIFIED]
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test --test_output=errors` - focused Bazel path passed. [VERIFIED]

### Secondary (MEDIUM confidence)

- Bright Builds canonical standards pages loaded from the pinned upstream raw URLs named by `AGENTS.bright-builds.md`: architecture, code-shape, verification, testing, and Rust guidance. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/index.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md]
- OWASP ASVS project page for the security-control framing. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Tertiary (LOW confidence)

- None. [VERIFIED: source review]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - all stack choices are locked to existing local Rust crates, Cargo manifests, Bazel manifests, and Phase 55 decisions. [VERIFIED: 55-CONTEXT.md; packages/slic3r-rust/Cargo.toml; MODULE.bazel]
- Architecture: HIGH - existing marker/structural parser and readiness patterns directly match the semantic boundary shape. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]
- Pitfalls: HIGH - pitfalls come from existing tests, Phase 54 verification, environment probes, and locked no-overclaiming rules. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; .planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md; cargo/bazel probes]

**Research date:** 2026-06-21 [VERIFIED: system date]
**Valid until:** 2026-07-21 for internal code/fixture recommendations; re-check toolchain availability before execution. [VERIFIED: local environment probes]
