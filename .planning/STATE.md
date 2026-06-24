---
gsd_state_version: 1.0
milestone: v1.15
milestone_name: milestone
status: executing
stopped_at: Completed 60-03-PLAN.md
last_updated: "2026-06-24T16:32:00.953Z"
last_activity: 2026-06-24
progress:
  total_phases: 4
  completed_phases: 3
  total_plans: 13
  completed_plans: 10
  percent: 77
---

# Project State

## Project Reference

See: `.planning/PROJECT.md` (updated 2026-06-23)

**Core value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

**Current focus:** Phase 60 — Executable Arc-Fitting Evidence

## Current Position

Phase: 60 (Executable Arc-Fitting Evidence) — EXECUTING
Plan: 4 of 6
Milestone: v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice
Status: Ready to execute
Last activity: 2026-06-24

Progress: [████████░░] 77%

## Performance Metrics

**Latest milestone baseline:**

- v1.15 maps 12 requirements across 4 planned phases: scope contract, fixture
  corpus, Rust arc-fitting evidence boundary, and executable arc-fitting
  evidence.

- Granularity is `fine`; the natural four-phase evidence ladder is preserved
  because it matches the requirement categories and existing v1.12-v1.14
  delivery boundary.

- v1.15 keeps broad `generated-outputs`, byte-for-byte G-code parity,
  printability, printer-runtime behavior, GUI behavior, non-Prusa fork
  behavior, release behavior, upstream import, and sync behavior deferred.

- v1.14 archived on 2026-06-22 with 4 phases, 11 plans, 22 tasks, 12 mapped
  requirements, and a passed milestone audit.

**Recent execution:**

- 60-01 completed in 7 min with 2 tasks and 4 implementation files changed.
- 60-02 completed in 4 min with 2 tasks and 2 implementation files changed.
- 60-03 completed in 8 min with 2 tasks and 5 implementation files changed.

## Accumulated Context

### Decisions

Decisions are logged in `PROJECT.md` Key Decisions table.

Recent decisions affecting v1.15:

- Continue phase numbering from Phase 57 because v1.14 ended at Phase 56.
- Use arc fitting as the next Prusa generated-output feature slice because it
  is a medium-complexity candidate that can reuse the v1.12-v1.14 G-code
  evidence ladder.

- Keep broad `generated-outputs`, byte-for-byte G-code parity, printability,
  printer-runtime behavior, GUI behavior, support generation, wall seam
  behavior, STEP import, non-Prusa fork behavior, release behavior, upstream
  imports, and sync automation deferred.

- Run milestone research before finalizing requirements because v1.15 opens a
  new generated-output feature slice.

- Map ARCSCOPE-01..03 to Phase 57, ARCFIX-01..03 to Phase 58,
  ARCRUST-01..03 to Phase 59, and ARCEV-01..03 to Phase 60.

- Preserve the four-step evidence ladder for v1.15: scope contract, fixture
  corpus, Rust boundary, executable evidence/status/docs.

- Keep the arc-fitting slice narrow and separate from broad
  `generated-outputs` and the existing `fork.prusaslicer.gcode-output` row.

Recent decisions affecting v1.14:

- Continue phase numbering from Phase 53 because v1.13 ended at Phase 52.
- Deepen the existing Prusa G-code evidence path semantically before planning
  support, seam, arc, broad generated-output, or non-Prusa fork milestones.

- Skip external ecosystem research for v1.14 because the milestone is an
  internal evidence-contract expansion over existing repo artifacts.

- Map v1.14 to the established evidence ladder: scope contract, fixture
  corpus, Rust boundary, executable evidence/status/docs.

Recent decisions affecting v1.13:

- Continue phase numbering from Phase 49 because v1.12 ended at Phase 48.
- Expand Prusa G-code evidence structurally before broad generated-output,
  byte-for-byte, geometry, runtime, support, seam, or arc parity is claimed.

- Keep broad `generated-outputs` in progress and active downstream-fork port
  planning limited to PrusaSlicer.

- Skip external ecosystem research for v1.13 because the milestone is an
  internal evidence-contract expansion over existing repo artifacts.

