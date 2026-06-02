# Phase 38: Prusa Fixture and Status Evidence Surface - Research

**Researched:** 2026-06-01. [VERIFIED: current session date]
**Domain:** Static Prusa profile/config fixture provenance, Bazel fixture exports, and conservative parity status vocabulary. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**Confidence:** HIGH for repo-local package patterns and locked Prusa source values; MEDIUM for exact new manifest and Bazel target names because those names are discretionary. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity/README.md; packages/fork-vendors/forks.tsv; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

<user_constraints>

## User Constraints (from CONTEXT.md)

Source: [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

### Locked Decisions

### Fixture Namespace and Shape

- **D-01:** Create the Phase 38 fixture namespace under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`.
- **D-02:** Use static checked-in Prusa vendor-bundle fixture files from the
  accepted source pin, including `PrusaResearch.ini` and the matching
  `PrusaResearch.idx`, instead of curated excerpts or derived parser
  expectation files.
- **D-03:** Keep these files as fixture inputs only. Export them through Bazel
  fixture targets or filegroups, but do not add `//packages/parity:*_parity`
  executable evidence in Phase 38.

### Fixture Provenance and Update Rules

- **D-04:** Add a fixture-local provenance/status manifest beside the fixture
  files. It must record `prusaslicer.profile-schema`, vendor id
  `prusaslicer`, accepted tag `version_2.9.5`, peeled commit
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`, source path
  `resources/profiles/PrusaResearch.ini`, and the Phase 37 checklist source.
- **D-05:** The manifest or README must state the fixture update route: update
  only after a reviewed intake change updates `packages/fork-vendors/forks.tsv`
  and the Prusa checklist/baseline gate. Branch-head observations remain
  drift-only.
- **D-06:** Add fail-closed verification that checks the fixture files,
  manifest source pin, source paths, boundary wording, and no Bambu Studio,
  OrcaSlicer, network, cloud, credential, or non-free plugin fixture namespace
  was introduced.
- **D-07:** Verification may check static fixture file presence and recorded
  provenance, but must not fetch upstream source, run profile auto-update,
  ingest plugins, or execute a Prusa parity command.

### Status Vocabulary and Non-Overclaiming

- **D-08:** Do not add a Prusa row to `packages/parity/status.tsv` in Phase 38.
  That file remains reserved for executable evidence rows.
- **D-09:** Update docs/status vocabulary to reserve the future token
  `fork.prusaslicer.profile-schema` for Phase 40 and state that it cannot be
  marked `verified` until a rerunnable `//packages/parity:*_parity` command
  exists.
- **D-10:** Port docs should make the distinction explicit: Phase 38 creates
  fixture/status preparation only; Phase 39 creates Rust parsing; Phase 40
  creates executable parity evidence and any verified status publication.

### Scope Boundaries

- **D-11:** Every new fixture README or manifest must explicitly exclude Bambu
  Studio, OrcaSlicer, network/device integration, cloud behavior, credentials,
  profile auto-update execution, non-free plugin ingestion, full Prusa runtime
  support, GUI support, sync automation, and fork release packaging.
- **D-12:** Phase 38 may reference the future Phase 40 evidence command shape
  as planned work, but must not create the command or imply support from
  source pins, fixtures, inventories, checklists, or flavor metadata alone.

### the agent's Discretion

- Exact fixture subdirectory names under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`,
  provided the raw vendor-bundle files and provenance manifest are easy to
  inspect.
- Exact manifest filename and format, provided it is grep-verifiable, readable,
  and stable enough for Phase 39/40 agents to consume.
- Whether the verifier is a standalone shell script in `packages/parity-fixtures`
  or package-local helpers plus Bazel targets, provided it is rerunnable and
  follows existing shell/Bazel patterns.
- Exact wording and placement of status vocabulary in docs, provided
  `packages/parity/status.tsv` does not gain a Prusa row in Phase 38.

### Deferred Ideas (OUT OF SCOPE)

- Rust profile/config parsing and normalization logic is Phase 39 scope.
- Executable Prusa profile/config parity command, docs/status publication, and
  verified evidence are Phase 40 scope.
- Adding `fork.prusaslicer.profile-schema` to `packages/parity/status.tsv`
  remains deferred until the executable Phase 40 evidence command exists.
- Prusa project files, STEP import, support generation, arc fitting, wall seam
  behavior, network/device integration, profile auto-update execution, full fork
  runtime support, GUI support, fork release builds, Bambu Studio, OrcaSlicer,
  upstream source imports, and vendor sync automation remain deferred beyond
  this phase.

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| EVID-01 | Maintainer can inspect a Prusa fixture namespace and update rules in the parity fixture package for the profile/config evidence slice, with no Bambu Studio, OrcaSlicer, network, cloud, credential, or non-free plugin fixtures introduced by this milestone. [VERIFIED: .planning/REQUIREMENTS.md] | Create the locked `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` namespace with README/manifest update rules and a fail-closed verifier that rejects Bambu, Orca, network, cloud, credential, and non-free plugin fixture namespaces. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; packages/parity-fixtures/README.md] |
| EVID-02 | Maintainer can inspect checked-in Prusa profile/config fixtures that are traceable to the accepted Prusa source pin and are suitable for rerunnable executable parity checks. [VERIFIED: .planning/REQUIREMENTS.md] | Check in raw `PrusaResearch.ini` and matching `PrusaResearch.idx` from the accepted `version_2.9.5` peeled commit, record source URLs, sizes, SHA-256 values, and line-ending facts, and expose the bundle through Bazel filegroups/aliases. [VERIFIED: local curl/shasum check against raw GitHub URLs; packages/fork-vendors/forks.tsv] |
| EVID-03 | Maintainer can inspect parity status vocabulary or status rows that reserve verified Prusa status for the v1.10 executable evidence command only, without marking full PrusaSlicer support verified. [VERIFIED: .planning/REQUIREMENTS.md] | Update docs and package README vocabulary to reserve `fork.prusaslicer.profile-schema` for Phase 40 while keeping `packages/parity/status.tsv` unchanged and free of Prusa rows. [VERIFIED: packages/parity/README.md; packages/parity/status.tsv; docs/port/parity-matrix.md] |

</phase_requirements>

## Summary

Phase 38 should be a static fixture and vocabulary preparation phase, not an executable parity or Rust parsing phase. [VERIFIED: .planning/ROADMAP.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] The repo already has the needed pattern: `packages/parity-fixtures` owns checked-in fixture bundles and Bazel fixture exports, while `packages/parity` owns executable evidence commands and checked-in status rows. [VERIFIED: packages/parity-fixtures/README.md; packages/parity-fixtures/BUILD.bazel; packages/parity/README.md; packages/parity/status.tsv]

Use a direct namespace at `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` containing `README.md`, `fixture-provenance.tsv`, `.gitattributes`, `PrusaResearch.ini`, and `PrusaResearch.idx`. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] Add a package-root verifier script and Bazel target under `packages/parity-fixtures` to check file presence, recorded source values, SHA-256 values, boundary wording, status non-publication, and forbidden fixture namespace absence without fetching upstream or running profile auto-update. [ASSUMED; VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; packages/fork-templates/verify_templates.sh; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

The accepted raw source files exist at the pinned PrusaSlicer commit. [VERIFIED: local curl check against raw GitHub URLs] `PrusaResearch.ini` is 1,543,688 bytes with SHA-256 `a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839`; `PrusaResearch.idx` is 31,543 bytes with SHA-256 `65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1`. [VERIFIED: local `wc -c` and `shasum -a 256` on raw GitHub files] The `.idx` file has CRLF line endings, so add a fixture-local `.gitattributes` with `PrusaResearch.ini -text` and `PrusaResearch.idx -text` to preserve raw bytes when possible. [VERIFIED: local `file` check; ASSUMED]

**Primary recommendation:** Add raw checked-in Prusa profile bundle inputs plus a TSV provenance manifest and a static Bazel verifier under `packages/parity-fixtures`; update `packages/parity-fixtures/README.md`, `packages/parity/README.md`, and the relevant `docs/port/` surfaces to reserve future status vocabulary while leaving `packages/parity/status.tsv` unchanged. [VERIFIED: packages/parity-fixtures/README.md; packages/parity/README.md; docs/port/README.md; docs/port/package-map.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md]

## Project Constraints (from AGENTS.md)

- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned canonical standards before planning, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; cited Bright Builds standards URLs]
- Do not edit managed Bright Builds text in `AGENTS.md` or `AGENTS.bright-builds.md`; repo-specific changes belong outside managed blocks or in `standards-overrides.md`. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- `standards-overrides.md` contains only the placeholder active-overrides table, so no real local standards exception changes Phase 38. [VERIFIED: standards-overrides.md]
- Future phase summaries must keep the YAML key `requirements-completed` hyphenated, synchronized with materially completed requirements, and not formatted with `mdformat`. [VERIFIED: AGENTS.md]
- Prefer repo-owned verification entrypoints, affected package checks, and pre-commit checks for changed paths. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Keep scripts checked in, rerunnable, shallow, and diagnosable instead of hiding substantial shell logic in inline commands. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Unit or shell failure-mode tests should test one concern at a time and use clear Arrange/Act/Assert sections when non-trivial. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- No project-local `.claude/skills/` or `.agents/skills/` directories exist. [VERIFIED: local project skill directory audit]
- No `tasks/lessons.md` or `.codex/tasks/lessons.md` file exists to review for this session. [VERIFIED: local lessons-file audit]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Bazel / Bazelisk | Bazel 8.6.0 from `.bazelversion`; Bazelisk available at `/opt/homebrew/bin/bazelisk`. [VERIFIED: `.bazelversion`; local `bazelisk --version`; local `command -v bazelisk`] | Export raw fixture files with aliases/filegroups and expose a static verifier/test target. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/prusa-baseline/BUILD.bazel] | Existing fixture and planning packages use Bazel package boundaries, `exports_files`, `filegroup`, `sh_binary`, and `sh_test` targets. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/prusa-baseline/BUILD.bazel; packages/fork-templates/BUILD.bazel] |
| Bash verifier | GNU Bash 3.2.57 on this macOS host. [VERIFIED: local `bash --version`] | Check exact fixture files, manifest values, status non-overclaiming text, and forbidden namespaces. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | Existing verifiers use `set -euo pipefail`, explicit `error` helpers, exact text checks, and focused diagnostics. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh; packages/fork-templates/verify_templates.sh] |
| Raw Prusa fixture files | `version_2.9.5` peeled commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`. [VERIFIED: packages/fork-vendors/forks.tsv] | Provide checked-in profile/config inputs for later Rust parsing and executable parity. [VERIFIED: .planning/REQUIREMENTS.md; .planning/ROADMAP.md] | Phase 38 is locked to static checked-in `PrusaResearch.ini` and matching `PrusaResearch.idx`, not curated excerpts or derived parser expectations. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| TSV provenance manifest | No runtime package version. [ASSUMED] | Record grep-verifiable fixture provenance, checksums, and update route beside the raw files. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | Existing fork metadata uses TSVs for source pins and inventories, and existing shell verifiers parse exact tabular values. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv; packages/fork-vendors/verify_forks.sh] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| `curl` | 8.7.1 locally. [VERIFIED: local `curl --version`] | Implementation-time one-shot retrieval of the two raw fixture files from the accepted pinned commit. [VERIFIED: local raw GitHub fixture check] | Use during implementation to download files, but do not call it from the committed verifier. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `shasum` | System command at `/usr/bin/shasum`. [VERIFIED: local `command -v shasum`] | Compute and verify SHA-256 checksums for raw fixture integrity. [VERIFIED: local `shasum -a 256` on raw GitHub fixture files] | Use in the static verifier and in implementation review. [ASSUMED] |
| `shfmt` | 3.12.0 locally. [VERIFIED: local `shfmt --version`] | Format/check any new shell verifier and shell tests. [CITED: Bright Builds verification standard URL above] | Run `shfmt -d` on new/changed shell files before completion. [VERIFIED: Phase 37 summary verification pattern] |
| `mdformat` | 1.0.0 locally. [VERIFIED: local `mdformat --version`] | Optional formatting for package docs only. [CITED: Bright Builds verification standard URL above] | Do not run it over phase `*-SUMMARY.md` files per repo-local guidance. [VERIFIED: AGENTS.md] |
| `buildifier` | Missing locally. [VERIFIED: local `buildifier` audit] | Optional BUILD formatting. [ASSUMED] | Rely on existing BUILD style plus Bazel analysis/test because this tool is absent. [ASSUMED; VERIFIED: packages/parity-fixtures/BUILD.bazel] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Direct namespace files in `prusaslicer.profile-schema/`. [ASSUMED] | Extra `raw/` or `vendor-bundle/` subdirectory. [ASSUMED] | A subdirectory can work under discretion, but direct files make the manifest and raw bundle easiest to inspect and keep "beside the fixture files" literal. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| TSV manifest. [ASSUMED] | JSON or Markdown-only manifest. [ASSUMED] | TSV matches existing source registry/inventory surfaces and is simple to grep from Bash without adding parsers. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv; packages/fork-vendors/verify_forks.sh] |
| Static verifier. [VERIFIED: locked decision] | Verifier that fetches raw upstream files and compares them. [ASSUMED] | Fetching upstream in the verifier contradicts the locked no-fetch/no-sync boundary for Phase 38 verification. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| Docs-only status reservation. [VERIFIED: locked decision] | Add `fork.prusaslicer.profile-schema` to `packages/parity/status.tsv` as `in progress`. [ASSUMED] | A status row would violate the locked decision that `status.tsv` remains reserved for executable evidence rows in Phase 38. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; packages/parity/README.md] |

