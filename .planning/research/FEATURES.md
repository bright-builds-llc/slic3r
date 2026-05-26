# Feature Research

**Domain:** fork vendor intake and downstream slicer feature inventory
**Researched:** 2026-05-26
**Confidence:** HIGH

## Feature Landscape

### Source Observations

These are the upstream facts that should shape v1.9 requirements.

| Source | Observed Baseline | Intake Meaning | Confidence |
|--------|-------------------|----------------|------------|
| Base Slic3r Rust port | Existing verified slice covers help, version, scoped config persistence, export workflows, transform/info/repair/split, cross-platform runtime paths, packaged launcher trees, and release artifacts | v1.9 should classify downstream behavior against these existing parity surfaces instead of reopening base parity | HIGH |
| PrusaSlicer | Official repo is a C++/CMake slicer built around `libslic3r`, with a thin CLI wrapper, standalone packages, profile bundles under `resources/profiles`, and vendor bundle `.ini`/`.idx` conventions | Treat as the primary downstream reference for shared Prusa-family behavior and the first feature inventory source | HIGH |
| Bambu Studio | Official repo states it is based on PrusaSlicer; it adds project workflows, multiple plates, remote control/monitoring, auto-arrange/orient, support variants, painting, STEP, arc path support, and JSON profile resources | Treat as a second-layer fork whose inventory must separate inherited Prusa behavior from Bambu-specific project, printer, and network behavior | HIGH |
| OrcaSlicer | Official repo redirects from SoftFever to OrcaSlicer, presents wide printer compatibility, calibration tooling, wall/seam controls, network printer support, adaptive bed mesh, and a larger JSON profile tree including `OrcaFilamentLibrary` | Treat as community-driven downstream behavior on top of Bambu/Prusa concepts, not as a source to wholesale merge | HIGH |
| Current upstream heads | `prusa3d/PrusaSlicer` default `master` at `9a583bd438b195856f3bcf7ea99b69ba4003a961`; `bambulab/BambuStudio` default `master` at `e150b502b3d2afc98b83dcc9e5720e998f9eb79a`; `OrcaSlicer/OrcaSlicer` default `main` at `398e007f2ec567ea56d3993864d03f52b210cbf3` | v1.9 should record pinned refs in a vendor registry, but requirements should not mandate these exact heads as permanent baselines | HIGH |

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Vendor source registry | Maintainers need one reviewed place that names each fork, repository URL, default branch, selected tag/commit, license, upstream lineage, and source paths used for inventory | LOW | Launch with PrusaSlicer, Bambu Studio, and OrcaSlicer only. Include observed commit SHAs, but require maintainers to choose stable tags or release branches before implementation milestones. |
| Fork lineage model | Downstream behavior cannot be scoped correctly without knowing that PrusaSlicer descends from Slic3r, Bambu Studio descends from PrusaSlicer, and OrcaSlicer builds on that Bambu/Prusa family | LOW | Use categories: `base-slic3r`, `shared-prusa-family`, `bambu-specific`, `orca-specific`, and `unknown-needs-review`. |
| Feature inventory template | The downstream consumer needs feature categories, table stakes, differentiators, anti-features, complexity, and dependencies | LOW | This is the core v1.9 deliverable. The template should be reusable per fork and per feature family. |
| Base-vs-shared-vs-fork-specific classification | Without classification, later roadmap work will either duplicate common behavior three times or accidentally treat fork-specific behavior as universal | MEDIUM | Require every inventory row to state whether it is base Slic3r, shared downstream, or fork-specific. Unknown rows stay out of implementation phases until classified. |
| Dependency mapping to existing parity surfaces | v1.9 must build on the verified help/version/config/export/transform/runtime/packaging/release surfaces already shipped | MEDIUM | Inventory rows should link to `cli.help`, `cli.version`, `config.persistence`, `export.workflows`, `transform.workflows`, platform runtime, packaged launcher, release artifacts, or `new-surface`. |
| PrusaSlicer feature intake | PrusaSlicer is the closest major downstream fork and defines many shared expectations: standalone packages, CLI, multi-material, G-code flavors, multi-object settings, multithreading, STL repair, profile bundles, 3D preview, variable layer height, supports, custom G-code macros, post-processing, and cooling logic | MEDIUM | v1.9 should inventory these as categories only. Do not port PrusaSlicer algorithms or GUI behavior yet. |
| Prusa vendor bundle/profile intake | Prusa profile ecosystems use `.ini` bundles with `.idx` compatibility indexes, optional bed/texture/thumbnail resources, inheritance, globally unique preset names, config-source/repo IDs, and compatibility constraints | MEDIUM | Table-stakes for intake because downstream work will otherwise confuse slicer features with vendor profile distribution. Implementation remains future work. |
| Bambu Studio feature intake | Bambu Studio adds project-based workflows, multiple plates, remote monitoring/control, auto-arrange/orient, support variants, painting tools, global/object/part settings, STEP, G2/G3 arcs, assembly/explosion view, and filament flushing workflows | HIGH | Inventory must tag GUI/project/network features as future unless they have a CLI/config/export dependency already in the existing verified slice. |
| Bambu JSON profile intake | Bambu uses JSON profile directories such as `resources/profiles/BBL/{machine,process,filament}` plus vendor metadata JSON files | MEDIUM | Capture profile schema families and required fixture examples. Do not promise JSON profile loading in v1.9. |
| OrcaSlicer feature intake | OrcaSlicer emphasizes calibration tools, wall/seam controls, sandwich/polyholes, overhang/support optimization, granular process controls, network printer support, mouse-ear brims, adaptive bed mesh, broad printer profiles, and community release cadence | HIGH | Inventory as future parity candidates with explicit fork-specific labels unless also observed in Bambu or Prusa sources. |
| Orca profile-library intake | Orca has a large `resources/profiles` tree and an `OrcaFilamentLibrary` profile family | MEDIUM | Record as a profile-distribution and compatibility surface, not a base slicing requirement. |
| Modular flavor boundary requirements | The Rust port needs a way to host fork-specific behavior without copying the Rust codebase into three forks | HIGH | v1.9 should define requirements for feature flags/package boundaries and future flavor modules, but detailed architecture belongs in `ARCHITECTURE.md`. |
| Parity checklist template | Later fork work needs a repeatable checklist for source pin, feature category, expected output, fixture need, status row, docs update, and exclusions | LOW | Table-stakes because the milestone goal includes parity checklist/documentation templates. |
| Documentation template for fork deltas | Maintainers need a human-readable record of what each fork adds beyond base Slic3r and what is intentionally deferred | LOW | Should produce docs templates, not implementation docs for nonexistent ports. |
| Exclusion ledger | The milestone must avoid drifting into full fork implementation, release-channel expansion, GUI migration, cloud/device control, or nightly sync automation | LOW | Make exclusions first-class so later phases do not infer overbroad scope from feature inventory names. |

