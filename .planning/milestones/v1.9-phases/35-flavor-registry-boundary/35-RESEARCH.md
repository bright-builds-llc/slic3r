# Phase 35: Flavor Registry Boundary - Research

**Researched:** 2026-05-27 [VERIFIED: system current_date]
**Domain:** Rust crate boundary, static metadata registry, Bazel/Cargo workspace wiring, fork inventory traceability [VERIFIED: .planning/phases/35-flavor-registry-boundary/35-CONTEXT.md]
**Confidence:** HIGH for local architecture and verification shape; MEDIUM for the exact static row subset because Phase 35 allows planner discretion [VERIFIED: .planning/phases/35-flavor-registry-boundary/35-CONTEXT.md]

<user_constraints>
## User Constraints (from CONTEXT.md)

Source: `.planning/phases/35-flavor-registry-boundary/35-CONTEXT.md` [VERIFIED: cat .planning/phases/35-flavor-registry-boundary/35-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Registry Package Boundary

- **D-01:** Add a new pure Rust crate under
  `packages/slic3r-rust/crates/slic3r_flavors` for registry composition. It
  should depend on `slic3r_contracts` instead of extending `slic3r_core` or
  folding composition into the contract parser module.
- **D-02:** Keep `slic3r_contracts` focused on typed vocabulary and strict
  parsers. The new flavor crate owns inspectable registry composition,
  capability metadata, and developer-facing lookup helpers.
- **D-03:** Do not create separate PrusaSlicer, Bambu Studio, or OrcaSlicer
  Rust workspaces. All downstream fork metadata should plug into one shared
  Rust package through capability-oriented registry entries.

### Registry Metadata Model

- **D-04:** Model registry data as flat capability records reachable from a
  `FlavorRegistryEntry` or equivalent root entry. Each capability record should
  carry typed `FlavorId`, `VendorSourceRef`, `FeatureOrigin`,
  `ParitySurface`, and `ChecklistStatus` values where applicable.
- **D-05:** Represent base, shared downstream, fork-specific, and
  unknown-needs-review metadata with the existing `FeatureOrigin` taxonomy
  instead of duplicating separate untyped buckets.
- **D-06:** Keep source-reference and ownership traceability on capability or
  provenance records, not only on the flavor root. A base flavor can still
  reference vendor-observed inventory evidence without becoming a downstream
  fork identity.
- **D-07:** Expose simple inspectable accessors such as all flavor entries,
  lookup by `FlavorId`, and capability iteration/filtering. These are metadata
  queries only, not runtime feature dispatch.

### Source of Truth and Purity

- **D-08:** Use a small static typed Rust registry for Phase 35. Do not parse
  TSVs at runtime and do not add a generator unless the metadata volume grows
  beyond a hand-auditable registry.
- **D-09:** Treat `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/*.tsv`, and
  `packages/fork-inventories/category-map.tsv` as canonical source evidence
  that the static registry traces to. They remain checked-in planning inputs,
  not runtime inputs.
- **D-10:** The registry crate must remain side-effect free: no Git,
  filesystem, network, process, release, environment, or clock operations in
  registry construction or lookup.
- **D-11:** If future metadata expansion needs generated Rust data, require a
  repo-owned generator plus drift tests in a later phase. Do not introduce a
  side-effecting build script in Phase 35.

### Verification and Documentation

- **D-12:** Add focused Rust tests proving that the registry exposes base,
  shared downstream, fork-specific, and unknown-needs-review metadata; maps
  metadata to canonical source refs and inventory ownership labels; and
  rejects accidental runtime parity claims.
- **D-13:** Wire the new crate into Cargo and Bazel so
  `//packages/slic3r-rust:verify` covers its tests, rustfmt, and clippy.
- **D-14:** Update `packages/slic3r-rust/README.md` and port docs so the module
  boundary is discoverable while preserving the metadata-only/no-runtime-parity
  language from Phases 32 through 34.
- **D-15:** Keep the docs explicit that Phase 35 registry entries are planning
  and architecture metadata only. They do not mark fork behavior as verified or
  supported.

### the agent's Discretion

- The planner may choose exact type names such as `FlavorRegistryEntry`,
  `FlavorCapability`, or `FlavorCapabilityRecord` if the public API remains
  clear and inspectable.
- The planner may decide whether lookup helpers return slices, iterators, or
  `Option<&FlavorRegistryEntry>` values, provided absence is explicit and
  internal nullable names use the repo's `maybe` convention where relevant.
- The planner may choose a small hand-curated subset of inventory rows if it is
  enough to prove every required ownership category and traceability path
  without pretending to be an exhaustive parity matrix.

### Deferred Ideas (OUT OF SCOPE)

- Generated registry data from TSVs is deferred until metadata volume warrants
  a repo-owned generator plus drift tests.
- Fork parity checklist templates, fixture namespaces, launcher-shape wording,
  and drift-refresh protocol templates belong to Phase 36.
- Runtime fork behavior, fork-specific CLI dispatch, fork-flavor release
  builds, online/cloud integration, credential handling, and non-free plugin
  support remain future milestones after executable parity evidence exists.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| ARCH-02 | Developer can inspect a documented module boundary that keeps base Slic3r behavior in shared core packages while future fork behavior plugs in through capability-oriented flavor metadata rather than copied Rust workspaces. [VERIFIED: .planning/REQUIREMENTS.md] | Use one new `slic3r_flavors` crate that depends on `slic3r_contracts`, exposes flavor/capability metadata, and documents that `slic3r_core` remains shared base behavior. [VERIFIED: 35-CONTEXT.md D-01..D-07; VERIFIED: packages/slic3r-rust/Cargo.toml] |
| ARCH-03 | Developer can use or inspect a pure flavor registry boundary that maps base, shared downstream, and fork-specific metadata without performing Git, filesystem, network, process, or release operations. [VERIFIED: .planning/REQUIREMENTS.md] | Use static Rust data, no build script, no runtime TSV parsing, no `std::fs`, process, env, network, clock, release, or Git calls; prove this with focused tests and `rg` verification. [VERIFIED: 35-CONTEXT.md D-08..D-11] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned Bright Builds standards before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; VERIFIED: AGENTS.bright-builds.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- Prefer functional core / imperative shell, parse raw values into domain types at boundaries, and make illegal states unrepresentable. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Prefer early returns, `let...else` guard extraction, `maybe_` names for `Option`-bearing internals, and newtypes/enums for Rust invariants. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Unit-test pure and business logic, keep one concern per unit test, and use Arrange/Act/Assert comments by default. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Prefer repo-owned verification entrypoints and run relevant verification before committing. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- Before a git commit in this Rust project, run `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features` or document why they could not run. [VERIFIED: user-provided AGENTS.md instructions]
- Do not run `mdformat` over phase `*-SUMMARY.md` files, and keep `requirements-completed` metadata hyphenated in summary frontmatter; this phase writes `35-RESEARCH.md`, not a summary file. [VERIFIED: AGENTS.md]
- No repo-local `.claude/skills/` or `.agents/skills/` skill files were found for this phase. [VERIFIED: find .claude/skills .agents/skills -maxdepth 2 -type f -name SKILL.md]

## Summary

Phase 35 should add `packages/slic3r-rust/crates/slic3r_flavors` as a pure Rust metadata crate that composes Phase 34 contract types into a small static registry. [VERIFIED: 35-CONTEXT.md D-01..D-08] The crate should not own base behavior, fork dispatch, release behavior, Git calls, filesystem reads, network calls, process execution, environment reads, clocks, TSV runtime parsing, or build-script generation. [VERIFIED: 35-CONTEXT.md D-08..D-11]

The registry should expose flat capability records from a `FlavorRegistryEntry` root, with capability-level provenance records carrying `VendorSourceRef`, inventory row IDs, source paths, ownership labels represented by `FeatureOrigin`, parity dependency surfaces represented by `ParitySurface`, and planning status represented by `ChecklistStatus`. [VERIFIED: 35-CONTEXT.md D-04..D-07; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; VERIFIED: packages/fork-inventories/*.tsv] Base Slic3r should remain `FlavorId::BaseSlic3r` with no downstream fork identity, even when its base-core capability cites vendor-observed inventory evidence from PrusaSlicer, Bambu Studio, or OrcaSlicer. [VERIFIED: 35-CONTEXT.md D-06; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs]

The main implementation prerequisite is adding public associated `const fn` constructors or constants for the `ParitySurface` tokens needed by static registry data, because `ParitySurface` is currently a private-field newtype that can only be created through fallible runtime parsing outside `slic3r_contracts`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] This keeps the registry static and typed without duplicating parser logic or using `expect()` during registry construction. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md; VERIFIED: 35-CONTEXT.md D-08]

**Primary recommendation:** Extend `slic3r_contracts` only with parity-surface const constructors, then implement `slic3r_flavors` as a std-only static registry with slice/iterator accessors, focused tests, Bazel/Cargo wiring, and metadata-only docs. [VERIFIED: 35-CONTEXT.md D-01..D-15; VERIFIED: packages/slic3r-rust/BUILD.bazel]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Rust toolchain | 1.94.1 | Compile, format, lint, build, and test the Rust workspace. [VERIFIED: rustup run 1.94.1 rustc --version; VERIFIED: MODULE.bazel] | The repo pins Rust 1.94.1 through `MODULE.bazel`, while Cargo workspace metadata requires Rust 1.94. [VERIFIED: MODULE.bazel; VERIFIED: packages/slic3r-rust/Cargo.toml] |
| `slic3r_contracts` | 0.1.0 | Provides `DownstreamFork`, `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | Phase 34 made this crate the typed metadata boundary, and Phase 35 is locked to depend on it. [VERIFIED: .planning/phases/34-rust-flavor-contracts/34-01-SUMMARY.md; VERIFIED: 35-CONTEXT.md D-01] |
| `slic3r_flavors` | 0.1.0 recommended | New local crate for registry composition and lookup helpers. [VERIFIED: 35-CONTEXT.md D-01; ASSUMED: local crate version convention from existing 0.1.0 crates] | Keeps registry composition out of `slic3r_core` and out of contract parsing. [VERIFIED: 35-CONTEXT.md D-01..D-02] |
| Rust standard library | 1.94.1 toolchain | Static slices, enums, `Option`, iterators, and pure lookup helpers. [VERIFIED: rustup run 1.94.1 rustc --version; VERIFIED: existing Rust crate patterns] | No external dependency is needed for static metadata and simple lookup. [VERIFIED: packages/slic3r-rust/Cargo.lock; VERIFIED: 35-CONTEXT.md D-08] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| Bazel | 8.6.0 | Runs aggregate Rust verification through `//packages/slic3r-rust:verify`. [VERIFIED: bazel --version; VERIFIED: .bazelversion; VERIFIED: packages/slic3r-rust/BUILD.bazel] | Wire the new crate's test, rustfmt, and clippy targets into the package-level verify suite. [VERIFIED: 35-CONTEXT.md D-13] |
| Bazelisk | 1.28.1 | Local Bazel launcher that honors `.bazelversion`. [VERIFIED: bazelisk version; VERIFIED: packages/slic3r-rust/README.md] | Use for local Bazel commands on macOS when invoking the pinned Bazel version. [VERIFIED: packages/slic3r-rust/README.md] |
| `rules_rust` | 0.69.0 | Provides Bazel `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test`. [VERIFIED: MODULE.bazel; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] | Follow existing crate-local BUILD patterns for the new `slic3r_flavors` crate. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |
| `packages/fork-vendors` TSVs | checked-in source data | Canonical vendor IDs and source pins. [VERIFIED: packages/fork-vendors/forks.tsv] | Use as source evidence for static registry provenance, not as runtime input. [VERIFIED: 35-CONTEXT.md D-09] |
| `packages/fork-inventories` TSVs | checked-in source data | Inventory IDs, ownership labels, source paths, parity dependencies, checklist decisions, and caution flags. [VERIFIED: packages/fork-inventories/*.tsv] | Use as source evidence for hand-curated static registry rows. [VERIFIED: 35-CONTEXT.md D-09] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Static typed registry | Runtime TSV parser | Rejected by locked Phase 35 decision; runtime parsing would add filesystem dependency and move planning inputs into runtime behavior. [VERIFIED: 35-CONTEXT.md D-08..D-10] |
| One shared `slic3r_flavors` crate | Vendor-specific Rust workspaces | Rejected by requirements and phase decisions because future fork behavior must plug into shared Rust packages instead of copied workspaces. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: 35-CONTEXT.md D-03] |
| Public parity-surface const constructors | `LazyLock` plus `ParitySurface::try_from(...).expect(...)` | Const constructors keep the registry truly static and avoid runtime initialization/panic paths for canonical tokens. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md] |
| Extending `slic3r_core` | New crate | Rejected by locked phase boundary because base Slic3r behavior remains in shared core and registry composition belongs in a separate flavor crate. [VERIFIED: 35-CONTEXT.md D-01..D-02] |

**Installation / workspace change:** no registry package install is needed; add a local Cargo workspace member and Bazel package. [VERIFIED: packages/slic3r-rust/Cargo.toml; VERIFIED: packages/slic3r-rust/BUILD.bazel]

```bash
# No npm/cargo registry install.
# Add:
# - packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml
# - packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel
# - packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs
# - packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs
```

**Version verification:** local crate versions and tool versions were verified through Cargo metadata, `Cargo.toml`, `Cargo.lock`, `MODULE.bazel`, `rustup`, Bazel, and Bazelisk rather than npm registry lookup because Phase 35 adds no npm packages. [VERIFIED: rustup run 1.94.1 cargo metadata --manifest-path packages/slic3r-rust/Cargo.toml --no-deps --format-version 1; VERIFIED: MODULE.bazel]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/
+-- Cargo.toml                         # add "crates/slic3r_flavors" workspace member [VERIFIED: existing workspace shape]
+-- BUILD.bazel                        # add alias, clippy data dep, and verify-suite entries [VERIFIED: existing package BUILD pattern]
+-- crates/
    +-- slic3r_contracts/              # typed vocabulary; add ParitySurface const constructors only [VERIFIED: Phase 34 summary]
    +-- slic3r_core/                   # shared base behavior remains here; do not add fork copies [VERIFIED: package map]
    +-- slic3r_flavors/
        +-- Cargo.toml                 # local crate depending on slic3r_contracts [VERIFIED: 35-CONTEXT.md D-01]
        +-- BUILD.bazel                # rust_library/rust_test/rust_clippy/rustfmt_test [VERIFIED: existing crate BUILD pattern]
        +-- src/lib.rs                 # public re-exports and docs [VERIFIED: existing contracts lib pattern]
        +-- src/registry.rs            # static entries and lookup helpers [VERIFIED: 35-CONTEXT.md D-08]
        +-- tests/flavor_registry.rs   # Arrange/Act/Assert behavior tests [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
```

### Pattern 1: One-Way Dependency Boundary

**What:** `slic3r_flavors` depends on `slic3r_contracts`; `slic3r_core` and `slic3r_contracts` do not depend on `slic3r_flavors`. [VERIFIED: 35-CONTEXT.md D-01..D-02]

**When to use:** Use this for all Phase 35 registry composition so metadata can be inspected without pulling fork metadata into base core behavior. [VERIFIED: .planning/REQUIREMENTS.md ARCH-02]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs and 35-CONTEXT.md
// Add this in packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs.
#![forbid(unsafe_code)]
//! Pure flavor metadata registry for Slic3r-family planning boundaries.

pub mod registry;

pub use registry::{
    all_flavors, maybe_flavor, FlavorCapability, FlavorProvenance, FlavorRegistryEntry,
};
```

### Pattern 2: Capability-Level Provenance

**What:** Put `VendorSourceRef`, inventory IDs, source paths, and ownership labels on capability provenance records, not only on the flavor root. [VERIFIED: 35-CONTEXT.md D-04..D-06]

**When to use:** Use this when a base capability cites source-observed inventory rows from downstream forks while preserving `FlavorId::BaseSlic3r.maybe_downstream_fork() == None`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; VERIFIED: packages/fork-inventories/*.tsv]

**Example:**

```rust
// Source: 35-CONTEXT.md and packages/fork-inventories/*.tsv.
use slic3r_contracts::{
    ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef,
};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorRegistryEntry {
    pub flavor_id: FlavorId,
    pub display_name: &'static str,
    pub capabilities: &'static [FlavorCapability],
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorCapability {
    pub capability_id: &'static str,
    pub feature_surface: &'static str,
    pub feature_category: &'static str,
    pub origin: FeatureOrigin,
    pub parity_dependencies: &'static [ParitySurface],
    pub checklist_status: ChecklistStatus,
    pub provenance: &'static [FlavorProvenance],
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorProvenance {
    pub inventory_id: &'static str,
    pub vendor_source: VendorSourceRef,
    pub source_paths: &'static [&'static str],
    pub ownership: FeatureOrigin,
}
```

### Pattern 3: Static Slice Registry With Explicit Absence

**What:** Store registry entries in `const`/`static` slice data and return borrowed slices or explicit `Option<&'static FlavorRegistryEntry>` lookups. [VERIFIED: 35-CONTEXT.md D-07..D-08]

**When to use:** Use this for all Phase 35 registry inspection helpers because the registry is metadata-only and hand-auditable. [VERIFIED: 35-CONTEXT.md D-08]

**Example:**

```rust
// Source: 35-CONTEXT.md D-07 and Bright Builds maybe_ naming guidance.
pub fn all_flavors() -> &'static [FlavorRegistryEntry] {
    FLAVOR_REGISTRY
}

pub fn maybe_flavor(flavor_id: FlavorId) -> Option<&'static FlavorRegistryEntry> {
    FLAVOR_REGISTRY
        .iter()
        .find(|entry| entry.flavor_id == flavor_id)
}

impl FlavorRegistryEntry {
    pub fn capabilities(&self) -> impl Iterator<Item = &FlavorCapability> {
        self.capabilities.iter()
    }

    pub fn capabilities_by_origin(
        &self,
        origin: FeatureOrigin,
    ) -> impl Iterator<Item = &FlavorCapability> {
        self.capabilities
            .iter()
            .filter(move |capability| capability.origin == origin)
    }
}
```

### Pattern 4: Contract Constructors Before Registry Constants

**What:** Add `ParitySurface` associated `const fn` constructors in `slic3r_contracts` for canonical tokens before writing registry constants that need typed `ParitySurface` values. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs]

**When to use:** Use this because `ParitySurface` has a private field and no current public const constructor, while `VendorSourceRef` already has public const constructors for the three canonical pins. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs.
impl ParitySurface {
    pub const fn cli_version() -> Self {
        Self("cli.version")
    }

    pub const fn cli_help() -> Self {
        Self("cli.help")
    }

    pub const fn file_formats() -> Self {
        Self("file-formats")
    }

    pub const fn generated_outputs() -> Self {
        Self("generated-outputs")
    }

    pub const fn config() -> Self {
        Self("config")
    }

    pub const fn config_persistence() -> Self {
        Self("config.persistence")
    }
}
```

### Recommended Static Row Subset

Use a hand-curated subset that proves the boundary without pretending to be exhaustive. [VERIFIED: 35-CONTEXT.md "the agent's Discretion"]

| Capability Purpose | Inventory Evidence | Why Include |
|--------------------|--------------------|-------------|
| Base core capability | `prusaslicer.base-core`, `bambustudio.base-core`, `orcaslicer.base-core` [VERIFIED: packages/fork-inventories/*.tsv] | Proves base metadata can cite vendor-observed evidence without making `base-slic3r` a downstream fork. [VERIFIED: 35-CONTEXT.md D-06] |
| Shared downstream support generation | `prusaslicer.support-generation`, `bambustudio.support-generation`, `orcaslicer.support-generation` [VERIFIED: packages/fork-inventories/*.tsv; VERIFIED: packages/fork-inventories/category-map.tsv] | Proves shared downstream metadata across all three forks. [VERIFIED: category-map.tsv] |
| Shared downstream STEP or arc | `prusaslicer.step-import` plus `bambustudio.step-import`, or `prusaslicer.arc-fitting` plus `bambustudio.arc-fitting` [VERIFIED: packages/fork-inventories/prusaslicer.tsv; VERIFIED: packages/fork-inventories/bambustudio.tsv] | Proves multi-vendor provenance for one capability that is not base core. [VERIFIED: category-map.tsv] |
| Fork-specific Prusa capability | `prusaslicer.profile-schema` [VERIFIED: packages/fork-inventories/prusaslicer.tsv] | Proves Prusa-specific metadata without a Prusa Rust workspace. [VERIFIED: 35-CONTEXT.md D-03] |
| Fork-specific Bambu capability | `bambustudio.project-file` or `bambustudio.assembly-workflow` [VERIFIED: packages/fork-inventories/bambustudio.tsv] | Proves Bambu-specific metadata without runtime Bambu dispatch. [VERIFIED: 35-CONTEXT.md D-07] |
| Fork-specific Orca needs-review capability | `orcaslicer.calibration-flow`, `orcaslicer.profile-library`, or `orcaslicer.community-profile` [VERIFIED: packages/fork-inventories/orcaslicer.tsv] | Proves `ChecklistStatus::NeedsReview` and no runtime parity claim. [VERIFIED: packages/fork-inventories/orcaslicer.tsv; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| Deferred network/plugin capability | one `*.network-device` row per fork, if planner wants to test deferred handling [VERIFIED: packages/fork-inventories/*.tsv] | Proves deferred cautions remain metadata and do not create online/cloud/credential/plugin support. [VERIFIED: packages/fork-inventories/README.md] |

### Anti-Patterns to Avoid

- **Runtime TSV parsing in `slic3r_flavors`:** violates the locked static-registry decision and introduces filesystem coupling. [VERIFIED: 35-CONTEXT.md D-08..D-10]
- **Side-effecting `build.rs` generator:** violates Phase 35 deferral of generated Rust data and drift tests. [VERIFIED: 35-CONTEXT.md D-11]
- **Putting fork metadata in `slic3r_core`:** blurs shared base behavior with future fork planning metadata. [VERIFIED: 35-CONTEXT.md D-01..D-02]
- **Creating `prusaslicer`, `bambustudio`, or `orcaslicer` Rust workspaces:** violates ARCH-02 and the locked shared-crate decision. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: 35-CONTEXT.md D-03]
- **Treating parity dependency surfaces as verified fork support:** `ParitySurface` values are dependency labels, not runtime fork parity claims. [VERIFIED: packages/parity/status.tsv; VERIFIED: 35-CONTEXT.md D-15]
- **Duplicating contract parsers in the registry crate:** Phase 34 already centralized typed parsing and display logic. [VERIFIED: .planning/phases/34-rust-flavor-contracts/34-01-SUMMARY.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Vendor/source identity parsing | New source-ref parser in `slic3r_flavors` | `VendorSourceRef` constructors and parsers from `slic3r_contracts` [VERIFIED: flavor.rs] | Phase 34 already rejects branch heads and malformed pins. [VERIFIED: flavor_contracts.rs] |
| Parity surface validation | Duplicate whitelist in `slic3r_flavors` | Add public const constructors on existing `ParitySurface` [VERIFIED: flavor.rs; ASSUMED: recommended synthesis] | Keeps one contract source of truth while allowing static typed registry data. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md] |
| Runtime inventory ingestion | TSV reader, generator, `include_str!` parser, or `build.rs` | Small hand-curated static Rust data [VERIFIED: 35-CONTEXT.md D-08..D-11] | Phase 35 is an inspectable metadata boundary, not data import infrastructure. [VERIFIED: 35-CONTEXT.md] |
| Fork feature dispatch | Match statements that execute fork behavior | Metadata-only lookup helpers [VERIFIED: 35-CONTEXT.md D-07] | Runtime fork behavior is deferred out of v1.9. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |
| Release/build flavor matrix | New fork release targets | Documentation that fork release builds are deferred [VERIFIED: .planning/REQUIREMENTS.md Out of Scope] | Fork release artifacts require verified runtime fork behavior first. [VERIFIED: .planning/REQUIREMENTS.md] |
| Vendor-specific crates/workspaces | `slic3r_prusaslicer`, `slic3r_bambu`, `slic3r_orca` workspaces | One `slic3r_flavors` crate with capability records [VERIFIED: 35-CONTEXT.md D-03] | Requirement ARCH-02 forbids copied Rust workspaces for fork behavior. [VERIFIED: .planning/REQUIREMENTS.md] |

**Key insight:** The registry is a pure architectural metadata boundary; it should make future fork work inspectable without becoming an importer, dispatcher, verifier, release system, or parity claim. [VERIFIED: 35-CONTEXT.md; VERIFIED: .planning/ROADMAP.md Phase 35 success criteria]

## Common Pitfalls

### Pitfall 1: `ParitySurface` Cannot Currently Be Const-Constructed Outside `slic3r_contracts`

**What goes wrong:** A static registry cannot write `ParitySurface("file-formats")` because the tuple field is private, and `ParitySurface::try_from("file-formats")` is not a const constructor. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs]

**Why it happens:** Phase 34 intentionally made `ParitySurface` a private-field validated newtype. [VERIFIED: .planning/phases/34-rust-flavor-contracts/34-01-SUMMARY.md]

**How to avoid:** Add public associated `const fn` constructors or public constants for the parity tokens that registry data needs, with tests proving they display the canonical tokens. [ASSUMED: recommended synthesis from flavor.rs and 35-CONTEXT.md]

**Warning signs:** Registry code uses `expect()`, `LazyLock`, duplicate string whitelists, or raw `&str` parity fields. [ASSUMED: implementation smell based on local code constraints]

### Pitfall 2: Base Flavor Accidentally Becomes a Downstream Fork

**What goes wrong:** A base entry cites `VendorSourceRef` evidence and then exposes `Some(DownstreamFork)` as its flavor identity. [VERIFIED: 35-CONTEXT.md D-06]

**Why it happens:** Source-observed base-core rows exist in each downstream inventory, but `FlavorId::BaseSlic3r` is intentionally separate from downstream fork IDs. [VERIFIED: packages/fork-inventories/*.tsv; VERIFIED: flavor.rs]

**How to avoid:** Keep `FlavorRegistryEntry.flavor_id == FlavorId::BaseSlic3r` and assert `FlavorId::BaseSlic3r.maybe_downstream_fork() == None` while capability provenance carries vendor source refs. [VERIFIED: flavor.rs; RECOMMENDED]

**Warning signs:** Root entry fields such as `vendor`, `fork`, or `source_ref` appear on `FlavorRegistryEntry` instead of on provenance records. [ASSUMED: recommended interpretation of 35-CONTEXT.md D-06]

### Pitfall 3: Registry Metadata Overclaims Runtime Parity

**What goes wrong:** Docs or tests describe `future-candidate`, `needs-review`, or parity dependency labels as supported fork behavior. [VERIFIED: 35-CONTEXT.md D-15]

**Why it happens:** `packages/parity/status.tsv` contains verified base surfaces, but inventory rows use those as dependency labels for future work. [VERIFIED: packages/parity/status.tsv; VERIFIED: packages/fork-inventories/*.tsv]

**How to avoid:** Name the field `parity_dependencies`, keep `ChecklistStatus` as the planning status, and test that no registry API exposes a "verified" or "supported" fork status. [ASSUMED: recommended synthesis from Phase 34 contracts and Phase 35 D-15]

**Warning signs:** Public API names such as `supported_capabilities`, `runtime_status`, `verified_fork`, or `dispatch`. [ASSUMED: naming risk based on phase exclusions]

### Pitfall 4: Unknown-Needs-Review Is in the Vocabulary but Not in Current Inventory Rows

**What goes wrong:** A plan promises a real `FeatureOrigin::UnknownNeedsReview` inventory-backed row, but current per-fork inventory TSVs do not contain an ownership value of `unknown-needs-review`. [VERIFIED: rg -n "unknown-needs-review|needs-review" packages/fork-inventories/*.tsv packages/fork-inventories/README.md]

**Why it happens:** The taxonomy supports `unknown-needs-review`, while the current source-pinned rows use `fork-specific` ownership and `needs-review` checklist status for Orca review rows. [VERIFIED: packages/fork-inventories/README.md; VERIFIED: packages/fork-inventories/orcaslicer.tsv]

**How to avoid:** Do not fabricate source-backed unknown ownership. Use Orca `needs-review` rows to prove review-status metadata, and explicitly decide whether D-12 requires a literal `FeatureOrigin::UnknownNeedsReview` example or a `ChecklistStatus::NeedsReview` example. [ASSUMED: recommended synthesis from 35-CONTEXT.md D-12 and current TSVs]

**Warning signs:** Static registry rows use inventory IDs that do not exist in `packages/fork-inventories/*.tsv`. [VERIFIED: verify_inventories.sh category-map exact-once checks]

### Pitfall 5: Bazel Verify Misses the New Crate

**What goes wrong:** Cargo tests pass locally but `//packages/slic3r-rust:verify` does not run the new registry test, rustfmt, or clippy target. [VERIFIED: packages/slic3r-rust/BUILD.bazel]

**Why it happens:** The aggregate verify suite manually lists crate-local targets. [VERIFIED: packages/slic3r-rust/BUILD.bazel]

**How to avoid:** Add the new crate's `rustfmt_check`, test target, and `clippy` target to `packages/slic3r-rust/BUILD.bazel`, and add the crate's clippy target to `clippy_check` data. [VERIFIED: existing BUILD pattern; VERIFIED: 35-CONTEXT.md D-13]

**Warning signs:** `bazel query //packages/slic3r-rust:verify` does not include a `slic3r_flavors` label. [ASSUMED: verification query method]

## Code Examples

Verified and recommended patterns for the planner:

### Contract Const Constructors

```rust
// Source: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs.
// Add inside impl ParitySurface so the new crate can build static typed data.
impl ParitySurface {
    pub const fn generated_outputs() -> Self {
        Self("generated-outputs")
    }
}

#[test]
fn parity_surface_constructors_display_canonical_tokens() {
    // Arrange
    let generated_outputs = ParitySurface::generated_outputs();

    // Act
    let token = generated_outputs.as_str();

    // Assert
    assert_eq!(token, "generated-outputs");
}
```

### Static Registry Slice

```rust
// Source: 35-CONTEXT.md D-04..D-10 and packages/fork-inventories/*.tsv.
const BASE_CORE_PARITY: &[ParitySurface] = &[
    ParitySurface::cli_version(),
    ParitySurface::cli_help(),
];

const BASE_CORE_PROVENANCE: &[FlavorProvenance] = &[
    FlavorProvenance {
        inventory_id: "prusaslicer.base-core",
        vendor_source: VendorSourceRef::prusa_slicer_version_2_9_5(),
        source_paths: &["src/libslic3r"],
        ownership: FeatureOrigin::BaseSlic3r,
    },
    FlavorProvenance {
        inventory_id: "bambustudio.base-core",
        vendor_source: VendorSourceRef::bambu_studio_v02_06_00_51(),
        source_paths: &["src/libslic3r"],
        ownership: FeatureOrigin::BaseSlic3r,
    },
    FlavorProvenance {
        inventory_id: "orcaslicer.base-core",
        vendor_source: VendorSourceRef::orca_slicer_v2_3_2(),
        source_paths: &["src/libslic3r"],
        ownership: FeatureOrigin::BaseSlic3r,
    },
];

const BASE_CAPABILITIES: &[FlavorCapability] = &[FlavorCapability {
    capability_id: "base-core",
    feature_surface: "base-core",
    feature_category: "base-core",
    origin: FeatureOrigin::BaseSlic3r,
    parity_dependencies: BASE_CORE_PARITY,
    checklist_status: ChecklistStatus::NoActionBase,
    provenance: BASE_CORE_PROVENANCE,
}];

static FLAVOR_REGISTRY: &[FlavorRegistryEntry] = &[FlavorRegistryEntry {
    flavor_id: FlavorId::BaseSlic3r,
    display_name: "Base Slic3r",
    capabilities: BASE_CAPABILITIES,
}];
```

### Focused Registry Test

```rust
// Source: Bright Builds testing.md and packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs.
#[test]
fn base_registry_entry_keeps_base_flavor_identity_without_losing_provenance() {
    // Arrange
    let maybe_base = maybe_flavor(FlavorId::BaseSlic3r);

    // Act
    let Some(base) = maybe_base else {
        panic!("base-slic3r must be registered");
    };
    let provenance_vendors = base
        .capabilities()
        .flat_map(|capability| capability.provenance.iter())
        .map(|provenance| provenance.vendor_source.vendor())
        .collect::<Vec<_>>();

    // Assert
    assert_eq!(base.flavor_id.maybe_downstream_fork(), None);
    assert!(provenance_vendors.contains(&DownstreamFork::PrusaSlicer));
    assert!(provenance_vendors.contains(&DownstreamFork::BambuStudio));
    assert!(provenance_vendors.contains(&DownstreamFork::OrcaSlicer));
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Raw fork/flavor/source strings crossing Rust boundaries | Typed `DownstreamFork`, `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus` | Phase 34 completed 2026-05-26 [VERIFIED: 34-01-SUMMARY.md] | Phase 35 should compose existing typed values, not re-parse or revalidate raw strings. [VERIFIED: Phase 34 summary] |
| Vendor-specific Rust workspaces or copied base behavior | One shared Rust workspace plus capability-oriented flavor metadata | Locked for Phase 35 [VERIFIED: 35-CONTEXT.md D-03] | Future fork work stays modular without forking base Rust code. [VERIFIED: .planning/REQUIREMENTS.md ARCH-02] |
| Runtime registry/input parsing | Small static typed registry | Locked for Phase 35 [VERIFIED: 35-CONTEXT.md D-08] | No filesystem, process, network, environment, or generator behavior belongs in registry construction. [VERIFIED: 35-CONTEXT.md D-10..D-11] |
| Source pins or inventories interpreted as parity evidence | Source-observed metadata remains planning input only | Phases 32-34 and Phase 35 locked language [VERIFIED: fork-vendors README; VERIFIED: fork-inventories README; VERIFIED: 35-CONTEXT.md D-15] | Docs and tests must avoid claiming fork runtime support. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |

**Deprecated/outdated for this phase:**
- Creating side-effecting registry code is out of scope. [VERIFIED: 35-CONTEXT.md D-10]
- Creating fork-specific release/build/CLI dispatch logic is out of scope. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope]
- Vendoring upstream fork source trees or importing upstream C++ as build inputs is out of scope. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | New local crate `slic3r_flavors` should use version `0.1.0` to match existing local Rust crates. [ASSUMED: local version convention] | Standard Stack | Low; using another local version would only affect Cargo metadata consistency. |
| A2 | `LazyLock`, `expect()`, duplicate whitelists, or raw `&str` parity fields are warning signs for registry construction in this phase. [ASSUMED: implementation smell based on local constraints] | Common Pitfalls | Medium; planner may allow one of these if const constructors are rejected, but it should be deliberate. |
| A3 | `bazel query //packages/slic3r-rust:verify` is a practical way to inspect aggregate verify membership. [ASSUMED: Bazel workflow convention] | Common Pitfalls | Low; reading `packages/slic3r-rust/BUILD.bazel` is enough if query is unavailable. |
| A4 | Public parity-surface const constructors are the preferred mitigation for static typed registry data. [ASSUMED: recommended synthesis] | Architecture Patterns / Common Pitfalls / Don't Hand-Roll | Medium; if rejected, planner must choose another pure/static construction path without duplicate validation. |
| A5 | Root-level `vendor`, `fork`, or `source_ref` fields on `FlavorRegistryEntry` are warning signs. [ASSUMED: recommended interpretation of 35-CONTEXT.md D-06] | Common Pitfalls | Medium; a root source field could accidentally blur base flavor identity with source-observed provenance. |
| A6 | Public API names like `supported_capabilities`, `runtime_status`, `verified_fork`, or `dispatch` are naming risks. [ASSUMED: naming risk based on phase exclusions] | Common Pitfalls | Medium; names can overclaim runtime support even when data remains metadata-only. |
| A7 | The unknown-needs-review gap should be handled with `ChecklistStatus::NeedsReview` rows unless a real `FeatureOrigin::UnknownNeedsReview` inventory row exists. [ASSUMED: recommended synthesis] | Common Pitfalls / Open Questions | High; literal D-12 interpretation may require user or planner confirmation before implementation. |
| A8 | `docs/port/README.md` is optional if the Rust README, contract inventory, and package map make the boundary discoverable. [ASSUMED: recommended synthesis] | Open Questions | Low; adding the README note is cheap if planner wants broader discoverability. |
| A9 | `grep` is a fallback if `rg` is unavailable. [ASSUMED: standard shell fallback] | Environment Availability | Low; `rg` is available locally. |
| A10 | STRIDE labels in the Security Domain are approximate mappings. [ASSUMED: STRIDE mapping] | Security Domain | Low; mitigations are driven by phase scope and source constraints, not by the exact STRIDE category. |
| A11 | A 30-day validity window is appropriate for this local architecture research. [ASSUMED: 30-day stability window] | Metadata | Low; planner should re-check sooner if source files change. |
| A12 | The registry field should be named `parity_dependencies`, and APIs should avoid "verified" or "supported" fork-status wording. [ASSUMED: recommended synthesis] | Common Pitfalls | Medium; poor naming can overclaim runtime parity even if the underlying data remains correct. |

## Open Questions (RESOLVED)

1. **Does D-12 require literal `FeatureOrigin::UnknownNeedsReview` registry data or `ChecklistStatus::NeedsReview` review metadata?** [VERIFIED: 35-CONTEXT.md D-12]
   - What we know: The contract enum supports `FeatureOrigin::UnknownNeedsReview`, and the inventory docs allow `unknown-needs-review`. [VERIFIED: flavor.rs; VERIFIED: packages/fork-inventories/README.md]
   - What's unclear: Current per-fork inventory rows do not contain ownership `unknown-needs-review`; they contain Orca rows with `v1_9_decision` of `needs-review`. [VERIFIED: packages/fork-inventories/orcaslicer.tsv; VERIFIED: rg unknown-needs-review]
   - Recommendation: Do not fabricate source-backed unknown ownership. Plan tests for `ChecklistStatus::NeedsReview` using Orca rows, and add an explicit planner note if literal `FeatureOrigin::UnknownNeedsReview` must wait for a future inventory row. [ASSUMED: recommended synthesis]
   - **RESOLVED:** Phase 35 uses current source-backed `ChecklistStatus::NeedsReview` metadata for Orca rows such as `orcaslicer.calibration-flow` and does not fabricate a `FeatureOrigin::UnknownNeedsReview` registry row unless a future inventory row actually uses that ownership label. Plan 35-02 includes an explicit test for this distinction. [VERIFIED: .planning/phases/35-flavor-registry-boundary/35-02-PLAN.md]

2. **Which docs are the minimum Phase 35 documentation surface?** [VERIFIED: 35-CONTEXT.md D-14]
   - What we know: Context names `packages/slic3r-rust/README.md` and port docs; integration points specifically name `docs/port/contract-inventory.md` and `docs/port/package-map.md`. [VERIFIED: 35-CONTEXT.md]
   - What's unclear: `docs/port/README.md` may also need a short "Current Flavor Registry State" update for discoverability. [VERIFIED: docs/port/README.md]
   - Recommendation: Update all three port docs only if the extra README note is concise; otherwise update `contract-inventory.md` and `package-map.md` plus the Rust README. [ASSUMED: recommended synthesis]
   - **RESOLVED:** Phase 35 updates `packages/slic3r-rust/README.md`, `docs/port/README.md`, `docs/port/contract-inventory.md`, and `docs/port/package-map.md`. Plan 35-03 keeps the overview note concise while making the registry boundary discoverable from the Rust workspace and port control-plane docs. [VERIFIED: .planning/phases/35-flavor-registry-boundary/35-03-PLAN.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| `rustup run 1.94.1 rustc` | Rust compile/test/format/clippy commands | yes [VERIFIED: command output] | `rustc 1.94.1 (e408947bf 2026-03-25)` [VERIFIED: rustup run 1.94.1 rustc --version] | None needed. |
| `rustup run 1.94.1 cargo` | Cargo workspace verification | yes [VERIFIED: command output] | `cargo 1.94.1 (29ea6fb6a 2026-03-24)` [VERIFIED: rustup run 1.94.1 cargo --version] | Use pinned rustup command instead of default `cargo` 1.91.1. [VERIFIED: cargo --version] |
| Bazel | Bazel verify target | yes [VERIFIED: command output] | 8.6.0 [VERIFIED: bazel --version; VERIFIED: .bazelversion] | Bazelisk is available. [VERIFIED: bazelisk version] |
| Bazelisk | Pinned Bazel launcher | yes [VERIFIED: command output] | 1.28.1 [VERIFIED: bazelisk version] | Direct `bazel` also reports 8.6.0. [VERIFIED: bazel --version] |
| Git | Existing vendor verifier and commit tooling | yes [VERIFIED: command output] | 2.53.0 [VERIFIED: git --version] | Not needed for registry runtime; only tooling uses Git. [VERIFIED: 35-CONTEXT.md D-10] |
| ripgrep | Verification scans for forbidden APIs and docs terms | yes [VERIFIED: command output] | 15.1.0 [VERIFIED: rg --version] | Use `grep` only if `rg` unavailable. [ASSUMED: standard shell fallback] |

**Missing dependencies with no fallback:** none found. [VERIFIED: environment probes]

**Missing dependencies with fallback:** none found. [VERIFIED: environment probes]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no [VERIFIED: 35-CONTEXT.md excludes credential handling and runtime fork behavior] | No auth code belongs in this crate. [VERIFIED: 35-CONTEXT.md D-10 and deferred scope] |
| V3 Session Management | no [VERIFIED: 35-CONTEXT.md excludes online/cloud integration] | No session state belongs in this crate. [VERIFIED: 35-CONTEXT.md] |
| V4 Access Control | no [VERIFIED: registry is metadata-only static Rust data] | No authorization checks belong in this crate; future runtime features need separate threat review. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |
| V5 Input Validation | yes, narrowly [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; VERIFIED: Phase 34 contracts] | Use `slic3r_contracts` typed values and const constructors; do not pass unchecked raw vendor/source/parity/status strings into registry APIs. [VERIFIED: flavor.rs] |
| V6 Cryptography | no [VERIFIED: no cryptographic behavior in Phase 35 scope] | Do not add crypto or signing/release behavior; fork releases remain deferred. [VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |

### Known Threat Patterns for Static Registry Work

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Metadata overclaiming runtime support | Spoofing / Repudiation [ASSUMED: STRIDE mapping] | Use planning-only `ChecklistStatus`, `parity_dependencies`, and docs that explicitly deny runtime fork parity. [VERIFIED: 35-CONTEXT.md D-15] |
| Runtime side effects in registry construction | Tampering / Information Disclosure [ASSUMED: STRIDE mapping] | Keep registry as static data and verify absence of `std::fs`, `std::process`, `std::env`, network, Git, release, and clock APIs. [VERIFIED: 35-CONTEXT.md D-10] |
| Non-free/network plugin metadata becoming implementation scope | Elevation of Privilege / Information Disclosure [ASSUMED: STRIDE mapping] | Keep cautioned network/plugin rows deferred metadata and do not add credential, device, cloud, or plugin code. [VERIFIED: packages/fork-inventories/README.md; VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/35-flavor-registry-boundary/35-CONTEXT.md` - locked decisions, scope, source references, and Phase 35 success framing. [VERIFIED: cat]
- `.planning/REQUIREMENTS.md` - ARCH-02, ARCH-03, and v1.9 out-of-scope list. [VERIFIED: cat]
- `.planning/ROADMAP.md` - Phase 35 goal, dependency, success criteria, and requirement mapping. [VERIFIED: cat]
- `.planning/STATE.md` - current Phase 35 ready-to-plan state. [VERIFIED: cat]
- `.planning/phases/34-rust-flavor-contracts/34-CONTEXT.md` and `34-01-SUMMARY.md` - Phase 34 contract handoff and actual delivered files. [VERIFIED: cat]
- `packages/slic3r-rust/Cargo.toml`, `Cargo.lock`, `MODULE.bazel`, `.bazelversion`, and Rust/Bazel command probes - workspace membership, versions, and tool availability. [VERIFIED: cat; VERIFIED: cargo metadata; VERIFIED: version commands]
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` and tests - available typed contracts, const constructors, and current `ParitySurface` limitation. [VERIFIED: sed]
- `packages/fork-vendors/forks.tsv` and `packages/fork-inventories/*.tsv` - vendor source pins and inventory evidence. [VERIFIED: cat]
- `packages/fork-inventories/README.md`, `verify_inventories.sh`, and `category-map.tsv` - inventory schema, enum values, validation rules, and exact-once map behavior. [VERIFIED: cat; VERIFIED: sed]

### Secondary (MEDIUM confidence)

- Bright Builds canonical standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: architecture, code shape, verification, testing, and Rust pages. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]

### Tertiary (LOW confidence)

- No unverified web-only sources were used. [VERIFIED: research log]

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - all recommended tools and local crate versions were verified from repo files and command output. [VERIFIED: Cargo.toml; VERIFIED: MODULE.bazel; VERIFIED: version commands]
- Architecture: HIGH - the crate boundary, static registry, and no-side-effects constraints are locked in Phase 35 context and match existing Rust/Bazel patterns. [VERIFIED: 35-CONTEXT.md; VERIFIED: existing BUILD files]
- Pitfalls: MEDIUM-HIGH - the `ParitySurface` const-construction issue is directly verified; the unknown-needs-review interpretation is a real data mismatch but requires planner/user interpretation. [VERIFIED: flavor.rs; VERIFIED: packages/fork-inventories/*.tsv]

**Research date:** 2026-05-27 [VERIFIED: system current_date]
**Valid until:** 2026-06-26 for local code patterns; re-check if Phase 34 contracts or fork inventory TSVs change first. [ASSUMED: 30-day stability window for local architecture research]
