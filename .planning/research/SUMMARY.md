# v1.11 Research Summary: PrusaSlicer Broader Parity Port

**Project:** Slic3r Rust Port
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Researched:** 2026-06-02
**Recommendation:** Use Prusa project-file evidence as the first broader
PrusaSlicer parity slice after v1.10 profile/config evidence.

## Executive Summary

v1.11 should broaden PrusaSlicer parity by promoting
`prusaslicer.project-file` from source-observed future candidate to a narrow
executable evidence slice. This is the best next step because it extends the
v1.10 proof chain into file-format-facing Prusa behavior while avoiding the
higher-risk generated-output surfaces such as support generation, arc fitting,
and wall seam behavior.

The milestone should not claim full PrusaSlicer project load/save parity at the
start. Phase 41 should first define the exact project-file evidence contract:
which fixture source is acceptable, what expected artifact proves, what Rust
summary/parser boundary is needed, and which claims remain deferred.

## Recommended Roadmap Shape

1. **Phase 41: Prusa Project-File Scope Gate**
   Review and record the `prusaslicer.project-file` checklist, accepted source
   values, fixture source decision, expected-artifact contract, and deferred
   surfaces.
1. **Phase 42: Prusa Project-File Fixture Surface**
   Add the checked-in fixture namespace, provenance manifest, update rules,
   expected artifact, and fixture verification.
1. **Phase 43: Rust Prusa Project-File Boundary**
   Add side-effect-free typed Rust summary/parser logic and metadata
   traceability tests for the selected project-file evidence contract.
1. **Phase 44: Executable Prusa Project-File Parity**
   Add the public Bazel parity command, divergence guard, exact status row,
   and docs that keep broader Prusa behavior deferred.

## Key Decisions

- Select `prusaslicer.project-file` for v1.11.
- Continue phase numbering at Phase 41.
- Preserve the v1.10 trust chain: source-pinned fixture, typed Rust boundary,
  checked-in expected artifact, public Bazel command, negative failure guard,
  exact status row, docs, UAT, and security verification.
- Keep STEP import, support generation, arc fitting, wall seam behavior,
  network/device integration, profile auto-update execution, GUI/runtime
  support, fork release builds, Bambu Studio, OrcaSlicer, and vendor sync
  automation deferred.

## Inputs Used

- `.planning/PROJECT.md`
- `.planning/milestones/v1.10-REQUIREMENTS.md`
- `.planning/milestones/v1.10-ROADMAP.md`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`
- `packages/parity/status.tsv`
- `docs/port/parity-matrix.md`
- `docs/port/package-map.md`
