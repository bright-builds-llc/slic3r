# Phase 44: Executable Prusa Project-File Parity - Research

**Researched:** 2026-06-05 [VERIFIED: current_date context]\
**Domain:** Bazel shell parity command, Rust summary adapter, fixture/status publication, non-overclaiming docs [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md]\
**Confidence:** HIGH [VERIFIED: local codebase audit; environment audit]

<user_constraints>

## User Constraints (from CONTEXT.md)

Source: [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Parity Command Surface

- **D-01:** Create the Phase 41 planned command
  `bazel run //packages/parity:prusaslicer_project_file_parity` in
  `packages/parity`.
- **D-02:** Mirror the narrow Prusa profile-schema parity command pattern:
  a repo-owned shell comparator, a Bazel `sh_binary`, fixture data from
  `packages/parity-fixtures`, and Rust summary output from
  `slic3r_flavors`.
- **D-03:** Add a Rust summary binary for project-file evidence only if needed
  to expose `prusa_project_file_summary_lines` to the shell comparator. Keep
  it in the existing `packages/slic3r-rust/crates/slic3r_flavors` crate and
  keep the production Rust boundary data-in/data-out.

### Expected Evidence Comparison

- **D-04:** Compare the Rust-backed summary of
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv`
  against the checked-in expected project summary. Do not inspect, parse, or
  claim full 3MF container semantics beyond the Phase 42 presence-level rows.
- **D-05:** The comparator must fail closed when the Rust summary output or
  checked-in expected artifact diverges. The first mismatch should name a
  useful row or line label and include a diff, following the profile-schema
  comparator precedent.
- **D-06:** The success output should include the exact status token
  `fork.prusaslicer.project-file`, accepted source ref, fixture path, expected
  artifact path, and row count so maintainers can audit what passed.

### Failure Guard

- **D-07:** Add a Bazel `sh_test` failure guard for the project-file parity
  comparator. It should mutate a temporary copy of
  `expected-project-summary.tsv`, prove the comparator exits non-zero, and
  assert that the original checked-in expected artifact remains unchanged.
- **D-08:** Keep mutation tests local and hermetic. Do not mutate checked-in
  fixture files, fetch upstream source, run Git, access network services,
  execute profile auto-update behavior, import upstream source trees, or
  ingest plugins.

### Status and Docs Publication

- **D-09:** Add a `fork.prusaslicer.project-file` row to
  `packages/parity/status.tsv` only after the runnable command exists and
  passes.
- **D-10:** Update `packages/parity/README.md`, `docs/port/README.md`,
  `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and
  `docs/port/parity-matrix.md` as needed so maintainers can run the command
  and understand the exact evidence slice.
- **D-11:** Docs and status wording must say this is a narrow
  `prusaslicer.project-file` expected-summary evidence slice backed by the
  Phase 42 fixture and Phase 43 Rust summary boundary, not full PrusaSlicer
  project loading, GUI behavior, load/save behavior, 3MF import/export, or
  generated-output parity.

### Verification Shape

- **D-12:** Verification should include the new parity command, its failure
  guard test, the relevant Rust/Bazel checks for any new Rust binary wiring,
  and documentation/status text checks proving exact scope and deferred
  surfaces.
- **D-13:** Keep this phase aligned with PPEV-01, PPEV-02, and PPEV-03: runnable
  command, divergence failure evidence, and exact docs/status publication.

### the agent's Discretion

- The agent may choose the exact comparator helper names and row-label
  extraction logic, provided errors remain actionable and failure tests prove
  divergence.
- The agent may decide whether a tiny Rust CLI binary is necessary or whether
  an existing binary surface can be reused without weakening the pure Rust
  boundary.
- The agent may choose the minimum docs edits needed to publish the verified
  evidence without rewriting unrelated milestone history.

### Deferred Ideas (OUT OF SCOPE)

## Deferred Ideas

None - yolo discussion stayed within Phase 44 scope.
</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PPEV-01 | Maintainer can run a repo-owned Bazel parity command for the selected Prusa project-file evidence slice. [VERIFIED: .planning/REQUIREMENTS.md] | Add `sh_binary(name = "prusaslicer_project_file_parity")` in `packages/parity/BUILD.bazel`, following the existing Prusa profile-schema command pattern. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_prusaslicer_profile_schema.sh] |
| PPEV-02 | Maintainer can see the Prusa project-file parity command fail when the Rust-backed summary or checked-in expected artifact diverges from fixture expectations. [VERIFIED: .planning/REQUIREMENTS.md] | Add a `sh_test` that copies and mutates `expected-project-summary.tsv`, runs the real comparator against original Rust input and mutated expected data, asserts non-zero exit, checks diagnostics, and checks the real artifact is unchanged. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; packages/parity/compare_prusaslicer_profile_schema_test.sh] |
| PPEV-03 | Maintainer can inspect docs and parity status updates that name the exact verified Prusa project-file evidence slice and keep broad PrusaSlicer runtime, GUI, generated-output, STEP, support, arc fitting, seam, release, network/device, profile auto-update, and sync surfaces deferred. [VERIFIED: .planning/REQUIREMENTS.md] | Publish exactly one `fork.prusaslicer.project-file` status row after the command passes, update stale Phase 44 deferral docs, and keep explicit deferral wording in parity/package/port docs. [VERIFIED: packages/parity/status.tsv absence audit; packages/parity/README.md; docs/port/README.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md] |
</phase_requirements>

## Summary

Phase 44 should be planned as the project-file analogue of Phase 40 profile-schema executable parity, not as a 3MF parser, PrusaSlicer runtime, GUI, or generated-output implementation. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; .planning/ROADMAP.md] The existing repo pattern is a `packages/parity` Bazel `sh_binary` that calls a thin Rust summary binary, compares actual summary output against deterministic expected data, reports a row label and `diff -u` on divergence, and prints exact evidence metadata on success. [VERIFIED: packages/parity/BUILD.bazel; packages/parity/compare_prusaslicer_profile_schema.sh; .planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-VERIFICATION.md]

