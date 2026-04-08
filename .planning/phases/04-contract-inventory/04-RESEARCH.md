# Phase 04: Contract Inventory - Research

**Researched:** 2026-04-08
**Domain:** Contract-surface inventory and migration guidance for the Slic3r Rust port
**Confidence:** HIGH

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions

### Contract taxonomy

- The primary parity surfaces for this phase are externally observable ones only: CLI behavior, config semantics, supported file formats, generated outputs, launcher path, and packaging-visible behavior. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Internal build plumbing, Bazel scaffolding, and temporary migration mechanics are evidence sources, not parity surfaces in their own right. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- The inventory should be organized by user- or integrator-visible contract surface, not by implementation language or directory. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

### Evidence standard

- Every inventory claim should point to concrete source-of-truth evidence in the repo: files, commands, or retained oracle labels. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- The contract inventory should distinguish between “currently trusted oracle evidence” and “legacy surface exists but evidence is weaker or deferred.” [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Broad claims without concrete file or command anchors should be avoided. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

### Deferred and unsupported handling

- Deferred or unstable surfaces must be stated plainly rather than hidden behind optimistic language. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- The broader retained legacy test wrapper should remain documented as deferred evidence, not as a trusted parity signal. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Phase 4 should explain which surfaces are in scope for upcoming migration work versus later milestones. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

### Migration guidance shape

- The migration guidance should emphasize preserving user-visible contracts, not preserving the old Perl or legacy implementation mechanics. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Launcher guidance should explicitly describe that the user-facing contract matters more than the Perl implementation path. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- The docs should remain conservative: do not imply Rust-backed parity for any surface that is still legacy-only. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

### Claude's Discretion

- Exact filenames for the new contract inventory and migration guidance docs [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Exact table schema or section ordering, as long as the contract surfaces, evidence model, and deferred-state guidance remain explicit [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Whether to update existing `docs/port/*` files in place or introduce one or two new docs under `docs/port/` to hold the richer inventory and guidance [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

### Deferred Ideas (OUT OF SCOPE)

- Do not implement new Rust parity behavior in this phase. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- Do not broaden the parity matrix to claim verified Rust-backed surfaces before later implementation phases land. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PARI-01 | Maintainer can enumerate the exported contracts and parity surfaces that the Rust port must preserve, including CLI behavior, config semantics, supported file formats, generated outputs, and packaging-visible behavior. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md] | Add a dedicated contract inventory under `docs/port/` that is grouped by those six externally visible surface families and gives each item a repo-anchored source of truth, trusted check, evidence status, current scope, and deferred notes. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; ASSUMED] |
| DOCS-03 | Contributor can find written guidance for the launcher refactor, monorepo layout, parity strategy, and fixture update protocol. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md] | Keep `docs/port/package-map.md` as the layout explainer, add migration guidance that covers launcher replacement, parity strategy, fixture update protocol, and scope/deferred boundaries, and link it from `docs/port/README.md`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED] |
</phase_requirements>

## Summary

Phase 04 should expand the existing `docs/port/` control plane rather than replace it. The repo already has a high-level README, checklist, package map, and parity matrix, but those files only describe surfaces at a coarse status level and do not yet enumerate contract items with evidence strength, trusted oracle scope, or explicit now-versus-later migration guidance. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md]

The strongest planning shape is a two-layer documentation model. Keep `docs/port/parity-matrix.md` as the readable dashboard of status vocabulary, and add one detailed evidence-backed contract inventory plus one migration-guidance document for launcher replacement, parity strategy, fixture update protocol, and scope/deferred boundaries. That preserves the current control-plane structure while giving later phases a concrete contract registry to build against. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; ASSUMED]

The critical nuance is evidence quality. The repo has many legacy contract sources, but the currently trusted retained oracle is intentionally narrow: `//:legacy_oracle_smoke` builds the retained legacy package and runs `slic3r.pl --help`, while `//:legacy_oracle_test` is still a documented deferred broader surface. Phase 04 should therefore document three separate things for each contract item: the legacy source of truth, the best currently trusted check, and any weaker or deferred evidence that exists but should not be overstated. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_oracle.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

