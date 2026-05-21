# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.6 — Windows Parity Foundation

**Shipped:** 2026-05-21\
**Phases:** 3 | **Plans:** 7 | **Sessions:** 1 focused milestone run plus
closeout UAT and security passes

### What Was Built

- A preferred Windows launcher/runtime target and Bazel smoke surface for the
  existing verified Rust-backed slice
- A shared Windows runtime parity command and Windows runtime fixture bundle
- Windows validation state published in the checked-in parity status source and
  the migration docs
- Archived v1.6 phase history and milestone requirements for the next
  milestone boundary

### What Worked

- Reusing the existing verified help/version/config/export/transform fixtures
  kept Windows runtime parity narrow and easy to defend.
- Splitting Windows runtime delivery, shared evidence, and visibility
  publication across three phases kept each phase independently reviewable.

### What Was Inefficient

- The milestone-completion helper still produced a skeletal milestone entry and
  left live planning files needing manual cleanup for `PROJECT.md`,
  `ROADMAP.md`, `STATE.md`, and `MILESTONES.md`.
- Automated accomplishment extraction for milestone summaries still collapsed
  to placeholder `Plan XX-YY:` lines instead of the real one-liners from the
  summary bodies.

### Patterns Established

- New platform work can reuse the Linux-to-Windows ladder directly:
  launcher/runtime path first, shared parity evidence second, visibility
  publication third.
- Publishing validation state deserves a dedicated closeout phase even when the
  underlying runtime evidence already exists.

### Key Lessons

1. Once the parity surface is bounded and backed by shared evidence, expanding
   to the next platform is much cheaper than the first platform foundation.
1. Milestone closeout needs its own verification passes for docs, UAT, and
   security so archival reflects the real shipped surface rather than just the
   implementation commits.

### Cost Observations

- Model mix: Codex-led execution with shared parity evidence reusing the
  retained legacy oracle only where needed
- Sessions: 1 focused milestone run with later closeout UAT and security gates
- Notable: Windows runtime parity was cheaper than Linux because the fixture
  and documentation pattern already existed

______________________________________________________________________

## Milestone: v1.4 — Linux Parity Foundation

**Shipped:** 2026-04-11\
**Phases:** 3 | **Plans:** 7 | **Sessions:** 1 focused milestone run

### What Was Built

- A preferred Linux launcher/runtime shim and Bazel smoke surface for the
  existing verified Rust-backed slice
- A shared Linux runtime parity command and Linux runtime fixture bundle
- Linux validation state published in the checked-in parity status source and
  the migration docs
- Archived v1.4 phase history, requirements, and audit artifacts for the next
  milestone boundary

### What Worked

- Reusing the already verified help/version/config/export/transform fixtures
  kept Linux parity work narrow and easy to verify.
- Splitting Linux runtime delivery, shared evidence, and visibility
  publication across three phases kept each phase independently defensible.

### What Was Inefficient

- The milestone-completion helper still left live planning files in a
  half-archived state and needed manual cleanup for `PROJECT.md`, `ROADMAP.md`,
  `STATE.md`, and `MILESTONES.md`.
- Bazel output-base lock contention is still easy to trigger when several
  run/test commands are started too aggressively in parallel.

### Patterns Established

- New platform work should follow the same ladder: launcher/runtime path first,
  shared parity evidence second, visibility publication third.
- Shared parity evidence can reuse existing slice fixtures when the expected
  outputs are platform-agnostic.

### Key Lessons

1. Platform expansion is much easier when the parity surface is already shaped
   around explicit shared evidence commands rather than ad hoc checks.
1. Publishing validation state deserves its own milestone phase; otherwise the
   status/docs layer lags behind the real evidence and weakens trust.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still kept in
  reserve rather than on the critical path
- Sessions: 1 focused milestone run with no follow-up gap phase required
- Notable: Linux runtime parity was materially cheaper than the first packaging
  milestone because it reused the existing slice boundaries and fixtures

## Milestone: v1.3 — Packaging-Visible Parity

**Shipped:** 2026-04-11\
**Phases:** 3 | **Plans:** 6 | **Sessions:** 1 milestone completion cycle with 1 audit-driven gap-closure phase

### What Was Built

- A scoped macOS packaged launcher bundle and startup shim for the verified
  Rust-backed slice
- Shared packaged parity evidence for bundle layout, startup handoff, packaged
  `--help`, packaged `--version`, and representative config persistence
- Aligned packaged launcher docs, notes, and parity status for the exact
  packaged evidence surface
