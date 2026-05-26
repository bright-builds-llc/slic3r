# Project Research Summary

**Project:** Slic3r Rust Port
**Domain:** v1.9 fork vendor intake and modular Rust flavor architecture
**Researched:** 2026-05-26
**Confidence:** HIGH for v1.9 intake and architecture direction; MEDIUM for future fork parity coverage

## Executive Summary

v1.9 is a vendor-intake and architecture milestone for a brownfield Rust port
of Slic3r. It should prepare future PrusaSlicer, Bambu Studio, and OrcaSlicer
parity work without importing those large C++ codebases or creating separate
Rust forks. Experts would treat the downstream slicers as pinned evidence
sources first: capture official repository refs, stable release tags, peeled
commits, licenses, lineage, feature inventories, and explicit deferrals before
any implementation phase claims support.

The recommended approach is narrow and manifest-driven. Add a checked-in fork
vendor manifest, validation target, source-pinned feature inventory templates,
and a small typed Rust flavor metadata layer. Keep source checkouts optional,
gitignored, and human-operated for inventory work only. Prefer release tags and
peeled commits over branch heads, and prefer one shared flavor registry over
vendor-specific Rust workspaces or broad Cargo feature switches.

The main risks are non-reproducible source references, marketing-list feature
inventories, overclaimed fork parity, licensing mistakes around AGPL and
optional non-free/network components, and hidden release-scope expansion.
Mitigate them by making `vendor-pinned`, `inventoried`, `planned`, `deferred`,
and `verified` distinct states; by refusing fork parity rows until executable
evidence exists; and by keeping GUI, release channels, fork-flavor builds,
nightly sync, cloud/device integrations, and profile auto-update execution
explicitly out of v1.9 scope.

## Key Findings

### Recommended Stack

v1.9 should stay on the existing Bazel/Rust stack and add only a small
metadata, docs, and validation layer. The research consistently rejects
submodules, vendored source copies, Bzlmod external repos for upstream fork
trees, and C++ build ingestion for this milestone. The fork sources are
references, not production build inputs.

**Core technologies:**

- Bazel + Bzlmod, repo-pinned at Bazel 8.6.0: keep one top-level build/test
  entrypoint and add ordinary validation targets for vendor metadata.
- `rules_rust` 0.69.0: keep Rust crates, tests, clippy, and rustfmt under the
  existing Bazel integration.
- Rust stable 1.94.1, edition 2024: model flavor IDs, vendor source pins,
  feature origins, and checklist states as typed, std-only domain values.
- Git CLI: verify official upstream tags and commits with `git ls-remote`
  without cloning the full fork repositories in CI.
- TSV manifest: use a small checked-in line-oriented manifest for fork source
  truth, matching the repo's existing TSV parity-status style.
- Markdown inventory and checklist templates: keep feature classification
  reviewable and explicit instead of pretending README summaries are parity
  evidence.
- `slic3r_flavors` crate: add a pure, std-only registry for flavor metadata if
  v1.9 needs Rust code; keep Git, filesystem, networking, and implementation
  behavior out of this crate.

**Pinned vendor baseline:**

- PrusaSlicer: official repo `prusa3d/PrusaSlicer`, stable tag
  `version_2.9.5`, peeled commit
  `9a583bd438b195856f3bcf7ea99b69ba4003a961`.
- Bambu Studio: official repo `bambulab/BambuStudio`, stable tag
  `v02.06.00.51`, peeled commit
  `b506005bc4ee62124e24bf00e0f58656db3646a6`.
- OrcaSlicer: official repo `OrcaSlicer/OrcaSlicer`, stable tag `v2.3.2`,
  peeled commit `c724a3f5f51c52336624b689e846c8fbc943a912`.

Default branch heads should be recorded as drift context only. They should not
be the canonical v1.9 inventory baseline.

### Expected Features

The v1.9 feature set is primarily maintainer-facing. It should produce
reproducible source references, structured inventories, typed module metadata,
and future parity templates. It should not port downstream algorithms, GUI
flows, profile loaders, cloud integrations, release channels, or fork builds.

**Must have (table stakes):**

- Vendor source registry for PrusaSlicer, Bambu Studio, and OrcaSlicer with
  official URL, selected release/tag, peeled commit, observed default-branch
  head, capture date, license, lineage, source paths, and refresh command.
- Fork lineage model that distinguishes base Slic3r, shared downstream
  Prusa-family behavior, Bambu-specific behavior, Orca-specific behavior, and
  unknown rows needing review.
- Feature inventory template with source evidence, ownership classification,
  surface, complexity, dependency on existing parity surfaces, and v1.9
  decision.
