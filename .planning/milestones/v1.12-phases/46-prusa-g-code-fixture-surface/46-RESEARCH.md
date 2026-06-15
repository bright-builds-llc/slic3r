# Phase 46: Prusa G-code Fixture Surface - Research

**Researched:** 2026-06-13  
**Domain:** Static PrusaSlicer G-code fixture provenance, expected-summary TSV, Bash/Bazel verifier  
**Confidence:** HIGH for local patterns and source identity; MEDIUM for the recommended derived fixture because upstream has no checked-in `.gcode` blob.

<user_constraints>
## User Constraints (from CONTEXT.md)

Provenance: copied from `.planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md`. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Fixture Namespace and Provenance

- **D-01:** Use the Phase 45 reserved flat namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`.
- **D-02:** Check in one small reviewed ASCII `.gcode` fixture in that
  namespace, with `.gitattributes` forcing text, LF line endings, and stable
  diff behavior for the fixture and TSV artifacts.
- **D-03:** Record provenance in `fixture-provenance.tsv` using the existing
  Prusa fork fixture model: fixture ID, vendor ID, inventory ID, source ref,
  accepted tag, peeled commit, source path, upstream URL, byte count, SHA-256,
  line-ending/encoding policy, role, Phase 45 scope record path, update route,
  status scope, privacy/post-processing exclusions, and broad deferrals.
- **D-04:** Pin all provenance to the accepted source identity
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` from
  the Phase 45 scope gate and `packages/fork-inventories/prusaslicer.tsv`.
  The selected fixture should come from PrusaSlicer source-controlled test or
  fixture data under that commit, not from live generation or a local printer
  export.
- **D-05:** The update route must require a reviewed intake change updating
  `packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
  and `packages/prusa-gcode-output-scope/gcode-output-scope.md`. Branch-head
  observations remain drift-only and do not update this fixture.

### Expected G-code Summary

- **D-06:** Create
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  as the only checked-in expected artifact for this phase.
- **D-07:** Keep the expected summary stable and summary-only. It should cover
  metadata and marker evidence such as source identity, fixture path, slicer or
  generated-by marker, flavor or printer/profile marker when present,
  representative G-code command markers, and deferred semantics notes.
- **D-08:** Use the exact columns reserved by the Phase 45 scope record:
  `source_ref`, `fixture_path`, `metadata_key`, `metadata_value`,
  `marker_key`, `marker_value`, and `notes`.
- **D-09:** Keep byte counts, hashes, upstream URLs, and update-route facts in
  provenance, not in `expected-gcode-summary.tsv`.
- **D-10:** Do not include geometry counts, extrusion totals, print duration,
  toolpath correctness, firmware compatibility, printability semantics,
  post-processing behavior, thumbnail/binary payloads, host upload behavior,
  status rows, or broad generated-output claims in the expected artifact.
  Use `notes` values to state the deferred semantics for each marker row.

### Fail-Closed Verifier

- **D-11:** Extend `packages/parity-fixtures/BUILD.bazel` with G-code fixture
  file exports, filegroups or aliases, `verify_prusa_gcode_output_fixture`, and
  `verify_prusa_gcode_output_fixture_test`, following the existing
  `prusaslicer.project-file` and `prusaslicer.profile-schema` fixture pattern.
- **D-12:** Implement the verifier as Bash with exact text checks plus targeted
  TSV header/row checks. Prefer the existing Prusa project-file and
  profile-schema fixture verifier style over a new parser framework.
- **D-13:** The verifier must fail when required fixture bytes, provenance,
  byte count, SHA-256, line-ending/encoding policy, expected-summary columns,
  update-route text, Phase 45 scope-record traceability, privacy or
  post-processing exclusions, or non-overclaiming boundary text are missing or
  inconsistent.
- **D-14:** The verifier or its tests must guard that Phase 47 and Phase 48
  artifacts have not been created early: no
  `slic3r_flavors::prusa_gcode_output` summary implementation, no
  `//packages/parity:prusaslicer_gcode_output_parity` target, and no
  `fork.prusaslicer.gcode-output` status row.
- **D-15:** Verification must remain local and hermetic. Do not fetch upstream
  source during verification, generate new G-code, execute printer-runtime
  behavior, run Git, access network services, import upstream source trees,
  ingest plugins, or process credentials.

### Docs and Handoff

- **D-16:** Update `packages/parity-fixtures/README.md` and the relevant
  `docs/port/` surfaces so maintainers can find the new fixture namespace, run
  the fixture verifier, and understand that Rust summary parsing, executable
  parity, and status publication remain unavailable until Phases 47 and 48.
