# Feature Landscape

**Project:** Slic3r Rust Port
**Milestone:** v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice
**Domain:** narrow PrusaSlicer arc-fitting G-code evidence
**Researched:** 2026-06-23
**Confidence:** HIGH for repo feature shape and source anchors; MEDIUM for the
exact arc fixture bytes and final summary fields until the v1.15 scope contract
selects and reviews the concrete fixture.

## Executive Feature Position

v1.15 should prove `prusaslicer.arc-fitting` as a new, narrow, source-pinned
PrusaSlicer feature slice. It should not broaden the existing
`fork.prusaslicer.gcode-output` status row. The existing G-code row is the
dependency: v1.12-v1.14 already proved marker, structural, and semantic
expected-summary evidence for Prusa G-code. Arc fitting should reuse that
evidence ladder and publish only an arc-specific evidence claim after a new
scope contract, fixture surface, Rust boundary, parity command, mutation guard,
and docs/status wording are in place.

Recommended public names:

- Evidence slug: `prusaslicer.arc-fitting`
- Fixture namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`
- Expected artifact:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-fitting-summary.tsv`
- Rust boundary: `slic3r_flavors::prusa_arc_fitting`
- Public parity command:
  `bazel run //packages/parity:prusaslicer_arc_fitting_parity`
- Status token: `fork.prusaslicer.arc-fitting`

The slice should focus on observable arc-fitting G-code facts: configured
arc-fitting source identity, checked-in G2/G3 arc-command evidence, I/J
center-offset command shape, direction/count summaries, and narrow traceability
back to the accepted PrusaSlicer source pin. It should not claim full
ArcWelder algorithm equivalence, byte-for-byte generated-output parity,
printability, firmware behavior, GUI behavior, support generation, wall seam
behavior, or non-Prusa fork behavior.

## Table Stakes

Features maintainers should expect. Missing these would make the milestone too
weak to support credible requirements or roadmap planning.

