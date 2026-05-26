# Architecture Research

**Domain:** Fork vendor intake and modular Rust flavor architecture for the Slic3r Rust port
**Researched:** 2026-05-26
**Confidence:** HIGH for integration architecture; MEDIUM for exact future feature coverage

## Standard Architecture

### System Overview

Fork vendor intake should be a reference and evidence layer beside the existing
Rust migration, not a second implementation tree. The retained legacy Slic3r
package remains the base parity oracle. PrusaSlicer, Bambu Studio, and
OrcaSlicer should enter the repo as pinned vendor references, feature
inventories, and later parity evidence that drive modular Rust flavor code.

```text
+--------------------------------------------------------------------+
| Bazel monorepo root                                                 |
| MODULE.bazel, BUILD.bazel, packages/BUILD.bazel                     |
+---------------------+----------------------+-----------------------+
| Reference sources   | Rust implementation  | Evidence and docs     |
|                     |                      |                       |
| packages/legacy-    | packages/slic3r-rust | packages/parity       |
| slic3r              | - slic3r_contracts   | packages/parity-      |
|                     | - slic3r_core        | fixtures              |
| New: packages/      | - slic3r_cli         | docs/port             |
| vendor-forks        | New: slic3r_flavors  | New: docs/port/forks  |
+---------------------+----------------------+-----------------------+
| Launcher and release boundary                                       |
| packages/launcher, tools/release                                    |
| base target now; flavor targets after vendor architecture is stable |
+--------------------------------------------------------------------+
```

### Architectural Position

The recommended shape is:

1. Keep upstream fork code out of the production Rust dependency graph.
1. Track each fork through a pinned source manifest and optional local checkout
   workflow.
1. Convert vendor behavior into typed inventories before any Rust module work.
1. Add one flavor registry over the existing Rust workspace instead of one
   Rust workspace per fork.
1. Extend launcher, parity, fixtures, docs, and release provenance by flavor
   only after the flavor model is typed and validated.

This fits the current repo because Bazel is already the top-level coordinator,
`packages/legacy-slic3r` already owns oracle behavior, and
`packages/slic3r-rust` already separates contracts, CLI shell, and lower-level
implementation. Fork intake should reuse those boundaries instead of adding a
parallel forked Rust tree.

### Component Responsibilities

| Component | Status | Responsibility | Typical Implementation |
| --- | --- | --- | --- |
| `packages/vendor-forks` | New | Own pinned vendor source references, source-intake metadata, license notes, and source fetch validation | Bazel package with `sources.tsv` or `sources.toml`, per-fork `SOURCE.md`, and a `vendor_sources_check` test |
| `docs/port/forks` | New | Human-facing fork inventory and checklist surface | `README.md`, `feature-inventory-template.md`, `parity-checklist-template.md`, and one inventory per fork |
| `packages/slic3r-rust/crates/slic3r_contracts` | Modified | Add stable flavor and inventory contract types | `ForkFlavor`, `DownstreamFork`, `FeatureOrigin`, `ParitySurface`, source IDs, and parsed CLI flavor selection |
| `packages/slic3r-rust/crates/slic3r_flavors` | New | Own pure flavor composition and feature registry | Registry maps `ForkFlavor` to base modules, shared downstream modules, and fork-specific modules |
| `packages/slic3r-rust/crates/slic3r_core` | Modified later | Continue to own reusable slicer behavior without vendor source or package concerns | Core functions accept typed flavor policy or feature set, not raw fork strings |
| `packages/slic3r-rust/crates/slic3r_cli` | Modified | Keep the imperative shell thin while selecting a typed flavor | `execute_args_for_flavor(...)`, process I/O, stdout/stderr/exit mapping |
| `packages/launcher` | Modified | Expose base and future flavor launcher targets without owning business logic | Bazel aliases or small Rust bin wrappers for `slic3r`, `prusaslicer`, `bambu-studio`, `orcaslicer` |
| `packages/parity` | Modified | Add fork-specific evidence status without breaking the base status file | New `fork-status.tsv` and `//packages/parity:<flavor>_<surface>_parity` targets |
| `packages/parity-fixtures` | Modified | Keep fork fixtures separate from base fixtures and record provenance | `forks/<flavor>/<surface>/...` and `forks/shared/<feature>/...` fixture namespaces |
| `tools/release` | Modified later | Add flavor provenance and cross-flavor build matrix only after flavor parity exists | Release scripts consume launcher flavor targets and parity evidence targets |