- **D-17:** Docs must continue to defer byte-for-byte G-code parity, broad
  generated-output parity, toolpath geometry, extrusion, timing, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, printer-runtime behavior, firmware or printability behavior,
  GUI export or viewer behavior, binary G-code, thumbnails, post-processing,
  host upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
  automation.

### the agent's Discretion

- The agent may choose the exact small Prusa-controlled ASCII `.gcode` fixture
  from the accepted source commit, as long as provenance records the exact
  source path, byte count, SHA-256, encoding, and update route.
- The agent may choose exact marker rows for `expected-gcode-summary.tsv` when
  they remain stable, summary-only, and useful to Phase 47 typed parsing.
- The agent may decide whether to share small Bash helper functions with
  existing fixture verifiers or keep a separate G-code verifier, whichever is
  clearer and lower risk.
- The agent may choose the minimum docs set to update, provided the fixture
  package README and port docs expose the verifier and preserve the
  non-overclaiming boundary.

### Deferred Ideas (OUT OF SCOPE)

Phase 47 owns Rust `prusa_gcode_output` summary types, parser/summary logic,
metadata, and Rust tests. Phase 48 owns executable parity, mutation guard,
exact status publication, and public docs/status alignment.

Byte-for-byte G-code parity, broad generated-output parity, toolpath geometry,
extrusion, timing, support generation, wall seam behavior, arc fitting, STEP
import, full 3MF import/export, printer-runtime behavior, firmware or
printability behavior, GUI export or viewer behavior, binary G-code,
thumbnails, post-processing, host upload, network/device integration, profile
auto-update execution, fork release builds, Bambu Studio, OrcaSlicer, upstream
source imports, and sync automation remain outside Phase 46.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PGFIX-01 | Maintainer can inspect a dedicated Prusa G-code fixture namespace containing one small reviewed ASCII `.gcode` fixture, provenance, update rules, byte count, SHA-256, line-ending/encoding policy, and a summary-only `expected-gcode-summary.tsv` artifact that traces back to the scope gate. | Use the flat namespace, derived `gcodewriter-set-speed.gcode` candidate, provenance header, `.gitattributes`, README, and expected-summary shape documented below. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/parity-fixtures/BUILD.bazel; CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_gcodewriter.cpp#L20-L35] |
| PGFIX-02 | Maintainer can run a repo-owned fixture verifier that fails when required Prusa G-code fixture provenance, checksums, line-ending policy, expected-summary shape, update rules, privacy/post-processing exclusions, or non-overclaiming scope text are missing or inconsistent. | Mirror the Bash/Bazel fixture verifier and mutation-test pattern from the project-file fixture, adjusted to fail closed on ASCII/LF, SHA-256, provenance, summary rows, Phase 45 traceability, and Phase 47/48 absence. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh] |
</phase_requirements>

## Summary

Phase 46 should add a static fixture surface under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`, not a parser, generator, parity target, or status row. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] The implementation should mirror the Phase 42 project-file fixture pattern: checked-in namespace README, `.gitattributes`, provenance TSV, expected-summary TSV, Bazel filegroup/aliases, Bash verifier, shell mutation test, and narrow docs routing. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md; VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

The accepted PrusaSlicer commit has no source-controlled `.gcode` blobs in its recursive GitHub tree, so a literal copy from an upstream `.gcode` file is not available. [VERIFIED: GitHub API `git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1`, `truncated=false`, 4533 tree items, zero `.gcode` blob paths] The best source-controlled candidate is a small derived fixture from upstream `tests/fff_print/test_gcodewriter.cpp` fixed-point `GCodeWriter::set_speed` expected-output literals at lines 20, 25, 30, and 35. [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_gcodewriter.cpp#L20-L35]

**Primary recommendation:** create `gcodewriter-set-speed.gcode` with exactly four ASCII LF lines, record it as a source-controlled upstream test-literal derived fixture, use the Phase 46 `expected-gcode-summary.tsv` columns, and update the Phase 45 scope verifier so it no longer rejects the now-intentional Phase 46 fixture namespace. [VERIFIED: local shasum/file check over proposed bytes; VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

## Project Constraints (from AGENTS.md)

- Read and follow `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned Bright Builds standards before planning or implementation. [VERIFIED: AGENTS.md; VERIFIED: AGENTS.bright-builds.md]
- Keep `.planning/phases/*/*-SUMMARY.md` YAML `requirements-completed` synchronized and do not run `mdformat` over phase summary files; this phase writes `46-RESEARCH.md`, not a summary file. [VERIFIED: AGENTS.md]
- Use plan-first behavior for non-trivial work, include verification tasks, and re-plan if constraints change or verification disproves the approach. [VERIFIED: user-provided AGENTS.md]
- Prefer `rg` for text search and semantic tools when available; no repo-local LSP tools or project skill directories were available in this session. [VERIFIED: user-provided AGENTS.md; VERIFIED: project skill directory probe]
- For Bash scripts, use `#!/usr/bin/env bash`, `set -euo pipefail`, early-return style, helper functions, and visible error propagation. [VERIFIED: user-provided AGENTS.md; VERIFIED: Bright Builds code-shape standard]
- Do not hide substantial foreign-language logic in strings; repo-owned verifier logic should live in checked-in shell scripts rather than inline Bazel command strings. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Unit and verifier tests should prove one concern per test and use clear Arrange, Act, Assert structure where useful. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Before commit, run relevant repo-native verification for changed paths, plus available Markdown and shell formatter/checker surfaces. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- No active standards override changes the default rules; `standards-overrides.md` contains only the placeholder template. [VERIFIED: standards-overrides.md]

