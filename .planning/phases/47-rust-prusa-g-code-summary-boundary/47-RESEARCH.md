# Phase 47: Rust Prusa G-code Summary Boundary - Research

**Researched:** 2026-06-14 [VERIFIED: current_date]
**Domain:** Rust typed parser boundary, Bazel Rust test wiring, PrusaSlicer fixture traceability [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: codebase grep; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

<user_constraints>
## User Constraints (from CONTEXT.md)

The following locked decisions, discretion areas, and deferred ideas are copied from `47-CONTEXT.md`. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Rust Boundary Shape

- **D-01:** Add a new `slic3r_flavors::prusa_gcode_output` module that mirrors
  the existing `prusa_project_file` pure boundary style: static metadata
  constants, typed summary row structs, small enums for accepted evidence
  fields, a parse result type, `parse_prusa_gcode_output_summary`, and
  `prusa_gcode_output_summary_lines`.
- **D-02:** Keep the module data-in/data-out only. It may parse a provided
  string and return values or formatted summary lines, but it must not read the
  filesystem, run Git, run processes, fetch network data, import upstream
  source, discover fixtures, update profiles, publish status, or generate
  G-code.
- **D-03:** Expose the new module and public types from
  `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` using names that do
  not imply verified runtime behavior or broad generated-output support.

### Metadata and Traceability

- **D-04:** The metadata function must trace `prusaslicer.gcode-output` to
  vendor ID `prusaslicer`, `FlavorId::PrusaSlicer`,
  `FeatureOrigin::SharedDownstream`, `ParitySurface::generated_outputs()`,
  `ChecklistStatus::FutureCandidate`, the accepted Prusa source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `tests/fff_print/test_gcodewriter.cpp`, fixture path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`,
  expected summary path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`,
  scope record path `packages/prusa-gcode-output-scope/gcode-output-scope.md`,
  and reserved future status token `fork.prusaslicer.gcode-output`.
- **D-05:** Add the capability to the `slic3r_flavors` registry as a
  `SharedDownstream` Prusa capability with generated-output parity dependency
  and future-candidate status. This records planning metadata only; it does not
  publish the status row or executable parity evidence.

### Expected Summary Parsing

- **D-06:** Parse exactly the Phase 45 reserved seven-column header:
  `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`,
  `marker_key`, `marker_value`, and `notes`.
- **D-07:** Treat the Phase 46 five data rows as the complete accepted row set:
  one source identity row and four feedrate command marker rows in fixture
  order. The parser must reject missing rows, duplicate rows, extra rows,
  unsupported evidence keys, wrong source refs, wrong fixture paths, wrong
  notes, empty required values, wrong column counts, and wrong ordering.
- **D-08:** Model accepted values with enums or equivalent typed domain values
  rather than raw strings flowing through the Rust core. Use note wrappers or
  exact note validation to preserve non-overclaiming language.
- **D-09:** Summary output should include stable traceability lines plus one
  evidence row per accepted summary row. The output must remain summary-only
  and must not include geometry counts, extrusion totals, timing, printability,
  printer-runtime, post-processing, or broad generated-output claims.

### Verification Guardrails

- **D-10:** Add focused Rust tests under `packages/slic3r-rust/crates/slic3r_flavors/tests/`
  that parse the checked-in expected G-code summary, assert exact metadata,
  assert stable summary lines, and cover the required negative cases from
  `PGSUM-03`.
- **D-11:** Update existing registry tests so `prusaslicer.gcode-output`
  appears in shared-downstream and future-candidate filters with exact
  provenance and generated-output dependency.
- **D-12:** Keep public API names non-overclaiming. Tests should fail if public
  declarations or helper names imply verified parity, runtime support, release
  behavior, generated-output execution, printer behavior, or synchronization.
- **D-13:** Update Bazel Rust targets and compile data so the new module and
  tests are verified by the repo's Rust/Bazel surfaces. A small summary binary
  may be added if it follows the existing project-file summary shape and only
  reads an explicitly provided TSV path.

### the agent's Discretion

- The agent may choose exact enum names for metadata keys, marker keys, and
  evidence values, provided they are typed, readable, and specific to the Phase
  46 summary-only contract.
- The agent may decide whether to add a `prusa_gcode_output_summary` binary in
  Phase 47 or leave executable wiring to Phase 48, as long as Phase 47 exposes
  the Rust summary function needed by future parity logic.
- The agent may refactor small shared helper shapes only if that reduces real
  duplication without broad churn. The default is to mirror
  `prusa_project_file` closely for lower risk.

### Deferred Ideas (OUT OF SCOPE)

Phase 48 owns the executable Bazel parity command, fail-closed parity mutation
guard, exact `packages/parity/status.tsv` row, and public docs/status
alignment for `fork.prusaslicer.gcode-output`.

Broader byte-for-byte G-code parity, full generated-output parity, toolpath
geometry, extrusion, timing, support, seam, arc, STEP, full 3MF, GUI,
runtime/printer behavior, firmware or printability, release builds,
network/device behavior, profile auto-update, Bambu Studio, OrcaSlicer, and
sync automation remain outside Phase 47.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PGSUM-01 | Developer can summarize the selected Prusa G-code fixture into typed Rust values for stable metadata and marker evidence before the data reaches shared parity or status publication logic. [VERIFIED: .planning/REQUIREMENTS.md] | Implement `src/prusa_gcode_output.rs` as pure typed parsing plus summary-line functions. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| PGSUM-02 | Developer can trace the Prusa G-code output capability from Rust metadata back to the accepted Prusa source identity, fixture namespace, raw fixture path, expected summary artifact, planned status token, and broad generated-output deferrals. [VERIFIED: .planning/REQUIREMENTS.md] | Add metadata constants and a registry row using `FlavorId::PrusaSlicer`, `FeatureOrigin::SharedDownstream`, `ParitySurface::generated_outputs()`, and `ChecklistStatus::FutureCandidate`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| PGSUM-03 | Developer can verify Prusa G-code summary parsing with focused Rust unit tests that reject unsupported evidence kinds, overclaiming notes, wrong source refs, wrong fixture paths, missing rows, duplicate rows, extra rows, and wrong ordering without performing Git, network, filesystem discovery, process execution, upstream source import, release, printer-runtime, profile-update, or vendor sync operations. [VERIFIED: .planning/REQUIREMENTS.md] | Add `tests/prusa_gcode_output.rs`, update `tests/flavor_registry.rs`, and wire them into Bazel `rust_test`, `rust_clippy`, and `rustfmt_test` targets. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
</phase_requirements>

## Summary

Plan Phase 47 as a close copy of the existing `prusa_project_file` pure boundary, with different accepted rows, metadata constants, and registry surface. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

The checked-in G-code expected summary has one exact seven-column header and five exact data rows: one source identity row and four feedrate marker rows. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv]

