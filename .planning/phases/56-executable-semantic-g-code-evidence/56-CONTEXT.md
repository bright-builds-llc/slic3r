---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 56-2026-06-21T16-41-17
generated_at: 2026-06-21T16:55:00Z
---

# Phase 56: Executable Semantic G-code Evidence - Context

**Gathered:** 2026-06-21
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 56 publishes the v1.14 semantic Prusa G-code evidence through the
existing public parity path. Maintainers should be able to run the public
Prusa G-code parity command and see marker summary, structural summary, and
semantic summary artifacts validated through the Rust boundary, with
fail-closed semantic mutation guards and exact status/docs wording.

The phase completes GSEV-01, GSEV-02, and GSEV-03 only. It must not claim
byte-for-byte G-code parity, broad `generated-outputs` verification,
printability, printer-runtime behavior, firmware behavior, support generation,
wall seam behavior, arc fitting, GUI behavior, release behavior, upstream
source imports, sync automation, or non-Prusa fork behavior.
</domain>

<decisions>
## Implementation Decisions

### Public command integration

- **D-01:** Keep the public evidence command as
  `bazel run //packages/parity:prusaslicer_gcode_output_parity`. Phase 56
  should extend this existing command instead of creating a companion command,
  preserving the Phase 48/52 public contract.
- **D-02:** Extend
  `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  with a `--semantic expected-gcode-semantic-summary.tsv` mode that calls the
  existing pure Rust semantic parser/summary surface. Keep the existing
  one-path marker mode and `--structural` mode stable.
- **D-03:** Extend
  `packages/parity/compare_prusaslicer_gcode_output.sh` to accept the semantic
  Rust input and expected semantic artifact after the structural arguments,
  validate both through the Rust binary, diff Rust output against expected
  semantic summary lines, and print semantic facts in the success output.
- **D-04:** Update `packages/parity/BUILD.bazel` so
  `prusaslicer_gcode_output_parity` and its failure test include
  `//packages/parity-fixtures:prusa_gcode_output_expected_gcode_semantic_summary`.
  Keep the target name unchanged.

### Semantic mutation guards

- **D-05:** Extend `packages/parity/compare_prusaslicer_gcode_output_test.sh`
  with focused semantic mutation cases that prove public evidence fails closed
  for movement class changes, coordinate-bound changes, extrusion-total
  changes, feedrate observation changes, fixture identity drift, and unsupported
  deferred-behavior claims.
- **D-06:** Each mutation test should alter only a copied temp artifact and
  assert a useful diagnostic mentioning `expected-gcode-semantic-summary.tsv`
  and the specific semantic field, such as `movement_class_counts`,
  `coordinate_bounds`, `extrusion_total`, `feedrate_observations`, or
  `fixture_id`.
- **D-07:** Keep marker and structural mutation guards intact. The semantic
  guards are additive; they should not weaken the existing `line_4` marker
  drift guard or `command_count_g1` structural drift guard.

### Status publication

- **D-08:** Update `packages/parity/status.tsv` only after public semantic
  evidence and mutation guards pass. The existing
  `fork.prusaslicer.gcode-output` row may remain `verified`, but its note must
  name the narrow semantic evidence slice backed by Phase 53 scope, Phase 54
  semantic fixture summary, Phase 55 Rust semantic parser/readiness boundary,
  and Phase 56 public parity command.
- **D-09:** Keep the broad `generated-outputs` row exactly `in progress`.
  Phase 56 strengthens a single fork-specific G-code evidence slice, not the
  broad generated-output surface.
- **D-10:** Reconcile fixture and scope verifier enforcement so stale
  structural-only status/docs wording fails closed where package verifiers own
  that boundary, without causing the semantic artifact itself to overclaim.

### Documentation publication

- **D-11:** Update `packages/parity/README.md` to describe the public Prusa
  G-code parity command as marker + structural + semantic expected-summary
  evidence, backed by the existing Rust summary binary.