**Primary recommendation:** Add `docs/port/contract-inventory.md` and `docs/port/migration-guidance.md`, keep `docs/port/parity-matrix.md` as the status dashboard, and require every contract row to separate source of truth, trusted check, evidence status, and deferred scope. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `docs/port/*.md` | repo-local Markdown, no external version pin. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md] | Contributor-facing migration control plane for parity status, package boundaries, and migration guidance. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md] | The repo already names `docs/port/` as the source of truth for migration-state documentation, so Phase 04 should extend that surface instead of creating a parallel docs tree. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md] |
| Bazel labels for oracle surfaces | repo-local labels, no external version pin. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel] | Command anchors for “trusted oracle,” “deferred broader test,” and current Rust verification surfaces. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel] | Phase context requires every claim to point at concrete files, commands, or retained oracle labels rather than prose alone. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] |
| Legacy contract sources | repo-local source tree, no external version pin. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/README.md] | Canonical current definitions of CLI behavior, config semantics, file formats, generated outputs, launcher behavior, and packaging-visible behavior while user-facing parity remains legacy-only. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/lib/Slic3r/Config.pm; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package] | Current docs explicitly say user-facing parity surfaces remain legacy-only after Phase 3. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md] |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` | repo-local test source. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp] | Richer but currently weaker evidence for export/output CLI behavior than the trusted smoke wrapper. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh] | Use when the inventory needs examples of output filenames, export modes, or CLI behaviors that are not covered by the trusted `--help` smoke check. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp] |
| `packages/legacy-slic3r/utils/zsh/functions/_slic3r` | repo-local completion script. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/utils/zsh/functions/\_slic3r] | Cross-check for option names, output extensions, and intentionally undocumented flags. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/utils/zsh/functions/\_slic3r] | Use when documenting CLI flags or when the inventory needs a second repo-local witness beyond `slic3r.pl` usage text. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/utils/zsh/functions/\_slic3r] |
| `mdformat` | `1.0.0`. \[VERIFIED: local command `mdformat --version`\] | Optional check-mode Markdown validation for changed docs because the repo has no repo-owned docs verifier. \[VERIFIED: local command `mdformat --version`; VERIFIED: local search `rg -n "markdownlint|mdformat|prettier|shfmt|verify|check|validate|ci" .github scripts tools docs packages`; CITED: https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md\] | Use on changed Markdown paths in Phase 04. \[VERIFIED: local command `mdformat --version`; CITED: https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md\] |
| `shfmt` | `3.12.0`. \[VERIFIED: local command `shfmt --version`\] | Optional shell-format check only if Phase 04 touches shell snippets or scripts. \[VERIFIED: local command `shfmt --version`; CITED: https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md\] | Use only when the phase ends up editing shell files or embedded shell examples. \[VERIFIED: local command `shfmt --version`\] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| A dedicated contract inventory doc that the parity matrix links to. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; ASSUMED] | Expand `docs/port/parity-matrix.md` into the full inventory. [ASSUMED] | This keeps one file count lower, but it collapses the current dashboard and the detailed evidence registry into the same surface and will make the existing status matrix much harder to scan. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; ASSUMED] |
| A structured table with explicit evidence columns. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED] | Narrative prose paragraphs by surface. [ASSUMED] | Prose is easier to write initially, but it is harder to diff, grep, review, and carry forward into later CLI/config/parity phases. [ASSUMED] |
| Marking `//:legacy_oracle_test` as deferred evidence. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | Treating it as a trusted parity signal because it runs real tests. [ASSUMED] | That would misstate the current oracle quality and contradict both current docs and locked context. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] |

**Installation:**

```bash
# No new dependencies are required for Phase 04.
mdformat --check docs/port/*.md
```

Phase 04 is documentation and inventory work over existing repo surfaces, not a dependency-addition phase. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port]

**Version verification:**

- No new package or library version pin is required for the recommended Phase 04 stack because the core surfaces are repo-local Markdown, repo-local source files, and repo-local Bazel labels. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r]
- Optional local validators available on this machine are `mdformat 1.0.0` and `shfmt 3.12.0`. \[VERIFIED: local command `mdformat --version`; VERIFIED: local command `shfmt --version`\]

## Architecture Patterns

### Recommended Project Structure

```text
docs/port/
├── README.md                 # control-plane index and vocabulary
├── parity-matrix.md          # high-level status dashboard
├── contract-inventory.md     # detailed contract registry with evidence columns
├── migration-guidance.md     # launcher replacement, parity strategy, fixtures, scope/deferred
├── checklist.md              # milestone checklist
└── package-map.md            # package and root-area responsibilities
```

