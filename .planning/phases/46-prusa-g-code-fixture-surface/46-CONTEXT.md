---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 46-2026-06-13T16-58-19
generated_at: 2026-06-13T16:58:19.738Z
---

# Phase 46: Prusa G-code Fixture Surface - Context

**Gathered:** 2026-06-13
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 46 creates the checked-in fixture surface for the narrow
`prusaslicer.gcode-output` evidence contract selected in Phase 45.

The phase must give maintainers an inspectable Prusa G-code fixture namespace,
one small reviewed ASCII `.gcode` fixture, provenance manifest, update rules,
line-ending and encoding policy, byte count, SHA-256, checked-in
`expected-gcode-summary.tsv`, and a repo-owned fail-closed fixture verifier.
Those artifacts must trace directly to the Phase 45 scope record and accepted
PrusaSlicer source identity.

This phase does not create the Phase 47 Rust G-code summary boundary, does not
create the Phase 48 parity command, does not publish
`fork.prusaslicer.gcode-output` in `packages/parity/status.tsv`, and does not
claim byte-for-byte G-code parity, broad generated-output parity, toolpath
geometry, extrusion, timing, support generation, wall seam behavior, arc
fitting, STEP import, full 3MF import/export, printer-runtime behavior,
firmware or printability behavior, GUI export or viewer behavior, binary
G-code, thumbnails, post-processing, host upload, network/device integration,
profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
upstream source imports, or sync automation.

</domain>

<decisions>

## Implementation Decisions

### Fixture Namespace and Provenance

- **D-01:** Use the Phase 45 reserved flat namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
- **D-02:** Check in one small reviewed ASCII `.gcode` fixture in that
  namespace, with `.gitattributes` forcing text, LF line endings, and stable
  diff behavior for the fixture and TSV artifacts.
- **D-03:** Record provenance in `fixture-provenance.tsv` using the existing
  Prusa fork fixture model: fixture ID, vendor ID, inventory ID, source ref,
  accepted tag, peeled commit, source path, upstream URL, byte count, SHA-256,
  line-ending/encoding policy, role, Phase 45 scope record path, update route,
  status scope, privacy/post-processing exclusions, and broad deferrals.
- **D-04:** Pin all provenance to the accepted source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` from
  the Phase 45 scope gate and `packages/fork-inventories/prusaslicer.tsv`.
  The selected fixture should come from PrusaSlicer source-controlled test or
  fixture data under that commit, not from live generation or a local printer
  export.
- **D-05:** The update route must require a reviewed intake change updating
  `packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
  and `packages/prusa-gcode-output-scope/gcode-output-scope.md`. Branch-head
  observations remain drift-only and do not update this fixture.

### Expected G-code Summary

- **D-06:** Create
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  as the only checked-in expected artifact for this phase.
- **D-07:** Keep the expected summary stable and summary-only. It should cover
  metadata and marker evidence such as source identity, fixture path, slicer or
  generated-by marker, flavor or printer/profile marker when present,
  representative G-code command markers, and deferred semantics notes.
- **D-08:** Use the exact columns reserved by the Phase 45 scope record:
  `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`,
  `marker_key`, `marker_value`, and `notes`.
- **D-09:** Keep byte counts, hashes, upstream URLs, and update-route facts in
  provenance, not in `expected-gcode-summary.tsv`.
- **D-10:** Do not include geometry counts, extrusion totals, print duration,
  toolpath correctness, firmware compatibility, printability semantics,
  post-processing behavior, thumbnail/binary payloads, host upload behavior,
  status rows, or broad generated-output claims in the expected artifact.
  Use `notes` values to state the deferred semantics for each marker row.

### Fail-Closed Verifier

- **D-11:** Extend `packages/parity-fixtures/BUILD.bazel` with G-code fixture
  file exports, filegroups or aliases, `verify_prusa_gcode_output_fixture`, and
  `verify_prusa_gcode_output_fixture_test`, following the existing
  `prusaslicer.project-file` and `prusaslicer.profile-schema` fixture pattern.
