# Phase 64: Rust Wall-Seam Evidence Boundary - Research

**Researched:** 2026-06-30
**Domain:** Pure Rust TSV evidence parsing, static flavor registry readiness metadata, Cargo/Bazel verification
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for all copied constraints in this block: [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Rust boundary placement

- **D-01:** Add the wall-seam parser as a new
  `slic3r_flavors::prusa_wall_seam` module under
  `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_wall_seam.rs`
  instead of extending `prusa_gcode_output.rs` or `prusa_arc_fitting.rs`.
  Wall seam has its own fixture namespace, source anchors, expected summary,
  readiness metadata, and future status token, so the module should stay
  inspectably separate.
- **D-02:** Export the public parser and summary-line helper from
  `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` through a
  `pub mod prusa_wall_seam;` entry. Helper names may include wall-seam and
  summary wording, but must not include public names that imply byte parity,
  seam geometry equivalence, printability, runtime, support, GUI,
  arc-fitting, or non-Prusa fork behavior.
- **D-03:** Keep the boundary pure data-in/data-out. The parser receives a
  caller-supplied string or lines from a checked-in
  `expected-wall-seam-summary.tsv` artifact. The module must not perform
  filesystem discovery, Git inspection, network access, process execution,
  generation, printer-runtime work, release work, or sync behavior.

### Parser contract and typed values

- **D-04:** Parse the Phase 63 long-row TSV shape exactly:
  `source_ref`, `fixture_path`, `wall_seam_field`,
  `wall_seam_category`, `wall_seam_value`, and `evidence_boundary`.
- **D-05:** Preserve the Phase 62/63 approved field order and closed field
  set: `source_ref`, `inventory_source_paths`, `source_anchor`,
  `fixture_id`, `fixture_path`, `seam_transition_observations`,
  `layer_context_observations`, `travel_context_observations`,
  `coordinate_bounds`, `extrusion_observations`,
  `retraction_observations`, and `evidence_boundary`.
- **D-06:** Model wall-seam rows with domain enums and typed summary/facts
  structs comparable to `PrusaArcFittingSummary`,
  `PrusaArcFittingSummaryRow`, and `PrusaArcFittingFacts`. Invalid headers,
  wrong column counts, missing rows, duplicate fields, unsupported fields,
  out-of-order rows, wrong source refs, wrong fixture paths, wrong values,
  and unsupported evidence boundaries should fail closed with precise errors.
- **D-07:** Treat `VendorSourceRef::prusa_slicer_version_2_9_5()` as the
  accepted source identity and parse it through existing contract types
  instead of carrying unchecked source strings deep into the module.
- **D-08:** Keep optional or nullable internals rare. When an internal Rust
  value is actually optional, use `maybe_` names in line with Bright Builds
  Rust guidance.

### Readiness and registry metadata

- **D-09:** Add static wall-seam readiness metadata that traces the parser to
  the accepted source identity, source path
  `src/libslic3r/GCode/SeamAligned.cpp`, source anchors, fixture corpus path,
  fixture path, expected summary path, scope record path, parser boundary,
  planned Phase 65 command, planned `fork.prusaslicer.wall-seam` status token,
  `generated-outputs` status restraint, publication boundary, and deferred
  generated-output surfaces.
- **D-10:** Add `prusaslicer.wall-seam` to the Prusa registry capability list
  as a source-observed future candidate with generated-output dependency and
  no public status publication in Phase 64. The registry note must keep wall
  seam separate from the existing semantic `fork.prusaslicer.gcode-output`
  row and the `fork.prusaslicer.arc-fitting` row.
- **D-11:** Use `ChecklistStatus::FutureCandidate`,
  `FeatureOrigin::SharedDownstream`, `FlavorId::PrusaSlicer`, and
  `ParitySurface::generated_outputs()` consistently with the existing
  generated-output feature slices.

### Verification and guards

- **D-12:** Add focused Cargo integration tests in
  `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_wall_seam.rs`
  that prove the checked-in Phase 63 summary parses, expected facts are
  exposed, invalid rows fail closed, and public helper names avoid forbidden
  claim text.
- **D-13:** Wire the new module, tests, and any new summary binary only where
  Phase 64 needs developer-facing evidence. Update
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` and
  `packages/slic3r-rust/BUILD.bazel` so `//packages/slic3r-rust:verify`
  includes the wall-seam parser/readiness coverage.
- **D-14:** Add registry tests in `tests/flavor_registry.rs` for the
  `prusaslicer.wall-seam` capability, readiness metadata, generated-output
  dependency, planned command/status token, and no-overclaiming note text.
- **D-15:** Phase 64 verification should run both Cargo and Bazel coverage for
  the changed Rust crate. The minimum expected checks are a focused Cargo test
  for `prusa_wall_seam`, a focused Bazel rust_test for the same file, the
  flavor registry test when registry metadata changes, and the package-level
  `//packages/slic3r-rust:verify` aggregate when feasible.

### Handoff to Phase 65

- **D-16:** Phase 64 may expose developer-facing parser and readiness APIs,
  but Phase 65 owns `bazel run
  //packages/parity:prusaslicer_wall_seam_parity`, public wall-seam mutation
  guards, `packages/parity/status.tsv`, and public port/package docs.
- **D-17:** Keep the public status token planned, not published. Phase 64
  tests should enforce that names and notes do not claim executable public
  evidence before Phase 65.
- **D-18:** Preserve broad `generated-outputs` as `in progress` and preserve
  existing `fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting`
  wording/meaning.

### the agent's Discretion

- Choose exact enum/type names, provided they are specific to wall-seam
  summaries and do not widen public claims.
- Choose whether to add a developer-facing wall-seam summary binary in Phase
  64 only if it remains local-file/caller-supplied and does not create the
  public Phase 65 parity command. If not needed for the Phase 64 acceptance
  criteria, keep the surface to library APIs and tests.
- Choose exact parser error type names and Display wording, provided invalid
  field, header, order, source, fixture, value, and boundary failures are
  diagnostically precise.

### Deferred Ideas (OUT OF SCOPE)

- Phase 65 owns the public wall-seam parity command, public mutation guards,
  exact status row, and public docs.
- Broader wall-seam fixture corpus growth, byte-for-byte G-code parity, seam
  geometry equivalence, seam visibility, printability, runtime behavior, GUI
  behavior, support generation, STEP import, release behavior, sync behavior,
  non-Prusa forks, and upstream import behavior remain out of scope.
- JSON-valued summary rows, live generation, and filesystem-discovery parser
  modes remain deferred; Phase 64 parses caller-supplied checked-in summaries
  only.
</user_constraints>

## Project Constraints (from AGENTS.md)

- Repo work must read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant local `standards/` pages before planning or implementation. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards/index.md]
- The Bright Builds managed block in `AGENTS.md` and the managed `AGENTS.bright-builds.md` file must not be edited downstream. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Phase `*-SUMMARY.md` files must keep the YAML frontmatter field `requirements-completed` in sync, must use the exact hyphenated key, and must not be processed with `mdformat`. [VERIFIED: AGENTS.md]
- Non-trivial work needs a short checkable plan with verification tasks, and completion requires relevant verification evidence. [VERIFIED: AGENTS.md]
- Rust work should prefer `foo.rs` plus `foo/` over `foo/mod.rs`, use `let...else` for guard extraction where clearer, prefix optional internal names with `maybe_`, encode invariants with enums/newtypes, and keep adapters thin around a pure core. [VERIFIED: AGENTS.md; standards/languages/rust.md; standards/core/code-shape.md; standards/core/architecture.md]
- Pure business/domain logic must have focused unit tests, and tests should be structured as Arrange, Act, Assert unless trivially clear. [VERIFIED: AGENTS.md; standards/core/testing.md]
- Before commit, run repo-relevant verification for changed paths; repo-owned Bazel verify targets are preferred when available. [VERIFIED: AGENTS.bright-builds.md; standards/core/verification.md]
- No project-local `.claude/skills` or `.agents/skills` directories were found during this research. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -type f -name SKILL.md`]
- The user instructed not to read agent definition files and not to mutate files outside the research output. [VERIFIED: user prompt]

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| SEAMRUST-01 | Developer can use a pure typed Rust wall-seam summary boundary that parses caller-supplied checked-in wall-seam summary artifacts into domain values without Git, network, filesystem discovery, process, generator, printer-runtime, release, or sync side effects. | Add `slic3r_flavors::prusa_wall_seam` with `&str` parser input, closed enums for the 12 wall-seam fields, typed row/facts values, and no filesystem/process/network APIs. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| SEAMRUST-02 | Developer can inspect static readiness or registry metadata that traces the wall-seam boundary to the accepted Prusa source identity, fixture corpus, expected wall-seam summaries, planned command, planned status wording, and deferred generated-output surfaces. | Add `PrusaWallSeamMetadata`, `PrusaWallSeamReadiness`, and one `registry.rs` row for `prusaslicer.wall-seam` using `VendorSourceRef::prusa_slicer_version_2_9_5()`, `FeatureOrigin::SharedDownstream`, `ChecklistStatus::FutureCandidate`, and `ParitySurface::generated_outputs()`. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| SEAMRUST-03 | Developer can run Cargo and Bazel coverage that proves valid wall-seam fixture rows parse, invalid rows fail closed, optional or nullable Rust internals are named clearly, and no public helper names claim byte parity, seam geometry equivalence, printability, runtime, support, GUI, arc-fitting, or non-Prusa fork behavior. | Add `tests/prusa_wall_seam.rs`, include the Phase 63 `expected-wall-seam-summary.tsv` through Bazel `compile_data`, extend crate and aggregate Bazel verify wiring, run Cargo with toolchain `+1.94.1`, and extend registry/no-overclaim tests. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel; `cargo +1.94.1 test --no-run`] |
</phase_requirements>

## Summary

Phase 64 should be planned as the wall-seam equivalent of Phase 59 arc-fitting: add a pure `slic3r_flavors` parser/readiness module, expose crate APIs and registry metadata, and prove the checked-in TSV parses and fails closed without publishing public status, public parity commands, public port docs, runtime generation, or side effects. [VERIFIED: .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-RESEARCH.md; .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

The strongest implementation precedent is `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs`, which already implements a separate generated-output feature parser with closed constants, typed rows/facts, metadata/readiness values, a pure summary-lines helper, and fail-closed tests wired through Cargo and Bazel. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**Primary recommendation:** Mirror the arc-fitting module and tests closely, replacing arc-specific constants with the Phase 63 wall-seam TSV values, adding the static registry/readiness row for `prusaslicer.wall-seam`, and leaving the Phase 65 public command/status/docs untouched. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv; packages/prusa-wall-seam-scope/wall-seam-scope.md]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Rust toolchain | 1.94.1 | Compile and test the Rust workspace. | `MODULE.bazel` registers Rust `1.94.1`, and `packages/slic3r-rust/Cargo.toml` declares workspace `rust-version = "1.94"`. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml; `rustc +1.94.1 --version`] |
| Cargo | 1.94.1 for pinned test runs | Run focused crate tests for `slic3r_flavors`. | The local default Cargo is `1.91.1`, while `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_arc_fitting --no-run` succeeds against the workspace requirement. [VERIFIED: `cargo --version`; `cargo +1.94.1 --version`; `cargo +1.94.1 test --no-run`; packages/slic3r-rust/Cargo.toml] |
| Bazel | 8.6.0 | Repo-owned build/test orchestration and aggregate verification. | Rust crate tests, rustfmt, clippy, and package verification are already wired through Bazel targets. [VERIFIED: `.bazelversion`; `bazel --version`; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel] |
| rules_rust | 0.69.0 | Bazel Rust rules and registered Rust toolchain. | `MODULE.bazel` declares `bazel_dep(name = "rules_rust", version = "0.69.0")` and registers the Rust `1.94.1` toolchain. [VERIFIED: MODULE.bazel] |
| `slic3r_flavors` crate | 0.1.0 | Add the wall-seam parser, facts, summary helper, metadata, and readiness APIs. | The crate already owns the pure flavor registry and feature-specific Prusa evidence parsers. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| `slic3r_contracts` crate | local path crate | Reuse typed source/status/origin/surface contract values. | `VendorSourceRef`, `FeatureOrigin`, `FlavorId`, `ParitySurface`, and `ChecklistStatus` are already used by parser metadata and registry rows. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |

### Supporting

| Artifact / Target | Version | Purpose | When to Use |
|-------------------|---------|---------|-------------|
| `//packages/parity-fixtures:prusa_wall_seam_expected_wall_seam_summary` | checked-in Bazel alias | Compile data for `prusa_wall_seam_test`. | Use in `rust_test(compile_data = [...])` so Bazel tests include the reviewed Phase 63 TSV artifact. [VERIFIED: packages/parity-fixtures/BUILD.bazel; `bazel query //packages/parity-fixtures:prusa_wall_seam_expected_wall_seam_summary`] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv` | Phase 63 artifact | Exact parser fixture and facts source. | Use through `include_str!` in Cargo/Bazel tests and as the source for `EXPECTED_WALL_SEAM_ROWS` constants. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs] |
| `packages/prusa-wall-seam-scope/wall-seam-scope.md` | Phase 62 artifact | Approved source identity, field contract, planned command/status, and deferrals. | Use to cross-check the parser field set, readiness strings, and no-overclaiming boundary. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md] |
| `packages/parity/status.tsv` | checked-in public status source | Guard against premature `fork.prusaslicer.wall-seam` publication. | Use only in validation or tests if Phase 64 touches status-adjacent code; current row count is zero. [VERIFIED: packages/parity/status.tsv; `awk -F '\t' '$1 == "fork.prusaslicer.wall-seam" { count++ } END { print count + 0 }' packages/parity/status.tsv`] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| New `prusa_wall_seam` module | Extend `prusa_gcode_output.rs` or `prusa_arc_fitting.rs` | Rejected by locked D-01 because wall seam has a separate fixture namespace, source anchors, summary artifact, readiness metadata, and future status token. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md] |
| Library API plus tests | New developer-facing wall-seam summary binary | Keep to library APIs and tests unless the plan finds a concrete Phase 64 acceptance need, because Phase 65 owns the public command and Phase 64 can satisfy requirements with `parse_prusa_wall_seam_summary` plus `prusa_wall_seam_summary_lines`. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| Closed parser constants | Generic TSV parser crate | Avoid a new dependency because the schema is exactly six columns and 12 ordered rows, and existing parser modules use `std` string splitting plus domain enums. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| Checked-in summary parsing | Live wall-seam generation or seam geometry comparison | Rejected because v1.16 proves checked-in wall-seam summary facts only, not byte parity, seam geometry equivalence, seam visibility, printability, GUI, or printer-runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md] |