- Archived v1.3 phase history, requirements, and audit artifacts for the next
  milestone boundary

### What Worked

- Treating the packaged launcher surface as its own parity slice kept the
  packaging work verifiable instead of vague.
- Using one representative packaged config-persistence path was enough to prove
  the packaged startup shim does real bounded work without overclaiming every
  packaged subflow.

### What Was Inefficient

- The milestone-completion helper still leaves live planning files in a
  half-archived state and needs manual cleanup for `PROJECT.md`, `ROADMAP.md`,
  `STATE.md`, and the milestone summary entry.
- The strict lifecycle hardening caught Phase 20 correctly, but only after a
  fallback-planned attempt had already been committed, which created avoidable
  rework.

### Patterns Established

- Packaged parity should verify one real packaged workflow beyond `--help` and
  `--version`, not just bundle layout.
- Packaged-scope notes should describe only what the shared packaged evidence
  command actually proves; broader slice ownership belongs elsewhere.

### Key Lessons

1. A packaged parity command is only trustworthy when it exercises the packaged
   startup shim through at least one representative stateful workflow.
1. Lifecycle provenance is now a real execution gate; fallback planning must be
   corrected before execution instead of papered over during wrap-up.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still doing
  the slowest parity confirmation work
- Sessions: 1 milestone completion cycle with 1 formal gap-closure phase
- Notable: the packaging work stayed manageable because the evidence surface
  was kept narrow and reused the existing CLI parity slice

## Milestone: v1.2 — Export and Transform Parity

**Shipped:** 2026-04-11\
**Phases:** 6 | **Plans:** 14 | **Sessions:** 1 milestone completion cycle with follow-up gap-closure passes

### What Was Built

- Rust-backed export workflows for G-code, STL, OBJ, AMF, 3MF, layered SVG,
  and explicit `--export-sla-svg`
- Rust-backed non-slicing `--info`, `--repair`, and `--split` behavior
- Shared fixture comparison commands for export and transform workflows
- Full fixture coverage for the explicit SLA SVG alias and the documented
  `--info` input matrix
- `requirements-completed` summary metadata and control-plane doc alignment for
  stronger milestone audits

### What Worked

- Keeping the implementation surface scoped and the verification surface
  explicit made it possible to expand parity without losing traceability.
- Phase-specific gap-closure passes worked well for converting audit findings
  into deterministic cleanup work instead of letting docs/process debt linger.

### What Was Inefficient

- The milestone-completion helper still required substantial manual cleanup for
  `PROJECT.md`, `ROADMAP.md`, `RETROSPECTIVE.md`, and the new milestone entry.
- `mdformat` is unsafe for phase `*-SUMMARY.md` files in this repo because it
  can flatten YAML frontmatter that the audit tooling depends on.

### Patterns Established

- Verify export and transform surfaces with dedicated parity commands backed by
  fixture corpora that map directly to the supported slice.
- Carry `requirements-completed` metadata in summary frontmatter so milestone
  audits can cross-check claims against phase outputs.
- Treat the `docs/port/` overview files as part of parity completion, not as
  optional polish after the behavior is already verified.

### Key Lessons

1. A parity row is not truly done until the overview docs and status surfaces
   say the same thing as the fixture commands.
1. Audit-trail metadata needs to be treated like product state: if the field is
   mandatory for tooling, it must be preserved explicitly and not handed to
   a formatter blindly.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still doing
  the slowest work
- Sessions: 1 milestone completion cycle with 2 follow-up gap-closure passes
- Notable: the legacy oracle rebuild remains expensive, but the parity commands
  stay understandable because each verified surface maps to one explicit
  evidence command

## Milestone: v1.1 — CLI Parity Expansion

**Shipped:** 2026-04-08\
**Phases:** 3 | **Plans:** 8 | **Sessions:** 1 milestone expansion run

### What Was Built

- Rust-backed help and usage support through the preferred launcher path
- Rust-backed scoped config persistence for save/load/datadir
- Shared fixture comparison commands for help, version, and config persistence
- Verified parity visibility for the supported CLI slice set

### What Worked

- Continuing from the narrow `--version` slice kept the next milestone focused
  and easy to verify.
- Separate comparison commands per supported slice made the verified status
  table concrete and reviewable.

### What Was Inefficient

- The retained legacy oracle rebuild still dominates fixture comparison runtime,
  even when only one supported slice is being verified.
- The GSD roadmap metadata still underreports `roadmap_complete` even when the
  milestone is actually complete.

### Patterns Established

- Verify each supported CLI slice with its own comparison command and fixture
  corpus.
