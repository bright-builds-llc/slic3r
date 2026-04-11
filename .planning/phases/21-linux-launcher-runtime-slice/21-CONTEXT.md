---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 21-2026-04-11T19-05-00
generated_at: 2026-04-11T19:05:00Z
---

# Phase 21: Linux Launcher Runtime Slice - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver the preferred Rust-backed Linux launcher/runtime path for the already
verified help/version/config/export/transform slice. This phase establishes the
Linux runtime handoff and Bazel surfaces only. It does not claim Linux
packaging-visible parity, distro packaging, AppImage parity, or Windows work.

</domain>

<decisions>
## Implementation Decisions

### Linux launcher shape

- Follow the legacy Linux launcher contract only at the visible entrypoint
  boundary: a thin startup shim that forwards arguments into the Rust CLI.
- Keep the new Linux startup shim shell-only and free of Perl business logic.
- Expose the preferred Linux runtime path through `packages/launcher` Bazel
  targets instead of inventing a separate package boundary.

### Verification shape

- Add a Linux launcher smoke surface that proves the startup shim can execute
  representative help/version/config/export/transform flows through the Rust CLI.
- Do not update shared parity status rows to `verified` for Linux in this
  phase; shared Linux parity evidence belongs to Phase 22.

### Documentation scope

- Document the supported Linux runtime slice and the remaining deferred Linux
  packaging gaps in `docs/port/`.
- Keep platform claims conservative: Linux runtime path exists, Linux packaging
  parity still deferred.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/launcher/BUILD.bazel`
- `packages/launcher/README.md`
- `packages/legacy-slic3r/package/linux/startup_script.sh`
- `docs/port/entrypoint-architecture.md`
- `docs/port/migration-guidance.md`
- `docs/port/package-map.md`
- `docs/port/parity-matrix.md`

</canonical_refs>