**Installation:**

```bash
# No new crates or npm packages are needed for Phase 64. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]
rustup toolchain install 1.94.1
```

**Version verification:** No `npm view` applies because Phase 64 adds no npm packages; verify local tool versions with `rustc +1.94.1 --version`, `cargo +1.94.1 --version`, `bazel --version`, `MODULE.bazel`, and Cargo manifests. [VERIFIED: command outputs; MODULE.bazel; packages/slic3r-rust/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
|-- src/
|   |-- lib.rs                  # Re-export wall-seam parser/facts/readiness APIs. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs]
|   |-- prusa_wall_seam.rs      # New pure parser, facts, metadata, readiness. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]
|   |-- prusa_arc_fitting.rs    # Closest implementation precedent. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]
|   `-- registry.rs             # Add prusaslicer.wall-seam capability row. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]
|-- tests/
|   |-- prusa_wall_seam.rs      # New valid/invalid/no-overclaim parser coverage. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]
|   |-- prusa_arc_fitting.rs    # Parser test precedent. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs]
|   `-- flavor_registry.rs      # Extend registry/readiness expectations. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]
`-- BUILD.bazel                 # Add source/test/compile_data/clippy/rustfmt wiring. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]
```

### Pattern 1: Closed Wall-Seam TSV Boundary

**What:** Parse the six-column TSV through exact header validation, exact column count, non-empty required values, closed field/category/value parsing, exact source ref, exact fixture path, exact row order, duplicate rejection, extra-row rejection, missing-row rejection, and exact evidence-boundary validation. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]

