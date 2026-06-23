# Domain Pitfalls

**Domain:** v1.15 PrusaSlicer arc-fitting G-code evidence slice
**Project:** Slic3r Rust Port
**Researched:** 2026-06-23
**Overall confidence:** HIGH for repo evidence-chain pitfalls; MEDIUM for exact
arc fixture shape until Phase 57 chooses the reviewed source-pinned fixture.

## Scope Assumption

v1.15 should reuse the v1.12-v1.14 G-code evidence ladder instead of creating a
new broad generated-output program. Recommended phase ownership:

1. **Phase 57: Arc-Fitting Scope Contract** - add a reviewed
   `prusaslicer.arc-fitting` scope contract tied to
   `packages/fork-inventories/prusaslicer.tsv`, the accepted
   `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`
   source identity, `src/libslic3r/Geometry/ArcWelder.cpp`, the existing
   `fork.prusaslicer.gcode-output` ladder, planned fixture summaries, planned
   Rust boundary, planned public evidence command, status wording, docs, and
   explicit deferrals.
2. **Phase 58: Arc-Fitting Fixture Corpus** - add the source-pinned arc fixture
   namespace, provenance, expected arc summary artifact, update rules, Bazel
   ownership, and fail-closed fixture verifier.
3. **Phase 59: Rust Arc-Fitting Evidence Boundary** - add pure typed Rust
   parsing/readiness for the checked-in arc summary only, with no generation,
   filesystem discovery, Git, network, PrusaSlicer runtime, printer-runtime,
   release, or sync side effects.
4. **Phase 60: Executable Arc-Fitting Evidence** - wire public evidence,
   mutation guards, exact status/docs wording, and traceability while keeping
   broad `generated-outputs` in progress.

If roadmap numbering changes, preserve this responsibility split. Do not let
fixture bytes, Rust parser work, public status/docs, or mutation guards appear
before the upstream source and expected arc evidence contract are closed.

## Critical Pitfalls

Mistakes in this section can cause misleading parity claims, rewrites of the
evidence chain, or a milestone audit failure.

### Pitfall 1: Promoting Arc-Fitting Evidence Into Broad Generated-Output Parity

**What goes wrong:** A narrow arc-fitting evidence slice gets described as
verified PrusaSlicer generated-output parity, byte-for-byte G-code parity,
toolpath geometry parity, printability, firmware behavior, runtime behavior, or
safe-to-print behavior.

**Why it happens:** Arc fitting emits user-visible G-code commands, so it is
tempting to treat `G2`/`G3` evidence as "real output parity." The existing repo
explicitly keeps `generated-outputs` in progress, and v1.14 still defers arc
fitting from the semantic G-code slice.

**Consequences:** `packages/parity/status.tsv`, docs, and audit artifacts would
overclaim. A future broader generated-output milestone would need to unwind
public wording before it can add real byte/output/runtime evidence.

**Prevention:** Phase 57 must define the arc-fitting evidence as an additive,
source-pinned summary slice. Phase 60 must publish only exact wording such as
"narrow source-pinned Prusa arc-fitting G-code evidence" and must leave the
`generated-outputs` row `in progress`.

**Warning signs:**

- `generated-outputs` changes from `in progress` to `verified`.
- Status/docs say "G-code parity", "generated-output parity", "matches
  PrusaSlicer output", "printable", "firmware verified", or "runtime verified"
  without narrow evidence qualifiers.
- The artifact is named like `expected-output.gcode` or
  `byte-for-byte-arc-parity`.
- The public command output does not mention deferred byte parity,
  printability, runtime, GUI, release, sync, and non-Prusa surfaces.

**Preventing phase:** Phase 57 owns the contract and forbidden claim list;
Phase 60 owns final status/docs enforcement.

**Detection:** Scope verifier rejects broad claim text. Public parity/status
test confirms exactly one `generated-outputs` row remains `in progress` and
the narrow fork row is the only verified publication surface.

### Pitfall 2: Using The Wrong Inventory Row Or Source Anchor

