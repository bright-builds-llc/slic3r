---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 33-2026-05-26T17-23-32
generated_at: 2026-05-26T17:24:45.822Z
---

# Phase 33: Inventory Templates and Source-Pinned Fork Inventories - Context

**Gathered:** 2026-05-26
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 33 creates maintainer-facing fork feature inventory templates and initial
source-pinned inventories for PrusaSlicer, Bambu Studio, OrcaSlicer, and
cross-fork category mapping. The phase classifies source-observed fork surfaces
before any downstream behavior becomes implementation scope. It must not import
upstream source trees, vendor fork code, mark fork parity as verified, create
Rust flavor contracts, implement runtime fork behavior, ingest non-free/network
plugin code, or define the later full drift-refresh protocol.

</domain>

<decisions>

## Implementation Decisions

### Inventory Package and Data Shape

- **D-01:** Add a dedicated `packages/fork-inventories` package for feature
  inventory templates, per-fork inventories, the cross-fork category map, and
  inventory verification. Keep it separate from `packages/fork-vendors`, which
  owns source refs, license/provenance metadata, and release-pin verification.
- **D-02:** Use checked-in TSV files rather than Markdown tables or a new parser
  dependency. This matches the repo's existing `packages/parity/status.tsv` and
  `packages/fork-vendors/forks.tsv` pattern and keeps verification shell-owned.
- **D-03:** Include one schema/template TSV that documents the required
  inventory columns and one TSV per fork, plus a cross-fork category map TSV.
  The template is the contract maintainers copy for future rows.

### Required Inventory Fields

- **D-04:** Every inventory row should require an inventory ID, vendor ID,
  feature surface, ownership classification, source reference, source paths,
  complexity, existing parity-surface dependency, v1.9 decision, and future
  parity notes.
- **D-05:** Source references must be pinned to Phase 32 selected stable tags or
  peeled commits. Do not use drift-only default branch heads as accepted source
  evidence.
- **D-06:** Use explicit enum-like vocabularies for classification and decision
  fields so Phase 34 can later parse them into Rust domain types without
  guessing prose meanings.

### Classification Taxonomy

- **D-07:** Classify ownership as `base-slic3r`, `shared-downstream`,
  `fork-specific`, or `unknown-needs-review`.
- **D-08:** Separate v1.9 decisions into future implementation candidates,
  deferred rows, no-action/base rows, and needs-review rows. Deferred rows must
  stay visible instead of being mixed with implementation candidates.
- **D-09:** Keep network, cloud, plugin, credential, and non-free surfaces as
  inventory cautions only. These rows must not create online integration,
  credential ingestion, or runtime fork support scope.

### Inventory Coverage

- **D-10:** The initial PrusaSlicer inventory should separate base Slic3r
  behavior, shared downstream behavior, and Prusa-specific behavior from the
  pinned PrusaSlicer source baseline.
- **D-11:** The initial Bambu Studio inventory must cover inherited
  Prusa-family behavior, shared downstream behavior, and Bambu-specific project,
  profile, network, support, STEP, arc, and assembly surfaces.
- **D-12:** The initial OrcaSlicer inventory must cover inherited
  Prusa/Bambu-family behavior, shared downstream behavior, and Orca-specific
  calibration, wall/seam, support, adaptive mesh, profile library, and
  community-profile surfaces.
- **D-13:** The cross-fork category map should group related rows across forks
  by category and explicitly distinguish base, shared downstream, fork-specific,
  and unknown-needs-review rows.

### Verification and Documentation

- **D-14:** Add a Bazel-owned verification target that checks TSV shape,
  required fields, enum values, vendor IDs against `packages/fork-vendors`,
  pinned source-reference form, required surface coverage, and cross-map
  references. Verification should not fetch, clone, or inspect upstream remotes.
- **D-15:** Document that inventories are source-observed planning inputs only.
  They do not prove executable parity, user-facing behavior, GUI support, fork
  release builds, or support for non-free/network plugins.
- **D-16:** Link the new package and maintainer command from `docs/port/README.md`
  and `docs/port/package-map.md` so reviewers can find the inventory boundary.

### the agent's Discretion

- The planner may choose exact column names if every INV requirement remains
  directly represented and easy to validate from shell.
- The planner may decide whether the cross-fork map stores row IDs directly or
  category-to-row references, provided stale or unknown row references fail
  verification.
- The planner may add package-local README sections, fixture TSV snippets, or
  verifier tests needed to make the inventory contract maintainable.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### GSD Phase Scope