**Installation:** Install no new dependencies for Phase 38. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; local environment audit]

**Version verification:** No npm packages are recommended, so `npm view` is not applicable. [VERIFIED: no JS package dependency in Phase 38 scope] Tool versions were verified with local `bazelisk --version`, `bash --version`, `curl --version`, `shfmt --version`, and `mdformat --version`. [VERIFIED: local environment audit]

## Fixture Source Facts

| File | Source URL | Bytes | Lines | SHA-256 | Line Endings |
|------|------------|-------|-------|---------|--------------|
| `PrusaResearch.ini` | `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini` [CITED: raw.githubusercontent.com/prusa3d/PrusaSlicer] | 1,543,688. [VERIFIED: local `wc -c`] | 42,247. [VERIFIED: local `wc -l`] | `a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839`. [VERIFIED: local `shasum -a 256`] | ASCII text, long lines. [VERIFIED: local `file`] |
| `PrusaResearch.idx` | `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx` [CITED: raw.githubusercontent.com/prusa3d/PrusaSlicer] | 31,543. [VERIFIED: local `wc -c`] | 438. [VERIFIED: local `wc -l`] | `65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1`. [VERIFIED: local `shasum -a 256`] | ASCII text with CRLF terminators. [VERIFIED: local `file`] |

The upstream profile bundle includes static URL-like and credential-like field names, including `config_update_url`, `changelog_url`, third-party filament note URLs, and an empty `octoprint_apikey =` field. [VERIFIED: local fixture pattern scan] This does not create network, profile auto-update, or credential support because Phase 38 must keep the files as inert fixture inputs only. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

