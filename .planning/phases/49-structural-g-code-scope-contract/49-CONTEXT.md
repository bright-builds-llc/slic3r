______________________________________________________________________

## generated_by: gsd-discuss-phase lifecycle_mode: yolo phase_lifecycle_id: 49-2026-06-16T14-43-39 generated_at: 2026-06-16T14:43:39.375Z

# Phase 49: Structural G-code Scope Contract - Context

**Gathered:** 2026-06-16
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 49 updates the reviewed Prusa G-code scope contract before any v1.13
fixture, Rust parser, or executable evidence expansion lands. The phase must
name exactly which structural G-code evidence fields are allowed for v1.13 and
must keep forbidden generated-output claims fail-closed.

The phase completes GCSCOPE-01, GCSCOPE-02, and GCSCOPE-03 only. It does not
create the Phase 50 structural fixture artifact, the Phase 51 Rust structural
summary parser, or the Phase 52 public parity command/status publication.
</domain>

<decisions>
## Implementation Decisions

### Contract placement

- **D-01:** Extend the existing `packages/prusa-gcode-output-scope` package
  instead of creating a new structural-scope package. This keeps the v1.13
  contract on the same reviewed evidence chain as Phases 45 through 48.
- **D-02:** Keep `packages/prusa-gcode-output-scope/gcode-output-scope.md` as
  the human-readable source of truth, with a new v1.13 structural section that
  is visibly additive over the v1.12 summary-only contract.
- **D-03:** Update `packages/prusa-gcode-output-scope/README.md` only enough to
  describe the reviewed structural scope expansion and the verification
  command. Avoid broad doc rewrites.

### Allowed structural evidence fields

- **D-04:** The contract must explicitly allow command counts, section counts,
  ordered markers, movement/extrusion indicators, temperature/tool-change
  markers, source identity, and fixture identity.
- **D-05:** Allowed fields should be expressed as a closed set in both the
  scope record and verifier logic. The verifier should fail on unsupported
  structural fields instead of treating unknown columns or terms as harmless.
- **D-06:** The structural field names should be chosen so Phase 50 can produce
  a checked-in expected structural summary without reinterpreting the scope
  contract. Prefer stable, TSV-friendly names over prose-only labels.

### Fail-closed forbidden claims

- **D-07:** Preserve all v1.12 no-overclaiming prohibitions: no byte-for-byte
  G-code parity, geometry/toolpath parity, printability, printer-runtime
  behavior, support generation, wall seam behavior, arc fitting, GUI
  export/viewer behavior, release behavior, network/device behavior, non-Prusa
  fork behavior, upstream source imports, or sync automation.
- **D-08:** Expand mutation coverage so unsupported structural fields and
  unsupported broad-behavior claim text fail closed. The mutation suite should
  prove both missing required structural contract text and forbidden claim
  insertion paths.
- **D-09:** Keep the broad `generated-outputs` row in progress. Phase 49 may
  reference the existing verified `fork.prusaslicer.gcode-output` row only as
  the narrow v1.12 evidence path that the structural expansion builds on.

### Traceability

- **D-10:** The updated scope contract must trace back to the accepted
  `prusaslicer.gcode-output` inventory row, `gcode.shared` category-map row,
  the v1.12 fixture namespace, the expected summary artifact, and the published
  narrow parity status row.
- **D-11:** The verifier should continue requiring the existing exact inventory
  and category-map rows so the v1.13 structural contract cannot drift to a
  branch-head observation, another Prusa feature, or a non-Prusa fork.
- **D-12:** Docs and status wording should continue to say that structural
  evidence is narrow evidence, not broad generated-output parity.

### the agent's Discretion

- Choose the exact helper function boundaries inside
  `verify_prusa_gcode_output_scope.sh`, as long as they stay readable,
  fail-closed, and follow the existing Bash style.
- Choose the exact mutation-test helper names in
  `verify_prusa_gcode_output_scope_test.sh`, as long as each new case proves
  one behavior and is easy to diagnose.
- Decide whether to add one new scope-record table section or extend existing
  rows, provided the resulting contract is inspectable and does not blur
  v1.12 summary-only evidence with v1.13 structural evidence.
  </decisions>

