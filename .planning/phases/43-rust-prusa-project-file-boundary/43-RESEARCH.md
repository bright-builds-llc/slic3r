# Phase 43: Rust Prusa Project-File Boundary - Research

**Researched:** 2026-06-05 [VERIFIED: environment context]
**Domain:** Rust domain boundary for PrusaSlicer project-file evidence [VERIFIED: .planning/ROADMAP.md]
**Confidence:** HIGH [VERIFIED: local codebase inspection; cited Bright Builds standards]

<user_constraints>

## User Constraints (from CONTEXT.md)

The content in this section is copied from `.planning/phases/43-rust-prusa-project-file-boundary/43-CONTEXT.md`. [VERIFIED: .planning/phases/43-rust-prusa-project-file-boundary/43-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Rust Boundary Placement

- **D-01:** Add the project-file boundary under the existing
  `packages/slic3r-rust/crates/slic3r_flavors` crate, reusing the
  `prusa_profile` module pattern rather than creating a new Rust workspace.
- **D-02:** Name the likely public surface `slic3r_flavors::prusa_project_file`
  with re-exports from `src/lib.rs`, unless planning finds an established local
  naming pattern that is clearly better.
- **D-03:** Keep production functions data-in/data-out. Callers may pass
  strings, slices, or already-loaded bytes, but the Rust domain code must not
  discover files, walk directories, inspect Git, spawn processes, access the
  network, execute profile auto-update behavior, import upstream source trees,
  or run vendor sync logic.

### Project Summary Shape

- **D-04:** Prefer parsing or summarizing the Phase 42
  `expected-project-summary.tsv` rows into typed Rust values for the first
  boundary. Do not require a full 3MF ZIP/container parser for Phase 43 unless
  research proves that a dependency-free or already-owned parser is necessary.
- **D-05:** Preserve the Phase 42 expected TSV columns exactly as boundary
  concepts: `source_ref`, `fixture_path`, `archive_member`, `project_marker`,
  `deferred_semantics`, and `notes`.
- **D-06:** Treat project markers as presence-level evidence only. Valid
  summary rows may mention archive members such as `[Content_Types].xml`,
  `_rels/.rels`, `3D/3dmodel.model`, `Metadata/thumbnail.png`,
  `Metadata/Slic3r_PE.config`, and `Metadata/Slic3r_PE_model.config`, but must
  not infer mesh geometry, printer/profile semantics, generated-output
  behavior, GUI behavior, load/save behavior, or full 3MF import/export parity.
- **D-07:** Fail malformed or unsupported summary input with typed errors.
  Avoid panics and avoid silently accepting missing required columns, empty
  required values, or rows for unexpected source refs or fixture paths.

### Provenance and Traceability

- **D-08:** Expose typed metadata that traces `prusaslicer.project-file` to
  vendor `prusaslicer`, flavor `PrusaSlicer`, inventory row
  `prusaslicer.project-file`, source ref
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  source path `src/libslic3r/Format/3mf.cpp`, fixture path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf`,
  expected summary path
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`,
  scope record `packages/prusa-project-file-scope/project-file-scope.md`, and
  planned status token `fork.prusaslicer.project-file`.
- **D-09:** Reuse existing contract types such as `FlavorId`,
  `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`
  wherever they fit. Add newtypes only where they prevent confusion between raw
  TSV text and typed project-file evidence.
- **D-10:** The Rust metadata may name the future status token as reserved
  traceability, but Phase 43 must not publish that token as verified parity.

### Verification Shape

- **D-11:** Add focused Rust unit/integration tests for summary parsing,
  required-column validation, malformed-row errors, metadata traceability, and
  no-overclaiming marker semantics.
- **D-12:** Tests should use Arrange, Act, Assert comments when setup is
  non-trivial and should cover one concern per test.
- **D-13:** Use `include_str!` for checked-in fixture summary tests if helpful;
  production code must remain free of filesystem and process side effects.
- **D-14:** Wire the new Rust tests into both Cargo and Bazel verification for
  `slic3r_flavors`, keeping `//packages/slic3r-rust:verify` green.

### Documentation and Scope Control

- **D-15:** Update Rust/package and port docs only enough to explain that Phase
  43 adds a parser/summary metadata boundary, while Phase 44 still owns the
  executable parity command and status publication.
- **D-16:** Preserve the Phase 41/42 deferred-scope wording: no full
  PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
  generated-output parity, STEP import, support generation, arc fitting, wall
  seam behavior, network/device integration, profile auto-update execution,
  fork release builds, Bambu Studio, OrcaSlicer, upstream source imports, or
  sync automation.

### the agent's Discretion

- The agent may choose exact Rust type names and file splits, provided the
  boundary remains small, pure, and consistent with `prusa_profile.rs`.
- The agent may decide whether the project-file summary rows need an enum for
  known archive members or a validated string newtype, whichever keeps the
  evidence narrow and maintainable.
- The agent may choose the minimum doc set needed to make the Rust boundary
  discoverable without rewriting unrelated milestone history.

### Deferred Ideas (OUT OF SCOPE)

Full PrusaSlicer runtime support, GUI project behavior, full 3MF import/export,
generated-output parity, STEP import, support generation, arc fitting, wall
seam behavior, network/device integration, profile auto-update execution, fork
release builds, Bambu Studio, OrcaSlicer, upstream source imports, and sync
automation remain outside Phase 43.
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PPROJ-01 | Developer can parse or summarize the selected Prusa project-file fixture evidence into typed Rust domain values before data reaches shared core profile, file-format, or config logic. [VERIFIED: .planning/REQUIREMENTS.md] | Use a pure `slic3r_flavors::prusa_project_file` parser over `expected-project-summary.tsv` and model the six TSV columns as typed values. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |
| PPROJ-02 | Developer can trace the Prusa project-file capability from Rust metadata back to the Prusa inventory row, accepted vendor source identity, source path or reviewed sample source, fixture path, checklist path, and planned status token. [VERIFIED: .planning/REQUIREMENTS.md] | Add metadata analogous to `PrusaProfileSchemaMetadata`, using `VendorSourceRef::prusa_slicer_version_2_9_5()` and exact Phase 41/42 paths. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/prusa-project-file-scope/project-file-scope.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv] |
| PPROJ-03 | Developer can verify Prusa project-file summary or parsing logic with focused Rust unit tests that do not perform Git, network, filesystem discovery, process, release, or vendor sync operations. [VERIFIED: .planning/REQUIREMENTS.md] | Add focused Cargo/Bazel tests that use inline strings and `include_str!` for the checked-in expected summary; production functions stay data-in/data-out. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
</phase_requirements>

