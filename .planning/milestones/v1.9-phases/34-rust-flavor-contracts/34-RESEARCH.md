# Phase 34: Rust Flavor Contracts - Research

**Researched:** 2026-05-26 [VERIFIED: environment current_date]
**Domain:** Rust domain contracts for fork/flavor metadata and boundary parsing [VERIFIED: .planning/phases/34-rust-flavor-contracts/34-CONTEXT.md]
**Confidence:** HIGH for repo-local vocabulary, crate placement, and verification shape; MEDIUM for exact public type names because Phase 34 leaves names to planner discretion [VERIFIED: 34-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs]

<user_constraints>
## User Constraints (from CONTEXT.md)

Source for all content in this block: `.planning/phases/34-rust-flavor-contracts/34-CONTEXT.md`. [VERIFIED: .planning/phases/34-rust-flavor-contracts/34-CONTEXT.md]

### Locked Decisions

### Contract Package Boundary

- **D-01:** Put the Phase 34 contracts in
  `packages/slic3r-rust/crates/slic3r_contracts`. This crate already owns
  stable launcher-facing contract types and is the narrowest place for
  boundary values that other Rust crates can consume without pulling in side
  effects.
- **D-02:** Keep the contracts as pure Rust domain types, parser/display
  helpers, and focused tests. Do not add filesystem, Git, network, process, or
  release operations to the contract crate.
- **D-03:** Treat `packages/fork-vendors/forks.tsv`,
  `packages/fork-inventories/*.tsv`, `packages/fork-inventories/category-map.tsv`,
  and `packages/parity/status.tsv` as vocabulary inputs for contract design,
  but do not parse those files at runtime in Phase 34.

### Typed Vocabulary

- **D-04:** Model downstream fork identity with the Phase 32 vendor IDs:
  `prusaslicer`, `bambustudio`, and `orcaslicer`. Preserve canonical token
  display so docs, TSVs, and Rust tests speak the same vocabulary.
- **D-05:** Model flavor identity separately from vendor identity. Include
  `base-slic3r` for the base Rust/Slic3r flavor and fork flavor IDs for the
  three downstream forks. This prevents raw vendor strings from doubling as
  runtime flavor concepts.
- **D-06:** Model vendor source identity as a parsed source pin shaped like
  `vendor_id:selected_tag@peeled_commit`. Require a known vendor ID, a non-empty
  selected tag, and a 40-character lowercase hex commit. Branch-head
  observations remain drift-only metadata from Phase 32 and must not be accepted
  as source identity.
- **D-07:** Model feature origin from the Phase 33 ownership taxonomy:
  `base-slic3r`, `shared-downstream`, `fork-specific`, and
  `unknown-needs-review`.
- **D-08:** Model parity surface as a boundary value that validates canonical
  tokens from `packages/parity/status.tsv` without hardcoding launcher behavior.
  A string-backed validated value is acceptable if it prevents unvalidated raw
  strings from crossing the contract boundary.
- **D-09:** Model checklist status from the Phase 33 decision vocabulary:
  `future-candidate`, `deferred`, `no-action-base`, and `needs-review`. This
  is planning/checklist status only, not executable parity status.

### Parsing and Error Semantics

- **D-10:** Expose strict parsers at the boundary, preferably through
  `FromStr`/`TryFrom<&str>` style APIs plus small explicit error types. Invalid
  strings should produce structured errors, not `Unsupported` catch-all values.
- **D-11:** Canonical parsing should be lowercase and hyphenated to match the
  checked-in TSVs. Display/output helpers should return those canonical tokens.
- **D-12:** Avoid `unwrap()` in production code. Use `let...else`, `?`
  propagation, and explicit validation paths consistent with the Rust project
  guidance.

### Verification Shape

- **D-13:** Add focused Rust tests in `slic3r_contracts` proving that the new
  types parse and display canonical tokens, reject unknown/raw values, and
  distinguish base Slic3r, shared downstream, fork-specific, and
  unknown-needs-review concepts.
- **D-14:** Keep tests behavior-focused and Arrange/Act/Assert structured.
  Include examples that show Phase 34 contracts can be used before values enter
  core logic.
- **D-15:** Use the existing Rust verification surface where possible:
  package-local `rust_test`, `rustfmt_test`, `rust_clippy`, Cargo checks, and
  the existing `//packages/slic3r-rust:verify` suite.

### the agent's Discretion

- The planner may choose exact Rust type names if each ARCH-01 concept is
  explicitly represented and easy to discover from public docs/tests.
- The planner may choose whether source-pin validation lives on a dedicated
  `VendorSourceRef` struct or a small set of parsed component types, provided
  callers cannot pass an unvalidated source pin as a plain string.
- The planner may decide whether `ParitySurface` is an enum or a validated
  newtype. The safer default is a validated newtype if the existing parity
  surface list is expected to keep growing.

### Deferred Ideas (OUT OF SCOPE)

- Side-effect-free flavor registry composition belongs to Phase 35.
- Fork parity checklist templates, fixture namespaces, and drift-refresh
  protocol wording belong to Phase 36.
- Runtime fork behavior, fork-flavor release builds, online/cloud integration,
  credential handling, and non-free plugin support remain future milestones
  after executable parity evidence exists.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| ARCH-01 | Developer can use typed Rust contracts for downstream fork identity, flavor identity, vendor source identity, feature origin, parity surface, and checklist status instead of passing raw vendor strings through core logic. [VERIFIED: .planning/REQUIREMENTS.md] | Extend `slic3r_contracts` with pure Rust enums/newtypes, `FromStr`/`TryFrom<&str>` parsers, canonical `Display`, and focused contract tests using Phase 32/33 TSV vocabularies. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv; packages/fork-inventories/category-map.tsv; packages/parity/status.tsv] |
</phase_requirements>

## Summary

