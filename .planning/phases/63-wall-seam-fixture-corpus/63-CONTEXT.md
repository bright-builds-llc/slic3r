---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 63-2026-06-26T23-55-59
generated_at: 2026-06-26T23:56:59.810Z
---

# Phase 63: Wall-Seam Fixture Corpus - Context

**Gathered:** 2026-06-26
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 63 creates the source-pinned `prusaslicer.wall-seam` fixture namespace,
fixture provenance, checked-in expected wall-seam summary, package bundle, and
fail-closed fixture verification required before Phase 64 Rust parsing or
Phase 65 public evidence/status/docs publication.

The phase completes SEAMFIX-01, SEAMFIX-02, and SEAMFIX-03 only. It must use
the Phase 62 approved field contract, preserve the existing
`fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting` meanings,
keep broad `generated-outputs` in progress, and avoid claiming byte-for-byte
G-code parity, full generated-output parity, full wall-seam algorithm or
geometry equivalence, seam visibility, printability, printer-runtime behavior,
GUI behavior, upstream source imports, release behavior, sync automation, or
non-Prusa fork behavior.
</domain>

<decisions>
## Implementation Decisions

### Fixture namespace and provenance

- **D-01:** Use the Phase 62 planned flat namespace
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/` instead
  of adding subdirectories or broad generated-output fixture intake. This
  matches the existing Prusa fixture namespace pattern and keeps Phase 63
  reviewable.
- **D-02:** Add one tiny checked-in ASCII/LF wall-seam observation fixture,
  expected as `wall-seam-observations.gcode`, unless implementation discovers
  a narrow reason to rename the file and records that reason in the plan
  summary. The fixture should be small enough for exact byte/SHA review and
  should contain only static observation data.
- **D-03:** Shape `fixture-provenance.tsv` after the Phase 58 arc-fitting
  precedent with one row containing fixture identity, vendor, inventory ID,
  accepted source ref, accepted tag, peeled commit, source path, source
  anchors, byte count, SHA-256, line-ending/encoding, role, Phase 62 scope
  record path, update route, status scope, privacy/post-processing exclusions,
  and broad deferrals.
- **D-04:** The update route should require a reviewed intake change that
  updates `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/prusaslicer.tsv`, and
  `packages/prusa-wall-seam-scope/wall-seam-scope.md`. Branch-head
  observation, upstream import, live generation, network access, and sync
  behavior must not update checked-in fixture bytes or expected-summary rows.

### Expected wall-seam summary

- **D-05:** Use an arc-style long-row TSV named
  `expected-wall-seam-summary.tsv` with header:
  `source_ref`, `fixture_path`, `wall_seam_field`,
  `wall_seam_category`, `wall_seam_value`, and `evidence_boundary`.
- **D-06:** Include exactly the 12 Phase 62 approved fields in approved order:
  `source_ref`, `inventory_source_paths`, `source_anchor`, `fixture_id`,
  `fixture_path`, `seam_transition_observations`,
  `layer_context_observations`, `travel_context_observations`,
  `coordinate_bounds`, `extrusion_observations`,
  `retraction_observations`, and `evidence_boundary`.
- **D-07:** Keep summary values deterministic ASCII/LF `key:value` style
  facts that are easy to verify exactly in Bash and easy for Phase 64 to parse
  into typed Rust values. Do not use JSON or a wide one-row fixture table in
  Phase 63.
- **D-08:** Every summary row must carry explicit evidence-boundary text. The
  final boundary value should remain a narrow phrase such as
  `checked-in-wall-seam-summary-only`; rows must not imply byte parity, full
  wall-seam algorithm equivalence, seam visibility, printability, runtime,
  firmware, GUI, or generated-output status evidence.

### Fixture verifier and mutation coverage

- **D-09:** Add `verify_prusa_wall_seam_fixture.sh` as a local-file-only Bash
  verifier in `packages/parity-fixtures`, following the arc-fitting fixture
  verifier pattern: `set -euo pipefail`, deterministic `error:` diagnostics,
  package-local defaults, Bazel-compatible argument mode, and final
  `ok: Prusa wall-seam fixture verification passed` output.
- **D-10:** The verifier must check fixture bytes, SHA-256, ASCII/LF encoding,
  provenance header and exact row, expected-summary header, exact row count,
  supported field set, required field counts, provenance alignment, exact
  approved row order, package README text, namespace README text, current
  status boundaries, and no overclaiming text.
- **D-11:** Add `verify_prusa_wall_seam_fixture_test.sh` with isolated temp
  fixture copies and focused mutation cases. Required failure classes include
  missing rows, duplicate rows, out-of-order rows, unsupported seam fields,
  unsupported claim text, wrong source refs, wrong fixture identities,
  checksum drift, stale package documentation references, generated-output
  status promotion, sibling status-row widening, and premature
  `fork.prusaslicer.wall-seam` publication.
- **D-12:** Wire Bazel aliases, a `prusa_wall_seam_bundle` filegroup,
  `verify_prusa_wall_seam_fixture` sh_binary, and
  `verify_prusa_wall_seam_fixture_test` sh_test in
  `packages/parity-fixtures/BUILD.bazel`. The bundle should include
  `.gitattributes`, namespace README, fixture bytes, provenance TSV, and
  expected summary TSV.

### Phase handoff boundaries

- **D-13:** Phase 63 may update `packages/parity-fixtures/README.md` and
  package-local fixture docs to describe the fixture namespace and verifier,
  but it must not update public parity status, add the Phase 65 public command,
  or publish public port docs as verified wall-seam evidence.
- **D-14:** Phase 64 owns the pure typed Rust boundary
  `slic3r_flavors::prusa_wall_seam` and parser/readiness tests over the
  checked-in summary artifact. Phase 63 should make that handoff easy by
  keeping field names, categories, values, and evidence boundaries stable and
  exact.
- **D-15:** Phase 65 owns `bazel run
  //packages/parity:prusaslicer_wall_seam_parity`, the
  `fork.prusaslicer.wall-seam` status row, public mutation guards, and public
  port/package docs. Phase 63 verifier status checks should keep that row
  absent until Phase 65.

