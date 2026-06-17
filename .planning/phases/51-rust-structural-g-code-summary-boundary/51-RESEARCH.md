# Phase 51: Rust Structural G-code Summary Boundary - Research

**Researched:** 2026-06-17 [VERIFIED: environment current_date]
**Domain:** Pure Rust typed TSV boundary, static registry metadata, Cargo/Bazel verification [VERIFIED: .planning/ROADMAP.md; .planning/phases/51-rust-structural-g-code-summary-boundary/51-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: codebase inspection and local command execution]

<user_constraints>

## User Constraints (from CONTEXT.md)

Source note: this section copies the Phase 51 context boundary, decisions, discretion areas, and deferrals from `51-CONTEXT.md`. [VERIFIED: .planning/phases/51-rust-structural-g-code-summary-boundary/51-CONTEXT.md]

### Phase Boundary

Phase 51 extends the existing pure `slic3r_flavors::prusa_gcode_output`
boundary so developers can parse and expose the Phase 50
`expected-gcode-structural-summary.tsv` artifact through typed Rust data.

The phase completes GCRUST-01, GCRUST-02, and GCRUST-03 only. It must not
create the Phase 52 public structural parity command, publish new status rows,
promote broad `generated-outputs`, or claim byte-for-byte G-code parity,
geometry/toolpath parity, printability, printer-runtime behavior, support
generation, wall seam behavior, arc fitting, GUI export/viewer behavior,
release behavior, network/device behavior, non-Prusa fork behavior, upstream
source imports, or sync automation.

### Locked Decisions

## Implementation Decisions

### Structural parser model

- **D-01:** Extend the existing `prusa_gcode_output` Rust module instead of
  creating a separate crate or parser package. Phase 51 is a typed expansion of
  the existing Prusa G-code evidence boundary.
- **D-02:** Use a closed, row-first structural model for the Phase 50 TSV. The
  parser should preserve the exact structural rows and expose typed fields for
  source refs, fixture paths, structural fields, structural categories,
  structural values, and evidence-boundary text.
- **D-03:** Keep a small typed projection available for callers that need
  inspectable structural facts, but make the parsed row contract the source of
  truth so row order, required rows, unsupported rows, and boundary text remain
  fail-closed.
- **D-04:** Do not add a TSV, CSV, Serde, or other parsing dependency for this
  phase. Match the existing dependency-free parser style already used by
  `parse_prusa_gcode_output_summary`.

### Structural validation behavior

- **D-05:** Require the exact Phase 50 structural header:
  `source_ref`, `fixture_path`, `structural_field`, `structural_category`,
  `structural_value`, and `evidence_boundary`.
- **D-06:** Require the exact 16 structural fields from Phase 50, in order:
  `source_ref`, `inventory_source_paths`, `fixture_source_literal`,
  `fixture_id`, `fixture_path`, `command_count_total`, `command_count_g1`,
  `section_count_total`, `ordered_marker_1`, `ordered_marker_2`,
  `ordered_marker_3`, `ordered_marker_4`, `movement_axis_present`,
  `extrusion_axis_present`, `temperature_marker_count`, and
  `tool_change_marker_count`.
- **D-07:** Parse structural values into domain types at the boundary where that
  prevents invalid states: counts as numeric counts, booleans as typed boolean
  indicators, source and fixture identities as exact known constants, and
  ordered markers as closed known marker values.
- **D-08:** Treat evidence-boundary text as part of the contract. Unsupported
  broad-behavior claim text must fail instead of passing as unstructured notes.

### Regression coverage

- **D-09:** Add focused Rust tests, one rejection class per test, following the
  existing Arrange/Act/Assert style in
  `tests/prusa_gcode_output.rs`.
- **D-10:** Cover every GCRUST-02 rejection class directly in Cargo and Bazel:
  invalid headers, wrong column counts, missing rows, duplicate rows,
  out-of-order rows, unsupported structural fields, unsupported claim text,
  wrong source refs, and wrong fixture identities.
- **D-11:** Keep CLI/temp-fixture mutation harness work deferred to Phase 52.
  Phase 51 proves the pure Rust boundary and Bazel/Cargo test wiring, not a
  public executable parity command.

### Registry readiness boundary