## Summary

Phase 43 should add a small, pure Rust module at `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs` and re-export it through `src/lib.rs`. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs] The module should parse the Phase 42 `expected-project-summary.tsv` artifact into typed Rust rows, validate exact columns and expected source/fixture values, and expose project-file metadata that traces to the accepted Prusa source pin, inventory row, fixture, expected summary, scope record, and reserved future status token. [VERIFIED: 43-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv; packages/prusa-project-file-scope/project-file-scope.md]

The planner should not plan a 3MF ZIP/container parser, executable parity command, status row publication, upstream source import, Git/network operation, or file discovery logic in production Rust for this phase. [VERIFIED: 43-CONTEXT.md; .planning/ROADMAP.md; packages/parity/README.md] Tests may load checked-in fixture text with `include_str!`, matching the existing `prusa_profile` test pattern. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs]

**Primary recommendation:** Implement `slic3r_flavors::prusa_project_file` as a std-only, data-in/data-out TSV boundary with typed metadata, exact-row validation, Cargo/Bazel tests, docs updates, and no Phase 44 status/parity publication. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

## Project Constraints (from AGENTS.md)

- `AGENTS.md` requires reading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds standards before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- No active local standards override is recorded beyond the placeholder table in `standards-overrides.md`. [VERIFIED: standards-overrides.md]
- Repo-local summary files must keep the YAML key `requirements-completed` synchronized and must not be rewritten with `mdformat`; this phase writes research, not a summary, but planners should preserve that rule for later summaries. [VERIFIED: AGENTS.md]
- Bright Builds architecture guidance says business rules should live in pure data-in/data-out functions and raw input should be parsed into domain types at boundaries. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Bright Builds Rust guidance says new or touched multi-file modules should use `foo.rs` plus `foo/` instead of `foo/mod.rs`, guard-style extraction should prefer `let...else` when it is clearer, optional internal names should use `maybe_`, and invariants should be encoded with newtypes/enums and fallible constructors. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Bright Builds testing guidance says pure and business logic must have unit tests, each unit test should prove one concern, and Arrange/Act/Assert should be delineated when structure is not trivial. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Bright Builds verification guidance says relevant repo-native verification must pass before commit and repo-owned verification entrypoints should be preferred when available. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- The user-provided AGENTS instructions for Rust projects require `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features` before creating a Rust commit. [VERIFIED: user-provided AGENTS.md instructions in prompt]
- The user-provided AGENTS instructions prohibit `unwrap()` in Rust and prefer error propagation, with `expect()` only when panic is impossible. [VERIFIED: user-provided AGENTS.md instructions in prompt]
- No `.claude/skills/` or `.agents/skills/` project skill directory exists in this checkout. [VERIFIED: local project skill directory check]

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Rust standard library | Rust workspace declares `rust-version = "1.94"` and local `rustup run 1.94.1` is available. [VERIFIED: packages/slic3r-rust/Cargo.toml; local rustup command] | Parse TSV text, split lines/columns, own typed values, and return `Result` errors without adding external crates. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] | The existing `prusa_profile` boundary is std-only and data-in/data-out. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |
| `slic3r_contracts` | `0.1.0` path dependency. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Reuse `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus` for metadata traceability. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] | These types already encode canonical fork, source, origin, parity, and checklist tokens. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| `slic3r_flavors` crate | `0.1.0`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Own the new `prusa_project_file` module, metadata helper, parser, and tests. [VERIFIED: 43-CONTEXT.md] | The existing crate owns pure flavor registry metadata and the prior `prusa_profile` parser boundary. [VERIFIED: packages/slic3r-rust/README.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Bazel / Bazelisk | Repo pins Bazel `8.6.0`; local Bazelisk is `1.28.1`. \[VERIFIED: .bazelversion; local `bazelisk version`\] | Wire new Rust test target into `slic3r_flavors` clippy/rustfmt and aggregate `//packages/slic3r-rust:verify`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel] | Use for repository verification and planner task gates. [VERIFIED: packages/slic3r-rust/README.md] |
| `mdformat` | Local `mdformat 1.0.0` is available. \[VERIFIED: local `mdformat --version`\] | Check Markdown docs if Phase 43 updates Rust/package/port docs. [VERIFIED: Phase 39 and 42 summaries record mdformat checks for docs] | Use for non-summary Markdown only, because repo-local guidance bans `mdformat` over `*-SUMMARY.md`. [VERIFIED: AGENTS.md] |
| `shfmt` | Local `shfmt 3.12.0` is available. \[VERIFIED: local `shfmt --version`\] | Check shell verifier changes if the Phase 42 fixture verifier guard is edited. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh] | Use only if planner includes shell edits. [VERIFIED: packages/parity-fixtures/BUILD.bazel] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Std-only TSV parser in `slic3r_flavors` | A new Rust TSV/CSV crate | Not recommended because the input is a fixed six-column checked-in TSV and the existing pattern is std-only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |
| Typed parser over `expected-project-summary.tsv` | Full 3MF ZIP/container parser | Not recommended because Phase 43 explicitly prefers the Phase 42 expected summary and defers full 3MF import/export. [VERIFIED: 43-CONTEXT.md; .planning/REQUIREMENTS.md] |
| New Rust crate/workspace | Add module to `slic3r_flavors` | Not recommended because D-01 locks the crate placement to `slic3r_flavors`. [VERIFIED: 43-CONTEXT.md] |