| Feature | Why Expected | Complexity | Notes |
| --- | --- | --- | --- |
| Reviewed `prusaslicer.arc-fitting` scope contract | v1.12-v1.14 all start with a reviewed G-code scope contract before fixtures, Rust parsing, or status claims. | Low | Add arc fitting to the existing scope discipline, but use the inventory row `prusaslicer.arc-fitting` instead of extending `prusaslicer.gcode-output` as if broad G-code output were complete. |
| Source identity tied to the Prusa inventory row | The local inventory already identifies `prusaslicer.arc-fitting` as a medium-complexity generated-output candidate sourced from `src/libslic3r/Geometry/ArcWelder.cpp`. | Low | The scope contract should require the accepted source ref `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, inventory row, category-map row `arc.shared`, and source path. |
| Companion source anchors for command emission | Arc fitting is not just the algorithm file; public G-code evidence depends on how Prusa emits arcs. | Medium | Cite `ArcWelder.hpp` for center/angle helpers, `GCode.cpp` for the G2/G3 I/J emission path, `PrintConfig.cpp` for `arc_fitting` values, and `tests/libslic3r/test_arc_welder.cpp` as deterministic source-controlled arc examples. |
| Arc-specific fixture namespace | Existing fixture rules group fork fixtures by inventory id or stable slug. | Low | Use `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` rather than adding arc files into the existing `prusaslicer.gcode-output` fixture namespace. |
| Small checked-in arc G-code fixture | The milestone goal is G-code evidence, not source-code metadata only. | Medium | The fixture should be ASCII/LF, source-pinned, and contain at least one arc command (`G2` or `G3`) using I/J center offsets plus enough neighboring movement context for a Rust parser to classify the command. |
| Fixture provenance manifest | v1.12-v1.14 require provenance before expected summaries are trusted. | Low | Record source ref, source paths, upstream URLs, byte count, SHA-256, line ending/encoding, fixture role, update route, privacy/post-processing exclusions, and broad deferrals. |
| Arc expected-summary artifact | The Rust boundary needs a reviewed schema, not raw fixture interpretation by convention. | Medium | Suggested fields: `source_ref`, `fixture_path`, `arc_field`, `arc_category`, `arc_value`, and `evidence_boundary`. Approved rows should cover source identity, fixture identity, config value `emit_center`, command counts for G2/G3/G1, I/J offset presence, direction counts, coordinate/extrusion/feedrate observations, and explicit deferred claims. |
| Pure Rust arc summary boundary | Bright Builds and existing Prusa evidence prefer parsing at boundaries into typed, side-effect-free domain values. | Medium | Implement `parse_prusa_arc_fitting_summary`, `prusa_arc_fitting_metadata`, and `prusa_arc_fitting_summary_lines` in `slic3r_flavors`; keep file I/O in a thin binary adapter only. |
| Reuse existing G-code semantic concepts | Arc fitting builds on the v1.14 parser vocabulary for command classes, movement classes, coordinate bounds, extrusion totals, and feedrate observations. | Medium | Extend by composition or parallel arc-specific types. Do not copy broad parser logic into a second inconsistent implementation. |
| Registry/readiness metadata | v1.9-v1.14 expose fork feature readiness through static metadata before public status claims. | Low | Metadata should trace `prusaslicer.arc-fitting` to source ref, inventory/category rows, fixture namespace, expected summary, Rust boundary, planned command, planned status token, and deferred surfaces. |
| Fail-closed scope verifier | The arc scope must reject unsupported source paths, duplicate/missing field rows, unsupported claim text, and status/docs drift. | Medium | Require exact one-row `generated-outputs` status as `in progress`; reject wording that says broad G-code parity, full generated-output parity, printability, firmware/runtime behavior, GUI behavior, support, seam, Bambu, Orca, release, upstream import, or sync is verified. |
| Fail-closed fixture verifier | The fixture package must catch missing rows, duplicate rows, stale docs, wrong source refs, unsupported fields, and provenance drift before parity evidence consumes it. | Medium | Reuse the `verify_prusa_gcode_output_fixture` pattern, but add an arc-specific verifier target rather than weakening the existing G-code fixture verifier. |
| Public parity command | Fork status rows become verified only after a rerunnable `//packages/parity:*_parity` command exists. | Medium | Add `//packages/parity:prusaslicer_arc_fitting_parity` to validate checked-in expected arc summaries through Rust and print only narrow arc evidence facts. |
| Mutation guards for arc drift | v1.12-v1.14 require public evidence to fail when checked facts drift. | Medium | At minimum mutate G2/G3 command counts, I/J offset presence, arc direction, source identity, fixture identity, and unsupported claim text. |
| Exact status/docs wording | Public docs are part of the parity contract. | Low | Add `fork.prusaslicer.arc-fitting` only after executable evidence passes. Keep `generated-outputs` in progress and keep `fork.prusaslicer.gcode-output` limited to the v1.14 semantic G-code evidence slice. |

## Differentiators

Features that make this milestone stronger than a generic G-code parser slice.

| Feature | Value Proposition | Complexity | Notes |
| --- | --- | --- | --- |
| Separate arc status token | Prevents maintainers from confusing an arc-specific feature slice with broad G-code output verification. | Low | `fork.prusaslicer.arc-fitting` should be the achieved row; `fork.prusaslicer.gcode-output` remains the prerequisite evidence chain. |
| Source-to-command traceability | Arc evidence is credible only if it ties algorithm, config, and G-code emission together. | Medium | The scope should connect `ArcWelder.cpp`, `ArcWelder.hpp`, `GCode.cpp`, `PrintConfig.cpp`, and `test_arc_welder.cpp` instead of citing only the inventory row. |
| I/J center-offset summary | Prusa's enabled arc-fitting config is `emit_center`, so I/J shape is the most useful narrow G-code command evidence. | Medium | Count I/J offset presence and reject unsupported R-radius mode claims unless a future scope explicitly adds them. |
| Positive and negative evidence | A positive arc fixture proves the parser sees arc commands; a no-arc or line fallback fixture proves the comparator rejects false positives. | Medium | The MVP can start with one positive fixture plus mutation guards. A small negative/control fixture is a useful differentiator if it stays source-pinned. |
| Arc direction classification | Distinguishing G2 and G3 makes the evidence more meaningful than a generic "contains arc command" check. | Medium | Keep direction classification syntactic unless the scope deliberately allows derived center/angle checks. |
| Reuse of semantic G-code parser lessons | v1.15 can avoid a rewrite because v1.14 already established command/movement/feedrate summary boundaries. | Low | The roadmap should explicitly depend on Phase 56 rather than rediscover marker/structural/semantic fixture mechanics. |
| Arc-specific non-overclaiming lexicon | The highest risk is publishing arc evidence as printability or generated-output parity. | Low | Verifiers should reject broad terms in achieved wording, not just rely on reviewer memory. |

