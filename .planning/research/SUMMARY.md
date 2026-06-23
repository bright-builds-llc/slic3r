# Project Research Summary

**Project:** Slic3r Rust Port
**Domain:** v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice
**Researched:** 2026-06-23
**Confidence:** HIGH for roadmap shape and stack; MEDIUM for exact fixture
bytes and final summary fields until Phase 57 closes the scope contract.

## Executive Summary

v1.15 should prove one narrow, source-pinned PrusaSlicer arc-fitting G-code
evidence slice. Expert implementation in this repo means reusing the
v1.12-v1.14 evidence ladder: reviewed scope contract, checked-in fixture
corpus, pure Rust parser/readiness boundary, public Bazel parity command,
fail-closed mutation guards, exact status/docs wording, and no broad runtime
claim. The product is not a slicer runtime feature yet; it is executable
evidence that the port can observe and protect a specific downstream
PrusaSlicer generated-output feature.

Use the existing Bazel/Rust/TSV/shell stack. Add no third-party G-code parser,
geometry crate, database, PrusaSlicer runtime invocation, upstream source
import, network fetch, or sync automation. The recommended architecture is a
modified-package milestone: extend `packages/prusa-gcode-output-scope` with a
v1.15 arc-fitting contract, add a new fixture namespace under
`packages/parity-fixtures`, add `slic3r_flavors::prusa_arc_fitting`, and publish
`//packages/parity:prusaslicer_arc_fitting_parity` only after executable
evidence passes.

The main risk is overclaiming. G2/G3 arc commands can show narrow command-shape
evidence, but they do not prove byte-for-byte G-code parity, broad
generated-output verification, toolpath geometry, printability, firmware or
runtime behavior, GUI behavior, non-Prusa fork behavior, release behavior,
upstream imports, or sync behavior. Phase 57 must define the allowed evidence
fields and forbidden wording before fixture, Rust, parity, status, or docs work
can publish anything.

## Key Findings

### Recommended Stack

Do not add a new external stack. v1.15 should stay inside the repo-owned
evidence tooling already used for Prusa G-code marker, structural, and semantic
evidence.

**Core technologies:**

- Bazel/Bazelisk 8.6.0: top-level build, test, run, verifier, and public
  evidence command surface.
- `rules_rust` 0.69.0: existing Rust target, clippy, rustfmt, binary, and test
  wiring for `slic3r_flavors`.
- Rust 1.94.1, edition 2024: typed, std-only parser/readiness code for checked
  TSV data.
- Bash `sh_binary`/`sh_test`: thin scope, fixture, parity, and mutation
  adapters around checked-in files and Rust binaries.
- TSV expected artifacts: closed schema for reviewed arc evidence facts.
- `slic3r_contracts` and `slic3r_flavors`: reuse existing source/flavor/parity
  metadata and add only the arc-fitting boundary needed by this slice.

**Stack additions:**

- Add `expected-arc-fitting-summary.tsv` under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/`.
- Add `slic3r_flavors::prusa_arc_fitting` plus a thin
  `prusa_arc_fitting_summary` binary.
- Add a public parity comparator and status row for
  `fork.prusaslicer.arc-fitting` after evidence passes.
- Keep `generated-outputs` `in progress`; do not add live PrusaSlicer
  generation, byte parity, geometry, firmware, GUI, release, upstream import,
  or sync tooling.

### Expected Features

v1.15 is table-stakes complete only if it creates a source-pinned evidence
chain for `prusaslicer.arc-fitting` that is separate from the existing
`fork.prusaslicer.gcode-output` row.

**Must have (table stakes):**

- Reviewed `prusaslicer.arc-fitting` scope contract with accepted source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  inventory/category-map traceability, allowed fields, planned fixture/Rust/
  parity paths, exact deferrals, and verifier coverage.
- Source anchors for arc fitting and command emission:
  `src/libslic3r/Geometry/ArcWelder.cpp`, `ArcWelder.hpp`, relevant `GCode.cpp`
  emission points, `PrintConfig.cpp` config values when used, and optionally
  `tests/libslic3r/test_arc_welder.cpp`.
- Arc-specific fixture namespace with ASCII/LF checked-in `.gcode` evidence,
  provenance, SHA/size/line-ending guards, update route, and broad-scope
  exclusions.
- Closed `expected-arc-fitting-summary.tsv` schema. Recommended columns:
  `source_ref`, `fixture_path`, `arc_field`, `arc_category`, `arc_value`,
  `evidence_boundary`.
- Pure Rust parser/readiness boundary that rejects invalid headers, unknown
  fields, duplicates, missing rows, row-order drift, wrong source/fixture
  identity, and unsupported claim text.
- Public `bazel run //packages/parity:prusaslicer_arc_fitting_parity` command
  with arc-specific mutation guards and field-specific diagnostics.