- **D-12:** Implement the verifier as Bash with exact text checks plus targeted
  TSV header/row checks. Prefer the existing Prusa project-file and
  profile-schema fixture verifier style over a new parser framework.
- **D-13:** The verifier must fail when required fixture bytes, provenance,
  byte count, SHA-256, line-ending/encoding policy, expected-summary columns,
  update-route text, Phase 45 scope-record traceability, privacy or
  post-processing exclusions, or non-overclaiming boundary text are missing or
  inconsistent.
- **D-14:** The verifier or its tests must guard that Phase 47 and Phase 48
  artifacts have not been created early: no
  `slic3r_flavors::prusa_gcode_output` summary implementation, no
  `//packages/parity:prusaslicer_gcode_output_parity` target, and no
  `fork.prusaslicer.gcode-output` status row.
- **D-15:** Verification must remain local and hermetic. Do not fetch upstream
  source during verification, generate new G-code, execute printer-runtime
  behavior, run Git, access network services, import upstream source trees,
  ingest plugins, or process credentials.

### Docs and Handoff

- **D-16:** Update `packages/parity-fixtures/README.md` and the relevant
  `docs/port/` surfaces so maintainers can find the new fixture namespace, run
  the fixture verifier, and understand that Rust summary parsing, executable
  parity, and status publication remain unavailable until Phases 47 and 48.
- **D-17:** Docs must continue to defer byte-for-byte G-code parity, broad
  generated-output parity, toolpath geometry, extrusion, timing, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, printer-runtime behavior, firmware or printability behavior,
  GUI export or viewer behavior, binary G-code, thumbnails, post-processing,
  host upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
  automation.

### the agent's Discretion

- The agent may choose the exact small Prusa-controlled ASCII `.gcode` fixture
  from the accepted source commit, as long as provenance records the exact
  source path, byte count, SHA-256, encoding, and update route.
- The agent may choose exact marker rows for `expected-gcode-summary.tsv` when
  they remain stable, summary-only, and useful to Phase 47 typed parsing.
- The agent may decide whether to share small Bash helper functions with
  existing fixture verifiers or keep a separate G-code verifier, whichever is
  clearer and lower risk.
- The agent may choose the minimum docs set to update, provided the fixture
  package README and port docs expose the verifier and preserve the
  non-overclaiming boundary.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 46 goal, dependency on Phase 45, PGFIX
  success criteria, and v1.12 execution order.
- `.planning/REQUIREMENTS.md` - PGFIX-01 and PGFIX-02 plus explicit v1.12
  out-of-scope exclusions.
- `.planning/PROJECT.md` - current milestone goal, current state, and evidence
  ladder constraints.
- `.planning/STATE.md` - current milestone state and recent Phase 45 decisions.
- `.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md` - Phase
  45 handoff decisions for fixture path, summary contract, Rust boundary,
  command/status names, and deferrals.
- `.planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md` -
  Phase 45 verified truths and required absence boundaries.

### Phase 45 Contract

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - accepted source
  identity, fixture source decision, expected-summary contract, downstream Rust
  boundary, planned parity command, planned status token, docs touched,
  license/security note, deferred scope, and reviewer signoff.
- `packages/prusa-gcode-output-scope/README.md` - Phase 45 package boundary and
  verifier route.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  fail-closed scope verifier style and Phase 46 absence checks.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
  - failure-mode shell test style for overclaiming and premature artifacts.

### Existing Fixture Patterns

- `.planning/milestones/v1.11-phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md`
  - prior yolo fixture-surface decisions to mirror for the G-code fixture
  phase.
- `packages/parity-fixtures/README.md` - fixture package rules, fork namespace
  policy, provenance expectations, and current state.