- **D-12:** Expose structural Prusa G-code readiness through pure typed Rust
  metadata reachable from the existing registry/capability path. The metadata
  should identify the structural summary artifact and source/fixture boundary
  without filesystem discovery, Git, network, process execution, release
  behavior, sync behavior, or status publication.
- **D-13:** Preserve `ChecklistStatus::FutureCandidate`,
  `ParitySurface::generated_outputs()`, and the existing
  `reserved_future_status_token` semantics. Structural parser readiness is not
  status verification and must not promote broad `generated-outputs`.
- **D-14:** Keep public names narrow. Prefer names such as structural summary,
  structural readiness, or expected structural summary over terms that imply
  output parity, runtime verification, printer behavior, release support, sync,
  or generated-output completion.

### the agent's Discretion

- Choose the exact Rust helper boundaries, enum names, and projection method
  names, provided the parser remains pure, typed, dependency-free, and easy to
  test.
- Choose whether the structural projection is returned from a new function or
  attached to the parsed summary type, as long as the row-first contract remains
  visible and testable.
- Use helper functions in tests when they reduce duplication without hiding the
  single concern of each rejection test.

### Deferred Ideas (OUT OF SCOPE)

- Phase 52 owns the public structural parity command, structural mutation guard
  at executable-command level, status/docs publication, and any public
  generated-output evidence wording.
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
| GCRUST-01 | Developer can parse the v1.13 expected structural summary artifact through a pure typed Rust boundary in `slic3r_flavors`. | Extend `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` with a dependency-free structural parser and typed row/projection types. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| GCRUST-02 | Developer can run Cargo and Bazel tests proving the Rust structural boundary rejects invalid headers, wrong column counts, missing rows, duplicate rows, out-of-order rows, unsupported structural fields, unsupported claim text, wrong source refs, and wrong fixture identities. | Extend `tests/prusa_gcode_output.rs`, add the structural TSV to Bazel `compile_data`, run Cargo with `+1.94.1`, and run focused Bazel tests serially. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; command execution] |
| GCRUST-03 | Developer can inspect registry metadata that exposes structural Prusa G-code evidence readiness without filesystem discovery, Git, network, process execution, release behavior, sync behavior, or premature broad generated-output status publication. | Add structural artifact metadata to the existing pure metadata path while preserving `FutureCandidate`, `generated-outputs`, and reserved status token semantics. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
</phase_requirements>

## Summary

Phase 51 should be planned as an internal Rust boundary extension, not a new package, public command, status update, or fixture-verifier rewrite. [VERIFIED: 51-CONTEXT.md] The existing `prusa_gcode_output.rs` parser already provides the standard local pattern: exact header validation, tab splitting with fixed column counts, required-value checks, typed domain enums, duplicate/missing/order checks, exact no-overclaiming note validation, and pure summary output. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

The Phase 50 structural sidecar is a checked-in six-column TSV with exactly 16 data rows and fixed values for source identity, fixture identity, counts, booleans, ordered `G1 F...` markers, and evidence-boundary text. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv] The planner should make the structural row list the source of truth, then expose a typed projection for convenience without letting the projection weaken row-order, field, or boundary-text validation. [VERIFIED: 51-CONTEXT.md]

**Primary recommendation:** Add structural parsing, typed rows, typed projection, metadata exposure, re-exports, and focused Cargo/Bazel tests inside `slic3r_flavors::prusa_gcode_output`; do not add dependencies, do not touch `packages/parity/status.tsv`, and do not create the Phase 52 parity command. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity/status.tsv]

## Project Constraints (from AGENTS.md)

