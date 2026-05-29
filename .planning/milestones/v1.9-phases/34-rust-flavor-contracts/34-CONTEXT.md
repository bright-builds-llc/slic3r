---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 34-2026-05-26T21-33-10
generated_at: 2026-05-26T21:34:27.138Z
---

# Phase 34: Rust Flavor Contracts - Context

**Gathered:** 2026-05-26
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 34 adds typed Rust domain contracts for downstream fork identity, flavor
identity, vendor source identity, feature origin, parity surface, and checklist
status. The phase should make raw fork, flavor, source, feature, parity, and
checklist strings parse into stable Rust values at the boundary before they can
enter core migration logic.

This phase must not implement a side-effecting flavor registry, runtime fork
behavior, fork-specific CLI dispatch, upstream source import, upstream fetch or
clone behavior, source-tree vendoring, online/cloud integration, credential
handling, non-free plugin ingestion, or executable fork parity.

</domain>

<decisions>

## Implementation Decisions

### Contract Package Boundary

- **D-01:** Put the Phase 34 contracts in
  `packages/slic3r-rust/crates/slic3r_contracts`. This crate already owns
  stable launcher-facing contract types and is the narrowest place for
  boundary values that other Rust crates can consume without pulling in side
  effects.
- **D-02:** Keep the contracts as pure Rust domain types, parser/display
  helpers, and focused tests. Do not add filesystem, Git, network, process, or
  release operations to the contract crate.
- **D-03:** Treat `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/*.tsv`, `packages/fork-inventories/category-map.tsv`,
  and `packages/parity/status.tsv` as vocabulary inputs for contract design,
  but do not parse those files at runtime in Phase 34.

### Typed Vocabulary

- **D-04:** Model downstream fork identity with the Phase 32 vendor IDs:
  `prusaslicer`, `bambustudio`, and `orcaslicer`. Preserve canonical token
  display so docs, TSVs, and Rust tests speak the same vocabulary.
- **D-05:** Model flavor identity separately from vendor identity. Include
  `base-slic3r` for the base Rust/Slic3r flavor and fork flavor IDs for the
  three downstream forks. This prevents raw vendor strings from doubling as
  runtime flavor concepts.
- **D-06:** Model vendor source identity as a parsed source pin shaped like
  `vendor_id:selected_tag@peeled_commit`. Require a known vendor ID, a non-empty
  selected tag, and a 40-character lowercase hex commit. Branch-head
  observations remain drift-only metadata from Phase 32 and must not be accepted
  as source identity.
- **D-07:** Model feature origin from the Phase 33 ownership taxonomy:
  `base-slic3r`, `shared-downstream`, `fork-specific`, and
  `unknown-needs-review`.
- **D-08:** Model parity surface as a boundary value that validates canonical
  tokens from `packages/parity/status.tsv` without hardcoding launcher behavior.
  A string-backed validated value is acceptable if it prevents unvalidated raw
  strings from crossing the contract boundary.
- **D-09:** Model checklist status from the Phase 33 decision vocabulary:
  `future-candidate`, `deferred`, `no-action-base`, and `needs-review`. This
  is planning/checklist status only, not executable parity status.

### Parsing and Error Semantics

- **D-10:** Expose strict parsers at the boundary, preferably through
  `FromStr`/`TryFrom<&str>` style APIs plus small explicit error types. Invalid
  strings should produce structured errors, not `Unsupported` catch-all values.
- **D-11:** Canonical parsing should be lowercase and hyphenated to match the
  checked-in TSVs. Display/output helpers should return those canonical tokens.
- **D-12:** Avoid `unwrap()` in production code. Use `let...else`, `?`
  propagation, and explicit validation paths consistent with the Rust project
  guidance.

### Verification Shape

- **D-13:** Add focused Rust tests in `slic3r_contracts` proving that the new
  types parse and display canonical tokens, reject unknown/raw values, and
  distinguish base Slic3r, shared downstream, fork-specific, and
  unknown-needs-review concepts.
- **D-14:** Keep tests behavior-focused and Arrange/Act/Assert structured.
  Include examples that show Phase 34 contracts can be used before values enter
  core logic.
- **D-15:** Use the existing Rust verification surface where possible:
  package-local `rust_test`, `rustfmt_test`, `rust_clippy`, Cargo checks, and
  the existing `//packages/slic3r-rust:verify` suite.

### the agent's Discretion

- The planner may choose exact Rust type names if each ARCH-01 concept is
  explicitly represented and easy to discover from public docs/tests.
- The planner may choose whether source-pin validation lives on a dedicated
  `VendorSourceRef` struct or a small set of parsed component types, provided
  callers cannot pass an unvalidated source pin as a plain string.
- The planner may decide whether `ParitySurface` is an enum or a validated
  newtype. The safer default is a validated newtype if the existing parity
  surface list is expected to keep growing.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### GSD Phase Scope