- Exact `fork.prusaslicer.arc-fitting` status/docs wording that preserves the
  existing `fork.prusaslicer.gcode-output` meaning and keeps broad
  `generated-outputs` in progress.

**Should have (differentiators):**

- Separate arc status token, not a widened `fork.prusaslicer.gcode-output`
  claim.
- Source-to-command traceability across ArcWelder, config, and G-code emission.
- I/J center-offset evidence for Prusa's `emit_center` shape, if approved by
  scope.
- G2 versus G3 direction counts rather than a generic "contains arc" check.
- Positive fixture evidence plus a negative/control case if it stays narrow and
  source-pinned.
- Reuse of v1.14 semantic G-code parser lessons without turning the parser into
  a generic unbounded key-value map.

**Defer (v2+ or separate milestones):**

- Broad `generated-outputs` verification.
- Byte-for-byte G-code parity.
- Full ArcWelder algorithm equivalence, tolerance, or geometry proof.
- Printability, printer firmware, printer runtime, host upload, timing, or
  material-use correctness.
- GUI setting/export behavior.
- Support generation, wall seam behavior, STEP import, full 3MF behavior,
  binary G-code, thumbnails, and post-processing.
- Bambu Studio, OrcaSlicer, fork release builds, upstream source imports,
  automated vendor refresh, and sync behavior.

### Architecture Approach

Use the existing G-code evidence ladder with a new feature-specific evidence
row. The research disagrees on whether to create a new
`packages/prusa-arc-fitting-scope` package; the roadmap should prefer the
architecture recommendation and extend `packages/prusa-gcode-output-scope`
because arc fitting is a G-code-shaped generated-output slice and the existing
scope package already owns the deferral vocabulary. A new top-level scope
package should require an explicit Phase 57 decision.

**Major components:**

1. `packages/prusa-gcode-output-scope` - owns the v1.15 arc-fitting scope
   section, source/category traceability, allowed fields, planned paths, and
   forbidden broad claims.
2. `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` - owns
   static fixture bytes, provenance, `expected-arc-fitting-summary.tsv`, update
   rules, fixture verifier, and mutation guards.
3. `slic3r_flavors::prusa_arc_fitting` - parses caller-supplied TSV text into
   closed Rust domain types and renders deterministic summary lines with no
   filesystem discovery, Git, network, process execution, runtime generation,
   release, or sync side effects.
4. `packages/parity` - owns public executable evidence, arc mutation guards,
   `fork.prusaslicer.arc-fitting` status publication, and regression coverage
   for the existing `prusaslicer_gcode_output_parity` command.
5. `docs/port` and package READMEs - publish the exact narrow evidence
   boundary and keep deferred surfaces explicit.

**Key patterns:**

- Scope first, fixture second, Rust third, public status/docs last.
- Closed TSV schema plus typed Rust enums/newtypes.
- Functional core, imperative shell: Rust owns parsing and domain validation;
  shell/Bazel owns paths, command invocation, temp files, and diffs.
- Verified status only after executable evidence and mutation guards pass.
- Existing G-code parity remains a regression check, not a container for arc
  overclaims.

### Critical Pitfalls

1. **Promoting narrow arc evidence into broad generated-output parity** - keep
   `generated-outputs` `in progress`; make verifiers reject byte parity,
   printability, runtime, GUI, release, sync, and non-Prusa claims.
2. **Using the wrong inventory row or source anchor** - trace the feature to
   `prusaslicer.arc-fitting` and `ArcWelder.cpp`; treat
   `fork.prusaslicer.gcode-output` only as the prerequisite evidence ladder.
3. **Selecting a fixture that does not exercise arc fitting** - require
   approved positive arc evidence such as G2/G3 commands, I/J center-offset
   shape when scoped, config/source provenance, and checksum/line-ending guards.
4. **Treating G2/G3 presence as geometry or runtime correctness** - classify
   command counts, direction, offsets, coordinates, extrusion, and feedrate as
   fixture observations only.
5. **Loose arc summary parsing** - reject unknown fields, missing/duplicate
   rows, row-order drift, wrong source or fixture identity, and broad claim
   text in Rust and shell tests.
6. **Missing arc-specific mutation guards** - mutate G2/G3 counts, direction,
   I/J mode, source identity, fixture identity, row order, and forbidden wording
   in public evidence tests.
7. **Introducing live generation or upstream fetching** - verifiers must not
   run PrusaSlicer, clone/fetch upstream, generate fresh G-code, upload to a
   host, or probe printer/runtime behavior.

