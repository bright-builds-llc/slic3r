# Phase 59: Rust Arc-Fitting Evidence Boundary - Research

**Researched:** 2026-06-24
**Domain:** Pure Rust TSV evidence parsing, static flavor registry metadata, and Cargo/Bazel verification
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for this section: [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md]

### Locked Decisions

### Rust module and public surface

- **D-01:** Add the boundary as a new `slic3r_flavors` module named
  `prusa_arc_fitting`, with public re-exports from `src/lib.rs` that mirror
  the established `prusa_gcode_output` and `prusa_project_file` parser
  surfaces.
- **D-02:** Keep the boundary pure and caller-supplied: parser entrypoints
  accept `&str` input and return typed values or typed parse errors. The Rust
  module must not perform filesystem discovery, Git access, network access,
  process spawning, environment inspection, clock reads, source imports, live
  G-code generation, printer-runtime behavior, or status/docs mutation.
- **D-03:** Do not add the Phase 60 public parity target or status row in this
  phase. If a developer-facing helper is useful, it must remain scoped to the
  Rust crate and must not be documented as public executable parity evidence.

### Arc summary schema and domain facts

- **D-04:** Parse the exact Phase 58 six-column TSV schema:
  `source_ref`, `fixture_path`, `arc_field`, `arc_category`, `arc_value`, and
  `evidence_boundary`.
- **D-05:** Treat the Phase 57 approved field list as a closed ordered enum:
  `source_ref`, `inventory_source_paths`, `source_anchor`, `fixture_id`,
  `fixture_path`, `arc_command_counts`, `arc_direction_counts`,
  `center_offset_observations`, `coordinate_bounds`,
  `extrusion_observations`, `feedrate_observations`, and
  `evidence_boundary`.
- **D-06:** Expose a typed summary row model plus an extracted facts model for
  the checked-in artifact values. Facts should include the accepted source ref,
  inventory/source paths, source anchors, fixture identity/path, G2/G3 arc
  command counts, direction counts, center-offset observations, coordinate
  bounds, extrusion observations, feedrate observations, and evidence-boundary
  token.
- **D-07:** Reject invalid header, wrong column count, missing row, duplicate
  row, out-of-order row, unsupported arc field, unexpected source ref,
  unexpected fixture path, unexpected fixture identity, unexpected value, and
  unsupported claim text. Diagnostics should name the failing line, field, or
  expected value where practical.
- **D-08:** Keep evidence-boundary validation strict. Forbidden claims include
  byte-for-byte parity, broad generated-output verification, ArcWelder
  algorithm equivalence, tolerance or geometry parity, printability, firmware
  behavior, printer-runtime behavior, GUI behavior, support generation, wall
  seam behavior, release behavior, upstream import, sync behavior, host upload,
  network/device behavior, Bambu Studio, OrcaSlicer, and non-Prusa fork
  behavior.

### Readiness metadata and registry integration

- **D-09:** Add static arc-fitting metadata that traces the boundary to
  `prusaslicer.arc-fitting`, source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `src/libslic3r/Geometry/ArcWelder.cpp`, fixture corpus path,
  expected summary path, Phase 57 scope record, planned Phase 60 command, and
  planned Phase 60 status token.
- **D-10:** Add readiness metadata that explicitly says Phase 59 provides a
  developer-facing parser/readiness boundary only. The metadata must keep
  public executable evidence, status publication, broad generated-output
  graduation, byte parity, printability, runtime behavior, GUI behavior,
  support, seam, release, sync, upstream import, and non-Prusa fork behavior
  deferred.
- **D-11:** Add `prusaslicer.arc-fitting` to the static flavor registry as a
  PrusaSlicer shared-downstream future candidate with `generated-outputs` as
  its dependency. Do not change the existing `prusaslicer.gcode-output`
  capability text except where a narrow no-widening reference is required by
  tests.

### Verification and documentation boundary

- **D-12:** Add focused Rust tests in `slic3r_flavors` for valid parsing,
  summary-line extraction if provided, fail-closed invalid rows, metadata
  values, registry visibility, and no-overclaiming public names or text.
  Tests should use Arrange, Act, Assert comments unless the test is trivial.
- **D-13:** Wire the new Rust test into crate-local Bazel targets and the
  aggregate Rust verification surface so both Cargo and Bazel coverage prove
  ARCRUST-03.
