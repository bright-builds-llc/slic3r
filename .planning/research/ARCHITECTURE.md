# Architecture Research

**Domain:** v1.12 PrusaSlicer G-code output evidence slice for the Slic3r Rust port
**Researched:** 2026-06-06
**Confidence:** HIGH

## Standard Architecture

### System Overview

The v1.12 slice should extend the existing Prusa evidence ladder, not create a
new generated-output subsystem. The architecture stays fixture-first, keeps
domain logic in pure Rust, and lets Bazel/shell own file, process, and status
publication.

```text
+--------------------------------------------------------------------+
| Maintainer Scope Gate                                              |
| packages/prusa-gcode-output-scope                                  |
| - selected source identity and fixture decision                     |
| - expected summary contract                                         |
| - reserved status token and deferred-scope wording                  |
+--------------------------------------------------------------------+
| Fixture Evidence                                                   |
| packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output |
| - one reviewed Prusa-generated .gcode fixture                       |
| - fixture-provenance.tsv                                            |
| - expected-gcode-summary.tsv                                        |
| - fail-closed fixture verifier                                      |
+--------------------------------------------------------------------+
| Pure Rust Core                                                     |
| packages/slic3r-rust/crates/slic3r_flavors                         |
| - prusa_gcode_output typed domain values                            |
| - raw G-code marker/metadata summarizer                             |
| - expected-summary parser/renderer                                  |
| - metadata traceability and unit tests                              |
+--------------------------------------------------------------------+
| Thin Imperative Shell                                               |
| packages/parity                                                     |
| - compare_prusaslicer_gcode_output.sh                               |
| - bazel run //packages/parity:prusaslicer_gcode_output_parity       |
| - mutation failure test                                             |
| - exact fork.prusaslicer.gcode-output status row                    |
+--------------------------------------------------------------------+
| Documentation                                                       |
| docs/port and package READMEs                                       |
| - evidence route and commands                                       |
| - exact verified scope                                              |
| - explicit generated-output/runtime/geometry deferrals              |
+--------------------------------------------------------------------+
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Scope package | Locks the evidence contract before fixture bytes, Rust code, parity command, or status publication exist. | New `packages/prusa-gcode-output-scope` Bazel package with `gcode-output-scope.md`, README, verifier, and verifier test. |
| Fixture namespace | Owns static Prusa-generated G-code fixture bytes, provenance, update route, expected summary, and local fixture verification. | New `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` namespace plus aliases, bundle, verifier, and tests in `packages/parity-fixtures/BUILD.bazel`. |
| Rust summary boundary | Parses raw G-code text into typed metadata/marker evidence and renders summary-only output. It must not validate motion, geometry, printer runtime, timing, or firmware execution. | New `slic3r_flavors::prusa_gcode_output` module, binary, and tests wired in `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`. |
| Flavor registry metadata | Makes the new evidence slice discoverable as a Prusa capability with `generated-outputs` as a dependency, without marking broad generated output as verified. | Modify `src/registry.rs` and `src/lib.rs`; no change to `slic3r_core`. |
| Parity command | Runs the Rust summary binary against the checked-in fixture, diffs against `expected-gcode-summary.tsv`, validates row count/status wording, and fails on mutation. | New `packages/parity/compare_prusaslicer_gcode_output.sh`, failure test, Bazel target, and exact row in `packages/parity/status.tsv`. |
| Port docs | Explain the command, package ownership, and non-overclaiming scope. | Modify `docs/port/README.md`, `package-map.md`, `migration-guidance.md`, `parity-matrix.md`, and likely `contract-inventory.md`. |

## Recommended Project Structure

```text
packages/
+-- prusa-gcode-output-scope/
|   +-- BUILD.bazel
|   +-- README.md
|   +-- gcode-output-scope.md
|   +-- verify_prusa_gcode_output_scope.sh
|   +-- verify_prusa_gcode_output_scope_test.sh
+-- parity-fixtures/
|   +-- BUILD.bazel
|   +-- verify_prusa_gcode_output_fixture.sh
|   +-- verify_prusa_gcode_output_fixture_test.sh
|   +-- forks/prusaslicer/prusaslicer.gcode-output/
|       +-- .gitattributes
|       +-- README.md
|       +-- fixture-provenance.tsv
|       +-- expected-gcode-summary.tsv
|       +-- <reviewed-prusa-fixture>.gcode
+-- slic3r-rust/crates/slic3r_flavors/
|   +-- BUILD.bazel
|   +-- src/lib.rs
|   +-- src/registry.rs
|   +-- src/prusa_gcode_output.rs
|   +-- src/bin/prusa_gcode_output_summary.rs
|   +-- tests/prusa_gcode_output.rs
+-- parity/
    +-- BUILD.bazel
    +-- status.tsv
    +-- compare_prusaslicer_gcode_output.sh
    +-- compare_prusaslicer_gcode_output_test.sh
