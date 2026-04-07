# Roadmap: Slic3r Rust Port

## Overview

This roadmap modernizes Slic3r through a phased brownfield migration rather than a rewrite-in-place. The work starts by giving the repository a Bazel-driven monorepo shape, preserving the legacy codebase as a buildable parity oracle, and making migration status visible through docs and parity tooling. Once that foundation exists, the roadmap introduces a Bright Builds-compliant Rust workspace, carves out contract-oriented modules, replaces the active Perl launcher path for scoped workflows, and then hardens the port with fixture-based legacy-vs-Rust comparisons on macOS before expanding to later surfaces.

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Foundation** - Establish the Bazel monorepo shape, package boundaries, and initial migration docs
- [ ] **Phase 2: Legacy Oracle** - Make the retained legacy package buildable and testable through Bazel on macOS
- [ ] **Phase 3: Rust Workspace** - Stand up the Bright Builds-compliant Rust workspace and Bazel-driven Rust verification on macOS
- [ ] **Phase 4: Contract Inventory** - Define the parity contract inventory and migration guidance that drives the port
- [ ] **Phase 5: Entry Surface Architecture** - Carve contract-oriented Rust modules and define the launcher replacement boundaries
- [ ] **Phase 6: macOS CLI Parity Slice** - Deliver the first preferred Rust-backed CLI workflow on macOS
- [ ] **Phase 7: Parity Visibility** - Add parity status reporting, fixture update discipline, and migration-progress visibility
- [ ] **Phase 8: Differential Parity Harness** - Compare legacy and Rust behavior on a shared fixture corpus for the first scoped workflows

## Phase Details

### Phase 1: Foundation

**Goal**: Establish the Bazel root, `packages/` monorepo layout, and migration docs/checklists so the repository has one coherent modernization surface.
**Depends on**: Nothing (first phase)
**Requirements**: MONO-01, MONO-02, DOCS-01, DOCS-02
**Success Criteria** (what must be TRUE):

1. Maintainer can invoke a top-level Bazel build/test entrypoint on macOS for the repo scaffold.
1. Contributor can see a `packages/`-based repository layout that clearly separates legacy, Rust, launcher, parity, and supporting concerns.
1. Migration progress docs and checklists exist under `docs/` and are part of the expected review surface for Rust-port changes.

**Plans**: 3 plans

Plans:

- [x] 01-01: Create Bazel root files, repo conventions, and initial package scaffolding
- [ ] 01-02: Move or mirror the current source tree into a retained legacy package without changing legacy behavior
- [ ] 01-03: Seed `docs/port/` with migration overview, checklist, and review-process docs

### Phase 2: Legacy Oracle

**Goal**: Keep the legacy implementation buildable, testable, and visibly reference-only under the new Bazel monorepo shape.
**Depends on**: Phase 1
**Requirements**: MONO-03, LEGA-01, LEGA-02, LEGA-03
**Success Criteria** (what must be TRUE):

1. Maintainer can build the retained legacy package from Bazel on macOS.
1. Maintainer can run the retained legacy verification surfaces from Bazel so the old implementation remains the parity oracle.
1. Contributors can tell from the repo layout and docs that the legacy package is preserved for reference, not preferred for new feature work.

**Plans**: 3 plans

Plans:

- [ ] 02-01: Wrap the legacy build surfaces in Bazel targets
- [ ] 02-02: Wrap the legacy test surfaces in Bazel targets
- [ ] 02-03: Mark and document the legacy package as reference-only

### Phase 3: Rust Workspace

**Goal**: Stand up the Rust workspace, toolchain, and verification path under Bazel with Bright Builds-aligned structure and practices.
**Depends on**: Phase 2
**Requirements**: RUST-01, RUST-02
**Success Criteria** (what must be TRUE):

1. Maintainer can build the new Rust package from Bazel on macOS.
1. Maintainer can run Rust formatting, linting, tests, and package-local verification through the Bazel-driven workflow.
1. Contributors can see a Bright Builds-compliant Rust package structure instead of an ad hoc rewrite sandbox.

**Plans**: 3 plans

Plans:

- [ ] 03-01: Initialize the Rust workspace and Bazel Rust toolchain integration
- [ ] 03-02: Add Rust verification targets for fmt, clippy, and tests
- [ ] 03-03: Align the Rust package layout with Bright Builds conventions and repo docs

### Phase 4: Contract Inventory