This keeps the existing control-plane entrypoint intact, preserves the current parity-matrix role, and adds exactly the two missing surfaces the requirements call for: a contract registry and contributor guidance. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]

### Pattern 1: Keep The Dashboard Separate From The Evidence Registry

**What:** Preserve `docs/port/parity-matrix.md` as the short status summary and move detailed contract rows into a dedicated inventory file. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; ASSUMED]
**When to use:** Immediately in Phase 04, because the current matrix already carries the shared vocabulary but not the per-contract evidence detail the phase requires. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]
**Example:**

```md
<!-- Source: docs/port/parity-matrix.md + 04-CONTEXT.md -->
| Surface | Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Deferred Notes |
|---------|---------------|------------------------|---------------|-----------------|---------------|----------------|
| CLI behavior | `--help` usage and exit path | `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` | trusted-oracle | in scope now | richer CLI/output flows remain later-phase parity work |
```

### Pattern 2: Separate “Source Of Truth” From “Trusted Check”

**What:** Every contract row should have one column for the legacy implementation source, one column for the strongest currently trusted command or label, and one column for weaker or deferred evidence. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_oracle.sh]
**When to use:** For all six surface families, because current oracle strength varies sharply across the repo. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md]
**Example:**

```md
<!-- Source: tools/bazel/legacy/test_legacy_smoke.sh + tools/bazel/legacy/test_legacy_oracle.sh -->
| Surface | Contract Item | Legacy Source of Truth | Trusted Check | Weaker Or Deferred Evidence |
|---------|---------------|------------------------|---------------|-----------------------------|
| CLI behavior | export flags and output naming | `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` only covers `--help` today | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r`, `//:legacy_oracle_test` |
```

### Pattern 3: Organize By External Surface, Not By Package Or Language

**What:** Top-level inventory sections should be the locked surface families: CLI behavior, config semantics, supported file formats, generated outputs, launcher path, and packaging-visible behavior. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
**When to use:** For the whole inventory and for cross-links from `README.md` or the parity matrix. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
**Example:**

```md
## CLI Behavior
## Config Semantics
## Supported File Formats
## Generated Outputs
## Launcher Path
## Packaging-Visible Behavior
```

### Pattern 4: Put Launcher, Parity Strategy, And Fixture Protocol In One Guidance Surface

**What:** Use one migration-guidance document to explain launcher replacement goals, how to interpret parity evidence, how future fixtures should be added or updated, and which surfaces are deferred. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]
**When to use:** When contributor guidance is shorter than a few hundred lines and benefits from one place to start. [ASSUMED]
**Example:**

```md
## Launcher Replacement
## Parity Strategy
## Fixture Update Protocol
## Scope Now vs Deferred
```

### Anti-Patterns to Avoid

- **Inventorying packages instead of contracts:** `packages/launcher`, `packages/parity`, and `packages/parity-fixtures` are currently placeholders and package boundaries, not evidence that those user-visible surfaces are already implemented. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/launcher/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity-fixtures/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md]
- **Collapsing trusted and deferred evidence:** Current docs explicitly distinguish trusted `//:legacy_oracle_smoke` from deferred broader legacy tests, so the inventory should not flatten those into one generic “tested” claim. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- **Treating Bazel scaffolding as a contract surface:** Locked context says build plumbing is evidence, not the parity surface itself. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
- **Documenting launcher behavior as only `slic3r.pl`:** Packaging-visible launcher behavior also lives in platform startup scripts and the Windows shell wrapper. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/common/shell.cpp]
- **Implying Rust-backed parity because `packages/slic3r-rust` exists:** The Rust package README explicitly says Phase 3 does not yet claim CLI, GUI, or output parity. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Contract registry | Freeform narrative paragraphs or scattered TODO notes. [ASSUMED] | A structured Markdown table under `docs/port/` with evidence columns and stable surface headings. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED] | Later phases need a diffable, grep-able, reviewable contract source, not prose that must be re-parsed by hand. [ASSUMED] |
| CLI contract capture | Memory, README marketing text, or one-off manual inspection. [ASSUMED] | `packages/legacy-slic3r/slic3r.pl`, `packages/legacy-slic3r/src/test/GUI/test_cli.cpp`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r`, and `//:legacy_oracle_smoke`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/utils/zsh/functions/\_slic3r; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh] | Those are the current repo-local sources that define or exercise the CLI surface. [VERIFIED: same as previous cell] |
| Packaging-visible behavior summary | One generic “packaging scripts live under `package/`” note. [ASSUMED] | Per-platform packaging subsections tied to `package/osx`, `package/linux`, `package/win`, plus startup scripts and the Windows shell wrapper. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/common/shell.cpp; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/startup_script.sh] | Packaging-visible behavior differs materially by platform and artifact shape. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/make_dmg.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/make_archive.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/win/package_win32.ps1] |
| Fixture-update guidance | A concrete fixture corpus or comparison harness in this phase. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | Written protocol only, anchored to the future `packages/parity-fixtures` boundary and later parity phases. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity-fixtures/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; ASSUMED] | Locked scope says Phase 04 documents the protocol and defers actual parity implementation. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] |
| Parity vocabulary | A new taxonomy for status words. [ASSUMED] | The existing `legacy-only`, `in progress`, `rust-backed`, and `verified` vocabulary already defined in `docs/port/README.md`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md] | Reusing the current vocabulary avoids review friction and terminology drift across docs. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md] |

