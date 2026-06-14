# Phase 48: Executable Prusa G-code Evidence - Research

**Researched:** 2026-06-14
**Domain:** Bazel/Rust/Bash executable parity evidence and status/docs publication
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

Source: copied verbatim from `.planning/phases/48-executable-prusa-g-code-evidence/48-CONTEXT.md`. [VERIFIED: 48-CONTEXT.md]

### Locked Decisions

## Implementation Decisions

### Executable Parity Command

- **D-01:** Add the public command
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` as the sole
  Phase 48 executable evidence command for this slice.
- **D-02:** Mirror the existing `prusaslicer_project_file_parity` command
  shape: a package-local `compare_prusaslicer_gcode_output.sh` shell wrapper in
  `packages/parity`, a Bazel `sh_binary`, and a small Rust summary binary under
  `packages/slic3r-rust/crates/slic3r_flavors/src/bin/` if no equivalent
  executable already exists.
- **D-03:** The command should run the Phase 47 Rust summary boundary against
  the checked-in
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  artifact and compare stable summary lines. It should not read raw G-code as a
  parser input, generate new G-code, run PrusaSlicer, fetch upstream source,
  run Git, inspect printers, or perform network/profile/release/sync behavior.
- **D-04:** Successful command output should identify the exact source ref,
  fixture path, expected summary path, and accepted row count while avoiding
  wording that implies runtime or byte-for-byte generated-output support.

### Fail-Closed Drift Guard

- **D-05:** Add a focused parity failure test, likely
  `packages/parity/compare_prusaslicer_gcode_output_test.sh`, wired as a Bazel
  `sh_test`, that mutates the expected summary or Rust-summary input and proves
  the parity command fails with a useful diff and mismatch label.
- **D-06:** The failure guard should cover the highest-risk drift path for this
  slice: Rust summary output and checked-in expected artifact divergence. The
  test may mirror the project-file mutation pattern, but the selected mutation
  should use G-code marker rows such as `line_1` through `line_4` or the
  `source_literal` marker so the failure is tied to Phase 46/47 evidence.
- **D-07:** Keep earlier scope and fixture verifiers aligned with Phase 48:
  after the parity target and status row exist, remove or narrow obsolete
  "Phase 48 absent" guards while preserving all broad-overclaim, source, and
  fixture integrity checks.

### Status Publication

- **D-08:** Add exactly one checked-in `packages/parity/status.tsv` row for
  `fork.prusaslicer.gcode-output` once the parity command passes.
- **D-09:** The row status should be `verified`, the evidence should be
  `//packages/parity:prusaslicer_gcode_output_parity`, and the notes must state
  that this is a narrow summary-only Prusa G-code evidence slice backed by the
  Phase 46 fixture and Phase 47 Rust summary boundary.
- **D-10:** Keep the broader `generated-outputs` row `in progress`. Do not
  fold the fork-specific G-code row into broad generated-output verification.

### Public Documentation

- **D-11:** Update the minimum public docs needed for discoverability and
  non-overclaiming consistency: `packages/parity/README.md`,
  `docs/port/parity-matrix.md`, `docs/port/README.md`, and any directly
  affected package-map or migration-guidance text discovered during planning.
- **D-12:** Docs should name the runnable command, exact status token, source
  identity, fixture namespace, expected summary artifact, and Rust summary
  boundary. They should also keep the same deferred-scope list used by prior
  G-code phases.
- **D-13:** Documentation should distinguish three facts clearly: Phase 46
  proves fixture surface integrity, Phase 47 proves typed summary parsing, and
  Phase 48 proves executable summary-only evidence/status wiring.

### Verification Scope

- **D-14:** Phase verification must include the new parity command, the new
  parity failure test, the existing G-code fixture verifier/test, the existing
  G-code scope verifier/test after guard reconciliation, relevant Rust
  format/clippy/build/test checks, and `git diff --check`.
- **D-15:** If a new Rust summary binary is added, include it in
  `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` clippy and
  rustfmt targets and validate through the aggregate
  `bazel test //packages/slic3r-rust:verify` surface when practical.

### the agent's Discretion

- The agent may choose the exact summary-binary file and function names, but
  they should follow `prusa_project_file_summary` naming and avoid claims
  broader than summary-only evidence.
- The agent may choose the exact mutation used by the failure test, provided it
  proves real divergence between Rust summary output and the checked-in
  expected artifact.
- The agent may update additional docs only when directly required to keep
  public status and package ownership text consistent.

### Deferred Ideas (OUT OF SCOPE)

