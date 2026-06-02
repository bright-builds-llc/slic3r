---
generated_by: gsd-phase-researcher
lifecycle_mode: yolo
phase_lifecycle_id: 40-2026-06-02T12-10-38
generated_at: 2026-06-02T12:23:36Z
---

# Phase 40: Executable Prusa Profile Parity - Research

<user_constraints>
## User Constraints (from CONTEXT.md)

Source: [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Repo-Owned Parity Command

- **D-01:** Add `bazel run //packages/parity:prusaslicer_profile_schema_parity`
  as the maintainer-facing command for this evidence slice.
- **D-02:** Keep the command under `packages/parity` so it follows the existing
  parity/status package ownership model. It may call Rust code or package-local
  helper scripts, but `packages/parity` owns the user-facing command target and
  status publication.
- **D-03:** The command should print a concise pass/fail summary that names
  `fork.prusaslicer.profile-schema`, the accepted source ref, the fixture path,
  and the expected output artifact or snapshot it compared.

### Comparison Contract

- **D-04:** Compare deterministic Rust-backed parser output from the Phase 39
  `slic3r_flavors::prusa_profile` boundary against checked-in expectations
  derived from the Phase 38 `PrusaResearch.ini` fixture.
- **D-05:** Keep the expected data narrow and stable: source identity, section
  count, entry count, representative section/key/value samples, and the
  profile-schema provenance metadata are enough for this phase.
- **D-06:** Do not attempt a full Prusa runtime configuration engine, printer
  preset resolver, profile inheritance evaluator, generated-output comparison,
  or upstream Prusa binary comparison in this milestone.
- **D-07:** Prefer a structured expected artifact that can be reviewed in git
  and used by a fail-closed verifier. JSON, TSV, or line-oriented snapshots are
  acceptable if the implementation keeps deterministic ordering and clear diffs.

### Divergence Failure Guard

- **D-08:** Add an automated test that proves the parity command fails when the
  Rust-backed parsed or normalized output diverges from checked-in fixture
  expectations.
- **D-09:** The negative test may use a copied/mutated expected artifact, a
  controlled fixture fragment, or helper flags that point the verifier at a bad
  expectation. It should not corrupt the real fixture bundle or require network,
  Git, profile auto-update, or upstream source-tree access.
- **D-10:** Failure diagnostics should identify the mismatched field or sample
  line clearly enough that maintainers can update the expected fixture only
  through the documented fixture/update route.

### Status and Documentation Publication

- **D-11:** Once the command and failure guard pass, publish exactly one narrow
  Prusa status row in `packages/parity/status.tsv` for
  `fork.prusaslicer.profile-schema`.
- **D-12:** The status row and docs must point to
  `//packages/parity:prusaslicer_profile_schema_parity` as the evidence command
  and must avoid any wording that implies full fork runtime support.
- **D-13:** Update the port control-plane docs, package map, migration guidance,
  parity matrix, parity README, fixture README, and Rust package docs only as
  needed to move `fork.prusaslicer.profile-schema` from reserved vocabulary to
  verified narrow executable evidence.

### Scope Guardrails

- **D-14:** Preserve Phase 37-39 deferrals: no GUI support, no generated-output
  parity, no Prusa project files, no STEP import, no support generation, no arc
  fitting, no wall seam behavior, no network/device/cloud/credential behavior,
  no non-free plugin ingestion, no fork release packaging, and no sync
  automation.
- **D-15:** Keep all new executable evidence local and deterministic. The
  parity command should consume checked-in fixtures and Rust parser output only.

### the agent's Discretion

- Exact verifier implementation language and file split, provided the
  maintainer-facing command is the Bazel target in `packages/parity`.
- Exact expected artifact format, provided it is deterministic, reviewable, and
  gives useful failure output.
- Whether Rust exposes a small helper binary, library function, or test-only
  fixture adapter for producing the comparison output, provided production Rust
  parser code remains side-effect free.
- Exact docs wording and section placement, provided the narrow evidence claim
  and deferrals are unmistakable.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

None - discussion stayed within phase scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PPAR-01 | Maintainer can run a repo-owned Bazel parity command for the Prusa profile/config evidence slice. [VERIFIED: .planning/REQUIREMENTS.md] | Use `sh_binary(name = "prusaslicer_profile_schema_parity")` in `packages/parity/BUILD.bazel`, following the existing parity command shape. [VERIFIED: packages/parity/BUILD.bazel] |
| PPAR-02 | Maintainer can see the Prusa parity command fail when Rust-backed parsed or normalized output diverges from checked-in Prusa fixture expectations. [VERIFIED: .planning/REQUIREMENTS.md] | Add a package-local negative `sh_test` that copies valid expected data to a temp dir, mutates one field, runs the same verifier with that bad expected file, and asserts a field-specific diagnostic. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| PPAR-03 | Maintainer can inspect docs and parity status updates that name the exact verified Prusa profile/config evidence slice while keeping broad fork support deferred. [VERIFIED: .planning/REQUIREMENTS.md] | Update exactly one `packages/parity/status.tsv` row plus the Phase 39 docs surfaces that currently reserve Phase 40 ownership. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- Read and honor `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the relevant Bright Builds standards before planning or implementation. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; ../coding-and-architecture-requirements/standards/index.md]
- Keep `packages/parity` as the visibility/status package and use repo-owned verification entrypoints instead of ad hoc low-level commands when the repo already exposes them. [VERIFIED: packages/parity/README.md; ../coding-and-architecture-requirements/standards/core/verification.md]
- Use functional core / imperative shell for this phase: pure Rust parser and summary logic should be separated from thin shell or binary adapters that read files and compare artifacts. [CITED: ../coding-and-architecture-requirements/standards/core/architecture.md; ../coding-and-architecture-requirements/standards/languages/rust.md]
- Parse boundary data into Rust domain values and make illegal states unrepresentable where practical. [CITED: ../coding-and-architecture-requirements/standards/core/architecture.md; ../coding-and-architecture-requirements/standards/languages/rust.md]
- Keep new Rust tests focused on one concern and use clear Arrange, Act, Assert structure for non-trivial tests. [CITED: ../coding-and-architecture-requirements/standards/core/testing.md; AGENTS.bright-builds.md]
- For Rust commits, the repo-level instruction requires `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features` before committing. [VERIFIED: user-provided AGENTS.md instructions]
- Prefer `foo.rs` plus `foo/` over new `foo/mod.rs` module layouts. [CITED: ../coding-and-architecture-requirements/standards/languages/rust.md]
- Use `maybe_` for internal optional names, and prefer early returns or `let...else` guard extraction. [CITED: ../coding-and-architecture-requirements/standards/core/code-shape.md; ../coding-and-architecture-requirements/standards/languages/rust.md]
- Checked-in shell scripts should use `#!/usr/bin/env bash` and `set -euo pipefail`. [VERIFIED: user-provided AGENTS.md instructions; packages/parity/compare_cli_help.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]
- Do not run `mdformat` over `.planning/phases/*/*-SUMMARY.md` files, and keep `requirements-completed` hyphenated in summary frontmatter. [VERIFIED: AGENTS.md]
- There is no project-local `.claude/skills/` or `.agents/skills/` directory in this checkout. [VERIFIED: shell audit]

## Summary

Phase 40 should be planned as one narrow executable evidence slice, not as a PrusaSlicer runtime port. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; .planning/ROADMAP.md] The strongest plan is to add a `packages/parity` Bazel `sh_binary` named `prusaslicer_profile_schema_parity`, have it call a Rust-backed summary producer for the checked-in `PrusaResearch.ini`, compare that output to a checked-in line-oriented expected snapshot, and print a concise pass/fail summary naming `fork.prusaslicer.profile-schema`, the accepted source ref, the fixture path, and the expected artifact. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]

