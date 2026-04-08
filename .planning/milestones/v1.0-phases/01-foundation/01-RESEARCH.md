# Phase 01: Foundation - Research

**Researched:** 2026-04-06
**Domain:** Bazel-driven brownfield monorepo foundation for a legacy desktop slicer migration
**Confidence:** MEDIUM

## User Constraints

### Locked Decisions

- The initial `packages/` set is exactly: `packages/legacy-slic3r`, `packages/slic3r-rust`, `packages/launcher`, `packages/parity`, and `packages/parity-fixtures`.
- Shared repo-level assets stay at the root: Bazel root files, `docs/`, `tools/`, and normal repo metadata should not be turned into packages.
- The Rust side starts as one top-level package, `packages/slic3r-rust`, with an internal Cargo workspace rather than multiple top-level Rust packages in Phase 1.
- The legacy source tree should move mostly as-is into `packages/legacy-slic3r/` during Phase 1 rather than being cleaned up or reshaped.
- The retained legacy implementation should be named exactly `packages/legacy-slic3r` and consistently described as the legacy reference package.
- Phase 1 should add a package-local README and a top-level migration note that clearly state the legacy package is the retained behavioral oracle and that new feature work targets the Rust implementation unless explicitly noted.
- Legacy code may only receive minimal relocation or integration changes needed to keep it buildable under Bazel, and those changes should be documented as parity-preserving.
- The legacy package should remain visible in the repo tree and fenced by naming and docs, not hidden or treated like dead code.
- Phase 1 should establish a small but real top-level Bazel surface: `bazel build //...`, `bazel test //...`, and a small set of named package targets that make the monorepo structure discoverable.
- Bazelisk plus `.bazelversion` should be the default contributor path on macOS.
- The repo should document explicit preferred top-level targets for legacy build/test, Rust sanity checks, a launcher placeholder, and a parity placeholder or status target, even if some are thin wrappers at first.
- Phase 1 should not attempt to wrap every legacy script perfectly; it should establish the canonical Bazel interface and enough working targets to anchor later phases.
- `docs/port/` should start with exactly four files: `README.md`, `checklist.md`, `parity-matrix.md`, and `package-map.md`.
- The checklist should be organized by migration surface, not by generic tasks. The expected surfaces are Bazel root, legacy package, Rust workspace, launcher, parity tooling, and docs.
- The parity matrix should explicitly track contract surfaces such as CLI behavior, config semantics, file formats, generated outputs, launcher path, and packaging-visible behavior.
- The default parity-matrix statuses are `legacy-only`, `in progress`, `rust-backed`, and `verified`.
- The review expectation for Phase 1 is that any Rust-port or parity-surface change updates the relevant `docs/port/` files in the same change, but there is no automated enforcement yet.

### Claude's Discretion

- Exact Bazel target names and how they are grouped across root and package-level `BUILD` files
- Exact formatting, wording, and visual structure of the `docs/port/` pages and checklists
- Exact internal crate names and folder decomposition inside `packages/slic3r-rust`, as long as the one-package-with-internal-workspace decision is preserved

### Deferred Ideas (OUT OF SCOPE)

- None — discussion stayed within phase scope

## Summary

Phase 1 should optimize for a trustworthy migration scaffold, not for maximal Bazel coverage. The official Bazel guidance strongly favors `MODULE.bazel` and Bzlmod as the modern dependency model, and the migration guide explicitly supports hybrid transition patterns for gradual adoption. That fits this repo well: the retained legacy package can be wrapped and exposed through a small canonical Bazel surface without pretending every historical script is already a first-class Bazel citizen.

The strongest phase-1 recommendation is to treat the repository root as orchestration-only and push ownership downward. The root should own `MODULE.bazel`, `.bazelversion`, high-signal top-level targets, and repo-wide docs/process. Each package should own its own local shape: legacy remains mostly untouched in `packages/legacy-slic3r`, Rust starts in `packages/slic3r-rust` as a Cargo workspace, and `docs/port/` becomes the migration control plane. That keeps the first phase concrete enough to plan while avoiding premature complexity like full legacy-script wrapping, platform expansion, or launcher behavior replacement.

