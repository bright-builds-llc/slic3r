---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 62-2026-06-26T23-04-21
generated_at: 2026-06-26T23:04:21.788Z
---

# Phase 62: Wall-Seam Scope Contract - Context

**Gathered:** 2026-06-26
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 62 creates the reviewed `prusaslicer.wall-seam` scope contract and a
fail-closed verifier before any wall-seam fixture corpus, Rust parser, public
evidence command, status publication, or public docs claim is added.

The phase completes SEAMSCOPE-01, SEAMSCOPE-02, and SEAMSCOPE-03 only. It must
authorize the Phase 63 fixture namespace, Phase 64 Rust evidence boundary, and
Phase 65 public evidence/status/docs path while keeping broad
`generated-outputs`, byte-for-byte G-code parity, full wall-seam algorithm or
geometry equivalence, seam visibility, printability, printer-runtime behavior,
GUI behavior, support generation, STEP import, release behavior, upstream
imports, sync automation, and non-Prusa fork behavior deferred.
</domain>

<decisions>
## Implementation Decisions

### Contract placement

- **D-01:** Create a new wall-seam-specific scope package, expected at
  `packages/prusa-wall-seam-scope`, instead of extending
  `packages/prusa-gcode-output-scope` or `packages/prusa-arc-fitting-scope`.
  Wall seam has its own inventory row, category-map row, planned fixture
  namespace, planned Rust boundary, and planned status token, so a separate
  package keeps the evidence contract inspectable without widening existing
  G-code output or arc-fitting evidence.
- **D-02:** The human-readable source of truth should be a package-local scope
  record, expected as `packages/prusa-wall-seam-scope/wall-seam-scope.md`.
  The record must name the accepted source identity, source anchors, inventory
  and category-map rows, approved seam fields, planned downstream artifact
  paths, security note, deferred scope, and reviewer signoff.
- **D-03:** Add package-local verification wiring consistent with the existing
  scope package pattern: `README.md`, `BUILD.bazel`,
  `verify_prusa_wall_seam_scope.sh`, and a mutation suite such as
  `verify_prusa_wall_seam_scope_test.sh`.

### Approved wall-seam evidence fields

- **D-04:** The scope contract must define a closed field set for Phase 63
  checked-in wall-seam summaries and Phase 64 typed parsing. Recommended
  approved fields are: `source_ref`, `inventory_source_paths`,
  `source_anchor`, `fixture_id`, `fixture_path`,
  `seam_transition_observations`, `layer_context_observations`,
  `travel_context_observations`, `coordinate_bounds`,
  `extrusion_observations`, `retraction_observations`, and
  `evidence_boundary`.
- **D-05:** Every approved field must state its evidence boundary in the scope
  record. Seam-transition rows are checked-in observation facts only, layer
  and travel context rows are fixture-summary context only, coordinate bounds
  are bounded observations only, extrusion and retraction values are summary
  observations only, and none of these fields prove wall-seam algorithm
  equivalence, seam visibility, byte parity, printability, firmware behavior,
  printer-runtime behavior, GUI behavior, or generated-output parity.
- **D-06:** Unknown seam fields, missing required fields, duplicate field rows,
  out-of-order field rows when the contract requires order, unsupported claim
  text, traceability drift, and missing deferred-scope language must fail
  closed in the verifier.

### Traceability and planned downstream artifacts

- **D-07:** The contract must trace to the existing `prusaslicer.wall-seam` row
  in `packages/fork-inventories/prusaslicer.tsv` and the `seam.shared` row in
  `packages/fork-inventories/category-map.tsv`.
- **D-08:** The accepted source identity is
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
  The source path is `src/libslic3r/GCode/SeamAligned.cpp`. The contract may
  include companion anchors only when they are exact and source-pinned.
- **D-09:** The planned fixture namespace should be
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/`.
  Phase 62 may name this namespace and its expected summary path, but Phase 63
  owns checked-in fixture bytes, provenance rows, expected wall-seam summaries,
  and fixture drift guards.
- **D-10:** The planned expected wall-seam summary artifact should be named
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`
  unless Phase 63 records a narrower fixture-specific reason to rename it.
- **D-11:** The planned Rust boundary should be
  `slic3r_flavors::prusa_wall_seam` in Phase 64. Keep the boundary pure and
  data-in/data-out over caller-supplied checked-in artifacts.
- **D-12:** The planned public evidence command should be
  `bazel run //packages/parity:prusaslicer_wall_seam_parity` in Phase 65.
  Phase 62 records this as planned text only; it must not create or publish the
  public command.
- **D-13:** The planned status token should be `fork.prusaslicer.wall-seam` in
  Phase 65 only. Phase 62 must keep the token planned and must not add a
  verified row to `packages/parity/status.tsv`.

### Status and no-overclaiming constraints

- **D-14:** Preserve `generated-outputs` exactly as `in progress` in
  `packages/parity/status.tsv`.
- **D-15:** Preserve the existing `fork.prusaslicer.gcode-output` and
  `fork.prusaslicer.arc-fitting` row text and meaning. Wall-seam scope work
  must not widen either row or imply the current semantic G-code or
  arc-fitting evidence already covers wall-seam behavior.
- **D-16:** The planned `fork.prusaslicer.wall-seam` wording must stay limited
  to the narrow v1.16 checked-in wall-seam summary evidence chain. It must
  explicitly defer byte-for-byte G-code parity, broad generated-output parity,
  full wall-seam algorithm or geometry equivalence, seam visibility,
  printability, firmware behavior, printer-runtime behavior, GUI behavior,
  support generation, STEP import, full 3MF import/export, binary G-code,
  thumbnails, post-processing, host upload, network/device behavior, profile
  auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
  upstream source imports, release behavior, sync automation, and non-Prusa
  fork behavior.
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