- **D-14:** Update only developer-facing Rust package documentation or crate
  docs when needed to make the Phase 59 boundary inspectable. Public port docs,
  `packages/parity/status.tsv`, and public parity package command docs remain
  Phase 60-owned.

### the agent's Discretion

- Choose exact Rust type names, helper functions, and parse-error variants,
  provided optional values use `maybe_` naming, invalid states are represented
  with enums/newtypes rather than raw strings where practical, and the public
  names do not overclaim parity.
- Choose whether to add a crate-local summary-lines helper, provided it
  consumes caller-supplied input and remains separate from public executable
  parity.
- Choose exact test helper names and mutation helpers, provided each test
  proves one behavior and the invalid-input cases are easy to read.

### Deferred Ideas (OUT OF SCOPE)

- Phase 60 owns public `bazel run //packages/parity:prusaslicer_arc_fitting_parity`,
  public mutation guards, exact `fork.prusaslicer.arc-fitting` status wording,
  `packages/parity` docs, and public `docs/port/*` publication.
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
| ARCRUST-01 | Developer can use a pure typed Rust arc-fitting summary boundary that parses caller-supplied checked-in arc summary artifacts into domain values without Git, network, filesystem discovery, process, generator, printer-runtime, release, or sync side effects. | Use a new `slic3r_flavors::prusa_arc_fitting` module with `&str` parser entrypoints, closed enums for the 12 approved arc fields, typed row/facts models, and no filesystem/process/network imports. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| ARCRUST-02 | Developer can inspect static readiness or registry metadata that traces the arc-fitting boundary to the accepted Prusa source identity, fixture corpus, expected arc summaries, planned command, planned status wording, and deferred generated-output surfaces. | Add `PrusaArcFittingMetadata`, `PrusaArcFittingReadiness`, and one `registry.rs` capability row for `prusaslicer.arc-fitting` with `ParitySurface::generated_outputs()` and `ChecklistStatus::FutureCandidate`. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] |
| ARCRUST-03 | Developer can run Cargo and Bazel coverage proving valid arc fixture rows parse, invalid rows fail closed, optional or nullable Rust internals are named clearly, and no public helper names claim deferred behavior. | Add `tests/prusa_arc_fitting.rs`, include the Phase 58 `expected-arc-summary.tsv` compile data, extend `BUILD.bazel` and `//packages/slic3r-rust:verify`, and run Cargo with toolchain `+1.94.1` plus Bazel tests. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel; cargo +1.94.1 test --no-run] |
</phase_requirements>

## Summary

Phase 59 should be implemented as a new pure Rust parser/readiness module under `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs`, not as a public parity command, status update, docs publication, or extension of the existing `prusaslicer.gcode-output` meaning. [VERIFIED: .planning/ROADMAP.md; .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

The parser should mirror the existing `prusa_gcode_output` structural/semantic pattern: validate an exact header, split rows by tabs, reject empty values, parse strings into closed enums/newtypes, enforce exact row order and uniqueness, build typed facts from validated rows, and expose static readiness metadata through `const fn` helpers. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; standards/core/architecture.md@05f8d7a6; standards/languages/rust.md@05f8d7a6]

**Primary recommendation:** Add `prusa_arc_fitting.rs`, `tests/prusa_arc_fitting.rs`, public re-exports in `lib.rs`, one registry capability row, Bazel test/compile-data wiring, and aggregate Rust verify wiring; do not add a binary or public parity target in Phase 59. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel]

## Project Constraints (from AGENTS.md)

