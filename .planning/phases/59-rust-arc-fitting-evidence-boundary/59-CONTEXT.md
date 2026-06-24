---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 59-2026-06-24T13-36-08
generated_at: 2026-06-24T13:36:36.611Z
---

# Phase 59: Rust Arc-Fitting Evidence Boundary - Context

**Gathered:** 2026-06-24
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 59 adds the pure typed Rust boundary that parses the Phase 58 checked-in
`expected-arc-summary.tsv` artifact and exposes static readiness metadata for
the narrow `prusaslicer.arc-fitting` evidence slice.

The phase completes ARCRUST-01, ARCRUST-02, and ARCRUST-03 only. It must not
publish the Phase 60 public parity command, add the
`fork.prusaslicer.arc-fitting` status row, update public `docs/port/*`
publication surfaces, run live generation, discover files at runtime, call
Git/network/process APIs, import upstream sources, claim byte-for-byte G-code
parity, claim ArcWelder algorithm equivalence, or widen the existing
`fork.prusaslicer.gcode-output` meaning.
</domain>

<decisions>
## Implementation Decisions

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
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 59 goal, dependency, requirement IDs, success
  criteria, and Phase 60 publication boundary.
- `.planning/REQUIREMENTS.md` - ARCRUST-01, ARCRUST-02, ARCRUST-03, and the
  v1.15 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.15 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa
  generated-output evidence-chain decisions.
- `.planning/phases/57-arc-fitting-scope-contract/57-CONTEXT.md` - locked
  scope decisions for the approved arc field set, Rust boundary name, planned
  command, planned status token, and no-overclaiming rules.
- `.planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md` - locked
  fixture decisions for namespace, expected summary schema, provenance, and
  Phase 59 ownership.
- `.planning/phases/58-arc-fitting-fixture-corpus/58-VERIFICATION.md` -
  evidence that Phase 58 passed and the checked-in summary is ready for Rust
  parser work.

### Arc-fitting source artifacts

- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - approved 12-field
  arc evidence contract, planned Rust boundary, planned public command, planned
  status token, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  - exact checked-in TSV artifact Phase 59 must parse.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv`
  - source identity, fixture identity, source anchors, checksum, update route,
  exclusions, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md`
  - namespace-local fixture boundary and Phase 59/60 ownership split.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - existing
  fixture verifier constants and exact artifact expectations that the Rust
  parser should agree with.

### Rust precedent to reuse

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  closest parser/readiness pattern for checked-in G-code expected summaries,
  typed fields, facts extraction, and no-overclaiming checks.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  closest valid/invalid parser test pattern and Bazel compile-data precedent.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs` -
  alternate pure parser and metadata pattern for source-pinned fixture
  evidence.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - static
  capability registry to extend with `prusaslicer.arc-fitting`.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - public module and
  re-export surface.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - crate-local
  Bazel library, test, clippy, and rustfmt wiring.
- `packages/slic3r-rust/BUILD.bazel` - aggregate Rust verification target to
  extend when adding the arc-fitting test.

### Status boundaries to preserve

- `packages/parity/status.tsv` - broad `generated-outputs` row and existing
  `fork.prusaslicer.gcode-output` row must remain unchanged in Phase 59.
- `packages/parity/README.md` - public parity docs remain Phase 60-owned for
  arc fitting.
- `docs/port/package-map.md`, `docs/port/parity-matrix.md`, and
  `docs/port/migration-guidance.md` - public port docs remain Phase 60-owned
  for arc fitting.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `slic3r_flavors::prusa_gcode_output`: Existing marker, structural, and
  semantic parser/readiness code shows the exact shape for closed TSV schemas,
  enum-backed fields, facts extraction, summary-line helpers, source/fixture
  guards, forbidden-claim checks, and typed parse errors.
- `slic3r_flavors::registry`: Existing Prusa capability metadata already
  models `prusaslicer.gcode-output` as a shared downstream future candidate
  with `generated-outputs` dependency and cautionary notes.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`:
  Existing tests show include-str fixture loading, mutation helpers,
  `maybe_` naming for optional binary paths, and Arrange/Act/Assert style.
- `packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary`: Phase 58
  Bazel fixture target should be used as compile data for the new Rust test.

### Established Patterns

- Rust evidence boundaries live under `packages/slic3r-rust/crates/slic3r_flavors`
  and stay pure. They parse caller-supplied text, expose typed static metadata,
  and do not discover files or mutate public status/docs.
- Public status and public docs are published only after the executable parity
  phase passes. Parser/readiness phases may expose developer-facing metadata
  without changing `packages/parity/status.tsv`.
- Bazel and Cargo coverage are both expected for new Rust migration behavior.
  The aggregate Bazel target `//packages/slic3r-rust:verify` is the preferred
  repo-owned Rust verification surface.

### Integration Points

- Add `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs`.
- Update `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` re-exports.
- Update `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` for the
  static `prusaslicer.arc-fitting` capability.
- Add `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs`.
- Update `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` and
  `packages/slic3r-rust/BUILD.bazel` for the new source/test wiring.
</code_context>

<specifics>
## Specific Ideas

- Model the expected arc summary as a narrow evidence table, not as a G-code
  parser. The Rust parser validates the checked-in sidecar facts that Phase 58
  already reviewed and verified.
- Use `PrusaArcFitting*` names that say "arc fitting" and "summary" rather
  than "parity" or "generated output" unless the name explicitly says planned
  or deferred.
- Keep the planned Phase 60 command and status token in metadata as traceability
  strings only. Do not create `//packages/parity:prusaslicer_arc_fitting_parity`
  or a `fork.prusaslicer.arc-fitting` status row.
- Preserve the existing `fork.prusaslicer.gcode-output` row and registry
  meaning. Arc-fitting evidence is a separate slice that depends on broad
  `generated-outputs` staying in progress.
</specifics>

<deferred>
## Deferred Ideas

- Phase 60 owns public `bazel run //packages/parity:prusaslicer_arc_fitting_parity`,
  public mutation guards, exact `fork.prusaslicer.arc-fitting` status wording,
  `packages/parity` docs, and public `docs/port/*` publication.
- Byte-for-byte G-code parity, broad generated-output verification, full
  ArcWelder algorithm equivalence, tolerance/geometry parity, printability,
  firmware behavior, printer-runtime behavior, GUI behavior, support
  generation, wall seam behavior, release behavior, upstream imports, sync
  automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior remain out
  of scope.
</deferred>

---

*Phase: 59-rust-arc-fitting-evidence-boundary*
*Context gathered: 2026-06-24*
