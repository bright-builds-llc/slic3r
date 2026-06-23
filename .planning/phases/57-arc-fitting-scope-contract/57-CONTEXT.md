---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 57-2026-06-23T18-45-58
generated_at: 2026-06-23T18:45:58.288Z
---

# Phase 57: Arc-Fitting Scope Contract - Context

**Gathered:** 2026-06-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 57 creates the reviewed `prusaslicer.arc-fitting` scope contract and a
fail-closed verifier before any fixture corpus, Rust parser, public evidence
command, status publication, or public docs claim is added for arc fitting.

The phase completes ARCSCOPE-01, ARCSCOPE-02, and ARCSCOPE-03 only. It must
authorize the Phase 58 fixture namespace, Phase 59 Rust evidence boundary, and
Phase 60 public evidence/status/docs path while keeping broad
`generated-outputs`, byte-for-byte G-code parity, printability,
printer-runtime behavior, GUI behavior, support generation, wall seam behavior,
release behavior, upstream imports, sync automation, and non-Prusa fork
behavior deferred.
</domain>

<decisions>
## Implementation Decisions

### Contract placement

- **D-01:** Create a new arc-fitting-specific scope package, expected at
  `packages/prusa-arc-fitting-scope`, instead of extending
  `packages/prusa-gcode-output-scope`. Arc fitting has its own inventory row,
  category-map row, planned fixture namespace, planned Rust boundary, and
  planned status token, so a separate package keeps the evidence contract
  inspectable without widening `prusaslicer.gcode-output`.
- **D-02:** The human-readable source of truth should be a package-local scope
  record, expected as `packages/prusa-arc-fitting-scope/arc-fitting-scope.md`.
  The record must name the accepted source identity, source anchors, inventory
  and category-map rows, approved arc fields, planned downstream artifact
  paths, security note, deferred scope, and reviewer signoff.
- **D-03:** Add package-local verification wiring consistent with the existing
  scope package pattern: `README.md`, `BUILD.bazel`,
  `verify_prusa_arc_fitting_scope.sh`, and a mutation suite such as
  `verify_prusa_arc_fitting_scope_test.sh`.

### Approved arc evidence fields

- **D-04:** The scope contract must define a closed field set for Phase 58
  checked-in arc summaries and Phase 59 typed parsing. Recommended approved
  fields are: `source_ref`, `inventory_source_paths`, `source_anchor`,
  `fixture_id`, `fixture_path`, `arc_command_counts`, `arc_direction_counts`,
  `center_offset_observations`, `coordinate_bounds`,
  `extrusion_observations`, `feedrate_observations`, and
  `evidence_boundary`.
- **D-05:** Every approved field must state its evidence boundary in the scope
  record. G2/G3 counts are command observations only, direction counts are
  fixture-summary facts only, center offsets are observed text/value evidence
  only, coordinate bounds are bounded observations only, extrusion/feedrate
  values are summary observations only, and none of these fields prove
  ArcWelder algorithm equivalence, byte parity, printability, firmware
  behavior, or runtime behavior.
- **D-06:** Unknown arc fields, missing required fields, duplicate field rows,
  out-of-order field rows when the contract requires order, unsupported claim
  text, and traceability drift must fail closed in the verifier.

### Traceability and planned downstream artifacts

- **D-07:** The contract must trace to the existing
  `prusaslicer.arc-fitting` row in `packages/fork-inventories/prusaslicer.tsv`
  and the `arc.shared` row in `packages/fork-inventories/category-map.tsv`.
- **D-08:** The accepted source identity is
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
  The source path is `src/libslic3r/Geometry/ArcWelder.cpp`. The contract may
  include companion anchors only when they are exact and source-pinned.
