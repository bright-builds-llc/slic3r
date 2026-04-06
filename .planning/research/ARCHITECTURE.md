# Architecture Research

**Domain:** Brownfield desktop 3D slicer migration
**Researched:** 2026-04-06
**Confidence:** MEDIUM

## Standard Architecture

### System Overview

```
┌──────────────────────────────────────────────────────────────┐
│ Bazel root                                                   │
│ `MODULE.bazel` + top-level BUILD files + repo-wide toolchain │
├───────────────────────┬───────────────────────┬──────────────┤
│ Legacy reference      │ Rust migration        │ Validation    │
│ `packages/legacy-...` │ `packages/slic3r-rust`│ `packages/...`│
├───────────────────────┴───────────────────────┴──────────────┤
│ Launchers + docs                                              │
│ `packages/launcher` + `docs/port/`                            │
└──────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Bazel root | Own the build graph and the top-level entrypoints for build, test, and parity | `MODULE.bazel`, repo-wide `BUILD.bazel`, `rules_rust`, `rules_cc` |
| Legacy reference package | Preserve the current behavior as a buildable oracle with minimal surface changes | Mostly untouched legacy tree under `packages/legacy-slic3r/` with Bazel wrappers around existing build/test flows |
| Rust migration workspace | Host the new implementation in a dependency-clean workspace with a shared lockfile | A Cargo workspace under `packages/slic3r-rust/` containing `core`, `contracts`, `cli`, and `parity` crates |
| Parity harness | Compare legacy and Rust behavior against the same corpus and report status | A Rust binary or Bazel test target under `packages/parity/` that runs fixtures and emits a summary |
| Launcher layer | Provide a thin user-facing entrypoint while Perl is retired | Small shell scripts or Bazel `run` targets in `packages/launcher/` |
| Docs and checklists | Track migration progress and parity coverage as first-class project artifacts | `docs/port/` Markdown files, parity matrices, and checklists updated alongside Rust changes |

## Recommended Project Structure

```
MODULE.bazel
docs/
  port/
    checklist.md
    parity-matrix.md
    migration-notes.md
packages/
  legacy-slic3r/
    BUILD.bazel
    ...legacy source tree...
  slic3r-rust/
    Cargo.toml
    crates/
      contracts/
      core/
      cli/
      parity/
  launcher/
    BUILD.bazel
    bin/
      slic3r
  parity-fixtures/
    BUILD.bazel
    corpus/
tools/
  bazel/
    macros/
```

### Structure Rationale

- `packages/legacy-slic3r/`: isolates the reference implementation so it can stay stable, buildable, and easy to compare against without becoming a moving target.
- `packages/slic3r-rust/`: keeps the Rust work in a single workspace so shared dependencies, one `Cargo.lock`, and crate-level ownership stay aligned.
- `packages/parity/` and `packages/parity-fixtures/`: separate comparison logic from fixture data so the corpus can grow without entangling the harness.
- `packages/launcher/`: keeps user-facing invocation logic thin and easy to replace once Rust CLI paths are mature.
- `docs/port/`: keeps migration state visible without forcing it into build logic or code packages.

## Architectural Patterns

### Pattern 1: Strangler Fig Migration

**What:** Keep the legacy implementation buildable as the reference while new Rust code gradually replaces active surfaces.
**When to use:** Any feature, API, or output path that still needs parity validation.
**Trade-offs:** Dual maintenance is real, but it lets the team replace behavior with evidence instead of guessing.

**Example:**

```text
bazel test //packages/parity:compare
  -> run legacy reference binary
  -> run Rust implementation
  -> compare outputs and report drift
```

### Pattern 2: Contract-First Core

**What:** Put exported config, file, and output contracts into explicit Rust crates instead of letting them leak through CLI code.
**When to use:** Any serialized format, CLI argument schema, or output file format that must remain stable.
**Trade-offs:** More up-front modeling, but less drift between the CLI, the core, and the parity harness.

**Example:**

```rust
// `packages/slic3r-rust/crates/contracts/src/lib.rs`
pub struct PrintJobSpec { /* stable contract fields */ }
```

### Pattern 3: Differential Parity Harness

**What:** Exercise both implementations with the same fixtures and compare behavior at the file/output boundary.
**When to use:** Replacing CLI commands, export logic, packaging-visible behavior, and any output that can be reduced to a golden corpus.
**Trade-offs:** Slower than a single implementation test, but it is the most direct proof of parity.

## Data Flow

### Request Flow

```
User action
    ↓
Thin launcher or Bazel target
    ↓
Rust CLI (`packages/slic3r-rust/crates/cli`)
    ↓
Rust core + contract crates
    ↓
Output files / logs / status
```

### State Management

```
Fixture corpus + golden outputs
    ↓
Parity harness
    ↓
Compare legacy vs Rust
    ↓
