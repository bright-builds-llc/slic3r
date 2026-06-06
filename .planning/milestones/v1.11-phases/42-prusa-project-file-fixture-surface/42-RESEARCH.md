# Phase 42: Prusa Project-File Fixture Surface - Research

**Researched:** 2026-06-03
**Domain:** PrusaSlicer project-file fixture provenance, expected artifact, Bazel/Bash verification, and port docs
**Confidence:** HIGH

<user_constraints>

## User Constraints (from CONTEXT.md)

All constraints in this section are copied from `.planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Fixture Namespace and Provenance

- **D-01:** Use the Phase 41 reserved flat namespace:
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`.
- **D-02:** Check in the source-pinned upstream fixture as
  `seam_test_object.3mf` in that namespace, with `.gitattributes` marking the
  fixture as binary.
- **D-03:** Record provenance in `fixture-provenance.tsv` using the existing
  profile-schema fixture model: fixture ID, vendor ID, inventory ID, source ref,
  accepted tag, peeled commit, source path, upstream URL, byte count, SHA-256,
  line endings, role, Phase 41 scope record path, update route, status scope,
  and exclusions.
- **D-04:** Pin the fixture to
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`, source
  path `tests/data/seam_test_object.3mf`, size `2514963`, SHA-256
  `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`, and
  binary line-ending handling.
- **D-05:** The update route must require a reviewed intake change updating
  `packages/fork-vendors/forks.tsv`, `packages/fork-inventories/prusaslicer.tsv`,
  and the Phase 41 project-file scope gate. Branch-head observations remain
  drift-only and do not update this fixture.

### Expected Artifact

- **D-06:** Create
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  with exactly these columns: `source_ref`, `fixture_path`, `archive_member`,
  `project_marker`, `deferred_semantics`, and `notes`.
- **D-07:** Use the expected artifact for shallow package-shape and marker
  evidence only. Rows should cover required archive members such as
  `[Content_Types].xml`, `_rels/.rels`, `3D/3dmodel.model`,
  `Metadata/thumbnail.png`, `Metadata/Slic3r_PE.config`, and
  `Metadata/Slic3r_PE_model.config`.
- **D-08:** `project_marker` values should stay presence-level and
  non-semantic, such as OPC content types, start-part relationship,
  `slic3rpe:Version3mf`, `Application=PrusaSlicer-2.8.0-alpha3`, and
  Prusa/Slic3r metadata config file presence.
- **D-09:** Keep byte counts, hashes, and upstream URLs in provenance, not in
  `expected-project-summary.tsv`.
- **D-10:** Do not include geometry counts, config key counts, printer/profile
  semantics, generated-output details, import/export behavior, status rows, or
  runtime claims in the expected artifact.

### Fail-Closed Verifier

- **D-11:** Add Bazel targets in `packages/parity-fixtures/BUILD.bazel`:
  `verify_prusa_project_file_fixture`,
  `verify_prusa_project_file_fixture_test`, and project-file fixture aliases or
  filegroups following the existing `prusaslicer.profile-schema` pattern.
- **D-12:** Implement the verifier as Bash with exact text checks plus targeted
  TSV header/row checks. Prefer the existing Phase 38 fixture verifier and
  Phase 41 scope verifier style over a new parser framework.
- **D-13:** The verifier must fail when required fixture bytes, provenance,
  expected-artifact columns, update-route text, scope-record traceability, or
  non-overclaiming boundary text are missing or inconsistent.
- **D-14:** The verifier or its tests must include negative guards that Phase 43
  and Phase 44 artifacts have not been created early: no
  `slic3r_flavors::prusa_project_file` parser surface, no
  `//packages/parity:prusaslicer_project_file_parity` target, and no
  `fork.prusaslicer.project-file` status row.
- **D-15:** Verification should remain local and hermetic. Do not fetch upstream
  source during verification, execute profile auto-update behavior, import
  upstream source trees, run Git, access network services, or ingest plugins.

### Docs and Handoff

- **D-16:** Update `packages/parity-fixtures/README.md` and relevant
  `docs/port/` surfaces so maintainers can find the new fixture namespace,
  run the fixture verifier, and understand that executable project-file parity
  remains unavailable until Phase 44.
- **D-17:** Docs must continue to defer full PrusaSlicer runtime support, GUI
  project behavior, full 3MF import/export, generated-output parity, STEP
  import, support generation, arc fitting, wall seam behavior, network/device
  integration, profile auto-update execution, fork release builds, Bambu
  Studio, OrcaSlicer, upstream source imports, and sync automation.

### the agent's Discretion

- The agent may decide the exact row wording for `expected-project-summary.tsv`
  as long as the file keeps the Phase 41 columns exactly and stays
  presence-level rather than semantic.
- The agent may decide whether to share small Bash helper functions with the
  existing profile-schema verifier or keep a separate project-file verifier,
  whichever is clearer and lower risk.
- The agent may decide the minimum doc set to update, provided the package
  README and port docs expose the fixture verifier and preserve the
  non-overclaiming boundary.

