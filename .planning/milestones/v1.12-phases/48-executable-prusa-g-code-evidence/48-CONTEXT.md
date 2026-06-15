---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 48-2026-06-14T18-49-25
generated_at: 2026-06-14T18:49:25.281Z
---

# Phase 48: Executable Prusa G-code Evidence - Context

**Gathered:** 2026-06-14
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 48 publishes the executable evidence layer for the narrow
`prusaslicer.gcode-output` summary-only slice prepared by Phases 45 through 47.

Maintainers must be able to run
`bazel run //packages/parity:prusaslicer_gcode_output_parity`, see the command
fail when the Rust-backed summary or checked-in expected summary diverges, and
inspect the exact `fork.prusaslicer.gcode-output` status row plus public docs
that name the verified slice.

This phase must keep broad `generated-outputs` in progress and must not claim
byte-for-byte G-code parity, full generated-output parity, toolpath geometry,
extrusion, timing, support generation, wall seam behavior, arc fitting, STEP
import, full 3MF import/export, printer-runtime behavior, firmware or
printability behavior, GUI export or viewer behavior, binary G-code,
thumbnails, post-processing, host upload, network/device integration, profile
auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream
source imports, release behavior, or sync automation.

</domain>

<decisions>

## Implementation Decisions

### Executable Parity Command

- **D-01:** Add the public command
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` as the sole
  Phase 48 executable evidence command for this slice.
- **D-02:** Mirror the existing `prusaslicer_project_file_parity` command
  shape: a package-local `compare_prusaslicer_gcode_output.sh` shell wrapper in
  `packages/parity`, a Bazel `sh_binary`, and a small Rust summary binary under
  `packages/slic3r-rust/crates/slic3r_flavors/src/bin/` if no equivalent
  executable already exists.
- **D-03:** The command should run the Phase 47 Rust summary boundary against
  the checked-in
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  artifact and compare stable summary lines. It should not read raw G-code as a
  parser input, generate new G-code, run PrusaSlicer, fetch upstream source,
  run Git, inspect printers, or perform network/profile/release/sync behavior.
- **D-04:** Successful command output should identify the exact source ref,
  fixture path, expected summary path, and accepted row count while avoiding
  wording that implies runtime or byte-for-byte generated-output support.

### Fail-Closed Drift Guard

- **D-05:** Add a focused parity failure test, likely
  `packages/parity/compare_prusaslicer_gcode_output_test.sh`, wired as a Bazel
  `sh_test`, that mutates the expected summary or Rust-summary input and proves
  the parity command fails with a useful diff and mismatch label.
- **D-06:** The failure guard should cover the highest-risk drift path for this
  slice: Rust summary output and checked-in expected artifact divergence. The
  test may mirror the project-file mutation pattern, but the selected mutation
  should use G-code marker rows such as `line_1` through `line_4` or the
  `source_literal` marker so the failure is tied to Phase 46/47 evidence.
- **D-07:** Keep earlier scope and fixture verifiers aligned with Phase 48:
  after the parity target and status row exist, remove or narrow obsolete
  "Phase 48 absent" guards while preserving all broad-overclaim, source, and
  fixture integrity checks.

### Status Publication

- **D-08:** Add exactly one checked-in `packages/parity/status.tsv` row for
  `fork.prusaslicer.gcode-output` once the parity command passes.
- **D-09:** The row status should be `verified`, the evidence should be
  `//packages/parity:prusaslicer_gcode_output_parity`, and the notes must state
  that this is a narrow summary-only Prusa G-code evidence slice backed by the
  Phase 46 fixture and Phase 47 Rust summary boundary.
- **D-10:** Keep the broader `generated-outputs` row `in progress`. Do not
  fold the fork-specific G-code row into broad generated-output verification.

### Public Documentation

- **D-11:** Update the minimum public docs needed for discoverability and
  non-overclaiming consistency: `packages/parity/README.md`,
  `docs/port/parity-matrix.md`, `docs/port/README.md`, and any directly
  affected package-map or migration-guidance text discovered during planning.
- **D-12:** Docs should name the runnable command, exact status token, source
  identity, fixture namespace, expected summary artifact, and Rust summary
  boundary. They should also keep the same deferred-scope list used by prior
  G-code phases.
- **D-13:** Documentation should distinguish three facts clearly: Phase 46
  proves fixture surface integrity, Phase 47 proves typed summary parsing, and
  Phase 48 proves executable summary-only evidence/status wiring.

### Verification Scope

- **D-14:** Phase verification must include the new parity command, the new
  parity failure test, the existing G-code fixture verifier/test, the existing
  G-code scope verifier/test after guard reconciliation, relevant Rust
  format/clippy/build/test checks, and `git diff --check`.
- **D-15:** If a new Rust summary binary is added, include it in
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` clippy and
  rustfmt targets and validate through the aggregate
  `bazel test //packages/slic3r-rust:verify` surface when practical.

### the agent's Discretion

- The agent may choose the exact summary-binary file and function names, but
  they should follow `prusa_project_file_summary` naming and avoid claims
  broader than summary-only evidence.
- The agent may choose the exact mutation used by the failure test, provided it
  proves real divergence between Rust summary output and the checked-in
  expected artifact.
- The agent may update additional docs only when directly required to keep
  public status and package ownership text consistent.

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase Scope

- `.planning/ROADMAP.md` - Phase 48 goal, dependency on Phase 47, success
  criteria, and mapped requirements.
