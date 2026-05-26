# Pitfalls Research

**Domain:** v1.9 fork vendor intake and modular Slic3r-family Rust architecture
**Researched:** 2026-05-26
**Confidence:** HIGH for process, licensing, source-control, and scope-control pitfalls; MEDIUM for exact fork feature completeness until v1.9 performs source-level inventories.

## Context Snapshot

v1.9 is not a fork-port milestone. It should establish pinned vendor references, checked-in feature inventories, Rust module boundaries, and parity checklist templates for later PrusaSlicer, Bambu Studio, and OrcaSlicer parity milestones. Full fork parity ports, fork-flavor builds, GUI work, signing, notarization, installers, release channels, and nightly vendor sync remain out of scope.

The upstreams are active and legally coupled enough that casual intake is risky:

| Upstream | Current primary evidence checked | Why it matters |
|----------|----------------------------------|----------------|
| Slic3r | AGPL-3.0 repo; latest GitHub release `1.3.0` from 2018; default branch `master` at `026c1380e0ad12176dd2fc8cdf8f6f181deeb071` during research | Base lineage and current repo's legacy oracle |
| PrusaSlicer | AGPL-3.0 repo; latest release `version_2.9.5` published 2026-05-19; default branch `master` at `9a583bd438b195856f3bcf7ea99b69ba4003a961` during research | First downstream fork target and likely shared downstream base |
| Bambu Studio | AGPL-3.0 repo; latest release `v02.06.00.51` published 2026-04-17; default branch `master` at `e150b502b3d2afc98b83dcc9e5720e998f9eb79a` during research | Vendor-specific behavior plus explicit non-free optional networking plugin note |
| OrcaSlicer | AGPL-3.0 repo; latest official release `v2.3.2` published 2026-03-23; default branch `main` at `398e007f2ec567ea56d3993864d03f52b210cbf3` during research | Broad downstream community fork with official-site phishing warnings and many integration features |

## Critical Pitfalls

### Pitfall 1: Branch-Named Vendor References That Are Not Reproducible

**What goes wrong:**
The repo records "PrusaSlicer master", "Bambu Studio latest", or "OrcaSlicer v2.3" as a source reference, but does not capture the exact commit, release tag, capture date, license file path, and update policy. Later inventories and roadmap phases then target a moving upstream, so re-running the same intake produces different feature lists.

**Why it happens:**
Vendor intake feels like documentation, not supply-chain state. GitHub pages make the default branch and latest release easy to read, while the real reproducibility contract is the commit SHA or locked mirror state. Git submodules can also look pinned in the tree while a developer has a different checked-out commit locally.

**How to avoid:**
Create a vendor-source manifest before writing feature inventories. Each vendor row should include upstream URL, default branch, exact commit SHA, optional release tag, release date when applicable, capture timestamp, license identifier, license file URL, local mirror/submodule path if used, and explicit update owner. If submodules are used, commit the superproject pointer and verify `git submodule status --cached`; do not use routine `update --remote` in v1.9 work. Record "latest upstream at intake" separately from "pinned source used for inventory".

**Warning signs:**
Docs say "latest", "current", or "master" without a SHA. A feature row cannot answer which upstream commit it came from. `git submodule status` shows a `+` prefix for a local checkout mismatch. Feature counts change after a fresh clone without an intentional vendor update.

**Phase to address:**
Recommended v1.9 Phase 1: Vendor Source Intake and License Baseline.

---

### Pitfall 2: Treating AGPL-3.0 as a Checkbox Instead of an Operating Constraint

**What goes wrong:**
The project correctly notices that Slic3r, PrusaSlicer, Bambu Studio, and OrcaSlicer are AGPL-3.0, but fails to carry license obligations into vendor manifests, fork module decisions, parity templates, notices, and future release planning. The highest-risk version is importing source snippets, generated data, or network/plugin assumptions without attribution, license provenance, or a review gate.

