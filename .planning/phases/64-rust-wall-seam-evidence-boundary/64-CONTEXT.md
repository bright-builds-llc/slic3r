---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 64-2026-06-30T22-34-45
generated_at: 2026-06-30T22:34:45.280Z
---

# Phase 64: Rust Wall-Seam Evidence Boundary - Context

**Gathered:** 2026-06-30
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 64 adds the pure typed Rust wall-seam summary boundary and static
readiness metadata needed before Phase 65 can publish public executable
wall-seam evidence, public status wording, or public docs.

The phase completes SEAMRUST-01, SEAMRUST-02, and SEAMRUST-03 only. It parses
caller-supplied checked-in wall-seam summary artifacts into typed Rust domain
values, exposes developer-facing readiness metadata, and wires focused
Cargo/Bazel coverage. It must not discover files, call Git, access the
network, spawn processes, run a slicer/generator, publish public status rows,
claim byte-for-byte G-code parity, claim wall-seam algorithm or geometry
equivalence, claim printability/runtime/GUI behavior, or widen existing
PrusaSlicer G-code output and arc-fitting evidence rows.
</domain>

<decisions>
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
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 64 goal, dependency, requirement IDs,
  success criteria, plan list, and planning notes.
- `.planning/REQUIREMENTS.md` - SEAMRUST-01, SEAMRUST-02, SEAMRUST-03, and
  the v1.16 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.16 milestone goal, current-state constraints,
  and key decisions for the wall-seam evidence ladder.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  the v1.12-v1.16 Prusa generated-output evidence ladder.

### Wall-seam source and fixture chain

- `.planning/phases/62-wall-seam-scope-contract/62-CONTEXT.md` - locked
  decisions for the Phase 62 wall-seam scope contract, approved fields,
  status constraints, and downstream handoff.
- `.planning/phases/63-wall-seam-fixture-corpus/63-CONTEXT.md` - locked
  decisions for the Phase 63 fixture namespace, expected-summary shape,
  verifier, and Phase 64 handoff.
- `packages/prusa-wall-seam-scope/wall-seam-scope.md` - reviewed source
  identity, approved 12-field wall-seam summary contract, planned paths, and
  boundary language.
- `packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh` - exact
  scope verifier whose approved field and status boundaries Phase 64 must
  respect.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`
  - caller-supplied checked-in summary artifact to parse.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/fixture-provenance.tsv`
  - source identity, source anchors, fixture identity, update route, and
  deferred-scope provenance.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/README.md`
  - namespace documentation and no-overclaiming language.
- `packages/parity-fixtures/verify_prusa_wall_seam_fixture.sh` - fixture
  verifier enforcing row order, exact values, status restraints, and forbidden
  claim text.

### Rust parser and readiness precedents

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs` -
  closest parser/readiness pattern for a feature-specific generated-output
  summary boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs` -
  focused Cargo/Bazel test pattern for valid summary rows and invalid
  fail-closed mutations.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  semantic and structural G-code parser patterns to preserve without widening.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  parser, helper-name, summary-line, and failure coverage patterns.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Prusa
  capability registry and generated-output future-candidate wiring.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry/readiness metadata tests and no-overclaiming public-name guards.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - crate-local
  rust_library, rust_test, clippy, and rustfmt wiring.
- `packages/slic3r-rust/BUILD.bazel` - package aggregate verify target that
  must include new wall-seam coverage when Phase 64 changes the crate.

### Status and publication boundaries

- `packages/parity/status.tsv` - broad `generated-outputs` row, existing
  `fork.prusaslicer.gcode-output` row, existing
  `fork.prusaslicer.arc-fitting` row, and future Phase 65 insertion point for
  `fork.prusaslicer.wall-seam`.
- `packages/parity/README.md` - public parity package wording that Phase 64
  must not publish as wall-seam verified evidence.
- `docs/port/package-map.md` - package ownership and generated-output
  evidence ladder documentation for Phase 65, not Phase 64 publication.
- `docs/port/parity-matrix.md` - public status wording boundary that remains
  unchanged until Phase 65.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs`:
  best local pattern for a separate generated-output feature parser,
  source/ref constants, expected-row constants, facts structs, readiness
  metadata, and no-overclaiming deferred surfaces.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs`:
  best local pattern for valid fixture parsing and fail-closed invalid-row
  coverage.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`: existing
  registry list already has generated-output future-candidate rows for G-code
  output and arc fitting, and should gain a wall-seam row.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`:
  canonical checked-in artifact for parser fixtures.

### Established Patterns

- Rust generated-output boundaries live in `slic3r_flavors`, not in public
  parity scripts, until the executable evidence phase.
- Parser modules encode expected summary rows as closed constants and parse
  caller-supplied text into typed values with exact fail-closed checks.
- Readiness metadata is developer-facing before publication and uses exact
  planned command/status wording while preserving generated-output deferrals.
- Bazel `rust_test` targets include checked-in fixture artifacts through
  `compile_data`, and aggregate `//packages/slic3r-rust:verify` keeps Rust
  parser coverage visible.

### Integration Points

- Add `src/prusa_wall_seam.rs` and expose it from `src/lib.rs`.
- Add `tests/prusa_wall_seam.rs` and wire it into
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`.
- Update `src/registry.rs` and `tests/flavor_registry.rs` for the wall-seam
  capability and readiness metadata.
- Update package aggregate verification wiring in
  `packages/slic3r-rust/BUILD.bazel` if the new crate-local test is not
  automatically covered.
</code_context>

<specifics>
## Specific Ideas

- Mirror the arc-fitting parser shape closely, replacing arc-specific fields
  with the 12 wall-seam fields and values from Phase 63.
- Use exact fixture values from
  `expected-wall-seam-summary.tsv`, including `checked-in-wall-seam-summary-only`.
- Keep planned public command and status token strings visible only in
  readiness metadata:
  `//packages/parity:prusaslicer_wall_seam_parity` and
  `fork.prusaslicer.wall-seam`.
- Add tests that scan public helper names and readiness notes to reject
  forbidden claim fragments such as byte parity, seam geometry equivalence,
  printability, runtime, support, GUI, arc-fitting, and non-Prusa behavior.
</specifics>

<deferred>
## Deferred Ideas

- Phase 65 owns the public wall-seam parity command, public mutation guards,
  exact status row, and public docs.
- Broader wall-seam fixture corpus growth, byte-for-byte G-code parity, seam
  geometry equivalence, seam visibility, printability, runtime behavior, GUI
  behavior, support generation, STEP import, release behavior, sync behavior,
  non-Prusa forks, and upstream import behavior remain out of scope.
- JSON-valued summary rows, live generation, and filesystem-discovery parser
  modes remain deferred; Phase 64 parses caller-supplied checked-in summaries
  only.
</deferred>

*Phase: 64-rust-wall-seam-evidence-boundary*
*Context gathered: 2026-06-30*
