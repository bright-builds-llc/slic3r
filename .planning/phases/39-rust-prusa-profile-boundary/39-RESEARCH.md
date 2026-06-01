# Phase 39: Rust Prusa Profile Boundary - Research

**Researched:** 2026-06-01  
**Domain:** Rust typed parser boundary for checked-in PrusaSlicer profile/config fixtures  
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

## Implementation Decisions

### Rust Boundary Placement

- **D-01:** Add the Prusa profile/config boundary to the shared Rust migration
  workspace under `packages/slic3r-rust`, reusing existing contract and flavor
  crate patterns. Do not create a Prusa-only Rust workspace or copy upstream
  Prusa source.
- **D-02:** Prefer the existing `slic3r_flavors` crate for flavor-specific
  Prusa profile-schema metadata and parser-facing helpers unless research
  finds a clearer existing Rust crate boundary. The boundary must remain pure
  and side-effect free.
- **D-03:** Keep this phase as a typed domain/parser boundary. It may expose
  Rust helpers and tests that consume fixture text supplied by callers, but it
  must not add the repo-owned executable parity command reserved for Phase 40.

### Profile Fixture Parsing and Normalization

- **D-04:** Parse `PrusaResearch.ini` as a static Prusa vendor-bundle profile
  input from Phase 38. The first implementation should focus on stable,
  grep-testable profile/config metadata needed to prove the boundary, not on a
  complete Prusa runtime configuration engine.
- **D-05:** Parse enough of the fixture to produce typed Rust values for the
  Prusa profile-schema capability, including section names, key/value pairs, and
  representative config/profile entries that Phase 40 can compare.
- **D-06:** Normalize values conservatively: preserve raw strings where the
  legacy semantics are not yet modeled, trim only syntactic INI whitespace,
  preserve source section/key identity, and avoid inventing behavioral meaning
  that is not required by Phase 39 requirements.
- **D-07:** Treat parser inputs as caller-provided strings or compile-time test
  fixtures. The Rust domain code must not discover files, walk directories,
  spawn processes, inspect Git, fetch network resources, run profile
  auto-update, or read environment-specific state.

### Provenance and Capability Traceability

- **D-08:** Add or extend typed Rust metadata so `prusaslicer.profile-schema`
  traces to vendor `prusaslicer`, flavor `PrusaSlicer`, source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `resources/profiles/PrusaResearch.ini`, fixture path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini`,
  and checklist status `future-candidate`.
- **D-09:** Reuse existing typed contracts such as `FlavorId`,
  `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`
  wherever they fit. Introduce newtypes/enums only when they encode real Prusa
  profile-schema invariants or prevent confusion between raw strings.
- **D-10:** The Rust metadata may name the future status token
  `fork.prusaslicer.profile-schema` as a planned evidence surface, but it must
  remain a future/reserved token until Phase 40 publishes executable parity
  evidence.

### Verification Shape

- **D-11:** Add focused Rust tests for parser behavior, normalization, and
  provenance traceability. Tests should be one-concern-per-test with explicit
  Arrange, Act, Assert comments when setup is non-trivial.
- **D-12:** Wire the new Rust tests into both Cargo and Bazel verification for
  the affected crate. The phase should keep `//packages/slic3r-rust:verify`
  green and add a narrow crate or test target that Phase 40 can depend on.
- **D-13:** Include negative tests proving side-effect boundaries by API shape
  and behavior: parser functions accept strings/slices, do not require paths,
  and reject malformed or unsupported profile fragments with typed errors
  instead of panics.

### Documentation and Scope Control

- **D-14:** Update port and package docs to explain that Phase 39 creates the
  Rust parser/metadata boundary only. Executable Prusa parity evidence,
  `packages/parity/status.tsv` publication, and the command
  `//packages/parity:prusaslicer_profile_schema_parity` remain Phase 40 scope.
- **D-15:** Preserve Phase 37/38 boundary wording in docs: no full PrusaSlicer
  runtime support, no GUI support, no network/device/cloud/credential behavior,
  no profile auto-update execution, no non-free plugin ingestion, no vendor sync
  automation, and no fork release packaging.

### the agent's Discretion

- Exact Rust module names and file split, provided they follow the existing
  crate style and avoid oversized mixed-responsibility files.
- Whether parser tests use small inline INI fragments, `include_str!` over the
  Phase 38 fixture, or both, provided the production parser remains pure and
  the tests verify real fixture compatibility.
- Exact typed error names and display text, provided unsupported and malformed
  inputs do not panic and failures are easy to diagnose.
- Whether the Prusa profile-schema capability is represented as an extension of
  the existing flavor registry or a small adjacent module re-exported from
  `slic3r_flavors`, provided downstream code can trace the capability without
  parsing TSV files at runtime.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

- Executable Prusa profile/config parity command is Phase 40 scope.
- Publishing a Prusa row to `packages/parity/status.tsv` is Phase 40 scope and
  requires the executable parity command.
- Full PrusaSlicer runtime support, project files, STEP import, support
  generation, arc fitting, wall seam behavior, network/device integration,
  profile auto-update execution, GUI support, sync automation, and fork release
  packaging remain out of scope for v1.10 Phase 39.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PROF-01 | Developer can parse the v1.10 Prusa profile/config fixtures into typed Rust domain values before the data reaches core profile or config logic. [VERIFIED: .planning/REQUIREMENTS.md] | Add a pure `slic3r_flavors` parser module that accepts `&str`, parses section headers and first-`=` key/value pairs, preserves source identity, and returns typed Rust values. [VERIFIED: 39-CONTEXT.md D-01..D-07; VERIFIED: fixture shape audit] |
