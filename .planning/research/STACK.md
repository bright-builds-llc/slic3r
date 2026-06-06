# Stack Research

**Domain:** Narrow PrusaSlicer G-code output evidence slice for an existing
Rust/Bazel Slic3r port
**Researched:** 2026-06-06
**Confidence:** HIGH for stack choices verified in local files; MEDIUM for
final fixture/source details until the v1.12 scope gate selects the exact
G-code fixture.

## Recommendation

Do not add a new technology stack for v1.12. Reuse the v1.10/v1.11 evidence
chain: source-pinned Prusa fixture, package-local fixture verifier, pure Rust
typed summary boundary in `slic3r_flavors`, public fail-closed Bazel parity
command in `packages/parity`, exact status row in `packages/parity/status.tsv`,
and non-overclaiming docs.

The only stack additions should be new repo-owned packages, files, and Bazel
targets for the G-code slice. The Rust implementation should be std-only and
line-oriented. A `.gcode` fixture is plain text, so v1.12 does not need a
third-party G-code parser, geometry library, slicer runtime, printer simulator,
ZIP/XML dependency, upstream source import, or generated-output execution path.

Use `prusaslicer.gcode-output` as the recommended stable evidence slug unless
the scope gate chooses a stricter inventory-derived slug. Use
`fork.prusaslicer.gcode-output` as the planned status token only after the
parity command exists and passes. Do not mark `prusaslicer.arc-fitting`,
`prusaslicer.wall-seam`, or `prusaslicer.support-generation` verified from this
slice; the local inventory says those future rows require separate G-code,
geometry, or output fixtures.

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Bazel/Bazelisk | Bazel 8.6.0 pinned in `.bazelversion` | Top-level build, test, fixture, and parity orchestration | This is the repo's existing control plane and all prior parity slices publish Bazel commands. |
| Bzlmod + `rules_rust` | `rules_rust` 0.69.0 in `MODULE.bazel` | Rust library, binary, test, clippy, and rustfmt targets | The Rust workspace already uses these rules for `slic3r_flavors` and Prusa summary helpers. |
| Rust | 1.94.1, edition 2024 | Typed summary boundary for G-code fixture metadata and markers | Matches the pinned workspace toolchain and keeps boundary data parsed into domain types. |
| `slic3r_flavors` crate | Existing workspace crate, 0.1.0 | Add `prusa_gcode_output` module, tests, and summary binary | v1.10/v1.11 already use this crate for Prusa profile and project-file evidence without vendor-specific workspaces. |
| `slic3r_contracts` crate | Existing workspace crate, 0.1.0 | Reuse `VendorSourceRef`, `FlavorId`, `FeatureOrigin`, `ParitySurface`, and status vocabulary | Prevents raw source/status strings from leaking through the Rust boundary. |
| Bash `sh_binary` / `sh_test` wrappers | Existing repo pattern | Fixture verification, parity comparison, and mutation failure guard | Existing Prusa parity commands are thin shell adapters around pure Rust summary binaries. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Rust standard library | Rust 1.94.1 | Read text fixtures, split lines/columns, validate exact markers, emit TSV summary lines | Use for all v1.12 Rust logic. No third-party crate is justified for a summary-only `.gcode` fixture. |
| `slic3r_contracts` | 0.1.0 | Typed source, flavor, origin, and parity-surface metadata | Use in the new `prusa_gcode_output` metadata API. |
| POSIX shell tools | Repo-local shell pattern | `diff`, `awk`, `grep`, `wc`, `shasum` fixture and parity checks | Use only in thin verifiers/comparators; keep parsing decisions in Rust or exact fixture guards. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `bazel run //packages/prusa-gcode-output-scope:verify` | Proposed scope-gate verifier | Mirror `packages/prusa-project-file-scope`; it should create no fixture bytes, Rust parser, parity target, or status row. |
| `bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture` | Proposed fixture verifier | Check fixture size, SHA-256, line endings, provenance, update route, expected summary shape, and deferred wording. |
| `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test` | Proposed focused Rust unit tests | Validate accepted markers, rejected unexpected markers, duplicate/missing rows, and non-overclaiming summary output. |
| `bazel run //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary -- <fixture.gcode>` | Proposed Rust summary helper | Reads the raw source-pinned `.gcode` fixture and emits deterministic summary TSV lines. |
| `bazel run //packages/parity:prusaslicer_gcode_output_parity` | Proposed public parity command | Diff Rust summary output against `expected-gcode-summary.tsv` and fail closed on drift. |
| `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test` | Proposed mutation guard | Mutate one expected marker row and require the comparator to fail with a labeled diff. |
| `bazel test //packages/slic3r-rust:verify` | Existing Rust package verification | Add the new Rust test and summary target to the existing clippy/rustfmt/verify lists. |
| `bazel run //packages/parity:status` | Existing status visibility command | Confirm exactly one `fork.prusaslicer.gcode-output` row only after executable evidence exists. |