Broader byte-for-byte G-code parity, full generated-output parity, toolpath
geometry, extrusion, timing, support generation, wall seam behavior, arc
fitting, STEP import, full 3MF import/export, printer-runtime behavior,
firmware or printability behavior, GUI export or viewer behavior, binary
G-code, thumbnails, post-processing, host upload, network/device integration,
profile auto-update execution, fork release builds, Bambu Studio, OrcaSlicer,
upstream source imports, release behavior, and sync automation remain outside
Phase 48.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PGEV-01 | Maintainer can run a repo-owned Bazel parity command for the selected summary-only Prusa G-code output evidence slice. | Add `//packages/parity:prusaslicer_gcode_output_parity` as a `sh_binary` modeled on `prusaslicer_project_file_parity`, backed by a new or existing Rust summary binary and the checked-in expected G-code summary. [VERIFIED: .planning/REQUIREMENTS.md, packages/parity/BUILD.bazel] |
| PGEV-02 | Maintainer can see the Prusa G-code evidence command fail when the Rust-backed summary or checked-in expected summary artifact diverges from fixture expectations. | Add `compare_prusaslicer_gcode_output_test.sh` as a Bazel `sh_test` that mutates a `source_literal` or `line_1` through `line_4` G-code marker and asserts non-zero exit, mismatch label, and unified diff output. [VERIFIED: .planning/REQUIREMENTS.md, packages/parity/compare_prusaslicer_project_file_test.sh] |
| PGEV-03 | Maintainer can inspect docs and parity status updates that name the exact verified Prusa G-code evidence slice while keeping deferred surfaces deferred. | Add one `fork.prusaslicer.gcode-output` status row, preserve `generated-outputs` as `in progress`, and update parity/package/port docs with exact source, fixture, expected summary, Rust boundary, command, and deferred-scope wording. [VERIFIED: .planning/REQUIREMENTS.md, packages/parity/status.tsv, docs/port/parity-matrix.md] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- `AGENTS.md` is the repo-local entrypoint, and it requires loading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant pinned Bright Builds standards pages before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md]
- Do not edit the managed Bright Builds block in `AGENTS.md` or the managed `AGENTS.bright-builds.md` file directly. [VERIFIED: AGENTS.md, AGENTS.bright-builds.md]
- `standards-overrides.md` exists but contains only placeholder/example rows, so no active local standards exception changes Phase 48 planning. [VERIFIED: standards-overrides.md]
- Bright Builds architecture guidance says business rules should live in pure data-in/data-out functions, while I/O and process effects stay in thin adapters. [CITED: Bright Builds architecture.md]
- Bright Builds Rust guidance says new or touched Rust code should encode invariants with types, keep adapters thin around a pure core, prefer `let...else` for guard extraction when clearer, and use repo-native Rust verification. [CITED: Bright Builds rust.md]
- Bright Builds testing guidance says pure/business logic must have focused unit tests and unit tests should clearly delineate Arrange, Act, and Assert unless trivially obvious. [CITED: Bright Builds testing.md]
- Bright Builds code-shape guidance says checked-in scripts should be rerunnable and diagnosable, and substantial foreign-language logic should live in checked-in scripts rather than inline command strings. [CITED: Bright Builds code-shape.md]
- Bright Builds verification guidance says fetch/sync before substantive repo-changing work and use repo-native verification for changed paths. [CITED: Bright Builds verification.md]
- Repo-local guidance only adds phase-summary constraints: keep `requirements-completed` frontmatter in `*-SUMMARY.md`, use `requirements-completed: []` when none are completed, do not run `mdformat` over phase `*-SUMMARY.md`, and edit only affected summary frontmatter blocks. [VERIFIED: AGENTS.md]
- No repo-local `.claude/skills/` or `.agents/skills/` project skill directories were found. [VERIFIED: `find .claude/skills .agents/skills -maxdepth 2 -name SKILL.md`]

## Summary

Phase 48 should be planned as a narrow publication layer over artifacts that already exist: the Phase 46 `expected-gcode-summary.tsv` fixture artifact and the Phase 47 `slic3r_flavors::prusa_gcode_output` pure Rust summary boundary. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv, packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs] The closest local implementation is Phase 44 project-file parity: a package-local Bash comparator, a Bazel `sh_binary`, a tiny Rust `src/bin/*_summary.rs` wrapper, and a focused mutation `sh_test`. [VERIFIED: packages/parity/compare_prusaslicer_project_file.sh, packages/parity/BUILD.bazel, packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_project_file_summary.rs]

The planner should include explicit reconciliation work for older absence guards because the current G-code scope and fixture verifiers still reject the exact Phase 48 parity target and status row. [VERIFIED: packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] The correct reconciliation pattern is already present in the project-file fixture verifier: require the published status row and parity target after executable evidence exists, while preserving fixture integrity and overclaiming checks. [VERIFIED: packages/parity-fixtures/verify_prusa_project_file_fixture.sh]

**Primary recommendation:** Implement the Phase 48 command as a thin Bash/Rust/Bazel evidence adapter around the existing `prusa_gcode_output_summary_lines` function, add fixed summary-value assertions plus a marker-row mutation failure test, then publish exactly one `fork.prusaslicer.gcode-output` status row while leaving broad `generated-outputs` in progress. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs, packages/parity/status.tsv]

## Standard Stack

### Core

