# Rust Workspace

`packages/slic3r-rust` is the new Bazel-backed Rust implementation package for the Slic3r migration.

Phase 3 establishes the workspace, toolchain, and verification surface only.
Phase 5 adds contract-oriented crate boundaries and the first launcher-facing
Rust CLI scaffold. Phase 6 makes the `--version` path the first supported
Rust-backed macOS CLI slice. Phase 9 adds the `--help` path. Broader CLI, GUI,
and output parity remain later work. Phase 10 adds the scoped config
persistence path. Phase 12 adds the scoped Rust-backed export workflows. Phase
13 adds the scoped Rust-backed transform/info workflows. Phase 39 adds the
`slic3r_flavors::prusa_profile` parser and metadata boundary for the
PrusaSlicer profile-schema fixture only. Phase 40 adds the Rust summary helper
and `bazel run //packages/parity:prusaslicer_profile_schema_parity` as narrow
executable Prusa profile-schema parser/config evidence.

## Layout

- `Cargo.toml` - virtual workspace root for the Rust package
- `BUILD.bazel` - package-level Bazel surface for build and verify commands
- `crates/slic3r_core/` - lower-level Rust implementation crate
- `crates/slic3r_contracts/` - stable contract-oriented launcher types plus
  Rust flavor contracts for downstream fork identity, flavor identity, vendor
  source identity, feature origin, parity surface, and checklist status
- `crates/slic3r_flavors/` - pure static flavor registry crate that depends on
  `slic3r_contracts` and composes base, shared downstream, and fork-specific
  capability metadata
- `crates/slic3r_cli/` - launcher-facing CLI scaffold

## Bazel Commands

- Build the first Rust target:
  - `//packages:rust_build`
- Build the launcher-facing Rust entrypoint scaffold:
  - `//packages:rust_entrypoint_scaffold`
- Run the first supported Rust-backed CLI slice:
  - `bazel run //packages/launcher:slic3r -- --version`
- Run the Rust-backed help slice:
  - `bazel run //packages/launcher:slic3r -- --help`
- Run the Rust-backed config persistence slice:
  - `bazel run //packages/launcher:slic3r -- --save cfg.ini`
  - `bazel run //packages/launcher:slic3r -- --load cfg.ini`
- Run the scoped Rust-backed export slice:
  - `bazel run //packages/launcher:slic3r -- --export-gcode model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-stl model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-obj model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-amf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-3mf model.stl`
  - `bazel run //packages/launcher:slic3r -- --export-svg model.stl`
  - `bazel run //packages/launcher:slic3r -- --sla model.stl`
  - `bazel run //packages/launcher:slic3r -- --info model.obj`
  - `bazel run //packages/launcher:slic3r -- --repair model.stl`
  - `bazel run //packages/launcher:slic3r -- --split model.stl`
- Run the package verification suite:
  - `//packages/slic3r-rust:verify`
- Run the flavor contract parser tests:
  - `//packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test`
- Run the flavor registry metadata tests:
  - `//packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test`
- Run the Prusa profile-schema parser boundary tests:
  - `//packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_test`
- Run the Prusa profile-schema summary helper:
  - `//packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_schema_summary`
- Run the narrow Prusa profile-schema parity command:
  - `bazel run //packages/parity:prusaslicer_profile_schema_parity`
- Run write-mode formatting with the pinned Rust toolchain:
  - `bazel run @rules_rust//:rustfmt`

## Notes

- The current supported Rust-backed CLI workflows are `--version`, `--help`,
  `--save`, `--load`, `--datadir`, the scoped export flags, and the scoped
  transform/info flags.
- Phase 12 only claims export routing, file creation, and scoped output naming.
  Phase 13 only claims transform/info routing, deterministic stdout, and
  legacy-shaped repair/split artifact naming. Geometry and output-content parity
  remain later work.
- Phase 14 verifies the supported export and transform/info slices through the
  parity package fixture commands.
- `crates/slic3r_contracts/` owns `DownstreamFork`, `FlavorId`,
  `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`
  as pure Rust flavor contract values for downstream metadata boundaries.
- `crates/slic3r_flavors/` is static metadata only. It does not implement
  runtime fork behavior, launcher dispatch, fork-flavor release builds,
  online/cloud integration, credential handling, non-free plugin ingestion, or
  executable fork parity.
- Phase 39 exposes `slic3r_flavors::prusa_profile`,
  `parse_prusa_profile_bundle`, and `prusa_profile_schema_metadata` for
  parser/metadata readiness only. Phase 40 adds
  `prusa_profile_schema_summary` and the summary binary for deterministic
  parser/config evidence. The boundary traces
  `prusaslicer.profile-schema` to
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  `resources/profiles/PrusaResearch.ini`,
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`,
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv`,
  `packages/prusa-baseline/profile-schema-checklist.md`, and checklist status
  `future-candidate`.
- `slic3r_flavors::prusa_profile` remains parser/metadata plus summary evidence
  only. `fork.prusaslicer.profile-schema` is verified through
  `bazel run //packages/parity:prusaslicer_profile_schema_parity` for the
  narrow Prusa profile-schema parser/config evidence slice only.
- Full PrusaSlicer runtime support remains deferred. GUI support remains
  deferred, generated-output parity remains deferred, fork release builds remain
  deferred, profile auto-update execution remains deferred, network/cloud/
  credential behavior remains deferred, non-free plugin ingestion remains
  deferred, and sync automation remains deferred.
- The package follows the Bright Builds coding and architecture requirements for Rust work.
- Bazelisk is the expected local Bazel launcher on macOS because the repo pins Bazel in [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion).