- **D-09:** The planned fixture namespace should be
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`.
  Phase 57 may name this namespace and its expected summary path, but Phase 58
  owns checked-in fixture bytes, provenance rows, expected arc summaries, and
  fixture drift guards.
- **D-10:** The planned expected arc summary artifact should be named
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  unless Phase 58 records a narrower fixture-specific reason to rename it.
- **D-11:** The planned Rust boundary should be
  `slic3r_flavors::prusa_arc_fitting` in Phase 59. Keep the boundary pure and
  data-in/data-out over caller-supplied checked-in artifacts.
- **D-12:** The planned public evidence command should be
  `bazel run //packages/parity:prusaslicer_arc_fitting_parity` in Phase 60.
  Phase 57 records this as planned text only; it must not create or publish the
  public command.
- **D-13:** The planned status token should be
  `fork.prusaslicer.arc-fitting` in Phase 60 only. Phase 57 must keep the
  token planned and must not add a verified row to `packages/parity/status.tsv`.

### Status and no-overclaiming constraints

- **D-14:** Preserve `generated-outputs` exactly as `in progress` in
  `packages/parity/status.tsv`.
- **D-15:** Preserve the existing `fork.prusaslicer.gcode-output` row text and
  meaning. Arc-fitting scope work must not widen that row or imply the current
  semantic G-code evidence already covers arc-fitting behavior.
- **D-16:** The planned `fork.prusaslicer.arc-fitting` wording must stay
  limited to the narrow v1.15 checked-in expected-summary evidence chain. It
  must explicitly defer byte-for-byte G-code parity, broad generated-output
  parity, full ArcWelder algorithm equivalence, tolerance/geometry parity,
  printability, firmware behavior, printer-runtime behavior, GUI behavior,
  support generation, wall seam behavior, release behavior, host upload,
  network/device behavior, profile auto-update execution, Bambu Studio,
  OrcaSlicer, upstream source imports, and sync automation.
- **D-17:** The security note should be explicit: no secrets, credentials,
  private data, runtime file discovery, Git, network, device, host upload,
  release, sync, upstream import, or printer-runtime behavior is introduced by
  the scope package.

### the agent's Discretion

- Choose the exact verifier helper function names, provided the script remains
  readable Bash with `set -euo pipefail`, package-local defaults, and
  deterministic failure messages.
- Choose whether the scope record uses one traceability table or several
  focused tables, provided maintainers can inspect source identity, inventory
  row, source anchors, planned paths, status wording, deferred scope, security
  note, and reviewer signoff in one document.
- Choose exact mutation test names, provided each test proves one failure mode
  and uses isolated temp copies rather than mutating repo sources.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 57 goal, dependency, requirement IDs, and
  success criteria.
- `.planning/REQUIREMENTS.md` - ARCSCOPE-01, ARCSCOPE-02, ARCSCOPE-03, and the
  v1.15 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.15 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  the v1.12-v1.14 Prusa generated-output evidence ladder.

### Existing arc-fitting inventory inputs

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.arc-fitting` row, source identity, source path, ownership,
  dependency, and planning note.
- `packages/fork-inventories/category-map.tsv` - `arc.shared` row that maps
  Prusa and Bambu arc-fitting as shared downstream future candidates.

### Existing G-code evidence precedent to preserve

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - existing marker,
  structural, and semantic G-code scope record whose status meaning must not
  be widened by arc-fitting work.
- `packages/prusa-gcode-output-scope/README.md` - current scope package public
  boundary and no-overclaiming language.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  fail-closed verifier helper patterns for exact rows, row counts, status
  checks, traceability checks, and overclaim rejection.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
  - mutation suite pattern for missing fields, unsupported fields,
  traceability drift, generated-output promotion, and forbidden claim text.
- `packages/prusa-gcode-output-scope/BUILD.bazel` - Bazel verifier/test
  wiring pattern for a metadata-only scope package.
- `.planning/milestones/v1.14-phases/53-semantic-g-code-scope-contract/53-CONTEXT.md`
  - prior yolo decisions for a closed generated-output scope contract.

### Status, docs, and future publication surfaces

- `packages/parity/status.tsv` - broad `generated-outputs` row, existing
  `fork.prusaslicer.gcode-output` row, and future insertion point for the
  Phase 60 `fork.prusaslicer.arc-fitting` row.
- `packages/parity/README.md` - public parity package wording for generated
  output and fork evidence rows.
- `docs/port/package-map.md` - package ownership and generated-output evidence
  ladder documentation.
- `docs/port/parity-matrix.md` - public status wording and non-overclaiming
  boundary.
- `docs/port/migration-guidance.md` - maintainer-facing guidance for Prusa
  fixture, Rust, and parity evidence boundaries.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/prusa-gcode-output-scope`: Existing metadata-only scope package
  provides the closest verifier, README, BUILD, and mutation-test structure for
  Phase 57.
