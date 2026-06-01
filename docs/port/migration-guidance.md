# Migration Guidance

This guide explains how to use the Phase 4 contract inventory while the port is
still mostly `legacy-only`. Read
[`contract-inventory.md`](./contract-inventory.md) for the detailed contract
rows and [`package-map.md`](./package-map.md) for the current and future package
boundaries.

## Launcher Replacement

- Treat the user-visible launch contract as the thing that must survive. The
  legacy evidence is `packages/legacy-slic3r/slic3r.pl`,
  `packages/legacy-slic3r/package/osx/startup_script.sh`,
  `packages/legacy-slic3r/package/linux/startup_script.sh`, and
  `packages/legacy-slic3r/package/common/shell.cpp`.
- The replacement does not need to preserve Perl internals. It does need to
  preserve argument handoff, visible entrypoints, packaged startup behavior, and
  the surrounding packaging-visible expectations those scripts and wrappers
  encode.
- `packages/launcher` is the future owner boundary for this surface. Until that
  package contains real code, the launcher contract remains defined by the
  retained legacy entrypoints and the Phase 4 docs.
- Keep any temporary shell shims thin. Bazel should stay the top-level build and
  test entrypoint, while Rust owns long-term behavior and shell only bridges the
  smallest necessary handoff.

## Parity Strategy

- Treat parity evidence as a ladder rather than one undifferentiated blob:
  legacy source of truth, trusted check, then weaker or deferred evidence.
- A surface stays `legacy-only` until a real Rust-backed implementation exists.
  A surface becomes `in progress` only when implementation work has started but
  is not yet the trusted path. A surface becomes `rust-backed` only when the
  Rust implementation provides the behavior but parity still needs more proof. A
  surface becomes `verified` only after the tracked proof for that scope passes.
- The current trusted oracle is `//:legacy_oracle_smoke`. It proves the retained
  macOS CLI help path is alive. `//:legacy_oracle_test` remains broader but
  weaker or deferred evidence until the retained XS loader path is stabilized.
- Do not claim Rust-backed parity because a package boundary exists, because a
  Rust crate exists, or because a broader retained legacy test happens to exist.
  Concrete implementation and verification evidence must move together.

## Fixture Update Protocol

- The shared fixture home is `packages/parity-fixtures`. It now contains
  fixture corpora for the verified help/version/config/export/transform slices,
  Linux and Windows runtime paths, the scoped macOS packaged launcher bundle,
  and the scoped Linux and Windows package-shaped launcher trees.
- `packages/parity-fixtures/README.md` is the package-local fixture workflow
  reference and should stay aligned with this guide.
- Every future fixture should record provenance: which legacy command or source
  generated it, which contract item it supports, and any platform or scope
  limits.
- Fixture naming should follow the contract surface first, then the scenario.
  For example, launcher fixtures should not be mixed into generated-output or
  config fixture names.
- Future fork fixture work is reserved under
  `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/`.
  Phase 38 creates
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` for
  the Prusa profile/config evidence slice.
- The Phase 38 Prusa fixture namespace update route is: update only after a reviewed intake change updates packages/fork-vendors/forks.tsv and the Prusa checklist/baseline gate.
  Branch-head observations remain drift-only.
- When a change adds, removes, or materially alters a fixture-backed parity
  surface, update the relevant rows in `docs/port/contract-inventory.md` and
  `docs/port/parity-matrix.md`. If the protocol itself changes, update this
  guide in the same change.

## Future Fork Parity Status

- The complete v1.9 fork-parity deferral list lives in
  [`README.md#v19-fork-parity-deferrals`](./README.md#v19-fork-parity-deferrals).
  Link to that block instead of repeating the full list in every package doc.
- Phase 38 does not add Prusa rows to `packages/parity/status.tsv`.
- Future fork status tokens should use `fork.<inventory_id>` or an
  inventory-derived stable slug, and `verified` requires a real
  `//packages/parity:*_parity` evidence command.
- `fork.prusaslicer.profile-schema` is reserved for Phase 40 only and requires
  `bazel run //packages/parity:prusaslicer_profile_schema_parity`.
- `packages/parity/status.tsv` must remain free of Prusa profile-schema rows
  until that command exists and passes.
- Future fork status requires executable parity evidence. Source pins,
  inventories, templates, checklist completion, and registry metadata remain
  planning inputs only.

Phase 37 routes PrusaSlicer baseline review through `packages/prusa-baseline`;
that package is a baseline/checklist gate only. Phase 38 fixture/status
preparation creates static Prusa inputs only, Phase 39 creates Rust parsing, and
Phase 40 creates executable parity/status publication.

## Scope Now vs Deferred

- Current verified scope now includes the preferred Rust-backed launcher slice,
  Linux and Windows runtime paths, scoped packaged launcher trees, and scoped
  base release build artifacts:
  - `//packages/parity:linux_packaged_launcher_parity` verifies the Linux
    package-shaped launcher tree for the supported help/version/config/export/
    transform slice.
  - `//packages/parity:windows_packaged_launcher_parity` verifies the Windows
    package-shaped launcher tree for the supported help/version/config/export/
    transform slice.
  - `.github/workflows/release-build-artifacts.yml` uploads macOS, Linux, and
    Windows base package archives with `release-provenance.txt` after running
    the matching packaged launcher parity target.
- Deferred to later phases:
  - broader CLI behavior beyond the verified slice
  - GUI replacement work
  - release-grade package formats such as AppImage, MSI, and DMG
  - installers, signing, notarization, native/cross-compiled release binaries,
    broad bundled dependency layout, downstream fork work, fork-flavor builds,
    GitHub Release publishing, and release channels
- The docs should prefer plain statements of what is deferred over optimistic
  wording. If the repo cannot prove a surface today, keep it `legacy-only` and
  say so.