### Differentiators (Competitive Advantage)

Features that set the project apart. Not required for basic intake, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Cross-fork feature matrix | Shows which downstream features are base, shared by multiple forks, or unique, so future milestones can implement common modules once | MEDIUM | High value for roadmap ordering. Should be generated from inventory rows rather than maintained as prose only. |
| Source-pinned evidence per feature | Keeps each downstream claim traceable to an upstream README, wiki, repo tree, source file, release note, or profile path | MEDIUM | Avoids stale or community-rumor-driven parity requirements. Each row should carry `source_url`, `source_ref`, and confidence. |
| Risk-ranked future parity backlog | Converts broad fork inventories into actionable future candidates without committing to full parity now | LOW | Rank by dependency on existing verified surfaces, implementation cost, and user-visible value. |
| Shared downstream module candidate marker | Flags features likely common across Prusa/Bambu/Orca so future architecture can create shared Rust modules instead of fork-local copies | MEDIUM | Examples: profile/preset handling, multi-plate/project concepts, multi-material semantics, support controls, printer/vendor metadata. |
| Profile schema comparison | Clarifies the difference between Slic3r/Prusa INI bundles and Bambu/Orca JSON profile trees | HIGH | Valuable but should stay an analysis artifact in v1.9. Actual loaders and converters are later implementation work. |
| Non-free/network boundary marker | Bambu notes an optional networking plugin based on non-free libraries; Bambu/Orca network printer features also imply credentials, LAN/cloud behavior, and device protocols | MEDIUM | Mark these as special review surfaces before any future module accepts them. |
| Fixture-seeding recommendations | Identifies which future parity fixtures will be needed for CLI/config/export/profile behavior | MEDIUM | Do not add broad fixtures in v1.9 unless templates require example placeholders. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Full PrusaSlicer, Bambu Studio, or OrcaSlicer parity in v1.9 | It would make the milestone sound complete | It contradicts the milestone scope and would pull in GUI, algorithms, profile loaders, network/device integrations, and packaging channels before module boundaries exist | Produce inventories, source pins, and checklist/docs templates only |
| Wholesale downstream code import | Seems faster than classifying features | It forks the Rust port immediately, loses clean package ownership, and makes shared behavior impossible to reason about | Intake source references and define modular flavor boundaries before any porting |
| Treating Bambu or Orca behavior as universal downstream behavior | Popular forks make their features look table-stakes | Fork-specific network, printer, calibration, or profile behavior can be wrong for Prusa or base Slic3r users | Require explicit category labels and evidence for "shared downstream" claims |
| Release-channel expansion | Fork flavors naturally suggest nightly builds, app releases, and downloadable channels | v1.8 only shipped base release build artifacts; fork-flavor builds and release channels are explicitly future work | Document future build/release needs as deferred dependencies |
| Nightly vendor sync automation | Current upstream forks move quickly, especially community profile changes | Automated sync before stable inventories and parity evidence creates review noise and accidental scope growth | Add manual source registry updates first; revisit automation after fork modules and parity checks exist |
| Network printer/cloud implementation | Remote control is a visible Bambu/Orca feature | It introduces credentials, device protocols, optional/non-free dependencies, security review, platform UI, and support burden | Inventory the feature family and require a future security/feasibility phase |
| GUI feature parity planning as implementation | Many fork differences are GUI-visible | GUI migration remains out of scope; treating GUI features as implementation requirements would distort v1.9 | Inventory GUI-visible behavior as future surfaces with CLI/config/export dependencies noted |
| Profile auto-update support | Prusa vendor bundles and fork profile trees include update/distribution concepts | Profile update channels have security, compatibility, and release-governance implications | Record source formats and compatibility rules; keep update/download execution deferred |
| Claiming source docs are exhaustive | Official READMEs and wikis summarize behavior but do not define every option or edge case | Requirements based only on marketing-level feature lists will miss source-level semantics | Mark high-level features as inventory candidates and require source/file-level validation before porting |

