---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 44-2026-06-05T23-05-16
generated_at: 2026-06-05T23:05:16.426Z
---

# Phase 44: Executable Prusa Project-File Parity - Context

**Gathered:** 2026-06-05
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 44 turns the already scoped, fixture-backed, and Rust-backed
`prusaslicer.project-file` evidence slice into executable parity evidence. It
must add a maintainer-runnable Bazel parity command, prove the command fails
when expected project-file evidence diverges, and publish docs/status wording
that names only the exact verified evidence slice.

This phase does not broaden into full PrusaSlicer runtime support, GUI project
behavior, full 3MF import/export, generated-output parity, STEP import, support
generation, arc fitting, wall seam behavior, network/device integration,
profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
upstream source imports, or sync automation.

</domain>

<decisions>
## Implementation Decisions

### Parity Command Surface

- **D-01:** Create the Phase 41 planned command
  `bazel run //packages/parity:prusaslicer_project_file_parity` in
  `packages/parity`.
- **D-02:** Mirror the narrow Prusa profile-schema parity command pattern:
  a repo-owned shell comparator, a Bazel `sh_binary`, fixture data from
  `packages/parity-fixtures`, and Rust summary output from
  `slic3r_flavors`.
- **D-03:** Add a Rust summary binary for project-file evidence only if needed
  to expose `prusa_project_file_summary_lines` to the shell comparator. Keep
  it in the existing `packages/slic3r-rust/crates/slic3r_flavors` crate and
  keep the production Rust boundary data-in/data-out.

### Expected Evidence Comparison

- **D-04:** Compare the Rust-backed summary of
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  against the checked-in expected project summary. Do not inspect, parse, or
  claim full 3MF container semantics beyond the Phase 42 presence-level rows.
- **D-05:** The comparator must fail closed when the Rust summary output or
  checked-in expected artifact diverges. The first mismatch should name a
  useful row or line label and include a diff, following the profile-schema
  comparator precedent.
- **D-06:** The success output should include the exact status token
  `fork.prusaslicer.project-file`, accepted source ref, fixture path, expected
  artifact path, and row count so maintainers can audit what passed.

### Failure Guard

- **D-07:** Add a Bazel `sh_test` failure guard for the project-file parity
  comparator. It should mutate a temporary copy of
  `expected-project-summary.tsv`, prove the comparator exits non-zero, and
  assert that the original checked-in expected artifact remains unchanged.
- **D-08:** Keep mutation tests local and hermetic. Do not mutate checked-in
  fixture files, fetch upstream source, run Git, access network services,
  execute profile auto-update behavior, import upstream source trees, or
  ingest plugins.

### Status and Docs Publication

- **D-09:** Add a `fork.prusaslicer.project-file` row to
  `packages/parity/status.tsv` only after the runnable command exists and
  passes.
