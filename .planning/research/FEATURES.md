# v1.11 Feature Research: PrusaSlicer Broader Parity Port

**Project:** Slic3r Rust Port
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Researched:** 2026-06-02

## Recommended Feature Slice

Use `prusaslicer.project-file` as the primary v1.11 slice. It is the best next
candidate because the inventory marks it as medium complexity, file-format
dependent, and shared-downstream, and because it broadens beyond the v1.10
profile/config parser without jumping directly into generated-output geometry
or runtime GUI behavior.

## Table Stakes

v1.11 should deliver these user-visible outcomes:

- Maintainers can inspect a reviewed Prusa project-file checklist record tied
  to the accepted Prusa source pin.
- Maintainers can inspect checked-in Prusa project-file fixture artifacts with
  provenance, update rules, and explicit non-overclaiming scope.
- Developers can use a typed Rust boundary that summarizes the selected
  project-file fixture data without raw vendor strings leaking into core code.
- Maintainers can run a repo-owned Bazel parity command for the exact selected
  project-file evidence slice.
- Maintainers can see the parity command fail when the Rust-backed summary or
  checked-in expected artifact diverges.
- Docs and status rows distinguish the verified project-file evidence slice
  from full PrusaSlicer runtime support, GUI support, STEP import, support
  generation, arc fitting, wall seam behavior, network/device integration,
  profile auto-update execution, fork release builds, and sync automation.

## Candidate Comparison

| Candidate | Inventory row | Complexity | Dependency | Recommendation |
|-----------|---------------|------------|------------|----------------|
| Project-file evidence | `prusaslicer.project-file` | Medium | File formats | Select for v1.11. |
| STEP import | `prusaslicer.step-import` | Medium | File formats | Defer until project-file fixture discipline exists. |
| Arc fitting | `prusaslicer.arc-fitting` | Medium | Generated outputs | Defer; needs G-code output comparison evidence. |
| Wall seam | `prusaslicer.wall-seam` | Medium | Generated outputs | Defer; needs geometry/output fixtures. |
| Support generation | `prusaslicer.support-generation` | High | Generated outputs | Defer; higher algorithmic and fixture risk. |
| Network/device | `prusaslicer.network-device` | High | None | Keep deferred for licensing, privacy, and credential review. |

## v1.11 Differentiators

- It should promote one broader Prusa slice from future-candidate planning to
  executable evidence.
- It should demonstrate that the v1.10 evidence pattern works for a
  file-format-facing Prusa capability, not only for profile/config text.
- It should avoid claims that require upstream PrusaSlicer runtime behavior,
  GUI flows, online services, or generated-output equivalence.

## Explicit Deferrals

Do not include these in v1.11 requirements:

- Full PrusaSlicer runtime or GUI support.
- STEP import, support generation, arc fitting, and wall seam parity.
- Bambu Studio or OrcaSlicer behavior.
- Fork-flavor release builds and cross-flavor CI automation.
- Vendor source sync automation or automatic accepted-pin refresh.
- Network/cloud/device communication, credentials, profile auto-update
  execution, or non-free plugin ingestion.