- Repo work must read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned Bright Builds standards before plan/review/implementation/audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- The managed Bright Builds block and `AGENTS.bright-builds.md` must not be edited directly. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- For `.planning/phases/*/*-SUMMARY.md`, keep the frontmatter key `requirements-completed` exact and do not run `mdformat` over summary files. [VERIFIED: AGENTS.md]
- Bright Builds architecture rules require functional core / imperative shell, parsing raw input into domain types at boundaries, and making illegal states unrepresentable where practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Bright Builds code-shape rules prefer early returns, `let...else`, `maybe` prefixes for nullable/optional internal names, and treating functions over roughly 161 lines and files over roughly 628 lines as refactor triggers. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Bright Builds testing rules require pure/business logic unit tests, one concern per unit test, and Arrange/Act/Assert structure. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Bright Builds Rust rules require `foo.rs` plus `foo/` over `foo/mod.rs` for new multi-file modules, `maybe_` for optional internal names, and enums/newtypes/fallible constructors for invariants. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Verification should prefer repo-owned entrypoints and run relevant checks before commits. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- No repo-local `.claude/skills` or `.agents/skills` directories were found during this research. [VERIFIED: find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Rust toolchain | 1.94.1 | Compile and test the Rust workspace. | `MODULE.bazel` registers Rust `1.94.1`, `packages/slic3r-rust/Cargo.toml` requires Rust `1.94`, and `rustup` has `1.94.1-aarch64-apple-darwin` installed. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml; rustup toolchain list; rustc +1.94.1 --version] |
| Cargo | 1.94.1 | Run crate-local Rust tests for `slic3r_flavors`. | Default Cargo `1.91.1` fails the workspace `rust-version` gate, while `cargo +1.94.1 test -p slic3r_flavors --manifest-path packages/slic3r-rust/Cargo.toml --no-run` succeeds. [VERIFIED: cargo --version; cargo test failure; cargo +1.94.1 test --no-run] |
| Bazel | 8.6.0 | Repo-owned build/test orchestration. | The repo uses Bazel targets for Rust tests and aggregate verification, and `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test` passes. [VERIFIED: bazel --version; .bazelrc; packages/slic3r-rust/BUILD.bazel; bazel test prusa_gcode_output_test] |
| rules_rust | 0.69.0 | Bazel Rust rules and registered Rust toolchain. | `MODULE.bazel` declares `bazel_dep(name = "rules_rust", version = "0.69.0")` and registers a Rust `1.94.1` toolchain. [VERIFIED: MODULE.bazel] |
| `slic3r_flavors` | 0.1.0 | Existing pure flavor parser/registry crate to extend. | The crate already owns Prusa profile, project-file, and G-code output parser/readiness surfaces. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs] |
| `slic3r_contracts` | local path | Typed flavor/source/status contracts. | Existing `prusa_gcode_output` and registry code use `ChecklistStatus`, `FeatureOrigin`, `FlavorId`, `ParitySurface`, and `VendorSourceRef` from this crate. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |

### Supporting

| Artifact / Target | Version | Purpose | When to Use |
|-------------------|---------|---------|-------------|
| `//packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary` | checked-in fixture alias | Compile data for new Rust tests. | Use in `prusa_arc_fitting_test` compile data so tests read the reviewed Phase 58 TSV via `include_str!`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; bazel query //packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary] |
| `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` | Phase 57 artifact | Closed 12-field arc evidence contract. | Use as the source for field order, source identity, planned command/status, and deferral wording. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` | Phase 58 artifact | Exact input schema and expected values. | Use as parser fixture and facts source. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv; .planning/phases/58-arc-fitting-fixture-corpus/58-VERIFICATION.md] |
| `packages/parity/status.tsv` | checked-in status source | Guard against premature status publication. | Read in tests or shell guards only to prove zero `fork.prusaslicer.arc-fitting` rows during Phase 59 if needed. [VERIFIED: awk status scan; packages/parity/status.tsv] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| New `prusa_arc_fitting` module | Extend `prusa_gcode_output.rs` | Rejected by locked decision D-01 and by the need to preserve `fork.prusaslicer.gcode-output` meaning. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| Pure crate helper only | New Phase 59 Rust binary | Rejected because Phase 59 must not add a public executable parity surface; Phase 60 owns the public command. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md] |
| Static closed parser | Generic TSV parser crate | Avoid new dependencies because the existing crate uses `std` split/validation and the schema is a tiny closed contract. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| Checked-in summary parsing | Live G-code generation or ArcWelder algorithm comparison | Rejected because v1.15 proves checked-in summary evidence only, not byte parity, printability, runtime behavior, or algorithm equivalence. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |

**Installation:**

```bash
# No new crates or npm packages are needed for Phase 59. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]
rustup toolchain install 1.94.1
```

**Version verification:** No `npm view` applies because Phase 59 adds no npm packages. Tool versions were verified with `cargo +1.94.1 --version`, `rustc +1.94.1 --version`, `bazel --version`, `MODULE.bazel`, and Cargo manifests. [VERIFIED: command outputs; MODULE.bazel; packages/slic3r-rust/Cargo.toml]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
├── src/
│   ├── lib.rs                 # Re-export the new parser/facts/readiness API. [VERIFIED: src/lib.rs]
│   ├── prusa_arc_fitting.rs   # New pure parser, facts, metadata, readiness. [VERIFIED: 59-CONTEXT.md]
│   ├── prusa_gcode_output.rs  # Existing parser/readiness precedent. [VERIFIED: src/prusa_gcode_output.rs]
│   └── registry.rs            # Add prusaslicer.arc-fitting capability row. [VERIFIED: src/registry.rs]
├── tests/
│   ├── prusa_arc_fitting.rs   # New valid/invalid/metadata/no-overclaim tests. [VERIFIED: 59-CONTEXT.md]
│   ├── prusa_gcode_output.rs  # Existing parser test precedent. [VERIFIED: tests/prusa_gcode_output.rs]
│   └── flavor_registry.rs     # Extend registry expectations. [VERIFIED: tests/flavor_registry.rs]
└── BUILD.bazel                # Add src/test/compile_data/clippy/rustfmt wiring. [VERIFIED: BUILD.bazel]
```

