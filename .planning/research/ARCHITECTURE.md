# Architecture Patterns

**Domain:** v1.15 PrusaSlicer arc-fitting G-code evidence slice
**Researched:** 2026-06-23
**Overall confidence:** HIGH

## Recommended Architecture

v1.15 should reuse the v1.12-v1.14 G-code evidence ladder, but it should not
fold arc-fitting into the existing `fork.prusaslicer.gcode-output` semantic
claim. Arc fitting is a separate source-observed inventory row
(`prusaslicer.arc-fitting`) with `generated-outputs` as its dependency, so it
needs a separate narrow evidence path and status token while sharing the same
packages and conventions.

```text
packages/prusa-gcode-output-scope
  v1.15 arc-fitting scope section
  -> verifies prusaslicer.arc-fitting inventory/category-map traceability
  -> records allowed arc fields and forbidden broad claims

packages/parity-fixtures
  forks/prusaslicer/prusaslicer.arc-fitting/
  -> checked-in source-pinned arc G-code evidence fixture
  -> fixture-provenance.tsv
  -> expected-arc-fitting-summary.tsv
  -> fixture verifier and mutation guards

packages/slic3r-rust/crates/slic3r_flavors
  prusa_arc_fitting.rs
  -> pure typed parser over caller-supplied TSV text
  -> arc readiness metadata and summary lines
  -> prusa_arc_fitting_summary binary

packages/parity
  prusaslicer_arc_fitting_parity
  -> runs Rust summary over checked-in artifacts
  -> fails closed on drift/mutations
  -> publishes fork.prusaslicer.arc-fitting only after evidence passes

docs/port and package READMEs
  -> describe the exact narrow arc-fitting evidence slice
  -> keep generated-outputs in progress
  -> keep byte parity, printability, runtime, GUI, release, sync, and
     non-Prusa fork behavior deferred
```

This is a modified-package milestone, not a new-package milestone. Add new
files inside existing package boundaries instead of creating
`packages/prusa-arc-fitting-scope` or a new Rust crate.

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|----------------|-------------------|
| `packages/prusa-gcode-output-scope` | Own the reviewed v1.15 `prusaslicer.arc-fitting` scope contract because the evidence is G-code-shaped and depends on the existing generated-output deferral vocabulary. | Reads `packages/fork-inventories/prusaslicer.tsv`, `packages/fork-inventories/category-map.tsv`, and later `packages/parity/status.tsv`; names fixture, Rust, parity, and docs targets. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` | Own static arc-fitting fixture bytes, provenance, update route, and `expected-arc-fitting-summary.tsv`. | Exposed through `packages/parity-fixtures/BUILD.bazel`; consumed by `slic3r_flavors` tests and `packages/parity`. |
| `slic3r_flavors::prusa_arc_fitting` | Parse checked-in arc summary TSV into typed Rust facts and render deterministic summary lines. Keep all domain checks pure and side-effect-free. | Consumed by a new `prusa_arc_fitting_summary` binary, registry tests, and parity command. |
| `packages/parity` | Own executable public evidence and status publication for the narrow `fork.prusaslicer.arc-fitting` row. | Invokes the Rust summary binary with fixture artifacts; updates `status.tsv`; keeps existing `prusaslicer_gcode_output_parity` intact. |
| `docs/port` and package READMEs | Publish exact scope and command wording without widening broad generated outputs. | Mirrors status/package changes and must stay consistent with verifier-checked text. |

## New vs Modified Packages

| Package | Action | Why |
|---------|--------|-----|
| New top-level package | Do not add one. | Existing package boundaries already model scope, fixtures, Rust flavor evidence, parity/status, and docs. A new package would duplicate the G-code evidence ladder. |
| `packages/prusa-gcode-output-scope` | Modify. Add a `v1.15 Arc-Fitting Evidence Scope` section and verifier coverage. | Arc-fitting proof is a G-code evidence slice and should share the established generated-output deferral guardrails. |
| `packages/parity-fixtures` | Modify. Add `forks/prusaslicer/prusaslicer.arc-fitting/`, aliases, bundle, fixture verifier, and verifier tests. | The fixture should trace to `prusaslicer.arc-fitting`, not reuse the feedrate-only `prusaslicer.gcode-output` fixture. |
| `packages/slic3r-rust/crates/slic3r_flavors` | Modify. Add `src/prusa_arc_fitting.rs`, `src/bin/prusa_arc_fitting_summary.rs`, exports, registry/readiness metadata, tests, clippy/rustfmt targets. | Arc-fitting is a new typed evidence boundary but still belongs in the shared flavor metadata crate. |
| `packages/parity` | Modify. Add `compare_prusaslicer_arc_fitting.sh`, failure test, Bazel target, and `fork.prusaslicer.arc-fitting` status row only in the publication phase. | Public evidence should be independently runnable and independently visible from `fork.prusaslicer.gcode-output`. |
| `docs/port` | Modify. Update `package-map.md`, `parity-matrix.md`, and adjacent port docs with exact narrow wording. | Roadmap consumers need to see that `generated-outputs` remains `in progress`. |

## Integration Points

### Scope Package

Use the existing `packages/prusa-gcode-output-scope` package as the reviewed
contract owner. The new section should tie the arc slice to:

| Link | Required Target |
|------|-----------------|
| Inventory row | `prusaslicer.arc-fitting` in `packages/fork-inventories/prusaslicer.tsv` |
| Category map | `arc.shared` in `packages/fork-inventories/category-map.tsv` |
| Accepted source ref | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Source path | `src/libslic3r/Geometry/ArcWelder.cpp` |
| Companion source evidence | `src/libslic3r/Geometry/ArcWelder.hpp` and the `GCode.cpp` arc emission integration points |
| Fixture namespace | `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` |
| Expected artifact | `expected-arc-fitting-summary.tsv` |
| Rust boundary | `slic3r_flavors::prusa_arc_fitting` |
| Public command | `bazel run //packages/parity:prusaslicer_arc_fitting_parity` |
| Status token | `fork.prusaslicer.arc-fitting` |
| Broad status row | `generated-outputs` remains `in progress` |

