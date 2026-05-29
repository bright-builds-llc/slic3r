---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 35-2026-05-27T11-24-13
generated_at: 2026-05-27T11:29:50.942Z
---

# Phase 35: Flavor Registry Boundary - Context

**Gathered:** 2026-05-27
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 35 adds a pure Rust flavor registry boundary for base Slic3r, shared
downstream, and fork-specific metadata. The registry should compose the typed
Phase 34 contracts into inspectable metadata that future fork work can consume
without creating vendor-specific Rust workspaces or copying base behavior.

This phase must not implement runtime fork behavior, fork-specific CLI
dispatch, fork release builds, executable fork parity, Git operations,
filesystem reads, network access, process execution, upstream source imports,
vendored fork source trees, online/cloud integration, credential handling, or
non-free plugin ingestion.

</domain>

<decisions>

## Implementation Decisions

### Registry Package Boundary

- **D-01:** Add a new pure Rust crate under
  `packages/slic3r-rust/crates/slic3r_flavors` for registry composition. It
  should depend on `slic3r_contracts` instead of extending `slic3r_core` or
  folding composition into the contract parser module.
- **D-02:** Keep `slic3r_contracts` focused on typed vocabulary and strict
  parsers. The new flavor crate owns inspectable registry composition,
  capability metadata, and developer-facing lookup helpers.
- **D-03:** Do not create separate PrusaSlicer, Bambu Studio, or OrcaSlicer
  Rust workspaces. All downstream fork metadata should plug into one shared
  Rust package through capability-oriented registry entries.

### Registry Metadata Model

- **D-04:** Model registry data as flat capability records reachable from a
  `FlavorRegistryEntry` or equivalent root entry. Each capability record should
  carry typed `FlavorId`, `VendorSourceRef`, `FeatureOrigin`,
  `ParitySurface`, and `ChecklistStatus` values where applicable.
- **D-05:** Represent base, shared downstream, fork-specific, and
  unknown-needs-review metadata with the existing `FeatureOrigin` taxonomy
  instead of duplicating separate untyped buckets.
- **D-06:** Keep source-reference and ownership traceability on capability or
  provenance records, not only on the flavor root. A base flavor can still
  reference vendor-observed inventory evidence without becoming a downstream
  fork identity.
- **D-07:** Expose simple inspectable accessors such as all flavor entries,
  lookup by `FlavorId`, and capability iteration/filtering. These are metadata
  queries only, not runtime feature dispatch.

### Source of Truth and Purity

- **D-08:** Use a small static typed Rust registry for Phase 35. Do not parse
  TSVs at runtime and do not add a generator unless the metadata volume grows
  beyond a hand-auditable registry.
- **D-09:** Treat `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/*.tsv`, and
  `packages/fork-inventories/category-map.tsv` as canonical source evidence
  that the static registry traces to. They remain checked-in planning inputs,
  not runtime inputs.
- **D-10:** The registry crate must remain side-effect free: no Git,
  filesystem, network, process, release, environment, or clock operations in
  registry construction or lookup.
- **D-11:** If future metadata expansion needs generated Rust data, require a
  repo-owned generator plus drift tests in a later phase. Do not introduce a
  side-effecting build script in Phase 35.

### Verification and Documentation

- **D-12:** Add focused Rust tests proving that the registry exposes base,
  shared downstream, fork-specific, and unknown-needs-review metadata; maps
  metadata to canonical source refs and inventory ownership labels; and
  rejects accidental runtime parity claims.
- **D-13:** Wire the new crate into Cargo and Bazel so
  `//packages/slic3r-rust:verify` covers its tests, rustfmt, and clippy.
- **D-14:** Update `packages/slic3r-rust/README.md` and port docs so the module
  boundary is discoverable while preserving the metadata-only/no-runtime-parity
  language from Phases 32 through 34.
- **D-15:** Keep the docs explicit that Phase 35 registry entries are planning
  and architecture metadata only. They do not mark fork behavior as verified or
  supported.

### the agent's Discretion

- The planner may choose exact type names such as `FlavorRegistryEntry`,
  `FlavorCapability`, or `FlavorCapabilityRecord` if the public API remains
  clear and inspectable.
- The planner may decide whether lookup helpers return slices, iterators, or
  `Option<&FlavorRegistryEntry>` values, provided absence is explicit and
  internal nullable names use the repo's `maybe` convention where relevant.
- The planner may choose a small hand-curated subset of inventory rows if it is
  enough to prove every required ownership category and traceability path
  without pretending to be an exhaustive parity matrix.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### GSD Phase Scope

- `.planning/PROJECT.md` - v1.9 milestone goal, current state, and Phase 35
  next-step framing.
- `.planning/REQUIREMENTS.md` - ARCH-02 and ARCH-03 acceptance requirements
  and v1.9 exclusions.
- `.planning/ROADMAP.md` - Phase 35 goal, dependency, success criteria, and
  requirement mapping.
- `.planning/STATE.md` - Current GSD state and Phase 35 ready-to-plan position.

### Repo and Standards Guidance