The upstream PrusaSlicer repository license file at the accepted commit is AGPL text, and the repo-local vendor registry records `AGPL-3.0-only` plus `metadata-only-not-legal-review`. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/LICENSE; VERIFIED: packages/fork-vendors/forks.tsv] The planner should include attribution/provenance text and avoid claiming that metadata verification is legal review. [VERIFIED: packages/fork-vendors/README.md]

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity-fixtures/
├── BUILD.bazel
├── README.md
├── verify_prusa_profile_schema_fixture.sh
├── verify_prusa_profile_schema_fixture_test.sh
└── forks/
    └── prusaslicer/
        └── prusaslicer.profile-schema/
            ├── .gitattributes
            ├── README.md
            ├── fixture-provenance.tsv
            ├── PrusaResearch.ini
            └── PrusaResearch.idx
```

This structure keeps the raw files, manifest, and scope README in the locked namespace while keeping reusable verification targets at the existing `packages/parity-fixtures` package root. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; packages/parity-fixtures/BUILD.bazel]

### Pattern 1: Fixture Bundle Export

**What:** Add explicit `exports_files`, aliases for each raw file, and a `filegroup(name = "prusa_profile_schema_bundle")` in `packages/parity-fixtures/BUILD.bazel`. [ASSUMED; VERIFIED: packages/parity-fixtures/BUILD.bazel]

**When to use:** Use this pattern because later Phase 39/40 Rust parsing and parity commands need stable Bazel labels for fixture inputs. [VERIFIED: .planning/ROADMAP.md; packages/parity-fixtures/BUILD.bazel]

**Example:**

```python
# Source pattern: packages/parity-fixtures/BUILD.bazel [VERIFIED]
alias(
    name = "prusa_profile_schema_prusa_research_ini",
    actual = "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
)