### Pattern 1: Closed TSV Boundary

**What:** Parse the six-column TSV through exact header, exact column count, non-empty values, closed field/category/value enums, exact row order, duplicate detection, extra-row detection, and missing-row detection. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv]

**When to use:** Use this for `expected-arc-summary.tsv` only; do not parse arbitrary G-code or discover fixture files. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

**Example:**

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs [VERIFIED]
pub fn parse_prusa_arc_fitting_summary(input: &str) -> PrusaArcFittingParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaArcFittingParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_arc_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_arc_summary_row(line, line_number)?;
        let row_key = PrusaArcFittingRowKey::from_row(&row);
        // Duplicate, extra, and order checks should mirror prusa_gcode_output. [VERIFIED]
        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_arc_rows(&row_keys)?;
    Ok(PrusaArcFittingSummary::from_validated_rows(rows))
}
```

### Pattern 2: Facts from Validated Rows

**What:** Build `PrusaArcFittingFacts` only after rows have passed exact validation, following `PrusaGcodeOutputStructuralFacts::from_validated_rows` and `PrusaGcodeOutputSemanticFacts::from_validated_rows`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

**When to use:** Use this to expose stable developer-facing facts for source ref, source paths, anchors, fixture identity/path, arc counts, direction counts, center offsets, coordinate bounds, extrusion observations, feedrate observations, and boundary token. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; expected-arc-summary.tsv]

**Example:**

```rust
// Source pattern: PrusaGcodeOutputSemanticSummary::from_validated_rows. [VERIFIED]
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaArcFittingSummary {
    rows: Vec<PrusaArcFittingSummaryRow>,
    facts: PrusaArcFittingFacts,
}

impl PrusaArcFittingSummary {
    fn from_validated_rows(rows: Vec<PrusaArcFittingSummaryRow>) -> Self {
        let facts = PrusaArcFittingFacts::from_validated_rows(&rows);
        Self { rows, facts }
    }

    pub fn rows(&self) -> &[PrusaArcFittingSummaryRow] {
        &self.rows
    }

    pub fn facts(&self) -> PrusaArcFittingFacts {
        self.facts
    }
}
```

### Pattern 3: Static Readiness and Registry Metadata

**What:** Add `prusa_arc_fitting_metadata()` and `prusa_arc_fitting_readiness()` as `const fn` helpers, and add one `registry.rs` capability row with `origin = FeatureOrigin::SharedDownstream`, `parity_dependencies = &[ParitySurface::generated_outputs()]`, and `checklist_status = ChecklistStatus::FutureCandidate`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]

**When to use:** Use metadata for developer traceability only; do not mutate `packages/parity/status.tsv` or add `//packages/parity:prusaslicer_arc_fitting_parity` in Phase 59. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md; bazel query //packages/parity:prusaslicer_arc_fitting_parity]

**Example:**

```rust
// Source pattern: prusa_gcode_output_semantic_readiness. [VERIFIED]
pub const fn prusa_arc_fitting_readiness() -> PrusaArcFittingReadiness {
    PrusaArcFittingReadiness {
        inventory_id: PRUSA_ARC_FITTING_INVENTORY_ID,
        source_ref: PRUSA_ARC_FITTING_SOURCE_REF,
        fixture_corpus_path: PRUSA_ARC_FITTING_FIXTURE_CORPUS_PATH,
        expected_arc_summary_path: PRUSA_ARC_FITTING_EXPECTED_SUMMARY_PATH,
        parser_boundary: "slic3r_flavors::prusa_arc_fitting::parse_prusa_arc_fitting_summary",
        planned_public_command: "//packages/parity:prusaslicer_arc_fitting_parity",
        planned_status_token: "fork.prusaslicer.arc-fitting",
        generated_outputs_status: "in progress",
        publication_boundary: "Phase 59 parser/readiness only; Phase 60 owns public executable evidence and status/docs publication.",
        deferred_surfaces: &PRUSA_ARC_FITTING_DEFERRED_SURFACES,
    }
}
```

