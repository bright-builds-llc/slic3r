# Phase 62: Wall-Seam Scope Contract - Research

**Researched:** 2026-06-26
**Domain:** Bazel/Bash metadata scope package for PrusaSlicer wall-seam evidence
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

All lines in this section are copied from `.planning/phases/62-wall-seam-scope-contract/62-CONTEXT.md`. [VERIFIED: .planning/phases/62-wall-seam-scope-contract/62-CONTEXT.md]

### Locked Decisions

### Contract placement

- **D-01:** Create a new wall-seam-specific scope package, expected at
  `packages/prusa-wall-seam-scope`, instead of extending
  `packages/prusa-gcode-output-scope` or `packages/prusa-arc-fitting-scope`.
  Wall seam has its own inventory row, category-map row, planned fixture
  namespace, planned Rust boundary, and planned status token, so a separate
  package keeps the evidence contract inspectable without widening existing
  G-code output or arc-fitting evidence.
- **D-02:** The human-readable source of truth should be a package-local scope
  record, expected as `packages/prusa-wall-seam-scope/wall-seam-scope.md`.
  The record must name the accepted source identity, source anchors, inventory
  and category-map rows, approved seam fields, planned downstream artifact
  paths, security note, deferred scope, and reviewer signoff.
- **D-03:** Add package-local verification wiring consistent with the existing
  scope package pattern: `README.md`, `BUILD.bazel`,
  `verify_prusa_wall_seam_scope.sh`, and a mutation suite such as
  `verify_prusa_wall_seam_scope_test.sh`.

### Approved wall-seam evidence fields

- **D-04:** The scope contract must define a closed field set for Phase 63
  checked-in wall-seam summaries and Phase 64 typed parsing. Recommended
  approved fields are: `source_ref`, `inventory_source_paths`,
  `source_anchor`, `fixture_id`, `fixture_path`,
  `seam_transition_observations`, `layer_context_observations`,
  `travel_context_observations`, `coordinate_bounds`,
  `extrusion_observations`, `retraction_observations`, and
  `evidence_boundary`.
- **D-05:** Every approved field must state its evidence boundary in the scope
  record. Seam-transition rows are checked-in observation facts only, layer
  and travel context rows are fixture-summary context only, coordinate bounds
  are bounded observations only, extrusion and retraction values are summary
  observations only, and none of these fields prove wall-seam algorithm
  equivalence, seam visibility, byte parity, printability, firmware behavior,
  printer-runtime behavior, GUI behavior, or generated-output parity.
- **D-06:** Unknown seam fields, missing required fields, duplicate field rows,
  out-of-order field rows when the contract requires order, unsupported claim
  text, traceability drift, and missing deferred-scope language must fail
  closed in the verifier.

### Traceability and planned downstream artifacts

- **D-07:** The contract must trace to the existing `prusaslicer.wall-seam` row
  in `packages/fork-inventories/prusaslicer.tsv` and the `seam.shared` row in
  `packages/fork-inventories/category-map.tsv`.
- **D-08:** The accepted source identity is
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
  The source path is `src/libslic3r/GCode/SeamAligned.cpp`. The contract may
  include companion anchors only when they are exact and source-pinned.
- **D-09:** The planned fixture namespace should be
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/`.
  Phase 62 may name this namespace and its expected summary path, but Phase 63
  owns checked-in fixture bytes, provenance rows, expected wall-seam summaries,
  and fixture drift guards.
- **D-10:** The planned expected wall-seam summary artifact should be named
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv`
  unless Phase 63 records a narrower fixture-specific reason to rename it.
- **D-11:** The planned Rust boundary should be
  `slic3r_flavors::prusa_wall_seam` in Phase 64. Keep the boundary pure and
  data-in/data-out over caller-supplied checked-in artifacts.
- **D-12:** The planned public evidence command should be
  `bazel run //packages/parity:prusaslicer_wall_seam_parity` in Phase 65.
  Phase 62 records this as planned text only; it must not create or publish the
  public command.
- **D-13:** The planned status token should be `fork.prusaslicer.wall-seam` in
  Phase 65 only. Phase 62 must keep the token planned and must not add a
  verified row to `packages/parity/status.tsv`.

### Status and no-overclaiming constraints

- **D-14:** Preserve `generated-outputs` exactly as `in progress` in
  `packages/parity/status.tsv`.
- **D-15:** Preserve the existing `fork.prusaslicer.gcode-output` and
  `fork.prusaslicer.arc-fitting` row text and meaning. Wall-seam scope work
  must not widen either row or imply the current semantic G-code or
  arc-fitting evidence already covers wall-seam behavior.
