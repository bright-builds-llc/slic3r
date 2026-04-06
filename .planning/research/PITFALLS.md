# Pitfalls Research

**Domain:** legacy desktop 3D-slicer modernization
**Researched:** 2026-04-06
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Parity Drift From a "Clean Rewrite"

**What goes wrong:**
The Rust code compiles and looks cleaner, but it silently diverges from the legacy CLI, config handling, file formats, toolpath output, or exit behavior. The team ends up with two slicers that both "work" but do not agree on real jobs.

**Why it happens:**
Porting work rewards forward momentum, and the old code is full of complexity people want to leave behind. Without an explicit legacy-oracle loop, implementers optimize for readability instead of observable contract parity.

**How to avoid:**
Keep the legacy package buildable and runnable as the reference implementation. Define a golden fixture corpus early, require side-by-side legacy-vs-Rust comparisons for core workflows, and treat CLI flags, config keys, export formats, and exit codes as parity contracts rather than implementation details.

**Warning signs:**
The parity checker only reports status instead of comparing outputs. Rust changes land with no fixture updates. Docs say "equivalent" but nobody can point to a failing comparison when behavior differs.

**Phase to address:**
Phase 1 for contract inventory, Phase 2 for Rust implementation boundaries, Phase 3 for fixture-based parity checks.

______________________________________________________________________

### Pitfall 2: A Bazel Migration That Is Not Hermetic

**What goes wrong:**
Bazel becomes another way to invoke the old repository layout instead of a real top-level build system. Builds depend on host-specific paths, ad hoc downloads, local SDK discovery, or environment quirks that break on a clean machine or different macOS setup.

**Why it happens:**
The legacy repo already has a lot of bootstrap logic, and it is tempting to wrap that logic instead of replacing it. Bazel also makes it easy to hide non-hermetic behavior in repository rules and toolchain setup.

**How to avoid:**
Use Bazel as the actual owner of the monorepo build graph, not just a dispatcher. Prefer Bzlmod-managed dependencies, pinned toolchains, and explicit platform constraints. Avoid repository rules that probe the host with `which`, `os`, or other environment-dependent checks. Use workspace-rule logs when auditing for non-hermetic behavior.

**Warning signs:**
Fresh-clone builds fail differently from cached developer builds. Absolute local paths show up in Bazel setup. The repository still needs manual environment setup before Bazel can even analyze targets.

**Phase to address:**
Phase 1 for Bazel bootstrap and package layout, with ongoing checks as new packages and toolchains are added.

______________________________________________________________________

### Pitfall 3: The Launcher Becomes a Second Legacy System

**What goes wrong:**
The Perl launcher is replaced by a growing pile of shell glue, ad hoc wrappers, and duplicated flag parsing. Instead of one clear entrypoint, the repo accumulates multiple partially overlapping ways to invoke the app.

**Why it happens:**
Launcher replacement looks easy compared with geometry or slicing logic, so it gets deferred and then reinvented in fragments. Teams often preserve old behavior by copying the old launcher shape instead of collapsing it into a smaller, clearer contract.

**How to avoid:**
Make the new entrypoint strategy explicit: Rust owns application behavior, Bazel owns orchestration, and shell scripts stay thin where they are unavoidable. Keep the legacy launcher in the retained package only as a reference surface. Do not let shell glue become the place where real product behavior lives.

**Warning signs:**
Shell scripts start parsing domain flags, path resolution differs between entrypoints, or contributors ask which command is the real one. The launcher and the Rust code disagree on defaults or help text.

**Phase to address:**
Phase 2, when the Rust CLI and replacement entrypoint are introduced.

______________________________________________________________________

### Pitfall 4: Fixture and Corpus Erosion

**What goes wrong:**
The parity harness exists, but the sample corpus is too small, too synthetic, or too stale to catch regressions. The project reports progress while the real-world cases that matter to slicers keep drifting.