The smallest deterministic artifact that satisfies PPAR-01 and PPAR-02 is a TSV or line-oriented snapshot with source identity, fixture/provenance metadata, total section and entry counts, per-kind counts, and a handful of exact section/key/value samples. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs; shell fixture audit] A broad dump of 6,976 sections and 27,340 entries is unnecessary for this phase and would make fixture review noisy without proving the deferred runtime semantics. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

The planner must explicitly update the Phase 38 fixture verifier because it currently fails when any Prusa status row appears in `packages/parity/status.tsv`. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] After Phase 40 publishes exactly one narrow status row, fixture verification should require the exact row and evidence command instead of requiring absence. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; packages/parity/README.md]

**Primary recommendation:** Use a TSV snapshot plus a fail-closed shell verifier in `packages/parity`, backed by pure Rust summary logic in `slic3r_flavors` and a thin Rust binary adapter only if needed for Bazel execution. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_export_workflows.sh; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; ../coding-and-architecture-requirements/standards/core/architecture.md]

## Standard Stack

### Core

| Tool or Library | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Bazel / Bazelisk | 8.6.0 from `.bazelversion` and local `bazel --version` | Own the maintainer-facing command and tests. | Existing parity and fixture commands are Bazel `sh_binary` / `sh_test` targets. [VERIFIED: .bazelversion; packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel; environment audit] |
| Bash | GNU bash 3.2.57 on this machine | Thin verifier and negative-test shell scripts. | Existing parity scripts and fixture tests use Bash with `set -euo pipefail`. [VERIFIED: packages/parity/compare_cli_help.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; environment audit] |
| Rust `slic3r_flavors` | workspace Rust 1.94 / edition 2024 | Parse Prusa profile text and expose metadata. | Phase 39 already implemented `parse_prusa_profile_bundle` and `prusa_profile_schema_metadata` in this crate. [VERIFIED: packages/slic3r-rust/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Rust standard library | Rust 1.94.1 local toolchain | Produce deterministic summary output without new dependencies. | The current Prusa parser is std-only and `slic3r_flavors` has only `slic3r_contracts` as a dependency. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; environment audit] |
| `diff -u` / line comparison | Apple diff available locally | Produce clear fail-closed output when expected and actual snapshots diverge. | Existing parity scripts compare exact expected and actual outputs and print mismatch diagnostics. [VERIFIED: packages/parity/compare_export_workflows.sh; packages/parity/compare_transform_workflows.sh; environment audit] |