- Read repo-local `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned canonical standards before plan/review/implementation/audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- For non-trivial work, create a short checkable plan with verification tasks before coding. [VERIFIED: user-provided AGENTS.md instructions]
- Prefer semantic navigation where available, otherwise use `rg` for text and file searches. [VERIFIED: user-provided AGENTS.md instructions]
- Preserve user changes; the current worktree already has an unrelated `.planning/config.json` modification, so commits must target only the research file or later phase files intentionally changed. [VERIFIED: `git status --short --branch`]
- Rust pre-commit checks in this repo are format, clippy, build, and tests, adapted to the repository's actual Cargo/Bazel entrypoints. [VERIFIED: user-provided AGENTS.md instructions; packages/slic3r-rust/BUILD.bazel]
- Rust code must avoid `unwrap()`, prefer `?`/`expect()` only when panic is impossible, use `let...else` for early returns where clear, and prefix optional internal names with `maybe_`. [VERIFIED: user-provided AGENTS.md instructions; cited Bright Builds Rust standard]
- Tests should verify behavior, keep one concern per unit test, and use Arrange/Act/Assert comments unless trivially obvious. [VERIFIED: user-provided AGENTS.md instructions; cited Bright Builds testing standard]
- For phase `*-SUMMARY.md` files, preserve `requirements-completed` frontmatter and do not run `mdformat` over summaries; this research file is not a summary, but later Phase 51 summaries must follow it. [VERIFIED: AGENTS.md]
- `standards-overrides.md` has no real active override; it contains placeholder rows only. [VERIFIED: standards-overrides.md]
- The pinned Bright Builds standards materially relevant here are architecture, code shape, verification, testing, and Rust. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Rust standard library | Rust workspace requires `rust-version = "1.94"`; Bazel pins Rust `1.94.1`; local `+1.94.1` toolchain is installed. [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel; `rustup toolchain list`] | Parse caller-supplied TSV text with `str::lines`, `split('\t')`, typed enums, and pure functions. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Locked decision D-04 forbids TSV/CSV/Serde dependencies, and the current summary/parser modules already use dependency-free parsing. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| `slic3r_flavors` | `0.1.0` path crate, edition 2024, rust-version 1.94. [VERIFIED: cargo metadata; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Owns the existing `prusa_gcode_output` parser/metadata module and registry exports. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Phase 51 is explicitly an expansion of this crate/module, not a new crate. [VERIFIED: 51-CONTEXT.md] |
| `slic3r_contracts` | `0.1.0` path crate, edition 2024, rust-version 1.94. [VERIFIED: cargo metadata; packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml] | Provides `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, `ChecklistStatus`, and `FlavorId` typed contracts. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs] | Existing G-code metadata uses these types and D-13 requires preserving `FutureCandidate`/`generated_outputs` semantics. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; 51-CONTEXT.md] |
| Bazel `rules_rust` | `0.69.0` with Rust toolchain `1.94.1`. [VERIFIED: MODULE.bazel] | Runs Bazel Rust tests, rustfmt checks, and clippy targets. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Phase 51 requires both Cargo and Bazel test coverage. [VERIFIED: .planning/REQUIREMENTS.md] |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `cargo +1.94.1` | Installed toolchain; default `cargo` is 1.91.1 and fails the workspace rust-version gate. [VERIFIED: `rustup toolchain list`; `cargo test -p slic3r_flavors prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml`] | Run focused Cargo tests and clippy for `slic3r_flavors`. [VERIFIED: command execution] | Use `cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml` and matching registry tests. [VERIFIED: command execution] |
| Bazel 8.6.0 / Bazelisk | `.bazelversion` is `8.6.0`; `bazel --version` reports 8.6.0. [VERIFIED: .bazelversion; command execution] | Run focused Rust integration tests and package verification targets. [VERIFIED: packages/slic3r-rust/BUILD.bazel] | Use for Bazel compile data and final phase gate; run commands serially because parallel Bazel invocations contend on the output-base lock. [VERIFIED: command execution] |
| `mdformat` | 1.0.0 installed. [VERIFIED: command execution] | Optional check-mode formatting for non-summary Markdown. [VERIFIED: Bright Builds verification standard; command execution] | This phase should not need Markdown implementation edits except planning artifacts; do not run over phase summaries. [VERIFIED: AGENTS.md] |
| `buildifier` | Not installed. [VERIFIED: command execution] | BUILD formatting if available. [VERIFIED: Bright Builds verification standard] | Preserve existing BUILD style manually and rely on Bazel analysis/tests as fallback. [VERIFIED: command execution; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Dependency-free TSV parsing | `csv`, `serde`, or a new TSV parser crate | Locked out by D-04; would add dependency surface for a fixed six-column, 16-row internal artifact. [VERIFIED: 51-CONTEXT.md; expected-gcode-structural-summary.tsv] |
| Extending `prusa_gcode_output.rs` | New `slic3r_gcode_structural` crate or module | Locked out by D-01 and would split one Prusa G-code evidence boundary across packages. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| Public structural parity command now | Add/modify `//packages/parity:prusaslicer_gcode_output_parity` | Deferred to Phase 52 and would violate D-11 plus Phase 51 boundary. [VERIFIED: 51-CONTEXT.md; packages/parity/BUILD.bazel] |

**Installation:**

```bash
# No new packages should be installed for Phase 51. Use existing Rust/Bazel tooling.
cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test
```

No `npm view`/registry package version check applies because Phase 51 adds no npm package and no external Rust crate. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
├── src/
│   ├── prusa_gcode_output.rs      # extend existing summary parser with structural rows/projection
│   ├── registry.rs                # expose pure structural readiness metadata through existing capability path
│   └── lib.rs                     # re-export new public structural types/functions
├── tests/
│   ├── prusa_gcode_output.rs      # add focused structural parser rejection and projection tests
│   └── flavor_registry.rs         # add structural readiness metadata tests
└── BUILD.bazel                    # add structural TSV compile_data to prusa_gcode_output_test
```

This is the correct structure because every listed file is already the integration surface for the Phase 47/48 Prusa G-code summary boundary. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

### Pattern 1: Closed Row-First Parser

**What:** Parse the structural TSV into exact typed rows first, detect duplicates/extra/out-of-order/missing rows against `EXPECTED_STRUCTURAL_ROWS`, then derive optional convenience facts from the parsed row set. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

**When to use:** Use this for `expected-gcode-structural-summary.tsv` because row order, field coverage, and evidence-boundary text are part of the contract. [VERIFIED: 51-CONTEXT.md; expected-gcode-structural-summary.tsv]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
if row_keys.contains(&row_key) {
    return Err(PrusaGcodeOutputParseError::DuplicateRow { /* typed fields */ });
}

if !is_expected_row_key(row_key) {
    return Err(PrusaGcodeOutputParseError::ExtraRow { /* typed fields */ });
}
```

The structural parser should mirror this flow with structural row keys based on `structural_field`, not a loose string map. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; 51-CONTEXT.md]