The Phase 43 Rust boundary already exposes `prusa_project_file_summary_lines(input)` over caller-supplied `expected-project-summary.tsv` text, so the likely Rust work is only a tiny `src/bin/prusa_project_file_summary.rs` adapter plus Bazel `rust_binary` wiring. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] The comparator should avoid a degenerate same-file self-comparison by accepting separate paths for the Rust summary input and the expected artifact; the normal Bazel command can pass the same checked-in alias for both, while the failure guard can pass the original checked-in artifact as Rust input and a mutated temp copy as the expected side. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04..D-07; packages/parity/compare_prusaslicer_profile_schema_test.sh]

The planner must include the Phase 42 verifier transition as a first-class task. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh] Those scripts currently fail if `fork.prusaslicer.project-file` or `prusaslicer_project_file_parity` appears, so Phase 44 must replace absence guards with exact status-row and target-publication validation after the parity command passes. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh; .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md]

**Primary recommendation:** Implement one narrow command slice: a Rust summary CLI over `expected-project-summary.tsv`, a fail-closed `packages/parity` shell comparator, a Bazel mutation failure test, an exact `fork.prusaslicer.project-file` status row, and minimal docs/verifier updates that name the Phase 42 fixture and Phase 43 Rust summary boundary while preserving all deferred surfaces. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; packages/parity/compare_prusaslicer_profile_schema.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

## Project Constraints (from AGENTS.md)

- Read and honor `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant Bright Builds canonical standards before planning or implementation. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md; standards-overrides.md; Bright Builds standards fetch]
- Repo-local summary files must use the exact YAML key `requirements-completed`, and `requirements-completed: []` is required when no mapped requirements close. [VERIFIED: AGENTS.md]
- Do not run `mdformat` over phase `*-SUMMARY.md` files; verify summaries through summary extraction, frontmatter integrity, and `git diff --check` instead. [VERIFIED: AGENTS.md]
- Backfill only affected summary frontmatter blocks when summaries are involved; do not rewrite summary bodies unless the text is wrong. [VERIFIED: AGENTS.md]
- Use functional core / imperative shell: keep Rust project-file parsing and summary logic data-in/data-out, with shell/Bazel owning explicit file/process orchestration. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]
- Parse boundary data into domain types and make illegal states unrepresentable where practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Prefer early returns, Rust `let...else` guard extraction where clearer, and `maybe_` prefixes for optional internal names. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/languages/rust.md]
- Unit tests for pure/business logic must focus on one concern and clearly follow Arrange, Act, Assert unless trivially obvious. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]
- Checked-in shell scripts should use `#!/usr/bin/env bash` and `set -euo pipefail`. [VERIFIED: user-provided AGENTS.md instructions; packages/parity/compare_prusaslicer_profile_schema.sh; packages/parity-fixtures/verify_prusa_project_file_fixture.sh]
- Before committing in this Rust project, run `cargo fmt --all`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo build --all-targets --all-features`, and `cargo test --all-features` in order unless the commit is not created. [VERIFIED: user-provided AGENTS.md instructions]
- No concrete project-local standards overrides were found beyond the placeholder table in `standards-overrides.md`. [VERIFIED: standards-overrides.md]
- No project-local `.claude/skills/` or `.agents/skills/` directory was found in this checkout. [VERIFIED: shell audit]

## Standard Stack

### Core

| Tool or Library | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Bazel / Bazelisk | 8.6.0 from `.bazelversion` and local `bazel --version` | Own maintainer-facing parity command, fixture verifier command, and failure tests. | Existing parity and fixture surfaces are Bazel `sh_binary` and `sh_test` targets. [VERIFIED: .bazelversion; environment audit; packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel] |
| Bash | GNU bash 3.2.57 locally | Implement thin fail-closed comparator and mutation tests. | Existing parity comparators and fixture verifiers are Bash scripts with explicit args and temp dirs. [VERIFIED: environment audit; packages/parity/compare_prusaslicer_profile_schema.sh; packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| Rust `slic3r_flavors` crate | crate version 0.1.0; Rust edition 2024; rustc 1.94.1 for verification | Produce typed project-file summary lines from caller-supplied TSV text. | Phase 43 already implemented `parse_prusa_project_file_summary`, `prusa_project_file_metadata`, and `prusa_project_file_summary_lines` in this crate. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; environment audit] |
| Rust standard library | rustc 1.94.1 locally | Read one explicit file path in the CLI adapter and call the pure Rust summary function. | The crate has no external project-file parsing dependencies beyond `slic3r_contracts`, and the profile-schema summary binary uses `std::fs::read_to_string` for the same adapter role. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs] |
| `diff -u` | Apple diff locally | Emit actionable expected-vs-actual mismatch output. | The profile-schema comparator uses `diff -u` and reports the first mismatched label before the diff. [VERIFIED: environment audit; packages/parity/compare_prusaslicer_profile_schema.sh] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| `mdformat` | 1.0.0 locally | Check touched Markdown docs. | Use on package and port docs, but not phase `*-SUMMARY.md` files. [VERIFIED: environment audit; AGENTS.md] |
| `shfmt` | 3.12.0 locally | Check touched shell scripts. | Use diff/check mode on new comparator and test scripts. [VERIFIED: environment audit; Bright Builds verification standard] |
| `rg` | 15.1.0 locally | Fast docs/status/scope guards. | Use for exact token, command, deferral, and forbidden-overclaim scans. [VERIFIED: environment audit; repo instruction preference] |
| `/usr/bin/awk` | available locally | TSV field checks and first mismatch labels. | Use for status row validation and shell-derived expected summary lines. [VERIFIED: environment audit; packages/parity/compare_prusaslicer_profile_schema.sh; packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| `shasum` | 6.02 locally | Preserve existing fixture checksum verification. | Keep in `verify_prusa_project_file_fixture.sh` for `seam_test_object.3mf`; do not use as parity proof by itself. [VERIFIED: environment audit; packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| `zipinfo` / `unzip` | ZipInfo 3.00 / UnZip 6.00 locally | Preserve existing archive-member fixture validation. | Keep in the Phase 42 fixture verifier; Phase 44 parity command should not broaden into new 3MF container parsing. [VERIFIED: environment audit; packages/parity-fixtures/verify_prusa_project_file_fixture.sh; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Rust summary CLI plus shell comparator | All-shell validation of `expected-project-summary.tsv` | All-shell validation would not prove Rust-backed summary output and would miss PPEV-01/PPEV-02 intent. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs] |
| Line-oriented TSV summary output | JSON summary output | JSON would need a new dependency or hand-rolled escaping, while the repo already uses TSV and line snapshots for Prusa evidence. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv; packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/expected-summary.tsv] |
| Separate Rust-input and expected-artifact comparator args | One argument reused internally for both actual and expected | A one-path self-comparison makes it hard to prove checked-in expected artifact divergence; separate args let the normal command pass the same alias while the failure guard mutates only the expected side. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-05..D-07; packages/parity/compare_prusaslicer_profile_schema_test.sh] |
| Existing Phase 42 archive verifier as the parity command | New `//packages/parity:prusaslicer_project_file_parity` command | The Phase 42 verifier proves fixture integrity and currently rejects Phase 44 publication; PPEV-01 requires a repo-owned parity command in `packages/parity`. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity/BUILD.bazel] |
| Parsing or summarizing `seam_test_object.3mf` in Rust | Staying on expected-summary evidence only | Rust archive parsing would broaden beyond the locked Phase 42 presence-level expected rows and the Phase 43 data-in/data-out boundary. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs] |

