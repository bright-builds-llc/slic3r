# Phase 52: Executable Structural G-code Evidence - Research

**Researched:** 2026-06-18
**Domain:** Bazel-owned parity evidence, Rust structural TSV parsing, Bash comparator mutation guards, and conservative port documentation [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: codebase inspection + current Bazel/Cargo/tool probes]

<user_constraints>
## User Constraints (from CONTEXT.md)

Copied verbatim from `.planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md`. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Public structural parity command

- **D-01:** Keep the public evidence surface in `packages/parity`, using the
  existing `//packages/parity:prusaslicer_gcode_output_parity` command as the
  maintainer-facing entry point unless planning finds a lower-risk adjacent
  structural target that preserves the same status token.
- **D-02:** The public command must validate both the original
  `expected-gcode-summary.tsv` evidence and the Phase 50
  `expected-gcode-structural-summary.tsv` evidence through Rust-owned parsing
  boundaries, rather than trusting TSV bytes or fixture verifier output alone.
- **D-03:** Command output should make the structural evidence visible with
  maintainer-readable lines for the structural summary path, structural row
  count, source identity, fixture identity, command counts, ordered markers,
  movement/extrusion indicators, and temperature/tool-change marker counts.
- **D-04:** Keep executable evidence narrow: the command proves that the
  checked-in structural expected summary matches the pure Rust boundary and
  reviewed fixture expectations. It does not generate fresh G-code or compare
  PrusaSlicer runtime output.

### Structural mutation guard

- **D-05:** Extend the existing
  `prusaslicer_gcode_output_parity_failure_test` mutation coverage to include
  a structural-summary drift case, not only the v1.12 `line_4` summary marker
  drift case.
- **D-06:** The structural mutation guard should mutate one meaningful
  structural value from `expected-gcode-structural-summary.tsv`, expect the
  public comparator to fail, and assert diagnostics naming the structural
  artifact and the drifted structural field.
- **D-07:** Prefer one focused command-level structural drift test for GCEV-02;
  do not duplicate all Phase 50 fixture-verifier or Phase 51 Rust parser
  rejection classes in the parity package.

### Status and documentation publication

- **D-08:** Update the `fork.prusaslicer.gcode-output` status row and parity
  docs from summary-only wording to narrow structural evidence wording while
  preserving the exact status token and public Bazel command.
- **D-09:** Keep the broad `generated-outputs` row exactly `in progress`.
  Phase 52 may make the narrow Prusa G-code slice more meaningful, but it must
  not promote broad generated-output parity.
- **D-10:** Update package and port docs only where needed to describe the
  structural evidence chain: Phase 49 scope, Phase 50 structural fixture,
  Phase 51 Rust parser/readiness, and Phase 52 public executable evidence.
- **D-11:** Public docs must keep deferred surfaces explicit, including
  byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, STEP import, full 3MF import/export, GUI behavior, binary G-code,
  thumbnails, post-processing, host upload, network/device integration,
  profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, release behavior, and sync automation.

### Lifecycle and verification

- **D-12:** Verification for this phase should include the public Bazel parity
  command, the parity failure mutation test, the Rust flavor tests that own the
  structural parser/readiness boundary, and relevant fixture/scope verifiers
  when touched by the implementation.
- **D-13:** Because this phase touches a Rust workspace before final commit,
  run the Rust pre-commit sequence from repo instructions when Rust files are
  changed: `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`,
  `cargo build --all-targets --all-features`, and `cargo test --all-features`
  from the relevant Cargo workspace, plus the repo-owned Bazel checks for the
  changed targets.

### the agent's Discretion

- Choose whether the Rust summary binary gains a structural mode, a second
  binary is added, or the comparator invokes existing Rust APIs through the
  clearest local pattern, provided the public command validates structural data
  through Rust and remains easy to diagnose.
- Choose exact Bash helper boundaries in
  `packages/parity/compare_prusaslicer_gcode_output.sh` and its test, as long
  as the script remains fail-closed, readable, and consistent with the existing
  parity package style.
- Choose the minimal docs touched to publish the structural evidence without
  broad rewrites.

### Deferred Ideas (OUT OF SCOPE)

- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, STEP import, full 3MF import/export, GUI behavior, binary G-code,
  thumbnails, post-processing, host upload, network/device integration,
  profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, release behavior, and sync automation
  remain out of scope.