## Feature Dependencies

```text
Vendor source registry
    └──requires──> upstream source verification
                       └──requires──> pinned repo URL, branch/tag/commit, license, source paths

Fork feature inventory template
    └──requires──> fork lineage model
                       └──requires──> base/shared/fork-specific taxonomy

Cross-fork feature matrix
    └──requires──> Prusa intake
    └──requires──> Bambu intake
    └──requires──> Orca intake

Parity checklist template
    └──requires──> existing parity surface map
                       └──requires──> docs/port/parity-matrix.md and contract-inventory.md

Future fork flavor modules
    └──requires──> modular boundary requirements
                       └──requires──> feature inventory classifications

Future fork parity implementation
    └──requires──> checklist templates
    └──requires──> source-pinned inventories
    └──requires──> existing base parity fixtures and status rows

Nightly vendor sync automation
    └──requires──> stable source registry
    └──requires──> review-gated fork module parity
    └──requires──> fork-flavor build automation
```

### Dependency Notes

- **Vendor source registry requires upstream source verification:** every fork reference should include the exact repository URL, default branch, selected inventory ref, observed source paths, license note, and date checked.
- **Feature inventory requires the lineage model:** without lineage, inherited Prusa behavior in Bambu/Orca will be counted as duplicate fork-specific work.
- **Cross-fork feature matrix requires all three intakes:** do not build shared downstream module requirements from one fork alone.
- **Parity checklist template requires existing parity docs:** future fork work must extend current verified surfaces instead of creating disconnected fork parity terminology.
- **Future fork modules require inventory classifications:** a module boundary should follow evidence-backed feature families, not brand names alone.
- **Nightly vendor sync automation requires later parity and release work:** v1.9 can record it as future work, but not design or enable it.

## MVP Definition

### Launch With (v1.9)

Minimum viable milestone output for fork vendor intake.

- [ ] Vendor source registry for PrusaSlicer, Bambu Studio, and OrcaSlicer with repository URL, selected ref, observed default branch/head, license, lineage, and source paths.
- [ ] Fork feature inventory template with category, ownership label, source evidence, complexity, dependency, parity status target, and defer/implement decision.
- [ ] PrusaSlicer inventory covering C++/`libslic3r`/CLI, profile bundle model, core slicing/printing families, packaging-visible expectations, and docs/test surfaces.
- [ ] Bambu Studio inventory covering inherited Prusa behavior, Bambu project/multi-plate/profile/network/painting/support/STEP/arc/assembly features, and optional networking-plugin boundary.
- [ ] OrcaSlicer inventory covering inherited Bambu/Prusa behavior, calibration tools, wall/seam controls, support/overhang controls, network printer support, adaptive mesh, profile library, and community profile cadence.
- [ ] Cross-fork category map that separates `base-slic3r`, `shared-prusa-family`, `bambu-specific`, `orca-specific`, and `unknown-needs-review`.
- [ ] Parity checklist/documentation templates tied to current `docs/port/` parity vocabulary and existing fixture/status surfaces.
- [ ] Explicit anti-scope section excluding full fork parity ports, GUI migration, release-channel expansion, fork-flavor builds, nightly sync automation, cloud/network device implementation, and profile auto-update execution.