**When to use:** Use only for caller-supplied checked-in wall-seam summary text; do not parse arbitrary G-code, discover fixture files, or generate fresh wall-seam output. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; .planning/REQUIREMENTS.md]

**Wall-seam field order:** `source_ref`, `inventory_source_paths`, `source_anchor`, `fixture_id`, `fixture_path`, `seam_transition_observations`, `layer_context_observations`, `travel_context_observations`, `coordinate_bounds`, `extrusion_observations`, `retraction_observations`, `evidence_boundary`. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/prusa-wall-seam-scope/wall-seam-scope.md]

### Pattern 2: Facts From Validated Rows

**What:** Build `PrusaWallSeamFacts` only after every row has passed exact validation, then expose `rows()` and `facts()` from `PrusaWallSeamSummary`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; standards/core/architecture.md; standards/languages/rust.md]

**Expected facts:** Source ref, inventory/source paths, source anchors, fixture identity/path, seam transition observations, layer context observations, travel context observations, coordinate bounds, extrusion observations, retraction observations, and evidence-boundary token. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

**Recommended values:** Use exact constants from the Phase 63 TSV, including `checked-in-wall-seam-summary-only`, `wall-seam-observations.gcode`, and `src/libslic3r/GCode/SeamAligned.cpp`. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv]

