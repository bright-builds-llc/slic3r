# Requirements: Slic3r Rust Port

**Defined:** 2026-04-11\
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

### Linux Launcher Runtime

- [x] **LNX-01**: User can run the preferred Rust-backed Linux launcher path for
  the supported `--help` and `--version` slice.
- [x] **LNX-02**: User can run the currently verified config persistence,
  export, and non-slicing transform workflows through the preferred Rust-backed
  Linux launcher path.
- [x] **LNX-03**: Maintainer can build and invoke the Linux Rust-backed runtime
  path from Bazel without relying on macOS-specific packaging surfaces.

### Linux Parity Evidence

- [x] **LNX-04**: Maintainer can execute shared parity evidence for the
  supported Linux Rust-backed runtime slice.
- [x] **LNX-05**: Maintainer can see Linux validation state reflected accurately
  in the parity status command and migration docs.

## v2 Requirements

### Broader Packaging

- **PACK-05**: Maintainer can verify packaging-visible launcher behavior for
  Linux and Windows through shared parity evidence.

### Windows Platform

- **WIN-01**: User can run validated Rust-backed parity workflows on Windows.
- **WIN-02**: Maintainer can verify the supported Windows runtime slice through
  shared parity evidence.

### GUI

- **GUI-01**: Maintainer has a concrete milestone and acceptance strategy for
  the future GUI migration.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Linux packaging-visible parity in this milestone | First establish a validated Linux runtime slice before claiming Linux packaging parity |
| Windows runtime or packaging parity in this milestone | v1.4 focuses on Linux foundations first so cross-platform work has one credible runtime target to copy from |
| GUI migration planning or implementation in this milestone | Platform/runtime parity still matters more than GUI planning |
| Broad new CLI slices beyond the currently verified help/version/config/export/transform surface | This milestone stabilizes Linux support for the existing verified slice rather than broadening feature scope |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| LNX-01 | Phase 21 | Complete |
| LNX-02 | Phase 21 | Complete |
| LNX-03 | Phase 21 | Complete |
| LNX-04 | Phase 22 | Complete |
| LNX-05 | Phase 23 | Complete |

**Coverage:**

- v1 requirements: 5 total
- Mapped to phases: 5
- Unmapped: 0 ✓

______________________________________________________________________

*Requirements defined: 2026-04-11*\
*Last updated: 2026-04-11 after Phase 23 Linux parity visibility*