**Why it happens:**
AGPL repositories are open, so it is tempting to treat their code and feature behavior as a free idea pool. The Bambu and Orca READMEs also call out optional Bambu networking plugins based on non-free libraries, which creates a sharp edge: "fork source is AGPL" does not mean every adjacent binary, service, or integration is safe to vendor or emulate in v1.9.

**How to avoid:**
Make the vendor manifest license-aware. For each fork, record SPDX ID, license file URL, upstream attribution, known additional license notes, and "excluded proprietary/non-free components" if present. Require a license gate before copying code, assets, generated config bundles, tests, network protocol code, or release assets. In v1.9, inventory non-free or cloud/network pieces as deferred and security-reviewed; do not vendor binaries or build network-plugin behavior.

**Warning signs:**
The only license field is "AGPL" with no source URL. Bambu networking behavior is assigned to a Rust module without a license/security note. Checklists mention future release artifacts but not corresponding source availability. Source snippets appear in docs or Rust code without upstream file, commit, and license attribution.

**Phase to address:**
Recommended v1.9 Phase 1: Vendor Source Intake and License Baseline, with a checklist gate repeated in the parity-template phase.

---

### Pitfall 3: Feature Inventories Collapse Into Marketing Lists

**What goes wrong:**
Inventories copy README feature bullets such as "advanced support", "remote control", "multi-material", or "calibration tools", but do not map those claims to concrete contracts. Later port phases cannot tell whether a row is a config key, CLI behavior, GUI workflow, algorithmic behavior, preset bundle, G-code dialect, network integration, or packaging concern.

**Why it happens:**
README features are easy to gather and look impressive. They are not designed to be parity checklists. Forks also inherit features from earlier projects, so the same marketing label can mean base Slic3r behavior, PrusaSlicer shared downstream behavior, Bambu-specific behavior, or Orca-specific behavior depending on source history.

**How to avoid:**
Use a strict row schema for inventories. Every row should include `vendor`, `classification` (`base-slic3r`, `shared-downstream`, `fork-specific`, `unknown-pending-source-review`), `surface` (`config`, `CLI`, `GUI`, `algorithm`, `preset`, `network`, `packaging`, `docs`), `source_ref`, `upstream_path_or_url`, `captured_commit`, `candidate_rust_module`, `parity_status`, `evidence_needed`, and `v1.9_scope` (`inventory-only`, `template-only`, `deferred`). Treat README bullets as discovery leads, not final inventory rows.

**Warning signs:**
Inventory rows have no upstream path or commit. The same feature appears in all three fork files with different wording and no classification. Rows use adjectives instead of observable behavior. No row can be converted into a future parity test or documentation checklist.

**Phase to address:**
Recommended v1.9 Phase 2: Fork Feature Inventory Baseline.

---

### Pitfall 4: Overclaiming Parity From Intake Artifacts

**What goes wrong:**
Pinned vendor references, feature inventories, and checklist templates make the repo look closer to supporting PrusaSlicer, Bambu Studio, or OrcaSlicer than it really is. Users or maintainers infer fork support, fork builds, or verified parity before any Rust-backed fork module exists.

**Why it happens:**
The existing migration process already uses parity status and release evidence. New fork documentation can accidentally reuse strong words like "supported", "verified", "compatible", or "release" because those words are present in prior shipped milestones.

**How to avoid:**
Add v1.9 status vocabulary and use it consistently: `vendor-pinned`, `inventoried`, `module-boundary-planned`, `checklist-template-ready`, `deferred`, and `verified` only after a future fork parity command passes. Do not add Prusa/Bambu/Orca rows to verified parity status. Do not mention fork-flavor builds in release automation docs except as explicitly deferred future work.

**Warning signs:**
`packages/parity/status.tsv` gains fork rows marked `verified`. The README or migration docs say the Rust port "supports" Bambu or Orca because an inventory exists. Release docs mention fork package outputs. Checklists are pre-checked or imply all inventory rows are committed scope.

**Phase to address:**
Recommended v1.9 Phase 4: Parity Checklist Templates and Scope Documentation.