The verifier should fail on missing inventory/category-map traceability,
unsupported arc evidence fields, duplicate fields, missing reviewer signoff,
unsupported broad claim text, stale generated-output wording, and premature
status claims. During the early scope phase, do not require the final verified
status row until the parity/status publication phase adds it.

### Fixture Package

Add a new fixture namespace instead of extending
`prusaslicer.gcode-output/gcodewriter-set-speed.gcode`. The existing fixture is
feedrate-only (`G1 F...`) and explicitly has no arc behavior claim, so using it
for arc evidence would be an overclaim.

Recommended fixture shape:

```text
packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/
  .gitattributes
  README.md
  arc-fitting-g2-g3.gcode
  fixture-provenance.tsv
  expected-arc-fitting-summary.tsv
```

The fixture may be a reviewed static G-code evidence artifact derived from the
pinned ArcWelder/GCode source observations, but the checked-in provenance must
say exactly how it was derived. It must not imply live PrusaSlicer generation,
printability, byte parity, printer runtime behavior, or geometry correctness.

Recommended `expected-arc-fitting-summary.tsv` schema:

```text
source_ref    fixture_path    arc_field    arc_category    arc_value    evidence_boundary
```

Recommended allowed fields:

| Field | Purpose | Boundary |
|-------|---------|----------|
| `source_ref` | Accepted PrusaSlicer source identity. | Source identity only. |
| `inventory_source_paths` | ArcWelder and GCode integration source anchors. | Source trace only. |
| `fixture_id` | Stable checked-in fixture identity. | Fixture identity only. |
| `fixture_path` | Exact fixture path. | Checked-in artifact only. |
| `arc_command_counts` | Counts of `G2` and `G3` commands in the selected fixture. | Arc command evidence only; no byte parity. |
| `linear_command_context` | Counts or markers for surrounding `G0`/`G1` context if present. | Context only; no generated conversion claim. |
| `arc_direction_counts` | Clockwise/counter-clockwise command observations. | Direction-token evidence only. |
| `ij_offset_presence` | Presence/absence of `I`/`J` center-offset words. | Arc center-offset encoding evidence only. |
| `coordinate_axes_present` | Presence of X/Y/Z words. | Token-level G-code evidence only. |
| `extrusion_axis_observed` | Presence/absence of E words. | Token-level extrusion observation only; no material-use claim. |
| `feedrate_observations` | Feedrate tokens if present. | Metadata only; no timing or firmware claim. |
| `arc_source_anchor` | Pinned source/test line anchor, such as `tests/libslic3r/test_arc_welder.cpp`. | Source trace only. |

Do not include fields such as `toolpath_geometry_verified`,
`arc_fitting_parity`, `printability`, `firmware_behavior`, or
`generated_outputs_verified`.

### Rust Boundary

