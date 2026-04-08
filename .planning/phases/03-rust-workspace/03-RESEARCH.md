# Phase 03: Rust Workspace - Research

**Researched:** 2026-04-08
**Domain:** Rust workspace bootstrapping under Bazel on macOS
**Confidence:** MEDIUM

\<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions

None. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md]

### Claude's Discretion

All implementation choices are at the agent's discretion within the locked roadmap and project constraints. Use the Phase 3 goal, success criteria, existing package scaffold, Bright Builds requirements, and Bazel-first repo structure as the governing spec. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md]

### Deferred Ideas (OUT OF SCOPE)

None. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md]
\</user_constraints>

\<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| RUST-01 | Maintainer can build a new Rust package in the monorepo that complies with the Bright Builds Coding and Architecture Requirements. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md] | Pin `rules_rust` under Bzlmod, register a Rust toolchain in `MODULE.bazel`, add one real crate under `packages/slic3r-rust/crates/`, and model it with native `rust_library` targets plus Bright Builds-aligned module boundaries. [CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/AGENTS.bright-builds.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/architecture.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/languages/rust.md] |
| RUST-02 | Maintainer can run Rust formatting, linting, unit tests, and package-local verification through the Bazel-driven workflow on macOS. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md] | Use `rustfmt_test`, `rust_clippy`, `rust_test`, and a Bazel `test_suite` aggregate instead of shelling out to Cargo for the verification gate; use `bazel run @rules_rust//:rustfmt` for write-mode formatting. [CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazel.build/reference/be/general] |
\</phase_requirements>

## Summary

Phase 3 should stand up the Rust package with native Bazel Rust rules, not with shell wrappers around `cargo fmt`, `cargo clippy`, or `cargo test`. The repo already has Bzlmod enabled, Bazel pinned to `8.6.0`, and `packages/slic3r-rust` reserved as the Rust package boundary, but today that package is only an empty virtual Cargo workspace with no toolchain deps and no runnable Rust targets. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelrc; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel]