Phase 34 should be planned as a small, side-effect-free Rust contract expansion in `packages/slic3r-rust/crates/slic3r_contracts`, not as a registry, fork runtime, or source inventory reader. [VERIFIED: 34-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs]

The implementation should introduce explicit domain values for six ARCH-01 concepts: downstream fork identity, flavor identity, vendor source identity, feature origin, parity surface, and checklist status. [VERIFIED: .planning/REQUIREMENTS.md; 34-CONTEXT.md]

**Primary recommendation:** Add a new Rust module such as `src/flavor.rs`, re-export the public contract types from `src/lib.rs`, add a new `tests/flavor_contracts.rs` integration test target, update Bazel target lists, and verify through both Bazel and the pinned Rust 1.94.1 Cargo toolchain. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel; packages/slic3r-rust/BUILD.bazel; MODULE.bazel; rustup command output]

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo-local instruction entrypoint, and the managed Bright Builds block must not be edited in downstream changes. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Planning and implementation must account for `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant Bright Builds standards pages. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md]
- `standards-overrides.md` contains only placeholder override rows, so no active local override changes the default Bright Builds guidance for Phase 34. [VERIFIED: standards-overrides.md]
- Phase `*-SUMMARY.md` files must preserve the hyphenated `requirements-completed` field and must not be formatted with `mdformat`; Phase 34 research does not edit summary files. [VERIFIED: AGENTS.md]
- Bright Builds architecture guidance says raw input should be parsed into domain types at boundaries and illegal states should be made unrepresentable when practical. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md]
- Bright Builds Rust guidance says Rust domain invariants should use newtypes, enums, and fallible constructors, and raw values should be parsed before reaching business functions. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md]
- Bright Builds code-shape guidance prefers early returns and Rust `let...else` for guard-style extraction. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md]
- Bright Builds testing guidance requires pure/business logic tests, one concern per unit test, and clear Arrange/Act/Assert sections when the structure is not trivial. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md]
- Bright Builds verification guidance requires repo-native verification before commit and prefers repo-owned aggregate verification when available. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md]
- No `.claude/skills` or `.agents/skills` directory exists in this repo, so no repo-local skill conventions apply to Phase 34. [VERIFIED: command output]
- The branch was clean before research edits, remote refs were fetched with `git fetch --all --prune`, and the branch remained `master...origin/master [ahead 2]`. [VERIFIED: git status and git fetch command output]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|---|---:|---|---|
| Rust standard library traits: `FromStr`, `TryFrom`, `Display`, `Error` | Stable in current std docs | Boundary parsing, fallible conversion, canonical formatting, and small explicit error types. | Phase 34 locks `FromStr`/`TryFrom<&str>` style APIs and no new dependency is justified for simple contract errors. [VERIFIED: 34-CONTEXT.md; CITED: https://doc.rust-lang.org/std/str/trait.FromStr.html; CITED: https://doc.rust-lang.org/std/convert/trait.TryFrom.html; CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html] |
| `slic3r_contracts` crate | `0.1.0` | Public contract types consumed by Rust CLI and future core modules. | Phase 34 locks this crate as the package boundary for pure contract values. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/Cargo.toml; 34-CONTEXT.md] |
| Rust edition | 2024 | Rust language edition for the contract crate and workspace. | The workspace and Bazel targets use edition 2024. [VERIFIED: packages/slic3r-rust/Cargo.toml; packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |
| Rust toolchain | 1.94.1 pinned for Bazel; default `rustc` is 1.91.1 | Build, format, lint, and test Rust code. | `MODULE.bazel` pins rules_rust toolchains to 1.94.1 and the Cargo workspace declares `rust-version = "1.94"`. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml; rustc command output; rustup command output] |
| Bazel / Bazelisk | 8.6.0 | Repo-native build and test entrypoint. | `.bazelversion` pins Bazel 8.6.0, and `packages/slic3r-rust:verify` is the existing Rust aggregate verification suite. [VERIFIED: .bazelversion; packages/slic3r-rust/BUILD.bazel; bazel command output] |
| `rules_rust` | 0.69.0 | Bazel Rust rules for `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test`. | `MODULE.bazel` declares `rules_rust` 0.69.0 and the contract crate already uses those rule macros. [VERIFIED: MODULE.bazel; packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|---|---:|---|---|
| `packages/fork-vendors/forks.tsv` | 3 vendor rows | Canonical vendor IDs and exact selected source pins for PrusaSlicer, Bambu Studio, and OrcaSlicer. | Use as the static design vocabulary for `DownstreamFork` and `VendorSourceRef`; do not parse it at runtime. [VERIFIED: packages/fork-vendors/forks.tsv; 34-CONTEXT.md] |
| `packages/fork-inventories/*.tsv` and `category-map.tsv` | Phase 33 TSV schema | Canonical ownership and checklist decision vocabularies. | Use as static design vocabulary for `FeatureOrigin` and `ChecklistStatus`; do not parse at runtime. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv; 34-CONTEXT.md] |
| `packages/parity/status.tsv` | 14 status rows | Canonical parity surface tokens. | Use as static design vocabulary for a validated `ParitySurface` newtype. [VERIFIED: packages/parity/status.tsv; 34-CONTEXT.md] |
| `rustfmt_test` / `rust_clippy` / `rust_test` | rules_rust targets | Package-local formatting, linting, and tests. | Update these targets when adding new source or test files. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|---|---|---|
| Std-only manual error types | Add `thiserror` | Rejected for Phase 34 because the contract crate currently has no dependencies and the required parse errors are small. [VERIFIED: packages/slic3r-rust/Cargo.lock; 34-CONTEXT.md] |
| `ParitySurface` validated newtype | Large enum for every parity status row | Use the newtype because Phase 34 context says it is the safer default if the parity list keeps growing. [VERIFIED: 34-CONTEXT.md; packages/parity/status.tsv] |
| Runtime TSV parsing | `include_str!` or filesystem reads | Rejected because Phase 34 says TSVs are vocabulary inputs for contract design and must not be parsed at runtime. [VERIFIED: 34-CONTEXT.md] |
| One copied raw string type | Reuse vendor IDs directly for flavors | Rejected because Phase 34 requires flavor identity to be modeled separately from vendor identity. [VERIFIED: 34-CONTEXT.md] |
| Registry object graph | Flavor registry with metadata maps | Rejected because side-effect-free flavor registry composition belongs to Phase 35. [VERIFIED: 34-CONTEXT.md; .planning/ROADMAP.md] |

**Installation:**

```bash
# No new Rust, npm, or system dependencies are recommended for Phase 34.
# Use the repo-pinned Bazel/rules_rust toolchain and std-only Rust APIs.
```

**Version verification:** `npm view` is not applicable because no npm packages are recommended; local tool versions were verified with `bazel --version`, `rustup run 1.94.1 rustc --version`, `rustup run 1.94.1 cargo --version`, `rustup run 1.94.1 rustfmt --version`, `rustup run 1.94.1 cargo clippy --version`, and `git --version`. [VERIFIED: command outputs]

## Canonical Token Vocabularies

### Downstream Fork Identity

| Token | Meaning | Source |
|---|---|---|
| `prusaslicer` | PrusaSlicer downstream fork ID. | `packages/fork-vendors/forks.tsv` vendor_id. [VERIFIED: packages/fork-vendors/forks.tsv] |
| `bambustudio` | Bambu Studio downstream fork ID. | `packages/fork-vendors/forks.tsv` vendor_id. [VERIFIED: packages/fork-vendors/forks.tsv] |
| `orcaslicer` | OrcaSlicer downstream fork ID. | `packages/fork-vendors/forks.tsv` vendor_id. [VERIFIED: packages/fork-vendors/forks.tsv] |

### Flavor Identity

| Token | Meaning | Source |
|---|---|---|
| `base-slic3r` | Base Rust/Slic3r flavor ID. | Locked by Phase 34 context. [VERIFIED: 34-CONTEXT.md] |
| `prusaslicer` | PrusaSlicer flavor ID, represented as a flavor type rather than a vendor string. | Locked by Phase 34 context and Phase 32 vendor token. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv] |
| `bambustudio` | Bambu Studio flavor ID, represented as a flavor type rather than a vendor string. | Locked by Phase 34 context and Phase 32 vendor token. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv] |
| `orcaslicer` | OrcaSlicer flavor ID, represented as a flavor type rather than a vendor string. | Locked by Phase 34 context and Phase 32 vendor token. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv] |

### Vendor Source Identity

| Canonical Source Pin | Accepted Components | Source |
|---|---|---|
| `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | vendor `prusaslicer`, selected tag `version_2.9.5`, peeled commit `9a583bd438b195856f3bcf7ea99b69ba4003a961`. | Phase 32 vendor registry and Phase 33 inventories. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/prusaslicer.tsv] |
| `bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6` | vendor `bambustudio`, selected tag `v02.06.00.51`, peeled commit `b506005bc4ee62124e24bf00e0f58656db3646a6`. | Phase 32 vendor registry and Phase 33 inventories. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/bambustudio.tsv] |
| `orcaslicer:v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912` | vendor `orcaslicer`, selected tag `v2.3.2`, peeled commit `c724a3f5f51c52336624b689e846c8fbc943a912`. | Phase 32 vendor registry and Phase 33 inventories. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/orcaslicer.tsv] |

Branch-head observations such as `master@43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b`, `master@e150b502b3d2afc98b83dcc9e5720e998f9eb79a`, and `main@e0c4d11baefa328331be113533c47ee89fda16c6` must not be accepted as source identity. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-vendors/README.md; 34-CONTEXT.md]

### Feature Origin

| Token | Meaning | Source |
|---|---|---|
| `base-slic3r` | Base Slic3r ownership classification. | Phase 33 ownership taxonomy. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `shared-downstream` | Shared downstream ownership classification. | Phase 33 ownership taxonomy. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `fork-specific` | Fork-specific ownership classification. | Phase 33 ownership taxonomy. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `unknown-needs-review` | Unknown ownership requiring review. | Phase 33 ownership taxonomy. [VERIFIED: packages/fork-inventories/README.md; 34-CONTEXT.md] |

### Checklist Status

| Token | Meaning | Source |
|---|---|---|
| `future-candidate` | Future implementation candidate status. | Phase 33 v1.9 decision vocabulary. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `deferred` | Deferred status. | Phase 33 v1.9 decision vocabulary. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `no-action-base` | No-action/base status. | Phase 33 v1.9 decision vocabulary. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |
| `needs-review` | Needs-review status. | Phase 33 v1.9 decision vocabulary. [VERIFIED: packages/fork-inventories/README.md; packages/fork-inventories/category-map.tsv] |

### Parity Surface

| Token |
|---|
| `cli.version` [VERIFIED: packages/parity/status.tsv] |
| `cli.help` [VERIFIED: packages/parity/status.tsv] |
| `cli.other` [VERIFIED: packages/parity/status.tsv] |
| `export.workflows` [VERIFIED: packages/parity/status.tsv] |
| `transform.workflows` [VERIFIED: packages/parity/status.tsv] |
| `linux.runtime` [VERIFIED: packages/parity/status.tsv] |
| `windows.runtime` [VERIFIED: packages/parity/status.tsv] |
| `linux.packaged-launcher` [VERIFIED: packages/parity/status.tsv] |
| `windows.packaged-launcher` [VERIFIED: packages/parity/status.tsv] |
| `config` [VERIFIED: packages/parity/status.tsv] |
| `config.persistence` [VERIFIED: packages/parity/status.tsv] |
| `file-formats` [VERIFIED: packages/parity/status.tsv] |
| `generated-outputs` [VERIFIED: packages/parity/status.tsv] |
| `launcher-packaging` [VERIFIED: packages/parity/status.tsv] |

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_contracts/
|-- src/
|   |-- lib.rs             # Existing launcher contracts plus public re-exports
|   `-- flavor.rs          # New Phase 34 fork/flavor contract domain types
|-- tests/
|   |-- parse.rs           # Existing CLI invocation parser tests
|   `-- flavor_contracts.rs # New ARCH-01 behavior-focused tests
`-- BUILD.bazel            # Add module src and new rust_test target
```

This structure keeps new multi-file Rust code in `foo.rs` form and avoids overloading the existing CLI parser tests with fork/flavor concerns. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md; VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/tests/parse.rs; packages/slic3r-rust/crates/slic3r_cli/BUILD.bazel]

### Files Likely Touched

| File | Expected Change | Reason |
|---|---|---|
| `packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs` | Add `mod flavor;` and public re-exports for Phase 34 types. | Existing public crate root already exposes contract API. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs] |
| `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs` | New pure domain module for enums/newtypes, parsers, display helpers, and parse errors. | Keeps fork/flavor contracts separate from existing launcher parser logic. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md] |
| `packages/slic3r-rust/crates/slic3r_contracts/tests/flavor_contracts.rs` | New focused behavior tests for canonical parse/display, invalid tokens, and typed boundary examples. | Phase 34 requires focused contract tests/examples. [VERIFIED: 34-CONTEXT.md] |
| `packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel` | Include the new source file, add `flavor_contracts_test`, and add it to clippy/rustfmt targets. | Bazel Rust targets list source and test files explicitly in this repo. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel; packages/slic3r-rust/crates/slic3r_cli/BUILD.bazel] |
| `packages/slic3r-rust/BUILD.bazel` | Add `//packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` to `:verify`. | Existing aggregate verify suite enumerates package tests explicitly. [VERIFIED: packages/slic3r-rust/BUILD.bazel] |
| `packages/slic3r-rust/README.md` | Optionally note that `slic3r_contracts` now includes fork/flavor domain contracts. | Port docs expect relevant Rust package docs to move when contract surfaces change. [VERIFIED: docs/port/README.md; packages/slic3r-rust/README.md] |

### Pattern 1: Enums for Closed Vocabularies

**What:** Use public enums for fixed vocabularies: `DownstreamFork`, `FlavorId`, `FeatureOrigin`, and `ChecklistStatus`. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv; packages/fork-inventories/README.md]

**When to use:** Use enums when the Phase 34 vocabulary is intentionally closed and small. [VERIFIED: 34-CONTEXT.md]

**Required APIs:** Implement `as_str() -> &'static str`, `Display`, `FromStr`, and `TryFrom<&str>` for each closed vocabulary type. [VERIFIED: 34-CONTEXT.md; CITED: https://doc.rust-lang.org/std/str/trait.FromStr.html; CITED: https://doc.rust-lang.org/std/convert/trait.TryFrom.html; CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html]

### Pattern 2: Validated Newtype for Parity Surface

**What:** Use a private-field newtype such as `pub struct ParitySurface(&'static str);` with static accepted token matching. [VERIFIED: 34-CONTEXT.md; packages/parity/status.tsv]

**When to use:** Use the newtype because the parity surface list already contains 14 checked-in values and can grow without forcing registry behavior into Phase 34. [VERIFIED: packages/parity/status.tsv; 34-CONTEXT.md]

**Required APIs:** Implement `as_str()`, `Display`, `FromStr`, and `TryFrom<&str>`; reject unknown tokens instead of storing arbitrary strings. [VERIFIED: 34-CONTEXT.md]

### Pattern 3: Exact Source Pin Contract

**What:** Use a `VendorSourceRef` struct that stores `DownstreamFork`, selected stable tag, and peeled commit after parsing `vendor_id:selected_tag@peeled_commit`. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv]

**When to use:** Use it at boundaries where raw inventory or source-reference strings enter Rust code. [VERIFIED: .planning/REQUIREMENTS.md; packages/fork-inventories/README.md]

**Recommended strictness:** Match the exact three accepted Phase 32 source pins listed in `forks.tsv`, not merely any known vendor plus any 40-character commit, so branch-head strings such as `bambustudio:branch-main@e150b502b3d2afc98b83dcc9e5720e998f9eb79a` fail before core logic. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/README.md; 34-CONTEXT.md]

### Pattern 4: Std-Only Structured Errors

**What:** Use small explicit error enums such as `DownstreamForkParseError`, `FlavorIdParseError`, `VendorSourceRefParseError`, `FeatureOriginParseError`, `ParitySurfaceParseError`, and `ChecklistStatusParseError`. [VERIFIED: 34-CONTEXT.md]

**When to use:** Use separate small errors when tests need to prove the exact rejection reason and callers should not receive an `Unsupported` sentinel. [VERIFIED: 34-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs]

**Implementation detail:** Implement `Debug`, `Clone`, `PartialEq`, `Eq`, `Display`, and `std::error::Error` manually with no new dependency. [VERIFIED: packages/slic3r-rust/Cargo.lock; 34-CONTEXT.md; CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html]

### Anti-Patterns to Avoid

- **Runtime TSV reads in contract code:** Phase 34 should not read `forks.tsv`, inventory TSVs, or `status.tsv` at runtime. [VERIFIED: 34-CONTEXT.md]
- **Registry composition:** Do not build a flavor registry, capability map, or metadata lookup table beyond the pure parsed contract values. [VERIFIED: 34-CONTEXT.md; .planning/ROADMAP.md]
- **Catch-all `Unsupported` for parse failures:** Existing launcher parsing has `LauncherCommand::Unsupported`, but Phase 34 parse APIs must return structured errors. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs; 34-CONTEXT.md]
- **Raw vendor strings as flavor identity:** `DownstreamFork` and `FlavorId` may display overlapping tokens, but they must remain distinct Rust types. [VERIFIED: 34-CONTEXT.md]
- **Branch-head source refs:** Default branch observations are drift-only metadata and must not parse as `VendorSourceRef`. [VERIFIED: packages/fork-vendors/README.md; packages/fork-vendors/forks.tsv; 34-CONTEXT.md]
- **New dependency for simple errors:** The workspace lockfile currently contains only workspace crates, so adding `thiserror` would be dependency churn for a small std-only contract surface. [VERIFIED: packages/slic3r-rust/Cargo.lock]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| Boundary parsing | Ad hoc `match` blocks at every call site | `FromStr` and `TryFrom<&str>` implementations on domain types | Rust std exposes these traits for fallible string parsing and conversions. [CITED: https://doc.rust-lang.org/std/str/trait.FromStr.html; CITED: https://doc.rust-lang.org/std/convert/trait.TryFrom.html] |
| Canonical formatting | Independent `to_token` helpers with duplicated string literals | `Display` plus `as_str()` backed by one token match per type | Rust std recommends `Display` for canonical text output, and Phase 34 requires display helpers to return canonical tokens. [CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html; VERIFIED: 34-CONTEXT.md] |
| Flavor metadata registry | A map from flavors to capability metadata | Phase 35 registry boundary | Phase 35 owns side-effect-free flavor registry composition. [VERIFIED: 34-CONTEXT.md; .planning/ROADMAP.md] |
| Runtime source validation | Git, filesystem, network, process, or release operations | Static source-pin parser for checked-in token vocabulary | Phase 34 contract crate must remain pure and side-effect-free. [VERIFIED: 34-CONTEXT.md] |
| Parity implementation | Runtime fork parity or launcher behavior | Typed `ParitySurface` token validation only | Phase 34 validates surface tokens but must not hardcode launcher behavior. [VERIFIED: 34-CONTEXT.md] |
| External parser/error crates | New parse or error dependencies | Rust std traits and manual error enums | The workspace currently has no external Rust dependencies and Phase 34 does not need one. [VERIFIED: packages/slic3r-rust/Cargo.lock; 34-CONTEXT.md] |

**Key insight:** Phase 34 is a parse-dont-validate contract phase: once a raw token parses, later core logic should receive a Rust domain value, not another string that must be rechecked. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md; VERIFIED: .planning/REQUIREMENTS.md; 34-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Accidentally Implementing Phase 35

**What goes wrong:** The plan adds a registry or capability map while adding contract types. [VERIFIED: 34-CONTEXT.md; .planning/ROADMAP.md]

**Why it happens:** `FlavorId`, `FeatureOrigin`, and `VendorSourceRef` naturally invite a metadata table, but Phase 34 only needs typed boundary values. [VERIFIED: 34-CONTEXT.md]

**How to avoid:** Restrict Phase 34 to enums/newtypes, parse/display helpers, and tests; leave all registry composition to Phase 35. [VERIFIED: 34-CONTEXT.md]

**Warning signs:** New code returns flavor capability lists, source inventory rows, parity checklist templates, or fork-specific behavior dispatch. [VERIFIED: 34-CONTEXT.md; .planning/ROADMAP.md]

### Pitfall 2: Treating Source Pins as Runtime Evidence

**What goes wrong:** A valid `VendorSourceRef` is described as proof that a fork feature works. [VERIFIED: packages/fork-vendors/README.md; packages/fork-inventories/README.md]

**Why it happens:** Source pins and parity surfaces are both visible in contract types, but they have different semantics. [VERIFIED: 34-CONTEXT.md; docs/port/parity-matrix.md]

**How to avoid:** Document and test that `VendorSourceRef` validates source identity only; do not use it to change parity status or runtime behavior. [VERIFIED: 34-CONTEXT.md]

**Warning signs:** New tests or docs say a fork feature is `verified`, `supported`, or executable because a source pin parsed. [VERIFIED: docs/port/README.md; packages/fork-inventories/README.md]

### Pitfall 3: Token Drift From TSV Sources

**What goes wrong:** Rust tokens drift from `forks.tsv`, `category-map.tsv`, or `status.tsv`. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/category-map.tsv; packages/parity/status.tsv]

**Why it happens:** Phase 34 intentionally avoids runtime TSV parsing, so the Rust constants must be kept in sync by tests and review. [VERIFIED: 34-CONTEXT.md]

**How to avoid:** Add one focused test per vocabulary proving all canonical tokens parse and display exactly. [VERIFIED: 34-CONTEXT.md; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md]

**Warning signs:** Tests include prose labels such as `Bambu Studio`, alternate IDs such as `bambu-studio`, or branch labels such as `branch-main`. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv]

### Pitfall 4: Bazel Source Lists Missing New Rust Files

**What goes wrong:** Cargo sees a new module or test, but Bazel does not include it in `srcs` or the aggregate verify suite. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel; packages/slic3r-rust/BUILD.bazel]

**Why it happens:** Existing `slic3r_contracts` Bazel targets explicitly list `src/lib.rs` and `tests/parse.rs`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel]

**How to avoid:** Update `rust_library.srcs`, add a dedicated `rust_test`, include the test in clippy/rustfmt targets, and add the new test to `//packages/slic3r-rust:verify`. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel; packages/slic3r-rust/BUILD.bazel]

**Warning signs:** `cargo test` passes but `bazel test //packages/slic3r-rust:verify` does not run the new test. [VERIFIED: packages/slic3r-rust/BUILD.bazel]

### Pitfall 5: Default Cargo Toolchain Mismatch

**What goes wrong:** Planner uses default `cargo`, which is 1.91.1 locally, against a workspace requiring Rust 1.94. [VERIFIED: cargo command output; packages/slic3r-rust/Cargo.toml]

**Why it happens:** `rustup` has 1.94.1 installed, but the active default toolchain is older than the workspace `rust-version`. [VERIFIED: rustup toolchain list; rustc command output]

**How to avoid:** Use Bazel for the repo-native verification and use `rustup run 1.94.1 cargo ...` for Cargo checks. [VERIFIED: MODULE.bazel; rustup command output]

**Warning signs:** Cargo reports an MSRV/rust-version mismatch or tests run under `rustc 1.91.1`. [VERIFIED: rustc command output; packages/slic3r-rust/Cargo.toml]

## Code Examples

### Closed Vocabulary Enum

```rust
use std::fmt;
use std::str::FromStr;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FeatureOrigin {
    BaseSlic3r,
    SharedDownstream,
    ForkSpecific,
    UnknownNeedsReview,
}

impl FeatureOrigin {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::BaseSlic3r => "base-slic3r",
            Self::SharedDownstream => "shared-downstream",
            Self::ForkSpecific => "fork-specific",
            Self::UnknownNeedsReview => "unknown-needs-review",
        }
    }
}

impl fmt::Display for FeatureOrigin {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for FeatureOrigin {
    type Err = FeatureOriginParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        match value {
            "base-slic3r" => Ok(Self::BaseSlic3r),
            "shared-downstream" => Ok(Self::SharedDownstream),
            "fork-specific" => Ok(Self::ForkSpecific),
            "unknown-needs-review" => Ok(Self::UnknownNeedsReview),
            _ => Err(FeatureOriginParseError {
                value: value.to_owned(),
            }),
        }
    }
}
```

This pattern matches Phase 34 strict parsing and canonical display requirements. [VERIFIED: 34-CONTEXT.md; CITED: https://doc.rust-lang.org/std/str/trait.FromStr.html; CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html]

### Validated Newtype for Parity Surface

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ParitySurface(&'static str);

impl ParitySurface {
    pub const fn as_str(self) -> &'static str {
        self.0
    }
}

impl TryFrom<&str> for ParitySurface {
    type Error = ParitySurfaceParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        match value {
            "cli.version"
            | "cli.help"
            | "cli.other"
            | "export.workflows"
            | "transform.workflows"
            | "linux.runtime"
            | "windows.runtime"
            | "linux.packaged-launcher"
            | "windows.packaged-launcher"
            | "config"
            | "config.persistence"
            | "file-formats"
            | "generated-outputs"
            | "launcher-packaging" => Ok(Self(value)),
            _ => Err(ParitySurfaceParseError {
                value: value.to_owned(),
            }),
        }
    }
}
```

The accepted token list is sourced from `packages/parity/status.tsv`, and the private field prevents arbitrary raw strings from crossing the boundary. [VERIFIED: packages/parity/status.tsv; 34-CONTEXT.md]

### Source Pin Parse Tests

```rust
#[test]
fn parses_canonical_vendor_source_ref() {
    // Arrange
    let source_ref =
        "bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6";

    // Act
    let parsed = source_ref.parse::<VendorSourceRef>();

    // Assert
    assert_eq!(
        parsed,
        Ok(VendorSourceRef::bambu_studio_v02_06_00_51())
    );
}

#[test]
fn rejects_branch_head_source_ref() {
    // Arrange
    let source_ref =
        "bambustudio:branch-main@e150b502b3d2afc98b83dcc9e5720e998f9eb79a";

    // Act
    let parsed = source_ref.parse::<VendorSourceRef>();

    // Assert
    assert_eq!(
        parsed,
        Err(VendorSourceRefParseError::UnknownSourcePin {
            value: source_ref.to_owned()
        })
    );
}
```

These tests follow the existing Arrange/Act/Assert pattern and prove branch-head observations do not parse as accepted source identity. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/tests/parse.rs; packages/fork-vendors/forks.tsv; 34-CONTEXT.md]

## Testing Strategy

| Behavior | Test Type | Recommended Command | Source |
|---|---|---|---|
| Every `DownstreamFork` token parses, displays, and rejects alternates such as `bambu-studio`. | Rust integration test in `tests/flavor_contracts.rs` | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv] |
| `FlavorId` includes `base-slic3r` and remains a distinct type from `DownstreamFork`. | Rust integration test | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: 34-CONTEXT.md] |
| `VendorSourceRef` accepts only the three canonical source pins and rejects observed branch heads, malformed commits, missing separators, and unknown vendors. | Rust integration test | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/README.md; 34-CONTEXT.md] |
| `FeatureOrigin` parses the four ownership tokens and distinguishes base/shared/fork/unknown cases. | Rust integration test | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: packages/fork-inventories/README.md; 34-CONTEXT.md] |
| `ParitySurface` validates all current `status.tsv` surface tokens and rejects unknown raw strings. | Rust integration test | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: packages/parity/status.tsv; 34-CONTEXT.md] |
| `ChecklistStatus` parses the four v1.9 decision tokens and does not imply executable parity. | Rust integration test | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:flavor_contracts_test` | [VERIFIED: packages/fork-inventories/README.md; 34-CONTEXT.md] |
| New module and tests are included in Bazel formatting, clippy, and aggregate verify. | Bazel tests | `bazel test //packages/slic3r-rust/crates/slic3r_contracts:rustfmt_check //packages/slic3r-rust/crates/slic3r_contracts:clippy //packages/slic3r-rust:verify` | [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel; packages/slic3r-rust/BUILD.bazel] |
| Cargo workspace still passes under pinned Rust 1.94.1. | Cargo checks | `cd packages/slic3r-rust && rustup run 1.94.1 cargo fmt --all -- --check && rustup run 1.94.1 cargo clippy --workspace --all-targets --all-features -- -D warnings && rustup run 1.94.1 cargo build --workspace --all-targets --all-features && rustup run 1.94.1 cargo test --workspace --all-features` | [VERIFIED: user-provided AGENTS.md instructions in task prompt; packages/slic3r-rust/Cargo.toml; rustup command output] |

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| Existing `slic3r_contracts` models launcher command contracts and currently uses `LauncherCommand::Unsupported` for unsupported CLI invocations. | Phase 34 should add strict contract parsers with structured errors for fork/flavor metadata. | Phase 34 planning. [VERIFIED: packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs; 34-CONTEXT.md] | Unsupported CLI behavior remains unchanged, while metadata boundary parsing gets explicit errors. [VERIFIED: 34-CONTEXT.md] |
| Phase 32 source pins live as checked-in TSV metadata. | Phase 34 should expose typed `VendorSourceRef` values for the canonical source pins. | After Phase 32 completion. [VERIFIED: packages/fork-vendors/forks.tsv; .planning/STATE.md] | Rust callers can depend on parsed source identity without reading or duplicating raw source strings. [VERIFIED: .planning/REQUIREMENTS.md] |
| Phase 33 ownership and decision vocabularies live as TSV enum-like fields. | Phase 34 should expose `FeatureOrigin` and `ChecklistStatus` Rust types for those vocabularies. | After Phase 33 completion. [VERIFIED: packages/fork-inventories/README.md; .planning/STATE.md] | Future registry and parity planning can receive typed values instead of ad hoc strings. [VERIFIED: .planning/ROADMAP.md] |
| Parity status tokens are validated by shell/data-package workflows. | Phase 34 should expose a validated `ParitySurface` Rust boundary value for the same token list. | Phase 34 planning. [VERIFIED: packages/parity/status.tsv; 34-CONTEXT.md] | Rust code can mention parity surfaces without hardcoding launcher behavior. [VERIFIED: 34-CONTEXT.md] |

**Deprecated/outdated:** [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md]

- Passing raw vendor strings through core migration logic is the behavior ARCH-01 is meant to replace. [VERIFIED: .planning/REQUIREMENTS.md]
- Accepting branch-head observations as source identity is forbidden by Phase 32/34 decisions. [VERIFIED: packages/fork-vendors/README.md; 34-CONTEXT.md]
- Implementing runtime fork behavior, fork-flavor release builds, online/cloud integration, credential handling, or non-free plugin ingestion is out of scope. [VERIFIED: .planning/REQUIREMENTS.md; 34-CONTEXT.md]

## Assumptions Log

All claims in this research were verified from repo files, command output, or cited official documentation; no `[ASSUMED]` claims are used. [VERIFIED: research process]

| # | Claim | Section | Risk if Wrong |
|---|---|---|---|
| None | None | None | None |

## Open Questions

None are blocking. [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|---|---|---:|---|---|
| Bazel / Bazelisk | Repo-native Rust verification and Bazel Rust tests | yes | 8.6.0 | None needed. [VERIFIED: command output; .bazelversion] |
| rules_rust | `rust_library`, `rust_test`, `rust_clippy`, `rustfmt_test` | yes | 0.69.0 in `MODULE.bazel` | None needed. [VERIFIED: MODULE.bazel] |
| Rust toolchain via `rustup run 1.94.1` | Cargo format, clippy, build, and test commands | yes | rustc/cargo 1.94.1 | Use Bazel pinned toolchain if Cargo invocation is unnecessary. [VERIFIED: rustup command output; MODULE.bazel] |
| Default Cargo/Rust | Direct `cargo` or `rustc` without `rustup run` | yes, but too old for workspace intent | cargo/rustc 1.91.1 | Use `rustup run 1.94.1` or Bazel. [VERIFIED: command output; packages/slic3r-rust/Cargo.toml] |
| rustfmt | Formatting checks | yes | rustfmt 1.8.0 under Rust 1.94.1 | Use `bazel test //packages/slic3r-rust/crates/slic3r_contracts:rustfmt_check`. [VERIFIED: rustup command output; packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |
| Clippy | Lint checks | yes | clippy 0.1.94 under Rust 1.94.1 | Use `bazel test //packages/slic3r-rust/crates/slic3r_contracts:clippy`. [VERIFIED: rustup command output; packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel] |
| Git | Repo sync and commit | yes | 2.53.0 | None needed. [VERIFIED: command output] |
| ripgrep | Research and final text checks | yes | 15.1.0 | Use `grep -R` if unavailable. [VERIFIED: command output] |

**Missing dependencies with no fallback:** None. [VERIFIED: command outputs]

**Missing dependencies with fallback:** Default `cargo`/`rustc` is older than the workspace target, but `rustup run 1.94.1` and Bazel provide the required toolchain. [VERIFIED: command outputs; MODULE.bazel; packages/slic3r-rust/Cargo.toml]

## Security Domain

Security enforcement is enabled by default because `.planning/config.json` does not set `security_enforcement: false`. [VERIFIED: .planning/config.json; GSD researcher workflow instructions]

The OWASP ASVS project describes ASVS as a basis for testing technical security controls and secure development requirements; the latest stable ASVS version advertised by the OWASP project page is 5.0.0. [CITED: https://www.owasp.community/projects/asvs]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---|---|---|
| V2 Authentication | no | Phase 34 adds no authentication surface. [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md] |
| V3 Session Management | no | Phase 34 adds no session or credential storage surface. [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md] |
| V4 Access Control | no | Phase 34 adds no runtime access-control decision or external service boundary. [VERIFIED: 34-CONTEXT.md] |
| V5 Input Validation | yes | Parse raw fork, flavor, source, feature-origin, parity, and checklist strings into typed Rust values before core logic. [VERIFIED: .planning/REQUIREMENTS.md; 34-CONTEXT.md] |
| V6 Cryptography | no | Phase 34 adds no cryptographic function and must not ingest credential or plugin behavior. [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md] |

### Known Threat Patterns for Rust Contract Parsing

| Pattern | STRIDE | Standard Mitigation |
|---|---|---|
| Token spoofing through alternate spelling such as `bambu-studio` | Tampering | Strict `FromStr`/`TryFrom<&str>` token matching against canonical TSV vocabulary. [VERIFIED: 34-CONTEXT.md; packages/fork-vendors/forks.tsv] |
| Branch-head source refs accepted as release pins | Tampering | Match exact selected stable tags and peeled commits from `forks.tsv`; reject observed default branch heads. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-vendors/README.md] |
| Invalid source refs represented as valid structs | Tampering | Keep struct fields private and expose only fallible constructors/parser APIs. [VERIFIED: 34-CONTEXT.md; CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md] |
| Source identity interpreted as runtime parity | Repudiation | Keep `VendorSourceRef`, `ParitySurface`, and `ChecklistStatus` as separate types and avoid runtime registry behavior. [VERIFIED: 34-CONTEXT.md; packages/fork-inventories/README.md] |

## Sources

### Primary (HIGH Confidence)

- `.planning/phases/34-rust-flavor-contracts/34-CONTEXT.md` - locked Phase 34 decisions, discretion, deferrals, and canonical references. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - ARCH-01 requirement and v1.9 out-of-scope boundaries. [VERIFIED: file read]
- `.planning/ROADMAP.md`, `.planning/STATE.md`, and `.planning/PROJECT.md` - Phase 34 position, dependency, and milestone state. [VERIFIED: file read]
- `.planning/phases/32-vendor-source-manifest-and-license-baseline/32-CONTEXT.md` - selected source-pin and branch-head drift boundary decisions. [VERIFIED: file read]
- `.planning/phases/33-inventory-templates-and-source-pinned-fork-inventories/33-CONTEXT.md` - ownership and checklist vocabulary handoff. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_contracts/src/lib.rs`, `tests/parse.rs`, `BUILD.bazel`, and `Cargo.toml` - current contract crate patterns. [VERIFIED: file read]
- `packages/slic3r-rust/Cargo.toml`, `BUILD.bazel`, `README.md`, `Cargo.lock`, and `MODULE.bazel` - workspace, toolchain, dependency, and verification surface. [VERIFIED: file read]
- `packages/fork-vendors/forks.tsv` and `README.md` - canonical vendor IDs and source pins. [VERIFIED: file read]
- `packages/fork-inventories/*.tsv`, `category-map.tsv`, and `README.md` - ownership, decision, source-ref, and inventory vocabularies. [VERIFIED: file read]
- `packages/parity/status.tsv`, `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/contract-inventory.md`, and `docs/port/parity-matrix.md` - parity surface tokens and docs integration expectations. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md` - repo-local and Bright Builds workflow constraints. [VERIFIED: file read]

### Standards and Official Docs (HIGH Confidence)

- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md` - Bright Builds rule levels and standards routing. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/index.md]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md` - parse-at-boundaries and illegal-state guidance. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/architecture.md]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md` - guard clauses and code shape guidance. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/code-shape.md]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md` - repo-native verification guidance. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/verification.md]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md` - unit test and Arrange/Act/Assert guidance. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/core/testing.md]
- `https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md` - Rust module, newtype/enum, `let...else`, and verification guidance. [CITED: https://github.com/bright-builds-llc/bright-builds-rules/blob/main/standards/languages/rust.md]
- `https://doc.rust-lang.org/std/str/trait.FromStr.html` - Rust `FromStr` API. [CITED: https://doc.rust-lang.org/std/str/trait.FromStr.html]
- `https://doc.rust-lang.org/std/convert/trait.TryFrom.html` - Rust `TryFrom` API. [CITED: https://doc.rust-lang.org/std/convert/trait.TryFrom.html]
- `https://doc.rust-lang.org/std/fmt/trait.Display.html` - Rust `Display` API and parseability note. [CITED: https://doc.rust-lang.org/std/fmt/trait.Display.html]
- `https://www.owasp.community/projects/asvs` - OWASP ASVS purpose and latest stable version note. [CITED: https://www.owasp.community/projects/asvs]

### Secondary (MEDIUM Confidence)

- None used; recommendations are based on locked phase context, repo files, command output, and official docs. [VERIFIED: research process]

### Tertiary (LOW Confidence)

- None used. [VERIFIED: research process]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - repo files confirm the Rust workspace, Bazel/rules_rust setup, no external Rust dependencies, and exact toolchain pin. [VERIFIED: packages/slic3r-rust/Cargo.toml; MODULE.bazel; packages/slic3r-rust/Cargo.lock]
- Architecture: HIGH - Phase 34 locks the crate boundary and pure-contract scope, and existing Bazel targets show how source/test additions must be wired. [VERIFIED: 34-CONTEXT.md; packages/slic3r-rust/crates/slic3r_contracts/BUILD.bazel]
- Vocabulary: HIGH - all canonical tokens are checked into Phase 32/33/parity TSV files. [VERIFIED: packages/fork-vendors/forks.tsv; packages/fork-inventories/README.md; packages/parity/status.tsv]
- Error design: MEDIUM - std-only explicit errors satisfy Phase 34 and current dependency posture, but exact error type names remain planner discretion. [VERIFIED: 34-CONTEXT.md; packages/slic3r-rust/Cargo.lock]
- Pitfalls: HIGH - scope boundaries are explicitly documented in Phase 34 context, requirements, and package READMEs. [VERIFIED: 34-CONTEXT.md; .planning/REQUIREMENTS.md; packages/fork-inventories/README.md]

**Research date:** 2026-05-26 [VERIFIED: environment current_date]
**Valid until:** 2026-06-25 for repo-local implementation patterns; re-check TSV vocabularies and toolchain pins if Phase 34 is planned after that date. [VERIFIED: repo-local files as of research date]