- `packages/parity-fixtures/BUILD.bazel` - existing Prusa fixture file exports,
  filegroups, verifier targets, and shell test pattern.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md`
  - Prusa fixture README structure, provenance fields, update route, status
  boundary, and exclusions.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv`
  - TSV provenance row shape for source-pinned fork fixtures.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  - checked-in expected artifact precedent.
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` - existing
  fixture verifier implementation pattern.
- `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` -
  existing verifier failure-mode test pattern.

### Docs and Traceability

- `docs/port/README.md` - current Prusa G-code output scope gate state and
  future fixture/Rust/parity handoff language.
- `docs/port/package-map.md` - package ownership and Phase 45 package route.
- `docs/port/migration-guidance.md` - fixture update route and G-code output
  status gating.
- `docs/port/parity-matrix.md` - current non-verified G-code status and
  narrow-scope wording.
- `packages/fork-inventories/prusaslicer.tsv` - `prusaslicer.gcode-output`
  source-observed inventory row.
- `packages/fork-vendors/forks.tsv` - accepted PrusaSlicer source identity.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`:
  existing flat fork fixture namespace to mirror for
  `prusaslicer.gcode-output`.
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh`: Bash
  verifier with file, size, SHA-256, provenance, README, expected summary,
  namespace, parity target, and status checks.
- `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh`:
  failure-mode test pattern for missing or inconsistent fixture artifacts.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`: Phase 46's source
  of truth for fixture source, expected artifact, planned command, planned
  status token, and deferred scope.

### Established Patterns

- Fork fixtures are source-pinned, checked in, and verified locally.
- Checked-in expected artifacts are narrow and explicit; broader semantic
  parsing waits for Rust boundary phases.
- Docs and status rows must name exact verified surfaces and avoid broad
  PrusaSlicer runtime or generated-output claims.
- Bazel `sh_binary` and `sh_test` targets are the established fixture verifier
  surface for `packages/parity-fixtures`.

### Integration Points

- `packages/parity-fixtures/BUILD.bazel` must expose G-code fixture files and
  verifier targets.
- `docs/port/README.md`, `docs/port/package-map.md`,
  `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md` should
  route maintainers from the Phase 45 scope gate to the Phase 46 fixture
  surface without claiming Phase 48 evidence.
- Later Phase 47 will consume `expected-gcode-summary.tsv` and fixture
  provenance for a pure Rust `slic3r_flavors::prusa_gcode_output` boundary.
- Later Phase 48 will consume the expected artifact when creating
  `//packages/parity:prusaslicer_gcode_output_parity` and the
  `fork.prusaslicer.gcode-output` status row.

</code_context>

<specifics>

## Specific Ideas

- Reuse the project-file fixture bundle shape unless a concrete implementation
  blocker appears.
- Treat the `.gcode` file as a checked-in upstream fixture, not as a network
  fetch or generated artifact in the verifier.
- Keep Phase 46 evidence at metadata and marker level. Deeper Rust parsing,
  generated-output comparison, and status publication belong in Phases 47 and
  48.
- Use exact negative checks so `fork.prusaslicer.gcode-output` cannot appear in
  `packages/parity/status.tsv` before executable Phase 48 evidence exists.

</specifics>

<deferred>

## Deferred Ideas

Phase 47 owns Rust `prusa_gcode_output` summary types, parser/summary logic,
metadata, and Rust tests. Phase 48 owns executable parity, mutation guard,
exact status publication, and public docs/status alignment.

Byte-for-byte G-code parity, broad generated-output parity, toolpath geometry,
extrusion, timing, support generation, wall seam behavior, arc fitting, STEP
import, full 3MF import/export, printer-runtime behavior, firmware or
printability behavior, GUI export or viewer behavior, binary G-code,
thumbnails, post-processing, host upload, network/device integration, profile
auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream
source imports, and sync automation remain outside Phase 46.

</deferred>

______________________________________________________________________

*Phase: 46-prusa-g-code-fixture-surface*
*Context gathered: 2026-06-13*
