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

- The future shared fixture home is `packages/parity-fixtures`. Until the corpus
  exists, contributors should document intended fixture additions in the Phase 4
  docs and in review descriptions rather than treating ad hoc local files as a
  hidden baseline.
- `packages/parity-fixtures/README.md` is the package-local fixture workflow
  reference and should stay aligned with this guide.
- Every future fixture should record provenance: which legacy command or source
  generated it, which contract item it supports, and any platform or scope
  limits.
- Fixture naming should follow the contract surface first, then the scenario.
  For example, launcher fixtures should not be mixed into generated-output or
  config fixture names.
- When a change adds, removes, or materially alters a fixture-backed parity
  surface, update the relevant rows in `docs/port/contract-inventory.md` and
  `docs/port/parity-matrix.md`. If the protocol itself changes, update this
  guide in the same change.

## Scope Now vs Deferred

- Phase 4 scope now:
  - inventory the six externally visible surface families
  - document launcher replacement rules
  - document the parity evidence model
  - document the fixture update protocol
  - keep the repo's status language conservative and macOS-first
- Deferred to later phases:
  - Rust-backed CLI implementation and preferred entrypoint replacement
  - the shared fixture corpus under `packages/parity-fixtures`
  - Linux and Windows packaging-visible parity
  - GUI replacement work
- The docs should prefer plain statements of what is deferred over optimistic
  wording. If the repo cannot prove a surface today, keep it `legacy-only` and
  say so.