### Pattern 3: Source Identity Through Contract Types

**What:** Parse and return `VendorSourceRef::prusa_slicer_version_2_9_5()` rather than storing the source identity as a loose `String` in summary rows or facts. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs]

**When to use:** Use for every TSV `source_ref` cell, readiness source field, and registry provenance row. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]

### Pattern 4: Static Readiness and Registry Metadata

**What:** Add `prusa_wall_seam_metadata()` and `prusa_wall_seam_readiness()` as `const fn` helpers, then add one `FlavorCapability` row with `origin = FeatureOrigin::SharedDownstream`, `parity_dependencies = &[ParitySurface::generated_outputs()]`, and `checklist_status = ChecklistStatus::FutureCandidate`. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]

**Required readiness strings:** Parser boundary `slic3r_flavors::prusa_wall_seam::parse_prusa_wall_seam_summary`, planned command `//packages/parity:prusaslicer_wall_seam_parity`, planned status token `fork.prusaslicer.wall-seam`, generated-output status `in progress`, and a publication boundary stating Phase 64 is parser/readiness only while Phase 65 owns public evidence/status/docs. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/prusa-wall-seam-scope/wall-seam-scope.md]

**Registry test impact:** `shared_downstream_filter_returns_source_observed_prusa_rows` currently expects `prusaslicer.project-file`, `prusaslicer.gcode-output`, and `prusaslicer.arc-fitting`; Phase 64 must update the expected list to include `prusaslicer.wall-seam`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

### Pattern 5: Focused Cargo and Bazel Tests

**What:** Add `tests/prusa_wall_seam.rs` modeled after `tests/prusa_arc_fitting.rs`, with one test for valid facts, one test for summary lines if the helper is added, one test scanning public declarations for forbidden claim words, and focused invalid-input tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; standards/core/testing.md]

**Minimum invalid cases:** Invalid header, wrong column count, missing row, duplicate row, out-of-order row, unsupported wall-seam field, unsupported category, wrong source ref, wrong fixture path, wrong value, and unsupported evidence-boundary claim text. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs]

### Anti-Patterns to Avoid