Status summary in stdout + docs/port checklist updates
```

### Key Data Flows

1. Legacy oracle flow: Bazel builds and runs `packages/legacy-slic3r/`, producing reference outputs that remain the comparison baseline.
1. Rust implementation flow: Rust crates parse configs, load geometry, run slicing/export logic, and emit the new implementation outputs.
1. Parity flow: The same fixture corpus is run through both implementations, and the harness records pass/fail/diff summaries.
1. Documentation flow: Migration notes, parity matrices, and checklists in `docs/port/` are updated when behavior moves or parity changes.

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| 1 migrated surface | One Rust workspace, one legacy package, one parity target, and a small launcher shim |
| Several migrated surfaces | Split Rust into more crates, add shared contract types, and expand fixture coverage by feature area |
| Full parity across CLI and packaging surfaces | Add platform-specific Bazel targets, stronger release packaging, and a stable parity dashboard or report artifact |

### Scaling Priorities

1. First bottleneck: contract drift between legacy and Rust. Fix it with shared contract crates, fixtures, and differential tests.
1. Second bottleneck: Bazel/package boundary sprawl. Fix it by keeping one package per major responsibility and avoiding mixed ownership trees.

## Anti-Patterns

### Anti-Pattern 1: Letting Rust depend on legacy internals

**What people do:** Call into the legacy implementation from production Rust code just to move faster.
**Why it's wrong:** It keeps the new implementation coupled to the old runtime and hides real parity gaps.
**Do this instead:** Keep the legacy package as an oracle only, and let the parity harness be the only code that runs both sides.

### Anti-Pattern 2: Bazel as a thin wrapper over ad hoc scripts

**What people do:** Use Bazel only to shell out to a pile of opaque scripts with no clear target graph.
**Why it's wrong:** The repo loses determinism, visibility, and package ownership.
**Do this instead:** Model major subprojects as Bazel packages and keep scripts tiny and explicit.

### Anti-Pattern 3: Porting behavior without fixtures

**What people do:** Rewrite code from the legacy implementation by inspection and trust manual testing.
**Why it's wrong:** Parity drift shows up late and is hard to diagnose.
**Do this instead:** Add a corpus and compare outputs at the boundary for every migrated surface.

### Anti-Pattern 4: Rewriting the GUI first

**What people do:** Spend the first milestone on the most visible surface instead of the most testable one.
**Why it's wrong:** It delays confidence in the core contracts that the GUI depends on.
**Do this instead:** Defer GUI work until the core, CLI, and parity harness are credible.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Bazel Central Registry | Bzlmod module resolution | Use `MODULE.bazel` as the repo boundary and keep the dependency graph explicit |
| `rules_rust` releases | Bazel Rust toolchain + crate integration | The official docs recommend the latest release; the docs also note Bzlmod support is still maturing, so pin and verify the exact release at implementation time |
| crates.io | Cargo workspace dependencies | Rust crates should share a workspace-level lockfile and be selected by package or workspace rather than ad hoc paths |
| GitHub | Source hosting and release metadata for the migration repo | Build-time and planning-time only, not a product runtime dependency |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| `packages/legacy-slic3r/` ↔ `packages/parity/` | File fixtures, process exit codes, and diffed artifacts | No production code sharing; the legacy package stays the oracle |
| `packages/slic3r-rust/crates/contracts` ↔ `core`/`cli`/`parity` | Shared Rust types and serializers | Keeps exported contracts centralized and testable |
| `packages/slic3r-rust/crates/core` ↔ `cli` | Library API | CLI stays thin and delegates to the core |
| `docs/port/` ↔ the Rust migration packages | Human-maintained checklists and parity notes | These are process artifacts, but they should stay close to the code they describe |
| `packages/launcher/` ↔ all user entrypoints | Shell or Bazel-run dispatch | Keep this layer small and deterministic |

## Sources

- Internal map: `.planning/codebase/ARCHITECTURE.md`
- Internal map: `.planning/codebase/STACK.md`
- Internal map: `.planning/codebase/CONCERNS.md`
- Internal map: `.planning/codebase/INTEGRATIONS.md`
- Bazel concepts: https://bazel.build/concepts/build-ref
- Bazel external dependencies and Bzlmod: https://bazel.build/external/overview
- rules_rust introduction: https://bazelbuild.github.io/rules_rust/index.html
- Cargo introduction and guide: https://doc.rust-lang.org/stable/cargo/ and https://doc.rust-lang.org/cargo/guide/
- Cargo package layout: https://doc.rust-lang.org/cargo/guide/project-layout.html
- Cargo workspaces: https://doc.rust-lang.org/beta/book/ch14-03-cargo-workspaces.html

______________________________________________________________________

*Architecture research for: brownfield desktop 3D slicer migration*
*Researched: 2026-04-06*