**Installation:** No new package or crate installation is needed for Phase 44. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; environment audit]

```bash
# Use existing repo tools.
bazel run //packages/parity:prusaslicer_project_file_parity
bazel test //packages/parity:prusaslicer_project_file_parity_failure_test
```

**Version verification:** `bazel --version` returned `bazel 8.6.0`, `.bazelversion` contains `8.6.0`, `rustup run 1.94.1 rustc --version` returned `rustc 1.94.1`, and `rustup run 1.94.1 cargo --version` returned `cargo 1.94.1`. [VERIFIED: environment audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/slic3r-rust/crates/slic3r_flavors/src/
├── prusa_project_file.rs                         # existing pure parser/metadata/summary boundary
└── bin/prusa_project_file_summary.rs             # new thin explicit-path CLI adapter

packages/parity/
├── compare_prusaslicer_project_file.sh           # new fail-closed comparator
├── compare_prusaslicer_project_file_test.sh      # new mutation failure guard
├── BUILD.bazel                                   # new sh_binary + sh_test
├── README.md                                     # command/status docs
└── status.tsv                                    # exact verified row after command passes

packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/
├── expected-project-summary.tsv                  # existing checked-in expected artifact
├── fixture-provenance.tsv                        # existing source/ref/hash/update metadata
├── seam_test_object.3mf                          # existing Phase 42 fixture bytes
└── README.md                                     # update Phase 44 publication wording
```

This structure keeps `packages/parity` as the maintainer-facing evidence owner, keeps project-file expected data under `packages/parity-fixtures`, and keeps Rust logic in the existing `slic3r_flavors` crate. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md]

### Pattern 1: Thin Rust Summary Adapter

**What:** Add a Rust binary that accepts exactly one explicit `expected-project-summary.tsv` path, reads it, calls `prusa_project_file_summary_lines(&input)`, prints each line, and exits non-zero with `error:` diagnostics on argument/read/parse failure. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**When to use:** Use this because the shell comparator needs Rust-backed project-file summary output, and no project-file CLI binary exists yet. \[VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; find audit of `src/bin`\]

**Example:**

```rust
// Source: mirror packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs
#![forbid(unsafe_code)]

use std::env;
use std::ffi::OsStr;
use std::fs;
use std::path::Path;
use std::process::ExitCode;

use slic3r_flavors::prusa_project_file_summary_lines;

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    if args.len() != 2 {
        eprintln!("error: expected exactly one expected-project-summary.tsv path argument");
        return ExitCode::FAILURE;
    }

    match run(&args[1]) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run(expected_summary_path: &OsStr) -> Result<(), String> {
    let path = Path::new(expected_summary_path);
    let input = fs::read_to_string(path)
        .map_err(|error| format!("failed to read {}: {error}", path.display()))?;
    let lines = prusa_project_file_summary_lines(&input)
        .map_err(|error| format!("failed to parse {}: {error:?}", path.display()))?;

    for line in lines {
        println!("{line}");
    }

    Ok(())
}
```

### Pattern 2: Bazel `rust_binary` Wiring

**What:** Add `rust_binary(name = "prusa_project_file_summary")` to the `slic3r_flavors` Bazel package and include it in crate-level `rust_clippy` and `rustfmt_test` targets. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**When to use:** Use this if no existing binary surface can expose `prusa_project_file_summary_lines` without weakening the pure Rust boundary. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-03]

**Example:**

```python
# Source: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel profile-schema binary pattern
rust_binary(
    name = "prusa_project_file_summary",
    srcs = ["src/bin/prusa_project_file_summary.rs"],
    crate_root = "src/bin/prusa_project_file_summary.rs",
    deps = [":slic3r_flavors"],
    edition = "2024",
)
```

### Pattern 3: Project-File Comparator With Separate Actual and Expected Paths

**What:** Add `compare_prusaslicer_project_file.sh` that accepts a summary binary path, a Rust input `expected-project-summary.tsv`, an expected artifact `expected-project-summary.tsv`, and fixture provenance; it writes actual summary output to a temp file, builds expected summary lines from the expected artifact, diffs them, and prints exact success metadata. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema.sh; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04..D-06]

**When to use:** Use this shape to let the normal Bazel command compare the checked-in expected artifact while the failure guard can mutate only the expected side. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema_test.sh; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-07]

**Example:**

```bash
# Source: adapted from packages/parity/compare_prusaslicer_profile_schema.sh
if [[ "$#" -ne 4 ]]; then
	printf 'error: expected summary_binary rust-input-expected-project-summary.tsv expected-project-summary.tsv fixture-provenance.tsv\n' >&2
	exit 2
fi

summary_binary="${1}"
rust_input_expected_summary="${2}"
expected_project_summary="${3}"
fixture_provenance="${4}"

"${summary_binary}" "${rust_input_expected_summary}" >"${actual_summary}"
write_expected_summary_lines "${expected_project_summary}" >"${expected_summary_lines}"

if ! diff_output="$(diff -u "${expected_summary_lines}" "${actual_summary}")"; then
	mismatch_label="$(first_mismatch_label "${expected_summary_lines}" "${actual_summary}")"
	printf 'error: expected-project-summary.tsv mismatch at %s in %s\n' \
		"${mismatch_label}" "${expected_project_summary}" >&2
	printf '%s\n' "${diff_output}" >&2
	exit 1
fi
```

### Pattern 4: Normal Bazel Command Passes the Checked-In Artifact Twice

**What:** The public `sh_binary` should pass `//packages/parity-fixtures:prusa_project_file_expected_project_summary` both as Rust input and as expected artifact. [VERIFIED: packages/parity-fixtures/BUILD.bazel alias; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04]

**When to use:** Use this for the normal maintainer command so the Rust summary validates the checked-in Phase 42 artifact and the comparator reports the expected artifact path. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv]

