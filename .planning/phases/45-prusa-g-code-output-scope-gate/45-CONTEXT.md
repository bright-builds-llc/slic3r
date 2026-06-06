---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 45-2026-06-06T13-53-22
generated_at: 2026-06-06T13:53:22.503Z
---

# Phase 45: Prusa G-code Output Scope Gate - Context

**Gathered:** 2026-06-06
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 45 delivers a reviewed `prusaslicer.gcode-output` scope gate only.
Maintainers must be able to inspect the accepted source identity, fixture
source decision, expected-summary contract, candidate Rust boundary, planned
evidence command, planned status token, docs touched, license/security note,
deferred scope, and reviewer signoff before fixture bytes, Rust summary code,
parity targets, or verified status rows are introduced.

This phase must not create a Prusa G-code fixture, expected summary artifact,
Rust parser/summary implementation, executable parity command, or
`packages/parity/status.tsv` publication.

</domain>

<decisions>

## Implementation Decisions

### Scope Record Contract

- **D-01:** Create a dedicated package for the Phase 45 scope gate, following
  the Phase 41 `packages/prusa-project-file-scope` shape: package-local
  `README.md`, one scope record markdown file, package-local verifier script,
  focused verifier test, and Bazel target named `verify`.
- **D-02:** The scope record must use the exact inventory row
  `prusaslicer.gcode-output` and must trace it to the accepted PrusaSlicer
  source identity from the v1.12 research and fork inventory context.
- **D-03:** The scope record must name the Phase 46 fixture decision as a
  future, reviewed, source-pinned ASCII `.gcode` fixture and must explicitly
  state that no fixture bytes are checked in during Phase 45.
- **D-04:** The expected-summary contract must be summary-only and future
  Phase 46 owned. It should plan
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  without creating that file in Phase 45.
- **D-05:** The candidate Rust boundary must be future Phase 47 owned and
  should reserve `slic3r_flavors::prusa_gcode_output` or the closest
  repo-conforming equivalent as a pure data-in/data-out summary boundary.
- **D-06:** The planned evidence command must be future Phase 48 owned and
  reserve `bazel run //packages/parity:prusaslicer_gcode_output_parity`
  without creating the target in Phase 45.
- **D-07:** The planned status token must be future Phase 48 owned and reserve
  `fork.prusaslicer.gcode-output` only after executable evidence passes.

### Verification Guardrails

- **D-08:** The Phase 45 verifier must fail closed on missing or changed scope
  record fields, missing non-overclaiming README language, missing deferred
  scope terms, missing source identity, missing future fixture/summary/Rust/
  command/status handoff text, or missing reviewer signoff.
- **D-09:** The verifier must also guard the absence boundary: Phase 45 should
  fail if the package or documentation implies fixture bytes, expected
  artifacts, Rust summary readiness, parity command availability, status row
  publication, upstream source import, Git/network/vendor sync behavior,
  printer-runtime behavior, host upload, profile auto-update execution,
  release builds, Bambu Studio, or OrcaSlicer support.
- **D-10:** Add a focused shell verifier test mirroring the Phase 41 style:
  one valid fixture pass plus targeted negative mutations for the highest-risk
  fields and claims.

### Downstream Handoff

- **D-11:** Phase 45 should update only the minimum docs needed to make the
  scope gate discoverable and non-overclaiming; broad docs/status publication
  remains Phase 48 work.
- **D-12:** The implementation should preserve the v1.10/v1.11 evidence
  ladder: scope gate first, then fixture surface, then Rust summary boundary,
  then executable evidence/status/docs.
- **D-13:** Keep broad `generated-outputs` in progress. Phase 45 can mention
  the future exact `fork.prusaslicer.gcode-output` token but must not verify or
  publish it.

### the agent's Discretion

The agent may choose exact file names and helper function names that best match
the local package and Bazel conventions, as long as the package remains a
scope gate only and the public command remains
`bazel run //packages/prusa-gcode-output-scope:verify` or an equivalently clear
repo-local label.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### v1.12 Milestone Scope

- `.planning/PROJECT.md` - v1.12 milestone goal, current state, and evidence
  ladder constraints.