## Anti-Features

Features to explicitly avoid in v1.15.

| Anti-Feature | Why Avoid | What to Do Instead |
| --- | --- | --- |
| Promoting broad `generated-outputs` to `verified` | One source-pinned arc slice still does not prove full generated-output behavior. | Keep `generated-outputs` exactly `in progress`. |
| Rewording `fork.prusaslicer.gcode-output` as arc evidence | That row is already verified for the narrow v1.14 semantic G-code evidence chain. | Add a separate `fork.prusaslicer.arc-fitting` row after arc evidence passes. |
| Byte-for-byte G-code parity | Byte equality would imply a much broader generator oracle and a larger controlled corpus. | Compare typed expected arc summary rows only. |
| Full ArcWelder algorithm equivalence | Reimplementing or proving least-squares fitting, tolerance behavior, and all fallback paths is too broad for this evidence slice. | Prove source-pinned observable G-code arc facts and defer algorithm-equivalence claims. |
| Printer firmware or printability claims | G2/G3 commands require firmware interpretation and physical-printer behavior outside this repo's current evidence model. | State that firmware/runtime/printability behavior remains deferred. |
| Live PrusaSlicer generation in Bazel | Building/running upstream PrusaSlicer would add toolchain, runtime, sync, and provenance risk. | Use reviewed checked-in fixtures and source-pinned provenance. |
| GUI arc-setting behavior | The config UI is not part of this CLI/G-code evidence slice. | Cite `PrintConfig.cpp` only for accepted config values and keep GUI behavior deferred. |
| Support generation or wall seam parity | These are separate generated-output feature slices with their own geometry and output risks. | Keep support and seam deferred; let them reuse the pattern after arc fitting ships. |
| Bambu Studio or OrcaSlicer arc fitting | Category map shows arc fitting as shared downstream, but active fork work is Prusa-only. | Keep non-Prusa forks parked until an explicit planning decision reopens them. |
| Upstream source import or sync automation | Source pins are planning inputs, not vendored runtime code or automated update policy. | Keep update route reviewer-gated and fixture-local. |
| Post-processing, host upload, binary G-code, thumbnails, or device behavior | These are adjacent G-code/runtime surfaces with different risk profiles. | Keep the fixture a static text evidence artifact only. |

## Feature Dependencies

```text
v1.9 fork inventory and category map
    -> prusaslicer.arc-fitting source-observed planning row
        -> v1.12 marker Prusa G-code evidence
            -> v1.13 structural Prusa G-code evidence
                -> v1.14 semantic Prusa G-code evidence
                    -> v1.15 arc-fitting scope contract
                        -> source-pinned arc fixture and expected summary
                            -> pure Rust arc summary boundary/readiness metadata
                                -> public arc parity command and mutation guards
                                    -> exact fork.prusaslicer.arc-fitting status/docs

fork.prusaslicer.gcode-output
    -> prerequisite evidence chain only
    -does not become-> arc fitting, byte parity, printability, or broad generated-output parity

generated-outputs
    -> remains in progress
    -blocks-> any broad generated-output verified claim from this milestone
```

## Dependency Notes