- `packages/fork-inventories/prusaslicer.tsv`: Already contains the accepted
  `prusaslicer.arc-fitting` row with source path
  `src/libslic3r/Geometry/ArcWelder.cpp`.
- `packages/fork-inventories/category-map.tsv`: Already contains `arc.shared`
  for traceability.
- `packages/parity/status.tsv`: Already has the exact broad and G-code output
  rows Phase 57 must protect.

### Established Patterns

- Scope packages are metadata and verifier packages first. Later phases own
  fixture artifacts, Rust parsing, public parity commands, status publication,
  and public docs.
- Verifiers use exact text/row checks, row-count checks, first-field duplicate
  checks, status-row checks, and forbidden-claim rejection rather than loose
  matching.
- Mutation tests use isolated temp files and intentionally broken fixture
  copies to prove fail-closed behavior.
- Public status/docs wording stays narrow. New evidence rows are published only
  after executable evidence passes, and broad `generated-outputs` stays in
  progress.

### Integration Points

- Phase 57 should create only the arc-fitting scope package, scope record,
  verifier, mutation tests, and minimal docs needed for the scope package.
- Phase 58 consumes the approved field set and planned namespace to create
  source-pinned fixture/provenance/expected-summary artifacts.
- Phase 59 consumes the approved field set and expected summary artifact to
  add a pure Rust parser/readiness boundary.
- Phase 60 consumes the fixture and Rust boundary to publish public executable
  evidence, mutation guards, status, and docs.
</code_context>

<specifics>
## Specific Ideas

- Treat arc fitting as a new feature-specific generated-output evidence slice,
  not as an automatic extension of the current `fork.prusaslicer.gcode-output`
  row.
- Make the approved arc field table small and closed so Phase 58 and Phase 59
  can fail closed on unsupported arc claims.
- Good field examples: G2/G3 command observations, clockwise/counterclockwise
  direction counts, I/J center-offset observations, coordinate bounds,
  extrusion observations, feedrate observations, source identity, fixture
  identity, and evidence-boundary text.
- Keep the verifier focused on contract integrity: missing row, duplicate row,
  unsupported arc field, source/inventory/category drift, broad
  generated-output promotion, existing G-code row mutation, unsupported runtime
  or printability claim, and missing deferred-scope wording.
</specifics>

<deferred>
## Deferred Ideas

- Phase 58 owns checked-in fixture bytes, fixture provenance, update rules,
  `expected-arc-summary.tsv`, and fixture-level drift guards.
- Phase 59 owns the pure typed Rust `prusa_arc_fitting` parser/readiness
  boundary and Cargo/Bazel tests.
- Phase 60 owns the public `prusaslicer_arc_fitting_parity` command, public
  mutation guards, `fork.prusaslicer.arc-fitting` status row, and public docs.
- Broad generated-output parity, byte-for-byte G-code parity, full ArcWelder
  algorithm equivalence, tolerance/geometry parity, printability, runtime,
  GUI, support, seam, release, sync, non-Prusa forks, upstream imports, and
  external device behavior remain out of scope.
</deferred>

---

*Phase: 57-arc-fitting-scope-contract*
*Context gathered: 2026-06-23*
