---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 54-2026-06-21T12-41-13
generated_at: 2026-06-21T12:41:13.487Z
---

# Phase 54: Semantic G-code Fixture Corpus - Context

**Gathered:** 2026-06-21
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 54 adds the source-pinned semantic Prusa G-code fixture corpus expected
by the Phase 53 semantic scope contract. The phase should create a checked-in
semantic expected summary artifact for the existing
`gcodewriter-set-speed.gcode` fixture, document the corpus and update route,
and extend the Bazel-owned fixture verifier plus mutation tests so drift fails
closed before Phase 55 Rust semantic parsing or Phase 56 public semantic
evidence consumes the artifact.

The phase completes GSFIX-01, GSFIX-02, and GSFIX-03 only. It does not add the
Phase 55 Rust semantic parser/readiness boundary, does not change public parity
status or port docs, does not claim broad `generated-outputs` verification, and
does not introduce generator, runtime, network, sync, host-upload,
post-processing, thumbnail, printability, firmware, GUI, release, or non-Prusa
fork behavior.
</domain>

<decisions>
## Implementation Decisions

### Fixture corpus shape

- **D-01:** Keep the Phase 54 corpus inside the existing
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`
  namespace. This preserves the Phase 46 marker summary and Phase 50
  structural sidecar chain for the same source-pinned fixture.
- **D-02:** Add the semantic expected summary as
  `expected-gcode-semantic-summary.tsv`, matching the Phase 53 planned artifact
  name exactly.
- **D-03:** Use the existing `gcodewriter-set-speed.gcode` fixture and accepted
  PrusaSlicer source identity:
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
  Do not add generated fixtures, downloaded fixtures, imported upstream trees,
  or new fixture sources.

### Semantic summary schema and values

- **D-04:** The semantic summary must be TSV-friendly, source-pinned, and
  restricted to the Phase 53 closed field set: `source_ref`, `fixture_id`,
  `fixture_path`, `command_class_counts`, `movement_class_counts`,
  `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, and
  `layer_marker_relationships`.
- **D-05:** The semantic artifact should include exactly one reviewed row for
  each approved semantic field. Missing, duplicate, unsupported, and
  out-of-order rows should fail closed.
- **D-06:** Semantic values should stay narrow for the selected speed-command
  fixture: command and movement class counts, absent coordinate/extrusion
  observations when the fixture has no axes, feedrate observations derived from
  the four checked-in `G1 F...` lines, and explicit layer/marker relationship
  absence. Avoid names or notes that imply toolpath geometry, timing,
  material-use, runtime, firmware, printability, GUI, support, seam, arc, or
  byte-for-byte parity.
- **D-07:** Each row must carry an evidence boundary that explains the
  observation as fixture-summary evidence only, not broad generated-output or
  printer-runtime behavior.

### Verifier and mutation coverage

- **D-08:** Extend `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`
  instead of creating a new verifier package. The verifier should read the
  semantic summary alongside the existing marker and structural summaries.
- **D-09:** The verifier must check the exact semantic header, exact row count,
  allowed field set, required field counts, source/fixture provenance alignment,
  exact expected rows or exact expected values, README provenance text, and
  forbidden broad-claim text.
- **D-10:** Extend `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`
  with focused mutation cases for semantic drift: missing rows, duplicate rows,
  out-of-order rows, unsupported fields, unsupported broad-behavior claims, and
  provenance mismatch. Keep each test focused on one behavior with Arrange,
  Act, Assert sections.
- **D-11:** Wire the new semantic summary into `packages/parity-fixtures/BUILD.bazel`
  as a checked-in exported fixture and into the existing fixture verifier target.

### Documentation and boundaries

- **D-12:** Update the fixture README to name the semantic expected artifact,
  explain that Phase 54 adds semantic fixture expectations, and keep the
  update route tied to reviewed intake changes through fork vendor, inventory,
  and scope records.
- **D-13:** Keep `packages/parity-fixtures/README.md` package-level wording
  narrow: fixture verification checks checked-in artifacts and must not fetch,
  generate, upload, or execute runtime behavior.
- **D-14:** Do not update `packages/parity/status.tsv`, public parity command
  behavior, Rust parser crates, or public port docs in this phase. Those belong
  to Phase 55 and Phase 56.

### the agent's Discretion

- Choose exact Bash helper names and constant organization in the existing
  fixture verifier, provided the verifier remains readable, exact, and
  fail-closed.
