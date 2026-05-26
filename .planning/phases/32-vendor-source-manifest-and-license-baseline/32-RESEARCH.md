# Phase 32: Vendor Source Manifest and License Baseline - Research

**Researched:** 2026-05-26T16:23:36Z [VERIFIED: `date -u +%Y-%m-%dT%H:%M:%SZ`]
**Domain:** Git remote reference verification, checked-in TSV registries, and upstream license/provenance metadata [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md]
**Confidence:** HIGH for source refs and verifier architecture; MEDIUM for normalized SPDX conclusions because this phase is metadata-only and not legal review [VERIFIED: git ls-remote; GitHub API; raw upstream README/LICENSE files]

<user_constraints>
## User Constraints (from CONTEXT.md)

The following content is copied verbatim from `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md`. [VERIFIED: 32-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Manifest Shape and Ownership

- **D-01:** Add a new `packages/fork-vendors` package to own vendor-source
  intake metadata instead of putting source pins inside `packages/parity`.
  This keeps source-reference metadata separate from executable parity evidence
  and avoids implying fork runtime support.
- **D-02:** Use one checked-in TSV registry, `packages/fork-vendors/forks.tsv`,
  with one row per fork. This follows the repo's existing checked-in data
  source pattern such as `packages/parity/status.tsv` while avoiding a new TOML,
  JSON, or SBOM parser dependency.
- **D-03:** Make delimiter rules explicit for multi-value TSV fields such as
  lineage IDs, source paths, attribution notes, and caution flags so shell
  verification can stay deterministic.

### Git Ref Verification

- **D-04:** Add a Bazel-owned verification command in `packages/fork-vendors`
  that uses `git ls-remote` to validate selected tags and peeled commits
  without cloning or building upstream repositories.
- **D-05:** Treat selected stable tags and peeled commits as the canonical
  acceptance baseline. The verifier should fail when a selected tag does not
  resolve to the recorded tag object or peeled commit.
- **D-06:** Record observed default branch heads as drift-only observations.
  Branch-head drift should be reported clearly, but it should not invalidate
  the accepted release pin unless the selected stable tag or peeled commit no
  longer resolves as recorded.

### License and Provenance Vocabulary

- **D-07:** Use structured observed-provenance fields rather than prose-only
  license notes or SBOM-style package records. Required fields should include
  SPDX identifier, license source, attribution/provenance notes, lineage, caution
  flags, and an explicit note that the data is metadata-only and not legal
  review.
- **D-08:** Use current SPDX identifiers such as `AGPL-3.0-only` or
  `AGPL-3.0-or-later` where the upstream license statement supports them.
  Deprecated upstream display strings may be recorded as observed upstream text
  but should not be used as the canonical internal identifier.
- **D-09:** Keep non-free and network-plugin cautions separate from the SPDX
  license expression. These are provenance/security scope cautions, not license
  identifiers and not evidence of runtime support.

### Refresh and Drift Baseline

- **D-10:** Capture `capture_date_utc`, official repository URL, selected stable
  tag, tag object when available, peeled commit, default branch name, observed
  default branch head, source paths, and refresh command in the single registry.
- **D-11:** Use the Phase 32 refresh command as a maintainer inspection aid, not
  a full automated drift-refresh protocol. Phase 36 owns the later template and
  protocol work.
- **D-12:** Documentation should consistently explain that source pins,
  inventories, and branch observations are intake evidence only. They do not
  mark fork parity as verified.

### the agent's Discretion

- The planner may choose the exact shell helper layout under
  `packages/fork-vendors` as long as it remains repo-owned, deterministic, and
  avoids new dependencies.
- The planner may choose the exact TSV column names, but they must cover all
  VEND-01 and VEND-03 fields and remain easy to validate from shell.
- The planner may decide whether branch-head drift exits zero with warnings or
  is exposed through a separate informational command, provided the canonical
  tag/commit validation remains a failing gate.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

- Formal SBOM or external compliance tooling belongs to a later compliance
  milestone if needed.
- Signed tag verification, tag object audit, or shallow object fetching belongs
  to a later hardening or vendor-refresh phase.
- Full drift-refresh protocol templates remain Phase 36 scope.
- Fork runtime parity, fork-flavor release builds, GUI migration, cloud/network
  integrations, and non-free plugin ingestion remain future milestones.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| VEND-01 | Maintainer can inspect one checked-in vendor source registry for PrusaSlicer, Bambu Studio, and OrcaSlicer that records official repository URL, selected stable tag, peeled commit, observed default branch head, capture date, lineage, source paths, and refresh command. [VERIFIED: .planning/REQUIREMENTS.md] | Use `packages/fork-vendors/forks.tsv` with the schema and pinned upstream rows in this research. [VERIFIED: 32-CONTEXT.md; git ls-remote; GitHub API] |
| VEND-02 | Maintainer can run a repo-owned verification target that validates every vendor registry row resolves to the recorded upstream tag and commit without cloning or building the full upstream fork repositories. [VERIFIED: .planning/REQUIREMENTS.md] | Use a Bazel `sh_binary` wrapper around `git ls-remote --tags` and `git ls-remote --symref`. [CITED: https://git-scm.com/docs/git-ls-remote; VERIFIED: packages/parity/BUILD.bazel] |
| VEND-03 | Maintainer can inspect license and provenance metadata for each tracked fork, including SPDX identifier, license source, attribution notes, and explicit non-free or network-plugin cautions. [VERIFIED: .planning/REQUIREMENTS.md] | Store normalized SPDX, observed license source, lineage, attribution, and caution fields in the same TSV. [VERIFIED: raw upstream README/LICENSE files; CITED: https://spdx.org/licenses/AGPL-3.0.html] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- Planning and implementation must follow root `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds standards pages. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Repo-local summary files must keep `requirements-completed` as the exact hyphenated YAML key, and Phase 32 does not need to touch summary frontmatter. [VERIFIED: AGENTS.md]
- Do not run `mdformat` over phase `*-SUMMARY.md` files; this phase writes `32-RESEARCH.md`, so the summary-specific prohibition is not directly triggered. [VERIFIED: AGENTS.md]
- Before committing changed docs or scripts, run relevant repo-native verification and at least a changed-path whitespace check such as `git diff --check`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Shell helpers should use `#!/usr/bin/env bash`, `set -euo pipefail`, shallow control flow, and clear failures. [VERIFIED: prompt-provided AGENTS.md instructions; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- For this repo, Bazel is the established verification entrypoint and existing checked-in TSV data is exposed through `sh_binary` targets. [VERIFIED: docs/port/README.md; packages/parity/BUILD.bazel; packages/parity/status.tsv]
- No project-local `.claude/skills` or `.agents/skills` directories were found. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md -print`]

## Summary

Implement Phase 32 as a new metadata-only package, `packages/fork-vendors`, containing `forks.tsv`, `verify_forks.sh`, `BUILD.bazel`, and a short package `README.md`. [VERIFIED: 32-CONTEXT.md; packages/parity/BUILD.bazel; packages/parity/README.md] Link the new package from `docs/port/README.md` and `docs/port/package-map.md` without changing runtime parity status. [VERIFIED: docs/port/README.md; docs/port/package-map.md; docs/port/migration-guidance.md]

The pinned release baseline should use the official GitHub latest non-draft, non-prerelease release API responses collected on 2026-05-26: PrusaSlicer `version_2.9.5`, Bambu Studio `v02.06.00.51`, and OrcaSlicer `v2.3.2`. [VERIFIED: GitHub Releases API 2026-05-26] The acceptance gate should compare the recorded tag ref SHA and peeled commit SHA with `git ls-remote --tags`; default branch heads should be reported as drift observations and must not fail the release-pin gate. [VERIFIED: git ls-remote output 2026-05-26; CITED: https://git-scm.com/docs/git-ls-remote]

The license baseline should normalize the upstream "GNU Affero General Public License, version 3" statements to `AGPL-3.0-only` for the internal SPDX field, while preserving observed upstream text and GitHub's deprecated `AGPL-3.0` metadata as provenance. [VERIFIED: raw upstream README/LICENSE files; VERIFIED: GitHub Repository API; CITED: https://spdx.org/licenses/AGPL-3.0.html; CITED: https://spdx.org/licenses/AGPL-3.0-only.html] Bambu Studio and OrcaSlicer both need explicit non-free Bambu networking plugin caution fields that are separate from the SPDX license expression. [VERIFIED: raw upstream README files]

**Primary recommendation:** Use `git ls-remote` plus a fixed-column TSV verifier under `packages/fork-vendors`; fail only on selected release tag/ref/peeled-commit mismatches and print branch-head drift as a warning. [VERIFIED: 32-CONTEXT.md; CITED: https://git-scm.com/docs/git-ls-remote]

## Standard Stack

### Core

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Git | 2.53.0 | Resolve remote tags, peeled commits, and HEAD symrefs without cloning. [VERIFIED: `git --version`] | `git ls-remote` is provider-neutral and its documented output includes `<oid><TAB><ref>` plus peeled annotated-tag rows. [CITED: https://git-scm.com/docs/git-ls-remote] |
| Bazel/Bazelisk | Bazel 8.6.0 | Own the maintainer verification target as `sh_binary`. [VERIFIED: `bazelisk --version`; `bazel --version`] | Existing repo commands expose shell verification through Bazel targets. [VERIFIED: packages/parity/BUILD.bazel; CITED: https://bazel.build/reference/be/shell] |
| Bash | 3.2.57 | Implement the TSV verifier with repo-compatible shell. [VERIFIED: `bash --version`] | macOS Bash 3.2 is available here, so the script must avoid Bash 4-only features such as associative arrays. [VERIFIED: `bash --version`] |
| awk/sed | awk 20200816; sed available | Format or inspect fixed-column TSV data when useful. [VERIFIED: `awk -W version`; `command -v sed`] | Existing package scripts use simple shell utilities and avoid parser dependencies. [VERIFIED: packages/parity/parity_status.sh] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| curl | 8.7.1 | Research-only release and repository metadata checks. [VERIFIED: `curl --version`] | Do not require curl for the Phase 32 verifier; use it only for maintainer refresh research if documented. [VERIFIED: 32-CONTEXT.md] |
| jq | 1.7.1 | Research-only JSON inspection. [VERIFIED: `jq --version`] | Do not add jq as a runtime dependency for `bazel run //packages/fork-vendors:verify`. [VERIFIED: 32-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `git ls-remote` | GitHub REST or GraphQL API | API calls are provider-specific and can introduce rate-limit/auth concerns; `git ls-remote` directly checks Git refs and is already required by the phase. [VERIFIED: 32-CONTEXT.md; CITED: https://git-scm.com/docs/git-ls-remote] |
| TSV | JSON, TOML, YAML, SPDX SBOM | Structured formats would add parser/tooling decisions that the user explicitly deferred for Phase 32. [VERIFIED: 32-CONTEXT.md] |
| Fixed shell verifier | Clone/fetch upstream repos | Cloning or building upstream forks is explicitly out of scope and unnecessary for tag/ref verification. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md] |

**Installation:** No package installation is required for Phase 32 because Git, Bazel/Bazelisk, Bash, awk, sed, curl, and jq are already present in this workspace. [VERIFIED: environment availability commands 2026-05-26]

**Version verification:** This phase does not recommend npm packages, so `npm view` is not applicable. [VERIFIED: no package.json dependency addition in 32-CONTEXT.md] Tool versions were verified through CLI commands listed in the Environment Availability section. [VERIFIED: CLI version probes]

## Pinned Vendor Baseline

| Fork | Official Repo URL | Selected Stable Tag | Release Published | Tag Kind | Tag Ref SHA | Tag Object SHA | Peeled Commit SHA | Default Branch | Observed Branch Head | Source |
|------|-------------------|---------------------|-------------------|----------|-------------|----------------|-------------------|----------------|----------------------|--------|
| PrusaSlicer | `https://github.com/prusa3d/PrusaSlicer` | `version_2.9.5` | 2026-05-19T13:25:48Z | annotated | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` | `9a583bd438b195856f3bcf7ea99b69ba4003a961` | `master` | `43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b` | [VERIFIED: GitHub Releases API; git ls-remote; GitHub Git Tags API] |
| Bambu Studio | `https://github.com/bambulab/BambuStudio` | `v02.06.00.51` | 2026-04-17T13:02:58Z | annotated | `41a32318a8f48d51f899be0525ff9a8841382044` | `41a32318a8f48d51f899be0525ff9a8841382044` | `b506005bc4ee62124e24bf00e0f58656db3646a6` | `master` | `e150b502b3d2afc98b83dcc9e5720e998f9eb79a` | [VERIFIED: GitHub Releases API; git ls-remote; GitHub Git Tags API] |
| OrcaSlicer | `https://github.com/OrcaSlicer/OrcaSlicer` | `v2.3.2` | 2026-03-23T13:08:14Z | lightweight | `c724a3f5f51c52336624b689e846c8fbc943a912` | `-` | `c724a3f5f51c52336624b689e846c8fbc943a912` | `main` | `e0c4d11baefa328331be113533c47ee89fda16c6` | [VERIFIED: GitHub Releases API; git ls-remote; GitHub Git Refs API] |

**Capture date:** Use `2026-05-26` or `2026-05-26T16:23:36Z` consistently in `capture_date_utc`. [VERIFIED: `date -u +%Y-%m-%dT%H:%M:%SZ`]

## License and Provenance Baseline

| Fork | Recommended SPDX | Observed Upstream License Source | Lineage | Attribution and Provenance | Caution Flags |
|------|------------------|----------------------------------|---------|----------------------------|---------------|
| PrusaSlicer | `AGPL-3.0-only` | README says GNU Affero General Public License, version 3; `LICENSE` contains AGPL v3 text; GitHub API reports deprecated `AGPL-3.0`. [VERIFIED: raw README at `version_2.9.5`; raw LICENSE at `version_2.9.5`; GitHub Repository API; CITED: https://spdx.org/licenses/AGPL-3.0.html] | `slic3r` | README attributes lineage to Slic3r by Alessandro Ranellucci and the RepRap community. [VERIFIED: raw README at `version_2.9.5`] | `none` for non-free/network plugin caution in upstream README evidence. [VERIFIED: raw README at `version_2.9.5`] |
| Bambu Studio | `AGPL-3.0-only` | README says GNU Affero General Public License, version 3; `LICENSE` contains AGPL v3 text; GitHub API reports deprecated `AGPL-3.0`. [VERIFIED: raw README at `v02.06.00.51`; raw LICENSE at `v02.06.00.51`; GitHub Repository API; CITED: https://spdx.org/licenses/AGPL-3.0.html] | `slic3r;prusaslicer` | README states Bambu Studio is based on PrusaSlicer, which is from Slic3r. [VERIFIED: raw README at `v02.06.00.51`] | `non-free-network-plugin;optional-network-plugin;network-device-surface;metadata-only-not-legal-review` because README says the Bambu networking plugin is based on non-free libraries and optional. [VERIFIED: raw README at `v02.06.00.51`] |
| OrcaSlicer | `AGPL-3.0-only` | README says GNU Affero General Public License, version 3; `LICENSE.txt` contains AGPL v3 text; GitHub API reports deprecated `AGPL-3.0`. [VERIFIED: raw README at `v2.3.2`; raw LICENSE.txt at `v2.3.2`; GitHub Repository API; CITED: https://spdx.org/licenses/AGPL-3.0.html] | `slic3r;prusaslicer;bambustudio;superslicer` | README states OrcaSlicer draws from Bambu Studio, PrusaSlicer, Slic3r, and ideas inspired by SuperSlicer, and notes a GPL v3 pressure-advance calibration pattern provenance chain. [VERIFIED: raw README at `v2.3.2`] | `non-free-network-plugin;optional-network-plugin;network-device-surface;gpl-pressure-advance-provenance;metadata-only-not-legal-review` because README calls the Bambu networking plugin non-free and optional and records GPL v3 calibration-pattern provenance. [VERIFIED: raw README at `v2.3.2`] |

## Recommended TSV Schema

Use this fixed column order for `packages/fork-vendors/forks.tsv`. [VERIFIED: 32-CONTEXT.md; packages/parity/status.tsv]

```text
# vendor_id	display_name	official_repo_url	selected_stable_tag	tag_kind	tag_ref_sha	tag_object_sha	peeled_commit_sha	default_branch	observed_default_branch_head	capture_date_utc	lineage_ids	source_paths	refresh_command	spdx_identifier	observed_license_id	license_source	attribution_notes	provenance_notes	caution_flags	caution_notes
```

Delimiter rules should be explicit in `packages/fork-vendors/README.md`: field delimiter is a literal tab, row delimiter is LF, multi-value delimiter is semicolon with no surrounding spaces, empty optional scalar is `-`, and fields must not contain literal tabs or newlines. [VERIFIED: 32-CONTEXT.md; packages/parity/status.tsv]

Recommended first-pass `source_paths` values are root-level paths that exist at the selected commit and are useful for later inventory work. [VERIFIED: GitHub Git Trees API]

| Fork | `source_paths` |
|------|----------------|
| PrusaSlicer | `src;resources;doc;tests;version.inc` [VERIFIED: GitHub Git Trees API at `9a583bd438b195856f3bcf7ea99b69ba4003a961`] |
| Bambu Studio | `src;resources;bbl;lib;xs;doc;tests;version.inc` [VERIFIED: GitHub Git Trees API at `b506005bc4ee62124e24bf00e0f58656db3646a6`] |
| OrcaSlicer | `src;resources;SoftFever_doc;localization;scripts;tests;version.inc` [VERIFIED: GitHub Git Trees API at `c724a3f5f51c52336624b689e846c8fbc943a912`] |

## Architecture Patterns

### Recommended Project Structure

```text
packages/fork-vendors/
├── BUILD.bazel          # Bazel package wrapper for metadata and verifier. [VERIFIED: packages/parity/BUILD.bazel pattern]
├── README.md            # Maintainer command and scope notes. [VERIFIED: packages/parity/README.md pattern]
├── forks.tsv            # Single checked-in vendor source/license registry. [VERIFIED: 32-CONTEXT.md]
└── verify_forks.sh      # Bash verifier using git ls-remote. [CITED: https://git-scm.com/docs/git-ls-remote]
```

Add `packages/fork-vendors` to `docs/port/package-map.md` and mention its maintainer command from `docs/port/README.md`. [VERIFIED: docs/port/README.md; docs/port/package-map.md]

### Pattern 1: Fixed-Column TSV Reader

**What:** Read rows with `IFS=$'\t' read -r` and skip blank or comment rows. [VERIFIED: packages/parity/parity_status.sh]
**When to use:** Use this for `forks.tsv` because there are three rows and a known schema. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md]
**Example:**

```bash
#!/usr/bin/env bash
set -euo pipefail

registry_file="${1}"

while IFS=$'\t' read -r vendor_id display_name official_repo_url selected_stable_tag tag_kind tag_ref_sha tag_object_sha peeled_commit_sha default_branch observed_default_branch_head capture_date_utc lineage_ids source_paths refresh_command spdx_identifier observed_license_id license_source attribution_notes provenance_notes caution_flags caution_notes; do
	if [[ -z "${vendor_id}" || "${vendor_id}" == \#* ]]; then
		continue
	fi
	# Validate required fields before any network call.
done <"${registry_file}"
```

Source: existing parity TSV reader and Bash project conventions. [VERIFIED: packages/parity/parity_status.sh; prompt-provided AGENTS.md instructions]

### Pattern 2: Tag Ref and Peeled Commit Verification

**What:** Query both `refs/tags/<tag>` and `refs/tags/<tag>^{}` and compare to recorded SHAs. [CITED: https://git-scm.com/docs/git-ls-remote]
**When to use:** Use this for every registry row in the failing verification target. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md]
**Example:**

```bash
tag_output="$(git ls-remote --tags "${official_repo_url}" "refs/tags/${selected_stable_tag}" "refs/tags/${selected_stable_tag}^{}")"
actual_tag_ref_sha="$(printf '%s\n' "${tag_output}" | awk -v ref="refs/tags/${selected_stable_tag}" '$2 == ref { print $1 }')"
actual_peeled_sha="$(printf '%s\n' "${tag_output}" | awk -v ref="refs/tags/${selected_stable_tag}^{}" '$2 == ref { print $1 }')"

if [[ -z "${actual_peeled_sha}" && "${tag_kind}" == "lightweight" ]]; then
	actual_peeled_sha="${actual_tag_ref_sha}"
fi

if [[ "${actual_tag_ref_sha}" != "${tag_ref_sha}" || "${actual_peeled_sha}" != "${peeled_commit_sha}" ]]; then
	printf 'vendor ref mismatch: %s %s\n' "${vendor_id}" "${selected_stable_tag}" >&2
	exit 1
fi
```

Source: Git documents `ls-remote` output and peeled annotated-tag rows. [CITED: https://git-scm.com/docs/git-ls-remote]

### Pattern 3: Branch Drift Warning

**What:** Query `HEAD` with `--symref`, compare default branch and observed branch head, and warn on drift without failing the tag gate. [VERIFIED: 32-CONTEXT.md; CITED: https://git-scm.com/docs/git-ls-remote]
**When to use:** Use this inside the verifier after release tag checks, or expose it as a separate informational target if the planner wants cleaner output. [VERIFIED: 32-CONTEXT.md]
**Example:**

```bash
head_output="$(git ls-remote --symref "${official_repo_url}" HEAD)"
actual_default_branch="$(printf '%s\n' "${head_output}" | awk '$1 == "ref:" && $3 == "HEAD" { sub("^refs/heads/", "", $2); print $2 }')"
actual_default_head="$(printf '%s\n' "${head_output}" | awk '$2 == "HEAD" { print $1 }')"

if [[ "${actual_default_branch}" != "${default_branch}" || "${actual_default_head}" != "${observed_default_branch_head}" ]]; then
	printf 'warning: branch drift observed for %s: recorded %s@%s, current %s@%s\n' \
		"${vendor_id}" "${default_branch}" "${observed_default_branch_head}" "${actual_default_branch}" "${actual_default_head}" >&2
fi
```

Source: Git documents `--symref` for HEAD and the phase decision says branch drift is informational. [CITED: https://git-scm.com/docs/git-ls-remote; VERIFIED: 32-CONTEXT.md]

### Anti-Patterns to Avoid

- **Evaluating `refresh_command`:** Store refresh commands for humans, but do not `eval` TSV content in the verifier. [VERIFIED: 32-CONTEXT.md; prompt-provided AGENTS.md instructions]
- **Assuming all tags are annotated:** OrcaSlicer `v2.3.2` is lightweight and has no separate peeled `^{}` row. [VERIFIED: git ls-remote; GitHub Git Refs API]
- **Failing on branch-head drift:** Branch heads are mutable observations, while selected release tags and peeled commits are the acceptance baseline. [VERIFIED: 32-CONTEXT.md]
- **Using Bash 4-only constructs:** Local Bash is 3.2.57, so avoid associative arrays and `mapfile`. [VERIFIED: `bash --version`]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Remote Git ref resolution | Custom HTTP scraping or GitHub HTML parsing | `git ls-remote` | Git already exposes remote refs and peeled tags in a documented format. [CITED: https://git-scm.com/docs/git-ls-remote] |
| Stable release selection | A homemade semantic-version sorter over all tags | GitHub `releases/latest` during research, then a checked-in selected tag | Upstreams do not share tag naming conventions, and Phase 32 needs a pinned baseline, not an auto-updating selector. [VERIFIED: GitHub Releases API; 32-CONTEXT.md] |
| License classification | A custom legal/compliance scanner | Structured observed metadata plus SPDX identifiers | Formal SBOM/compliance tooling is deferred and Phase 32 is not legal review. [VERIFIED: 32-CONTEXT.md; CITED: https://spdx.org/licenses/AGPL-3.0.html] |
| Branch drift policy | Treat mutable default branch heads as release acceptance evidence | Warning-only drift observation | Branch-head drift must not invalidate the accepted stable tag/commit. [VERIFIED: 32-CONTEXT.md] |

**Key insight:** Phase 32 is an intake metadata baseline, so the robust path is to pin observable Git facts and license-source facts while leaving cloning, SBOM generation, signed-tag auditing, and full refresh protocol work out of scope. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Conflating Tag Objects and Peeled Commits

**What goes wrong:** Annotated tags have a tag object SHA and a peeled commit SHA, but lightweight tags have only a commit SHA. [CITED: https://git-scm.com/docs/git-ls-remote; VERIFIED: git ls-remote]
**Why it happens:** `git ls-remote --tags` returns two rows for annotated tags unless `--refs` is used, but OrcaSlicer `v2.3.2` returns only one row. [CITED: https://git-scm.com/docs/git-ls-remote; VERIFIED: git ls-remote]
**How to avoid:** Store `tag_kind`, `tag_ref_sha`, `tag_object_sha`, and `peeled_commit_sha` separately. [VERIFIED: git ls-remote]
**Warning signs:** The verifier expects `refs/tags/<tag>^{}` for every row and fails on OrcaSlicer. [VERIFIED: git ls-remote]

### Pitfall 2: Treating Branch Drift as Failure

**What goes wrong:** The verifier fails whenever `master` or `main` moves after the capture date. [VERIFIED: git ls-remote HEAD output]
**Why it happens:** Mutable branch heads are mixed with canonical release pins in one acceptance rule. [VERIFIED: 32-CONTEXT.md]
**How to avoid:** Fail on tag ref or peeled commit mismatch; warn on branch name or branch head drift. [VERIFIED: 32-CONTEXT.md]
**Warning signs:** A new upstream commit to `master` or `main` breaks the target even when the selected release tag is unchanged. [VERIFIED: 32-CONTEXT.md]

### Pitfall 3: License Identifier Drift

**What goes wrong:** The registry records GitHub's deprecated `AGPL-3.0` string as the canonical internal SPDX identifier. [VERIFIED: GitHub Repository API; CITED: https://spdx.org/licenses/AGPL-3.0.html]
**Why it happens:** GitHub repository metadata still reports `AGPL-3.0` for these repos. [VERIFIED: GitHub Repository API]
**How to avoid:** Store `spdx_identifier=AGPL-3.0-only`, store `observed_license_id=AGPL-3.0`, and cite README/LICENSE sources. [VERIFIED: raw upstream README/LICENSE files; CITED: https://spdx.org/licenses/AGPL-3.0-only.html]
**Warning signs:** The SPDX column contains `AGPL-3.0` or mixes non-free plugin notes into the license expression. [CITED: https://spdx.org/licenses/AGPL-3.0.html; VERIFIED: raw upstream README files]

### Pitfall 4: Shell Injection Through Refresh Commands

**What goes wrong:** The verifier executes a `refresh_command` field from TSV. [VERIFIED: recommended schema]
**Why it happens:** Human-readable commands are mistaken for trusted program input. [VERIFIED: prompt-provided AGENTS.md instructions]
**How to avoid:** Treat `refresh_command` as display-only and construct `git ls-remote` invocations from validated fields. [VERIFIED: 32-CONTEXT.md]
**Warning signs:** The verifier uses `eval`, `bash -c "${refresh_command}"`, or unquoted variables. [VERIFIED: prompt-provided AGENTS.md instructions]

### Pitfall 5: Letting Plugin Cautions Imply Runtime Scope

**What goes wrong:** Non-free networking plugin notes are treated as a license expression or as planned runtime integration. [VERIFIED: raw Bambu Studio and OrcaSlicer README files; 32-CONTEXT.md]
**Why it happens:** The upstream README warnings are adjacent to license text. [VERIFIED: raw Bambu Studio and OrcaSlicer README files]
**How to avoid:** Store non-free/network cautions in `caution_flags` and `caution_notes`, separate from SPDX. [VERIFIED: 32-CONTEXT.md]
**Warning signs:** A future plan starts importing networking plugin code, credentials, or cloud integration behavior in Phase 32. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md]

## Code Examples

### Bazel Target Shape

```python
package(default_visibility = ["//visibility:public"])

exports_files([
    "README.md",
    "forks.tsv",
])

sh_binary(
    name = "verify",
    srcs = ["verify_forks.sh"],
    data = ["forks.tsv"],
    args = ["$(location forks.tsv)"],
)

filegroup(
    name = "package_boundary",
    srcs = [
        "README.md",
        "forks.tsv",
        "verify_forks.sh",
    ],
)
```

Source: existing `packages/parity` Bazel pattern and Bazel shell rule docs. [VERIFIED: packages/parity/BUILD.bazel; CITED: https://bazel.build/reference/be/shell]

### Maintainer Refresh Commands

```bash
git ls-remote --symref https://github.com/prusa3d/PrusaSlicer HEAD
git ls-remote --tags https://github.com/prusa3d/PrusaSlicer refs/tags/version_2.9.5 'refs/tags/version_2.9.5^{}'

git ls-remote --symref https://github.com/bambulab/BambuStudio HEAD
git ls-remote --tags https://github.com/bambulab/BambuStudio refs/tags/v02.06.00.51 'refs/tags/v02.06.00.51^{}'

git ls-remote --symref https://github.com/OrcaSlicer/OrcaSlicer HEAD
git ls-remote --tags https://github.com/OrcaSlicer/OrcaSlicer refs/tags/v2.3.2 'refs/tags/v2.3.2^{}'
```

Source: commands used during research and compatible with Git's documented `ls-remote` syntax. [VERIFIED: git ls-remote output; CITED: https://git-scm.com/docs/git-ls-remote]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| SPDX `AGPL-3.0` | `AGPL-3.0-only` or `AGPL-3.0-or-later` | SPDX deprecated `AGPL-3.0` in license list version 3.0. [CITED: https://spdx.org/licenses/AGPL-3.0.html] | Store current SPDX identifiers internally and preserve upstream/GitHub observed strings separately. [CITED: https://spdx.org/licenses/AGPL-3.0-only.html] |
| Branch head as acceptance evidence | Release tag ref plus peeled commit as acceptance evidence | Phase 32 user decision D-05/D-06. [VERIFIED: 32-CONTEXT.md] | Branch drift is visible but does not break a stable release baseline. [VERIFIED: 32-CONTEXT.md] |
| Repo cloning for source intake verification | Remote ref inspection without cloning | Phase 32 user decision D-04. [VERIFIED: 32-CONTEXT.md] | Verification stays cheap and avoids pulling full upstream fork trees into this repo. [VERIFIED: .planning/REQUIREMENTS.md] |

**Deprecated/outdated:**

- `AGPL-3.0` should not be the canonical internal SPDX identifier because SPDX marks it deprecated. [CITED: https://spdx.org/licenses/AGPL-3.0.html]
- `--heads` should be avoided in new docs because Git documents `--heads` as a deprecated synonym for `--branches`. [CITED: https://git-scm.com/docs/git-ls-remote]
- HTML scraping of GitHub release pages should not be used for the verifier because Git and GitHub APIs provide structured ref/release data. [CITED: https://git-scm.com/docs/git-ls-remote; VERIFIED: GitHub Releases API]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Normalizing upstream "GNU Affero General Public License, version 3" to `AGPL-3.0-only` is the right metadata choice for this phase when no "or later" wording was found in README/LICENSE evidence. [ASSUMED] | License and Provenance Baseline | A legal reviewer could prefer a different expression or require file-level license scanning before accepting the normalized SPDX field. |

## Open Questions

1. **Should Phase 32 include a file-level license scan?** [VERIFIED: 32-CONTEXT.md]
   - What we know: The phase requires license/provenance metadata, and formal SBOM or external compliance tooling is deferred. [VERIFIED: .planning/REQUIREMENTS.md; 32-CONTEXT.md]
   - What's unclear: Whether maintainers want a later legal/compliance pass to validate every file-level header across the selected upstream commits. [ASSUMED]
   - Recommendation: Do not add file-level scanning in Phase 32; record README/LICENSE evidence and explicit upstream caution notes, then leave deeper compliance to a later milestone. [VERIFIED: 32-CONTEXT.md]

2. **Should the planner add a root alias such as `//packages:fork_vendor_verify`?** [VERIFIED: packages/BUILD.bazel]
   - What we know: `packages/BUILD.bazel` exposes selected package aliases and `packages/parity` has package-local commands. [VERIFIED: packages/BUILD.bazel; packages/parity/BUILD.bazel]
   - What's unclear: Whether vendor intake should be discoverable from `//packages` or remain package-local to avoid conflating it with parity evidence. [VERIFIED: 32-CONTEXT.md]
   - Recommendation: Add package-local `//packages/fork-vendors:verify` first; add a root/package alias only if docs need it for discoverability. [VERIFIED: 32-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Git | `verify_forks.sh` remote ref checks | yes | 2.53.0 [VERIFIED: `git --version`] | None; phase requirement depends on Git remote ref resolution. [VERIFIED: .planning/REQUIREMENTS.md] |
| Bazelisk | Maintainer target execution | yes | Bazel 8.6.0 [VERIFIED: `bazelisk --version`] | `bazel` is also available at 8.6.0. [VERIFIED: `bazel --version`] |
| Bash | Shell verifier | yes | 3.2.57 [VERIFIED: `bash --version`] | None needed; write Bash 3.2-compatible code. [VERIFIED: `bash --version`] |
| awk | TSV field extraction in shell | yes | 20200816 [VERIFIED: `awk -W version`] | Use Bash string checks for simple validations if awk becomes unnecessary. [VERIFIED: packages/parity/parity_status.sh] |
| sed | Optional local inspection | yes | BSD sed version output unavailable [VERIFIED: `command -v sed`] | Avoid relying on GNU-only sed flags. [VERIFIED: macOS environment probe] |
| curl | Research/manual release metadata inspection | yes | 8.7.1 [VERIFIED: `curl --version`] | Do not require it for the verifier. [VERIFIED: 32-CONTEXT.md] |
| jq | Research/manual JSON inspection | yes | 1.7.1 [VERIFIED: `jq --version`] | Do not require it for the verifier. [VERIFIED: 32-CONTEXT.md] |

**Missing dependencies with no fallback:** None found for Phase 32 planning. [VERIFIED: environment availability commands]

**Missing dependencies with fallback:** None found for Phase 32 planning. [VERIFIED: environment availability commands]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | No credentials or authenticated upstream APIs are required by the verifier. [VERIFIED: 32-CONTEXT.md] |
| V3 Session Management | no | No sessions are created by this metadata/verifier phase. [VERIFIED: 32-CONTEXT.md] |
| V4 Access Control | no | The phase adds checked-in metadata and a local Bazel target only. [VERIFIED: .planning/REQUIREMENTS.md] |
| V5 Input Validation | yes | Validate TSV column count, non-empty required fields, URL shape, tag kind, SHA format, delimiter rules, and caution flag vocabulary before network checks. [VERIFIED: recommended TSV schema] |
| V6 Cryptography | limited | Do not hand-roll cryptography or claim signed-tag assurance; signed-tag verification is deferred. [VERIFIED: 32-CONTEXT.md] |

### Known Threat Patterns for Git/TSV Vendor Metadata

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Release tag retargeting | Tampering | Compare `refs/tags/<tag>` and peeled commit against checked-in SHAs and fail on mismatch. [VERIFIED: git ls-remote; 32-CONTEXT.md] |
| Branch drift confused with accepted baseline | Tampering/Repudiation | Record branch heads as drift-only observations and warn without failing release pins. [VERIFIED: 32-CONTEXT.md] |
| TSV command injection | Elevation of Privilege | Never `eval` `refresh_command`; construct quoted `git ls-remote` calls from validated fields. [VERIFIED: recommended verifier pattern] |
| Non-free plugin scope creep | Information Disclosure/Supply Chain | Keep plugin cautions as metadata only and do not ingest network plugin code or credentials. [VERIFIED: raw Bambu Studio and OrcaSlicer README files; .planning/REQUIREMENTS.md] |
| Legal overclaiming | Repudiation | State that metadata is not legal review and record license source/provenance separately from normalized SPDX. [VERIFIED: 32-CONTEXT.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md` - locked phase decisions, boundaries, and deferred scope. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - VEND-01, VEND-02, VEND-03 acceptance requirements. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 32 goal and success criteria. [VERIFIED: local file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo and Bright Builds constraints. [VERIFIED: local file read]
- `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`, `docs/port/contract-inventory.md`, `docs/port/release-build-automation.md` - local docs vocabulary and package patterns. [VERIFIED: local file read]
- `packages/parity/BUILD.bazel`, `packages/parity/status.tsv`, `packages/parity/parity_status.sh`, `packages/parity/README.md` - checked-in TSV and Bazel shell target patterns. [VERIFIED: local file read]
- `git ls-remote` outputs for PrusaSlicer, Bambu Studio, and OrcaSlicer tags and HEAD refs on 2026-05-26. [VERIFIED: CLI command output]
- GitHub REST API repository, release, ref, tag, and tree endpoints for `prusa3d/PrusaSlicer`, `bambulab/BambuStudio`, and `OrcaSlicer/OrcaSlicer`. [VERIFIED: GitHub API]
- Raw upstream README/LICENSE files at selected tags:
  - https://raw.githubusercontent.com/prusa3d/PrusaSlicer/version_2.9.5/README.md [VERIFIED: curl]
  - https://raw.githubusercontent.com/prusa3d/PrusaSlicer/version_2.9.5/LICENSE [VERIFIED: curl]
  - https://raw.githubusercontent.com/bambulab/BambuStudio/v02.06.00.51/README.md [VERIFIED: curl]
  - https://raw.githubusercontent.com/bambulab/BambuStudio/v02.06.00.51/LICENSE [VERIFIED: curl]
  - https://raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/v2.3.2/README.md [VERIFIED: curl]
  - https://raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/v2.3.2/LICENSE.txt [VERIFIED: curl]
- Git documentation for `git ls-remote`: https://git-scm.com/docs/git-ls-remote [CITED: official docs]
- Bazel shell rule documentation: https://bazel.build/reference/be/shell [CITED: official docs]
- SPDX license pages:
  - https://spdx.org/licenses/AGPL-3.0.html [CITED: official SPDX]
  - https://spdx.org/licenses/AGPL-3.0-only.html [CITED: official SPDX]
  - https://spdx.org/licenses/AGPL-3.0-or-later.html [CITED: official SPDX]

### Secondary (MEDIUM confidence)

- GitHub rendered release pages for selected tags:
  - https://github.com/prusa3d/PrusaSlicer/releases/tag/version_2.9.5 [CITED: GitHub release page]
  - https://github.com/bambulab/BambuStudio/releases/tag/v02.06.00.51 [CITED: GitHub release page]
  - https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.3.2 [CITED: GitHub release page]

### Tertiary (LOW confidence)

- Web search snippets were used only to discover official pages and were cross-checked against GitHub API or raw upstream files before inclusion. [VERIFIED: web search; GitHub API; raw upstream files]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - tools are present locally and match existing repo patterns. [VERIFIED: CLI probes; packages/parity/BUILD.bazel]
- Architecture: HIGH - package shape follows locked phase decisions and existing Bazel/TSV patterns. [VERIFIED: 32-CONTEXT.md; packages/parity/BUILD.bazel]
- Upstream refs: HIGH - release tags, tag refs, peeled commits, and branch heads were verified through GitHub API and `git ls-remote`. [VERIFIED: GitHub API; git ls-remote]
- License/provenance: MEDIUM - upstream README/LICENSE evidence and SPDX pages were verified, but Phase 32 is not legal review and does not scan every file. [VERIFIED: raw upstream files; CITED: SPDX pages]
- Pitfalls: HIGH - pitfalls are directly tied to observed tag kinds, branch mutability decisions, shell environment, and repo constraints. [VERIFIED: git ls-remote; 32-CONTEXT.md; CLI probes]

**Research date:** 2026-05-26 [VERIFIED: `date -u +%Y-%m-%dT%H:%M:%SZ`]
**Valid until:** 2026-06-02 for "latest stable release" and branch-head observations; pinned tag SHA facts should remain valid unless an upstream retargets or deletes a tag. [ASSUMED]

## RESEARCH COMPLETE

**Phase:** 32 - Vendor Source Manifest and License Baseline [VERIFIED: .planning/ROADMAP.md]
**Confidence:** HIGH for upstream refs and verifier architecture; MEDIUM for normalized SPDX because legal review and file-level license scanning are out of scope. [VERIFIED: git ls-remote; GitHub API; raw upstream README/LICENSE files; 32-CONTEXT.md]

**Key findings:**

- Upstream refs are resolved for PrusaSlicer `version_2.9.5`, Bambu Studio `v02.06.00.51`, and OrcaSlicer `v2.3.2`; no upstream ref fact remains unresolved. [VERIFIED: GitHub Releases API; git ls-remote]
- Use `packages/fork-vendors/forks.tsv` plus `//packages/fork-vendors:verify` implemented as a Bazel `sh_binary` around `git ls-remote`. [VERIFIED: 32-CONTEXT.md; packages/parity/BUILD.bazel]
- Branch heads are drift-only observations and should warn without failing the release-tag acceptance gate. [VERIFIED: 32-CONTEXT.md]
- Bambu Studio and OrcaSlicer require explicit non-free/networking-plugin caution fields separate from SPDX license identifiers. [VERIFIED: raw upstream README files]
- License normalization from upstream "version 3" wording to `AGPL-3.0-only` needs legal verification before being treated as more than metadata normalization. [ASSUMED]

**File Created:** `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-RESEARCH.md` [VERIFIED: local file write]

**Open verification item:** Confirm the normalized SPDX choice with a maintainer or legal reviewer if this registry will be used for compliance decisions; Phase 32 should otherwise label the data metadata-only and not legal review. [ASSUMED]