**Primary recommendation:** Start Phase 1 with Bazelisk + a pinned Bazel version, a Bzlmod-first root, the locked `packages/` skeleton, and a docs-first migration surface; treat perfect legacy build encapsulation as follow-on work in Phase 2, not a blocking requirement for the foundation phase.

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|---|---|---|---|
| Bazel | 8.0 LTS | Top-level build/test orchestrator for the new monorepo shape | Bazel 8 is the current official LTS line, and the official release notes make Bzlmod the default dependency model with legacy `WORKSPACE` disabled by default. That makes it the safest foundation baseline for a gradual brownfield migration. |
| Bazelisk | latest | Contributor-facing Bazel launcher and version pinning | The official Bazelisk README recommends checking in a `.bazelversion` file so the repo can control the Bazel version and make upgrades atomic. That fits the user’s desired macOS contributor path. |
| `MODULE.bazel` + Bzlmod | Bazel 8-era model | Root dependency and toolchain configuration | The official migration guide says Bzlmod replaces the legacy `WORKSPACE` system and is required for Bazel 9. Starting here avoids foundational churn later. |
| Cargo virtual workspace | Rust 2024 edition | Internal organization for `packages/slic3r-rust` | The Cargo Book recommends a virtual workspace when there is no single primary package and multiple crates are organized under one root, which matches the locked Phase 1 Rust-package decision. |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|---|---|---|---|
| `rules_rust` | 0.69.0 | Bazel integration for Rust binaries, libraries, tests, `rustfmt`, and `clippy` | Use when Phase 3 stands up the Rust workspace under Bazel. The official `rules_rust` repo is active and its latest release is 0.69.0 as of 2026-02-26. |
| `rules_cc` | Bazel 8-era external rules | C/C++ rules and toolchain migration support | Use when wrapping or building retained legacy native components under Bazel. Bazel 8 release notes call out C++ toolchain migration toward `rules_cc`. |
| `rules_shell` | Bazel 8-era external rules | Thin shell-script targets and wrappers | Use for the launcher placeholder and any shell-based glue that Phase 1 needs without embedding real behavior in scripts. |
| Xcode Command Line Tools | current macOS toolchain | Native compiler/SDK baseline on macOS | Use because the project is explicitly macOS-first and Bazel/native toolchain work will sit on top of the local Apple toolchain. |
| `mdformat` | existing repo-local tool | Markdown formatting for migration docs | Use because Phase 1 explicitly introduces `docs/port/`, and `mdformat` is already available in this repo’s working environment. |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|---|---|---|
| Bazel 8.0 LTS | Bazel 9.x immediately | Bazel 9 is the future destination, but Phase 1 is safer on the official LTS while legacy-wrapping patterns are still being established. |
| Bzlmod-first root | `WORKSPACE`-first or custom repository wrappers | The official migration guide treats Bzlmod as the required long-term path; starting anywhere else creates avoidable rework. |
| One `packages/slic3r-rust` Cargo workspace | Multiple top-level Rust packages from day one | Multiple top-level Rust packages may become appropriate later, but they complicate the foundation phase without improving the locked package skeleton. |

**Installation:**

```bash
brew install bazelisk
xcode-select --install

# repo-pinned Bazel version lives in .bazelversion
# Rust workspace foundation comes later, but Phase 1 should reserve the shape
```

## Architecture Patterns

### Recommended Project Structure

```text
MODULE.bazel
.bazelversion
docs/
  port/
    README.md
    checklist.md
    parity-matrix.md
    package-map.md
packages/
  legacy-slic3r/
  slic3r-rust/
    Cargo.toml
    crates/
  launcher/
  parity/
  parity-fixtures/
tools/
```

### Pattern 1: Thin Root, Strong Packages

**What:** Keep the repository root responsible for orchestration, shared docs, and Bazel version/toolchain wiring; keep package-specific ownership inside `packages/`.
**When to use:** Immediately in Phase 1 when creating the monorepo skeleton.
**Example:**

```bzl
# Source: https://bazel.build/external/migration
module(
    name = "slic3r",
    repo_name = "slic3r",
)
```

