---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 52-2026-06-18T01-09-43
generated_at: 2026-06-18T01:11:16.536Z
---

# Phase 52: Executable Structural G-code Evidence - Context

**Gathered:** 2026-06-18
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 52 publishes the v1.13 structural Prusa G-code evidence as a public
Bazel parity command and updates the exact status/docs wording for the narrow
`fork.prusaslicer.gcode-output` slice. It consumes the Phase 49 closed
structural scope contract, the Phase 50 checked-in structural fixture summary,
and the Phase 51 pure Rust structural parser/readiness boundary.

The phase completes GCEV-01, GCEV-02, and GCEV-03 only. It must not claim
byte-for-byte G-code parity, broad generated-output parity, geometry/toolpath
parity, printability, printer-runtime behavior, support generation, wall seam
behavior, arc fitting, GUI export/viewer behavior, release behavior,
network/device behavior, non-Prusa fork behavior, upstream source imports, or
sync automation.
</domain>

<decisions>
## Implementation Decisions

### Public structural parity command

- **D-01:** Keep the public evidence surface in `packages/parity`, using the
  existing `//packages/parity:prusaslicer_gcode_output_parity` command as the
  maintainer-facing entry point unless planning finds a lower-risk adjacent
  structural target that preserves the same status token.
- **D-02:** The public command must validate both the original
  `expected-gcode-summary.tsv` evidence and the Phase 50
  `expected-gcode-structural-summary.tsv` evidence through Rust-owned parsing
  boundaries, rather than trusting TSV bytes or fixture verifier output alone.
- **D-03:** Command output should make the structural evidence visible with
  maintainer-readable lines for the structural summary path, structural row
  count, source identity, fixture identity, command counts, ordered markers,
  movement/extrusion indicators, and temperature/tool-change marker counts.
- **D-04:** Keep executable evidence narrow: the command proves that the
  checked-in structural expected summary matches the pure Rust boundary and
  reviewed fixture expectations. It does not generate fresh G-code or compare
  PrusaSlicer runtime output.

### Structural mutation guard

- **D-05:** Extend the existing
  `prusaslicer_gcode_output_parity_failure_test` mutation coverage to include
  a structural-summary drift case, not only the v1.12 `line_4` summary marker
  drift case.
- **D-06:** The structural mutation guard should mutate one meaningful
  structural value from `expected-gcode-structural-summary.tsv`, expect the
  public comparator to fail, and assert diagnostics naming the structural
  artifact and the drifted structural field.
- **D-07:** Prefer one focused command-level structural drift test for GCEV-02;
  do not duplicate all Phase 50 fixture-verifier or Phase 51 Rust parser
  rejection classes in the parity package.

### Status and documentation publication

- **D-08:** Update the `fork.prusaslicer.gcode-output` status row and parity
  docs from summary-only wording to narrow structural evidence wording while
  preserving the exact status token and public Bazel command.
- **D-09:** Keep the broad `generated-outputs` row exactly `in progress`.
  Phase 52 may make the narrow Prusa G-code slice more meaningful, but it must
  not promote broad generated-output parity.
- **D-10:** Update package and port docs only where needed to describe the
  structural evidence chain: Phase 49 scope, Phase 50 structural fixture,
  Phase 51 Rust parser/readiness, and Phase 52 public executable evidence.
- **D-11:** Public docs must keep deferred surfaces explicit, including
  byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, STEP import, full 3MF import/export, GUI behavior, binary G-code,
  thumbnails, post-processing, host upload, network/device integration,
  profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, release behavior, and sync automation.

### Lifecycle and verification

- **D-12:** Verification for this phase should include the public Bazel parity
  command, the parity failure mutation test, the Rust flavor tests that own the
  structural parser/readiness boundary, and relevant fixture/scope verifiers
  when touched by the implementation.
- **D-13:** Because this phase touches a Rust workspace before final commit,
  run the Rust pre-commit sequence from repo instructions when Rust files are
  changed: `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`,
  `cargo build --all-targets --all-features`, and `cargo test --all-features`
  from the relevant Cargo workspace, plus the repo-owned Bazel checks for the
  changed targets.

### the agent's Discretion

- Choose whether the Rust summary binary gains a structural mode, a second
  binary is added, or the comparator invokes existing Rust APIs through the
  clearest local pattern, provided the public command validates structural data
  through Rust and remains easy to diagnose.
- Choose exact Bash helper boundaries in
  `packages/parity/compare_prusaslicer_gcode_output.sh` and its test, as long
  as the script remains fail-closed, readable, and consistent with the existing
  parity package style.
- Choose the minimal docs touched to publish the structural evidence without
  broad rewrites.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 52 goal, dependency, requirements, and
  success criteria.
- `.planning/REQUIREMENTS.md` - GCEV-01, GCEV-02, GCEV-03, and the v1.13
  out-of-scope boundary.
- `.planning/PROJECT.md` - v1.13 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated decisions.
- `.planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md` -
  locked structural scope and no-overclaiming decisions.
- `.planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md` -
  locked structural fixture artifact, schema, values, and mutation scope.