### Pattern 2: Parse Boundary Values Into Domain Types

**What:** Convert structural counts, booleans, source identity, fixture identity, ordered markers, categories, and evidence-boundary text into closed Rust types at parse time. [VERIFIED: 51-CONTEXT.md]

**When to use:** Use this for every structural row because D-07 requires boundary parsing where it prevents invalid states. [VERIFIED: 51-CONTEXT.md]

**Recommended type shape:**

```rust
// Source pattern: existing typed enum/as_str parser style in prusa_gcode_output.rs.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputStructuralField {
    SourceRef,
    InventorySourcePaths,
    FixtureSourceLiteral,
    FixtureId,
    FixturePath,
    CommandCountTotal,
    CommandCountG1,
    SectionCountTotal,
    OrderedMarker1,
    OrderedMarker2,
    OrderedMarker3,
    OrderedMarker4,
    MovementAxisPresent,
    ExtrusionAxisPresent,
    TemperatureMarkerCount,
    ToolChangeMarkerCount,
}
```

The names can vary under the agent's discretion, but the closed field set cannot vary. [VERIFIED: 51-CONTEXT.md]

### Pattern 3: Pure Static Registry Readiness

**What:** Add structural artifact/readiness metadata to the existing G-code metadata/capability path without reading files or publishing status. [VERIFIED: 51-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]

**When to use:** Use for GCRUST-03 so developers can inspect structural readiness through Rust values. [VERIFIED: .planning/REQUIREMENTS.md]

**Recommended shape:** Extend `PrusaGcodeOutputMetadata` with `expected_structural_summary_path` and, if needed, a small `PrusaGcodeOutputStructuralReadiness` value returned from a pure `const fn`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; 51-CONTEXT.md]

### Anti-Patterns to Avoid