filegroup(
    name = "prusa_profile_schema_bundle",
    srcs = [
        "forks/prusaslicer/prusaslicer.profile-schema/README.md",
        "forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx",
    ],
)
```

### Pattern 2: Manifest-Driven Static Verifier

**What:** Verify local fixture bytes and manifest values with a Bash script that takes explicit file paths from Bazel `data` and `args`. [ASSUMED; VERIFIED: packages/prusa-baseline/BUILD.bazel; packages/prusa-baseline/verify_prusa_baseline.sh]

**When to use:** Use this for file presence, checksum, source pin, source path, README boundary wording, and status non-publication checks. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

**Example:**

```bash
# Source pattern: packages/prusa-baseline/verify_prusa_baseline.sh [VERIFIED]
require_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if ! grep -Fq "${pattern}" "${file}"; then
		error "${label}: missing required text: ${pattern}"
	fi
}
```

### Pattern 3: Status Vocabulary Without Status Row

**What:** Add docs text reserving `fork.prusaslicer.profile-schema` for Phase 40, but keep `packages/parity/status.tsv` unchanged. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

**When to use:** Use this because `packages/parity/status.tsv` is already defined as the checked-in status data source for executable evidence rows. [VERIFIED: packages/parity/README.md; packages/parity/status.tsv]

**Example:**

```text
Future token: fork.prusaslicer.profile-schema
Phase 38 state: reserved vocabulary only; no status.tsv row.
Verified gate: Phase 40 rerunnable //packages/parity:*_parity command.
```

The wording above is recommended prose, not an existing file excerpt. [ASSUMED]

### Anti-Patterns to Avoid

- **Adding `fork.prusaslicer.profile-schema` to `packages/parity/status.tsv`:** This violates D-08 because Phase 38 has no executable Prusa parity command. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
- **Adding `//packages/parity:prusaslicer_profile_schema_parity`:** This moves into Phase 40 executable evidence scope. [VERIFIED: .planning/ROADMAP.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
- **Fetching upstream from committed verification:** This violates the no-fetch verifier boundary and can make verification unstable. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
- **Normalizing `PrusaResearch.idx` silently:** The accepted raw `.idx` has CRLF line endings, so silent normalization changes raw-byte provenance. [VERIFIED: local `file` and `shasum` checks]
- **Treating embedded update URLs or empty API-key fields as support:** These are static upstream profile fields and must not enable network, cloud, credential, or profile auto-update behavior. [VERIFIED: local fixture scan; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

## Fixture Provenance Format

Use `fixture-provenance.tsv` because it is readable, stable, and easy to validate from Bash. [ASSUMED; VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv]

Recommended header: [ASSUMED]

```text
# fixture_id	vendor_id	inventory_id	source_ref	source_path	source_url	local_path	sha256	bytes	line_endings	role	notes
```

Recommended rows: [ASSUMED; VERIFIED: local raw GitHub fixture check]

```text
PrusaResearch.ini	prusaslicer	prusaslicer.profile-schema	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	resources/profiles/PrusaResearch.ini	https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini	PrusaResearch.ini	a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839	1543688	lf	raw-vendor-bundle-input	Phase 38 fixture input only; future Phase 39 parsing and Phase 40 executable parity may consume it.
PrusaResearch.idx	prusaslicer	prusaslicer.profile-schema	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961	resources/profiles/PrusaResearch.idx	https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx	PrusaResearch.idx	65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1	31543	crlf	raw-vendor-bundle-index	Matching upstream PrusaResearch.idx from the accepted commit; static fixture input only.
```

The namespace README should also record the Phase 37 checklist source as `packages/prusa-baseline/profile-schema-checklist.md`, the accepted checklist gate command as `bazel run //packages/prusa-baseline:verify`, and the update route through reviewed changes to `packages/fork-vendors/forks.tsv` plus the Prusa baseline/checklist gate. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md; packages/prusa-baseline/README.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

## Exact Files Likely To Change

| Path | Action | Reason |
|------|--------|--------|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes` | Create. [ASSUMED] | Preserve raw text fixture bytes, especially CRLF in `PrusaResearch.idx`. [VERIFIED: local `file` check] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md` | Create. [VERIFIED: locked namespace and README/manifest boundary] | Explain fixture input scope, update route, accepted source pin, excluded surfaces, and no verified status claim. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv` | Create. [ASSUMED] | Provide grep-verifiable provenance/status manifest required by D-04 and D-05. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini` | Create from pinned raw source. [VERIFIED: local raw GitHub fixture check] | Provide static Prusa profile/config fixture input for later parsing/parity. [VERIFIED: .planning/REQUIREMENTS.md] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx` | Create from pinned raw source. [VERIFIED: local raw GitHub fixture check] | Provide matching Prusa profile bundle index fixture. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity-fixtures/BUILD.bazel` | Modify. [VERIFIED: existing fixture export surface] | Export new files, add aliases/filegroup, add verifier and verifier test targets, and extend `package_boundary`. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh` | Create. [ASSUMED] | Implement fail-closed static verification without fetch, profile auto-update, plugins, or parity command execution. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` | Create. [ASSUMED] | Add failure-mode coverage for missing files, wrong pin/checksum, missing boundary wording, and forbidden namespace/status row checks. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline_test.sh] |
| `packages/parity-fixtures/README.md` | Modify. [VERIFIED: existing fixture rules] | Replace future-only Prusa namespace wording with Phase 38's Prusa fixture surface while keeping other fork namespaces future/deferred. [VERIFIED: packages/parity-fixtures/README.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity/README.md` | Modify. [VERIFIED: existing status package rules] | Reserve `fork.prusaslicer.profile-schema` for future Phase 40 executable evidence without adding a status row. [VERIFIED: packages/parity/README.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `docs/port/README.md` | Modify. [VERIFIED: port control-plane entrypoint] | Add current Phase 38 fixture/status-prep state. [VERIFIED: docs/port/README.md] |
| `docs/port/package-map.md` | Modify. [VERIFIED: package-role docs] | Add Phase 38 note under `packages/parity-fixtures` / notes. [VERIFIED: docs/port/package-map.md] |
| `docs/port/migration-guidance.md` | Modify. [VERIFIED: fixture protocol docs] | Add update-route and future status-token routing. [VERIFIED: docs/port/migration-guidance.md] |
| `docs/port/parity-matrix.md` | Modify. [VERIFIED: status vocabulary docs] | Reserve future token and restate no verified Prusa status until executable evidence. [VERIFIED: docs/port/parity-matrix.md] |
| `packages/parity/status.tsv` | Do not modify. [VERIFIED: locked decision] | Phase 38 must not add a Prusa row. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `packages/parity/BUILD.bazel` | Do not modify for Prusa command creation. [VERIFIED: locked decision] | Phase 38 must not add `//packages/parity:*_parity` evidence. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |

## Likely Bazel Targets

| Target | Type | Purpose |
|--------|------|---------|
| `//packages/parity-fixtures:prusa_profile_schema_prusa_research_ini` | `alias`. [ASSUMED] | Stable label for `PrusaResearch.ini` fixture input. [VERIFIED: packages/parity-fixtures/BUILD.bazel pattern] |
| `//packages/parity-fixtures:prusa_profile_schema_prusa_research_idx` | `alias`. [ASSUMED] | Stable label for `PrusaResearch.idx` fixture input. [VERIFIED: packages/parity-fixtures/BUILD.bazel pattern] |
| `//packages/parity-fixtures:prusa_profile_schema_bundle` | `filegroup`. [ASSUMED] | Bundle README, manifest, and raw fixture files for later Phase 39/40 consumers. [VERIFIED: packages/parity-fixtures/BUILD.bazel pattern] |
| `//packages/parity-fixtures:verify_prusa_profile_schema_fixture` | `sh_binary`. [ASSUMED] | Run static fixture/provenance/status-prep verification. [VERIFIED: packages/prusa-baseline/BUILD.bazel pattern] |
| `//packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` | `sh_test`. [ASSUMED] | Prove verifier failure modes. [VERIFIED: packages/prusa-baseline/BUILD.bazel pattern] |

Do not create `//packages/parity:prusaslicer_profile_schema_parity` in Phase 38. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] The current query for that target fails because it is not declared. [VERIFIED: local `bazel query //packages/parity:prusaslicer_profile_schema_parity`]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Upstream source synchronization | Nightly sync, clone, subtree, submodule, Bzlmod upstream repo, or updater script. [VERIFIED: .planning/REQUIREMENTS.md] | One-time raw file intake from accepted pinned URLs plus manifest checks. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | v1.10 excludes upstream source-tree imports and vendor sync automation. [VERIFIED: .planning/REQUIREMENTS.md] |
| Prusa profile parsing | INI parser, schema normalizer, or Rust domain model. [VERIFIED: .planning/ROADMAP.md] | Raw fixture files and static provenance only. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | Rust parsing is Phase 39 scope. [VERIFIED: .planning/ROADMAP.md] |
| Prusa parity command | Placeholder `*_parity` script or command that only checks files. [ASSUMED] | Future Phase 40 executable parity command. [VERIFIED: .planning/ROADMAP.md] | Verified status requires real rerunnable executable evidence, not fixture presence. [VERIFIED: packages/parity/README.md] |
| Status table publication | Custom status generator or manual Prusa row in `packages/parity/status.tsv`. [VERIFIED: locked decision] | Docs-only vocabulary reservation. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | `status.tsv` is reserved for executable evidence rows. [VERIFIED: packages/parity/README.md] |
| Checksum implementation | Custom hashing in Bash or Rust. [ASSUMED] | `shasum -a 256`. [VERIFIED: local command availability] | The system tool is available and avoids new code. [VERIFIED: local environment audit] |
| Forbidden namespace detection | Ad hoc human review only. [ASSUMED] | Static `find`/path checks in verifier plus explicit plan verification commands. [ASSUMED; VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh] | EVID-01 requires maintainers to confirm no forbidden fixture namespaces were introduced. [VERIFIED: .planning/REQUIREMENTS.md] |

**Key insight:** The artifact to trust after Phase 38 is fixture provenance and scope control, not behavior. [VERIFIED: .planning/ROADMAP.md] Behavior remains untrusted until Phase 39 parses the fixture and Phase 40 compares executable evidence. [VERIFIED: .planning/ROADMAP.md]

## Common Pitfalls

### Pitfall 1: Publishing Status Before Evidence

**What goes wrong:** `packages/parity/status.tsv` gains `fork.prusaslicer.profile-schema` before a rerunnable Prusa parity command exists. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**Why it happens:** Checked-in fixtures can look like proof even though this phase only prepares evidence inputs. [VERIFIED: packages/parity/README.md]
**How to avoid:** Keep `status.tsv` unchanged and reserve the token in docs/README prose only. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**Warning signs:** `rg -n "fork\\.prusaslicer|prusaslicer.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv` returns matches. [VERIFIED: local status guard command]

### Pitfall 2: Line Ending Drift Changes Fixture Provenance