- Per-fork initial inventories for PrusaSlicer, Bambu Studio, and OrcaSlicer,
  plus shared downstream classification where at least two source-backed forks
  justify it.
- Dependency mapping to current verified parity surfaces such as CLI help,
  version, config persistence, export, transform, runtime, packaging-visible
  launcher, and release artifacts.
- Modular flavor metadata and contracts so future fork behavior can plug into
  the Rust workspace without copying `slic3r_core` or creating separate Rust
  workspaces per vendor.
- Parity checklist and documentation templates that include source pin,
  inventory row ID, candidate module, fixture need, evidence command, docs
  touched, license/security note, and deferred scope.
- Exclusion ledger that keeps full fork parity, GUI migration, fork-flavor
  release builds, nightly vendor sync, cloud/device integrations, and profile
  auto-update execution out of v1.9.

**Should have (differentiators):**

- Cross-fork feature matrix generated or derived from structured inventory
  rows, not maintained only as prose.
- Source-pinned evidence per feature using official upstream repositories,
  release metadata, repo paths, wiki pages, or source files.
- Risk-ranked future parity backlog that separates inventory-only work from
  implementable CLI/config/profile/export surfaces.
- Shared downstream module candidate markers for behavior that should become a
  shared Rust capability rather than duplicated fork-local code.
- Profile schema comparison notes for Prusa INI/IDX bundles versus Bambu/Orca
  JSON profile trees, kept as analysis rather than loaders.
- Non-free/network boundary marker for Bambu/Orca remote printer integrations
  and optional networking plugins.
- Fixture-seeding recommendations for future parity work, without adding broad
  fork fixture corpora before executable behavior exists.

**Defer (v2+ or later v1.x):**

- Full PrusaSlicer, Bambu Studio, or OrcaSlicer runtime parity.
- Wholesale downstream source import, Git submodules as normal inputs, or Git
  subtree vendoring.
- Vendor-specific Rust core crates with copied base behavior.
- Fork-flavor release packages, signing/notarization/installers, release
  channels, or GitHub Actions matrices.
- GUI migration or GUI feature parity.
- Network printer/cloud implementation, real credentials, optional non-free
  plugin ingestion, or vendor service calls.
- Profile update/download execution and online profile-distribution support.
- Nightly vendor sync or automated merge assistance.

### Architecture Approach

Fork intake should be an evidence layer beside the existing Rust migration.
The legacy Slic3r package remains the base parity oracle. The fork repositories
enter the repo as pinned references, feature inventories, typed metadata, and
future parity checklist inputs. Runtime fork support is a later milestone.

**Major components:**

1. `packages/fork-vendors` - recommended manifest package for official fork
   source pins, license notes, lineage, and Bazel-visible validation. The
   architecture research used `packages/vendor-forks` in places; resolve the
   naming tension by choosing `packages/fork-vendors` for v1.9 because the
   stack research already defines its `forks.tsv` and verify target shape.
2. `docs/port/forks` - human-facing inventories, fork delta docs, parity
   checklist templates, source strategy notes, and explicit deferrals.
3. `slic3r_contracts` - stable domain types for flavor IDs, downstream fork
   IDs, vendor source IDs, feature origin, parity surface, and checklist
   status. Raw strings should be parsed here before reaching core code.
4. `slic3r_flavors` - pure registry/composition crate for base, shared
   downstream, and fork-specific metadata. It must not perform Git, network,
   filesystem, or process I/O.
5. `slic3r_core` - remains base reusable behavior. It should receive typed
   policies or feature sets, not know about vendor docs, branch names, or raw
   fork strings.
6. `slic3r_cli` and `packages/launcher` - future thin shell and entrypoint
   owners for flavor selection after metadata is typed. Do not add flavor
   package claims in v1.9.
7. `packages/parity` and `packages/parity-fixtures` - future fork evidence
   namespace and fixture provenance. v1.9 may define templates and naming, but
   should not mark any fork runtime surface verified.

### Critical Pitfalls

1. **Branch-named vendor references** - avoid with release tags, peeled
   commits, capture dates, official source URLs, and manifest validation.
2. **AGPL treated as a checkbox** - record SPDX IDs, license file URLs,
   attribution, optional non-free component notes, and excluded binaries/plugins.
3. **Marketing-list inventories** - require source refs, surfaces,
   classification, candidate module, evidence need, and v1.9 decision on every
   row.
4. **Overclaimed parity from intake artifacts** - use narrow status vocabulary
   and reserve `verified` for future executable parity evidence.
5. **Three Rust codebase forks** - model capability families and typed flavor
   composition instead of vendor-specific copies or core `if flavor == ...`
   conditionals.