**Example:**

```python
# Source: packages/parity/BUILD.bazel sh_binary pattern
sh_binary(
    name = "prusaslicer_project_file_parity",
    srcs = ["compare_prusaslicer_project_file.sh"],
    data = [
        "status.tsv",
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_summary",
        "//packages/parity-fixtures:prusa_project_file_expected_project_summary",
        "//packages/parity-fixtures:prusa_project_file_provenance",
    ],
    args = [
        "$(location //packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_summary)",
        "$(location //packages/parity-fixtures:prusa_project_file_expected_project_summary)",
        "$(location //packages/parity-fixtures:prusa_project_file_expected_project_summary)",
        "$(location //packages/parity-fixtures:prusa_project_file_provenance)",
    ],
)
```

### Pattern 5: Mutation Failure Guard

**What:** Add `sh_test(name = "prusaslicer_project_file_parity_failure_test")` that copies `expected-project-summary.tsv`, mutates a single field in the temp copy, runs the comparator with original Rust input and mutated expected artifact, asserts non-zero exit, asserts useful diagnostics, and asserts the real expected artifact remains unchanged. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-07; packages/parity/compare_prusaslicer_profile_schema_test.sh]

**When to use:** Use this to satisfy PPEV-02 without mutating checked-in fixture files or requiring Git/network/upstream access. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08]

**Example:**

```bash
# Source: adapted from packages/parity/compare_prusaslicer_profile_schema_test.sh
mutated_expected="${tmp_dir}/expected-project-summary.tsv"
cp "${expected_summary}" "${mutated_expected}"
mutate_project_marker "${mutated_expected}"

if run_comparator "${expected_summary}" "${mutated_expected}" \
	"${tmp_dir}/mutated.out" "${tmp_dir}/mutated.err"; then
	fail "mutated expected-project-summary.tsv passed"
fi

assert_contains "${tmp_dir}/mutated.err" "expected-project-summary.tsv"
assert_contains "${tmp_dir}/mutated.err" "project_marker"
assert_contains "${expected_summary}" $'\t[Content_Types].xml\topc-content-types\t'
```

### Pattern 6: Fixture Verifier Status Transition

**What:** Replace `verify_status_row_absent` and `verify_parity_target_absent` with validation that the command target and exactly one status row exist after Phase 44 publication. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh]

**When to use:** Use this after `bazel run //packages/parity:prusaslicer_project_file_parity` passes, because D-09 forbids status publication before runnable evidence exists. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-09]

**Example status row:**

```tsv
fork.prusaslicer.project-file	verified	//packages/parity:prusaslicer_project_file_parity	Shared fixture comparison proves the narrow Prusa project-file expected-summary evidence slice only; full PrusaSlicer runtime support, GUI support, generated-output parity, STEP import, support generation, arc fitting, wall seam behavior, fork release builds, network/device integration, profile auto-update execution, and sync automation remain deferred
```

### Anti-Patterns to Avoid

- **Self-comparison that cannot fail:** Passing one expected file and deriving both actual and expected from the same mutated bytes can mask expected-artifact drift. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-05..D-07]
- **Publishing status before command proof:** `fork.prusaslicer.project-file` must stay absent until the runnable command exists and passes. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-09; packages/parity/status.tsv absence audit]
- **Leaving Phase 42 absence guards in place:** The current fixture verifier intentionally rejects the target and status row Phase 44 must add. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]
- **Parsing full 3MF in Phase 44:** The locked evidence slice is the Phase 42 expected-summary artifact and Phase 43 Rust summary boundary, not full 3MF import/export or project loading. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]
- **Mutating checked-in fixtures in tests:** Failure tests must mutate temp copies and prove the checked-in expected artifact remains unchanged. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-07; packages/parity/compare_prusaslicer_profile_schema_test.sh]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| 3MF container semantics | A new Rust ZIP/XML/3MF parser for `seam_test_object.3mf` | Existing Phase 42 expected summary plus `prusa_project_file_summary_lines` | Phase 44 scope is presence-level expected-summary evidence only. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-04; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv] |
| Project-file summary logic | Shell-only parsing as the evidence source | `slic3r_flavors::prusa_project_file_summary_lines` | PPEV-01/PPEV-02 require Rust-backed summary evidence, and Phase 43 already owns the typed parser. [VERIFIED: .planning/REQUIREMENTS.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs] |
| Expected artifact generation | Generating expected output from actual output during the command | Checked-in expected artifact and fail-closed diff | Generating expected data at runtime would hide divergence and fail PPEV-02. [VERIFIED: .planning/REQUIREMENTS.md; packages/parity/compare_prusaslicer_profile_schema.sh] |
| Upstream fixture refresh | Git clone/fetch, network downloads, or branch-head source reads | Existing checked-in `seam_test_object.3mf`, provenance, and expected TSV | Phase 44 must stay local and hermetic. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/fixture-provenance.tsv] |
| Broad status interpretation | A `verified` row that implies full PrusaSlicer project support | Exact status notes naming the narrow expected-summary evidence slice and deferrals | PPEV-03 requires status/docs to limit the verified claim. [VERIFIED: .planning/REQUIREMENTS.md; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11] |