- Broader `generated-outputs` verification remains future work after multiple
  reviewed generated-output surfaces have executable evidence.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| GCEV-01 | Maintainer can run a public Bazel parity command that validates the structural Prusa G-code expected summary through the Rust boundary and checked-in fixture expectations. | Use existing `//packages/parity:prusaslicer_gcode_output_parity`, add `expected-gcode-structural-summary.tsv` as target data/args, and validate it through a Rust structural summary mode backed by `parse_prusa_gcode_output_structural_summary`. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] |
| GCEV-02 | Maintainer can see the public parity command fail closed on a structural-summary mutation guard, not only the v1.12 marker-line drift guard. | Extend `prusaslicer_gcode_output_parity_failure_test` with one `command_count_g1` structural drift mutation and assertions for `expected-gcode-structural-summary.tsv` plus the drifted field name. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/compare_prusaslicer_gcode_output_test.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |
| GCEV-03 | Maintainer can inspect parity status, package docs, and port docs that describe the exact narrow `fork.prusaslicer.gcode-output` structural evidence slice while keeping broad `generated-outputs` in progress and all deferred generated-output/runtime/fork surfaces explicit. | Update `packages/parity/status.tsv`, `packages/parity/README.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and `docs/port/package-map.md`; keep the `generated-outputs` row status as `in progress`. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv; packages/parity/README.md; docs/port/parity-matrix.md; docs/port/migration-guidance.md; docs/port/package-map.md] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo entrypoint and requires reading `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant pinned Bright Builds standards before plan/review/implementation/audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Repo-local guidance says phase summary frontmatter must keep `requirements-completed` synchronized and must use the exact key `requirements-completed`; Phase 52 research does not edit summaries, but the planner must preserve this for later summary tasks. [VERIFIED: AGENTS.md]
- Repo-local guidance says not to run `mdformat` over phase `*-SUMMARY.md` files; this does not constrain `52-RESEARCH.md`, but later Phase 52 summary work must honor it. [VERIFIED: AGENTS.md]
- Bright Builds defaults require functional core / imperative shell, parse boundary data into domain types, make illegal states unrepresentable when practical, use early returns, keep scripts rerunnable/diagnosable, and test pure logic. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md]
- Rust guidance requires new/touched Rust domain invariants to be encoded with types/newtypes/enums where useful, optional internal names to use `maybe_`, and Rust verification to prefer the repo's own scoped commands. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Verification guidance says substantive implementation should sync/prepare dependencies first and run relevant repo-native checks before commit. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md]
- `standards-overrides.md` contains only placeholder override rows and no active repo-specific exception that changes Phase 52's implementation path. [VERIFIED: standards-overrides.md]
- No `.claude/skills/` or `.agents/skills/` project skill directories were found in the repository. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md -print`]

## Summary

Phase 52 is an internal evidence-publication phase, not an ecosystem/library selection phase. The repo already has the structural scope contract from Phase 49, the checked-in structural sidecar from Phase 50, and the pure Rust structural parser/readiness boundary from Phase 51. [VERIFIED: .planning/phases/49-structural-g-code-scope-contract/49-CONTEXT.md; .planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md; .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md]

The lowest-risk plan is to keep the existing public target `//packages/parity:prusaslicer_gcode_output_parity`, extend the existing Rust G-code summary binary with an explicit structural mode, and extend the existing Bash comparator/test around both the v1.12 summary TSV and the v1.13 structural TSV. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_prusaslicer_gcode_output.sh; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs]