## Standard Stack

### Core

| Tool/Surface | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| Bash verifier scripts | GNU bash 3.2.57 on this machine | Fail-closed fixture validation and mutation tests | Existing Prusa fixture and scope packages use Bash `sh_binary`/`sh_test` verifiers. [VERIFIED: local `bash --version`; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; VERIFIED: packages/prusa-gcode-output-scope/BUILD.bazel] |
| Bazel | 8.6.0 on this machine | Repo-owned runnable verifier and test targets | Existing fixture surfaces expose `sh_binary`, `sh_test`, filegroups, and package boundaries through Bazel. [VERIFIED: local `bazel --version`; VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| TSV files | N/A | Provenance and expected-summary artifacts | Existing Prusa fixture bundles use TSV provenance and checked-in expected summary artifacts. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv] |
| `shasum -a 256`, `wc -c`, `awk`, `grep` | Local system tools | Byte count, SHA-256, exact row/header checks, and text checks | Existing fixture verifiers use these tools and keep validation local. [VERIFIED: local command availability; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |

### Supporting

| Tool/Surface | Version | Purpose | When to Use |
|--------------|---------|---------|-------------|
| `shfmt` | 3.12.0 | Shell formatting check | Run check/diff mode for touched shell scripts before finalizing. [VERIFIED: local `shfmt --version`; CITED: Bright Builds verification standard] |
| `shellcheck` | 0.11.0 | Shell diagnostics | Run on new fixture verifier and mutation test. [VERIFIED: local `shellcheck --version`; CITED: Bright Builds verification standard] |
| `mdformat` | 1.0.0 | Markdown formatting check | Use `--check` on changed Markdown docs, excluding phase `*-SUMMARY.md` files. [VERIFIED: local `mdformat --version`; VERIFIED: AGENTS.md] |
| `buildifier` | Missing locally | Bazel formatting | Do not make it a blocking dependency; follow adjacent BUILD.bazel style and verify with Bazel because the tool is unavailable. [VERIFIED: local command probe] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Derived upstream test-literal fixture | Upstream `.gcode` blob | No upstream `.gcode` blob exists at the accepted commit, so this is unavailable without changing the phase source decision. [VERIFIED: GitHub API tree query] |
| Static checked-in fixture | Live G-code generation | Live generation is explicitly out of scope and would violate the Phase 46 context. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| Bash exact checks | New parser framework | The phase is a fixture-surface phase, and existing fixtures use Bash exact checks rather than parser frameworks. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| New G-code semantic parser | Phase 47 Rust summary boundary | Parser/summary logic belongs to Phase 47, not Phase 46. [VERIFIED: .planning/ROADMAP.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |

**Installation:** no new npm, Cargo, Python, or system packages should be added for Phase 46. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md; VERIFIED: packages/parity-fixtures existing verifier pattern]

**Version verification:** npm package verification is not applicable because Phase 46 should not add npm dependencies. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

## Fixture Source Candidate

### Recommended Candidate

Use `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`. [VERIFIED: Phase 46 namespace decision; VERIFIED: candidate byte/hash computation]

```gcode
G1 F99999.123
G1 F1
G1 F203.2
G1 F203.201
```

Candidate facts:

| Fact | Value | Source |
|------|-------|--------|
| Upstream source path | `tests/fff_print/test_gcodewriter.cpp` | [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_gcodewriter.cpp#L20-L35] |
| Source identity | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | [VERIFIED: packages/fork-vendors/forks.tsv; VERIFIED: packages/fork-inventories/prusaslicer.tsv] |
| Fixture bytes | `42` | [VERIFIED: local `wc -c` over exact candidate bytes] |
| Fixture SHA-256 | `dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb` | [VERIFIED: local `shasum -a 256` over exact candidate bytes] |
| Encoding and line endings | US-ASCII text with LF final newlines | [VERIFIED: local `file --mime` and byte construction] |
| Why this candidate | The accepted upstream tree has no `.gcode` blobs, and these four exact expected-output literals are source-controlled under the accepted commit. | [VERIFIED: GitHub API tree query; CITED: upstream `test_gcodewriter.cpp` lines 20,25,30,35] |

### Rejected Candidates

| Candidate | Reason to Reject | Source |
|-----------|------------------|--------|
| Any upstream `*.gcode` file | No `.gcode` blob exists in the accepted commit's full recursive tree. | [VERIFIED: GitHub API tree query] |
| `packages/parity-fixtures/export-workflows/expected-gcode.txt` | Base export fixture reuse is explicitly excluded by Phase 46 success criteria. | [VERIFIED: .planning/ROADMAP.md; VERIFIED: user-provided Phase 46 success criteria] |
| G-code generated from upstream tests at implementation time | Live generation is explicitly excluded, and verifier must not generate G-code. | [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| `test_printgcode.cpp` generated output | The file verifies generated output behavior through runtime slicing, which Phase 46 must not execute or claim. | [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_printgcode.cpp] |

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity-fixtures/
├── BUILD.bazel
├── README.md
├── verify_prusa_gcode_output_fixture.sh
├── verify_prusa_gcode_output_fixture_test.sh
└── forks/prusaslicer/prusaslicer.gcode-output/
    ├── .gitattributes
    ├── README.md
    ├── fixture-provenance.tsv
    ├── expected-gcode-summary.tsv
    └── gcodewriter-set-speed.gcode
```

This structure mirrors the existing flat Prusa fixture namespaces and keeps the verifier local to `packages/parity-fixtures`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file]

### Pattern 1: Provenance First, Expected Summary Second

**What:** Put source identity, upstream URL, byte count, SHA-256, line-ending/encoding policy, update route, status scope, privacy/post-processing exclusions, and broad deferrals in `fixture-provenance.tsv`; keep `expected-gcode-summary.tsv` to source/fixture metadata and marker rows with deferred-semantics notes only. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

**When to use:** Use for every Phase 46 G-code fixture fact that Phase 47 will consume but that does not belong in runtime summary evidence. [VERIFIED: .planning/ROADMAP.md]

Recommended provenance header:

```text
fixture_id	vendor_id	inventory_id	source_ref	accepted_tag	peeled_commit	source_path	upstream_url	bytes	sha256	line_endings_encoding	role	phase45_scope_record	update_route	status_scope	privacy_post_processing_exclusions	broad_deferrals
```

Recommended provenance row values should include `gcodewriter-set-speed.gcode`, `prusaslicer`, `prusaslicer.gcode-output`, `version_2.9.5`, `9a583bd438b195856f3bcf7ea99b69ba4003a961`, `tests/fff_print/test_gcodewriter.cpp`, a GitHub URL with `#L20-L35`, `42`, the SHA-256 above, `ascii-lf`, `source-controlled-gcodewriter-set-speed-expected-output`, `packages/prusa-gcode-output-scope/gcode-output-scope.md`, and the reviewed intake route from D-05. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md; VERIFIED: local candidate byte/hash check; CITED: upstream test file URL]

### Pattern 2: Explicit Expected Summary Shape

Use the exact Phase 45 scope-record shape, now carried forward by Phase 46:

```text
source_ref	fixture_path	metadata_key	metadata_value	marker_key	marker_value	notes
```

Recommended rows:

```text
source_ref	fixture_path	metadata_key	metadata_value	marker_key	marker_value	notes
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	source_identity	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	source_literal	tests/fff_print/test_gcodewriter.cpp#L20-L35	Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_role	source-controlled-gcodewriter-set-speed-expected-output	line_1	G1 F99999.123	Representative fixed-point feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_role	source-controlled-gcodewriter-set-speed-expected-output	line_2	G1 F1	Representative integer feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_role	source-controlled-gcodewriter-set-speed-expected-output	line_3	G1 F203.2	Representative one-decimal feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode	fixture_role	source-controlled-gcodewriter-set-speed-expected-output	line_4	G1 F203.201	Representative three-decimal rounded feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.
```

Planner warning: the Phase 45 scope record owns the expected-summary column
contract. Plans should preserve `metadata_key`, `metadata_value`,
`marker_key`, `marker_value`, and `notes` rather than introducing a new TSV
shape in Phase 46. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Pattern 3: Verifier as Exact Contract

The verifier should:

- Accept either no args for repo-root operation or explicit path args for mutation tests, matching existing fixture verifier style. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]
- Check required files, exact byte count, exact SHA-256, exact TSV headers, exact row count, exact expected rows, README scope text, package README routing, Phase 45 scope-record traceability, and Phase 47/48 absence. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]
- Check ASCII/LF policy with local text inspection, not by trusting Git attributes alone. [VERIFIED: .planning/REQUIREMENTS.md]
- Reject `fork.prusaslicer.gcode-output` in `packages/parity/status.tsv`, `name = "prusaslicer_gcode_output_parity"` in `packages/parity/BUILD.bazel`, and Rust markers such as `pub mod prusa_gcode_output`, `prusa_gcode_output_summary`, and `parse_prusa_gcode_output_summary`. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md; VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

### Pattern 4: Relax Phase 45 Absence Checks for Phase 46

`packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` currently rejects the Phase 46 fixture namespace and `expected-gcode-summary.tsv`, which will become required artifacts in Phase 46. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] The plan should remove or revise only those Phase 46 absence checks while preserving Phase 47/48 absence checks. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Anti-Patterns to Avoid

