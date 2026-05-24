# Phase 30: Packaging Visibility and Docs - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-05-23T13:21:45.967Z
**Phase:** 30-Packaging Visibility and Docs
**Mode:** Yolo
**Areas discussed:** Parity Status Publication, Documentation Scope, Traceability and Closeout

---

## Parity Status Publication

| Option | Description | Selected |
| --- | --- | --- |
| Split into platform-specific packaged-launcher rows | Publish `linux.packaged-launcher` and `windows.packaged-launcher`, each pointing to one exact evidence command. | yes |
| Keep one aggregate `launcher-packaging` row | Use a smaller table but risk broad or ambiguous packaging claims. | |
| Make `parity:status` run packaged parity targets live | Turn status into live verification, increasing runtime and brittleness. | |

**User's choice:** Yolo selected the recommended platform-specific status rows.
**Notes:** The selected approach mirrors existing `linux.runtime` and
`windows.runtime` status rows while avoiding AppImage/MSI/DMG/installer/release
claims.

---

## Documentation Scope

| Option | Description | Selected |
| --- | --- | --- |
| Minimal status/dashboard update | Update only the status dashboard and a few nearby docs. | |
| Scoped cross-doc publication pass | Align status data, parity matrix, contract inventory, migration guidance, platform docs, package docs, and fixture docs. | yes |
| Central cross-platform packaged-launcher page | Add or expand a canonical cross-platform packaged-launcher hub. | |
| Package-local-only boundary wording | Keep edits near launcher/parity packages. | |

**User's choice:** Yolo selected the scoped cross-doc publication pass.
**Notes:** This best satisfies `PVIS-02` because migration docs and package docs
both need stale deferred wording removed without creating broader release
claims.

---

## Traceability and Closeout

| Option | Description | Selected |
| --- | --- | --- |
| Minimal Phase 30 closeout metadata | Claim only Phase 30 PVIS requirements and avoid touching prior summaries. | |
| Phase 30 closeout plus explicit traceability verification | Prove 12/12 v1.7 requirements map to exactly one phase and preserve prior summary history. | yes |
| Strict summary-level dedupe repair | Retroactively change prior summary metadata to dedupe repeated IDs. | |

**User's choice:** Yolo selected explicit traceability verification.
**Notes:** Phase 30 should claim only `PVIS-01`, `PVIS-02`, and `PVIS-03`; do
not run `mdformat` over phase summaries.

---

## the agent's Discretion

- Choose the smallest coherent status/docs file set that removes stale
  deferred claims.
- Keep status and docs wording conservative and exact.
- Use repo-native verification commands and parser checks.

## Deferred Ideas

- A new cross-platform packaged-launcher documentation hub before v1.8.
- Signing, notarization, installers, AppImage, MSI, DMG, GUI packaging,
  release archives, native/cross-compiled release binaries, release-channel
  automation, broad bundled dependency layout, downstream fork vendoring, fork
  parity ports, and fork-flavor builds.
