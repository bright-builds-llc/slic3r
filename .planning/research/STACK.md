# Stack Research

**Domain:** Slic3r Rust port fork vendor intake and module architecture
**Researched:** 2026-05-26
**Confidence:** HIGH for stack decisions, MEDIUM for later feature taxonomy

## Recommended Stack

v1.9 should add a small manifest-and-module layer on top of the existing
Bazel/Rust stack. It should not ingest, build, or periodically sync the full
PrusaSlicer, Bambu Studio, or OrcaSlicer source trees yet. The fork source
relationship is large, C++-heavy, AGPL-licensed, and actively moving; v1.9 needs
stable references and comparison structure, not another build system inside the
monorepo.

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Bazel + Bzlmod | Bazel 8.6.0, repo-pinned | Keep the existing top-level monorepo build/test entrypoint | The repository already validates Rust, launcher, parity, and release-package surfaces through Bazel. v1.9 should add Bazel targets for manifest validation and any new Rust crate, not introduce a parallel runner. |
| `rules_rust` | 0.69.0, repo-pinned | Build and test Rust crates through Bazel | The current Rust package already uses `rust_library`, `rust_binary`, `rust_test`, `rust_clippy`, and `rustfmt_test`. Keep this path and add the new flavor registry crate to `//packages/slic3r-rust:verify`. |
| Rust stable | 1.94.1, edition 2024, repo-pinned | Define typed fork/flavor boundaries | The existing workspace is dependency-free and AGPL-3.0-or-later. v1.9 can add typed metadata for flavor IDs, source pins, and feature scopes without external crates or unsafe code. |
| Git CLI | Git 2.x, verified against current upstream refs | Verify pinned upstream release tags and optional local source checkouts | Git is the primary source-control interface for all three upstreams. Use `git ls-remote` for CI-safe pin checks and optional local clones for human inventory work. |
| TSV manifest | Repo-owned, no external version | Machine-readable fork source registry | This repo already uses TSV for `packages/parity/status.tsv`. A TSV fork manifest keeps shell validation simple and avoids adding TOML/JSON parsing dependencies for v1.9. |
| Markdown inventory templates | Repo-owned | Human-readable feature inventories and parity checklist templates | Feature classification needs reviewer judgment. Markdown templates give roadmap and implementation phases a stable checklist without pretending the inventory is executable parity evidence. |
| `slic3r_flavors` Rust crate | New crate, std-only | Typed Rust module boundary for fork/flavor metadata | One shared crate avoids three forked Rust workspaces. It can define `ForkFlavor`, `VendorSource`, `FeatureScope`, and checklist metadata while keeping fork-specific implementation out of `slic3r_core`. |

### Pinned Vendor Source Baseline

Use latest stable upstream releases as the v1.9 intake baseline. Record branch
HEAD separately as drift context, not as the canonical parity target.

| Fork | Canonical repository | Stable release pin | Peeled commit | Branch HEAD observed | License |
|------|----------------------|--------------------|---------------|----------------------|---------|
| PrusaSlicer | `https://github.com/prusa3d/PrusaSlicer.git` | `version_2.9.5`, released 2026-05-19 | `9a583bd438b195856f3bcf7ea99b69ba4003a961` | `master` at `9a583bd438b195856f3bcf7ea99b69ba4003a961` | AGPL-3.0 |
| Bambu Studio | `https://github.com/bambulab/BambuStudio.git` | `v02.06.00.51`, released 2026-04-17 | `b506005bc4ee62124e24bf00e0f58656db3646a6` | `master` at `e150b502b3d2afc98b83dcc9e5720e998f9eb79a` | AGPL-3.0, with optional non-free networking plugin noted upstream |
| OrcaSlicer | `https://github.com/OrcaSlicer/OrcaSlicer.git` | `v2.3.2`, released 2026-03-23 | `c724a3f5f51c52336624b689e846c8fbc943a912` | `main` at `398e007f2ec567ea56d3993864d03f52b210cbf3` | AGPL-3.0, with optional Bambu networking plugin noted upstream |

