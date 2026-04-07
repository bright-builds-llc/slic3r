# Parity Matrix

| Surface | Current Source of Truth | Status | Notes |
|---------|-------------------------|--------|-------|
| CLI behavior | `packages/legacy-slic3r/slic3r.pl` and legacy native surfaces | legacy-only | Rust CLI work is deferred to later phases |
| Config semantics | `packages/legacy-slic3r/lib/Slic3r/Config.pm` and related legacy code | legacy-only | Contract inventory not yet extracted into Rust-facing modules |
| Supported file formats | Legacy Perl/C++/XS pipeline under `packages/legacy-slic3r/` | legacy-only | STL, OBJ, AMF, 3MF, SVG, and related surfaces still live only in legacy |
| Generated outputs | Legacy slicing and export pipeline under `packages/legacy-slic3r/` | legacy-only | G-code and other export parity remain future work |
| Launcher path | Legacy launcher retained under `packages/legacy-slic3r/slic3r.pl` | legacy-only | `packages/launcher` exists, but only as a placeholder boundary |
| Packaging-visible behavior | Legacy packaging scripts under `packages/legacy-slic3r/package/` | legacy-only | Packaging remains legacy-only until later phases |

## Interpretation

Phase 1 is intentionally about foundation, not Rust-backed parity. The correct status today is mostly `legacy-only` because the migration control plane is now explicit, but the Rust implementation and parity harness have not started delivering these surfaces yet.