**What goes wrong:** Arc-fitting evidence is attached only to
`prusaslicer.gcode-output`, `src/libslic3r/GCode.cpp`, or the old
`tests/fff_print/test_gcodewriter.cpp` fixture instead of the source-observed
`prusaslicer.arc-fitting` row and `src/libslic3r/Geometry/ArcWelder.cpp`.

**Why it happens:** v1.12-v1.14 intentionally built the G-code output ladder
under `fork.prusaslicer.gcode-output`. Arc fitting is adjacent to that ladder
but has its own inventory row and source path.

**Consequences:** The evidence would not prove the milestone goal. Reviewers
could not trace from the artifact to the source-observed arc-fitting surface,
and future support/seam/generated-output milestones could inherit a bad
precedent.

**Prevention:** Phase 57 should add an arc-specific scope section or package
that names both surfaces: `prusaslicer.arc-fitting` as the feature under test,
and `fork.prusaslicer.gcode-output` as the existing evidence command/status
ladder it extends. It should source-pin
`src/libslic3r/Geometry/ArcWelder.cpp` and, if config mode is part of the
fixture contract, `src/libslic3r/PrintConfig.cpp` / `PrintConfig.hpp`.

**Warning signs:**

- Scope contract names only `prusaslicer.gcode-output`.
- Fixture provenance still cites only `tests/fff_print/test_gcodewriter.cpp`.
- Expected arc summary lacks `inventory_id=prusaslicer.arc-fitting`.
- Review notes say "arc is just another semantic G-code field" without source
  path traceability.

**Preventing phase:** Phase 57.

**Detection:** Scope verifier checks exact inventory row, source ref, peeled
commit, source path, companion config source when used, fixture namespace,
planned Rust boundary, and planned publication wording.

### Pitfall 3: Selecting A Fixture That Does Not Actually Exercise Arc Fitting

**What goes wrong:** The fixture is easy to verify but contains no approved arc
evidence: no `G2`/`G3` commands, no explicit arc-fitting config mode, no
source-pinned path to the upstream arc code, or no relation to the existing
semantic G-code summaries.

**Why it happens:** The current `gcodewriter-set-speed.gcode` fixture is tiny,
stable, and already wired through marker/structural/semantic evidence. It is
not an arc fixture. Reusing it would keep verification simple but prove nothing
about arc fitting.

**Consequences:** The milestone can pass mechanically while failing its core
intent. Later phases would have to replace the fixture corpus and all parser,
parity, status, and docs assumptions.

**Prevention:** Phase 58 must add a reviewed source-pinned arc fixture or
sidecar with at least one positive arc observation and any required negative
controls. It should record fixture role, input source or upstream literal,
generator/config provenance, `arc_fitting` mode, G-code encoding, checksum,
line endings, update route, and broad deferrals.

**Warning signs:**

- Arc expected summary says `G2:0;G3:0` for the only fixture.
- The fixture path remains only `gcodewriter-set-speed.gcode`.
- Fixture provenance lacks `arc_fitting=emit_center` or a deliberate
  equivalent source/config decision.
- The verifier checks byte count and checksum but not arc-specific fields.

**Preventing phase:** Phase 58, with Phase 57 defining the minimum acceptable
arc evidence fields.

**Detection:** Fixture verifier rejects missing arc rows, duplicate rows,
out-of-order rows, unsupported fields, stale fixture identity, missing config
mode, missing source path, missing checksum, and fixture content with no
approved positive arc evidence.

### Pitfall 4: Treating G2/G3 Presence As Geometry Or Runtime Correctness

**What goes wrong:** The summary starts claiming that arcs are geometrically
equivalent, printer-safe, firmware-supported, smoother, faster, or correctly
printed because `G2` or `G3` commands are present.

**Why it happens:** Upstream ArcWelder code fits polylines into circular
segments under tolerance rules, and Prusa config describes an arc-fitting
setting that emits `G2`/`G3` moves. Presence and counts are easier to verify
than geometric equivalence or printer behavior, but the language can drift.

**Consequences:** The evidence would cross into toolpath geometry,
printability, firmware, timing, and printer-runtime surfaces that this repo has
explicitly deferred.

