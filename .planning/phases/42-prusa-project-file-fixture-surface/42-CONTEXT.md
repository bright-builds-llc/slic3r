______________________________________________________________________

## generated_by: gsd-discuss-phase lifecycle_mode: yolo phase_lifecycle_id: 42-2026-06-03T20-35-51 generated_at: 2026-06-03T20:35:51.198Z

# Phase 42: Prusa Project-File Fixture Surface - Context

**Gathered:** 2026-06-03
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 42 creates the checked-in fixture surface for the narrow
`prusaslicer.project-file` evidence contract selected in Phase 41.

The phase must give maintainers an inspectable Prusa project-file fixture
namespace, provenance manifest, update rules, checked-in expected artifact, and
repo-owned fail-closed fixture verifier. Those artifacts must trace directly to
the Phase 41 scope record and accepted source decision.

This phase does not create the Phase 43 Rust project-file parser or summary
boundary, does not create the Phase 44 parity command, does not publish
`fork.prusaslicer.project-file` in `packages/parity/status.tsv`, and does not
claim full 3MF import/export, GUI project behavior, generated-output parity, or
broader PrusaSlicer runtime support.

</domain>

<decisions>
## Implementation Decisions

### Fixture Namespace and Provenance

- **D-01:** Use the Phase 41 reserved flat namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`.
- **D-02:** Check in the source-pinned upstream fixture as
  `seam_test_object.3mf` in that namespace, with `.gitattributes` marking the
  fixture as binary.
- **D-03:** Record provenance in `fixture-provenance.tsv` using the existing
  profile-schema fixture model: fixture ID, vendor ID, inventory ID, source ref,
  accepted tag, peeled commit, source path, upstream URL, byte count, SHA-256,
  line endings, role, Phase 41 scope record path, update route, status scope,
  and exclusions.
- **D-04:** Pin the fixture to
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, source
  path `tests/data/seam_test_object.3mf`, size `2514963`, SHA-256
  `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`, and
  binary line-ending handling.
- **D-05:** The update route must require a reviewed intake change updating
  `packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
  and the Phase 41 project-file scope gate. Branch-head observations remain
  drift-only and do not update this fixture.

### Expected Artifact

- **D-06:** Create
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  with exactly these columns: `source_ref`, `fixture_path`, `archive_member`,
  `project_marker`, `deferred_semantics`, and `notes`.
- **D-07:** Use the expected artifact for shallow package-shape and marker
  evidence only. Rows should cover required archive members such as
  `[Content_Types].xml`, `_rels/.rels`, `3D/3dmodel.model`,
  `Metadata/thumbnail.png`, `Metadata/Slic3r_PE.config`, and
  `Metadata/Slic3r_PE_model.config`.
- **D-08:** `project_marker` values should stay presence-level and
  non-semantic, such as OPC content types, start-part relationship,
  `slic3rpe:Version3mf`, `Application=PrusaSlicer-2.8.0-alpha3`, and
  Prusa/Slic3r metadata config file presence.
- **D-09:** Keep byte counts, hashes, and upstream URLs in provenance, not in
  `expected-project-summary.tsv`.
- **D-10:** Do not include geometry counts, config key counts, printer/profile
  semantics, generated-output details, import/export behavior, status rows, or
  runtime claims in the expected artifact.

### Fail-Closed Verifier

- **D-11:** Add Bazel targets in `packages/parity-fixtures/BUILD.bazel`:
  `verify_prusa_project_file_fixture`,
  `verify_prusa_project_file_fixture_test`, and project-file fixture aliases or
  filegroups following the existing `prusaslicer.profile-schema` pattern.
- **D-12:** Implement the verifier as Bash with exact text checks plus targeted
  TSV header/row checks. Prefer the existing Phase 38 fixture verifier and
  Phase 41 scope verifier style over a new parser framework.
- **D-13:** The verifier must fail when required fixture bytes, provenance,
  expected-artifact columns, update-route text, scope-record traceability, or
  non-overclaiming boundary text are missing or inconsistent.
- **D-14:** The verifier or its tests must include negative guards that Phase 43
  and Phase 44 artifacts have not been created early: no
  `slic3r_flavors::prusa_project_file` parser surface, no
  `//packages/parity:prusaslicer_project_file_parity` target, and no
  `fork.prusaslicer.project-file` status row.
- **D-15:** Verification should remain local and hermetic. Do not fetch upstream
  source during verification, execute profile auto-update behavior, import
  upstream source trees, run Git, access network services, or ingest plugins.

### Docs and Handoff

- **D-16:** Update `packages/parity-fixtures/README.md` and relevant
  `docs/port/` surfaces so maintainers can find the new fixture namespace,
  run the fixture verifier, and understand that executable project-file parity
  remains unavailable until Phase 44.
- **D-17:** Docs must continue to defer full PrusaSlicer runtime support, GUI
  project behavior, full 3MF import/export, generated-output parity, STEP
  import, support generation, arc fitting, wall seam behavior, network/device
  integration, profile auto-update execution, fork release builds, Bambu
  Studio, OrcaSlicer, upstream source imports, and sync automation.

### the agent's Discretion