**Installation:**

```bash
# No new package installation is required for Phase 43.
```

**Version verification:** No `npm view` checks apply because Phase 43 should add no npm packages and no external Rust crates. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] Rust and Bazel availability were verified locally with `rustup run 1.94.1`, `cargo --version`, `bazel version`, and `bazelisk version`. [VERIFIED: local environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/
├── src/
│   ├── lib.rs                  # Re-export public project-file API. [VERIFIED: existing lib.rs pattern]
│   ├── prusa_profile.rs        # Existing pure boundary precedent. [VERIFIED: existing file]
│   ├── prusa_project_file.rs   # New pure Phase 43 project-file TSV boundary. [VERIFIED: 43-CONTEXT.md]
│   └── registry.rs             # Existing capability registry; keep project-file status future-candidate. [VERIFIED: existing registry.rs]
├── tests/
│   ├── flavor_registry.rs      # Add metadata traceability/no-overclaiming assertions. [VERIFIED: existing test pattern]
│   └── prusa_project_file.rs   # New focused parser and metadata tests. [VERIFIED: 43-CONTEXT.md]
└── BUILD.bazel                 # Add source and tests to library, clippy, and rustfmt. [VERIFIED: existing BUILD.bazel pattern]
```

### Pattern 1: Pure TSV Boundary

**What:** Accept `&str`, parse exact six-column TSV rows, and return typed values or typed errors. [VERIFIED: 43-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv]

**When to use:** Use this for Phase 43 production Rust; do not read paths, inspect ZIP members, or execute external tools in production functions. [VERIFIED: 43-CONTEXT.md]

**Recommended API:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs
// Source: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv
pub fn parse_prusa_project_file_summary(
    input: &str,
) -> PrusaProjectFileParseResult {
    // Parse header and rows into PrusaProjectFileSummary.
}
```

**Planner detail:** Model `source_ref`, `fixture_path`, `archive_member`, `project_marker`, `deferred_semantics`, and `notes` as named typed fields, not as `Vec<String>` or a raw map. [VERIFIED: 43-CONTEXT.md; cited Bright Builds architecture standards]

### Pattern 2: Exact Metadata Helper

**What:** Add `PrusaProjectFileMetadata` beside the parser, analogous to `PrusaProfileSchemaMetadata`, but include the project-file-specific expected summary path and scope record path. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; 43-CONTEXT.md]

