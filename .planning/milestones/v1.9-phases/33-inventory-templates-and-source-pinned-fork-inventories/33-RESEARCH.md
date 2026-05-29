# Phase 33: Inventory Templates and Source-Pinned Fork Inventories - Research

**Researched:** 2026-05-26 [VERIFIED: environment current_date]
**Domain:** docs/data/shell-verifier implementation for fork feature inventories [VERIFIED: .planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md]
**Confidence:** HIGH for repo patterns and verifier architecture; MEDIUM for initial row ownership classifications that infer lineage from source-path overlap [VERIFIED: codebase grep; CITED: GitHub API tree endpoints]

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for all content in this block: `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md`. [VERIFIED: .planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md]

### Locked Decisions

### Inventory Package and Data Shape

- **D-01:** Add a dedicated `packages/fork-inventories` package for feature
  inventory templates, per-fork inventories, the cross-fork category map, and
  inventory verification. Keep it separate from `packages/fork-vendors`, which
  owns source refs, license/provenance metadata, and release-pin verification.
- **D-02:** Use checked-in TSV files rather than Markdown tables or a new parser
  dependency. This matches the repo's existing `packages/parity/status.tsv` and
  `packages/fork-vendors/forks.tsv` pattern and keeps verification shell-owned.
- **D-03:** Include one schema/template TSV that documents the required
  inventory columns and one TSV per fork, plus a cross-fork category map TSV.
  The template is the contract maintainers copy for future rows.

### Required Inventory Fields

- **D-04:** Every inventory row should require an inventory ID, vendor ID,
  feature surface, ownership classification, source reference, source paths,
  complexity, existing parity-surface dependency, v1.9 decision, and future
  parity notes.
- **D-05:** Source references must be pinned to Phase 32 selected stable tags or
  peeled commits. Do not use drift-only default branch heads as accepted source
  evidence.
- **D-06:** Use explicit enum-like vocabularies for classification and decision
  fields so Phase 34 can later parse them into Rust domain types without
  guessing prose meanings.

### Classification Taxonomy

- **D-07:** Classify ownership as `base-slic3r`, `shared-downstream`,
  `fork-specific`, or `unknown-needs-review`.
- **D-08:** Separate v1.9 decisions into future implementation candidates,
  deferred rows, no-action/base rows, and needs-review rows. Deferred rows must
  stay visible instead of being mixed with implementation candidates.
- **D-09:** Keep network, cloud, plugin, credential, and non-free surfaces as
  inventory cautions only. These rows must not create online integration,
  credential ingestion, or runtime fork support scope.

### Inventory Coverage

- **D-10:** The initial PrusaSlicer inventory should separate base Slic3r
  behavior, shared downstream behavior, and Prusa-specific behavior from the
  pinned PrusaSlicer source baseline.
- **D-11:** The initial Bambu Studio inventory must cover inherited
  Prusa-family behavior, shared downstream behavior, and Bambu-specific project,
  profile, network, support, STEP, arc, and assembly surfaces.
- **D-12:** The initial OrcaSlicer inventory must cover inherited
  Prusa/Bambu-family behavior, shared downstream behavior, and Orca-specific
  calibration, wall/seam, support, adaptive mesh, profile library, and
  community-profile surfaces.
- **D-13:** The cross-fork category map should group related rows across forks
  by category and explicitly distinguish base, shared downstream, fork-specific,
  and unknown-needs-review rows.

### Verification and Documentation

- **D-14:** Add a Bazel-owned verification target that checks TSV shape,
  required fields, enum values, vendor IDs against `packages/fork-vendors`,
  pinned source-reference form, required surface coverage, and cross-map
  references. Verification should not fetch, clone, or inspect upstream remotes.
- **D-15:** Document that inventories are source-observed planning inputs only.
  They do not prove executable parity, user-facing behavior, GUI support, fork
  release builds, or support for non-free/network plugins.
- **D-16:** Link the new package and maintainer command from `docs/port/README.md`
  and `docs/port/package-map.md` so reviewers can find the inventory boundary.

### the agent's Discretion

- The planner may choose exact column names if every INV requirement remains
  directly represented and easy to validate from shell.
- The planner may decide whether the cross-fork map stores row IDs directly or
  category-to-row references, provided stale or unknown row references fail
  verification.
- The planner may add package-local README sections, fixture TSV snippets, or
  verifier tests needed to make the inventory contract maintainable.

### Deferred Ideas (OUT OF SCOPE)

- Full executable fork parity remains a future milestone after v1.9 establishes
  inventory and flavor boundaries.
- Runtime flavor contracts and Rust domain types remain Phase 34 and Phase 35
  scope.
