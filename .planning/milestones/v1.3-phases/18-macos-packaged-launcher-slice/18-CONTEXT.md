---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 18-2026-04-11T15-10-03
generated_at: 2026-04-11T15:10:03Z
---

# Phase 18: macOS Packaged Launcher Slice - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver the preferred packaged macOS launcher/startup path for the currently
verified Rust-backed CLI slice. This phase covers an inspectable bundle layout,
a thin packaged startup shim, and documentation for the bounded macOS packaged
surface. It does not claim full DMG/signing/notarization parity yet.

</domain>

<decisions>
## Implementation Decisions

### Packaging scope

- Materialize a scoped `Slic3r.app`-style bundle under a repo-defined tmp path
  via a Bazel-run packaging command.
- Keep the packaged startup path thin: a shell shim in `Contents/MacOS/` that
  execs the bundled Rust CLI binary.
- Reuse an existing legacy macOS icon resource rather than inventing a new
  packaging asset for this bounded slice.

### Evidence posture

- Add a packaged-launcher smoke test in Bazel for the currently supported
  Rust-backed slice.
- Mark launcher packaging as `rust-backed` once the bundle builder and smoke
  test exist.
- Defer shared packaging parity evidence to Phase 19.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/legacy-slic3r/package/osx/startup_script.sh`
- `packages/legacy-slic3r/package/osx/make_dmg.sh`
- `docs/port/entrypoint-architecture.md`
- `docs/port/contract-inventory.md`

</canonical_refs>
