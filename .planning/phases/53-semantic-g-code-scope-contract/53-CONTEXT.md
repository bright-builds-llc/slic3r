---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 53-2026-06-21T00-15-35
generated_at: 2026-06-21T00:17:18.367Z
---

# Phase 53: Semantic G-code Scope Contract - Context

**Gathered:** 2026-06-21
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 53 updates the reviewed Prusa G-code scope contract before any v1.14
semantic fixture corpus, Rust semantic parser, or executable semantic evidence
lands. The phase must name exactly which semantic G-code evidence fields are
allowed for v1.14 and must keep broad generated-output, runtime, printability,
GUI, release, sync, and non-Prusa fork claims fail-closed.

The phase completes GSSCOPE-01, GSSCOPE-02, and GSSCOPE-03 only. It does not
create the Phase 54 semantic fixture artifact, the Phase 55 Rust semantic
summary parser, or the Phase 56 public semantic parity/status publication.
</domain>

<decisions>
## Implementation Decisions

### Contract placement

- **D-01:** Extend the existing `packages/prusa-gcode-output-scope` package
  instead of creating a new semantic-scope package. This preserves the Phase
  45 -> Phase 49 -> Phase 52 evidence chain for `prusaslicer.gcode-output`.
- **D-02:** Keep `packages/prusa-gcode-output-scope/gcode-output-scope.md` as
  the human-readable source of truth, with a new v1.14 semantic section that is
  visibly additive over the v1.13 structural contract.
- **D-03:** Update `packages/prusa-gcode-output-scope/README.md` only enough to
  describe the semantic scope contract and the verification command. Avoid
  broad doc rewrites or status wording changes outside the scope package.

### Allowed semantic evidence fields

- **D-04:** The semantic contract must explicitly allow only this closed field
  set for Phase 54 fixture expectations and Phase 55 typed parsing:
  `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`,
  `movement_class_counts`, `coordinate_bounds`, `extrusion_total`,
  `feedrate_observations`, and `layer_marker_relationships`.
- **D-05:** Each allowed semantic field must state its evidence boundary in the
  scope record. Coordinate bounds are bounded observations only, extrusion
  totals are summary totals only, feedrate observations are metadata only, and
  layer/marker relationships are fixture-summary relationships only.
- **D-06:** Field names should be stable and TSV-friendly so Phase 54 can
  create `expected-gcode-semantic-summary.tsv` without reinterpreting the
  contract. Unknown semantic fields must fail closed.

### Fail-closed forbidden claims

- **D-07:** Preserve all v1.12/v1.13 no-overclaiming prohibitions: no
  byte-for-byte G-code parity, broad generated-output verification, toolpath
  geometry parity, printability, printer-runtime behavior, support generation,
  wall seam behavior, arc fitting, GUI export/viewer behavior, release
  behavior, network/device behavior, non-Prusa fork behavior, upstream source
  imports, or sync automation.
- **D-08:** Add semantic mutation coverage that proves missing required
  semantic fields, unsupported semantic fields, duplicate semantic rows,
  missing semantic traceability, missing reviewer signoff, and semantic
  overclaim text fail closed.
- **D-09:** Keep `generated-outputs` exactly `in progress`. Phase 53 may plan
  a future semantic update to the existing `fork.prusaslicer.gcode-output`
  row, but it must not change status wording or claim semantic executable
  evidence before Phase 56.

### Traceability

- **D-10:** The updated scope contract must trace to the accepted
  `prusaslicer.gcode-output` inventory row, `gcode.shared` category-map row,
  accepted PrusaSlicer source identity, existing fixture namespace, current
  summary and structural artifacts, planned semantic summary artifact,
  existing Rust boundary path, planned Phase 56 public command, and deferred
  status boundary.
- **D-11:** The planned semantic summary artifact should be
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`.
- **D-12:** The planned Rust boundary should extend the existing
  `slic3r_flavors::prusa_gcode_output` module in Phase 55, keeping it pure and
  data-in/data-out over caller-supplied checked-in artifacts.
- **D-13:** The planned public evidence command should remain
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` unless Phase
  56 planning records a deliberate companion-command decision that preserves
  the existing status-token contract.

### the agent's Discretion

- Choose exact Bash helper names and table-count helper reuse inside
  `verify_prusa_gcode_output_scope.sh`, provided the verifier stays
  fail-closed, readable, and consistent with the existing package style.
- Choose the exact mutation-test helper names in
  `verify_prusa_gcode_output_scope_test.sh`, provided each case proves one
  behavior and reports a useful diagnostic.
- Choose whether semantic traceability is one table or several small tables,
  provided maintainers can inspect source identity, fixture namespace, planned
  semantic artifact, Rust boundary, public command, status boundary, deferred
  scope, and reviewer signoff without ambiguity.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 53 goal, dependency, requirements, plans, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GSSCOPE-01, GSSCOPE-02, GSSCOPE-03, and the
  v1.14 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.14 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  the v1.12/v1.13 Prusa G-code evidence chain.

### Prior Prusa G-code evidence decisions