**What goes wrong:** `PrusaResearch.idx` is normalized from CRLF to LF, changing the raw SHA-256 from the accepted upstream bytes. [VERIFIED: local `file` and `shasum` checks]
**Why it happens:** The repo has no root `.gitattributes`, so line-ending handling is not pinned by repo policy. [VERIFIED: local `.gitattributes` audit]
**How to avoid:** Add fixture-local `.gitattributes` and have the verifier check the checked-in checksum. [ASSUMED; VERIFIED: local raw fixture checks]
**Warning signs:** The checked-in `.idx` checksum does not match `65fc21319b2954e5df36040e5a581a313fb409ad9337c2007b1d0f9f2b2352f1`. [VERIFIED: local `shasum -a 256`]

### Pitfall 3: Static URL Fields Become Runtime Scope

**What goes wrong:** Docs or future code treats `config_update_url`, `changelog_url`, filament URLs, or `octoprint_apikey =` as permission to run profile auto-update, network/device, cloud, or credential behavior. [VERIFIED: local fixture scan; .planning/REQUIREMENTS.md]
**Why it happens:** The upstream vendor bundle includes real configuration fields even when Phase 38 uses the file only as inert fixture input. [VERIFIED: local fixture scan; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**How to avoid:** README and verifier required text must state "static fixture input only" and explicitly exclude network/device integration, cloud behavior, credentials, and profile auto-update execution. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**Warning signs:** New code executes profile update URLs, reads credentials, or imports network plugin behavior. [VERIFIED: .planning/REQUIREMENTS.md]

### Pitfall 4: Curated Excerpts Replace Raw Vendor Bundle

**What goes wrong:** Implementation checks in only a small excerpt or derived parser expectation file. [VERIFIED: locked D-02]
**Why it happens:** The raw `.ini` is large at 1,543,688 bytes, and excerpts are easier to review. [VERIFIED: local `wc -c`; ASSUMED]
**How to avoid:** Check in the raw `PrusaResearch.ini` and matching `PrusaResearch.idx` from the accepted pin, then let Phase 39 create parser fixtures/tests from those inputs. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; .planning/ROADMAP.md]
**Warning signs:** Manifest lacks raw source URLs, source paths, or SHA-256 values for both files. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]

### Pitfall 5: Forbidden Fork/Network Fixtures Slip In

**What goes wrong:** A broad `forks/` fixture tree also adds Bambu Studio, OrcaSlicer, network, cloud, credential, or non-free plugin fixtures. [VERIFIED: .planning/REQUIREMENTS.md]
**Why it happens:** The repo already has source inventories for multiple forks, but Phase 38 is Prusa-only. [VERIFIED: packages/fork-inventories/README.md; .planning/REQUIREMENTS.md]
**How to avoid:** Verifier should scan under `packages/parity-fixtures/forks` and allow only the locked Prusa profile-schema namespace. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
**Warning signs:** Paths contain `bambustudio`, `orcaslicer`, `network`, `cloud`, `credential`, or `plugin` under `packages/parity-fixtures/forks`. [ASSUMED; VERIFIED: .planning/REQUIREMENTS.md]

## Code Examples

Verified patterns from repository sources follow. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/prusa-baseline/verify_prusa_baseline.sh]

### Bazel Verifier Shape

```python
# Source pattern: packages/prusa-baseline/BUILD.bazel [VERIFIED]
sh_binary(
    name = "verify_prusa_profile_schema_fixture",
    srcs = ["verify_prusa_profile_schema_fixture.sh"],
    data = [
        "forks/prusaslicer/prusaslicer.profile-schema/README.md",
        "forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx",
        "//packages/parity:status.tsv",
    ],
)
```

The exact target name is recommended under discretion. [ASSUMED]

### Exact Manifest Text Check

```bash
# Source pattern: packages/prusa-baseline/verify_prusa_baseline.sh [VERIFIED]
require_text "${manifest_file}" "fixture-provenance.tsv" \
	"prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
```

### Checksum Check

```bash
# Source: local shasum command used during research [VERIFIED]
actual_sha="$(shasum -a 256 "${ini_file}" | awk '{ print $1 }')"
if [[ "${actual_sha}" != "a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839" ]]; then
	error "PrusaResearch.ini: checksum mismatch"
fi
```

### Status Non-Publication Guard

```bash
# Source pattern: packages/prusa-baseline/verify_prusa_baseline.sh [VERIFIED]
if grep -Eq 'fork\.prusaslicer|prusaslicer\.profile-schema|prusaslicer_profile_schema_parity' "${status_file}"; then
	error "packages/parity/status.tsv must not publish Prusa profile-schema status in Phase 38"
fi
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Phase 36 documented a future fork fixture namespace but created no fork fixture files. [VERIFIED: packages/parity-fixtures/README.md; docs/port/migration-guidance.md] | Phase 38 should create the first real Prusa fixture namespace and raw checked-in bundle. [VERIFIED: .planning/ROADMAP.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | v1.10 Phase 38. [VERIFIED: .planning/ROADMAP.md] | Later Phase 39/40 work can consume stable fixture labels instead of inventing fixture provenance. [ASSUMED] |
| Phase 37 checklist only named future fixture and command shapes. [VERIFIED: packages/prusa-baseline/profile-schema-checklist.md] | Phase 38 should materialize the fixture input surface and still keep parity command/status publication future-only. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | After Phase 37 completion. [VERIFIED: .planning/phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md] | The milestone moves from source/checklist gate to inspectable fixture evidence input. [VERIFIED: .planning/ROADMAP.md] |
| Fork status rows were entirely absent. [VERIFIED: packages/parity/status.tsv; docs/port/parity-matrix.md] | Phase 38 reserves `fork.prusaslicer.profile-schema` vocabulary in docs only. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | v1.10 Phase 38. [VERIFIED: .planning/ROADMAP.md] | Maintainers can discuss future status without overclaiming verified Prusa support. [VERIFIED: .planning/REQUIREMENTS.md] |

**Deprecated/outdated:** Treating source pins, inventories, checklists, flavor metadata, or raw fixtures as verified fork parity is explicitly rejected by current repo docs. [VERIFIED: packages/parity/README.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Use direct files under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/` rather than a `raw/` subdirectory. [ASSUMED] | Summary; Architecture Patterns; Exact Files | Low: the context allows subdirectory discretion as long as raw files and manifest are easy to inspect. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| A2 | Use `fixture-provenance.tsv` as the manifest filename and TSV as the format. [ASSUMED] | Fixture Provenance Format | Low: the context allows filename/format discretion, but implementation must update verifier/docs to match. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| A3 | Add fixture-local `.gitattributes` with `-text` for the raw fixture files. [ASSUMED] | Summary; Exact Files; Pitfalls | Medium: this adds one extra file but protects raw-byte provenance for the CRLF `.idx` file. [VERIFIED: local `.gitattributes` audit; local `file` check] |
| A4 | Use target names `prusa_profile_schema_bundle`, `verify_prusa_profile_schema_fixture`, and matching aliases/tests. [ASSUMED] | Likely Bazel Targets | Low: target names are discretionary, but Phase 39/40 plans need stable labels once chosen. [VERIFIED: packages/parity-fixtures/BUILD.bazel pattern] |