### Anti-Patterns to Avoid

- **Adding a Phase 59 binary or public parity target:** Phase 60 owns `bazel run //packages/parity:prusaslicer_arc_fitting_parity`. [VERIFIED: 59-CONTEXT.md]
- **Adding `fork.prusaslicer.arc-fitting` to `packages/parity/status.tsv`:** Phase 59 must keep the row absent. [VERIFIED: 59-CONTEXT.md; awk status scan]
- **Extending `prusaslicer.gcode-output` as if arc fitting is already covered:** Existing status text explicitly defers arc fitting. [VERIFIED: packages/parity/status.tsv]
- **Leaving row values as raw strings throughout the domain model:** Bright Builds and existing code prefer parsing boundary data into enums/newtypes. [CITED: standards/core/architecture.md@05f8d7a6; VERIFIED: prusa_gcode_output.rs]
- **Using default `cargo` without a toolchain override:** Default Cargo `1.91.1` fails the repo `rust-version` requirement, while `cargo +1.94.1` works. [VERIFIED: cargo command outputs]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| ArcWelder equivalence | A Rust implementation of ArcWelder geometry/tolerance logic | Checked-in `expected-arc-summary.tsv` facts only | v1.15 excludes algorithm equivalence, tolerance/geometry parity, printability, and runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| Runtime fixture discovery | Filesystem walkers, env vars, Git commands, or source imports | Caller-supplied `&str` parser input plus test `include_str!` | Phase 59 forbids filesystem discovery, Git, network, process, generator, release, sync, and runtime side effects. [VERIFIED: 59-CONTEXT.md] |
| Public evidence publication | New public binary, parity target, status row, or docs publication | Static crate metadata/readiness strings | Phase 60 owns public evidence/status/docs. [VERIFIED: 59-CONTEXT.md; packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| Generic TSV framework | New dependency or generic runtime schema engine | Small closed parser modeled after `prusa_gcode_output` | The schema has exactly six columns and 12 ordered rows, and `slic3r_flavors` currently has no TSV parser dependency. [VERIFIED: expected-arc-summary.tsv; slic3r_flavors/Cargo.toml; prusa_gcode_output.rs] |
| Status boundary checking | Mutating or interpreting all public docs in Rust | Focused tests over helper names/metadata plus existing Bash fixture/status guards | The crate should stay pure and metadata-only; existing fixture verifiers already protect status absence before Phase 60. [VERIFIED: verify_prusa_arc_fitting_fixture.sh; 58-VERIFICATION.md] |

**Key insight:** Phase 59 is an evidence-boundary phase, not an implementation of arc fitting; custom runtime logic increases claim risk without satisfying ARCRUST requirements. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md; .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Publishing Phase 60 Surfaces Early

**What goes wrong:** A plan adds `//packages/parity:prusaslicer_arc_fitting_parity`, a `fork.prusaslicer.arc-fitting` status row, or public `docs/port/*` wording in Phase 59. [VERIFIED: 59-CONTEXT.md]

**Why it happens:** The planned command and planned status token are required metadata, but they are traceability strings only in Phase 59. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; 59-CONTEXT.md]