## Recommended Project Structure

```text
packages/
  vendor-forks/                         # New: reference intake, not production code
    BUILD.bazel
    README.md
    sources.tsv                         # fork id, upstream URL, tag/commit, license, notes
    forks/
      prusaslicer/
        SOURCE.md
        FEATURES.md
        PARITY-CHECKLIST.md
      bambu-studio/
        SOURCE.md
        FEATURES.md
        PARITY-CHECKLIST.md
      orcaslicer/
        SOURCE.md
        FEATURES.md
        PARITY-CHECKLIST.md

  slic3r-rust/
    Cargo.toml                          # Add slic3r_flavors when real code starts
    crates/
      slic3r_contracts/                 # Modified: typed flavor/source/inventory contracts
      slic3r_core/                      # Modified later: reusable behavior only
      slic3r_flavors/                   # New: pure flavor registry and composition
      slic3r_cli/                       # Modified: shell selects a typed flavor
      slic3r_prusaslicer/               # Future: only when Prusa behavior is being ported
      slic3r_bambu/                     # Future: only when Bambu behavior is being ported
      slic3r_orca/                      # Future: only when Orca behavior is being ported

  launcher/
    BUILD.bazel                         # Modified: future flavor entrypoint aliases/wrappers

  parity/
    BUILD.bazel                         # Modified: fork evidence targets
    status.tsv                          # Existing base status remains stable
    fork-status.tsv                     # New: flavor/surface/status/evidence/source

  parity-fixtures/
    forks/
      shared/                           # Behavior shared by multiple downstream forks
      prusaslicer/
      bambu-studio/
      orcaslicer/

docs/
  port/
    forks/
      README.md
      vendor-source-strategy.md
      feature-inventory-template.md
      module-architecture.md
      parity-checklist-template.md

tools/
  vendor/
    fetch_vendor_forks.sh               # Optional: fetch pins into .planning/.tmp
    validate_vendor_sources.sh          # Check pins are immutable and complete
```

### Structure Rationale

- **`packages/vendor-forks`:** Use a package boundary because vendor intake is
  part of the monorepo contract, but keep it as metadata and documentation.
  Do not put large upstream checkouts or CMake projects into the Rust workspace.
- **`docs/port/forks`:** Keep feature inventories reviewable by maintainers and
  aligned with the existing `docs/port` parity discipline.
- **`slic3r_contracts`:** Flavor IDs, source IDs, and inventory categories are
  contracts. Parse them once at the boundary so core code never receives raw
  fork strings.
- **`slic3r_flavors`:** One pure composition crate prevents the workspace from
  becoming one crate tree per fork. It should know which modules apply to a
  flavor, but it should not perform file I/O or process execution.
- **Future fork crates:** Add `slic3r_prusaslicer`, `slic3r_bambu`, and
  `slic3r_orca` only when actual behavior is being ported. Empty placeholder
  crates create churn without evidence.
- **`packages/parity` and `packages/parity-fixtures`:** Keep base parity stable
  and add fork status as a separate namespace so existing status tooling does
  not break.

## Architectural Patterns

### Pattern 1: Vendor References as Evidence, Not Build Dependencies

**What:** Record upstream fork URL, tag, commit, license, source date, and
feature inventory in a checked-in package, then fetch large upstream repos into
an ignored local cache only when needed.

**When to use:** v1.9 vendor intake and later feature-diff work.

**Trade-offs:** Maintainers must run a fetch command before deep local source
comparison, but normal Bazel, Rust, and parity workflows stay fast and stable.
Submodules remain an option later, but they should not become production build
inputs unless a future phase proves that need.

**Recommended pin model:**

```rust
pub enum VendorPin {
    ReleaseTag {
        tag: NonEmptyText,
        commit: GitSha,
    },
    Commit(GitSha),
}

pub struct VendorSource {
    pub fork: DownstreamFork,
    pub upstream_url: SourceUrl,
    pub pin: VendorPin,
    pub license: LicenseId,
    pub maybe_non_free_component: Option<NonFreeComponentNote>,
}
```