### Supporting

| Tool or Library | Version | Purpose | When to Use |
|-----------------|---------|---------|-------------|
| `mdformat` | 1.0.0 locally | Check Markdown docs updated by Phase 40. | Use for changed docs except phase `*-SUMMARY.md` files. [VERIFIED: environment audit; AGENTS.md] |
| `shasum` | 6.02 locally | Preserve existing raw fixture checksum verification. | Keep in the fixture verifier for `PrusaResearch.ini` and `.idx`; do not use it as the parity comparison itself. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; environment audit] |
| `awk`, `grep`, `rg` | awk 20200816 locally; `rg` used in repo audits | Status/docs guards and simple TSV validation. | Use for verification guards around exact status row, forbidden overclaiming text, and docs coverage. [VERIFIED: environment audit; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| TSV / line snapshot | JSON | JSON is structured, but the current Rust crate has no `serde_json` dependency and hand-rolled JSON escaping would add risk for little value in this narrow snapshot. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| Thin Rust summary binary plus shell verifier | All-shell parser | An all-shell parser would not be Rust-backed and would fail the Phase 40 requirement to compare Rust-backed parsed or normalized output. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |
| Checked-in expected snapshot | Generate expected from actual during the command | Generating expected data during verification would mask divergence and fail PPAR-02. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/compare_cli_help.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| Fixture-owned expected artifact | Parity-owned expected artifact | Fixture-owned expectations match existing fixture package ownership and Bazel alias patterns, while `packages/parity` should own the user-facing command and status row. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity/BUILD.bazel; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |

**Installation:** No new package installation is needed for the recommended plan. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; environment audit]

```bash
# Use existing repo tools.
bazel run //packages/parity:prusaslicer_profile_schema_parity
rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features
```

**Version verification:** `bazel --version` returned `bazel 8.6.0`, `.bazelversion` contains `8.6.0`, `rustup run 1.94.1 rustc --version` returned `rustc 1.94.1`, and `rustup run 1.94.1 cargo --version` returned `cargo 1.94.1`. [VERIFIED: environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/parity/
├── compare_prusaslicer_profile_schema.sh          # fail-closed verifier shell
├── compare_prusaslicer_profile_schema_test.sh     # negative divergence guard
├── BUILD.bazel                                    # user-facing sh_binary + sh_test
├── README.md                                      # status and command docs
└── status.tsv                                     # exactly one narrow Prusa row

packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/
├── PrusaResearch.ini                              # existing raw input
├── PrusaResearch.idx                              # existing provenance mate
├── fixture-provenance.tsv                         # existing source metadata
├── expected-summary.tsv                           # new checked-in parity expectation
└── README.md                                      # update route and Phase 40 evidence scope

packages/slic3r-rust/crates/slic3r_flavors/src/
├── prusa_profile.rs                               # existing pure parser
├── prusa_profile_summary.rs                       # pure deterministic summary builder, if needed
└── bin/prusa_profile_schema_summary.rs            # thin explicit-path adapter, if needed
```

This structure keeps `packages/parity` as the user-facing evidence owner, keeps checked-in expected data with fixture provenance, and keeps Rust transformation logic near the existing parser. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

### Pattern 1: Parity Command as Bazel `sh_binary`

**What:** Add `sh_binary(name = "prusaslicer_profile_schema_parity")` under `packages/parity`, with `srcs = ["compare_prusaslicer_profile_schema.sh"]`, `data` including the Rust summary binary, raw fixture, provenance, expected snapshot, and relevant README/status files, and `args` using Bazel `$(location ...)` paths. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_cli_help.sh]

**When to use:** Use this for the maintainer command because Phase 40 locks the public command path to `bazel run //packages/parity:prusaslicer_profile_schema_parity`. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**Example:**

```python
# Source: packages/parity/BUILD.bazel existing sh_binary patterns
sh_binary(
    name = "prusaslicer_profile_schema_parity",
    srcs = ["compare_prusaslicer_profile_schema.sh"],
    data = [
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_schema_summary",
        "//packages/parity-fixtures:prusa_profile_schema_prusa_research_ini",
        "//packages/parity-fixtures:prusa_profile_schema_expected_summary",
        "//packages/parity-fixtures:prusa_profile_schema_provenance",
        "status.tsv",
    ],
    args = [
        "$(location //packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_schema_summary)",
        "$(location //packages/parity-fixtures:prusa_profile_schema_prusa_research_ini)",
        "$(location //packages/parity-fixtures:prusa_profile_schema_expected_summary)",
        "$(location //packages/parity-fixtures:prusa_profile_schema_provenance)",
    ],
)
```

### Pattern 2: Pure Rust Summary Builder, Thin Adapter

**What:** Keep `parse_prusa_profile_bundle(input: &str)` unchanged as the pure parser, add any deterministic summary builder as pure data-in/data-out Rust, and isolate file reads to a tiny binary adapter that accepts explicit paths from Bazel. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; ../coding-and-architecture-requirements/standards/core/architecture.md]