Docs should update only the narrow `fork.prusaslicer.gcode-output` wording and should keep broad `generated-outputs` in progress plus every deferred generated-output/runtime/fork surface explicit. [VERIFIED: packages/parity/status.tsv; docs/port/parity-matrix.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**Primary recommendation:** Add a compatibility-preserving `--structural <expected-gcode-structural-summary.tsv>` mode to the existing `prusa_gcode_output_summary` Rust binary, feed that mode from `compare_prusaslicer_gcode_output.sh`, and extend the existing parity failure test with one `command_count_g1` structural mutation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity/compare_prusaslicer_gcode_output_test.sh]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Bazel | 8.6.0 | Public parity command/test execution and target data wiring | The repo root pins `.bazelversion` to `8.6.0`, and the current public G-code parity command is a Bazel `sh_binary`. [VERIFIED: .bazelversion; packages/parity/BUILD.bazel; `bazel --version`] |
| `rules_rust` | 0.69.0 | Bazel Rust library/binary/test integration | `MODULE.bazel` declares `rules_rust` 0.69.0 and registers Rust toolchains through its extension. [VERIFIED: MODULE.bazel] |
| Rust | 1.94.1, edition 2024 | Pure structural TSV parser, typed facts, and Rust CLI adapter | `MODULE.bazel` pins Rust and rustfmt 1.94.1; `packages/slic3r-rust/Cargo.toml` sets edition 2024 and `rust-version = "1.94"`. [VERIFIED: MODULE.bazel; packages/slic3r-rust/Cargo.toml; `cargo +1.94.1 --version`] |
| Bash | GNU bash 3.2.57 on this machine | Comparator orchestration and mutation-test harness | Existing parity and fixture comparators use `#!/usr/bin/env bash` plus `set -euo pipefail`; local Bash 3.2.57 is available. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; `bash --version`] |
| TSV fixtures | repo-owned files | Stable checked-in expected summaries and provenance | The summary and structural sidecar are exported from `packages/parity-fixtures/BUILD.bazel`, and fixture verification checks exact headers, rows, source/fixture values, and overclaim boundaries. [VERIFIED: packages/parity-fixtures/BUILD.bazel; packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

### Supporting

| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| Cargo | 1.94.1 via explicit rustup toolchain | Rust pre-commit sequence and focused Rust test runs | Use `cargo +1.94.1 ...` because the default local Cargo is 1.91.1 and is below the repo's Rust version requirement. [VERIFIED: `cargo --version`; `cargo +1.94.1 --version`; packages/slic3r-rust/Cargo.toml] |
| `awk`, `diff`, `grep`, `sed`, `mktemp` | system tools | Shell comparator labels, diffs, field extraction, and temp test fixtures | Existing comparator and verifier scripts already rely on these tools, and local `/usr/bin/awk` plus Apple diff are available. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; `which awk`; `diff --version`] |
| `shasum` | system tool | Fixture byte-integrity verification | Existing fixture verifier checks the G-code fixture SHA-256 through `shasum -a 256`, and the local command reproduced the expected hash. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; `shasum -a 256 .../gcodewriter-set-speed.gcode`] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Existing Rust binary with `--structural` mode | Add a second `prusa_gcode_output_structural_summary` binary | A second binary is allowed by discretion, but the existing parity target already carries one G-code summary binary and local adapter patterns use small single-purpose binaries per surface, so a mode preserves target shape with less Bazel churn. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Rust structural parser | Shell-only structural TSV checks in the comparator | Shell-only checks would violate D-02 because Phase 52 must validate structural evidence through Rust-owned parsing boundaries. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| Existing public target | New public structural parity target | A new target would require status/docs decisions to preserve the same status token, while D-01 already selects the existing public command unless a lower-risk adjacent target is found. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity/status.tsv] |

**Installation:**

No package installation is planned; use the repo-pinned Bazel/Rust toolchains and existing system shell utilities. [VERIFIED: MODULE.bazel; .bazelversion; environment probes]

```bash
bazel run //packages/parity:prusaslicer_gcode_output_parity
cargo +1.94.1 test -p slic3r_flavors --test prusa_gcode_output --manifest-path packages/slic3r-rust/Cargo.toml
```

**Version verification:** `bazel --version` returned `bazel 8.6.0`; `cargo +1.94.1 --version` returned `cargo 1.94.1`; `rustc +1.94.1 --version` returned `rustc 1.94.1`; default `cargo --version` returned `cargo 1.91.1`, so explicit `+1.94.1` is needed for Cargo verification. [VERIFIED: environment probes]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
|-- parity/
|   |-- BUILD.bazel                         # public parity target and failure test
|   |-- compare_prusaslicer_gcode_output.sh # thin Bash comparator/orchestrator
|   |-- compare_prusaslicer_gcode_output_test.sh
|   |-- status.tsv                          # exact narrow status row
|   `-- README.md                           # public command/package docs
|-- parity-fixtures/
|   `-- forks/prusaslicer/prusaslicer.gcode-output/
|       |-- expected-gcode-summary.tsv
|       `-- expected-gcode-structural-summary.tsv
`-- slic3r-rust/crates/slic3r_flavors/
    |-- src/prusa_gcode_output.rs           # pure typed summary + structural parser
    |-- src/bin/prusa_gcode_output_summary.rs
    `-- tests/prusa_gcode_output.rs
```