The lowest-risk plan is to add `rules_rust` `0.69.0`, pin the Rust toolchain to `1.94.1`, create one real library crate under `packages/slic3r-rust/crates/`, and expose build, test, clippy, rustfmt-check, and aggregate verify targets directly in Bazel. `crate_universe` is the standard answer once third-party crates arrive, but Phase 3 does not need it yet because there are no external Rust dependencies in the repo and the phase success criteria are about workspace/toolchain/verification scaffolding, not dependency ingestion. [CITED: https://registry.bazel.build/modules/rules_rust; CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0; CITED: https://blog.rust-lang.org/releases/; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml; ASSUMED]

The current machine has Xcode and a local Rust toolchain, but no `bazel` or `bazelisk` on `PATH`, so local phase execution is blocked until Bazel is installed. Because the repo already pins `.bazelversion`, Bazelisk is the cleanest onboarding path. \[VERIFIED: local command `xcode-select -p`; VERIFIED: local command `clang --version`; VERIFIED: local command `rustc --version`; VERIFIED: local command `cargo --version`; VERIFIED: local command `bazel --version || bazelisk --version`; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion; CITED: https://github.com/bazelbuild/bazelisk\]

**Primary recommendation:** Use `rules_rust` `0.69.0` with a pinned `1.94.1` stable toolchain, one real `slic3r_core` crate, native `rust_*` Bazel targets, and a runnable `test_suite` verification surface; defer `crate_universe` until the first external Rust dependency appears. [CITED: https://registry.bazel.build/modules/rules_rust; CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; CITED: https://bazel.build/reference/be/general; ASSUMED]

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Bazel | `8.6.0` `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]` | Top-level build/test entrypoint for the monorepo. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel]` | The repo is already Bzlmod-first and Phase 3 success criteria explicitly require Bazel-driven build and verification on macOS. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelrc; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md]` |
| Bazelisk | current launcher; install path recommended on macOS via Homebrew `[CITED: https://github.com/bazelbuild/bazelisk]` | Ensures `bazel` resolves the version pinned in `.bazelversion`. `[CITED: https://github.com/bazelbuild/bazelisk; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]` | This repo already pins Bazel, and Bazelisk is the documented launcher that reads `.bazelversion` and installs `bazel`/`bazelisk` on `PATH`. `[CITED: https://github.com/bazelbuild/bazelisk]` |
| `rules_rust` | `0.69.0` released `2026-02-26` `[CITED: https://registry.bazel.build/modules/rules_rust; CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0]` | Official Bazel Rust rules for `rust_library`, `rust_test`, clippy, rustfmt, and toolchain registration. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` | It is the official Rust/Bazel ruleset, published in the Bazel Central Registry and tested on macOS Apple Silicon and Bazel `8.x`. `[CITED: https://registry.bazel.build/modules/rules_rust]` |
| Rust toolchain | `1.94.1` stable released `2026-03-26` `[CITED: https://blog.rust-lang.org/releases/; CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]` | Compiler/toolchain pin for reproducible Rust builds under Bazel. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]` | `rules_rust` Bzlmod docs currently default host tools to `1.94.1`, and Phase 3 should pin an exact stable version instead of floating. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html; CITED: https://blog.rust-lang.org/releases/]` |
| Cargo virtual workspace | `[workspace]` with `resolver = "3"` and explicit members `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml; CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html]` | Keeps Rust package metadata, shared lockfile semantics, workspace lints, and inherited package metadata inside `packages/slic3r-rust`. `[CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html]` | Cargo workspaces are the standard Rust-side packaging boundary even when Bazel owns the repo-wide orchestration. `[CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md]` |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `rust_test` | bundled with `rules_rust` `0.69.0` `[CITED: https://bazelbuild.github.io/rules_rust/rust.html]` | Native unit and integration test execution for Rust crates under Bazel. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html]` | Use for crate unit tests and first package smoke tests in Phase 3. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html]` |
| `rust_clippy` | bundled with `rules_rust` `0.69.0` `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]` | Native Clippy execution on specific Bazel Rust targets. `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]` | Use for package-local lint gating instead of shelling out to `cargo clippy`. `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]` |
| `rustfmt_test` | bundled with `rules_rust` `0.69.0` `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` | `rustfmt --check` as a Bazel test target. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` | Use in the verification suite; use `bazel run @rules_rust//:rustfmt` for write-mode formatting. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` |
| `test_suite` | Bazel built-in general rule `[CITED: https://bazel.build/reference/be/general]` | Runnable aggregate verification target for fmt/lint/tests. `[CITED: https://bazel.build/reference/be/general]` | Use for `//packages/slic3r-rust:verify` and any root-level runnable Rust verification surface. `[CITED: https://bazel.build/reference/be/general]` |
| `crate_universe` | bundled with `rules_rust` `0.69.0` `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]` | Generates Bazel Rust dependency targets from Cargo manifests or Bazel specs. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]` | Defer until the first external Rust dependency or generated build-script dependency appears. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]` |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Native `rust_test` / `rust_clippy` / `rustfmt_test` targets `[CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` | Shell wrappers that call `cargo test`, `cargo clippy`, and `cargo fmt --check`. `[ASSUMED]` | This duplicates toolchain management, weakens Bazel visibility, and misses the repo’s Bazel-first success criteria. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]` |
| Deferring `crate_universe` until external crates exist. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]` | Enabling `crate_universe` from `Cargo.toml` immediately. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]` | `from_cargo` is standard once dependencies exist, but it adds a repin and lockfile workflow before this phase needs third-party crates. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]` |
| `test_suite` for runnable verification aggregates. `[CITED: https://bazel.build/reference/be/general]` | Root `alias` targets that point at tests or test suites. `[CITED: https://bazel.build/reference/be/general]` | Bazel aliases do not execute tests when invoked on the command line, and `test_suite` cannot be aliased as a runnable test surface. `[CITED: https://bazel.build/reference/be/general]` |

**Installation:**

```bash
brew install bazelisk
```

The repo already pins Bazel in `.bazelversion`, so Phase 3 should document Bazelisk as the expected local launcher. `[CITED: https://github.com/bazelbuild/bazelisk; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]`

**Version verification:**

