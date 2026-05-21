---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 24-2026-04-12T01-20-47
generated_at: 2026-04-12T01:20:47Z
---

# Phase 24: Windows Launcher Runtime Slice - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Deliver the preferred Rust-backed Windows launcher/runtime path for the already
verified help/version/config/export/transform slice. This phase establishes the
Windows runtime handoff and Bazel surfaces only. It does not claim Windows
packaging-visible parity, packaged `Slic3r.exe` ownership, shared Windows
parity evidence, or published Windows validation status.

</domain>

<decisions>
## Implementation Decisions

### Windows launcher shape

- Use a dedicated Rust console entrypoint as the preferred Windows runtime
  surface instead of adding a PowerShell-only or shell-based launcher shim.
- Expose that runtime entrypoint through `packages/launcher:windows_slic3r`
  so Bazel owns the public invocation surface.
- Keep the Windows runtime handoff thin and limited to the already verified
  help/version/config/export/transform slice.

### Verification shape

- Add a Windows launcher smoke surface that proves the direct runtime target
  can execute representative help/version/config/export/transform flows.
- Do not add shared Windows parity fixtures or status rows in this phase; those
  belong to Phases 25 and 26.
- Keep claims conservative: Phase 24 creates the runtime target and smoke
  coverage, not packaging-visible Windows parity.

### Documentation scope

- Document the supported Windows runtime slice and the remaining deferred
  Windows packaging gaps in `docs/port/`.
- Update the contract inventory and package map so contributors can see the
  Windows runtime boundary without inferring it from the code alone.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/launcher/BUILD.bazel`
- `packages/launcher/README.md`
- `packages/slic3r-rust/crates/slic3r_cli/src/lib.rs`
- `packages/legacy-slic3r/package/common/shell.cpp`
- `packages/legacy-slic3r/package/win/package_win32.ps1`
- `docs/port/entrypoint-architecture.md`
- `docs/port/migration-guidance.md`
- `docs/port/package-map.md`
- `docs/port/parity-matrix.md`
- `docs/port/contract-inventory.md`

</canonical_refs>