**When to use:** Use the helper in tests, docs, and later Phase 44 command planning so metadata does not drift from the parser boundary. [VERIFIED: 43-CONTEXT.md; Phase 39 summaries]

**Recommended fields:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs
pub struct PrusaProjectFileMetadata {
    pub inventory_id: &'static str,
    pub vendor_id: &'static str,
    pub flavor_id: FlavorId,
    pub source_ref: VendorSourceRef,
    pub source_path: &'static str,
    pub fixture_path: &'static str,
    pub expected_summary_path: &'static str,
    pub scope_record_path: &'static str,
    pub reserved_future_status_token: &'static str,
}
```

**Planner detail:** Keep `reserved_future_status_token` as metadata only and keep `packages/parity/status.tsv` unchanged in Phase 43. [VERIFIED: 43-CONTEXT.md; packages/parity/status.tsv]

### Pattern 3: Exact Row Set With Narrow Semantics

**What:** Validate the current expected artifact as a known seven-row evidence set with the exact source ref and fixture path. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**When to use:** Use this when parsing the checked-in Phase 42 evidence to avoid accepting extra semantic claims. [VERIFIED: 42-VERIFICATION.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**Recommended type shape:** Use enums for `ArchiveMember`, `ProjectMarker`, and `DeferredSemantics` because the current value set is small and exact; use newtypes for path and note text where the invariant is non-empty and exact fixture/source validation happens at construction. [CITED: Bright Builds Rust newtype/enum guidance; VERIFIED: expected-project-summary.tsv]

### Pattern 4: Test With `include_str!`, Not Runtime I/O

**What:** Integration tests can include the checked-in expected summary at compile time, while production parser functions only accept caller-provided text. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs]

**When to use:** Use `include_str!` for the fixture summary test and inline strings for malformed input tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs]

### Anti-Patterns to Avoid

- **Adding a 3MF ZIP parser in Phase 43:** Phase 43 is scoped to the Phase 42 expected summary, not full project-file import/export or archive decoding. [VERIFIED: 43-CONTEXT.md; .planning/REQUIREMENTS.md]
- **Adding a new binary or parity command:** Phase 44 owns `//packages/parity:prusaslicer_project_file_parity`; Phase 43 should stay a Rust domain boundary. [VERIFIED: 43-CONTEXT.md; docs/port/migration-guidance.md]
- **Publishing `fork.prusaslicer.project-file`:** The status row remains absent until Phase 44 executable evidence exists. [VERIFIED: 43-CONTEXT.md; packages/parity/status.tsv; packages/parity/README.md]
- **Passing raw TSV rows deep into shared logic:** Boundary data should become domain types before it reaches shared profile, file-format, or config logic. [VERIFIED: PPROJ-01 in .planning/REQUIREMENTS.md; cited Bright Builds architecture standards]
- **Silently accepting unknown rows:** Phase 42 already fixed a verifier warning by rejecting extra expected-summary rows, so the Rust parser should also fail unsupported/extra semantic evidence. [VERIFIED: 42-VERIFICATION.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Source reference parsing | Manual split/commit validation inside `prusa_project_file.rs` | `VendorSourceRef::try_from` or `VendorSourceRef::prusa_slicer_version_2_9_5()` | The canonical source pins and parse errors already live in `slic3r_contracts`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs] |
| Flavor/source/status vocabulary | Stringly typed metadata fields for flavor, origin, parity, and checklist status | `FlavorId`, `FeatureOrigin`, `ParitySurface`, `ChecklistStatus` | These contract types already encode canonical tokens. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; 43-CONTEXT.md] |
| 3MF archive inspection | New ZIP reader, unzip wrapper, or archive-member discovery in production Rust | Parse the checked-in `expected-project-summary.tsv` rows | Phase 43 explicitly defers full 3MF import/export and file discovery. [VERIFIED: 43-CONTEXT.md; .planning/REQUIREMENTS.md] |
| Runtime parity/status publication | New parity command or `packages/parity/status.tsv` row | Metadata-only reserved token plus tests that status remains absent | Phase 44 owns executable parity and status publication. [VERIFIED: 43-CONTEXT.md; packages/parity/README.md] |
| Generic TSV framework | Reusable parser abstraction across unrelated packages | Small module-local parser helpers | The current input has one exact six-column schema and one checked-in expected artifact. [VERIFIED: expected-project-summary.tsv; 43-CONTEXT.md] |