- Full drift-refresh protocol templates remain Phase 36 scope.
- GUI migration, fork-flavor release builds, online/cloud integrations,
  credential handling, and non-free plugin ingestion remain future work.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| INV-01 | Maintainer can use a checked-in fork feature inventory template requiring source reference, ownership classification, feature surface, complexity, parity dependency, v1.9 decision, and future parity notes. [VERIFIED: .planning/REQUIREMENTS.md] | Use `inventory-template.tsv` plus a verifier-enforced 12-column schema. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/verify_forks.sh] |
| INV-02 | Maintainer can inspect a PrusaSlicer inventory separating base, shared downstream, and Prusa-specific behavior from the pinned PrusaSlicer baseline. [VERIFIED: .planning/REQUIREMENTS.md] | Seed `prusaslicer.tsv` with rows anchored to `version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`. [VERIFIED: packages/fork-vendors/forks.tsv] |
| INV-03 | Maintainer can inspect a Bambu Studio inventory separating inherited and Bambu-specific project, profile, network, support, STEP, arc, and assembly surfaces. [VERIFIED: .planning/REQUIREMENTS.md] | Seed `bambustudio.tsv` with rows anchored to `v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6` and source paths verified in the pinned tree. [VERIFIED: packages/fork-vendors/forks.tsv; CITED: https://api.github.com/repos/bambulab/BambuStudio/git/trees/b506005bc4ee62124e24bf00e0f58656db3646a6?recursive=1] |
| INV-04 | Maintainer can inspect an OrcaSlicer inventory separating inherited and Orca-specific calibration, wall/seam, support, adaptive mesh, profile library, and community-profile surfaces. [VERIFIED: .planning/REQUIREMENTS.md] | Seed `orcaslicer.tsv` with rows anchored to `v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912` and source paths verified in the pinned tree. [VERIFIED: packages/fork-vendors/forks.tsv; CITED: https://api.github.com/repos/OrcaSlicer/OrcaSlicer/git/trees/c724a3f5f51c52336624b689e846c8fbc943a912?recursive=1] |
| INV-05 | Maintainer can inspect a cross-fork category map separating base, shared downstream, fork-specific, unknown-needs-review, deferred, and future-candidate rows. [VERIFIED: .planning/REQUIREMENTS.md] | Use `category-map.tsv` with row-ID references and fail verification on unknown or stale inventory IDs. [VERIFIED: 33-CONTEXT.md] |
</phase_requirements>

## Summary

Phase 33 should be planned as one bounded docs/data package: create `packages/fork-inventories`, add a TSV template, one TSV inventory per fork, a cross-fork category map TSV, a Bash verifier, a Bazel `verify` target, a verifier test target, and port-doc links. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/BUILD.bazel; packages/parity/BUILD.bazel; docs/port/README.md]

The implementation must preserve the Phase 32 boundary: source refs and inventories are intake evidence only, while runtime fork parity, online integrations, credential handling, non-free plugin ingestion, fork release builds, and Rust flavor contracts stay deferred. [VERIFIED: packages/fork-vendors/README.md; .planning/REQUIREMENTS.md; 33-CONTEXT.md]

**Primary recommendation:** Use fixed-column TSVs validated by a Bash 3.2-compatible verifier that cross-checks vendor pins from `packages/fork-vendors/forks.tsv`, parity dependency names from `packages/parity/status.tsv`, required surface coverage, and cross-map row references without fetching or inspecting upstream remotes. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/verify_forks.sh; packages/parity/status.tsv; command: bash --version]

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo-local instruction entrypoint, and Bright Builds managed text must not be edited in downstream repo changes. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Planning or implementation work must account for `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant Bright Builds standards pages. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md]
- Phase `*-SUMMARY.md` files must keep `requirements-completed` metadata synchronized, must use the hyphenated key, and must not be formatted with `mdformat`; Phase 33 research does not edit summary files. [VERIFIED: AGENTS.md]
- `standards-overrides.md` contains only placeholder override rows, so no local exception changes the default Bright Builds guidance for this phase. [VERIFIED: standards-overrides.md]
- Bright Builds architecture guidance recommends functional core / imperative shell separation, so the planner should keep pure TSV validation logic separable from thin file I/O in the verifier where practical. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md]
- Bright Builds code-shape guidance recommends early returns and guard clauses, so verifier failures should use small validation helpers and exit immediately on invalid rows. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md]
- Bright Builds verification guidance recommends fetching remote state before repo-changing work; `git fetch --all --prune` was run and the branch remained `master...origin/master [ahead 2]`. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md; VERIFIED: command output]
- Bright Builds testing guidance requires pure/business logic tests; verifier behavior should have a package-local `sh_test` that covers valid rows and failure modes. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md; VERIFIED: packages/fork-vendors/verify_forks_test.sh]
- No project-local `.claude/skills` or `.agents/skills` skill files were found, so there are no additional repo-local skill conventions for this phase. [VERIFIED: command: find .claude/skills .agents/skills -maxdepth 2 -type f -name SKILL.md]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|---|---:|---|---|
| Checked-in TSV files | N/A | Inventory template, per-fork inventories, and cross-fork map. | Locked by Phase 33 decisions and consistent with `packages/parity/status.tsv` and `packages/fork-vendors/forks.tsv`. [VERIFIED: 33-CONTEXT.md; packages/parity/status.tsv; packages/fork-vendors/forks.tsv] |
| Bash verifier | GNU bash 3.2.57 on this machine | Deterministic TSV shape, enum, source pin, coverage, and reference validation. | Existing fork vendor verifier is Bash with `set -euo pipefail`, and macOS `/bin/bash` is 3.2, so avoid Bash 4 associative arrays. [VERIFIED: packages/fork-vendors/verify_forks.sh; command: bash --version] |
| Bazel `sh_binary` / `sh_test` | Bazel 8.6.0 on this machine | Maintainer command and package-local test target. | Existing package commands expose shell tools through Bazel targets. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/parity/BUILD.bazel; command: bazel --version] |
| `packages/fork-vendors/forks.tsv` | 21 fixed columns | Canonical Phase 32 vendor IDs, selected stable tags, peeled commits, lineage, source paths, and cautions. | Phase 33 source references must be pinned to Phase 32 selected tags or peeled commits. [VERIFIED: packages/fork-vendors/forks.tsv; 33-CONTEXT.md] |
| `packages/parity/status.tsv` | 4 fixed columns | Source of valid existing parity-surface dependency tokens. | INV-01 requires dependency on existing parity surfaces, and this repo already uses `status.tsv` as the checked-in parity source. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv; packages/parity/README.md] |

### Supporting

| Tool | Version | Purpose | When to Use |
|---|---:|---|---|
| `awk` | awk 20200816 | Cross-file set validation and TSV field counting without adding a parser dependency. | Use for inventory ID uniqueness, row-ID reference validation, and parity dependency membership because Bash 3.2 lacks associative arrays. [VERIFIED: command: awk --version; command: bash --version] |
| `rg` | ripgrep 15.1.0 | Planning/verification spot checks for docs links and required wording. | Use for final verification that package docs and port docs mention the new command and intake-only scope. [VERIFIED: command: rg --version] |
| GitHub API tree endpoints | N/A | Research-only verification of source-path anchors at pinned commits. | Use only during research/planning to identify initial row anchors; Phase 33 implementation verifier must not fetch, clone, or inspect upstream remotes. [CITED: https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1; VERIFIED: 33-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|---|---|---|
| TSV | Markdown tables | Rejected because Phase 33 locks checked-in TSVs and the repo already validates TSV-like data through shell-owned commands. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/verify_forks.sh] |
| TSV + shell | JSON/TOML/YAML parser dependency | Rejected because Phase 33 locks no new parser dependency and a simple TSV schema is enough for three initial fork inventories. [VERIFIED: 33-CONTEXT.md] |
| Source-path inventory | Cloned/vendor upstream source trees | Rejected because v1.9 explicitly excludes vendored source trees, upstream source imports, and building upstream C++ forks. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-vendors/README.md] |
| Inventory rows | Runtime fork parity implementation | Rejected because source inventories do not prove executable parity or user-facing behavior. [VERIFIED: 33-CONTEXT.md; docs/port/migration-guidance.md] |

**Installation:**

```bash
# No npm, Rust, or external parser packages should be installed for Phase 33.
# Use existing Bash, awk, Bazel, and checked-in TSV files.
```

**Version verification:** `npm view` is not applicable because no npm packages are recommended; local tool versions were verified with `bash --version`, `bazel --version`, `awk --version`, `rg --version`, and `git --version`. [VERIFIED: command outputs]

## Architecture Patterns

### Recommended Project Structure

```text
packages/fork-inventories/
|-- BUILD.bazel                # Bazel package boundary, verify command, verifier test
|-- README.md                  # Maintainer command, schema, scope cautions
|-- inventory-template.tsv     # Commented header/template contract
|-- prusaslicer.tsv            # PrusaSlicer source-pinned inventory rows
|-- bambustudio.tsv            # Bambu Studio source-pinned inventory rows
|-- orcaslicer.tsv             # OrcaSlicer source-pinned inventory rows
|-- category-map.tsv           # Cross-fork category-to-row map
|-- verify_inventories.sh      # Bash verifier, no upstream network access
`-- verify_inventories_test.sh # Mock/fixture tests for verifier failures
```