**Key insight:** The project-file parity command is an executable trust-chain proof over a narrow checked-in expected-summary artifact; it is not a project-loader implementation and should not create new runtime semantics. [VERIFIED: .planning/ROADMAP.md; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

## Common Pitfalls

### Pitfall 1: Phase 42 Guards Fail After Publication

**What goes wrong:** `bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture` fails because it still rejects `fork.prusaslicer.project-file` and `prusaslicer_project_file_parity`. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**Why it happens:** Phase 42 and Phase 43 correctly kept executable parity/status absent until Phase 44, so the verifier is currently an absence guard. [VERIFIED: .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md]

**How to avoid:** Plan a verifier/status transition task after command proof: replace absence checks with exact row/target checks and update `verify_prusa_project_file_fixture_test.sh` to cover missing, duplicate, wrong evidence, and overclaiming notes. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh]

**Warning signs:** `rg -n "forbidden premature row|forbidden premature target" packages/parity-fixtures/verify_prusa_project_file_fixture.sh` still returns matches after the status row is added. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

### Pitfall 2: Divergence Test Mutates the Rust Input and Expected Side Together

**What goes wrong:** The failure guard mutates the only file the comparator reads, causing actual and expected paths to agree or fail only through parser errors instead of a clear expected-vs-actual diff. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-05..D-07]

**Why it happens:** Unlike profile-schema parity, the project-file Rust boundary consumes `expected-project-summary.tsv` rather than a separate raw `.ini` fixture. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema.sh; packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs]

**How to avoid:** Let the comparator accept separate Rust-input and expected-artifact paths; pass the same checked-in artifact twice for the public command and pass original-vs-mutated paths in the failure test. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema_test.sh; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-07]

**Warning signs:** The test invokes the comparator with only a mutated `expected-project-summary.tsv` path and no original Rust-input path. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema_test.sh pattern comparison]

### Pitfall 3: Status Row Overclaims Full Project Support

**What goes wrong:** Maintainers read `fork.prusaslicer.project-file` as full PrusaSlicer project loading, GUI behavior, load/save, 3MF import/export, or generated-output parity. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11]

**Why it happens:** The token name includes `project-file`, which is adjacent to broader 3MF/runtime behavior. [VERIFIED: packages/prusa-project-file-scope/project-file-scope.md; docs/port/parity-matrix.md]

**How to avoid:** Status/docs should say "narrow Prusa project-file expected-summary evidence slice" and list deferred full runtime, GUI, generated-output, STEP, support, arc fitting, seam, release, network/device, profile auto-update, Bambu, Orca, upstream import, and sync surfaces where relevant. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11; .planning/REQUIREMENTS.md]

**Warning signs:** Docs use words like "load", "save", "runtime support", "3MF import/export", or "generated-output parity" without "deferred" or "not claimed" nearby. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs public no-overclaiming test pattern]

### Pitfall 4: Rust CLI Adapter Becomes a Discovery Tool

**What goes wrong:** The Rust binary starts discovering files, reading environment-specific paths, spawning processes, or contacting upstream sources. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08; .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md]

**Why it happens:** A CLI binary is imperative by nature, so it can accidentally grow beyond a thin adapter. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]

**How to avoid:** Mirror `prusa_profile_schema_summary.rs`: exactly one path arg, `fs::read_to_string`, call pure summary function, print lines, return `ExitCode`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs]

**Warning signs:** `rg -n "std::process|Command|std::net|reqwest|curl|git|read_dir|profile auto-update|vendor sync" packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs` returns matches after implementation. [VERIFIED: .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md side-effect audit pattern]

## Code Examples

### Generate Expected Summary Lines in Shell

The comparator can construct expected summary-line output from fixed metadata plus row triples in `expected-project-summary.tsv`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs output format; packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv]

```bash
# Source: derived from prusa_project_file_summary_lines() output order.
write_expected_summary_lines() {
	local expected_project_summary="${1}"
	local row_count

	row_count="$(awk 'NR > 1 { count++ } END { print count }' "${expected_project_summary}")"
	printf 'surface\tfork.prusaslicer.project-file\n'
	printf 'inventory_id\tprusaslicer.project-file\n'
	printf 'vendor_id\tprusaslicer\n'
	printf 'flavor_id\tprusaslicer\n'
	printf 'origin\tshared-downstream\n'
	printf 'parity_dependency\tfile-formats\n'
	printf 'checklist_status\tfuture-candidate\n'
	printf 'source_ref\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\n'
	printf 'source_path\tsrc/libslic3r/Format/3mf.cpp\n'
	printf 'fixture_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf\n'
	printf 'expected_summary_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv\n'
	printf 'scope_record_path\tpackages/prusa-project-file-scope/project-file-scope.md\n'
	printf 'reserved_future_status_token\tfork.prusaslicer.project-file\n'
	printf 'row_count\t%s\n' "${row_count}"
	awk -F '\t' 'NR > 1 { printf "evidence_row\t%s\t%s\t%s\n", $3, $4, $5 }' \
		"${expected_project_summary}"
}
```

### Exact Status Row Guard

Use the Phase 40 status-published pattern and adapt the token, evidence target, and notes. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh]