## Implications for Roadmap

Based on the combined research, keep v1.15 as four phases: scope contract,
fixture corpus, Rust boundary, and executable evidence.

### Phase 57: Arc-Fitting Scope Contract

**Rationale:** The highest-risk failure mode is overclaiming before the
evidence contract is closed. Scope must define the exact inventory row, source
anchors, field set, package paths, public command name, planned status token,
deferrals, and verifier rules before any fixture, parser, parity, or docs work
can claim evidence.

**Delivers:** v1.15 scope section in `packages/prusa-gcode-output-scope`,
source/category/status traceability, allowed arc fields, forbidden claim list,
fixture/Rust/parity path contract, reviewer signoff, and fail-closed scope
verification.

**Addresses:** Reviewed scope contract, source identity, companion source
anchors, generated-output restraint, and exact deferral vocabulary.

**Avoids:** Wrong inventory row, premature status publication, broad
generated-output wording, ambiguous config mode, and fixture/parser work based
on an unapproved schema.

### Phase 58: Arc-Fitting Fixture Corpus

**Rationale:** Rust parsing and parity comparison need a reviewed static input
and expected-summary artifact. The fixture must be source-pinned and
arc-specific; reusing the feedrate-only G-code fixture would mechanically pass
while proving the wrong feature.

**Delivers:** `prusaslicer.arc-fitting` fixture namespace, `.gitattributes`,
README/update route, source-pinned `.gcode` evidence, `fixture-provenance.tsv`,
`expected-arc-fitting-summary.tsv`, Bazel aliases/bundles, fixture verifier,
and fail-closed fixture mutation tests.

**Addresses:** Checked-in fixture evidence, provenance manifest, arc expected
summary, ASCII/LF and checksum guards, fixture identity, arc command counts,
I/J or syntax-mode bounds when approved, and explicit deferred scope.

**Avoids:** Fixture with no positive arc evidence, live generation, upstream
fetch/import, binary G-code, thumbnails, post-processing, host upload, stale
docs, duplicate rows, and unsupported fields.

### Phase 59: Rust Arc-Fitting Evidence Boundary

**Rationale:** The evidence contract should be parsed into typed Rust domain
values before public parity shell code consumes it. This phase keeps the
functional core pure and prevents arbitrary TSV strings from becoming evidence
by accident.

**Delivers:** `src/prusa_arc_fitting.rs`,
`src/bin/prusa_arc_fitting_summary.rs`, `lib.rs` exports, registry/readiness
metadata, Rust tests, Bazel target wiring, clippy coverage, and rustfmt
coverage.

**Uses:** Rust 1.94.1, edition 2024, std-only parsing,
`slic3r_contracts` metadata types where useful, and existing
`slic3r_flavors` target patterns.

**Implements:** Closed parser/readiness component for
`slic3r_flavors::prusa_arc_fitting`.

**Avoids:** Generic key-value maps, unchecked primitive leakage, filesystem or
Git discovery in core logic, process execution, network access, runtime
generation, broad generated-output semantics, and monolithic G-code parser
growth without a reviewable boundary.

### Phase 60: Executable Arc-Fitting Evidence

**Rationale:** Publication belongs last. The status row and docs are credible
only after scope, fixture, Rust parsing, public comparator, mutation guards, and
the existing G-code parity regression all pass.

**Delivers:** `compare_prusaslicer_arc_fitting.sh`, public
`//packages/parity:prusaslicer_arc_fitting_parity`, arc-specific failure test,
exact `fork.prusaslicer.arc-fitting` status row, package README updates,
`docs/port` updates, and regression verification for
`//packages/parity:prusaslicer_gcode_output_parity`.

**Addresses:** Executable public evidence, mutation guards, status/docs
publication, traceability, and non-overclaiming public language.

**Avoids:** Publishing verified status before executable evidence, weakening
the existing `fork.prusaslicer.gcode-output` row, contradictory deferral docs,
and public command output that omits remaining byte parity, printability,
runtime, GUI, release, sync, upstream import, and non-Prusa deferrals.

### Phase Ordering Rationale

- Scope first prevents implementation from selecting fixture fields or public
  wording before the source and evidence contract are reviewed.
- Fixture second gives the Rust boundary a concrete, reviewed input/output
  artifact instead of letting code invent the schema.
- Rust third keeps parsing and validation pure, typed, and unit-testable before
  shell/Bazel publication.
- Executable evidence last makes public status a consequence of passing
  verifiers and mutation guards.
- The four-phase split maps directly to the existing v1.12-v1.14 ladder, so the
  roadmap can move quickly while keeping the new feature-specific status row
  separate from broad generated-output parity.