- **Public Phase 65 surfaces in Phase 64:** Do not add `//packages/parity:prusaslicer_wall_seam_parity`, `fork.prusaslicer.wall-seam` in `packages/parity/status.tsv`, or public port docs in this phase. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; `bazel query //packages/parity:prusaslicer_wall_seam_parity`; packages/parity/status.tsv]
- **Runtime or discovery APIs inside the parser module:** Do not import `std::fs`, `std::process`, networking APIs, environment inspection, clocks, Git wrappers, generator adapters, or release/sync code. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md]
- **Loose row maps:** Do not accept rows by presence alone or allow arbitrary field names because Phase 62 and Phase 63 define a closed ordered field set. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh]
- **Overclaiming names:** Do not put `parity`, `verified`, `runtime`, `printability`, `support`, `gui`, `arc`, `geometry`, `byte`, `bambu`, `orca`, or `non_prusa` claim wording in public helper names. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Wall-seam algorithm evidence | A Rust implementation of seam geometry, seam visibility, tolerance, or printability logic | Checked-in wall-seam summary facts only | v1.16 excludes byte parity, full algorithm or geometry equivalence, seam visibility, printability, GUI, and printer-runtime behavior. [VERIFIED: .planning/REQUIREMENTS.md; packages/prusa-wall-seam-scope/wall-seam-scope.md] |
| Runtime fixture discovery | Filesystem walkers, Git commands, env var discovery, network calls, process spawning, or source imports | Caller-supplied `&str` input plus test `include_str!` | Phase 64 explicitly forbids filesystem discovery, Git, network, process, generator, release, sync, and runtime side effects. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs] |
| Source identity validation | Raw source-ref strings carried through facts and registry rows | `VendorSourceRef::prusa_slicer_version_2_9_5()` from `slic3r_contracts` | The contract crate already encodes canonical selected source pins and rejects malformed or unknown pins. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs] |
| Generic TSV framework | New crate dependency or runtime schema engine | Small closed parser modeled after `prusa_arc_fitting.rs` | The schema has exactly six columns and 12 rows, and `slic3r_flavors` has no external parser dependency. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| Public evidence publication | New public binary, parity target, public mutation guards, status row, or docs publication | Static crate parser/readiness APIs and registry metadata | Phase 65 owns public evidence/status/docs. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; .planning/ROADMAP.md] |

**Key insight:** Phase 64 is an evidence-boundary phase, not a wall-seam implementation phase; adding runtime seam logic, public command surfaces, or broad generated-output wording increases claim risk without satisfying SEAMRUST requirements. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Publishing Phase 65 Surfaces Early

**What goes wrong:** A plan adds `//packages/parity:prusaslicer_wall_seam_parity`, a `fork.prusaslicer.wall-seam` status row, or public `docs/port/*` wall-seam publication during Phase 64. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

**Why it happens:** Readiness metadata must mention the planned command and status token, but those strings are traceability metadata only in Phase 64. [VERIFIED: packages/prusa-wall-seam-scope/wall-seam-scope.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

**How to avoid:** Keep planned command/status fields inside `PrusaWallSeamReadiness`, assert the status row remains absent if status-adjacent files are touched, and leave public command/docs to Phase 65. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh; `awk` status scan]

**Warning signs:** New files under `packages/parity`, edits to `packages/parity/status.tsv`, or public `docs/port` edits appear in the Phase 64 diff. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

### Pitfall 2: Parser Accepts Drift Because It Is Too Generic

**What goes wrong:** The parser accepts duplicate rows, swapped rows, unsupported fields, wrong source refs, wrong fixture paths, wrong values, or unsupported boundary claims. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh]

**Why it happens:** A generic TSV loader can validate shape while missing the evidence contract. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh]

**How to avoid:** Use `EXPECTED_WALL_SEAM_ROWS`, a row-key type keyed by `PrusaWallSeamField`, exact order checks, duplicate/extra/missing checks, field-specific category/value checks, and exact evidence-boundary text checks. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv]

**Warning signs:** Tests cover valid parsing but omit invalid header, wrong columns, missing/duplicate/out-of-order rows, unsupported fields, wrong source/fixture/value, or overclaim boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

### Pitfall 3: Helper Names Overclaim Evidence

**What goes wrong:** Public Rust names imply byte parity, seam geometry equivalence, printability, runtime support, GUI behavior, arc-fitting behavior, or non-Prusa fork behavior. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

**Why it happens:** Wall seam is a generated-output feature, but Phase 64 validates checked-in summary facts only. [VERIFIED: .planning/ROADMAP.md; packages/prusa-wall-seam-scope/wall-seam-scope.md]

**How to avoid:** Use names like `PrusaWallSeamSummary`, `PrusaWallSeamFacts`, `PrusaWallSeamReadiness`, `parse_prusa_wall_seam_summary`, and `prusa_wall_seam_summary_lines`; scan public declarations for forbidden fragments. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]

**Warning signs:** A no-overclaim test needs exceptions for a new wall-seam API name. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

### Pitfall 4: Registry Tests Fail Because Expected Lists Are Not Updated