6. **Hidden release scope expansion** - keep fork builds, signing, installers,
   release channels, and CI matrices deferred until fork parity modules exist.
7. **Network/cloud feature leakage** - classify remote control, monitoring,
   cloud, LAN, credentials, and optional networking plugins as deferred
   security/licensing review surfaces.

## Implications for Roadmap

Based on research, the roadmap should use this v1.9 phase structure:

### Phase 1: Vendor Source Manifest and License Baseline

**Rationale:** Inventories and module decisions need reproducible source truth
first. Branch heads and "latest" labels are not stable enough for future parity
work.

**Delivers:** `packages/fork-vendors`, `forks.tsv`, official repo URLs, stable
release tags, peeled commits, observed branch heads, capture timestamps,
license fields, non-free/network notes, update policy, and
`//packages/fork-vendors:verify`.

**Addresses:** vendor source registry, fork lineage model, upstream source
verification, license baseline.

**Avoids:** branch-named references, AGPL/provenance gaps, unofficial download
sources, and premature source vendoring.

### Phase 2: Inventory Templates and Source-Pinned Fork Inventories

**Rationale:** Feature rows must be classified before they become roadmap or
module work. Bambu and Orca inherit substantial Prusa-family behavior, so
brand-first inventories will duplicate shared behavior.

**Delivers:** `docs/port/forks`, feature inventory template, parity checklist
template draft, per-fork Prusa/Bambu/Orca inventories, shared downstream
inventory, cross-fork category map, and deferred-scope ledger.

**Uses:** pinned manifest source IDs, official upstream docs/repos, existing
`docs/port` parity vocabulary.

**Avoids:** marketing-list inventories, treating fork-specific behavior as
universal, network/cloud leakage, and stale inventory ambiguity.

### Phase 3: Rust Flavor Contracts

**Rationale:** Typed contracts should exist before runtime modules so illegal
states are ruled out at the boundary. The Rust port should parse raw flavor and
source strings once, then pass domain values through pure logic.

**Delivers:** `ForkFlavor`, `DownstreamFork`, `FeatureOrigin`,
`VendorSourceId`, `FeatureId`, `ParitySurface`, and checklist status types in
`slic3r_contracts`, with focused unit tests.

**Implements:** modular Rust metadata/contracts for base Slic3r, shared
downstream behavior, and fork-specific behavior.

**Avoids:** raw vendor strings in core logic, invalid flavor/source
combinations, and broad compile-time feature switches.

### Phase 4: Flavor Registry Boundary

**Rationale:** One registry should describe composition before any fork module
ports behavior. This creates a single place to map base, shared downstream, and
fork-specific metadata without forking the Rust workspace.

**Delivers:** std-only `slic3r_flavors` crate or documented pre-crate module
boundary, pure registry functions, source-pin metadata mirrors, and metadata
tests. It should not expose runtime support claims.

**Uses:** `slic3r_contracts`, the manifest baseline, inventory ownership
labels, and Bright Builds functional-core guidance.

**Avoids:** vendor-specific core copies, core dependencies on fork crates, and
feature-flag soup.

### Phase 5: Parity, Fixture, Launcher, and Deferral Templates

**Rationale:** Future fork support needs a repeatable evidence ladder, but
v1.9 should stop at templates and vocabulary. Runtime support should not be
inferred from source pins or inventories.

**Delivers:** fork parity checklist template, optional `fork-status.tsv`
template or documented row shape, fixture namespace conventions under
`packages/parity-fixtures/forks/`, future launcher target shape, manual drift
refresh instructions, and explicit release/network/GUI deferrals.

**Addresses:** parity checklist templates, documentation templates, future
fixture planning, status vocabulary, and release-scope boundaries.

**Avoids:** overclaimed fork support, generic checklists, fork rows marked
verified, accidental release workflow changes, and nightly sync scope creep.

### Phase Ordering Rationale

- Vendor pins must precede inventories because every feature claim needs a
  reproducible source ref.
- Inventories must precede Rust module decisions because shared downstream
  behavior should be discovered before code boundaries harden.
- Contract types should precede the registry so raw source/CLI/manifest data is
  parsed into valid domain values first.
- The registry should precede parity/launcher templates so future entrypoints
  select typed flavor metadata instead of brand strings.
- Parity and release templates come last because they must communicate future
  evidence requirements without claiming runtime fork support.

### Research Flags

Phases likely needing deeper research during planning:

- **Phase 2:** Exact per-fork inventories need source-level validation beyond
  README/wiki feature bullets, especially CLI deltas, profile schemas, support
  behavior, calibration tooling, and Orca community profile handling.