**Key insight:** The hard part of this phase is not discovering that the legacy tree is large; it is expressing contract facts conservatively enough that future phases can trust the inventory without mistaking source presence for parity proof. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md]

## Common Pitfalls

### Pitfall 1: Treating “Source Exists” As “Parity Is Proven”

**What goes wrong:** The inventory points at a source file and implies that the contract is well-validated even when the only currently trusted oracle is much narrower. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_oracle.sh]
**Why it happens:** The retained legacy tree contains many tests, helpers, and packaging scripts, which makes it easy to confuse “there is evidence” with “there is trusted proof.” [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/t; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp]
**How to avoid:** Give each row separate columns for `Legacy Source of Truth`, `Trusted Check`, and `Weaker Or Deferred Evidence`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]
**Warning signs:** A row has one “Evidence” cell that mixes files, commands, and tests without explaining confidence. [ASSUMED]

### Pitfall 2: Letting Placeholder Packages Masquerade As Implemented Surfaces

**What goes wrong:** The inventory claims launcher, parity tooling, or fixture workflows are already partly implemented because corresponding top-level packages exist. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/launcher/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity-fixtures/BUILD.bazel]
**Why it happens:** Phase 1 established visible package boundaries early, and Phase 3 added a real Rust crate, so future-facing boundaries look more mature than they are. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md]
**How to avoid:** Phrase placeholder packages as “future owner/boundary” metadata, not as evidence that the user-visible surface has moved. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md; ASSUMED]
**Warning signs:** Words like “partial,” “started,” or “moved” appear next to `packages/launcher`, `packages/parity`, or `packages/parity-fixtures` without concrete implementation evidence. [ASSUMED]

### Pitfall 3: Under-Documenting Launcher Behavior

**What goes wrong:** The phase treats launcher behavior as only “the CLI is `slic3r.pl`,” missing platform startup scripts and the Windows shell wrapper that are visible packaging/launch behavior. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/common/shell.cpp]
**Why it happens:** The parity matrix currently names the launcher path at a high level, which is correct but not detailed enough for migration guidance. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md]
**How to avoid:** Inventory launcher behavior as a surface family with sub-items for direct script entry, packaged startup scripts, and wrapper executables. [ASSUMED]
**Warning signs:** The guidance says “replace the Perl launcher” without defining what user-visible launch contract must remain stable. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]

### Pitfall 4: Finishing The Inventory Without A Fixture Update Protocol

**What goes wrong:** The contracts are listed, but contributors still do not know how future parity fixtures should be named, updated, justified, or linked back to evidence. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]
**Why it happens:** There is no seeded fixture corpus yet, so it is easy to postpone fixture guidance until the future tooling phase. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/parity-fixtures/BUILD.bazel]
**How to avoid:** Document the protocol now even if the actual corpus remains deferred: location, naming, provenance, update expectations, and docs-touch requirement. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; ASSUMED]
**Warning signs:** The plan says “fixtures later” without adding any contributor guidance in `docs/`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]

### Pitfall 5: Hiding Deferred Scope Behind Optimistic Language