```bash
# Source: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
verify_project_file_status_published() {
	local status_errors
	status_errors="$(awk -F '\t' \
		-v surface="fork.prusaslicer.project-file" \
		-v required_status="verified" \
		-v required_evidence="//packages/parity:prusaslicer_project_file_parity" \
		-v required_narrow="narrow Prusa project-file expected-summary evidence slice only" \
		-v required_runtime="full PrusaSlicer runtime support" '
		$1 == surface {
			count++
			if ($2 != required_status) {
				printf "%s status: expected %s, got %s\n", surface, required_status, $2
				failed = 1
			}
			if ($3 != required_evidence) {
				printf "%s evidence: expected %s, got %s\n", surface, required_evidence, $3
				failed = 1
			}
			if (index($4, required_narrow) == 0) {
				printf "%s notes: missing %s\n", surface, required_narrow
				failed = 1
			}
			if (index($4, required_runtime) == 0) {
				printf "%s notes: missing %s\n", surface, required_runtime
				failed = 1
			}
		}
		END {
			if (count == 0) {
				printf "%s status: missing row\n", surface
				failed = 1
			}
			if (count > 1) {
				printf "%s status: duplicate rows: %d\n", surface, count
				failed = 1
			}
			exit failed ? 1 : 0
		}
	' "${status_file}")" || error "packages/parity/status.tsv: ${status_errors}"
}
```

## Runtime State Inventory

This phase does not rename a runtime key or migrate external stored state; it publishes a new checked-in command/status/docs evidence surface. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; codebase audit]

| Category | Items Found | Action Required |
|----------|-------------|-----------------|
| Stored data | None; the relevant state is checked-in TSV/Markdown/Bazel/Rust source files, not a runtime database. [VERIFIED: codebase audit; .planning/STATE.md] | No data migration; edit checked-in files only. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| Live service config | None; Phase 44 forbids network services, upstream fetches, profile auto-update execution, plugins, and sync automation. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08] | No live-service patch. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| OS-registered state | None found; the command is a Bazel target, not a launchd/systemd/Task Scheduler/pm2 registration. [VERIFIED: packages/parity/BUILD.bazel; environment audit] | No OS re-registration. [VERIFIED: packages/parity/BUILD.bazel] |
| Secrets/env vars | None; the phase uses checked-in fixture paths and no credentials or secret env vars. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08; packages/parity/compare_prusaslicer_profile_schema.sh pattern] | No secret/env var update. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| Build artifacts | Existing local `target/`/Bazel outputs may contain old build products, but they are not source-of-truth and do not require migration for planning. \[VERIFIED: codebase `rg` output showing `packages/slic3r-rust/target/`; .gitignore/build-artifact convention inferred from repo layout\] | Rebuild via Bazel/Cargo verification; do not edit artifacts. [VERIFIED: packages/slic3r-rust/BUILD.bazel; AGENTS.md pre-commit instructions] |

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Phase 42 project-file fixture verifier rejects any project-file status row or parity target. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] | Phase 44 should require the exact project-file status row and command after executable evidence passes. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-09; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] | Phase 44 planning, 2026-06-05. [VERIFIED: .planning/STATE.md] | The plan must include fixture verifier/test updates, not only a status TSV edit. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh] |
| Phase 43 parser/metadata readiness only; target and status row intentionally absent. [VERIFIED: .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md; bazel query audit; status grep audit] | Phase 44 executable parity command plus exact status/docs publication. [VERIFIED: .planning/ROADMAP.md; .planning/REQUIREMENTS.md] | Phase 44 follows completed Phase 43. [VERIFIED: .planning/STATE.md] | Command can consume Phase 43 Rust summary logic but must not broaden runtime semantics. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| Prusa profile-schema parity has an executable command, failure guard, status row, and exact docs. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema.sh; .planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-VERIFICATION.md] | Project-file parity should mirror that pattern with the project-file expected-summary evidence slice. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-02] | Phase 44. [VERIFIED: .planning/ROADMAP.md] | Reuse naming, Bazel wiring, diff diagnostics, and status-row guard patterns. [VERIFIED: packages/parity/BUILD.bazel; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] |

**Deprecated/outdated:** "Phase 44 still owns executable parity and status publication" wording becomes stale after the command passes and `fork.prusaslicer.project-file` is published, but broad Prusa runtime/project loading claims remain forbidden. [VERIFIED: packages/parity/README.md; docs/port/README.md; docs/port/migration-guidance.md; docs/port/parity-matrix.md; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11]

## Docs And Status Update Map