Recent decisions affecting v1.12:

- Continue phase numbering from Phase 45 because v1.11 ended at Phase 44.
- Use the four-step evidence ladder: scope gate, fixture surface, Rust summary
  boundary, executable evidence.

- Keep v1.12 summary-only and narrow; do not claim byte-for-byte G-code,
  broad generated-output, runtime/printer, geometry, support, seam, arc, STEP,
  desktop app, release, network, or sync parity.

- Keep broad `generated-outputs` in progress; only the exact
  `fork.prusaslicer.gcode-output` row may be planned after executable evidence.

- [Phase 45-prusa-g-code-output-scope-gate]: Kept prusaslicer.gcode-output as source-observed planning metadata only, not executable parity evidence.
- [Phase 45-prusa-g-code-output-scope-gate]: Mapped the row under gcode-output, shared-downstream, and future-candidate without adding Bambu Studio or OrcaSlicer claims.
- [Phase 45-prusa-g-code-output-scope-gate]: Left packages/parity/status.tsv unchanged so fork.prusaslicer.gcode-output remains unpublished before executable evidence.
- [Phase 45-prusa-g-code-output-scope-gate]: Kept packages/prusa-gcode-output-scope metadata-only while naming Phase 46-48 handoff paths and labels without creating fixture, expected summary, Rust implementation, parity target, or status row.
- [Phase 45-prusa-g-code-output-scope-gate]: Made the Prusa G-code scope verifier fail closed on exact scope, inventory, category, overclaim, and absence-boundary drift.
- [Phase 45-prusa-g-code-output-scope-gate]: Used isolated temp checkout roots in mutation tests so negative fixture, status, and expected-summary cases are proven without creating forbidden repo artifacts.
- [Phase 45-prusa-g-code-output-scope-gate]: Made the Phase 45 G-code output scope gate discoverable from port docs while preserving the no-evidence boundary.
- [Phase 45-prusa-g-code-output-scope-gate]: Kept `generated-outputs` in progress and left `fork.prusaslicer.gcode-output` unpublished until Phase 48 executable evidence.
- [Phase 45-prusa-g-code-output-scope-gate]: Documented Phase 46-48 handoff names as planned text only: fixture namespace, Rust boundary, parity command, and status token.
- [Phase 46-prusa-g-code-fixture-surface]: Used the accepted PrusaSlicer set_speed expected-output literals because the accepted upstream tree has no checked-in .gcode blob.
- [Phase 46-prusa-g-code-fixture-surface]: Kept byte count, SHA-256, upstream URL, and update-route facts in provenance rather than the expected summary.
- [Phase 46-prusa-g-code-fixture-surface]: Kept the expected artifact to the exact Phase 45 seven-column metadata and marker schema with no broad G-code parity claims.
- [Phase 46-prusa-g-code-fixture-surface]: Kept G-code fixture verification as local Bash exact checks instead of adding a parser or generator framework.
- [Phase 46-prusa-g-code-fixture-surface]: Used self-scan-safe split literals so the verifier rejects Git/network/generation/host-upload behavior without matching its own forbidden-term list.
- [Phase 46-prusa-g-code-fixture-surface]: Allowed only the Phase 46 fixture namespace and expected-summary artifact in the Phase 45 scope verifier while keeping status, parity, and Rust summary artifacts absent.
- [Phase 46-prusa-g-code-fixture-surface]: Published the Phase 46 fixture surface through package and port docs without adding a Phase 47 Rust summary boundary, Phase 48 parity command, or status row.
- [Phase 46-prusa-g-code-fixture-surface]: Kept fork.prusaslicer.gcode-output absent from packages/parity/status.tsv while documenting the reserved Phase 48 command and publication gate.
- [Phase 46-prusa-g-code-fixture-surface]: Recorded the final validation task as an empty test(46-03) commit because the task was verification-only and produced no file changes.
- [Phase 49]: Kept the v1.13 structural contract inside the existing prusa-gcode-output-scope package.
- [Phase 49]: Used a closed sixteen-row Markdown field table as the inspectable source for Phase 50 and Phase 51.
- [Phase 49]: Kept broad generated-outputs in progress and deferred verifier enforcement to 49-02 as planned.
- [Phase 49]: Kept structural enforcement in the existing prusa-gcode-output-scope verifier package. — This preserves the Phase 45-49 reviewed evidence chain and avoids creating a new package boundary.
- [Phase 49]: Enforced the structural field table with exact required rows plus an exact sixteen-row body count. — This makes unsupported structural fields fail closed instead of passing through presence-only checks.
- [Phase 49]: Kept generated-outputs fail-closed as exactly one in-progress status row while preserving the narrow verified fork row. — This completes GCSCOPE-03 without promoting broad generated-output parity.
- [Phase 52-01]: Extended the existing G-code summary binary with explicit --structural mode instead of adding a second binary.
- [Phase 52-01]: Kept structural CLI behavior limited to caller-supplied local file reads through the Rust parser boundary.
- [Phase 52-02]: Kept the existing public Prusa G-code parity target while adding structural sidecar validation.
- [Phase 52-02]: Used the existing Rust summary binary's --structural mode for public structural validation instead of adding a new comparator binary.
- [Phase 52-02]: Added exactly one command-level structural mutation guard for command_count_g1 drift.
- [Phase 52-03]: Published the existing `fork.prusaslicer.gcode-output` row as narrow structural evidence without changing its status token or public parity command.
- [Phase 52-03]: Kept the broad `generated-outputs` row exactly `in progress`.
- [Phase 52-03]: Preserved the verifier's split literal around `host upload` so forbidden-term self-scanning remains fail-closed.
- [Phase 52]: Kept Phase 52 scope publication inside the existing prusa-gcode-output-scope package instead of adding a new scope boundary.
- [Phase 52]: Used the exact Plan 52-03 structural status row text as the verifier contract.
- [Phase 52]: Preserved generated-outputs as exactly one in-progress row.
- [Phase 52]: Kept the public fork.prusaslicer.gcode-output status token and public Prusa G-code parity command unchanged while updating package docs to structural evidence wording.
- [Phase 52]: Documented Rust summary and --structural modes as caller-supplied checked-in TSV parsing only.
- [Phase 52]: Preserved fixture provenance values and deferred generated-output/runtime/fork boundaries.
- [Phase 52-06]: Published fork.prusaslicer.gcode-output in public port docs as narrow structural evidence only, not broad generated-output parity.
- [Phase 52-06]: Kept the Phase 49 -> Phase 50 -> Phase 51 -> Phase 52 evidence chain explicit across parity matrix, migration guidance, README, and package map docs.
- [Phase 52-06]: Preserved the broad generated-outputs status as in progress and kept all D-11 deferred generated-output, runtime, fork, upstream import, release, and sync surfaces explicit.
- [Phase 53]: Kept the v1.14 semantic contract inside the existing prusa-gcode-output-scope package.
- [Phase 53]: Used a closed nine-row Markdown field table as the inspectable source for Phase 54 and Phase 55.
- [Phase 53]: Kept generated-outputs in progress and recorded planned semantic artifacts as planned text only.
- [Phase 53]: Kept semantic enforcement in the existing prusa-gcode-output-scope verifier package.
- [Phase 53]: Enforced the semantic field table with exact required rows plus an exact nine-row body count.
- [Phase 53]: Preserved generated-outputs as exactly one in-progress row and left public status/docs untouched.
- [Phase 55]: Extended the existing prusa_gcode_output Rust module with semantic parsing instead of adding a new crate, binary mode, or public parity command.
- [Phase 55]: Validated exact semantic rows, values, source/fixture identity, order, and evidence-boundary text before exposing typed facts.
- [Phase 55]: Kept public status/docs, parity targets, generator behavior, Git/network/process access, and binary semantic mode untouched for Phase 56.
- [Phase 55]: Exposed semantic readiness as static slic3r_flavors metadata instead of adding a public command, file discovery, generator, status mutation, or docs publication.
- [Phase 55]: Kept the prusaslicer.gcode-output registry row as FutureCandidate with generated_outputs dependency while updating only the developer-facing note.
- [Phase 55]: Proved status restraint with exact shell checks for generated-outputs and fork.prusaslicer.gcode-output rows instead of embedding status.tsv into Rust tests.
- [Phase 56]: Extended the existing public Prusa G-code parity Bazel target instead of adding a companion semantic command.
- [Phase 56]: Kept semantic validation inside the Rust slic3r_flavors boundary and used Bash only for orchestration, diffs, and fact assertions.
- [Phase 56]: Printed only narrow semantic evidence facts and kept broad generated-output, byte parity, printability, runtime, support, seam, arc, GUI, release, sync, and non-Prusa behavior out of achieved output wording.
- [Phase 56]: Kept semantic drift coverage inside the existing public parity failure test instead of adding a companion target.
- [Phase 56]: Mutated only temp copies of expected-gcode-semantic-summary.tsv and asserted field-specific diagnostics.
- [Phase 56]: Used the existing Rust-backed comparator as the failure authority instead of parsing semantic validity in Bash.
- [Phase 56]: Published the existing fork.prusaslicer.gcode-output row as narrow semantic evidence without changing its status token or public parity target.
- [Phase 56]: Kept generated-outputs exactly one in-progress row.
- [Phase 56]: Used one exact semantic status row across status.tsv, fixture verifier enforcement, scope verifier enforcement, and mutation tests.
- [Phase 56]: Kept verifier self-scan literals split where needed while preserving their runtime text.
- [Phase 56]: Published package, fixture, and scope docs against the existing public Prusa G-code parity command instead of adding a companion docs surface.
- [Phase 56]: Kept Phase 54 fixture provenance and semantic TSV values unchanged while documenting Phase 56 consumption.
- [Phase 56]: Updated verifier exact-text contracts when stale planned wording blocked the required package and scope verification.
- [Phase 56]: Published public port docs against the existing public Prusa G-code parity command instead of adding a companion docs surface.
- [Phase 56]: Kept broad generated-outputs in progress across public docs while publishing only the narrow semantic Prusa G-code evidence slice.
- [Phase 56]: Kept Phase 49 through Phase 52 as historical structural rungs only; the current published state now uses the Phase 53 through Phase 56 semantic chain.
- [Phase 60-01]: Added a new arc-specific Rust summary binary instead of widening the existing Prusa G-code output summary binary.
- [Phase 60-01]: Kept public arc-fitting validation inside the Rust slic3r_flavors boundary and used Bash only for runfile orchestration, diffs, field assertions, and approved output text.
- [Phase 60-01]: Published a separate public arc-fitting parity command while preserving the existing Prusa G-code output parity contract.
- [Phase 60-02]: Kept ARCEV-02 drift coverage in a dedicated public Bazel sh_test target beside the existing Prusa parity failure tests.
- [Phase 60-02]: Mutated only temp copies of expected-arc-summary.tsv and preserved that basename for public comparator diagnostics.
- [Phase 60-02]: Used the public Rust-backed comparator as the failure authority instead of reimplementing arc summary validation in Bash.
- [Phase 60-03]: Published `fork.prusaslicer.arc-fitting` as a separate narrow status row instead of widening `fork.prusaslicer.gcode-output`. — Keeps arc-fitting evidence separate from the existing semantic Prusa G-code output contract.
- [Phase 60-03]: Kept `generated-outputs` exactly one `in progress` row while publishing the arc-fitting feature slice. — One feature-specific evidence slice is not broad generated-output parity.
- [Phase 60-03]: Used exact status-row constants in both fixture and scope verifiers so public row drift fails locally. — Exact verifier contracts make missing rows, wrong targets, duplicate rows, and widened wording observable before docs publication.
- [Phase 60-03]: Covered status publication drift with isolated temp status fixtures in both verifier mutation suites. — Temp fixtures prove fail-closed behavior without mutating checked-in status artifacts.

### Pending Todos

None.

### Blockers/Concerns

None.

## Session Continuity

Last session: 2026-06-24T16:31:21.213Z
Stopped at: Completed 60-03-PLAN.md
Resume file: None