**Why it happens:**
Fixture maintenance is tedious, especially when outputs are large, binary-ish, or sensitive to floating-point and platform differences. Without ownership, the corpus becomes a one-time setup rather than a living contract.

**How to avoid:**
Version the fixture corpus and tie it to the parity checker. Include representative models, configs, and expected outputs from the legacy package. Keep a documented update protocol so corpus changes are deliberate and reviewed, not incidental. Make macOS the first validation target, but keep the corpus structured so Linux and Windows coverage can be added later.

**Warning signs:**
The parity checker only exercises one or two happy-path jobs. Fixture files are updated whenever a test fails, with no explanation. No one knows which models represent the actual contract surface.

**Phase to address:**
Phase 3, once the Rust core is producing meaningful outputs and can be compared to legacy.

______________________________________________________________________

### Pitfall 5: Documentation Becomes Theater

**What goes wrong:**
The repo gets `docs/` pages and checklists, but they drift from the actual code. Progress looks good on paper while the migration reality is elsewhere.

**Why it happens:**
Documentation is easy to postpone when the code is changing quickly. If docs are not part of the normal merge workflow, they become stale almost immediately in a porting project.

**How to avoid:**
Require docs and checklists to move with Rust-port changes as a process rule. Keep the migration plan, parity checklist, and status summaries in the repo, and make them the first place reviewers look for migration state. Tie each meaningful code change to an explicit doc update.

**Warning signs:**
The roadmap says a capability is done, but the docs still mark it as pending. New Rust packages appear without a matching checklist update. People ask for the "real status" because the docs no longer answer the question.

**Phase to address:**
Phase 1 for the process definition, then every phase after that.

______________________________________________________________________

### Pitfall 6: Platform Scope Creeps Too Early

**What goes wrong:**
The migration tries to make Linux, macOS, and Windows all first-class at once. The Bazel graph, Rust toolchain, and launcher strategy become tangled in cross-platform conditionals before macOS parity is stable.

**Why it happens:**
Supporting every platform sounds safer, but it usually multiplies the number of moving parts before the core contract is proven. Migration work is already high-risk; adding platform expansion too early raises the cost of every failure.

**How to avoid:**
Keep macOS as the first hard target. Put platform-specific logic behind clear boundaries and defer Linux/Windows expansion until the core, CLI, parity tooling, and docs process are stable. Use the retained legacy package as a cross-platform reference, not as a reason to ship all platforms in the first milestone.

**Warning signs:**
Shared code starts sprouting platform ifdefs, Bazel targets become heavily conditional, or platform setup occupies more time than parity validation. The team cannot explain which platform is the current source of truth.

**Phase to address:**
Phase 1 for scope control, Phase 4+ for later platform expansion.

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Copy legacy behavior into Rust without a comparison harness | Faster first milestone | Parity drift becomes invisible | Never |
| Keep shell scripts as the primary orchestration layer | Quick bootstrap | A second hidden build system appears | Only for thin launchers or glue |
| Leave old and new config schemas both "active" indefinitely | Less migration work now | Two sources of truth and endless edge cases | Only during a tightly bounded transition |

## Integration Gotchas

Common mistakes when connecting the Bazel/Rust migration pieces.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Bazel external dependencies and toolchains | Let repository rules discover host paths, SDKs, or binaries implicitly | Pin toolchains, prefer Bzlmod-managed deps, and keep repository rules hermetic |
| Rust workspace/package layout | Build one giant crate or let package boundaries leak everywhere | Use a workspace with explicit package ownership and narrow dependency direction |
| macOS SDK/Xcode setup | Assume the developer machine has the right local SDK and environment variables | Declare the macOS toolchain and SDK requirements explicitly in the Bazel path |

## Performance Traps

Patterns that work at small scale but fail as the port grows.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Full parity suite runs on every tiny edit | Slow iteration and skipped validation | Split smoke checks from full corpus checks and scope Bazel targets | As soon as fixture sets or targets grow beyond a few trivial cases |
| Rebuilding both legacy and Rust trees for unrelated changes | Long build/test cycles | Use package boundaries and affected-target selection | When the repo contains multiple packages with independent change sets |
| Huge output diffs or large model corpora loaded into every test | Memory pressure and noisy failures | Shard fixtures and keep representative samples small | When outputs become large enough to dominate test runtime |