This structure already exists; Phase 52 should extend these files rather than create a new package boundary. [VERIFIED: `rg --files`; packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

### Pattern 1: Pure Rust Parser, Thin CLI Mode

**What:** Keep structural validation in `slic3r_flavors::prusa_gcode_output`; the CLI reads one file, chooses summary vs structural mode, calls a pure helper, and prints stable TSV-like summary lines. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs]

**When to use:** Use for GCEV-01 because the public parity command must validate the checked-in structural sidecar through Rust while keeping shell orchestration thin. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**Example:**

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs
// Recommended shape: preserve one-arg summary mode and add an explicit structural mode.
match args.as_slice() {
    [_, fixture_path] => run_summary(fixture_path),
    [_, mode, fixture_path] if mode == "--structural" => run_structural_summary(fixture_path),
    _ => {
        eprintln!("error: expected expected-gcode-summary.tsv or --structural expected-gcode-structural-summary.tsv");
        ExitCode::FAILURE
    }
}
```

The existing binary currently accepts exactly one `expected-gcode-summary.tsv` path and calls `prusa_gcode_output_summary_lines`, so the added mode should be compatibility-preserving. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs]

### Pattern 2: Public Comparator Validates Both Artifacts

**What:** Extend `compare_prusaslicer_gcode_output.sh` from four arguments to include both original and expected structural TSV paths, mirroring the current original-vs-mutated summary artifact pattern. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/compare_prusaslicer_gcode_output_test.sh]

**When to use:** Use when a mutation test needs the comparator to compare a known-good fixture input with a mutated expected artifact and report the first drifted field. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

**Example:**

```bash
# Source: packages/parity/compare_prusaslicer_gcode_output.sh
"${summary_binary}" --structural "${rust_structural_input}" >"${actual_structural_summary}"
if ! "${summary_binary}" --structural "${expected_structural_artifact}" >"${expected_structural_lines}"; then
    mismatch_label="$(first_structural_raw_mismatch_label "${rust_structural_input}" "${expected_structural_artifact}")"
    printf 'error: expected-gcode-structural-summary.tsv failed Rust structural summary validation at %s in %s\n' \
        "${mismatch_label}" "${expected_structural_artifact}" >&2
    exit 1
fi
```

The comparator should keep existing summary validation and add structural validation; it should not replace the v1.12 marker evidence path. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity/compare_prusaslicer_gcode_output.sh]

### Pattern 3: One Command-Level Structural Mutation Test

**What:** Keep the existing `line_4` marker mutation and add exactly one structural mutation, preferably `command_count_g1` from `4` to `3`. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**When to use:** Use for GCEV-02 to prove public-command fail-closed behavior without duplicating all fixture-level and Rust-parser rejection classes. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**Example:**

```bash
# Source: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
awk 'BEGIN { FS = OFS = "\t" } $3 == "command_count_g1" && $5 == "4" { $5 = "3"; changed++ } { print } END { exit changed == 1 ? 0 : 1 }' \
    "${structural_path}" >"${structural_path}.tmp"