This layout follows the Phase 33 package decision and the existing `packages/fork-vendors` shape. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/BUILD.bazel]

### Pattern 1: Inventory TSV Schema

**What:** Use one fixed 12-column schema for every inventory TSV data row. [VERIFIED: 33-CONTEXT.md]

**Recommended columns:**

```text
# inventory_id	vendor_id	source_ref	source_paths	feature_surface	feature_category	ownership	complexity	parity_dependency	v1_9_decision	caution_flags	future_parity_notes
```

**Validation rules:** `inventory_id` must be globally unique and vendor-prefixed; `vendor_id` must exist in `forks.tsv`; `source_ref` must equal `<vendor_id>:<selected_stable_tag>@<peeled_commit_sha>` from `forks.tsv`; `source_paths` must be non-empty semicolon-delimited paths; `ownership`, `complexity`, and `v1_9_decision` must be enums; `parity_dependency` must be `none` or semicolon-delimited surfaces from `packages/parity/status.tsv`; `future_parity_notes` must be non-empty. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/forks.tsv; packages/parity/status.tsv]

**Enums:** [VERIFIED: 33-CONTEXT.md]

| Field | Values |
|---|---|
| `ownership` | `base-slic3r`, `shared-downstream`, `fork-specific`, `unknown-needs-review` |
| `complexity` | `none`, `low`, `medium`, `high`, `unknown-needs-review` |
| `v1_9_decision` | `future-candidate`, `deferred`, `no-action-base`, `needs-review` |
| `caution_flags` | `none`, or semicolon list from `network-scope`, `cloud-scope`, `credential-scope`, `non-free-plugin-scope`, `license-provenance`, `runtime-parity-not-verified` |

