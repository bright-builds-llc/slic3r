# Requirements: Slic3r Rust Port

**Defined:** 2026-04-08
**Core Value:** Deliver a trustworthy Rust successor to Slic3r that matches the
legacy behavior and interfaces closely enough that the old implementation can
eventually be retired without breaking the contracts users and integrators
depend on.

## v1 Requirements

### CLI Help and Usage

- [x] **CLI-01**: User can invoke `--help` through the preferred Rust-backed
  launcher path on macOS and receive a usage screen.
- [x] **CLI-02**: The Rust-backed usage screen clearly distinguishes supported
  Rust-backed slices from still-legacy-owned CLI behavior.

### Config Persistence

- [x] **CFG-01**: User can save configuration to an INI file through the
  preferred Rust-backed CLI path on macOS.
- [x] **CFG-02**: User can load one or more configuration files through the
  preferred Rust-backed CLI path on macOS.
- [x] **CFG-03**: User can scope configuration state with `--datadir` for the
  supported Rust-backed CLI flows on macOS.

### CLI Parity Visibility

- [ ] **PCLI-01**: Maintainer can execute shared fixture comparisons for the
  supported help, version, and config CLI slices.
- [ ] **PCLI-02**: Maintainer can see those supported CLI slices reflected
  accurately in the parity status command and migration docs.

## v2 Requirements

### Export and Transform Workflows

- **XCLI-01**: User can invoke export workflows such as `--export-gcode`,
  `--export-stl`, `--export-obj`, `--export-amf`, `--export-3mf`, and
  `--export-svg` through the preferred Rust-backed launcher path.
- **XCLI-02**: User can invoke non-slicing transform workflows such as
  `--repair`, `--split`, `--cut`, `--cut-grid`, and `--info` through the
  preferred Rust-backed launcher path.

### Packaging and Platforms

- **PACK-01**: Maintainer can verify packaging-visible launcher behavior for
  macOS through shared parity evidence.
- **PLAT-01**: User can run validated Rust-backed parity workflows on Linux.
- **PLAT-02**: User can run validated Rust-backed parity workflows on Windows.

### GUI

- **GUI-01**: Maintainer has a concrete milestone and acceptance strategy for
  the future GUI migration.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Export, slicing, and geometry-transform parity in this milestone | Help and config persistence are the smallest next CLI slices that can be delivered credibly after `--version` |
| Packaging-visible parity implementation in this milestone | Launcher/package ownership exists, but packaged behavior still needs a later dedicated milestone |
| Linux and Windows parity in this milestone | v1.1 remains macOS-first so the CLI surface can deepen before platform expansion |
| GUI rewrite planning or implementation in this milestone | CLI/core parity still needs broader coverage before GUI work is worth scoping tightly |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| CLI-01 | Phase 9 | Complete |
| CLI-02 | Phase 9 | Complete |
| CFG-01 | Phase 10 | Complete |
| CFG-02 | Phase 10 | Complete |
| CFG-03 | Phase 10 | Complete |
| PCLI-01 | Phase 11 | Pending |
| PCLI-02 | Phase 11 | Pending |

**Coverage:**

- v1 requirements: 7 total
- Mapped to phases: 7
- Unmapped: 0 ✓

______________________________________________________________________

*Requirements defined: 2026-04-08*
*Last updated: 2026-04-08 after milestone v1.1 definition*