- Bazel repo pin: `8.6.0`. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]`
- `rules_rust`: `0.69.0`, released `2026-02-26`. `[CITED: https://registry.bazel.build/modules/rules_rust; CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0]`
- Rust stable: `1.94.1`, released `2026-03-26`. `[CITED: https://blog.rust-lang.org/releases/]`
- Local host state: `rustc 1.91.1`, `cargo 1.91.1`, `rustfmt 1.8.0-stable`, `clippy 0.1.91`, and no `bazel`/`bazelisk` on `PATH`. `[VERIFIED: local command `rustc --version`; VERIFIED: local command `cargo --version`; VERIFIED: local command `rustfmt --version`; VERIFIED: local command `cargo clippy --version`; VERIFIED: local command `bazel --version || bazelisk --version`]`

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/
├── BUILD.bazel                  # package-level aggregate build and verify surfaces
├── Cargo.toml                   # virtual Cargo workspace root
└── crates/
    └── slic3r_core/
        ├── BUILD.bazel          # rust_library + rust_test targets
        ├── Cargo.toml           # member crate manifest
        ├── src/
        │   └── lib.rs           # Bright Builds-friendly pure core start point
        └── tests/
            └── smoke.rs         # first integration/smoke test
```

This keeps the Rust work inside the already-reserved package boundary, satisfies Cargo workspace requirements, and gives Bazel explicit package ownership at both the package and crate levels. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel; CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/architecture.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/languages/rust.md; ASSUMED]`

### Pattern 1: Pin The Rust Toolchain In `MODULE.bazel`

**What:** Add `rules_rust`, register a pinned stable toolchain, and keep Bazel as the owner of compiler selection. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`
**When to use:** Immediately in Phase 3, before adding any Rust build targets. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]`
**Example:**

```bzl
# Source: https://bazelbuild.github.io/rules_rust/
# Source: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html
bazel_dep(name = "rules_rust", version = "0.69.0")

rust = use_extension("@rules_rust//rust:extensions.bzl", "rust")
rust.toolchain(
    edition = "2024",
    versions = ["1.94.1"],
    rustfmt_version = "1.94.1",
)

use_repo(rust, "rust_toolchains")
register_toolchains("@rust_toolchains//:all")
```

### Pattern 2: Keep Cargo As Package Metadata, Not Repo Orchestration

**What:** Keep `packages/slic3r-rust/Cargo.toml` as a virtual workspace root with explicit members and shared workspace metadata while Bazel remains the top-level build runner. `[CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]`
**When to use:** For Phase 3 and later phases where Rust crates grow under `packages/slic3r-rust`. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md]`
**Example:**

```toml
# Source: https://doc.rust-lang.org/cargo/reference/workspaces.html
[workspace]
members = ["crates/slic3r_core"]
resolver = "3"

[workspace.package]
edition = "2024"
rust-version = "1.94"

[workspace.lints.rust]
unsafe_code = "forbid"
```

### Pattern 3: Build A Runnable Verify Surface With Native Bazel Rules

**What:** Use `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test`, then aggregate them with `test_suite`. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; CITED: https://bazel.build/reference/be/general]`
**When to use:** For the Phase 3 package-level verification contract and any root-level convenience verify target. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]`
**Example:**

```bzl
# Source: https://bazelbuild.github.io/rules_rust/rust.html
# Source: https://bazelbuild.github.io/rules_rust/rust_clippy.html
# Source: https://bazelbuild.github.io/rules_rust/rust_fmt.html
# Source: https://bazel.build/reference/be/general
load("@rules_rust//rust:defs.bzl", "rust_clippy", "rust_library", "rust_test", "rustfmt_test")

rust_library(
    name = "slic3r_core",
    srcs = ["src/lib.rs"],
    edition = "2024",
)

rust_test(
    name = "slic3r_core_test",
    crate = ":slic3r_core",
)

rust_clippy(
    name = "clippy",
    testonly = True,
    deps = [
        ":slic3r_core",
        ":slic3r_core_test",
    ],
)

rustfmt_test(
    name = "rustfmt_check",
    targets = [
        ":slic3r_core",
        ":slic3r_core_test",
    ],
)

