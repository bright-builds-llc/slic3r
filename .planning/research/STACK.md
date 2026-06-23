# Technology Stack

**Project:** Slic3r Rust Port v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice
**Researched:** 2026-06-23
**Mode:** Ecosystem, repo-local stack research
**Overall confidence:** HIGH for stack/package recommendations; MEDIUM for the exact arc fixture source until the Phase 57 scope contract selects the source-pinned fixture.

## Recommendation

Do not add a new external technology stack for v1.15. Arc-fitting evidence should reuse the existing Rust/Bazel/TSV/shell evidence ladder from v1.12-v1.14, but with a separate `prusaslicer.arc-fitting` boundary so it cannot accidentally widen the already verified `fork.prusaslicer.gcode-output` row.

The stack additions should be repo-owned files and Bazel targets only:

- a metadata-only arc-fitting scope package
- a Prusa arc-fitting fixture namespace under `packages/parity-fixtures`
- a pure `slic3r_flavors::prusa_arc_fitting` parser/readiness module and summary binary
- a public `packages/parity` command for `fork.prusaslicer.arc-fitting`
- exact status/docs updates that keep broad `generated-outputs` in progress

The Rust side should stay std-only and data-in/data-out. The fixture verifier can validate checked-in G-code bytes and exact arc markers, while the Rust boundary should parse caller-supplied expected-summary TSV into typed domain values. Do not run PrusaSlicer, clone upstream, port C++ ArcWelder, simulate firmware, or introduce a third-party G-code/geometry crate for this milestone.

## Current Stack Elements

| Element | Current State | v1.15 Use |
| --- | --- | --- |
| Bazel/Bazelisk | Bazel 8.6.0 pinned in `.bazelversion` | Keep as the top-level verifier and public evidence command surface. |
| Bzlmod + `rules_rust` | `rules_rust` 0.69.0 in `MODULE.bazel` | Reuse existing `rust_library`, `rust_binary`, `rust_test`, `rust_clippy`, and `rustfmt_test` patterns. |
| Rust toolchain | Rust 1.94.1, edition 2024, workspace resolver 3 | Add typed arc-fitting parser/readiness code inside `slic3r_flavors`; no new Rust workspace. |
| Bash `sh_binary` / `sh_test` | Existing package verifiers and parity comparators use `set -euo pipefail` shell scripts | Add thin scope, fixture, parity, and mutation guards; keep shell out of domain parsing beyond exact file/row checks. |
| TSV expected artifacts | Existing Prusa evidence slices use checked-in TSV expected summaries | Add `expected-arc-fitting-summary.tsv` with a closed schema and field set. |
| `slic3r_contracts` | Owns shared flavor/source/status/domain contract types | Reuse `VendorSourceRef`, `FlavorId`, `FeatureOrigin`, `ParitySurface`, and `ChecklistStatus`; do not add contracts unless implementation discovers a real missing invariant. |
| `slic3r_flavors` | Owns pure Prusa profile, project-file, and G-code output boundaries | Add `prusa_arc_fitting` module, tests, binary, exports, and registry metadata. |
| `packages/parity` | Owns public evidence commands and `status.tsv` | Add a new arc-fitting parity command and status row after executable evidence passes. |

## Recommended Stack

### Core Framework

| Technology | Version | Purpose | Why |
| --- | --- | --- | --- |
| Bazel/Bazelisk | 8.6.0 | Build/test/run orchestration | Existing parity, fixture, Rust, and scope work already publishes Bazel targets; v1.15 should remain one-command reproducible. |
| `rules_rust` | 0.69.0 | Rust target definitions and formatting/lint targets | Already drives `slic3r_flavors`; adding arc-fitting here avoids package drift. |
| Rust | 1.94.1, edition 2024 | Typed expected-summary parser/readiness boundary | Bright Builds guidance favors parsing raw boundary data into domain types and testing pure logic. |
| Bash | System shell through Bazel `sh_binary`/`sh_test` | Thin verifiers, comparators, and mutation guards | Existing repo-owned tools are shell adapters around checked-in files and Rust binaries. |

### Database

| Technology | Version | Purpose | Why |
| --- | --- | --- | --- |
| None | N/A | No persistence layer | Arc-fitting evidence is checked-in fixture and TSV data. A database would add state without improving the evidence contract. |

### Infrastructure

