---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 43-2026-06-05T13-01-41
generated_at: 2026-06-05T13:02:42.920Z
---

# Phase 43: Rust Prusa Project-File Boundary - Context

**Gathered:** 2026-06-05
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 43 creates the Rust domain boundary for the v1.11
`prusaslicer.project-file` evidence slice. The boundary should parse or
summarize the checked-in Phase 42 project-file expected evidence into typed,
side-effect-free Rust values that trace back to the accepted Prusa source
identity, inventory row, fixture path, scope record, and planned status token.

This phase must not create the Phase 44 executable parity command, publish
`fork.prusaslicer.project-file` in `packages/parity/status.tsv`, claim full 3MF
import/export, decode generated output, model GUI project behavior, or add
broader PrusaSlicer runtime support.

</domain>

<decisions>
## Implementation Decisions

### Rust Boundary Placement

- **D-01:** Add the project-file boundary under the existing
  `packages/slic3r-rust/crates/slic3r_flavors` crate, reusing the
  `prusa_profile` module pattern rather than creating a new Rust workspace.
- **D-02:** Name the likely public surface `slic3r_flavors::prusa_project_file`
  with re-exports from `src/lib.rs`, unless planning finds an established local
  naming pattern that is clearly better.
- **D-03:** Keep production functions data-in/data-out. Callers may pass
  strings, slices, or already-loaded bytes, but the Rust domain code must not
  discover files, walk directories, inspect Git, spawn processes, access the
  network, execute profile auto-update behavior, import upstream source trees,
  or run vendor sync logic.

### Project Summary Shape

- **D-04:** Prefer parsing or summarizing the Phase 42
  `expected-project-summary.tsv` rows into typed Rust values for the first
  boundary. Do not require a full 3MF ZIP/container parser for Phase 43 unless
  research proves that a dependency-free or already-owned parser is necessary.
- **D-05:** Preserve the Phase 42 expected TSV columns exactly as boundary
  concepts: `source_ref`, `fixture_path`, `archive_member`, `project_marker`,
  `deferred_semantics`, and `notes`.
- **D-06:** Treat project markers as presence-level evidence only. Valid
  summary rows may mention archive members such as `[Content_Types].xml`,
  `_rels/.rels`, `3D/3dmodel.model`, `Metadata/thumbnail.png`,
  `Metadata/Slic3r_PE.config`, and `Metadata/Slic3r_PE_model.config`, but must
  not infer mesh geometry, printer/profile semantics, generated-output
  behavior, GUI behavior, load/save behavior, or full 3MF import/export parity.
- **D-07:** Fail malformed or unsupported summary input with typed errors.
  Avoid panics and avoid silently accepting missing required columns, empty
  required values, or rows for unexpected source refs or fixture paths.

### Provenance and Traceability

- **D-08:** Expose typed metadata that traces `prusaslicer.project-file` to
  vendor `prusaslicer`, flavor `PrusaSlicer`, inventory row
  `prusaslicer.project-file`, source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `src/libslic3r/Format/3mf.cpp`, fixture path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf`,
  expected summary path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`,
  scope record `packages/prusa-project-file-scope/project-file-scope.md`, and
  planned status token `fork.prusaslicer.project-file`.
- **D-09:** Reuse existing contract types such as `FlavorId`,
  `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`
  wherever they fit. Add newtypes only where they prevent confusion between raw
  TSV text and typed project-file evidence.
- **D-10:** The Rust metadata may name the future status token as reserved
  traceability, but Phase 43 must not publish that token as verified parity.

### Verification Shape

- **D-11:** Add focused Rust unit/integration tests for summary parsing,
  required-column validation, malformed-row errors, metadata traceability, and
  no-overclaiming marker semantics.
- **D-12:** Tests should use Arrange, Act, Assert comments when setup is
  non-trivial and should cover one concern per test.
- **D-13:** Use `include_str!` for checked-in fixture summary tests if helpful;
  production code must remain free of filesystem and process side effects.
- **D-14:** Wire the new Rust tests into both Cargo and Bazel verification for
  `slic3r_flavors`, keeping `//packages/slic3r-rust:verify` green.

### Documentation and Scope Control

- **D-15:** Update Rust/package and port docs only enough to explain that Phase
  43 adds a parser/summary metadata boundary, while Phase 44 still owns the
  executable parity command and status publication.
- **D-16:** Preserve the Phase 41/42 deferred-scope wording: no full
  PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
  generated-output parity, STEP import, support generation, arc fitting, wall
  seam behavior, network/device integration, profile auto-update execution,
  fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, or
  sync automation.

### the agent's Discretion

- The agent may choose exact Rust type names and file splits, provided the
  boundary remains small, pure, and consistent with `prusa_profile.rs`.
- The agent may decide whether the project-file summary rows need an enum for
  known archive members or a validated string newtype, whichever keeps the
  evidence narrow and maintainable.