- Choose the exact semantic row wording and category names, provided every row
  maps cleanly to a Phase 53 allowed field and avoids broad behavior claims.
- Choose whether semantic expected rows are validated by one exact multiline
  constant or field-specific expected values, provided unsupported, duplicate,
  missing, out-of-order, and provenance-drift cases are covered.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 54 goal, dependency, requirements, plans, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GSFIX-01, GSFIX-02, GSFIX-03, and the v1.14
  out-of-scope boundary.
- `.planning/PROJECT.md` - v1.14 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa G-code
  evidence-chain decisions.
- `.planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md` - locked
  Phase 53 semantic field contract, planned semantic artifact path, and
  no-overclaiming boundaries.
- `.planning/phases/53-semantic-g-code-scope-contract/53-VERIFICATION.md` -
  evidence that Phase 53 passed with exactly nine approved semantic fields.

### Existing Prusa G-code fixture package

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - existing marker/structural fixture provenance, update route, status
  boundary, and deferred scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - accepted source identity, fixture identity, source literal, checksum,
  update route, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`
  - checked-in source-derived fixture lines.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - Phase 46 marker summary pattern.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - Phase 50 structural sidecar pattern that the semantic summary should
  extend without reinterpreting.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - existing
  fixture verifier to extend.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` -
  existing mutation harness to extend.
- `packages/parity-fixtures/BUILD.bazel` - Bazel fixture exports, verifier
  wiring, and test target.
- `packages/parity-fixtures/README.md` - package-level fixture verification
  boundary.

### Scope contract and downstream boundaries

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - Phase 53
  approved semantic field list and deferred semantic scope.
- `packages/prusa-gcode-output-scope/README.md` - package-level semantic scope
  verification command and boundary.
- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.gcode-output` inventory row.
- `packages/fork-inventories/category-map.tsv` - `gcode.shared` category-map
  reference to `prusaslicer.gcode-output`.
- `packages/parity/status.tsv` - broad `generated-outputs` and narrow
  `fork.prusaslicer.gcode-output` status rows that Phase 54 must not promote.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`: Existing
  Bash verifier already has exact header, exact row, ASCII/LF, checksum,
  provenance, structural field, status-row, and overclaim checks.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`:
  Existing temp-copy mutation harness already has helpers for writing valid
  fixture copies, replacing/removing lines, running the verifier, and asserting
  failures.
- `packages/parity-fixtures/BUILD.bazel`: Existing package owns fixture
  exports and verifier/test targets for Prusa G-code output fixtures.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`:
  Current sidecar shows the preferred row shape: source ref, fixture path,
  field name, category, value, and evidence boundary.

### Established Patterns

- Fixture verifier work stays in Bash/Bazel and checks checked-in artifacts
  exactly. It does not fetch, generate, upload, or run a slicer runtime.
- The evidence ladder is additive: marker fixture, structural sidecar,
  semantic sidecar, Rust parser/readiness boundary, then public parity/status
  evidence.
- Fixture summaries are intentionally conservative. They record observed facts
  from checked-in artifacts and use evidence-boundary text to reject broad
  behavior claims.
- Mutation tests use isolated temp fixture trees so negative cases prove
  fail-closed behavior without mutating source artifacts.

### Integration Points

- Phase 54 should update the fixture namespace, fixture README,
  `packages/parity-fixtures/BUILD.bazel`, fixture verifier, and fixture
  mutation test.
- Phase 55 will consume `expected-gcode-semantic-summary.tsv` from Rust without
  creating filesystem discovery, generator, Git, network, process, runtime, or
  sync behavior.
- Phase 56 will consume the semantic sidecar and Rust boundary for public
  parity evidence and status/docs publication.
</code_context>

<specifics>
## Specific Ideas

- Treat the semantic sidecar as the third rung after marker and structural
  evidence, not as parity proof.
- The fixture currently has four feedrate-only `G1 F...` commands and no
  movement axes or extrusion axes. Semantic rows should reflect that narrow
  observed reality instead of inventing richer toolpath data.
- Good semantic row examples: `command_class_counts` can record feedrate
  command counts, `movement_class_counts` can record no travel/extrusion moves,
  `coordinate_bounds` can record no coordinate axes observed, `extrusion_total`
  can record no extrusion axis observed, `feedrate_observations` can record the
  four feedrate literals, and `layer_marker_relationships` can record no layer
  markers observed.
</specifics>

<deferred>
## Deferred Ideas

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

*Phase: 54-semantic-g-code-fixture-corpus*
*Context gathered: 2026-06-21*
