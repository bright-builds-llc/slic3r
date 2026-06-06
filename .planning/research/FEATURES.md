# Feature Research

**Project:** Slic3r Rust Port
**Milestone:** v1.12 PrusaSlicer G-code Output Evidence Foundation
**Domain:** narrow PrusaSlicer G-code output evidence slice
**Researched:** 2026-06-06
**Confidence:** HIGH for feature shape; MEDIUM for the exact fixture candidate
until the scope gate reviews a concrete Prusa-generated G-code file.

## Feature Landscape

v1.12 should prove one deliberately narrow Prusa-generated G-code evidence path.
The slice should not generate G-code in CI, run PrusaSlicer, import upstream
source, or compare full output bytes. It should check in one small reviewed
Prusa-generated G-code fixture, record exact provenance, derive a stable typed
summary from that raw fixture, compare that summary to a checked-in expected
artifact, and publish one exact fork status row whose notes say what remains
deferred.

Recommended public names:

- Evidence slug: `prusaslicer.gcode-output`
- Fixture namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`
- Expected artifact:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
- Rust boundary: `slic3r_flavors::prusa_gcode_output`
- Parity command: `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- Status token: `fork.prusaslicer.gcode-output`

The slug is a new stable evidence slug, not an existing v1.9 inventory row.
The scope record should say that explicitly and trace the dependency to the
existing `generated-outputs` parity surface plus adjacent Prusa future rows
such as `prusaslicer.arc-fitting`, `prusaslicer.wall-seam`, and
`prusaslicer.support-generation`. v1.12 must not mark any of those adjacent
rows complete.

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = the milestone cannot support a
credible requirements or roadmap plan.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Reviewed G-code evidence scope gate | v1.10 and v1.11 both start with a reviewed scope/checklist before fixtures or status claims. | LOW | Add a package like `packages/prusa-gcode-output-scope` with accepted Prusa source identity, fixture decision, expected-summary contract, Rust boundary name, planned parity command, planned status token, docs touched, license/security note, deferred scope, and reviewer signoff. |
| One small Prusa-generated G-code fixture | The milestone goal is a real Prusa-generated output evidence path, not another metadata-only planning row. | MEDIUM | Check in one reviewed `.gcode` fixture with `fixture-provenance.tsv`, byte count, SHA-256, generation context, accepted source pin, update route, and scope text. Do not fetch, regenerate, or run PrusaSlicer in the verifier. |
| Summary-only expected artifact | Raw G-code is too volatile for byte parity; a stable expected artifact is the right evidence boundary. | MEDIUM | Use a TSV such as `expected-gcode-summary.tsv` with columns like `source_ref`, `fixture_path`, `marker`, `evidence_kind`, `expected_value`, `deferred_semantics`, and `notes`. Rows should cover stable header/comment/config markers only. |
| Typed Rust G-code summary boundary | Bright Builds architecture and existing Prusa slices parse boundary data into domain types before core logic receives it. | MEDIUM | Implement pure Rust parsing over caller-supplied G-code text. Suggested API: `parse_prusa_gcode_output_summary`, `prusa_gcode_output_metadata`, and `prusa_gcode_output_summary_lines`. Keep filesystem reads in the small binary adapter only. |
| Focused Rust unit tests | Pure parsing and summary logic must be cheap to verify and fail specifically. | LOW | Mirror the v1.10/v1.11 tests: accepted fixture parses, metadata traces exactly, unsupported markers fail closed, missing/duplicate rows fail, and optional values use `maybe_` naming when introduced. |
| Fail-closed fixture verifier | Fixture provenance and non-overclaiming language must fail before the parity command trusts the fixture. | MEDIUM | Add a Bazel-visible verifier that checks README text, provenance header/rows, fixture size/SHA, expected summary shape, update route, and required deferrals. |
| Public Bazel parity command | Existing parity visibility requires maintainers to rerun a real `//packages/parity:*_parity` command before a fork row is `verified`. | MEDIUM | `//packages/parity:prusaslicer_gcode_output_parity` should run the Rust summary binary on the raw fixture and diff against `expected-gcode-summary.tsv`. It should print the status token, source ref, fixture path, expected path, and row count. |
| Mutation failure guard | The evidence path must prove it fails when either fixture evidence or expected summary evidence drifts. | MEDIUM | Add a sh test that mutates a required G-code marker or expected TSV row and asserts the parity command fails with a useful mismatch label. |
| Exact status row and docs | v1.10/v1.11 publish exact fork rows only after executable evidence passes. | LOW | Add `fork.prusaslicer.gcode-output` only in the final evidence phase. Keep `generated-outputs` as `in progress`; do not mark global generated-output parity verified. |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not required for a generic evidence slice,
but valuable for this port because they reduce future rewrite risk.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Generated-output evidence without generated-output parity overclaim | Lets the roadmap step into output evidence while staying honest about geometry/content limits. | LOW | The status row should say the slice proves metadata/marker summary evidence only, not G-code content parity. |
| Stable-marker semantics on every expected row | Makes it obvious which rows are metadata, marker presence, or deferred semantics. | MEDIUM | Reuse the v1.11 idea of `member-presence-only` / `member-marker-only`, adapted to G-code markers such as `metadata-marker-only` or `comment-marker-only`. |
| New evidence slug separated from adjacent feature rows | Prevents the first G-code fixture from accidentally completing support, arc, or seam roadmap items. | LOW | The scope record should list adjacent rows as dependencies or future consumers, not completed capabilities. |
| Fixture review as a future generated-output gate | Gives later arc fitting, wall seam, and support generation phases a proven fixture/provenance pattern. | LOW | This is valuable precisely because it does not solve those features yet. |
| Raw fixture to typed summary comparison | Stronger than v1.11's expected-summary self-validation because the Rust code reads the actual G-code fixture. | MEDIUM | Keep the parser intentionally shallow: comments, stable metadata markers, and marker counts/presence only. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Broad generated-output parity | It sounds like the natural goal for a G-code milestone. | It would imply geometry, toolpath, extrusion, timing, printer-specific, and content parity that this repo cannot prove yet. | Verify only stable metadata and marker summary evidence for one fixture. |
| Full G-code byte parity | A byte-for-byte diff feels definitive. | Timestamps, comments, ordering, numeric formatting, and generator version details make byte parity brittle and misleading. | Compare typed summary rows with explicit `deferred_semantics`. |
| Printer-runtime or printability claims | A G-code fixture looks like something a printer can run. | The repo is not validating firmware behavior, thermal safety, motion safety, material behavior, or physical print outcomes. | State that printer-runtime, printability, and device behavior are out of scope. |
| GUI export or G-code viewer behavior | Prusa-generated G-code is often created through GUI workflows. | GUI state, previews, project dialogs, and export UX need separate visual and interaction validation. | Record the fixture's generation context as provenance only. |
| Support generation parity | Support is a high-value Prusa output capability. | Local inventory marks support generation as high complexity and dependent on generated-output fixtures. | Defer `prusaslicer.support-generation` until after the summary fixture pattern is proven. |
| Wall seam behavior parity | The v1.11 project-file fixture used `seam_test_object.3mf`, so seam parity is tempting. | Wall seam requires geometry and toolpath evidence, not marker summaries. | Keep wall seam explicitly deferred. |
| Arc fitting parity | Arc output is naturally expressed in G-code. | Arc fitting requires G-code output comparison evidence that proves G2/G3 semantics and geometry constraints. | Treat v1.12 as prerequisite evidence only; defer `prusaslicer.arc-fitting`. |
| STEP import or full 3MF/project import/export | G-code output often starts from project or model files. | STEP and full 3MF behavior are file-format/parser surfaces, not this output-summary slice. | Depend on existing project-file evidence only for trust-chain pattern, not import/export claims. |
| Live upstream PrusaSlicer execution in Bazel | Regenerating the fixture feels fresher. | It would add upstream build/runtime/toolchain dependency, slow CI, and blur fixture provenance with runtime parity. | Check in a reviewed static fixture and verify provenance/summary locally. |
| Reusing base Rust `export.workflows` G-code fixture as Prusa evidence | It is already local and small. | That fixture is Rust-generated base Slic3r evidence, not Prusa-generated output. | Add a separate Prusa fixture namespace and status row. |
| Bambu Studio, OrcaSlicer, network/device, profile auto-update, release, or sync behavior | Fork work invites broader downstream-slicer scope. | These surfaces have separate provenance, credential, licensing, privacy, release, and automation risks. | Keep all non-Prusa, network, profile-update, release, and sync surfaces deferred. |