**How to avoid:** Keep planned command/status fields inside `PrusaArcFittingReadiness`; assert the public target remains absent or leave that guard to existing Phase 58 verification if no Phase 59 code touches `packages/parity`. [VERIFIED: bazel query //packages/parity:prusaslicer_arc_fitting_parity; 58-VERIFICATION.md]

**Warning signs:** New files under `packages/parity`, edits to `packages/parity/status.tsv`, or public `docs/port` edits appear in Phase 59 diff. [VERIFIED: 59-CONTEXT.md]

### Pitfall 2: Overclaiming in Names or Metadata

**What goes wrong:** Public helper names or metadata mention verified parity, support, runtime, release, executable behavior, printability, GUI, seam, byte parity, or non-Prusa behavior. [VERIFIED: ARCRUST-03 in .planning/REQUIREMENTS.md; tests/flavor_registry.rs]

**Why it happens:** Arc-fitting evidence is a generated-output feature slice, but Phase 59 only validates checked-in summary facts. [VERIFIED: .planning/ROADMAP.md; packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

**How to avoid:** Use `PrusaArcFittingSummary`, `PrusaArcFittingFacts`, `PrusaArcFittingReadiness`, `parse_prusa_arc_fitting_summary`, and `prusa_arc_fitting_summary_lines`; avoid `parity`, `verified`, `runtime`, `supported`, and `executable` in public helper names. [VERIFIED: 59-CONTEXT.md; tests/flavor_registry.rs]

**Warning signs:** A no-overclaim test needs allowlist exceptions for the new arc-fitting API. [VERIFIED: tests/prusa_gcode_output.rs; tests/flavor_registry.rs]

### Pitfall 3: Parser Accepts Drift Because It Only Checks Presence

**What goes wrong:** A parser accepts duplicate rows, swapped rows, wrong values, unsupported fields, or unsupported boundary claims because it validates only headers and column count. [VERIFIED: 59-CONTEXT.md; verify_prusa_arc_fitting_fixture.sh]

**Why it happens:** The Phase 58 Bash verifier is exact, but a new Rust parser could accidentally be looser if it is built as a generic TSV loader. [VERIFIED: verify_prusa_arc_fitting_fixture.sh; prusa_gcode_output.rs]

**How to avoid:** Use `EXPECTED_ARC_ROWS`, `PrusaArcFittingRowKey`, duplicate/extra/order/missing checks, field-specific value parsing, and exact evidence-boundary strings. [VERIFIED: prusa_gcode_output.rs; expected-arc-summary.tsv]

**Warning signs:** Tests do not cover invalid header, wrong column count, missing row, duplicate row, out-of-order row, unsupported field, wrong source, wrong fixture, wrong value, and unsupported claim text. [VERIFIED: 59-CONTEXT.md; tests/prusa_gcode_output.rs]

### Pitfall 4: Cargo Uses the Wrong Rust Toolchain

**What goes wrong:** `cargo test -p slic3r_flavors --manifest-path packages/slic3r-rust/Cargo.toml` fails before compile because default `rustc` is `1.91.1` and the workspace requires `1.94`. [VERIFIED: cargo command output; packages/slic3r-rust/Cargo.toml]

**Why it happens:** Bazel uses `MODULE.bazel` to register Rust `1.94.1`, but shell `cargo` inherits the default rustup toolchain unless the command pins `+1.94.1`. [VERIFIED: MODULE.bazel; rustup toolchain list]

**How to avoid:** Use `cargo +1.94.1 test -p slic3r_flavors --manifest-path packages/slic3r-rust/Cargo.toml` for Cargo coverage, or update the default toolchain before execution. [VERIFIED: cargo +1.94.1 test --no-run]

**Warning signs:** Error text says `slic3r_contracts@0.1.0 requires rustc 1.94`. [VERIFIED: cargo test failure]

## Code Examples

Verified patterns from repo sources:

### Exact Field Enum and Row Key

```rust
// Source pattern: prusa_gcode_output structural/semantic fields and row keys. [VERIFIED]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaArcFittingField {
    SourceRef,
    InventorySourcePaths,
    SourceAnchor,
    FixtureId,
    FixturePath,
    ArcCommandCounts,
    ArcDirectionCounts,
    CenterOffsetObservations,
    CoordinateBounds,
    ExtrusionObservations,
    FeedrateObservations,
    EvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaArcFittingRowKey {
    arc_field: PrusaArcFittingField,
}
```

### Focused Test Shape

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs [VERIFIED]
#[test]
fn rejects_arc_summary_out_of_order_rows() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_ARC_SUMMARY.lines().collect();
    lines.swap(1, 2);
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_arc_fitting_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaArcFittingParseError::UnexpectedRowOrder {
            line_number: 2,
            expected_arc_field: PrusaArcFittingField::SourceRef,
            actual_arc_field: PrusaArcFittingField::InventorySourcePaths,
        })
    ));
}
```

### Bazel Test Wiring

```python
# Source pattern: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel [VERIFIED]
rust_test(
    name = "prusa_arc_fitting_test",
    srcs = ["tests/prusa_arc_fitting.rs"],
    compile_data = [
        "src/prusa_arc_fitting.rs",
        "//packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary",
    ],
    deps = [
        ":slic3r_flavors",
        "//packages/slic3r-rust/crates/slic3r_contracts:slic3r_contracts",
    ],
    edition = "2024",
)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source-observed fork rows without executable evidence | Four-step evidence ladder: scope, fixture, Rust boundary, executable evidence | v1.12 through v1.15 | Phase 59 should add only the Rust boundary rung before Phase 60 publication. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md] |
| Marker-only Prusa G-code summary | Structural and semantic typed parsers with readiness metadata | Phases 51 and 55 | Arc-fitting should reuse the closed TSV parser/readiness pattern rather than invent a new parsing style. [VERIFIED: .planning/STATE.md; prusa_gcode_output.rs] |
| Broad generated-output claims deferred without feature-specific slice | Narrow `prusaslicer.arc-fitting` checked-in summary slice | Phase 57 and Phase 58 | Phase 59 can type the arc summary facts but still must not graduate `generated-outputs`. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; 58-VERIFICATION.md] |
| Public parity publication during parser phase | Public publication only after executable phase | Phase 55 to Phase 56 precedent | Phase 59 should mirror Phase 55 restraint and leave Phase 60 to publish command/status/docs. [VERIFIED: .planning/STATE.md; 59-CONTEXT.md] |