**Goal**: Define the exact parity surfaces and migration guidance so implementation work is driven by contracts instead of assumptions.
**Depends on**: Phase 3
**Requirements**: PARI-01, DOCS-03
**Success Criteria** (what must be TRUE):

1. Maintainer can enumerate the exported contracts to preserve, including CLI behavior, config semantics, file formats, generated outputs, and packaging-visible behavior.
1. Contributors can find written guidance for launcher replacement, parity strategy, and fixture update protocol in `docs/`.
1. The migration docs explain which surfaces are in scope now versus deferred to later phases.

**Plans**: 2 plans

Plans:

- [ ] 04-01: Create the parity contract inventory and scope matrix
- [ ] 04-02: Write migration guidance for launcher strategy, parity boundaries, and fixture discipline

### Phase 5: Entry Surface Architecture

**Goal**: Carve out contract-oriented Rust modules and define the Rust/Bazel/shell entrypoint boundaries that will replace the Perl path.
**Depends on**: Phase 4
**Requirements**: RUST-04, ENTR-02
**Success Criteria** (what must be TRUE):

1. Contributor can locate contract-oriented Rust modules separately from lower-level implementation code.
1. Contributor can understand from repo docs and package boundaries which responsibilities belong to Bazel, Rust, and any temporary shell shims.
1. The launcher replacement strategy is concrete enough to implement without hidden Perl behavior creeping back in.

**Plans**: 3 plans

Plans:

- [ ] 05-01: Define Rust crates/modules for stable contracts versus implementation internals
- [ ] 05-02: Shape the launcher package and shell shim boundaries
- [ ] 05-03: Document the preferred entrypoint architecture and migration path off Perl

### Phase 6: macOS CLI Parity Slice

**Goal**: Deliver the first macOS-first Rust-backed CLI workflow and make it the preferred path for that scoped slice.
**Depends on**: Phase 5
**Requirements**: RUST-03, ENTR-01
**Success Criteria** (what must be TRUE):

1. User can invoke a Rust-backed CLI path on macOS for the first supported workflows.
1. The Rust-backed CLI preserves the intended legacy command-line contract for those workflows.
1. The preferred invocation for that slice no longer depends on the old Perl launcher as the primary implementation path.

**Plans**: 3 plans

Plans:

- [ ] 06-01: Implement the first Rust CLI/core workflow slice on macOS
- [ ] 06-02: Route the preferred entrypoint to the Rust-backed slice
- [ ] 06-03: Document supported and unsupported CLI parity surfaces for the slice

### Phase 7: Parity Visibility

**Goal**: Make migration progress and fixture discipline visible through a parity status command and documented update process.
**Depends on**: Phase 6
**Requirements**: PARI-02, PARI-04
**Success Criteria** (what must be TRUE):

1. Maintainer can run a parity status command that reports legacy-only, Rust-backed, blocked, and in-progress surfaces.
1. Contributor can add or update parity fixtures through a documented protocol rather than ad hoc comparisons.
1. The repo docs and checklists reflect the current migration and parity status in a way reviewers can use.

**Plans**: 2 plans

Plans:

- [ ] 07-01: Build the parity status command and status data source
- [ ] 07-02: Establish the fixture update workflow and tie it to migration docs

### Phase 8: Differential Parity Harness

**Goal**: Compare the legacy and Rust implementations on a shared fixture corpus for the initial macOS CLI/core workflows.
**Depends on**: Phase 7
**Requirements**: PARI-03
**Success Criteria** (what must be TRUE):

1. Maintainer can execute the shared fixture corpus against both legacy and Rust implementations for the first supported workflows.
1. Comparison results clearly show pass/fail/drift for those workflows instead of relying on manual spot checks.
1. The fixture corpus and comparison harness are structured so later phases can expand platform and surface coverage safely.

**Plans**: 3 plans

Plans:

- [ ] 08-01: Create the initial shared macOS fixture corpus
- [ ] 08-02: Implement the legacy-vs-Rust comparison harness
- [ ] 08-03: Report parity results in a way that feeds docs and future roadmap expansion

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 1/3 | In progress | - |
| 2. Legacy Oracle | 0/3 | Not started | - |
| 3. Rust Workspace | 0/3 | Not started | - |
| 4. Contract Inventory | 0/2 | Not started | - |
| 5. Entry Surface Architecture | 0/3 | Not started | - |
| 6. macOS CLI Parity Slice | 0/3 | Not started | - |
| 7. Parity Visibility | 0/2 | Not started | - |
| 8. Differential Parity Harness | 0/3 | Not started | - |