## Feature Dependencies

```text
v1.9 source pins and fork inventories
    -> v1.10 Prusa profile-schema trust chain
        -> v1.11 Prusa project-file summary pattern
            -> v1.12 G-code output scope gate
                -> static Prusa-generated G-code fixture and provenance
                    -> expected-gcode-summary.tsv
                        -> typed Rust G-code summary boundary
                            -> fail-closed Bazel parity command
                                -> mutation guard
                                    -> exact fork.prusaslicer.gcode-output status row and docs

generated-outputs stays in progress
    -conflicts-> marking broad generated-output parity verified

Prusa G-code summary evidence
    -enables later-> arc fitting, wall seam, and support-generation research
    -does not complete-> arc fitting, wall seam, support generation, STEP, GUI,
                       printer-runtime, or byte parity
```

### Dependency Notes

- **v1.9 source pins and inventories are prerequisites:** `packages/fork-vendors/forks.tsv` pins PrusaSlicer to `version_2.9.5` at `9a583bd438b195856f3bcf7ea99b69ba4003a961`, and `packages/fork-inventories/prusaslicer.tsv` marks generated-output-adjacent rows as future candidates.
- **v1.10 is the trust-chain dependency:** the profile-schema slice proves the pattern for baseline review, fixture provenance, typed Rust parsing, parity command, mutation guard, exact fork row, and conservative docs.
- **v1.11 is the summary-artifact dependency:** the project-file slice proves a narrow expected-summary evidence artifact and Rust summary boundary while keeping broader file-format and generated-output claims deferred.
- **The raw G-code fixture must precede Rust work:** without fixture provenance and expected summary shape, the Rust parser has no reviewed contract to encode.
- **The Rust boundary must precede parity/status:** status publication should wait until `prusa_gcode_output_summary_lines` can summarize the raw fixture and the Bazel command fails closed on drift.
- **The global `generated-outputs` row must remain bounded:** v1.12 may add a fork row, but it should not upgrade global generated-output parity.