### Research Flags

Phases likely needing deeper `/gsd-research-phase` or extra planning research:

- **Phase 57:** Needs focused resolution of exact fixture derivation route,
  minimal allowed field set, config-mode evidence, whether a negative/control
  fixture is required, and the final package-boundary decision if maintainers
  want a new scope package instead of extending the existing one.
- **Phase 58:** Needs careful provenance validation for the selected fixture
  bytes and confirmation that the checked-in G-code exercises the approved arc
  fields without live generation or runtime claims.

Phases with standard patterns where extra research should usually be skipped:

- **Phase 59:** Existing `slic3r_flavors` parser/readiness patterns are well
  documented from v1.12-v1.14; planning should focus on exact enum/fact shape.
- **Phase 60:** Existing `packages/parity` command, status, docs, and mutation
  guard patterns are well documented; planning should focus on arc-specific
  mutations and exact wording.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Existing Bazel, `rules_rust`, Rust, shell, TSV, fixture, parity, and docs surfaces fit the milestone without new dependencies. |
| Features | HIGH | Table stakes and deferrals are consistent across research files and `.planning/PROJECT.md`. Exact fixture fields remain Phase 57 work. |
| Architecture | HIGH | Existing v1.12-v1.14 ladder provides direct scope -> fixture -> Rust -> parity/status/docs sequencing. Package-boundary conflict is resolved here in favor of extending the existing G-code scope package. |
| Pitfalls | HIGH | Major failure modes repeat across research: overclaims, wrong source row, bad fixture, loose parser, missing mutations, and live generation. |
| Fixture Details | MEDIUM | Research did not prove final fixture bytes, final expected rows, or whether a positive-only corpus is enough. |

**Overall confidence:** HIGH for roadmap structure; MEDIUM for fixture-specific
details until Phase 57.

### Gaps to Address

- Exact checked-in arc fixture source and bytes: resolve in Phase 57, enforce in
  Phase 58 with provenance, checksum, and ASCII/LF rules.
- Final expected-summary field set: choose the smallest closed set that
  distinguishes arc fitting from existing semantic G-code evidence.
- Arc syntax bounds: decide whether v1.15 is limited to I/J center-offset
  `emit_center` evidence and explicitly defer radius `R` or other encodings.
- Derived checks: avoid geometry/tolerance checks unless Phase 57 defines exact
  tolerances and failure messages; default to syntactic fixture observations.
- Documentation placement: update existing G-code-output docs only to point to
  the separate arc row; do not rewrite the old row as arc evidence.

## Sources

### Primary (HIGH confidence)

- `.planning/PROJECT.md` - v1.15 goal, active requirements, deferrals, and
  prior Prusa G-code evidence ladder.
- `.planning/research/STACK.md` - stack recommendation, versions, repo-owned
  additions, expected artifact shape, and verification targets.
- `.planning/research/FEATURES.md` - table stakes, differentiators,
  anti-features, dependencies, suggested requirements, and phase shape.
- `.planning/research/ARCHITECTURE.md` - component boundaries, data flow,
  modified package recommendation, build order, and patterns.
- `.planning/research/PITFALLS.md` - critical/moderate/minor pitfalls,
  phase-specific warnings, and detection strategies.
- `packages/fork-inventories/prusaslicer.tsv` and
  `packages/fork-inventories/category-map.tsv` as cited by research - existing
  `prusaslicer.arc-fitting` and `arc.shared` planning rows.
- `packages/parity/status.tsv` and `docs/port/parity-matrix.md` as cited by
  research - current narrow `fork.prusaslicer.gcode-output` meaning and broad
  `generated-outputs` in-progress state.
- Pinned PrusaSlicer source at
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`: `ArcWelder.cpp`,
  `ArcWelder.hpp`, `GCode.cpp`, `PrintConfig.cpp`, `PrintConfig.hpp`, and
  `tests/libslic3r/test_arc_welder.cpp` as cited by research.

### Standards and Process (HIGH confidence)

- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md`.
- Bright Builds pinned standards at
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`,
  `standards/core/architecture.md`, `standards/core/code-shape.md`,
  `standards/core/verification.md`, `standards/core/testing.md`, and
  `standards/languages/rust.md`.

### Secondary (MEDIUM confidence)

- Recommended final fixture bytes, optional negative/control fixture, and exact
  row values in `expected-arc-fitting-summary.tsv` - consistent research
  recommendations, but they need Phase 57 review and Phase 58 checked-in
  evidence before becoming implementation facts.

---

*Research completed: 2026-06-23*
*Ready for roadmap: yes*