- **D-16:** The planned `fork.prusaslicer.wall-seam` wording must stay limited
  to the narrow v1.16 checked-in wall-seam summary evidence chain. It must
  explicitly defer byte-for-byte G-code parity, broad generated-output parity,
  full wall-seam algorithm or geometry equivalence, seam visibility,
  printability, firmware behavior, printer-runtime behavior, GUI behavior,
  support generation, STEP import, full 3MF import/export, binary G-code,
  thumbnails, post-processing, host upload, network/device behavior, profile
  auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
  upstream source imports, release behavior, sync automation, and non-Prusa
  fork behavior.
- **D-17:** The security note should be explicit: no secrets, credentials,
  private data, runtime file discovery, Git, network, device, host upload,
  release, sync, upstream import, or printer-runtime behavior is introduced by
  the scope package.

### the agent's Discretion

- Choose the exact verifier helper function names, provided the script remains
  readable Bash with `set -euo pipefail`, package-local defaults, and
  deterministic failure messages.
- Choose whether the scope record uses one traceability table or several
  focused tables, provided maintainers can inspect source identity, inventory
  row, source anchors, planned paths, status wording, deferred scope, security
  note, and reviewer signoff in one document.
- Choose exact mutation test names, provided each test proves one failure mode
  and uses isolated temp copies rather than mutating repo sources.

### Deferred Ideas (OUT OF SCOPE)

- Phase 63 owns checked-in fixture bytes, fixture provenance, update rules,
  `expected-wall-seam-summary.tsv`, and fixture-level drift guards.
- Phase 64 owns the pure typed Rust `prusa_wall_seam` parser/readiness boundary
  and Cargo/Bazel tests.
- Phase 65 owns the public `prusaslicer_wall_seam_parity` command, public
  mutation guards, `fork.prusaslicer.wall-seam` status row, and public docs.
- Broad generated-output parity, byte-for-byte G-code parity, full wall-seam
  algorithm or geometry equivalence, seam visibility, printability, runtime,
  GUI, support generation, STEP import, release, sync, non-Prusa forks,
  upstream imports, and external device behavior remain out of scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| SEAMSCOPE-01 | Maintainer can inspect a reviewed Prusa wall-seam evidence scope contract that names the accepted source identity, inventory row, category-map row, source anchors, fixture namespace, expected wall-seam summary artifact, Rust boundary, public evidence command, planned status wording, docs touched, security note, deferred scope, and reviewer signoff. | Use `packages/prusa-wall-seam-scope/wall-seam-scope.md` with the Phase 57 pre-publication arc-fitting section pattern and exact wall-seam inventory/category/status values. [VERIFIED: 62-CONTEXT.md, git show 54351651d:packages/prusa-arc-fitting-scope/arc-fitting-scope.md, packages/fork-inventories/prusaslicer.tsv, packages/fork-inventories/category-map.tsv] |