Add a separate `prusa_arc_fitting` module instead of expanding
`prusa_gcode_output.rs` indefinitely. The existing G-code module already owns
marker, structural, and semantic facts for `prusaslicer.gcode-output`; arc
fitting has a different inventory ID and status token.

Recommended Rust surface:

```rust
pub struct PrusaArcFittingSummary { /* typed rows and facts */ }
pub struct PrusaArcFittingFacts { /* source, fixture, arc command fields */ }
pub enum PrusaArcFittingField { /* closed allowed field set */ }
pub enum PrusaArcFittingParseError { /* fail-closed variants */ }

pub fn parse_prusa_arc_fitting_summary(input: &str) -> Result<PrusaArcFittingSummary, PrusaArcFittingParseError>;
pub fn prusa_arc_fitting_summary_lines(input: &str) -> Result<Vec<String>, PrusaArcFittingParseError>;
pub const fn prusa_arc_fitting_readiness() -> PrusaArcFittingReadiness;
```

The module should parse caller-supplied TSV text into domain types, enforce row
order, reject unsupported fields and broad claims, and expose readiness metadata
without filesystem discovery, Git, network, process execution, source import,
release, sync, runtime generation, or printer behavior.

Use a thin binary:

```text
//packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary
```

The binary can read a file path because it is an adapter. The domain parser
must stay pure and data-in/data-out.

### Parity Command and Status

Add a new public command:

```text
bazel run //packages/parity:prusaslicer_arc_fitting_parity
```

The command should follow the existing G-code comparator pattern:

1. Assert the Rust summary binary and checked-in artifacts exist.
2. Run the Rust summary binary over the fixture summary input.
3. Run the Rust summary binary over the expected artifact.
4. Diff normalized summary lines.
5. Assert exact source ref, fixture path, row count, arc command counts, and
   deferred-scope wording.
6. Print concise success output naming `fork.prusaslicer.arc-fitting`.

Add a status row only when the executable evidence is in place:

```text
fork.prusaslicer.arc-fitting    verified    //packages/parity:prusaslicer_arc_fitting_parity    Shared fixture comparison proves the narrow PrusaSlicer arc-fitting G-code evidence slice only; generated-outputs remains in progress and byte-for-byte G-code parity, broad generated-output verification, toolpath geometry, printability, printer-runtime behavior, support generation, wall seam behavior, GUI behavior, release behavior, sync automation, upstream source imports, and non-Prusa fork behavior remain deferred
```

Keep `fork.prusaslicer.gcode-output` as the v1.14 semantic evidence row. Do not
rewrite it to absorb arc-fitting, and do not mark `generated-outputs` verified.

### Documentation

Update docs as a final publication step, not before executable evidence exists:

| File | Required Wording |
|------|------------------|
| `packages/prusa-gcode-output-scope/README.md` | v1.15 arc-fitting scope is reviewed and verifier-guarded; broad generated-output remains deferred. |
| `packages/parity-fixtures/README.md` | New `prusaslicer.arc-fitting` namespace and update route. |
| `packages/slic3r-rust/README.md` | New pure Rust arc-fitting parser/readiness boundary; no runtime generation. |
| `packages/parity/README.md` | New public parity command and exact status row meaning. |
| `docs/port/package-map.md` | Existing packages now include arc-fitting evidence files. |
| `docs/port/parity-matrix.md` | `fork.prusaslicer.arc-fitting` is verified only for narrow arc-fitting evidence; `generated-outputs` remains in progress. |

## Data Flow

```text
Pinned Prusa inventory row
  -> reviewed arc-fitting scope contract
  -> checked-in static fixture/provenance/expected summary
  -> pure Rust parser and summary renderer
  -> parity comparator and mutation guard
  -> status row and docs publication
```

Detailed flow:

1. `packages/fork-inventories/prusaslicer.tsv` supplies the accepted
   `prusaslicer.arc-fitting` identity and source pin.
2. `packages/prusa-gcode-output-scope/gcode-output-scope.md` records the
   allowed v1.15 arc fields, fixture path, Rust boundary, planned command, and
   forbidden claims.
3. `packages/parity-fixtures` adds a checked-in fixture namespace with
   provenance and `expected-arc-fitting-summary.tsv`.
4. `slic3r_flavors::prusa_arc_fitting` parses the TSV into closed Rust types
   and renders stable summary lines.
5. `packages/parity:prusaslicer_arc_fitting_parity` runs the binary and diffs
   normalized output against the checked-in expected artifact.
