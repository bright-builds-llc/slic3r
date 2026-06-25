---
phase: 58-arc-fitting-fixture-corpus
verified: 2026-06-23T21:10:57Z
status: passed
score: "6/6 must-haves verified"
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 58-2026-06-23T19-50-26
generated_at: 2026-06-23T21:10:57Z
lifecycle_validated: true
overrides_applied: 0
---

# Phase 58: Arc-Fitting Fixture Corpus Verification Report

**Phase Goal:** Maintainers have a source-pinned arc-fitting fixture corpus and checked-in expected summaries constrained to the Phase 57 approved fields.
**Verified:** 2026-06-23T21:10:57Z
**Status:** passed
**Re-verification:** No - initial verification

Material guidance used: `AGENTS.md` repo-local guidance, `AGENTS.bright-builds.md`, `standards-overrides.md`, and pinned Bright Builds `standards/index.md`, `standards/core/verification.md`, `standards/core/testing.md`, `standards/core/code-shape.md`, and `standards/core/operability.md`.

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Maintainer can inspect a `prusaslicer.arc-fitting` fixture namespace with source-pinned provenance, update rules, fixture identity, expected arc summary paths, and explicit generator/runtime/network/sync/upload/post-processing/thumbnail/printability/GUI exclusions. | VERIFIED | Namespace contains `.gitattributes`, `README.md`, `arc-fitting-observations.gcode`, `expected-arc-summary.tsv`, and `fixture-provenance.tsv`. README and provenance pin `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, `src/libslic3r/Geometry/ArcWelder.cpp`, update route, fixture identity, and explicit exclusions. |
| 2 | Maintainer can inspect checked-in expected arc summaries that cover only the Phase 57 approved fields. | VERIFIED | `expected-arc-summary.tsv` has 13 lines, six columns per data row, and exactly the 12 approved fields in order: `source_ref`, `inventory_source_paths`, `source_anchor`, `fixture_id`, `fixture_path`, `arc_command_counts`, `arc_direction_counts`, `center_offset_observations`, `coordinate_bounds`, `extrusion_observations`, `feedrate_observations`, `evidence_boundary`. |
| 3 | Maintainer can run fixture verification that rejects missing rows, duplicate rows, out-of-order rows, unsupported arc fields, unsupported claim text, wrong source refs, wrong fixture identities, and stale documentation references. | VERIFIED | `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture` passed and printed `ok: Prusa arc-fitting fixture verification passed`; `bazel test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test` passed. Mutation tests cover all named ARCFIX-03 drift classes plus wrong fixture path, provenance mismatch, checksum drift, and forbidden verifier behavior. |
| 4 | Maintainer can inspect the new `prusaslicer.arc-fitting` namespace without widening the existing `prusaslicer.gcode-output` namespace or status meaning. | VERIFIED | Arc files live under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`; `packages/parity/status.tsv` still has one `generated-outputs` row as `in progress`, one `fork.prusaslicer.gcode-output` row, and zero `fork.prusaslicer.arc-fitting` rows. |
| 5 | Maintainer can inspect source-pinned provenance tied to the accepted Prusa source ref and `ArcWelder.cpp`. | VERIFIED | `fixture-provenance.tsv` row links `inventory_id=prusaslicer.arc-fitting`, peeled commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`, `source_path=src/libslic3r/Geometry/ArcWelder.cpp`, anchors `ArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634`, `bytes=94`, and SHA-256 `b1db8e3ef28d47f045f1eec852e4f83675da920b312abeeb3f3e40a5927f796f`. |
| 6 | Maintainer can confirm Phase 58 still does not publish public arc-fitting parity, Rust parser behavior, public docs, or a `fork.prusaslicer.arc-fitting` status row. | VERIFIED | `bazel query //packages/parity:prusaslicer_arc_fitting_parity` reports no such target; scan of `docs/port`, `packages/slic3r-rust`, and `packages/parity` found no public arc-fitting surface matches; package and namespace READMEs defer Phase 59/60 work. |