---

### Pitfall 5: Module Architecture Creates Three Rust Codebase Forks

**What goes wrong:**
The Rust workspace grows `slic3r_prusa_core`, `slic3r_bambu_core`, and `slic3r_orca_core` copies, or the base core fills with `if flavor == ...` conditionals. The project avoids forking the repository but recreates the same maintenance problem inside Rust package boundaries.

**Why it happens:**
Fork features are easiest to understand by vendor name. Without a module taxonomy, implementers map vendor identity directly to crates and then copy base concepts into each fork. This feels safe for the first fork and becomes unmaintainable by the third.

**How to avoid:**
Design modules around capability families, not vendor brands. Base contracts and core slicing behavior stay shared. Fork packages should compose extension providers for config schema additions, preset catalogs, G-code dialect behavior, calibration generators, support/infill variants, and UI-visible metadata. Dependency direction should be one-way: flavor packages depend on base contracts/core; base core does not depend on flavor packages. The parity harness chooses a flavor provider; the core should not know about every downstream brand.

**Warning signs:**
Core code imports a fork crate. Shared config structs are duplicated with vendor prefixes. Build features such as `bambu`, `orca`, and `prusa` gate large parts of the core. Package names encode vendors but no capability boundary. The package map cannot answer where a shared downstream feature should live.

**Phase to address:**
Recommended v1.9 Phase 3: Modular Fork Package Architecture.

---

### Pitfall 6: Hidden Release Scope Expansion

**What goes wrong:**
Because upstream forks publish installers, AppImages, DMGs, cloud features, GUI workflows, and printer-specific packaging, v1.9 drifts from intake and architecture into release engineering or product support. This undermines the milestone and conflicts with the current project decision to keep fork-flavor builds, signing, installers, release channels, GUI work, and full fork parity ports out of scope.

**Why it happens:**
Vendor fork features are user-visible. Once a feature appears in an inventory, it is easy to treat it as committed scope. Release-build automation from v1.8 is also available, so adding fork flavors can look like a small matrix extension even though no fork parity exists yet.

**How to avoid:**
Every vendor, inventory, module, and checklist document should carry an explicit v1.9 boundary: intake and templates only. Add a required `deferred_reason` field for rows involving installers, signed/notarized artifacts, AppImage/MSI/DMG, GUI workflows, release channels, cloud services, printer account authentication, or fork-flavor CI builds. Do not touch release workflows except to keep future fork builds explicitly deferred.

**Warning signs:**
New GitHub Actions matrices include fork flavors. Vendor docs link to binary release assets as implementation inputs. A v1.9 phase starts adding GUI, cloud, signing, or installer tasks. "Just one representative fork build" appears as acceptance criteria.

**Phase to address:**
Recommended v1.9 Phase 4: Parity Checklist Templates and Scope Documentation.

---

### Pitfall 7: Vendor Drift Is Invisible Until v1.10+

**What goes wrong:**
Inventories are correct on the day they are written, then upstream forks move. By the time v1.10, v1.11, or v1.12 starts, the vendor pins, latest release notes, README feature lists, and source files have drifted. The next milestone begins by debugging stale research instead of porting.

**Why it happens:**
PrusaSlicer, Bambu Studio, and OrcaSlicer are active. v1.9 explicitly excludes nightly sync automation, so drift will happen unless the manual refresh protocol is visible and cheap.

**How to avoid:**
For each vendor, record `captured_at`, `pinned_commit`, `upstream_head_at_capture`, `latest_release_at_capture`, and `refresh_command`. Add a stale-inventory rule such as "before any fork parity phase, rerun vendor refresh and record whether the pinned commit changed." Keep this as a manual checklist in v1.9; reserve automated nightly sync for the later roadmap.

**Warning signs:**
Inventory files lack dates. A future phase references "current OrcaSlicer" but the recorded commit is weeks or months old. No command exists to compare pinned refs to upstream heads. Reviewers cannot tell whether a feature was omitted intentionally or added upstream after intake.

