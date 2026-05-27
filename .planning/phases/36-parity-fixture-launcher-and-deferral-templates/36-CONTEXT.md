---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 36-2026-05-27T13-38-25
generated_at: 2026-05-27T13:38:25.226Z
---

# Phase 36: Parity, Fixture, Launcher, and Deferral Templates - Context

**Gathered:** 2026-05-27
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 36 delivers maintainer-facing templates and vocabulary for future fork
parity work while preserving the v1.9 boundary: intake, architecture, and
planning metadata only. It must not create executable fork parity, fork-flavor
runtime behavior, fork release artifacts, automated vendor sync, online/cloud
integration, credential handling, profile auto-update execution, GUI migration,
or non-free plugin ingestion.

</domain>

<decisions>
## Implementation Decisions

### Fork Parity Checklist Template

- **D-01:** Create a dedicated Phase 36 template package for fork parity
  templates instead of placing the checklist under `packages/fork-inventories`,
  `packages/parity`, or docs-only surfaces.
- **D-02:** The checklist template must be Markdown with a fixed required-field
  table covering inventory row ID, source pin, candidate Rust module, fixture
  need, evidence command, docs touched, license or security note, deferred
  scope, and reviewer signoff.
- **D-03:** Add a repo-owned verification target for the template package so
  required checklist fields and reserved wording are mechanically checked, while
  making clear that template verification does not prove any fork parity.

### Fork Fixture Namespace and Parity Status Vocabulary

- **D-04:** Reserve future fork fixtures inside the existing parity fixture
  package namespace, using a path shaped like
  `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/`.
- **D-05:** Do not add fork rows to `packages/parity/status.tsv` in v1.9.
  Future fork status rows are reserved for executable parity targets only.
- **D-06:** Future fork status tokens should be traceable to inventory evidence,
  such as `fork.<inventory_id>` or an equivalent inventory-derived stable slug,
  and should require a real `//packages/parity:*_parity` evidence command before
  reaching `verified`.

### v1.9 Deferral Documentation

- **D-07:** Add one central v1.9 fork-parity deferral block to
  `docs/port/README.md`, then link to it from the Phase 36 template docs and
  parity guidance instead of duplicating the full list everywhere.
- **D-08:** The deferral block must explicitly name full fork parity ports, GUI
  migration, fork-flavor release builds, signing, installers, release channels,
  nightly vendor sync, cloud or network device integrations, profile
  auto-update execution, and non-free plugin ingestion as out of scope for
  v1.9.

### Manual Drift-Refresh Protocol

- **D-09:** Keep the drift-refresh protocol manual for Phase 36. It should be a
  pre-milestone runbook that uses the existing vendor registry verification and
  records reviewer decisions without cloning, fetching, building, importing, or
  vendoring upstream fork source trees.
- **D-10:** The protocol must distinguish selected stable tags and peeled
  commits from drift-only branch head observations. Drift observations do not
  change accepted source pins by themselves.
- **D-11:** A future manual report target is allowed only if planning finds it
  necessary, but it must not become nightly sync automation or update vendor
  refs automatically.

### the agent's Discretion

- Exact file names inside the new template package.
- Whether the verifier is a shell script or another repo-local script type,
  provided it is rerunnable and wired through Bazel.
- Exact wording of examples in checklist and runbook docs, as long as the v1.9
  non-overclaiming boundary is explicit.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 36 goal, success criteria, dependencies, and
  requirement mapping.
- `.planning/REQUIREMENTS.md` - PAR-01 through PAR-04 acceptance criteria and
  v1.9 out-of-scope boundaries.
- `.planning/STATE.md` - Current phase state and prior Phase 35 decisions that
  keep fork registry metadata planning-only.

### Existing Fork Intake and Inventory Contracts

- `packages/fork-vendors/README.md` - Vendor registry verification boundary,
  source pin meaning, drift-only branch heads, and no-vendoring rule.