**When to use:** Use this only if shell cannot directly invoke the Rust library; the adapter should read the explicit fixture path, call the pure parser and summary builder, print the snapshot, and avoid path discovery, Git, network, environment-dependent source selection, process spawning, profile auto-update, and vendor sync. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]

**Example:**

```rust
// Source: recommended shape from Phase 39 pure parser API
pub fn prusa_profile_schema_summary_lines(input: &str) -> Result<Vec<String>, PrusaProfileParseError> {
    let bundle = parse_prusa_profile_bundle(input)?;
    let metadata = prusa_profile_schema_metadata();

    Ok(vec![
        format!("inventory_id\t{}", metadata.inventory_id),
        format!("source_ref\t{}", metadata.source_ref.as_str()),
        format!("section_count\t{}", bundle.sections.len()),
    ])
}
```

### Pattern 3: Fail-Closed Negative `sh_test`

**What:** Add a `sh_test` under `packages/parity` that copies the valid expected snapshot into a temp directory, mutates exactly one stable expected line, runs the same verifier with the bad expected path, and asserts stderr contains the mismatched field or sample line. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

**When to use:** Use this to satisfy PPAR-02 without corrupting the real fixture bundle or requiring network/Git/upstream source access. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**Example:**

```bash
# Source: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh pattern
test_bad_expected_section_count_fails() {
    # Arrange
    local expected="${tmp_dir}/expected-summary.tsv"
    cp "${source_expected}" "${expected}"
    replace_first_line_containing "${expected}" $'section_count\t6976' $'section_count\t6975'

    # Act
    if run_parity "${source_fixture}" "${expected}" "${tmp_dir}/bad.out" "${tmp_dir}/bad.err"; then
        fail "bad expected summary passed"
    fi

    # Assert
    assert_contains "${tmp_dir}/bad.err" "section_count"
}
```

### Anti-Patterns to Avoid

- **Parsing Prusa fixture counts in shell for the actual comparison:** The parity command must compare Rust-backed parsed output, so shell may compare artifacts but should not be the parser of record. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]
- **Regenerating expected output during the parity run:** The expected artifact must be checked in and compared fail-closed, or divergence cannot be detected. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/compare_cli_help.sh]
- **Putting file discovery or process/network behavior into `prusa_profile.rs`:** Phase 39 locked the production parser to caller-provided strings and side-effect-free behavior. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]
- **Adding a broad Prusa runtime or status claim:** Phase 40 may publish only `fork.prusaslicer.profile-schema` for the narrow profile/config evidence slice. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; docs/port/parity-matrix.md]

## Expected Artifact Shape

Use `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv` as the checked-in expectation. [VERIFIED: packages/parity-fixtures/BUILD.bazel; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

Recommended rows:

```tsv
field	value
inventory_id	prusaslicer.profile-schema
status_token	fork.prusaslicer.profile-schema
source_ref	prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961
source_path	resources/profiles/PrusaResearch.ini
fixture_path	packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini
checklist_path	packages/prusa-baseline/profile-schema-checklist.md
section_count	6976
entry_count	27340
section_kind_count	vendor	1
section_kind_count	printer_model	35
section_kind_count	print	633
section_kind_count	filament	6069
section_kind_count	printer	238
sample	vendor	vendor	config_version	2.4.14
sample	printer_model	MK4S	name	Original Prusa MK4S
sample	print	0.20mm SPEED @MK4S 0.4	inherits	0.20mm SPEED @MK4IS 0.4; *MK4S_04*
sample	filament	Prusament PLA @PG	inherits	Prusament PLA; *PLAPG*
sample	printer	Original Prusa MK4S 0.4 nozzle	inherits	Original Prusa MK4S HF0.4 nozzle; *MK4S_LFNOZZLE*
```

The count values above are already asserted by the Phase 39 real-fixture Rust test, and the sample values were spot-checked from the checked-in fixture. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini; shell fixture audit]

