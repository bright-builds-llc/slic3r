---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 37-2026-05-31T23-02-59
generated_at: 2026-05-31T23:02:59.004Z
---

# Phase 37: Prusa Baseline and Checklist Gate - Context

**Gathered:** 2026-05-31
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 37 delivers a maintainer-facing PrusaSlicer baseline review package for
the narrow v1.10 profile schema/config evidence slice. It should record the
accepted v1.9 Prusa source pin, current manual drift-review observations,
reviewer decision/signoff fields, and completed checklist entries for the
`prusaslicer.profile-schema` inventory row before implementation begins.

This phase must stay evidence-gate and scope-control work only. It must not add
Prusa fixture files, fork parity status rows, executable Prusa parity commands,
upstream source imports, vendored fork source trees, automatic sync, runtime
fork support, GUI support, network/device integration, profile auto-update
execution, or fork release packaging.

</domain>

<decisions>
## Implementation Decisions

### Prusa Baseline Package

- **D-01:** Add a dedicated package under `packages/` for the Phase 37 Prusa
  baseline/checklist review records instead of rewriting the Phase 36 template
  package or mixing completed Prusa records into future fixture/status packages.
- **D-02:** The package must be review-gated documentation plus a local verifier
  only. Verification proves record completeness and boundary wording; it does
  not prove Prusa runtime support or executable fork parity.
- **D-03:** The package should be discoverable from the port control-plane docs
  and package map so later Prusa phases can find the accepted baseline inputs.

### Drift-Refresh Record

- **D-04:** Record the accepted Prusa source baseline from
  `packages/fork-vendors/forks.tsv`: selected tag `version_2.9.5`, peeled
  commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`, and upstream repo
  `https://github.com/prusa3d/PrusaSlicer`.
- **D-05:** Include a maintainer review record shaped by
  `packages/fork-templates/manual-drift-refresh-protocol.md`, with explicit
  fields for selected stable tag confirmation, peeled commit confirmation,
  branch drift observation, reviewer decision, and reviewer signoff.
- **D-06:** Treat branch-head data as drift-only observation. The Phase 37
  record must state that accepted source pins remain unchanged unless a future
  reviewed intake update modifies `packages/fork-vendors/forks.tsv`.

### Checklist Gate

- **D-07:** Complete the checklist for the first v1.10 Prusa candidate row:
  `prusaslicer.profile-schema` from `packages/fork-inventories/prusaslicer.tsv`.
- **D-08:** The checklist record must include the inventory row ID, source pin,
  candidate Rust module, fixture need, evidence command, docs touched, license
  or security note, deferred scope, and reviewer signoff, matching the Phase 36
  checklist template fields.
- **D-09:** Candidate Rust module should point to the shared Rust profile/config
  boundary planned for later phases, not to a Prusa-only workspace or copied
  upstream source tree.
- **D-10:** Fixture need and evidence command should be future-oriented and
  explicit: Phase 37 may name the intended future fixture namespace and parity
  command shape, but must not create the fixtures or command yet.

### Scope-Control Wording

- **D-11:** Add human-readable boundary text that distinguishes the selected
  v1.10 Prusa profile/config evidence scope from deferred Prusa project files,
  STEP import, support generation, arc fitting, wall seam behavior,
  network/device integration, full fork runtime support, GUI support, fork
  release builds, and sync automation.
- **D-12:** The verifier should fail closed when required review fields,
  accepted pin values, checklist field labels, or non-overclaiming phrases are
  missing.

### the agent's Discretion

- Exact package name and record file names, provided they are discoverable and
  scoped to Prusa baseline/checklist evidence.
- Whether the verifier is one shell script or split into helper/test scripts,
  provided it is rerunnable directly and through Bazel.
- Exact reviewer placeholders, as long as the record keeps reviewer decision
  and signoff visibly incomplete until a human fills them.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 37 goal, dependency on Phase 36, PRUSA-01
  through PRUSA-03 mapping, and success criteria.
- `.planning/REQUIREMENTS.md` - v1.10 Prusa baseline requirements and explicit
  milestone out-of-scope table.
- `.planning/STATE.md` - Current milestone state and recent v1.10 decisions.
- `.planning/milestones/v1.9-phases/36-parity-fixture-launcher-and-deferral-templates/36-CONTEXT.md`
  - Prior decisions for checklist, fixture namespace, status vocabulary, and
  manual drift-refresh protocol boundaries.
- `.planning/milestones/v1.9-phases/36-parity-fixture-launcher-and-deferral-templates/36-VERIFICATION.md`
  - Verified Phase 36 template and deferral package behavior.

### Source Baseline and Inventory Inputs