- **Stringly typed structural facts:** Passing raw `structural_field` and `structural_value` strings past parsing would violate D-07 and Bright Builds parse-boundary guidance. [VERIFIED: 51-CONTEXT.md; cited Bright Builds architecture standard]
- **Projection-first parsing:** Building a summary struct while ignoring exact rows would make missing/duplicate/out-of-order rows harder to reject. [VERIFIED: 51-CONTEXT.md]
- **Forbidden-word-only evidence checks:** D-08 requires exact evidence-boundary text, not only scanning for broad-claim terms. [VERIFIED: 51-CONTEXT.md; expected-gcode-structural-summary.tsv]
- **Public names with parity/status/runtime implications:** Existing tests reject risky public helper names, and D-14 says structural names must remain narrow. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; 51-CONTEXT.md]
- **Parallel Bazel verification in the same output base:** Local parallel Bazel commands waited on the output-base lock, so plans should run Bazel commands serially. [VERIFIED: command execution]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Structural TSV parsing | A generic TSV/CSV parser abstraction or new crate | Fixed-column parsing in `prusa_gcode_output.rs` with exact constants and typed parse helpers | D-04 forbids parser dependencies and the artifact is a closed six-column, 16-row internal TSV. [VERIFIED: 51-CONTEXT.md; expected-gcode-structural-summary.tsv] |
| Broad G-code semantics | A G-code parser/interpreter, geometry analyzer, printer-runtime model, or byte-for-byte comparator | Parse only the Phase 50 structural sidecar rows and exact ordered marker values | The milestone explicitly forbids broad generated-output, geometry, runtime, and byte parity claims. [VERIFIED: .planning/REQUIREMENTS.md; 51-CONTEXT.md] |
| Public parity/status publication | New `packages/parity` command, status row edits, or generated-output promotion | Pure Rust metadata/readiness in `slic3r_flavors`; leave executable/status work to Phase 52 | D-11/D-13 defer public command and status publication. [VERIFIED: 51-CONTEXT.md; packages/parity/status.tsv] |
| Runtime artifact discovery | Filesystem, Git, network, or process execution to locate/validate artifacts | Caller-supplied TSV string plus static metadata paths | GCRUST-03 requires no filesystem discovery, Git, network, process execution, release behavior, sync behavior, or status publication. [VERIFIED: .planning/REQUIREMENTS.md] |
| New fixture verifier | Rust-side reimplementation of Phase 50 Bash verifier | Consume the already verified checked-in structural TSV and add parser tests | Phase 50 owns fixture verification; Phase 51 owns pure Rust boundary tests. [VERIFIED: 50-CONTEXT.md; 51-CONTEXT.md] |

**Key insight:** The hard problem is not TSV parsing; it is preserving the evidence boundary so structural readiness cannot silently become a generated-output parity claim. [VERIFIED: 49-CONTEXT.md; 50-CONTEXT.md; 51-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Default Cargo Toolchain Fails Before Tests

**What goes wrong:** `cargo test -p slic3r_flavors ...` with the default toolchain fails because default `rustc` is 1.91.1 while the workspace requires Rust 1.94. [VERIFIED: command execution; packages/slic3r-rust/Cargo.toml]
**How to avoid:** Use `cargo +1.94.1 ...` or update the default Rust toolchain before Cargo verification. [VERIFIED: `rustup toolchain list`; command execution]
**Warning signs:** Cargo reports `rustc 1.91.1 is not supported` for `slic3r_contracts` and `slic3r_flavors`. [VERIFIED: command execution]

### Pitfall 2: Misusing Bazel `:clippy` As a Test Target

**What goes wrong:** `bazel test //packages/slic3r-rust/crates/slic3r_flavors:clippy` builds outputs but exits with `ERROR: No test targets were found`. [VERIFIED: command execution]
**How to avoid:** Use `bazel build //packages/slic3r-rust/crates/slic3r_flavors:clippy` or `bazel test //packages/slic3r-rust:verify`. [VERIFIED: command execution; packages/slic3r-rust/BUILD.bazel]
**Warning signs:** Bazel prints `.clippy.ok` outputs and then says no test targets were found. [VERIFIED: command execution]

### Pitfall 3: Missing Structural TSV Compile Data

**What goes wrong:** Bazel Rust tests cannot `include_str!` the structural sidecar unless `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary` is added to `prusa_gcode_output_test` `compile_data`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/parity-fixtures/BUILD.bazel]
**How to avoid:** Add the structural summary alias to the existing `prusa_gcode_output_test` compile data next to the summary-only TSV. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]
**Warning signs:** Cargo tests pass but Bazel tests fail to locate the structural TSV at compile time. [VERIFIED: existing Bazel compile_data pattern]

### Pitfall 4: Treating Evidence-Boundary Text As Comments