### Pattern 2: Typed Flavor Registry over One Rust Workspace

**What:** Keep the Rust implementation as one workspace with typed flavor
composition. A flavor selects modules and policies; it does not select a
separate copy of the codebase.

**When to use:** All PrusaSlicer, Bambu Studio, and OrcaSlicer behavior.

**Trade-offs:** A registry requires up-front modeling, but it keeps shared
downstream behavior reusable and makes differences explicit.

**Example:**

```rust
pub enum DownstreamFork {
    PrusaSlicer,
    BambuStudio,
    OrcaSlicer,
}

pub enum ForkFlavor {
    BaseSlic3r,
    Downstream(DownstreamFork),
}

pub enum FeatureOrigin {
    BaseSlic3r,
    SharedDownstream(NonEmptyForkSet),
    ForkSpecific(DownstreamFork),
}
```

This avoids invalid combinations such as "base-only fork-specific behavior" and
forces shared downstream features to name at least one downstream fork.

### Pattern 3: Functional Core, Imperative Shell by Flavor

**What:** Launcher and parity targets perform process I/O. Contracts parse raw
arguments and source files into domain types. Flavor/core modules perform pure
decisions over typed values.

**When to use:** CLI parsing, feature inventory parsing, flavor selection,
profile selection, config overlays, generated-output decisions, and parity
classification.

**Trade-offs:** Some integration code remains imperative, but the behavior that
must be reviewed for parity can be unit tested without Bazel, GitHub, file
systems, or platform launchers.

**Example flow:**

```text
raw argv + launcher target
  -> parse into CliInvocation { flavor, command }
  -> resolve FlavorPlan from slic3r_flavors
  -> execute pure/core behavior where possible
  -> CLI shell maps response to stdout/stderr/exit code
```

### Pattern 4: Flavor Evidence Ladder

**What:** Treat fork parity evidence as a ladder: vendor source reference,
feature inventory, fixture corpus, Rust-backed implementation, parity command,
then verified status.

**When to use:** Every fork-specific feature and shared downstream feature.

**Trade-offs:** Slower than marking a whole fork "supported", but it preserves
the repo's current evidence discipline and prevents overclaiming.

## Data Flow

### Vendor Intake Flow

```text
Official upstream repo/release
  -> packages/vendor-forks/sources.tsv
  -> optional tools/vendor/fetch_vendor_forks.sh checkout in .planning/.tmp
  -> per-fork SOURCE.md and FEATURES.md
  -> docs/port/forks inventory and roadmap inputs
```

Key rule: the source manifest is the boundary. Parse and validate immutable
pins before any feature inventory or parity task depends on them.

### Feature Classification Flow

```text
Vendor source + existing base contract inventory
  -> feature inventory row
  -> FeatureOrigin::BaseSlic3r
   | FeatureOrigin::SharedDownstream(...)
   | FeatureOrigin::ForkSpecific(...)
  -> implementation owner and parity checklist row
```

Base Slic3r behavior should continue to point to `packages/legacy-slic3r` and
the existing `docs/port/contract-inventory.md`. Downstream behavior should point
to the pinned fork source and the fork inventory row that justified the module.

### Runtime Flavor Flow

```text
User or Bazel target
  -> packages/launcher flavor target
  -> slic3r_cli process shell
  -> slic3r_contracts parses command + flavor
  -> slic3r_flavors builds a FlavorPlan
  -> slic3r_core and fork modules execute typed behavior
  -> stdout/stderr/files/exit code
```

The launcher target may choose a default flavor, but core functions should
receive typed policy or feature data. Avoid raw strings such as
`"bambu-studio"` past the parsing boundary.

### Parity Flow

```text
Feature inventory row
  -> fixture provenance under packages/parity-fixtures/forks/...
  -> parity command under packages/parity
  -> fork-status.tsv row
  -> docs/port/forks checklist update
```

Fork parity should compare against the relevant vendor reference when that
reference is buildable and scoped. When a vendor reference cannot be built
reliably in Bazel yet, mark the evidence as source/inventory based and do not
claim verified runtime parity.

## New vs Modified Components