**Key insight:** The hard problem in Phase 43 is not parsing tab characters; it is preventing overclaiming by converting a narrow, reviewed expected artifact into types that cannot accidentally represent broader 3MF/runtime behavior. [VERIFIED: 43-CONTEXT.md; cited Bright Builds architecture standards]

## Common Pitfalls

### Pitfall 1: Leaving the Phase 42 Rust-Negative Guard Unchanged

**What goes wrong:** `packages/parity-fixtures:verify_prusa_project_file_fixture` currently fails if it finds `prusa_project_file` in `slic3r_flavors` source or tests. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**Why it happens:** Phase 42 intentionally guarded against premature Phase 43 surfaces. [VERIFIED: 42-CONTEXT.md; 42-VERIFICATION.md]

**How to avoid:** Phase 43 should update that guard to allow the planned Rust boundary while still rejecting Phase 44 parity target and status row publication. [VERIFIED: 43-CONTEXT.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**Warning signs:** A plan adds `src/prusa_project_file.rs` but does not include a verifier update or re-run `bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture`. [VERIFIED: packages/parity-fixtures/BUILD.bazel; 42-VERIFICATION.md]

### Pitfall 2: Treating Markers as Semantics

**What goes wrong:** Parser or summary names imply mesh geometry, profile config semantics, load/save behavior, runtime version parity, or full 3MF import/export. [VERIFIED: 43-CONTEXT.md; expected-project-summary.tsv]

**Why it happens:** The fixture contains archive members and Prusa marker strings, but the accepted evidence is presence-level only. [VERIFIED: expected-project-summary.tsv; 43-CONTEXT.md]

**How to avoid:** Type names should use terms such as `ArchiveMember`, `ProjectMarker`, and `DeferredSemantics`, not `ModelGeometry`, `ProfileConfig`, `LoadSave`, or `ImportExport`. [VERIFIED: 43-CONTEXT.md]

**Warning signs:** Tests assert mesh counts, config key counts, printer compatibility, generated output, GUI behavior, or actual 3MF load/save success. [VERIFIED: .planning/REQUIREMENTS.md; 43-CONTEXT.md]

### Pitfall 3: Letting Raw Strings Bypass Invariants

**What goes wrong:** Callers receive unchecked `String` values for source refs, fixture paths, members, or semantics and must revalidate them later. [CITED: Bright Builds architecture standards]

**Why it happens:** TSV parsing looks simple enough to keep as `Vec<Vec<&str>>`, but this pushes invariants out of the boundary. [VERIFIED: expected-project-summary.tsv; cited Bright Builds architecture standards]

**How to avoid:** Use fallible constructors, enums, and newtypes so unsupported source refs, fixture paths, members, markers, and semantics fail during parsing. [CITED: Bright Builds Rust standards; VERIFIED: 43-CONTEXT.md]

**Warning signs:** Public API returns `Vec<HashMap<String, String>>`, `Vec<Vec<String>>`, or raw column tuples without domain names. [CITED: Bright Builds architecture standards]

### Pitfall 4: Adding Side Effects to Production Rust

**What goes wrong:** The module reads files, walks directories, inspects Git, spawns `unzip`, calls Bazel, or accesses the network. [VERIFIED: 43-CONTEXT.md]

**Why it happens:** Phase 42 fixture verification uses shell/archive tools, and Phase 44 will later add a command surface, but Phase 43 is not that layer. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; 43-CONTEXT.md]

**How to avoid:** Keep production Rust functions `&str` in and typed values out; keep file reading only in tests via `include_str!`. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs]

**Warning signs:** New production code imports `std::fs`, `std::process`, `std::env`, network crates, or path discovery helpers. [VERIFIED: 43-CONTEXT.md]

