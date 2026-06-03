---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 41-2026-06-03T01-42-30
generated_at: 2026-06-03T01:43:25.461Z
---

# Phase 41: Prusa Project-File Scope Gate - Context

**Gathered:** 2026-06-03
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 41 delivers a reviewed scope package for the narrow
`prusaslicer.project-file` evidence contract before any fixture, Rust parser,
parity command, status publication, or broad runtime claim is implemented.

The scope package must let maintainers inspect the accepted source identity,
inventory row, fixture source decision, expected-artifact contract, candidate
Rust boundary, planned evidence command, docs touched, license or security note,
deferred scope, and reviewer signoff for the project-file evidence slice.

This phase does not add fixtures, parse project files, publish a verified status
row, or create executable parity evidence. Those are reserved for Phases 42-44.

</domain>

<decisions>
## Implementation Decisions

### Scope Package Contents

- **D-01:** Create a maintainer-readable `prusaslicer.project-file` scope record
  that is specific enough for later phases to implement without re-deciding the
  evidence contract.
- **D-02:** Treat the required record fields from PSEL-01 as mandatory:
  accepted source identity, inventory row ID, fixture source decision,
  expected-artifact contract, candidate Rust boundary, planned evidence command,
  docs touched, license or security note, deferred scope, and reviewer signoff.
- **D-03:** Keep the scope package reviewable as checked-in documentation or
  data, not as generated prose that downstream phases must infer.

### Source Identity and Inventory

- **D-04:** Start from the existing `packages/fork-inventories/prusaslicer.tsv`
  row for `prusaslicer.project-file`.
- **D-05:** Preserve the current accepted source pin
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` unless
  the plan finds a concrete reason that a reviewed sample source needs a
  narrower or different source identity.
- **D-06:** Anchor the source path decision on
  `src/libslic3r/Format/3mf.cpp` and keep it distinct from full 3MF
  import/export or generated-output parity.

### Fixture and Expected-Artifact Contract

- **D-07:** Phase 41 should choose the fixture source strategy and expected
  artifact shape only at the contract level; actual checked-in fixtures belong
  in Phase 42.
- **D-08:** The selected contract should be easy to verify fail-closed in Phase
  42, with provenance, update rules, and expected artifacts tracing directly
  back to the Phase 41 scope record.
- **D-09:** Prefer the same evidence discipline used by the v1.10 Prusa
  profile-schema path: source-pinned fixture inputs, an explicit expected
  artifact, a verifier, typed Rust metadata, a public Bazel parity command, and
  exact status/docs wording.

### Downstream Handoff

- **D-10:** Name the candidate Rust boundary and planned evidence command before
  implementation, but do not create the Rust parser or command in this phase.
- **D-11:** Downstream Phases 42-44 must be able to trace fixture paths, Rust
  metadata, status token, and evidence command back to this scope record.
- **D-12:** The planned status token should remain narrow and evidence-backed,
  matching the existing `fork.prusaslicer.profile-schema` precedent without
  claiming full PrusaSlicer runtime behavior.

### Deferred Scope and Non-Overclaiming

- **D-13:** Explicitly defer full PrusaSlicer runtime support, GUI project
  behavior, full 3MF import/export, generated-output parity, STEP import,
  support generation, arc fitting, wall seam behavior, network/device
  integration, profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, and sync automation.
- **D-14:** Docs touched in this phase should clarify the evidence contract and
  deferred scope, not imply executable parity before Phases 42-44 are complete.

### the agent's Discretion

- The agent may decide the exact file name and tabular or Markdown shape for
  the scope record, provided the mandatory fields are inspectable and easy to
  verify in later phases.
- The agent may decide whether to add a lightweight verifier for the Phase 41
  scope record if it reduces risk and stays within the scope-gate boundary.
- The agent may choose the most concise docs updates needed to make the scope
  package discoverable without rewriting unrelated milestone history.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Milestone Scope

- `.planning/ROADMAP.md` - Phase 41 goal, success criteria, dependency on
  Phase 40, and v1.11 execution order.
- `.planning/REQUIREMENTS.md` - PSEL-01 and PSEL-02 plus explicit v1.11
  out-of-scope exclusions.
- `.planning/PROJECT.md` - current milestone goal, last shipped Prusa
  profile-schema evidence precedent, and key project constraints.
- `.planning/STATE.md` - current Phase 41 position and recent v1.11 decisions.

### Existing Prusa Evidence Chain

- `docs/port/README.md` - current Prusa baseline, fixture/status preparation,
  Rust boundary, and narrow-scope documentation precedent.
- `docs/port/package-map.md` - package ownership for `packages/prusa-baseline`,
  `packages/parity-fixtures`, `packages/slic3r-rust`, and `packages/parity`.
- `packages/fork-inventories/prusaslicer.tsv` - source-observed
  `prusaslicer.project-file` inventory row.
- `packages/fork-inventories/category-map.tsv` - shared downstream
  project-file categorization.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - static
  `prusaslicer.project-file` capability metadata and provenance pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  existing test coverage for shared downstream capability lookup.

### Prior Phase Artifacts

- `.planning/milestones/v1.10-phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md` -
  Prusa baseline and checklist gate precedent.
- `.planning/milestones/v1.10-phases/38-prusa-fixture-and-status-evidence-surface/38-01-SUMMARY.md` -
  fixture namespace and status preparation precedent.
- `.planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md` -
  pure Rust boundary precedent.
- `.planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md` -
  parser documentation and traceability precedent.
- `.planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-01-SUMMARY.md` -
  executable parity command and expected-artifact precedent.
- `.planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-02-SUMMARY.md` -
  status publication and narrow docs precedent.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/fork-inventories/prusaslicer.tsv`: already contains the
  `prusaslicer.project-file` source-observed planning row that Phase 41 should
  promote into a reviewed evidence contract.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`: already exposes
  `prusaslicer.project-file` as shared downstream capability metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs`:
  already proves that shared downstream capability lookup returns
  `prusaslicer.project-file`.
- `packages/prusa-baseline` and
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`:
  provide the v1.10 model for source pins, checklist gates, provenance, expected
  artifacts, and narrow docs.

### Established Patterns

- Fork parity evidence advances in small, source-pinned slices rather than
  broad runtime claims.
- Rust fork/flavor logic stays pure and metadata-driven until executable parity
  owns status publication.
- Fixture and parity verification use Bazel targets with checked-in expected
  artifacts and negative failure guards.
- Docs and status rows must name the exact verified surface and explicitly
  defer adjacent surfaces.

### Integration Points

- Phase 41 should connect to `packages/fork-inventories`, docs under
  `docs/port/`, and planning artifacts under `.planning/phases/41-*`.
- Phase 42 will consume the selected fixture source decision and expected
  artifact contract.
- Phase 43 will consume the candidate Rust boundary and traceability fields.
- Phase 44 will consume the planned evidence command and status/docs wording.

</code_context>

<specifics>
## Specific Ideas

- Reuse the v1.10 Prusa profile-schema trust chain instead of inventing a new
  evidence model.
- Keep `prusaslicer.project-file` distinct from full 3MF import/export; the
  first contract should be a narrow project-file evidence slice.
- Make the scope record inspectable enough that a maintainer can sign off before
  any fixtures or parser code are created.

</specifics>

<deferred>
## Deferred Ideas

- Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
  generated-output parity, STEP import, support generation, arc fitting, wall
  seam behavior, network/device integration, profile auto-update execution,
  fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, and
  sync automation all remain outside Phase 41.

</deferred>

---

*Phase: 41-prusa-project-file-scope-gate*
*Context gathered: 2026-06-03*