- The agent may decide the exact row wording for `expected-project-summary.tsv`
  as long as the file keeps the Phase 41 columns exactly and stays
  presence-level rather than semantic.
- The agent may decide whether to share small Bash helper functions with the
  existing profile-schema verifier or keep a separate project-file verifier,
  whichever is clearer and lower risk.
- The agent may decide the minimum doc set to update, provided the package
  README and port docs expose the fixture verifier and preserve the
  non-overclaiming boundary.

</decisions>

\<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 42 goal, PFIX success criteria, and v1.11
  execution order.
- `.planning/REQUIREMENTS.md` - PFIX-01 and PFIX-02 plus explicit v1.11
  out-of-scope exclusions.
- `.planning/PROJECT.md` - current milestone goal and Prusa project-file scope
  state.
- `.planning/STATE.md` - current Phase 42 position and recent v1.11 decisions.

### Phase 41 Contract

- `packages/prusa-project-file-scope/project-file-scope.md` - accepted source
  identity, fixture source decision, expected-artifact contract, downstream
  Rust boundary, planned parity command, planned status token, docs touched,
  license/security note, deferred scope, and reviewer signoff.
- `packages/prusa-project-file-scope/README.md` - Phase 41 package boundary and
  verifier route.
- `packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh` -
  fail-closed scope verifier style.
- `packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh` -
  failure-mode shell test style.
- `.planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md` - Phase
  41 implementation summary and handoff.
- `.planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md` -
  Phase 41 verified truths and negative checks.

### Existing Fixture Patterns

- `packages/parity-fixtures/README.md` - fixture package rules, fork namespace
  policy, provenance expectations, and current state.
- `packages/parity-fixtures/BUILD.bazel` - profile-schema fixture aliases,
  filegroup, verifier, and shell test pattern.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md`
  - Prusa fixture README structure, provenance fields, update route, status
    boundary, and exclusions.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv`
  - TSV provenance row shape.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv`
  - checked-in expected artifact precedent.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` - existing
  fixture verifier implementation pattern.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` -
  existing verifier failure-mode test pattern.

### Docs and Traceability

- `docs/port/README.md` - current Prusa project-file scope gate state and
  fixture path contract.
- `docs/port/package-map.md` - package ownership and Phase 41/42 package route.
- `docs/port/migration-guidance.md` - fixture update route and project-file
  status gating.
- `docs/port/parity-matrix.md` - current non-verified project-file status and
  narrow-scope wording.
- `packages/fork-inventories/prusaslicer.tsv` - `prusaslicer.project-file`
  source-observed inventory row.
- `packages/fork-vendors/forks.tsv` - accepted PrusaSlicer source identity.

\</canonical_refs>

\<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`:
  existing flat fork fixture namespace to mirror for `prusaslicer.project-file`.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh`: Bash
  verifier with file, size, SHA-256, provenance, README, namespace, and status
  checks.
- `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh`:
  failure-mode test pattern for missing or inconsistent fixture artifacts.
- `packages/prusa-project-file-scope/project-file-scope.md`: Phase 42's source
  of truth for fixture source, expected artifact, planned command, planned
  status token, and deferred scope.

### Established Patterns

- Fork fixtures are source-pinned, checked in, and verified locally.
- Checked-in expected artifacts are narrow and explicit; broader semantic
  parsing waits for Rust boundary phases.
- Docs and status rows must name exact verified surfaces and avoid broad
  PrusaSlicer runtime claims.
- Bazel `sh_binary` and `sh_test` targets are the established fixture verifier
  surface for this package.

### Integration Points

- `packages/parity-fixtures/BUILD.bazel` must expose project-file fixture files
  and verifier targets.
- `docs/port/README.md`, `docs/port/package-map.md`,
  `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md` should
  route maintainers from the Phase 41 scope gate to the Phase 42 fixture
  surface without claiming Phase 44 evidence.
- Later Phase 43 will consume `expected-project-summary.tsv` and fixture
  provenance for a pure Rust `slic3r_flavors::prusa_project_file` boundary.
- Later Phase 44 will consume the expected artifact when creating
  `//packages/parity:prusaslicer_project_file_parity` and the
  `fork.prusaslicer.project-file` status row.

\</code_context>

<specifics>
## Specific Ideas

- Reuse the profile-schema fixture bundle shape unless a concrete implementation
  blocker appears.
- Treat `seam_test_object.3mf` as a checked-in binary fixture, not as a network
  fetch in the verifier.
- Keep project-file evidence at the ZIP/OPC member and marker level for Phase
  42\. Deeper 3MF parsing and semantic summaries belong in Phase 43.
- Use exact negative checks so `fork.prusaslicer.project-file` cannot appear in
  `packages/parity/status.tsv` before executable Phase 44 evidence exists.

</specifics>

<deferred>
## Deferred Ideas

Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
generated-output parity, STEP import, support generation, arc fitting, wall
seam behavior, network/device integration, profile auto-update execution, fork
release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
automation remain outside Phase 42.

</deferred>

______________________________________________________________________

*Phase: 42-prusa-project-file-fixture-surface*
*Context gathered: 2026-06-03*