- **D-12:** Update `packages/prusa-gcode-output-scope/gcode-output-scope.md`
  and `packages/prusa-gcode-output-scope/README.md` from planned semantic
  publication wording to actual Phase 56 semantic publication wording while
  preserving all deferred surfaces.
- **D-13:** Update fixture and package docs only where necessary to point to
  the public semantic command and status row. Avoid reworking fixture
  provenance values or changing the Phase 54 expected semantic artifact.
- **D-14:** Update public port docs, especially `docs/port/package-map.md`,
  `docs/port/parity-matrix.md`, and `docs/port/migration-guidance.md`, so they
  describe the exact narrow semantic evidence slice and keep broad
  `generated-outputs` in progress.

### Verification and phase closeout

- **D-15:** Plan verification should include the focused public parity command,
  the parity failure test, the fixture verifier, the scope verifier, relevant
  Rust parser/binary tests, package/doc drift checks, summary extraction, and
  `git diff --check` over changed files.
- **D-16:** Because this is a Rust-touching phase, commits must follow the
  repo's Rust pre-commit gate where applicable: `cargo fmt --all`, clippy,
  build, and tests through the repo's Rust manifest, plus the relevant Bazel
  targets.

### the agent's Discretion

- Choose the exact semantic summary-line field names printed by the Rust
  binary, provided they are narrow, stable, and easy for the public comparator
  to assert.
- Choose whether the comparator shares structural helper functions for semantic
  mismatch labels or adds semantic-specific helpers, provided diagnostics stay
  specific and Bash remains readable.
- Choose the exact plan split across the five roadmap plans, provided the
  sequence preserves command integration, mutation guards, status publication,
  package/scope docs, and public port docs as separate reviewable steps.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 56 goal, dependency, requirements, planned
  plans, and success criteria.
- `.planning/REQUIREMENTS.md` - GSEV-01, GSEV-02, GSEV-03, and the v1.14
  out-of-scope boundary.
- `.planning/PROJECT.md` - v1.14 milestone goal, current state, and
  non-overclaiming generated-output constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa G-code
  evidence-chain decisions.
- `.planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md` - locked
  semantic scope contract, planned public command, and deferred surfaces.
- `.planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md` - locked
  semantic fixture artifact shape and mutation expectations.
- `.planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md` -
  evidence that the semantic fixture corpus and fixture mutation guards passed.
- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-CONTEXT.md` -
  locked Rust semantic parser/readiness decisions.
- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-01-SUMMARY.md`
  - parser boundary files, tests, and verification from Plan 55-01.
- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-02-SUMMARY.md`
  - semantic readiness metadata and status-restraint verification from Plan
  55-02.
- `.planning/phases/55-rust-semantic-g-code-summary-boundary/55-VERIFICATION.md`
  - evidence that Phase 55 passed and Phase 56 remains the publication step.

### Public parity command surface

- `packages/parity/BUILD.bazel` - current
  `prusaslicer_gcode_output_parity` target and failure-test data wiring.
- `packages/parity/compare_prusaslicer_gcode_output.sh` - current marker and
  structural comparator to extend with semantic validation.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh` - current marker
  and structural mutation harness to extend with semantic drift cases.
- `packages/parity/status.tsv` - broad `generated-outputs` and narrow
  `fork.prusaslicer.gcode-output` status rows.
- `packages/parity/README.md` - public parity package docs for the Prusa
  G-code command.

### Rust semantic boundary

- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  - summary binary that currently supports default marker mode and
  `--structural`; Phase 56 should add `--semantic`.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  pure marker, structural, semantic parser/readiness boundary and expected
  semantic facts.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  Rust parser and summary-binary coverage to extend for semantic mode.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry/readiness/status restraint coverage relevant to publication wording.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Rust binary,
  compile-data, clippy, rustfmt, and test targets.
- `packages/slic3r-rust/Cargo.toml` - Rust workspace manifest for Cargo
  verification.