6. `packages/parity/status.tsv` publishes `fork.prusaslicer.arc-fitting` only
   after the command and mutation guards pass.
7. `docs/port/*` and package READMEs describe the command and exact evidence
   boundary.

## Build Order

Recommended phase/order structure:

1. **Arc-fitting scope contract** - Modify `packages/prusa-gcode-output-scope`
   first. Verify source identity, category-map traceability, allowed arc
   fields, planned fixture/Rust/parity paths, and deferral wording.
2. **Arc-fitting fixture evidence** - Add
   `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`,
   fixture provenance, expected summary, Bazel aliases/bundle, verifier, and
   mutation tests.
3. **Rust arc-fitting boundary** - Add `slic3r_flavors::prusa_arc_fitting`,
   summary binary, readiness metadata, registry wiring, and Rust tests for
   success plus fail-closed rejection cases.
4. **Executable evidence and publication** - Add
   `//packages/parity:prusaslicer_arc_fitting_parity`, mutation guards, exact
   `fork.prusaslicer.arc-fitting` status row, and docs/status updates.

Verification targets should include:

```text
bazel run //packages/prusa-gcode-output-scope:verify
bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_test
bazel run //packages/parity:prusaslicer_arc_fitting_parity
bazel run //packages/parity:prusaslicer_gcode_output_parity
bazel run //packages/parity:status
```

The existing G-code output parity command should still pass at the end because
v1.15 is additive and should not regress the v1.12-v1.14 evidence chain.

## Patterns to Follow

### Pattern 1: Feature-Specific Evidence Row

**What:** Publish arc fitting as `fork.prusaslicer.arc-fitting`, not as a wider
`fork.prusaslicer.gcode-output` claim.

**When:** Use this pattern whenever a source-observed fork inventory row has
its own evidence chain and status meaning.

**Example:**

```text
inventory row: prusaslicer.arc-fitting
status row:    fork.prusaslicer.arc-fitting
command:       //packages/parity:prusaslicer_arc_fitting_parity
```

### Pattern 2: Closed TSV Schema Plus Typed Rust Facts

**What:** Keep `expected-arc-fitting-summary.tsv` as a closed schema with a
fixed allowed field set, then parse it into Rust enums and fact structs.

**When:** Use for checked-in evidence summaries where unsupported rows could
turn into overclaims.

**Example:**

```rust
pub enum PrusaArcFittingField {
    SourceRef,
    FixtureId,
    FixturePath,
    ArcCommandCounts,
    ArcDirectionCounts,
    IjOffsetPresence,
}
```

### Pattern 3: Thin Imperative Shell

**What:** Let shell/Bazel own file paths, executable invocation, temp
directories, and diffs. Keep parsing and validation rules in Rust.

**When:** Use for parity commands and fixture verifiers.

**Example:**

```text
compare_prusaslicer_arc_fitting.sh
  -> assert files
  -> invoke prusa_arc_fitting_summary
  -> diff normalized output
  -> print exact narrow success summary
```

### Pattern 4: Status After Evidence

**What:** Keep status publication as the last step. Earlier scope, fixture, and
Rust readiness phases may name the planned status token but must not publish a
verified row.

**When:** Use for every new fork evidence slice.

## Anti-Patterns to Avoid

### Anti-Pattern 1: Reusing Feedrate-Only G-code Evidence for Arc Claims

**What:** Treating `gcodewriter-set-speed.gcode` as arc evidence.
**Why bad:** That fixture contains only `G1 F...` feedrate markers and its docs
explicitly defer arc behavior.
**Instead:** Add a new `prusaslicer.arc-fitting` fixture namespace and summary.

### Anti-Pattern 2: Promoting Broad Generated Outputs

**What:** Marking `generated-outputs` as verified or saying arc evidence proves
generated-output parity.
**Why bad:** The milestone only proves a narrow source-pinned evidence path.
**Instead:** Add `fork.prusaslicer.arc-fitting` and keep `generated-outputs`
`in progress`.

### Anti-Pattern 3: Live Upstream or Runtime Generation

**What:** Fetching PrusaSlicer, running a slicer, cloning upstream, importing
source trees, or generating fresh G-code in the verifier/parity command.
**Why bad:** The existing architecture is source-pinned, checked-in, and
fail-closed; live generation introduces drift and runtime scope.
**Instead:** Use checked-in fixtures and cite exact upstream source pins.

### Anti-Pattern 4: Generic Key-Value Parser

