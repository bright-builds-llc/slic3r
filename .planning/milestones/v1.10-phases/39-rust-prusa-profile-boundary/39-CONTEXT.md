---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 39-2026-06-01T02-49-54
generated_at: 2026-06-01T02:49:54.027Z
---

# Phase 39: Rust Prusa Profile Boundary - Context

**Gathered:** 2026-06-01
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 39 delivers the Rust domain boundary for the v1.10 Prusa profile/config
evidence slice. It should parse the checked-in Phase 38 Prusa profile-schema
fixtures into typed, side-effect-free Rust values, normalize the limited
profile-schema/config metadata needed for the first executable evidence path,
and expose traceability back to the accepted Prusa source pin, inventory row,
source paths, and checklist status.

This phase must not create the Phase 40 executable parity command, publish a
Prusa row in `packages/parity/status.tsv`, claim full PrusaSlicer runtime
support, fetch upstream source, run profile auto-update, ingest plugins, touch
network/cloud/credential behavior, add Bambu Studio or OrcaSlicer behavior, add
GUI support, or create fork release packaging.

</domain>

<decisions>
## Implementation Decisions

### Rust Boundary Placement

- **D-01:** Add the Prusa profile/config boundary to the shared Rust migration
  workspace under `packages/slic3r-rust`, reusing existing contract and flavor
  crate patterns. Do not create a Prusa-only Rust workspace or copy upstream
  Prusa source.
- **D-02:** Prefer the existing `slic3r_flavors` crate for flavor-specific
  Prusa profile-schema metadata and parser-facing helpers unless research
  finds a clearer existing Rust crate boundary. The boundary must remain pure
  and side-effect free.
- **D-03:** Keep this phase as a typed domain/parser boundary. It may expose
  Rust helpers and tests that consume fixture text supplied by callers, but it
  must not add the repo-owned executable parity command reserved for Phase 40.

### Profile Fixture Parsing and Normalization

- **D-04:** Parse `PrusaResearch.ini` as a static Prusa vendor-bundle profile
  input from Phase 38. The first implementation should focus on stable,
  grep-testable profile/config metadata needed to prove the boundary, not on a
  complete Prusa runtime configuration engine.
- **D-05:** Parse enough of the fixture to produce typed Rust values for the
  Prusa profile-schema capability, including section names, key/value pairs, and
  representative config/profile entries that Phase 40 can compare.
- **D-06:** Normalize values conservatively: preserve raw strings where the
  legacy semantics are not yet modeled, trim only syntactic INI whitespace,
  preserve source section/key identity, and avoid inventing behavioral meaning
  that is not required by Phase 39 requirements.
- **D-07:** Treat parser inputs as caller-provided strings or compile-time test
  fixtures. The Rust domain code must not discover files, walk directories,
  spawn processes, inspect Git, fetch network resources, run profile
  auto-update, or read environment-specific state.

### Provenance and Capability Traceability

- **D-08:** Add or extend typed Rust metadata so `prusaslicer.profile-schema`
  traces to vendor `prusaslicer`, flavor `PrusaSlicer`, source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `resources/profiles/PrusaResearch.ini`, fixture path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`,
  and checklist status `future-candidate`.
- **D-09:** Reuse existing typed contracts such as `FlavorId`,
  `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`
  wherever they fit. Introduce newtypes/enums only when they encode real Prusa
  profile-schema invariants or prevent confusion between raw strings.
- **D-10:** The Rust metadata may name the future status token
  `fork.prusaslicer.profile-schema` as a planned evidence surface, but it must
  remain a future/reserved token until Phase 40 publishes executable parity
  evidence.

### Verification Shape

- **D-11:** Add focused Rust tests for parser behavior, normalization, and
  provenance traceability. Tests should be one-concern-per-test with explicit
  Arrange, Act, Assert comments when setup is non-trivial.
- **D-12:** Wire the new Rust tests into both Cargo and Bazel verification for
  the affected crate. The phase should keep `//packages/slic3r-rust:verify`
  green and add a narrow crate or test target that Phase 40 can depend on.
- **D-13:** Include negative tests proving side-effect boundaries by API shape
  and behavior: parser functions accept strings/slices, do not require paths,
  and reject malformed or unsupported profile fragments with typed errors
  instead of panics.

### Documentation and Scope Control

- **D-14:** Update port and package docs to explain that Phase 39 creates the
  Rust parser/metadata boundary only. Executable Prusa parity evidence,
  `packages/parity/status.tsv` publication, and the command
  `//packages/parity:prusaslicer_profile_schema_parity` remain Phase 40 scope.
- **D-15:** Preserve Phase 37/38 boundary wording in docs: no full PrusaSlicer
  runtime support, no GUI support, no network/device/cloud/credential behavior,
  no profile auto-update execution, no non-free plugin ingestion, no vendor sync
  automation, and no fork release packaging.

### the agent's Discretion

- Exact Rust module names and file split, provided they follow the existing
  crate style and avoid oversized mixed-responsibility files.
- Whether parser tests use small inline INI fragments, `include_str!` over the
  Phase 38 fixture, or both, provided the production parser remains pure and
  the tests verify real fixture compatibility.
- Exact typed error names and display text, provided unsupported and malformed
  inputs do not panic and failures are easy to diagnose.
- Whether the Prusa profile-schema capability is represented as an extension of
  the existing flavor registry or a small adjacent module re-exported from
  `slic3r_flavors`, provided downstream code can trace the capability without
  parsing TSV files at runtime.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 39 goal, dependency on Phase 38, PROF-01
  through PROF-03 mapping, and success criteria.
- `.planning/REQUIREMENTS.md` - Rust Prusa profile boundary requirements and
  milestone out-of-scope table.