- `.planning/phases/51-rust-structural-g-code-summary-boundary/51-CONTEXT.md` -
  locked Rust parser/readiness decisions and Phase 52 deferrals.
- `.planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md`
  - proof that Phase 51 parser/readiness verification passed.

### Existing public parity surface

- `packages/parity/BUILD.bazel` - public parity command and mutation-test
  targets to extend for structural evidence.
- `packages/parity/compare_prusaslicer_gcode_output.sh` - existing summary-only
  public comparator that Phase 52 must extend or wrap.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh` - existing
  command-level mutation guard to extend with structural drift coverage.
- `packages/parity/status.tsv` - checked-in status row source that must publish
  the narrow structural wording while keeping broad `generated-outputs` in
  progress.
- `packages/parity/README.md` - package docs for public parity commands and
  fork status rows.

### Structural fixture and scope inputs

- `packages/parity-fixtures/BUILD.bazel` - Bazel labels for the Prusa G-code
  summary, structural summary, provenance, and bundle artifacts.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - original summary-only expected artifact that must keep passing.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - Phase 50 structural summary artifact that the public command must validate.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - source identity, fixture identity, update route, and deferral metadata.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`
  - checked-in selected fixture bytes.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture-scope text and Phase 52 publication boundary.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - Phase 50
  fixture verifier, useful for structural artifact expectations.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` -
  fixture-level mutation coverage pattern.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - closed v1.13
  structural field contract and no-overclaiming boundary.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` -
  status, scope, and no-overclaiming verifier patterns.

### Rust structural boundary

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  Rust summary and structural parser/readiness implementation.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  - current CLI summary binary and likely Phase 52 integration point.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  Rust parser tests and structural rejection coverage.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` -
  registry/readiness tests for Prusa G-code structural metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Rust binary,
  test, compile data, clippy, and rustfmt wiring.
- `packages/slic3r-rust/Cargo.toml` - Rust workspace manifest for Cargo
  verification.

### Public docs

- `docs/port/parity-matrix.md` - public status matrix wording for generated
  outputs and Prusa G-code evidence.
- `docs/port/migration-guidance.md` - maintainer-facing migration guidance for
  the Prusa G-code evidence chain.
- `docs/port/package-map.md` - package ownership and evidence package
  descriptions.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `packages/parity/compare_prusaslicer_gcode_output.sh`: Existing public
  comparator already validates the summary-only TSV through the Rust summary
  binary, checks exact metadata fields, diffs actual versus expected summary
  lines, and prints maintainer-readable success output.
- `packages/parity/compare_prusaslicer_gcode_output_test.sh`: Existing
  mutation harness copies the expected artifact, mutates a meaningful value,
  expects failure, and asserts diagnostic text.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`:
  Phase 51 already added dependency-free structural parsing and typed readiness
  metadata.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`:
  Current CLI binary is summary-only and small enough to extend or mirror for
  structural output.
- `packages/parity-fixtures/BUILD.bazel`: Already exports
  `prusa_gcode_output_expected_gcode_structural_summary` for Bazel data wiring.

### Established Patterns

- Public parity evidence lives in `packages/parity` as Bazel `sh_binary`
  targets backed by checked-in fixtures and Rust helper binaries.
- Mutation tests for parity commands prove command-level fail-closed behavior,
  not every lower-level parser branch.
- Rust flavor boundaries stay pure and dependency-free. Shell comparators own
  command orchestration and diagnostics.
- Status/docs wording is conservative: exact narrow rows can be verified, while
  broad surfaces stay in progress until much broader executable evidence exists.

### Integration Points

- Update the `prusaslicer_gcode_output_parity` target data/args if the
  comparator needs the structural summary artifact or an additional Rust
  structural summary binary.
- Extend the command-level failure test with a structural-summary mutation and
  include the structural artifact in Bazel test data.
- Update `packages/parity/status.tsv`, `packages/parity/README.md`, and port
  docs to say the narrow Prusa G-code row is structural evidence, not
  summary-only evidence.
</code_context>

<specifics>
## Specific Ideas

- Keep the exact public target name `//packages/parity:prusaslicer_gcode_output_parity`
  unless planning identifies a clearer adjacent target that still satisfies the
  existing status-token contract.
- Keep the exact structural artifact name
  `expected-gcode-structural-summary.tsv`.
- A good structural drift mutation is changing `command_count_g1` from `4` to
  another value or changing one ordered marker; the diagnostic should name the
  structural field instead of reporting only a generic line mismatch.
- Success output should be concrete enough for maintainers to see that Phase 52
  strengthened the evidence path without implying a generated-output runtime
  comparison.
</specifics>

<deferred>
## Deferred Ideas

- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, STEP import, full 3MF import/export, GUI behavior, binary G-code,
  thumbnails, post-processing, host upload, network/device integration,
  profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, release behavior, and sync automation
  remain out of scope.
- Broader `generated-outputs` verification remains future work after multiple
  reviewed generated-output surfaces have executable evidence.
</deferred>

---

*Phase: 52-executable-structural-g-code-evidence*
*Context gathered: 2026-06-18*
