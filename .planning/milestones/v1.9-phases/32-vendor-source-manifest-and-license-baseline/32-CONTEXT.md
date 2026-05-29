---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 32-2026-05-26T16-14-55
generated_at: 2026-05-26T16:14:55.811Z
---

# Phase 32: Vendor Source Manifest and License Baseline - Context

**Gathered:** 2026-05-26
**Status:** Ready for planning
**Mode:** Yolo

<domain>

## Phase Boundary

Phase 32 establishes a reproducible vendor-source and license baseline for
PrusaSlicer, Bambu Studio, and OrcaSlicer. The phase should add checked-in
metadata and a repo-owned verification target that validate pinned official
source refs without importing, vendoring, cloning, or building upstream fork
source trees. Runtime fork parity, feature inventories, fork-flavor builds,
online integrations, non-free plugin ingestion, and full drift-refresh protocol
templates remain out of scope for this phase.

</domain>

<decisions>

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

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### GSD Phase Scope

- `.planning/PROJECT.md` - Current milestone context, constraints, and
  out-of-scope boundaries for v1.9 fork vendor intake.
- `.planning/REQUIREMENTS.md` - VEND-01, VEND-02, and VEND-03 acceptance
  requirements and v1.9 exclusions.
- `.planning/ROADMAP.md` - Phase 32 goal, success criteria, dependencies, and
  requirement mapping.
- `.planning/STATE.md` - Current GSD state and active phase.

### Repo and Standards Guidance

- `AGENTS.md` - Repo-local summary metadata rules and Bright Builds routing
  requirements.
- `AGENTS.bright-builds.md` - Bright Builds workflow defaults, sync-first
  guidance, verification expectations, and task artifact rules.
- `standards-overrides.md` - Repo-local standards override surface.

### Existing Port Documentation

- `docs/port/README.md` - Existing docs source-of-truth structure, status
  vocabulary, and review expectations.
- `docs/port/package-map.md` - Existing package ownership boundaries and
  package documentation pattern.
- `docs/port/migration-guidance.md` - Conservative parity vocabulary and
  deferred scope rules.
- `docs/port/parity-matrix.md` - Current parity status vocabulary and evidence
  framing.
- `docs/port/contract-inventory.md` - Existing registry style for source of
  truth, evidence, scope notes, and deferred parity language.
- `docs/port/release-build-automation.md` - Existing provenance and evidence
  gate wording to keep metadata terminology consistent.

### Existing Build and Verification Patterns

- `packages/BUILD.bazel` - Root-facing package alias pattern.
- `packages/parity/BUILD.bazel` - Bazel `sh_binary` pattern for checked-in data
  source verification commands.
- `packages/parity/README.md` - Package-local documentation style for
  maintainer commands and conservative scope.
- `packages/parity/status.tsv` - Existing checked-in TSV data source pattern.

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- `packages/parity/status.tsv` provides a simple checked-in TSV data source
  pattern that can be mirrored for vendor refs.
- `packages/parity/BUILD.bazel` shows the repo's current Bazel-owned shell
  command pattern for visibility and parity checks.
- `docs/port/README.md`, `docs/port/package-map.md`, and
  `packages/parity/README.md` provide the documentation style for a new package
  boundary and maintainer-facing command list.

### Established Patterns

- Port documentation uses conservative status vocabulary and distinguishes
  verified parity from source-only or deferred evidence.
- Bazel is the top-level verification entrypoint; package-local commands are
  exposed through `BUILD.bazel` targets and root/package aliases when useful.
- Docs and package metadata move together when a change touches Rust-port
  behavior, parity surfaces, launcher boundaries, fixture protocol, or package
  ownership.

### Integration Points

- Add a new `packages/fork-vendors` package for Phase 32 artifacts.
- Link the new package and maintainer command from `docs/port/README.md` and
  `docs/port/package-map.md`.
- Add a root or `packages` alias only if it improves discoverability without
  conflating vendor source intake with `packages/parity`.

</code_context>

<specifics>

## Specific Ideas

- Prefer `git ls-remote` over GitHub API calls or shallow fetches for the Phase
  32 verifier because it is provider-neutral, installed with Git, and supports
  remote ref and peeled-tag inspection without cloning.
- Avoid parser dependencies in Phase 32. A TSV plus shell verifier is enough
  for three vendor rows and aligns with current repo practice.
- Make docs state that branch heads are drift observations. The selected stable
  tag and peeled commit are the accepted source baseline.
- Use caution flags for non-free networking plugin and cloud/network surfaces
  so later phases can see the issue without treating it as license expression or
  implementation scope.

</specifics>

<deferred>

## Deferred Ideas

- Formal SBOM or external compliance tooling belongs to a later compliance
  milestone if needed.
- Signed tag verification, tag object audit, or shallow object fetching belongs
  to a later hardening or vendor-refresh phase.
- Full drift-refresh protocol templates remain Phase 36 scope.
- Fork runtime parity, fork-flavor release builds, GUI migration, cloud/network
  integrations, and non-free plugin ingestion remain future milestones.

</deferred>

---

*Phase: 32-vendor-source-manifest-and-license-baseline*
*Context gathered: 2026-05-26*