PrusaSlicer and Bambu Studio use annotated release tags, so the manifest should
store both the tag object and the peeled commit when practical. The peeled
commit is the source snapshot reviewers actually compare.

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Rust standard library | 1.94.1 | Parse small in-repo metadata and expose flavor domain types | Use for `slic3r_flavors`; do not add `serde`, `toml`, `git2`, or parser crates for the v1.9 metadata scale. |
| Bash | System shell, `set -euo pipefail` | Verify fork pins and local source-cache presence | Use for a thin `verify_vendor_pins.sh` wrapped by Bazel. Keep it line-oriented and diagnostic-heavy. |
| Git `ls-remote` | Git CLI | Confirm remote tag and commit pins without cloning large repos | Use in CI or local verification for the manifest. This is enough for v1.9 because no fork source is a build input yet. |
| Git partial clone | Git CLI with `--filter=blob:none` | Optional local source cache for inventory authors | Use only for local human research under a gitignored cache such as `.vendor/forks/`; do not make this cache part of Bazel inputs. |
| Existing parity fixture model | Repo-owned | Future fork parity checklist and fixture naming alignment | Use the same surface-first naming strategy as `packages/parity-fixtures`, but add templates only in v1.9. Do not add fork fixtures until executable fork behavior exists. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `//packages/fork-vendors:verify` | New Bazel `sh_test` for source manifest checks | Should read a checked-in TSV manifest and verify each release tag resolves to the recorded commit. It should not clone or build the upstream repos. |
| `//packages/slic3r-rust:verify` | Existing Rust package verification suite | Add `slic3r_flavors` rustfmt, clippy, and unit tests to this suite when the crate is created. |
| `git diff --check` | Markdown whitespace sanity check | Relevant because v1.9 is mostly docs/data. Do not run `mdformat` on phase summaries, per repo-local guidance. |
| `bazel run //packages/parity:status` | Existing parity visibility command | Keep base parity status as-is. Add fork status rows only after fork-backed behavior exists; v1.9 inventories are not parity proof. |
| `packages/parity-fixtures/README.md` workflow | Fixture provenance model | Reuse its provenance expectations for future fork fixtures and checklist templates. |

## Recommended Repository Additions

### Fork Vendor Intake Package

Add a small data package rather than checked-out upstream source trees:

```text
packages/fork-vendors/
  BUILD.bazel
  README.md
  forks.tsv
  verify_vendor_pins.sh
```

Recommended `forks.tsv` columns:

```text
fork	repo_url	default_branch	release_tag	tag_object	peeled_commit	license_spdx	observed_branch_head	observed_at_utc	notes
```

This keeps vendor intake reproducible while avoiding submodule checkout cost.
The manifest should be the canonical source for roadmap and docs references.

### Fork Inventory Docs

Add fork docs under the existing port control plane:

```text
docs/port/forks/
  README.md
  feature-inventory-template.md
  parity-checklist-template.md
  prusa-feature-inventory.md
  bambu-feature-inventory.md
  orca-feature-inventory.md
  shared-downstream-feature-inventory.md
```

Use a three-way feature scope in every inventory row:

```text
base-slic3r | shared-downstream | fork-specific
```

This is the key v1.9 taxonomy. It prevents future phases from treating every
downstream feature as a fork-specific module and prevents shared Bambu/Orca
behavior from being copied twice.

### Rust Flavor Registry Crate

Add one crate now:

```text
packages/slic3r-rust/crates/slic3r_flavors/
  BUILD.bazel
  Cargo.toml
  src/lib.rs
  src/base.rs
  src/prusa.rs
  src/bambu.rs
  src/orca.rs
  tests/flavor_registry.rs
```

Initial responsibilities:

- Define stable flavor IDs: `BaseSlic3r`, `PrusaSlicer`, `BambuStudio`,
  `OrcaSlicer`.
- Define feature scopes: `Base`, `SharedDownstream`, `ForkSpecific`.
- Define typed source-pin metadata mirroring `packages/fork-vendors/forks.tsv`.
- Define checklist status values for docs and future parity work.
- Expose pure functions only; no filesystem, network, or Git calls inside this
  crate.

Keep `slic3r_core` base-only. Let future fork implementation modules depend on
shared core behavior, not the other way around. Let `slic3r_cli` depend on
`slic3r_flavors` only when the CLI actually needs flavor selection.