| Area | Action | Why |
| --- | --- | --- |
| `packages/vendor-forks` | Add | Provides a stable, Bazel-visible intake boundary for source pins and licensing notes without vendoring large fork trees into Rust |
| `tools/vendor` | Add | Keeps source fetch/update logic scriptable and reviewable while writing checkouts to `.planning/.tmp` |
| `docs/port/forks` | Add | Gives roadmap and maintainers one place for fork-specific inventories and checklists |
| `slic3r_contracts` | Modify | It already owns stable launcher contracts; add flavor/source/inventory domain types there |
| `slic3r_flavors` | Add when code starts | Pure registry/composition belongs outside CLI shell and outside low-level core |
| `slic3r_core` | Modify only through typed APIs | Base reusable behavior should not import vendor docs, source paths, or launcher details |
| `slic3r_cli` | Modify | It is the correct shell for process I/O and flavor dispatch |
| `packages/launcher` | Modify after typed flavor model exists | It owns entrypoints and package-shaped startup handoff, not flavor business logic |
| `packages/parity` | Modify | Add fork evidence commands and `fork-status.tsv` without breaking base `status.tsv` |
| `packages/parity-fixtures` | Modify | Fork fixtures need separate provenance and namespaces |
| `tools/release` and `.github/workflows` | Defer | Cross-flavor release automation depends on implemented and verified flavor targets |

## Integration Points

### External Sources

| Source | Integration Pattern | Notes |
| --- | --- | --- |
| PrusaSlicer official repo | Pin URL plus release tag/commit in `packages/vendor-forks` | Official README describes PrusaSlicer as based on Slic3r and C++/libslic3r centered. Treat it as the first downstream reference because Bambu and Orca inherit from this line. |
| Bambu Studio official repo | Pin URL plus release tag/commit and feature inventory | Official README identifies Bambu Studio as based on PrusaSlicer and lists Bambu-specific surfaces such as remote control, multiple plates, STEP, and Bambu packaging. |
| OrcaSlicer official repo | Pin URL plus release tag/commit and feature inventory | Official README describes origins across Bambu Studio, PrusaSlicer, and SuperSlicer, with calibration/network/printer-compatibility emphasis. |
| Optional/non-free Bambu network components | Intake note only unless a legal and product decision approves more | OrcaSlicer documents the Bambu networking plugin as optional and based on non-free BambuLab libraries. Do not put those libraries into the Rust build by default. |
| GitHub releases/API | Fetch/update helper input | Useful for refreshing pins, but runtime builds must not depend on live network access. |

### Internal Boundaries

| Boundary | Communication | Notes |
| --- | --- | --- |
| `packages/vendor-forks` to `docs/port/forks` | Source IDs and inventory rows | Inventories should reference source IDs, not ad hoc URLs in every row |
| `docs/port/forks` to roadmap | Markdown tables/checklists | Roadmap phases should be created from checked-in inventory rows |
| `slic3r_contracts` to `slic3r_flavors` | Typed enums/newtypes | Parse raw source/CLI/manifest data before the flavor registry sees it |
| `slic3r_flavors` to `slic3r_core` | Pure value objects and policies | Core stays reusable and testable |
| `slic3r_cli` to `packages/launcher` | Binary targets and process exit behavior | Launcher remains an entrypoint owner, not business logic owner |
| `packages/parity-fixtures` to `packages/parity` | Files, expected outputs, provenance | Fork fixture namespaces prevent base/fork evidence from blurring |
| `tools/release` to `packages/launcher`/`packages/parity` | Artifact target plus evidence target | Add flavor release outputs only after fork parity targets exist |

## Build Order

1. **Vendor source boundary**
   - Add `packages/vendor-forks` with `sources.tsv` or `sources.toml`.
   - Include PrusaSlicer, Bambu Studio, and OrcaSlicer URL, pin, license, source
     date, and known non-free component notes.
   - Add a Bazel-visible validation target that fails on missing URL, floating
     branch-only pins, duplicate fork IDs, or malformed commit hashes.

2. **Feature inventory and checklist templates**
   - Add `docs/port/forks` templates before Rust code changes.
   - Require every row to classify behavior as base, shared downstream, or
     fork-specific.
   - Require every row to name implementation owner, evidence state, source ID,
     and deferred/blocked notes.