### Pitfall 5: Accidentally Advancing Status

**What goes wrong:** Phase 43 docs or code make `fork.prusaslicer.project-file` look verified. [VERIFIED: 43-CONTEXT.md; packages/parity/README.md]

**Why it happens:** The metadata needs to name the future token for traceability, but the token is not a verified status row yet. [VERIFIED: 43-CONTEXT.md]

**How to avoid:** Name the field `reserved_future_status_token`, keep `ChecklistStatus::FutureCandidate`, and add negative tests/greps for `packages/parity/status.tsv`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs; packages/parity/status.tsv]

**Warning signs:** `packages/parity/status.tsv` changes or docs say the project-file slice is verified before Phase 44. [VERIFIED: packages/parity/status.tsv; docs/port/parity-matrix.md]

## Code Examples

Verified patterns from local sources and pinned standards. [VERIFIED: local codebase inspection; cited Bright Builds standards]

### Metadata Helper

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs
// Source: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs
pub const fn prusa_project_file_metadata() -> PrusaProjectFileMetadata {
    PrusaProjectFileMetadata {
        inventory_id: "prusaslicer.project-file",
        vendor_id: "prusaslicer",
        flavor_id: FlavorId::PrusaSlicer,
        source_ref: VendorSourceRef::prusa_slicer_version_2_9_5(),
        source_path: "src/libslic3r/Format/3mf.cpp",
        fixture_path: "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf",
        expected_summary_path: "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv",
        scope_record_path: "packages/prusa-project-file-scope/project-file-scope.md",
        reserved_future_status_token: "fork.prusaslicer.project-file",
    }
}
```

### Header Validation

```rust
// Source: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs
const EXPECTED_HEADER: &str =
    "source_ref\tfixture_path\tarchive_member\tproject_marker\tdeferred_semantics\tnotes";