**What goes wrong:** The docs imply current Rust-backed coverage or near-term support that the repo does not yet prove. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md]
**Why it happens:** There is already a real Rust crate and a verification target, which can tempt a planner to describe user-visible parity as “in progress” too broadly. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md]
**How to avoid:** State “legacy-only” unless there is concrete Rust-backed surface evidence, and explicitly mark Linux/Windows packaging migration work deferred even if those packaging contracts are inventoried now. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]
**Warning signs:** Phrases like “Rust path exists” or “launcher replacement has started” appear without concrete files, commands, or accepted parity checks. [ASSUMED]

## Code Examples

Verified patterns from repo evidence and locked phase context:

### Contract Inventory Table Shape

```md
<!-- Source: 04-CONTEXT.md + docs/port/parity-matrix.md -->
| Surface | Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Deferred Notes | Future Owner |
|---------|---------------|------------------------|---------------|-----------------|---------------|----------------|-------------|
| Config semantics | INI load/save and CLI overlay rules | `packages/legacy-slic3r/lib/Slic3r/Config.pm` | none stronger than source-level evidence today | source-only | in scope now | per-option exhaustive extraction can wait for later config work | `packages/slic3r-rust` |
```

### Migration Guidance Outline

```md
<!-- Source: REQUIREMENTS.md + 04-CONTEXT.md + docs/port/README.md -->
# Migration Guidance

## Launcher Replacement
## Parity Strategy
## Fixture Update Protocol
## Scope Now vs Deferred
```

### Launcher Contract Subsection

```md
<!-- Source: slic3r.pl + platform startup scripts + shell.cpp -->
## Launcher Path

- Direct legacy entry: `packages/legacy-slic3r/slic3r.pl`
- Packaged macOS entry: `packages/legacy-slic3r/package/osx/startup_script.sh`
- Packaged Linux entry: `packages/legacy-slic3r/package/linux/startup_script.sh`
- Packaged Windows wrapper: `packages/legacy-slic3r/package/common/shell.cpp`
- Current trusted oracle touchpoint: `//:legacy_oracle_smoke`
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Broad six-row parity matrix only. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md] | Keep the matrix as a dashboard and add a detailed evidence-backed contract inventory. [ASSUMED] | Phase 04 planning, after Phase 3 left user-visible parity surfaces legacy-only. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/README.md; ASSUMED] | Later phases can target exact contract items without rereading the full legacy tree. [ASSUMED] |
| Generic “legacy oracle” wording. [ASSUMED] | Explicit distinction between trusted `//:legacy_oracle_smoke`, deferred `//:legacy_oracle_test`, and source-only evidence. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_oracle.sh] | Phase 2 introduced the narrow trusted oracle; Phase 04 should carry that distinction into every contract row. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; ASSUMED] | Prevents the inventory from overstating parity confidence. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] |
| Package boundaries discussed separately from contracts. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md] | Contract docs link each surface to both the current legacy source and the future owning package or phase. [ASSUMED] | Phase 04 planning. [ASSUMED] | Contributors can see what exists today and who should own migration work later. [ASSUMED] |

**Deprecated/outdated:**

- Treating `//:legacy_oracle_test` as the trusted parity signal is outdated because current docs explicitly mark it as the deferred broader retained test surface. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md]
- Treating packaging-visible behavior as one undifferentiated “package scripts” row is too weak for planning because macOS, Linux, and Windows packaging artifacts expose different launcher and artifact behavior. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/make_dmg.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/make_archive.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/win/package_win32.ps1]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The cleanest Phase 04 doc split is `docs/port/contract-inventory.md` plus `docs/port/migration-guidance.md` instead of overloading existing files. [ASSUMED] | Summary; Architecture Patterns | Low. The same content can be redistributed into existing docs if reviewers prefer fewer files. |
| A2 | `parity-matrix.md` should remain a dashboard and not become the exhaustive registry. [ASSUMED] | Summary; Standard Stack; Architecture Patterns | Medium. If reviewers want one-file docs, the matrix may need a heavier redesign. |
| A3 | A single guidance document can hold launcher replacement, parity strategy, fixture protocol, and scope/deferred guidance without becoming too large. [ASSUMED] | Architecture Patterns; Open Questions | Low. The guidance can be split later if it loses scanability. |
| A4 | For config semantics, Phase 04 should inventory option families and high-signal behaviors now rather than enumerate every individual option exhaustively. [ASSUMED] | Open Questions | Medium. If maintainers expect per-option detail immediately, the documentation scope grows substantially. |

## Open Questions

