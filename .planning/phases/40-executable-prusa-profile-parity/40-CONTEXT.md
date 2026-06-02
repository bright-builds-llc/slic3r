---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 40-2026-06-02T12-10-38
generated_at: 2026-06-02T12:10:38.683Z
---

# Phase 40: Executable Prusa Profile Parity - Context

**Gathered:** 2026-06-02
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 40 delivers the first executable PrusaSlicer parity evidence slice for
`prusaslicer.profile-schema`. Maintainers must be able to run a repo-owned
Bazel command, see it compare Rust-backed parsed or normalized profile/config
output against checked-in Prusa fixture expectations, and inspect docs/status
updates that name only the narrow verified evidence slice.

This phase may publish the reserved `fork.prusaslicer.profile-schema` status row
after executable evidence exists. It must not claim full PrusaSlicer runtime
support, GUI support, generated-output parity, fork release builds, profile
auto-update execution, vendor sync automation, Bambu Studio support, or
OrcaSlicer support.

</domain>

<decisions>
## Implementation Decisions

### Repo-Owned Parity Command

- **D-01:** Add `bazel run //packages/parity:prusaslicer_profile_schema_parity`
  as the maintainer-facing command for this evidence slice.
- **D-02:** Keep the command under `packages/parity` so it follows the existing
  parity/status package ownership model. It may call Rust code or package-local
  helper scripts, but `packages/parity` owns the user-facing command target and
  status publication.
- **D-03:** The command should print a concise pass/fail summary that names
  `fork.prusaslicer.profile-schema`, the accepted source ref, the fixture path,
  and the expected output artifact or snapshot it compared.

### Comparison Contract

- **D-04:** Compare deterministic Rust-backed parser output from the Phase 39
  `slic3r_flavors::prusa_profile` boundary against checked-in expectations
  derived from the Phase 38 `PrusaResearch.ini` fixture.
- **D-05:** Keep the expected data narrow and stable: source identity, section
  count, entry count, representative section/key/value samples, and the
  profile-schema provenance metadata are enough for this phase.
- **D-06:** Do not attempt a full Prusa runtime configuration engine, printer
  preset resolver, profile inheritance evaluator, generated-output comparison,
  or upstream Prusa binary comparison in this milestone.
- **D-07:** Prefer a structured expected artifact that can be reviewed in git
  and used by a fail-closed verifier. JSON, TSV, or line-oriented snapshots are
  acceptable if the implementation keeps deterministic ordering and clear diffs.

### Divergence Failure Guard

- **D-08:** Add an automated test that proves the parity command fails when the
  Rust-backed parsed or normalized output diverges from checked-in fixture
  expectations.
- **D-09:** The negative test may use a copied/mutated expected artifact, a
  controlled fixture fragment, or helper flags that point the verifier at a bad
  expectation. It should not corrupt the real fixture bundle or require network,
  Git, profile auto-update, or upstream source-tree access.
- **D-10:** Failure diagnostics should identify the mismatched field or sample
  line clearly enough that maintainers can update the expected fixture only
  through the documented fixture/update route.

### Status and Documentation Publication

- **D-11:** Once the command and failure guard pass, publish exactly one narrow
  Prusa status row in `packages/parity/status.tsv` for
  `fork.prusaslicer.profile-schema`.
- **D-12:** The status row and docs must point to
  `//packages/parity:prusaslicer_profile_schema_parity` as the evidence command
  and must avoid any wording that implies full fork runtime support.
- **D-13:** Update the port control-plane docs, package map, migration guidance,
  parity matrix, parity README, fixture README, and Rust package docs only as
  needed to move `fork.prusaslicer.profile-schema` from reserved vocabulary to
  verified narrow executable evidence.

### Scope Guardrails

- **D-14:** Preserve Phase 37-39 deferrals: no GUI support, no generated-output
  parity, no Prusa project files, no STEP import, no support generation, no arc
  fitting, no wall seam behavior, no network/device/cloud/credential behavior,
  no non-free plugin ingestion, no fork release packaging, and no sync
  automation.
- **D-15:** Keep all new executable evidence local and deterministic. The
  parity command should consume checked-in fixtures and Rust parser output only.

### the agent's Discretion

- Exact verifier implementation language and file split, provided the
  maintainer-facing command is the Bazel target in `packages/parity`.
- Exact expected artifact format, provided it is deterministic, reviewable, and
  gives useful failure output.
- Whether Rust exposes a small helper binary, library function, or test-only
  fixture adapter for producing the comparison output, provided production Rust
  parser code remains side-effect free.
- Exact docs wording and section placement, provided the narrow evidence claim
  and deferrals are unmistakable.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 40 goal, dependency on Phase 39, PPAR-01
  through PPAR-03 mapping, and success criteria.
- `.planning/REQUIREMENTS.md` - Executable Prusa parity requirements and
  milestone out-of-scope table.
- `.planning/PROJECT.md` - v1.10 milestone goal, current state, active
  requirement, and key decisions.