## MVP Definition

### Launch With (v1.12)

Minimum viable milestone: what is needed to validate this evidence slice.

- [ ] Reviewed `prusaslicer.gcode-output` scope gate with source identity,
  fixture decision, planned expected artifact, planned Rust boundary,
  planned command, status token, docs touched, and explicit deferrals.
- [ ] One checked-in small Prusa-generated `.gcode` fixture with provenance,
  update route, size/SHA guard, and non-overclaiming fixture README.
- [ ] `expected-gcode-summary.tsv` containing stable metadata and marker
  evidence only.
- [ ] Pure `slic3r_flavors::prusa_gcode_output` Rust summary boundary with
  focused tests and no Git, network, process, vendor sync, or filesystem
  discovery in the core parser.
- [ ] `bazel run //packages/parity:prusaslicer_gcode_output_parity` comparing
  Rust-derived summary lines against the expected artifact.
- [ ] Failure-mode test proving mutation/drift is caught.
- [ ] Exact `fork.prusaslicer.gcode-output` status row and docs that keep broad
  generated-output, printer-runtime, geometry, GUI, support, seam, arc,
  STEP, release, network, profile-update, sync, and byte-parity behavior
  deferred.

### Add After Validation (v1.x)

Features to add only after this narrow slice is trusted.

- [ ] A second Prusa-generated G-code fixture if maintainers need coverage for
  a different stable marker family.
- [ ] More marker classes in the typed summary boundary, but only after each
  marker is reviewed as stable.
- [ ] Phase-specific research for arc fitting, wall seam, or support generation
  using this fixture/provenance pattern as a prerequisite.

### Future Consideration (v2+)

Features to defer until the project is ready for deeper generated-output work.

- [ ] Full G-code content or byte comparison.
- [ ] Toolpath geometry, extrusion, support, seam, or arc semantic comparison.
- [ ] Printer runtime, firmware, physical print validation, send-to-printer,
  upload, cloud, or device communication.
- [ ] GUI export, G-code viewer, project interaction, and visual preview parity.
- [ ] Building or vendoring upstream PrusaSlicer in Bazel.

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Reviewed G-code scope gate | HIGH | LOW | P1 |
| Static Prusa-generated fixture provenance | HIGH | MEDIUM | P1 |
| Summary-only expected artifact | HIGH | MEDIUM | P1 |
| Typed Rust G-code summary boundary | HIGH | MEDIUM | P1 |
| Fail-closed fixture verifier | HIGH | MEDIUM | P1 |
| Bazel parity command | HIGH | MEDIUM | P1 |
| Mutation guard | HIGH | MEDIUM | P1 |
| Exact status/docs publication | HIGH | LOW | P1 |
| Second G-code fixture | MEDIUM | MEDIUM | P3 |
| Toolpath/geometry comparison | HIGH | HIGH | P3 |