The implementation should not add Phase 48 executable parity or status publication; the reserved `fork.prusaslicer.gcode-output` token is metadata only in Phase 47. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md]

**Primary recommendation:** Add `slic3r_flavors::prusa_gcode_output` as a strict typed TSV parser and summary formatter, export it from `lib.rs`, register the capability as future-candidate generated-output metadata, and verify with focused Bazel Rust tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

## Project Constraints (from AGENTS.md)

- Read repo-local `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned Bright Builds standards before plan or implementation work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- The repo-local summary metadata rules only apply to `.planning/phases/*/*-SUMMARY.md`; this research file should not trigger summary frontmatter edits. [VERIFIED: AGENTS.md]
- Do not run `mdformat` over phase `*-SUMMARY.md` files in this repo. [VERIFIED: AGENTS.md]
- Bright Builds architecture guidance favors functional-core / imperative-shell, parsing raw input into domain types, and making illegal states unrepresentable when practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Bright Builds Rust guidance favors `foo.rs` plus `foo/` for new multi-file modules, `let...else` for guard extraction, optional internal names prefixed with `maybe_`, and invariants encoded with newtypes/enums. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Bright Builds testing guidance requires unit tests for pure/business logic, one concern per unit test, and clear Arrange/Act/Assert sections. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Bright Builds verification guidance requires relevant repo-native verification before commit and prefers repo-owned or affected-package commands when available. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- `standards-overrides.md` contains only placeholder override rows, so no active local standards exception changes this phase. [VERIFIED: standards-overrides.md]
- No `.claude/skills/` or `.agents/skills/` project skill files were found. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md`]
- The user explicitly requested no commit or push for this research artifact. [VERIFIED: user objective]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Rust crate `slic3r_flavors` | `0.1.0`, edition 2024 [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Owns flavor-specific pure metadata and parser boundaries. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs] | Existing crate already owns `prusa_profile` and `prusa_project_file` boundaries. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs] |
| Rust crate `slic3r_contracts` | Path dependency, edition 2024 [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Provides `VendorSourceRef`, `FlavorId`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Existing boundaries and registry rows already use these types for source and parity metadata. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| Rust standard library | Rust 1.94 workspace target; Bazel toolchain 1.94.1 [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel] | String parsing, vectors, enums, and formatting. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs] | No new external parser crate is needed for the fixed TSV shape. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] |
| Bazel `rules_rust` | `0.69.0` [VERIFIED: MODULE.bazel] | Builds library, binaries, Rust tests, clippy, and rustfmt targets. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | The repo uses Bazel as the top-level build/test entrypoint. [VERIFIED: .planning/PROJECT.md; MODULE.bazel] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| `packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary` | Existing Bazel alias [VERIFIED: packages/parity-fixtures/BUILD.bazel] | Compile data for Rust tests that include the checked-in expected summary. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs] | Use in `prusa_gcode_output_test` compile data. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/parity-fixtures/BUILD.bazel] |
| `include_str!` | Rust macro [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs] | Loads checked-in test fixtures and source text at compile time. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs] | Use for expected TSV and public-surface guard tests. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Exact local TSV parsing with `split('\t')` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs] | Add `csv` or another TSV parser crate [ASSUMED] | Do not add a dependency for this fixed, closed five-row artifact; the existing project-file parser proves the local strict parser pattern. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] |
| Leave executable wrapper to Phase 48 [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Add `src/bin/prusa_gcode_output_summary.rs` in Phase 47 [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Recommended default is to skip the binary in Phase 47 because PGSUM requires the pure boundary and Phase 48 owns executable parity. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

**Installation:**

```bash
# No package installation is recommended for Phase 47.
```

No npm package version verification applies because this phase adds no npm packages. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

No new Rust crate version verification applies because this phase should use only existing workspace crates and `std`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
├── src/
│   ├── lib.rs                  # export prusa_gcode_output [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs]
│   ├── prusa_gcode_output.rs   # new pure typed summary boundary [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
│   └── registry.rs             # add capability metadata [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]
├── tests/
│   ├── prusa_gcode_output.rs   # new parser and summary tests [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
│   └── flavor_registry.rs      # update registry expectations [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]
└── BUILD.bazel                 # add src, tests, compile_data, clippy, rustfmt wiring [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]
```

### Recommended Plan Decomposition

| Plan | Scope | Files |
|------|-------|-------|
| 47-01 | Add pure `prusa_gcode_output` domain types, constants, parser, summary output, and parser tests. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | `src/prusa_gcode_output.rs`, `src/lib.rs`, `tests/prusa_gcode_output.rs`, `BUILD.bazel` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| 47-02 | Add registry capability metadata and update registry tests for shared-downstream, future-candidate, provenance, and generated-output dependency. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | `src/registry.rs`, `tests/flavor_registry.rs` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] |
| 47-03 | Run Rust/Bazel verification, review non-overclaiming public API names, and decide whether to defer the optional summary binary to Phase 48. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | `BUILD.bazel`, optional `src/bin/prusa_gcode_output_summary.rs` only if the planner explicitly wants it. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs] |

### Pattern 1: Pure Fail-Closed Boundary

**What:** Parse a caller-provided TSV string into typed values and return either typed summary rows or a typed parse error. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**When to use:** Use for the Phase 46 `expected-gcode-summary.tsv` and no other input source in Phase 47. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Example:**

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs
pub fn parse_prusa_gcode_output_summary(input: &str) -> PrusaGcodeOutputParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaGcodeOutputParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_header(header)?;
    // Continue with exact row parsing, duplicate detection, order checks, and missing-row checks.
}
```

### Pattern 2: Domain Enums for Accepted Evidence

**What:** Represent accepted `metadata_key`, `metadata_value`, `marker_key`, `marker_value`, and notes as enums or wrappers after parsing. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**When to use:** Use for all five accepted rows so raw strings do not leak through the Rust core. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Recommended enum surfaces:** `PrusaGcodeOutputMetadataKey`, `PrusaGcodeOutputMetadataValue`, `PrusaGcodeOutputMarkerKey`, `PrusaGcodeOutputMarkerValue`, and `PrusaGcodeOutputNote`. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; CITED: Bright Builds Rust invariant guidance]

### Pattern 3: Summary Lines Stay Traceable and Narrow

**What:** Emit traceability lines plus one `evidence_row` per accepted row. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**Recommended evidence row shape:** `evidence_row\t{metadata_key}\t{metadata_value}\t{marker_key}\t{marker_value}\t{notes}`. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Why include notes:** Phase 47 must preserve non-overclaiming note evidence, and the G-code expected summary notes are part of the accepted row set. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv]

### Anti-Patterns to Avoid

- Do not trim or normalize TSV values; exact strings should fail closed when they drift. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]
- Do not parse fixture provenance in this Rust module; provenance remains fixture-surface metadata and Phase 47 metadata constants should point to it indirectly through fixture paths and source refs. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
- Do not scan all source text for words like `runtime` or `generated-output`, because accepted notes intentionally contain deferred-scope words; scan public declarations and imports instead. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]
- Do not add `fork.prusaslicer.gcode-output` to `packages/parity/status.tsv` in Phase 47. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; `rg "fork\\.prusaslicer\\.gcode-output" packages/parity packages/slic3r-rust/crates/slic3r_flavors -n`]
- Do not use the Phase 45 scope record's broad inventory source path as the Phase 47 metadata `source_path`; Phase 47 context requires `tests/fff_print/test_gcodewriter.cpp`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Source identity parsing | Custom source-ref string parser in `slic3r_flavors` [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | `VendorSourceRef::prusa_slicer_version_2_9_5()` [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Existing contract type already represents the accepted Prusa source pin. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| Parity dependency strings | Raw `"generated-outputs"` strings in registry rows [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] | `ParitySurface::generated_outputs()` [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Existing registry stores typed `ParitySurface` slices. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| Registry framework | New dynamic registry or TSV loader [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] | Existing static `FlavorCapability` arrays [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] | The registry is intentionally pure static metadata with no runtime I/O. [VERIFIED: .planning/PROJECT.md; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs] |
| G-code behavior interpretation | Motion, extrusion, timing, printability, or geometry parser [VERIFIED: .planning/REQUIREMENTS.md] | Exact marker enum values for `G1 F99999.123`, `G1 F1`, `G1 F203.2`, and `G1 F203.201` [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv] | Phase 47 proves marker evidence only, not generated-output behavior. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| Executable parity command | `//packages/parity:prusaslicer_gcode_output_parity` in Phase 47 [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Pure library API and tests [VERIFIED: .planning/REQUIREMENTS.md] | Phase 48 owns executable parity and status publication. [VERIFIED: .planning/ROADMAP.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

**Key insight:** The hard part is not parsing TSV; the hard part is preserving exact evidence boundaries without letting type names, notes, registry rows, or summary lines imply broad generated-output parity. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]

## Common Pitfalls

### Pitfall 1: Overclaiming Through Public Names

**What goes wrong:** Public names imply verified parity, runtime support, generated-output execution, release behavior, printer behavior, or synchronization. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Why it happens:** The capability is related to G-code output, but Phase 47 only models a source-pinned summary artifact. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md]

**How to avoid:** Use names like `PrusaGcodeOutputSummary`, `PrusaGcodeOutputMarkerValue`, and `prusa_gcode_output_metadata`; avoid names containing `verified`, `runtime`, `execute`, `printer`, `release`, or broad parity wording. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Warning signs:** A public declaration says `supported`, `verified`, `runtime`, `execution`, `printer`, `release`, or `sync`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

### Pitfall 2: Exact Row Set Drift

**What goes wrong:** The parser accepts an extra marker, missing row, duplicate row, changed note, changed fixture path, or out-of-order row. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Why it happens:** A generic TSV parser would validate shape but not the Phase 46 evidence contract. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**How to avoid:** Store a private `EXPECTED_ROWS` array and compare parsed row keys for duplicate, missing, extra, and order errors. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**Warning signs:** Tests assert only row count or only successful parsing. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]

### Pitfall 3: Source Path Confusion

**What goes wrong:** The Rust metadata uses `src/libslic3r/GCode.cpp` instead of the Phase 47 required fixture source path `tests/fff_print/test_gcodewriter.cpp`. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Why it happens:** The scope gate records the inventory row source, while Phase 46 provenance and Phase 47 metadata point to the upstream test literal source for the selected fixture. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**How to avoid:** Put `PRUSA_GCODE_OUTPUT_SOURCE_PATH` at exactly `tests/fff_print/test_gcodewriter.cpp` and keep `source_literal` row value at `tests/fff_print/test_gcodewriter.cpp#L20-L35`. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv]

**Warning signs:** Metadata tests pass against the scope record but fail against fixture provenance or the Phase 47 context. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

### Pitfall 4: Side Effects Sneak Into the Boundary

**What goes wrong:** The module reads files, discovers fixtures, runs Git, invokes a process, fetches network data, imports upstream source, or generates G-code. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**Why it happens:** Existing summary binaries perform filesystem reads, but the module itself must stay data-in/data-out. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

**How to avoid:** Put all parsing in `parse_prusa_gcode_output_summary(input: &str)` and keep any optional binary as a thin adapter only if Phase 47 intentionally adds it. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs]

**Warning signs:** `src/prusa_gcode_output.rs` imports `std::fs`, `std::env`, `std::process`, networking, or path discovery APIs. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

### Pitfall 5: Direct Cargo Verification May Use the Wrong Toolchain

**What goes wrong:** Direct `cargo` commands may fail locally because the workspace declares Rust `1.94` while local `rustc` and `cargo` report `1.91.1`. [VERIFIED: packages/slic3r-rust/Cargo.toml; `rustc --version`; `cargo --version`]

**Why it happens:** Bazel is configured with a hermetic Rust `1.94.1` toolchain, but the shell `cargo`/`rustc` currently point to `1.91.1`. [VERIFIED: MODULE.bazel; `rustc --version`; `cargo --version`]

**How to avoid:** Use Bazel targets for phase verification and update/select a local Rust 1.94+ toolchain before relying on direct Cargo pre-commit checks. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml]

**Warning signs:** `cargo test`, `cargo clippy`, or `cargo build` errors before compiling crate code because `rust-version` is newer than local `rustc`. [VERIFIED: packages/slic3r-rust/Cargo.toml; `rustc --version`]

## Code Examples

Verified patterns from local sources:

### Metadata Constants and Metadata Function

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs
pub(crate) const PRUSA_GCODE_OUTPUT_INVENTORY_ID: &str = "prusaslicer.gcode-output";
pub(crate) const PRUSA_GCODE_OUTPUT_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_PATH: &str = "tests/fff_print/test_gcodewriter.cpp";

pub const fn prusa_gcode_output_metadata() -> PrusaGcodeOutputMetadata {
    PrusaGcodeOutputMetadata {
        inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
        vendor_id: PRUSA_GCODE_OUTPUT_VENDOR_ID,
        flavor_id: FlavorId::PrusaSlicer,
        origin: FeatureOrigin::SharedDownstream,
        parity_dependency: ParitySurface::generated_outputs(),
        checklist_status: ChecklistStatus::FutureCandidate,
        source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
        source_path: PRUSA_GCODE_OUTPUT_SOURCE_PATH,
        fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        expected_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_SUMMARY_PATH,
        scope_record_path: PRUSA_GCODE_OUTPUT_SCOPE_RECORD_PATH,
        reserved_future_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
    }
}
```

### Accepted Row Key Pattern

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaGcodeOutputRowKey {
    metadata_key: PrusaGcodeOutputMetadataKey,
    metadata_value: PrusaGcodeOutputMetadataValue,
    marker_key: PrusaGcodeOutputMarkerKey,
    marker_value: PrusaGcodeOutputMarkerValue,
}

fn validate_missing_rows(
    row_keys: &[PrusaGcodeOutputRowKey],
) -> Result<(), PrusaGcodeOutputParseError> {
    for expected_row in EXPECTED_ROWS {
        let row_key = PrusaGcodeOutputRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputParseError::MissingRow {
                metadata_key: expected_row.metadata_key,
                marker_key: expected_row.marker_key,
            });
        }
    }
    Ok(())
}
```

### Registry Addition Pattern

```rust
// Source pattern: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs
static PRUSA_GCODE_OUTPUT_PATHS: [&str; 1] = [PRUSA_GCODE_OUTPUT_SOURCE_PATH];
static PRUSA_GCODE_OUTPUT_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
    vendor_source: PRUSA_GCODE_OUTPUT_SOURCE_REF,
    source_paths: &PRUSA_GCODE_OUTPUT_PATHS,
    ownership: FeatureOrigin::SharedDownstream,
}];
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Phase 45 scope text reserved a future Rust boundary and no Rust implementation existed. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md] | Phase 47 should add the pure Rust typed boundary. [VERIFIED: .planning/ROADMAP.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Phase 47 planning date 2026-06-14. [VERIFIED: current_date; .planning/STATE.md] | Developers get typed summary values before Phase 48 status publication. [VERIFIED: .planning/REQUIREMENTS.md] |
| Phase 46 checked in fixture bytes and expected summary only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md] | Phase 47 should consume only the expected summary string and fixture metadata constants. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Phase 46 completed 2026-06-13. [VERIFIED: .planning/ROADMAP.md; .planning/PROJECT.md] | Rust parsing remains side-effect-free and does not generate G-code. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| The registry shared-downstream filter currently returns only `prusaslicer.project-file`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] | Add `prusaslicer.gcode-output` as a second shared-downstream Prusa capability. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Phase 47. [VERIFIED: .planning/ROADMAP.md] | Registry tests must update exact filter expectations and provenance assertions. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs] |

**Deprecated/outdated:**

- Treating the Phase 45 `src/libslic3r/GCode.cpp` scope source as the Phase 47 fixture source path is outdated for this Rust metadata function. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
- Publishing `fork.prusaslicer.gcode-output` before executable evidence is out of scope for Phase 47. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | A `csv` or another TSV parser crate could be used as an alternative to exact local TSV parsing. [ASSUMED] | Standard Stack / Alternatives Considered | Low; the recommendation is still to avoid the dependency and mirror the existing local parser. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] |
| A2 | Source or fixture spoofing maps to STRIDE Spoofing / Tampering. [ASSUMED] | Security Domain | Low; the mitigation is independently required by PGSUM-03 regardless of STRIDE label. [VERIFIED: .planning/REQUIREMENTS.md] |
| A3 | Evidence overclaiming maps to STRIDE Repudiation / Tampering. [ASSUMED] | Security Domain | Low; exact note validation and public-name guards are required by Phase 47 context regardless of STRIDE label. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| A4 | Side-effect injection through parser expansion maps to STRIDE Tampering / Elevation of Privilege. [ASSUMED] | Security Domain | Low; the phase explicitly requires a side-effect-free data-in/data-out module regardless of STRIDE label. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

## Open Questions (RESOLVED)

1. **Should Phase 47 add a summary binary?** [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
   - What we know: The context allows a small binary if it only reads an explicitly provided TSV path. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
   - What's unclear: Phase 47 requirements do not require an executable wrapper. [VERIFIED: .planning/REQUIREMENTS.md]
   - RESOLVED: Defer the binary to Phase 48. Phase 47 plans the pure Rust boundary, tests, registry metadata, and verifier reconciliation only. [VERIFIED: .planning/ROADMAP.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]
2. **Should direct Cargo checks be part of Phase 47 verification?** [VERIFIED: packages/slic3r-rust/Cargo.toml; `cargo --version`]
   - What we know: Bazel is available and configured with Rust 1.94.1; local Cargo/Rust are 1.91.1. [VERIFIED: `bazel --version`; MODULE.bazel; `cargo --version`; `rustc --version`]
   - What's unclear: The executor may have a rustup toolchain override available outside the shell probe. [VERIFIED: environment probe scope]
   - RESOLVED: Treat Bazel verification as mandatory for Phase 47. Direct Cargo verification is optional only after selecting Rust 1.94+ because the shell `cargo`/`rustc` probes are below the workspace `rust-version`. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Rust/Bazel build and test targets [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | yes [VERIFIED: `bazel --version`] | 8.6.0 [VERIFIED: `bazel --version`] | None needed. [VERIFIED: environment probe] |
| `rules_rust` | Bazel Rust rules [VERIFIED: MODULE.bazel] | configured [VERIFIED: MODULE.bazel] | 0.69.0 [VERIFIED: MODULE.bazel] | None needed unless Bazel module download fails. [VERIFIED: MODULE.bazel] |
| Bazel Rust toolchain | Bazel Rust build/test [VERIFIED: MODULE.bazel] | configured, not build-probed [VERIFIED: MODULE.bazel] | 1.94.1 [VERIFIED: MODULE.bazel] | Run Bazel with network/module cache available if the toolchain is not already downloaded. [VERIFIED: MODULE.bazel] |
| Cargo | Optional direct Rust checks [VERIFIED: Bright Builds Rust verification guidance] | yes, but older than workspace requirement [VERIFIED: `cargo --version`; packages/slic3r-rust/Cargo.toml] | 1.91.1 [VERIFIED: `cargo --version`] | Use Bazel targets or select Rust 1.94+. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml] |
| rustc | Optional direct Rust checks [VERIFIED: Bright Builds Rust verification guidance] | yes, but older than workspace requirement [VERIFIED: `rustc --version`; packages/slic3r-rust/Cargo.toml] | 1.91.1 [VERIFIED: `rustc --version`] | Use Bazel toolchain or select Rust 1.94+. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml] |
| rustfmt | Optional direct formatting checks [VERIFIED: Bright Builds Rust verification guidance] | yes, but older than Bazel toolchain [VERIFIED: `rustfmt --version`; MODULE.bazel] | 1.8.0-stable from rustc 1.91.1 [VERIFIED: `rustfmt --version`] | Use `bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| cargo-clippy | Optional direct lint checks [VERIFIED: Bright Builds Rust verification guidance] | yes, but older than workspace requirement [VERIFIED: `cargo clippy --version`; packages/slic3r-rust/Cargo.toml] | 0.1.91 [VERIFIED: `cargo clippy --version`] | Use `bazel test //packages/slic3r-rust/crates/slic3r_flavors:clippy`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Git | Absence/status checks only [VERIFIED: AGENTS.md] | yes [VERIFIED: `git --version`] | 2.53.0 [VERIFIED: `git --version`] | None needed. [VERIFIED: environment probe] |

**Missing dependencies with no fallback:**

- None for research and planning. [VERIFIED: environment probe]

**Missing dependencies with fallback:**

- Direct Cargo verification is toolchain-blocked until Rust 1.94+ is selected; Bazel is the repo-native fallback for Phase 47 verification. [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel; `rustc --version`]

## Recommended Verification Commands

Run these after implementation and before any commit. [VERIFIED: AGENTS.md; Bright Builds verification standard]

```bash
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test
bazel test //packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test
bazel test //packages/slic3r-rust/crates/slic3r_flavors:clippy
bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check
```

If the optional binary is added, include it in `clippy` and `rustfmt_check` target lists. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md]

If a commit workflow requires direct Cargo checks, select Rust 1.94+ first and then run the repo-relevant Cargo commands from `packages/slic3r-rust`. [VERIFIED: packages/slic3r-rust/Cargo.toml; `rustc --version`; AGENTS.md]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json; GSD researcher instructions]

The current OWASP ASVS stable version is 5.0.0, and OWASP recommends versioned requirement references because identifiers can change. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

The table below uses the project research template's security-domain labels as planning shorthand, not versioned ASVS 5.0.0 requirement IDs. [VERIFIED: GSD researcher instructions; CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| Authentication | no [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | No auth surface is introduced. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| Session Management | no [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | No session surface is introduced. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| Access Control | no [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | No permission or user boundary is introduced. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| Input Validation | yes [VERIFIED: .planning/REQUIREMENTS.md] | Exact header, column count, non-empty values, typed enums, note validation, duplicate/missing/extra/order checks. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; .planning/REQUIREMENTS.md] |
| Cryptography | no [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Use the existing fixture SHA-256 as provenance only; do not add cryptographic behavior. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

### Known Threat Patterns for This Phase

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Source or fixture spoofing through changed TSV values [VERIFIED: .planning/REQUIREMENTS.md] | Spoofing / Tampering [ASSUMED] | Reject wrong source refs and fixture paths with typed parse errors. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; .planning/REQUIREMENTS.md] |
| Evidence overclaiming through notes or public names [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Repudiation / Tampering [ASSUMED] | Validate exact notes and scan public declarations for forbidden broad-claim names. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |
| Side-effect injection through parser expansion [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] | Tampering / Elevation of Privilege [ASSUMED] | Keep the module data-in/data-out and test or review imports for no filesystem, Git, process, network, source import, status mutation, or G-code generation. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md` - locked Phase 47 implementation decisions, deferrals, and required canonical refs. [VERIFIED: cat]
- `.planning/ROADMAP.md` - Phase 47 goal, dependency, success criteria, and Phase 48 boundary. [VERIFIED: cat]
- `.planning/REQUIREMENTS.md` - PGSUM-01, PGSUM-02, PGSUM-03, and v1.12 out-of-scope list. [VERIFIED: cat]
- `.planning/STATE.md` and `.planning/PROJECT.md` - milestone state, evidence ladder, and current Phase 47 focus. [VERIFIED: cat]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and `bright-builds-rules.audit.md` - repo-local workflow constraints and Bright Builds pin. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs` - closest Rust parser/metadata/summary-line pattern. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs` - closest positive, negative, and public-name tests. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` and `tests/flavor_registry.rs` - capability registry and test update pattern. [VERIFIED: cat]
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` and `packages/parity-fixtures/BUILD.bazel` - Bazel Rust and fixture alias wiring. [VERIFIED: cat]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`, `fixture-provenance.tsv`, and `README.md` - accepted G-code rows, source traceability, and non-overclaiming boundary. [VERIFIED: cat]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - Phase 45 scope gate, planned Rust boundary, planned status token, and deferrals. [VERIFIED: cat]
- `MODULE.bazel` and `packages/slic3r-rust/Cargo.toml` - Bazel Rust toolchain, `rules_rust`, workspace edition, and Rust version requirement. [VERIFIED: cat]

### Secondary (MEDIUM confidence)

- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: architecture, code shape, verification, testing, and Rust guidance. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- OWASP ASVS project page for current stable version and versioned reference guidance. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Tertiary (LOW confidence)

- None. [VERIFIED: this file]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - existing workspace crates, Bazel files, and module pin verified locally. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; MODULE.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]
- Architecture: HIGH - Phase 47 explicitly requires mirroring `prusa_project_file`, and that pattern was read in source and tests. [VERIFIED: .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]
- Pitfalls: HIGH - required negative cases and out-of-scope boundaries are explicit in requirements, context, fixture docs, and existing tests. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]
- Environment: MEDIUM - CLI versions were probed, but Bazel Rust toolchain download/build was not executed during research. [VERIFIED: `bazel --version`; `rustc --version`; MODULE.bazel]

**Research date:** 2026-06-14 [VERIFIED: current_date]
**Valid until:** 2026-07-14 for codebase planning assumptions, or earlier if Phase 46 fixture rows or `slic3r_flavors` registry shape changes. [VERIFIED: current_date; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs]

## RESEARCH COMPLETE