- `.planning/milestones/v1.12-phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md`
  - original G-code scope gate, handoff paths, and no-overclaiming boundary.
- `.planning/milestones/v1.13-phases/49-structural-g-code-scope-contract/49-CONTEXT.md`
  - locked structural scope placement, field closure, and verifier decisions.
- `.planning/milestones/v1.13-phases/52-executable-structural-g-code-evidence/52-CONTEXT.md`
  - public structural command/status/docs boundary that Phase 53 must preserve.

### Existing Prusa G-code scope package

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - current reviewed
  scope record, structural field contract, traceability, and deferred scope.
- `packages/prusa-gcode-output-scope/README.md` - package boundary and public
  verification command.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  fail-closed verifier that Phase 53 must extend.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
  - mutation suite pattern for scope drift and overclaiming checks.
- `packages/prusa-gcode-output-scope/BUILD.bazel` - Bazel package pattern for
  scope verifier and tests.

### Source, fixture, Rust, status, and public docs

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.gcode-output` inventory row.
- `packages/fork-inventories/category-map.tsv` - `gcode.shared` category-map
  reference to `prusaslicer.gcode-output`.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace and current fixture boundary.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - original marker summary artifact.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - Phase 50 structural summary artifact that semantic work builds on.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, fixture identity, update route, and deferral metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  existing Rust summary/structural boundary that Phase 55 should extend.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  - existing summary adapter and likely Phase 56 integration point.
- `packages/parity/status.tsv` - current broad `generated-outputs` and narrow
  `fork.prusaslicer.gcode-output` status rows.
- `packages/parity/README.md` - public parity package docs for the existing
  structural Prusa G-code command.
- `docs/port/package-map.md` - package ownership and phase history.
- `docs/port/parity-matrix.md` - public generated-output and fork evidence
  wording that must remain non-overclaiming.
- `docs/port/migration-guidance.md` - maintainer-facing migration guidance for
  Prusa G-code evidence boundaries.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/prusa-gcode-output-scope/gcode-output-scope.md`: Existing Markdown
  scope record already has a v1.13 structural table and traceability table that
  can be mirrored for v1.14 semantic scope.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`:
  Existing helpers already check exact section rows, exact row counts,
  inventory/category/status rows, generated-output status, deferred terms, and
  forbidden overclaiming text.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`:
  Existing mutation harness writes isolated fixtures and has focused tests for
  missing structural fields, unsupported fields, traceability drift, and
  overclaim text.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`:
  Current structural schema shows how v1.14 semantic fields can remain
  source/fixture pinned and TSV-friendly.

### Established Patterns

- Scope packages are metadata and verifier packages first; later phases own
  fixture artifacts, Rust parsing, public parity commands, status updates, and
  public docs.
- Verification is deliberately exact and conservative: missing rows,
  unsupported rows, duplicate status rows, promoted broad status rows, and
  broad behavior claims fail closed.
- Rust migration code keeps parser/readiness boundaries pure and
  dependency-free, while shell/Bazel targets own orchestration.
- Public docs and status rows stay narrow. A fork-specific row may become more
  meaningful, but the broad `generated-outputs` surface remains in progress
  until substantially broader executable evidence exists.

### Integration Points

- Phase 53 should update the scope package record, README, verifier, and
  mutation tests.
- Phase 54 will consume the closed semantic field set when writing
  `expected-gcode-semantic-summary.tsv`.
- Phase 55 will consume the same field set when adding typed Rust semantic
  parsing/readiness.
- Phase 56 will consume the semantic artifact and Rust boundary when updating
  public parity evidence and status/docs wording.
</code_context>

<specifics>
## Specific Ideas

- Treat semantic evidence as a third rung after marker summary and structural
  facts, not as byte-for-byte or geometry parity.
- Keep the semantic field list closed and small so fixture, Rust, and parity
  phases can fail closed on unsupported semantic claims.
- Good semantic field examples: command classes, movement classes, coordinate
  bounds, extrusion totals, feedrate observations, and layer/marker
  relationships.
- The verifier should make failures obvious: missing semantic field, unsupported
  semantic field, missing semantic traceability, generated-output promotion, or
  forbidden semantic overclaim.
</specifics>

<deferred>
## Deferred Ideas

- Phase 54 owns the semantic fixture corpus, source-pinned provenance, update
  rules, `expected-gcode-semantic-summary.tsv`, and fixture-level semantic
  drift guards.
- Phase 55 owns the pure typed Rust semantic parser/readiness boundary and
  Cargo/Bazel parser coverage.
- Phase 56 owns public semantic parity evidence, semantic mutation guards,
  exact status wording, and public docs.
- Byte-for-byte G-code parity, broad generated-output verification,
  geometry/toolpath parity, printability, printer-runtime behavior, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, GUI behavior, binary G-code, thumbnails, post-processing, host
  upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, release
  behavior, and sync automation remain out of scope.
</deferred>

---

*Phase: 53-semantic-g-code-scope-contract*
*Context gathered: 2026-06-21*