The summary should sort only where the source semantics require it; otherwise preserve explicit row order in the expected artifact so diffs are stable and reviewer-controlled. [VERIFIED: packages/parity/compare_export_workflows.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Prusa INI parsing | A new shell, awk, or ad hoc parser in `packages/parity` | Existing `parse_prusa_profile_bundle(input: &str)` | Phase 39 already provides typed sections, entries, metadata, and parser tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs] |
| JSON serialization | Manual JSON escaping or a new `serde_json` dependency | TSV / line-oriented snapshot | The current crate has no JSON dependency, and the required fields are simple scalar rows. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| Bazel location resolution | Custom workspace search or environment discovery | `$(location ...)` args plus existing `BUILD_WORKSPACE_DIRECTORY` fallback pattern | Existing parity scripts already handle Bazel-run paths and workspace fallback. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_cli_help.sh] |
| Divergence testing | Mutating real fixtures in place | Temp-copy mutation inside `sh_test` | Existing fixture failure tests mutate temp copies and assert diagnostics. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| Status publication policy | Free-form docs text without machine guards | Exact TSV row plus grep/awk scope guards | Existing status table is the data source for `//packages/parity:status`, and docs require executable evidence before verified fork rows. [VERIFIED: packages/parity/status.tsv; packages/parity/parity_status.sh; packages/parity/README.md] |

**Key insight:** The hard part is not parsing every Prusa profile semantic; it is making a narrow, rerunnable, fail-closed evidence command that cannot be mistaken for full PrusaSlicer support. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; docs/port/migration-guidance.md]

## Common Pitfalls

### Pitfall 1: Publishing the Status Row Breaks the Existing Fixture Verifier

**What goes wrong:** `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` currently rejects any `fork.prusaslicer`, `prusaslicer.profile-schema`, or `prusaslicer_profile_schema_parity` entry in `packages/parity/status.tsv`. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh]

**Why it happens:** Phase 38 intentionally made status non-publication part of fixture verification. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

**How to avoid:** Phase 40 must update that verifier and its test from "row must be absent" to "exact narrow Phase 40 row must be present and scoped." [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**Warning signs:** The final plan adds `packages/parity/status.tsv` but does not touch `verify_prusa_profile_schema_fixture.sh` or `verify_prusa_profile_schema_fixture_test.sh`. [VERIFIED: packages/parity-fixtures/BUILD.bazel]

### Pitfall 2: Overclaiming Runtime PrusaSlicer Support

**What goes wrong:** Docs or status wording can imply GUI support, generated-output parity, fork runtime support, profile auto-update execution, release builds, or sync automation. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; docs/port/parity-matrix.md]

**Why it happens:** The token name contains `fork.prusaslicer`, but the evidence only covers `prusaslicer.profile-schema` parser/metadata output. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**How to avoid:** Use the wording "narrow Prusa profile-schema parser/config evidence slice" and keep the full deferral list visible in docs. [VERIFIED: packages/parity/README.md; docs/port/migration-guidance.md]

**Warning signs:** A status note says "PrusaSlicer verified" without "profile-schema" or "narrow". [VERIFIED: packages/parity/status.tsv; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

### Pitfall 3: Comparing Against a Generated Expected File

**What goes wrong:** The command passes even when the Rust output changes because the expected file is regenerated from the same output during the run. [VERIFIED: .planning/REQUIREMENTS.md]

**Why it happens:** Regeneration is convenient during fixture updates, but parity verification needs a committed oracle. [VERIFIED: packages/parity/compare_cli_help.sh; packages/parity/compare_export_workflows.sh]

**How to avoid:** Keep `expected-summary.tsv` checked in and compare actual output to it with exact line comparison or `diff -u`. [VERIFIED: packages/parity/compare_export_workflows.sh]

**Warning signs:** The parity script writes the expected path before comparing. [VERIFIED: packages/parity/compare_cli_config_persistence.sh]

### Pitfall 4: File I/O Creeps Into the Parser Boundary

**What goes wrong:** `prusa_profile.rs` starts reading fixture paths, environment variables, Git state, or network resources. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md]

**Why it happens:** A runnable command needs file I/O, but that I/O belongs in the adapter, not the pure parser. [CITED: ../coding-and-architecture-requirements/standards/core/architecture.md]

**How to avoid:** Put pure summary construction in library code and put explicit-path `std::fs::read_to_string` only in a tiny `src/bin/...` adapter if a Rust binary is needed. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; ../coding-and-architecture-requirements/standards/languages/rust.md]

**Warning signs:** Side-effect terms appear in `src/prusa_profile.rs` instead of a binary adapter. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-VERIFICATION.md]

### Pitfall 5: Negative Test Diagnostics Are Too Vague

**What goes wrong:** The failure test proves non-zero exit but not that maintainers can identify the mismatched field or sample. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**Why it happens:** Shell scripts often print a generic "mismatch" message unless the label includes the field. [VERIFIED: packages/parity/compare_export_workflows.sh]

**How to avoid:** Include field labels such as `section_count`, `entry_count`, or the full sample row in the diff or stderr. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

**Warning signs:** The failure test checks only `exit 1` and not stderr content. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

## Code Examples

### Shell Verifier Skeleton