3. **Typed flavor contracts**
   - Extend `slic3r_contracts` with `ForkFlavor`, `DownstreamFork`,
     `FeatureOrigin`, `VendorSourceId`, `FeatureId`, and parity status types.
   - Unit test constructors and parsers. This is where illegal states should be
     ruled out.

4. **Flavor registry crate**
   - Add `slic3r_flavors` only after the contract types exist.
   - Keep it pure: no filesystem, no GitHub, no process calls.
   - Model base modules, shared downstream modules, and fork-specific modules as
     composable entries in one registry.

5. **Launcher flavor identity**
   - Add flavor-aware execution in `slic3r_cli`.
   - Add future launcher aliases or small Rust bin wrappers only after the
     registry exists.
   - Keep base `//packages/launcher:slic3r` unchanged while adding flavor
     targets separately.

6. **Fork parity namespace**
   - Add `fork-status.tsv` and fixture namespaces before claiming runtime fork
     support.
   - Create parity command templates that name flavor, surface, source pin, and
     fixture provenance.

7. **Port sequence after v1.9**
   - Start with PrusaSlicer modules because Bambu Studio and OrcaSlicer inherit
     substantial behavior from the PrusaSlicer line.
   - Promote duplicated Prusa/Bambu/Orca behavior into shared downstream
     modules only after at least two inventories and fixtures prove the overlap.
   - Add Bambu Studio modules next, then OrcaSlicer modules, with non-free or
     networked integrations kept behind explicit review gates.

## Scaling Considerations

| Scale | Architecture Adjustments |
| --- | --- |
| v1.9 intake only | Metadata package, docs, validation scripts, typed contracts; no fork runtime claims |
| One fork port | Add one fork crate or module set plus flavor parity fixtures and status rows |
| Three fork ports | Promote common behavior into `shared` flavor modules and use flavor targets in launcher/parity |
| Cross-platform flavor releases | Extend release provenance with `flavor`, `vendor_source`, and `evidence_target`; add GitHub Actions matrix only after parity is verified |
| More forks later | Keep manifest/registry generated or table-driven; avoid adding one-off launcher, release, and parity logic per fork |

### Scaling Priorities

1. **First bottleneck:** feature classification drift. Fix it with typed
   inventory IDs, validation, and reviewable docs before code.
1. **Second bottleneck:** shared downstream behavior duplicated across fork
   modules. Fix it by promoting proven overlap into shared modules.
1. **Third bottleneck:** launcher/release matrix sprawl. Fix it with typed
   flavor targets and provenance fields, not custom scripts per fork.

## Anti-Patterns

### Anti-Pattern 1: Forking the Rust Workspace Per Vendor

**What people do:** Copy `packages/slic3r-rust` into separate Prusa, Bambu, and
Orca workspaces.

**Why it is wrong:** Fixes, contracts, and parity evidence immediately diverge.
Shared downstream features become copy/paste, and cross-flavor builds become
branch management instead of normal targets.

**Do this instead:** Use one workspace, typed flavor composition, and
flavor-specific modules only where behavior actually differs.

### Anti-Pattern 2: Treating Upstream Fork Trees as Bazel Build Inputs

**What people do:** Add upstream C++ fork repositories as submodules and wire
them into normal Bazel builds.

**Why it is wrong:** The fork codebases have their own CMake/dependency stacks
and will slow or destabilize unrelated Rust/Bazel verification. They are
reference sources first, not production dependencies.

**Do this instead:** Pin vendor references in `packages/vendor-forks`, fetch
them into an ignored cache when needed, and extract fixtures/inventories through
explicit tasks.

### Anti-Pattern 3: Compile-Time Feature Soup

**What people do:** Add Cargo features such as `prusaslicer`, `bambu`, and
`orca` that toggle behavior inside the same functions.

**Why it is wrong:** Mutual exclusions and feature combinations become hard to
test. Illegal states remain representable.

**Do this instead:** Use typed flavor values and a registry. If compile-time
selection is ever required for packaging, generate thin binaries that choose a
typed flavor and still call shared library code.

### Anti-Pattern 4: Free-Text Feature Inventories

**What people do:** Write prose summaries of fork features without stable IDs,
source pins, ownership, or evidence state.