```

### Structure Rationale

- **`packages/prusa-gcode-output-scope/`:** v1.11 proved that a separate scope
  package prevents accidental expansion. Use the same pattern for generated
  output because this is the riskiest wording surface.
- **`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`:**
  keep this separate from `export-workflows/expected-gcode.txt`. The existing
  export fixture is Rust-generated base CLI evidence, not a reviewed
  PrusaSlicer-generated fixture.
- **`slic3r_flavors::prusa_gcode_output`:** this crate already owns fork flavor
  metadata and pure Prusa summary boundaries. Do not place Prusa-specific
  summary parsing in `slic3r_core`.
- **`packages/parity`:** this package is the only owner of public parity
  commands and status rows. The new row must not update the broad
  `generated-outputs` row to `verified`.

## Architectural Patterns

### Pattern 1: Scope-First Evidence Gate

**What:** Create a reviewed scope record before adding fixture bytes, Rust
parsing, parity targets, or status rows.

**When to use:** Use this for v1.12 because G-code output wording can easily
turn into broad generated-output, geometry, firmware, printer-runtime, or GUI
claims.

**Trade-offs:** Adds one small package and verifier, but it creates a clean
phase boundary and gives later verifiers exact text to enforce.

**Recommended contract fields:**

```text
Inventory or stable slice token: prusaslicer.gcode-output
Accepted source identity: prusaslicer:version_2.9.5@...
Fixture source decision: one reviewed Prusa-generated .gcode fixture
Expected artifact: expected-gcode-summary.tsv
Candidate Rust boundary: slic3r_flavors::prusa_gcode_output
Planned command: bazel run //packages/parity:prusaslicer_gcode_output_parity
Planned status token: fork.prusaslicer.gcode-output
Deferred scope: full generated-output parity, geometry, printer runtime, GUI, support generation, arc fitting, wall seam behavior, network/device, profile auto-update, fork release, sync
```

### Pattern 2: Summary-Only Fixture Evidence

**What:** Check in a small raw `.gcode` fixture and a stable summary artifact.
The expected artifact should summarize only whitelisted metadata and marker
evidence, such as fixture identity, source ref, selected generated-by markers,
stable header/footer markers, and row-level deferral notes.

**When to use:** Use this instead of full G-code diffing. Full line-by-line
G-code diffs would imply content parity and would be brittle across harmless
metadata, time, and numeric changes.

**Trade-offs:** Proves less than a full output comparison by design. That is the
right trade-off for v1.12 because the milestone goal is evidence plumbing, not
PrusaSlicer output parity.

**Suggested expected summary shape:**

```text
source_ref	fixture_path	marker_key	marker_value	deferred_semantics	notes
prusaslicer:version_2.9.5@...	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/<fixture>.gcode	generated_by	PrusaSlicer-...	metadata-marker-only	Generated-by marker only; no runtime or content parity claimed.
```

Use exact row ordering and exact notes. The verifier should fail on duplicate,
missing, reordered, unsupported, or semantically overbroad rows.

### Pattern 3: Pure Rust Summary Boundary With Thin CLI

**What:** Put all interpretation in pure functions that accept `&str` and
return typed values. The binary only reads a file path and prints normalized
summary lines.

**When to use:** Use this for `prusa_gcode_output` because G-code marker
selection and deferral semantics are domain rules, while file reads and stdout
are shell concerns.

**Example:**

```rust
pub fn summarize_prusa_gcode_output(
    input: &str,
) -> Result<PrusaGcodeOutputSummary, PrusaGcodeOutputParseError>;

pub fn parse_prusa_gcode_output_expected_summary(
    input: &str,
) -> Result<PrusaGcodeOutputSummary, PrusaGcodeOutputParseError>;