**Prevention:** Phase 57 should classify allowed fields as evidence facts, not
behavioral guarantees. Good fields are source identity, fixture identity,
arc-fitting config mode, `G2`/`G3` command counts, clockwise/counterclockwise
presence, I/J center-offset presence if that syntax is chosen, selected
coordinate observations, and explicit deferral notes. Bad fields are
`geometry_matches`, `smoothness_verified`, `print_time_verified`,
`firmware_supported`, or `safe_to_print`.

**Warning signs:**

- Expected rows include "geometry parity", "arc correctness",
  "printer accepts", "safe", "smooth", "speed", or "VFA" claims.
- Notes explain why Prusa's algorithm is correct instead of what the checked
  artifact contains.
- Tests compare rendered geometry or printer behavior in this milestone.

**Preventing phase:** Phase 57 and Phase 58.

**Detection:** Scope and fixture verifiers reject forbidden behavior terms.
Rust parser rejects unsupported fields and unsupported evidence-boundary text.

### Pitfall 5: Loose Arc Summary Parsing Lets Drift Pass

**What goes wrong:** The Rust parser accepts arbitrary strings, unknown fields,
missing rows, duplicate rows, wrong row order, wrong source refs, wrong fixture
paths, or broad claim text in the arc summary.

**Why it happens:** Arc data can be represented compactly as text:
`G2:1;G3:2;I:true;J:true`. If treated as an opaque string everywhere, the
parser cannot protect the evidence boundary.

**Consequences:** Mutation guards will miss real drift. A typo or unsupported
field could silently become public evidence.

**Prevention:** Phase 59 should parse raw TSV into domain types and enums at
the boundary, mirroring the v1.14 semantic parser pattern. Required rows should
be exact, ordered, and typed. Optionality should be explicit and named with
`maybe_` when used internally.

**Warning signs:**

- New parser function returns `HashMap<String, String>` or a free-form
  `Vec<String>` as the public domain model.
- Tests only cover the happy path.
- Unsupported `arc_*` rows are ignored instead of rejected.
- The parser shares broad semantic errors but not arc-specific errors.

**Preventing phase:** Phase 59.

**Detection:** Cargo/Bazel tests reject invalid headers, wrong column counts,
empty required values, unsupported fields/categories/values, unexpected
evidence boundaries, duplicate rows, missing rows, extra rows, out-of-order
rows, wrong source refs, wrong fixture paths, and forbidden claim text.

### Pitfall 6: Public Evidence Lacks Arc-Specific Mutation Guards

**What goes wrong:** The public parity command is updated to include an arc
summary, but failure tests only prove old marker/structural/semantic drift.
Changes to arc command counts, `G2` vs `G3`, I/J center-offset mode, fixture
identity, source identity, or deferred-claim wording can pass.

**Why it happens:** The existing `prusaslicer_gcode_output_parity` command has
good mutation coverage for the v1.14 semantic rows. It does not yet know about
arc-specific drift classes.

**Consequences:** Maintainers get a green public command that does not protect
the new milestone's evidence.

**Prevention:** Phase 60 must add public fail-closed mutation cases for each
arc-specific field approved in Phase 57. If the existing command is extended,
the new output should print arc summary facts and the failure test should
assert diagnostics name the mutated arc field.

**Warning signs:**

- Only `movement_class_counts`, `coordinate_bounds`, `extrusion_total`,
  `feedrate_observations`, or old fixture identity mutations are tested.
- Arc summary is included in `data` but not in comparator args or output.
- Failure diagnostics say only `line_count` or `expected summary mismatch`
  without naming the arc field.

**Preventing phase:** Phase 60.

**Detection:** `//packages/parity:prusaslicer_gcode_output_parity_failure_test`
or a companion arc failure test mutates every approved arc evidence field and
requires field-specific diagnostics.

### Pitfall 7: Introducing Live Generation, Upstream Fetching, Or Runtime Side Effects

**What goes wrong:** A verifier or Rust binary runs PrusaSlicer, fetches
upstream source, clones a repo, generates G-code from models, executes
post-processing, uploads to a host, or probes printer/runtime behavior.