- `.planning/STATE.md` - Current milestone state and recent v1.10 decisions.
- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md` -
  Locked source baseline, checklist, and scope-control decisions.
- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md` -
  Completed Prusa baseline package and verification commands.
- `.planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md`
  - Locked fixture namespace, provenance, status-vocabulary, and
  non-overclaiming decisions.
- `.planning/phases/38-prusa-fixture-and-status-evidence-surface/38-01-SUMMARY.md`
  - Completed Phase 38 fixture files, verifier targets, and next-phase
  readiness notes.

### Prusa Baseline and Fixture Inputs

- `packages/prusa-baseline/profile-schema-checklist.md` - Checklist record for
  `prusaslicer.profile-schema`, candidate Rust boundary, source path, source
  pin, and future evidence command shape.
- `packages/prusa-baseline/README.md` - Phase 37 baseline package boundary and
  source input routing.
- `packages/fork-vendors/forks.tsv` - Accepted PrusaSlicer source pin,
  selected stable tag, peeled commit, SPDX/provenance, and caution fields.
- `packages/fork-inventories/prusaslicer.tsv` - Source-pinned Prusa inventory
  row for `prusaslicer.profile-schema`.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md`
  - Phase 38 fixture scope, source pin, update route, and status boundary.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv`
  - Fixture-local source paths, sizes, SHA-256 values, update route, and
  status scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`
  - Raw Prusa profile/config fixture input for parser compatibility tests.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx`
  - Matching raw Prusa profile bundle index fixture input for traceability and
  future Phase 40 evidence.

### Rust Contracts and Registry

- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - Existing typed
  downstream fork, flavor, source-ref, origin, parity surface, and checklist
  status contracts.
- `packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs` -
  Contract parsing/display and canonical source pin tests.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Existing pure
  static flavor registry and capability metadata pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  Existing flavor registry provenance and no-overclaiming tests.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Bazel Rust
  library, test, rustfmt, and clippy wiring for the likely target crate.
- `packages/slic3r-rust/Cargo.toml` - Workspace membership and Rust 1.94
  edition/toolchain expectations.
- `packages/slic3r-rust/BUILD.bazel` - Aggregate Rust verification suite that
  should remain green.

### Docs and Status Boundaries

- `packages/parity/README.md` - Status-package rules reserving fork rows for
  executable parity targets.
- `packages/parity/status.tsv` - Parity status data source that must not gain a
  Prusa row in Phase 39.
- `docs/port/README.md` - Port control-plane state and fork parity deferrals.
- `docs/port/package-map.md` - Package roles and discoverability for Rust,
  fixture, parity, Prusa baseline, vendor, and inventory packages.
- `docs/port/migration-guidance.md` - Future fork fixture and status
  publication rules.
- `docs/port/parity-matrix.md` - Human-facing parity vocabulary and fork row
  guardrails.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `slic3r_contracts::flavor` already contains canonical Prusa source-ref,
  flavor, origin, parity-surface, and checklist-status domain types.
- `slic3r_flavors::registry` already models pure static flavor capabilities
  with provenance and no runtime side effects.
- `packages/parity-fixtures:prusa_profile_schema_bundle` already exports the
  raw Prusa fixture files and local provenance for downstream consumers.
- Existing Rust tests under `packages/slic3r-rust/crates/*/tests/` establish
  behavior-focused Arrange/Act/Assert test style.
- Existing Bazel Rust crate files show how to add `rust_library`, `rust_test`,
  `rustfmt_test`, and `rust_clippy` coverage.

### Established Patterns

- Rust migration crates use `#![forbid(unsafe_code)]`, typed contracts, pure
  helpers, and static data rather than filesystem/process/network side effects.
- Optional/absent values use `maybe_` naming in Rust internals, matching the
  Bright Builds and repo style.
- Flavor/fork metadata avoids public helper names that imply verified runtime
  support before executable parity exists.
- Package docs route parity claims through `docs/port/` and package READMEs
  rather than relying only on code comments.

### Integration Points

- Likely implementation target: `packages/slic3r-rust/crates/slic3r_flavors`,
  with possible support types in `slic3r_contracts` if new domain invariants
  belong at the shared contract layer.
- Add parser/provenance tests under
  `packages/slic3r-rust/crates/slic3r_flavors/tests/` or an adjacent crate test
  file.
- Wire any new Rust source files into
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`.
- Update docs in `packages/slic3r-rust`, `docs/port/`, and possibly
  `packages/parity-fixtures` to name the Phase 39 parser boundary while keeping
  Phase 40 parity/status claims deferred.

</code_context>

<specifics>
## Specific Ideas

- The first parser compatibility target should be the Phase 38 fixture
  `PrusaResearch.ini` from the accepted source pin
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- The capability id should remain `prusaslicer.profile-schema`.
- The future docs/status token remains `fork.prusaslicer.profile-schema`, but
  Phase 39 must not publish it as verified status.
- Use `config` and `config.persistence` as the relevant existing parity
  dependency concepts when representing the profile-schema capability.

</specifics>

<deferred>
## Deferred Ideas

- Executable Prusa profile/config parity command is Phase 40 scope.
- Publishing a Prusa row to `packages/parity/status.tsv` is Phase 40 scope and
  requires the executable parity command.
- Full PrusaSlicer runtime support, project files, STEP import, support
  generation, arc fitting, wall seam behavior, network/device integration,
  profile auto-update execution, GUI support, sync automation, and fork release
  packaging remain out of scope for v1.10 Phase 39.

</deferred>

---

*Phase: 39-rust-prusa-profile-boundary*
*Context gathered: 2026-06-01*