- `.planning/REQUIREMENTS.md` - Phase 45 requirements `PGSEL-01` and
  `PGSEL-02`.
- `.planning/ROADMAP.md` - Phase 45 goal, dependencies, success criteria, and
  downstream Phase 46-48 boundaries.
- `.planning/STATE.md` - current milestone/phase status.
- `.planning/research/SUMMARY.md` - v1.12 research synthesis and roadmap
  implications.
- `.planning/research/ARCHITECTURE.md` - source gate to fixture to Rust to
  evidence sequence.
- `.planning/research/FEATURES.md` - recommended namespace, status token, and
  expected-summary vocabulary.
- `.planning/research/PITFALLS.md` - overclaiming and fixture-boundary failure
  modes.
- `.planning/research/STACK.md` - no-new-dependency guidance and local
  verification surfaces.

### Local Implementation Pattern

- `packages/prusa-project-file-scope/README.md` - prior Prusa scope gate
  package README shape and non-overclaiming language.
- `packages/prusa-project-file-scope/project-file-scope.md` - prior scope
  record table shape and downstream handoff fields.
- `packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh` -
  fail-closed verifier pattern for scope records.
- `packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh`
  - focused shell mutation tests for scope verifiers.
- `packages/prusa-project-file-scope/BUILD.bazel` - Bazel package pattern for
  scope verifier and tests.

### Status and Port Documentation

- `packages/fork-inventories/prusaslicer.tsv` - source-observed PrusaSlicer
  inventory rows and accepted source context.
- `packages/parity/status.tsv` - existing parity status vocabulary and the
  absence of a Phase 45 `fork.prusaslicer.gcode-output` verified row.
- `docs/port/migration-guidance.md` - existing fork fixture/status guidance
  and future evidence rules.
- `docs/port/parity-matrix.md` - public parity matrix language that must avoid
  broad generated-output claims during Phase 45.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/prusa-project-file-scope` can be mirrored for the new G-code scope
  package structure, verifier style, Bazel wiring, and shell mutation tests.
- `packages/parity/status.tsv` already keeps broad `generated-outputs` in
  progress and contains narrow fork-specific verified rows only after
  executable evidence.
- `docs/port/migration-guidance.md` already explains that future fork status
  requires executable parity evidence.

### Established Patterns

- Scope gates are package-local, metadata-only records with fail-closed Bazel
  verification.
- Future evidence commands and status tokens may be reserved as text, but
  targets and status rows appear only in their owning later phases.
- Shell verifiers use `set -euo pipefail`, small helper functions, explicit
  required strings/table rows, and focused mutation tests.

### Integration Points

- New Phase 45 files should live under a dedicated `packages/prusa-gcode-output-scope`
  package or similarly clear package name.
- Bazel should expose a package-local `verify` target and a shell test target.
- Docs should reference Phase 45 as a scope gate only, with fixture/Rust/parity
  work explicitly deferred to Phases 46-48.

</code_context>

<specifics>

## Specific Ideas

- Treat the G-code output evidence path as the generated-output analogue of
  the v1.11 project-file evidence ladder, but keep it summary-only.
- Use exact strings for deferred scope so reviewers can see that byte parity,
  broad generated-output parity, geometry, runtime/printer, GUI, release,
  network/device, profile auto-update, and sync behavior remain out of scope.

</specifics>

<deferred>

## Deferred Ideas

- Phase 46 owns fixture bytes, provenance, update rules, byte count, SHA-256,
  line-ending/encoding policy, and `expected-gcode-summary.tsv`.
- Phase 47 owns Rust G-code summary types, parser/summary logic, metadata, and
  Rust tests.
- Phase 48 owns executable parity, mutation guard, exact status publication,
  and public docs/status alignment.
- Broader byte-for-byte G-code parity, generated-output parity, geometry,
  extrusion, timing, support, seam, arc, STEP, GUI, runtime/printer behavior,
  release builds, network/device behavior, Bambu Studio, OrcaSlicer, and sync
  automation remain outside v1.12 Phase 45.

</deferred>

______________________________________________________________________

*Phase: 45-prusa-g-code-output-scope-gate*
*Context gathered: 2026-06-06*