**What goes wrong:** Adding a `prusaslicer.wall-seam` capability changes Prusa capability counts and shared-downstream filter expectations. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

**Why it happens:** `PRUSA_CAPABILITIES` is currently a fixed-size static array and tests assert exact shared-downstream capability IDs. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

**How to avoid:** Add `PRUSA_WALL_SEAM_PATHS` and `PRUSA_WALL_SEAM_PROVENANCE`, increase `PRUSA_CAPABILITIES` length, add the capability row near arc fitting, and update exact tests plus future-candidate/no-overclaim helper lists. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

**Warning signs:** Only parser tests pass while `flavor_registry_test` fails on exact expected IDs or metadata values. [VERIFIED: packages/slic3r-rust/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

### Pitfall 5: Cargo Uses the Wrong Toolchain

**What goes wrong:** Cargo coverage fails before testing because default `cargo` and `rustc` are `1.91.1`, while the workspace requires Rust `1.94`. [VERIFIED: `cargo --version`; `rustc --version`; packages/slic3r-rust/Cargo.toml]

**Why it happens:** Bazel uses the pinned `MODULE.bazel` toolchain, but shell Cargo uses the active default toolchain unless the command pins `+1.94.1`. [VERIFIED: MODULE.bazel; `rustup toolchain list`; `cargo +1.94.1 --version`]

**How to avoid:** Run `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_wall_seam --test flavor_registry`, or make `1.94.1` the active toolchain before Cargo verification. [VERIFIED: `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_arc_fitting --no-run`]

**Warning signs:** Error text mentions workspace `rust-version = "1.94"` or a crate requiring newer `rustc` than default. [VERIFIED: packages/slic3r-rust/Cargo.toml; local default toolchain audit]

## Code Examples

Verified patterns from local sources.

### Closed Parser Skeleton

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs [VERIFIED]
pub fn parse_prusa_wall_seam_summary(input: &str) -> PrusaWallSeamParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaWallSeamParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_wall_seam_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_wall_seam_summary_row(line, line_number)?;
        let row_key = WallSeamRowKey::from_row(&row);
        // Duplicate, extra, order, and missing checks should mirror prusa_arc_fitting. [VERIFIED]
        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_wall_seam_rows(&row_keys)?;
    Ok(PrusaWallSeamSummary {
        rows,
        facts: PrusaWallSeamFacts::from_validated_rows(),
    })
}
```

### Wall-Seam Fact Constants

```rust
// Source values: packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv [VERIFIED]
const WALL_SEAM_SOURCE_ANCHOR_VALUE: &str =
    "SeamAligned.cpp#L16;SeamAligned.cpp#L115-L148;SeamAligned.cpp#L272-L313;SeamAligned.cpp#L463-L525";
const WALL_SEAM_TRANSITION_OBSERVATIONS_VALUE: &str =
    "seam_markers:seam_start,seam_resume;transition_count:2";