- **Copying base export fixtures:** Reusing `export-workflows/expected-gcode.txt` would violate the Phase 46 explicit exclusion. [VERIFIED: .planning/ROADMAP.md]
- **Generating G-code during verification:** The verifier must not execute slicers, upstream tests, Git, network, or printer-runtime behavior. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]
- **Publishing status early:** `fork.prusaslicer.gcode-output` belongs to Phase 48 after executable evidence. [VERIFIED: .planning/ROADMAP.md; VERIFIED: docs/port/migration-guidance.md]
- **Adding Rust summary early:** `slic3r_flavors::prusa_gcode_output` belongs to Phase 47. [VERIFIED: .planning/ROADMAP.md]
- **Claiming generated-output parity:** Phase 46 proves fixture surface integrity only. [VERIFIED: .planning/REQUIREMENTS.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| G-code parsing | A custom parser or semantic summary in Bash | Exact line and marker checks only | Phase 47 owns typed Rust parsing. [VERIFIED: .planning/ROADMAP.md] |
| Fixture generation | A local slicer invocation or upstream test execution | Checked-in static fixture bytes | Phase 46 requires static, source-pinned fixture bytes. [VERIFIED: .planning/REQUIREMENTS.md] |
| Upstream source retrieval in verifier | `curl`, `git`, API calls, or clone/import behavior | Checked-in provenance strings and hashes | Verification must remain local and hermetic. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| Broad generated-output proof | Geometry, extrusion, timing, support, seam, arc, printability checks | Summary-only expected marker rows | These semantics are explicitly deferred. [VERIFIED: .planning/REQUIREMENTS.md] |
| New verifier framework | Python/Node/Rust helper only for this fixture | Existing Bash `sh_binary`/`sh_test` style | Existing fixture verifiers use Bash exact checks. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |

**Key insight:** the fixture is evidence that a small, reviewed, source-pinned G-code text surface exists and is stable, not evidence that PrusaSlicer output behavior is correct. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Searching for an Upstream `.gcode` Blob

**What goes wrong:** the planner assumes the accepted commit contains a small `.gcode` file to copy. [VERIFIED: GitHub API tree query]  
**Why it happens:** the phase asks for a `.gcode` fixture, but the accepted upstream tree contains G-code logic and tests, not `.gcode` blobs. [VERIFIED: GitHub API tree query]  
**How to avoid:** use the source-controlled `GCodeWriter` expected-output literals and document the fixture as a derived upstream test-literal fixture. [CITED: upstream `test_gcodewriter.cpp` lines 20-35]  
**Warning signs:** provenance points to a local export file, generated output, or a repo fixture outside `forks/prusaslicer/prusaslicer.gcode-output`. [VERIFIED: .planning/ROADMAP.md]

### Pitfall 2: Leaving Phase 45 Verifier Absence Checks Intact

**What goes wrong:** `bazel run //packages/prusa-gcode-output-scope:verify` fails after Phase 46 creates the fixture namespace. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]  
**Why it happens:** Phase 45 correctly rejected Phase 46 artifacts before fixture approval. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md]  
**How to avoid:** revise the scope verifier to stop rejecting Phase 46 fixture artifacts while still rejecting Phase 47/48 Rust, parity, and status artifacts. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]  
**Warning signs:** tests named `test_premature_fixture_namespace_fails` or `test_premature_expected_summary_artifact_fails` still expect failure after fixture creation. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh]

