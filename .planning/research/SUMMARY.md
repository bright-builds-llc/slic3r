# Project Research Summary

**Project:** Slic3r Rust Port
**Domain:** Brownfield desktop 3D slicer migration
**Researched:** 2026-04-06
**Confidence:** MEDIUM

## Executive Summary

This is a legacy desktop 3D-slicer modernization program, not a greenfield rewrite. The research points to a Bazel-driven monorepo with explicit package boundaries as the right top-level shape, because the repository needs to keep the legacy implementation buildable as a parity oracle while the new Rust implementation grows beside it. The migration should be macOS-first, GUI-later, and contract-first: preserve exported behavior, then replace implementation detail behind stable CLI/config/output surfaces.

The main recommendation is to separate concerns early. Keep the legacy code isolated as a retained reference package, make Rust the new implementation target, and add a parity harness plus a simple status command as soon as the first Rust surfaces exist. The biggest risks are parity drift, non-hermetic Bazel integration, launcher sprawl, fixture decay, and documentation drift. The roadmap should therefore start with build/package structure and contract inventory, then move to Rust core/CLI replacement, then expand parity comparison and only later broaden platforms or GUI work.

## Key Findings

### Recommended Stack

The stack research favors Bazel 9 with Bzlmod at the repository root, Bazelisk for contributor ergonomics, and Rust stable 1.94.0 with the 2024 edition inside a Cargo workspace under `packages/`. `rules_rust` is the correct Bazel bridge for the Rust targets, while `rustfmt`, `clippy`, and `cargo test` remain the inner Rust-quality tools. On macOS, the native toolchain should rely on Xcode command line tools. For parity comparisons, use a dedicated Rust CLI or Bazel test target plus fixture-diff helpers such as `cmp` and `diff`.

**Core technologies:**

- Bazel 9.0 LTS: top-level monorepo build/test orchestration and package boundary owner
- Rust stable 1.94.0: new implementation language for the port
- Bazelisk: contributor-friendly Bazel pinning and launch wrapper
- `rules_rust`: Bazel integration for Rust binaries, libraries, tests, `rustfmt`, and `clippy`

### Expected Features

The migration program itself has a small set of table-stakes capabilities: the legacy package must remain buildable and testable, the Rust package must live beside it, Bazel must become the canonical entrypoint, macOS must be the first validated platform, and the existing contracts and file formats must be preserved. Research also suggests two differentiators that make the port trustworthy rather than merely rewritten: a parity status command and a differential legacy-vs-Rust harness.

**Must have (table stakes):**

- Legacy package stays buildable and testable — parity oracle and reference implementation
- Rust package exists beside the legacy package — actual new implementation target
- Bazel becomes the top-level build/test entrypoint — one reproducible repo-wide surface
- macOS-first CLI/core parity path — the highest-value initial platform
- Preserved exported contracts and file formats — parity only matters if users see the same behavior
- Fixture corpus for legacy-vs-Rust comparison — regression-proofing requires shared cases

**Should have (competitive):**

- Parity status command — makes migration progress visible
- Dual-run legacy/Rust comparison harness — turns the legacy code into an executable oracle
- Bazel-native package boundaries — keeps the migration readable for contributors
- Documented shell/Rust replacement for the Perl launcher — removes launcher complexity without losing behavior

**Defer (v2+):**

- Linux and Windows parity for the new Rust implementation — defer until macOS proves the strategy
- Full GUI rewrite in Rust — too much surface area for the first milestone
- Automated docs/checklist enforcement — required by process first, automation later
- Deleting the legacy package entirely — only after parity is proven

### Architecture Approach

The recommended architecture is a strangler-style migration with explicit boundaries: `packages/legacy-slic3r` remains a buildable oracle, `packages/slic3r-rust` holds the new Rust workspace, `packages/parity` and `packages/parity-fixtures` own comparison logic and corpus data, and `packages/launcher` stays thin while Perl is retired. `docs/port/` should track parity matrices, migration notes, and checklists as first-class artifacts so progress is visible even before enforcement becomes automated.

**Major components:**

1. Bazel root — owns the build graph, targets, and top-level orchestration
1. Legacy reference package — preserves current behavior with minimal change
1. Rust migration workspace — hosts contract/core/CLI/parity crates
1. Parity harness and fixtures — compares legacy and Rust outputs on the same corpus
1. Thin launcher layer and docs — keep entrypoints understandable and migration state visible

### Critical Pitfalls

The highest-risk failures are predictable. A “clean rewrite” can drift from the legacy CLI, config, and outputs without anyone noticing. Bazel can become a wrapper around old host-specific scripts instead of a real hermetic build. The Perl launcher can be replaced by a second legacy system made of shell glue. Fixture corpora can stagnate, docs can drift into theater, and platform scope can expand too early.

