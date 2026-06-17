---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 51-2026-06-17T22-55-52
generated_at: 2026-06-17T22:55:52.222Z
---

# Phase 51: Rust Structural G-code Summary Boundary - Context

**Gathered:** 2026-06-17
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

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
</domain>

<decisions>
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
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 51 goal, dependency, requirements, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GCRUST-01, GCRUST-02, GCRUST-03, and the
  v1.13 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.13 milestone goal, current-state constraints,
  and Rust/Bazel migration decisions.
- `.planning/STATE.md` - current phase position and accumulated decisions.
- `.planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md` -
  locked structural scope and no-overclaiming decisions.
- `.planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md` -
  locked structural TSV schema, required rows, fixture values, and Phase 51
  handoff intent.

### Structural fixture artifact

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - Phase 50 structural TSV artifact that Phase 51 must parse.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - existing v1.12 summary artifact that must remain stable.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, fixture identity, update route, and deferral metadata.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`
  - checked-in selected fixture bytes whose structural facts are summarized.
- `packages/parity-fixtures/BUILD.bazel` - Bazel exports and data targets for
  the Prusa G-code fixture artifacts.

### Rust boundary and registry

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  existing pure Prusa G-code summary boundary to extend structurally.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  existing parser and no-overclaiming test style to extend.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - static
  registry metadata that must expose structural readiness without side effects.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry tests for capability metadata and provenance.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Bazel Rust
  library, test, compile data, clippy, and rustfmt wiring.
- `packages/slic3r-rust/Cargo.toml` - Rust workspace and edition/lint
  settings.

### Scope and status boundaries

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - closed v1.13
  structural field contract and no-overclaiming boundary.
- `packages/parity/status.tsv` - existing narrow `fork.prusaslicer.gcode-output`
  row and broad `generated-outputs` in-progress row that Phase 51 must not
  promote.
- `packages/parity/BUILD.bazel` - Phase 48 public parity target that Phase 51
  must not repurpose into structural executable evidence.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`:
  existing constants, parse errors, row parsing, duplicate/missing/order checks,
  summary output, and metadata function for the v1.12 G-code summary artifact.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`:
  existing focused Rust mutation tests and public declaration no-overclaiming
  test.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`: pure static
  capability metadata for Prusa G-code output, including provenance and future
  parity notes.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`: existing
  `prusa_gcode_output_test`, compile data, clippy, and rustfmt targets.

### Established Patterns

- Rust flavor boundaries are pure data-in/data-out modules with no filesystem,
  Git, network, process, release, or sync side effects.
- Parser code uses closed constants, typed enums, exact expected rows, and
  explicit error variants instead of accepting primitive strings deep into the
  domain layer.
- Tests are behavior-focused and mostly one rejection class per test, with
  Arrange/Act/Assert comments.
- Bazel and Cargo both need to exercise the Rust boundary.

### Integration Points

- Add structural summary parsing and exports to the existing
  `slic3r_flavors::prusa_gcode_output` surface.
- Add the Phase 50 structural TSV as Bazel compile data for the Prusa G-code
  output test.
- Extend registry metadata or capability metadata so maintainers can inspect
  structural readiness from Rust without discovering files at runtime.
</code_context>

<specifics>
## Specific Ideas

- Keep the exact Phase 50 artifact name:
  `expected-gcode-structural-summary.tsv`.
- Keep the exact structural value domain small and closed: source strings,
  fixture strings, decimal counts, lowercase booleans, and the four ordered
  `G1 F...` markers.
- Keep all diagnostics maintainer-facing: errors should name the line number,
  row key or structural field, and the unsupported source, fixture, field, or
  boundary text where practical.
</specifics>

<deferred>
## Deferred Ideas

- Phase 52 owns the public structural parity command, structural mutation guard
  at executable-command level, status/docs publication, and any public
  generated-output evidence wording.
- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, GUI export/viewer behavior, release behavior, network/device
  behavior, non-Prusa fork behavior, upstream source imports, and sync
  automation remain out of scope.
</deferred>

---

*Phase: 51-rust-structural-g-code-summary-boundary*
*Context gathered: 2026-06-17*