1. **Should the guidance stay in one file or split by topic?** [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

   - What we know: Locked context allows “one or two new docs under `docs/port/`.” [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]
   - What's unclear: Whether reviewers want one onboarding path or smaller topic-specific docs. [ASSUMED]
   - Recommendation: Start with one `migration-guidance.md` and split only if the content becomes hard to scan. [ASSUMED]

1. **How deep should config-semantics extraction go in Phase 04?** [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/lib/Slic3r/Config.pm]

   - What we know: `Slic3r::Config` loads/saves INI, overlays CLI values, normalizes values, and validates many options today. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/lib/Slic3r/Config.pm; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl]
   - What's unclear: Whether the phase should document every individual option or only the exported config families and key semantic rules. [ASSUMED]
   - Recommendation: Capture config families, format/load/save semantics, and validation hot spots now; leave exhaustive per-option catalogs to later CLI/config implementation phases. [ASSUMED]

1. **How should non-macOS packaging surfaces be treated in a macOS-first milestone?** [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]

   - What we know: Packaging scripts exist for macOS, Linux, and Windows, and packaging-visible behavior is explicitly part of PARI-01. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/make_dmg.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/make_archive.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/win/package_win32.ps1; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]
   - What's unclear: Whether reviewers expect equal documentation depth across platforms in Phase 04. [ASSUMED]
   - Recommendation: Inventory all three platform packaging surfaces now, but mark Linux and Windows migration work deferred outside the initial milestone. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; ASSUMED]

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Markdown content review plus check-mode `mdformat`; no repo-owned docs verifier is present. \[VERIFIED: local command `mdformat --version`; VERIFIED: local search `rg -n "markdownlint|mdformat|prettier|shfmt|verify|check|validate|ci" .github scripts tools docs packages`; CITED: https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md\] |
| Config file | none detected. \[VERIFIED: local command `for f in .pre-commit-config.yaml .pre-commit-config.yml lefthook.yml package.json justfile Justfile Makefile .husky/pre-commit; do if [ -e "$f" ]; then echo "FOUND $f"; fi; done`\] |
| Quick run command | `mdformat --check docs/port/*.md && rg -n "CLI behavior|Config semantics|Supported file formats|Generated outputs|Launcher path|Packaging-visible behavior" docs/port/contract-inventory.md` once the file exists. \[VERIFIED: local command `mdformat --version`; ASSUMED\] |
| Full suite command | `mdformat --check docs/port/*.md && rg -n "Launcher Replacement|Parity Strategy|Fixture Update Protocol|Scope Now vs Deferred" docs/port/migration-guidance.md docs/port/README.md` once the files exist. \[VERIFIED: local command `mdformat --version`; ASSUMED\] |

### Phase Requirements -> Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PARI-01 | Inventory enumerates all six exported parity surface families and gives each a repo-anchored evidence model. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | manual docs review + grep smoke | `rg -n "CLI behavior|Config semantics|Supported file formats|Generated outputs|Launcher path|Packaging-visible behavior" docs/port/contract-inventory.md` [ASSUMED] | ❌ Wave 0 |
| DOCS-03 | Contributors can find launcher replacement, parity strategy, monorepo layout, and fixture update guidance in `docs/`. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md] | manual docs review + grep smoke | `rg -n "Launcher Replacement|Parity Strategy|Fixture Update Protocol" docs/port/migration-guidance.md && rg -n "package map|layout" docs/port/README.md docs/port/package-map.md` [ASSUMED] | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** `mdformat --check` on changed Markdown files plus targeted `rg` checks for required headings and surface families. \[VERIFIED: local command `mdformat --version`; CITED: https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md; ASSUMED\]
- **Per wave merge:** rerun the same checks across all `docs/port/*.md` files touched by the phase. [ASSUMED]
- **Phase gate:** Required docs exist, required headings/surface families are present, and the wording keeps deferred surfaces explicit. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]

### Wave 0 Gaps

- [ ] `docs/port/contract-inventory.md` - covers PARI-01. [ASSUMED]
- [ ] `docs/port/migration-guidance.md` - covers launcher replacement, parity strategy, fixture update protocol, and scope/deferred guidance for DOCS-03. [ASSUMED]
- [ ] No repo-owned docs verification entrypoint exists; use `mdformat --check` and targeted `rg` content checks for this phase. \[VERIFIED: local search `rg -n "markdownlint|mdformat|prettier|shfmt|verify|check|validate|ci" .github scripts tools docs packages`; VERIFIED: local command `mdformat --version`; ASSUMED\]

