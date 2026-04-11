---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 22-2026-04-11T21-28-35
generated_at: 2026-04-11T21:28:35Z
---

# Phase 22: Linux Shared Parity Evidence - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Verify the supported Linux Rust-backed runtime slice through shared parity
evidence. This phase adds a Linux runtime parity command and its fixture bundle
for representative help/version/config/export/transform flows. It does not yet
publish Linux validation state in `status.tsv` or the migration docs; that
visibility work belongs to Phase 23.

</domain>

<decisions>
## Implementation Decisions

### Evidence scope

- Add one Linux runtime parity command under `packages/parity` that exercises
  the preferred Linux launcher/runtime shim.
- Reuse the existing verified fixture corpora where the expected outputs are the
  same across launcher runtimes instead of duplicating help/version/config/
  export/transform expected files.
- Create a Linux-runtime fixture bundle and README so the parity command is
  reviewable without hidden local knowledge.

### Visibility boundaries

- Update package-local parity and fixture docs to mention the new Linux parity
  command and bundle.
- Do not update `packages/parity/status.tsv` or broader migration visibility
  docs in this phase; Linux validation-state publication is deferred to Phase 23.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

- `packages/launcher/BUILD.bazel`
- `packages/launcher/package/linux/startup_script.sh`
- `packages/launcher/package/linux/test_linux_launcher.sh`
- `packages/parity/BUILD.bazel`
- `packages/parity/README.md`
- `packages/parity-fixtures/BUILD.bazel`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/config-persistence/*`
- `packages/parity-fixtures/export-workflows/*`
- `packages/parity-fixtures/transform-workflows/*`

</canonical_refs>