**Why it happens:** Arc-fitting evidence is harder to source-pin than the old
literal `G1 F...` fixture. It is tempting to make verification reproducible by
running a slicer or fetching upstream inputs.

**Consequences:** The milestone would become a runtime/import/sync milestone,
not a checked-in evidence milestone. It would also add network, credential,
host-upload, reproducibility, and CI stability risks that the repo has
explicitly deferred.

**Prevention:** Phase 58 fixture verification should check checked-in artifacts
only. Phase 59 Rust code should be pure data-in/data-out. Phase 60 public
evidence should compare checked-in expected summaries through the Rust boundary
only.

**Warning signs:**

- Verifier contains `curl`, `git fetch`, `git clone`, `PrusaSlicer --`,
  `slic3r --`, `send-gcode`, host upload, or post-processing script execution.
- Rust parser reads fixture paths on its own instead of receiving caller
  supplied input.
- Fixture README update route mentions "latest upstream" or branch head as
  authoritative.

**Preventing phase:** Phase 58 for fixture tooling, Phase 59 for Rust purity,
Phase 60 for public command behavior.

**Detection:** Verifiers scan their own scripts for forbidden network/runtime
terms. Rust tests and review confirm no filesystem discovery, Git, network,
process execution, generator, host upload, printer-runtime, release, or sync
behavior exists in the parser boundary.

## Moderate Pitfalls

### Pitfall 1: Arc-Fitting Config Mode Is Ambiguous

**What goes wrong:** The evidence does not say whether arc fitting was disabled
or enabled, or whether it used Prusa's `emit_center` mode. Reviewers cannot
tell if the fixture proves arc-fitting evidence or plain G-code output.

**Prevention:** Phase 57 should include the allowed config key/value in the
scope contract. Phase 58 should record that value in provenance and in the
expected summary if the fixture depends on it.

**Warning signs:** The fixture has arcs but no config provenance; docs imply
arc fitting is universally enabled; expected rows omit `arc_fitting` mode.

**Preventing phase:** Phase 57 and Phase 58.

### Pitfall 2: G2/G3 Syntax Variants Are Not Bounded

**What goes wrong:** The summary mixes center-offset `I/J`, radius `R`,
absolute/relative positioning, extrusion-bearing arcs, and feedrate-bearing
arcs without saying which syntax is in scope.

**Prevention:** Phase 57 should choose a narrow arc command shape. If the
source-pinned fixture uses `G2/G3 I J`, the schema should say that explicitly
and defer other arc encodings until later.

**Warning signs:** Rows named `arc_command_valid` with no syntax; fixture has
both `R` and `I/J` arcs; parser accepts arbitrary arc parameters.

**Preventing phase:** Phase 57 and Phase 59.

### Pitfall 3: Existing Marker, Structural, And Semantic Evidence Regresses

**What goes wrong:** Adding the arc summary renames the existing public command,
changes the old expected summaries, drops the old fixture from the bundle, or
weakens v1.12-v1.14 mutation guards.

**Prevention:** Phase 60 should preserve
`bazel run //packages/parity:prusaslicer_gcode_output_parity` unless the
roadmap deliberately chooses a companion command. Phase 58 should add arc
artifacts to the fixture bundle without removing marker/structural/semantic
artifacts.

**Warning signs:** Existing output no longer reports marker/structural/semantic
row counts; old failure tests are deleted instead of extended; fixture
aliases are renamed without compatibility.

**Preventing phase:** Phase 58, Phase 59, and Phase 60.

### Pitfall 4: The Rust Boundary Becomes A Monolithic G-code Dumping Ground

**What goes wrong:** Arc parsing is appended directly to the already-large
`prusa_gcode_output.rs` file without a coherent split, making future evidence
work harder to review.

**Prevention:** Phase 59 should consider splitting by evidence rung if the
change materially expands the module: marker, structural, semantic, and arc
submodules with a stable public facade. Keep the split narrow and avoid a
rename-only cleanup unless it lowers the risk of the arc addition.

**Warning signs:** One file gains unrelated parser, metadata, CLI, tests, and
status logic; helper names obscure which evidence rung owns a field.