| File | Required Phase 44 Update | Boundary That Must Remain |
|------|--------------------------|---------------------------|
| `packages/parity/status.tsv` | Add exactly one `fork.prusaslicer.project-file` row after the parity command passes. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-09] | Notes must state narrow expected-summary evidence only and preserve deferred surfaces. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11] |
| `packages/parity/README.md` | Add `bazel run //packages/parity:prusaslicer_project_file_parity` to the current command surface and replace "unavailable until Phase 44" wording. [VERIFIED: packages/parity/README.md] | Keep policy that fork rows require runnable `//packages/parity:*_parity` evidence. [VERIFIED: packages/parity/README.md] |
| `packages/parity-fixtures/verify_prusa_project_file_fixture.sh` | Replace target/status absence guards with exact publication checks. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh] | Keep fixture bytes, SHA-256, archive-member, expected-row, provenance, and update-route checks. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh` | Replace premature-row/target tests with missing/wrong/duplicate/overclaim status/target tests. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh; packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh] | Keep checksum, header, member-row, provenance, README, and Phase 43 Rust-surface tests where still relevant. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh] |
| `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md` | Replace "executable parity unavailable until Phase 44" with command/status publication wording after command proof. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md] | Keep provenance, update route, and exclusions. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md] |
| `packages/slic3r-rust/README.md` | Add the project-file summary binary target if a binary is added. [VERIFIED: packages/slic3r-rust/README.md; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Keep Rust boundary data-in/data-out and no Git/network/process/discovery behavior. [VERIFIED: packages/slic3r-rust/README.md; .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md] |
| `docs/port/README.md` | Move project-file state from Phase 44 future ownership to executable evidence. [VERIFIED: docs/port/README.md] | State exact source ref, fixture path, expected artifact, command, and limited evidence slice. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-06, D-11] |
| `docs/port/package-map.md` | Add Phase 44 package-discoverability text: command/status in `packages/parity`, expected artifact in fixtures, summary boundary in Rust. [VERIFIED: docs/port/package-map.md] | Keep package ownership clear and avoid adding new package boundaries. [VERIFIED: docs/port/package-map.md; packages/parity/BUILD.bazel] |
| `docs/port/migration-guidance.md` | Replace status-unavailable rule with verified-for-this-narrow-slice language. [VERIFIED: docs/port/migration-guidance.md] | Keep future fork status tied to executable evidence and keep all broad deferrals. [VERIFIED: docs/port/migration-guidance.md] |
| `docs/port/parity-matrix.md` | Update fork parity interpretation to name the verified project-file row and command. [VERIFIED: docs/port/parity-matrix.md] | Do not upgrade file-format/generated-output/runtime surface statuses beyond the exact evidence slice. [VERIFIED: docs/port/parity-matrix.md; .planning/REQUIREMENTS.md] |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | All planning-relevant claims in this research were verified against local files, command probes, prior phase artifacts, or cited official standards. [VERIFIED: source tags throughout this file] | All sections | No user confirmation is needed before planning. [VERIFIED: source tags throughout this file] |

## Open Questions (RESOLVED)

1. **No blocking implementation questions remain for planning.** [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; codebase audit]
   - What we know: the command target, status token, expected artifact, source ref, fixture path, docs surfaces, failure guard shape, and deferred scope are locked. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md]
   - What's unclear: only helper names and exact row-label extraction details remain discretionary. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md]
   - Recommendation: use `compare_prusaslicer_project_file.sh`, `compare_prusaslicer_project_file_test.sh`, and `prusa_project_file_summary` because they mirror existing repo naming. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema.sh; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `bazel run` / `bazel test` targets | yes | 8.6.0 | none needed [VERIFIED: environment audit] |
| Bazelisk | Repo-pinned Bazel launcher on macOS | yes | reports Bazel 8.6.0 | use `bazel` directly [VERIFIED: environment audit; packages/slic3r-rust/README.md] |
| Rustup | Pinned Rust command invocation | yes | 1.29.0 | use active toolchain only if it is compatible with repo checks [VERIFIED: environment audit] |
| Rustc | Rust summary binary build | yes | 1.94.1 | none needed [VERIFIED: environment audit] |
| Cargo | Rust fmt/clippy/build/test | yes | 1.94.1 | none needed [VERIFIED: environment audit] |
| Bash | Comparator and tests | yes | GNU bash 3.2.57 | none needed [VERIFIED: environment audit] |
| `diff` | Expected-vs-actual output | yes | Apple diff | exact line comparison only if `diff` becomes unavailable [VERIFIED: environment audit] |
| `mdformat` | Markdown checks | yes | 1.0.0 | document skip only if unavailable later [VERIFIED: environment audit; AGENTS.md] |
| `shfmt` | Shell formatting checks | yes | 3.12.0 | document skip only if unavailable later [VERIFIED: environment audit] |
| `rg` | Scope/status grep checks | yes | 15.1.0 | use `grep` only if unavailable [VERIFIED: environment audit] |
| `awk` | TSV/status guards | yes | `/usr/bin/awk` available | keep checks simple or move complex parsing into Rust [VERIFIED: environment audit] |
| `shasum` | Existing fixture checksum guard | yes | 6.02 | none needed [VERIFIED: environment audit] |
| `zipinfo` / `unzip` | Existing archive-member fixture guard | yes | 3.00 / 6.00 | verifier already falls back from `zipinfo` to `unzip -Z -1` [VERIFIED: environment audit; packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |
| Node | GSD schema/commit tooling | yes | v24.13.0 | none needed [VERIFIED: environment audit; gsd init command] |
| Git | Commit tooling and diff checks | yes | 2.53.0 | do not use in parity command or tests [VERIFIED: environment audit; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08] |

**Missing dependencies with no fallback:** None found. [VERIFIED: environment audit]

**Missing dependencies with fallback:** None required for the recommended implementation. [VERIFIED: environment audit]

## Security Domain

### Applicable ASVS Categories

OWASP documents ASVS as an application security verification standard and lists V2 Authentication, V3 Session Management, V4 Access Control, V5 Validation/Sanitization/Encoding, and V6 Stored Cryptography among its sections. [CITED: https://devguide.owasp.org/en/06-verification/01-guides/03-asvs/]

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | no | Phase 44 adds a local Bazel command and no authentication surface. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| V3 Session Management | no | Phase 44 adds no sessions, cookies, or stateful user interactions. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| V4 Access Control | no | The command reads checked-in fixtures through explicit Bazel paths and does not expose privileged runtime access. [VERIFIED: packages/parity/BUILD.bazel pattern; .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md] |
| V5 Validation, Sanitization and Encoding | yes | Use the typed Rust parser plus fail-closed shell diff/status guards for TSV input validation. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs; packages/parity/compare_prusaslicer_profile_schema.sh] |
| V6 Stored Cryptography | limited | Preserve existing SHA-256 fixture integrity checks; do not add custom cryptography. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Expected artifact drift is accepted silently. [VERIFIED: .planning/REQUIREMENTS.md PPEV-02] | Tampering | Use checked-in expectations, exact summary diff, and a mutation `sh_test`. [VERIFIED: packages/parity/compare_prusaslicer_profile_schema.sh; packages/parity/compare_prusaslicer_profile_schema_test.sh] |
| Project-file status row overclaims support. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-11] | Spoofing / Repudiation | Use exact status-row notes and docs grep checks for narrow evidence and deferrals. [VERIFIED: packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh; docs/port/parity-matrix.md] |
| Comparator consumes unreviewed local files through discovery. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08] | Tampering / Information Disclosure | Pass explicit Bazel `$(location)` paths and keep Rust CLI path input explicit. [VERIFIED: packages/parity/BUILD.bazel pattern; packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_profile_schema_summary.rs] |
| Network, Git, profile auto-update, plugin, or sync behavior enters parity evidence. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md D-08] | Information Disclosure / Tampering | Side-effect scans should reject Git/network/process/source-import/sync terms in new comparator and Rust adapter. [VERIFIED: .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md] |

## Verification Commands For Plans

### Command And Failure Evidence

```bash
bazel query //packages/parity:prusaslicer_project_file_parity
bazel run //packages/parity:prusaslicer_project_file_parity
bazel test //packages/parity:prusaslicer_project_file_parity_failure_test
```

These commands should succeed after implementation; `bazel query //packages/parity:prusaslicer_project_file_parity` currently fails because the target is absent before Phase 44 implementation. [VERIFIED: bazel query audit; .planning/phases/43-rust-prusa-project-file-boundary/43-VERIFICATION.md]

