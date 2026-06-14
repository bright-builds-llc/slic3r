---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 47-2026-06-14T15-07-52
generated_at: 2026-06-14T15:07:52.277Z
---

# Phase 47: Rust Prusa G-code Summary Boundary - Context

**Gathered:** 2026-06-14
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 47 creates the pure Rust summary boundary for the checked-in Phase 46
`prusaslicer.gcode-output` expected summary artifact.

Developers must be able to parse the exact
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
shape into typed, side-effect-free Rust values that preserve source identity,
fixture path, metadata key/value evidence, marker key/value evidence, notes,
and traceability metadata for the future Phase 48 parity/status layer.

This phase must not create the Phase 48 Bazel parity command, must not publish
`fork.prusaslicer.gcode-output` in `packages/parity/status.tsv`, and must not
claim byte-for-byte G-code parity, full generated-output parity, toolpath
geometry, extrusion, timing, support generation, wall seam behavior, arc
fitting, STEP import, full 3MF import/export, printer-runtime behavior,
firmware or printability behavior, GUI export or viewer behavior, binary
G-code, thumbnails, post-processing, host upload, network/device integration,
profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
upstream source imports, release behavior, or sync automation.

</domain>

<decisions>

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

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 47 goal, dependency on Phase 46, success
  criteria, and mapped requirements.
- `.planning/REQUIREMENTS.md` - `PGSUM-01`, `PGSUM-02`, `PGSUM-03`, and
  explicit v1.12 out-of-scope exclusions.
- `.planning/PROJECT.md` - v1.12 milestone goal, current state, and evidence
  ladder constraints.
- `.planning/STATE.md` - current milestone state and prior Phase 45/46
  decisions.
- `.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md` - Phase
  45 reserved Rust boundary, expected summary contract, future command/status
  names, and absence boundaries.
- `.planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md` - Phase 46
  fixture, provenance, expected summary, verifier, and Phase 47 handoff
  decisions.

### G-code Evidence Contract

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - accepted source
  identity, candidate Rust boundary, planned status token, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - exact TSV header and accepted rows to parse.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - byte count, hash, upstream source path, role, update route, and broad
  deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace boundary and non-overclaiming usage language.

### Existing Rust Patterns

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs` -
  closest parser, metadata, summary line, and fail-closed row validation
  precedent.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs` -
  closest positive and negative Rust test pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - public export
  surface for flavor-specific modules.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - flavor
  capability registry and provenance wiring.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry behavior and non-overclaiming public helper tests.
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - typed
  `VendorSourceRef`, `FeatureOrigin`, `FlavorId`, `ParitySurface`, and
  `ChecklistStatus` values.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Rust library,
  test, clippy, and rustfmt target wiring.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `prusa_project_file.rs` already implements the desired pure Rust shape:
  constants, metadata, exact header validation, typed row keys, duplicate/missing
  row detection, row-order checks, note validation, and summary-line output.
- `tests/prusa_project_file.rs` already exercises checked-in fixture parsing,
  metadata exposure, summary output, invalid headers, wrong counts, unsupported
  values, overclaiming notes, duplicate rows, missing rows, extra rows, and
  public-surface name checks.
- `registry.rs` already exposes Prusa project-file and profile-schema
  capabilities with typed provenance and parity dependency arrays.

### Established Patterns

- Rust flavor boundaries are pure library code, with any filesystem access
  isolated to tiny `src/bin/*_summary.rs` command wrappers.
- Static metadata values use `VendorSourceRef::prusa_slicer_version_2_9_5()`
  and `ChecklistStatus::FutureCandidate` until executable evidence is added in
  a later phase.
- Tests use explicit Arrange, Act, Assert sections and validate behavior by
  exact accepted rows instead of broad parser implementation details.

### Integration Points

- Add `src/prusa_gcode_output.rs`, export it from `src/lib.rs`, and include it
  in `BUILD.bazel`.
- Add `tests/prusa_gcode_output.rs` with compile data pointing at the Phase 46
  expected G-code summary and the new source module.
- Update `registry.rs` and `tests/flavor_registry.rs` for the new
  `prusaslicer.gcode-output` capability.
- If a summary binary is added, follow `src/bin/prusa_project_file_summary.rs`
  and wire it into Bazel clippy/rustfmt targets.

</code_context>

<specifics>

## Specific Ideas

- Keep the G-code boundary to metadata and marker evidence only: `source_literal`
  and `line_1` through `line_4` are markers, not proof of generated-output
  runtime behavior.
- Treat the literal feedrate lines (`G1 F99999.123`, `G1 F1`, `G1 F203.2`,
  `G1 F203.201`) as exact accepted marker values.
- Keep `fork.prusaslicer.gcode-output` as a reserved future token only until
  Phase 48 creates executable evidence and status publication.

</specifics>

<deferred>

## Deferred Ideas

Phase 48 owns the executable Bazel parity command, fail-closed parity mutation
guard, exact `packages/parity/status.tsv` row, and public docs/status
alignment for `fork.prusaslicer.gcode-output`.

Broader byte-for-byte G-code parity, full generated-output parity, toolpath
geometry, extrusion, timing, support, seam, arc, STEP, full 3MF, GUI,
runtime/printer behavior, firmware or printability, release builds,
network/device behavior, profile auto-update, Bambu Studio, OrcaSlicer, and
sync automation remain outside Phase 47.

</deferred>

______________________________________________________________________

*Phase: 47-rust-prusa-g-code-summary-boundary*
*Context gathered: 2026-06-14*