fn parse_header(line: &str) -> Result<(), PrusaProjectFileParseError> {
    if line != EXPECTED_HEADER {
        return Err(PrusaProjectFileParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}
```

### Focused Test Shape

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs
#[test]
fn rejects_unexpected_fixture_path() {
    // Arrange
    let input = "source_ref\tfixture_path\tarchive_member\tproject_marker\tdeferred_semantics\tnotes\n\
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\twrong.3mf\t[Content_Types].xml\topc-content-types\tmember-presence-only\tNo behavior claimed.\n";

    // Act
    let result = parse_prusa_project_file_summary(input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnexpectedFixturePath { .. })
    ));
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source-observed fork inventory row only | Reviewed scope gate, checked-in fixture expected artifact, then pure Rust boundary | Phases 41-43 in v1.11 [VERIFIED: .planning/ROADMAP.md; Phase 41/42 verification] | Plans must trace Rust metadata to the scope record and fixture expected summary before executable parity. [VERIFIED: 43-CONTEXT.md] |
| Broad "project-file support" wording | Presence-level marker evidence with deferred 3MF/runtime/GUI semantics | Phase 41/42 v1.11 scope decisions [VERIFIED: packages/prusa-project-file-scope/project-file-scope.md; expected-project-summary.tsv] | Type and test names must not imply full 3MF import/export or runtime support. [VERIFIED: 43-CONTEXT.md] |
| Ad hoc strings for fork metadata | `slic3r_contracts` types plus module-local metadata helper | Established before Phase 43 [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] | Planner should reuse contract types and avoid duplicate token parsing. [VERIFIED: 43-CONTEXT.md] |

**Deprecated/outdated:**

- Treating `prusaslicer.project-file` as full PrusaSlicer runtime or full 3MF import/export evidence is out of scope for v1.11 Phase 43. [VERIFIED: .planning/REQUIREMENTS.md; 43-CONTEXT.md]
- Treating the Phase 42 fixture verifier's `prusa_project_file` ban as permanent is outdated once Phase 43 implements the planned Rust boundary. [VERIFIED: 42-CONTEXT.md; 43-CONTEXT.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]
- Treating `fork.prusaslicer.project-file` as publishable status is premature until Phase 44 executable evidence exists. [VERIFIED: 43-CONTEXT.md; packages/parity/README.md; packages/parity/status.tsv]

## Assumptions Log

All claims in this research were verified from local repository artifacts, local commands, pinned Bright Builds standards, or official OWASP documentation. [VERIFIED: Sources section]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

No assumed claims were recorded. [VERIFIED: Sources section]

## Open Questions

1. **Metadata field naming for the Phase 41 record path**
   - What we know: Context D-08 requires metadata to expose `packages/prusa-project-file-scope/project-file-scope.md` as the scope record, while PPROJ-02 says checklist path. [VERIFIED: 43-CONTEXT.md; .planning/REQUIREMENTS.md]
   - What's unclear: Whether the public Rust field should be named `scope_record_path`, `checklist_path`, or both. [VERIFIED: 43-CONTEXT.md; .planning/REQUIREMENTS.md]
   - Recommendation: Use `scope_record_path` in the Rust type and test it as satisfying the project-file checklist/record traceability requirement, because this evidence slice has a scope record rather than a Prusa baseline checklist. [VERIFIED: packages/prusa-project-file-scope/project-file-scope.md; 43-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| `rustup` | Pinned Rust toolchain commands | yes \[VERIFIED: local `rustup --version`\] | `1.29.0` [VERIFIED: local command] | None needed. [VERIFIED: local command] |
| Rust `1.94.1` | Cargo fmt/clippy/build/test for workspace rust-version `1.94` | yes \[VERIFIED: local `rustup run 1.94.1 rustc --version`\] | `rustc 1.94.1`, `cargo 1.94.1` [VERIFIED: local commands] | None needed. [VERIFIED: local commands] |
| Bazel/Bazelisk | Bazel test wiring and `//packages/slic3r-rust:verify` | yes \[VERIFIED: local `bazel version`; local `bazelisk version`\] | Bazel `8.6.0`, Bazelisk `1.28.1` [VERIFIED: local commands; .bazelversion] | None needed. [VERIFIED: local commands] |
| `rg` | Verification greps and implementation search | yes \[VERIFIED: local `rg --version`\] | `ripgrep 15.1.0` [VERIFIED: local command] | Use project-native checks if unavailable. [VERIFIED: AGENTS.md] |
| `mdformat` | Optional docs verification | yes \[VERIFIED: local `mdformat --version`\] | `1.0.0` [VERIFIED: local command] | Use `git diff --check` if docs formatting is not required. [VERIFIED: AGENTS.md] |
| `shfmt` | Optional shell verifier edits | yes \[VERIFIED: local `shfmt --version`\] | `3.12.0` [VERIFIED: local command] | Avoid shell edits or rely on existing shell tests if not needed. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| `zipinfo` / `unzip` | Existing Phase 42 fixture verifier only | yes [VERIFIED: local commands] | `ZipInfo 3.00`, `UnZip 6.00` [VERIFIED: local commands] | Phase 43 production Rust should not need these tools. [VERIFIED: 43-CONTEXT.md] |

**Missing dependencies with no fallback:** None found for Phase 43 planning. [VERIFIED: environment audit]

**Missing dependencies with fallback:** None found for Phase 43 planning. [VERIFIED: environment audit]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement` to `false`. [VERIFIED: .planning/config.json]

### Applicable ASVS Categories

OWASP ASVS 5.0.0 is the latest stable version named by the OWASP project page, and ASVS includes categories such as authentication, session management, access control, validation/sanitization/encoding, and stored cryptography. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://devguide.owasp.org/en/06-verification/01-guides/03-asvs/]

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no [VERIFIED: 43-CONTEXT.md] | Phase 43 has no user authentication surface. [VERIFIED: 43-CONTEXT.md] |
| V3 Session Management | no [VERIFIED: 43-CONTEXT.md] | Phase 43 has no session or cookie surface. [VERIFIED: 43-CONTEXT.md] |
| V4 Access Control | no [VERIFIED: 43-CONTEXT.md] | Phase 43 has no user authorization boundary. [VERIFIED: 43-CONTEXT.md] |
| V5 Validation, Sanitization and Encoding | yes [CITED: OWASP ASVS docs; VERIFIED: 43-CONTEXT.md] | Validate exact TSV header, column count, source ref, fixture path, allowed members/markers, non-empty notes, and unsupported rows with typed errors. [VERIFIED: 43-CONTEXT.md; expected-project-summary.tsv] |
| V6 Stored Cryptography | no [VERIFIED: 43-CONTEXT.md] | Phase 43 must not add cryptographic storage or hash verification logic in production Rust. [VERIFIED: 43-CONTEXT.md] |

### Known Threat Patterns for Rust Project-File Boundary

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Malformed TSV accepted as valid evidence | Tampering | Exact header, exact column count, typed parse errors, and tests for malformed rows. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs] |
| Unsupported extra rows overclaim semantics | Repudiation / Tampering | Reject unsupported row values and assert the current selected expected summary parses to seven rows. [VERIFIED: 42-VERIFICATION.md; expected-project-summary.tsv] |
| Source or fixture trace drift | Spoofing / Repudiation | Compare parsed source ref and fixture path against metadata constants and `VendorSourceRef::prusa_slicer_version_2_9_5()`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs; fixture-provenance.tsv] |
| Production side effects | Elevation of Privilege / Tampering | Keep production code free of filesystem discovery, Git, process, network, profile auto-update, release, and vendor sync calls. [VERIFIED: 43-CONTEXT.md] |
| Premature status publication | Repudiation | Keep `fork.prusaslicer.project-file` as `reserved_future_status_token` metadata only and retain negative status/parity checks until Phase 44. [VERIFIED: 43-CONTEXT.md; packages/parity/status.tsv; packages/parity/README.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/43-rust-prusa-project-file-boundary/43-CONTEXT.md` - locked Phase 43 user decisions, constraints, and canonical refs. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - PPROJ-01, PPROJ-02, PPROJ-03, and v1.11 out-of-scope list. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 43 goal, success criteria, dependency, and Phase 44 boundary. [VERIFIED: file read]
- `.planning/STATE.md` - current project state and Phase 42 to Phase 43 handoff. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: file read]
- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape, verification, testing, and Rust rules. [CITED: GitHub raw standards URLs in this file]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` - existing parser, metadata, typed error, and summary-line pattern. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - crate re-export pattern. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - existing `prusaslicer.project-file` registry row and provenance pattern. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs` and `tests/flavor_registry.rs` - Arrange/Act/Assert parser and traceability tests. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` and `packages/slic3r-rust/BUILD.bazel` - Bazel Rust target wiring. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` - contract types for vendor source, flavor, origin, parity surface, and checklist status. [VERIFIED: file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`, `fixture-provenance.tsv`, and `README.md` - Phase 42 selected evidence, provenance, and deferred scope. [VERIFIED: file read]
- `packages/prusa-project-file-scope/project-file-scope.md` - Phase 41 accepted source identity and downstream handoff record. [VERIFIED: file read]
- `.planning/phases/41-prusa-project-file-scope-gate/41-VERIFICATION.md` and `.planning/phases/42-prusa-project-file-fixture-surface/42-VERIFICATION.md` - verified prior-phase truths and negative checks. [VERIFIED: file read]
- `packages/parity/README.md` and `packages/parity/status.tsv` - status publication rule and current absence of `fork.prusaslicer.project-file`. [VERIFIED: file read]

### Secondary (MEDIUM confidence)

- OWASP ASVS project page and OWASP Developer Guide ASVS page - current ASVS category framing for the security section. [CITED: https://owasp.org/www-project-application-security-verification-standard/; CITED: https://devguide.owasp.org/en/06-verification/01-guides/03-asvs/]
- Local environment probes for Rust, Cargo, Bazel/Bazelisk, `rg`, `mdformat`, `shfmt`, `zipinfo`, and `unzip`. [VERIFIED: local commands]

### Tertiary (LOW confidence)

- None. [VERIFIED: research sources]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - Phase 43 is locked to the existing Rust workspace and std-only local parser pattern; no external dependency decision remains open. [VERIFIED: 43-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; prusa_profile.rs]
- Architecture: HIGH - Phase 43 placement, purity, metadata traceability, and verification shape are locked by CONTEXT and match established Phase 39/40 patterns. [VERIFIED: 43-CONTEXT.md; Phase 39 summaries; prusa_profile.rs]
- Pitfalls: HIGH - Pitfalls derive from explicit Phase 43 exclusions, Phase 42 verifier guards, and verified prior-phase no-overclaiming fixes. [VERIFIED: 43-CONTEXT.md; 42-VERIFICATION.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]
- Security: MEDIUM - The phase has a narrow local parser surface, and ASVS category mapping was checked against current OWASP pages, but final implementation still needs code review for exact validation behavior. [CITED: OWASP ASVS docs; VERIFIED: 43-CONTEXT.md]

**Research date:** 2026-06-05 [VERIFIED: environment context]
**Valid until:** 2026-07-05 for local Phase 43 planning, unless the accepted Prusa source identity, Phase 42 fixture summary, Bright Builds pinned commit, or Rust workspace version changes. [VERIFIED: fork-vendors/forks.tsv; expected-project-summary.tsv; AGENTS.bright-builds.md; packages/slic3r-rust/Cargo.toml]