pub fn prusa_gcode_output_summary_lines(
    summary: &PrusaGcodeOutputSummary,
) -> Vec<String>;
```

The CLI should stay as small as the existing
`src/bin/prusa_project_file_summary.rs`: parse args, read the file, call the
pure boundary, print lines, and exit non-zero on typed errors.

## Data Flow

### Evidence Flow

```text
Reviewed v1.12 scope record
    |
    v
Source-pinned Prusa-generated G-code fixture
    |
    v
Fixture verifier checks bytes, hash, provenance, README scope, marker presence
    |
    v
Rust summary binary reads raw fixture and calls pure summary boundary
    |
    v
Typed Rust summary renders normalized summary-only TSV
    |
    v
Parity comparator diffs actual summary against expected-gcode-summary.tsv
    |
    v
Mutation guard proves drift fails closed
    |
    v
packages/parity/status.tsv publishes one exact verified row
    |
    v
docs/port explain exact scope and deferred surfaces
```

### State Management

There is no runtime state. The evidence state is checked-in data:

```text
scope record + fixture provenance + raw fixture + expected summary + status row
```

The Rust crate should not perform Git, network, filesystem discovery, process
execution, upstream source fetching, profile auto-update execution, printer
communication, or generated-output creation.

### Key Data Flows

1. **Scope to fixture:** the scope verifier defines the accepted source,
   fixture source decision, expected summary columns, planned command, planned
   status token, and required deferral terms.
1. **Fixture to Rust:** the fixture verifier proves the selected raw G-code
   file exists and contains the whitelisted stable markers; the Rust binary
   consumes the raw text only after fixture verification has locked the surface.
1. **Rust to parity:** the summary binary emits a deterministic TSV summary;
   the parity script compares it to the checked-in expected artifact and fails
   with a useful first-mismatch label.
1. **Parity to docs/status:** only the final phase may add
   `fork.prusaslicer.gcode-output` as `verified`; docs must keep the broad
   `generated-outputs` surface `in progress` or explicitly deferred.

## Build Order

1. **Phase 45: Prusa G-code Output Scope Gate**

   - New package: `packages/prusa-gcode-output-scope`.
   - Decide whether to add a distinct `prusaslicer.gcode-output` inventory row
     or record an inventory-derived stable slug in the scope gate. Prefer adding
     the row if the status token will be `fork.prusaslicer.gcode-output`.
   - Verify no fixture, Rust parser, parity target, or status row exists yet.
   - Docs touched only to route the future package and deferrals.

1. **Phase 46: Prusa G-code Fixture Surface**

   - Add the fixture namespace and expected summary artifact under
     `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
   - Modify `packages/parity-fixtures/BUILD.bazel` with aliases, bundle,
     verifier, test, and `package_boundary` entries.
   - Verifier checks provenance, byte count, SHA-256, line endings, exact
     expected summary header/rows, marker presence, update route, and
     non-overclaiming README text.
   - No Rust boundary, public parity command, or verified status row yet.

1. **Phase 47: Rust Prusa G-code Summary Boundary**

   - Add `src/prusa_gcode_output.rs`, `src/bin/prusa_gcode_output_summary.rs`,
     and `tests/prusa_gcode_output.rs`.
   - Modify `src/lib.rs`, `src/registry.rs`, and
     `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`.
   - Registry capability should depend on `ParitySurface::generated_outputs()`
     but remain a narrow Prusa capability. Do not mark the broad
     `generated-outputs` status row verified.
   - Tests must cover valid summary output, metadata traceability, missing
     marker, duplicate marker, unsupported marker, reordered expected row, and
     wording that attempts a semantic claim.

1. **Phase 48: Executable G-code Evidence Parity**

   - Add `compare_prusaslicer_gcode_output.sh` and failure test.
   - Modify `packages/parity/BUILD.bazel` with
     `prusaslicer_gcode_output_parity` and
     `prusaslicer_gcode_output_parity_failure_test`.
   - Add exactly one `packages/parity/status.tsv` row:
     `fork.prusaslicer.gcode-output`, `verified`,
     `//packages/parity:prusaslicer_gcode_output_parity`, with notes that name
     the narrow summary-only metadata/marker evidence slice and explicitly
     defer full generated-output, geometry, printer-runtime, GUI, support,
     arc-fitting, wall-seam, network/device, profile auto-update, fork release,
     Bambu, Orca, upstream source import, and sync surfaces.
   - Update `docs/port/*` and package READMEs in the same change.