- `.planning/PROJECT.md` - v1.9 milestone goal, active requirements, and
  current Phase 32 baseline.
- `.planning/REQUIREMENTS.md` - INV-01 through INV-05 acceptance requirements
  and v1.9 exclusions.
- `.planning/ROADMAP.md` - Phase 33 goal, success criteria, dependency, and
  requirement mapping.
- `.planning/STATE.md` - Current GSD state and active phase.
- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md`
  - Locked vendor-source intake decisions that Phase 33 must carry forward.

### Repo and Standards Guidance

- `AGENTS.md` - Repo-local summary metadata rules and Bright Builds routing
  requirements.
- `AGENTS.bright-builds.md` - Bright Builds workflow defaults, sync-first
  guidance, verification expectations, and task artifact rules.
- `standards-overrides.md` - Repo-local standards override surface.

### Existing Fork Vendor Baseline

- `packages/fork-vendors/forks.tsv` - Canonical vendor IDs, official repos,
  selected tags, peeled commits, source paths, license/provenance cautions, and
  drift-only branch observations.
- `packages/fork-vendors/README.md` - Phase 32 package boundary and maintainer
  command wording.
- `packages/fork-vendors/BUILD.bazel` - Bazel shell command pattern for the
  vendor-source package.
- `packages/fork-vendors/verify_forks.sh` - Shell verifier style and strict TSV
  validation rules.

### Existing Port Documentation

- `docs/port/README.md` - Migration control-plane structure, status vocabulary,
  and review expectations.
- `docs/port/package-map.md` - Package ownership boundaries and phase history
  notes.
- `docs/port/migration-guidance.md` - Conservative parity vocabulary and
  deferred scope rules.
- `docs/port/parity-matrix.md` - Current parity status vocabulary and evidence
  framing.
- `docs/port/contract-inventory.md` - Existing source-of-truth registry style
  and future owner fields.

### Existing Build and Verification Patterns

- `packages/BUILD.bazel` - Root-facing package alias pattern.
- `packages/parity/BUILD.bazel` - Bazel `sh_binary`/`sh_test` pattern for
  checked-in data source verification commands.
- `packages/parity/README.md` - Package-local documentation style for
  maintainer commands and conservative scope.
- `packages/parity/status.tsv` - Existing checked-in TSV status source pattern.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/fork-vendors/forks.tsv` already records the authoritative vendor
  IDs, selected tags, peeled commits, and source path hints that inventory rows
  should reference.
- `packages/fork-vendors/verify_forks.sh` provides strict shell validation
  patterns for TSV field count, enum-like fields, LF-only rows, and clear error
  messages.
- `packages/parity/status.tsv` and `docs/port/contract-inventory.md` provide
  checked-in registry patterns with source-of-truth and future-owner language.

### Established Patterns

- Package-local Bazel targets expose maintainer commands through `sh_binary`
  and test them with `sh_test`.
- Port docs use conservative vocabulary and do not mark a surface `verified`
  until executable parity evidence exists.
- Documentation and package metadata move together when a change creates a new
  package boundary or migration-control-plane surface.

### Integration Points

- Add a new `packages/fork-inventories` package beside `packages/fork-vendors`.
- Use `packages/fork-vendors/forks.tsv` as the canonical vendor/source baseline
  for inventory verification.
- Link the package and command from `docs/port/README.md` and
  `docs/port/package-map.md`.

</code_context>

<specifics>

## Specific Ideas

- Prefer source-reference strings that combine vendor ID, selected stable tag or
  peeled commit, and source path, so maintainers can see each row is tied to a
  Phase 32 pin.
- Include row-level notes that say whether a surface is a future candidate,
  deferred because it needs executable parity evidence, or deferred because it
  touches non-free/network/plugin/credential scope.
- Keep the initial inventories intentionally bounded to the surfaces named by
  INV-02 through INV-05. Exhaustive upstream feature archaeology can be a later
  inventory expansion after this template exists.

</specifics>

<deferred>

## Deferred Ideas

- Full executable fork parity remains a future milestone after v1.9 establishes
  inventory and flavor boundaries.
- Runtime flavor contracts and Rust domain types remain Phase 34 and Phase 35
  scope.
- Full drift-refresh protocol templates remain Phase 36 scope.
- GUI migration, fork-flavor release builds, online/cloud integrations,
  credential handling, and non-free plugin ingestion remain future work.

</deferred>

---

*Phase: 33-inventory-templates-and-source-pinned-fork-inventories*
*Context gathered: 2026-05-26*