- `.planning/STATE.md` - Current phase position and recent v1.10 decisions.
- `.planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md` - Locked
  parser, metadata, side-effect, docs, and Phase 40 deferral decisions.
- `.planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md` - Rust
  parser, metadata, Cargo/Bazel wiring, and requirement completion evidence.
- `.planning/phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md` - Docs
  updates that preserve Phase 40 parity/status ownership.
- `.planning/phases/39-rust-prusa-profile-boundary/39-VERIFICATION.md` - Goal
  achievement evidence and explicit Phase 40 deferred item.

### Prusa Fixture and Parser Inputs

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md`
  - Fixture scope, source pin, update route, and Phase 40 command reservation.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv`
  - Fixture-local source paths, sizes, SHA-256 values, update route, and status
  scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`
  - Raw Prusa profile/config fixture input for executable parity.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx`
  - Matching raw Prusa profile bundle index fixture input for traceability.
- `packages/parity-fixtures/BUILD.bazel` - Prusa fixture exports and fixture
  verifier targets.
- `packages/parity-fixtures/README.md` - Fixture package rules, namespace, and
  update protocol.
- `packages/prusa-baseline/profile-schema-checklist.md` - Checklist gate for
  `prusaslicer.profile-schema`, source path, source pin, and planned evidence
  command.
- `packages/fork-vendors/forks.tsv` - Accepted PrusaSlicer source pin.
- `packages/fork-inventories/prusaslicer.tsv` - Source-pinned Prusa inventory
  row for `prusaslicer.profile-schema`.

### Rust Parser and Metadata Boundary

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` - Phase 39
  pure parser, typed output, parse errors, and provenance metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs` - Parser
  behavior and real-fixture compatibility tests.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - Existing
  Prusa profile-schema capability metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  Registry provenance and reserved-status tests.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Crate-local
  Rust/Bazel test wiring.
- `packages/slic3r-rust/BUILD.bazel` - Aggregate Rust verification suite.
- `packages/slic3r-rust/README.md` - Rust package docs and current Prusa parser
  boundary wording.

### Parity and Docs Surfaces

- `packages/parity/BUILD.bazel` - Existing parity command/test target patterns.
- `packages/parity/README.md` - Status-package rules and existing reserved
  Prusa status wording.
- `packages/parity/status.tsv` - Status table that should gain exactly one
  narrow Prusa row after executable evidence exists.
- `packages/parity/parity_status.sh` - Existing status display command.
- `docs/port/README.md` - Port control-plane state and evidence boundaries.
- `docs/port/package-map.md` - Package roles and discoverability.
- `docs/port/migration-guidance.md` - Fixture/status publication rules.
- `docs/port/parity-matrix.md` - Human-facing parity vocabulary and status
  wording.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `slic3r_flavors::prusa_profile` already parses `PrusaResearch.ini` into typed
  sections, entries, source identity, and typed errors without side effects.
- `prusa_profile_schema_metadata()` already exposes inventory id, vendor id,
  accepted source ref, source path, fixture path, checklist path, and reserved
  status token.
- `packages/parity-fixtures:prusa_profile_schema_bundle` exports the raw Prusa
  fixture files and provenance.
- Existing `packages/parity` targets provide command/test patterns for fixture
  comparisons and status publication.
- Existing docs in `docs/port/` and package READMEs already describe the
  reserved Phase 40 Prusa command/status boundary.

### Established Patterns

- Parity evidence is published through repo-owned Bazel commands under
  `packages/parity`.
- Fixture-backed parity commands compare checked-in expected outputs with
  deterministic Rust/legacy command output and have failure-mode tests.
- Status rows are conservative and should appear only when a rerunnable evidence
  command exists.
- Rust migration code favors typed, pure domain logic with Cargo and Bazel test
  coverage.

### Integration Points

- Add or extend a `packages/parity` command target named
  `prusaslicer_profile_schema_parity`.
- Add any expected output artifact under a fixture-owned or parity-owned
  location that keeps provenance and update rules clear.
- If a Rust helper is needed, keep it in or near `slic3r_flavors` and wire it
  through Cargo/Bazel without introducing side effects into the parser module.
- Update `packages/parity/status.tsv`, `packages/parity/README.md`,
  `packages/parity-fixtures/README.md`, `packages/slic3r-rust/README.md`, and
  `docs/port/*` only after the executable evidence command passes.

</code_context>

<specifics>
## Specific Ideas

- The status token is `fork.prusaslicer.profile-schema`.
- The maintainer command is
  `bazel run //packages/parity:prusaslicer_profile_schema_parity`.
- The accepted source ref remains
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- The fixture input remains
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`.
- Good initial comparison fields include the parser source identity, 6976
  parsed sections, 27340 parsed entries, representative section/key/value
  samples, and profile-schema metadata from Phase 39.

</specifics>

<deferred>
## Deferred Ideas

None - discussion stayed within phase scope.

</deferred>

---

*Phase: 40-executable-prusa-profile-parity*
*Context gathered: 2026-06-02*