- `.planning/REQUIREMENTS.md` - `PGEV-01`, `PGEV-02`, `PGEV-03`, v1.12
  out-of-scope exclusions, and traceability.
- `.planning/PROJECT.md` - v1.12 milestone goal, current state, evidence
  ladder, and key decision to keep generated-output work summary-only.
- `.planning/STATE.md` - current phase position and prior G-code decisions.
- `.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md` - scope
  gate, planned command/status token, expected summary contract, and absence
  boundaries.
- `.planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md` - fixture
  namespace, provenance, expected summary, verifier, and Phase 48 handoff.
- `.planning/phases/47-rust-prusa-g-code-summary-boundary/47-CONTEXT.md` -
  Rust summary boundary, typed metadata, parser/summary output decisions, and
  Phase 48 handoff.
- `.planning/phases/47-rust-prusa-g-code-summary-boundary/47-VERIFICATION.md`
  - verified Phase 47 truths and explicit Phase 48 absence checks that must be
  reconciled in this phase.

### G-code Evidence Inputs

- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - accepted source
  identity, expected summary contract, reserved parity command, reserved status
  token, and deferred scope.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace boundary and non-overclaiming fixture language.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - byte count, hash, upstream source path, role, update route, and broad
  deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - exact summary TSV artifact that Phase 48 command must validate.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  Phase 47 pure Rust parser, metadata, and summary-line boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  positive, negative, and public-name guard tests for the G-code summary
  boundary.

### Existing Executable Patterns

- `packages/parity/compare_prusaslicer_project_file.sh` - closest executable
  parity command pattern for summary-only fork evidence.
- `packages/parity/compare_prusaslicer_project_file_test.sh` - closest
  mutation-style parity failure test pattern.
- `packages/parity/BUILD.bazel` - parity `sh_binary` and `sh_test` wiring.
- `packages/parity/status.tsv` - checked-in status vocabulary and row format.
- `packages/parity/README.md` - public command list and fork status wording.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs`
  - small Rust summary binary pattern.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Rust binary,
  clippy, rustfmt, and test wiring.

### Public Docs

- `docs/port/README.md` - public control-plane overview and parity visibility
  state.
- `docs/port/parity-matrix.md` - high-level status dashboard and fork parity
  interpretation.
- `docs/port/migration-guidance.md` - parity evidence and fixture evolution
  rules.
- `docs/port/package-map.md` - package ownership and route documentation.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `compare_prusaslicer_project_file.sh` already validates a summary binary,
  expected artifact, provenance file, stable summary lines, and row count while
  reporting useful mismatch labels and diffs.
- `compare_prusaslicer_project_file_test.sh` already demonstrates a focused
  mutation test that proves summary drift fails through the public comparator.
- `prusa_project_file_summary.rs` is a minimal Rust wrapper that reads one
  caller-provided TSV path, invokes a pure summary function, prints stable
  lines, and exits non-zero on parse errors.
- `prusa_gcode_output.rs` already exposes `prusa_gcode_output_summary_lines`,
  parser types, metadata, exact accepted row validation, and non-overclaiming
  public names.

### Established Patterns

- Fork-specific status rows become `verified` only after a real
  `//packages/parity:*_parity` command exists and passes.
- Broad status rows such as `generated-outputs` remain conservative even when
  a narrow fork-specific slice becomes verified.
- Prior phase verifiers reject only future artifacts that are still forbidden;
  once a planned boundary becomes real, obsolete absence guards are reconciled
  instead of left as blockers.
- Rust flavor summary binaries are thin imperative shells around pure
  `slic3r_flavors` functions.

### Integration Points

- Add or update `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`.
- Update `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` with the new
  binary and aggregate clippy/rustfmt coverage.
- Add `packages/parity/compare_prusaslicer_gcode_output.sh` and
  `packages/parity/compare_prusaslicer_gcode_output_test.sh`.
- Update `packages/parity/BUILD.bazel` with
  `prusaslicer_gcode_output_parity` and the matching failure test.
- Update `packages/parity/status.tsv`, `packages/parity/README.md`, and the
  relevant `docs/port/` files.
- Reconcile
  `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` and
  `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` if
  they still reject the now-owned Phase 48 artifacts.

</code_context>

<specifics>

## Specific Ideas

- Treat `fork.prusaslicer.gcode-output` as verified only for the exact
  summary-only evidence slice, not for generated-output behavior generally.
- Use the exact command name reserved since Phase 45:
  `bazel run //packages/parity:prusaslicer_gcode_output_parity`.
- Keep accepted marker rows tied to the Phase 46 literal feedrate lines:
  `G1 F99999.123`, `G1 F1`, `G1 F203.2`, and `G1 F203.201`.
- Prefer project-file parity as the implementation template because it is the
  closest prior summary-only fork evidence command.

</specifics>

<deferred>

## Deferred Ideas

Broader byte-for-byte G-code parity, full generated-output parity, toolpath
geometry, extrusion, timing, support generation, wall seam behavior, arc
fitting, STEP import, full 3MF import/export, printer-runtime behavior,
firmware or printability behavior, GUI export or viewer behavior, binary
G-code, thumbnails, post-processing, host upload, network/device integration,
profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
upstream source imports, release behavior, and sync automation remain outside
Phase 48.

</deferred>

______________________________________________________________________

*Phase: 48-executable-prusa-g-code-evidence*
*Context gathered: 2026-06-14*