```

The Phase 50 fixture mutation suite already uses this exact drift field and expects diagnostics to include `expected-gcode-structural-summary.tsv` plus `command_count_g1`. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh]

### Anti-Patterns to Avoid

- **Creating a new public package or broad target:** Phase 52 should strengthen `packages/parity` and preserve `//packages/parity:prusaslicer_gcode_output_parity` unless planning finds a lower-risk adjacent target, which the inspected code did not require. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity/BUILD.bazel]
- **Shell-only structural validation:** The fixture verifier already checks the structural TSV in Bash, but Phase 52's public command must go through the Rust structural parser. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]
- **Regenerating or comparing fresh G-code:** The fixture README says the accepted upstream tree has no checked-in `.gcode` blob and the namespace does not introduce live generation; Phase 52 only validates checked-in evidence. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]
- **Promoting `generated-outputs`:** The broad `generated-outputs` row is currently `in progress` and must stay that way. [VERIFIED: packages/parity/status.tsv; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]
- **Large opportunistic Rust refactor:** `prusa_gcode_output.rs` is 1,628 lines and Phase 51 verification flagged it as an info-level split trigger, but Phase 52 should avoid unrelated splits unless implementation changes become hard to review. [VERIFIED: .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Structural TSV validation | New shell parser in `packages/parity` | Existing `parse_prusa_gcode_output_structural_summary` plus a structural summary-lines helper | The Rust parser already enforces header, column count, required order, duplicates, supported fields, exact values, source/fixture identity, and boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs] |
| Public evidence target | New package or unrelated command | Existing `//packages/parity:prusaslicer_gcode_output_parity` | The status row already points to that target, and D-01 selects it as the maintainer entry point. [VERIFIED: packages/parity/status.tsv; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| Structural drift matrix | Recreate all Phase 50/51 negative tests in parity | One command-level `command_count_g1` drift test | D-07 explicitly says not to duplicate all lower-level rejection classes in `packages/parity`. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| G-code oracle | Runtime PrusaSlicer execution, upstream fetch/import, or generated output comparison | Checked-in fixture + expected summary + Rust parser validation | Phase 52 does not generate fresh G-code or compare PrusaSlicer runtime output. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md] |
| Broad parity wording | New prose implying generated-output completion | Exact narrow structural evidence wording plus deferred list | GCEV-03 requires broad `generated-outputs` to remain in progress and deferred surfaces to stay explicit. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/status.tsv] |

**Key insight:** The deceptive complexity is not parsing TSV text; it is preserving the evidence ladder without overclaiming, so the Rust parser should own structural truth and the shell comparator should only orchestrate, diff, label, and publish readable command output. [VERIFIED: .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md; packages/parity/compare_prusaslicer_gcode_output.sh]

## Common Pitfalls

### Pitfall 1: Mutated Structural TSV Fails With Generic Diagnostics

**What goes wrong:** A structural drift test can fail only with a generic Rust `Debug` error or diff, without naming `expected-gcode-structural-summary.tsv` and `command_count_g1`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**Why it happens:** The existing Rust CLI maps parser errors through `format!("failed to summarize {}: {error:?}", path.display())`, and the existing comparator only has summary-specific mismatch labels. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; packages/parity/compare_prusaslicer_gcode_output.sh]

**How to avoid:** Add a structural mismatch-label helper in the Bash comparator and assert exact diagnostic substrings in the parity failure test. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity/compare_prusaslicer_gcode_output_test.sh]

**Warning signs:** Test assertions look only for `diff`, `@@`, or a Rust enum variant instead of the artifact filename and structural field name. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

### Pitfall 2: Public Command Output Still Looks Summary-Only

**What goes wrong:** The command may validate structural data but still print only `rows: 5`, hiding Phase 52's stronger evidence from maintainers. [VERIFIED: current `bazel run //packages/parity:prusaslicer_gcode_output_parity` output]

**Why it happens:** The current comparator prints source ref, fixture path, expected summary path, and summary row count only. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh]

**How to avoid:** Print structural summary path, `structural_rows: 16`, fixture/source identity, command counts, ordered markers, movement/extrusion booleans, and temperature/tool-change counts after successful structural validation. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv]

**Warning signs:** Successful command output does not include `expected-gcode-structural-summary.tsv` or `command_count_g1`. [VERIFIED: current `bazel run //packages/parity:prusaslicer_gcode_output_parity` output]

### Pitfall 3: Status Docs Over-Promote Generated Outputs

**What goes wrong:** Updating the narrow fork row can accidentally imply full generated-output, byte-for-byte G-code, runtime, geometry, or printability parity. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

**Why it happens:** Existing docs contain repeated summary-only wording and broad deferred lists; a broad rewrite can easily change scope. [VERIFIED: `rg -n "summary-only|generated-outputs|deferred" ...`]

**How to avoid:** Edit only the exact `fork.prusaslicer.gcode-output` paragraphs/row notes and preserve the broad `generated-outputs` row status. [VERIFIED: packages/parity/status.tsv; docs/port/parity-matrix.md; packages/parity/README.md]