### Pitfall 3: Expected Summary Shape Drift

**What goes wrong:** Phase 47 typed parsing gets planned against a TSV shape that does not match the checked-in artifact. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]  
**Why it happens:** The research pass originally considered a newer shape, but the canonical Phase 45 scope record fixed the final Phase 46 columns. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]  
**How to avoid:** preserve the Phase 45 scope shape and make the Phase 46 verifier check the header exactly. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]  
**Warning signs:** `expected-gcode-summary.tsv` contains `evidence_kind`, `marker`, `expected_value`, or `deferred_semantics` columns after Phase 46. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Pitfall 4: Letting the Fixture Become a Parity Claim

**What goes wrong:** docs imply byte-for-byte G-code parity, printability, extrusion, timing, or generated-output parity. [VERIFIED: .planning/REQUIREMENTS.md]  
**Why it happens:** `.gcode` files look like generated output, so reviewers may read more into the fixture than the phase proves. [VERIFIED: .planning/REQUIREMENTS.md]  
**How to avoid:** make README, provenance, expected summary notes, and verifier forbidden-claim checks repeat the deferral list. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]  
**Warning signs:** docs say "verified G-code output", "generated-output parity", "printable", or "toolpath correctness" without "deferred" or "not claimed". [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh]

### Pitfall 5: Trusting `.gitattributes` Without Byte Checks