## Installation

No package installation or new dependency command is needed.

```bash
# Keep using the repo-pinned toolchain.
bazel test //packages/slic3r-rust:verify

# Do not add crates for this milestone.
# Do not run cargo add, npm install, or introduce a new external repository.
```

## Stack Additions By Package

| Package | Add | Why |
|---------|-----|-----|
| `packages/prusa-gcode-output-scope` | Scope record, README, `verify_prusa_gcode_output_scope.sh`, Bazel `verify` target | v1.11 showed that a reviewed scope gate prevents fixture/parser/status work from overclaiming broad runtime or output parity. |
| `packages/parity-fixtures` | `forks/prusaslicer/prusaslicer.gcode-output/` namespace with one `.gcode` fixture, `.gitattributes`, `README.md`, `fixture-provenance.tsv`, `expected-gcode-summary.tsv`, filegroup/aliases, verifier, verifier test | Keeps Prusa fixture evidence under the established fork fixture namespace and separate from base `export-workflows` fixtures. |
| `packages/slic3r-rust/crates/slic3r_flavors` | `src/prusa_gcode_output.rs`, `src/bin/prusa_gcode_output_summary.rs`, `tests/prusa_gcode_output.rs`, `lib.rs` exports, `BUILD.bazel` target entries | Reuses the proven pure Rust fork/flavor evidence boundary instead of creating a Prusa-specific workspace or touching core slicer logic. |
| `packages/parity` | `compare_prusaslicer_gcode_output.sh`, failure test, `prusaslicer_gcode_output_parity` target, exact status row after pass | Keeps public executable evidence and visibility in the package that already owns parity commands and `status.tsv`. |
| `docs/port` and package READMEs | Update `README.md`, `package-map.md`, `migration-guidance.md`, `parity-matrix.md`, and likely `contract-inventory.md` | Docs must name the exact verified slice and keep byte-for-byte generation, runtime, geometry, and GUI claims deferred. |

## Expected Artifact Shape

Use a summary-only TSV artifact, not a copied whole-output oracle. Recommended
path:

```text
packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv
```

Recommended columns:

```text
source_ref	fixture_path	marker_key	marker_value	evidence_kind	deferred_semantics	notes
```

The Rust boundary should parse the raw `.gcode` fixture and emit deterministic
summary lines. The expected artifact should record only stable metadata and
marker evidence selected by the scope gate, such as generator/version comments,
print/profile metadata comments, and bounded start/end markers if they are
stable in the chosen fixture. Avoid line-number assertions, extrusion path
counts, coordinates, timing estimates, support/toolpath semantics, or any
marker that would imply byte-for-byte output or printer-runtime parity.

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Std-only Rust line scanner | Third-party G-code parser crate | Only in a later milestone that deliberately models G-code semantics beyond stable summary markers. |
| Checked-in Prusa-generated fixture | Generate G-code during the parity command | Use live generation only in a future generated-output parity milestone with explicit runtime, config, geometry, and printer behavior scope. |
| Summary-only expected artifact | Byte-for-byte `.gcode` output diff | Use byte-for-byte diff only after the project is ready to claim a much broader generated-output surface. |
| `slic3r_flavors::prusa_gcode_output` | New Prusa-only Rust crate/workspace | Use a separate crate only if multiple Prusa runtime modules create real dependency or ownership pressure. v1.12 does not. |
| Fork fixture namespace | Existing `export-workflows` fixture directory | Use `export-workflows` only for base Slic3r launcher/export slices; v1.12 is a source-pinned Prusa evidence slice. |
| Shell as thin comparator/verifier | Shell as the parser | Keep shell to file checks and diffs; put marker interpretation into typed Rust values. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| New Rust crates for G-code parsing, geometry, slicing, or printer simulation | The milestone only needs stable text metadata and markers; new dependencies would imply broader semantics than the slice can prove. | Rust standard library plus typed enums/newtypes. |
| PrusaSlicer upstream source submodule, vendored source tree, Git clone, or network fetch in verification | v1.10/v1.11 use source pins and checked-in fixtures; verification must be rerunnable offline and fail closed. | Checked-in fixture bytes with provenance, size, SHA-256, line-ending, and update-route guards. |
| `packages/launcher` or `--export-gcode` generation path | That would turn the milestone into runtime output generation evidence. | Read one reviewed Prusa-generated `.gcode` fixture and summarize it. |
| Byte-for-byte generated-output parity | The milestone explicitly avoids broad generated-output parity. | Compare Rust summary output to `expected-gcode-summary.tsv`. |
| Arc fitting, wall seam, support-generation, STEP, 3MF import/export, or GUI integration libraries | Local inventory marks these as separate future candidate surfaces. | Keep v1.12 to one G-code metadata/marker evidence slice. |
| New Bazel macros or package architecture | Existing `exports_files`, `alias`, `filegroup`, `sh_binary`, `sh_test`, `rust_library`, `rust_binary`, and `rust_test` are enough. | Extend current BUILD files in the same style as v1.10/v1.11. |
| Updating broad `generated-outputs` to `verified` | The status matrix says generated outputs are still in progress and content/geometry parity is deferred. | Add one exact `fork.prusaslicer.gcode-output` row after the command passes. |