| Tool or Library | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| Bazel / Bazelisk | 8.6.0, pinned by `.bazelversion` | Public `bazel run` and `bazel test` surfaces for parity evidence. | Existing repo parity commands and verifiers are Bazel `sh_binary` / `sh_test` targets. [VERIFIED: `.bazelversion`, `bazel --version`, packages/parity/BUILD.bazel] |
| `rules_rust` | 0.69.0 | Rust library, binary, test, clippy, and rustfmt target wiring. | Existing Rust crates and summary binaries are wired through `rules_rust`; the module pins Rust 1.94.1 and edition 2024. [VERIFIED: MODULE.bazel, packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] |
| Rust | 1.94.1 | Pure summary parser boundary and tiny summary binary. | The repo's Bazel module pins Rust 1.94.1 and `cargo`/`rustc` 1.94.1 are installed locally. [VERIFIED: MODULE.bazel, `rustup run 1.94.1 rustc --version`, `rustup run 1.94.1 cargo --version`] |
| `slic3r_flavors` crate | local workspace crate | Owns `prusa_gcode_output_summary_lines`, metadata, parser, and tests. | Phase 47 already added the pure Rust G-code summary boundary and exports it from `src/lib.rs`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs, packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs] |
| Bash | GNU bash 3.2.57 on this machine | Thin comparator and failure-test scripts. | Existing parity comparators and verifier scripts are Bash with `set -euo pipefail`. [VERIFIED: `bash --version`, packages/parity/compare_prusaslicer_project_file.sh] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| `awk` | `/usr/bin/awk` | TSV field lookup, mismatch labels, and exact-row checks in shell scripts. | Use for small local TSV checks, matching existing comparator and verifier style. [VERIFIED: `command -v awk`, packages/parity/compare_prusaslicer_project_file.sh] |
| `diff` | Apple diff based on FreeBSD diff | Unified diff output for comparator failures. | Use in comparator and failure tests so maintainers see exact expected/actual drift. [VERIFIED: `diff --version`, packages/parity/compare_prusaslicer_project_file.sh] |
| `shasum` | 6.02 | Existing fixture checksum verification. | Keep existing fixture verifier checksum checks; Phase 48 comparator should not need new hashing. [VERIFIED: `shasum --version`, packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh] |
| `git` | 2.53.0 | `git diff --check` and optional documentation commit tooling. | Use for whitespace verification and GSD doc commit only; the parity command itself must not run Git. [VERIFIED: `git --version`, 48-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Bash comparator plus Rust summary binary | A Rust-only comparator binary | Not recommended because existing public parity evidence uses package-local Bash comparators with Bazel `sh_binary` data/args, and matching that shape reduces review risk. [VERIFIED: packages/parity/BUILD.bazel, packages/parity/compare_prusaslicer_project_file.sh] |
| Existing `expected-gcode-summary.tsv` as the only input artifact | Add a second checked-in expected summary-output artifact | Not recommended for Phase 48 because the locked decision says use the checked-in expected G-code summary artifact and mirror project-file shape; instead, add fixed shell assertions for stable summary values. [VERIFIED: 48-CONTEXT.md, packages/parity/compare_prusaslicer_project_file.sh] |
| Mutate arbitrary TSV text in failure test | Mutate `source_literal` or `line_1` through `line_4` marker rows | Use marker-row mutations because the locked decision ties failure evidence to the Phase 46/47 G-code marker contract. [VERIFIED: 48-CONTEXT.md, expected-gcode-summary.tsv] |

**Installation:**

No npm packages or new package-manager dependencies are recommended for Phase 48. [VERIFIED: no `package.json` or JS lockfile found by `rg --files`] The planner should use the existing Bazel, Rust, Bash, and Unix utilities already present in the repo and environment. [VERIFIED: MODULE.bazel, environment probes]

**Version verification:**

```bash
bazel --version
bazelisk --version
rustup run 1.94.1 rustc --version
rustup run 1.94.1 cargo --version
bash --version
diff --version
shasum --version
```

The commands above were run during research and reported Bazel 8.6.0, Rust/Cargo 1.94.1, Bash 3.2.57, Apple diff, and shasum 6.02. [VERIFIED: environment probes]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
+-- parity/
|   +-- compare_prusaslicer_gcode_output.sh        # new thin comparator shell
|   +-- compare_prusaslicer_gcode_output_test.sh   # new mutation failure guard
|   +-- BUILD.bazel                                # new sh_binary and sh_test wiring
|   +-- README.md                                  # public command/status docs
|   +-- status.tsv                                 # exact fork.prusaslicer.gcode-output row
+-- parity-fixtures/
|   +-- verify_prusa_gcode_output_fixture.sh       # reconcile old absence guards
|   +-- forks/prusaslicer/prusaslicer.gcode-output/
|       +-- expected-gcode-summary.tsv             # existing checked-in input artifact
|       +-- fixture-provenance.tsv                 # existing provenance
|       +-- gcodewriter-set-speed.gcode            # existing fixture bytes
+-- prusa-gcode-output-scope/
|   +-- verify_prusa_gcode_output_scope.sh         # reconcile old absence guards
+-- slic3r-rust/crates/slic3r_flavors/
    +-- src/bin/prusa_gcode_output_summary.rs      # new only if no equivalent exists
    +-- BUILD.bazel                                # add binary to clippy/rustfmt targets
```

This structure mirrors the established project-file evidence slice and uses only package boundaries already present in the repo. [VERIFIED: packages/parity/BUILD.bazel, packages/parity-fixtures/BUILD.bazel, packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

### Pattern 1: Thin Rust Summary Binary

**What:** Add `src/bin/prusa_gcode_output_summary.rs` only as a filesystem-reading adapter around `prusa_gcode_output_summary_lines`. [VERIFIED: 48-CONTEXT.md, prusa_project_file_summary.rs]

**When to use:** Use it because Phase 47 left the binary absent and Phase 48 needs an executable summary program for Bazel runfiles. [VERIFIED: 47-VERIFICATION.md, `test -e packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`]

**Example:**

```rust
#![forbid(unsafe_code)]

use std::{env, ffi::OsStr, fs, path::Path, process::ExitCode};

use slic3r_flavors::prusa_gcode_output_summary_lines;

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    if args.len() != 2 {
        eprintln!("error: expected exactly one expected-gcode-summary.tsv fixture path argument");
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

fn run(fixture_path: &OsStr) -> Result<(), String> {
    let path = Path::new(fixture_path);
    let input = fs::read_to_string(path)
        .map_err(|error| format!("failed to read {}: {error}", path.display()))?;
    let lines = prusa_gcode_output_summary_lines(&input)
        .map_err(|error| format!("failed to summarize {}: {error:?}", path.display()))?;

    for line in lines {
        println!("{line}");
    }

    Ok(())
}
```

This example is the project-file summary binary shape with the Phase 47 G-code summary function substituted. [VERIFIED: prusa_project_file_summary.rs, prusa_gcode_output.rs]

### Pattern 2: Bazel `sh_binary` Comparator Wiring

**What:** Add `prusaslicer_gcode_output_parity` as a `sh_binary` in `packages/parity/BUILD.bazel`. [VERIFIED: 48-CONTEXT.md, packages/parity/BUILD.bazel]

**When to use:** Use this for the public maintainer command `bazel run //packages/parity:prusaslicer_gcode_output_parity`. [VERIFIED: 48-CONTEXT.md]

**Example:**

```python
sh_binary(
    name = "prusaslicer_gcode_output_parity",
    srcs = ["compare_prusaslicer_gcode_output.sh"],
    data = [
        "status.tsv",
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary",
        "//packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary",
        "//packages/parity-fixtures:prusa_gcode_output_provenance",
    ],
    args = [
        "$(location //packages/slic3r-rust/crates/slic3r_flavors:prusa_gcode_output_summary)",
        "$(location //packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary)",
        "$(location //packages/parity-fixtures:prusa_gcode_output_expected_gcode_summary)",
        "$(location //packages/parity-fixtures:prusa_gcode_output_provenance)",
    ],
)
```

The duplicated expected-summary argument mirrors `prusaslicer_project_file_parity`; the comparator test should pass a mutated copy for the second argument to prove drift failure. [VERIFIED: packages/parity/BUILD.bazel, compare_prusaslicer_project_file_test.sh]

### Pattern 3: Comparator Assertions Beyond Self-Diff

**What:** In addition to diffing generated stable summary lines, assert exact values for `surface`, `source_ref`, `fixture_path`, `expected_summary_path`, `reserved_future_status_token`, `row_count`, and at least one `evidence_row` marker. [VERIFIED: prusa_gcode_output.rs, compare_prusaslicer_project_file.sh]

**Why:** The project-file comparator generates both compared files with the same summary binary, so fixed assertions make Rust-summary label/value drift visible even if both generated sides otherwise match. [VERIFIED: compare_prusaslicer_project_file.sh, packages/parity/BUILD.bazel]

**Example shell checks:**

```bash
surface="$(field_value "surface" "${actual_summary}")" || {
	printf 'error: surface missing from actual summary\n' >&2
	exit 1
}
if [[ "${surface}" != "fork.prusaslicer.gcode-output" ]]; then
	printf 'error: expected surface fork.prusaslicer.gcode-output, got %s\n' "${surface}" >&2
	exit 1
fi

rows="$(field_value "row_count" "${actual_summary}")" || {
	printf 'error: row_count missing from actual summary\n' >&2
	exit 1
}
if [[ "${rows}" != "5" ]]; then
	printf 'error: expected row_count 5, got %s\n' "${rows}" >&2
	exit 1
fi

if ! grep -Fxq $'evidence_row\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_4\tG1 F203.201\tRepresentative three-decimal rounded feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.' "${actual_summary}"; then
	printf 'error: expected line_4 G-code marker missing from actual summary\n' >&2
	exit 1
fi
```

The exact summary keys and row count are emitted by `prusa_gcode_output_summary_lines`, and the `line_4` row is part of the checked-in Phase 46 expected summary. [VERIFIED: prusa_gcode_output.rs, expected-gcode-summary.tsv]

### Pattern 4: Focused Marker Mutation Test

**What:** Add a Bash `sh_test` that copies `expected-gcode-summary.tsv`, mutates one marker row, invokes the comparator with original input and mutated expected artifact, and asserts failure output. [VERIFIED: compare_prusaslicer_project_file_test.sh, expected-gcode-summary.tsv]

**Example mutation helper:**

```bash
mutate_line_4_marker() {
	local path="${1}"
	local tmp_file="${path}.tmp"

	awk '
		BEGIN { FS = OFS = "\t" }
		!changed && $5 == "line_4" && $6 == "G1 F203.201" {
			$6 = "G1 F203.202"
			changed = 1
		}
		{ print }
		END { if (!changed) exit 1 }
	' "${path}" >"${tmp_file}"
	mv "${tmp_file}" "${path}"
}
```

The planner should make the assertions look for `expected-gcode-summary.tsv`, `line_4`, `@@`, and `diff`, matching local parity failure-test style. [VERIFIED: compare_prusaslicer_project_file_test.sh]

### Anti-Patterns to Avoid

- **Do not parse raw `.gcode` in Phase 48:** Phase 48 is summary-only and must run the Phase 47 Rust boundary against `expected-gcode-summary.tsv`. [VERIFIED: 48-CONTEXT.md]
- **Do not run PrusaSlicer or generate new G-code:** The locked scope forbids generation, upstream fetches, network/profile/release/sync behavior, and printer inspection. [VERIFIED: 48-CONTEXT.md]
- **Do not publish broad `generated-outputs` as verified:** The exact fork row may become verified, but the broad generated-output row stays `in progress`. [VERIFIED: 48-CONTEXT.md, packages/parity/status.tsv]
- **Do not leave old absence guards active:** Current scope/fixture verifiers reject the Phase 48 target and status row, so they must be narrowed or converted to publication checks. [VERIFIED: verify_prusa_gcode_output_scope.sh, verify_prusa_gcode_output_fixture.sh]
- **Do not omit Rust clippy/rustfmt wiring for a new binary:** Existing summary binaries are included in the `slic3r_flavors` `clippy` and `rustfmt_check` target lists. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Summary parsing | A new shell or awk parser for the G-code summary contract | Existing `slic3r_flavors::prusa_gcode_output_summary_lines` through a thin Rust binary | Phase 47 already typed and tested exact header, row order, row count, marker values, notes, and metadata. [VERIFIED: prusa_gcode_output.rs, tests/prusa_gcode_output.rs] |
| Parity command structure | A custom CLI framework or new runner package | `packages/parity` Bash comparator plus Bazel `sh_binary` | Existing fork evidence commands use this package-local shape. [VERIFIED: packages/parity/BUILD.bazel] |
| Drift failure testing | An ad hoc manual mutation procedure | Bazel `sh_test` mutation guard modeled on project-file parity | Existing parity failure tests are executable and hermetic under Bazel. [VERIFIED: compare_prusaslicer_project_file_test.sh] |
| Fixture/status validation | A new status parser or docs scanner | Narrowly update existing scope/fixture verifiers and status docs | Existing verifiers already enforce fixture integrity, provenance, and overclaim boundaries. [VERIFIED: verify_prusa_gcode_output_fixture.sh, verify_prusa_gcode_output_scope.sh] |
| G-code behavior evidence | Raw G-code comparison, geometry checks, extrusion totals, timing checks, or printability checks | Summary-only marker evidence over five accepted rows | Those behavior surfaces are explicitly deferred for Phase 48. [VERIFIED: 48-CONTEXT.md, .planning/REQUIREMENTS.md] |

**Key insight:** The hard part is not parsing G-code; it is publishing executable, fail-closed evidence without accidentally converting a five-row summary contract into broad generated-output or runtime support. [VERIFIED: .planning/REQUIREMENTS.md, 48-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Comparator Self-Comparison Hides Rust Summary Drift

**What goes wrong:** A comparator that runs the same Rust binary over the same expected TSV for both actual and expected sides can miss changes to summary labels or non-row metadata. [VERIFIED: compare_prusaslicer_project_file.sh, packages/parity/BUILD.bazel]

**Why it happens:** The project-file parity target passes the same expected artifact for both `rust_summary_input` and `expected_artifact`, and both sides are generated by the same binary. [VERIFIED: packages/parity/BUILD.bazel]

**How to avoid:** Keep the local shape but add fixed assertions for exact surface, source ref, fixture path, expected summary path, reserved status token, row count, and representative evidence rows. [VERIFIED: prusa_gcode_output.rs]

**Warning signs:** The comparator only checks `diff` and `row_count`, or the failure test mutates only the expected side without asserting stable summary values. [VERIFIED: compare_prusaslicer_project_file.sh, compare_prusaslicer_project_file_test.sh]

### Pitfall 2: Old Absence Guards Fail After Publication

**What goes wrong:** The Phase 48 implementation succeeds but `verify_prusa_gcode_output_fixture` or `verify_prusa_gcode_output_scope` fails because it still treats the new target/status row as forbidden. [VERIFIED: verify_prusa_gcode_output_fixture.sh, verify_prusa_gcode_output_scope.sh]

**Why it happens:** Phase 45 and Phase 46 intentionally guarded Phase 48 absence, and those guards are still present. [VERIFIED: 47-VERIFICATION.md]

**How to avoid:** Convert or narrow `reject_status_row` and `reject_parity_target` to Phase 48-aware publication checks while preserving source, fixture, and overclaim checks. [VERIFIED: verify_prusa_project_file_fixture.sh]

**Warning signs:** `rg` still finds `forbidden parity target exists: prusaslicer_gcode_output_parity` or `forbidden status row exists: fork.prusaslicer.gcode-output` in the final verifier path. [VERIFIED: rg absence-guard scan]

### Pitfall 3: Status Row Overclaims Broad Generated Output

**What goes wrong:** The docs or `status.tsv` imply byte-for-byte G-code, full generated-output parity, runtime/printer behavior, geometry, support, seam, arc, STEP, GUI, release, network, or sync support. [VERIFIED: 48-CONTEXT.md, .planning/REQUIREMENTS.md]

**Why it happens:** The public row name contains `gcode-output`, but the actual evidence is only five summary rows. [VERIFIED: expected-gcode-summary.tsv, prusa_gcode_output.rs]

**How to avoid:** Add exactly one `fork.prusaslicer.gcode-output` row, leave `generated-outputs` as `in progress`, and use notes that say "narrow summary-only Prusa G-code evidence slice backed by the Phase 46 fixture and Phase 47 Rust summary boundary." [VERIFIED: 48-CONTEXT.md]

**Warning signs:** The broad `generated-outputs` row changes status, or docs omit the deferred-scope list. [VERIFIED: packages/parity/status.tsv, docs/port/parity-matrix.md]

### Pitfall 4: New Rust Binary Is Not in Aggregate Verification

**What goes wrong:** `bazel run //packages/parity:prusaslicer_gcode_output_parity` works, but clippy/rustfmt aggregate verification misses the new binary. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**Why it happens:** Existing binaries are explicitly listed in `rust_clippy` and `rustfmt_test` targets. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel]

**How to avoid:** Add `:prusa_gcode_output_summary` to the crate `clippy` deps and `rustfmt_check` targets, then run `bazel test //packages/slic3r-rust:verify`. [VERIFIED: packages/slic3r-rust/BUILD.bazel]

**Warning signs:** `rg prusa_gcode_output_summary packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` finds only the binary target and not the clippy/rustfmt lists. [VERIFIED: current `rg` found no summary binary before Phase 48]

### Pitfall 5: Mutation Test Is Not G-code-Specific

**What goes wrong:** The failure test proves generic TSV drift but does not tie the evidence to the Phase 46 marker rows. [VERIFIED: 48-CONTEXT.md]

**Why it happens:** Copying a project-file mutation literally can target project-file-specific markers instead of `source_literal` or `line_1` through `line_4`. [VERIFIED: compare_prusaslicer_project_file_test.sh, expected-gcode-summary.tsv]

**How to avoid:** Mutate `line_4` (`G1 F203.201`) or `source_literal` and assert the error mentions the G-code marker label. [VERIFIED: expected-gcode-summary.tsv]

**Warning signs:** Failure output mentions only `line_count` or a generic header, not a G-code evidence row. [VERIFIED: compare_prusaslicer_project_file.sh]

## Code Examples

Verified patterns from repo sources:

### Comparator Mismatch Label Pattern

```bash
first_mismatch_label() {
	local expected_file="${1}"
	local actual_file="${2}"

	awk -F '\t' '
		NR == FNR {
			expected[FNR] = $0
			expected_count = FNR
			next
		}
		{
			actual_count = FNR
			if (!found && expected[FNR] != $0) {
				if (expected[FNR] != "") {
					split(expected[FNR], fields, "\t")
					if (fields[1] == "evidence_row") {
						print fields[2] "/" fields[3] "/" fields[4]
					} else {
						print fields[1]
					}
				} else if ($1 != "") {
					print $1
				} else {
					print "line"
				}
				found = 1
				exit
			}
		}
		END {
			if (!found && expected_count != actual_count) {
				print "line_count"
			}
		}
	' "${expected_file}" "${actual_file}"
}
```

This pattern is already used by the project-file comparator and should be adapted to G-code evidence rows. [VERIFIED: compare_prusaslicer_project_file.sh]

### Status Row Shape

```text
fork.prusaslicer.gcode-output	verified	//packages/parity:prusaslicer_gcode_output_parity	Shared fixture comparison proves the narrow summary-only Prusa G-code evidence slice backed by the Phase 46 fixture and Phase 47 Rust summary boundary only; byte-for-byte G-code parity, full generated-output parity, toolpath geometry, extrusion, timing, support generation, wall seam behavior, arc fitting, STEP, full 3MF, printer-runtime, firmware or printability, GUI, binary G-code, thumbnails, post-processing, host upload, network/device, profile auto-update, fork release, Bambu Studio, OrcaSlicer, upstream source imports, release, and sync surfaces remain deferred
```

The exact wording may be tightened during planning, but the row must have status `verified`, evidence `//packages/parity:prusaslicer_gcode_output_parity`, and a notes field that limits the claim to summary-only evidence. [VERIFIED: 48-CONTEXT.md, packages/parity/status.tsv]

### Verifier Publication Check Pattern

```bash
verify_status_published() {
	require_exact_line \
		"${status_file}" \
		"packages/parity/status.tsv" \
		"${GCODE_OUTPUT_STATUS_ROW}" \
		"fork.prusaslicer.gcode-output status/evidence/notes"

	local status_count
	status_count="$(awk -F '\t' '$1 == "fork.prusaslicer.gcode-output" { count++ } END { print count + 0 }' "${status_file}")"
	if [[ "${status_count}" != "1" ]]; then
		error "packages/parity/status.tsv: fork.prusaslicer.gcode-output status: duplicate rows: ${status_count}"
	fi
}
```

This is the G-code analogue of the project-file fixture verifier's post-publication check. [VERIFIED: verify_prusa_project_file_fixture.sh]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Phase 45 reserved command/status text only | Phase 48 should create the real `//packages/parity:prusaslicer_gcode_output_parity` command and `fork.prusaslicer.gcode-output` row | Phase 48 | Converts planned evidence into runnable evidence without broad generated-output claims. [VERIFIED: 45-CONTEXT.md, 48-CONTEXT.md] |
| Phase 46 fixture verifier rejects any Phase 48 target/status row | Phase 48 should require the exact target/status row while retaining fixture/provenance checks | Phase 48 | Prevents obsolete absence guards from blocking valid publication. [VERIFIED: verify_prusa_gcode_output_fixture.sh, verify_prusa_project_file_fixture.sh] |
| Phase 47 exposes pure Rust summary lines with no summary binary | Phase 48 should add a tiny `src/bin/prusa_gcode_output_summary.rs` adapter if no equivalent executable exists | Phase 48 | Makes the pure summary boundary callable from Bazel runfiles. [VERIFIED: 47-VERIFICATION.md, prusa_project_file_summary.rs] |
| Broad `generated-outputs` remains `in progress` | Broad `generated-outputs` must remain `in progress` after the fork-specific G-code row is verified | Still current in Phase 48 | Keeps status vocabulary conservative and avoids global generated-output claims. [VERIFIED: packages/parity/status.tsv, 48-CONTEXT.md] |

**Deprecated/outdated:**

- Treating `fork.prusaslicer.gcode-output` as absent is outdated once Phase 48 lands, but only for the specific scope/fixture verifier guards that were meant to block premature publication. [VERIFIED: verify_prusa_gcode_output_scope.sh, verify_prusa_gcode_output_fixture.sh]
- Treating Phase 46 fixture artifacts alone as executable evidence remains incorrect; Phase 48 must add the runnable command and mutation guard before status publication. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md, 48-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|

All claims in this research were verified from repo files, local command output, or cited official project/standards pages; no user-confirmation assumptions are required before planning. [VERIFIED: Sources section]

## Open Questions

1. **Exact failure-test mutation**
   - What we know: The locked decision permits any mutation that proves divergence and recommends G-code marker rows such as `line_1` through `line_4` or `source_literal`. [VERIFIED: 48-CONTEXT.md]
   - What's unclear: The exact row is left to the agent's discretion. [VERIFIED: 48-CONTEXT.md]
   - Recommendation: Use `line_4` because it is the final accepted marker row and produces a clear `line_4` mismatch label without changing source identity semantics. [VERIFIED: expected-gcode-summary.tsv]

2. **Whether to update extra docs beyond the required four**
   - What we know: The locked decision requires `packages/parity/README.md`, `docs/port/parity-matrix.md`, `docs/port/README.md`, and any directly affected package-map or migration-guidance text discovered during planning. [VERIFIED: 48-CONTEXT.md]
   - What's unclear: `docs/port/package-map.md`, `docs/port/migration-guidance.md`, and `packages/slic3r-rust/README.md` currently contain Phase 46 or Phase 44-era G-code/project-file wording that may become stale when Phase 48 lands. [VERIFIED: docs/port/package-map.md, docs/port/migration-guidance.md, packages/slic3r-rust/README.md]
   - Recommendation: Include package-map and migration-guidance in planning; include `packages/slic3r-rust/README.md` only if a new summary binary is added. [VERIFIED: docs/port/package-map.md, packages/slic3r-rust/README.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | `bazel run` / `bazel test` public evidence | yes | 8.6.0 | None needed; pinned in `.bazelversion`. [VERIFIED: `.bazelversion`, `bazel --version`] |
| Bazelisk | Local Bazel launcher | yes | reports Bazel 8.6.0 | Use `bazel` directly; both resolve to 8.6.0 here. [VERIFIED: `bazelisk --version`] |
| Rust toolchain | Summary binary and Rust verification | yes | rustc/cargo 1.94.1 | None needed; `MODULE.bazel` pins 1.94.1. [VERIFIED: MODULE.bazel, rustc/cargo probes] |
| rustup | Running pinned Cargo commands | yes | 1.29.0 | Use Bazel Rust targets if rustup is unavailable. [VERIFIED: `rustup --version`, packages/slic3r-rust/BUILD.bazel] |
| Bash | Comparator and tests | yes | GNU bash 3.2.57 | None needed; existing scripts use Bash. [VERIFIED: `bash --version`, existing scripts] |
| `awk` | TSV helpers | yes | `/usr/bin/awk` | None needed; existing scripts use portable awk patterns. [VERIFIED: `command -v awk`, existing scripts] |
| `diff` | Unified mismatch output | yes | Apple diff | None needed. [VERIFIED: `diff --version`, compare_prusaslicer_project_file.sh] |
| `shasum` | Existing fixture verifier | yes | 6.02 | None needed; Phase 48 should not add new checksum needs. [VERIFIED: `shasum --version`, verify_prusa_gcode_output_fixture.sh] |
| Git | `git diff --check` and optional GSD commit | yes | 2.53.0 | None needed. [VERIFIED: `git --version`] |

**Missing dependencies with no fallback:** None. [VERIFIED: environment probes]

**Missing dependencies with fallback:** None. [VERIFIED: environment probes]

## Security Domain

OWASP ASVS is a web-application and web-service verification standard; this Phase 48 work is a local CLI/docs/Bazel evidence slice, so only the input-validation style controls are directly applicable. [CITED: OWASP ASVS project page, VERIFIED: 48-CONTEXT.md]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | No authentication, credentials, users, or sessions are introduced by the parity command. [VERIFIED: 48-CONTEXT.md] |
| V3 Session Management | no | No web/session state is introduced. [VERIFIED: 48-CONTEXT.md] |
| V4 Access Control | no | No authorization boundary or privileged service is introduced. [VERIFIED: 48-CONTEXT.md] |
| V5 Input Validation | yes | Use the existing typed Rust parser for the TSV contract plus shell `assert_file`, executable checks, exact row checks, and fail-closed errors. [VERIFIED: prusa_gcode_output.rs, compare_prusaslicer_project_file.sh] |
| V6 Cryptography | no | No cryptographic operation is added; fixture hashes remain existing fixture-verifier provenance checks. [VERIFIED: verify_prusa_gcode_output_fixture.sh, 48-CONTEXT.md] |

### Known Threat Patterns for Phase 48

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Tampered expected summary row passes publication | Tampering | Rust parser rejects wrong source refs, fixture paths, marker keys/values, notes, duplicates, missing rows, extra rows, and wrong ordering; comparator mutation test must prove non-zero failure. [VERIFIED: prusa_gcode_output.rs, tests/prusa_gcode_output.rs] |
| Status overclaim misleads maintainers | Spoofing / Information Disclosure | Add only the exact fork row, keep broad `generated-outputs` in progress, and require deferred-scope wording in docs/status. [VERIFIED: 48-CONTEXT.md, packages/parity/status.tsv] |
| Comparator accidentally reads or executes broad behavior | Elevation of Privilege / Tampering | Keep shell as a thin adapter over checked-in runfiles; forbid raw G-code parsing, PrusaSlicer execution, Git, network, printer, profile, release, and sync behavior. [VERIFIED: 48-CONTEXT.md] |
| Runfiles path confusion produces false pass/fail | Tampering | Wire all inputs through Bazel `data` and `$(location)`, then check file presence and summary-binary executability before comparison. [VERIFIED: packages/parity/BUILD.bazel, compare_prusaslicer_project_file.sh] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/48-executable-prusa-g-code-evidence/48-CONTEXT.md` - locked Phase 48 decisions, discretion, deferred scope, and canonical refs. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - PGEV-01, PGEV-02, PGEV-03 and v1.12 exclusions. [VERIFIED: file read]
- `.planning/ROADMAP.md` and `.planning/STATE.md` - Phase 48 goal, sequencing, dependency on Phase 47, and current state. [VERIFIED: file read]
- `.planning/PROJECT.md` - v1.12 evidence ladder and current milestone context. [VERIFIED: file read]
- `.planning/phases/45-*`, `46-*`, and `47-*` context plus `47-VERIFICATION.md` - prior handoff decisions and absence boundaries. [VERIFIED: file read]
- `packages/parity/compare_prusaslicer_project_file.sh`, `compare_prusaslicer_project_file_test.sh`, `BUILD.bazel`, `status.tsv`, and `README.md` - closest executable parity pattern. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`, `tests/prusa_gcode_output.rs`, `src/bin/prusa_project_file_summary.rs`, and `BUILD.bazel` - Rust summary boundary and binary pattern. [VERIFIED: file read]
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh`, `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`, and project-file fixture verifier - absence guard and publication-check reconciliation pattern. [VERIFIED: file read]
- `docs/port/README.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, `docs/port/package-map.md`, and `packages/slic3r-rust/README.md` - public docs surfaces affected by Phase 48. [VERIFIED: file read]
- Local command probes for Bazel, Rust, Bash, diff, shasum, Git, and existing G-code verifiers/tests. [VERIFIED: command output]

### Primary Standards (HIGH confidence)

- Bright Builds pinned standards index at commit `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: `standards/index.md`, `core/architecture.md`, `core/code-shape.md`, `core/verification.md`, `core/testing.md`, `core/operability.md`, `core/local-guidance.md`, and `languages/rust.md`. [CITED: raw.githubusercontent.com/bright-builds-llc/bright-builds-rules]
- OWASP ASVS project page and OWASP ASVS GitHub repository - ASVS is a web application / web service verification standard and latest stable 5.0.0 context. [CITED: owasp.org/www-project-application-security-verification-standard, github.com/OWASP/ASVS]

### Secondary (MEDIUM confidence)

- None used. [VERIFIED: research process]

### Tertiary (LOW confidence)

- None used. [VERIFIED: research process]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - all tools and local versions were verified from `.bazelversion`, `MODULE.bazel`, and environment probes. [VERIFIED: `.bazelversion`, MODULE.bazel, command output]
- Architecture: HIGH - the implementation pattern is copied from existing project-file parity and Rust summary binaries in the repo. [VERIFIED: packages/parity/BUILD.bazel, prusa_project_file_summary.rs]
- Pitfalls: HIGH - absence guards and comparator behavior were verified from current scripts and Phase 47 verification. [VERIFIED: verify_prusa_gcode_output_fixture.sh, verify_prusa_gcode_output_scope.sh, compare_prusaslicer_project_file.sh, 47-VERIFICATION.md]
- Security: MEDIUM - ASVS applicability is limited because Phase 48 is not a web application surface, but local input-validation and no-side-effect controls are directly verified. [CITED: OWASP ASVS project page, VERIFIED: 48-CONTEXT.md]

**Research date:** 2026-06-14
**Valid until:** 2026-07-14 for local repo patterns; re-check environment versions and current absence guards before implementation if the branch changes. [VERIFIED: git/status and command probes on 2026-06-14]