**Warning signs:** `packages/parity/status.tsv` no longer has exactly one `generated-outputs` row with status `in progress`, or docs omit deferred surfaces required by D-11. [VERIFIED: packages/parity/status.tsv; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

### Pitfall 4: Using Default Cargo Instead of the Pinned Toolchain

**What goes wrong:** Cargo checks can run under 1.91.1 locally even though the repo pins Rust 1.94.1. [VERIFIED: `cargo --version`; packages/slic3r-rust/Cargo.toml; MODULE.bazel]

**Why it happens:** The default toolchain is `stable-aarch64-apple-darwin`, while `1.94.1-aarch64-apple-darwin` is installed but not default. [VERIFIED: `rustup toolchain list`]

**How to avoid:** Use `cargo +1.94.1 ...` for Cargo verification and let Bazel use the registered Rust 1.94.1 toolchain. [VERIFIED: `cargo +1.94.1 --version`; MODULE.bazel]

**Warning signs:** `cargo test` runs without `+1.94.1`, or errors mention edition/toolchain mismatch. [VERIFIED: environment probes; packages/slic3r-rust/Cargo.toml]

## Code Examples

Verified patterns from local sources:

### Structural Summary Lines Helper

```rust
// Source: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs
pub fn prusa_gcode_output_structural_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaGcodeOutputStructuralParseError> {
    let summary = parse_prusa_gcode_output_structural_summary(input)?;
    let readiness = prusa_gcode_output_structural_readiness();
    let facts = summary.facts();

    Ok(vec![
        summary_line("structural_summary_path", readiness.expected_structural_summary_path),
        format!("structural_row_count\t{}", summary.rows().len()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("fixture_path", facts.fixture_path),
        format!("command_count_g1\t{}", facts.command_count_g1),
    ])
}
```

The exact final output should include all D-03 visible fields, not just the shortened example above. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]

### Comparator Structural Drift Label

```bash
# Source: packages/parity/compare_prusaslicer_gcode_output.sh
first_structural_raw_mismatch_label() {
    local expected_file="${1}"
    local actual_file="${2}"

    awk -F '\t' '
        NR == FNR { expected[FNR] = $0; expected_count = FNR; next }
        {
            actual_count = FNR
            if (!found && expected[FNR] != $0) {
                split(expected[FNR], fields, "\t")
                if (fields[3] != "") { print fields[3] } else { print "line" }
                found = 1
                exit
            }
        }
        END {
            if (!found && expected_count != actual_count) { print "line_count" }
        }
    ' "${expected_file}" "${actual_file}"
}
```

This mirrors the existing `first_raw_mismatch_label` / `first_summary_mismatch_label` pattern while using structural field column 3 as the diagnostic label. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv]

### Bazel Wiring

```python
# Source: packages/parity/BUILD.bazel
sh_binary(
    name = "prusaslicer_gcode_output_parity",
    srcs = ["compare_prusaslicer_gcode_output.sh"],
    data = [
        "status.tsv",
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary",
        "//packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary",
        "//packages/parity-fixtures:prusa_gcode_output_expected_gcode_structural_summary",
        "//packages/parity-fixtures:prusa_gcode_output_provenance",
    ],
)
```

The exact args should pass both a Rust-input and expected-artifact path for summary and structural TSVs so mutation tests can compare original vs mutated artifacts. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Summary-only G-code evidence through `expected-gcode-summary.tsv` | Structural sidecar exists and Rust parser/readiness is complete, but public command/docs are not yet structural | Phase 50 and Phase 51 completed by 2026-06-18 | Phase 52 should publish structural evidence through the public parity command and docs without changing broad generated-output status. [VERIFIED: .planning/phases/50-structural-g-code-fixture-expansion/50-CONTEXT.md; .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md; packages/parity/status.tsv] |
| Public command output reports only summary rows | Public command should report structural path, 16 structural rows, and typed structural facts | Phase 52 scope | Maintainers can inspect the exact narrow structural evidence slice directly from the public command. [VERIFIED: current `bazel run //packages/parity:prusaslicer_gcode_output_parity` output; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| Failure test covers only `line_4` marker drift | Failure test should also cover one structural-summary drift | Phase 52 scope | GCEV-02 proves command-level fail-closed behavior for the structural sidecar. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; .planning/REQUIREMENTS.md] |

**Deprecated/outdated:**

- Summary-only wording for `fork.prusaslicer.gcode-output` will become outdated after Phase 52 implementation; replace it with narrow structural evidence wording. [VERIFIED: packages/parity/status.tsv; packages/parity/README.md; docs/port/parity-matrix.md]
- The phrase "public structural parity/status publication remains Phase 52-owned" in fixture docs is true before Phase 52 execution and should be reviewed if those docs are touched by the Phase 52 publication change. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md]

## Assumptions Log