**What:** Parsing arbitrary `arc_field` values into a map and only checking a
few known keys.
**Why bad:** Unsupported fields can pass silently and later be interpreted as
evidence.
**Instead:** Use enums, exact row order, duplicate detection, missing-row
detection, and unsupported-claim rejection.

### Anti-Pattern 5: Registry as Proof

**What:** Treating `slic3r_flavors` readiness metadata as verified arc-fitting
support.
**Why bad:** Registry metadata is side-effect-free planning/readiness data, not
public executable evidence by itself.
**Instead:** Publish verification only through `packages/parity` after the
public command passes.

### Anti-Pattern 6: Mixing Non-Prusa Scope

**What:** Adding Bambu Studio or OrcaSlicer arc fixtures because
`arc.shared` includes other future rows.
**Why bad:** v1.15 active planning is Prusa-only.
**Instead:** Keep non-Prusa rows as inventory/history until a later explicit
milestone scopes them.

## Scalability Considerations

| Concern | Current Slice | Later Feature Slices | Broad Generated Outputs |
|---------|---------------|----------------------|-------------------------|
| Fixture size | One reviewed arc fixture and one expected summary. | Add one namespace per inventory row or scenario only after reviewed scope. | Requires a larger fixture corpus and generation oracle; out of scope. |
| Rust module size | New `prusa_arc_fitting.rs` keeps arc logic separate from the already large G-code output module. | Extract shared TSV helpers only if duplication becomes real across multiple feature modules. | Avoid a generic parser that weakens field closure. |
| Status rows | One new `fork.prusaslicer.arc-fitting` row. | One row per executable evidence slice. | Do not collapse feature rows into broad `generated-outputs` until evidence supports it. |
| Verification time | Small Bazel shell/Rust targets should stay cheap. | Run affected package verifiers plus existing G-code parity regression. | Full generated-output parity will need separate planning and heavier evidence. |

## Sources

- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo and Bright Builds workflow requirements; local standards files are not checked into the repo, so pinned upstream standards were read from commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`.
- Pinned Bright Builds standards: `standards/core/architecture.md`, `standards/core/verification.md`, `standards/core/testing.md`, and `standards/languages/rust.md` at `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/`.
- `.planning/PROJECT.md` and `.planning/STATE.md` - v1.15 goal, active requirements, and decision to use arc fitting as the next Prusa generated-output feature slice.
- `.planning/codebase/architecture.md` - existing monorepo, Rust migration, and parity package architecture.
- `.planning/milestones/v1.14-ROADMAP.md` - prior G-code evidence ladder: scope, fixture, Rust boundary, executable evidence/status/docs.
- `packages/fork-inventories/prusaslicer.tsv` and `packages/fork-inventories/category-map.tsv` - `prusaslicer.arc-fitting` and `arc.shared` source-pinned planning rows.
- `packages/prusa-gcode-output-scope/README.md` and `packages/prusa-gcode-output-scope/gcode-output-scope.md` - current G-code scope package and deferral wording.
- `packages/parity-fixtures/README.md`, `packages/parity-fixtures/BUILD.bazel`, and `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/*` - fixture namespace and summary patterns.
- `packages/slic3r-rust/README.md`, `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`, `src/bin/prusa_gcode_output_summary.rs`, and related tests - current pure Rust G-code evidence boundary.
- `packages/parity/README.md`, `packages/parity/BUILD.bazel`, `packages/parity/status.tsv`, and `compare_prusaslicer_gcode_output.sh` - public parity command/status pattern.
- `docs/port/package-map.md` and `docs/port/parity-matrix.md` - current docs publication pattern and generated-output deferrals.
- Pinned PrusaSlicer source at `9a583bd438b195856f3bcf7ea99b69ba4003a961`: `src/libslic3r/Geometry/ArcWelder.cpp`, `src/libslic3r/Geometry/ArcWelder.hpp`, `src/libslic3r/GCode.cpp`, `src/libslic3r/GCode.hpp`, and `tests/libslic3r/test_arc_welder.cpp`.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Package integration | HIGH | Existing packages and Bazel targets show the exact extension pattern. |
| Source anchors | HIGH | Local inventory and pinned upstream source agree on ArcWelder/GCode integration. |
| Fixture schema | MEDIUM | Recommended fields are architecture guidance; exact row values need phase implementation review. |
| Status/docs strategy | HIGH | Existing status conventions require executable evidence before verified fork rows. |
| No-overclaim boundary | HIGH | Existing verifiers, docs, and project requirements repeatedly enforce narrow claims and broad deferrals. |