test_suite(
    name = "verify",
    tests = [
        ":rustfmt_check",
        ":clippy",
        ":slic3r_core_test",
    ],
)
```

### Anti-Patterns to Avoid

- **Cargo shell wrappers as the primary gate:** Do not satisfy RUST-02 by writing shell scripts that only forward to `cargo fmt`, `cargo clippy`, or `cargo test`; use native Bazel Rust rules so Bazel sees the graph and owns the verification surface. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; ASSUMED]`
- **Root aliases for runnable test surfaces:** Bazel documents that aliases do not execute tests and that `test_suite` cannot be aliased as a runnable suite. `[CITED: https://bazel.build/reference/be/general]`
- **Floating rustfmt version:** `rules_rust` currently defaults `rustfmt_version` to a nightly toolchain date even when the Rust compiler pin is stable, so Phase 3 should set `rustfmt_version` explicitly to the same stable version. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`
- **Premature `crate_universe` repin workflow:** `from_cargo` is correct when external crates are real, but it requires repinning before the first build and on manifest changes; that is unnecessary process overhead for an empty dependency graph. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]`

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Rust formatting gate | A `sh_binary` or `sh_test` that shells out to `cargo fmt --check`. `[ASSUMED]` | `rustfmt_test` plus `bazel run @rules_rust//:rustfmt`. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` | The official rules already expose both check-mode and write-mode formatting surfaces. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` |
| Rust lint gate | A custom script that invokes `cargo clippy` over package paths. `[ASSUMED]` | `rust_clippy` or `rust_clippy_aspect`. `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]` | This keeps linting target-scoped and Bazel-native. `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]` |
| Runnable verification aggregate | An `alias` chain that points at tests. `[CITED: https://bazel.build/reference/be/general]` | `test_suite`. `[CITED: https://bazel.build/reference/be/general]` | Bazel explicitly says aliases do not run tests and that a `test_suite` should be used instead. `[CITED: https://bazel.build/reference/be/general]` |
| Rust toolchain bootstrap | Requiring contributors to keep the host `rustup` toolchain in sync with the repo as the authoritative build path. `[ASSUMED]` | `rules_rust` toolchain registration plus Bazelisk for Bazel version pinning. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://github.com/bazelbuild/bazelisk]` | That keeps the Bazel path reproducible and reduces host drift. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://github.com/bazelbuild/bazelisk]` |
| External crate BUILD generation once dependencies appear | Hand-writing third-party crate BUILD targets. `[ASSUMED]` | `crate_universe` `from_cargo` or `from_specs`. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]` | The official dependency generator already supports Cargo workspaces, direct specs, repinning, and generated aliases. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]` |

**Key insight:** Phase 3 should hand-roll as little as possible: the custom work belongs in package naming, target layout, docs, and Bright Builds-aligned crate structure, not in re-implementing Rust build/test/lint/fmt plumbing that `rules_rust` already provides. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/verification.md]`

## Common Pitfalls

### Pitfall 1: A Root `alias` That Looks Runnable But Does Not Execute Tests

**What goes wrong:** The plan copies the existing alias-heavy package pattern and creates `//:rust_verify` as an `alias`, but `bazel test //:rust_verify` does not execute the underlying tests. `[CITED: https://bazel.build/reference/be/general]`
**Why it happens:** The repo already uses aliases for non-test surfaces such as package placeholders and build wrappers. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel]`
**How to avoid:** Use `test_suite` for any runnable verify surface, whether package-local or root-level. `[CITED: https://bazel.build/reference/be/general]`
**Warning signs:** A plan says “add an alias for verify” or “alias the test suite.” `[CITED: https://bazel.build/reference/be/general]`

### Pitfall 2: Stable Compiler, Nightly Formatter Drift

**What goes wrong:** The Rust compiler is pinned to stable, but rustfmt silently comes from the nightly default in `rules_rust`, so formatting can drift from local expectations. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`
**Why it happens:** The `rust.toolchain` docs show the default `versions` and `rustfmt_version` are not the same thing. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`
**How to avoid:** Set `rustfmt_version` explicitly to the same stable pin as `versions`. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`
**Warning signs:** The toolchain pin is stable, but `rustfmt_version` is omitted from `MODULE.bazel`. `[CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]`

### Pitfall 3: Pulling In `crate_universe` Before It Pays For Itself

**What goes wrong:** The phase spends time on Cargo lockfile generation and repin commands even though the initial crate has no third-party dependencies. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]`
**Why it happens:** `crate_universe` is the standard long-term answer for Rust dependencies, so it is easy to add it reflexively instead of when the graph actually needs it. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]`
**How to avoid:** Keep Phase 3 focused on toolchain registration and native local targets; introduce `crate_universe` in the first dependency-bearing phase. `[ASSUMED]`
**Warning signs:** The plan adds `Cargo.lock`, repin instructions, and generated dependency repos before any external dependency exists. `[CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html; ASSUMED]`

### Pitfall 4: Assuming The Host Already Has Bazel

**What goes wrong:** The plan says “run `bazel build`” without documenting how contributors get Bazel on macOS. `[VERIFIED: local command `bazel --version || bazelisk --version`]`
**Why it happens:** The repo already contains `.bazelversion`, which can make the tool appear present conceptually even when no launcher is installed. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]`
**How to avoid:** Document Bazelisk installation as part of Phase 3 and keep the Rust toolchain Bazel-managed. `[CITED: https://github.com/bazelbuild/bazelisk; CITED: https://bazelbuild.github.io/rules_rust/]`
**Warning signs:** The docs mention `.bazelversion` but never mention Bazelisk or a `bazel` install path. `[CITED: https://github.com/bazelbuild/bazelisk; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion]`