```bash
# Source: packages/parity/compare_export_workflows.sh and compare_cli_help.sh
#!/usr/bin/env bash
set -euo pipefail

summary_binary="${1}"
fixture_file="${2}"
expected_file="${3}"

actual_file="$(mktemp "${TMPDIR:-/tmp}/prusaslicer-profile-schema.XXXXXX")"
trap 'rm -f "${actual_file}"' EXIT

"${summary_binary}" "${fixture_file}" >"${actual_file}"

if ! diff -u "${expected_file}" "${actual_file}" >&2; then
    printf 'Prusa profile-schema parity mismatch for expected artifact: %s\n' "${expected_file}" >&2
    exit 1
fi

printf 'verified fork.prusaslicer.profile-schema source_ref=%s fixture=%s expected=%s\n' \
    'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961' \
    "${fixture_file}" \
    "${expected_file}"
```

This script shape is consistent with existing exact-output parity scripts and satisfies the required concise pass summary. [VERIFIED: packages/parity/compare_cli_help.sh; packages/parity/compare_export_workflows.sh; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

### Rust Summary Test Shape

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs
#[test]
fn summarizes_checked_in_prusa_research_fixture() {
    // Arrange
    let input = PRUSA_RESEARCH_INI;

    // Act
    let summary = prusa_profile_schema_summary_lines(input).expect("fixture should summarize");

    // Assert
    assert!(summary.iter().any(|line| line == "section_count\t6976"));
    assert!(summary.iter().any(|line| line == "entry_count\t27340"));
}
```

This test shape extends the existing real-fixture parser coverage without introducing file discovery into production parser code. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_profile.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]

### Exact Status Row Shape

```tsv
fork.prusaslicer.profile-schema	verified	//packages/parity:prusaslicer_profile_schema_parity	Shared fixture comparison proves the narrow Prusa profile-schema parser/config evidence slice only; full PrusaSlicer runtime support remains deferred
```

This row follows the existing four-column `surface status evidence notes` status table and uses the locked Phase 40 surface token and command. [VERIFIED: packages/parity/status.tsv; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Phase 38 fixture/status preparation rejected any Prusa status publication. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] | Phase 40 should require exactly one narrow verified row after executable evidence exists. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] | Phase 40 planning, 2026-06-02. [VERIFIED: .planning/STATE.md] | The planner must include fixture verifier updates, not only status row insertion. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| Phase 39 parser/metadata readiness only. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-VERIFICATION.md] | Phase 40 executable parity command and status publication. [VERIFIED: .planning/ROADMAP.md] | Phase 40 follows completed Phase 39. [VERIFIED: .planning/STATE.md] | The command can consume the parser but must not broaden runtime semantics. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| Existing parity commands compare CLI/export/runtime/package surfaces. [VERIFIED: packages/parity/BUILD.bazel] | New parity command compares Rust parser summary against a Prusa profile-schema expectation. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] | Phase 40. [VERIFIED: .planning/ROADMAP.md] | The command remains package-owned under `packages/parity` and fixture-backed. [VERIFIED: packages/parity/README.md] |

**Deprecated/outdated:** Treating `fork.prusaslicer.profile-schema` as docs-only reserved vocabulary becomes outdated once the Phase 40 command and negative guard pass, but treating it as full PrusaSlicer support remains forbidden. [VERIFIED: packages/parity/README.md; docs/port/parity-matrix.md; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

## Docs And Status Update Map

| File | Required Phase 40 Update | Boundary That Must Remain |
|------|--------------------------|---------------------------|
| `packages/parity/status.tsv` | Add exactly one `fork.prusaslicer.profile-schema` row with status `verified` and evidence `//packages/parity:prusaslicer_profile_schema_parity`. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; packages/parity/status.tsv] | Notes must say narrow profile-schema/parser-config evidence only, not full fork runtime support. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| `packages/parity/README.md` | Add the new command to Current Surface and change future/reserved Prusa text to Phase 40 verified narrow evidence. [VERIFIED: packages/parity/README.md] | Keep "Do not mark verified until shared fixture comparison exists" as the policy. [VERIFIED: packages/parity/README.md] |
| `packages/parity-fixtures/README.md` | Add Phase 40 expected-summary artifact and command evidence to the Prusa fixture namespace description. [VERIFIED: packages/parity-fixtures/README.md] | Keep update route tied to reviewed intake changes, not branch-head drift. [VERIFIED: packages/parity-fixtures/README.md; fixture-provenance.tsv] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md` | Replace Phase 38-only wording with raw fixture plus Phase 40 expected snapshot and command evidence. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md] | Keep no Bambu, Orca, network, cloud, credentials, auto-update, non-free plugin, runtime, GUI, sync, or release scope. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md] |
| `packages/slic3r-rust/README.md` | Document any new summary helper or binary target and keep parser side-effect boundaries. [VERIFIED: packages/slic3r-rust/README.md] | Keep full Prusa runtime, GUI, network/cloud/credential, auto-update, sync, and release packaging deferred. [VERIFIED: packages/slic3r-rust/README.md] |
| `docs/port/README.md` | Add current Prusa executable parity evidence state. [VERIFIED: docs/port/README.md] | State exact source ref, fixture path, command, and limited evidence slice. [VERIFIED: docs/port/README.md; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| `docs/port/package-map.md` | Add Phase 40 package-discoverability note for parity command, expected artifact, and status row. [VERIFIED: docs/port/package-map.md] | Keep package ownership clear: parity command/status in `packages/parity`, expected artifact in fixtures, parser in Rust. [VERIFIED: docs/port/package-map.md] |
| `docs/port/migration-guidance.md` | Change "reserved until command exists" to "verified for this narrow evidence slice" after command passes. [VERIFIED: docs/port/migration-guidance.md] | Keep future fork status policy tied to executable evidence. [VERIFIED: docs/port/migration-guidance.md] |
| `docs/port/parity-matrix.md` | Update Fork Parity Interpretation to name the verified narrow row and command. [VERIFIED: docs/port/parity-matrix.md] | Keep full PrusaSlicer runtime, GUI, generated-output parity, release builds, and sync automation deferred. [VERIFIED: docs/port/parity-matrix.md] |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | All claims in this research were verified against local phase artifacts, source files, standards files, or command probes. [VERIFIED: source tags throughout this file] | All sections | No user confirmation is needed before planning. [VERIFIED: source tags throughout this file] |

## Open Questions

1. **No blocking implementation questions remain for planning.** [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; codebase audit]
   - What we know: the command target name, source ref, fixture path, status token, comparison scope, docs surfaces, and negative failure requirement are locked. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]
   - What's unclear: only local implementation names such as `expected-summary.tsv`, `compare_prusaslicer_profile_schema.sh`, and `prusa_profile_schema_summary` remain discretionary. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]
   - Recommendation: use the names above because they match existing repo naming and keep the status token discoverable. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `bazel run` / `bazel test` parity targets | yes | 8.6.0 | none needed [VERIFIED: environment audit] |
| Bazelisk | Repo-pinned Bazel launcher on macOS | yes | reports Bazel 8.6.0 | use `bazel` directly [VERIFIED: packages/slic3r-rust/README.md; environment audit] |
| Rustup | Pinned Rust command invocation | yes | 1.29.0 | use active toolchain only if it is 1.94.1 [VERIFIED: environment audit] |
| Rustc | Rust parser/helper build | yes | 1.94.1 | none needed [VERIFIED: environment audit; packages/slic3r-rust/Cargo.toml] |
| Cargo | Rust fmt/clippy/build/test | yes | 1.94.1 | none needed [VERIFIED: environment audit] |
| Bash | Parity scripts and tests | yes | GNU bash 3.2.57 | none needed [VERIFIED: environment audit] |
| `mdformat` | Markdown checks | yes | 1.0.0 | skip only if unavailable and document reason [VERIFIED: environment audit; ../coding-and-architecture-requirements/standards/core/verification.md] |
| `shasum` | Existing fixture checksum verifier | yes | 6.02 | none needed [VERIFIED: environment audit; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |
| `awk` | TSV/status verifier snippets | yes | 20200816 | use Rust or Bash parsing for complex checks [VERIFIED: environment audit] |
| `diff` | Snapshot mismatch output | yes | Apple diff | shell exact string compare if `diff` unavailable [VERIFIED: environment audit] |

**Missing dependencies with no fallback:** None found. [VERIFIED: environment audit]

**Missing dependencies with fallback:** None required for the recommended plan. [VERIFIED: environment audit]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | No authentication surface is in Phase 40 scope. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| V3 Session Management | no | No session surface is in Phase 40 scope. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| V4 Access Control | no | The command reads checked-in fixtures via explicit Bazel paths and does not expose privileged runtime access. [VERIFIED: packages/parity/BUILD.bazel; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] |
| V5 Input Validation | yes | Use `parse_prusa_profile_bundle` typed parse errors and fail-closed expected artifact comparison. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| V6 Cryptography | limited | Keep existing SHA-256 fixture integrity checks through `shasum`; do not add custom cryptography. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Fixture or expected artifact drift is accepted silently. [VERIFIED: .planning/REQUIREMENTS.md] | Tampering | Use checked-in expectations, exact comparison, `diff -u`, and a negative mutation test. [VERIFIED: packages/parity/compare_export_workflows.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] |
| Status row overclaims support. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] | Spoofing / Repudiation | Use exact status row guards and docs grep checks for required deferrals. [VERIFIED: packages/parity/status.tsv; docs/port/migration-guidance.md] |
| Runtime file discovery consumes unreviewed local files. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-CONTEXT.md] | Tampering | Pass explicit Bazel `$(location)` paths and avoid discovery in parser code. [VERIFIED: packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs] |
| Network/profile auto-update behavior enters the evidence command. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md] | Information Disclosure / Tampering | Keep command local-only and add side-effect scans for network, process, Git, and auto-update terms. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-VERIFICATION.md] |

## Verification Commands For Plans

### Rust

- `rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; environment audit]
- `rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; user-provided AGENTS.md instructions]
- `rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; user-provided AGENTS.md instructions]
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; user-provided AGENTS.md instructions]
- `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_profile_test //packages/slic3r-rust:verify` [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; packages/slic3r-rust/BUILD.bazel]

