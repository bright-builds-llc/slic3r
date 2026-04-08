# Phase 02: Legacy Oracle - Research

**Researched:** 2026-04-07
**Domain:** Bazel-wrapped legacy oracle build and test surfaces for a brownfield Perl/C++ desktop slicer on macOS
**Confidence:** MEDIUM

## User Constraints

### Locked Decisions

- Phase 2 should prioritize the legacy CLI and native oracle build path on macOS, not the legacy GUI build.
- Release packaging outputs such as `.dmg`, installers, and archive production are out of scope for this phase.
- If a legacy build path still depends on existing scripts or manual bootstrap behavior, Bazel may invoke that path and document the caveats rather than replacing it with a clean Bazel-native implementation now.
- Success for this phase is producing the retained legacy executable or artifacts needed for reference use on macOS, not matching the historical packaging layout exactly.
- Phase 2 should elevate the most reliable and meaningful legacy macOS test and smoke surfaces as the first-class oracle set, even if some older paths are deferred.
- A lightweight oracle smoke test is acceptable in this phase if deeper legacy suites are not yet Bazel-friendly, as long as the gap is documented explicitly.
- When Perl-era tests and native tests differ in usefulness or reliability, the planner should prioritize the tests that best preserve the behavioral oracle on macOS rather than preserving historical symmetry.
- Phase 2 should explicitly document which legacy tests are part of the trusted oracle set versus which are retained only for historical or reference reasons.
- Phase 2 should prefer documented wrapper fidelity over trying to eliminate every awkward legacy bootstrap step immediately.
- Non-hermetic or host-specific legacy dependencies are acceptable in this phase if they are treated as explicit debt and recorded clearly.
- If a legacy dependency path is too brittle to automate cleanly in Phase 2, the acceptable outcome is a Bazel target plus documented manual prerequisites, not a hidden dependency-modernization project.
- Phase 2 should produce a clear record of what the legacy oracle path assumes is already present on macOS.
- The legacy package remains reference-only; build and test enablement does not reopen it as a normal feature-development surface.
- If Bazel wrapping requires small legacy edits, they must remain minimal, parity-preserving integration changes only.
- Phase 2 docs should state that Bazel support for the legacy package exists to preserve the oracle, not because the long-term target is continued investment in the legacy implementation.
- If contributors find tempting legacy cleanup opportunities, those should be captured as deferred notes rather than folded into this phase.

### Claude's Discretion

- Exact names and grouping of Bazel targets that expose the legacy build and test surfaces
- Which specific legacy test and smoke commands form the first trusted oracle set, as long as the selection is documented and justified
- Exact wording and structure for the oracle caveat documentation and prerequisite notes

### Deferred Ideas (OUT OF SCOPE)

- Legacy GUI build support — future phase
- Legacy release packaging outputs under Bazel — future phase
- Legacy dependency cleanup or full hermetic bootstrap redesign — future phase
- Linux and Windows legacy-oracle support under Bazel — future phase

## Summary

Phase 2 should wrap the legacy reality honestly rather than re-implementing it. In this repository, the strongest existing legacy entrypoint is `packages/legacy-slic3r/Build.PL`: it bootstraps Perl dependencies through `cpanm`, rebuilds the XS layer in `packages/legacy-slic3r/xs`, and runs the Perl test surface through `App::Prove`. That makes it the most direct oracle-oriented build-and-test path for the retained package, even though it is non-hermetic and network-sensitive.

The newer `packages/legacy-slic3r/src/CMakeLists.txt` tree is also useful, but it should be treated as a secondary native oracle surface in this phase, not the only one. It is valuable for the native CLI and Catch2-based tests, but it brings in more toolchain variables, and the GUI path is explicitly out of scope. The planning implication is to create a small set of Bazel wrapper targets that expose: a legacy build target, a trusted oracle test target or suite, and one or more smoke tests that verify the retained package is callable on macOS.