### Pitfall 5: Treating `rules_rust` Bzlmod As Mature Enough To Skip Exact Pinning

**What goes wrong:** The phase uses floating or copied values from old examples and then gets hit by Bzlmod-edge behavior later. `[CITED: https://bazelbuild.github.io/rules_rust/]`
**Why it happens:** The official introduction still says Bzlmod support is a work in progress even though most features should work. `[CITED: https://bazelbuild.github.io/rules_rust/]`
**How to avoid:** Pin `rules_rust`, pin Rust, keep Phase 3 small, and verify the concrete build/test/fmt/lint surfaces immediately. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://registry.bazel.build/modules/rules_rust]`
**Warning signs:** The plan says “use latest” without writing down the exact rules/toolchain versions. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://registry.bazel.build/modules/rules_rust]`

## Code Examples

Verified patterns from official sources:

### Bzlmod Rust Toolchain Registration

```bzl
# Source: https://bazelbuild.github.io/rules_rust/
# Source: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html
bazel_dep(name = "rules_rust", version = "0.69.0")

rust = use_extension("@rules_rust//rust:extensions.bzl", "rust")
rust.toolchain(
    edition = "2024",
    versions = ["1.94.1"],
    rustfmt_version = "1.94.1",
)

use_repo(rust, "rust_toolchains")
register_toolchains("@rust_toolchains//:all")
```

### Cargo Workspace Root

```toml
# Source: https://doc.rust-lang.org/cargo/reference/workspaces.html
[workspace]
members = ["crates/slic3r_core"]
resolver = "3"

[workspace.package]
edition = "2024"
rust-version = "1.94"

[workspace.lints.rust]
unsafe_code = "forbid"
```

### Package Verify Surface

```bzl
# Source: https://bazelbuild.github.io/rules_rust/rust.html
# Source: https://bazelbuild.github.io/rules_rust/rust_clippy.html
# Source: https://bazelbuild.github.io/rules_rust/rust_fmt.html
# Source: https://bazel.build/reference/be/general
load("@rules_rust//rust:defs.bzl", "rust_clippy", "rust_library", "rust_test", "rustfmt_test")

rust_library(
    name = "slic3r_core",
    srcs = ["src/lib.rs"],
    edition = "2024",
)

rust_test(
    name = "slic3r_core_test",
    crate = ":slic3r_core",
)

rust_clippy(
    name = "clippy",
    testonly = True,
    deps = [":slic3r_core", ":slic3r_core_test"],
)

rustfmt_test(
    name = "rustfmt_check",
    targets = [":slic3r_core", ":slic3r_core_test"],
)

test_suite(
    name = "verify",
    tests = [
        ":rustfmt_check",
        ":clippy",
        ":slic3r_core_test",
    ],
)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| WORKSPACE-era Rust setup with `rust_register_toolchains`. `[CITED: https://bazelbuild.github.io/rules_rust/]` | Bzlmod `bazel_dep` plus `rust.toolchain` and `use_repo`. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]` | Current official `rules_rust` docs and `0.69.0` release guidance as of `2026-02-26`. `[CITED: https://bazelbuild.github.io/rules_rust/; CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0]` | Matches this repo’s existing Bzlmod-first root and avoids introducing a second dependency model. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelrc; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel]` |
| Cargo-only fmt/lint/test commands at the package boundary. `[ASSUMED]` | Bazel-native `rustfmt_test`, `rust_clippy`, and `rust_test` targets. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust.html]` | Current docs in `rules_rust` `0.69.0`. `[CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0]` | Gives Phase 3 a real Bazel verification surface instead of a wrapped Cargo workflow. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]` |
| Alias-based convenience targets for everything. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel]` | `test_suite` for runnable verification aggregates and aliases only for non-test convenience surfaces. `[CITED: https://bazel.build/reference/be/general]` | Bazel `8.6` reference updated `2026-02-26`. `[CITED: https://bazel.build/reference/be/general]` | Prevents a misleading `//:rust_verify` target that looks testable but does not execute tests. `[CITED: https://bazel.build/reference/be/general]` |

**Deprecated/outdated:**

- A new WORKSPACE-based Rust setup in this repo is outdated because the repo root is already Bzlmod-first and `rules_rust` documents Bzlmod usage directly. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelrc; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel; CITED: https://bazelbuild.github.io/rules_rust/]`
- A verification plan built around custom Cargo shell wrappers is outdated for this phase because `rules_rust` already exposes first-party Bazel lint/fmt/test surfaces. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]`

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Phase 3 should defer `crate_universe` until the first external Rust dependency appears because native local `rust_*` rules are sufficient for the current success criteria. | Summary; Standard Stack; Common Pitfalls | Later dependency-onboarding work may need an extra migration step to introduce generated crate repos. |
| A2 | The first real crate should be a single `slic3r_core` library crate under `packages/slic3r-rust/crates/` instead of multiple crates in Phase 3. | Summary; Architecture Patterns | A later phase may need an earlier crate split for contracts or CLI boundaries. |
| A3 | Phase 3 can leave `Cargo.lock` out unless `crate_universe` or external dependencies are introduced. | Open Questions | If maintainers want Cargo manifests to be the dependency source of truth immediately, the plan will need to add `Cargo.lock` generation sooner. |

## Open Questions

1. **Should Phase 3 commit `Cargo.lock` immediately, or wait for the first external dependency?**

   - What we know: The repo currently has no `Cargo.lock`, the Rust package has no members yet, and `crate_universe` only becomes useful once dependencies exist. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml; CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]`
   - What's unclear: Whether maintainers want Cargo workspace metadata to become the dependency source of truth in Phase 3 or only in the first dependency-bearing phase. `[ASSUMED]`
   - Recommendation: Decide this before planning any task that touches dependency resolution or generated crate repos. `[ASSUMED]`