**Why it is wrong:** Roadmap phases cannot reliably turn prose into tasks, and
future sync automation cannot detect what changed.

**Do this instead:** Use a table with stable `FeatureId`, `FeatureOrigin`,
`VendorSourceId`, implementation owner, parity surface, status, and notes.

### Anti-Pattern 5: Pulling Non-Free Network Integrations into Core

**What people do:** Treat Bambu/Orca network plugins as ordinary slicer core
behavior.

**Why it is wrong:** Network integrations have licensing, security, and service
dependency risks that are different from slicing algorithms or config/profile
behavior.

**Do this instead:** Record them in inventories with an explicit integration
kind and keep them out of core/runtime builds until there is a separate legal,
security, and product decision.

## Roadmap Implications

Suggested phase structure for v1.9:

1. **Vendor Source Intake Package**
   - Adds `packages/vendor-forks`, source pins, source docs, and validation.
   - Avoids polluting the Rust workspace with upstream C++ trees.

2. **Fork Inventory Templates and Initial Inventories**
   - Adds `docs/port/forks` and per-fork feature inventory skeletons.
   - Establishes base/shared/fork-specific classification before code.

3. **Rust Flavor Contract Types**
   - Adds pure typed contracts in `slic3r_contracts`.
   - Applies Bright Builds parse-at-boundaries and illegal-state rules.

4. **Flavor Registry Boundary**
   - Adds `slic3r_flavors` or a documented pre-crate module boundary.
   - Defines how base, shared downstream, and fork-specific behavior compose.

5. **Parity and Launcher Integration Templates**
   - Adds fork parity namespace, status template, fixture conventions, and
     future launcher target shape.
   - Keeps actual fork runtime parity and release builds deferred until modules
     exist.

**Ordering rationale:** vendor pins must exist before inventories; inventories
must exist before typed feature ownership; typed ownership should exist before
runtime modules; parity namespaces should exist before any flavor claims are
marked verified.

## Confidence and Gaps

| Area | Confidence | Notes |
| --- | --- | --- |
| Repo integration points | HIGH | Based on current `.planning`, Bazel, Rust workspace, launcher, parity, fixture, and docs files |
| Upstream lineage and source shape | HIGH | Verified against official GitHub repositories on 2026-05-26 |
| Exact fork feature inventory | MEDIUM | Official README feature lists are enough for architecture; detailed inventories need source-level follow-up |
| License/network plugin handling | MEDIUM | Official sources identify AGPL and optional non-free network components, but policy needs maintainer/legal review before implementation |
| Future release automation | MEDIUM | Current release architecture is clear, but fork release targets should wait for parity evidence |

## Sources

- Local project context: `.planning/PROJECT.md`, `.planning/ROADMAP.md`,
  `.planning/codebase/ARCHITECTURE.md`, `.planning/codebase/STRUCTURE.md`,
  `.planning/codebase/CONVENTIONS.md`
- Local Bazel/Rust surfaces: `MODULE.bazel`,
  `packages/slic3r-rust/Cargo.toml`,
  `packages/slic3r-rust/BUILD.bazel`,
  `packages/slic3r-rust/crates/*/BUILD.bazel`,
  `packages/launcher/BUILD.bazel`, `packages/parity/BUILD.bazel`,
  `packages/parity-fixtures/BUILD.bazel`
- Local docs: `docs/port/package-map.md`,
  `docs/port/entrypoint-architecture.md`,
  `docs/port/contract-inventory.md`,
  `docs/port/parity-matrix.md`,
  `docs/port/migration-guidance.md`,
  `docs/port/release-build-automation.md`
- Bright Builds local guidance: `AGENTS.md`, `AGENTS.bright-builds.md`,
  `standards-overrides.md`
- Bright Builds pinned standards:
  https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md
- Bright Builds architecture:
  https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md
- Bright Builds Rust guidance:
  https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md
- PrusaSlicer official repository: https://github.com/prusa3d/PrusaSlicer
- Bambu Studio official repository: https://github.com/bambulab/BambuStudio
- OrcaSlicer official repository: https://github.com/OrcaSlicer/OrcaSlicer

---

*Architecture research for: v1.9 fork vendor intake and module architecture*
*Researched: 2026-05-26*