| SEAMSCOPE-02 | Maintainer can run a fail-closed wall-seam scope verifier that rejects unsupported seam fields, duplicate or missing field rows, traceability drift, unsupported generated-output claims, unsupported runtime or printability claims, and missing deferred-scope language. | Reuse the Phase 57 verifier helper pattern: exact Markdown rows, closed field row count, exact TSV row checks, category reference count, status row count, zero premature feature status rows, and isolated temp mutation tests. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh] |
| SEAMSCOPE-03 | Maintainer can confirm the broad `generated-outputs` status row remains `in progress`, the existing `fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting` status rows are not widened, and the planned `fork.prusaslicer.wall-seam` status row remains limited to the exact narrow evidence slice planned by this milestone. | The verifier must require exact current G-code and arc-fitting status rows, require exactly one `generated-outputs` row with status `in progress`, and require zero `fork.prusaslicer.wall-seam` rows during Phase 62. [VERIFIED: packages/parity/status.tsv, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
</phase_requirements>

## Summary

Phase 62 is not a parser, fixture, status-publication, or docs-publication phase; it is a metadata-only scope contract plus fail-closed verifier package. [VERIFIED: .planning/ROADMAP.md, .planning/REQUIREMENTS.md, 62-CONTEXT.md]

Use the Phase 57 pre-publication arc-fitting package as the closest implementation model, not the current post-Phase-60 arc-fitting package state. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/*, packages/prusa-arc-fitting-scope/*] The current arc package has been updated to require the published `fork.prusaslicer.arc-fitting` row, while Phase 62 must require the planned `fork.prusaslicer.wall-seam` row to remain absent from `packages/parity/status.tsv`. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, 62-CONTEXT.md]

**Primary recommendation:** Create `packages/prusa-wall-seam-scope` with `README.md`, `wall-seam-scope.md`, `BUILD.bazel`, `verify_prusa_wall_seam_scope.sh`, and `verify_prusa_wall_seam_scope_test.sh`; use exact row checks and isolated mutation tests to fail closed on field, traceability, status, and overclaim drift. [VERIFIED: 62-CONTEXT.md, packages/prusa-arc-fitting-scope/BUILD.bazel, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

## Project Constraints (from AGENTS.md)

| Constraint | Planning Impact |
|------------|-----------------|
| Do not edit managed Bright Builds blocks or managed files directly. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md] | Phase 62 should create/edit only the new wall-seam scope package and any explicitly planned metadata, not managed standards text. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md] |
| Read repo-local guidance and relevant Bright Builds standards before planning or implementation. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md, standards/index.md] | Planner can assume these sources informed this research and should reference them in plans. [VERIFIED: this research session] |
| Do not run `mdformat` over phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md] | Not directly applicable to `62-RESEARCH.md`, but future summaries must preserve YAML frontmatter manually. [VERIFIED: AGENTS.md] |
| Before commits, run relevant repo-native verification and do not commit failing checks. [VERIFIED: standards/core/verification.md] | Phase plans should include `bazel run`/`bazel test` checks and `git diff --check` for changed files. [VERIFIED: standards/core/verification.md] |
| Checked-in Bash scripts should use `#!/usr/bin/env bash`, `set -euo pipefail`, quoted variables, and visible failures. [VERIFIED: AGENTS.md, packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] | New verifier and mutation suite should follow the existing scope package Bash style. [VERIFIED: AGENTS.md, packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| Unit tests should prove one concern and use Arrange/Act/Assert when helpful. [VERIFIED: standards/core/testing.md, packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh] | Each mutation test should cover one failure mode and use isolated temp copies. [VERIFIED: standards/core/testing.md, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh] |
| Functional core and parse-at-boundary guidance applies to future Rust phases. [VERIFIED: standards/core/architecture.md, standards/languages/rust.md] | Phase 62 should only name `slic3r_flavors::prusa_wall_seam`; Rust implementation remains Phase 64. [VERIFIED: 62-CONTEXT.md, standards/languages/rust.md] |
| `standards-overrides.md` contains only placeholder rows and no active local exceptions. [VERIFIED: standards-overrides.md] | Use the default Bright Builds verification, testing, architecture, and Rust standards. [VERIFIED: standards-overrides.md, AGENTS.bright-builds.md] |
| No project-local skills were found under `.claude/skills/` or `.agents/skills/`. [VERIFIED: find .claude/skills .agents/skills] | Planner does not need to account for additional repo-local skill instructions. [VERIFIED: find .claude/skills .agents/skills] |

## Standard Stack

### Core

| Tool/Package | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| Bazel | 8.6.0 | Package targets, `sh_binary`, `sh_test`, and runfiles data wiring. | Existing scope packages use Bazel for verifier binaries and mutation tests. [VERIFIED: bazel --version, packages/prusa-arc-fitting-scope/BUILD.bazel, packages/prusa-gcode-output-scope/BUILD.bazel] |
| Bash | 3.2.57 | Deterministic verifier and mutation test scripts. | Existing scope packages are Bash scripts with `set -euo pipefail`. [VERIFIED: bash --version, packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| awk/grep/sed/coreutils | System tools | Exact Markdown and TSV checks. | Existing verifiers use `awk` for row counts and `grep -F`/`grep -E` for required/rejected text. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| `packages/prusa-wall-seam-scope` | New package | Wall-seam scope contract, verifier, mutation tests, package README. | Locked Phase 62 decision requires a separate package. [VERIFIED: 62-CONTEXT.md] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| shfmt | 3.12.0 | Optional shell formatting check. | Use in check mode or diff/list mode if the phase edits shell scripts. [VERIFIED: shfmt --version, standards/core/verification.md] |
| ShellCheck | 0.11.0 | Optional shell static analysis. | Use on new verifier scripts if locally available; do not make it a new dependency. [VERIFIED: shellcheck --version, standards/core/verification.md] |
| Git | 2.53.0 | Historical comparison of Phase 57 pre-publication package state. | Use only for local history inspection, not runtime behavior in the verifier. [VERIFIED: git --version, 62-CONTEXT.md D-17] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| New `packages/prusa-wall-seam-scope` package | Extend `packages/prusa-gcode-output-scope` or `packages/prusa-arc-fitting-scope` | Rejected by locked decision because wall seam has separate inventory/category/status/fixture/Rust boundaries. [VERIFIED: 62-CONTEXT.md D-01] |
| Exact Bash checks | Generic Markdown parser or custom DSL | Existing repo pattern is exact Markdown/TSV verification with small Bash helpers; a parser would add dependency and abstraction without reducing risk. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, AGENTS.md dependency guidance] |
| Published status row guard | Planned/absent status guard | Phase 62 must use planned/absent status guard; published status belongs to Phase 65. [VERIFIED: 62-CONTEXT.md D-13, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |

**Installation:** No new dependency installation is needed. [VERIFIED: package patterns and environment audit]

**Version verification:** Versions were verified with `bazel --version`, `bash --version`, `shfmt --version`, `shellcheck --version`, and `git --version`. [VERIFIED: local command outputs]

## Architecture Patterns

### Recommended Project Structure

```text
packages/prusa-wall-seam-scope/
|-- BUILD.bazel                         # Bazel sh_binary/sh_test/filegroup wiring
|-- README.md                           # Package boundary and command docs
|-- wall-seam-scope.md                  # Human-readable source of truth
|-- verify_prusa_wall_seam_scope.sh     # Fail-closed verifier
`-- verify_prusa_wall_seam_scope_test.sh # Isolated mutation suite
```

This mirrors the completed arc-fitting and G-code scope package shape. [VERIFIED: packages/prusa-arc-fitting-scope/BUILD.bazel, packages/prusa-gcode-output-scope/BUILD.bazel]

### Pattern 1: Scope Record Sections

Use these sections in `wall-seam-scope.md`: `## Scope Record`, `## Source Row Details`, `## Approved Wall-Seam Evidence Fields`, `## Wall-Seam Traceability`, `## Planned Status Wording`, and `## Boundary`. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

The scope record should include the inventory row ID, accepted source identity, inventory row source, source path, planned fixture namespace, planned expected summary artifact, planned Rust boundary, planned public evidence command, planned status token, docs touched, security note, deferred scope, and reviewer signoff. [VERIFIED: 62-CONTEXT.md D-02, git show 54351651d:packages/prusa-arc-fitting-scope/arc-fitting-scope.md]

### Pattern 2: Exact Traceability Inputs

The exact wall-seam inventory row is:

```text
prusaslicer.wall-seam	prusaslicer	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	src/libslic3r/GCode/SeamAligned.cpp	wall-seam	wall-seam	shared-downstream	medium	generated-outputs	future-candidate	none	Wall seam planning row; future parity requires geometry and output fixtures before behavior is claimed.
```

[VERIFIED: packages/fork-inventories/prusaslicer.tsv]

The exact category-map row is:

```text
seam.shared	wall-seam	shared-downstream	future-candidate	prusaslicer.wall-seam	Prusa seam row is a shared downstream future candidate.
```

[VERIFIED: packages/fork-inventories/category-map.tsv]

### Pattern 3: Source Anchors

Use source-pinned GitHub line anchors only; do not quote algorithm bodies or infer equivalence from them. [VERIFIED: 62-CONTEXT.md D-08, https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode/SeamAligned.cpp]

Recommended anchors:

| Anchor | Why Include |
|--------|-------------|
| `src/libslic3r/GCode/SeamAligned.cpp#L16` | Names the `Slic3r::Seams::Aligned` namespace. [VERIFIED: PrusaSlicer raw source at commit 9a583bd438b195856f3bcf7ea99b69ba4003a961] |
| `src/libslic3r/GCode/SeamAligned.cpp#L115-L148` | Covers `get_seam_options`, a stable source-level seam option helper. [VERIFIED: PrusaSlicer raw source at commit 9a583bd438b195856f3bcf7ea99b69ba4003a961] |
| `src/libslic3r/GCode/SeamAligned.cpp#L272-L313` | Covers `get_seam_candidate`, a source-level seam candidate helper. [VERIFIED: PrusaSlicer raw source at commit 9a583bd438b195856f3bcf7ea99b69ba4003a961] |
| `src/libslic3r/GCode/SeamAligned.cpp#L463-L525` | Covers `get_object_seams`, the object-level seam aggregation entry in this file. [VERIFIED: PrusaSlicer raw source at commit 9a583bd438b195856f3bcf7ea99b69ba4003a961] |
| `src/libslic3r/GCode/SeamAligned.hpp#L89-L99` | Provides the header declaration for `Params` and `get_object_seams` if the contract wants a companion anchor. [VERIFIED: PrusaSlicer raw source at commit 9a583bd438b195856f3bcf7ea99b69ba4003a961] |

### Pattern 4: Verifier Structure

Use small Bash helpers: `require_file`, `require_text`, `reject_text`, `require_section_table_row`, `require_section_table_exact_row`, `require_section_table_body_row_count`, `require_exact_tsv_row_once`, `require_first_field_count`, and `require_category_reference_count`. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

The `main` sequence should check files, README boundary text, scope record rows, source row details, field contract, traceability record, inventory/category rows, status boundaries, overclaiming text, and deferred scope terms. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

### Anti-Patterns to Avoid

- **Copying current arc publication state:** Current `packages/prusa-arc-fitting-scope` requires the published arc status row; Phase 62 must use the pre-publication absence guard for wall seam. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]
- **Extending G-code or arc status meanings:** Wall-seam work must not modify the existing exact `fork.prusaslicer.gcode-output` or `fork.prusaslicer.arc-fitting` rows. [VERIFIED: 62-CONTEXT.md D-15, packages/parity/status.tsv]
- **Loose presence-only checks:** Require exact rows plus first-field counts so missing, duplicate, and mutated rows fail closed. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]
- **Runtime source discovery:** The scope package must not call Git, network, upstream import, or runtime file discovery. [VERIFIED: 62-CONTEXT.md D-17]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Wall-seam fixture data | Fixture corpus or expected summary rows | Planned text only in `wall-seam-scope.md` | Phase 63 owns fixture bytes and `expected-wall-seam-summary.tsv`. [VERIFIED: 62-CONTEXT.md deferred ideas] |
| Rust parser/readiness | `slic3r_flavors::prusa_wall_seam` implementation | Planned boundary name only | Phase 64 owns Rust parsing and Cargo/Bazel tests. [VERIFIED: 62-CONTEXT.md D-11, deferred ideas] |
| Public parity command | `//packages/parity:prusaslicer_wall_seam_parity` target | Planned command text only | Phase 65 owns public executable evidence. [VERIFIED: 62-CONTEXT.md D-12, deferred ideas] |
| Public wall-seam status row | `fork.prusaslicer.wall-seam` in `status.tsv` | Zero-row absence guard | Phase 62 must not publish verified status. [VERIFIED: 62-CONTEXT.md D-13] |
| Markdown/TSV validation framework | New parser dependency | Existing Bash exact-row helpers | Existing scope packages verify contract integrity without new dependencies. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| Broad output comparison | Byte diff, geometry comparator, printability/runtime checks | Deferred-scope text and forbidden-claim checks | v1.16 only proves narrow checked-in wall-seam summary evidence after later phases. [VERIFIED: .planning/REQUIREMENTS.md, 62-CONTEXT.md] |

**Key insight:** Phase 62 should authorize later work, not perform it; the verifier's job is to make unauthorized claims fail before Phase 63-65 artifacts exist. [VERIFIED: .planning/ROADMAP.md, 62-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Reusing Post-Publication Arc Status Logic

**What goes wrong:** The new verifier requires `fork.prusaslicer.wall-seam` to exist in `packages/parity/status.tsv`. [VERIFIED: comparison between current arc verifier and Phase 57 historical verifier]

**Why it happens:** The current arc-fitting verifier was updated after Phase 60 to require the published arc row. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

**How to avoid:** Base wall-seam status logic on `git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh`, where the feature row count must be zero. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

**Warning signs:** A `WALL_SEAM_STATUS_ROW` exact row is required during Phase 62, or `packages/parity/status.tsv` is edited in Phase 62. [VERIFIED: 62-CONTEXT.md D-13]

### Pitfall 2: Field Count Without Exact Field Rows

**What goes wrong:** A mutation can replace an approved field with another row while preserving the row count. [VERIFIED: existing mutation tests cover unsupported/missing/duplicate field rows]

**Why it happens:** Count checks alone detect cardinality, not identity. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

**How to avoid:** Require exactly 12 approved wall-seam field rows and require each exact row text. [VERIFIED: 62-CONTEXT.md D-04, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

**Warning signs:** The verifier only calls a row-count helper for `## Approved Wall-Seam Evidence Fields`. [VERIFIED: code inspection pattern]

### Pitfall 3: Overclaim Regex Rejects Legitimate Deferred Text

**What goes wrong:** Required deferral language such as "does not prove printability" is rejected as an unsupported claim. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

**Why it happens:** A broad forbidden-term scan without verbs or phase-specific context cannot distinguish deferral from claim. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

**How to avoid:** Use explicit forbidden claim strings plus phase-scoped verb/term regexes, and verify required deferred terms separately. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

**Warning signs:** `grep -E "printability|runtime|generated-output"` rejects any occurrence in README/scope. [VERIFIED: code inspection pattern]

### Pitfall 4: Missing Arc-Fitting Preservation

**What goes wrong:** The wall-seam verifier preserves G-code status but forgets the existing arc-fitting status row. [VERIFIED: 62-CONTEXT.md D-15, packages/parity/status.tsv]

**Why it happens:** Phase 57 had only G-code to preserve; Phase 62 must preserve both G-code and arc-fitting rows. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, packages/parity/status.tsv]

**How to avoid:** Include exact constants and first-field counts for `fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting`. [VERIFIED: packages/parity/status.tsv]

**Warning signs:** `verify_status_boundaries` has no `fork.prusaslicer.arc-fitting` check. [VERIFIED: code inspection pattern]

### Pitfall 5: Parallel Bazel Runs

**What goes wrong:** Concurrent Bazel commands wait on the output-base lock. [VERIFIED: local run of parallel `bazel run` commands]

**Why it happens:** Bazel serializes access to the output base. [VERIFIED: local Bazel output]

**How to avoid:** Use one Bazel invocation with multiple test targets where possible. [VERIFIED: local `bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test` passed]

**Warning signs:** Output includes "Another command holds the output base lock". [VERIFIED: local Bazel output]

## Code Examples

### BUILD.bazel Shape

```python
package(default_visibility = ["//visibility:public"])

exports_files([
    "README.md",
    "wall-seam-scope.md",
])

sh_binary(
    name = "verify",
    srcs = ["verify_prusa_wall_seam_scope.sh"],
    data = [
        "README.md",
        "wall-seam-scope.md",
        "//packages/fork-inventories:prusaslicer.tsv",
        "//packages/fork-inventories:category-map.tsv",
        "//packages/parity:status.tsv",
    ],
    args = [
        "$(location README.md)",
        "$(location wall-seam-scope.md)",
        "$(location //packages/fork-inventories:prusaslicer.tsv)",
        "$(location //packages/fork-inventories:category-map.tsv)",
        "$(location //packages/parity:status.tsv)",
    ],
)

sh_test(
    name = "verify_prusa_wall_seam_scope_test",
    srcs = ["verify_prusa_wall_seam_scope_test.sh"],
    data = ["verify_prusa_wall_seam_scope.sh"],
)
```

This is the existing metadata-only scope package Bazel pattern with wall-seam names substituted. [VERIFIED: packages/prusa-arc-fitting-scope/BUILD.bazel]

### Status Boundary Helper

```bash
verify_status_boundaries() {
    local generated_count
    local wall_seam_status_count

    generated_count="$(awk -F '\t' '$1 == "generated-outputs" && $2 == "in progress" { count++ } END { print count + 0 }' "${status_file}")"
    if [[ "${generated_count}" != "1" ]]; then
        error "packages/parity/status.tsv: expected generated-outputs to remain in progress"
    fi
    require_first_field_count "${status_file}" "packages/parity/status.tsv" "generated-outputs" "1"

    require_exact_tsv_row_once "${status_file}" "packages/parity/status.tsv" "${GCODE_OUTPUT_STATUS_ROW}"
    require_first_field_count "${status_file}" "packages/parity/status.tsv" "fork.prusaslicer.gcode-output" "1"

    require_exact_tsv_row_once "${status_file}" "packages/parity/status.tsv" "${ARC_FITTING_STATUS_ROW}"
    require_first_field_count "${status_file}" "packages/parity/status.tsv" "fork.prusaslicer.arc-fitting" "1"

    wall_seam_status_count="$(awk -F '\t' '$1 == "fork.prusaslicer.wall-seam" { count++ } END { print count + 0 }' "${status_file}")"
    if [[ "${wall_seam_status_count}" != "0" ]]; then
        error "packages/parity/status.tsv: no verified fork.prusaslicer.wall-seam status row may be published in Phase 62"
    fi
}
```

This adapts the Phase 57 pre-publication absence guard and adds the Phase 62 arc-fitting preservation requirement. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, packages/parity/status.tsv, 62-CONTEXT.md D-15]

### Mutation Test Shape

```bash
test_premature_wall_seam_status_publication_fails() {
    # Arrange
    local dir="${tmp_dir}/premature-wall-seam-status"
    write_valid_fixture "${dir}"
    printf '%s\n' $'fork.prusaslicer.wall-seam\tverified\t//packages/parity:prusaslicer_wall_seam_parity\tPremature wall-seam status.' >>"${dir}/packages/parity/status.tsv"

    # Act
    if run_verifier "${dir}" "${tmp_dir}/premature-wall-seam-status.out" "${tmp_dir}/premature-wall-seam-status.err"; then
        fail "premature wall-seam status fixture passed"
    fi

    # Assert
    assert_contains "${tmp_dir}/premature-wall-seam-status.err" '^error:'
    assert_contains "${tmp_dir}/premature-wall-seam-status.err" 'no verified fork\.prusaslicer\.wall-seam status row may be published in Phase 62'
}
```

This follows the existing isolated temp-copy mutation style and Arrange/Act/Assert comments. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh, standards/core/testing.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Put generated-output evidence scope in `packages/prusa-gcode-output-scope`. | Use feature-specific scope package for medium-complexity slices such as arc fitting and wall seam. | Phase 57 created `packages/prusa-arc-fitting-scope`. [VERIFIED: git log -- packages/prusa-arc-fitting-scope, 57-CONTEXT.md] | Planner should create `packages/prusa-wall-seam-scope` instead of adding a section to G-code or arc scope packages. [VERIFIED: 62-CONTEXT.md D-01] |
| Scope package only planned future status. | After executable evidence phases, scope package docs/verifiers can be updated to require published status rows. | Arc-fitting changed between Phase 57 and Phase 60. [VERIFIED: git log -- packages/prusa-arc-fitting-scope] | Phase 62 must stay in pre-publication mode until Phase 65. [VERIFIED: 62-CONTEXT.md D-13] |
| One existing generated-output row. | Existing public generated-output evidence includes narrow semantic G-code and narrow arc-fitting rows while broad `generated-outputs` remains `in progress`. | Current `packages/parity/status.tsv` has both rows. [VERIFIED: packages/parity/status.tsv] | Wall-seam verifier must preserve both existing rows and keep the wall-seam row absent. [VERIFIED: 62-CONTEXT.md D-15] |

**Deprecated/outdated:** Treating `fork.prusaslicer.gcode-output` as covering wall seam is rejected for Phase 62. [VERIFIED: 62-CONTEXT.md D-15]

## Assumptions Log

All claims in this research are tagged `[VERIFIED: ...]` or `[CITED: ...]`; no `[ASSUMED]` claims are intentionally used. [VERIFIED: this research file]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| - | None | - | - |

## Open Questions

1. **Reviewer signoff exact date**
   - What we know: Phase 57 used `Peter Ryszkiewicz, 2026-06-23 UTC`, and Phase 62 context requires reviewer signoff. [VERIFIED: git show 54351651d:packages/prusa-arc-fitting-scope/arc-fitting-scope.md, 62-CONTEXT.md]
   - What's unclear: Whether the Phase 62 signoff date should be the implementation date or fixed to the context date `2026-06-26`. [VERIFIED: 62-CONTEXT.md generated_at]
   - Recommendation: Use the actual Phase 62 implementation date in UTC unless the maintainer directs otherwise. [VERIFIED: existing arc pattern]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `BUILD.bazel`, `sh_binary`, `sh_test`, verifier runs | yes | 8.6.0 | None needed. [VERIFIED: bazel --version] |
| Bash | verifier and mutation suite | yes | 3.2.57 | None needed. [VERIFIED: bash --version] |
| Git | local history inspection only | yes | 2.53.0 | Use checked-in current files if history is unavailable. [VERIFIED: git --version] |
| shfmt | optional shell formatting check | yes | 3.12.0 | Skip if unavailable; do not install just for policy. [VERIFIED: shfmt --version, standards/core/verification.md] |
| ShellCheck | optional shell analysis | yes | 0.11.0 | Skip if unavailable; do not install just for policy. [VERIFIED: shellcheck --version, standards/core/verification.md] |

**Missing dependencies with no fallback:** None found. [VERIFIED: environment audit]

**Missing dependencies with fallback:** None found. [VERIFIED: environment audit]

## Security Domain

OWASP ASVS provides requirements for application security verification and secure development guidance. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Phase 62 introduces no authentication, credentials, secrets, or private data. [VERIFIED: 62-CONTEXT.md D-17] |
| V3 Session Management | no | Phase 62 introduces no sessions or runtime service behavior. [VERIFIED: 62-CONTEXT.md D-17] |
| V4 Access Control | no | Phase 62 creates a local metadata package and verifier only. [VERIFIED: 62-CONTEXT.md, packages/prusa-arc-fitting-scope pattern] |
| V5 Input Validation | yes | Validate Markdown and TSV inputs fail-closed with exact rows, counts, and forbidden-claim checks. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| V6 Cryptography | no | Phase 62 introduces no cryptography, secrets, or credential handling. [VERIFIED: 62-CONTEXT.md D-17] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Traceability tampering in TSV rows | Tampering | Require exact inventory/status rows once and exact category-map reference counts. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| Documentation overclaiming | Repudiation/Information integrity | Reject explicit broad generated-output, runtime, printability, algorithm-equivalence, seam-visibility, and non-Prusa claims. [VERIFIED: 62-CONTEXT.md D-16, packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| Premature status publication | Tampering | Require zero `fork.prusaslicer.wall-seam` rows in Phase 62. [VERIFIED: 62-CONTEXT.md D-13, git show 54351651d:packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh] |
| Shell path handling mistakes | Tampering/DoS | Quote variables, avoid `eval`, fail on missing files, and use `set -euo pipefail`. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh, AGENTS.md] |

## Verification Commands

Existing commands verified during research:

```bash
bazel run //packages/prusa-arc-fitting-scope:verify
bazel run //packages/prusa-gcode-output-scope:verify
bazel run //packages/fork-inventories:verify
bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test
```

All four existing verification commands passed during research. [VERIFIED: local command outputs]

Likely Phase 62 commands after implementation:

```bash
bazel run //packages/prusa-wall-seam-scope:verify
bazel test //packages/prusa-wall-seam-scope:verify_prusa_wall_seam_scope_test
bazel run //packages/fork-inventories:verify
bazel run //packages/prusa-gcode-output-scope:verify
bazel run //packages/prusa-arc-fitting-scope:verify
git diff --check -- packages/prusa-wall-seam-scope
```

The planner should prefer one Bazel invocation for multiple test targets when possible to avoid output-base lock waits. [VERIFIED: local Bazel output]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/62-wall-seam-scope-contract/62-CONTEXT.md` - locked decisions, discretion, deferred scope. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - SEAMSCOPE-01..03 and v1.16 out-of-scope boundary. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 62 goal, success criteria, and plan list. [VERIFIED: file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - v1.16 current state and accumulated generated-output evidence decisions. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards/index.md`, `standards/core/verification.md`, `standards/core/testing.md`, `standards/core/code-shape.md`, `standards/core/architecture.md`, `standards/languages/rust.md`, `standards-overrides.md` - project constraints and standards. [VERIFIED: file read]
- `packages/prusa-arc-fitting-scope/*` and `git show 54351651d:packages/prusa-arc-fitting-scope/*` - current and pre-publication feature-specific scope package patterns. [VERIFIED: file read and git history]
- `packages/prusa-gcode-output-scope/*` - older G-code scope package and status-preservation patterns. [VERIFIED: file read]
- `packages/fork-inventories/prusaslicer.tsv`, `packages/fork-inventories/category-map.tsv`, `packages/parity/status.tsv` - exact rows Phase 62 must verify. [VERIFIED: file read]
- `packages/parity/README.md`, `docs/port/package-map.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md` - current public docs constraints to preserve. [VERIFIED: file read]
- PrusaSlicer pinned source: `https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode/SeamAligned.cpp` and `SeamAligned.hpp` - exact source anchor candidates. [VERIFIED: curl raw.githubusercontent.com and web open]

### Secondary (MEDIUM confidence)

- OWASP ASVS project page - security verification framing. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Tertiary (LOW confidence)

- None. [VERIFIED: source log]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - package and tool patterns were verified from existing repo files and local versions. [VERIFIED: local command outputs, package files]
- Architecture: HIGH - Phase 62 decisions lock package placement and prior Phase 57 implementation provides a direct pre-publication model. [VERIFIED: 62-CONTEXT.md, git show 54351651d]
- Pitfalls: HIGH - risks come from current-vs-historical arc verifier differences and existing mutation coverage. [VERIFIED: packages/prusa-arc-fitting-scope, git show 54351651d]
- Source anchors: MEDIUM - anchors were verified against the pinned upstream source, but maintainers may choose a smaller subset. [VERIFIED: PrusaSlicer raw source, 62-CONTEXT.md D-08]

**Research date:** 2026-06-26
**Valid until:** 2026-07-26 for repo-local package patterns; re-check status rows immediately if Phase 65 or other generated-output status publication lands before planning completes. [VERIFIED: active roadmap state]