- `prusaslicer.arc-fitting` already exists in `packages/fork-inventories/prusaslicer.tsv` with complexity `medium`, ownership `shared-downstream`, dependency `generated-outputs`, and source path `src/libslic3r/Geometry/ArcWelder.cpp`.
- `category-map.tsv` maps `arc.shared` to `prusaslicer.arc-fitting` and `bambustudio.arc-fitting`; v1.15 should use only the Prusa row.
- The existing `fork.prusaslicer.gcode-output` row proves marker, structural, and semantic expected-summary evidence through `bazel run //packages/parity:prusaslicer_gcode_output_parity`; it still explicitly defers arc fitting.
- Prusa source anchors at the accepted commit show that arc fitting is configured by `arc_fitting`, emits G2/G3 I/J style when enabled, and depends on ArcWelder path fitting before G-code emission.
- The fixture must come before Rust parsing, because the Rust boundary should encode a reviewed summary contract rather than inventing arc fields independently.
- Public status/docs must come last, after the arc parity command and mutation guards pass.

## MVP Recommendation

Prioritize:

1. Reviewed `prusaslicer.arc-fitting` scope contract with exact inventory,
   category, source, fixture, Rust, command, status, docs, and deferral fields.
2. Checked-in arc fixture namespace with provenance and
   `expected-arc-fitting-summary.tsv`.
3. Pure Rust arc summary parser/readiness metadata in `slic3r_flavors`.
4. Public `//packages/parity:prusaslicer_arc_fitting_parity` command with
   mutation guards for G2/G3 count, I/J offset presence, direction, fixture
   identity, source identity, and unsupported claim text.
5. Exact `fork.prusaslicer.arc-fitting` status/docs wording that keeps
   `generated-outputs` in progress and preserves existing G-code-output
   boundaries.

Defer:

- Full ArcWelder algorithm proof: too broad; needs geometry/tolerance research.
- Byte-for-byte G-code parity: requires a larger generated-output oracle.
- Firmware/printability validation: requires printer-runtime evidence.
- GUI config/export behavior: requires a separate GUI scope.
- Support, seam, STEP, Bambu Studio, OrcaSlicer, release, upstream import, and
  sync behavior: separate milestones only.

## Suggested Arc Summary Fields

| Field | Purpose | Complexity | Boundary |
| --- | --- | --- | --- |
| `source_ref` | Pins the accepted PrusaSlicer source identity. | Low | Exact accepted source ref only. |
| `inventory_source_paths` | Records `ArcWelder.cpp` plus companion source anchors. | Low | Source traceability only; no source import. |
| `fixture_id` | Names the checked-in arc fixture. | Low | Fixture identity only. |
| `fixture_path` | Identifies the local fixture artifact. | Low | Checked-in path only. |
| `arc_fitting_config_value` | Records the accepted enabled config shape. | Low | `emit_center` evidence only; no GUI behavior. |
| `command_count_g2` | Counts clockwise arc commands. | Medium | Syntactic G-code command evidence only. |
| `command_count_g3` | Counts counter-clockwise arc commands. | Medium | Syntactic G-code command evidence only. |
| `center_offset_axes_present` | Confirms I/J center-offset command shape. | Medium | Command-shape evidence only; no firmware claim. |
| `arc_direction_counts` | Distinguishes G2 from G3 direction evidence. | Medium | Syntactic direction classification only. |
| `coordinate_bounds` | Summarizes X/Y observations from the fixture. | Medium | Observation only; no toolpath geometry parity. |
| `extrusion_total` | Summarizes E-axis observations if present. | Medium | Summary only; no material-use or printability claim. |
| `feedrate_observations` | Summarizes F values if present. | Low | Metadata only; no timing or firmware claim. |
| `line_fallback_count` | Records remaining G1 lines in the arc fixture. | Medium | Local fixture fact only; no algorithm fallback proof. |
| `deferred_scope` | Keeps overclaiming out of achieved wording. | Low | Exact deferral language enforced by verifiers. |