### Bazel Parity

- `bazel run //packages/parity:prusaslicer_profile_schema_parity` [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]
- `bazel test //packages/parity:prusaslicer_profile_schema_parity_failure_test` [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]
- `bazel query //packages/parity:prusaslicer_profile_schema_parity` should succeed after implementation; it currently fails because the target is absent before Phase 40 execution. [VERIFIED: bazel query audit; .planning/phases/39-rust-prusa-profile-boundary/39-VERIFICATION.md]

### Fixture And Status

- `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture` [VERIFIED: packages/parity-fixtures/BUILD.bazel]
- `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test` [VERIFIED: packages/parity-fixtures/BUILD.bazel]
- `bazel run //packages/parity:status | rg "fork\\.prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity"` [VERIFIED: packages/parity/parity_status.sh; packages/parity/status.tsv]
- `awk -F '\t' '$1=="fork.prusaslicer.profile-schema" && $2=="verified" && $3=="//packages/parity:prusaslicer_profile_schema_parity" { found=1 } END { exit found ? 0 : 1 }' packages/parity/status.tsv` [VERIFIED: packages/parity/status.tsv; .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md]

### Docs And Scope Guards

- `mdformat --check packages/parity/README.md packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md packages/slic3r-rust/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md; AGENTS.md]
- `rg -n "fork\\.prusaslicer\\.profile-schema|prusaslicer_profile_schema_parity|prusaslicer:version_2\\.9\\.5@9a583bd438b195856f3bcf7ea99b69ba4003a961|PrusaResearch\\.ini" packages/parity/README.md packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md packages/slic3r-rust/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md` [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md]
- `rg -n "full PrusaSlicer runtime support|GUI support|generated-output parity|fork release builds|sync automation|profile auto-update|network|cloud|credential|non-free plugin" packages/parity/README.md packages/parity-fixtures/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md packages/slic3r-rust/README.md docs/port/README.md docs/port/migration-guidance.md docs/port/parity-matrix.md` [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; .planning/phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md]

### Negative Failure Behavior

- The negative test should mutate a temp copy of `expected-summary.tsv`, run the real verifier with the bad file, assert non-zero exit, and assert stderr contains the changed field such as `section_count`. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]
- The final verification should include `git diff --check` because prior phase summaries used it as a whitespace guard. [VERIFIED: .planning/phases/39-rust-prusa-profile-boundary/39-01-SUMMARY.md; .planning/phases/39-rust-prusa-profile-boundary/39-02-SUMMARY.md]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md` - locked Phase 40 command, comparison, failure, status, docs, and scope decisions. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - PPAR-01, PPAR-02, PPAR-03 and v1.10 out-of-scope table. [VERIFIED: local file read]
- `.planning/ROADMAP.md` and `.planning/STATE.md` - Phase 40 sequencing after completed Phase 39. [VERIFIED: local file read]
- `packages/parity/BUILD.bazel`, `packages/parity/*.sh`, `packages/parity/README.md`, and `packages/parity/status.tsv` - existing parity command, comparison, and status patterns. [VERIFIED: local file read]
- `packages/parity-fixtures/BUILD.bazel`, `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh`, and `packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh` - fixture aliases, verifier, and negative mutation test pattern. [VERIFIED: local file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs` and tests - Phase 39 Rust parser and fixture count evidence. [VERIFIED: local file read]
- `docs/port/README.md`, `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and `docs/port/parity-matrix.md` - current docs boundaries and Phase 40 deferrals. [VERIFIED: local file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and sibling Bright Builds standards pages - repo and standards constraints. [VERIFIED: local file read]

### Secondary (MEDIUM confidence)

- Local command probes for Bazel, Bazelisk, Rustup, Rust, Cargo, Bash, `mdformat`, `shasum`, `awk`, and `diff`. [VERIFIED: environment audit]
- Local `bazel query` probes showing existing prerequisite targets and absent Phase 40 target. [VERIFIED: bazel query audit]

### Tertiary (LOW confidence)

- None. [VERIFIED: source tags throughout this file]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH because the phase uses existing repo tools and local versions were probed. [VERIFIED: environment audit; packages/parity/BUILD.bazel; packages/slic3r-rust/Cargo.toml]
- Architecture: HIGH because command ownership, parser boundary, fixture ownership, and docs/status scope are locked by Phase 40 context and established by existing code. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_profile.rs]
- Pitfalls: HIGH because the status-row verifier conflict and negative-test patterns are directly visible in current scripts. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

**Research date:** 2026-06-02 [VERIFIED: current_date context]
**Valid until:** 2026-07-02 for repository-local planning unless the Prusa fixture/source pin, Bazel/Rust toolchain, or Phase 40 context changes first. [VERIFIED: .planning/phases/40-executable-prusa-profile-parity/40-CONTEXT.md; .bazelversion; packages/slic3r-rust/Cargo.toml]

## RESEARCH COMPLETE