**Primary recommendation:** In Phase 2, make Bazel the honest top-level wrapper around the retained legacy oracle by exposing `Build.PL`-driven build/test flows, a small trusted macOS smoke-test set, and clearly documented prerequisites. Do not try to hermeticize CPAN, Boost, or old bootstrap scripts yet; surface those assumptions instead.

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|---|---|---|---|
| Bazel native shell rules (`sh_binary`, `sh_test`) | Bazel 8.x built-ins | Wrap existing legacy scripts and commands as top-level Bazel targets | Official Bazel shell rules are the simplest way to expose legacy build/test commands without pretending the legacy system is already Bazel-native. |
| `alias` and `filegroup` | Bazel built-ins | Present stable top-level labels and package-level surfaces | These keep the oracle surface discoverable without forcing early refactors of legacy layout. |
| `packages/legacy-slic3r/Build.PL` | repo-pinned legacy entrypoint | Bootstrap Perl dependencies, rebuild XS, and run the Perl test harness | It already drives the legacy Perl/XS flow end to end and is the clearest retained oracle surface. |
| `packages/legacy-slic3r/xs/Build.PL` | repo-pinned legacy XS entrypoint | Build the XS/C++ layer with Boost and Perl toolchain assumptions | It is a critical sub-step of the retained build path and exposes native dependency assumptions the planner must account for. |
| `packages/legacy-slic3r/src/CMakeLists.txt` | repo-pinned native build definition | Build the native CLI and Catch2-based tests on the C++ side | It provides the native CLI and test surface that complements the Perl/XS path, but should stay secondary to the oracle wrapper plan in this phase. |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|---|---|---|---|
| Perl + `cpanm` + `local::lib` | existing legacy stack | Required for `Build.PL` to resolve Perl dependencies into `local-lib/` | Use when wrapping the retained Perl/XS build flow; do not try to replace this in Phase 2. |
| Xcode Command Line Tools | current macOS baseline | Provide the macOS compiler and linker toolchain | Required for native compilation on the macOS-first path. |
| Boost include/lib path environment (`BOOST_INCLUDEDIR`, `BOOST_LIBRARYPATH`, optionally `BOOST_DIR`) | existing legacy contract | Drive native dependency discovery for `xs/Build.PL` | Use as documented prerequisites or wrapper-supplied environment when auto-discovery is insufficient. |
| App::Prove / Perl test harness | legacy test runner | Runs `packages/legacy-slic3r/t/` via `Build.PL` | Use when exposing the retained Perl test surface. |
| Catch2 + CMake test targets | legacy native test runner | Runs `src/test/` and optional GUI/native test targets | Use selectively for a trusted macOS oracle test set once the native path is callable. |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|---|---|---|
| `Build.PL`-first legacy wrapper | CMake-only wrapper | CMake-only is cleaner on the native side, but it skips the retained Perl/XS path that still represents much of the legacy runtime contract. |
| `sh_test` wrappers | `genrule`-driven execution | `genrule` is worse for long-lived test semantics and exit-code-driven oracle checks. Prefer test rules for test behavior. |
| Small trusted oracle set | “Run every historical test” immediately | Full historical coverage sounds safer, but Phase 2 would drown in flaky or low-value legacy surfaces before the oracle path becomes usable. |
| Documented prerequisite model | Full dependency vendoring/hermeticization | Hermeticization is valuable later, but it turns this phase into a dependency-rebuild project instead of an oracle-enablement phase. |

**Installation / prerequisites to document:**

```bash
# macOS baseline
xcode-select --install

# Perl bootstrap path expected by the legacy package
which perl
which cpanm

# When Boost auto-discovery fails
export BOOST_INCLUDEDIR=/path/to/boost/include
export BOOST_LIBRARYPATH=/path/to/boost/lib
```

## Architecture Patterns

### Recommended Project Structure

```text
packages/
├── legacy-slic3r/
│   ├── Build.PL
│   ├── xs/Build.PL
│   ├── src/CMakeLists.txt
│   └── BUILD.bazel
tools/
└── bazel/
    └── legacy/
        ├── build_legacy.sh
        ├── test_legacy_oracle.sh
        └── check_legacy_prereqs.sh
```

### Pattern 1: Wrapper-First Oracle Surface

**What:** Put a thin Bazel target in front of the existing legacy build/test commands instead of rewriting the commands into Bazel-native actions.
**When to use:** When the legacy flow already exists and the phase goal is to preserve it as a reference path.
**Example:**

```python
# Source: https://bazel.build/reference/be/shell
sh_binary(
    name = "legacy_build",
    srcs = ["//tools/bazel/legacy:build_legacy.sh"],
    data = [
        "//packages/legacy-slic3r:package_placeholder",
    ],
)
```

### Pattern 2: Trusted Oracle Test Set