- **Phase 5:** Any movement beyond templates into network/cloud, release
  automation, installers, or fork-flavor packaging requires separate legal,
  security, and release engineering research.

Phases with standard patterns where `/gsd-research-phase` should usually be
skipped:

- **Phase 1:** Manifest validation with Git `ls-remote`, TSV parsing, and
  license metadata is well understood. Verify pins, but do not re-research the
  architecture.
- **Phase 3:** Rust contract types follow established repo and Bright Builds
  patterns: parse at boundaries, newtypes/enums, unit tests.
- **Phase 4:** A pure std-only flavor registry is a standard Rust composition
  boundary as long as it remains metadata-only.
- **Phase 5:** Checklist and fixture namespace templates can follow existing
  `docs/port`, `packages/parity`, and `packages/parity-fixtures` patterns.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Current repo pins, Bazel/Rust surfaces, and official upstream refs support a narrow metadata-and-validation stack. No new dependencies are needed. |
| Features | HIGH for v1.9, MEDIUM for future parity | The v1.9 deliverables are clear. Exact downstream behavior still needs source-level inventories before implementation phases. |
| Architecture | HIGH for intake boundaries, MEDIUM for future modules | Manifest, docs, contracts, and registry boundaries are well supported. Future fork behavior ownership depends on inventory evidence. |
| Pitfalls | HIGH | Process, scope, licensing, source-control, and overclaiming risks are strongly evidenced across all research files. |

**Overall confidence:** HIGH for the v1.9 roadmap; MEDIUM for downstream fork
parity after v1.9.

### Gaps to Address

- **Package naming tension:** Stack recommends `packages/fork-vendors`, while
  architecture uses `packages/vendor-forks` in places. Use
  `packages/fork-vendors` for v1.9 to match the fork vendor intake language and
  concrete verify-target proposal.
- **Manifest versus source checkout tension:** Prefer manifest-only CI and
  optional gitignored partial clones for human inventory work. Require explicit
  future evidence before submodules, source vendoring, or build ingestion.
- **Taxonomy tension:** Features research uses `shared-prusa-family`,
  `bambu-specific`, and `orca-specific`; stack architecture uses
  `base-slic3r`, `shared-downstream`, and `fork-specific`. Use the broader
  Rust/domain taxonomy in code and allow inventory rows to add fork-family
  detail as a subcategory.
- **Contracts versus registry timing:** Add contract types first. Add
  `slic3r_flavors` in v1.9 only if it remains pure metadata/registry code; do
  not add empty fork behavior crates.
- **License/network policy:** Bambu and Orca optional networking components
  need explicit future legal/security review before implementation. v1.9 should
  only inventory and defer them.
- **Profile schema depth:** Prusa INI/IDX and Bambu/Orca JSON profile trees are
  important future surfaces, but v1.9 should stop at schema-family inventory
  and representative source paths.
- **Drift protocol:** Record capture dates, observed heads, and refresh
  commands now. Automated nightly sync remains deferred until fork modules and
  parity evidence exist.

## Sources

### Primary (HIGH confidence)

- `.planning/PROJECT.md` - v1.9 milestone goal, active requirements, current
  verified parity surface, and out-of-scope boundaries.
- `.planning/research/STACK.md` - recommended Bazel/Rust/Git/TSV stack,
  release pins, crate/package suggestions, and source-vendoring alternatives.
- `.planning/research/FEATURES.md` - v1.9 table stakes, differentiators,
  anti-features, dependency notes, inventory row shape, and competitor feature
  observations.
- `.planning/research/ARCHITECTURE.md` - evidence-layer architecture, component
  responsibilities, data flow, build order, and roadmap implications.
- `.planning/research/PITFALLS.md` - critical source-control, licensing,
  parity, module, release, network, and checklist pitfalls.
- Official upstream repositories: `https://github.com/prusa3d/PrusaSlicer`,
  `https://github.com/bambulab/BambuStudio`, and
  `https://github.com/OrcaSlicer/OrcaSlicer`.

### Secondary (MEDIUM confidence)

- Upstream wiki/release/profile observations captured by the research files for
  PrusaSlicer, Bambu Studio, and OrcaSlicer feature families.
- Bright Builds repo guidance and pinned standards at commit
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676`, especially architecture,
  code-shape, verification, and Rust guidance.

### Tertiary (LOW confidence)

- None used as source truth. Unofficial download sites, mirrors, blogs, and
  community guides should remain discovery-only unless verified against
  official upstream source.

---
*Research completed: 2026-05-26*
*Ready for roadmap: yes*
