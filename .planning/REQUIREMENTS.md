# Requirements: Slic3r Rust Port

**Defined:** 2026-04-06
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the legacy behavior and interfaces closely enough that the old implementation can eventually be retired without breaking the contracts users and integrators depend on.

## v1 Requirements

### Monorepo Foundation

- [ ] **MONO-01**: Maintainer can build the repository from a Bazel top-level entrypoint on macOS without relying on ad hoc root-level legacy commands
- [ ] **MONO-02**: Contributor can navigate a `packages/`-based repository layout that clearly separates the retained legacy implementation, new Rust implementation, launcher surface, parity tooling, and supporting assets
- [ ] **MONO-03**: Maintainer can run repository-relevant verification for the legacy and Rust packages from Bazel targets on macOS

### Legacy Reference Package

- [ ] **LEGA-01**: Maintainer can build the retained legacy Slic3r package from Bazel while leaving the legacy implementation behaviorally unchanged
- [ ] **LEGA-02**: Maintainer can run the retained legacy test surfaces from Bazel so the old implementation remains the parity oracle
- [ ] **LEGA-03**: Contributor can identify the retained legacy package as reference-only rather than the preferred surface for new feature work

### Rust Implementation

- [ ] **RUST-01**: Maintainer can build a new Rust package in the monorepo that complies with the Bright Builds Coding and Architecture Requirements
- [ ] **RUST-02**: Maintainer can run Rust formatting, linting, unit tests, and package-local verification through the Bazel-driven workflow on macOS
- [ ] **RUST-03**: User can invoke a macOS-first Rust CLI path that preserves the intended legacy command-line contract for the first supported workflows
- [ ] **RUST-04**: Contributor can locate contract-oriented Rust modules for stable CLI/config/file-format behavior separately from lower-level implementation code

### Parity

- [ ] **PARI-01**: Maintainer can enumerate the exported contracts and parity surfaces that the Rust port must preserve, including CLI behavior, config semantics, supported file formats, generated outputs, and packaging-visible behavior
- [ ] **PARI-02**: Maintainer can run a parity status command that reports which surfaces are still legacy-only, which are implemented in Rust, and which are blocked or in progress
- [ ] **PARI-03**: Maintainer can execute a shared fixture corpus against the legacy and Rust implementations to compare at least the first macOS CLI/core parity workflows
- [ ] **PARI-04**: Contributor can add or update parity fixtures with documented expectations instead of relying on undocumented ad hoc comparisons

### Entry Point

- [ ] **ENTR-01**: User can launch the preferred Slic3r CLI workflow without depending on the old Perl launcher as the primary implementation path
- [ ] **ENTR-02**: Contributor can understand, from repo docs and package boundaries, which responsibilities belong to Bazel, which belong to Rust, and which thin shell shims still exist temporarily

### Documentation

- [ ] **DOCS-01**: Contributor can find migration progress documentation and checklists under `docs/` that explain the current port status and parity scope
- [ ] **DOCS-02**: Reviewer can determine whether a Rust-port change also updated the corresponding migration docs and checklists as part of the normal review process
- [ ] **DOCS-03**: Contributor can find written guidance for the launcher refactor, monorepo layout, parity strategy, and fixture update protocol

## v2 Requirements

### Platforms

- **PLAT-01**: User can run the new Rust implementation with validated parity workflows on Linux
- **PLAT-02**: User can run the new Rust implementation with validated parity workflows on Windows

### GUI

- **GUI-01**: User can use a Rust-backed GUI path with parity goals against the legacy desktop surface
- **GUI-02**: Maintainer can validate GUI parity behavior with a documented fixture or acceptance strategy

### Automation

- **AUTO-01**: Maintainer can enforce migration-doc and checklist updates automatically in repository verification
- **AUTO-02**: Maintainer can run broader differential parity checks in CI across a larger corpus and more platforms

### Retirement

- **RETR-01**: Maintainer can retire the legacy package only after parity is proven and the retained oracle is no longer required

## Out of Scope

| Feature | Reason |
|---------|--------|
| Full GUI rewrite in the initial milestone | Core, CLI, build, and parity foundations need to be credible before the GUI surface expands the scope |
| Linux and Windows parity in the initial milestone | macOS is the active development platform and the fastest path to a validated first milestone |
| Intentional redesign of legacy contracts or user-visible behavior | This initiative is parity-first and modernization-focused, not a product reinvention |
| Ongoing feature development inside the retained legacy package | The legacy codebase should remain the reference implementation rather than a second active feature surface |
| CI-enforced docs/checklist gating in the initial milestone | Documentation updates are required by process first, with enforcement deferred until the workflow is stable |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| MONO-01 | Phase 1 | Complete |
| MONO-02 | Phase 1 | Complete |
| MONO-03 | Phase 2 | Complete |
| LEGA-01 | Phase 2 | Complete |
| LEGA-02 | Phase 2 | Complete |
| LEGA-03 | Phase 2 | Complete |
| RUST-01 | Phase 3 | Complete |
| RUST-02 | Phase 3 | Complete |
| RUST-03 | Phase 6 | Complete |
| RUST-04 | Phase 5 | Complete |
| PARI-01 | Phase 4 | Complete |
| PARI-02 | Phase 7 | Pending |
| PARI-03 | Phase 8 | Pending |
| PARI-04 | Phase 7 | Pending |
| ENTR-01 | Phase 6 | Complete |
| ENTR-02 | Phase 5 | Complete |
| DOCS-01 | Phase 1 | Complete |
| DOCS-02 | Phase 1 | Complete |
| DOCS-03 | Phase 4 | Complete |

**Coverage:**

- v1 requirements: 19 total
- Mapped to phases: 19
- Unmapped: 0 ✓

______________________________________________________________________

*Requirements defined: 2026-04-06*
*Last updated: 2026-04-08 after Phase 6 completion*