### Pattern 2: Cross-Fork Category Map

**What:** Use a separate TSV that stores row-ID references directly and groups rows by category, ownership, and v1.9 decision. [VERIFIED: 33-CONTEXT.md]

**Recommended columns:**

```text
# map_id	feature_category	ownership	v1_9_decision	inventory_ids	notes
```

**Validation rules:** every `inventory_id` reference must exist in exactly one per-fork inventory row; every inventory row must appear exactly once in `category-map.tsv`; rows grouped together should share the same `ownership` and `v1_9_decision`; `deferred` and `future-candidate` rows must be in different map rows. [RESOLVED: chosen for plan determinism; VERIFIED: 33-CONTEXT.md]

### Pattern 3: Bazel-Owned Verification

**What:** Add `bazel run //packages/fork-inventories:verify` and `bazel test //packages/fork-inventories:verify_inventories_test`. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/parity/BUILD.bazel]

**Recommended `BUILD.bazel` shape:**

```python
package(default_visibility = ["//visibility:public"])

exports_files([
    "README.md",
    "inventory-template.tsv",
    "prusaslicer.tsv",
    "bambustudio.tsv",
    "orcaslicer.tsv",
    "category-map.tsv",
])

sh_binary(
    name = "verify",
    srcs = ["verify_inventories.sh"],
    data = [
        "inventory-template.tsv",
        "prusaslicer.tsv",
        "bambustudio.tsv",
        "orcaslicer.tsv",
        "category-map.tsv",
        "//packages/fork-vendors:forks.tsv",
        "//packages/parity:status.tsv",
    ],
    args = [
        "$(location inventory-template.tsv)",
        "$(location prusaslicer.tsv)",
        "$(location bambustudio.tsv)",
        "$(location orcaslicer.tsv)",
        "$(location category-map.tsv)",
        "$(location //packages/fork-vendors:forks.tsv)",
        "$(location //packages/parity:status.tsv)",
    ],
)

sh_test(
    name = "verify_inventories_test",
    srcs = ["verify_inventories_test.sh"],
    data = ["verify_inventories.sh"],
)
```

This shape mirrors the checked-in fork vendor package pattern and keeps the verifier runnable through Bazel. [VERIFIED: packages/fork-vendors/BUILD.bazel]

### Pattern 4: Minimal Source-Pinned Row Coverage

**PrusaSlicer minimum rows:** include `base-core`, `project`, `profiles-prusaresearch`, `support`, `step`, `arc`, `wall-seam`, and optional `network-prusa-connect` caution rows so the inventory clearly separates base, shared downstream, and Prusa-specific behavior. [VERIFIED: .planning/REQUIREMENTS.md; CITED: https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1]