## Stack Patterns by Variant

**If the selected fixture is a plain `.gcode` text file:**

- Use a std-only Rust scanner over caller-supplied fixture text.
- Emit summary rows for exact markers and bounded metadata only.
- Compare to `expected-gcode-summary.tsv` through a shell parity wrapper.

**If the selected fixture requires decompression, Prusa runtime execution, or
source checkout to inspect:**

- Reject it for v1.12 and choose a smaller reviewed text fixture.
- This milestone should not add ZIP/XML/runtime/source-fetch dependencies.

**If roadmap planning wants a source inventory token:**

- Add one narrow `prusaslicer.gcode-output` planning row with
  `parity_dependency` set to `generated-outputs` and future notes limited to
  summary-only G-code evidence.
- Do not repurpose `prusaslicer.arc-fitting`, `prusaslicer.wall-seam`, or
  `prusaslicer.support-generation`.

**If later phases want output behavior claims:**

- Start a separate milestone with new requirements, fixture contracts, and
  parity commands.
- Keep byte-for-byte output, generation, printer runtime, geometry, support,
  seam, and arc claims out of v1.12 docs/status.

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| Bazel 8.6.0 | `rules_rust` 0.69.0 | Verified from `.bazelversion` and `MODULE.bazel`; keep BUILD additions in existing rule style. |
| `rules_rust` 0.69.0 | Rust 1.94.1 / edition 2024 | `MODULE.bazel` pins the Rust toolchain and rustfmt version. |
| Rust workspace resolver 3 | `slic3r_flavors` 0.1.0 and `slic3r_contracts` 0.1.0 | `Cargo.toml` and `Cargo.lock` show only internal workspace crates; no external Rust dependencies are present. |
| `packages/parity` shell wrappers | `slic3r_flavors` summary binaries | Existing Prusa parity commands pass a Rust summary binary plus expected/provenance artifacts into a thin comparator. |
| `packages/parity-fixtures` fork namespace | `packages/parity/status.tsv` | Fixture verifiers already guard exact status rows for Prusa profile/project-file slices. |

## Sources

- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo
  workflow, Bright Builds routing, and local phase-summary guidance.
- Bright Builds pinned standards at commit
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - architecture, code shape,
  verification, testing, and Rust guidance.
- `.planning/PROJECT.md`, `.planning/MILESTONES.md`,
  `.planning/milestones/v1.11-ROADMAP.md` - v1.12 goal, active requirements,
  v1.10/v1.11 evidence chain, and pending G-code decision.
- `.bazelversion`, `MODULE.bazel`, `packages/slic3r-rust/Cargo.toml`,
  `packages/slic3r-rust/Cargo.lock` - pinned Bazel, rules_rust, Rust, edition,
  workspace, and dependency state.
- `packages/slic3r-rust/README.md`,
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`,
  `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`,
  `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs` -
  existing typed Prusa summary boundary pattern.
- `packages/parity/README.md`, `packages/parity/BUILD.bazel`,
  `packages/parity/status.tsv`,
  `packages/parity/compare_prusaslicer_project_file.sh`,
  `packages/parity/compare_prusaslicer_project_file_test.sh` - parity command,
  status, and mutation guard pattern.
- `packages/parity-fixtures/README.md`,
  `packages/parity-fixtures/BUILD.bazel`,
  `packages/parity-fixtures/verify_prusa_project_file_fixture.sh`,
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/*` -
  fork fixture namespace, provenance, expected-summary, and fail-closed fixture
  verification pattern.
- `packages/fork-inventories/prusaslicer.tsv`,
  `docs/port/README.md`, `docs/port/package-map.md`,
  `docs/port/migration-guidance.md`, `docs/port/parity-matrix.md`,
  `docs/port/contract-inventory.md` - inventory, package boundaries, docs
  surfaces, and deferred generated-output scope.

______________________________________________________________________

*Stack research for: v1.12 PrusaSlicer G-code Output Evidence Foundation*
*Researched: 2026-06-06*