**Priority key:**

- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have or future consideration

## Recommended Requirement Categories

| Category | Suggested IDs | What Requirements Should Cover |
|----------|---------------|--------------------------------|
| Prusa G-code Output Scope Gate | `PGSEL-01`, `PGSEL-02` | Reviewed scope record, evidence slug/status-token decision, source identity, fixture source decision, expected-summary contract, planned command, docs touched, reviewer signoff, and explicit deferred scope. |
| Prusa G-code Fixture Surface | `PGFIX-01`, `PGFIX-02` | Fixture namespace, raw `.gcode` file, provenance manifest, update route, expected summary shape, fixture verifier, and absence of live generation or upstream imports. |
| Rust Prusa G-code Summary Boundary | `PGSUM-01`, `PGSUM-02`, `PGSUM-03` | Typed parsing of stable G-code metadata/markers, metadata traceability to source/fixture/status, focused Rust tests, and no side-effect behavior in the parser. |
| Executable Prusa G-code Evidence | `PGEV-01`, `PGEV-02`, `PGEV-03` | Public Bazel parity command, mutation failure guard, exact status row, docs update, and explicit non-overclaiming language. |

Recommended phase shape:

1. **Phase 45: Prusa G-code Output Scope Gate**
1. **Phase 46: Prusa G-code Fixture Surface**
1. **Phase 47: Rust Prusa G-code Summary Boundary**
1. **Phase 48: Executable Prusa G-code Evidence**

## Adjacent Evidence Analysis

| Existing Evidence | What It Proves | v1.12 Approach |
|-------------------|----------------|----------------|
| `export.workflows` | Base Rust CLI can create scoped output artifacts, including a tiny Rust-generated G-code fixture. | Do not reuse as Prusa evidence; keep it as proof that base export naming exists. |
| `fork.prusaslicer.profile-schema` | v1.10 Prusa profile/config expected-summary evidence is executable and verified. | Reuse the checklist, fixture, Rust parser, parity, status, and docs discipline. |
| `fork.prusaslicer.project-file` | v1.11 project-file expected-summary evidence is executable and verified. | Reuse the summary-only and deferred-semantics pattern, but have Rust parse the raw G-code fixture. |
| `generated-outputs` | Generated outputs are still `in progress`; geometry/content parity is deferred. | Keep this row in progress while adding only a narrow fork G-code output evidence row. |
| `prusaslicer.arc-fitting`, `prusaslicer.wall-seam`, `prusaslicer.support-generation` | Local inventory marks these as future candidates that depend on generated-output evidence. | Mention them as future consumers, not as completed v1.12 features. |

## Sources

- `.planning/PROJECT.md`
- `.planning/MILESTONES.md`
- `.planning/milestones/v1.10-REQUIREMENTS.md`
- `.planning/milestones/v1.10-ROADMAP.md`
- `.planning/milestones/v1.11-REQUIREMENTS.md`
- `.planning/milestones/v1.11-ROADMAP.md`
- `packages/fork-vendors/forks.tsv`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/fork-inventories/category-map.tsv`
- `packages/prusa-baseline/profile-schema-checklist.md`
- `packages/prusa-project-file-scope/project-file-scope.md`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
- `packages/parity/README.md`
- `packages/parity/status.tsv`
- `docs/port/README.md`
- `docs/port/migration-guidance.md`
- `docs/port/package-map.md`
- `docs/port/parity-matrix.md`
- `docs/port/contract-inventory.md`
- Pinned Bright Builds standards: architecture, verification, testing, and Rust
  pages at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`

## Verification Notes

- Local `.planning/REQUIREMENTS.md` was not present during research; this file
  is intended to feed the v1.12 requirements pass.
- The exact G-code fixture is intentionally left for the Phase 45 scope gate.
  No local file currently proves a Prusa-generated G-code fixture has already
  been selected for v1.12.
- The feature shape is HIGH confidence because it follows the shipped v1.10
  and v1.11 evidence pattern and is consistent with current parity/status docs.

______________________________________________________________________

*Feature research for: v1.12 PrusaSlicer G-code output evidence foundation*
*Researched: 2026-06-06*