### Rust

```bash
rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all
rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings
rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features
rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features
bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_test //packages/slic3r-rust:verify
```

These commands match the Rust project pre-commit requirement and existing aggregate verification surface. [VERIFIED: user-provided AGENTS.md instructions; packages/slic3r-rust/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

### Fixture And Status

```bash
bazel run //packages/parity-fixtures:verify_prusa_project_file_fixture
bazel test //packages/parity-fixtures:verify_prusa_project_file_fixture_test
bazel run //packages/parity:status | rg "fork\\.prusaslicer\\.project-file|prusaslicer_project_file_parity"
awk -F '\t' '$1=="fork.prusaslicer.project-file" && $2=="verified" && $3=="//packages/parity:prusaslicer_project_file_parity" { found=1 } END { exit found ? 0 : 1 }' packages/parity/status.tsv
```

The fixture verifier commands currently pass only while the Phase 44 target/status row are absent; update them during Phase 44 to require exact publication instead. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh]

### Docs And Scope Guards

```bash
mdformat --check packages/parity/README.md packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/README.md packages/slic3r-rust/README.md docs/port/README.md docs/port/package-map.md docs/port/migration-guidance.md docs/port/parity-matrix.md
shfmt -d packages/parity/compare_prusaslicer_project_file.sh packages/parity/compare_prusaslicer_project_file_test.sh packages/parity-fixtures/verify_prusa_project_file_fixture.sh packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh
git diff --check
```

Do not run `mdformat` over phase `*-SUMMARY.md` files if summaries are created later. [VERIFIED: AGENTS.md]

## Sources

### Primary (HIGH confidence)

- `.planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md` - locked Phase 44 command, comparison, failure, status, docs, and scope decisions. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - PPEV-01, PPEV-02, PPEV-03 and v1.11 out-of-scope table. [VERIFIED: local file read]
- `.planning/ROADMAP.md`, `.planning/STATE.md`, and `.planning/PROJECT.md` - Phase 44 sequencing after Phase 43 and milestone evidence chain. [VERIFIED: local file read]
- `packages/parity/BUILD.bazel`, `packages/parity/compare_prusaslicer_profile_schema.sh`, `packages/parity/compare_prusaslicer_profile_schema_test.sh`, `packages/parity/README.md`, and `packages/parity/status.tsv` - existing parity command, comparison, mutation test, and status patterns. [VERIFIED: local file read]
- `packages/parity-fixtures/BUILD.bazel`, `packages/parity-fixtures/verify_prusa_project_file_fixture.sh`, `packages/parity-fixtures/verify_prusa_project_file_fixture_test.sh`, and project-file fixture files - fixture aliases, current absence guards, expected rows, provenance, and update rules. [VERIFIED: local file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`, `src/lib.rs`, tests, and `BUILD.bazel` - Phase 43 Rust parser, metadata, summary output, and Bazel wiring gap. [VERIFIED: local file read]
- `.planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-RESEARCH.md`, `40-01-PLAN.md`, `40-02-PLAN.md`, and `40-VERIFICATION.md` - profile-schema executable parity precedent. [VERIFIED: local file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and Bright Builds canonical standards pages at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676` - repo and standards constraints. [VERIFIED: local file read; CITED: raw.githubusercontent.com Bright Builds URLs]

### Secondary (MEDIUM confidence)

- Local command probes for Bazel, Bazelisk, Rustup, Rust, Cargo, Bash, `mdformat`, `shfmt`, `rg`, `awk`, `diff`, `shasum`, `zipinfo`, `unzip`, Node, and Git. [VERIFIED: environment audit]
- `bazel query //packages/parity:prusaslicer_project_file_parity` and `rg -n "fork\.prusaslicer\.project-file" packages/parity/status.tsv` showing target/status absence at research time. [VERIFIED: environment audit]
- OWASP Developer Guide ASVS page for ASVS category names and verification framing. [CITED: https://devguide.owasp.org/en/06-verification/01-guides/03-asvs/]

### Tertiary (LOW confidence)

- None. [VERIFIED: source tags throughout this file]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH because the phase uses existing repo tools and local versions were probed. [VERIFIED: environment audit; packages/parity/BUILD.bazel; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]
- Architecture: HIGH because command ownership, parser boundary, fixture ownership, and docs/status scope are locked by Phase 44 context and established by prior profile-schema parity. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; packages/parity/compare_prusaslicer_profile_schema.sh; .planning/milestones/v1.10-phases/40-executable-prusa-profile-parity/40-VERIFICATION.md]
- Pitfalls: HIGH because the status-row verifier conflict, mutation-test pattern, and no-overclaiming constraints are directly visible in current scripts/docs/tests. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh; packages/parity/compare_prusaslicer_profile_schema_test.sh; packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs]

**Research date:** 2026-06-05 [VERIFIED: current_date context]\
**Valid until:** 2026-07-05 for repo-local planning unless the Prusa project-file fixture/source pin, Bazel/Rust toolchain, or Phase 44 context changes first. [VERIFIED: .planning/phases/44-executable-prusa-project-file-parity/44-CONTEXT.md; .bazelversion; packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml]

## RESEARCH COMPLETE
