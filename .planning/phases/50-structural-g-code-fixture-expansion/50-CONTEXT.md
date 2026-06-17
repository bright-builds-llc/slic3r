---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 50-2026-06-17T16-13-19
generated_at: 2026-06-17T16:19:36.990Z
---

# Phase 50: Structural G-code Fixture Expansion - Context

**Gathered:** 2026-06-17
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 50 expands the existing Prusa `set_speed` G-code fixture surface with a
checked-in structural expected summary and Bazel-owned fail-closed fixture
verification. The phase consumes the Phase 49 closed structural field contract
and prepares the fixture data that Phase 51 can parse through a typed Rust
boundary.

The phase completes GCFIX-01, GCFIX-02, and GCFIX-03 only. It does not create
the Phase 51 Rust structural parser, the Phase 52 public structural parity
command, or any byte-for-byte G-code, geometry/toolpath, printability,
printer-runtime, support, wall seam, arc, GUI, release, network/device,
non-Prusa fork, upstream import, or sync claim.
</domain>

<decisions>
## Implementation Decisions

### Structural summary artifact

- **D-01:** Add a separate checked-in sidecar artifact named
  `expected-gcode-structural-summary.tsv` under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
  Keep the existing `expected-gcode-summary.tsv` unchanged so the v1.12
  summary-only Rust parser and Phase 48 parity command remain stable.
- **D-02:** Use an exact structural TSV schema:
  `source_ref`, `fixture_path`, `structural_field`, `structural_category`,
  `structural_value`, and `evidence_boundary`.
- **D-03:** Represent the Phase 49 closed structural field set as exactly 16
  required rows. The field names must be:
  `source_ref`, `inventory_source_paths`, `fixture_source_literal`,
  `fixture_id`, `fixture_path`, `command_count_total`, `command_count_g1`,
  `section_count_total`, `ordered_marker_1`, `ordered_marker_2`,
  `ordered_marker_3`, `ordered_marker_4`, `movement_axis_present`,
  `extrusion_axis_present`, `temperature_marker_count`, and
  `tool_change_marker_count`.
- **D-04:** Use concrete structural values for the selected fixture:
  source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source paths `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`, source
  literal `tests/fff_print/test_gcodewriter.cpp#L20-L35`, fixture ID
  `gcodewriter-set-speed.gcode`, four total commands, four `G1` commands, one
  selected fixture section, the four ordered `G1 F...` markers from the
  checked-in fixture, `false` movement and extrusion axis indicators, and zero
  temperature/tool-change markers.
- **D-05:** Keep bytes, SHA-256, update route, and source provenance in
  `fixture-provenance.tsv` and README text, not in the structural summary
  artifact. The structural summary should describe allowed structural evidence,
  not file integrity metadata or public status publication.

### Fixture verifier ownership

- **D-06:** Extend the existing
  `//packages/parity-fixtures:verify_prusa_gcode_output_fixture` target and
  `verify_prusa_gcode_output_fixture.sh` instead of creating a new structural
  fixture verifier or moving checks into `packages/prusa-gcode-output-scope`.
  The fixture package owns fixture bytes and expected artifacts; the scope
  package remains the metadata-only contract source.
- **D-07:** The verifier must check the structural summary header, exact 16
  rows, required field names, row count, duplicate field rejection,
  source_ref/fixture_path alignment, provenance/update-route alignment, and
  the existing no-overclaiming boundaries.
- **D-08:** Wire the new structural TSV into `packages/parity-fixtures/BUILD.bazel`
  exports, the `prusa_gcode_output_bundle`, the verifier data, and the package
  boundary filegroup so Bazel owns the artifact.
- **D-09:** Update the fixture README and package README only enough to make the
  Phase 50 structural artifact and verification command inspectable. Avoid
  broad doc rewrites and do not update public parity/status wording beyond
  preserving the existing narrow status boundary.

### Mutation coverage

- **D-10:** Use a balanced mutation suite in
  `verify_prusa_gcode_output_fixture_test.sh`: valid fixture passes, then one
  focused negative case for each GCFIX-03 failure class.
- **D-11:** Required negative cases are structural value drift, missing
  required structural row, duplicate structural row, unsupported structural
  field, unsupported broad-behavior claim in fixture-owned text or structural
  notes, and provenance mismatch between the structural summary and
  `fixture-provenance.tsv`.
- **D-12:** Keep mutation tests in the existing temp-checkout style, with each
  test proving one behavior and asserting a diagnostic that points at the
  failing artifact or structural field.

### Scope and status boundaries

- **D-13:** Carry forward Phase 49's additive structural scope contract without
  re-litigating field names or broad deferrals.