- `.planning/PROJECT.md` - v1.9 milestone goal, current state, active
  requirements, and Phase 34 next-step framing.
- `.planning/REQUIREMENTS.md` - ARCH-01 acceptance requirement and v1.9
  exclusions.
- `.planning/ROADMAP.md` - Phase 34 goal, dependency, success criteria, and
  requirement mapping.
- `.planning/STATE.md` - Current GSD state and Phase 34 ready-to-plan position.

### Repo and Standards Guidance

- `AGENTS.md` - Repo-local summary metadata rules and Bright Builds routing
  requirements.
- `AGENTS.bright-builds.md` - Bright Builds workflow defaults, sync-first
  guidance, verification expectations, and task artifact rules.
- `standards-overrides.md` - Repo-local standards override surface.

### Prior Phase Decisions

- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md`
  - Phase 32 source-pin and drift-only branch-head decisions.
- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-VERIFICATION.md`
  - Verified vendor-source registry behavior and no-runtime-fork-parity
  boundary.
- `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md`
  - Phase 33 ownership, decision, and inventory-boundary taxonomy.
- `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-VERIFICATION.md`
  - Verified source-pinned inventory behavior and Phase 32 regression boundary.

### Rust Contract Surface

- `packages/slic3r-rust/Cargo.toml` - Rust workspace members, edition, and lint
  baseline.
- `packages/slic3r-rust/BUILD.bazel` - Rust package verification suite and
  crate aliases.
- `packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs` - Existing
  contract crate public API and parser style.
- `packages/slic3r-rust/crates/slic3r_contracts/tests/parse.rs` - Existing
  behavior-focused parser tests using Arrange/Act/Assert sections.
- `packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel` - Package-local
  `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test` pattern.
- `packages/slic3r-rust/README.md` - Rust workspace package overview and
  verification commands.

### Source Vocabulary Inputs

- `packages/fork-vendors/forks.tsv` - Canonical downstream vendor IDs, selected
  stable tags, peeled commits, and branch-head drift distinction.
- `packages/fork-inventories/inventory-template.tsv` - Inventory schema and
  canonical field names.
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

- `docs/port/README.md` - Migration control-plane status vocabulary and Phase
  33 inventory note.
- `docs/port/package-map.md` - Package ownership boundaries and Phase 33/34
  handoff context.
- `docs/port/contract-inventory.md` - Existing contract registry style and
  source-of-truth wording.
- `docs/port/parity-matrix.md` - Conservative parity status vocabulary and
  evidence framing.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/slic3r-rust/crates/slic3r_contracts` already hosts stable
  launcher-facing contract types and parser tests.
- `packages/fork-vendors/forks.tsv` already defines the canonical downstream
  fork IDs and source pins that Phase 34 contracts should recognize.
- `packages/fork-inventories` already defines ownership and checklist decision
  vocabularies that Phase 34 should convert into typed Rust values.
- `packages/parity/status.tsv` already defines the parity-surface token list
  that Phase 34 should validate at the type boundary.

### Established Patterns

- Rust crates use Bazel `rust_library`, `rust_test`, `rust_clippy`, and
  `rustfmt_test` targets alongside Cargo workspace metadata.
- Existing Rust parser tests are behavior-focused and use explicit
  Arrange/Act/Assert comments.
- The Rust workspace forbids unsafe code and follows the repository's
  Bright Builds Rust guidance.
- Port docs keep runtime parity claims separate from metadata, source pins,
  and planning checklists.

### Integration Points

- Extend `slic3r_contracts/src/lib.rs` rather than creating a new crate unless
  research proves a split is materially clearer.
- Extend `slic3r_contracts/tests/parse.rs` or add focused contract tests beside
  it.
- Update `packages/slic3r-rust/README.md` and relevant `docs/port/` files only
  if the public contract boundary needs to be discoverable outside the crate.

</code_context>

<specifics>

## Specific Ideas

- Prefer canonical token constants or `Display` implementations so docs, TSV
  rows, and Rust types cannot drift silently.
- Include at least one test that demonstrates a raw typo such as
  `bambu-studio` or `branch-main@...` fails before reaching core logic.
- Keep any examples small and contract-oriented. Do not create a full registry
  data model in this phase; Phase 35 owns the registry boundary.

</specifics>

<deferred>

## Deferred Ideas

- Side-effect-free flavor registry composition belongs to Phase 35.
- Fork parity checklist templates, fixture namespaces, and drift-refresh
  protocol wording belong to Phase 36.
- Runtime fork behavior, fork-flavor release builds, online/cloud integration,
  credential handling, and non-free plugin support remain future milestones
  after executable parity evidence exists.

</deferred>

---

*Phase: 34-rust-flavor-contracts*
*Context gathered: 2026-05-26*