### Pattern 2: Strangler Package Boundary

**What:** Preserve the legacy code as a visible reference package while creating a separate Rust package that will eventually replace active behavior slice by slice.
**When to use:** For any brownfield migration where the old implementation remains the parity oracle.
**Example:**

```text
packages/
  legacy-slic3r/   # retained oracle, minimal integration-only changes
  slic3r-rust/     # new implementation target
```

### Pattern 3: Docs as Migration Control Plane

**What:** Treat `docs/port/` as a first-class, review-visible surface that tracks package roles, parity state, and migration progress.
**When to use:** In Phase 1, before there is enough executable Rust to make parity visible in code alone.
**Example:**

```text
docs/port/
  README.md         # source-of-truth overview
  checklist.md      # migration-surface checklist
  parity-matrix.md  # contract-by-contract status
  package-map.md    # intended role of each package
```

### Anti-Patterns to Avoid

- **Wrapper-all-the-things foundation:** trying to make every historical build script Bazel-perfect in Phase 1 instead of establishing a stable top-level interface first
- **Legacy cleanup during relocation:** reshaping the legacy tree while moving it, which risks parity drift before the oracle boundary is established
- **Root-level sprawl:** leaving package roles implicit so contributors cannot tell where new Rust, legacy, launcher, parity, and docs responsibilities actually live

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| Bazel version management | A custom shell wrapper that downloads and selects Bazel versions | Bazelisk + `.bazelversion` | Officially supported workflow, simpler contributor path, easier upgrades |
| Dependency root migration | A custom hybrid dependency system at the root | `MODULE.bazel` + Bzlmod, with `WORKSPACE.bzlmod` only if a temporary hybrid bridge is truly needed | The official Bazel migration guide already defines the supported gradual-migration path |
| Rust package graph metadata | Ad hoc shell-discovered crate relationships | Cargo virtual workspace metadata in `packages/slic3r-rust/Cargo.toml` | Cargo already provides workspace membership, shared lockfile, shared output dir, and inherited metadata |
| Migration progress tracking | An opaque status file hidden in tools or comments | `docs/port/checklist.md` + `docs/port/parity-matrix.md` | Reviewers and contributors need visible, human-readable state during the port |

**Key insight:** Phase 1 should not invent infrastructure where official Bazel and Cargo primitives already define the shape. The valuable custom work is in package boundaries and migration documentation, not in replacing Bazelisk, Bzlmod, or Cargo workspace semantics.

## Common Pitfalls

### Pitfall 1: Picking the Future Bazel Destination Instead of the Safest Foundation Baseline

**What goes wrong:** The phase optimizes for “latest Bazel” instead of “least risky foundation for a brownfield migration,” and the repo burns time on version churn before the package boundaries settle.

**Why it happens:** Teams conflate eventual target state with first stable foundation.

**How to avoid:** Use the current official LTS line for the foundation work, but structure `MODULE.bazel` and package boundaries so upgrading later is deliberate rather than architectural.

**Warning signs:** Most phase effort goes into Bazel version breakage instead of package layout, docs, and discoverable targets.

### Pitfall 2: Reorganizing the Legacy Tree and Its Behavior at the Same Time

**What goes wrong:** The repo moves the legacy source and “fixes” it during relocation, making it unclear whether behavior changes came from the move or from accidental edits.

**Why it happens:** Cleanup work feels cheap while files are already moving.

**How to avoid:** Keep relocation and behavior change separate. In Phase 1, legacy changes should be relocation or Bazel integration only, with explicit parity-preserving notes.

**Warning signs:** Contributors cannot explain whether a legacy diff is structural or behavioral.

### Pitfall 3: Treating Docs as a Postscript

**What goes wrong:** The package skeleton lands, but the docs lag behind, so contributors immediately lose the package-role and parity-state context the phase was supposed to create.

**Why it happens:** Docs are seen as “after the code.”

**How to avoid:** Plan docs as co-equal outputs of the phase, not polish. `docs/port/` should exist and be useful before deeper implementation starts.