**Bambu Studio minimum rows:** include inherited `base-core` plus Bambu rows for `project`, `profile`, `network`, `support`, `step`, `arc`, and `assembly`. [VERIFIED: .planning/REQUIREMENTS.md; CITED: https://api.github.com/repos/bambulab/BambuStudio/git/trees/b506005bc4ee62124e24bf00e0f58656db3646a6?recursive=1]

**OrcaSlicer minimum rows:** include inherited `base-core` plus Orca rows for `calibration`, `wall-seam`, `support`, `adaptive-mesh`, `profile-library`, and `community-profile`. [VERIFIED: .planning/REQUIREMENTS.md; CITED: https://api.github.com/repos/OrcaSlicer/OrcaSlicer/git/trees/c724a3f5f51c52336624b689e846c8fbc943a912?recursive=1]

**Representative source-path anchors:** [CITED: GitHub API tree endpoints in Sources]

| Vendor | Surface | Source path anchors |
|---|---|---|
| `prusaslicer` | base/project/profile/network/support/STEP/arc/wall-seam | `src/libslic3r`; `src/libslic3r/Format/3mf.cpp`; `resources/profiles/PrusaResearch.ini`; `src/slic3r/Utils/PrusaConnect.cpp`; `src/libslic3r/SLA/DefaultSupportTree.cpp`; `src/libslic3r/Format/STEP.cpp`; `src/libslic3r/Geometry/ArcWelder.cpp`; `src/libslic3r/GCode/SeamAligned.cpp` |
| `bambustudio` | project/profile/network/support/STEP/arc/assembly | `src/libslic3r/Format/bbs_3mf.cpp`; `resources/profiles/BBL`; `src/slic3r/GUI/DeviceCore`; `src/libslic3r/Support/TreeSupport.cpp`; `src/libslic3r/Format/STEP.cpp`; `src/libslic3r/ArcFitter.cpp`; `src/slic3r/GUI/Gizmos/GLGizmoAssembly.cpp` |
| `orcaslicer` | calibration/wall-seam/support/adaptive-mesh/profile-library/community-profile | `resources/calib`; `src/libslic3r/GCode/SeamPlacer.cpp`; `src/libslic3r/Support/SupportSpotsGenerator.cpp`; `src/libslic3r/SlicingAdaptive.cpp`; `resources/profiles/OrcaFilamentLibrary.json`; `resources/profiles` plus `.github/workflows/check_profiles.yml` |

### Anti-Patterns to Avoid

- **Treating inventory as parity evidence:** Source paths and pins are planning inputs only; `verified` remains reserved for executable evidence. [VERIFIED: 33-CONTEXT.md; docs/port/migration-guidance.md]
- **Using default branch heads as source evidence:** Branch heads in `forks.tsv` are drift-only observations, not accepted row evidence. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/forks.tsv]
- **Letting cross-map references be prose-only:** Row references must be machine-checked so deleted or renamed inventory rows fail verification. [VERIFIED: 33-CONTEXT.md]
- **Using Bash 4-only associative arrays:** The local `/bin/bash` is 3.2.57, so use `awk`, temp files, or sorted lists for cross-file lookups. [VERIFIED: command: bash --version]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| Inventory data model | Custom Markdown parser or bespoke prose conventions | Fixed-column TSV with enum fields | TSV is locked by Phase 33 and already matches repo data-source patterns. [VERIFIED: 33-CONTEXT.md; packages/parity/status.tsv] |
| Source pin authority | New vendor source registry | `packages/fork-vendors/forks.tsv` | Phase 32 already owns vendor IDs, selected stable tags, peeled commits, lineage, and cautions. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-vendors/README.md] |
| Parity dependency vocabulary | New ad hoc surface list | `packages/parity/status.tsv` | Existing parity surfaces already have a checked-in source and command. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md] |
| Upstream source discovery in verifier | Fetching, cloning, GitHub API calls, or source-tree inspection | Validate checked-in paths and pinned source-ref strings only | Phase 33 verifier is explicitly forbidden from fetching, cloning, or inspecting upstream remotes. [VERIFIED: 33-CONTEXT.md] |
| Runtime fork support | Network/cloud/profile/plugin behavior | Inventory cautions and deferred decisions | v1.9 excludes runtime fork parity, online integrations, credential handling, and non-free plugin ingestion. [VERIFIED: .planning/REQUIREMENTS.md; 33-CONTEXT.md] |

**Key insight:** The hard part is not parsing TSV; it is preventing a source-observed row from becoming an implied implementation promise. The schema and docs should make `source_ref`, `ownership`, and `v1_9_decision` visible on every row. [VERIFIED: 33-CONTEXT.md; docs/port/migration-guidance.md]

## Common Pitfalls

### Pitfall 1: Source Pin Drift Into Runtime Claims

**What goes wrong:** A row tied to a fork source path is described as supported behavior. [VERIFIED: docs/port/migration-guidance.md]

**Why it happens:** Source inventories and parity status both live near port docs, so reviewers may read source evidence as executable proof. [VERIFIED: docs/port/README.md; packages/parity/README.md]

**How to avoid:** Use `runtime-parity-not-verified` caution text and keep all new docs wording aligned with "source-observed planning inputs only." [VERIFIED: 33-CONTEXT.md]

**Warning signs:** New rows or docs use `verified`, `supported`, `runtime`, `GUI support`, or `works` for fork behavior. [VERIFIED: docs/port/migration-guidance.md]

### Pitfall 2: Stale Cross-Map Row IDs

**What goes wrong:** A category map points at an inventory row that was renamed or deleted. [VERIFIED: 33-CONTEXT.md]

**Why it happens:** Prose category maps are easy to update independently from TSV inventories. [ASSUMED]