No assumption-tagged claims are used in this research; all recommendations are based on repo context, code inspection, command probes, or cited upstream standards. [VERIFIED: this RESEARCH.md]

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | All claims are verified or cited. | All | No user confirmation needed before planning. |

## Open Questions (RESOLVED)

RESOLVED: Do not split `prusa_gcode_output.rs` during Phase 52; record future cleanup only if implementation changes make reviewability worse.

1. **Should Phase 52 split `prusa_gcode_output.rs` while touching Rust?** [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md]
   - What we know: The file is 1,628 lines and Phase 51 verification recorded that as an info-level Bright Builds split trigger. [VERIFIED: .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md]
   - What's unclear: A split could improve maintainability but would expand Phase 52 beyond its narrow publication/evidence scope. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md]
   - Recommendation: Do not split during Phase 52 unless the structural summary-lines helper materially worsens reviewability; record a future cleanup instead. [VERIFIED: Bright Builds code-shape guidance; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Public parity command/test and Rust Bazel targets | Yes | 8.6.0 | None needed. [VERIFIED: `.bazelversion`; `bazel --version`] |
| `rules_rust` | Bazel Rust targets | Yes | 0.69.0 | None needed. [VERIFIED: MODULE.bazel] |
| Rust toolchain | Cargo verification and Rust implementation | Yes with explicit toolchain | 1.94.1 installed; default is 1.91.1 | Use `cargo +1.94.1` / `rustc +1.94.1`; do not rely on default Cargo. [VERIFIED: `rustup toolchain list`; `cargo --version`; `cargo +1.94.1 --version`] |
| Bash | Comparator and tests | Yes | GNU bash 3.2.57 | Keep scripts Bash-3.2-compatible because that is the local shell version. [VERIFIED: `bash --version`; existing scripts] |
| `awk` / `diff` / `grep` / `sed` / `mktemp` | Comparator helper logic and mutation tests | Yes | system tools | None needed; keep POSIX-ish usage consistent with existing scripts. [VERIFIED: `which awk`; `diff --version`; existing scripts] |
| `shasum` | Fixture verifier | Yes | system tool | None needed. [VERIFIED: `shasum -a 256 ...`] |
| Git | Optional research doc commit | Yes | 2.53.0 | None needed. [VERIFIED: `git --version`] |

**Missing dependencies with no fallback:**

- None found for Phase 52 planning and implementation. [VERIFIED: environment probes]

**Missing dependencies with fallback:**

- Default Cargo is too old for the repo's Rust requirement, but `cargo +1.94.1` is installed and should be used. [VERIFIED: environment probes; packages/slic3r-rust/Cargo.toml]

## Security Domain

Security enforcement is not explicitly disabled in `.planning/config.json`, so include this section. [VERIFIED: .planning/config.json]

OWASP ASVS is a web-application verification standard, and its current stable project page identifies ASVS 5.0.0 as the latest stable version; this phase is a local CLI/parser evidence phase, so web auth/session controls are mostly not applicable. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | No | No authentication surface is introduced by local Bazel/Rust/Bash evidence commands. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| V3 Session Management | No | No session or cookie state exists in the parity command path. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs] |
| V4 Access Control | No | No multi-user access-control boundary is introduced; the command reads checked-in fixture files supplied by Bazel. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel] |
| V5 Input Validation | Yes | Validate TSV structure and values through typed Rust parser boundaries, then shell compares exact outputs and labels failures. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity/compare_prusaslicer_gcode_output.sh] |
| V6 Cryptography | No | No new cryptographic operation is introduced; existing fixture SHA-256 verification remains in the fixture verifier. [VERIFIED: packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |

### Known Threat Patterns for Phase 52 Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Tampered checked-in structural TSV passes public evidence | Tampering | Parse with `parse_prusa_gcode_output_structural_summary`, assert expected structural facts, and add command-level mutation coverage. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs; packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh] |
| Status/docs overclaim broad generated-output or runtime support | Information disclosure / Repudiation of evidence scope | Keep `generated-outputs` status `in progress` and preserve explicit deferred-surface lists in status/docs. [VERIFIED: packages/parity/status.tsv; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |
| Shell comparator hides a failing Rust structural parse | Tampering / Repudiation | Use `set -euo pipefail`, explicit `if ! command` failure blocks, and artifact/field-specific diagnostics. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; Bright Builds code-shape guidance] |
| Runtime/upstream execution sneaks into evidence path | Elevation of privilege / Tampering | Do not fetch, import, generate, upload, or run PrusaSlicer runtime behavior; validate checked-in artifacts only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md; .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md] |

