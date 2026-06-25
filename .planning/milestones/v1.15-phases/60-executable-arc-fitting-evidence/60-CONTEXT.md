---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T15:09:13.299Z
---

# Phase 60: Executable Arc-Fitting Evidence - Context

**Gathered:** 2026-06-24
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 60 publishes the public executable evidence, mutation guards, exact
status wording, and public docs for the narrow `prusaslicer.arc-fitting`
evidence slice that Phases 57, 58, and 59 prepared.

The phase completes ARCEV-01, ARCEV-02, and ARCEV-03 only. It may add the
public `bazel run //packages/parity:prusaslicer_arc_fitting_parity` command,
the verified `fork.prusaslicer.arc-fitting` status row, package docs, and port
docs after the executable evidence passes. It must preserve the existing
`fork.prusaslicer.gcode-output` command/status meaning, keep broad
`generated-outputs` exactly `in progress`, and continue to defer
byte-for-byte G-code parity, broad generated-output verification, full
ArcWelder algorithm equivalence, tolerance or geometry parity, printability,
firmware behavior, printer-runtime behavior, GUI behavior, support
generation, wall seam behavior, release behavior, upstream source imports,
sync automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior.
</domain>

<decisions>
## Implementation Decisions

### Public executable evidence

- **D-01:** Add the public evidence command as
  `bazel run //packages/parity:prusaslicer_arc_fitting_parity`, matching the
  Phase 57 planned command and the Phase 59 readiness metadata. The command
  should live in `packages/parity` beside the existing public Prusa G-code,
  project-file, and profile-schema parity commands.
- **D-02:** The public command should validate the checked-in
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  through the Rust `slic3r_flavors::prusa_arc_fitting` boundary. Shell may
  orchestrate fixture paths, command output, and status text, but the Rust
  boundary remains the authority for parsed arc facts and invalid summary
  rejection.
- **D-03:** Public command output should print narrow evidence facts only:
  source identity, fixture identity/path, G2/G3 counts, direction counts,
  center-offset observations, coordinate bounds, extrusion observations,
  feedrate observations, and the checked-in-summary evidence boundary. It
  must not describe the result as byte parity, generated-output parity,
  algorithm equivalence, geometry/tolerance parity, printability, runtime
  behavior, GUI behavior, release behavior, sync behavior, or non-Prusa fork
  support.
- **D-04:** Preserve the existing public
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` contract and
  `fork.prusaslicer.gcode-output` status wording. Arc-fitting publication is a
  separate evidence row and must not widen the semantic Prusa G-code output
  row.

### Fail-closed mutation guards

- **D-05:** Add public parity mutation coverage for every ARCEV-02 drift class:
  G2/G3 command-count changes, arc direction changes, center-offset changes,
  coordinate-bound changes, extrusion observation changes, feedrate
  observation changes, source identity drift, fixture identity/path drift, and
  unsupported deferred-behavior claims.
- **D-06:** Mutation tests should use isolated temporary copies of the checked-in
  arc summary or related status/docs inputs. They should assert diagnostics
  from the public command or Rust-backed validation path rather than duplicating
  arc validation logic in Bash.
- **D-07:** Keep mutation tests focused: each test should prove one failure
  class and name the field or artifact that failed. This follows the existing
  `compare_prusaslicer_gcode_output_test.sh` pattern while applying it to the
  arc-fitting summary facts.

### Status and docs publication

- **D-08:** Add exactly one `fork.prusaslicer.arc-fitting` row to
  `packages/parity/status.tsv` only after the public executable evidence and
  mutation guards pass. The row must name the narrow Phase 57-60 evidence chain
  and keep all generated-output/runtime deferrals explicit.
- **D-09:** Preserve exactly one broad `generated-outputs` row with status
  `in progress`. Phase 60 is one feature-specific generated-output slice, not
  sufficient evidence to graduate the broad generated-output surface.
- **D-10:** Update `packages/parity/README.md`, `docs/port/package-map.md`,
  `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and any
  directly related port docs only as needed to expose the new public
  arc-fitting evidence command/status row and the narrow evidence boundary.
