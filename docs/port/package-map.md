# Package Map

## Root-Owned Areas

| Path | Role |
|------|------|
| `MODULE.bazel`, `.bazelversion`, `.bazelrc`, `BUILD.bazel` | Canonical Bazel root and repo entrypoint |
| `docs/` | Human-readable migration, contract, and project documentation |
| `tools/` | Repo-level helper scripts such as Bazel smoke tests |
| `.planning/` | GSD project memory, research, roadmap, and execution metadata |
| `.github/`, `.travis.yml`, `appveyor.yml`, Bright Builds files | Repo metadata and inherited automation surfaces retained at the root; Phase 31 adds `.github/workflows/release-build-artifacts.yml` for scoped base package release build artifacts |
| `tools/release/` | Repo-owned release artifact scripts used by GitHub Actions and local maintainer checks |

## Packages

| Package | Role |
|---------|------|
| `packages/legacy-slic3r` | Retained legacy reference package, behavioral oracle, and Bazel-wrapped macOS legacy build/smoke surface |
| `packages/slic3r-rust` | Bright Builds-compliant Rust workspace package with separate implementation, contract, CLI, and flavor-registry crate boundaries plus a Bazel-native verification surface; `slic3r_flavors` owns the Prusa profile parser and summary helper |
| `packages/launcher` | Entry-point package boundary that points at the Rust CLI and now owns the preferred Linux runtime shim, the scoped Linux packaged launcher tree, the preferred Windows runtime target, the scoped Windows packaged launcher tree, and the scoped macOS packaged launcher/startup surface |
| `packages/parity` | Parity visibility package with the checked-in status data source, the status command, and shared comparison commands for the verified CLI, Linux runtime, Windows runtime, export, transform, scoped macOS packaged launcher, Linux packaged launcher, Windows packaged launcher, and narrow Prusa profile-schema slices |
| `packages/parity-fixtures` | Fixture package boundary with contributor-facing provenance rules, shared corpora for the verified help/version/config, Linux runtime, Windows runtime, export, transform, scoped macOS packaged launcher, `linux-packaged-launcher`, `windows-packaged-launcher`, Prusa profile-schema, and Phase 42 Prusa project-file fixture slices, including checked-in expected artifacts such as `expected-summary.tsv` and `expected-project-summary.tsv` |
| `packages/fork-vendors` | Vendor-source intake metadata, release-pin verification, and license/provenance cautions for downstream Slic3r-family fork planning |
| `packages/fork-inventories` | Owns feature inventory templates, PrusaSlicer/Bambu Studio/OrcaSlicer source-pinned inventory TSVs, the cross-fork category map, and inventory verification |
| `packages/fork-templates` | Owns Phase 36 maintainer templates for future fork parity checklists, launcher-shape planning, and manual drift-refresh review without proving runtime fork parity |
| `packages/prusa-baseline` | Phase 37 PrusaSlicer baseline and checklist gate package for the narrow v1.10 profile schema/config evidence slice |
| `packages/prusa-project-file-scope` | Phase 41 checked-in scope record and verifier package for the narrow `prusaslicer.project-file` evidence contract only |

## Notes

- The legacy package is visible by design. Contributors should be able to compare the old and new implementation paths directly.
- The trusted Phase 2 oracle set is intentionally narrower than the full retained historical test tree. Today the trusted macOS oracle check is the smoke wrapper, while the broader retained legacy test wrapper remains documented but deferred.
- Root-owned areas stay outside `packages/` so the monorepo does not hide shared orchestration and documentation behind package boundaries.
- The Rust side starts as one top-level package in Phase 1. Phase 3 adds the first real internal crate, `crates/slic3r_core`, without exploding the top-level package list.
- The Phase 4 contract registry lives in `docs/port/contract-inventory.md`, and the contributor-facing launcher/parity/fixture rules live in `docs/port/migration-guidance.md`.
- Phase 5 adds `docs/port/entrypoint-architecture.md` and explicit Rust crate boundaries for launcher contracts and the CLI shell.
- Phase 6 adds `docs/port/cli-slice.md` and makes `--version` the first supported Rust-backed launcher workflow on macOS.
- Phase 7 makes `packages/parity` and `packages/parity-fixtures` real package boundaries with a status command and fixture workflow rules.
- Phase 8 seeds the first shared fixture corpus and comparison command for `cli.version`.
- Phase 11 expands that corpus and comparison surface to the supported help and config persistence slices.
- Phase 14 adds verified fixture comparison commands and corpora for the scoped export and transform slices.
- Phase 15 tightens those fixtures so the explicit `--export-sla-svg` alias and the full documented `--info` input matrix are covered.
- Phase 18 adds a scoped macOS packaged launcher bundle under `packages/launcher/package/osx` and documents its bundle layout expectations.
- Phase 19 adds parity evidence and fixture coverage for the scoped macOS packaged launcher slice.
- Phase 21 adds a preferred Linux runtime shim under `packages/launcher/package/linux` for the existing verified Rust-backed slice.
- Phase 24 adds a preferred Windows runtime target through `//packages/launcher:windows_slic3r` for the existing verified Rust-backed slice.
- Phase 27 adds a scoped Linux packaged launcher tree through
  `//packages/launcher:linux_packaged_launcher_tree` and keeps release-grade
  Linux package formats deferred.
- Phase 22 adds a shared Linux runtime parity command that validates the
  preferred Linux launcher path against the existing verified slice.