const WALL_SEAM_EVIDENCE_BOUNDARY_VALUE: &str = "checked-in-wall-seam-summary-only";
```

### Bazel Test Wiring

```python
# Source pattern: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel [VERIFIED]
rust_test(
    name = "prusa_wall_seam_test",
    srcs = ["tests/prusa_wall_seam.rs"],
    compile_data = [
        "src/prusa_wall_seam.rs",
        "//packages/parity-fixtures:prusa_wall_seam_expected_wall_seam_summary",
    ],
    deps = [
        ":slic3r_flavors",
        "//packages/slic3r-rust/crates/slic3r_contracts:slic3r_contracts",
    ],
    edition = "2024",
)
```

### Focused Invalid Row Test

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs [VERIFIED]
#[test]
fn rejects_wall_seam_out_of_order_rows() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_WALL_SEAM_SUMMARY.lines().collect();
    lines.swap(1, 2);
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_wall_seam_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaWallSeamParseError::UnexpectedRowOrder {
            line_number: 2,
            expected_wall_seam_field: PrusaWallSeamField::SourceRef,
            actual_wall_seam_field: PrusaWallSeamField::InventorySourcePaths,
        })
    ));
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source-observed fork rows without executable evidence | Four-step generated-output evidence ladder: scope, fixture, Rust boundary, executable evidence | v1.12 through v1.16 | Phase 64 should add only the Rust wall-seam boundary rung before Phase 65 publication. [VERIFIED: .planning/STATE.md; .planning/ROADMAP.md] |
| Broad generated-output status only | Narrow feature-specific Prusa evidence rows for G-code output and arc fitting, with wall seam planned next | Phases 53-60 and current v1.16 | Wall seam must become its own registry/readiness row without widening existing public status rows. [VERIFIED: packages/parity/status.tsv; .planning/STATE.md; .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md] |
| Arc-fitting parser/readiness as planned precedent | `prusa_arc_fitting.rs` now exists and passed Phase 59 verification | 2026-06-24 | Phase 64 can mirror the completed arc-fitting Rust boundary instead of designing a new parser architecture. [VERIFIED: .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| No wall-seam fixture artifact | Phase 63 checked in wall-seam fixture, provenance, expected summary, and fail-closed fixture verifier | 2026-06-27 | Phase 64 can parse a real checked-in summary artifact without live generation. [VERIFIED: .planning/STATE.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh] |

**Deprecated/outdated:**

- Treating `prusaslicer.gcode-output` as a catch-all generated-output row is not allowed because its public status text still defers wall seam behavior. [VERIFIED: packages/parity/status.tsv]
- Treating `prusaslicer.arc-fitting` as wall-seam evidence is not allowed because arc fitting is a separate checked-in summary evidence slice with its own source path, fixture corpus, command, and status row. [VERIFIED: packages/parity/status.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]
- Using loose string maps instead of domain enums/newtypes is not the current Rust evidence-boundary pattern. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; standards/languages/rust.md; standards/core/architecture.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | This research is valid for 7 days because Phase 65 planning and local toolchain defaults may change quickly during the active milestone. [ASSUMED] | Metadata | Planner may rely on stale public-boundary or environment facts if Phase 65 lands before execution. |

## Open Questions

1. **Should Phase 64 add a wall-seam summary binary?**
   - What we know: The context allows a developer-facing binary only if it remains caller-supplied/local-file scoped and does not create the Phase 65 public parity command. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]
   - What's unclear: The success criteria require parser/readiness APIs and Cargo/Bazel coverage, not a binary. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]
   - Recommendation: Do not add a binary in Phase 64 unless the planner finds a direct acceptance gap; add the pure `prusa_wall_seam_summary_lines` helper so Phase 65 can build on it. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md]

2. **Should Phase 64 assert public target/status absence?**
   - What we know: `fork.prusaslicer.wall-seam` currently has zero public status rows, and `//packages/parity:prusaslicer_wall_seam_parity` currently has no Bazel target. [VERIFIED: `awk` status scan; `bazel query //packages/parity:prusaslicer_wall_seam_parity`]
   - What's unclear: If Phase 64 only touches Rust crate files, a Rust test does not need to read public status files. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md]
   - Recommendation: Use registry/readiness tests to keep planned wording developer-facing, and add explicit status/target absence checks only if the implementation touches public status or `packages/parity` files. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Bazel rust_test targets and `//packages/slic3r-rust:verify` | yes | 8.6.0 | None needed. [VERIFIED: `.bazelversion`; `bazel --version`] |