- **D-11:** Public docs should describe the evidence chain as: Phase 57 reviewed
  scope contract, Phase 58 checked-in fixture/expected summary, Phase 59 pure
  Rust parser/readiness boundary, and Phase 60 public command/status/docs.
  Docs must say the existing semantic Prusa G-code output evidence remains
  separate.

### Verification gate

- **D-12:** Required verification should include the new public parity command,
  its mutation test target, the existing public Prusa G-code output parity
  command/test, arc-fitting fixture verification, arc-fitting scope
  verification, aggregate Rust verification, parity status checks, and docs or
  package verifiers touched by the plan.
- **D-13:** If exact wording guards in existing scope or fixture verifiers fail
  because Phase 60 legitimately publishes status/docs, update those verifier
  contracts narrowly to the new Phase 60-published wording. Do not relax
  forbidden-claim or generated-output guards.

### the agent's Discretion

- Choose the exact shell helper names and public output line ordering, provided
  output is deterministic, reviewable, and constrained to the approved
  arc-fitting facts.
- Choose whether the public command calls an existing Rust binary mode or a new
  narrowly named helper, provided the validation path still uses
  `slic3r_flavors::prusa_arc_fitting` and avoids live generation, Git, network,
  process discovery, upstream import, or runtime side effects beyond the
  checked-in evidence command itself.
- Choose exact documentation placement and wording, provided every public
  surface keeps the narrow arc-fitting slice separate from broad
  `generated-outputs` and existing `fork.prusaslicer.gcode-output` semantics.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 60 goal, dependency, requirement IDs, success
  criteria, and no-widening requirement for the existing Prusa G-code output
  row.
- `.planning/REQUIREMENTS.md` - ARCEV-01, ARCEV-02, ARCEV-03, future
  generated-output requirements, and the v1.15 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.15 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa
  generated-output evidence-chain decisions.
- `.planning/phases/57-arc-fitting-scope-contract/57-CONTEXT.md` - locked
  scope decisions for the planned command, planned status token, approved arc
  fields, and no-overclaiming rules.
- `.planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md` - locked
  fixture decisions for namespace, summary artifact, provenance, and Phase 60
  ownership.
- `.planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md` -
  locked Rust boundary decisions, readiness metadata, registry constraints, and
  Phase 60 publication boundary.
- `.planning/phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md`
  - evidence that Phase 59 passed and the Rust boundary is ready for public
  executable consumption.

### Arc-fitting source artifacts

- `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` - approved
  arc-fitting scope record, planned public command, planned status wording,
  deferred scope, security note, and traceability.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh` -
  existing exact scope verifier that may need narrow Phase 60 publication
  updates without relaxing forbidden-claim checks.
- `packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh` -
  scope mutation-test precedent for status and overclaim guards.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  - checked-in summary artifact the public command must validate.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv`
  - source identity, fixture identity, source anchors, checksum, update route,
  exclusions, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md`
  - namespace-local boundary and Phase 60 ownership split.
- `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - fixture
  verifier constants and exact artifact expectations the public command should
  agree with.

### Rust boundary and public parity precedent

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs` -
  pure Rust parser, typed facts, readiness metadata, and forbidden-claim
  boundary for checked-in arc summaries.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs` -
  valid/invalid Rust parser coverage and include-str fixture precedent.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - static
  registry row for `prusaslicer.arc-fitting` and existing generated-output
  dependency semantics.