1. **Should contributor onboarding rely on a documented Bazelisk install, or should the repo add a checked-in launcher wrapper?**

   - What we know: The current host has no `bazel` or `bazelisk` on `PATH`, and Bazelisk documents both Homebrew installation and checked-in launcher patterns. `[VERIFIED: local command `bazel --version || bazelisk --version`; CITED: https://github.com/bazelbuild/bazelisk]`
   - What's unclear: Whether this repo wants “install Bazelisk once” or “always use a checked-in launcher” as the contributor contract. `[ASSUMED]`
   - Recommendation: Pick one onboarding path in the plan and reflect it in `docs/port/checklist.md` and `docs/port/package-map.md`. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; ASSUMED]`

1. **Do root-level Rust convenience targets matter in Phase 3, or are package-level targets enough?**

   - What we know: The repo already exposes root aliases for legacy/package surfaces, but Bazel aliases are the wrong tool for runnable test surfaces. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; CITED: https://bazel.build/reference/be/general]`
   - What's unclear: Whether maintainers want `bazel test //packages/slic3r-rust:verify` only, or also a root `//:rust_verify` convenience target implemented as a `test_suite`. `[ASSUMED]`
   - Recommendation: If root conveniences are desired, use direct root `test_suite`/build targets rather than alias chains. `[CITED: https://bazel.build/reference/be/general; ASSUMED]`

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| `bazel` or `bazelisk` on `PATH` | Every Phase 3 build/test/fmt/lint command. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]` | ✗ `[VERIFIED: local command `bazel --version || bazelisk --version`]` | — `[VERIFIED: local command `bazel --version || bazelisk --version`]` | — `[ASSUMED]` |
| Xcode Command Line Tools / Apple toolchain | macOS-native linking and host C/C++ toolchain needs during Bazel Rust builds. `[VERIFIED: local command `xcode-select -p`; VERIFIED: local command `clang --version`; CITED: https://registry.bazel.build/modules/rules_rust]` | ✓ `[VERIFIED: local command `xcode-select -p`; VERIFIED: local command `clang --version`]` | Xcode path present; Apple clang `21.0.0`. `[VERIFIED: local command `xcode-select -p`; VERIFIED: local command `clang --version`]` | — `[ASSUMED]` |
| Local `rustc` / `cargo` / `rustfmt` / `clippy` | Optional manual Cargo inspection and any future non-Bazel Rust tooling. `[VERIFIED: local command `rustc --version`; VERIFIED: local command `cargo --version`; VERIFIED: local command `rustfmt --version`; VERIFIED: local command `cargo clippy --version`]` | ✓ `[VERIFIED: local command `rustc --version`; VERIFIED: local command `cargo --version`; VERIFIED: local command `rustfmt --version`; VERIFIED: local command `cargo clippy --version`]` | `1.91.1` host toolchain; older than recommended Bazel pin. `[VERIFIED: local command `rustc --version`; VERIFIED: local command `cargo --version`; CITED: https://blog.rust-lang.org/releases/]` | Bazel-managed `rules_rust` toolchains should remain the authoritative build path. `[CITED: https://bazelbuild.github.io/rules_rust/; ASSUMED]` |

**Missing dependencies with no fallback:**

- `bazel`/`bazelisk` is missing locally, and the phase success criteria are explicitly Bazel-driven. `[VERIFIED: local command `bazel --version || bazelisk --version`; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]`

**Missing dependencies with fallback:**

- None. `[VERIFIED: local command `bazel --version || bazelisk --version`; ASSUMED]`

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Bazel plus `rules_rust` native test/lint/fmt rules. `[CITED: https://bazelbuild.github.io/rules_rust/rust.html; CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]` |
| Config file | `MODULE.bazel` for toolchain pinning and `packages/slic3r-rust/BUILD.bazel` plus crate BUILD files for target definitions. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel; ASSUMED]` |
| Quick run command | `bazel test //packages/slic3r-rust:verify` once the package verify suite exists. `[ASSUMED]` |
| Full suite command | `bazel test //packages/slic3r-rust/...` for package scope, and `bazel test //...` at the phase gate. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| RUST-01 | Build the first real Rust package from Bazel on macOS. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]` | build/smoke `[ASSUMED]` | `bazel build //packages/slic3r-rust/...` `[ASSUMED]` | ❌ Wave 0 `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml]` |
| RUST-02 | Run formatting, linting, unit tests, and package-local verification through Bazel. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]` | verification suite `[ASSUMED]` | `bazel test //packages/slic3r-rust:verify` plus `bazel run @rules_rust//:rustfmt` for write-mode formatting. `[CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; ASSUMED]` | ❌ Wave 0 `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel]` |