**Phase to address:**
Recommended v1.9 Phase 1 for source manifest fields and Phase 2 for inventory refresh rules.

---

### Pitfall 8: Network and Cloud Features Are Treated Like Ordinary Slicing Features

**What goes wrong:**
Remote control, monitoring, printer account integrations, LAN/cloud behavior, and optional networking plugins are inventoried as normal fork features and assigned to ordinary Rust modules. This bypasses licensing, privacy, credential, and threat-model review.

**Why it happens:**
Modern fork READMEs advertise remote control and network integrations alongside slicing features. In a slicer UI they feel like product features, but they are different from local G-code generation because they can touch credentials, cloud services, LAN devices, proprietary components, and user identity.

**How to avoid:**
Classify network and cloud rows separately. In v1.9 they should be `inventory-only` and `deferred-security-review`, with notes distinguishing local-device protocols from vendor cloud services and non-free plugins. Parity templates should require explicit test isolation, fake credentials, and source/licensing review before any future implementation. No v1.9 phase should download network plugins, require cloud credentials, or call vendor services.

**Warning signs:**
Inventory rows mention "remote monitoring" without a trust boundary. Tests require real account credentials. Bambu networking plugin behavior appears in a core module plan. A checklist asks only "does remote print work?" instead of asking what source, protocol, credentials, and license evidence are involved.

**Phase to address:**
Recommended v1.9 Phase 2: Fork Feature Inventory Baseline, with security notes carried into Phase 4 templates.

---

### Pitfall 9: Parity Checklist Templates Are Too Generic To Drive Future Work

**What goes wrong:**
The repo creates a checklist template, but it only asks whether a feature is done. Future port phases still have to rediscover source references, classification, module ownership, fixture needs, evidence commands, exclusions, and review gates.

**Why it happens:**
Templates are often written as documentation aids instead of executable planning aids. For this project, checklists must bridge vendor intake, Rust module ownership, parity evidence, and docs without claiming implementation.

**How to avoid:**
Make checklist templates structured enough to become future phase inputs. Required fields should include inventory row ID, vendor, upstream commit, upstream path or URL, feature classification, surface, candidate Rust module, implementation status, fixture/provenance requirement, expected evidence command, docs touched, license/security notes, deferred scope, and reviewer signoff. Include an explicit "not parity until evidence command exists and passes" note.

**Warning signs:**
The template has checkboxes but no evidence command field. It cannot identify which inventory row it came from. It has no source commit field. It does not include an exclusion/deferred field. Reviewers still ask "where should this module live?"

**Phase to address:**
Recommended v1.9 Phase 4: Parity Checklist Templates and Scope Documentation.

---

### Pitfall 10: Official Source Confusion and Download Spoofing

**What goes wrong:**
The project links to unofficial sites, mirrors, or release assets as authoritative vendor sources. This can poison vendor intake with stale documentation, malware-risk downloads, or incorrect licensing claims.

**Why it happens:**
Slicer forks have many community pages, download mirrors, guides, and SEO-heavy sites. OrcaSlicer's own README warns about clickbait and malicious lookalike sites. Search results also mix official repos, third-party guides, and news coverage.

**How to avoid:**
Treat official GitHub repositories and official project sites as primary intake sources. Use GitHub API or `git ls-remote` for refs and releases. Do not download release binaries for v1.9 research or implementation. If a non-primary source is useful, mark it as discovery-only and verify against official upstream source before adding a finding.

**Warning signs:**
Vendor manifest URLs point to unofficial download domains. A feature row cites a blog or guide but no upstream source. Docs tell users to download or install a fork binary. License claims come from search snippets instead of upstream repositories or license files.