**Preventing phase:** Phase 59.

### Pitfall 5: Deferral Wording Becomes Internally Contradictory

**What goes wrong:** One doc publishes arc-fitting evidence while another still
lists all arc fitting as deferred, or the new status row says "arc fitting
verified" without preserving remaining deferrals.

**Prevention:** Phase 60 should update `packages/parity/status.tsv`,
`packages/prusa-gcode-output-scope/README.md`,
`packages/parity-fixtures/README.md`, fixture README, and
`docs/port/parity-matrix.md` together. Wording should distinguish "this narrow
arc-fitting evidence slice" from still-deferred byte parity, broad
generated-output parity, geometry, printability, runtime, GUI, release, sync,
and non-Prusa behavior.

**Warning signs:** `arc fitting` appears both as verified and fully deferred in
the same status path; package docs mention Phase 56 as current after Phase 60.

**Preventing phase:** Phase 60.

## Minor Pitfalls

### Pitfall 1: Public Names Overclaim

**What goes wrong:** Function, target, or status names imply runtime,
printability, geometry, or byte parity.

**Prevention:** Prefer names like `prusa_gcode_output_arc_summary`,
`parse_prusa_gcode_output_arc_summary`, or `arc_fitting_evidence` over names
like `arc_printability`, `arc_geometry_parity`, or `arc_runtime_verified`.

**Warning signs:** Public helper names contain `runtime`, `printable`,
`geometry_parity`, `safe_to_print`, `byte_parity`, or `firmware`.

**Preventing phase:** Phase 59 and Phase 60.

### Pitfall 2: TSV Header, Row Count, Or Ordering Drift

**What goes wrong:** Arc rows are present but ordered inconsistently, missing a
required field, duplicated, or using a header that Rust and shell verifiers
disagree on.

**Prevention:** Phase 58 should make the fixture verifier the first owner of
the exact header, required field list, row count, and row order. Phase 59
should duplicate those invariants in typed parser tests.

**Warning signs:** `awk` checks allow any order; Rust parser sorts rows before
validation; failures report only a raw diff.

**Preventing phase:** Phase 58 and Phase 59.

### Pitfall 3: Binary G-code, Thumbnails, Or Post-Processing Sneaks Into The Arc Fixture

**What goes wrong:** The arc fixture uses `.bgcode`, thumbnail blocks,
post-processed output, or host-upload side effects because those features are
near Prusa G-code output.

**Prevention:** Phase 57 should explicitly keep binary G-code, thumbnails,
post-processing, host upload, and printer integration out of scope. Phase 58
should enforce ASCII/LF text, checksum, and provenance exclusions unless a
future milestone deliberately changes scope.

**Warning signs:** Fixture verifier needs binary decoding, image libraries,
post-processing environment variables, host URLs, or non-text checks.

**Preventing phase:** Phase 57 and Phase 58.

### Pitfall 4: Community Reports Drive Claims Instead Of Checked Sources

**What goes wrong:** Open upstream issues or forum reports about arc-fitting
quality, speed artifacts, or firmware behavior become evidence in this repo's
status/docs.

**Prevention:** Use community reports only as cautionary context. The v1.15
artifact should be based on the pinned upstream source, checked-in fixture
artifact, typed parser, and fail-closed comparison.

**Warning signs:** Docs cite issue anecdotes to claim correctness or failure
of Prusa arc fitting; fixture expected values come from screenshots or forum
posts.

