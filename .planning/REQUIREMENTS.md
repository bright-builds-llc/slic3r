# Requirements: Slic3r Rust Port

**Defined:** 2026-04-11\
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

### macOS Packaging Launcher

- [ ] **PACK-01**: User can launch the preferred packaged macOS startup path
  for the currently supported Rust-backed CLI slice.
- [ ] **PACK-02**: Maintainer can inspect or produce the scoped macOS
  packaging-visible launcher layout with the expected startup scripts,
  bundle-local resources, and handoff behavior for the supported slice.

### macOS Packaging Parity Evidence

- [ ] **PACK-03**: Maintainer can verify macOS packaging-visible launcher
  behavior and artifact layout through shared parity evidence.
- [ ] **PACK-04**: Maintainer can see the macOS packaging-visible launcher slice
  reflected accurately in the parity status command and migration docs.

## v2 Requirements

### Platform Expansion

- **PLAT-01**: User can run validated Rust-backed parity workflows on Linux.
- **PLAT-02**: User can run validated Rust-backed parity workflows on Windows.

### GUI

- **GUI-01**: Maintainer has a concrete milestone and acceptance strategy for
  the future GUI migration.

### Broader Packaging

- **PACK-05**: Maintainer can verify packaging-visible launcher behavior for
  Linux and Windows through shared parity evidence.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Linux and Windows parity in this milestone | v1.3 remains macOS-first so packaged launcher behavior can be proven before platform expansion |
| GUI rewrite planning or implementation in this milestone | GUI strategy still depends on broader CLI/core/packaging maturity |
| Broad packaged feature parity beyond the currently supported Rust-backed CLI slice | This milestone is about packaging-visible behavior for the already verified scoped slice, not a broader feature expansion |
| Package signing, notarization, and distribution-channel automation | Those are downstream release concerns and should follow after packaged launcher parity exists |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| PACK-01 | Phase 18 | Pending |
| PACK-02 | Phase 18 | Pending |
| PACK-03 | Phase 19 | Pending |
| PACK-04 | Phase 19 | Pending |

**Coverage:**

- v1 requirements: 4 total
- Mapped to phases: 4
- Unmapped: 0 ✓

______________________________________________________________________

*Requirements defined: 2026-04-11*\
*Last updated: 2026-04-11 after milestone v1.3 definition*