**Phase to address:**
Recommended v1.9 Phase 1: Vendor Source Intake and License Baseline.

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Record vendor branches instead of exact commits | Fast intake doc | Non-reproducible inventories and impossible future parity diffs | Never |
| Copy README feature lists directly into inventories | Looks comprehensive quickly | Marketing text replaces testable contracts | Only as discovery notes, never as final rows |
| Create one Rust crate per vendor fork with copied base logic | Clear first implementation path | Three Rust forks to maintain, plus shared fixes must be ported repeatedly | Never for core logic |
| Use Cargo features for broad vendor behavior switches in the core | Simple compile-time selection | Conditional core sprawl and hard-to-test flavor combinations | Only for tiny build integration toggles, not domain behavior |
| Include release assets or installer behavior in intake | Makes fork support feel tangible | Scope expansion into signing, packaging, and binary supply-chain review | Never in v1.9 |
| Leave network/cloud features in the normal feature bucket | Avoids difficult security questions | Credentials, proprietary plugin, privacy, and legal risks appear later | Never |
| Write checklist templates with checkboxes only | Quick documentation artifact | Future phases still lack source, module, fixture, and evidence requirements | Never |
| Let inventories age without a refresh protocol | Less process today | v1.10+ starts from stale source assumptions | Acceptable only if every inventory is clearly marked stale and blocked before port work |

## Integration Gotchas

Common mistakes when connecting vendor intake to the migration repo.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Git submodules or mirrors | Trust the branch name or local checkout instead of the commit recorded in the superproject | Use an explicit vendor manifest and verify pinned SHAs; if submodules are used, check cached submodule status |
| GitHub releases | Treat latest release assets as implementation inputs | Use release metadata for context only; use source commits/tags for inventories |
| License metadata | Record only `AGPL-3.0` | Record license file URL, SPDX ID, attribution, extra license notes, and excluded non-free/proprietary pieces |
| Existing parity status | Add fork rows as verified because intake docs exist | Keep new fork rows out of verified status until future fork-specific evidence commands pass |
| Package map | Add vendor package names without dependency direction | Define base contracts, extension providers, flavor composition packages, and parity harness selection rules |
| Release automation | Extend v1.8 artifact workflow to fork flavors | Keep fork-flavor builds deferred until fork parity ports and cross-flavor build automation milestones |
| Feature inventory docs | Mix base, shared downstream, and fork-specific behavior in one flat list | Require classification, source ref, surface, module owner, evidence need, and v1.9 scope on every row |
| Security review | Let cloud and LAN rows ride with normal slicing features | Mark network/cloud rows deferred and require licensing, privacy, credential, and threat-model review later |

## Performance Traps

Patterns that work at small scale but fail as the fork program grows.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Clone or diff every full upstream repo in routine checks | Slow local and CI runs; contributors skip verification | v1.9 should store pins and manifests; deep diffs should be explicit maintainer commands | As soon as all three active fork repos are included |
| One giant feature inventory file | Merge conflicts, stale rows, unclear ownership | Use one vendor inventory plus a shared feature taxonomy and cross-fork summary | When the first shared downstream feature spans multiple forks |
| Matrix all forks by all platforms too early | CI cost grows before parity exists | Keep v1.9 off release/build matrices; defer to v1.14 | The first fork flavor build is added without parity evidence |
| Compare generated slicer outputs before row scope is stable | Massive noisy diffs and unclear failures | Start with inventory and checklist schema; reserve output parity for future port phases | When feature rows are still marketing-level labels |
| Vendor-specific branches in Rust core | Every shared change requires three mental models | Keep base core shared and use extension providers selected by flavor | Once Bambu and Orca both need overlapping behavior |

## Security Mistakes

Domain-specific security issues beyond generic repository hygiene.

