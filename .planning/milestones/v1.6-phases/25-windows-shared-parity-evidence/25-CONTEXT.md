---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 25-2026-04-12T01-33-50
generated_at: 2026-04-12T01:33:50Z
---

# Phase 25: Windows Shared Parity Evidence - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Verify the supported Windows Rust-backed runtime slice through shared parity
evidence. This phase adds a Windows runtime parity command and its fixture
bundle for representative help/version/config/export/transform flows. It does
not yet publish Windows validation state in `status.tsv` or the broader
migration dashboard docs; that visibility work belongs to Phase 26.

</domain>

<decisions>
## Implementation Decisions

### Evidence scope

- Add one Windows runtime parity command under `packages/parity` that exercises
  the preferred Windows runtime target.
- Reuse the existing verified fixture corpora where the expected outputs are the
  same across launcher runtimes instead of duplicating help/version/config/
  export/transform expected files.
- Create a Windows-runtime fixture bundle and README so the parity command is
  reviewable without hidden local knowledge.

### Visibility boundaries

- Update the package-local parity and fixture docs to mention the new Windows
  runtime parity command and bundle.
- Update `docs/port/windows-launcher-slice.md` only enough to keep its Phase 25
  verification note accurate.
- Do not update `packages/parity/status.tsv` or the broader Windows validation
  state surfaces in this phase; that publication remains Phase 26 work.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/launcher/BUILD.bazel`
- `packages/launcher/package/win/test_windows_launcher.sh`
- `packages/parity/BUILD.bazel`
- `packages/parity/README.md`
- `packages/parity-fixtures/BUILD.bazel`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/config-persistence/*`
- `packages/parity-fixtures/export-workflows/*`
- `packages/parity-fixtures/transform-workflows/*`
- `docs/port/windows-launcher-slice.md`

</canonical_refs>
