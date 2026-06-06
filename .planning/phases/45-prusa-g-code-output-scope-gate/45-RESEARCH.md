# Phase 45: Prusa G-code Output Scope Gate - Research

**Researched:** 2026-06-06
**Domain:** PrusaSlicer G-code output metadata-only scope gate
**Confidence:** HIGH for package/verifier shape; MEDIUM for the exact new inventory-row details until implementation reviews the row text

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for this entire copied constraints section:
[VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Scope Record Contract

- **D-01:** Create a dedicated package for the Phase 45 scope gate, following
  the Phase 41 `packages/prusa-project-file-scope` shape: package-local
  `README.md`, one scope record markdown file, package-local verifier script,
  focused verifier test, and Bazel target named `verify`.
- **D-02:** The scope record must use the exact inventory row
  `prusaslicer.gcode-output` and must trace it to the accepted PrusaSlicer
  source identity from the v1.12 research and fork inventory context.
- **D-03:** The scope record must name the Phase 46 fixture decision as a
  future, reviewed, source-pinned ASCII `.gcode` fixture and must explicitly
  state that no fixture bytes are checked in during Phase 45.
- **D-04:** The expected-summary contract must be summary-only and future
  Phase 46 owned. It should plan
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  without creating that file in Phase 45.
- **D-05:** The candidate Rust boundary must be future Phase 47 owned and
  should reserve `slic3r_flavors::prusa_gcode_output` or the closest
  repo-conforming equivalent as a pure data-in/data-out summary boundary.
- **D-06:** The planned evidence command must be future Phase 48 owned and
  reserve `bazel run //packages/parity:prusaslicer_gcode_output_parity`
  without creating the target in Phase 45.
- **D-07:** The planned status token must be future Phase 48 owned and reserve
  `fork.prusaslicer.gcode-output` only after executable evidence passes.

### Verification Guardrails

- **D-08:** The Phase 45 verifier must fail closed on missing or changed scope
  record fields, missing non-overclaiming README language, missing deferred
  scope terms, missing source identity, missing future fixture/summary/Rust/
  command/status handoff text, or missing reviewer signoff.
- **D-09:** The verifier must also guard the absence boundary: Phase 45 should
  fail if the package or documentation implies fixture bytes, expected
  artifacts, Rust summary readiness, parity command availability, status row
  publication, upstream source import, Git/network/vendor sync behavior,
  printer-runtime behavior, host upload, profile auto-update execution,
  release builds, Bambu Studio, or OrcaSlicer support.
- **D-10:** Add a focused shell verifier test mirroring the Phase 41 style:
  one valid fixture pass plus targeted negative mutations for the highest-risk
  fields and claims.

### Downstream Handoff

- **D-11:** Phase 45 should update only the minimum docs needed to make the
  scope gate discoverable and non-overclaiming; broad docs/status publication
  remains Phase 48 work.
- **D-12:** The implementation should preserve the v1.10/v1.11 evidence
  ladder: scope gate first, then fixture surface, then Rust summary boundary,
  then executable evidence/status/docs.
- **D-13:** Keep broad `generated-outputs` in progress. Phase 45 can mention
  the future exact `fork.prusaslicer.gcode-output` token but must not verify or
  publish it.

### the agent's Discretion

The agent may choose exact file names and helper function names that best match
the local package and Bazel conventions, as long as the package remains a
scope gate only and the public command remains
`bazel run //packages/prusa-gcode-output-scope:verify` or an equivalently clear
repo-local label.

### Deferred Ideas (OUT OF SCOPE)

- Phase 46 owns fixture bytes, provenance, update rules, byte count, SHA-256,
  line-ending/encoding policy, and `expected-gcode-summary.tsv`.
- Phase 47 owns Rust G-code summary types, parser/summary logic, metadata, and
  Rust tests.
- Phase 48 owns executable parity, mutation guard, exact status publication,
  and public docs/status alignment.
- Broader byte-for-byte G-code parity, generated-output parity, geometry,
  extrusion, timing, support, seam, arc, STEP, GUI, runtime/printer behavior,
  release builds, network/device behavior, Bambu Studio, OrcaSlicer, and sync
  automation remain outside v1.12 Phase 45.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PGSEL-01 | Maintainer can inspect a reviewed `prusaslicer.gcode-output` scope record with accepted source identity, fixture source decision, expected-summary contract, candidate Rust boundary, planned evidence command, planned status token, docs touched, license/security note, deferred scope, and reviewer signoff. | Use a Phase 41-shaped package-local markdown record and fail-closed verifier, with an added inventory-row reconciliation task because current `packages/fork-inventories/prusaslicer.tsv` does not yet contain `prusaslicer.gcode-output`. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md; packages/prusa-project-file-scope/*; packages/fork-inventories/prusaslicer.tsv] |
| PGSEL-02 | Maintainer can distinguish the narrow v1.12 summary-only Prusa G-code evidence contract from byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP import, full 3MF import/export, printer-runtime behavior, firmware or printability behavior, GUI export or viewer behavior, binary G-code, thumbnails, post-processing, host upload, network/device integration, profile auto-update execution, fork release builds, and sync automation. | Make deferred-scope wording and absence checks first-class verifier inputs, and keep `generated-outputs` plus `fork.prusaslicer.gcode-output` unverified during Phase 45. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- `AGENTS.md` requires reading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds standards before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md]
- Repo-local guidance only constrains phase summary files: keep `requirements-completed` frontmatter synchronized, use the exact hyphenated key, do not run `mdformat` over `*-SUMMARY.md`, and edit only affected frontmatter when backfilling summary metadata. [VERIFIED: AGENTS.md]
- `AGENTS.bright-builds.md` points to Bright Builds commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`, and the relevant pinned pages were fetched from that commit for architecture, code shape, verification, testing, and Rust guidance. [VERIFIED: AGENTS.bright-builds.md; bright-builds-rules.audit.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Bright Builds requires functional core / imperative shell as the default architecture, parsing boundary data into domain types, making illegal states unrepresentable where practical, repo-native verification before commit, and focused Arrange/Act/Assert unit tests for pure logic. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- No project-local `.claude/skills/` or `.agents/skills/` directories were present during research. [VERIFIED: project skill directory audit command]

## Summary

Phase 45 should be planned as a metadata-only scope gate, not as a fixture,
Rust parser, parity command, or status-publication phase. [VERIFIED:
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
.planning/ROADMAP.md]

The strongest local implementation pattern is Phase 41
`packages/prusa-project-file-scope`: it contains a package-local README, one
scope markdown record, `verify_prusa_project_file_scope.sh`, a mutation-style
shell test, and a Bazel `verify` target; both the verifier and test passed
during this research run. [VERIFIED: packages/prusa-project-file-scope/*;
verified commands `bazel run //packages/prusa-project-file-scope:verify` and
`bazel test //packages/prusa-project-file-scope:verify_prusa_project_file_scope_test`]

The only planning-critical wrinkle is that the locked Phase 45 context calls
`prusaslicer.gcode-output` an exact inventory row, but the current
`packages/fork-inventories/prusaslicer.tsv` does not contain that row. [VERIFIED:
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/fork-inventories/prusaslicer.tsv] The planner should include either
a first task to add `prusaslicer.gcode-output` plus a matching category-map
entry, or make the scope verifier fail until that row exists; treating the row
as already present would be false. [VERIFIED: packages/fork-inventories/README.md;
packages/fork-inventories/category-map.tsv]

**Primary recommendation:** create `packages/prusa-gcode-output-scope`, add or
verify the `prusaslicer.gcode-output` inventory row, and write a fail-closed
scope verifier that checks required record text plus forbidden later-phase
artifacts/status/docs claims. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/prusa-project-file-scope/*; packages/parity/status.tsv]

## Standard Stack

### Core

Source for this table: local pinned toolchain files, prior Prusa scope package,
and environment probes run on 2026-06-06. [VERIFIED: .bazelversion;
MODULE.bazel; packages/prusa-project-file-scope/BUILD.bazel; environment
availability command]

| Library / Surface | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Bazel / Bazelisk | 8.6.0 | Build and run the package-local `verify` target and shell test. | The repo pins Bazel 8.6.0 and prior scope/parity packages expose Bazel commands. |
| Bash `sh_binary` and `sh_test` | Bash 3.2.57 available locally | Implement the verifier and focused negative test. | Phase 41 uses the same shell/Bazel shape and it verified successfully in this research run. |
| POSIX `grep` / `awk` / `diff` style checks | Available locally | Check exact README text, markdown table rows, duplicate rows, and forbidden claims. | Existing verifiers use these tools for fail-closed text and TSV validation. |
| `packages/prusa-project-file-scope` pattern | Repo-local | Template for package structure and mutation tests. | It is the accepted prior Prusa scope-gate package and its verifier/test passed. |
| `packages/fork-inventories` | Repo-local | Source-pinned planning row source for `prusaslicer.gcode-output`. | The Phase 45 context requires an exact inventory row, and inventory docs require every row to appear in the category map exactly once. |
| `packages/parity/status.tsv` | Repo-local | Absence guard for `fork.prusaslicer.gcode-output` and broad `generated-outputs`. | The status file currently has `generated-outputs` in progress and no G-code fork row. |

### Supporting

Source for this table: local docs and environment probes run on 2026-06-06.
[VERIFIED: docs/port/migration-guidance.md; docs/port/parity-matrix.md;
packages/parity/README.md; environment availability command]

| Library / Surface | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `docs/port/migration-guidance.md` | Repo-local | Minimal discoverability for future fork fixture/status rules. | Use only if needed to route the new scope gate without claiming verified evidence. |
| `docs/port/parity-matrix.md` | Repo-local | Public non-overclaiming status language. | Use only to clarify that broad generated outputs remain in progress and G-code parity is not verified. |
| `shfmt` | 3.12.0 available locally | Optional shell-format check for the new verifier/test. | Use after writing shell scripts if formatting is relevant and does not rewrite unrelated files. |
| ShellCheck | 0.11.0 available locally | Optional shell diagnostics for the new verifier/test. | Use for targeted shell validation if the planner wants a stronger local check. |

### Alternatives Considered

Source for this table: locked scope decisions and local v1.12 research.
[VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
.planning/research/STACK.md; .planning/research/PITFALLS.md]

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Package-local shell verifier | New generic generated-output verifier framework | Too broad for a metadata-only gate and not established locally. |
| Scope markdown record | Checked-in `.gcode` fixture | Fixture bytes are explicitly Phase 46-owned and forbidden in Phase 45. |
| Planned command text only | Real `//packages/parity:prusaslicer_gcode_output_parity` target | The real parity target is Phase 48-owned and would violate the absence boundary. |
| Planned status token text only | `fork.prusaslicer.gcode-output` row in `status.tsv` | The status row is Phase 48-owned and must not be published in Phase 45. |
| Inventory row plus scope record | Treat `prusaslicer.gcode-output` as an undocumented slug | The locked context says "exact inventory row", and inventory docs require traceable row/category-map data. |

**Installation:**

No dependency installation is needed for Phase 45. [VERIFIED: .planning/research/STACK.md; environment availability command]

```bash
bazel run //packages/prusa-gcode-output-scope:verify
bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test
```

**Version verification:** no npm packages are recommended, so `npm view` is
not applicable. [VERIFIED: .planning/research/STACK.md] Bazel is pinned to
8.6.0 in `.bazelversion`, `rules_rust` is pinned to 0.69.0 in `MODULE.bazel`,
Rust is pinned to 1.94.1 for future phases, and local `bazel --version`
reported `bazel 8.6.0`. [VERIFIED: .bazelversion; MODULE.bazel; environment
availability command]

## Architecture Patterns

### Recommended Project Structure

Source for this structure: Phase 41 package layout and Phase 45 locked
decisions. [VERIFIED: packages/prusa-project-file-scope/*;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

```text
packages/
+-- prusa-gcode-output-scope/
|   +-- BUILD.bazel
|   +-- README.md
|   +-- gcode-output-scope.md
|   +-- verify_prusa_gcode_output_scope.sh
|   +-- verify_prusa_gcode_output_scope_test.sh
+-- fork-inventories/
|   +-- prusaslicer.tsv          # add/verify prusaslicer.gcode-output row if required by D-02
|   +-- category-map.tsv         # keep inventory exact-once mapping valid
docs/port/
+-- migration-guidance.md        # optional minimal scope-route wording
+-- parity-matrix.md             # optional non-overclaiming status wording
```

### Pattern 1: Scope Package Before Evidence

**What:** create a dedicated metadata package with a README, one scope record,
a shell verifier, a shell verifier test, exported files, and a Bazel `verify`
target. [VERIFIED: packages/prusa-project-file-scope/*]

**When to use:** use it for Phase 45 because the roadmap requires a reviewed
scope contract before fixture, Rust, parity, or status work begins. [VERIFIED:
.planning/ROADMAP.md; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Example:**

```starlark
package(default_visibility = ["//visibility:public"])

exports_files([
    "README.md",
    "gcode-output-scope.md",
])

sh_binary(
    name = "verify",
    srcs = ["verify_prusa_gcode_output_scope.sh"],
    data = [
        "README.md",
        "gcode-output-scope.md",
    ],
    args = [
        "$(location README.md)",
        "$(location gcode-output-scope.md)",
    ],
)

sh_test(
    name = "verify_prusa_gcode_output_scope_test",
    srcs = ["verify_prusa_gcode_output_scope_test.sh"],
    data = ["verify_prusa_gcode_output_scope.sh"],
)
```

Source: adapted from the verified Phase 41 BUILD shape. [VERIFIED:
packages/prusa-project-file-scope/BUILD.bazel]

### Pattern 2: Positive Contract Checks Plus Absence Checks

**What:** require exact table rows for source identity, fixture handoff,
summary contract, Rust boundary, command, token, docs, license/security,
deferrals, and signoff, then reject Phase 46-48 artifacts and claims if they
already appear. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**When to use:** use this because D-08 and D-09 require both fail-closed scope
fields and absence-boundary enforcement. [VERIFIED:
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Example:**

```bash
require_section_table_row "${scope_file}" "gcode-output-scope.md" \
    "## Scope Record" "Inventory row ID" "`prusaslicer.gcode-output`"

reject_existing_path "fixture namespace" \
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"

reject_status_row "fork.prusaslicer.gcode-output" \
    "packages/parity/status.tsv"
```

Source: row-checking style from Phase 41 plus Phase 45 absence guardrail.
[VERIFIED: packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

### Pattern 3: Inventory Row Reconciliation

**What:** either add `prusaslicer.gcode-output` to `packages/fork-inventories/prusaslicer.tsv`
and `category-map.tsv`, or make the scope verifier check fail until the row
exists. [VERIFIED: packages/fork-inventories/prusaslicer.tsv;
packages/fork-inventories/category-map.tsv; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**When to use:** use this before writing the scope record, because D-02 calls
the slug an exact inventory row while the current inventory only has adjacent
rows such as support generation, arc fitting, and wall seam. [VERIFIED:
packages/fork-inventories/prusaslicer.tsv; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Recommended row anchor:** use accepted source ref
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, with
`src/libslic3r/GCode.cpp` as the minimum verified upstream source path and
`src/libslic3r/GCode.hpp` as companion evidence if the planner wants a
multi-value `source_paths` field. [VERIFIED: packages/fork-vendors/forks.tsv;
CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.cpp;
CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.hpp]

### Anti-Patterns to Avoid

- **Creating evidence early:** do not create fixture bytes, expected-summary
  files, Rust modules, parity commands, or status rows in Phase 45. [VERIFIED:
  .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]
- **Treating planning text as proof:** source pins, inventory rows, and scope
  records are planning inputs only and do not prove fork parity. [VERIFIED:
  packages/fork-inventories/README.md; packages/parity/README.md]
- **Promoting `generated-outputs`:** leave broad `generated-outputs` in
  progress during Phase 45. [VERIFIED: packages/parity/status.tsv;
  .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]
- **Over-broad docs:** do not describe byte parity, full generated-output
  parity, geometry, runtime, support, seam, arc, STEP, GUI, release, network,
  or sync behavior as verified. [VERIFIED: .planning/REQUIREMENTS.md]

## Don't Hand-Roll

Source for this table: locked Phase 45 decisions and existing local packages.
[VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/prusa-project-file-scope/*; packages/parity/status.tsv]

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Scope verification | A new verifier framework or generated-output DSL | A package-local Bash verifier modeled on Phase 41 | The local repo already has the exact pattern and it passed. |
| Scope record format | YAML/JSON custom schema | Markdown table record with exact shell row checks | Phase 41 uses a markdown record and shell row checks successfully. |
| G-code parsing | A general parser or third-party crate | No parser in Phase 45 | Parser work is Phase 47-owned and forbidden in Phase 45. |
| Fixture validation | `.gcode` bytes or expected summary | Future handoff text only | Fixture bytes and expected summary are Phase 46-owned. |
| Public evidence | A real parity target | Planned command text only | Executable evidence is Phase 48-owned. |
| Status publication | `fork.prusaslicer.gcode-output` in `status.tsv` | Reserved token text plus absence guard | The row may be published only after executable evidence passes. |

**Key insight:** Phase 45 is a gate that prevents later work from overclaiming,
so the verifier should be stricter about what must be absent than the Phase 41
verifier was. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh]

## Common Pitfalls

### Pitfall 1: Assuming `prusaslicer.gcode-output` Already Exists

**What goes wrong:** the scope record refers to an "inventory row" that is not
actually present in `packages/fork-inventories/prusaslicer.tsv`. [VERIFIED:
packages/fork-inventories/prusaslicer.tsv; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Why it happens:** v1.12 research describes `prusaslicer.gcode-output` as a
stable evidence slug, while the Phase 45 context locks it as an exact
inventory row. [VERIFIED: .planning/research/FEATURES.md;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**How to avoid:** plan an inventory/category-map reconciliation step before or
inside the scope package work. [VERIFIED: packages/fork-inventories/README.md;
packages/fork-inventories/category-map.tsv]

**Warning signs:** the verifier checks only markdown text and never validates
the backing inventory row. [VERIFIED: packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh]

### Pitfall 2: Publishing Future Evidence Too Early

**What goes wrong:** Phase 45 accidentally adds a fixture namespace, expected
summary, Rust boundary, parity command, or status row. [VERIFIED:
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Why it happens:** the phase names future paths and labels, so implementation
can drift from "reserved text" to "created artifact". [VERIFIED:
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**How to avoid:** add explicit absence checks for `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output`,
`expected-gcode-summary.tsv`, `slic3r_flavors::prusa_gcode_output`,
`prusaslicer_gcode_output_parity`, and `fork.prusaslicer.gcode-output`.
[VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
absence grep/find audit command]

**Warning signs:** `rg` finds those strings in implementation packages instead
of only in planning or scope-gate docs. [VERIFIED: absence grep/find audit command]

### Pitfall 3: Overclaiming G-code Output

**What goes wrong:** docs or README wording implies byte-for-byte G-code
parity, broad generated-output parity, geometry, runtime, printability, GUI,
support, seam, arc, STEP, release, network, or sync support. [VERIFIED:
.planning/REQUIREMENTS.md]

**Why it happens:** G-code is user-visible output, so even a scope package can
sound like output parity if "summary-only" and "future evidence" wording is
not repeated. [VERIFIED: .planning/research/PITFALLS.md]

**How to avoid:** require the full PGSEL-02 deferral vocabulary in the scope
record and package README, and reject forbidden overclaiming phrases. [VERIFIED:
.planning/REQUIREMENTS.md; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Warning signs:** `generated-outputs` changes from `in progress`, or docs say
"Prusa G-code parity verified" before Phase 48. [VERIFIED:
packages/parity/status.tsv; docs/port/parity-matrix.md]

### Pitfall 4: Positive-Only Verifier

**What goes wrong:** the verifier checks required rows but never fails when
forbidden later-phase artifacts or claims are present. [VERIFIED:
packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Why it happens:** Phase 41's verifier is a good positive-row template, but
Phase 45 has a stronger absence-boundary decision. [VERIFIED:
packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**How to avoid:** add targeted negative mutation tests for missing rows,
changed source identity, missing deferrals, premature status row, premature
parity target, and README overclaim. [VERIFIED:
packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh;
.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

**Warning signs:** the test suite has a valid fixture pass but no negative
mutations for absence claims. [VERIFIED:
packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh]

## Code Examples

Verified patterns from official/local sources:

### Scope Verifier Helpers

```bash
require_text() {
    local file="$1"
    local label="$2"
    local pattern="$3"
    if ! grep -Fq -- "${pattern}" "${file}"; then
        error "${label}: missing required text: ${pattern}"
    fi
}

require_section_table_row() {
    local file="$1"
    local label="$2"
    local section="$3"
    local field="$4"
    local value="$5"
    local row="| ${field} | ${value} |"

    if ! awk -v section="${section}" -v row="${row}" '
        $0 == section { in_section = 1; next }
        in_section && /^## / { exit }
        in_section && $0 == row { found = 1; exit }
        END { exit found ? 0 : 1 }
    ' "${file}"; then
        error "${label}: missing required table row in ${section}: ${row}"
    fi
}
```

Source: Phase 41 verifier helper style. [VERIFIED:
packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh]

### Phase 45 Absence Guard Skeleton

```bash
reject_existing_path() {
    local label="$1"
    local path="$2"
    if [[ -e "${path}" ]]; then
        error "${label}: forbidden Phase 45 artifact exists: ${path}"
    fi
}

reject_text() {
    local file="$1"
    local label="$2"
    local pattern="$3"
    if grep -Fq -- "${pattern}" "${file}"; then
        error "${label}: forbidden Phase 45 claim or artifact text: ${pattern}"
    fi
}
```

Source: required by Phase 45 D-09; helper shape follows local shell verifier
style. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh]

### Mutation Test Shape

```bash
test_missing_status_token_fails() {
    # Arrange
    local dir="${tmp_dir}/missing-status-token"
    write_valid_fixture "${dir}"
    remove_line_containing "${dir}/gcode-output-scope.md" "| Planned status token |"

    # Act
    if run_verifier "${dir}" "${tmp_dir}/missing-status.out" "${tmp_dir}/missing-status.err"; then
        fail "missing status token fixture passed"
    fi

    # Assert
    assert_contains "${tmp_dir}/missing-status.err" '^error:'
    assert_contains "${tmp_dir}/missing-status.err" 'Planned status token'
}
```

Source: Phase 41 focused shell mutation tests and Bright Builds testing
standard. [VERIFIED: packages/prusa-project-file-scope/verify_prusa_project_file_scope_test.sh;
CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

## State of the Art

Source for this table: shipped v1.10/v1.11 local evidence chain and active
v1.12 roadmap. [VERIFIED: .planning/PROJECT.md; .planning/ROADMAP.md;
packages/parity/README.md; packages/parity-fixtures/README.md]

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source pins and inventories as planning records only | Scope gate, then fixture, then Rust boundary, then executable parity/status | v1.10 and v1.11 shipped this ladder before v1.12 | Phase 45 must stay at the scope-gate step. |
| Broad fork rows inferred from metadata | Exact `fork.<slice>` rows only after executable evidence | v1.10/v1.11 fork parity status publication | Phase 45 may reserve `fork.prusaslicer.gcode-output` but must not publish it. |
| General generated-output wording | Narrow summary-only G-code metadata/marker wording | v1.12 roadmap and requirements | Phase 45 must distinguish the contract from byte/content/runtime claims. |

**Deprecated/outdated:**

- Treating an inventory row, checklist, source pin, or scope record as
  executable parity evidence is outdated for this repo's fork work. [VERIFIED:
  packages/fork-inventories/README.md; packages/parity/README.md]
- Reusing base `export-workflows/expected-gcode.txt` as Prusa evidence is not
  valid for this milestone because v1.12 requires a source-pinned Prusa
  fixture namespace in Phase 46. [VERIFIED: .planning/research/PITFALLS.md;
  .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

All claims in this research were verified or cited; no assumed claims were
used. [VERIFIED: research source audit]

## Open Questions (RESOLVED)

1. **Exact reviewer signoff string - RESOLVED**
   - What we know: PGSEL-01 and D-08 require reviewer signoff in the scope record. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]
   - Prior uncertainty: the context did not specify the exact signoff name/date text for Phase 45. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md]
   - Resolution: Plan 45-02 sets and verifies the exact scope-record row `| Reviewer signoff | Peter Ryszkiewicz, 2026-06-06 UTC |`. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-02-PLAN.md]
2. **Exact `prusaslicer.gcode-output` inventory row text - RESOLVED**
   - What we know: the locked context requires the row, and the current inventory lacks it. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md; packages/fork-inventories/prusaslicer.tsv]
   - Prior uncertainty: the exact `feature_category`, `source_paths` multi-value set, and `category-map.tsv` `map_id` were not specified in context. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv]
   - Resolution: Plan 45-01 sets the exact literal-tab-delimited inventory row to `prusaslicer.gcode-output	prusaslicer	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp	gcode-output	gcode-output	shared-downstream	high	generated-outputs	future-candidate	none	Source-observed G-code output planning row; parity requires reviewed source-pinned summary evidence before output behavior is claimed.` [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-01-PLAN.md]
   - Resolution: Plan 45-01 sets the exact category-map row to `gcode.shared	gcode-output	shared-downstream	future-candidate	prusaslicer.gcode-output	Prusa G-code output row needs reviewed source-pinned summary evidence before generated-output behavior is claimed.` and verifies it with `bazel run //packages/fork-inventories:verify`. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-01-PLAN.md]

## Environment Availability

Source for this table: local environment probe run on 2026-06-06. [VERIFIED:
environment availability command]

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Bazel | `//packages/prusa-gcode-output-scope:verify` and test targets | yes | bazel 8.6.0 | None needed |
| Bash | verifier and mutation test scripts | yes | GNU bash 3.2.57 | None needed |
| `grep` | exact text checks | yes | smoke checked | None needed |
| `awk` | exact table-row and duplicate checks | yes | smoke checked | None needed |
| ripgrep | implementation audit and final diff checks | yes | 15.1.0 | Use `grep` for narrow checks |
| `shfmt` | optional shell formatting check | yes | 3.12.0 | Manual style review |
| ShellCheck | optional shell diagnostics | yes | 0.11.0 | Bazel shell tests |
| Buildifier | optional BUILD formatting | no | - | Follow existing BUILD style and rely on Bazel analysis |

**Missing dependencies with no fallback:**

- None for Phase 45 scope planning and local verification. [VERIFIED: environment availability command]

**Missing dependencies with fallback:**

- Buildifier is missing; the planner can still use existing BUILD.bazel style
  and Bazel analysis unless it wants to add a tool-install step. [VERIFIED:
  environment availability command; packages/prusa-project-file-scope/BUILD.bazel]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does
not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json;
GSD researcher workflow instructions]

### Applicable ASVS Categories

Source for this table: Phase 45 scope and GSD security-section requirements.
[VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
GSD researcher workflow instructions]

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Phase 45 creates no auth surface, credential behavior, network/device integration, or host upload behavior. |
| V3 Session Management | no | Phase 45 creates no sessions or runtime user state. |
| V4 Access Control | no | Phase 45 creates no privileged runtime operation or service boundary. |
| V5 Input Validation | yes | Shell verifier must validate exact markdown fields, inventory row presence, status absence, and forbidden overclaiming text. |
| V6 Cryptography | no | Phase 45 creates no fixture bytes or checksum contract; SHA-256 belongs to Phase 46 fixture work. |

### Known Threat Patterns for Phase 45

Source for this table: locked Phase 45 guardrails and local prior verifier
patterns. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md;
packages/prusa-project-file-scope/*; packages/parity/status.tsv]

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Scope overclaim in docs or README | Spoofing / Repudiation | Exact required deferral strings plus forbidden-claim checks. |
| Premature verified status row | Tampering | Reject `fork.prusaslicer.gcode-output` in `packages/parity/status.tsv` during Phase 45. |
| Hidden fixture/parser/parity artifact | Tampering | Reject later-phase paths and labels in implementation packages. |
| Inventory/source mismatch | Repudiation | Require `prusaslicer.gcode-output` row and accepted source ref traceability before scope record passes. |
| Network/source import claim | Information disclosure / Tampering | README and scope record must state no upstream source import, Git/network/vendor sync, host upload, or profile auto-update execution. |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md` - locked decisions, discretion, deferrals, canonical refs, and implementation boundaries. [VERIFIED: required initial read]
- `.planning/REQUIREMENTS.md` - PGSEL-01 and PGSEL-02 requirements. [VERIFIED: required initial read]
- `.planning/ROADMAP.md` - Phase 45 goal and success criteria. [VERIFIED: required initial read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - current milestone state and evidence-ladder decisions. [VERIFIED: required initial read; project context read]
- `.planning/research/SUMMARY.md`, `ARCHITECTURE.md`, `FEATURES.md`, `PITFALLS.md`, and `STACK.md` - v1.12 research synthesis and detailed domain research. [VERIFIED: local research reads]
- `packages/prusa-project-file-scope/*` - verified Phase 41 scope package template. [VERIFIED: file reads; Bazel verifier/test runs]
- `packages/fork-inventories/prusaslicer.tsv`, `category-map.tsv`, and `README.md` - current inventory contract and missing `prusaslicer.gcode-output` row. [VERIFIED: file reads]
- `packages/fork-vendors/forks.tsv` - accepted PrusaSlicer source identity and license/provenance context. [VERIFIED: file read]
- `packages/parity/status.tsv`, `packages/parity/README.md`, and `packages/parity/BUILD.bazel` - current status vocabulary and absence of `fork.prusaslicer.gcode-output`. [VERIFIED: file reads]
- `docs/port/migration-guidance.md` and `docs/port/parity-matrix.md` - current fork/status guidance and generated-output wording. [VERIFIED: file reads]

### Primary External (HIGH confidence)

- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - index, architecture, code shape, verification, testing, and Rust guidance. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- PrusaSlicer pinned upstream `src/libslic3r/GCode.cpp` and `GCode.hpp` at commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` - verified source anchors for a possible `prusaslicer.gcode-output` inventory row. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.cpp; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.hpp]

### Secondary (MEDIUM confidence)

- None needed beyond local and pinned upstream sources. [VERIFIED: source hierarchy audit]

### Tertiary (LOW confidence)

- None. [VERIFIED: source hierarchy audit]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - local toolchain files, environment probes, and the prior scope package were verified. [VERIFIED: .bazelversion; MODULE.bazel; packages/prusa-project-file-scope/*; environment availability command]
- Architecture: HIGH - the locked Phase 45 decisions directly mirror the verified Phase 41 scope-gate package. [VERIFIED: .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md; packages/prusa-project-file-scope/*]
- Pitfalls: HIGH - the main risks are explicitly listed in PGSEL-02 and D-08/D-09, and current status/docs confirm the absence boundary. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md; packages/parity/status.tsv]
- Inventory row details: MEDIUM - the row is locked by context but absent from the current inventory, and only the source anchors were verified externally. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; .planning/phases/45-prusa-g-code-output-scope-gate/45-CONTEXT.md; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/GCode.cpp]

**Research date:** 2026-06-06
**Valid until:** 2026-07-06 for local package patterns; re-check tool versions and upstream source availability if planning happens later than that. [VERIFIED: research date; environment availability command]