- Promote a slice from `rust-backed` to `verified` only after the corresponding
  comparison command passes and the status surface is updated in the same change.

### Key Lessons

1. Help and config persistence are the right kinds of next-step CLI slices after
   `--version`: small enough to verify, but still representative of real
   contract expansion.
1. Checked-in parity status is most trustworthy when every verified row points
   at exactly one evidence command.

### Cost Observations

- Model mix: Codex-led execution with the legacy oracle still doing the slowest
  work
- Sessions: 1 focused follow-up milestone run
- Notable: the fixture corpus stayed small, but the oracle build cost is still
  the pacing factor

______________________________________________________________________

## Milestone: v1.0 — Rust Port Foundations

**Shipped:** 2026-04-08\
**Phases:** 8 | **Plans:** 22 | **Sessions:** 1 major milestone run

### What Was Built

- Bazel monorepo scaffolding with retained legacy and new Rust packages
- A buildable and testable macOS legacy oracle preserved behind Bazel
- Contract inventory, migration guidance, parity visibility, and fixture workflow docs
- The first supported Rust-backed CLI slice for `--version`
- A shared fixture comparison harness that verifies `cli.version`

### What Worked

- Narrowing the first supported Rust-backed slice to `--version` kept parity
  claims honest and verifiable.
- Bazel package boundaries made it straightforward to expose launcher, parity,
  and fixture ownership without rewriting the whole legacy surface.

### What Was Inefficient

- The autonomous/yolo wrapper path degraded into nested workflow overhead and
  did not reliably carry the formal discuss/plan lifecycle for phases 5-8.
- The built-in milestone archival helper only handled the mechanical archive
  steps; the higher-signal roadmap and project evolution still needed manual
  cleanup.

### Patterns Established

- Preserve the legacy implementation as a narrow, explicit oracle instead of
  overclaiming test coverage.
- Treat shared parity fixtures and checked-in status data as first-class package
  surfaces, not ad hoc docs-only state.

### Key Lessons

1. Keep the first parity slice extremely small when introducing a new runtime
   path; verifiability matters more than surface area early on.
1. Autonomous workflows need explicit provenance and watchdogs if they are going
   to claim a guaranteed discuss -> plan -> execute lifecycle.

### Cost Observations

- Model mix: dominated by Codex interactive execution in one repo-bound session
- Sessions: 1 sustained milestone completion run
- Notable: the retained legacy oracle rebuild remains the slowest verification
  surface and should stay scoped tightly

______________________________________________________________________

## Cross-Milestone Trends

### Process Evolution

| Milestone | Sessions | Phases | Key Change |
|-----------|----------|--------|------------|
| v1.4 | 1 | 3 | Expanded verified parity from macOS-only runtime/package surfaces into a verified Linux runtime slice with a dedicated Linux evidence command |
| v1.3 | 1 | 3 | Extended verified parity into packaging-visible launcher behavior and hardened the packaged evidence surface with a representative config-persistence proof |
| v1.2 | 1 | 6 | Expanded verified parity from help/config into export and transform slices, then hardened fixture coverage and audit metadata |
| v1.1 | 1 | 3 | Expanded the verified CLI slice set from `--version` to help/version/config persistence |
| v1.0 | 1 | 8 | Established the full Bazel/Rust/legacy/parity migration control plane |

### Cumulative Quality

| Milestone | Tests | Coverage | Zero-Dep Additions |
|-----------|-------|----------|-------------------|
| v1.4 | Verified Linux launcher runtime parity for representative help/version/config/export/transform flows | milestone-scoped | reused the existing slice fixtures instead of cloning a second platform-specific corpus |
| v1.3 | Verified packaged launcher parity for bundle layout, startup handoff, packaged help/version, and representative config persistence | milestone-scoped | reused the existing bundled Rust CLI slice instead of broadening packaged scope prematurely |
| v1.2 | Verified fixture parity for export and transform workflows plus summary metadata auditability | milestone-scoped | kept parity command-per-slice-family and added summary requirement metadata |
| v1.1 | Verified fixture parity for help/version/config persistence | milestone-scoped | kept fixture verification command-per-slice |
| v1.0 | Verified fixture parity for `cli.version` plus package verification surfaces | milestone-scoped | kept new runtime dependencies minimal |

### Top Lessons (Verified Across Milestones)

1. Shared parity fixtures should arrive as soon as a supported Rust-backed slice exists.
1. Migration docs and executable package boundaries need to move together.
1. Milestone audit metadata should be treated as a first-class artifact, not post-hoc prose.