- Phase 25 adds a shared Windows runtime parity command under `packages/parity`.
- Phase 26 publishes the bounded Windows runtime validation state through
  `packages/parity/status.tsv` and the migration docs.
- Phase 28 adds a scoped Windows packaged launcher tree through
  `//packages/launcher:windows_packaged_launcher_tree`.
- Phase 29 adds shared packaged launcher evidence through
  `//packages/parity:linux_packaged_launcher_parity` and
  `//packages/parity:windows_packaged_launcher_parity`, backed by
  `linux-packaged-launcher` and `windows-packaged-launcher` fixtures under
  `packages/parity-fixtures`.
- Phase 30 publishes `linux.packaged-launcher` and
  `windows.packaged-launcher` through `packages/parity/status.tsv` while
  keeping AppImage, MSI, DMG, installers, signing, GUI packaging, release
  archives, native/cross-compiled release binaries, broad dependency bundling,
  and release channels deferred.
- Phase 31 adds scoped release build automation through
  `.github/workflows/release-build-artifacts.yml` and
  `tools/release/build_release_artifact.sh`. The workflow uploads base Slic3r
  macOS, Linux, and Windows package-tree archives with provenance after running
  the matching packaged launcher parity evidence. It still keeps signing,
  notarization, installers, AppImage, MSI, DMG, GUI packaging, release-channel
  publishing, fork-flavor builds, and new CLI behavior deferred.
- Phase 32 adds `packages/fork-vendors` for vendor source references, selected
  release pins, branch drift-only observations, SPDX/license provenance, and
  non-free/network-plugin cautions. Runtime fork parity, fork-flavor builds,
  online integrations, non-free plugin ingestion, and full drift-refresh
  protocol templates remain deferred.
- Phase 33 adds `packages/fork-inventories` for source-pinned feature inventory
  templates and per-fork inventory TSVs, the cross-fork category map, and
  `bazel run //packages/fork-inventories:verify`. This preserves the Phase 32
  boundary: no upstream source import, no clone/vendor/build, no runtime fork
  parity claim, no online/cloud integration, no credential handling, and no
  non-free plugin ingestion.
- Phase 34 extends `packages/slic3r-rust/crates/slic3r_contracts`
  with typed fork/flavor contract values and tests. Phase 35 adds `packages/slic3r-rust/crates/slic3r_flavors`
  as the shared static flavor registry boundary. Base Slic3r behavior remains
  in shared core packages, and
  future fork behavior plugs in through capability-oriented metadata, not
  PrusaSlicer, Bambu Studio, or OrcaSlicer-specific Rust workspaces or copied
  base behavior. The Phase 32/33 source-intake and inventory-only boundaries
  remain in force: no upstream source import, clone/vendor/build, runtime fork
  parity claim, online/cloud integration, credential handling, or non-free
  plugin ingestion.
- Phase 36 adds `packages/fork-templates` as the documentation and template
  package for future fork parity checklists, launcher-shape planning, and the
  manual drift-refresh protocol. Link to the central
  [fork-parity deferral](./README.md#v19-fork-parity-deferrals) block instead
  of duplicating the complete v1.9 deferral list. `bazel run //packages/fork-templates:verify` checks template wording only; template
  verification does not prove fork parity.
- Phase 37 adds `packages/prusa-baseline`, records the accepted Prusa baseline
  `version_2.9.5` at `9a583bd438b195856f3bcf7ea99b69ba4003a961`, records the
  `prusaslicer.profile-schema` checklist gate, and keeps fixtures, parity
  status rows, executable parity commands, runtime fork support, GUI support,
  sync automation, and fork release packaging out of Phase 37.
- Phase 38 adds the static Prusa fixture namespace
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` and
  verifies it with
  `//packages/parity-fixtures:verify_prusa_profile_schema_fixture`.
- Phase 39 adds the Rust parser/metadata boundary
  `slic3r_flavors::prusa_profile` with `parse_prusa_profile_bundle` and
  `prusa_profile_schema_metadata` for `prusaslicer.profile-schema`. It traces
  the accepted source
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  `resources/profiles/PrusaResearch.ini`,
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`,
  `packages/prusa-baseline/profile-schema-checklist.md`, and
  `future-candidate` status.
- Phase 40 makes the Prusa package boundaries discoverable:
  `packages/parity` owns `bazel run //packages/parity:prusaslicer_profile_schema_parity` and the
  `fork.prusaslicer.profile-schema` status row, `packages/parity-fixtures` owns
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv`,
  and `packages/slic3r-rust/crates/slic3r_flavors` owns parser/summary logic for
  the narrow Prusa profile-schema parser/config evidence slice.
- Phase 41 adds `packages/prusa-project-file-scope`, which owns the checked-in
  `prusaslicer.project-file` scope record and verifier only. It does not create
  fixture bytes, expected artifacts, Rust parser code, parity targets, status
  rows, upstream source imports, Bambu Studio scope, OrcaSlicer scope, or sync
  automation.
- Phase 42 adds the project-file fixture namespace at
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`, with
  `seam_test_object.3mf`, `fixture-provenance.tsv`,
  `expected-project-summary.tsv`, the
  `//packages/parity-fixtures:prusa_project_file_bundle` bundle, and
  `bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture`.
  `packages/parity` still does not publish a project-file parity command or
  status row.