**How to avoid:** Treat `category-map.tsv` references as hard verifier inputs and fail on unknown row IDs. [VERIFIED: 33-CONTEXT.md]

**Warning signs:** `category-map.tsv` contains row IDs not found by `rg` in per-fork TSVs, or an inventory row appears in no category map. [VERIFIED: 33-CONTEXT.md]

### Pitfall 3: Bash 3.2 Compatibility Breakage

**What goes wrong:** A verifier uses Bash 4 features that fail on macOS `/bin/bash`. [VERIFIED: command: bash --version]

**Why it happens:** Cross-file maps invite associative arrays, but Bash 3.2 does not provide them. [VERIFIED: command: bash --version]

**How to avoid:** Use `awk` associative arrays, temp files, or sorted-list membership checks from Bash. [VERIFIED: command: awk --version]

**Warning signs:** The script uses `declare -A`, namerefs, or `mapfile`. [VERIFIED: command: bash --version]

### Pitfall 4: Network and Non-Free Plugin Scope Creep

**What goes wrong:** Network, cloud, credential, or plugin rows become implementation tasks. [VERIFIED: 33-CONTEXT.md]

**Why it happens:** Bambu and Orca source trees contain network/device/cloud paths, and Phase 32 records plugin cautions. [VERIFIED: packages/fork-vendors/forks.tsv; CITED: GitHub API tree endpoints]

**How to avoid:** Mark these rows `deferred` with caution flags such as `network-scope`, `cloud-scope`, `credential-scope`, and `non-free-plugin-scope`. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/README.md]

**Warning signs:** The plan includes credential storage, online API calls, plugin code ingestion, cloud login, or device communication. [VERIFIED: .planning/REQUIREMENTS.md]

## Code Examples

### Inventory TSV Rows

```tsv
# inventory_id	vendor_id	source_ref	source_paths	feature_surface	feature_category	ownership	complexity	parity_dependency	v1_9_decision	caution_flags	future_parity_notes
bambustudio.network-device	bambustudio	bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6	src/slic3r/GUI/DeviceCore;src/slic3r/Utils/NetworkAgent.cpp	network	network-device	fork-specific	high	none	deferred	network-scope;credential-scope;runtime-parity-not-verified	Inventory only; no cloud login, credential handling, device communication, or runtime fork support in v1.9.
orcaslicer.profile-library	orcaslicer	orcaslicer:v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912	resources/profiles/OrcaFilamentLibrary.json;resources/profiles/OrcaFilamentLibrary	profile-library	profile-library	fork-specific	medium	config;config.persistence	needs-review	runtime-parity-not-verified	Inventory only; future parity needs fixture and loader evidence before support can be claimed.
```

These examples use Phase 32 source refs and source paths observed in pinned official trees. [VERIFIED: packages/fork-vendors/forks.tsv; CITED: GitHub API tree endpoints]

### Cross-Map TSV Rows

```tsv
# map_id	feature_category	ownership	v1_9_decision	inventory_ids	notes
network.deferred	network-device	fork-specific	deferred	bambustudio.network-device;orcaslicer.network-device	Network/cloud/plugin/credential surfaces stay deferred and do not create runtime support.
profiles.future	profile-library	fork-specific	needs-review	orcaslicer.profile-library;orcaslicer.community-profiles	Profile rows are planning inputs until fixture-backed loader parity exists.
```

The direct `inventory_ids` field gives the verifier a concrete stale-reference check. [VERIFIED: 33-CONTEXT.md]

### Bash 3.2-Compatible Validation Sketch

```bash
validate_enum() {
	value="$1"
	allowed="$2"
	label="$3"
	row_number="$4"

	if ! printf '%s\n' "${allowed}" | tr ';' '\n' | grep -Fxq "${value}"; then
		error "row ${row_number}: ${label} has invalid value: ${value}"
	fi
}

validate_source_ref() {
	row_number="$1"
	expected_source_ref="$2"

	if [[ "${source_ref}" != "${expected_source_ref}" ]]; then
		error "row ${row_number} (${inventory_id}): source_ref must be ${expected_source_ref}"
	fi
}
```

This style matches the existing verifier's small helper functions and early failures. [VERIFIED: packages/fork-vendors/verify_forks.sh; CITED: Bright Builds code-shape standards]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| Parity docs and `status.tsv` tracked base migration status only. | Phase 33 adds source-pinned fork inventories separate from parity status. | v1.9 Phase 33. [VERIFIED: .planning/ROADMAP.md] | Fork feature planning can start without marking fork runtime behavior as verified. [VERIFIED: .planning/REQUIREMENTS.md] |
| Phase 32 had source pins, lineage, license, and caution metadata only. | Phase 33 consumes those pins to classify source-observed fork surfaces. | After Phase 32 completion on 2026-05-26. [VERIFIED: .planning/STATE.md; 32-01-SUMMARY.md] | Inventories should reference `forks.tsv` instead of duplicating vendor source authority. [VERIFIED: packages/fork-vendors/forks.tsv] |
| Branch heads could be tempting source anchors. | Selected stable tags and peeled commits are the accepted source baseline. | Phase 32. [VERIFIED: packages/fork-vendors/README.md] | Default-branch drift observations must not satisfy inventory source evidence. [VERIFIED: 33-CONTEXT.md] |