- `packages/parity/compare_prusaslicer_gcode_output.sh` - closest existing
  public Prusa generated-output evidence command pattern.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh` - closest public
  mutation guard pattern for checked-in summary drift.
- `packages/parity/BUILD.bazel` - public parity command/test wiring.
- `packages/parity/status.tsv` - broad `generated-outputs`, existing
  `fork.prusaslicer.gcode-output`, and new Phase 60
  `fork.prusaslicer.arc-fitting` publication surface.
- `packages/parity/README.md` - public parity package docs to update for the
  new command and status row.

### Public docs

- `docs/port/package-map.md` - package ownership and evidence ladder docs to
  update for the public arc-fitting command/status publication.
- `docs/port/parity-matrix.md` - public status wording, generated-output row,
  and no-overclaiming boundary.
- `docs/port/migration-guidance.md` - maintainer-facing public guidance for
  Prusa fixture, Rust, and parity evidence boundaries.
- `docs/port/README.md` - port overview text if the new public arc-fitting
  evidence slice needs a visible summary alongside existing generated-output
  evidence.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity/compare_prusaslicer_gcode_output.sh`: Existing public
  generated-output evidence command that validates checked-in Prusa summary
  artifacts through Rust helpers and prints narrow public evidence facts.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh`: Existing public
  mutation harness for summary drift and no-overclaiming checks.
- `packages/parity/BUILD.bazel`: Existing wiring for public parity shell
  commands, `sh_test` targets, data dependencies, and package boundary exports.
- `slic3r_flavors::prusa_arc_fitting`: Phase 59 Rust module that validates the
  exact checked-in arc summary rows and exposes typed facts/readiness metadata.
- `packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary` and
  `packages/parity-fixtures:verify_prusa_arc_fitting_fixture`: Fixture targets
  that should feed or guard the public command.
- `packages/prusa-arc-fitting-scope:verify`: Scope verifier that protects the
  reviewed contract and no-overclaiming boundary.

### Established Patterns

- Public executable evidence phases publish a narrow parity command, mutation
  test, exact status row, and docs only after the scope, fixture, and Rust
  parser/readiness phases have passed.
- Shell commands orchestrate checked-in artifacts and user-visible output while
  Rust parser boundaries own typed validation of evidence summaries.
- Status/docs publication is guarded by exact text and forbidden-claim tests.
  Broad status rows stay conservative until multiple evidence slices justify a
  separate milestone decision.
- Mutation tests use temp copies and field-specific diagnostics rather than
  mutating tracked fixture files.

### Integration Points

- Add a new public parity script under `packages/parity/`, likely named
  `compare_prusaslicer_arc_fitting.sh`.
- Add `prusaslicer_arc_fitting_parity` and its mutation test to
  `packages/parity/BUILD.bazel`.
- Extend `packages/parity/status.tsv` with exactly one
  `fork.prusaslicer.arc-fitting` row.
- Update `packages/parity/README.md` and the relevant `docs/port/*` pages for
  the new public command/status row.
- Narrowly update arc-fitting scope and fixture verifiers only if their planned
  Phase 60 absence checks become stale after legitimate publication.
</code_context>

<specifics>
## Specific Ideas

- Treat this as the arc-fitting equivalent of the Phase 56 semantic Prusa
  G-code publication step, not as a broad generated-output graduation.
- Use status wording that says the public command validates checked-in
  arc-fitting expected-summary evidence through the Phase 59 Rust boundary.
- Keep command output boring and exact so mutation tests can assert it without
  brittle prose.
- Include a regression check that the existing
  `fork.prusaslicer.gcode-output` row and public command remain semantic
  G-code evidence only.
</specifics>

<deferred>
## Deferred Ideas

- Byte-for-byte Prusa G-code parity, broad generated-output verification,
  full ArcWelder algorithm equivalence, tolerance/geometry parity,
  printability, firmware behavior, printer-runtime behavior, GUI behavior,
  support generation, wall seam behavior, release behavior, upstream imports,
  sync automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior remain
  out of scope.
- Richer arc-fitting geometry, tolerance, algorithm-equivalence, or
  printability evidence belongs to future requirement ARC-02 or a later
  generated-output milestone.
</deferred>

---

*Phase: 60-executable-arc-fitting-evidence*
*Context gathered: 2026-06-24*