**What goes wrong:** The parser accepts unsupported broad-claim wording if `evidence_boundary` is stored as an unconstrained string. [VERIFIED: 51-CONTEXT.md]
**How to avoid:** Model boundary text like existing `PrusaGcodeOutputNote`: parse exact expected text per structural row and reject drift. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; expected-gcode-structural-summary.tsv]
**Warning signs:** A mutation from `no generated-output behavior claimed` to `full generated-output parity verified` still parses. [VERIFIED: tests/prusa_gcode_output.rs existing `rejects_unexpected_note_claim`; 51-CONTEXT.md]

### Pitfall 5: Allowing Supported Tokens In Unsupported Pairings

**What goes wrong:** A row with individually supported values can form an unsupported row pairing and must not pass. [VERIFIED: existing `rejects_extra_row` test in tests/prusa_gcode_output.rs]
**How to avoid:** Validate whole row keys against an exact expected-row list before accepting notes/boundary values. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]
**Warning signs:** Tests only mutate unknown field names and do not test an extra row made from known tokens. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs]

### Pitfall 6: Letting Projection Become the Contract

**What goes wrong:** A projection with counts and booleans can hide missing rows, duplicate rows, or row-order drift. [VERIFIED: 51-CONTEXT.md]
**How to avoid:** Return/store parsed rows first and derive projection only after row validation succeeds. [VERIFIED: 51-CONTEXT.md]
**Warning signs:** Tests assert only `command_count_total == 4` and do not assert row count/order or structural field identity. [VERIFIED: expected-gcode-structural-summary.tsv; 51-CONTEXT.md]

### Pitfall 7: Registry Wording Overclaims Status

**What goes wrong:** Updating `future_parity_notes`, helper names, or metadata fields with words like verified/runtime/executable/release can violate the no-overclaiming boundary. [VERIFIED: 51-CONTEXT.md; tests/flavor_registry.rs]
**How to avoid:** Use names such as `expected_structural_summary_path`, `structural_summary`, and `structural_readiness`; preserve `FutureCandidate`, `generated_outputs`, and reserved status token values. [VERIFIED: 51-CONTEXT.md]
**Warning signs:** `packages/parity/status.tsv` changes or registry tests need to accept `verified` language. [VERIFIED: packages/parity/status.tsv; tests/flavor_registry.rs]

## Code Examples

Verified patterns from current codebase sources:

### Exact Header And Column Count

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
const EXPECTED_HEADER: &str =
    "source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes";
const EXPECTED_COLUMN_COUNT: usize = 7;
```

Use a structural equivalent with header `source_ref\tfixture_path\tstructural_field\tstructural_category\tstructural_value\tevidence_boundary` and count `6`. [VERIFIED: expected-gcode-structural-summary.tsv; 51-CONTEXT.md]

### Exact Source And Fixture Identity

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
fn parse_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaGcodeOutputParseError> {
    if value != PRUSA_GCODE_OUTPUT_FIXTURE_PATH {
        return Err(PrusaGcodeOutputParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_FIXTURE_PATH)
}
```

Reuse this exact style for structural source refs and fixture identity fields, with structural-specific error variants if clearer. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; 51-CONTEXT.md]