**Warning signs:** Reviewers ask where the source of truth is for package roles or parity status right after the phase lands.

## Code Examples

### Root Bzlmod module

```bzl
# Source: https://bazel.build/external/migration
module(
    name = "slic3r",
    repo_name = "slic3r",
)
```

### Cargo virtual workspace skeleton

```toml
# Source: https://doc.rust-lang.org/cargo/reference/workspaces.html
[workspace]
members = ["crates/*"]
resolver = "3"
```

### Bazelisk repo pin

```text
# Source: https://github.com/bazelbuild/bazelisk
.bazelversion
8.0.0
```

## State of the Art (2024-2026)

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| `WORKSPACE` as default dependency root | Bzlmod / `MODULE.bazel` as the modern dependency system | Bazel 7 defaulted Bzlmod on; Bazel 8 disabled `WORKSPACE` by default | New monorepo foundations should start from Bzlmod, not from legacy root macros |
| Treating Bazel version as a machine-local concern | Pinning through Bazelisk + `.bazelversion` | Current Bazelisk guidance | Makes contributor onboarding and upgrades deterministic |
| Flat Rust crate sprawl | Virtual Cargo workspaces with shared lockfile and metadata | Current Cargo Book guidance | Supports the locked “one top-level Rust package, internal workspace” decision cleanly |
| Root-owned giant migration notes | Focused `docs/port/` surfaces | Best practice for long-lived migrations | Makes review and contributor onboarding tractable |

**New tools and patterns to consider later:**

- `WORKSPACE.bzlmod` as a temporary bridge only if specific legacy dependency definitions truly block the foundation work
- `workspace.package`, `workspace.dependencies`, and `workspace.lints` once the Rust package is active in later phases

**Deprecated or outdated for this phase:**

- Starting a new Bazel root from `WORKSPACE`
- Treating the Perl launcher as part of the foundation package shape rather than a later entrypoint-replacement concern

## Open Questions

1. **Should Phase 1 pin Bazel 8 LTS explicitly, or is there already a repo-wide reason to jump to Bazel 9 immediately?**

   - What we know: The official Bazel docs make Bzlmod mandatory in Bazel 9, but Bazel 8 is the current official LTS line and already has `WORKSPACE` off by default.
   - What's unclear: Whether the migration team values latest-version alignment more than lower-risk phase-1 stabilization.
   - Recommendation: Plan Phase 1 around Bazel 8 LTS unless an external repo policy requires Bazel 9 now.

1. **How much of the retained legacy tree can be wrapped through Bazel without introducing non-hermetic host assumptions?**

   - What we know: The repo has legacy Perl/C++/packaging scripts, and the user explicitly does not want Phase 1 to wrap every script perfectly.
   - What's unclear: Which minimum legacy build/test surfaces are the right first-class Phase 1 targets.
   - Recommendation: The planner should keep Phase 1 focused on a small canonical surface and leave full legacy wrapping to Phase 2.

1. **Which top-level named Bazel targets should be considered canonical on day one?**

   - What we know: The user wants explicit named targets for legacy build/test, Rust sanity, launcher placeholder, and parity placeholder/status.
   - What's unclear: The exact naming scheme and grouping.
   - Recommendation: Leave naming to planner discretion, but require the plan to choose and document a stable minimal target set.

## Sources

### Primary (HIGH confidence)

- Bazel Bzlmod Migration Guide: https://bazel.build/external/migration
- Bazel 8.0 LTS release notes: https://blog.bazel.build/2024/12/09/bazel-8-release.html
- Bazelisk README: https://github.com/bazelbuild/bazelisk
- Cargo Book, Workspaces: https://doc.rust-lang.org/cargo/reference/workspaces.html
- `rules_rust` repository and releases: https://github.com/bazelbuild/rules_rust

### Secondary (MEDIUM confidence)

- Local project context from `.planning/phases/01-foundation/01-CONTEXT.md`
- Local migration framing from `.planning/PROJECT.md`, `.planning/ROADMAP.md`, and `.planning/REQUIREMENTS.md`

______________________________________________________________________

*Phase research completed: 2026-04-06*