### Add After Validation (v1.x)

Features to add once v1.9 inventories and boundaries are reviewed.

- [ ] Fork-specific Rust package scaffolds — add when architecture requirements define how flavor modules plug into shared crates.
- [ ] Source-backed option inventories for selected CLI/config/profile surfaces — add when a future phase chooses which fork surface to port first.
- [ ] Profile fixture corpus for representative Prusa INI and Bambu/Orca JSON profiles — add when profile loading/conversion is in scope.
- [ ] Cross-fork parity status rows — add when a concrete fork module exposes behavior worth testing.
- [ ] Fork-flavor package targets — add after at least one fork module is implemented and verified.

### Future Consideration (v2+)

Features to defer until downstream module parity is credible.

- [ ] Full PrusaSlicer flavor parity — requires deeper algorithm, GUI, profile, packaging, and test-source research.
- [ ] Full Bambu Studio flavor parity — requires project/multi-plate behavior, printer integration, optional plugin, and network/security design.
- [ ] Full OrcaSlicer flavor parity — requires calibration generators, profile validator/library handling, community profile governance, and network-printer integrations.
- [ ] GUI migration or GUI feature parity — still blocked by base GUI migration strategy.
- [ ] Release-channel publishing for fork flavors — requires fork package targets, signing/notarization/installer decisions, and release governance.
- [ ] Nightly vendor sync with automated merge assistance — requires stable vendor registry, deterministic inventories, review gates, and passing fork parity evidence.

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Vendor source registry | HIGH | LOW | P1 |
| Fork lineage model | HIGH | LOW | P1 |
| Feature inventory template | HIGH | LOW | P1 |
| Base/shared/fork-specific classification | HIGH | MEDIUM | P1 |
| Dependency mapping to existing parity surfaces | HIGH | MEDIUM | P1 |
| PrusaSlicer feature intake | HIGH | MEDIUM | P1 |
| Prusa vendor bundle/profile intake | HIGH | MEDIUM | P1 |
| Bambu Studio feature intake | HIGH | HIGH | P1 |
| Bambu JSON profile intake | MEDIUM | MEDIUM | P1 |
| OrcaSlicer feature intake | HIGH | HIGH | P1 |
| Orca profile-library intake | MEDIUM | MEDIUM | P1 |
| Parity checklist template | HIGH | LOW | P1 |
| Documentation template for fork deltas | HIGH | LOW | P1 |
| Cross-fork feature matrix | HIGH | MEDIUM | P2 |
| Source-pinned evidence per feature | HIGH | MEDIUM | P2 |
| Risk-ranked future parity backlog | MEDIUM | LOW | P2 |
| Profile schema comparison | MEDIUM | HIGH | P3 |
| Non-free/network boundary marker | MEDIUM | MEDIUM | P2 |
| Fixture-seeding recommendations | MEDIUM | MEDIUM | P2 |
| Fork-specific Rust package scaffolds | HIGH | HIGH | P2 |
| Fork-flavor release/package targets | MEDIUM | HIGH | P3 |
| Nightly vendor sync automation | MEDIUM | HIGH | P3 |

**Priority key:**

- P1: Must have for v1.9
- P2: Should have soon after requirements are accepted
- P3: Future consideration

## Competitor Feature Analysis