- **D-14:** Preserve the current `fork.prusaslicer.gcode-output` status row as
  the narrow summary-only Prusa G-code evidence slice. Phase 50 may strengthen
  fixture evidence but must not promote `generated-outputs` or claim structural
  executable parity.

### the agent's Discretion

- Choose exact Bash helper names and constant layout inside
  `verify_prusa_gcode_output_fixture.sh`, as long as the verifier remains
  readable, exact, and fail-closed.
- Choose whether the structural expected rows are represented as individual
  constants or a compact loop-friendly list, provided failure diagnostics stay
  clear.
- Choose exact README phrasing for Phase 50, provided it keeps the structural
  fixture expansion narrow and does not blur Phase 51 or Phase 52 ownership.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 50 goal, dependencies, requirements, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GCFIX-01, GCFIX-02, GCFIX-03, and the v1.13
  out-of-scope boundary.
- `.planning/PROJECT.md` - milestone goal and current-state constraints for
  v1.13.
- `.planning/STATE.md` - current phase position and accumulated decisions.
- `.planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md` -
  locked Phase 49 structural scope decisions that Phase 50 consumes.

### Structural scope contract

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - closed v1.13
  structural field contract and traceability table.
- `packages/prusa-gcode-output-scope/README.md` - scope package boundary and
  verification command.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  exact scope verifier patterns for structural field and status boundary
  checks.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` -
  mutation-test style for unsupported structural fields and overclaims.

### Fixture package and selected artifact

- `packages/parity-fixtures/BUILD.bazel` - Bazel exports, bundles, verifier
  targets, and package boundary filegroup for fixture artifacts.
- `packages/parity-fixtures/README.md` - fixture package boundary and
  verification behavior.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - existing
  fixture verifier to extend for Phase 50 structural checks.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` -
  existing fixture mutation suite to extend for GCFIX-03.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - selected fixture provenance, update route, and deferred scope text.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - existing summary-only expected artifact that remains unchanged.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, update route, byte count, and hash provenance.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`
  - checked-in selected Prusa `set_speed` fixture bytes.

### Status and future consumers

- `packages/parity/status.tsv` - current broad `generated-outputs` in-progress
  row and narrow `fork.prusaslicer.gcode-output` verified row.
- `packages/parity/BUILD.bazel` - existing Phase 48 public parity target that
  must not be repurposed in Phase 50.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  current summary-only Rust boundary that Phase 51 will extend structurally,
  not Phase 50.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`: Already
  validates G-code bytes, provenance, summary-only expected rows, README
  scope text, status row, parity target, and forbidden verifier behavior.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`:
  Existing temp-checkout mutation harness for fixture drift, malformed
  expected summaries, README overclaims, status drift, parity-target drift, and
  forbidden verifier behavior.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`: The closed
  structural field set Phase 50 must mirror exactly.
- `packages/parity-fixtures/BUILD.bazel`: Existing `prusa_gcode_output_bundle`,
  verifier target, test target, exports, and package boundary filegroup.

### Established Patterns

- Fixture packages own checked-in fixture artifacts and fixture verifiers;
  scope packages own reviewed metadata contracts.
- Verifiers are Bash scripts with exact constants and fail-fast diagnostics,
  run through Bazel `sh_binary` and `sh_test` targets.
- Mutation tests use isolated temp checkout roots and one-behavior failure
  cases.
- Rust parsing and registry readiness remain pure data-in/data-out work for
  later phases, not fixture-verifier work.

### Integration Points

- Add the structural summary TSV under the existing Prusa G-code fixture
  namespace.
- Extend the existing G-code fixture verifier and Bazel wiring in
  `packages/parity-fixtures`.
- Preserve Phase 48 status/parity target behavior while exposing stronger
  fixture-level structural evidence for Phase 51.
</code_context>

<specifics>
## Specific Ideas

- Treat the sidecar structural TSV as the exact handoff artifact for Phase 51.
- Keep the structural value domain intentionally small: decimal counts,
  lowercase booleans, exact source/path strings, and exact ordered marker
  strings.
- Cross-check structural rows against provenance and fixture paths so the two
  expected artifacts cannot silently diverge.
- Keep diagnostics maintainer-friendly: failures should name
  `expected-gcode-structural-summary.tsv` and the missing, duplicated, or
  drifted structural field.
</specifics>

<deferred>
## Deferred Ideas

- Phase 51 owns parsing `expected-gcode-structural-summary.tsv` through a pure
  typed Rust boundary and deciding the internal Rust data model.
- Phase 52 owns public structural parity/status/docs publication.
- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, GUI export/viewer behavior, release behavior, network/device
  behavior, non-Prusa fork behavior, upstream source imports, and sync
  automation remain out of scope.
</deferred>

______________________________________________________________________

*Phase: 50-structural-g-code-fixture-expansion*
*Context gathered: 2026-06-17*