**Score:** 6/6 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/.gitattributes` | LF policy for G-code, TSV, README | VERIFIED | Contains exact LF text rules for `*.gcode`, `*.tsv`, and `README.md`. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md` | Namespace-local docs and Phase 58 boundary | VERIFIED | Names namespace, source ref/path, artifacts, update route, Phase 59/60 ownership, and exclusions. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode` | Small reviewed G2/G3 observation fixture | VERIFIED | 2 LF-terminated lines, 94 bytes, SHA-256 `b1db8e3ef28d47f045f1eec852e4f83675da920b312abeeb3f3e40a5927f796f`. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv` | Ordered Phase 57 field summary | VERIFIED | 13 lines; header plus one row for each approved Phase 57 field; all rows share the expected source ref and fixture path. |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/fixture-provenance.tsv` | Source-pinned provenance and update route | VERIFIED | 2 lines; exact provenance row includes inventory ID, source ref, commit, source path, anchors, byte count, SHA, exclusions, and deferrals. |
| `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` | Fail-closed fixture verifier | VERIFIED | Checks file presence, ASCII/LF, line counts, byte count, SHA, TSV headers/columns, allowed fields, uniqueness, exact ordered rows, provenance alignment, docs, overclaim text, and status boundaries. |
| `packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh` | Mutation coverage | VERIFIED | Contains focused tests for missing, duplicate, out-of-order, unsupported, wrong-source, wrong-fixture, stale-doc, provenance, checksum, overclaim, and verifier-behavior drift. |
| `packages/parity-fixtures/BUILD.bazel` | Bundle, aliases, verifier, test targets, package boundary | VERIFIED | Exposes `prusa_arc_fitting_*` aliases, `prusa_arc_fitting_bundle`, `verify_prusa_arc_fitting_fixture`, and `verify_prusa_arc_fitting_fixture_test`; includes scripts and fixture files in `package_boundary`. |
| `packages/parity-fixtures/README.md` | Package-level Phase 58 docs and command | VERIFIED | Documents namespace, bundle target, verifier command, source ref/path, status/doc/Rust deferrals, and existing G-code status boundary. |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `expected-arc-summary.tsv` | `packages/prusa-arc-fitting-scope/arc-fitting-scope.md` | Exact Phase 57 approved field order | VERIFIED | Phase 57 scope lists the 12 approved fields; expected summary contains exactly those fields in order and no extras. |
| `fixture-provenance.tsv` | `packages/fork-inventories/prusaslicer.tsv` | `inventory_id` and `source_ref` | VERIFIED | Inventory row `prusaslicer.arc-fitting` exists with the same source ref and `src/libslic3r/Geometry/ArcWelder.cpp`; provenance row uses that ID/source/path. |
| `BUILD.bazel` | Arc-fitting fixture files | Alias and bundle `srcs` | VERIFIED | `prusa_arc_fitting_readme`, `prusa_arc_fitting_provenance`, `prusa_arc_fitting_expected_arc_summary`, `prusa_arc_fitting_arc_observations`, and `prusa_arc_fitting_bundle` point at namespace files. |
| `BUILD.bazel` | `verify_prusa_arc_fitting_fixture.sh` | `sh_binary` `srcs` and data | VERIFIED | Target `verify_prusa_arc_fitting_fixture` uses the script and data `:prusa_arc_fitting_bundle`, `README.md`, and `//packages/parity:status.tsv`. |
| `verify_prusa_arc_fitting_fixture.sh` | `expected-arc-summary.tsv` | Default package-local fixture path and exact row checks | VERIFIED | Zero-argument mode resolves `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`; exact rows and values are hard-checked. |
| `verify_prusa_arc_fitting_fixture_test.sh` | `verify_prusa_arc_fitting_fixture.sh` | Temp-copy mutation harness | VERIFIED | `run_verifier` invokes the verifier with explicit fixture/readme/status paths; Bazel test passed. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|--------------------|--------|
| Arc fixture corpus | Static checked-in G-code/TSV rows | Repository files under `prusaslicer.arc-fitting` | Yes - exact bytes/rows verified by Bash and Bazel | VERIFIED |
| Verifier | File arguments/default package paths | Checked-in fixture, provenance, summary, README, status TSV | Yes - reads actual files and fails closed on drift | VERIFIED |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Fixture verifier accepts valid corpus | `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture` | Printed `ok: Prusa arc-fitting fixture verification passed` | PASS |
| Mutation suite covers drift classes | `bazel test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test` | Passed | PASS |
| Regression gate preserves adjacent scope/G-code checks | `bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test` | 3 tests pass | PASS |
| Schema drift gate | `node .../gsd-tools.cjs verify schema-drift 58` | `drift_detected: false` | PASS |
| Status rows remain bounded | `awk` over `packages/parity/status.tsv` | `generated-outputs=in progress`, one `fork.prusaslicer.gcode-output`, zero `fork.prusaslicer.arc-fitting` | PASS |
| Public parity target absent | `bazel query //packages/parity:prusaslicer_arc_fitting_parity` | Fails with no such target | PASS |
| Public docs/Rust/parity surfaces absent | `rg` scan of `docs/port`, `packages/slic3r-rust`, `packages/parity` | No public arc-fitting surface matches | PASS |
| Whitespace and Bash syntax | `git diff --check -- packages/parity-fixtures .planning/phases/58-arc-fitting-fixture-corpus`; `bash -n ...` | No output, exit 0 | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| ARCFIX-01 | 58-01, 58-02 | Inspect small reviewed source-pinned fixture corpus with update rules, identity, paths, and exclusions. | SATISFIED | Namespace files, README, provenance, fixture bytes/SHA, package docs, and verifier all confirm the fixture-only boundary. |
| ARCFIX-02 | 58-01, 58-02 | Inspect checked-in expected summaries covering only Phase 57 approved fields. | SATISFIED | `expected-arc-summary.tsv` has exactly the 12 approved rows/fields in order and is checked by the verifier. |
| ARCFIX-03 | 58-02 | Run fail-closed fixture verification rejecting drift classes and stale docs. | SATISFIED | Verifier and mutation suite are Bazel-wired and passing; tests cover the required failure classes. |

All Phase 58 requirement IDs in `REQUIREMENTS.md` are claimed by at least one PLAN frontmatter block. Both SUMMARY files use the repo-required `requirements-completed` key: 58-01 lists ARCFIX-01 and ARCFIX-02; 58-02 lists ARCFIX-01, ARCFIX-02, and ARCFIX-03.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` | 46 | ShellCheck `SC2034`: unused `PEELED_COMMIT` constant | Info | Non-blocking maintainability issue already reported by code review. The exact peeled commit is still verified through `PROVENANCE_ROW`, so goal achievement is not affected. |

The generic stub scan also matched `XXXXXX` inside the `mktemp` template in the mutation test; this is a false positive and not a placeholder implementation.

### Human Verification Required

None. The phase output is static fixtures, docs, Bazel wiring, and local verifier behavior; all goal-critical behavior is programmatically checkable.

### Gaps Summary

No gaps found. The phase delivers a source-pinned `prusaslicer.arc-fitting` fixture corpus, checked-in expected summaries constrained to the Phase 57 approved fields, fail-closed fixture verification with mutation coverage, and preserves the Phase 59/60 publication boundaries.

---

_Verified: 2026-06-23T21:10:57Z_
_Verifier: the agent (gsd-verifier)_