**What:** Define a named set of legacy smoke/tests that are trustworthy on macOS, and document what is intentionally deferred.
**When to use:** When the historical test estate is mixed in quality or too broad for the first oracle-enablement pass.
**Example:**

```python
# Source: https://bazel.build/reference/be/shell
sh_test(
    name = "legacy_oracle_smoke",
    srcs = ["//tools/bazel/legacy:test_legacy_oracle.sh"],
    data = ["//packages/legacy-slic3r:package_placeholder"],
)
```

### Pattern 3: Explicit Prerequisite Gate

**What:** Fail early with a human-readable prerequisite check before invoking brittle legacy build/test flows.
**When to use:** When tools like `cpanm`, Boost, or macOS toolchain pieces must already exist and the phase explicitly allows documented caveats.
**Example:**

```bash
# Source: project wrapper pattern derived from Bazel shell-rule usage
command -v cpanm >/dev/null || {
  echo "cpanm is required for the legacy oracle path on macOS"
  exit 1
}
```

### Anti-Patterns to Avoid

- **Bazel as a fake pass-through:** exposing labels that still require users to remember undocumented legacy commands or env vars.
- **Hermetic cleanup disguised as wrapper work:** turning Phase 2 into CPAN/Boost/toolchain redesign instead of oracle enablement.
- **Single “all legacy tests” target with no trust model:** it obscures which failures matter for parity and which are historical noise.
- **GUI/package-output creep:** pulling wxWidgets GUI builds or release packaging into the oracle phase when the phase boundary explicitly excludes them.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| Legacy build orchestration | A new custom Starlark build system for Perl/XS/CMake internals | Thin `sh_binary`/`sh_test` wrappers plus documented prerequisites | The phase is about wrapping the oracle, not rewriting it. |
| Oracle verification | A brand-new test taxonomy before the legacy path is usable | A small trusted macOS smoke/test set backed by existing legacy entrypoints | You need a reliable oracle quickly, not a perfect taxonomy on day one. |
| Dependency normalization | Full CPAN/Boost/wx vendoring or toolchain repackaging | Explicit prerequisite checks and caveat docs | Cleanup is a future phase; Phase 2 needs the oracle path alive first. |
| Legacy package messaging | Ad hoc comments sprinkled through the repo | Clear README/package docs plus explicit Bazel target names | The oracle role needs one obvious story contributors can follow. |

**Key insight:** For this phase, “honest wrapper + explicit caveats” is better than “partial modernization pretending to be clean.”

## Common Pitfalls

### Pitfall 1: Treating `Build.PL` and CMake as Competing Truths

**What goes wrong:** The plan tries to make both legacy build paths equally primary, and the phase gets stuck reconciling two different ecosystems instead of exposing an oracle surface.
**Why it happens:** The repo contains both paths, so it is tempting to model them symmetrically.
**How to avoid:** Choose a clear oracle-first entrypoint for Phase 2, with the other path wrapped secondarily or deferred within the trusted test set.
**Warning signs:** Plans say “wrap all legacy build systems” without naming a first-class oracle path.

### Pitfall 2: Hiding Prerequisites Inside Bazel

**What goes wrong:** Bazel targets silently depend on `cpanm`, Boost env vars, or host-specific paths, but the contributor-facing docs never say so.
**Why it happens:** Wrappers get written quickly and rely on the author’s machine state.
**How to avoid:** Add explicit prerequisite checks and document the required macOS baseline in both wrapper scripts and Phase 2 docs.
**Warning signs:** Builds fail on a fresh machine with missing-tool errors that were never mentioned in docs.

### Pitfall 3: Oracle Drift Through “Helpful” Legacy Cleanup

**What goes wrong:** The legacy package changes beyond minimal integration, so the reference implementation stops being a stable oracle.
**Why it happens:** Once someone is in the legacy tree, cleanup opportunities are everywhere.
**How to avoid:** Keep wrapper-related edits narrow, document them as parity-preserving, and defer cleanup ideas explicitly.
**Warning signs:** Phase 2 diffs start touching logic files for readability or simplification instead of only wrapper/integration surfaces.

### Pitfall 4: Over-Broad Test Wrapping

