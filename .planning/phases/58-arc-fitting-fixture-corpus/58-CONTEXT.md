---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 58-2026-06-23T19-50-26
generated_at: 2026-06-23T19:52:01.042Z
---

# Phase 58: Arc-Fitting Fixture Corpus - Context

**Gathered:** 2026-06-23
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 58 adds the source-pinned `prusaslicer.arc-fitting` fixture namespace,
checked-in arc expected summary, provenance/update rules, and fail-closed
fixture verification required by the Phase 57 scope contract.

The phase completes ARCFIX-01, ARCFIX-02, and ARCFIX-03 only. It must not add
the Phase 59 Rust `slic3r_flavors::prusa_arc_fitting` parser/readiness
boundary, the Phase 60 public parity command, the
`fork.prusaslicer.arc-fitting` status row, public port-doc publication, live
generation, upstream import/sync, network/device behavior, host upload,
post-processing, thumbnails, printability, GUI behavior, printer-runtime
behavior, Bambu Studio support, OrcaSlicer support, or broad
`generated-outputs` claims.
</domain>

<decisions>
## Implementation Decisions

### Fixture namespace and provenance

- **D-01:** Create a new fixture namespace at
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`, as
  planned by Phase 57. Do not place arc evidence inside the existing
  `prusaslicer.gcode-output` namespace, because the current
  `fork.prusaslicer.gcode-output` status meaning must remain limited to the
  Phase 53 through Phase 56 semantic evidence slice.
- **D-02:** Add namespace-local fixture documentation, a `.gitattributes`
  boundary, `fixture-provenance.tsv`, one or more checked-in source-pinned
  fixture artifacts if needed, and the expected arc summary artifact named
  `expected-arc-summary.tsv`.
- **D-03:** Keep provenance tied to the accepted source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, the
  inventory row `prusaslicer.arc-fitting`, and the source path
  `src/libslic3r/Geometry/ArcWelder.cpp`. Fixture update rules must route
  through reviewed intake changes to fork vendors, fork inventories, and the
  Phase 57 scope record, not branch-head observation or live generation.

### Expected arc summary schema

- **D-04:** Use `expected-arc-summary.tsv` as the exact Phase 58 handoff
  artifact for Phase 59. Its field set must mirror the Phase 57 closed
  contract: `source_ref`, `inventory_source_paths`, `source_anchor`,
  `fixture_id`, `fixture_path`, `arc_command_counts`,
  `arc_direction_counts`, `center_offset_observations`,
  `coordinate_bounds`, `extrusion_observations`, `feedrate_observations`,
  and `evidence_boundary`.
- **D-05:** Use one reviewed row per approved arc field. Missing rows,
  duplicate rows, out-of-order rows, unsupported fields, wrong source refs,
  wrong fixture identities, unsupported claim text, and stale documentation
  references must fail closed.
- **D-06:** Keep every row observational. G2/G3 counts are command facts only;
  clockwise/counterclockwise counts are direction observations only; I/J center
  offsets are summary facts only; bounds, extrusion, and feedrate rows are
  checked-in fixture observations only. None of the row values or evidence
  boundaries may claim byte-for-byte G-code parity, ArcWelder algorithm
  equivalence, tolerance/geometry parity, printability, firmware behavior,
  printer-runtime behavior, GUI behavior, support generation, wall seam
  behavior, release behavior, upstream import, sync behavior, or non-Prusa
  fork behavior.

### Verifier ownership and mutation coverage

- **D-07:** Extend `packages/parity-fixtures` with an arc-fitting fixture
  verifier target rather than adding checks to `packages/prusa-arc-fitting-scope`.
  The scope package owns the Phase 57 contract; the fixture package owns
  checked-in fixture bytes, provenance, expected summaries, and fixture drift
  guards.
- **D-08:** Use the existing Bash/Bazel fixture-verifier style: package-local
  paths, `set -euo pipefail`, exact header checks, exact row counts, exact
  required fields, duplicate-field rejection, provenance/source alignment,
  fixture identity checks, README/package-boundary checks, and forbidden-claim
  scanning.
- **D-09:** Add focused mutation tests for the ARCFIX-03 drift classes:
  missing row, duplicate row, out-of-order row, unsupported arc field,
  unsupported broad claim text, wrong source ref, wrong fixture identity, stale
  README/package reference, and provenance mismatch. Keep temp checkouts
  isolated and assert diagnostics that name the failing artifact or field.

### Documentation and publication boundary

- **D-10:** Update `packages/parity-fixtures/README.md`,
  `packages/parity-fixtures/BUILD.bazel`, and the new namespace README only
  enough to expose the Phase 58 fixture corpus, bundle, and verification
  command.
- **D-11:** Do not update `packages/parity/status.tsv`, `packages/parity`
  public command behavior, `packages/slic3r-rust`, or public `docs/port/*`
  publication surfaces in this phase. Those belong to Phase 59 and Phase 60.
- **D-12:** Preserve broad `generated-outputs` as `in progress` and preserve
  the existing `fork.prusaslicer.gcode-output` row wording and meaning.

### the agent's Discretion

- Choose the exact fixture ID and fixture bytes/source excerpt strategy,
  provided the artifact is source-pinned, small, reviewable, and constrained to
  Phase 57 approved arc evidence fields.
- Choose exact Bash helper names, constants, and target names, provided the
  verifier remains readable, exact, Bash 3.2-compatible where practical, and
  fail-closed.
- Choose whether `expected-arc-summary.tsv` validates rows through exact
  multiline constants or field-specific expected values, provided order,
  missing, duplicate, unsupported, provenance, identity, stale-doc, and
  overclaim mutations are covered.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 58 goal, dependency, requirement IDs, and
  success criteria.
- `.planning/REQUIREMENTS.md` - ARCFIX-01, ARCFIX-02, ARCFIX-03, and the v1.15
  out-of-scope boundary.
- `.planning/PROJECT.md` - v1.15 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa
  generated-output evidence-chain decisions.
- `.planning/phases/57-arc-fitting-scope-contract/57-CONTEXT.md` - locked
  Phase 57 decisions for namespace, expected artifact path, closed field set,
  traceability, and publication boundaries.
- `.planning/phases/57-arc-fitting-scope-contract/57-VERIFICATION.md` -
  evidence that Phase 57 passed and the contract is ready for fixture work.

### Arc-fitting scope contract

- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - approved
  arc-fitting field contract, planned namespace, planned summary path, source
  identity, status wording, deferred scope, and traceability.
- `packages/prusa-arc-fitting-scope/README.md` - package-local verification
  command and boundary.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` -
  exact verifier patterns for approved arc fields, traceability, status, and
  forbidden claims.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh` -
  mutation suite precedent for unsupported arc fields, duplicate/missing rows,
  traceability drift, status drift, and overclaims.

### Fixture package precedent

- `packages/parity-fixtures/BUILD.bazel` - fixture exports, bundles, verifier
  targets, tests, and package boundary filegroup to extend for arc fitting.
- `packages/parity-fixtures/README.md` - package-level fixture rules,
  existing fork namespace pattern, and no-runtime/no-fetch boundary.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - closest
  existing Bash fixture verifier for exact checked-in summary validation.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` -
  temp-checkout mutation harness pattern for fixture drift.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - existing Prusa generated-output fixture namespace documentation pattern.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, update route, privacy/post-processing exclusions, and
  broad deferral row pattern.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`
  - sidecar TSV row shape and evidence-boundary wording precedent.

### Source inventory and status boundaries

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.arc-fitting` inventory row.
- `packages/fork-inventories/category-map.tsv` - `arc.shared` category-map row
  that references `prusaslicer.arc-fitting`.
- `packages/parity/status.tsv` - broad `generated-outputs` row and existing
  `fork.prusaslicer.gcode-output` row that Phase 58 must preserve.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/BUILD.bazel`: Existing exports, bundle filegroups,
  verifier targets, test targets, and package boundary filegroup show where
  the new arc-fitting fixture namespace, bundle, verifier, and tests should be
  wired.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`: Closest
  existing pattern for exact Bash validation of checked-in provenance and
  expected-summary sidecars.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`:
  Existing temp-checkout helpers and one-behavior mutation cases can be reused
  or mirrored for arc-fitting fixture drift tests.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`:
  Existing `.gitattributes`, README, provenance TSV, and summary sidecars show
  the fixture namespace shape.
- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md`: Closed 12-field arc
  evidence contract that Phase 58 must consume exactly.

### Established Patterns

- Fixture phases add checked-in artifacts plus fixture verifier coverage; they
  do not publish public status rows or public parity commands.
- Fixture summaries are TSV sidecars with source identity, fixture path, field
  name, category, value, and evidence boundary. They record observed facts and
  explicitly reject broad behavior claims.
- Verifiers use exact constants, exact rows/line counts, required-field
  uniqueness, provenance alignment, documentation-reference checks, and
  forbidden-claim guards.
- Mutation tests use isolated temp checkout roots and assert diagnostics for
  each failure class.

### Integration Points

- Phase 58 should modify `packages/parity-fixtures` and the new
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`
  namespace.
- Phase 59 will parse `expected-arc-summary.tsv` through a pure Rust boundary
  without Git, network, process, generator, runtime, or filesystem discovery
  side effects.
- Phase 60 will consume the Phase 58 fixture corpus and Phase 59 Rust boundary
  to publish public executable evidence, status wording, mutation guards, and
  public docs.
</code_context>

<specifics>
## Specific Ideas

- Treat `expected-arc-summary.tsv` as a sibling evidence sidecar to the prior
  structural and semantic G-code summaries, but in the new
  `prusaslicer.arc-fitting` namespace so current G-code output status wording
  remains untouched.
- Good summary observations include G2/G3 command counts, clockwise versus
  counterclockwise direction counts, I/J center-offset observations, coordinate
  bounds, extrusion-axis facts, feedrate facts, source identity, fixture
  identity, and explicit evidence-boundary text.
- Favor a small reviewed fixture over broad corpus expansion. The selected
  fixture must be enough to prove Phase 57 approved fields and fixture drift
  guards, not full ArcWelder equivalence.
</specifics>

<deferred>
## Deferred Ideas

- Phase 59 owns the pure typed Rust `slic3r_flavors::prusa_arc_fitting`
  parser/readiness boundary and Cargo/Bazel coverage.
- Phase 60 owns public `bazel run //packages/parity:prusaslicer_arc_fitting_parity`,
  fail-closed public mutation guards, exact `fork.prusaslicer.arc-fitting`
  status wording, and public docs.
- Byte-for-byte G-code parity, broad generated-output verification, full
  ArcWelder algorithm equivalence, tolerance/geometry parity, printability,
  firmware behavior, printer-runtime behavior, GUI behavior, support
  generation, wall seam behavior, release behavior, upstream imports, sync
  automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior remain out
  of scope.
</deferred>

---

*Phase: 58-arc-fitting-fixture-corpus*
*Context gathered: 2026-06-23*