| Feature | PrusaSlicer | Bambu Studio | OrcaSlicer | Our v1.9 Approach |
|---------|-------------|--------------|------------|-------------------|
| Upstream lineage | Based on Slic3r | Based on PrusaSlicer, from Slic3r | Bambu/Prusa-family community slicer | Record lineage and classify inherited behavior before any porting |
| Source structure | C++/CMake, `libslic3r`, `src/CLI`, `resources/profiles`, `tests` | C++/CMake with legacy-style `lib`, `t`, `xs` remnants, `src/libslic3r`, `resources/profiles`, `bbl` | C++/CMake with `src/libslic3r`, `resources/profiles`, `SoftFever_doc`, `tools` | Inventory source paths and likely module boundaries; do not copy structure into Rust wholesale |
| CLI/config surface | Complete CLI; wiki says use `--help` for current interface and notes Prusa-specific changes vs upstream Slic3r | Wiki documents `bambu-studio` options for settings, filaments, outputdir, arrange/orient, export 3MF/settings/slicedata, info, slice, and config priority | CLI details need source-level validation; public docs emphasize settings, profiles, calibration, and workflows | Map only current verified base CLI surfaces now; mark fork CLI deltas as future source validation |
| Profile model | INI bundles plus IDX compatibility indexes, inheritance, vendor resources, source IDs | JSON vendor metadata plus `machine`, `process`, `filament` folders, especially `BBL` | Larger JSON profile tree with vendor folders and `OrcaFilamentLibrary` | Record profile schemas and examples; defer loaders, converters, and online updates |
| Core slicer behavior | Multi-material, G-code flavors, multiple object settings, multithreading, STL repair, variable layer height, support, cooling, macros, post-processing | Adds multiple plates, auto-arrange/orient, support variants, painting, STEP, G2/G3 arcs, assembly/explosion, flushing into infill/object | Adds calibration suite, wall/seam controls, sandwich/polyholes, overhang/support optimization, adaptive bed mesh, mouse-ear brims | Categorize into base/shared/fork-specific and attach complexity; no algorithm parity in v1.9 |
| Network/device behavior | PrusaLink/Connect ecosystem exists, but not part of current base Rust slice | Remote control/monitoring plus optional non-free networking plugin | Network printer support including Klipper, PrusaLink, and OctoPrint | Mark as future security/feasibility work, not a v1.9 implementation target |
| Packaging/release | Standalone Windows/macOS/Linux packages | Windows/macOS/Linux releases, Linux AppImage/Flathub note | Stable and nightly downloads | Keep fork-flavor builds and release channels deferred; v1.9 can only record future package implications |

## Recommended Inventory Row Shape

Use this shape for the v1.9 checklist/docs template work:

| Field | Purpose |
|-------|---------|
| `fork` | `prusa`, `bambu`, `orca`, or `shared` |
| `category` | `cli`, `config`, `profile`, `slicing-core`, `project-workflow`, `gui`, `network-device`, `packaging`, `docs-tests`, or `release` |
| `ownership` | `base-slic3r`, `shared-prusa-family`, `bambu-specific`, `orca-specific`, or `unknown-needs-review` |
| `feature` | Human-readable feature name |
| `source_ref` | Upstream URL plus branch/tag/commit used |
| `evidence_type` | `readme`, `wiki`, `repo-tree`, `source-file`, `release-note`, `profile-file`, or `observed-command` |
| `complexity` | `LOW`, `MEDIUM`, or `HIGH` |
| `depends_on` | Existing parity surface or `new-surface` |
| `v1_9_decision` | `inventory-only`, `template-only`, `defer`, or `needs-deeper-research` |
| `future_parity_notes` | What a later implementation phase must prove |

## Sources

- PrusaSlicer official repository and README: https://github.com/prusa3d/PrusaSlicer
- PrusaSlicer raw README: https://raw.githubusercontent.com/prusa3d/PrusaSlicer/master/README.md
- PrusaSlicer Command Line Interface wiki: https://github.com/prusa3d/PrusaSlicer/wiki/Command-Line-Interface
- PrusaSlicer vendor bundle process: https://github.com/prusa3d/PrusaSlicer/wiki/Vendor-bundles-and-updating-process
- PrusaSlicer settings repository: https://github.com/prusa3d/PrusaSlicer-settings
- Bambu Studio official repository and README: https://github.com/bambulab/BambuStudio
- Bambu Studio Command Line Usage wiki: https://github.com/bambulab/BambuStudio/wiki/Command-Line-Usage
- OrcaSlicer official repository and README: https://github.com/OrcaSlicer/OrcaSlicer
- OrcaSlicer wiki home: https://github.com/OrcaSlicer/OrcaSlicer/wiki
- OrcaSlicer profile creation wiki: https://github.com/OrcaSlicer/OrcaSlicer/wiki/How-to-create-profiles
- GitHub repository tree observations through `gh api` on 2026-05-26 for `resources/profiles`, `src`, and root directories of all three upstream repositories.
- Upstream HEAD observations through `git ls-remote --symref` on 2026-05-26 for all three upstream repositories.
- Existing project context: `.planning/PROJECT.md`, `.planning/MILESTONES.md`, `.planning/codebase/STRUCTURE.md`, `docs/port/README.md`, `docs/port/parity-matrix.md`, and `docs/port/contract-inventory.md`.

______________________________________________________________________

*Feature research for: fork vendor intake and downstream slicer feature inventory*
*Researched: 2026-05-26*
