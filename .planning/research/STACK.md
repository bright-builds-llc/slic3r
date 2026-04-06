# Stack Research

**Domain:** brownfield desktop 3D slicer modernization
**Researched:** 2026-04-06
**Confidence:** MEDIUM

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Bazel | 9.0 LTS | Top-level monorepo build/test orchestrator | Bazel 9 is the current LTS line, and Bzlmod has replaced WORKSPACE as the modern dependency model. That fits a monorepo that must build legacy and Rust packages side by side. |
| Bazelisk | latest | Bazel launcher and version pinning wrapper | Keeps the repo pinned without asking contributors to manage Bazel binaries manually. It also makes upgrades atomic through `.bazelversion`. |
| Rust | stable 1.94.0 | New implementation language | Rust stable is the safest production baseline for the port. The 2024 edition is current and aligns with a new codebase, while keeping the toolchain on stable rather than nightly. |
| Cargo workspace | Rust 2024 edition | Per-Rust-package dependency and crate management | Each Rust package should keep normal Cargo ergonomics inside `packages/`, while Bazel owns top-level orchestration. Use workspace inheritance for shared deps. |
| `rules_rust` | latest release, pinned in `MODULE.bazel` | Bazel integration for Rust targets, tests, fmt, and clippy | The official Rust/Bazel rules provide `rust_library`, `rust_binary`, `rust_test`, `rustfmt`, and `clippy` integration. Bzlmod support exists, though it is still a moving piece. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `rustfmt` | bundled with stable toolchain | Canonical Rust formatting | Use for all Rust code in CI and pre-commit style checks. |
| `clippy` | bundled with stable toolchain | Rust linting | Use for logic that needs maintainability and safety checks beyond the compiler. |
| `cargo metadata` | bundled with Cargo | Inspect crate graph and workspace metadata | Use in parity tooling and repository introspection scripts. |
| `cmp` / `diff` | system tools | Golden-corpus comparisons | Use for legacy-vs-Rust parity checks over fixtures and rendered outputs. |
| `xcode-select` / Xcode Command Line Tools | current installed macOS toolchain | Native macOS build prerequisites | Use on the macOS-first path for compilers, SDKs, and linking. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `mdformat` | Markdown formatting | Useful for `docs/` and planning artifacts already present in this repo. |
| `cargo test` | Rust unit/integration tests | Keep package-local tests close to the Rust workspace. |
| Bazel `sh_test` / `rust_test` | Repository-level verification | Prefer Bazel as the top-level check, with package-local Cargo checks underneath when needed. |
| `cargo fmt --all --check` | Rust formatting gate | Use inside the Rust package, but keep Bazel as the outer orchestrator. |
| `cargo clippy --all-targets --all-features -- -D warnings` | Lint gate | Gate new Rust code before parity claims are made. |

## Installation

```bash
# Bazel launcher
brew install bazelisk

# Rust toolchain
rustup toolchain install stable
rustup component add rustfmt clippy

# macOS compiler toolchain
xcode-select --install
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Bazel 9 + Bzlmod | WORKSPACE-only Bazel | Only for short-lived compatibility shims; Bazel 9 has removed WORKSPACE support. |
| Bazelisk | Direct Bazel binary installs | Acceptable for CI images, but worse for contributor onboarding and version pinning. |
| Rust stable + 2024 edition | nightly Rust | Only for experimental compiler features that are explicitly blocked on stable. |
| Cargo workspace inside `packages/` | One giant root Cargo workspace | Use only if the Rust portion eventually dominates the repository; today Bazel needs to own the repo-wide build. |
| Bazel `sh_test` parity checks | Direct ad hoc shell scripts | Use scripts only as thin wrappers; Bazel should be the authoritative runner. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| New WORKSPACE-based Bazel setup | Bazel 9 removes WORKSPACE support and the ecosystem has moved to modules | `MODULE.bazel` with Bzlmod |
| Cargo as the top-level repo build system | The repo must orchestrate legacy and Rust packages together, not just Rust crates | Bazel at the root, Cargo inside Rust package boundaries |
| Early Rust/C++ FFI as the primary migration boundary | It couples the new code to legacy internals and slows the port before parity is proven | Package boundaries, process boundaries, and golden-corpus comparisons first |
| Perl bootstrap as the preferred launcher path | The migration goal is to move away from Perl, not preserve it as the main entrypoint | Rust/Bazel/shell shims or a Rust CLI entrypoint |
| Windows-first validation | The first milestone is macOS-first and the team is currently on macOS | macOS CLT/Xcode plus macOS Bazel validation first |

## Stack Patterns by Variant

**If building the retained legacy package:**

- Keep it as a separate Bazel package under `packages/legacy-slic3r`
- Wrap the existing Perl/C++ build and tests without rewriting the internals
- Treat it as the parity oracle, not the innovation surface

**If building the Rust package:**

- Use a Cargo workspace rooted inside `packages/rust-slic3r`
- Keep package-local `Cargo.toml`, `Cargo.lock`, `src/lib.rs`, `src/main.rs`, and `tests/` conventions
- Expose Bazel targets for the same crates so the repo can build the package through Bazel and inspect it through Cargo

**If building parity tooling:**

- Use a dedicated Rust CLI or Bazel `sh_test` target that runs legacy and Rust implementations over the same fixture corpus
- Prefer fixture-based diffs for observable outputs such as CLI text, config dumps, rendered meshes, and generated G-code
- Keep the parity command simple enough to print a status summary early, then grow it into a comparison harness over time

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| Bazel 9.0 LTS | Bzlmod-based dependencies | Bazel 9 is the right monorepo baseline for this migration. Validate any Rust rule set against it early. |
| `rules_rust` latest release | Bazel 9 + Rust stable | The official docs support Bzlmod, but note that the Bzlmod path is still described as work in progress. Pin and test carefully. |
| Rust stable 1.94.0 | Rust 2024 edition | Use the stable channel for the port; reserve nightly for exceptional compiler-feature experiments. |
| macOS CLT / Xcode | Bazel + Rust native builds on macOS | Required for the macOS-first validation path and native linking. |

______________________________________________________________________

*Stack analysis: 2026-04-06*
