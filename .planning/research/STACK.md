# v1.11 Stack Research: PrusaSlicer Broader Parity Port

**Project:** Slic3r Rust Port
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Researched:** 2026-06-02
**Confidence:** High for repo-local stack choices; medium for exact future
project-file fixture shape until Phase 41 selects the checked-in artifact.

## Recommendation

Stay on the existing Bazel, shell-verifier, and Rust workspace stack. Do not
add a 3MF/ZIP/XML dependency during milestone setup. Let Phase 41 choose a
narrow Prusa project-file evidence contract first, then add only the smallest
parser or summary dependency justified by that contract during implementation.

The current repo already has the right primitives:

- `packages/fork-inventories/prusaslicer.tsv` identifies
  `prusaslicer.project-file` as a medium-complexity, shared-downstream,
  file-format candidate.
- `packages/slic3r-rust/crates/slic3r_flavors` already carries Prusa
  capability metadata.
- `packages/parity-fixtures/forks/prusaslicer/` already provides the namespace
  pattern for source-pinned Prusa fixture evidence.
- `packages/parity` already owns public `*_parity` commands and exact status
  rows.
- `packages/prusa-baseline` owns the reviewed Prusa source baseline and
  checklist gate pattern.

## Existing Stack To Reuse

| Area | Current tool | v1.11 use |
|------|--------------|-----------|
| Build orchestration | Bazel/Bzlmod | Add fixture and parity targets under existing packages. |
| Rust toolchain | Rust 1.94.1, edition 2024 | Add typed project-file summary logic only after the Phase 41 contract is explicit. |
| Rust crate boundary | `slic3r_flavors` | Extend shared fork/flavor evidence boundaries without creating a Prusa-only Rust workspace. |
| Contracts | `slic3r_contracts` | Reuse typed fork/flavor/source/status vocabulary. |
| Fixtures | `packages/parity-fixtures` | Add a Prusa project-file namespace with provenance and expected artifacts. |
| Public evidence | `packages/parity` | Add one fail-closed project-file parity command and status row. |
| Docs | `docs/port/*` | Publish exact verified scope and remaining deferrals. |

## Dependency Guidance

Use standard library Rust for metadata summaries and line-oriented fixture
checks when possible. If Phase 41 chooses a real `.3mf` container fixture that
requires ZIP/XML inspection, the implementation plan should explicitly justify
the dependency, pin it, and add tests that prove malformed fixture handling
fails visibly.

Do not add these by default:

- Git submodules, Git subtree imports, or Bzlmod external repos for upstream
  Prusa source.
- A Prusa-only Rust workspace or copied upstream C++ implementation.
- Network fetches, profile auto-update execution, or source sync automation.
- Full PrusaSlicer GUI/runtime build integration.

## Verification Stack

v1.11 should keep the v1.10 proof chain:

1. Source-pinned fixture provenance.
1. Static fixture verifier with negative checks.
1. Typed Rust summary/parser tests.
1. Public Bazel parity command.
1. Mutation or expected-artifact divergence guard.
1. Exact `packages/parity/status.tsv` row.
1. Port docs that name the verified slice and deferred surfaces.