## Recommended Requirement Categories

| Category | Suggested IDs | What Requirements Should Cover |
| --- | --- | --- |
| Arc Scope Contract | `ARCSCOPE-01` to `ARCSCOPE-03` | Reviewed scope record, source anchors, approved arc fields, exact deferrals, generated-output status restraint, and scope verifier. |
| Arc Fixture Corpus | `ARCFIX-01` to `ARCFIX-03` | Fixture namespace, provenance manifest, expected summary artifact, update route, fixture verifier, and no live generation/import behavior. |
| Rust Arc Boundary | `ARCRUST-01` to `ARCRUST-03` | Pure typed parser/readiness metadata, Cargo/Bazel coverage, invalid-row rejection, and no Git/network/process/filesystem discovery in core logic. |
| Executable Arc Evidence | `ARCEV-01` to `ARCEV-03` | Public parity command, mutation guards, exact status row, package docs, port docs, and preserved broad deferrals. |

Recommended phase shape:

1. **Phase 57: Arc-Fitting Scope Contract**
2. **Phase 58: Arc-Fitting Fixture Corpus**
3. **Phase 59: Rust Arc-Fitting Evidence Boundary**
4. **Phase 60: Executable Arc-Fitting Evidence**

## Scope Boundaries

In scope for v1.15:

- Source-pinned PrusaSlicer arc-fitting evidence for `prusaslicer.arc-fitting`.
- Checked-in fixture evidence containing observable G2/G3 I/J arc-command facts.
- Typed Rust parsing of checked-in expected arc summaries.
- Fail-closed verification for arc field drift and unsupported claim text.
- Public parity/status/docs for only `fork.prusaslicer.arc-fitting`.

Out of scope for v1.15:

- Broad `generated-outputs` promotion.
- Byte-for-byte G-code parity.
- Full generated-output content parity.
- Full ArcWelder algorithm equivalence.
- Toolpath geometry parity beyond explicitly approved fixture observations.
- Printer-runtime, firmware, host-upload, or printability behavior.
- GUI export, preview, or settings behavior.
- Support generation, wall seam behavior, STEP import, full 3MF import/export.
- Bambu Studio, OrcaSlicer, fork release builds, upstream source imports, and
  sync automation.

## Sources

- `AGENTS.md`
- `AGENTS.bright-builds.md`
- `standards-overrides.md`
- `.planning/PROJECT.md`
- `.planning/STATE.md`
- `.planning/milestones/v1.14-REQUIREMENTS.md`
- `.planning/milestones/v1.14-ROADMAP.md`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/fork-inventories/category-map.tsv`
- `packages/parity/status.tsv`
- `docs/port/parity-matrix.md`
- `docs/port/migration-guidance.md`
- `packages/parity/README.md`
- `packages/parity-fixtures/README.md`
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
- `packages/slic3r-rust/README.md`
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`
- PrusaSlicer `ArcWelder.cpp` at accepted commit:
  `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp`
- PrusaSlicer `ArcWelder.hpp` at accepted commit:
  `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.hpp`
- PrusaSlicer `GCode.cpp` at accepted commit:
  `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.cpp`
- PrusaSlicer `PrintConfig.cpp` at accepted commit:
  `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/PrintConfig.cpp`
- PrusaSlicer `test_arc_welder.cpp` at accepted commit:
  `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_arc_welder.cpp`
- Pinned Bright Builds standards at commit
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: architecture, verification,
  and testing.

## Gaps to Resolve During Scope Planning

- Pick the exact checked-in arc fixture bytes and decide whether the MVP needs
  one positive fixture only or a positive plus no-arc control fixture.
- Decide whether arc summary fields remain purely syntactic or include a small
  derived center-offset consistency check. Do not include derived geometry
  unless the scope contract defines exact tolerances and failure messages.
- Confirm whether public docs should add only `fork.prusaslicer.arc-fitting` or
  also mention the new arc slice in the existing `fork.prusaslicer.gcode-output`
  notes as a related-but-separate verified row.