## Validation Commands for Planner

Run these after implementation, scoped to changed paths. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; AGENTS.md]

```bash
bazel run //packages/parity:prusaslicer_gcode_output_parity
bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test
bazel test --cache_test_results=no //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_test //packages/slic3r-rust/crates/slic3r_flavors:flavor_registry_test //packages/slic3r-rust/crates/slic3r_flavors:rustfmt_check
bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture
bazel run //packages/prusa-gcode-output-scope:verify
```

If Rust files change, run the Rust pre-commit sequence from the Rust workspace with the explicit pinned toolchain. [VERIFIED: AGENTS.md; packages/slic3r-rust/Cargo.toml; environment probes]

```bash
cd packages/slic3r-rust
cargo +1.94.1 fmt --all
cargo +1.94.1 clippy --all-targets --all-features -- -D warnings
cargo +1.94.1 build --all-targets --all-features
cargo +1.94.1 test --all-features
```

Run `git diff --check` before finalizing to catch whitespace issues. [VERIFIED: AGENTS.md; Phase 51 verification command pattern]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md` - locked Phase 52 decisions, constraints, deferrals, and canonical refs. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - GCEV-01, GCEV-02, GCEV-03, and v1.13 out-of-scope requirements. [VERIFIED: file read]
- `.planning/ROADMAP.md` - Phase 52 goal, dependency, success criteria, and milestone boundaries. [VERIFIED: file read]
- `.planning/STATE.md` and `.planning/PROJECT.md` - current project state and accumulated evidence-chain decisions. [VERIFIED: file read]
- Phase 49, 50, and 51 context/verification files - structural contract, fixture sidecar, and Rust boundary readiness. [VERIFIED: file read]
- `packages/parity/BUILD.bazel`, `compare_prusaslicer_gcode_output.sh`, `compare_prusaslicer_gcode_output_test.sh`, `status.tsv`, and `README.md` - existing public parity surface and mutation guard. [VERIFIED: file read + `rg`]
- `packages/parity-fixtures/BUILD.bazel`, `expected-gcode-summary.tsv`, `expected-gcode-structural-summary.tsv`, `fixture-provenance.tsv`, and fixture verifier/test scripts - checked-in fixture expectations and structural drift patterns. [VERIFIED: file read + `rg`]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`, `src/bin/prusa_gcode_output_summary.rs`, Rust tests, and Bazel/Cargo manifests - typed parser/readiness boundary and CLI adapter. [VERIFIED: file read + `rg`]
- `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and `docs/port/package-map.md` - public port docs that still contain summary-only G-code wording. [VERIFIED: file read + `rg`]
- Local environment probes for Bazel, Rust/Cargo, Bash, Git, `awk`, `diff`, and `shasum`. [VERIFIED: command output]

### Primary External (HIGH confidence)

- Bright Builds standards index, architecture, code-shape, verification, testing, local-guidance, operability, and Rust pages at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/index.md]
- OWASP ASVS project page for current ASVS context and applicability. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Secondary (MEDIUM confidence)

- None used. [VERIFIED: research process]

### Tertiary (LOW confidence)

- None used. [VERIFIED: research process]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - versions and target wiring were verified from repo manifests and local command probes. [VERIFIED: .bazelversion; MODULE.bazel; packages/slic3r-rust/Cargo.toml; environment probes]
- Architecture: HIGH - Phase 52 is constrained by existing packages and locked decisions, and the inspected files show clear local patterns. [VERIFIED: .planning/phases/52-executable-structural-g-code-evidence/52-CONTEXT.md; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]
- Pitfalls: HIGH - pitfalls come from current command output, existing summary-only docs, default-vs-pinned Rust toolchain probes, and Phase 51 verification notes. [VERIFIED: command output; docs/port/parity-matrix.md; packages/parity/status.tsv; environment probes; .planning/phases/51-rust-structural-g-code-summary-boundary/51-VERIFICATION.md]

**Research date:** 2026-06-18
**Valid until:** 2026-07-18, unless Phase 52 implementation or repo toolchain pins change first. [VERIFIED: .planning/config.json; MODULE.bazel]