### Test Shape

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs
#[test]
fn rejects_wrong_column_count() {
    // Arrange
    let input = replace_first_data_row("only\tsix\tcolumns\tin\tthis\trow");

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::WrongColumnCount {
            line_number: 2,
            expected: 7,
            actual: 6,
        })
    ));
}
```

Structural rejection tests should follow this one-concern Arrange/Act/Assert pattern for each GCRUST-02 class. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs; 51-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| v1.12 summary-only G-code expected summary with 5 rows and marker metadata. [VERIFIED: expected-gcode-summary.tsv] | v1.13 structural sidecar with 16 exact rows covering source, fixture, counts, ordered markers, booleans, and marker counts. [VERIFIED: expected-gcode-structural-summary.tsv] | Phase 50 completed on 2026-06-17. [VERIFIED: .planning/STATE.md; 50-CONTEXT.md] | Phase 51 must parse the new sidecar without destabilizing the old summary parser or Phase 48 parity command. [VERIFIED: 51-CONTEXT.md; packages/parity/BUILD.bazel] |
| Rust G-code metadata exposed only `expected_summary_path`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] | Add structural artifact/readiness metadata while preserving status semantics. [VERIFIED: 51-CONTEXT.md] | Phase 51. [VERIFIED: .planning/ROADMAP.md] | Developers can inspect structural readiness without filesystem discovery or status publication. [VERIFIED: .planning/REQUIREMENTS.md] |
| Public parity command validates summary-only expected artifact. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/status.tsv] | Public structural parity command remains deferred. [VERIFIED: 51-CONTEXT.md] | Phase 52 owns it. [VERIFIED: .planning/ROADMAP.md] | Planner must avoid editing `packages/parity/BUILD.bazel` or `packages/parity/status.tsv` for Phase 51. [VERIFIED: 51-CONTEXT.md] |

**Deprecated/outdated:**

- Using default `cargo` for this workspace is outdated on this host because it resolves to Rust 1.91.1 while the workspace requires Rust 1.94. [VERIFIED: command execution; packages/slic3r-rust/Cargo.toml]
- Treating `fork.prusaslicer.gcode-output` as structural evidence status is outdated for Phase 51 because the existing status row is still summary-only and structural publication is deferred. [VERIFIED: packages/parity/status.tsv; 51-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

All claims in this research were verified against repo files, command execution, or pinned Bright Builds standards during this session; no `[ASSUMED]` claims are intentionally present. [VERIFIED: Sources section]

## Open Questions (RESOLVED)

1. **RESOLVED: Exact structural type/projection names are implementation discretion.** [VERIFIED: 51-CONTEXT.md]
   - What we know: The parser must be pure, typed, dependency-free, row-first, and easy to test. [VERIFIED: 51-CONTEXT.md]
   - What's unclear: The final enum/helper names are not locked. [VERIFIED: 51-CONTEXT.md]
   - Recommendation: Use `PrusaGcodeOutputStructural*` names and a small projection method or function only after the row contract is parsed. [VERIFIED: existing naming pattern in prusa_gcode_output.rs; 51-CONTEXT.md]

No blocking open questions were found for planning. [VERIFIED: codebase inspection]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Rust default toolchain | Cargo commands if no explicit toolchain is used | Partial | `rustc 1.91.1`, `cargo 1.91.1`; too old for `rust-version = "1.94"` [VERIFIED: command execution; packages/slic3r-rust/Cargo.toml] | Use installed `+1.94.1` or update default toolchain. [VERIFIED: `rustup toolchain list`] |
| Rust `1.94.1` toolchain | Cargo verification for Phase 51 | yes | `1.94.1-aarch64-apple-darwin` installed [VERIFIED: `rustup toolchain list`] | None needed. [VERIFIED: command execution] |
| Cargo | Focused Rust tests, fmt, clippy | yes with `+1.94.1` | `cargo +1.94.1` passes focused tests and clippy. [VERIFIED: command execution] | Use Bazel for Rust tests if Cargo toolchain selection is unavailable, but GCRUST-02 still requires Cargo coverage. [VERIFIED: .planning/REQUIREMENTS.md] |
| Bazel/Bazelisk | Bazel Rust tests and package verification | yes | `.bazelversion` and `bazel --version` are `8.6.0`. [VERIFIED: .bazelversion; command execution] | None needed. [VERIFIED: command execution] |
| `rules_rust` | Bazel Rust toolchain/tests | yes | `0.69.0`, Rust `1.94.1`. [VERIFIED: MODULE.bazel] | None needed. [VERIFIED: Bazel test execution] |
| `buildifier` | Optional BUILD formatting | no | command not found [VERIFIED: command execution] | Preserve existing BUILD style manually and rely on Bazel analysis/tests. [VERIFIED: command execution] |
| `mdformat` | Optional non-summary Markdown formatting | yes | 1.0.0 [VERIFIED: command execution] | Use `git diff --check` if unavailable; do not run on phase summaries. [VERIFIED: AGENTS.md] |

**Missing dependencies with no fallback:** None for research/planning; Phase 51 implementation can proceed with installed `cargo +1.94.1` and Bazel. [VERIFIED: command execution]

**Missing dependencies with fallback:** `buildifier` is missing; manual BUILD style plus Bazel verification is viable because Phase 51 only needs to add an existing fixture alias to existing `compile_data`. [VERIFIED: command execution; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**Verified baseline commands:**

```bash
cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml
cargo +1.94.1 test -p slic3r_flavors --test flavor_registry --manifest-path packages/slic3r-rust/Cargo.toml
cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all -- --check
cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features -- -D warnings
cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-targets --all-features
cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --workspace --all-features
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test
bazel test //packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test
bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check
bazel build //packages/slic3r-rust/crates/slic3r_flavors:clippy
git diff --check
```

Every listed baseline command passed in this session except the intentionally documented stale default-Cargo and wrong `bazel test :clippy` probes. [VERIFIED: command execution]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json; GSD researcher instructions]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Phase 51 has no authentication surface. [VERIFIED: 51-CONTEXT.md] |
| V3 Session Management | no | Phase 51 has no session surface. [VERIFIED: 51-CONTEXT.md] |
| V4 Access Control | no | Phase 51 exposes static Rust metadata and caller-supplied parsing, not user authorization. [VERIFIED: 51-CONTEXT.md; prusa_gcode_output.rs] |
| V5 Input Validation | yes | Closed header, column-count, required-value, source/fixture identity, structural-field, structural-value, row-order, duplicate, missing-row, and evidence-boundary validation. [VERIFIED: 51-CONTEXT.md; prusa_gcode_output.rs] |
| V6 Cryptography | no | Phase 51 does not compute or validate cryptographic hashes; fixture SHA-256 remains in Phase 50 provenance. [VERIFIED: fixture-provenance.tsv; 51-CONTEXT.md] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Malformed TSV accepted as structural evidence | Tampering | Exact header, column count, non-empty value, and closed enum parsing. [VERIFIED: prusa_gcode_output.rs; 51-CONTEXT.md] |
| Broad parity/status claim smuggled through notes | Tampering / Repudiation | Exact evidence-boundary text per expected row and no public status mutation. [VERIFIED: expected-gcode-structural-summary.tsv; packages/parity/status.tsv; 51-CONTEXT.md] |
| Wrong source ref or fixture identity accepted | Spoofing | Parse source/fixture identities against static known constants and reject mismatches. [VERIFIED: prusa_gcode_output.rs; expected-gcode-structural-summary.tsv] |
| Runtime side effects hidden in parser path | Elevation of scope | Keep parser data-in/data-out with no filesystem discovery, Git, network, process, release, sync, or status publication. [VERIFIED: 51-CONTEXT.md; prusa_gcode_output.rs] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/51-rust-structural-g-code-summary-boundary/51-CONTEXT.md` - locked Phase 51 decisions, boundary, deferrals, and discretion. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - GCRUST-01, GCRUST-02, GCRUST-03, and v1.13 scope. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 51 goal, success criteria, and Phase 52 deferral. [VERIFIED: file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - current state and milestone history. [VERIFIED: file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv` - exact Phase 50 structural sidecar rows. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` - existing pure parser pattern and metadata. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` - existing test style and rejection classes. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` and `tests/flavor_registry.rs` - registry metadata shape and no-overclaiming tests. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`, `packages/slic3r-rust/BUILD.bazel`, `MODULE.bazel`, `.bazelversion`, and Cargo manifests - build/test/toolchain configuration. [VERIFIED: file read]
- Local command execution - Rust/Cargo/Bazel/buildifier/mdformat availability and focused baseline commands. [VERIFIED: command execution]

### Secondary (MEDIUM confidence)

- Pinned Bright Builds standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: architecture, code shape, verification, testing, and Rust guidance. [CITED: AGENTS.bright-builds.md; raw GitHub standards URLs]

### Tertiary (LOW confidence)

- None. [VERIFIED: source review]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - no new external dependency is allowed, local crate/toolchain versions were verified with manifests, `cargo metadata`, and command execution. [VERIFIED: 51-CONTEXT.md; cargo metadata; command execution]
- Architecture: HIGH - the target module already implements the exact parser pattern Phase 51 needs to extend. [VERIFIED: prusa_gcode_output.rs]
- Pitfalls: HIGH - pitfalls are grounded in existing tests, local command failures, and locked Phase 51 deferrals. [VERIFIED: tests/prusa_gcode_output.rs; command execution; 51-CONTEXT.md]
- Environment: HIGH - command availability and baseline commands were executed locally during research. [VERIFIED: command execution]

**Research date:** 2026-06-17 [VERIFIED: environment current_date]
**Valid until:** 2026-07-17 for internal code/fixture architecture; re-check toolchain availability if planning happens later. [VERIFIED: stable internal repo scope; command execution]