**What goes wrong:** CRLF conversion, non-ASCII text, or missing final newline changes fixture bytes without obvious review. [VERIFIED: .planning/REQUIREMENTS.md]  
**Why it happens:** Git attributes describe intended behavior but do not prove the checked-in bytes have the expected encoding and line endings. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/.gitattributes]  
**How to avoid:** check `.gitattributes`, exact byte count, exact SHA-256, exact line count, and ASCII/LF content in the verifier. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; VERIFIED: local candidate byte/hash check]  
**Warning signs:** verifier tests mutate CRLF or non-ASCII bytes and still pass. [VERIFIED: .planning/REQUIREMENTS.md]

## Code Examples

### ASCII/LF Check

```bash
require_ascii_lf() {
	local file="$1"
	local label="$2"
	if ! LC_ALL=C awk 'index($0, "\r") || $0 !~ /^[ -~]*$/ { exit 1 }' "${file}"; then
		error "${label}: expected US-ASCII text with LF line endings"
	fi
}
```

Use this as a verifier helper because Phase 46 must fail on line-ending or encoding policy drift. [VERIFIED: .planning/REQUIREMENTS.md]

### Exact Header Check

```bash
readonly EXPECTED_GCODE_SUMMARY_HEADER=$'source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes'

require_exact_header "${expected_summary_file}" \
	"expected-gcode-summary.tsv" \
	"${EXPECTED_GCODE_SUMMARY_HEADER}"
```

This mirrors existing exact-header checks while using the Phase 45 scope-record
shape carried into Phase 46. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Phase 47/48 Absence Guard

```bash
reject_status_row "fork.prusaslicer.gcode-output" "${status_file}"
reject_text "${parity_build_file}" "packages/parity/BUILD.bazel" 'name = "prusaslicer_gcode_output_parity"'
reject_rust_implementation_markers
```