**Preventing phase:** Phase 57.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
| --- | --- | --- |
| Phase 57: Arc-Fitting Scope Contract | Wrong source anchor, broad generated-output overclaim, or ambiguous config mode | Require exact `prusaslicer.arc-fitting` inventory row, accepted source identity, `ArcWelder.cpp` source path, optional config source path, allowed fields, forbidden claims, planned command/status wording, and reviewer signoff. |
| Phase 58: Arc-Fitting Fixture Corpus | Fixture has no positive arc evidence, no reproducible provenance, or live generation side effects | Add checked-in source-pinned artifacts only; verify checksum, ASCII/LF, source ref, fixture identity, config mode, expected arc rows, update route, and forbidden runtime/network/post-processing terms. |
| Phase 59: Rust Arc-Fitting Evidence Boundary | Parser accepts loose strings or leaks side effects | Parse TSV into enums/newtypes and exact facts; reject invalid headers, wrong columns, unsupported fields, duplicates, missing/extra/out-of-order rows, wrong source/fixture values, and forbidden claim text. Keep the boundary pure. |
| Phase 60: Executable Arc-Fitting Evidence | Public command/status/docs publish without arc-specific mutation guards | Extend or add public parity evidence only after Phase 59; mutate every approved arc field; assert field-specific diagnostics; update status/docs together while keeping broad `generated-outputs` in progress. |

## Sources

**Repo sources - HIGH confidence**

- `AGENTS.md` - repo-local planning, verification, and summary metadata
  guidance.
- `AGENTS.bright-builds.md` and `standards-overrides.md` - Bright Builds
  workflow and local override guidance.
- `.planning/PROJECT.md` - v1.15 goal and target feature boundary.
- `.planning/milestones/v1.14-REQUIREMENTS.md` - v1.14 semantic evidence
  requirements and explicit future `ARC-01` deferral.
- `.planning/milestones/v1.14-MILESTONE-AUDIT.md` - verified v1.14 ladder and
  deferred-scope audit.
- `.planning/milestones/v1.14-ROADMAP.md` - Phase 53-56 pattern and future
  revisit notes.
- `packages/fork-inventories/prusaslicer.tsv` - source-observed
  `prusaslicer.arc-fitting` row and `ArcWelder.cpp` source path.
- `packages/parity/status.tsv` - current verified narrow
  `fork.prusaslicer.gcode-output` row and `generated-outputs` in-progress row.
- `packages/prusa-gcode-output-scope/README.md` and
  `packages/prusa-gcode-output-scope/gcode-output-scope.md` - existing scope
  gate, semantic field contract, and deferred behavior list.
- `packages/parity-fixtures/README.md` and
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace, provenance/update rules, checked-in artifact boundary,
  and deferred surfaces.
- `docs/port/parity-matrix.md` - public parity interpretation and fork evidence
  rules.
- `packages/parity/compare_prusaslicer_gcode_output.sh` and
  `packages/parity/compare_prusaslicer_gcode_output_test.sh` - current public
  comparator and mutation guard pattern.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - current
  fixture verifier invariants and no-runtime/no-fetch checks.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  current pure typed marker/structural/semantic parser/readiness pattern.

**Upstream PrusaSlicer sources - HIGH confidence for source shape**

- PrusaSlicer `ArcWelder.cpp` at
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`:
  `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp`
  - confirms the arc-fitting implementation source path and G0/G1 to G2/G3
  arc-fitting context.
- PrusaSlicer `ArcWelder.hpp` at
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`:
  `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.hpp`
  - confirms the `Segment`/`Path` arc representation and `fit_path` boundary.
- PrusaSlicer `PrintConfig.cpp` and `PrintConfig.hpp` at
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`:
  `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/PrintConfig.cpp`
  and
  `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/PrintConfig.hpp`
  - confirms the `arc_fitting` config key and `ArcFittingType` values
  `Disabled` / `EmitCenter`.

**Canonical standards - HIGH confidence for process expectations**

- Bright Builds standards index:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md`
- Architecture standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md`
- Verification standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md`
- Testing standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md`
- Code shape and Rust standards:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md`
  and
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md`

## Gaps To Revisit During Phase Planning

- Exact fixture shape is intentionally unresolved here. Phase 57 must decide
  whether the arc fixture is derived from an upstream test/literal, a checked-in
  reviewed G-code sample, or a narrow manual export note.
- The research did not prove which arc evidence fields are the best minimal
  set. Phase 57 should choose the smallest field set that distinguishes arc
  fitting from ordinary semantic G-code evidence.
- Upstream issue/forum reports were not treated as evidence because the
  milestone asks for a source-pinned evidence path, not real-world arc quality
  validation.
