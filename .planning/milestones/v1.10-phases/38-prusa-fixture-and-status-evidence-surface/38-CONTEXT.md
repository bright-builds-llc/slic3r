---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 38-2026-06-01T00-33-46
generated_at: 2026-06-01T00:40:01.598Z
---

# Phase 38: Prusa Fixture and Status Evidence Surface - Context

**Gathered:** 2026-06-01
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 38 delivers the first real Prusa fixture/status evidence surface for the
v1.10 profile schema/config slice. It should create an inspectable Prusa fixture
namespace under `packages/parity-fixtures`, check in Prusa profile/config
fixtures traceable to the accepted Phase 37 source pin, define update and
provenance rules, and document the future status vocabulary that reserves
`verified` for the Phase 40 executable parity command.

This phase must not add Rust profile parsing, executable Prusa parity commands,
verified Prusa status rows, broader fork runtime support, upstream source-tree
imports, vendor sync automation, Bambu Studio fixtures, OrcaSlicer fixtures,
network/cloud/credential fixtures, non-free plugin fixtures, GUI support, or
fork release packaging.

</domain>

<decisions>
## Implementation Decisions

### Fixture Namespace and Shape

- **D-01:** Create the Phase 38 fixture namespace under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`.
- **D-02:** Use static checked-in Prusa vendor-bundle fixture files from the
  accepted source pin, including `PrusaResearch.ini` and the matching
  `PrusaResearch.idx`, instead of curated excerpts or derived parser
  expectation files.
- **D-03:** Keep these files as fixture inputs only. Export them through Bazel
  fixture targets or filegroups, but do not add `//packages/parity:*_parity`
  executable evidence in Phase 38.

### Fixture Provenance and Update Rules

- **D-04:** Add a fixture-local provenance/status manifest beside the fixture
  files. It must record `prusaslicer.profile-schema`, vendor id
  `prusaslicer`, accepted tag `version_2.9.5`, peeled commit
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`, source path
  `resources/profiles/PrusaResearch.ini`, and the Phase 37 checklist source.
- **D-05:** The manifest or README must state the fixture update route: update
  only after a reviewed intake change updates `packages/fork-vendors/forks.tsv`
  and the Prusa checklist/baseline gate. Branch-head observations remain
  drift-only.
- **D-06:** Add fail-closed verification that checks the fixture files,
  manifest source pin, source paths, boundary wording, and no Bambu Studio,
  OrcaSlicer, network, cloud, credential, or non-free plugin fixture namespace
  was introduced.
- **D-07:** Verification may check static fixture file presence and recorded
  provenance, but must not fetch upstream source, run profile auto-update,
  ingest plugins, or execute a Prusa parity command.

### Status Vocabulary and Non-Overclaiming

- **D-08:** Do not add a Prusa row to `packages/parity/status.tsv` in Phase 38.
  That file remains reserved for executable evidence rows.
- **D-09:** Update docs/status vocabulary to reserve the future token
  `fork.prusaslicer.profile-schema` for Phase 40 and state that it cannot be
  marked `verified` until a rerunnable `//packages/parity:*_parity` command
  exists.
- **D-10:** Port docs should make the distinction explicit: Phase 38 creates
  fixture/status preparation only; Phase 39 creates Rust parsing; Phase 40
  creates executable parity evidence and any verified status publication.

### Scope Boundaries

- **D-11:** Every new fixture README or manifest must explicitly exclude Bambu
  Studio, OrcaSlicer, network/device integration, cloud behavior, credentials,
  profile auto-update execution, non-free plugin ingestion, full Prusa runtime
  support, GUI support, sync automation, and fork release packaging.
- **D-12:** Phase 38 may reference the future Phase 40 evidence command shape
  as planned work, but must not create the command or imply support from
  source pins, fixtures, inventories, checklists, or flavor metadata alone.

### the agent's Discretion

- Exact fixture subdirectory names under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`,
  provided the raw vendor-bundle files and provenance manifest are easy to
  inspect.
- Exact manifest filename and format, provided it is grep-verifiable, readable,
  and stable enough for Phase 39/40 agents to consume.
- Whether the verifier is a standalone shell script in `packages/parity-fixtures`
  or package-local helpers plus Bazel targets, provided it is rerunnable and
  follows existing shell/Bazel patterns.
- Exact wording and placement of status vocabulary in docs, provided
  `packages/parity/status.tsv` does not gain a Prusa row in Phase 38.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 38 goal, dependency on Phase 37,
  EVID-01 through EVID-03 mapping, and success criteria.
- `.planning/REQUIREMENTS.md` - v1.10 evidence-surface requirements and
  milestone out-of-scope table.
- `.planning/STATE.md` - Current milestone state and recent v1.10 fork parity
  decisions.
- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md` -
  Locked Phase 37 baseline/checklist decisions and deferred Phase 38 fixture
  scope.
- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md` -
  Completed Phase 37 package files, verification commands, and non-overclaiming
  guardrails.

### Source Baseline and Checklist Inputs

- `packages/prusa-baseline/README.md` - Phase 37 Prusa baseline package
  boundary and source input routing.
- `packages/prusa-baseline/profile-schema-checklist.md` - Checklist gate for
  `prusaslicer.profile-schema`, planned fixture namespace, source path, source
  pin, and future evidence command shape.
- `packages/fork-vendors/forks.tsv` - Accepted PrusaSlicer source pin,
  selected stable tag, peeled commit, branch observation, SPDX/provenance, and
  caution fields.
- `packages/fork-inventories/prusaslicer.tsv` - Source-pinned Prusa inventory
  row for `prusaslicer.profile-schema`.
- `packages/fork-inventories/README.md` - Inventory TSV contract and
  planning-only scope.

### Fixture and Status Surfaces

- `packages/parity-fixtures/README.md` - Existing fixture package rules and
  future fork fixture namespace.
- `packages/parity-fixtures/BUILD.bazel` - Current fixture exports and
  filegroup patterns.
- `packages/parity/README.md` - Status-package rules that reserve future fork
  rows for executable parity targets.
- `packages/parity/status.tsv` - Checked-in parity status data source, which
  should not gain a Prusa row in Phase 38.
- `packages/parity/parity_status.sh` - Current status display command.
- `docs/port/README.md` - Port control-plane state and fork parity deferrals.
- `docs/port/package-map.md` - Package roles and discoverability for fixture,
  parity, Prusa baseline, vendor, and inventory packages.
- `docs/port/migration-guidance.md` - Future fork fixture namespace and status
  publication rules.
- `docs/port/parity-matrix.md` - Human-facing parity vocabulary and fork row
  guardrails.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity-fixtures` already owns the shared fixture package boundary,
  fixture provenance rules, Bazel exports, and future fork fixture namespace.
- `packages/parity` already owns the conservative status table and status
  command; its README says future fork rows are reserved for executable parity
  targets.
- `packages/prusa-baseline` provides the accepted Prusa source pin,
  `prusaslicer.profile-schema` checklist gate, and future fixture/parity command
  references.
- `packages/fork-vendors/forks.tsv` and
  `packages/fork-inventories/prusaslicer.tsv` are the authoritative source pin
  and inventory row inputs.

### Established Patterns

- Bazel package boundaries expose checked-in fixture/doc files through
  `exports_files`, aliases, and `filegroup` targets.
- Package-local shell verifiers use `set -euo pipefail`, exact text checks, and
  focused failure diagnostics.
- Fork source pins, inventories, templates, Prusa baseline records, flavor
  metadata, and fixtures are planning inputs until an executable parity command
  proves behavior.
- Docs route state through `docs/port/README.md`, `package-map.md`,
  `migration-guidance.md`, and `parity-matrix.md` rather than relying only on
  package-local READMEs.

### Integration Points

- Add files under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`.
- Extend `packages/parity-fixtures/BUILD.bazel` with explicit exports/filegroups
  for the Prusa fixture bundle and verifier target.
- Extend `packages/parity-fixtures/README.md` and relevant `docs/port/` files
  with Phase 38 fixture/update/status-vocabulary rules.
- Update `packages/parity/README.md` or docs as needed to reserve
  `fork.prusaslicer.profile-schema` without adding it to `status.tsv`.

</code_context>

<specifics>
## Specific Ideas

- The fixture source should be the accepted PrusaSlicer pin:
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- The source fixture path is `resources/profiles/PrusaResearch.ini`; include
  the matching `PrusaResearch.idx` when checking in the vendor-bundle fixture.
- The future status token should be `fork.prusaslicer.profile-schema`.
- The planned future evidence command may remain
  `bazel run //packages/parity:prusaslicer_profile_schema_parity`, but Phase 38
  must not add that command.

</specifics>

<deferred>
## Deferred Ideas

- Rust profile/config parsing and normalization logic is Phase 39 scope.
- Executable Prusa profile/config parity command, docs/status publication, and
  verified evidence are Phase 40 scope.
- Adding `fork.prusaslicer.profile-schema` to `packages/parity/status.tsv`
  remains deferred until the executable Phase 40 evidence command exists.
- Prusa project files, STEP import, support generation, arc fitting, wall seam
  behavior, network/device integration, profile auto-update execution, full fork
  runtime support, GUI support, fork release builds, Bambu Studio, OrcaSlicer,
  upstream source imports, and vendor sync automation remain deferred beyond
  this phase.

</deferred>

---

*Phase: 38-prusa-fixture-and-status-evidence-surface*
*Context gathered: 2026-06-01*