**Deprecated/outdated:**

- Treating `prusaslicer.gcode-output` as a catch-all generated-output row is not allowed because its current public status text explicitly excludes arc fitting. [VERIFIED: packages/parity/status.tsv]
- Using loose stringly-typed row maps is not the current crate pattern for reviewed evidence summaries. [VERIFIED: prusa_project_file.rs; prusa_gcode_output.rs; standards/languages/rust.md@05f8d7a6]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The research should be considered fresh for 7 days because local toolchain state and Phase 60 boundaries may change quickly during the active milestone. [ASSUMED] | Metadata | Planner may rely on stale environment or publication-boundary facts if Phase 60 or toolchain defaults change before execution. |

## Open Questions (RESOLVED)

1. **Should Phase 59 add `prusa_arc_fitting_summary_lines`?**
   - What we know: The context leaves this to the agent's discretion, and existing parser modules expose pure summary-line helpers. [VERIFIED: 59-CONTEXT.md; prusa_gcode_output.rs; prusa_project_file.rs]
   - What's unclear: Phase 60 could consume facts directly or use summary lines for public command output. [VERIFIED: 59-CONTEXT.md]
   - Recommendation: Add the pure crate-local helper now because it has no side effects and gives Phase 60 a stable developer-facing output surface without adding a binary. [VERIFIED: prusa_gcode_output.rs; 59-CONTEXT.md]
   - Resolution: RESOLVED by `59-01-PLAN.md`, which adds the pure crate-local `prusa_arc_fitting_summary_lines` helper without adding a binary, public parity target, status row, or public docs.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Bazel tests and `//packages/slic3r-rust:verify` | yes | 8.6.0 | none needed. [VERIFIED: bazel --version] |