### Sampling Rate

- **Per task commit:** `bazel test //packages/slic3r-rust:verify` `[ASSUMED]`
- **Per wave merge:** `bazel test //packages/slic3r-rust/...` `[ASSUMED]`
- **Phase gate:** `bazel test //...` `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]`

### Wave 0 Gaps

- [ ] `packages/slic3r-rust/crates/slic3r_core/BUILD.bazel` — missing first real crate target surface for RUST-01/RUST-02. `[ASSUMED]`
- [ ] `packages/slic3r-rust/crates/slic3r_core/src/lib.rs` — missing first Bright Builds-aligned pure library entry point. `[ASSUMED]`
- [ ] `packages/slic3r-rust/crates/slic3r_core/Cargo.toml` — missing first member manifest for the workspace. `[ASSUMED]`
- [ ] `packages/slic3r-rust/BUILD.bazel` updates — missing `rustfmt_test`, `rust_clippy`, and `test_suite` verify surface. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel; ASSUMED]`
- [ ] Bazel launcher install — `bazel`/`bazelisk` is missing locally. `[VERIFIED: local command `bazel --version || bazelisk --version`]`

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no `[ASSUMED]` | Not in scope for a workspace/toolchain phase with no auth surface. `[ASSUMED]` |
| V3 Session Management | no `[ASSUMED]` | Not in scope for this phase. `[ASSUMED]` |
| V4 Access Control | no `[ASSUMED]` | Not in scope for this phase. `[ASSUMED]` |
| V5 Input Validation | yes `[ASSUMED]` | Parse-at-boundary domain types once real CLI/config APIs begin, following Bright Builds architecture guidance. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/architecture.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/languages/rust.md; ASSUMED]` |
| V6 Cryptography | no `[ASSUMED]` | Not in scope unless later phases add signing, hashing policies, or secret transport. `[ASSUMED]` |

### Known Threat Patterns for Rust-under-Bazel Workspace Bootstrapping

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Unpinned Bazel or Rust toolchain drift | Tampering | Pin `.bazelversion`, install Bazelisk, and register an exact Rust toolchain version in `MODULE.bazel`. `[VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.bazelversion; CITED: https://github.com/bazelbuild/bazelisk; CITED: https://bazelbuild.github.io/rules_rust/]` |
| Host-dependent probing in build glue | Tampering | Prefer declarative `rules_rust` toolchain setup over custom host-discovery shell scripts. `[CITED: https://bazelbuild.github.io/rules_rust/; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/verification.md]` |
| Shell interpolation in verification wrappers | Elevation of Privilege | Avoid custom Cargo wrapper scripts for fmt/lint/test; use native Bazel rules instead. `[CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html; CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/code-shape.md]` |

## Sources

### Primary (HIGH confidence)

- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/03-rust-workspace/03-CONTEXT.md` - phase boundary, existing code insights, and discretion scope. [VERIFIED: local file]
- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md` - RUST-01 and RUST-02 requirements. [VERIFIED: local file]
- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/STATE.md` - current phase status. [VERIFIED: local file]
- `/Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel`, `/Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel`, `/Users/peterryszkiewicz/Repos/Slic3r/.bazelrc`, `/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion` - current Bazel root state. [VERIFIED: local files]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel`, `/Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel`, `/Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml` - current Rust package scaffold. [VERIFIED: local files]
- `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md`, `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md` - migration docs expectations. [VERIFIED: local files]
- `/Users/peterryszkiewicz/Repos/Slic3r/AGENTS.md`, `/Users/peterryszkiewicz/Repos/Slic3r/AGENTS.bright-builds.md`, `/Users/peterryszkiewicz/Repos/Slic3r/standards-overrides.md` - repo-local standards routing and overrides state. [VERIFIED: local files]
- `/Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/architecture.md`, `/Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/code-shape.md`, `/Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/verification.md`, `/Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/core/testing.md`, `/Users/peterryszkiewicz/Repos/Slic3r/../coding-and-architecture-requirements/standards/languages/rust.md` - Bright Builds architectural, verification, testing, and Rust requirements. [VERIFIED: local files]
- `https://registry.bazel.build/modules/rules_rust` - current `rules_rust` BCR version, tested platforms, and Bazel-version coverage. [CITED: https://registry.bazel.build/modules/rules_rust]
- `https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0` - `rules_rust` `0.69.0` release date and release guidance. [CITED: https://github.com/bazelbuild/rules_rust/releases/tag/0.69.0]
- `https://bazelbuild.github.io/rules_rust/` - official `rules_rust` setup guidance and Bzlmod caveat. [CITED: https://bazelbuild.github.io/rules_rust/]
- `https://bazelbuild.github.io/rules_rust/rust_bzlmod.html` - toolchain extension defaults and `rustfmt_version` behavior. [CITED: https://bazelbuild.github.io/rules_rust/rust_bzlmod.html]
- `https://bazelbuild.github.io/rules_rust/rust.html` - `rust_library`, `rust_test`, and `rust_lint_config` rules. [CITED: https://bazelbuild.github.io/rules_rust/rust.html]
- `https://bazelbuild.github.io/rules_rust/rust_clippy.html` - `rust_clippy` rule and aspect guidance. [CITED: https://bazelbuild.github.io/rules_rust/rust_clippy.html]
- `https://bazelbuild.github.io/rules_rust/rust_fmt.html` - `rustfmt_test`, write-mode rustfmt, and config settings. [CITED: https://bazelbuild.github.io/rules_rust/rust_fmt.html]
- `https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html` - Cargo-workspace integration and repin workflow. [CITED: https://bazelbuild.github.io/rules_rust/crate_universe_bzlmod.html]
- `https://doc.rust-lang.org/cargo/reference/workspaces.html` - Cargo workspace structure, `resolver = "3"`, `workspace.package`, `workspace.dependencies`, and `workspace.lints`. [CITED: https://doc.rust-lang.org/cargo/reference/workspaces.html]
- `https://blog.rust-lang.org/releases/` - current Rust stable release chronology. [CITED: https://blog.rust-lang.org/releases/]
- `https://bazel.build/reference/be/general` - `alias` and `test_suite` behavior. [CITED: https://bazel.build/reference/be/general]
- `https://github.com/bazelbuild/bazelisk` - Bazelisk install guidance and `.bazelversion` behavior. [CITED: https://github.com/bazelbuild/bazelisk]

### Secondary (MEDIUM confidence)

- None. [VERIFIED: all external recommendations above were drawn from official docs, official registries, or repo-local files]

### Tertiary (LOW confidence)

- None. \[VERIFIED: all intentionally uncertain recommendations are tagged `[ASSUMED]` in-line instead of being sourced from unverified tertiary material\]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - Exact repo state, official `rules_rust` docs, BCR, Bazelisk docs, and Rust release docs all agree on the recommended stack. [VERIFIED: local files; CITED: official sources above]
- Architecture: MEDIUM - The toolchain and target model are well-supported, but the exact first crate split and `crate_universe` timing are still planning assumptions. [CITED: official sources above; ASSUMED]
- Pitfalls: HIGH - The biggest pitfalls are directly documented by Bazel and `rules_rust`, or directly observed in this repo and local environment. [VERIFIED: local files; VERIFIED: local commands; CITED: official sources above]

**Research date:** 2026-04-08
**Valid until:** 2026-04-22 due to the fast-moving `rules_rust` and Rust release cadence. [ASSUMED]