| PROF-02 | Developer can trace the Prusa profile schema/config capability from Rust metadata back to the Prusa inventory row, accepted vendor source identity, source path, and checklist status. [VERIFIED: .planning/REQUIREMENTS.md] | Extend or add adjacent Rust metadata for `prusaslicer.profile-schema` using `FlavorId::PrusaSlicer`, `VendorSourceRef::prusa_slicer_version_2_9_5()`, `FeatureOrigin::ForkSpecific`, `ParitySurface::config()`, `ParitySurface::config_persistence()`, and `ChecklistStatus::FutureCandidate`. [VERIFIED: flavor.rs; VERIFIED: registry.rs; VERIFIED: packages/fork-inventories/prusaslicer.tsv] |
| PROF-03 | Developer can verify Prusa profile/config parsing and normalization logic with focused Rust unit tests that do not perform Git, network, filesystem discovery, process, release, or vendor sync operations. [VERIFIED: .planning/REQUIREMENTS.md] | Add focused Cargo and Bazel tests under `slic3r_flavors`, use inline strings plus optional `include_str!` test fixture input, and add negative tests for malformed input and side-effect boundary API shape. [VERIFIED: 39-CONTEXT.md D-11..D-13; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
</phase_requirements>

## Summary

Phase 39 should extend the existing shared Rust migration workspace, not create a vendor-specific workspace. [VERIFIED: 39-CONTEXT.md D-01] The best implementation target is `packages/slic3r-rust/crates/slic3r_flavors`, because that crate already owns pure static flavor/capability metadata and depends on `slic3r_contracts`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]

The parser should be a bounded Prusa profile boundary parser, not a general INI editor and not a PrusaSlicer runtime configuration engine. [VERIFIED: 39-CONTEXT.md D-03..D-07] The checked-in `PrusaResearch.ini` fixture is a 1,543,688-byte LF file with 42,247 lines, 6,976 sections, and 27,340 key/value lines, and the section kinds are `vendor`, `printer_model`, `print`, `filament`, and `printer`. [VERIFIED: wc/awk fixture audit; VERIFIED: fixture-provenance.tsv]

The planner should include metadata and tests as first-class deliverables. [VERIFIED: 39-CONTEXT.md D-08..D-13] The new capability must remain a future candidate and must not publish `fork.prusaslicer.profile-schema` in `packages/parity/status.tsv` or create `//packages/parity:prusaslicer_profile_schema_parity`, because those are Phase 40 scope. [VERIFIED: packages/parity/README.md; VERIFIED: docs/port/migration-guidance.md; VERIFIED: 39-CONTEXT.md D-10, D-14]

**Primary recommendation:** Add `slic3r_flavors::prusa_profile` as a pure std-only parser/metadata module, extend the flavor registry with `prusaslicer.profile-schema` capability metadata, expose a narrow `parse_prusa_profile_bundle(&str) -> Result<PrusaProfileBundle, PrusaProfileParseError>` API, and wire focused Cargo/Bazel tests without adding runtime file discovery or a parity command. [VERIFIED: 39-CONTEXT.md; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; VERIFIED: Bright Builds architecture standard]

## Project Constraints (from AGENTS.md)

- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant canonical Bright Builds standards before planning, review, implementation, or audit work. [VERIFIED: AGENTS.md; VERIFIED: AGENTS.bright-builds.md]
- Use repo-local `AGENTS.md` guidance before Bright Builds defaults, and keep downstream-specific rules outside the managed Bright Builds block. [VERIFIED: AGENTS.md; VERIFIED: AGENTS.bright-builds.md]
- For phase summary files, keep YAML `requirements-completed` synchronized, hyphenated, and avoid `mdformat` over `*-SUMMARY.md`; this phase writes research, not summaries, but the planner should preserve this rule for later artifacts. [VERIFIED: AGENTS.md]
- Bright Builds requires functional core / imperative shell, parse-at-boundaries domain types, and illegal-state prevention where practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Bright Builds Rust guidance requires `foo.rs` plus `foo/` over new `foo/mod.rs` multi-file modules, `let...else` for guard extraction when clearer, `maybe_` names for optional internals, newtypes/enums for real invariants, and thin adapters around pure core logic. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Unit tests for pure/business logic are required, one concern per test, with clear Arrange/Act/Assert structure by default. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Before committing Rust project changes, the global repo instructions require `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features`. [VERIFIED: AGENTS.md]
- No project-local `.claude/skills/` or `.agents/skills/` directories were present during research. [VERIFIED: find .claude/skills .agents/skills]
- No `tasks/lessons.md` or `.codex/tasks/lessons.md` file was present to review. [VERIFIED: ls tasks .codex/tasks]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Rust toolchain via `rustup run 1.94.1` | `rustc 1.94.1`, `cargo 1.94.1` | Compile and test the Rust 2024 workspace. [VERIFIED: rustup run 1.94.1 rustc/cargo --version] | The workspace declares edition `2024` and `rust-version = "1.94"`, while Bazel registers Rust `1.94.1`. [VERIFIED: packages/slic3r-rust/Cargo.toml; VERIFIED: MODULE.bazel] |
| Rust standard library | Rust 1.94.1 | Implement the bounded line parser, error types, vectors, strings, and iterators. [VERIFIED: packages/slic3r-rust/Cargo.toml; VERIFIED: cargo info alternatives] | Existing Rust crates are std-only except local workspace dependencies, and Phase 39 does not need a runtime dependency for a narrow source-preserving parser. [VERIFIED: packages/slic3r-rust/crates/*/Cargo.toml; VERIFIED: 39-CONTEXT.md D-04..D-07] |
| `slic3r_contracts` | `0.1.0` | Reuse `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml; VERIFIED: flavor.rs] | These types already encode canonical fork/flavor/source/parity/checklist tokens and reject noncanonical values. [VERIFIED: flavor.rs; VERIFIED: flavor_contracts.rs] |
| `slic3r_flavors` | `0.1.0` | Own Prusa profile-schema metadata and parser-facing helpers. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | The crate already composes flavor capability metadata as pure static Rust values and exposes lookup/filter helpers. [VERIFIED: registry.rs; VERIFIED: docs/port/contract-inventory.md] |
| Bazel | `8.6.0` | Run crate tests, rustfmt tests, clippy targets, and aggregate Rust verification. [VERIFIED: .bazelversion; VERIFIED: bazel --version] | The repository pins Bazel `8.6.0` and the Rust package exposes `//packages/slic3r-rust:verify`. [VERIFIED: .bazelversion; VERIFIED: packages/slic3r-rust/BUILD.bazel] |
| `rules_rust` | `0.69.0` | Provide `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test`. [VERIFIED: MODULE.bazel; VERIFIED: slic3r_flavors/BUILD.bazel] | Existing Rust crates use these rules for library, test, clippy, and formatting coverage. [VERIFIED: slic3r_contracts/BUILD.bazel; VERIFIED: slic3r_flavors/BUILD.bazel] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| `include_str!` in tests only | Rust 1.94.1 macro | Compile the checked-in fixture into a test binary without production filesystem discovery. [VERIFIED: Rust std macro availability; VERIFIED: 39-CONTEXT.md D-07, D-11] | Use for fixture compatibility tests after inline parser unit tests cover small malformed and normalization cases. [VERIFIED: 39-CONTEXT.md D-11..D-13] |
| `//packages/parity-fixtures:prusa_profile_schema_bundle` | Bazel filegroup/fixture bundle | Provide fixture data to Bazel tests when a test target needs the raw `PrusaResearch.ini`. [VERIFIED: packages/parity-fixtures/BUILD.bazel] | Use as `data` for a Bazel `rust_test` if the planner prefers runtime testdata over `include_str!`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: 39-CONTEXT.md D-11 discretion] |
| `//packages/slic3r-rust:verify` | Bazel test suite | Confirm the aggregate Rust verification surface stays green. [VERIFIED: packages/slic3r-rust/BUILD.bazel] | Run after adding the narrow crate test target to the suite. [VERIFIED: 39-CONTEXT.md D-12] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Bounded std-only parser | `rust-ini` `0.21.3` | `rust-ini` is a general INI configuration parser with MIT license and Rust 1.64 minimum, but Phase 39 only needs a source-preserving typed boundary and the workspace currently avoids nonlocal dependencies for this crate. [VERIFIED: cargo info rust-ini; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; VERIFIED: 39-CONTEXT.md D-04..D-07] |
| Bounded std-only parser | `configparser` `3.1.0` / `ini` `1.3.0` | These crates target customizable application settings and would add a new dependency for behavior that is smaller than the phase's required source-preserving syntax slice. [VERIFIED: cargo info configparser; VERIFIED: cargo info ini; VERIFIED: 39-CONTEXT.md D-06] |
| Bounded std-only parser | `ini_core` `0.2.0` | `ini_core` is a bare-bones streaming INI parser, but using it still adds a dependency where a first-`=` line parser can satisfy the fixture format and preserve exact source line identity. [VERIFIED: cargo info ini_core; VERIFIED: fixture shape audit] |
| Bounded std-only parser | `ini-edit` `0.2.1` / `ini-preserve` `0.1.1` | These format-preserving crates are useful for editing or round-tripping INI files, but Phase 39 does not edit or write Prusa profiles. [VERIFIED: cargo info ini-edit; VERIFIED: cargo info ini-preserve; VERIFIED: 39-CONTEXT.md D-03] |

**Installation / dependency change:** No new Cargo dependency is recommended for Phase 39. [VERIFIED: package Cargo.toml audit; VERIFIED: 39-CONTEXT.md D-04..D-07]

```bash
# Use existing workspace crates and the pinned Rust toolchain.
rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_test
```

**Version verification:** `rustup run 1.94.1 rustc --version`, `rustup run 1.94.1 cargo --version`, `.bazelversion`, `bazel --version`, `MODULE.bazel`, and `cargo info` were used to verify versions during research. [VERIFIED: local command audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
|-- BUILD.bazel                 # add parser test and include it in clippy/rustfmt deps [VERIFIED: existing BUILD.bazel]
|-- Cargo.toml                  # keep only local slic3r_contracts dependency [VERIFIED: existing Cargo.toml]
|-- src/
|   |-- lib.rs                  # re-export parser and metadata API [VERIFIED: existing lib.rs pattern]
|   |-- registry.rs             # extend Prusa capability metadata [VERIFIED: existing registry.rs pattern]
|   `-- prusa_profile.rs        # new pure Prusa profile-schema parser boundary [VERIFIED: 39-CONTEXT.md D-02]
`-- tests/
    |-- flavor_registry.rs      # extend provenance/no-overclaiming registry tests [VERIFIED: existing test]
    `-- prusa_profile.rs        # new parser and normalization tests [VERIFIED: 39-CONTEXT.md D-11]
```

### Pattern 1: Extend Registry Metadata Without Claiming Runtime Support

**What:** Add a `prusaslicer.profile-schema` `FlavorCapability` for `FlavorId::PrusaSlicer` with `FeatureOrigin::ForkSpecific`, `ChecklistStatus::FutureCandidate`, provenance pointing at `resources/profiles/PrusaResearch.ini`, and dependencies on `ParitySurface::config()` plus `ParitySurface::config_persistence()`. [VERIFIED: packages/fork-inventories/prusaslicer.tsv; VERIFIED: registry.rs; VERIFIED: flavor.rs]

**When to use:** Use this when Phase 39 needs Rust metadata traceability but not executable parity status publication. [VERIFIED: 39-CONTEXT.md D-08..D-10]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs
static PRUSA_PROFILE_SCHEMA_PARITY: [ParitySurface; 2] = [
    ParitySurface::config(),
    ParitySurface::config_persistence(),
];

static PRUSA_PROFILE_SCHEMA_PATHS: [&str; 1] = ["resources/profiles/PrusaResearch.ini"];

static PRUSA_PROFILE_SCHEMA_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: "prusaslicer.profile-schema",
    vendor_source: VendorSourceRef::prusa_slicer_version_2_9_5(),
    source_paths: &PRUSA_PROFILE_SCHEMA_PATHS,
    ownership: FeatureOrigin::ForkSpecific,
}];
```

### Pattern 2: Adjacent Fixture Metadata For Paths Not Represented By `FlavorCapability`

**What:** Use a small adjacent metadata struct for fixture path, checklist path, and reserved future status token if adding those fields to every `FlavorCapability` would pollute unrelated rows. [VERIFIED: registry.rs lacks fixture/checklist path fields; VERIFIED: 39-CONTEXT.md D-08]

**When to use:** Use this if the planner wants exact Phase 38 fixture traceability without changing all existing capability rows. [VERIFIED: 39-CONTEXT.md "the agent's Discretion"]

**Example:**

```rust
// Source: recommended synthesis from 39-CONTEXT.md and registry.rs.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaProfileSchemaMetadata {
    pub capability_id: &'static str,
    pub fixture_path: &'static str,
    pub checklist_path: &'static str,
    pub future_status_token: &'static str,
}

pub const PRUSA_PROFILE_SCHEMA_METADATA: PrusaProfileSchemaMetadata =
    PrusaProfileSchemaMetadata {
        capability_id: "prusaslicer.profile-schema",
        fixture_path: "packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini",
        checklist_path: "packages/prusa-baseline/profile-schema-checklist.md",
        future_status_token: "fork.prusaslicer.profile-schema",
    };
```

### Pattern 3: Line-Oriented Source-Preserving Parser

**What:** Parse caller-provided `&str` line by line, keep source line numbers, preserve section/key identity, split key/value on the first `=`, and reject malformed lines with typed errors. [VERIFIED: 39-CONTEXT.md D-05..D-07, D-13; VERIFIED: fixture shape audit]

**When to use:** Use this for Phase 39 because the fixture audit found no non-section/non-comment/non-blank/non-key-value lines and found values with additional `=` characters. [VERIFIED: awk fixture audit]

**Example:**

```rust
// Source: recommended parser shape from fixture audit and Bright Builds parse-boundary rule.
pub fn parse_prusa_profile_bundle(input: &str) -> Result<PrusaProfileBundle, PrusaProfileParseError> {
    let mut sections = Vec::new();
    let mut maybe_current: Option<PrusaProfileSection> = None;

    for (zero_based_line, raw_line) in input.lines().enumerate() {
        let line_number = zero_based_line + 1;
        let trimmed = raw_line.trim();
        if trimmed.is_empty() || trimmed.starts_with('#') || trimmed.starts_with(';') {
            continue;
        }

        if trimmed.starts_with('[') {
            if let Some(section) = maybe_current.take() {
                sections.push(section);
            }
            maybe_current = Some(parse_section_header(trimmed, line_number)?);
            continue;
        }

        let Some(section) = maybe_current.as_mut() else {
            return Err(PrusaProfileParseError::EntryBeforeSection { line_number });
        };
        let entry = parse_key_value(raw_line, line_number)?;
        section.entries.push(entry);
    }

    if let Some(section) = maybe_current {
        sections.push(section);
    }

    Ok(PrusaProfileBundle { sections })
}
```

### Anti-Patterns to Avoid

- **Runtime file reads in production parser:** Production functions must accept strings/slices supplied by callers and must not discover fixture paths. [VERIFIED: 39-CONTEXT.md D-07, D-13]
- **Map-only representation:** A `HashMap<section, HashMap<key, value>>` loses section order, duplicate-entry evidence, and line-level traceability needed for fixture comparison. [VERIFIED: PROF-01/PROF-02 requirements; VERIFIED: fixture shape audit]
- **Inline comment stripping:** The fixture contains values with semicolon-delimited material lists and G-code comments, so `;` must remain data except when it starts a trimmed comment line. [VERIFIED: PrusaResearch.ini fixture audit]
- **Splitting on every `=`:** Values contain URLs and compatibility expressions with `=`, `==`, and regex operators, so key/value parsing must split on the first `=` only. [VERIFIED: awk NF>2 fixture audit]
- **Adding `ParitySurface::fork_prusaslicer_profile_schema()`:** Existing `ParitySurface` constructors mirror active `packages/parity/status.tsv` surfaces, and the fork token is reserved until Phase 40. [VERIFIED: flavor.rs; VERIFIED: packages/parity/status.tsv; VERIFIED: packages/parity/README.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Canonical vendor/flavor/source/checklist token parsing | New string parsers in `slic3r_flavors` | Existing `slic3r_contracts` types and constructors | These types already reject branch heads, malformed source refs, noncanonical flavors, and noncanonical statuses. [VERIFIED: flavor.rs; VERIFIED: flavor_contracts.rs] |
| Full PrusaSlicer config/profile runtime semantics | Inheritance resolver, preset compatibility evaluator, G-code expression evaluator, profile auto-update implementation | Raw typed sections/entries plus conservative normalization | Phase 39 is explicitly a parser/domain boundary and Phase 40 owns executable comparison. [VERIFIED: 39-CONTEXT.md D-03..D-07; VERIFIED: ROADMAP.md] |
| Fixture provenance validation shell logic | Duplicate SHA/size/provenance verifier in Rust parser | Existing `//packages/parity-fixtures:verify_prusa_profile_schema_fixture` | Phase 38 already owns fixture integrity and status non-publication checks. [VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: verify_prusa_profile_schema_fixture.sh] |
| Executable parity command | `//packages/parity:prusaslicer_profile_schema_parity` in Phase 39 | Defer to Phase 40 | Phase 39 must not create the repo-owned executable parity command. [VERIFIED: 39-CONTEXT.md D-03, D-14; VERIFIED: docs/port/migration-guidance.md] |
| Runtime fork support or release channels | Launcher dispatch, fork builds, installer/release packaging, GUI integration | Documentation that names the Phase 39 parser boundary only | v1.10 Phase 39 excludes runtime support, GUI, sync, and release packaging. [VERIFIED: 39-CONTEXT.md D-15; VERIFIED: .planning/REQUIREMENTS.md Out of Scope] |
| General-purpose INI round-trip editing | Format-preserving writer/editor | Bounded read-only parser | Phase 39 reads static evidence and does not edit or write Prusa profile files. [VERIFIED: 39-CONTEXT.md D-03..D-07; VERIFIED: cargo info ini-edit; VERIFIED: cargo info ini-preserve] |

**Key insight:** The parser is allowed to be custom because it is a narrow boundary over a source-pinned fixture format, but the plan must not let that grow into a custom Prusa runtime engine. [VERIFIED: 39-CONTEXT.md D-04..D-07]

## Common Pitfalls

### Pitfall 1: Treating Static Metadata As Verified Fork Support

**What goes wrong:** The implementation adds `fork.prusaslicer.profile-schema` to `status.tsv` or public helper names imply verified support. [VERIFIED: packages/parity/README.md; VERIFIED: flavor_registry.rs runtime-claim test pattern]

**Why it happens:** Phase 39 metadata is close to parity evidence but lacks the Phase 40 executable command. [VERIFIED: ROADMAP.md Phase 39/40 split]

**How to avoid:** Keep the token as reserved/future metadata only and add tests that the status table has no Prusa row if docs are touched. [VERIFIED: docs/port/migration-guidance.md; VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh]

**Warning signs:** A diff adds `prusaslicer_profile_schema_parity`, edits `packages/parity/status.tsv`, or introduces helper names containing `verified`, `supported`, `release`, or runtime dispatch language. [VERIFIED: 39-CONTEXT.md D-10, D-14, D-15; VERIFIED: flavor_registry.rs]

### Pitfall 2: Losing Source Traceability During Parsing

**What goes wrong:** Parsed values cannot be traced back to a source line, section header, key, fixture path, source path, or accepted source pin. [VERIFIED: PROF-01/PROF-02; VERIFIED: 39-CONTEXT.md D-08]

**Why it happens:** Generic config-shaped maps collapse order and source location into final values. [VERIFIED: fixture audit showed 6,976 sections and 27,340 key/value lines]

**How to avoid:** Store `section_index`, `line_number`, section kind/name, key, normalized value, and raw/source line enough for diagnostic tests. [VERIFIED: PROF-01/PROF-02 requirements; VERIFIED: 39-CONTEXT.md D-06, D-08]

**Warning signs:** Parser tests assert only `bundle.get("vendor", "config_version")` and never assert line, section, source path, or provenance metadata. [VERIFIED: 39-CONTEXT.md D-08, D-11..D-13]

### Pitfall 3: Incorrect INI Tokenization

**What goes wrong:** Values after `=` are truncated, inline semicolon content is stripped, or G-code/template values are interpreted. [VERIFIED: PrusaResearch.ini fixture audit]

**Why it happens:** Ordinary INI assumptions do not hold for slicer profile fields that contain URLs, regex comparisons, G-code comments, escaped `\n`, and semicolon-delimited lists. [VERIFIED: awk NF>2 fixture audit; VERIFIED: PrusaResearch.ini sample lines]

**How to avoid:** Split only on the first `=`, trim section/key/value syntactic whitespace, skip only whole-line comments after trimming, and keep value contents opaque. [VERIFIED: 39-CONTEXT.md D-06]

**Warning signs:** Parser code uses `.split('=')`, strips `;.*$`, parses numbers/booleans globally, unescapes `\n`, or evaluates `compatible_printers_condition`. [VERIFIED: fixture audit; VERIFIED: 39-CONTEXT.md D-06]

### Pitfall 4: Production Parser Reads Test Fixture Files

**What goes wrong:** `parse_prusa_profile_bundle` takes a path or reads `PrusaResearch.ini` internally. [VERIFIED: 39-CONTEXT.md D-07, D-13]

**Why it happens:** Fixture compatibility tests can legitimately use `include_str!` or Bazel data, and that can leak into production API design. [VERIFIED: 39-CONTEXT.md "the agent's Discretion"]

**How to avoid:** Keep production APIs data-in/data-out and limit fixture loading to tests. [CITED: Bright Builds architecture standard; VERIFIED: 39-CONTEXT.md D-07]

**Warning signs:** Production code imports `std::fs`, `std::env`, `std::process`, `SystemTime`, `Instant`, or path types for parser work. [VERIFIED: existing no-side-effect grep pattern from Phase 35 summary; VERIFIED: 39-CONTEXT.md D-07]

### Pitfall 5: Using The Default Rust Toolchain

**What goes wrong:** Local Cargo commands run with Rust 1.91.1 while the workspace and Bazel setup expect Rust 1.94/1.94.1. [VERIFIED: rustc --version; VERIFIED: packages/slic3r-rust/Cargo.toml; VERIFIED: MODULE.bazel]

**Why it happens:** `rustc` on PATH is older than the installed `1.94.1` rustup toolchain. [VERIFIED: rustc --version; VERIFIED: rustup toolchain list]

**How to avoid:** Use `rustup run 1.94.1 cargo ...` for Cargo verification and Bazel/Bazelisk for Bazel verification. [VERIFIED: rustup run 1.94.1; VERIFIED: .bazelversion]

**Warning signs:** `cargo test` fails with edition or rust-version errors before tests run. [ASSUMED]

## Code Examples

Verified patterns from local sources and constrained recommendations:

### Metadata Capability Lookup

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs
fn maybe_capability(capability_id: &str) -> Option<&'static FlavorCapability> {
    all_capabilities().find(|capability| capability.capability_id == capability_id)
}
```

### Focused Parser Test Shape

```rust
// Source: Bright Builds testing standard and existing Rust tests in flavor_registry.rs.
#[test]
fn parses_vendor_section_with_source_line_numbers() {
    // Arrange
    let input = "\
[vendor]
repo_id = prusa-fff
config_version = 2.4.14
";

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("fixture fragment should parse");

    // Assert
    assert_eq!(bundle.sections[0].kind, PrusaProfileSectionKind::Vendor);
    assert_eq!(bundle.sections[0].entries[0].key.as_str(), "repo_id");
    assert_eq!(bundle.sections[0].entries[0].line_number, 2);
}
```

### Negative Parser Test Shape

```rust
// Source: 39-CONTEXT.md D-13.
#[test]
fn rejects_key_value_before_first_section() {
    // Arrange
    let input = "config_version = 2.4.14\n";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProfileParseError::EntryBeforeSection { line_number: 1 })
    ));
}
```

### Fixture Compatibility Test Shape

```rust
// Source: 39-CONTEXT.md allows include_str! for tests; production parser still accepts &str.
#[test]
fn parses_checked_in_prusa_research_fixture_without_side_effects() {
    // Arrange
    let input = include_str!("../../../../parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini");

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("PrusaResearch.ini should parse");

    // Assert
    assert_eq!(bundle.sections.len(), 6976);
    assert!(bundle.sections.iter().any(|section| section.kind == PrusaProfileSectionKind::Vendor));
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source pins, fork inventories, and static registry metadata only | Add typed Rust parser values for the Prusa profile-schema fixture before core profile/config logic sees raw strings | Phase 39 after Phase 38 fixture completion [VERIFIED: ROADMAP.md; VERIFIED: STATE.md] | Phase 40 can compare Rust-backed parsed/normalized output against checked-in fixture expectations. [VERIFIED: ROADMAP.md Phase 40] |
| Treat fork profile schema as a planning row | Represent `prusaslicer.profile-schema` in Rust metadata with source/ref/checklist/fixture traceability | Phase 39 [VERIFIED: 39-CONTEXT.md D-08] | Developers can inspect provenance without parsing TSV files at runtime. [VERIFIED: 39-CONTEXT.md "the agent's Discretion"] |
| General INI parser dependency as the default instinct | Bounded std-only parser for a source-pinned read-only evidence format | Phase 39 recommendation [VERIFIED: Cargo dependency audit; VERIFIED: fixture audit] | Avoids new dependency and avoids over-modeling Prusa runtime semantics. [VERIFIED: 39-CONTEXT.md D-04..D-07] |
| ASVS v4-style category labels in local templates | ASVS 5.0.0 official docs recommend version-qualified numeric identifiers | ASVS 5.0.0 released 2025-05-30 [CITED: https://owasp.org/www-project-application-security-verification-standard/] | Security notes should map controls descriptively and avoid claiming formal ASVS coverage from this parser-only phase. [CITED: https://owasp.org/www-project-application-security-verification-standard/] |

**Deprecated/outdated:**

- Publishing fork status from static metadata is outdated for this milestone; verified fork rows require executable parity evidence. [VERIFIED: packages/parity/README.md; VERIFIED: docs/port/migration-guidance.md]
- Creating vendor-specific Rust workspaces conflicts with current milestone decisions; use the shared `slic3r_flavors` crate. [VERIFIED: 39-CONTEXT.md D-01; VERIFIED: STATE.md]
- Using unqualified ASVS requirement numbers is discouraged by current OWASP ASVS docs because identifiers can change between versions. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Parser command failures caused by default `cargo test` may present as rust-version or edition errors when PATH uses Rust 1.91.1. [ASSUMED] | Common Pitfalls | Low; planner can avoid the risk by using `rustup run 1.94.1` commands already verified in Environment Availability. |
| A2 | The GSD security template's legacy ASVS category labels should be kept for planner compatibility even though OWASP ASVS 5.0.0 recommends version-qualified numeric identifiers. [ASSUMED: GSD template compatibility] | Security Domain / Metadata | Low; affects wording only, not parser controls. |
| A3 | Research validity through 2026-07-01 is an estimate for local architecture and fixture findings. [ASSUMED] | Metadata | Low; planner can re-run targeted version checks if implementation happens later. |

## Open Questions

1. **Checklist signoff wording remains pending**
   - What we know: `packages/prusa-baseline/profile-schema-checklist.md` still says reviewer signoff is `PENDING - human reviewer name and UTC date required before implementation consumes this gate`. [VERIFIED: profile-schema-checklist.md]
   - What's unclear: Phase 39 context is marked ready in yolo mode, so the planner needs to decide whether this pending wording is acceptable for implementation or should become a documentation/task item. [VERIFIED: 39-CONTEXT.md frontmatter; VERIFIED: STATE.md]
   - Recommendation: Do not block research; include a planning task or verification note to preserve or resolve the signoff wording according to current project process. [VERIFIED: profile-schema-checklist.md; VERIFIED: 39-CONTEXT.md frontmatter]

2. **Exact metadata field placement**
   - What we know: Existing `FlavorCapability` has checklist status and provenance but lacks fixture path, checklist path, or future status token fields. [VERIFIED: registry.rs]
   - What's unclear: The implementation can either extend `FlavorCapability` globally or add adjacent Prusa profile-schema metadata. [VERIFIED: 39-CONTEXT.md "the agent's Discretion"]
   - Recommendation: Prefer adjacent `PrusaProfileSchemaMetadata` unless multiple capabilities need fixture/checklist/future-token fields in this phase. [VERIFIED: registry.rs; VERIFIED: 39-CONTEXT.md "the agent's Discretion"]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| `rustup` | Running the pinned Rust 1.94.1 toolchain | Yes [VERIFIED: command -v rustup] | rustup installed with `1.94.1-aarch64-apple-darwin` [VERIFIED: rustup toolchain list] | None needed |
| `rustc` / `cargo` default PATH | Ad hoc Cargo commands | Available but wrong for workspace [VERIFIED: rustc --version; cargo --version] | `rustc 1.91.1`, `cargo 1.91.1` [VERIFIED: local command audit] | Use `rustup run 1.94.1` |
| `rustc` / `cargo` via `rustup run 1.94.1` | Workspace Cargo checks | Yes [VERIFIED: rustup run 1.94.1 rustc/cargo --version] | `rustc 1.94.1`, `cargo 1.94.1` [VERIFIED: local command audit] | None needed |
| Bazel | Bazel tests and aggregate verify | Yes [VERIFIED: command -v bazel] | `8.6.0` [VERIFIED: bazel --version; .bazelversion] | Bazelisk also available |
| Bazelisk | Local launcher for pinned Bazel | Yes [VERIFIED: command -v bazelisk] | `1.28.1` [VERIFIED: bazelisk version] | Use `bazel` directly; both resolve to 8.6.0 in this repo [VERIFIED: .bazelversion] |
| Network access | `cargo info` research only | Yes during research [VERIFIED: cargo info outputs] | crates.io current as of 2026-06-01 [VERIFIED: cargo info outputs] | Not required for implementation if no new deps are added |

**Missing dependencies with no fallback:**

- None found for Phase 39 implementation and verification. [VERIFIED: environment audit]

**Missing dependencies with fallback:**

- Default PATH Rust is below the workspace/Bazel target version; use `rustup run 1.94.1`. [VERIFIED: rustc --version; VERIFIED: rustup run 1.94.1]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

OWASP ASVS 5.0.0 is the current stable ASVS version, and OWASP recommends version-qualified requirement identifiers because identifiers can change between versions. [CITED: https://owasp.org/www-project-application-security-verification-standard/] The table below keeps the GSD template's legacy category labels while mapping controls descriptively for this parser-only phase. [ASSUMED: GSD template compatibility]

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No | No authn surface is introduced because parser inputs are caller-provided strings and no users, credentials, sessions, or remote services are involved. [VERIFIED: 39-CONTEXT.md D-07, D-15] |
| V3 Session Management | No | No session state is introduced. [VERIFIED: 39-CONTEXT.md D-07, D-15] |
| V4 Access Control | No | No authorization boundary is introduced; fixture provenance remains checked-in metadata and the parser is pure. [VERIFIED: 39-CONTEXT.md D-07; VERIFIED: fixture-provenance.tsv] |
| V5 Input Validation | Yes | Parse at the boundary into typed Rust values, reject malformed/unsupported fragments with typed errors, and avoid `panic!`, `unwrap()`, or silent fallback. [VERIFIED: 39-CONTEXT.md D-13; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md] |
| V6 Cryptography | No | No cryptographic operation is introduced; SHA-256 fixture integrity remains owned by the Phase 38 shell verifier, not the Rust parser. [VERIFIED: verify_prusa_profile_schema_fixture.sh; VERIFIED: 39-CONTEXT.md D-03] |

### Known Threat Patterns for Rust Prusa Profile Parser

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Malformed profile fragment causes panic | Denial of Service | Return `PrusaProfileParseError` for malformed headers, key/value before section, empty keys, unsupported section kinds, and unterminated headers. [VERIFIED: 39-CONTEXT.md D-13] |
| Fixture tampering is mistaken for accepted source evidence | Tampering | Keep provenance metadata tied to the accepted source ref and rely on the existing Phase 38 fixture verifier for size/SHA/source-path checks. [VERIFIED: fixture-provenance.tsv; VERIFIED: verify_prusa_profile_schema_fixture.sh] |
| Runtime side effects leak credentials or environment state | Information Disclosure | Keep production parser free of `std::fs`, `std::env`, `std::process`, network calls, clocks, and profile auto-update behavior. [VERIFIED: 39-CONTEXT.md D-07, D-15] |
| Overbroad parsing evaluates G-code or compatibility expressions | Tampering / Elevation of Privilege | Treat values as opaque strings in Phase 39 and do not evaluate profile expressions, commands, or update URLs. [VERIFIED: 39-CONTEXT.md D-06; VERIFIED: PrusaResearch.ini fixture audit] |

## Sources

### Primary (HIGH Confidence)

- `.planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md` - locked decisions, discretion, deferred scope, and canonical refs. [VERIFIED: mandatory read]
- `.planning/REQUIREMENTS.md` - PROF-01, PROF-02, PROF-03 and v1.10 out-of-scope table. [VERIFIED: mandatory read]
- `.planning/ROADMAP.md` - Phase 39 goal/success criteria and Phase 40 split. [VERIFIED: mandatory read]
- `.planning/STATE.md` - current milestone decisions and shared `slic3r_flavors` direction. [VERIFIED: mandatory read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: mandatory read]
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - typed fork/flavor/source/origin/surface/status contracts. [VERIFIED: mandatory read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - existing pure registry pattern. [VERIFIED: mandatory read]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` - existing test style and no-overclaiming checks. [VERIFIED: mandatory read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md` and `fixture-provenance.tsv` - fixture identity, source ref, source paths, sizes, hashes, and scope. [VERIFIED: mandatory read]
- `packages/prusa-baseline/profile-schema-checklist.md` - profile-schema checklist row, candidate module, and pending reviewer-signoff wording. [VERIFIED: mandatory read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini` - fixture shape audit for parser syntax. [VERIFIED: local awk/wc audit]
- `packages/slic3r-rust/Cargo.toml`, `MODULE.bazel`, `.bazelversion`, and Rust crate `BUILD.bazel` files - toolchain and verification wiring. [VERIFIED: local file reads]
- Bright Builds canonical standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape, verification, testing, Rust. [CITED: AGENTS.bright-builds.md; CITED: raw.githubusercontent.com/bright-builds-llc/bright-builds-rules]
- OWASP ASVS official project page - current ASVS version and reference guidance. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Secondary (MEDIUM Confidence)

- `cargo info rust-ini`, `cargo info configparser`, `cargo info ini`, `cargo info ini_core`, `cargo info ini-edit`, `cargo info ini-preserve` - current crates.io versions and descriptions for INI alternatives. [VERIFIED: crates.io via cargo]
- `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`, `docs/port/contract-inventory.md` - status and documentation boundaries. [VERIFIED: local file reads]
- `packages/parity/README.md` and `packages/parity/status.tsv` - status publication rules and current absence of Prusa row. [VERIFIED: local file reads]

### Tertiary (LOW Confidence)

- A1 in Assumptions Log about exact failure shape when default Rust 1.91.1 is used for this workspace. [ASSUMED]
- A2 in Assumptions Log about keeping the GSD template's legacy ASVS category labels for planner compatibility. [ASSUMED: GSD template compatibility]
- A3 in Assumptions Log about the research validity window. [ASSUMED]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - local Cargo/Bazel files and installed toolchains were verified, and no new dependency is recommended. [VERIFIED: local command audit]
- Architecture: HIGH - locked context, existing crate boundaries, and Bright Builds standards all point to a pure `slic3r_flavors` parser/metadata module. [VERIFIED: 39-CONTEXT.md; VERIFIED: registry.rs; CITED: Bright Builds architecture standard]
- Parser shape: HIGH - fixture audit verified the exact line categories, section kinds, first-`=` risk, and file size/line counts needed to plan tests. [VERIFIED: awk/wc fixture audit]
- Pitfalls: HIGH - each major pitfall is tied to a locked Phase 39 boundary, fixture syntax evidence, or existing status/no-overclaiming docs. [VERIFIED: 39-CONTEXT.md; VERIFIED: packages/parity/README.md; VERIFIED: PrusaResearch.ini audit]
- Security: MEDIUM - phase-specific security controls are verified, but ASVS category labels are mapped through the GSD template while ASVS 5.0.0 uses current version-qualified identifiers. [CITED: https://owasp.org/www-project-application-security-verification-standard/; ASSUMED: GSD template compatibility]

**Research date:** 2026-06-01  
**Valid until:** 2026-07-01 for local architecture and fixture findings; re-check toolchain/crates.io versions if adding external dependencies after that date. [ASSUMED]