## Installation

No new package manager or external dependency installation is needed for v1.9.
Use the existing repo toolchain.

```bash
# Existing repo pins to keep
cat .bazelversion
cat MODULE.bazel
cat packages/slic3r-rust/Cargo.toml

# Verify release pins without cloning upstream repositories
git ls-remote https://github.com/prusa3d/PrusaSlicer.git refs/tags/version_2.9.5 'refs/tags/version_2.9.5^{}'
git ls-remote https://github.com/bambulab/BambuStudio.git refs/tags/v02.06.00.51 'refs/tags/v02.06.00.51^{}'
git ls-remote https://github.com/OrcaSlicer/OrcaSlicer.git refs/tags/v2.3.2 'refs/tags/v2.3.2^{}'
```

Optional local source-cache command shape for inventory authors:

```bash
git clone --filter=blob:none --no-checkout https://github.com/prusa3d/PrusaSlicer.git .vendor/forks/prusa
git -C .vendor/forks/prusa checkout 9a583bd438b195856f3bcf7ea99b69ba4003a961
```

If this helper is implemented, add `.vendor/forks/` to `.gitignore`. The cache
must stay local and must not become a Bazel input in v1.9.

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| TSV manifest plus `git ls-remote` verification | Git submodules for the three upstream repos | Use submodules only when upstream source trees become regular, intentional checkout inputs. For v1.9, submodules add clone cost and checkout state without improving inventory quality. |
| Stable release tags as canonical pins | Default branch HEADs | Use branch HEADs only for drift notes or exploratory research. Roadmap phases need reproducible baselines. |
| One `slic3r_flavors` crate | Three immediate crates: `slic3r_prusa`, `slic3r_bambu`, `slic3r_orca` | Split later when fork behavior becomes large enough to need separate ownership or dependencies. In v1.9, separate crates would mostly encode names, not behavior. |
| Markdown feature inventories | Generated inventories from upstream source scans | Use generation later if inventories become repetitive and stable. Initial classification requires human judgment across base/shared/fork-specific behavior. |
| Existing Bazel `sh_test` pattern | New Python/Node/Rust intake CLI | Add a real CLI only if the manifest validation grows beyond line-oriented checks. v1.9 does not justify another toolchain surface. |
| Keep upstream source outside Bazel | `rules_foreign_cc`, CMake, or Bzlmod external repositories for downstream slicers | Use build ingestion only in future full parity implementation phases. v1.9 is not compiling PrusaSlicer, Bambu Studio, or OrcaSlicer. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Git submodules for v1.9 fork intake | Git records submodule URLs in `.gitmodules` and updates working trees to superproject-recorded commits. That is useful for build inputs, but too heavy for documentation-first intake of three large C++ repositories. | Checked-in TSV pins plus optional gitignored local clones. |
| Vendored source copies or Git subtree imports | They would bloat the Rust-port repo, obscure provenance, and create merge pressure before any fork code is being built. | Manifest pins and source links. |
| Nightly sync automation | The milestone explicitly excludes nightly vendor sync. Automated movement before inventories and parity boundaries exist would turn drift into noise. | Manual, review-gated manifest updates. |
| Forked Rust workspaces or fork-specific binaries | They would recreate the downstream fork problem in Rust before the shared module architecture is proven. | A shared `slic3r_flavors` crate and base-owned `slic3r_core`. |
| New external Rust crates for manifest parsing | Current metadata fits TSV and pure stdlib parsing. Extra crates increase Bazel/Cargo lock maintenance without solving a real v1.9 problem. | Rust stdlib and shell validation. |
| Building upstream C++ fork repos in Bazel | That expands scope into toolchain, dependency, and GUI build problems unrelated to v1.9's intake and architecture deliverables. | Record release pins and classify features. |
| Importing Bambu/Orca optional networking plugins or binary assets | Upstreams explicitly note optional networking plugins based on non-free BambuLab libraries. v1.9 should not ingest non-free plugin code or binaries. | Record licensing notes and defer any network/printer integration decision. |

## Stack Patterns by Variant

**If recording a vendor source:**