| rules_rust | Bazel Rust toolchain and Rust tests | yes | 0.69.0 | None needed. [VERIFIED: MODULE.bazel] |
| Rust via Bazel | Bazel Rust tests | yes | 1.94.1 | None needed. [VERIFIED: MODULE.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Cargo default toolchain | Cargo coverage if run without override | wrong version | cargo/rustc 1.91.1 | Use `cargo +1.94.1 ...`. [VERIFIED: `cargo --version`; `rustc --version`; packages/slic3r-rust/Cargo.toml] |
| Cargo `+1.94.1` toolchain | Required Cargo coverage | yes | cargo 1.94.1, rustc 1.94.1 | None needed. [VERIFIED: `rustup toolchain list`; `cargo +1.94.1 --version`; `rustc +1.94.1 --version`] |
| Wall-seam fixture alias | New Bazel test compile data | yes | checked-in target | None needed. [VERIFIED: packages/parity-fixtures/BUILD.bazel; `bazel query //packages/parity-fixtures:prusa_wall_seam_expected_wall_seam_summary`] |
| Public wall-seam parity target | Phase 65 only | absent as expected | no target | Keep absent in Phase 64. [VERIFIED: `bazel query //packages/parity:prusaslicer_wall_seam_parity`] |
| Public wall-seam status row | Phase 65 only | absent as expected | 0 rows | Keep absent in Phase 64. [VERIFIED: packages/parity/status.tsv; `awk` status scan] |

**Missing dependencies with no fallback:**

- None, provided Cargo coverage uses `+1.94.1` or the default toolchain is updated before execution. [VERIFIED: `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_arc_fitting --no-run`]

**Missing dependencies with fallback:**

- Default `cargo`/`rustc` are too old for the workspace; run Cargo commands as `cargo +1.94.1 ...` or set the active toolchain to `1.94.1`. [VERIFIED: `cargo --version`; `rustc --version`; packages/slic3r-rust/Cargo.toml; `cargo +1.94.1 --version`]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement: false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Phase 64 adds a pure parser/readiness module and no authentication surface. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; CITED: https://owasp.org/www-project-application-security-verification-standard/] |
| V3 Session Management | no | Phase 64 adds no session, cookie, token, or browser session surface. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; CITED: https://github.com/OWASP/ASVS/blob/master/4.0/en/0x11-V2-Authentication.md] |
| V4 Access Control | no | The parser receives caller-supplied strings and does not access permissioned runtime resources. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; CITED: https://cornucopia.owasp.org/taxonomy/asvs-4.0.3/level-1-controls] |
| V5 Input Validation | yes | Use positive allow-list parsing: exact header, exact column count, closed fields/categories, exact source/fixture/value/boundary checks, duplicate/order/missing rejection, and typed domain values. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv; CITED: https://cornucopia.owasp.org/taxonomy/asvs-4.0.3/05-validation-sanitization-and-encoding/01-input-validation] |
| V6 Cryptography | no new cryptography | Do not add cryptography; fixture SHA-256 remains a Phase 63 Bash provenance/verifier concern, not a Phase 64 Rust security protocol. [VERIFIED: packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh; packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv; CITED: https://cornucopia.owasp.org/taxonomy/cheat-sheets-asvs-4.0.3] |

### Known Threat Patterns for the Phase 64 Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Spoofed source ref or fixture path | Spoofing | Parse only the accepted `VendorSourceRef::prusa_slicer_version_2_9_5()` and exact wall-seam fixture path; reject mismatches with typed errors. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| Unsupported TSV field, duplicate row, missing row, or reordered row | Tampering | Enforce the closed 12-field enum, exact expected rows, row-key duplicate detection, row-order checks, and missing-row validation. [VERIFIED: packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| Evidence overclaiming through helper names or metadata | Repudiation | Scan public declarations and readiness/registry text for forbidden claim fragments, and keep public status/command publication deferred to Phase 65. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] |
| Accidental side effects during parsing | Elevation of privilege / Tampering | Keep the module data-in/data-out, and verify no filesystem, process, network, Git, env, clock, generator, release, or sync APIs are introduced. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md` - locked Phase 64 decisions, discretion, canonical refs, and deferrals. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 64 goal, success criteria, dependency, and Phase 65 boundary. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - SEAMRUST-01, SEAMRUST-02, SEAMRUST-03, and v1.16 out-of-scope boundaries. [VERIFIED: local file read]
- `.planning/STATE.md` - generated-output evidence ladder decisions and current milestone state. [VERIFIED: local file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, `standards/index.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/testing.md`, `standards/core/verification.md`, and `standards/languages/rust.md` - repo workflow, Rust, testing, and verification constraints. [VERIFIED: local file read]
- `packages/prusa-wall-seam-scope/wall-seam-scope.md` and `packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh` - approved wall-seam field contract, traceability, planned command/status, and status absence guard. [VERIFIED: local file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`, `fixture-provenance.tsv`, and `README.md` - exact Phase 63 parser input, source identity, source anchors, fixture identity, and deferrals. [VERIFIED: local file read]
- `packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh` - exact wall-seam summary row constants and fail-closed fixture rules. [VERIFIED: local file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs` and `tests/prusa_arc_fitting.rs` - closest completed parser/readiness/test precedent. [VERIFIED: local file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`, `src/lib.rs`, `tests/flavor_registry.rs`, and `BUILD.bazel` - static registry, public re-export, test, and Bazel wiring surfaces to change. [VERIFIED: local file read]
- `packages/slic3r-rust/BUILD.bazel`, `packages/slic3r-rust/Cargo.toml`, `packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml`, and `MODULE.bazel` - aggregate verification, workspace Rust version, crate dependency, rules_rust, and toolchain facts. [VERIFIED: local file read]
- `.planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-RESEARCH.md` and `59-VERIFICATION.md` - completed arc-fitting Rust evidence-boundary precedent and verification proof. [VERIFIED: local file read]

### Secondary (MEDIUM confidence)

- OWASP ASVS project page - ASVS purpose and scope as a web application security verification standard. [CITED: https://owasp.org/www-project-application-security-verification-standard/]
- OWASP ASVS GitHub repository - latest stable ASVS version context and official project repository. [CITED: https://github.com/OWASP/ASVS]
- OWASP Cornucopia ASVS 4.0.3 V5.1 input validation page - positive validation and strongly typed structured data controls used for the local parser security mapping. [CITED: https://cornucopia.owasp.org/taxonomy/asvs-4.0.3/05-validation-sanitization-and-encoding/01-input-validation]
- OWASP Cornucopia ASVS 4.0.3 index pages - V2/V3/V4/V5/V6 category mapping used by the GSD security-domain template. [CITED: https://cornucopia.owasp.org/taxonomy/asvs-4.0.3/level-1-controls; CITED: https://cornucopia.owasp.org/taxonomy/cheat-sheets-asvs-4.0.3]

### Tertiary (LOW confidence)

- None. [VERIFIED: source review]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - toolchain, crate, Bazel, and fixture aliases were verified from manifests and local commands. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; command outputs]
- Architecture: HIGH - the recommendation mirrors a completed same-rung arc-fitting implementation and verification report. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; .planning/milestones/v1.15-phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md]
- Pitfalls: HIGH - failure classes come directly from Phase 64 locked decisions, SEAMRUST requirements, Phase 63 fixture verifier checks, and existing arc-fitting tests. [VERIFIED: .planning/phases/64-rust-wall-seam-evidence-boundary/64-CONTEXT.md; .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs]

**Research date:** 2026-06-30
**Valid until:** 2026-07-07 [ASSUMED]