- The agent may choose the minimum doc set needed to make the Rust boundary
  discoverable without rewriting unrelated milestone history.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 43 goal, success criteria, dependency on Phase
  42, and v1.11 execution order.
- `.planning/REQUIREMENTS.md` - PPROJ-01, PPROJ-02, PPROJ-03, and explicit
  v1.11 out-of-scope exclusions.
- `.planning/PROJECT.md` - current milestone goal, Phase 41/42 state, and
  Prusa project-file evidence constraints.
- `.planning/STATE.md` - current phase position and recent GSD state.

### Phase 41/42 Inputs

- `packages/prusa-project-file-scope/project-file-scope.md` - accepted source
  identity, expected-artifact contract, candidate Rust boundary, planned parity
  command, planned status token, and deferred scope.
- `.planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md` - locked
  scope-gate decisions.
- `.planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md` - Phase
  41 implementation handoff.
- `.planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md` -
  verified scope-gate truths.
- `.planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md` -
  locked fixture, expected artifact, verifier, and docs handoff decisions.
- `.planning/phases/42-prusa-project-file-fixture-surface/42-VERIFICATION.md`
  - verified Phase 42 fixture facts and negative checks.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  - selected presence-level expected project summary rows.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv`
  - source ref, fixture hash, update route, and Phase 41 traceability.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md`
  - fixture namespace boundary and deferred-scope wording.

### Rust Contracts and Existing Boundary Pattern

- `.planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-CONTEXT.md`
  - prior pure Rust Prusa profile-schema boundary decisions.
- `.planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md`
  - completed parser module, tests, and Bazel/Cargo wiring precedent.
- `.planning/milestones/v1.10-phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md`
  - profile-schema summary and documentation precedent.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` - existing
  typed parser, metadata, summary-line, and typed-error pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - crate re-export
  pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - existing
  `prusaslicer.project-file` capability metadata and provenance row.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs` -
  Arrange/Act/Assert parser and summary tests.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry traceability and no-overclaiming tests.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Bazel Rust
  library, test, clippy, and rustfmt wiring.
- `packages/slic3r-rust/Cargo.toml` - Rust workspace membership and Cargo
  verification surface.
- `packages/slic3r-rust/BUILD.bazel` - aggregate Rust verification target.

### Docs and Status Boundaries

- `packages/slic3r-rust/README.md` - Rust package boundary and existing Prusa
  profile-schema evidence wording.
- `docs/port/README.md` - port control-plane state and Prusa project-file phase
  routing.
- `docs/port/package-map.md` - package roles for fixtures, Rust, and parity.
- `docs/port/migration-guidance.md` - fork fixture/status publication rules.
- `docs/port/parity-matrix.md` - human-facing parity vocabulary and guardrails.
- `packages/parity/README.md` - status-package rules reserving fork rows for
  executable parity targets.
- `packages/parity/status.tsv` - status data source that must not gain
  `fork.prusaslicer.project-file` during Phase 43.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs`: existing
  pure parser/summary/metadata boundary to mirror for project-file evidence.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs`: focused
  Rust parser and summary tests with checked-in fixture coverage.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`: already
  contains the `prusaslicer.project-file` source-observed capability row.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`:
  selected Phase 42 data surface for Rust summary parsing.

### Established Patterns

- Prusa fork evidence advances through source-pinned, narrow, executable slices
  and explicitly defers broad runtime claims.
- Rust flavor logic stays pure and side-effect free; I/O and command execution
  belong to parity commands or verifier scripts.
- The Rust crate uses typed structs/newtypes and typed parse errors rather than
  raw maps passed through the domain layer.
- Bazel and Cargo verification both need to know about new Rust modules/tests.

### Integration Points

- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` should re-export the
  new project-file boundary when implementation adds it.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` must include any new
  source and test targets in library, clippy, and rustfmt coverage.
- Phase 44 will consume the Phase 43 Rust summary boundary when creating
  `//packages/parity:prusaslicer_project_file_parity` and the
  `fork.prusaslicer.project-file` status row.

</code_context>

<specifics>
## Specific Ideas

- Reuse the `prusa_profile` module's small public metadata struct plus parser
  result shape, but keep project-file row semantics limited to the Phase 42
  expected summary.
- Treat `expected-project-summary.tsv` as the first Rust-friendly evidence
  source. Full 3MF import/export and geometry/config semantics stay deferred.
- Keep `fork.prusaslicer.project-file` as a reserved future token until Phase
  44 verifies executable evidence.

</specifics>

<deferred>
## Deferred Ideas

Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
generated-output parity, STEP import, support generation, arc fitting, wall
seam behavior, network/device integration, profile auto-update execution, fork
release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
automation remain outside Phase 43.

</deferred>

---

*Phase: 43-rust-prusa-project-file-boundary*
*Context gathered: 2026-06-05*