**What goes wrong:** The plan promises every old test path at once, including flaky or low-value surfaces, and Phase 2 bogs down.
**Why it happens:** “More tests” feels safer, but the phase goal is a trusted oracle, not exhaustive rehabilitation of every historical suite.
**How to avoid:** Define a named trusted oracle set and document what is deferred.
**Warning signs:** There is no distinction between trusted tests, retained tests, and deferred tests in the plan or docs.

## Code Examples

### Wrapper build target

```python
# Source: https://bazel.build/reference/be/shell
sh_binary(
    name = "legacy_build",
    srcs = ["//tools/bazel/legacy:build_legacy.sh"],
    data = ["//packages/legacy-slic3r:package_placeholder"],
)
```

### Wrapper test target

```python
# Source: https://bazel.build/reference/be/shell
sh_test(
    name = "legacy_oracle_smoke",
    srcs = ["//tools/bazel/legacy:test_legacy_oracle.sh"],
    data = ["//packages/legacy-slic3r:package_placeholder"],
)
```

### Stable top-level label

```python
# Source: https://bazel.build/reference/be/general#alias
alias(
    name = "legacy_reference",
    actual = "//packages/legacy-slic3r:package_placeholder",
)
```

## State of the Art (2024-2026)

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| `WORKSPACE`-centric Bazel roots | Bzlmod via `MODULE.bazel` | Bazel 8/9 era | Wrapper work should live under the existing Bzlmod root rather than introducing legacy repo wiring patterns. |
| “One huge CI script” ownership | Smaller explicit Bazel entrypoints plus wrapper scripts | Modern Bazel repos | Legacy oracle access should be surfaced through a small set of stable targets, not hidden in CI-era scripts. |
| Exhaustive parity claims early | Trusted subset + explicit deferred surfaces | Common brownfield migration practice | The planner should define a trusted oracle set first, then expand. |

**New tools/patterns to consider:**

- Explicit prerequisite gate scripts under `tools/bazel/legacy/` so failures are actionable instead of mysterious.
- `test_suite` or equivalent grouping once the first trusted oracle tests exist, so Phase 2 can expose a meaningful “legacy oracle” label.

**Deprecated/outdated:**

- Treating CPAN auto-installs inside `Build.PL` as if they were hermetic CI behavior.
- Treating historical release packaging or GUI build paths as part of the first oracle wrapper scope.

## Open Questions

1. **Which exact legacy tests should count as the trusted macOS oracle set first?**

   - What we know: `Build.PL` runs the Perl test surface and `src/CMakeLists.txt` exposes native Catch2 tests.
   - What's unclear: which subset is both stable enough and valuable enough to be Phase 2’s first-class oracle.
   - Recommendation: start with a documented smoke/core subset that exercises the retained CLI/native path and expand only after Phase 2 is stable.

1. **How much of the `Build.PL` bootstrap can run non-interactively on the target macOS environment?**

   - What we know: `Build.PL` expects `cpanm`, `local::lib`, and often Boost path resolution; it can auto-install modules and rebuild `./xs`.
   - What's unclear: which of these prerequisites are already satisfied in the intended macOS workflow versus needing explicit manual setup.
   - Recommendation: plan an explicit prerequisite-check target early and document the macOS assumptions before attempting deeper wrapper automation.

## Sources

### Primary (HIGH confidence)

- `packages/legacy-slic3r/Build.PL` — authoritative Perl/XS bootstrap and Perl test entrypoint in the retained package
- `packages/legacy-slic3r/xs/Build.PL` — authoritative XS/native dependency expectations for the retained package
- `packages/legacy-slic3r/src/CMakeLists.txt` — authoritative native CLI/test build surface for the retained package
- [Bazel shell rules reference](https://bazel.build/reference/be/shell) — official `sh_binary` / `sh_test` guidance
- [Bazel alias and general rules reference](https://bazel.build/reference/be/general#alias) — official stable-label guidance
- [Bazel external migration guide](https://bazel.build/external/migration) — official Bzlmod-first migration guidance

### Secondary (MEDIUM confidence)

- [Bazelisk README](https://github.com/bazelbuild/bazelisk) — repo-pinned Bazel version launcher guidance
- [Cargo workspaces chapter](https://doc.rust-lang.org/cargo/reference/workspaces.html) — workspace organization reference inherited from Phase 1 package decisions

### Tertiary (LOW confidence - needs validation during implementation)

- None currently.

______________________________________________________________________

*Research completed: 2026-04-07*