- `.planning/ROADMAP.md` - Phase 62 goal, dependency, requirement IDs, success
  criteria, plan list, and planning notes.
- `.planning/REQUIREMENTS.md` - SEAMSCOPE-01, SEAMSCOPE-02, SEAMSCOPE-03, and
  the v1.16 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.16 milestone goal, current-state constraints,
  and key decisions for wall-seam evidence.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  the v1.12-v1.15 Prusa generated-output evidence ladder.

### Existing wall-seam inventory inputs

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.wall-seam` row, source identity, source path, ownership,
  dependency, and planning note.
- `packages/fork-inventories/category-map.tsv` - `seam.shared` row that maps
  the Prusa wall-seam row as the shared downstream future candidate.

### Existing generated-output evidence precedent to preserve

- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - closest completed
  feature-specific generated-output scope contract pattern.
- `packages/prusa-arc-fitting-scope/README.md` - package-level scope boundary
  and no-overclaiming language for a separate feature slice.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` -
  fail-closed verifier helper patterns for exact rows, row counts, status
  checks, traceability checks, and overclaim rejection.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh` -
  mutation suite pattern for missing fields, unsupported fields, traceability
  drift, generated-output promotion, existing-row mutation, and forbidden claim
  text.
- `packages/prusa-arc-fitting-scope/BUILD.bazel` - Bazel verifier/test wiring
  pattern for a metadata-only scope package.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - existing marker,
  structural, and semantic G-code scope record whose status meaning must not
  be widened by wall-seam work.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  older scope verifier patterns and self-scan-safe forbidden-claim handling.
- `.planning/milestones/v1.15-phases/57-arc-fitting-scope-contract/57-CONTEXT.md`
  - prior yolo decisions for a comparable feature-specific generated-output
  scope contract.

### Status, docs, and future publication surfaces

- `packages/parity/status.tsv` - broad `generated-outputs` row, existing
  `fork.prusaslicer.gcode-output` row, existing `fork.prusaslicer.arc-fitting`
  row, and future insertion point for the Phase 65
  `fork.prusaslicer.wall-seam` row.
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

- `packages/prusa-arc-fitting-scope`: Existing metadata-only feature scope
  package provides the closest README, BUILD, verifier, and mutation-test
  structure for Phase 62.
- `packages/prusa-gcode-output-scope`: Existing G-code evidence scope package
  provides older structural/semantic verifier patterns and status-preservation
  checks that wall-seam work must not widen.
- `packages/fork-inventories/prusaslicer.tsv`: Already contains the accepted
  `prusaslicer.wall-seam` row with source path
  `src/libslic3r/GCode/SeamAligned.cpp`.
- `packages/fork-inventories/category-map.tsv`: Already contains `seam.shared`
  for Prusa wall-seam traceability.
- `packages/parity/status.tsv`: Already has the exact broad, semantic G-code,
  and arc-fitting rows Phase 62 must protect.

### Established Patterns

- Scope packages are metadata and verifier packages first. Later phases own
  fixture artifacts, Rust parsing, public parity commands, status publication,
  and public docs.
- Verifiers use exact text/row checks, row-count checks, first-field duplicate
  checks, status-row checks, traceability checks, and forbidden-claim rejection
  rather than loose matching.
- Mutation tests use isolated temp files and intentionally broken fixture
  copies to prove fail-closed behavior.
- Public status/docs wording stays narrow. New evidence rows are published only
  after executable evidence passes, and broad `generated-outputs` stays in
  progress.

### Integration Points

- Phase 62 should create only the wall-seam scope package, scope record,
  verifier, mutation tests, and minimal package docs needed for the scope
  package.
- Phase 63 consumes the approved field set and planned namespace to create
  source-pinned fixture/provenance/expected-summary artifacts.
- Phase 64 consumes the approved field set and expected summary artifact to
  add a pure Rust parser/readiness boundary.
- Phase 65 consumes the fixture and Rust boundary to publish public executable
  evidence, mutation guards, status, and docs.
</code_context>

<specifics>
## Specific Ideas

- Treat wall seam as a new feature-specific generated-output evidence slice,
  not as an automatic extension of the current `fork.prusaslicer.gcode-output`
  or `fork.prusaslicer.arc-fitting` rows.
- Make the approved wall-seam field table small and closed so Phase 63 and
  Phase 64 can fail closed on unsupported seam claims.
- Good field examples: seam-transition observations, layer context, travel
  context, coordinate bounds, extrusion observations, retraction observations,
  source identity, fixture identity, and evidence-boundary text.
- Keep the verifier focused on contract integrity: missing row, duplicate row,
  unsupported seam field, source/inventory/category drift, broad
  generated-output promotion, existing G-code or arc-fitting row mutation,
  unsupported runtime/printability/geometry/seam-visibility claim, and missing
  deferred-scope wording.
</specifics>

<deferred>
## Deferred Ideas

- Phase 63 owns checked-in fixture bytes, fixture provenance, update rules,
  `expected-wall-seam-summary.tsv`, and fixture-level drift guards.
- Phase 64 owns the pure typed Rust `prusa_wall_seam` parser/readiness boundary
  and Cargo/Bazel tests.
- Phase 65 owns the public `prusaslicer_wall_seam_parity` command, public
  mutation guards, `fork.prusaslicer.wall-seam` status row, and public docs.
- Broad generated-output parity, byte-for-byte G-code parity, full wall-seam
  algorithm or geometry equivalence, seam visibility, printability, runtime,
  GUI, support generation, STEP import, release, sync, non-Prusa forks,
  upstream imports, and external device behavior remain out of scope.
</deferred>

---

*Phase: 62-wall-seam-scope-contract*
*Context gathered: 2026-06-26*