| Mistake | Risk | Prevention |
|---------|------|------------|
| Using unofficial download sites or mirrors as source truth | Stale, malicious, or mislicensed intake artifacts | Use official GitHub repos and official project sites only; mark other sources discovery-only |
| Downloading vendor release binaries for v1.9 | Supply-chain and malware exposure, plus accidental packaging scope | Do not download or vendor binaries in v1.9; use source refs and metadata |
| Treating Bambu/Orca networking plugins as normal source dependencies | Non-free/proprietary, credential, privacy, and cloud-service risks | Inventory as deferred and security-reviewed; no plugin vendoring or cloud calls in v1.9 |
| Storing real printer/cloud credentials in fixtures or checklist examples | Credential leakage into repo history | Templates must use fake credentials and state that real credentials are prohibited |
| Copying AGPL source snippets without attribution | License and provenance ambiguity | Require upstream file, commit SHA, license, and attribution for any copied source |
| Importing upstream post-processing or macro behavior without trust boundaries | Local command execution risks through trusted print/project configs | Record as a trusted-input surface and require explicit future security review |

## UX Pitfalls

Common contributor and maintainer experience mistakes in this domain.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Vendor source is scattered across docs | Maintainers cannot tell which upstream commit the roadmap targets | Put source truth in one manifest and link inventories/checklists back to it |
| Status labels are ambiguous | Users think fork support exists before parity work | Use narrow v1.9 states: `vendor-pinned`, `inventoried`, `planned`, `deferred` |
| Inventories use vendor marketing terms | Future implementers cannot turn rows into tests | Classify rows by observable contract surface and source path |
| Architecture docs name vendor crates but not ownership rules | Contributors add fork-specific conditionals wherever convenient | Define dependency direction and extension provider boundaries |
| Deferred scope is buried in prose | Scope creep returns in each phase discussion | Put deferred markers directly on inventory rows and checklist templates |
| Official source links are not obvious | Contributors use SEO pages or unofficial downloads | Include official upstream URLs in every vendor manifest row |

## "Looks Done But Isn't" Checklist

Things that appear complete but are missing critical pieces.

- [ ] **Vendor source strategy:** Has upstream URLs but no exact commit, tag/release, capture date, license file, and refresh rule - verify the manifest can reproduce every inventory row.
- [ ] **Submodule or mirror path:** Exists in the tree but local checkout differs from the recorded superproject commit - verify cached submodule status or equivalent manifest SHA.
- [ ] **License baseline:** Says `AGPL-3.0` but does not identify attribution, license file URL, non-free optional components, or excluded binaries/plugins - verify each vendor has license notes.
- [ ] **Feature inventory:** Contains feature names but no source path, classification, surface, candidate module, evidence need, or v1.9 scope - verify rows can become future parity tasks.
- [ ] **Shared downstream catalog:** Lists common features but cannot distinguish inherited base behavior from shared Prusa/Bambu/Orca downstream behavior - verify every shared row has at least two source-backed fork references.
- [ ] **Module architecture:** Has package names but no dependency direction or extension-provider model - verify base core never depends on fork packages.
- [ ] **Parity checklist template:** Has checkboxes but no upstream SHA, inventory row ID, fixture provenance, evidence command, or deferred-scope field - verify a future phase could execute from the template.
- [ ] **Docs wording:** Mentions fork support or release outputs because source references exist - verify docs say inventory/planning only until evidence commands pass.
- [ ] **Network features:** Included in normal feature lists with no security or license note - verify every network/cloud row is deferred and separately reviewed.
- [ ] **Release workflows:** Changed during v1.9 for fork flavors - verify v1.9 does not add fork-flavor CI/release matrices.

## Recovery Strategies