- `packages/fork-vendors/forks.tsv` - Accepted fork source refs, selected
  stable tags, peeled commits, and observed branch heads.
- `packages/fork-vendors/verify_forks.sh` - Existing remote-ref validation
  behavior to reuse or reference in the manual drift protocol.
- `packages/fork-inventories/README.md` - Inventory TSV contract, source ref
  rules, category map contract, and planning-only scope.
- `packages/fork-inventories/inventory-template.tsv` - Required source-observed
  inventory columns that future checklist rows must trace back to.
- `packages/fork-inventories/category-map.tsv` - Shared downstream,
  fork-specific, and deferred category mapping for future parity planning.

### Existing Parity and Fixture Surfaces

- `packages/parity-fixtures/README.md` - Current fixture update and namespace
  rules for verified parity surfaces.
- `packages/parity/status.tsv` - Current status vocabulary and checked-in
  executable evidence rows.
- `packages/parity/README.md` - Current parity command entrypoints and evidence
  interpretation.
- `docs/port/parity-matrix.md` - Human-facing parity status dashboard and
  verified/in-progress vocabulary.
- `docs/port/migration-guidance.md` - Launcher replacement, parity evidence,
  fixture protocol, and scope-now-versus-deferred rules.
- `docs/port/README.md` - Port control-plane entrypoint and central location
  for the Phase 36 deferral block.

### Flavor Registry Boundary

- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - Typed Rust
  flavor, vendor, source, feature origin, parity surface, and checklist status
  contracts.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Static
  metadata-only flavor registry boundary that must remain side-effect free.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/fork-vendors/verify_forks.sh` can inform the drift-refresh protocol
  because it already compares selected stable tags, peeled commits, and branch
  heads with `git ls-remote` without cloning or building upstream forks.
- `packages/fork-inventories/verify_inventories.sh` provides a local pattern
  for TSV/header/enum validation that can be mirrored for a template package
  verifier.
- `packages/parity-fixtures/README.md` and existing fixture directories show
  the current fixture naming style for future fork namespace reservations.
- `packages/parity/status.tsv` is the current checked-in parity visibility
  source and must not receive future fork rows until executable evidence exists.

### Established Patterns

- Fork source pins, inventories, and flavor registry metadata are planning
  inputs only; they do not prove executable fork parity or user-facing support.
- Package-local Bazel `verify` targets are the preferred repo-native validation
  shape for structured metadata and template contracts.
- Rust flavor registry work is side-effect free static metadata. Git,
  filesystem, network, process, release, launcher-dispatch, runtime TSV
  parsing, cloud, credential, and plugin ingestion behavior stay outside that
  boundary.

### Integration Points

- A new template package should be added under `packages/` and exposed through
  the relevant package-level Bazel build graph.
- Port docs should link the new templates from `docs/port/README.md` and the
  parity/fixture guidance without implying fork parity support exists today.
- Future fork parity milestones should use the checklist template before adding
  fork fixture directories, parity commands, or status rows.

</code_context>

<specifics>
## Specific Ideas

- Prefer a dedicated `packages/fork-templates` package for Phase 36 artifacts.
- Use existing parity fixture roots for future fork fixture namespace
  reservation, not a separate fork parity status system.
- Keep deferral language centralized to reduce drift.
- Treat manual drift review as a human gate before later fork parity milestones,
  not as sync automation.

</specifics>

<deferred>
## Deferred Ideas

- Full PrusaSlicer, Bambu Studio, or OrcaSlicer runtime parity.
- GUI migration and GUI feature parity.
- Fork-flavor release builds, signing, notarization, installers, AppImage, MSI,
  DMG, release channels, and cross-flavor GitHub Actions build matrices.
- Nightly vendor sync or automated source refresh.
- Cloud, network printer, credential, remote-device, profile auto-update, or
  non-free plugin ingestion.

</deferred>

---

*Phase: 36-parity-fixture-launcher-and-deferral-templates*
*Context gathered: 2026-05-27*
