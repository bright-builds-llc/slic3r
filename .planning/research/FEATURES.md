# Feature Research

**Domain:** brownfield desktop slicer port program
**Researched:** 2026-04-06
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Legacy package stays buildable and testable | The old code is the parity oracle and the reference implementation during migration | HIGH | Keep it isolated as a retained package and build it through Bazel, not by modifying it in place |
| Rust package exists beside the legacy package | A real port needs a new implementation target, not just wrapper scripts | HIGH | Put the new code under `packages/` with clear ownership and dependency direction |
| Bazel becomes the top-level build/test entrypoint | A monorepo needs one reproducible way to build both legacy and Rust surfaces | HIGH | Bazel should orchestrate legacy builds, Rust builds, tests, and parity checks |
| macOS-first CLI/core parity path | Current development is on macOS and the GUI rewrite is deferred | HIGH | Focus on the CLI and core behaviors that already drive the slicer workflow |
| Preserved exported contracts and file formats | Parity only matters if inputs/outputs/configs remain stable for users and integrators | HIGH | Include CLI flags, config parsing, project files, generated outputs, and packaging-visible behavior |
| Migration docs and checklists in `docs/` | A long-lived port needs visible progress and explicit review points | MEDIUM | Make updates part of the normal change process so parity status does not drift |
| Fixture corpus for legacy-vs-Rust comparison | Regression-proofing requires shared cases that both implementations can run | HIGH | Use real slicer inputs/outputs, not synthetic unit-only cases |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not required, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Parity check command with status summary | Makes port progress visible and keeps the migration honest | MEDIUM | Start with a summary of implemented surfaces, then expand toward fixture comparison and diff reporting |
| Dual-run legacy/Rust comparison harness | Turns the legacy implementation into an executable oracle instead of a passive code dump | HIGH | Best path to confidence when outputs must stay aligned across many surfaces |
| Bazel-native monorepo package boundaries | Clarifies what is legacy, what is new, and how they depend on each other | HIGH | Helps contributors avoid accidentally mixing the migration layers |
| Documented shell/Rust replacement for the Perl launcher | Removes the old launcher path without losing the user-facing entrypoints | MEDIUM | Treat as a refactor of responsibility, not a cosmetic script swap |
| Process-required docs/checklists alongside code | Keeps parity work reviewable by humans even before automated enforcement exists | LOW | Useful because the migration has many moving parts and hidden assumptions |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Big-bang rewrite that deletes the legacy code immediately | Feels cleaner and faster | Removes the parity oracle and makes regressions much harder to diagnose | Keep the legacy package buildable and use it as the reference implementation |
| GUI rewrite in the first milestone | The GUI is visible and tempting to modernize | It adds a large surface area before the core parity path is trustworthy | Defer GUI work until CLI/core parity and build plumbing are stable |
| Linux/Windows support from day one | Cross-platform support sounds complete | It multiplies the migration problem before the macOS path is proven | Validate macOS first, then expand platform support in later milestones |
| Treating the Perl launcher as a must-preserve implementation detail | It is the current entrypoint | The launcher itself is not the value; preserving it blocks cleaner Rust/Bazel/shell shaping | Preserve the user-facing contracts, not the Perl mechanism |
| Making docs/checklists optional | Seems lighter-weight during the port | The migration will lose traceability and parity status will drift | Keep docs/checklists required by process and update them with each Rust change |
| Over-automating parity too early | Automation sounds rigorous | Early automation can hide incomplete definitions and create false confidence | Start with a clear status command and add deeper comparison as the corpus matures |

## Feature Dependencies

```text
Bazel monorepo
    └──requires──> legacy package isolation
                       └──requires──> explicit package boundaries

Parity check command
    └──requires──> fixture corpus
                       └──requires──> legacy oracle package

Rust CLI/core port
    └──requires──> preserved exported contracts
                       └──requires──> documentation/checklist discipline

Perl launcher replacement
    └──requires──> Rust/Bazel/shell entrypoint strategy
                       └──requires──> stable CLI/core behavior
```

### Dependency Notes

- **Bazel monorepo requires legacy package isolation:** the retained codebase must remain buildable and callable without becoming entangled with new Rust packages.
- **Parity check command requires a fixture corpus:** status reporting is useful immediately, but behavioral comparison only becomes meaningful once shared inputs and expected outputs are defined.
- **Rust CLI/core port requires preserved exported contracts:** the migration cannot progress safely if inputs, outputs, or config semantics are drifting at the same time.
- **Perl launcher replacement requires stable CLI/core behavior:** the launcher can only be simplified once the new entrypoints are trustworthy and documented.

## MVP Definition

### Launch With (v1)

Minimum viable product — what's needed to validate the concept.

- [ ] Bazel can build and test the retained legacy package and the initial Rust package on macOS — proves the monorepo shape is real
- [ ] Rust core and CLI can reproduce the highest-value legacy behaviors on a limited fixture set — proves the port has a working spine
- [ ] A parity status command reports what is implemented, what is still legacy-only, and what is blocked — makes migration progress visible
- [ ] Migration docs and checklists exist in `docs/` and are updated with each Rust change — keeps the port auditable

### Add After Validation (v1.x)

Features to add once core is working.

- [ ] Broader fixture comparison and diff reporting — add once the first parity corpus is stable enough to trust
- [ ] Shell/Rust replacement for the Perl launcher entrypoint — add once the CLI/core path is reliable on macOS
- [ ] GUI migration planning and surface inventory — add once the core port is stable enough to justify the extra complexity

### Future Consideration (v2+)

Features to defer until product-market fit is established.

- [ ] Linux and Windows parity for the new Rust implementation — defer until the macOS path proves the migration strategy
- [ ] Full GUI rewrite in Rust — defer until the CLI/core parity path and build plumbing are mature
- [ ] Automated enforcement of docs/checklist updates — defer until the process settles and the checks are well understood
- [ ] Deleting the legacy package entirely — defer until parity is proven and the legacy oracle is no longer needed

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Bazel can build/test legacy + Rust packages | HIGH | HIGH | P1 |
| Rust core/CLI parity on macOS | HIGH | HIGH | P1 |
| Parity status command | HIGH | MEDIUM | P1 |
| Fixture corpus for comparison | HIGH | HIGH | P1 |
| Migration docs/checklists in `docs/` | MEDIUM | LOW | P1 |
| Shell/Rust launcher replacement | MEDIUM | MEDIUM | P2 |
| Broader diff-based parity harness | HIGH | HIGH | P2 |
| GUI migration planning | MEDIUM | HIGH | P3 |

**Priority key:**

- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | Competitor A | Competitor B | Our Approach |
|---------|--------------|--------------|--------------|
| Migration strategy | Legacy Slic3r in-place | Big-bang rewrite | Retain legacy as the oracle and add Rust beside it |
| Build system | Ad hoc Perl/C++ flows | Single-language native build | Bazel as the top-level orchestrator for both worlds |
| Parity validation | Manual spot checks | Automated tests only | Status command plus fixture-based comparison over time |
| Launcher path | Perl launcher | Rust-only assumption | Rust/Bazel/shell replacement with the user-facing contract preserved |
| Platform rollout | All historical targets at once | New platform only | macOS first, then Linux and Windows later |

## Sources

- `.planning/PROJECT.md`
- `.planning/codebase/ARCHITECTURE.md`
- `.planning/codebase/STACK.md`
- `.planning/codebase/CONCERNS.md`
- `.planning/codebase/INTEGRATIONS.md`

______________________________________________________________________

*Feature research for: brownfield desktop slicer port program*
*Researched: 2026-04-06*