When pitfalls occur despite prevention, how to recover.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Unpinned vendor references | MEDIUM | Freeze new inventory edits, add a manifest with exact SHAs, rerun source capture, then mark rows changed by the correction |
| License/provenance gap | HIGH | Stop any affected code or asset import, identify upstream files and licenses, remove unsupported material, add attribution and legal/security review notes |
| Marketing-only inventory | MEDIUM | Keep the original list as discovery notes, add structured rows, and require source-backed classification before roadmap use |
| Overclaimed fork parity | HIGH | Revert or correct status/docs, add explicit v1.9 vocabulary, and block release/build claims until future evidence commands exist |
| Forked Rust module architecture | HIGH | Extract shared base contracts, replace vendor conditionals with extension providers, and move vendor-specific behavior behind flavor composition boundaries |
| Release scope creep | MEDIUM | Move release/build/signing tasks to deferred roadmap notes, restore v1.9 acceptance criteria to intake and templates, and verify release workflows are unchanged |
| Stale inventory discovered in v1.10+ | MEDIUM | Run vendor refresh, produce a drift report, update changed rows, and require roadmap revalidation before port implementation |
| Network/cloud feature leakage | HIGH | Remove credentials/plugins/binary dependencies, reclassify rows as deferred, and add security/licensing review requirements |
| Weak checklist templates | LOW | Add required fields and regenerate templates before using them for parity planning |

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Branch-named vendor references | Phase 1: Vendor Source Intake and License Baseline | Manifest includes URL, branch, exact SHA, release/tag if applicable, capture date, license URL, and refresh command for each vendor |
| AGPL as checkbox | Phase 1 and Phase 4 | License notes identify SPDX, attribution, upstream license URLs, non-free optional components, and excluded binaries/plugins |
| Marketing-list inventories | Phase 2: Fork Feature Inventory Baseline | Every inventory row has classification, surface, source ref, commit, candidate module, evidence need, and v1.9 scope |
| Overclaimed parity | Phase 4: Parity Checklist Templates and Scope Documentation | No fork rows are marked verified; docs use `vendor-pinned` or `inventoried` until evidence commands pass |
| Rust codebase forks | Phase 3: Modular Fork Package Architecture | Package map documents dependency direction; base core has no dependency on flavor packages |
| Hidden release expansion | Phase 4 | Release workflows are unchanged except for explicit deferred docs; fork-flavor builds remain future work |
| Invisible vendor drift | Phase 1 and Phase 2 | Each vendor and inventory file carries capture metadata and a manual refresh command |
| Network/cloud feature leakage | Phase 2 and Phase 4 | Network/cloud rows are classified separately, deferred, and require future security/licensing review |
| Generic checklist templates | Phase 4 | Templates include inventory row ID, upstream SHA, source path, module owner, fixture provenance, evidence command, docs touched, license/security notes, and deferred scope |
| Official source confusion | Phase 1 | Vendor manifest uses official GitHub/project URLs; non-primary sources are marked discovery-only |

## Sources

- Local project context: `.planning/PROJECT.md`, `.planning/MILESTONES.md`, `.planning/ROADMAP.md`, `.planning/STATE.md`
- Local migration docs: `docs/port/migration-guidance.md`, `docs/port/package-map.md`, `docs/port/contract-inventory.md`
- Local codebase concerns/testing: `.planning/codebase/CONCERNS.md`, `.planning/codebase/TESTING.md`
- Slic3r upstream repository and README: `https://github.com/slic3r/Slic3r` - HIGH confidence
- PrusaSlicer upstream repository and README/license: `https://github.com/prusa3d/PrusaSlicer` - HIGH confidence
- Bambu Studio upstream repository and README/license: `https://github.com/bambulab/BambuStudio` - HIGH confidence
- OrcaSlicer upstream repository and README/license/security warning: `https://github.com/OrcaSlicer/OrcaSlicer` - HIGH confidence
- GNU AGPLv3 text and license notes: `https://www.gnu.org/licenses/agpl-3.0.en.html`, `https://www.gnu.org/licenses/` - HIGH confidence
- Git submodule behavior: `https://git-scm.com/docs/git-submodule` - HIGH confidence
- GitHub fork sync behavior and conflict note: `https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork` - HIGH confidence
- GitHub license detection caveats: `https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository` - MEDIUM confidence for detection behavior, not legal interpretation
- GitHub API and `git ls-remote` checks performed 2026-05-26 for default branches, latest releases, license metadata, and absence of `.gitmodules` in the four upstream repos - HIGH confidence for the snapshot only

---
*Pitfalls research for: v1.9 fork vendor intake and modular Slic3r-family Rust architecture*
*Researched: 2026-05-26*