## Security Mistakes

Domain-specific security issues in a porting-and-build migration.

| Mistake | Risk | Prevention |
|---------|------|------------|
| Repository rules or shell glue execute host commands to "discover" the environment | Non-hermetic builds and potential supply-chain surprises | Keep build setup declarative and audit workspace rules for host dependence |
| Launcher shims pass untrusted arguments into post-processing or external tools without clear boundaries | Arbitrary local command execution through trusted project files | Keep shell/Rust entrypoints thin, document trusted-input surfaces, and avoid shell interpolation |
| Parity fixtures or docs accidentally include private paths, credentials, or release material | Sensitive data leaks into a public repo or build corpus | Treat fixtures and docs as public artifacts and scan them before commit |

## UX Pitfalls

Common contributor-experience mistakes in a migration repo.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Multiple commands claim to be the "real" way to build or run the project | Contributors waste time figuring out which path is canonical | Make Bazel the primary top-level path and keep legacy entrypoints clearly labeled |
| Parity status is just a pass/fail label | No one knows what is actually left to port | Report progress, gaps, and the current comparison corpus explicitly |
| Docs and checklists are separate from code changes | New contributors cannot tell what is current | Keep migration docs in-repo and require updates as part of the normal workflow |

## "Looks Done But Isn't" Checklist

Things that appear complete but are missing critical pieces.

- [ ] **Bazel builds succeed:** Verify legacy and Rust packages both build from clean checkout, not just on a developer machine with cached state
- [ ] **Parity checker exists:** Verify it compares actual outputs or contracts, not only status text
- [ ] **Rust CLI works:** Verify flags, exit codes, file paths, and generated outputs against the legacy reference
- [ ] **Docs updated:** Verify `docs/` and checklist files changed alongside the code, not after the fact

## Recovery Strategies

When pitfalls occur despite prevention, how to recover.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Parity drift | HIGH | Freeze new Rust changes, diff against the legacy oracle, regenerate a focused corpus, and fix the narrowest contract mismatch first |
| Non-hermetic Bazel setup | MEDIUM | Audit repository rules, pin toolchains, remove host probing, and re-run from a clean checkout |
| Launcher/entrypoint confusion | MEDIUM | Collapse to one documented canonical command path and demote any extra wrappers to thin compatibility shims |

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Parity drift from a clean rewrite | Phase 1 through Phase 3 | Legacy-vs-Rust comparison runs on representative fixtures |
| Non-hermetic Bazel migration | Phase 1 | Clean-clone Bazel build and workspace-rule audit pass |
| Launcher becomes a second legacy system | Phase 2 | One canonical entrypoint plus thin shims only |
| Fixture and corpus erosion | Phase 3 | Versioned corpus and explicit update protocol |
| Documentation theater | Phase 1 onward | Code changes require matching doc/checklist updates |
| Platform scope creeps too early | Phase 1 and Phase 4+ | macOS stays the initial hard target; later platforms are staged deliberately |

## Sources

- Local codebase map: `.planning/codebase/ARCHITECTURE.md`, `.planning/codebase/CONCERNS.md`, `.planning/codebase/STACK.md`, `.planning/codebase/TESTING.md`
- Project brief: `.planning/PROJECT.md`
- Bazel docs: `https://bazel.build/`, `https://blog.bazel.build/2023/12/11/bazel-7-release.html`, `https://docs.bazel.build/versions/main/workspace-log.html`
- Rust docs: `https://doc.rust-lang.org/`, `https://doc.rust-lang.org/cargo/guide/project-layout.html`, `https://doc.rust-lang.org/cargo/reference/`

______________________________________________________________________

*Pitfalls research for: legacy desktop 3D-slicer modernization*
*Researched: 2026-04-06*