## Scaling Considerations

| Evidence Scale | Architecture Adjustments |
|----------------|--------------------------|
| One v1.12 fixture | Keep one module, one binary, one expected summary, one parity command. Avoid generic generated-output frameworks. |
| Several Prusa G-code marker fixtures | Make the Rust parser table-driven over fixture metadata, but keep the same `prusa_gcode_output` boundary and one command if the scope is still marker-only. |
| Full generated-output parity | Requires a separate milestone and architecture. It would need generation inputs, oracle policy, numeric tolerance rules, geometry/runtime ownership, and likely more than `slic3r_flavors`. Do not prepare that in v1.12. |

### Scaling Priorities

1. **First bottleneck:** evidence wording drift. Prevent it with exact verifier
   text and exact status row checks before adding more fixtures.
1. **Second bottleneck:** marker-summary duplication. If more fixtures arrive,
   extract shared row parsing inside `prusa_gcode_output.rs`, not into shell.
1. **Third bottleneck:** broad output claims. Keep broad generated-output
   parity behind a future roadmap decision.

## Anti-Patterns

### Anti-Pattern 1: Reusing `export-workflows/expected-gcode.txt`

**What people do:** Treat the existing base Rust export fixture as PrusaSlicer
G-code output evidence.

**Why it is wrong:** That file is a scoped Rust CLI export fixture, not a
reviewed Prusa-generated fixture with Prusa source provenance.

**Do this instead:** Add a dedicated Prusa fixture namespace with source
identity, SHA-256, update route, and expected summary.

### Anti-Pattern 2: Full G-code Diff as v1.12 Evidence

**What people do:** Diff every line of a generated G-code output and call the
slice verified.

**Why it is wrong:** It implies geometry, motion, print-time, firmware, and
runtime parity, which the milestone explicitly excludes.

**Do this instead:** Diff a summary-only artifact that names stable metadata
and marker evidence, with notes that say what is not claimed.

### Anti-Pattern 3: Shell-Owned Domain Parsing

**What people do:** Put marker interpretation, row validation, and deferral
semantics into `compare_prusaslicer_gcode_output.sh`.

**Why it is wrong:** It violates the existing pure Rust core and thin shell
pattern, and makes unit testing harder.

**Do this instead:** Keep shell scripts to file checks, command execution,
temporary directories, and `diff`; put parsing and domain validation in Rust.

### Anti-Pattern 4: Updating Broad `generated-outputs` to `verified`

**What people do:** Mark the broad generated-output status row verified after
the narrow Prusa marker slice passes.

**Why it is wrong:** The new evidence does not prove geometry, content,
support, arc fitting, wall seam behavior, printer runtime, or generated output
parity.

**Do this instead:** Add one exact fork row and leave broad generated-output
status scoped to the existing state.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| PrusaSlicer upstream source | Static source-pinned fixture reference only. | No Git clone, no network fetch, no branch-head sync, no upstream source import during verification. |
| Bazel | Public commands and test targets. | Use existing `sh_binary`, `sh_test`, `rust_binary`, `rust_test`, `rust_clippy`, and `rustfmt_test` patterns. |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Scope package to fixture package | Checked-in markdown contract and verifier-enforced text. | Fixture phase must reference the scope record and fail if the source decision or deferral language drifts. |
| Fixture package to Rust crate | Raw fixture path and expected summary path exposed as Bazel data/compile data. | Rust pure functions receive text, not paths; the binary is the only Rust file reader. |
| Rust crate to parity package | Bazel `rust_binary` label passed as data to a shell comparator. | Comparator should not parse G-code semantics beyond invoking the Rust binary and diffing summaries. |
| Registry to docs/status | Shared constants and exact status token. | Registry metadata is discoverability, not executable proof. Status row waits until parity command exists. |
| Docs to status | Exact scope language and command references. | Docs must state that broad generated-output parity remains deferred. |

## Specific File Impact

### New Components