\<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 49 goal, dependencies, requirements, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GCSCOPE-01, GCSCOPE-02, and GCSCOPE-03 plus the
  v1.13 out-of-scope boundary.
- `.planning/PROJECT.md` - milestone goal and current-state constraints for
  v1.13.
- `.planning/STATE.md` - current phase position and accumulated decisions from
  v1.12 and v1.13 setup.

### Existing Prusa G-code scope contract

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - current reviewed
  `prusaslicer.gcode-output` scope record and deferred-scope list.
- `packages/prusa-gcode-output-scope/README.md` - package boundary and public
  verification command.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  fail-closed scope verifier that Phase 49 must extend.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` -
  mutation suite pattern for scope drift and overclaiming checks.
- `packages/prusa-gcode-output-scope/BUILD.bazel` - Bazel targets for the
  scope verifier and mutation suite.

### Source and status traceability

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.gcode-output` inventory row.
- `packages/fork-inventories/category-map.tsv` - `gcode.shared` category-map
  reference to `prusaslicer.gcode-output`.
- `packages/parity/status.tsv` - existing broad `generated-outputs` in-progress
  row and narrow `fork.prusaslicer.gcode-output` verified row.
- `packages/parity/README.md` - public description of the narrow summary-only
  Prusa G-code parity command.
- `docs/port/parity-matrix.md` - port-level parity-status wording and deferred
  generated-output boundaries.
- `docs/port/migration-guidance.md` - migration guidance for the Prusa G-code
  evidence chain.
- `docs/port/package-map.md` - package ownership for
  `packages/prusa-gcode-output-scope`.

### Existing fixture and Rust boundary handoff

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - v1.12 fixture provenance and update route.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - current summary-only artifact that Phase 50 will structurally expand.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, source path, byte count, and hash provenance.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  existing pure Rust summary boundary that Phase 51 will extend structurally.
  \</canonical_refs>

\<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`:
  Existing verifier already has reusable helpers for exact text checks, table
  row checks, exact TSV row checks, status publication checks, and forbidden
  overclaiming text.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`:
  Existing mutation tests provide the local pattern for temporary checkout
  roots and one-behavior failure cases.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`: Existing table
  format is the inspectable contract surface maintainers already know.

### Established Patterns

- Scope packages are metadata and verifier packages first; later phases own
  fixture bytes, Rust boundaries, executable parity, and status publication.
- The repository uses Bazel `sh_binary`/`sh_test` style verifier packages for
  these fork evidence gates.
- Rust migration code under `packages/slic3r-rust` keeps flavor metadata and
  parser boundaries pure and data-in/data-out.
- Verification and documentation should stay narrow and explicit instead of
  normalizing broad generated-output claims.

### Integration Points

- Phase 49 should update the scope package and its Bazel verifier/test targets.
- Phase 49 may update docs that reference the scope package only where needed
  to describe the structural scope expansion.
- Phase 50 will consume the allowed field set when writing the structural
  expected summary fixture.
- Phase 51 will consume the same allowed field set when extending the Rust
  structural summary boundary.
  \</code_context>

<specifics>
## Specific Ideas

- Treat the v1.13 structural contract as an additive expansion over the
  v1.12 summary-only evidence path, not a rebrand of broad G-code parity.
- Prefer a closed structural field list that can be copied into Phase 50's
  expected-summary validation and Phase 51's parser tests.
- Keep mutation failures readable: a maintainer should immediately see whether
  a failure came from missing allowed-field text, unsupported structural fields,
  or forbidden broad claim text.
  </specifics>

<deferred>
## Deferred Ideas

- Phase 50 owns the checked-in structural fixture artifact and structural
  fixture drift guards.
- Phase 51 owns the typed Rust structural summary parser and registry readiness.
- Phase 52 owns public executable structural evidence and public docs/status
  updates.
- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, GUI export/viewer behavior, release behavior, network/device
  behavior, non-Prusa fork behavior, upstream source imports, and sync
  automation remain out of scope.
  </deferred>

______________________________________________________________________

*Phase: 49-structural-g-code-scope-contract*
*Context gathered: 2026-06-16*