### Fixture and scope inputs

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - original marker summary artifact.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - Phase 50 structural summary artifact.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`
  - Phase 54 semantic summary artifact consumed by public evidence.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - accepted source identity, fixture identity, source literal, checksum,
  update route, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace and semantic artifact documentation.
- `packages/parity-fixtures/BUILD.bazel` - semantic fixture alias and bundle
  wiring.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - fixture
  verifier that should remain aligned with public semantic evidence.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` -
  fixture-level semantic mutation coverage.
- `packages/parity-fixtures/README.md` - package-level fixture boundary.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - approved
  semantic field list and publication/deferred boundary.
- `packages/prusa-gcode-output-scope/README.md` - scope package public
  verification command and boundary.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  scope verifier that should remain fail-closed after semantic publication.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
  - scope mutation tests.

### Public port docs

- `docs/port/package-map.md` - package ownership and phase history.
- `docs/port/parity-matrix.md` - public generated-output and fork evidence
  wording.
- `docs/port/migration-guidance.md` - maintainer-facing migration guidance for
  Prusa G-code evidence boundaries.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `compare_prusaslicer_gcode_output.sh` already runs the Rust summary binary
  over marker and structural artifacts, diffs Rust-generated summary lines,
  asserts key facts, and prints a compact success report.
- `compare_prusaslicer_gcode_output_test.sh` already has temp-copy mutation
  helpers for marker drift and structural `command_count_g1` drift.
- `prusa_gcode_output_summary.rs` is a thin imperative shell around pure
  parser functions; adding `--semantic` should follow the existing
  `--structural` pattern.
- `prusa_gcode_output.rs` already exposes
  `parse_prusa_gcode_output_semantic_summary`, semantic facts, expected
  semantic summary path, readiness metadata, and deferred surface wording.
- `packages/parity-fixtures/BUILD.bazel` already exports and aliases the
  semantic summary artifact for Bazel consumers.

### Established Patterns

- The public evidence ladder is additive: marker summary, structural summary,
  semantic summary, then status/docs publication for the same narrow
  `fork.prusaslicer.gcode-output` slice.
- Public parity shell comparators validate checked-in fixtures through Rust
  parser binaries, then assert exact status/provenance facts and print a
  maintainer-readable summary.
- Mutation tests use isolated temp files and fail closed on one drift concern
  at a time.
- Public status/docs updates are conservative and must keep broad
  `generated-outputs` in progress until a much wider generated-output evidence
  surface exists.

### Integration Points

- Plan 56-01 should wire semantic mode into the Rust binary and public parity
  comparator.
- Plan 56-02 should extend public mutation guards for semantic drift classes.
- Plan 56-03 should publish exact semantic status wording and reconcile
  verifier enforcement.
- Plan 56-04 should update package/scope docs for the semantic evidence chain.
- Plan 56-05 should update port docs while preserving broad generated-output
  restraint.
</code_context>

<specifics>
## Specific Ideas

- Public success output should say semantic evidence, not generated-output
  parity. It can include `semantic_rows: 9`, the exact feedrate observations,
  `movement_class_counts`, `coordinate_bounds`, `extrusion_total`, and
  `layer_marker_relationships` facts.
- The semantic summary binary mode should be explicit (`--semantic`) so marker,
  structural, and semantic artifact validation remain visually distinct in
  shell scripts and diagnostics.
- The fixture has only four feedrate-only commands and no coordinate axes,
  extrusion axis, or layer markers; public semantic evidence should repeat
  those narrow observations instead of implying richer toolpath comparison.
</specifics>

<deferred>
## Deferred Ideas

- Byte-for-byte G-code parity, broad generated-output verification,
  geometry/toolpath parity, printability, printer-runtime behavior, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, GUI behavior, binary G-code, thumbnails, post-processing,
  host upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, release
  behavior, and sync automation remain out of scope.
- Future generated-output feature slices such as support generation, seam
  behavior, and arc fitting should build on the semantic comparison machinery
  only after explicit future planning decisions.
</deferred>

---

*Phase: 56-executable-semantic-g-code-evidence*
*Context gathered: 2026-06-21*