### the agent's Discretion

- Choose the exact static G-code observation lines, provided they are small,
  deterministic, ASCII/LF, reviewed as checked-in observation input only, and
  support all 12 approved summary fields without claiming generated-output
  parity.
- Choose exact `key:value` summary value grammar, provided the grammar is
  deterministic, readable, and suitable for exact Bash checks plus later typed
  Rust parsing.
- Choose helper names and mutation test names, provided the verifier remains
  local-file-only, fail-closed, and each mutation test proves one clear
  failure mode.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 63 goal, dependency, requirement IDs,
  success criteria, plan list, and planning notes.
- `.planning/REQUIREMENTS.md` - SEAMFIX-01, SEAMFIX-02, SEAMFIX-03, and the
  v1.16 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.16 milestone goal, current-state constraints,
  and key decisions for the wall-seam evidence ladder.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  the v1.12-v1.16 Prusa generated-output evidence ladder.

### Wall-seam scope contract

- `.planning/phases/62-wall-seam-scope-contract/62-CONTEXT.md` - locked
  decisions for the Phase 62 wall-seam scope contract, planned namespace,
  approved fields, status constraints, and downstream handoff.
- `.planning/phases/62-wall-seam-scope-contract/62-VERIFICATION.md` - passed
  Phase 62 verification report and required Phase 63 deferrals.
- `packages/prusa-wall-seam-scope/wall-seam-scope.md` - reviewed source
  identity, approved 12-field wall-seam summary contract, planned paths, and
  boundary language.
- `packages/prusa-wall-seam-scope/verify_prusa_wall_seam_scope.sh` - exact
  scope verifier that Phase 63 fixture work must remain compatible with.

### Fixture precedent

- `packages/parity-fixtures/README.md` - fixture namespace rules, update
  route expectations, and Prusa fixture evidence history.