## Open Questions (RESOLVED)

1. **Does committing upstream AGPL profile fixture data need maintainer/legal review beyond recorded provenance?** [VERIFIED: packages/fork-vendors/forks.tsv]
   - What we know: Phase 38 is locked to checked-in raw Prusa fixture inputs, and the vendor registry records `AGPL-3.0-only` plus `metadata-only-not-legal-review`. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; packages/fork-vendors/forks.tsv]
   - Resolution: Proceed in Phase 38 with clear attribution/provenance, `AGPL-3.0-only`, and `metadata-only-not-legal-review` wording, because the roadmap and context explicitly require checked-in static fixture inputs and no separate legal-review gate is recorded in repo instructions, requirements, or Phase 37 outputs. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; .planning/phases/37-prusa-baseline-and-checklist-gate/37-01-SUMMARY.md]
   - Guardrail: Do not claim legal review is complete. Preserve `metadata-only-not-legal-review` wording in fixture provenance/docs, cite upstream source/license, and keep runtime support, plugin ingestion, network/cloud/credential behavior, source imports, and sync automation out of scope. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/forks.tsv; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
   - Escalation rule: If a human maintainer later requires legal approval before committing upstream fixture content, stop before Task 1 and convert the plan to a non-autonomous checkpoint. No such requirement is currently present in the repo-local instructions or phase scope. [VERIFIED: AGENTS.md; .planning/REQUIREMENTS.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazelisk / Bazel | Bazel exports, verifier, and test targets. [VERIFIED: packages/parity-fixtures/BUILD.bazel pattern] | Yes. [VERIFIED: local `command -v bazelisk`; local `command -v bazel`] | Bazel 8.6.0. [VERIFIED: `.bazelversion`; local `bazelisk --version`] | None needed. [VERIFIED: existing Bazel repo pattern] |
| Bash | Verifier and shell tests. [VERIFIED: packages/prusa-baseline/verify_prusa_baseline.sh] | Yes. [VERIFIED: local `bash --version`] | GNU Bash 3.2.57. [VERIFIED: local `bash --version`] | Keep scripts Bash 3.2-compatible. [ASSUMED] |
| `curl` | One-time implementation retrieval of raw fixture files. [VERIFIED: local raw GitHub fixture check] | Yes. [VERIFIED: local `command -v curl`] | 8.7.1. [VERIFIED: local `curl --version`] | Manual browser/download is a human fallback; committed verifier must not depend on network. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| `shasum` | Static checksum verification. [VERIFIED: local `shasum -a 256`] | Yes. [VERIFIED: local `command -v shasum`] | System command, version not printed. [VERIFIED: local command availability] | Use `sha256sum` only if porting the verifier to an environment without `shasum`. [ASSUMED] |
| `git` | Commit workflow and optional review checks. [VERIFIED: local `git --version`] | Yes. [VERIFIED: local `command -v git`] | 2.53.0. [VERIFIED: local `git --version`] | None needed. [ASSUMED] |
| `shfmt` | Shell script formatting check. [CITED: Bright Builds verification standard] | Yes. [VERIFIED: local `command -v shfmt`] | 3.12.0. [VERIFIED: local `shfmt --version`] | If missing on another machine, rely on shell test plus code review. [ASSUMED] |
| `mdformat` | Optional docs formatting outside phase summaries. [VERIFIED: AGENTS.md] | Yes. [VERIFIED: local `mdformat --version`] | 1.0.0. [VERIFIED: local `mdformat --version`] | Do not run over phase summaries. [VERIFIED: AGENTS.md] |
| `buildifier` | Optional BUILD formatting. [ASSUMED] | No. [VERIFIED: local `buildifier` audit] | N/A. [VERIFIED: local `buildifier` audit] | Follow existing BUILD style and run Bazel query/test. [ASSUMED; VERIFIED: packages/parity-fixtures/BUILD.bazel] |

**Missing dependencies with no fallback:** None for Phase 38. [VERIFIED: local environment audit]

**Missing dependencies with fallback:** `buildifier` is missing, but Bazel analysis and existing BUILD style are adequate for this small package edit. [ASSUMED; VERIFIED: local `buildifier` audit; packages/parity-fixtures/BUILD.bazel]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | No authentication surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V3 Session Management | No. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | No session state is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | No. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] | No authorization boundary is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | Yes. [VERIFIED: planned verifier boundary] | Validate local file presence, checksums, manifest values, status non-publication, and forbidden namespace absence. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| V6 Cryptography | Limited integrity use only. [ASSUMED] | Use `shasum -a 256` for provenance integrity checks; do not add custom crypto. [VERIFIED: local `shasum` availability] |