- Add or update one row in `packages/fork-vendors/forks.tsv`.
- Store both tag identity and peeled commit when the upstream tag is annotated.
- Include license SPDX and an explicit observed date.
- Verify with `//packages/fork-vendors:verify`.

**If writing a feature inventory:**

- Use `docs/port/forks/feature-inventory-template.md`.
- Classify each feature as `base-slic3r`, `shared-downstream`, or
  `fork-specific`.
- Link to the source pin row, not to a moving branch URL.
- Mark uncertain classifications as research flags; do not turn them into Rust
  module decisions yet.

**If adding Rust module architecture:**

- Put flavor metadata in `slic3r_flavors`.
- Keep pure decision logic in Rust functions with unit tests.
- Follow the repo's Rust layout rule: use `foo.rs` plus `foo/` when a module
  grows into multiple files, not `foo/mod.rs`.
- Avoid feature flags for product forks until there is a real build matrix.

**If preparing future parity templates:**

- Add checklist templates in `docs/port/forks/`.
- Do not add fork parity rows to `packages/parity/status.tsv` until there is
  executable fork-backed behavior and evidence.
- Future fixture directories should live under `packages/parity-fixtures/forks/`
  by flavor and surface, but v1.9 should only define the template.

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| Bazel 8.6.0 | `rules_rust` 0.69.0 | Keep current repo pins. The v1.9 additions should be ordinary `sh_test`, `rust_library`, `rust_test`, `rust_clippy`, and `rustfmt_test` targets. |
| Rust 1.94.1 / edition 2024 | `slic3r_flavors` std-only crate | No new Cargo dependencies are needed. Preserve `#![forbid(unsafe_code)]`. |
| Current workspace license `AGPL-3.0-or-later` | Upstream fork sources reporting `AGPL-3.0` | Treat copied source or translated behavior as AGPL-governed. Do not assume optional plugin licensing is compatible without separate review. |
| PrusaSlicer `version_2.9.5` | Feature inventory baseline | Latest stable GitHub release observed 2026-05-26; release page identifies it as PrusaSlicer 2.9.5. |
| Bambu Studio `v02.06.00.51` | Feature inventory baseline | Latest stable GitHub release observed 2026-05-26; release page identifies it as 2.6.0 Public Release (Hotfix). |
| OrcaSlicer `v2.3.2` | Feature inventory baseline | Latest stable GitHub release observed 2026-05-26; `v2.4.0-alpha` exists but should not be the v1.9 baseline. |

## Sources

- Existing repo context: `.planning/PROJECT.md`, `.planning/MILESTONES.md`,
  `.planning/codebase/STACK.md`, `.planning/codebase/ARCHITECTURE.md`,
  `.planning/codebase/INTEGRATIONS.md`.
- Existing repo stack pins: `.bazelversion`, `MODULE.bazel`,
  `packages/slic3r-rust/Cargo.toml`, `packages/slic3r-rust/BUILD.bazel`.
- Existing parity/docs patterns: `packages/parity/status.tsv`,
  `packages/parity/BUILD.bazel`, `packages/parity-fixtures/BUILD.bazel`,
  `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`.
- PrusaSlicer official repository and release:
  `https://github.com/prusa3d/PrusaSlicer`,
  `https://github.com/prusa3d/PrusaSlicer/releases/tag/version_2.9.5`,
  `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/master/README.md`.
- Bambu Studio official repository and release:
  `https://github.com/bambulab/BambuStudio`,
  `https://github.com/bambulab/BambuStudio/releases/tag/v02.06.00.51`,
  `https://raw.githubusercontent.com/bambulab/BambuStudio/master/README.md`.
- OrcaSlicer official repository and release:
  `https://github.com/OrcaSlicer/OrcaSlicer`,
  `https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.3.2`,
  `https://raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/main/README.md`.
- Git submodule official docs:
  `https://git-scm.com/docs/git-submodule`.
- Bright Builds guidance used for recommendations:
  `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`,
  `standards/core/architecture.md`, `standards/core/code-shape.md`,
  `standards/core/testing.md`, `standards/core/verification.md`,
  `standards/languages/rust.md` at pinned commit
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676`.

---
*Stack research for: v1.9 fork vendor intake and module architecture*
*Researched: 2026-05-26*