- `packages/parity-fixtures/BUILD.bazel` - existing aliases, bundles, verifier
  sh_binary targets, and sh_test wiring for Prusa fixture namespaces.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md`
  - closest completed feature-specific fixture namespace docs.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv`
  - provenance row shape to mirror for wall-seam fixture identity and update
  route.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  - long-row expected summary pattern to adapt for wall-seam fields.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - fail-closed
  fixture verifier pattern for bytes, SHA, summary rows, docs, and status
  boundaries.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh` -
  isolated mutation-test pattern for fixture verifier negative cases.

### Traceability and status boundaries

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.wall-seam` row and source path.
- `packages/fork-inventories/category-map.tsv` - `seam.shared` row that maps
  the Prusa wall-seam row.
- `packages/parity/status.tsv` - broad `generated-outputs` row, existing
  `fork.prusaslicer.gcode-output` row, existing
  `fork.prusaslicer.arc-fitting` row, and future Phase 65 insertion point for
  `fork.prusaslicer.wall-seam`.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting`: Best
  fixture namespace model for Phase 63, including flat layout,
  `.gitattributes`, namespace README, fixture bytes, provenance, and expected
  summary.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh`: Best
  verifier model for exact fixture bytes, TSV rows, package docs, no-runtime
  checks, overclaim rejection, and status preservation.
- `packages/prusa-wall-seam-scope`: Phase 62 source of truth for wall-seam
  source identity, approved fields, planned paths, and forbidden claims.

### Established Patterns

- Feature-specific Prusa fixture namespaces stay flat, small, checked-in, and
  source-pinned.
- Expected summaries use exact TSV contracts rather than runtime generation or
  loose parsing.
- Fixture verification is local-file-only Bash with exact rows and isolated
  mutation suites before Rust parser or public parity phases consume the
  artifact.
- Public status rows are published only after executable evidence phases, not
  during fixture corpus phases.

### Integration Points

- Phase 63 integrates with `packages/parity-fixtures/BUILD.bazel` by adding
  wall-seam fixture exports, aliases, bundle, verifier, and mutation test.
- Phase 63 integrates with `packages/parity-fixtures/README.md` by adding a
  Phase 63 wall-seam namespace paragraph and verification command.
- Phase 64 will consume
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`
  through a pure Rust parser/readiness boundary.
- Phase 65 will consume the checked-in fixture and Phase 64 parser to publish
  public parity evidence, status, and docs.
</code_context>

<specifics>
## Specific Ideas

- Use `wall-seam-observations.gcode` as the likely fixture filename.
- Use `expected-wall-seam-summary.tsv` with the field column named
  `wall_seam_field`, mirroring `arc_field` from the arc-fitting summary.
- Keep the final summary boundary value narrow:
  `checked-in-wall-seam-summary-only`.
- Treat unsupported source import, Git, network, live generation, slicer
  runtime behavior, host upload, printer-runtime behavior, and sync behavior
  as forbidden verifier behavior.
</specifics>

<deferred>
## Deferred Ideas

- Multiple wall-seam fixture files or a subdirectory-based fixture family are
  deferred until a future phase explicitly needs broader wall-seam corpus
  growth.
- JSON-valued summary rows and wide one-row fixture summaries are deferred; the
  long-row TSV shape is preferred for exact Bash verification and Phase 64
  Rust parsing.
- Phase 64 owns typed Rust parsing, readiness metadata, and Cargo/Bazel parser
  tests.
- Phase 65 owns public executable evidence, public status/docs publication,
  and public wall-seam mutation guards.
- Broad generated-output parity, byte-for-byte G-code parity, full wall-seam
  algorithm or geometry equivalence, seam visibility, printability, runtime,
  GUI, release, sync, non-Prusa forks, upstream imports, and external device
  behavior remain out of scope.
</deferred>

---

*Phase: 63-wall-seam-fixture-corpus*
*Context gathered: 2026-06-26*