### Known Threat Patterns for Static Fixture Evidence

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Fixture poisoning by editing `PrusaResearch.ini` or `.idx` while leaving provenance unchanged. [ASSUMED] | Tampering | Verify SHA-256, byte size, source ref, and source path in a rerunnable target. [VERIFIED: local raw fixture checks; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| Status overclaim by publishing a Prusa row before executable evidence. [VERIFIED: packages/parity/README.md] | Spoofing | Fail if `packages/parity/status.tsv` contains Prusa profile-schema row/token text in Phase 38. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| Network or credential behavior inferred from static profile fields. [VERIFIED: local fixture scan] | Elevation of Privilege / Information Disclosure | README and verifier required text must exclude profile auto-update execution, network/cloud behavior, and credentials. [VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| Forbidden fork fixture expansion slips into milestone. [VERIFIED: .planning/REQUIREMENTS.md] | Tampering | Static path scan should reject Bambu Studio, OrcaSlicer, network, cloud, credential, and non-free plugin fixture namespaces. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md] |
| License/provenance represented as legal review. [VERIFIED: packages/fork-vendors/forks.tsv] | Repudiation | Preserve `metadata-only-not-legal-review` wording and cite upstream source/license. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/forks.tsv] |

## Validation Notes

`workflow.nyquist_validation` is not explicitly set to `true` in `.planning/config.json`, so the dedicated Validation Architecture section is omitted by GSD rules. [VERIFIED: .planning/config.json]

Recommended Phase 38 verification commands for the implementation plan: [ASSUMED]

```bash
bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture
bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test
shfmt -d packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh
bazel query //packages/parity-fixtures:prusa_profile_schema_bundle
bazel query //packages/parity:prusaslicer_profile_schema_parity
rg -n "fork\\.prusaslicer|prusaslicer.profile-schema|prusaslicer_profile_schema_parity" packages/parity/status.tsv
git diff --check
```

The `bazel query //packages/parity:prusaslicer_profile_schema_parity` command should fail during Phase 38, and the `rg` command against `packages/parity/status.tsv` should return no matches. [VERIFIED: local Bazel/status guard checks]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md` - locked Phase 38 decisions, discretion, deferred scope, canonical refs, and code context. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - EVID-01 through EVID-03 and v1.10 out-of-scope table. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 38 goal, dependency, success criteria, and Phase 39/40 boundaries. [VERIFIED: local file read]
- `.planning/STATE.md` - current milestone state and fork parity evidence decisions. [VERIFIED: local file read]
- `.planning/phases/37-prusa-baseline-and-checklist-gate/37-CONTEXT.md` and `37-01-SUMMARY.md` - prior locked decisions and completed Phase 37 outputs. [VERIFIED: local file read]
- `packages/parity-fixtures/README.md` and `BUILD.bazel` - current fixture package rules, exports, aliases, and filegroup patterns. [VERIFIED: local file read]
- `packages/parity/README.md`, `status.tsv`, `BUILD.bazel`, and `parity_status.sh` - status package rules and current no-Prusa-row state. [VERIFIED: local file read; local status guard]
- `packages/prusa-baseline/README.md`, `profile-schema-checklist.md`, `BUILD.bazel`, and verifier scripts - Phase 37 accepted baseline and shell/Bazel verifier patterns. [VERIFIED: local file read]
- `packages/fork-vendors/forks.tsv` and README - accepted Prusa source pin, license/provenance fields, and branch-drift-only update policy. [VERIFIED: local file read]
- `packages/fork-inventories/prusaslicer.tsv` and README - `prusaslicer.profile-schema` inventory row and planning-only scope. [VERIFIED: local file read]
- `docs/port/README.md`, `package-map.md`, `migration-guidance.md`, and `parity-matrix.md` - docs routing, fixture protocol, and status vocabulary guardrails. [VERIFIED: local file read]
- Raw Prusa fixture URLs at commit `9a583bd438b195856f3bcf7ea99b69ba4003a961` - file existence, size, checksum, line ending, and static field scan. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.ini; CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/resources/profiles/PrusaResearch.idx; VERIFIED: local curl/wc/file/shasum/awk checks]
- Bright Builds standards at pinned commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape, verification, testing, and operability pages. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

### Secondary (MEDIUM confidence)

- None. [VERIFIED: no secondary sources used]

### Tertiary (LOW confidence)

- None. [VERIFIED: no unverified search findings used]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - stack is repo-local Bazel, Bash, static files, and system checksum tools verified in this session. [VERIFIED: packages/parity-fixtures/BUILD.bazel; local environment audit]
- Architecture: HIGH - fixture package and verifier patterns are established by existing package code. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/prusa-baseline/BUILD.bazel; packages/prusa-baseline/verify_prusa_baseline.sh]
- Fixture source facts: HIGH - raw files were fetched from the accepted pinned commit and checked locally for bytes, line counts, checksums, and line endings. [VERIFIED: local curl/wc/file/shasum checks]
- Manifest and target naming: MEDIUM - exact names are recommended under explicit agent discretion. [ASSUMED; VERIFIED: .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md]
- Pitfalls: HIGH - overclaiming, no-fetch verification, forbidden namespaces, and status-row limits are explicit in requirements/context/docs. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/38-prusa-fixture-and-status-evidence-surface/38-CONTEXT.md; packages/parity/README.md]

**Research date:** 2026-06-01. [VERIFIED: current session date]
**Valid until:** 2026-07-01 for repo-local patterns; re-check raw fixture URLs/checksums if the accepted source pin changes through a reviewed intake update. [ASSUMED; VERIFIED: packages/fork-vendors/README.md]
