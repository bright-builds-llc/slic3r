# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

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
| v1.1 | 1 | 3 | Expanded the verified CLI slice set from `--version` to help/version/config persistence |
| v1.0 | 1 | 8 | Established the full Bazel/Rust/legacy/parity migration control plane |

### Cumulative Quality

| Milestone | Tests | Coverage | Zero-Dep Additions |
|-----------|-------|----------|-------------------|
| v1.1 | Verified fixture parity for help/version/config persistence | milestone-scoped | kept fixture verification command-per-slice |
| v1.0 | Verified fixture parity for `cli.version` plus package verification surfaces | milestone-scoped | kept new runtime dependencies minimal |

### Top Lessons (Verified Across Milestones)

1. Shared parity fixtures should arrive as soon as a supported Rust-backed slice exists.
1. Migration docs and executable package boundaries need to move together.