- `AGENTS.md` - Repo-local summary metadata rules and Bright Builds routing
  requirements.
- `AGENTS.bright-builds.md` - Bright Builds workflow defaults, sync-first
  guidance, verification expectations, and task artifact rules.
- `standards-overrides.md` - Repo-local standards override surface.

### Prior Phase Decisions

- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md`
  - Source-pin, drift-only branch-head, and no-runtime-fork-parity decisions.
- `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md`
  - Inventory package, ownership taxonomy, and checklist-status vocabulary.
- `.planning/phases/34-rust-flavor-contracts/34-CONTEXT.md` - Typed Rust
  flavor contracts and Phase 35 registry handoff decisions.
- `.planning/phases/34-rust-flavor-contracts/34-01-SUMMARY.md` - Files,
  verification surface, and contract patterns delivered by Phase 34.

### Rust Flavor Contract Surface

- `packages/slic3r-rust/Cargo.toml` - Rust workspace membership and dependency
  surface.
- `packages/slic3r-rust/BUILD.bazel` - Aggregate Rust verification suite.
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - Existing
  typed flavor contracts consumed by the registry.
- `packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs` - Public
  re-export pattern for Rust contract crates.
- `packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs` -
  Behavior-focused parser tests and Arrange/Act/Assert structure.
- `packages/slic3r-rust/README.md` - Rust package overview and verification
  command documentation.

### Source Vocabulary Inputs

- `packages/fork-vendors/forks.tsv` - Canonical downstream vendor IDs,
  selected stable tags, peeled commits, and branch-head drift distinction.
- `packages/fork-inventories/inventory-template.tsv` - Inventory schema and
  canonical fields.
- `packages/fork-inventories/prusaslicer.tsv` - PrusaSlicer source-pinned
  inventory rows.
- `packages/fork-inventories/bambustudio.tsv` - Bambu Studio source-pinned
  inventory rows.
- `packages/fork-inventories/orcaslicer.tsv` - OrcaSlicer source-pinned
  inventory rows.
- `packages/fork-inventories/category-map.tsv` - Cross-fork category map and
  implementation/deferred grouping.
- `packages/parity/status.tsv` - Existing parity surface token source.

### Port Documentation

- `docs/port/README.md` - Migration control-plane status vocabulary and
  package index.
- `docs/port/package-map.md` - Package ownership boundaries and Phase 35
  registry composition handoff.
- `docs/port/contract-inventory.md` - Existing contract registry style and
  metadata-only Rust flavor contract wording.
- `docs/port/parity-matrix.md` - Conservative parity status vocabulary and
  evidence framing.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/slic3r-rust/crates/slic3r_contracts` already owns the typed
  flavor vocabulary that Phase 35 should consume.
- `packages/fork-vendors/forks.tsv` already defines canonical downstream
  vendor IDs and source pins.
- `packages/fork-inventories` already defines source-pinned rows, ownership
  labels, checklist decisions, and cross-fork category mapping.
- `packages/parity/status.tsv` already defines parity-surface tokens that the
  registry can reference without adding runtime behavior.

### Established Patterns

- Rust workspace crates use Cargo metadata plus Bazel `rust_library`,
  `rust_test`, `rust_clippy`, and `rustfmt_test` targets.
- `//packages/slic3r-rust:verify` is the aggregate Rust verification surface.
- Behavior tests in the Rust package use explicit Arrange, Act, and Assert
  sections.
- Port docs consistently separate source-observed metadata from verified
  executable parity.

### Integration Points

- Add `packages/slic3r-rust/crates/slic3r_flavors` as the registry crate.
- Depend on `slic3r_contracts` for typed metadata values.
- Add crate-local tests and wire them into
  `packages/slic3r-rust/BUILD.bazel`.
- Update `packages/slic3r-rust/README.md`,
  `docs/port/contract-inventory.md`, and `docs/port/package-map.md`.

</code_context>

<specifics>

## Specific Ideas

- Prefer static registry constants/functions over TSV runtime parsing for this
  phase.
- Include tests that prove the base flavor has no downstream fork identity
  while still exposing base metadata and source-observed inventory provenance.
- Include tests that demonstrate PrusaSlicer, Bambu Studio, and OrcaSlicer
  entries share a common registry type instead of creating vendor-specific Rust
  workspace roots.
- Add documentation language that says the registry is a metadata boundary,
  not feature dispatch, not launcher selection, and not fork parity support.

</specifics>

<deferred>

## Deferred Ideas

- Generated registry data from TSVs is deferred until metadata volume warrants
  a repo-owned generator plus drift tests.
- Fork parity checklist templates, fixture namespaces, launcher-shape wording,
  and drift-refresh protocol templates belong to Phase 36.
- Runtime fork behavior, fork-specific CLI dispatch, fork-flavor release
  builds, online/cloud integration, credential handling, and non-free plugin
  support remain future milestones after executable parity evidence exists.

</deferred>

---

*Phase: 35-flavor-registry-boundary*
*Context gathered: 2026-05-27*