### Deferred Ideas (OUT OF SCOPE)

Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
generated-output parity, STEP import, support generation, arc fitting, wall
seam behavior, network/device integration, profile auto-update execution, fork
release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
automation remain outside Phase 42.
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PFIX-01 | Maintainer can inspect a Prusa project-file fixture namespace, provenance manifest, update rules, and checked-in expected artifact that trace to the Phase 41 scope gate and accepted source decision. [VERIFIED: .planning/REQUIREMENTS.md] | Use the Phase 41 reserved namespace, checked-in `seam_test_object.3mf`, `fixture-provenance.tsv`, `.gitattributes`, fixture README, and `expected-project-summary.tsv` shape described below. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/prusa-project-file-scope/project-file-scope.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv] |
| PFIX-02 | Maintainer can run a repo-owned fixture verifier that fails when required Prusa project-file fixture provenance, expected artifacts, update rules, or non-overclaiming scope text are missing or inconsistent. [VERIFIED: .planning/REQUIREMENTS.md] | Mirror the existing `verify_prusa_profile_schema_fixture.sh` plus failure-mode shell test pattern, add exact size/SHA/member/header checks, and retain negative guards for Phase 43/44 artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
</phase_requirements>

## Summary

Phase 42 should create the project-file fixture surface in `packages/parity-fixtures`, not Rust parser code or executable parity status. [VERIFIED: .planning/ROADMAP.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] The local precedent is the Prusa profile-schema fixture bundle: checked-in fixture inputs, a fixture README, `.gitattributes`, `fixture-provenance.tsv`, expected artifact, Bazel filegroups/aliases, and a Bash verifier with failure-mode tests. [VERIFIED: packages/parity-fixtures/README.md; packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

The upstream fixture is confirmed at the pinned commit and path from Phase 41/42: `tests/data/seam_test_object.3mf` under `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. [VERIFIED: packages/prusa-project-file-scope/project-file-scope.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] A research-only download to `/tmp` verified byte count `2514963`, SHA-256 `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`, and exactly six archive members. \[VERIFIED: local `curl`, `wc -c`, `shasum -a 256`, `zipinfo -1` against /tmp/slic3r-phase42-seam_test_object.3mf on 2026-06-03\]

**Primary recommendation:** Add a self-contained project-file fixture bundle and fail-closed verifier under `packages/parity-fixtures`, with expected evidence limited to archive members and presence-level markers; keep `slic3r_flavors::prusa_project_file`, `//packages/parity:prusaslicer_project_file_parity`, and `fork.prusaslicer.project-file` absent until later phases. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; .planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md; packages/parity/status.tsv]

## Project Constraints (from AGENTS.md)

- Before planning, review, implementation, or audit work, the repo requires reading `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds standards pages. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- The managed Bright Builds block in `AGENTS.md` and the sidecar `AGENTS.bright-builds.md` must not be edited directly. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Repo-specific workflow facts belong in `AGENTS.md`; deliberate standards deviations belong in `standards-overrides.md`. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md]
- `standards-overrides.md` contains only the placeholder active override row, so no active local exception changes this Phase 42 research. [VERIFIED: standards-overrides.md]
- For `.planning/phases/*/*-SUMMARY.md`, keep `requirements-completed` in sync, use the exact hyphenated key, and do not run `mdformat` over phase summary files. [VERIFIED: AGENTS.md]
- For Phase 42 implementation planning, prefer functional-core/imperative-shell separation where logic grows beyond exact Bash fixture checks, parse boundary data into structured/domain values before deeper Rust work, and make illegal states unrepresentable in Rust phases. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Verification should use repo-owned entrypoints first, and changed Markdown or shell paths should use available formatter checks when repo guidance does not define a narrower workflow. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Unit tests for pure or business logic must test one concern and clearly delineate Arrange, Act, and Assert when the structure is not trivial. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]

## Standard Stack

### Core

| Tool or Surface | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Bazel `sh_binary`, `sh_test`, `filegroup`, `alias`, and `exports_files` | Bazel 8.6.0 locally | Expose fixture files and verifier commands through repo-owned targets. \[VERIFIED: local `bazel --version`; packages/parity-fixtures/BUILD.bazel\] | Existing fixture packages already use these Bazel rules for profile-schema verification and parity handoff. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |
| Bash verifier scripts | GNU bash 3.2.57 locally | Implement exact file, size, hash, TSV, README, and negative boundary checks. \[VERIFIED: local `bash --version`; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh\] | Phase 38 and Phase 41 use Bash verifiers with `set -euo pipefail`, exact text helpers, and failure-mode shell tests. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh] |
| `shasum`, `wc`, `awk`, `grep`, `find` | `shasum` 6.02; system `/usr/bin` tools | Verify fixture byte count, SHA-256, provenance rows, required text, and namespace boundaries. \[VERIFIED: local `shasum --version`; local `command -v awk grep wc find`\] | The current profile-schema verifier uses `wc -c`, `shasum -a 256`, `awk`, `grep`, and `find` for fail-closed local checks. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| `zipinfo` / `unzip -p` | ZipInfo 3.00 / UnZip 6.00 locally | Verify the checked-in 3MF archive member list and presence-level marker strings without extracting source trees or parsing full 3MF semantics. \[VERIFIED: local `zipinfo -h`; local `unzip -v`; local archive inspection\] | A 3MF file is a ZIP/OPC container for this fixture surface, and Phase 42 evidence is limited to archive/member markers rather than Rust parsing. [VERIFIED: zipinfo against upstream fixture; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |

### Supporting

| Tool or Surface | Version | Purpose | When to Use |
|-----------------|---------|---------|-------------|
| `shfmt` | 3.12.0 locally | Check shell formatting for new verifier scripts. \[VERIFIED: local `shfmt --version`\] | Use on `verify_prusa_project_file_fixture.sh` and its test after implementation. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md] |
| `mdformat` | 1.0.0 locally | Check non-summary Markdown formatting when the plan touches package docs or port docs. \[VERIFIED: local `mdformat --version`; .planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md\] | Use on package README and `docs/port/*.md`; do not run it over phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md] |
| `curl` | `/usr/bin/curl` available | One-time fixture intake or research download from the pinned upstream raw URL. \[VERIFIED: local `command -v curl`; local research download\] | Use only for human-reviewed intake outside the verifier; the Phase 42 verifier must not fetch network content. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `file` | `/usr/bin/file` available | Optional local evidence that `Metadata/thumbnail.png` is a PNG member. \[VERIFIED: local `command -v file`; local `unzip -p ... | file -`\] | Use for research or optional verifier strictness only if it stays presence-level and nonsemantic. [VERIFIED: local archive inspection; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Bash exact checks | Python, Rust, or a new TSV/ZIP parser | Do not add a parser framework in Phase 42 because the local standard is exact Bash fixture verification and Rust parsing is Phase 43. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| Checked-in fixture bytes | Fetch the upstream file during `bazel run` | Do not fetch during verification because Phase 42 requires local/hermetic verification and source fetching would break the fail-closed fixture contract. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Presence-level expected artifact | Geometry/config semantic summary | Do not summarize geometry counts, config key counts, printer/profile semantics, generated output, import/export behavior, or runtime status in Phase 42. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |

**Installation:**

No new package dependency should be installed for Phase 42. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local environment checks]

**Version verification:**

`npm view` is not applicable because Phase 42 adds no npm package. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] Tool versions were verified with local CLI probes: `bazel --version`, `bash --version`, `shasum --version`, `unzip -v`, `zipinfo -h`, `shfmt --version`, and `mdformat --version`. [VERIFIED: local command outputs on 2026-06-03]

## Concrete Artifact Surface

| Artifact | Owner | Required Content | Planner Notes |
|----------|-------|------------------|---------------|
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/.gitattributes` | `packages/parity-fixtures` | Mark `seam_test_object.3mf` as binary with `-text`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes] | Mirror the profile-schema fixture `.gitattributes` pattern but use the project-file fixture name. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes] |
| `.../seam_test_object.3mf` | `packages/parity-fixtures` | Checked-in upstream fixture from `tests/data/seam_test_object.3mf`, size `2514963`, SHA-256 `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local curl/wc/shasum verification] | This is fixture input only and must not imply broad 3MF import/export support. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `.../fixture-provenance.tsv` | `packages/parity-fixtures` | Columns should be `fixture_id`, `vendor_id`, `inventory_id`, `source_ref`, `accepted_tag`, `peeled_commit`, `source_path`, `upstream_url`, `bytes`, `sha256`, `line_endings`, `role`, `phase41_scope_record`, `update_route`, `status_scope`, and `exclusions`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv] | Use `packages/prusa-project-file-scope/project-file-scope.md` for the Phase 41 traceability field. [VERIFIED: packages/prusa-project-file-scope/project-file-scope.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `.../expected-project-summary.tsv` | `packages/parity-fixtures` | Exactly `source_ref`, `fixture_path`, `archive_member`, `project_marker`, `deferred_semantics`, `notes` columns. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/prusa-project-file-scope/project-file-scope.md] | Keep rows presence-level; put hashes, sizes, and URLs in provenance instead. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `.../README.md` | `packages/parity-fixtures` | Fixture provenance summary, update route, status boundary, exclusions, and command route to the Phase 42 verifier. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | State that executable project-file parity remains unavailable until Phase 44. [VERIFIED: docs/port/parity-matrix.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` | `packages/parity-fixtures` | Local Bash verifier for file existence, exact size/SHA, provenance row, expected artifact header/rows, README/update route text, docs boundary text, and negative guards. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] | Keep it separate unless sharing tiny helpers is clearly lower risk. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` | `packages/parity-fixtures` | Failure-mode shell tests for missing fixture, wrong checksum, wrong provenance, missing expected artifact columns/rows, missing non-overclaiming text, and premature Phase 43/44 artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Use Arrange/Act/Assert comments as the existing shell tests do. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md] |
| `packages/parity-fixtures/BUILD.bazel` | `packages/parity-fixtures` | Add project-file `exports_files`, aliases, bundle `filegroup`, `sh_binary`, and `sh_test`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Do not add `//packages/parity:prusaslicer_project_file_parity`; that target belongs to Phase 44. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; bazel query result] |
| `packages/parity-fixtures/README.md` and `docs/port/*.md` | Fixture package docs and port docs | Add discoverability for the fixture namespace and verifier while preserving deferrals. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; docs/port/README.md; docs/port/package-map.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md] | Do not edit `packages/parity/status.tsv` in Phase 42. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity/status.tsv] |

## Upstream Fixture Evidence

| Evidence | Value | Source |
|----------|-------|--------|
| Upstream URL | `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/data/seam_test_object.3mf` | [VERIFIED: packages/fork-vendors/forks.tsv; packages/prusa-project-file-scope/project-file-scope.md; local curl download] |
| Source ref | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv; packages/prusa-project-file-scope/project-file-scope.md] |
| Byte count | `2514963` | \[VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local `wc -c /tmp/slic3r-phase42-seam_test_object.3mf`\] |
| SHA-256 | `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2` | \[VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local `shasum -a 256 /tmp/slic3r-phase42-seam_test_object.3mf`\] |
| Archive members | `[Content_Types].xml`, `Metadata/thumbnail.png`, `_rels/.rels`, `3D/3dmodel.model`, `Metadata/Slic3r_PE.config`, `Metadata/Slic3r_PE_model.config` | \[VERIFIED: local `zipinfo -1 /tmp/slic3r-phase42-seam_test_object.3mf`\] |
| Member sizes | six entries; uncompressed total `18174542`, compressed total `2514121`, ZIP file size `2514963` | \[VERIFIED: local `zipinfo -l /tmp/slic3r-phase42-seam_test_object.3mf`\] |
| OPC content type markers | `rels`, `model`, and `png` defaults are present. | \[VERIFIED: local `unzip -p ... '\[Content_Types\].xml'`\] |
| Relationship markers | `/3D/3dmodel.model` start-part relationship and `/Metadata/thumbnail.png` thumbnail relationship are present. | \[VERIFIED: local `unzip -p ... '_rels/.rels'`\] |
| Model markers | `slic3rpe:Version3mf` is `1`, `Application` is `PrusaSlicer-2.8.0-alpha3`, and one build item is present. | \[VERIFIED: local `unzip -p ... '3D/3dmodel.model' | grep ...`\] |
| Metadata config markers | `Metadata/Slic3r_PE.config` starts with `generated by PrusaSlicer 2.8.0-alpha3`; config semantics remain out of scope. | \[VERIFIED: local `unzip -p ... 'Metadata/Slic3r_PE.config' | grep ...`; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\] |
| Model config markers | `Metadata/Slic3r_PE_model.config` contains object/volume metadata for `3DBenchy.stl`; geometry and mesh semantics remain out of scope. | \[VERIFIED: local `unzip -p ... 'Metadata/Slic3r_PE_model.config' | grep ...`; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\] |
| Thumbnail marker | `Metadata/thumbnail.png` is a PNG member. | \[VERIFIED: local `unzip -p ... 'Metadata/thumbnail.png' | file -`\] |

## Expected Artifact Row Guidance

Use the same `source_ref` and `fixture_path` on every expected-project-summary row: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` and `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/prusa-project-file-scope/project-file-scope.md]

| archive_member | project_marker | deferred_semantics | notes |
|----------------|----------------|--------------------|-------|
| `[Content_Types].xml` | OPC content types for relationships, 3D model, and PNG members are present. [VERIFIED: local archive inspection] | no-full-3mf-import-export; no-runtime-claim [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Presence-level OPC package-shape evidence only. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `_rels/.rels` | Start-part relationship targets `/3D/3dmodel.model`; thumbnail relationship targets `/Metadata/thumbnail.png`. [VERIFIED: local archive inspection] | no-gui-project-behavior; no-runtime-claim [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Relationship presence only, not load/save behavior. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `3D/3dmodel.model` | `slic3rpe:Version3mf=1`; `Application=PrusaSlicer-2.8.0-alpha3`. [VERIFIED: local archive inspection] | no-geometry-counts; no-generated-output-parity [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Do not include vertex, triangle, item, transform, or mesh counts in Phase 42 expected output. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `Metadata/thumbnail.png` | Thumbnail PNG member is present. [VERIFIED: local archive inspection] | no-gui-project-behavior; no-visual-claim [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Thumbnail presence does not prove GUI project behavior. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `Metadata/Slic3r_PE.config` | Prusa/Slic3r metadata config file is present and generated by PrusaSlicer 2.8.0-alpha3. [VERIFIED: local archive inspection] | no-config-key-counts; no-printer-profile-semantics [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Avoid using `seam_position`, printer model, or profile IDs as Phase 42 semantic proof. [VERIFIED: local archive inspection; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| `Metadata/Slic3r_PE_model.config` | Prusa/Slic3r model metadata config file is present. [VERIFIED: local archive inspection] | no-geometry-semantics; no-runtime-claim [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] | Object/source-file text may be noted as metadata presence, not as geometry parsing. [VERIFIED: local archive inspection; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity-fixtures/
├── forks/prusaslicer/prusaslicer.project-file/        # Phase 42 fixture namespace [VERIFIED: 42-CONTEXT.md]
│   ├── .gitattributes                                # binary fixture protection [VERIFIED: 42-CONTEXT.md]
│   ├── README.md                                     # provenance, update route, boundary [VERIFIED: profile-schema README pattern]
│   ├── seam_test_object.3mf                          # checked-in upstream fixture [VERIFIED: 42-CONTEXT.md]
│   ├── fixture-provenance.tsv                        # pinned source/size/hash manifest [VERIFIED: 42-CONTEXT.md]
│   └── expected-project-summary.tsv                  # shallow archive/member expected artifact [VERIFIED: 42-CONTEXT.md]
├── verify_prusa_project_file_fixture.sh              # fail-closed local verifier [VERIFIED: 42-CONTEXT.md]
└── verify_prusa_project_file_fixture_test.sh         # failure-mode shell tests [VERIFIED: 42-CONTEXT.md]
```

### Pattern 1: Mirror the Profile-Schema Fixture Bundle

**What:** Add project-file exports, aliases, a bundle filegroup, verifier binary, and verifier shell test in `packages/parity-fixtures/BUILD.bazel`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**When to use:** Use this for all Phase 42 fixture files because `packages/parity-fixtures` already owns shared and fork fixture corpora. [VERIFIED: packages/parity-fixtures/README.md; docs/port/package-map.md]

**Example Pattern Source:**

```python
# Source: packages/parity-fixtures/BUILD.bazel
filegroup(
    name = "prusa_profile_schema_bundle",
    srcs = [
        "forks/prusaslicer/prusaslicer.profile-schema/.gitattributes",
        "forks/prusaslicer/prusaslicer.profile-schema/README.md",
        "forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv",
        "forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx",
    ],
)
```

### Pattern 2: Exact Checks, Not Parser Frameworks

**What:** Use small Bash helpers like `require_file`, `require_text`, `require_size`, `require_sha256`, and `awk` row checks to fail closed on missing or inconsistent artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/prusa-project-file-scope/verify_prusa_project_file_scope.sh]

**When to use:** Use this for Phase 42 because the phase verifies a fixed fixture surface and expected-artifact contract rather than parsing 3MF semantics. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**Example Pattern Source:**

```bash
# Source: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
require_size "${ini_file}" "PrusaResearch.ini" "1543688"
require_sha256 "${ini_file}" "PrusaResearch.ini" \
	"a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839"
```

### Pattern 3: Negative Guards Must Be Scoped

**What:** Confirm `packages/parity/status.tsv` does not publish `fork.prusaslicer.project-file`, confirm `//packages/parity:prusaslicer_project_file_parity` is undeclared, and confirm no `prusa_project_file` parser surface exists in `slic3r_flavors`. \[VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local `rg`; local `bazel query`\]

**When to use:** Use this after fixture implementation because Phase 42 is allowed to create fixture files but must not create Phase 43 parser code or Phase 44 parity/status artifacts. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**Important scoping detail:** The existing flavor registry already contains source-observed `prusaslicer.project-file` metadata, so negative checks must not ban every occurrence of that inventory ID. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

### Anti-Patterns to Avoid

- **Broad 3MF parser in Phase 42:** Phase 42 should not parse geometry, config semantics, printer profiles, generated output, or import/export behavior. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]
- **Verifier network access:** The verifier must not call `curl`, `git`, fetch upstream source, import source trees, or access network services. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]
- **Premature parity/status publication:** Do not add `//packages/parity:prusaslicer_project_file_parity` or `fork.prusaslicer.project-file` in Phase 42. \[VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity/status.tsv; local `bazel query`\]
- **Overbroad token absence checks:** Do not fail on existing `prusaslicer.project-file` registry metadata because that metadata predates Phase 42 and is not a parser surface. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; .planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| ZIP/OPC member discovery | A custom archive parser in Bash, Rust, or ad hoc string reads | `zipinfo -1`, `zipinfo -l`, and `unzip -p` exact member extraction | These tools are available locally and keep Phase 42 at package-shape evidence. [VERIFIED: local tool checks; local archive inspection; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| TSV validation | A new reusable parser framework | `awk -F '\t'` row/header checks like the existing verifier | Existing fixture verification already uses targeted `awk` row validation. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| Fixture source refresh | A verifier-time network fetcher or Git checkout | Checked-in fixture bytes plus reviewed intake update route | Phase 42 verification must remain local and hermetic. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Project-file semantics | Geometry/config/profile/runtime interpretation | Presence-level expected rows only | Phase 43 owns typed Rust summaries and Phase 44 owns executable parity. [VERIFIED: .planning/ROADMAP.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Status publication | Manual status row in Phase 42 | Absence guard until Phase 44 | `verified` fork status requires a real parity command. [VERIFIED: docs/port/parity-matrix.md; docs/port/migration-guidance.md; packages/parity/status.tsv] |

**Key insight:** The hard part is not extracting more meaning from the 3MF; it is preserving a narrow, source-pinned, local, fail-closed fixture contract so later Rust and parity phases cannot overclaim. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; .planning/ROADMAP.md; .planning/REQUIREMENTS.md]

## Common Pitfalls

### Pitfall 1: Turning Presence Evidence Into Semantic Claims

**What goes wrong:** Expected rows start counting mesh vertices, config keys, printer profiles, seam behavior, or generated-output data. [VERIFIED: local archive inspection shows those values exist; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md excludes those claims]

**Why it happens:** The upstream fixture contains large model XML and Prusa config content, so it is easy to treat available data as Phase 42 evidence. \[VERIFIED: local `unzip -p` evidence; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\]

**How to avoid:** Keep `expected-project-summary.tsv` to archive members and presence-level markers only. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**Warning signs:** Expected rows mention vertex counts, triangle counts, config key counts, `seam_position` behavior, printer/profile compatibility, generated output, load/save success, or runtime support. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

### Pitfall 2: Verifier Fetches Upstream Content

**What goes wrong:** `bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture` depends on network availability or upstream GitHub state. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**Why it happens:** The fixture comes from a raw upstream URL, but provenance belongs in the manifest and reviewed update route, not the verifier. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**How to avoid:** Check in the fixture bytes and verify size/SHA locally. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh]

**Warning signs:** New verifier or test source contains `curl`, `git clone`, `git fetch`, upstream API URLs as executable commands, or dynamic checkout paths. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

### Pitfall 3: Negative Guard False Positives

**What goes wrong:** A guard bans all `prusaslicer.project-file` occurrences and fails on existing registry metadata. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs]

**Why it happens:** Phase 35 already modeled `prusaslicer.project-file` as source-observed capability metadata. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; docs/port/package-map.md]

**How to avoid:** Guard against parser module/function surfaces such as `prusa_project_file` in Rust source, the Phase 44 parity target, and the status row, while allowing existing `capability_id: "prusaslicer.project-file"`. \[VERIFIED: local `rg`; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\]

**Warning signs:** Negative checks use only `rg "prusaslicer.project-file"` across `packages/` without path or symbol scoping. \[VERIFIED: local `rg` output\]

### Pitfall 4: Binary Fixture Corruption

**What goes wrong:** Git line-ending normalization changes the checked-in 3MF bytes and SHA verification fails. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes]

**Why it happens:** The existing profile-schema bundle explicitly marks raw vendor files `-text`, and Phase 42 requires binary line-ending handling for the 3MF. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**How to avoid:** Add `.gitattributes` in the project-file namespace before committing the fixture and verify SHA after checkout. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

**Warning signs:** `.gitattributes` is missing or does not mention `seam_test_object.3mf -text`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

### Pitfall 5: Status Row Appears Before Evidence

**What goes wrong:** `packages/parity/status.tsv` gets `fork.prusaslicer.project-file` during Phase 42. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity/status.tsv]

**Why it happens:** The fixture surface can look like parity evidence, but Phase 44 owns the public parity command and status publication. [VERIFIED: .planning/ROADMAP.md; docs/port/parity-matrix.md]

**How to avoid:** Include a negative check that the status row is absent and document executable parity as unavailable until Phase 44. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; docs/port/migration-guidance.md]

**Warning signs:** `packages/parity/status.tsv` or `packages/parity/BUILD.bazel` changes in a Phase 42 plan. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

## Code Examples

Verified patterns from local sources:

### Bazel Fixture Verifier Wiring

```python
# Source: packages/parity-fixtures/BUILD.bazel
sh_binary(
    name = "verify_prusa_profile_schema_fixture",
    srcs = ["verify_prusa_profile_schema_fixture.sh"],
    data = [
        ":prusa_profile_schema_bundle",
        "//packages/parity-fixtures:prusa_profile_schema_expected_summary",
        "README.md",
        "forks/prusaslicer/prusaslicer.profile-schema/README.md",
        "forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
        "forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx",
        "//packages/parity:status.tsv",
    ],
)
```

Phase 42 should adapt this pattern in `packages/parity-fixtures/BUILD.bazel` for the project-file bundle and verifier, while excluding Phase 44 parity/status publication. [VERIFIED: packages/parity-fixtures/BUILD.bazel; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

### Bash Exact Size and Hash Checks

```bash
# Source: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
require_size() {
	local file="$1"
	local label="$2"
	local expected_size="$3"
	local actual_size
	actual_size="$(wc -c <"${file}" | tr -d ' ')"
	if [[ "${actual_size}" != "${expected_size}" ]]; then
		error "${label}: expected ${expected_size} bytes, got ${actual_size}"
	fi
}
```

Phase 42 should reuse this style for `seam_test_object.3mf` with byte count `2514963` and SHA-256 `9fa91ee2f54a33dc65fd681bb24dce666c77a501196815548a051d54e857bdc2`. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; local hash verification]

### Failure-Mode Test Shape

```bash
# Source: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh
test_wrong_ini_checksum_fails() {
	# Arrange
	local dir="${tmp_dir}/wrong-ini-checksum"
	write_valid_fixture_copy "${dir}"
	perl -0pi -e 's/Prusa/Prusb/' "${dir}/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"

	# Act
	if PRUSA_FIXTURE_FORKS_ROOT="${dir}/forks" run_verifier "${dir}" "${tmp_dir}/wrong-ini-checksum.out" "${tmp_dir}/wrong-ini-checksum.err"; then
		fail "wrong PrusaResearch.ini checksum fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-ini-checksum.err" "a6155d92471d3b0ae11bed051bb04a4c1157fd6b05fef22416eafd12bce9c839"
}
```

Phase 42 should create analogous tests for wrong 3MF checksum, missing expected-project-summary header, missing archive-member rows, missing scope-record path, and premature Phase 43/44 artifacts. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

## Verification Commands for the Plan

The eventual Phase 42 plan should include these verification commands after implementation. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; .planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md]

```bash
bazel run //packages/prusa-project-file-scope:verify
bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture
bash packages/parity-fixtures/verify_prusa_project_file_fixture.sh
bash packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture
bazel test //packages/parity-fixtures:verify_prusa_project_file_fixture_test
shfmt -d packages/parity-fixtures/verify_prusa_project_file_fixture.sh packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
mdformat --check packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md
bazel query //packages/parity:prusaslicer_project_file_parity
rg -n "fork\\.prusaslicer\\.project-file|prusaslicer_project_file_parity" packages/parity/status.tsv
rg -n "prusa_project_file" packages/slic3r-rust/crates/slic3r_flavors/src packages/slic3r-rust/crates/slic3r_flavors/tests
git diff --check
```

The `bazel query //packages/parity:prusaslicer_project_file_parity` command should fail in Phase 42 because the parity target belongs to Phase 44. \[VERIFIED: local `bazel query` failed with target not declared; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\] The `rg` status-row command should return no matches in `packages/parity/status.tsv`. \[VERIFIED: local `rg`; packages/parity/status.tsv\] The Rust `rg` must be interpreted carefully because `prusaslicer.project-file` registry metadata is allowed, while a `prusa_project_file` parser/module/function surface is not allowed in Phase 42. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source-observed inventory rows alone | Reviewed scope gate before fixture creation | Phase 41 | Project-file work now starts from `packages/prusa-project-file-scope` before bytes, parser, parity, or status. [VERIFIED: .planning/phases/41-prusa-project-file-scope-gate/41-01-SUMMARY.md; packages/prusa-project-file-scope/project-file-scope.md] |
| Static fixture inputs without expected artifact | Checked-in fixture plus expected summary artifact | Phase 40 for profile-schema, Phase 42 planned for project-file | Phase 42 should include both the binary fixture and expected presence-level artifact before Rust parsing. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv; .planning/ROADMAP.md] |
| Broad fork parity implication from source pins | Narrow verified status only after executable parity command passes | Phase 40 precedent and Phase 44 plan | Phase 42 must keep status unavailable until Phase 44. [VERIFIED: docs/port/parity-matrix.md; packages/parity/status.tsv; .planning/ROADMAP.md] |
| Ad hoc fixture files | Source-pinned namespace with provenance, README, update route, and local verifier | Phase 38 profile-schema precedent | Project-file fixture surface should mirror `prusaslicer.profile-schema`. [VERIFIED: packages/parity-fixtures/README.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md] |

**Deprecated/outdated:**

- Treating `prusaslicer.project-file` as full 3MF import/export is outdated for v1.11 because the active roadmap requires a narrow fixture-backed evidence slice first. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]
- Treating branch-head observations as fixture refresh authority is outdated because the locked update route requires reviewed intake changes and Phase 41 scope gate updates. [VERIFIED: packages/fork-vendors/forks.tsv; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

All claims in this research were verified or cited; no `[ASSUMED]` claims are present. [VERIFIED: source tagging review of this file]

## Open Questions (RESOLVED)

1. **RESOLVED: None blocking.** The exact prose for
   `expected-project-summary.tsv` rows is delegated to the agent's discretion,
   but the allowed columns, required archive members, and nonsemantic boundary
   are locked. [VERIFIED:
   .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Bazel verifier and tests | yes | 8.6.0 | Use `bazelisk`; it also reports Bazel 8.6.0 locally. \[VERIFIED: local `bazel --version`; local `bazelisk --version`\] |
| Bash | Verifier scripts | yes | 3.2.57 | None needed. \[VERIFIED: local `bash --version`\] |
| `shasum` | Fixture SHA-256 verification | yes | 6.02 | None needed on macOS. \[VERIFIED: local `shasum --version`\] |
| `awk`, `grep`, `wc`, `find` | Exact text, row, byte, and namespace checks | yes | system `/usr/bin` tools | None needed. \[VERIFIED: local `command -v awk grep wc find`\] |
| `unzip` / `zipinfo` | 3MF member and marker checks | yes | UnZip 6.00 / ZipInfo 3.00 | `unzip -Z -1` can provide filenames if `zipinfo` is unavailable. \[VERIFIED: local `unzip -v`; local `zipinfo -h`\] |
| `shfmt` | Shell formatting verification | yes | 3.12.0 | If absent, document omission; no install should be required by Phase 42. \[VERIFIED: local `shfmt --version`; CITED: Bright Builds verification standard\] |
| `mdformat` | Non-summary Markdown check | yes | 1.0.0 | If absent, use `git diff --check`; do not run `mdformat` on `*-SUMMARY.md`. \[VERIFIED: local `mdformat --version`; AGENTS.md\] |
| `curl` | One-time intake or research download only | yes | `/usr/bin/curl` | Manual reviewed fixture acquisition; verifier must not use network. \[VERIFIED: local `command -v curl`; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md\] |
| `file` | Optional thumbnail marker evidence | yes | `/usr/bin/file` | Skip thumbnail type check and rely on archive member/content type presence. \[VERIFIED: local `command -v file`; local archive inspection\] |

**Missing dependencies with no fallback:** None found for planning Phase 42. [VERIFIED: local environment audit]

**Missing dependencies with fallback:** None found for planning Phase 42. [VERIFIED: local environment audit]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | Phase 42 has no auth surface. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| V3 Session Management | no | Phase 42 has no session surface. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| V4 Access Control | no | Phase 42 has no user authorization surface. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| V5 Input Validation | yes | Validate checked-in fixture files, TSV headers/rows, archive members, expected artifact rows, docs text, and negative artifact absence with exact local checks. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| V6 Cryptography | limited | Use platform `shasum -a 256` for integrity checking; do not hand-roll hashing or treat SHA-256 as legal/security attestation. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md] |

### Known Threat Patterns for Phase 42

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Fixture byte tampering | Tampering | Verify exact byte count and SHA-256 for `seam_test_object.3mf`. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| Provenance drift | Tampering / Repudiation | Verify the full provenance row against source ref, tag, peeled commit, upstream URL, size, hash, update route, and exclusions. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Overclaiming project-file support | Spoofing / Repudiation | Require non-overclaiming README/docs text and absence of Phase 44 status row. [VERIFIED: docs/port/parity-matrix.md; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Network-dependent verification | Information Disclosure / Tampering | Ban verifier-time `curl`, Git fetch/clone, upstream source imports, network services, and plugin ingestion. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |
| Path or member confusion in ZIP checks | Tampering | Use explicit archive member names and presence-level marker checks; do not extract arbitrary paths into the repo. [VERIFIED: local archive inspection; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `AGENTS.md` - repo-local Bright Builds routing and summary-file guidance. [VERIFIED: file read]
- `AGENTS.bright-builds.md` - pinned Bright Builds commit and high-signal standards. [VERIFIED: file read]
- `standards-overrides.md` - no active local override beyond placeholder row. [VERIFIED: file read]
- `.planning/PROJECT.md`, `.planning/STATE.md`, `.planning/ROADMAP.md`, `.planning/REQUIREMENTS.md` - v1.11 scope, Phase 42 definition, PFIX requirements, and exclusions. [VERIFIED: file read]
- `.planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md` - locked Phase 42 YOLO decisions. [VERIFIED: file read]
- `packages/prusa-project-file-scope/project-file-scope.md`, `README.md`, verifier scripts, and Phase 41 summary/verification - accepted source identity and handoff boundary. [VERIFIED: file read]
- `packages/parity-fixtures/README.md`, `BUILD.bazel`, `prusaslicer.profile-schema` fixture files, and profile-schema verifier/test - local fixture precedent. [VERIFIED: file read]
- `docs/port/README.md`, `package-map.md`, `migration-guidance.md`, and `parity-matrix.md` - docs and status boundaries. [VERIFIED: file read]
- Local upstream fixture inspection via `curl`, `wc -c`, `shasum -a 256`, `zipinfo`, `unzip -p`, and `file` against `/tmp/slic3r-phase42-seam_test_object.3mf`. [VERIFIED: local commands on 2026-06-03]

### Secondary (MEDIUM confidence)

- Bright Builds pinned standards pages for architecture, code shape, verification, testing, and Rust guidance. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Raw upstream fixture URL at pinned PrusaSlicer commit. [CITED: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/data/seam_test_object.3mf]

### Tertiary (LOW confidence)

- None. [VERIFIED: research source review]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - all tools are local and match existing repo fixture patterns. [VERIFIED: local tool checks; packages/parity-fixtures/BUILD.bazel]
- Architecture: HIGH - Phase 42 decisions lock namespace, artifact names, verifier style, docs boundaries, and exclusions. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]
- Pitfalls: HIGH - pitfalls derive from explicit Phase 42 exclusions, Phase 41 verification, existing profile-schema precedent, and observed fixture archive contents. [VERIFIED: .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md; .planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md; local archive inspection]

**Research date:** 2026-06-03
**Valid until:** 2026-07-03 for local fixture/verifier planning; re-check upstream source only if the accepted Prusa source identity changes. [VERIFIED: packages/fork-vendors/forks.tsv; .planning/phases/42-prusa-project-file-fixture-surface/42-CONTEXT.md]