**Deprecated/outdated:** [VERIFIED: 33-CONTEXT.md; .planning/REQUIREMENTS.md]

- Using default branch heads as accepted inventory source refs is out of scope. [VERIFIED: packages/fork-vendors/README.md]
- Importing, vendoring, cloning, or building upstream fork source trees is out of scope for v1.9. [VERIFIED: .planning/REQUIREMENTS.md]
- Marking fork feature inventories as `verified` runtime support is out of scope. [VERIFIED: docs/port/migration-guidance.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|---|---|---|
| A1 | Source-path overlap across pinned trees is a sufficient starting signal for `shared-downstream` classification, while uncertain rows can be downgraded to `unknown-needs-review`. [ASSUMED] | Architecture Patterns / Minimal Source-Pinned Row Coverage | Some initial rows may need ownership reclassification during implementation review, but verifier and map design still hold. |
| A2 | The initial inventories can satisfy INV-02 through INV-04 with bounded rows for named surfaces rather than exhaustive upstream feature archaeology. [ASSUMED] | Architecture Patterns / Minimal Source-Pinned Row Coverage | Planner may need to add more rows if reviewers expect broader fork inventory coverage. |

## Open Questions (RESOLVED)

1. **RESOLVED: Include Prusa network/Prusa Connect as deferred caution metadata.** [VERIFIED: GitHub API tree query; .planning/REQUIREMENTS.md]
   - What we know: PrusaSlicer pinned tree contains `src/slic3r/Utils/PrusaConnect.cpp` and related GUI request handler paths. [CITED: https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1]
   - Resolution: Include one Prusa network caution row to make source-observed network/cloud surfaces visible while keeping it deferred and inventory-only. The row must use `v1_9_decision` = `deferred`, include `network-scope;credential-scope;runtime-parity-not-verified`, and state that v1.9 has no online integration, credential handling, device communication, or runtime fork support. [RESOLVED: planner input; VERIFIED: 33-CONTEXT.md]

2. **RESOLVED: Require every inventory row to appear exactly once in `category-map.tsv`.** [VERIFIED: 33-CONTEXT.md]
   - What we know: Cross-map stale or unknown row references must fail verification. [VERIFIED: 33-CONTEXT.md]
   - Resolution: Use exact-once membership for Phase 33 so missing references, duplicate references, and stale references fail deterministically. Future multi-category mapping can be introduced only by a later phase that changes the map contract explicitly. [RESOLVED: planner input]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|---|---|---:|---|---|
| Bash | `verify_inventories.sh` and `verify_inventories_test.sh` | yes | GNU bash 3.2.57 | Use Bash 3.2-compatible syntax only. [VERIFIED: command output] |
| Bazel | `//packages/fork-inventories:verify` and test target | yes | 8.6.0 | None needed. [VERIFIED: command output] |
| awk | Cross-file set validation | yes | awk 20200816 | Use `grep`/`sort` temp files only if an awk portability issue appears. [VERIFIED: command output] |
| git | Repo verification and Phase 32 source-pin command context | yes | 2.53.0 | Not required by Phase 33 verifier. [VERIFIED: command output; 33-CONTEXT.md] |
| rg | Final text verification | yes | 15.1.0 | Use `grep -R` if unavailable. [VERIFIED: command output] |
| Node | Research-only GSD tooling and GitHub API inspection | yes | v24.13.0 | Not required by Phase 33 implementation. [VERIFIED: command output] |

**Missing dependencies with no fallback:** None. [VERIFIED: command outputs]

**Missing dependencies with fallback:** None. [VERIFIED: command outputs]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement: false`. [VERIFIED: .planning/config.json; GSD researcher workflow instructions]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---|---|---|
| V2 Authentication | no | No authentication implementation belongs to Phase 33; network/cloud rows stay deferred caution metadata. [VERIFIED: .planning/REQUIREMENTS.md; 33-CONTEXT.md] |
| V3 Session Management | no | No sessions or credential stores are introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V4 Access Control | no | No runtime access-control surface is introduced. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | yes | Validate TSV field count, required fields, enum values, source-ref pins, parity dependencies, required coverage, and category-map row references. [VERIFIED: 33-CONTEXT.md] |
| V6 Cryptography | no | No cryptographic function should be added; credential and plugin surfaces are inventory cautions only. [VERIFIED: 33-CONTEXT.md] |

### Known Threat Patterns for TSV Inventory Package

| Pattern | STRIDE | Standard Mitigation |
|---|---|---|
| Malformed TSV or delimiter ambiguity | Tampering | Reject CR characters, incorrect field counts, empty required fields, and spaced semicolon delimiters as `verify_forks.sh` already does. [VERIFIED: packages/fork-vendors/verify_forks.sh] |
| Cross-map row spoofing or stale references | Tampering | Validate every `inventory_id` reference against all per-fork inventory rows and fail on unknown IDs. [VERIFIED: 33-CONTEXT.md] |
| Source inventory interpreted as runtime support | Repudiation | Require `v1_9_decision`, `caution_flags`, and docs language that states inventories are source-observed planning inputs only. [VERIFIED: 33-CONTEXT.md] |
| Network/cloud/plugin row becomes credential integration work | Information Disclosure | Mark network/cloud/plugin/credential rows as deferred cautions and do not add runtime code or secret handling. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-vendors/README.md] |

## Sources

### Primary (HIGH Confidence)

- `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md` - locked Phase 33 decisions, discretion, and deferrals. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - INV-01 through INV-05 and v1.9 out-of-scope boundaries. [VERIFIED: file read]
- `.planning/ROADMAP.md` and `.planning/STATE.md` - Phase 33 milestone position and Phase 32 dependency state. [VERIFIED: file read]
- `.planning/PROJECT.md` - v1.9 milestone goal and Phase 32 current state. [VERIFIED: file read]
- `packages/fork-vendors/forks.tsv`, `README.md`, `BUILD.bazel`, and `verify_forks.sh` - canonical source pins, package boundary, and verifier style. [VERIFIED: file read]
- `packages/parity/status.tsv`, `README.md`, and `BUILD.bazel` - parity dependency vocabulary and Bazel command pattern. [VERIFIED: file read]
- `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`, and `docs/port/contract-inventory.md` - documentation integration and conservative parity vocabulary. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: file read]

### Primary Web / Official Source Trees (HIGH Confidence for Path Presence)

- `https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1` - pinned PrusaSlicer tree; query returned HTTP 200, `truncated=false`, 4533 entries. [CITED: GitHub API; VERIFIED: command output]
- `https://api.github.com/repos/bambulab/BambuStudio/git/trees/b506005bc4ee62124e24bf00e0f58656db3646a6?recursive=1` - pinned Bambu Studio tree; query returned HTTP 200, `truncated=false`, 10416 entries. [CITED: GitHub API; VERIFIED: command output]
- `https://api.github.com/repos/OrcaSlicer/OrcaSlicer/git/trees/c724a3f5f51c52336624b689e846c8fbc943a912?recursive=1` - pinned OrcaSlicer tree; query returned HTTP 200, `truncated=false`, 17636 entries. [CITED: GitHub API; VERIFIED: command output]

### Standards (HIGH Confidence)

- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md` - rule levels and standards routing. [CITED: official Bright Builds standards]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md` - functional core / imperative shell guidance. [CITED: official Bright Builds standards]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md` - early returns and guard-style code shape. [CITED: official Bright Builds standards]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md` - sync and verification guidance. [CITED: official Bright Builds standards]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md` - unit test and Arrange/Act/Assert expectations. [CITED: official Bright Builds standards]

### Secondary (MEDIUM Confidence)

- None used; recommendations are based on locked context, repo files, and official pinned source-tree metadata. [VERIFIED: research process]

### Tertiary (LOW Confidence)

- None used. [VERIFIED: research process]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - Phase 33 locks TSV, shell verification, Bazel target, and Phase 32 source pins; repo files confirm matching patterns. [VERIFIED: 33-CONTEXT.md; packages/fork-vendors/BUILD.bazel]
- Architecture: HIGH - package layout, Bazel target shape, and docs integration follow existing `packages/fork-vendors` and `packages/parity` patterns. [VERIFIED: packages/fork-vendors/BUILD.bazel; packages/parity/BUILD.bazel; docs/port/package-map.md]
- Initial row coverage: MEDIUM - required surfaces are locked, and source paths were verified in pinned trees, but some ownership labels infer lineage from path overlap and may need reviewer adjustment. [VERIFIED: .planning/REQUIREMENTS.md; CITED: GitHub API tree endpoints; ASSUMED]
- Pitfalls: HIGH - scope creep and parity-overclaiming risks are directly documented in Phase 33 context, requirements, and migration guidance. [VERIFIED: 33-CONTEXT.md; .planning/REQUIREMENTS.md; docs/port/migration-guidance.md]

**Research date:** 2026-05-26 [VERIFIED: environment current_date]
**Valid until:** 2026-06-25 for repo-local implementation patterns; re-check upstream tree paths before expanding inventories beyond the Phase 33 minimum rows. [ASSUMED]