- **D-10:** Update `packages/parity/README.md`, `docs/port/README.md`,
  `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and
  `docs/port/parity-matrix.md` as needed so maintainers can run the command
  and understand the exact evidence slice.
- **D-11:** Docs and status wording must say this is a narrow
  `prusaslicer.project-file` expected-summary evidence slice backed by the
  Phase 42 fixture and Phase 43 Rust summary boundary, not full PrusaSlicer
  project loading, GUI behavior, load/save behavior, 3MF import/export, or
  generated-output parity.

### Verification Shape

- **D-12:** Verification should include the new parity command, its failure
  guard test, the relevant Rust/Bazel checks for any new Rust binary wiring,
  and documentation/status text checks proving exact scope and deferred
  surfaces.
- **D-13:** Keep this phase aligned with PPEV-01, PPEV-02, and PPEV-03: runnable
  command, divergence failure evidence, and exact docs/status publication.

### the agent's Discretion

- The agent may choose the exact comparator helper names and row-label
  extraction logic, provided errors remain actionable and failure tests prove
  divergence.
- The agent may decide whether a tiny Rust CLI binary is necessary or whether
  an existing binary surface can be reused without weakening the pure Rust
  boundary.
- The agent may choose the minimum docs edits needed to publish the verified
  evidence without rewriting unrelated milestone history.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 44 goal, success criteria, dependency on
  Phase 43, and PPEV requirement mapping.
- `.planning/REQUIREMENTS.md` - PPEV-01, PPEV-02, PPEV-03, and explicit v1.11
  out-of-scope exclusions.
- `.planning/PROJECT.md` - milestone goal, prior Prusa evidence chain, current
  state, and non-overclaiming constraints.
- `.planning/STATE.md` - current Phase 44 position and recent Phase 43 handoff.

### Phase 41-43 Inputs

- `packages/prusa-project-file-scope/project-file-scope.md` - planned evidence
  command, planned status token, source identity, fixture contract, and
  deferred scope.
- `.planning/phases/41-prusa-project-file-scope-gate/41-CONTEXT.md` - locked
  scope-gate decisions.
- `.planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md` -
  locked fixture, expected artifact, verifier, and docs decisions.
- `.planning/phases/43-rust-prusa-project-file-boundary/43-CONTEXT.md` -
  locked Rust boundary, metadata, verification, and docs decisions.
- `.planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md` -
  verified Phase 43 parser/metadata readiness and negative checks.

### Fixture and Rust Evidence

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  - checked-in presence-level expected project summary rows.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv`
  - accepted source ref, fixture path, hash, update route, and exclusions.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md`
  - fixture namespace boundary and Phase 44 handoff.
- `packages/parity-fixtures/BUILD.bazel` - project-file fixture aliases and
  verifier targets.
- `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` - fixture
  verifier and exact expected row checks.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs` -
  pure Rust parser, metadata, summary-line, and typed-error boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs` -
  focused Rust parser and summary tests.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Rust library,
  binary, test, clippy, and rustfmt wiring pattern.

### Existing Parity Pattern and Publication Surfaces

- `packages/parity/compare_prusaslicer_profile_schema.sh` - comparator pattern
  for source-backed Prusa parity evidence.
- `packages/parity/compare_prusaslicer_profile_schema_test.sh` - mutation
  failure guard pattern.
- `packages/parity/BUILD.bazel` - parity command and test wiring.
- `packages/parity/README.md` - parity package rules and fork status row
  publication constraints.
- `packages/parity/status.tsv` - checked-in parity status data source.
- `docs/port/README.md` - port control-plane state and Prusa project-file phase
  routing.
- `docs/port/package-map.md` - package ownership and Phase 44 route.
- `docs/port/migration-guidance.md` - fork fixture/status publication rules.
- `docs/port/parity-matrix.md` - human-facing parity vocabulary and guardrails.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity/compare_prusaslicer_profile_schema.sh` already implements a
  fail-closed expected-vs-actual comparator with row labels and diff output.
- `packages/parity/compare_prusaslicer_profile_schema_test.sh` already proves a
  mutated expected artifact fails while the checked-in expected artifact stays
  unchanged.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`
  already exposes `parse_prusa_project_file_summary`,
  `prusa_project_file_metadata`, and `prusa_project_file_summary_lines`.
- `packages/parity-fixtures:prusa_project_file_expected_project_summary` and
  related aliases already expose the Phase 42 fixture evidence to Bazel.

### Established Patterns

- Public parity evidence lives in `packages/parity` as Bazel `sh_binary`
  targets, with checked-in expected artifacts under `packages/parity-fixtures`.
- Fork parity status rows stay absent until a real runnable evidence command
  exists and passes.
- Rust flavor logic remains pure and side-effect free; shell comparators own
  filesystem and process orchestration.
- Documentation must name exact verified surfaces and repeat deferred scope for
  adjacent Prusa runtime, GUI, generated-output, release, network, and sync
  surfaces.

### Integration Points

- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` may need a new
  `rust_binary` target and clippy/rustfmt inclusion if Phase 44 adds a
  project-file summary CLI.
- `packages/parity/BUILD.bazel` must wire the comparator, fixture expected
  summary, fixture provenance if needed, status source, and new failure test.
- `packages/parity/status.tsv` should gain exactly one new verified row:
  `fork.prusaslicer.project-file`.
- `docs/port/*` and `packages/parity/README.md` should replace "Phase 44 will"
  wording with "Phase 44 provides" wording only for the narrow executable
  evidence slice.

</code_context>

<specifics>
## Specific Ideas

- Prefer the command name already reserved in the Phase 41 scope record:
  `//packages/parity:prusaslicer_project_file_parity`.
- Prefer success output shaped like:
  `ok: fork.prusaslicer.project-file parity passed`, followed by `source_ref`,
  `fixture`, `expected`, and `rows`.
- Prefer a mutation test that changes a single temporary expected-summary field
  such as `project_marker` or `deferred_semantics`, then checks stderr names
  `expected-project-summary.tsv` and the changed row label.

</specifics>

<deferred>
## Deferred Ideas

None - yolo discussion stayed within Phase 44 scope.

</deferred>

---

*Phase: 44-executable-prusa-project-file-parity*
*Context gathered: 2026-06-05*