| rules_rust | Bazel Rust toolchain and Rust tests | yes | 0.69.0 | none needed. [VERIFIED: MODULE.bazel] |
| Rust toolchain via Bazel | Bazel Rust tests | yes | 1.94.1 | none needed. [VERIFIED: MODULE.bazel; bazel test prusa_gcode_output_test] |
| Cargo default toolchain | Cargo coverage if run without override | wrong version | cargo/rustc 1.91.1 | Use `cargo +1.94.1 ...`. [VERIFIED: cargo --version; rustc --version; cargo test failure] |
| Cargo `+1.94.1` toolchain | Required Cargo coverage | yes | cargo 1.94.1, rustc 1.94.1 | none needed. [VERIFIED: cargo +1.94.1 --version; rustc +1.94.1 --version; cargo +1.94.1 test --no-run] |
| Phase 58 fixture alias | Rust test compile data | yes | checked-in target | none needed. [VERIFIED: bazel query //packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary] |

**Missing dependencies with no fallback:**

- None if Cargo commands pin `+1.94.1`. [VERIFIED: rustup toolchain list; cargo +1.94.1 test --no-run]

**Missing dependencies with fallback:**

- Default Cargo/Rust toolchain is too old for this workspace; use `cargo +1.94.1` or make `1.94.1` the active toolchain before running Cargo coverage. [VERIFIED: cargo command outputs; packages/slic3r-rust/Cargo.toml]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | No authentication surface is introduced by a pure parser module. [VERIFIED: 59-CONTEXT.md] |
| V3 Session Management | no | No session or cookie surface is introduced by a pure parser module. [VERIFIED: 59-CONTEXT.md] |
| V4 Access Control | no | No permissioned runtime resource is accessed because the parser receives caller-supplied `&str`. [VERIFIED: 59-CONTEXT.md] |
| V5 Input Validation | yes | Exact header, column, enum, row order, duplicate, missing, source, fixture, value, and boundary validation. [VERIFIED: 59-CONTEXT.md; prusa_gcode_output.rs] |
| V6 Cryptography | no | No cryptography is added; existing fixture SHA values remain Phase 58 Bash provenance checks. [VERIFIED: fixture-provenance.tsv; verify_prusa_arc_fitting_fixture.sh] |

### Known Threat Patterns for the Phase 59 Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Spoofed source ref or fixture path | Spoofing | Parse only the accepted source ref and exact fixture path; reject mismatches with typed errors. [VERIFIED: prusa_gcode_output.rs; expected-arc-summary.tsv] |
| Unsupported row or value drift | Tampering | Enforce closed enum fields, exact values, exact order, duplicate rejection, and missing-row rejection. [VERIFIED: prusa_gcode_output.rs; verify_prusa_arc_fitting_fixture.sh] |
| Overclaiming evidence text | Repudiation | Exact evidence-boundary strings plus tests scanning public helper names/metadata for forbidden claim words. [VERIFIED: 59-CONTEXT.md; tests/flavor_registry.rs; tests/prusa_gcode_output.rs] |
| Accidental side effects during parsing | Elevation of privilege / Tampering | Keep parser data-in/data-out and do not import filesystem, process, network, env, clock, Git, or generator APIs. [VERIFIED: 59-CONTEXT.md; prusa_gcode_output.rs] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md` - locked Phase 59 implementation decisions, discretion, and deferrals. [VERIFIED: cat]
- `.planning/ROADMAP.md` - Phase 59 goal, success criteria, dependency, and Phase 60 boundary. [VERIFIED: cat]
- `.planning/REQUIREMENTS.md` - ARCRUST-01, ARCRUST-02, ARCRUST-03, and v1.15 out-of-scope list. [VERIFIED: cat]
- `.planning/STATE.md` and `.planning/PROJECT.md` - accumulated generated-output evidence ladder decisions. [VERIFIED: cat]
- `.planning/phases/58-arc-fitting-fixture-corpus/58-VERIFICATION.md` - Phase 58 passed evidence and artifact readiness. [VERIFIED: cat]
- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - approved arc field contract, traceability, planned command/status, and deferrals. [VERIFIED: cat]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` - exact Phase 58 parser input. [VERIFIED: cat]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv` - source identity, fixture identity, checksum, update route, exclusions, and deferrals. [VERIFIED: cat]
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - exact fixture validation constants and failure modes. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - closest parser/readiness/facts precedent. [VERIFIED: cat and sed chunks]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` - closest parser test precedent. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` and `tests/flavor_registry.rs` - static registry metadata and no-overclaim tests. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`, `packages/slic3r-rust/BUILD.bazel`, and `packages/parity-fixtures/BUILD.bazel` - Bazel wiring patterns and fixture aliases. [VERIFIED: cat]
- `MODULE.bazel`, `.bazelrc`, and `packages/slic3r-rust/Cargo.toml` - Rust/Bazel toolchain and workspace requirements. [VERIFIED: cat]

### Secondary (MEDIUM confidence)

- Pinned Bright Builds standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`, `core/architecture.md`, `core/code-shape.md`, `core/testing.md`, `core/verification.md`, `core/operability.md`, and `languages/rust.md`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

### Tertiary (LOW confidence)

- None. [VERIFIED: research used repo artifacts, command output, and pinned standards only]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - versions and targets were verified from manifests and local command output. [VERIFIED: MODULE.bazel; Cargo.toml; cargo/rustc/bazel command outputs]
- Architecture: HIGH - implementation shape is locked by Phase 59 context and matches existing parser/readiness code. [VERIFIED: 59-CONTEXT.md; prusa_gcode_output.rs; prusa_project_file.rs]
- Pitfalls: HIGH - pitfalls map directly to locked out-of-scope decisions, existing tests, and Phase 58 verification. [VERIFIED: 59-CONTEXT.md; .planning/REQUIREMENTS.md; 58-VERIFICATION.md; tests/flavor_registry.rs]

**Research date:** 2026-06-24
**Valid until:** 2026-07-01, because local toolchain state and Phase 60 boundaries may change quickly during the active milestone. [ASSUMED]
