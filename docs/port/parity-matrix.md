# Parity Matrix

| Surface | Current Source of Truth | Status | Notes |
|---------|-------------------------|--------|-------|
| CLI behavior | `packages/legacy-slic3r/slic3r.pl` and legacy native surfaces | legacy-only | `//:legacy_oracle_smoke` is the current trusted macOS oracle check for the retained CLI path |
| Config semantics | `packages/legacy-slic3r/lib/Slic3r/Config.pm` and related legacy code | legacy-only | Contract inventory not yet extracted into Rust-facing modules |
| Supported file formats | Legacy Perl/C++/XS pipeline under `packages/legacy-slic3r/` | legacy-only | STL, OBJ, AMF, 3MF, SVG, and related surfaces still live only in legacy |
| Generated outputs | Legacy slicing and export pipeline under `packages/legacy-slic3r/` | legacy-only | G-code and other export parity remain future work |
| Launcher path | Legacy launcher retained under `packages/legacy-slic3r/slic3r.pl` | legacy-only | `packages/launcher` exists as a placeholder boundary; the retained launcher is currently exercised through `//:legacy_oracle_smoke` |
| Packaging-visible behavior | Legacy packaging scripts under `packages/legacy-slic3r/package/` | legacy-only | Packaging remains legacy-only until later phases |

## Interpretation

Phase 1 established the foundation, and Phase 2 established the first Bazel-wrapped macOS legacy oracle surface. The correct status is still mostly `legacy-only` because the Rust implementation and parity harness have not started delivering these surfaces yet, but contributors should now distinguish between:

- the trusted retained oracle check on macOS: `//:legacy_oracle_smoke`
- broader retained legacy tests that are exposed but still deferred until their XS loader path is stabilized