1. **Parity drift from a clean rewrite** — keep the legacy oracle buildable and compare both implementations on a real fixture corpus
1. **Non-hermetic Bazel migration** — use pinned toolchains, Bzlmod, and explicit package ownership instead of host probing
1. **Launcher becomes a second legacy system** — keep launchers thin and move behavior into Rust or Bazel-owned entrypoints
1. **Fixture and corpus erosion** — version the corpus and require deliberate updates
1. **Documentation theater** — keep `docs/` and checklists tied to Rust changes by process
1. **Platform scope creep** — keep macOS first and stage Linux/Windows later

## Implications for Roadmap

Based on research, the roadmap should begin with repository shape and contract inventory, not feature rewriting. The first phase should establish Bazel as the top-level orchestrator, isolate the legacy package, define the migration docs/checklists, and seed the parity corpus/status surface. The second phase should introduce the Rust contract/core/CLI path and the thin launcher replacement strategy on macOS. The third phase should harden parity with comparison runs and broaden the corpus. Only after those pieces are trustworthy should the roadmap expand to GUI planning or other platforms.

### Phase 1: Monorepo Foundation

**Rationale:** The repo needs a stable build shape and a clear oracle before implementation can move safely.

**Delivers:** Bazel root, `packages/` layout, legacy package isolation, migration docs/checklists, and an initial parity status command.

**Addresses:** legacy package stays buildable, Bazel as top-level entrypoint, docs/checklist discipline, fixture corpus bootstrap.

**Avoids:** non-hermetic Bazel setup, documentation theater, and early parity drift.

### Phase 2: Rust Core and CLI

**Rationale:** Once the repository shape is stable, the highest-value contract surface is the CLI/core path on macOS.

**Delivers:** Rust contracts/core/CLI crates, a macOS-first entrypoint strategy, and replacement of the Perl launcher path with thin Rust/Bazel/shell glue.

**Uses:** Rust stable, Cargo workspace, `rules_rust`, macOS CLT/Xcode, and the retained legacy oracle.

**Implements:** contract-first Rust migration workspace and thin launcher layer.

### Phase 3: Parity Harness

**Rationale:** The port needs evidence, not optimism, so behavior comparison must become routine after the first Rust surfaces exist.

**Delivers:** fixture-based comparison runs, clearer status reporting, and growth of the legacy-vs-Rust corpus.

**Uses:** fixture corpus, diff tooling, parity CLI or Bazel test targets.

**Implements:** differential parity harness and corpus management.

### Phase 4: Expansion

**Rationale:** Linux/Windows and GUI work should come after the macOS core proves the migration strategy.

**Delivers:** staged platform expansion, GUI planning, and later enforcement around docs/checklists if the process needs it.

**Uses:** the stabilized Rust workspace, Bazel package boundaries, and the established parity corpus.

**Implements:** platform-specific targets and deferred surfaces.

### Phase Ordering Rationale

- Build shape and oracle first, because parity is impossible to trust without a stable legacy reference.
- Rust core and CLI before GUI, because the CLI/core path is the smallest testable slice of the product.
- Parity harness before broad expansion, because hidden drift is the main migration risk.
- macOS before Linux/Windows, because the current development environment and validation path are already macOS-centered.

### Research Flags

Phases likely needing deeper research during planning:

- **Phase 1:** Bazel module/toolchain details and how to wrap the legacy build without making Bazel non-hermetic
- **Phase 2:** CLI contract mapping and launcher replacement strategy for preserving exported behavior
- **Phase 3:** Fixture corpus design and output normalization rules for fair comparisons

Phases with standard patterns (skip research-phase):

- **Phase 4:** Platform expansion and GUI planning can follow established migration patterns once the core is stable

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM | Bazel/Rust choices are well-supported, but exact versions and rule pinning still need implementation validation |
| Features | HIGH | The migration-program feature set follows directly from the project brief and current codebase state |
| Architecture | MEDIUM | The package boundaries are practical and consistent with the research, but exact repo layout still needs implementation work |
| Pitfalls | HIGH | The failure modes are strongly evidenced by the legacy codebase shape and the migration requirements |

**Overall confidence:** MEDIUM

### Gaps to Address

- Exact Bazel rule set and pinning strategy: confirm during implementation and lock it in early
- Concrete fixture corpus selection: choose representative jobs/models before parity work starts
- Launcher replacement contract: define what shell/Bazel shims remain versus what Rust owns

## Sources

### Primary (HIGH confidence)

- `.planning/PROJECT.md` — project goals, constraints, and phase direction
- `.planning/codebase/ARCHITECTURE.md` — current architecture and migration boundaries
- `.planning/codebase/STACK.md` — current and recommended toolchain shape
- `.planning/codebase/CONCERNS.md` — legacy debt, risks, and fragile areas
- `.planning/codebase/INTEGRATIONS.md` — external services and build dependencies

### Secondary (MEDIUM confidence)

- Bazel concepts and Bzlmod guidance referenced in the stack/architecture research
- Rust Cargo and workspace layout guidance referenced in the stack/architecture research

______________________________________________________________________

*Research completed: 2026-04-06*
*Ready for roadmap: yes*