| File or Module | Purpose |
|----------------|---------|
| `packages/prusa-gcode-output-scope/BUILD.bazel` | Bazel wrapper for the scope verifier and package boundary. |
| `packages/prusa-gcode-output-scope/README.md` | Maintainer-facing scope gate usage and explicit non-parity warning. |
| `packages/prusa-gcode-output-scope/gcode-output-scope.md` | Reviewed source identity, fixture decision, expected summary contract, candidate Rust boundary, planned command, status token, and deferrals. |
| `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` | Fail-closed checks for required scope rows and deferred terms. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` | Raw fixture, provenance, expected summary, and namespace README. |
| `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` | Fixture-surface verifier for bytes, hash, expected summary, marker presence, docs, and status gating. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` | Pure typed G-code metadata/marker summary boundary. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs` | Thin CLI shell over the pure Rust boundary. |
| `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` | Unit tests for parsing, summary rendering, traceability, and fail-closed invalid inputs. |
| `packages/parity/compare_prusaslicer_gcode_output.sh` | Public comparator implementation. |
| `packages/parity/compare_prusaslicer_gcode_output_test.sh` | Mutation guard proving expected artifact or marker drift fails. |

### Modified Components

| File | Required Change |
|------|-----------------|
| `packages/parity-fixtures/BUILD.bazel` | Export fixture files, add aliases, `prusa_gcode_output_bundle`, verifier `sh_binary`, verifier `sh_test`, and package boundary entries. |
| `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` | Add Rust module source, summary binary, Rust test, clippy deps, and rustfmt targets. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` | Publish `prusa_gcode_output` module types and functions. |
| `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` | Add Prusa G-code output capability/provenance with `ParitySurface::generated_outputs()` dependency and future-candidate checklist status. |
| `packages/parity/BUILD.bazel` | Add `prusaslicer_gcode_output_parity` and failure test. |
| `packages/parity/status.tsv` | Add one exact `fork.prusaslicer.gcode-output` row only in the executable parity phase. |
| `packages/fork-inventories/prusaslicer.tsv` | Recommended: add `prusaslicer.gcode-output` if the scope gate uses that status token as an inventory-backed capability. Do not reuse support, arc-fitting, or wall-seam rows. |
| `packages/fork-inventories/category-map.tsv` | Update only if a new inventory category is added. |
| `docs/port/README.md` | Publish the current v1.12 scope, fixture, Rust boundary, command, and deferred surfaces. |
| `docs/port/package-map.md` | Add package ownership and phase-by-phase routing. |
| `docs/port/migration-guidance.md` | Add fixture update protocol and future fork status guidance for the G-code output slice. |
| `docs/port/parity-matrix.md` | Add the exact fork row interpretation while keeping broad generated outputs deferred. |
| `docs/port/contract-inventory.md` | Clarify that generated outputs are still broad/in-progress despite the narrow Prusa marker-evidence row. |

## Verification Strategy

- Scope phase: `bazel run //packages/prusa-gcode-output-scope:verify` and
  scope verifier test.
- Fixture phase:
  `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` and
  verifier failure-mode test.
- Rust phase:
  `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test`,
  plus the crate's clippy and rustfmt targets.
- Parity phase:
  `bazel run //packages/parity:prusaslicer_gcode_output_parity`,
  `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test`,
  `bazel run //packages/parity:status`, and targeted docs/status verifier
  checks.
- Final diff review must confirm no broad `generated-outputs` row is marked
  verified and no docs claim PrusaSlicer runtime, geometry, printer, GUI, or
  full generated-output parity.

## Sources

- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md`
- Bright Builds canonical standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`:
  architecture, code shape, verification, testing, and Rust guidance
- `.planning/PROJECT.md`, `.planning/MILESTONES.md`, and
  `.planning/milestones/v1.11-ROADMAP.md`
- `packages/parity-fixtures/BUILD.bazel`
- `packages/parity/BUILD.bazel` and `packages/parity/status.tsv`
- `packages/parity/compare_prusaslicer_project_file.sh` and failure test
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh`
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs`
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs`
- `packages/prusa-project-file-scope/*`
- `packages/parity-fixtures/README.md`
- `docs/port/README.md`, `docs/port/package-map.md`,
  `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md`

______________________________________________________________________

*Architecture research for: v1.12 PrusaSlicer G-code output evidence foundation*
*Researched: 2026-06-06*