- `packages/fork-vendors/forks.tsv` - Accepted PrusaSlicer source pin,
  selected stable tag, peeled commit, branch observation, SPDX/provenance, and
  caution fields.
- `packages/fork-vendors/README.md` - Source registry verification boundary,
  manual drift routing, and accepted-pin versus branch-drift distinction.
- `packages/fork-vendors/verify_forks.sh` - Existing verifier behavior used by
  the manual drift protocol.
- `packages/fork-inventories/prusaslicer.tsv` - Source-pinned Prusa inventory
  rows, especially `prusaslicer.profile-schema`.
- `packages/fork-inventories/README.md` - Inventory TSV contract, accepted
  `source_ref` rules, and planning-only scope.
- `packages/fork-inventories/category-map.tsv` - Cross-fork category map that
  groups `prusaslicer.profile-schema` under the profile-schema future-candidate
  category.

### Phase 36 Templates and Scope Guardrails

- `packages/fork-templates/manual-drift-refresh-protocol.md` - Review-gated
  manual drift-refresh fields and prohibited work.
- `packages/fork-templates/fork-parity-checklist-template.md` - Required
  checklist fields and review rules.
- `packages/fork-templates/README.md` - Template verification boundary and
  central deferral routing.
- `docs/port/README.md` - Control-plane status, current fork template package
  state, current flavor registry boundary state, and central fork parity
  deferrals.
- `docs/port/package-map.md` - Package roles and discoverability for fork
  vendor, inventory, template, parity, fixture, and Rust flavor packages.
- `docs/port/migration-guidance.md` - Fixture/status guidance, future fork
  namespace policy, and executable evidence requirement.
- `docs/port/parity-matrix.md` - Human-facing parity vocabulary and no-fork-row
  boundary until executable evidence exists.

### Rust Metadata Boundary

- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - Typed fork,
  flavor, source, origin, parity surface, and checklist status contracts.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Side-effect
  free static flavor registry and capability metadata.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/fork-templates` provides the nearest package pattern for
  documentation-only fork planning artifacts, `sh_binary` verification, and
  failure-mode shell tests.
- `packages/fork-vendors/verify_forks.sh` already checks selected tags and
  peeled commits with `git ls-remote` while treating branch heads as drift-only
  warnings.
- `packages/fork-inventories/prusaslicer.tsv` already contains the
  `prusaslicer.profile-schema` row and accepted source ref needed for the first
  v1.10 checklist record.
- `docs/port/README.md`, `docs/port/package-map.md`,
  `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md` are the
  current control-plane surfaces for explaining package roles and avoiding
  overclaims.

### Established Patterns

- Package-local `bazel run //packages/<name>:verify` targets are the preferred
  validation shape for structured docs and metadata.
- Fork source pins, inventories, templates, and flavor metadata are planning
  inputs only. Runtime support or verified fork status requires future
  executable parity evidence.
- Shell verifiers in fork packages use `set -euo pipefail`, direct file checks,
  exact required-text checks, and focused `sh_test` failure fixtures.
- Existing Rust flavor/fork contracts are shared metadata boundaries, not
  vendor-specific workspaces or runtime fork implementation.

### Integration Points

- New package under `packages/` for Prusa baseline records and verification.
- Documentation routing from `docs/port/README.md` and
  `docs/port/package-map.md`.
- Optional cross-links from `packages/fork-vendors/README.md` and
  `packages/fork-inventories/README.md` if they help future maintainers find
  the completed Prusa review record.

</code_context>

<specifics>
## Specific Ideas

- The first checklist row should be `prusaslicer.profile-schema` because v1.10
  intentionally starts with profile schema/config evidence.
- A future fixture namespace may be named as
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/...`,
  but Phase 37 must not create that directory.
- A future evidence command may be named in checklist prose as a planned
  `//packages/parity:*prusa*profile*` command, but Phase 37 must not add the
  command or mark a status row verified.
- Keep reviewer signoff fields visibly placeholder-based, because the phase
  supplies the gate and record surface but does not impersonate a human reviewer.

</specifics>

<deferred>
## Deferred Ideas

- Prusa fixture files and fixture update rules are Phase 38 scope.
- Rust profile/config parsing and normalization logic is Phase 39 scope.
- Executable Prusa profile/config parity command, docs/status update, and
  verified evidence are Phase 40 scope.
- Prusa project files, STEP import, support generation, arc fitting, wall seam
  behavior, network/device integration, profile auto-update execution, full fork
  runtime support, GUI support, fork release builds, and vendor sync automation
  remain deferred beyond v1.10 unless future roadmap work pulls them forward.

</deferred>

---

*Phase: 37-prusa-baseline-and-checklist-gate*
*Context gathered: 2026-05-31*