The Phase 46 verifier should own these absence checks after the Phase 45 verifier stops rejecting Phase 46 fixture files. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Scope-only absence gate for `prusaslicer.gcode-output` | Static fixture namespace plus expected summary, with Rust/parity/status still absent | Phase 46 after Phase 45 completed on 2026-06-06 | Planner must move fixture/expected-summary checks from forbidden to required while preserving later-phase absence. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md; VERIFIED: .planning/ROADMAP.md] |
| Prusa project-file fixture model | Reuse the same fixture bundle/verifier/test shape for G-code | Phase 42 precedent | Planner should add aliases/filegroup/verifier/test in `packages/parity-fixtures/BUILD.bazel`. [VERIFIED: .planning/milestones/v1.11-phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| Phase 45 expected-summary column wording | Phase 46 preserves `metadata_key`/`metadata_value`/`marker_key`/`marker_value`/`notes` | Phase 46 context correction on 2026-06-13 | Planner should preserve the scope-record contract and verifier expectations. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |

**Deprecated/outdated:**

- Treating Phase 46 fixture files as forbidden artifacts is outdated after Phase 46 starts implementation. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md; VERIFIED: .planning/ROADMAP.md]
- Treating `evidence_kind`/`marker`/`expected_value`/`deferred_semantics` as the final Phase 46 TSV shape conflicts with the canonical Phase 45 scope-record contract. [VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

## Assumptions Log

All claims in this research were verified in local repo files, local tool probes, official GitHub source/API responses, pinned Bright Builds standards, or official OWASP ASVS project pages. No `[ASSUMED]` claims are used. [VERIFIED: source list below]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | No unverified assumptions recorded. | N/A | N/A |

## Open Questions (RESOLVED)

1. **RESOLVED: Should maintainers explicitly approve the derived fixture because there is no upstream `.gcode` blob?**
   What we know: the accepted commit has zero `.gcode` blobs, and the Phase 46 context allows source-controlled test or fixture data under the accepted commit. [VERIFIED: GitHub API tree query; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]  
   Resolution: proceed with the derived `GCodeWriter` literal fixture because D-04 permits source-controlled test or fixture data under the accepted commit, and no source-controlled `.gcode` blob exists at that identity. The plan must make README and provenance explicit that the fixture is derived from upstream expected-output literals rather than copied from an upstream `.gcode` blob. [CITED: upstream `test_gcodewriter.cpp` lines 20-35; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

2. **RESOLVED: Should Phase 46 update the Phase 45 scope package?**
   What we know: the Phase 45 verifier currently rejects the Phase 46 fixture namespace and expected summary, and the Phase 45 scope record names older expected-summary columns. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; VERIFIED: packages/prusa-gcode-output-scope/gcode-output-scope.md]  
   Resolution: include a Phase 46 reconciliation task for the Phase 45 scope verifier so current repo verification remains coherent after the fixture lands. The reconciliation must allow only the Phase 46 fixture namespace and `expected-gcode-summary.tsv` while still rejecting the Phase 47 Rust implementation marker, the Phase 48 parity target, and the Phase 48 status row. [VERIFIED: Bright Builds verification standard; VERIFIED: packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bash | Verifier and tests | Yes | GNU bash 3.2.57 | None needed. [VERIFIED: local `bash --version`] |
| Bazel | `sh_binary` and `sh_test` verifier targets | Yes | 8.6.0 | Direct shell test can supplement but should not replace Bazel target. [VERIFIED: local `bazel --version`] |
| `shasum` | SHA-256 checks | Yes | 6.02 | `sha256sum` would need portability handling if used. [VERIFIED: local `shasum` probe] |
| `awk` | Exact TSV and text checks | Yes | awk 20200816 | Keep checks simple and POSIX-ish. [VERIFIED: local `awk` probe] |
| `grep` | Required/forbidden text checks | Yes | BSD grep 2.6.0-compatible | Existing scripts already use `grep -Fq`. [VERIFIED: local `grep` probe; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| `wc` | Byte and line counts | Yes | system `wc` | None needed. [VERIFIED: local `wc` probe] |
| `shfmt` | Shell formatting check | Yes | 3.12.0 | If unavailable on another machine, rely on ShellCheck/Bazel and manual review. [VERIFIED: local `shfmt --version`] |
| `shellcheck` | Shell diagnostics | Yes | 0.11.0 | If unavailable on another machine, document skip and run Bash/Bazel tests. [VERIFIED: local `shellcheck --version`] |
| `mdformat` | Markdown check | Yes | 1.0.0 | Do not run over `*-SUMMARY.md`; not relevant to this research artifact. [VERIFIED: local `mdformat --version`; VERIFIED: AGENTS.md] |
| `buildifier` | Bazel formatting | No | N/A | Follow adjacent BUILD.bazel style and run Bazel targets. [VERIFIED: local command probe] |

**Missing dependencies with no fallback:** none for implementation and verification. [VERIFIED: local tool probes]

**Missing dependencies with fallback:** `buildifier` is missing; use adjacent Bazel style and Bazel execution as fallback. [VERIFIED: local command probe]

## Verification Commands for the Plan

Recommended implementation verification commands:

```bash
bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture
bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test
bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
bazel run //packages/prusa-gcode-output-scope:verify
shfmt -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
shellcheck packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
mdformat --check packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md
git diff --check
```

These commands are scoped to the changed fixture/docs/shell surfaces and match Bright Builds verification guidance. [CITED: pinned Bright Builds verification standard; VERIFIED: local tool availability]

## Security Domain

OWASP ASVS is a web-application security verification standard; this phase is a local static fixture and verifier phase, so only ASVS-style controls that map to local input/file integrity are applicable. [CITED: https://owasp.org/www-project-application-security-verification-standard/; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No | No authentication surface is added. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| V3 Session Management | No | No session or service runtime is added. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| V4 Access Control | No | No user authorization boundary is added. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |
| V5 Input Validation | Yes | Exact TSV header/row checks, ASCII/LF checks, byte count, and forbidden-claim checks. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| V6 Cryptography | Limited | Use SHA-256 only as an integrity checksum for fixture bytes; do not introduce secrets, credentials, encryption, or key management. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md; VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |

### Known Threat Patterns for Static Fixture Verification

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Fixture byte tampering | Tampering | Exact byte count plus SHA-256 in verifier and provenance. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| Line-ending or encoding drift | Tampering | `.gitattributes`, ASCII/LF verifier helper, line count, and checksum. [VERIFIED: .planning/REQUIREMENTS.md] |
| Scope overclaiming | Repudiation/Information Disclosure by misleading evidence | Required deferral text and forbidden-claim checks in README/docs/verifier tests. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh] |
| Network or Git behavior in verifier | Tampering/Spoofing through uncontrolled external state | No `curl`, `git`, upstream import, live generation, host upload, or credential handling in verifier. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md` - locked Phase 46 fixture, summary, verifier, docs, and deferral decisions. [VERIFIED: local read]
- `.planning/REQUIREMENTS.md` - PGFIX-01, PGFIX-02, and v1.12 out-of-scope list. [VERIFIED: local read]
- `.planning/ROADMAP.md` - Phase 46 goal, dependencies, success criteria, and Phase 47/48 boundaries. [VERIFIED: local read]
- `.planning/phases/45-prusa-g-code-output-scope-gate/45-VERIFICATION.md` - Phase 45 verified absence boundaries and handoff. [VERIFIED: local read]
- `packages/parity-fixtures/BUILD.bazel`, `packages/parity-fixtures/verify_prusa_project_file_fixture.sh`, and `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` - fixture bundle and verifier pattern. [VERIFIED: local read]
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` and `verify_prusa_gcode_output_scope.sh` - Phase 45 scope contract and current absence checks. [VERIFIED: local read]
- `packages/fork-vendors/forks.tsv` and `packages/fork-inventories/prusaslicer.tsv` - accepted source identity and inventory row. [VERIFIED: local read]
- GitHub API tree for `prusa3d/PrusaSlicer` commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` - no `.gcode` blobs; tree not truncated. [VERIFIED: GitHub API]
- Upstream PrusaSlicer `tests/fff_print/test_gcodewriter.cpp` at commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` - candidate G-code literal source. [CITED: https://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_gcodewriter.cpp#L20-L35]
- Pinned Bright Builds standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape, verification, and testing rules. [CITED: raw GitHub standards URLs above]

### Secondary (MEDIUM confidence)

- OWASP ASVS project page - confirms ASVS purpose as a web application security verification standard and latest stable ASVS 5.0.0. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Tertiary (LOW confidence)

- None.

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - based on existing local Bash/Bazel fixture patterns and local tool probes. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: local tool probes]
- Architecture: HIGH - based on Phase 42 project-file fixture precedent and Phase 46 locked decisions. [VERIFIED: .planning/milestones/v1.11-phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]
- Fixture source candidate: MEDIUM - no upstream `.gcode` blob exists, so the recommendation uses source-controlled expected-output literals and should be called out clearly in the plan. [VERIFIED: GitHub API tree query; CITED: upstream `test_gcodewriter.cpp` lines 20-35]
- Pitfalls: HIGH - based on verified Phase 45 absence checks, Phase 46 requirements, and local docs/status boundaries. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh; VERIFIED: .planning/REQUIREMENTS.md]

**Research date:** 2026-06-13  
**Valid until:** 2026-07-13 for local repo patterns; re-check upstream source tree if accepted source identity changes. [VERIFIED: .planning/phases/46-prusa-g-code-fixture-surface/46-CONTEXT.md]