| Technology | Version | Purpose | Why |
| --- | --- | --- | --- |
| Checked-in fixture corpus | Source-pinned to `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | Arc-fitting G-code evidence input | Matches the v1.12-v1.14 offline fixture model and keeps verification deterministic. |
| `packages/parity/status.tsv` | Existing TSV status source | Publish exact `fork.prusaslicer.arc-fitting` evidence row | Fork rows become verified only after executable Bazel evidence exists. |
| `docs/port/*` | Existing port-progress docs | Publish narrow docs and deferrals | Docs must distinguish "G-code output row does not prove arc fitting" from "arc-fitting row proves only narrow arc evidence." |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
| --- | --- | --- | --- |
| Rust standard library | 1.94.1 | TSV parsing, line validation, deterministic summary output | Use for all arc-fitting Rust logic. |
| `slic3r_contracts` | Workspace crate 0.1.0 | Typed vendor/source/flavor/parity metadata | Use for source ref, flavor id, feature origin, and generated-output dependency metadata. |
| POSIX tools available to shell | Local environment | `awk`, `grep`, `diff`, `wc`, `shasum` style exact guards | Use in repo-owned verifiers/comparators only. Keep semantic parsing in Rust. |

## Repo-Owned Additions

| Package | Add or Change | Rationale |
| --- | --- | --- |
| `packages/prusa-arc-fitting-scope` | New metadata-only package with `arc-fitting-scope.md`, `README.md`, `verify_prusa_arc_fitting_scope.sh`, `verify_prusa_arc_fitting_scope_test.sh`, and `BUILD.bazel` | `prusaslicer.arc-fitting` is a distinct inventory row from `prusaslicer.gcode-output`; a dedicated scope gate prevents the new slice from widening the old status row. |
| `packages/parity-fixtures` | New namespace `forks/prusaslicer/prusaslicer.arc-fitting/` with `.gitattributes`, `README.md`, `fixture-provenance.tsv`, checked-in `.gcode` fixture, `expected-arc-fitting-summary.tsv`, aliases/filegroup, verifier, and verifier test | Keeps source-pinned arc G-code evidence under the existing fork fixture convention. |
| `packages/slic3r-rust/crates/slic3r_flavors` | Add `src/prusa_arc_fitting.rs`, `src/bin/prusa_arc_fitting_summary.rs`, `tests/prusa_arc_fitting.rs`, `lib.rs` exports, `BUILD.bazel` entries, and registry metadata | Reuses the pure metadata/parser crate without creating a Prusa-specific workspace or touching core slicer logic. |
| `packages/parity` | Add `compare_prusaslicer_arc_fitting.sh`, `compare_prusaslicer_arc_fitting_test.sh`, `prusaslicer_arc_fitting_parity`, and eventually a `fork.prusaslicer.arc-fitting` status row | Public executable evidence belongs in the existing parity package. |
| `docs/port` and package READMEs | Update parity matrix, package map/guidance as needed, fixture docs, Rust README, and status wording | Publication must be exact: broad `generated-outputs` remains `in progress`; byte parity, runtime, printability, GUI, release, sync, and non-Prusa behavior remain deferred. |
| `packages/prusa-gcode-output-scope` | Update only if wording would otherwise keep saying all arc fitting is deferred | Preserve the existing `fork.prusaslicer.gcode-output` meaning while pointing to the separate arc-fitting row once it exists. |

## Expected Artifact Shape

Recommended path:

```text
packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-fitting-summary.tsv
```

Recommended columns:

```text
source_ref	fixture_path	arc_field	arc_category	arc_value	evidence_boundary
```

Recommended closed field set:

| Field | Purpose | Boundary |
| --- | --- | --- |
| `source_ref` | Accepted PrusaSlicer source identity | Source identity only. |
| `inventory_source_path` | `src/libslic3r/Geometry/ArcWelder.cpp` | Source path only, not a source import. |
| `companion_test_path` | `tests/libslic3r/test_arc_welder.cpp` if selected by scope | Test/source trace only. |
| `fixture_id` | Stable fixture name | Fixture identity only. |
| `fixture_path` | Checked-in `.gcode` fixture path | Local checked-in artifact only. |
| `arc_fitting_config` | Optional `arc_fitting = emit_center` trace if the selected fixture depends on Prusa profile config | Config observation only, not proof of profile runtime behavior. |
| `arc_command_counts` | Counts of `G2` and `G3` commands in the selected fixture | Arc command evidence only, not geometry correctness. |
| `linear_command_counts` | Counts of relevant `G0`/`G1` context commands | Context only, not byte parity. |
| `arc_parameter_mode` | Presence of center offsets such as `I`/`J` or radius parameter `R` | Parameter-shape evidence only. |
| `coordinate_bounds` | Bounded X/Y/Z/I/J observations if approved by scope | Numeric observations only, not printability or tolerance proof. |
| `extrusion_observations` | E-axis presence/counts or totals if approved by scope | Fixture evidence only, not material-use correctness. |
| `feedrate_observations` | Feedrate values around arc commands | Metadata only, not timing or firmware behavior. |

The scope verifier should reject unsupported fields, duplicate/missing rows, out-of-order rows, broad generated-output claims, runtime/printability language, and non-Prusa fork language.

## Verification Targets

| Target | Owner | When It Should Pass |
| --- | --- | --- |
| `bazel run //packages/prusa-arc-fitting-scope:verify` | Scope package | After the reviewed `prusaslicer.arc-fitting` contract exists. |
| `bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test` | Scope package | With mutation coverage for unsupported claims and missing required rows. |
| `bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture` | Fixture package | After fixture bytes, provenance, expected summary, docs, and BUILD aliases exist. |
| `bazel test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test` | Fixture package | With fail-closed mutations for SHA/size/line drift, unsupported fields, duplicate/missing rows, provenance mismatch, and stale docs. |
| `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_test` | Rust crate | After the pure parser/readiness boundary exists. |
| `bazel run //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary -- <expected-arc-fitting-summary.tsv>` | Rust crate | Emits deterministic summary lines from caller-supplied checked-in TSV. |
| `bazel test //packages/slic3r-rust/crates/slic3r_flavors:clippy` | Rust crate | After adding the new module/binary/test to the existing clippy target. |
| `bazel test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check` | Rust crate | After adding the new module/binary/test to the existing rustfmt target. |
| `bazel run //packages/parity:prusaslicer_arc_fitting_parity` | Parity package | After public comparison validates fixture, Rust summary output, provenance, and exact status wording. |
| `bazel test //packages/parity:prusaslicer_arc_fitting_parity_failure_test` | Parity package | With mutation guards for arc command count drift, G2/G3 direction drift, parameter-mode drift, coordinate/feedrate drift, source/fixture identity drift, and unsupported claim text. |
| `bazel run //packages/parity:status` | Parity package | Shows exactly one `fork.prusaslicer.arc-fitting` row only after parity passes; leaves `generated-outputs` in progress. |

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
| --- | --- | --- | --- |
| Scope boundary | New `packages/prusa-arc-fitting-scope` package | Extend `packages/prusa-gcode-output-scope` only | Arc fitting has its own inventory row and source path; separate scope reduces overclaim risk. |
| Fixture namespace | `forks/prusaslicer/prusaslicer.arc-fitting/` | Add arc files to `prusaslicer.gcode-output/` | The old namespace proves the gcode-output ladder; v1.15 should publish a distinct arc-fitting row. |
| Rust boundary | New `slic3r_flavors::prusa_arc_fitting` module | Add `--arc-fitting` mode to `prusa_gcode_output_summary` | A dedicated module/binary keeps status, metadata, tests, and failure labels tied to `prusaslicer.arc-fitting`. |
| Parser dependencies | Std-only Rust parser | Add a G-code parser, geometry crate, or C++ ArcWelder port | The milestone compares checked-in evidence, not computed geometry or generated output. |
| Evidence source | Checked-in fixture and expected-summary TSV | Live PrusaSlicer generation | Live generation would introduce runtime/config/geometry scope that v1.15 explicitly defers. |
| Public status | New `fork.prusaslicer.arc-fitting` row | Promote broad `generated-outputs` or rewrite `fork.prusaslicer.gcode-output` | One narrow arc slice is not broad generated-output parity. |

## What NOT to Add

| Avoid | Why | Use Instead |
| --- | --- | --- |
| Third-party G-code parser crate | The current evidence can be parsed with std-only TSV/domain types. | Closed expected-summary schema plus fixture byte guards. |
| Geometry/math libraries for radius fitting | v1.15 should not prove geometric correctness or tolerance behavior. | Counts, command classes, parameter-shape observations, and bounded fixture facts. |
| Porting Prusa `ArcWelder.cpp` into Rust | That would become implementation parity, not evidence-slice validation. | Source-pinned scope plus checked-in fixture summary. |
| Building or running PrusaSlicer | Pulls in runtime/config/model slicing scope. | Offline checked-in fixture and provenance verification. |
| Git clone, submodule, network fetch, vendor sync, or upstream source import in verification | Existing fork evidence is offline and reviewer-gated. | Source refs, raw URL provenance, SHA/size checks, and reviewed update route. |
| `packages/launcher`, `slic3r_core`, GUI, release, or packaging changes | Arc evidence should not touch runtime user flows. | Keep work in scope, fixture, flavors, parity, and docs packages. |
| Byte-for-byte G-code parity | Too broad for this milestone. | Arc-specific summary comparison. |
| Printer firmware simulation or printability checks | Arc commands can be observed without proving printer acceptance. | Explicit deferred-scope language and fail-closed docs checks. |
| Non-Prusa fork rows | Active downstream work remains Prusa-only. | Keep Bambu Studio and OrcaSlicer deferred. |

## Version and Dependency Notes

| Item | Value | Notes |
| --- | --- | --- |
| Bazel | 8.6.0 | Pinned in `.bazelversion`; use Bazel targets for every public check. |
| `rules_rust` | 0.69.0 | Pinned in `MODULE.bazel`; keep target style consistent with `slic3r_flavors`. |
| Rust | 1.94.1 | Pinned in `MODULE.bazel`; workspace `rust-version` is 1.94. |
| Rust edition | 2024 | Workspace edition and Bazel targets already use edition 2024. |
| Rust dependencies | Internal workspace crates only for this slice | Do not run `cargo add`; no new external crate is justified. |
| License posture | AGPL-3.0-or-later workspace; upstream Prusa source is AGPL-family | Treat fixture provenance as metadata-only-not-legal-review, matching prior Prusa evidence slices. |
| Accepted Prusa source ref | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` | Reuse the existing Prusa inventory source identity unless a reviewed intake update changes it. |
| Source paths | `src/libslic3r/Geometry/ArcWelder.cpp`, likely `ArcWelder.hpp`, and optionally `tests/libslic3r/test_arc_welder.cpp` | Official upstream tree search found these ArcWelder paths; exact fixture provenance should be locked by the scope phase. |

## Source Findings

- `packages/fork-inventories/prusaslicer.tsv` already has `prusaslicer.arc-fitting`, source path `src/libslic3r/Geometry/ArcWelder.cpp`, ownership `shared-downstream`, complexity `medium`, dependency `generated-outputs`, and note "future parity requires G-code output comparison evidence."
- `packages/parity/status.tsv` has `generated-outputs` still `in progress` and `fork.prusaslicer.gcode-output` verified only for the narrow semantic G-code evidence slice. It still excludes arc fitting from that row.
- `docs/port/parity-matrix.md` says fork rows become verified only with real `//packages/parity:*_parity` evidence commands and warns not to infer runtime support from inventories or registry metadata.
- `packages/prusa-gcode-output-scope`, `packages/parity-fixtures`, `packages/parity`, and `slic3r_flavors` already implement the four-step evidence ladder: scope, fixture, Rust parser/readiness, public parity/status/docs.
- Official upstream `ArcWelder.cpp` at the accepted commit describes arc fitting as compressing many G0/G1 commands into G2/G3 arc commands while staying within a resolution. That supports G2/G3 command evidence as the narrow v1.15 observation surface, not printability or runtime behavior.
- Official upstream tree search at the accepted commit found `src/libslic3r/Geometry/ArcWelder.cpp`, `src/libslic3r/Geometry/ArcWelder.hpp`, and `tests/libslic3r/test_arc_welder.cpp` for ArcWelder terms. I did not find a source-controlled arc `.gcode` fixture by those terms, so Phase 57 should explicitly approve the fixture derivation route.
- Local Prusa profile fixture contains `arc_fitting = emit_center` entries. Use that only as optional config traceability if the scope approves it; do not turn v1.15 into profile runtime evidence.

## Sources

- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`
- Bright Builds pinned standards at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`, `standards/core/architecture.md`, `standards/core/code-shape.md`, `standards/core/verification.md`, `standards/core/testing.md`, `standards/languages/rust.md`
- `.planning/PROJECT.md`
- `.planning/milestones/v1.14-REQUIREMENTS.md`
- `.planning/milestones/v1.14-ROADMAP.md`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/parity/status.tsv`
- `docs/port/parity-matrix.md`
- `packages/prusa-gcode-output-scope/README.md`
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/BUILD.bazel`
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
- `packages/slic3r-rust/README.md`
- `packages/slic3r-rust/Cargo.toml`
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel`
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs`
- `packages/parity/BUILD.bazel`
- `packages/parity/compare_prusaslicer_gcode_output.sh`
- Official upstream source: `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/src/libslic3r/Geometry/ArcWelder.cpp`
- Official upstream test source: `https://raw.githubusercontent.com/prusa3d/PrusaSlicer/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/libslic3r/test_arc_welder.cpp`
- Official upstream tree API: `https://api.github.com/repos/prusa3d/PrusaSlicer/git/trees/9a583bd438b195856f3bcf7ea99b69ba4003a961?recursive=1`

______________________________________________________________________

*Stack research for: v1.15 PrusaSlicer Arc-Fitting G-code Evidence Slice*
*Researched: 2026-06-23*