## Security Domain

This phase is documentation-only and does not introduce runtime auth, session, access-control, validation, or cryptography code. The main security-adjacent risk is misleading migration documentation that causes operators or contributors to over-trust parity claims. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | n/a for docs-only phase. [VERIFIED: same source] |
| V3 Session Management | no. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | n/a for docs-only phase. [VERIFIED: same source] |
| V4 Access Control | no. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | n/a for docs-only phase. [VERIFIED: same source] |
| V5 Input Validation | no runtime change. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | use evidence-backed doc tables and explicit deferred labeling to avoid false claims. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED] |
| V6 Cryptography | no. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | n/a for docs-only phase. [VERIFIED: same source] |

### Known Threat Patterns for Documentation-Only Contract Work

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Overstated parity claim in migration docs. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | Tampering | Require file/command anchors and separate trusted-versus-deferred evidence columns. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED] |
| Launcher guidance that preserves implementation mechanics instead of the user-facing contract. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md] | Spoofing | Document the launch contract in terms of user-visible entrypoints and packaged launch artifacts, not “keep Perl.” [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/common/shell.cpp; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/startup_script.sh; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/startup_script.sh] |

## Sources

### Primary (HIGH confidence)

- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md` - locked scope, evidence model, and deferred-state rules. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/REQUIREMENTS.md` - requirement mapping for PARI-01 and DOCS-03. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/.planning/STATE.md` - current phase position and prior phase outputs. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md` - control-plane role, status vocabulary, and current trusted/deferred oracle wording. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/parity-matrix.md` - current coarse parity surface taxonomy. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md` - current docs, launcher, parity-fixture, and automation gaps. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md` - package roles and placeholder boundaries. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/slic3r.pl` - CLI behavior, help text, export modes, and output semantics. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/lib/Slic3r/Config.pm` - config load/save, CLI overlay, normalization, and validation semantics. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/src/test/GUI/test_cli.cpp` - richer but weaker CLI/output evidence. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/utils/zsh/functions/_slic3r` - CLI option vocabulary cross-check. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/osx/make_dmg.sh` - macOS packaging-visible behavior. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/linux/make_archive.sh` - Linux packaging-visible behavior. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/win/package_win32.ps1` - Windows packaging-visible behavior. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r/package/common/shell.cpp` - packaged launcher-wrapper behavior. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_smoke.sh` - exact trusted smoke oracle behavior today. [VERIFIED]
- `/Users/peterryszkiewicz/Repos/Slic3r/tools/bazel/legacy/test_legacy_oracle.sh` - exact deferred broader oracle behavior today. [VERIFIED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/index.md` - standards hierarchy and rule levels. [CITED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/architecture.md` - separation of core decisions from adapters. [CITED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/code-shape.md` - early returns, `maybe` naming, and docs/script structure expectations. [CITED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/verification.md` - changed-path verification guidance and optional Markdown formatter checks. [CITED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/core/testing.md` - phase-validation expectations for explicit, focused checks. [CITED]
- `https://raw.githubusercontent.com/bright-builds-llc/coding-and-architecture-requirements/9d81debbcc0c228fc75388281d9a480503fc3878/standards/languages/rust.md` - repo language guidance, mainly relevant for later Rust ownership of inventoried contracts. [CITED]

### Secondary (MEDIUM confidence)

- None. The research did not need non-official external sources. [VERIFIED: this research session]

### Tertiary (LOW confidence)

- None. All low-confidence recommendations are marked `[ASSUMED]` inline and listed in the assumptions log. [VERIFIED: this document]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - the recommended stack is almost entirely the repo’s existing docs/control-plane surface and concrete local evidence anchors, with little ecosystem ambiguity. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/packages/legacy-slic3r]
- Architecture: MEDIUM - the document split and table shape are evidence-backed and fit the locked scope, but exact filenames and granularity remain discretionary design choices. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md; ASSUMED]
- Pitfalls: HIGH - the main pitfalls come directly from current repo gaps and the locked requirement to avoid overstating parity. [VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/README.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md; VERIFIED: /Users/peterryszkiewicz/Repos/Slic3r/.planning/phases/04-contract-inventory/04-CONTEXT.md]

**Research date:** 2026-04-08
**Valid until:** 2026-05-08 for current repo structure and docs-state assumptions. [ASSUMED]
