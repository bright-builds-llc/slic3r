# Phase 60: Executable Arc-Fitting Evidence - Research

**Researched:** 2026-06-24 [VERIFIED: system current date]
**Domain:** Bazel public parity command, Rust evidence boundary adapter, fail-closed shell mutation guards, status/docs publication [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]
**Confidence:** HIGH [VERIFIED: codebase inspection, Bazel query/test runs, .planning/STATE.md]

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

The following locked decisions are copied from `.planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md`. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

## Implementation Decisions

### Public executable evidence

- **D-01:** Add the public evidence command as
  `bazel run //packages/parity:prusaslicer_arc_fitting_parity`, matching the
  Phase 57 planned command and the Phase 59 readiness metadata. The command
  should live in `packages/parity` beside the existing public Prusa G-code,
  project-file, and profile-schema parity commands.
- **D-02:** The public command should validate the checked-in
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
  through the Rust `slic3r_flavors::prusa_arc_fitting` boundary. Shell may
  orchestrate fixture paths, command output, and status text, but the Rust
  boundary remains the authority for parsed arc facts and invalid summary
  rejection.
- **D-03:** Public command output should print narrow evidence facts only:
  source identity, fixture identity/path, G2/G3 counts, direction counts,
  center-offset observations, coordinate bounds, extrusion observations,
  feedrate observations, and the checked-in-summary evidence boundary. It
  must not describe the result as byte parity, generated-output parity,
  algorithm equivalence, geometry/tolerance parity, printability, runtime
  behavior, GUI behavior, release behavior, sync behavior, or non-Prusa fork
  support.
- **D-04:** Preserve the existing public
  `bazel run //packages/parity:prusaslicer_gcode_output_parity` contract and
  `fork.prusaslicer.gcode-output` status wording. Arc-fitting publication is a
  separate evidence row and must not widen the semantic Prusa G-code output
  row.

### Fail-closed mutation guards

- **D-05:** Add public parity mutation coverage for every ARCEV-02 drift class:
  G2/G3 command-count changes, arc direction changes, center-offset changes,
  coordinate-bound changes, extrusion observation changes, feedrate
  observation changes, source identity drift, fixture identity/path drift, and
  unsupported deferred-behavior claims.
- **D-06:** Mutation tests should use isolated temporary copies of the checked-in
  arc summary or related status/docs inputs. They should assert diagnostics
  from the public command or Rust-backed validation path rather than duplicating
  arc validation logic in Bash.
- **D-07:** Keep mutation tests focused: each test should prove one failure
  class and name the field or artifact that failed. This follows the existing
  `compare_prusaslicer_gcode_output_test.sh` pattern while applying it to the
  arc-fitting summary facts.

### Status and docs publication

- **D-08:** Add exactly one `fork.prusaslicer.arc-fitting` row to
  `packages/parity/status.tsv` only after the public executable evidence and
  mutation guards pass. The row must name the narrow Phase 57-60 evidence chain
  and keep all generated-output/runtime deferrals explicit.
- **D-09:** Preserve exactly one broad `generated-outputs` row with status
  `in progress`. Phase 60 is one feature-specific generated-output slice, not
  sufficient evidence to graduate the broad generated-output surface.
- **D-10:** Update `packages/parity/README.md`, `docs/port/package-map.md`,
  `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and any
  directly related port docs only as needed to expose the new public
  arc-fitting evidence command/status row and the narrow evidence boundary.
- **D-11:** Public docs should describe the evidence chain as: Phase 57 reviewed
  scope contract, Phase 58 checked-in fixture/expected summary, Phase 59 pure
  Rust parser/readiness boundary, and Phase 60 public command/status/docs.
  Docs must say the existing semantic Prusa G-code output evidence remains
  separate.

### Verification gate

- **D-12:** Required verification should include the new public parity command,
  its mutation test target, the existing public Prusa G-code output parity
  command/test, arc-fitting fixture verification, arc-fitting scope
  verification, aggregate Rust verification, parity status checks, and docs or
  package verifiers touched by the plan.
- **D-13:** If exact wording guards in existing scope or fixture verifiers fail
  because Phase 60 legitimately publishes status/docs, update those verifier
  contracts narrowly to the new Phase 60-published wording. Do not relax
  forbidden-claim or generated-output guards.

### the agent's Discretion

- Choose the exact shell helper names and public output line ordering, provided
  output is deterministic, reviewable, and constrained to the approved
  arc-fitting facts.
- Choose whether the public command calls an existing Rust binary mode or a new
  narrowly named helper, provided the validation path still uses
  `slic3r_flavors::prusa_arc_fitting` and avoids live generation, Git, network,
  process discovery, upstream import, or runtime side effects beyond the
  checked-in evidence command itself.
- Choose exact documentation placement and wording, provided every public
  surface keeps the narrow arc-fitting slice separate from broad
  `generated-outputs` and existing `fork.prusaslicer.gcode-output` semantics.

### Deferred Ideas (OUT OF SCOPE)

No separate `## Deferred Ideas` section exists in `60-CONTEXT.md`; deferrals are embedded in the Phase Boundary and locked implementation decisions above. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| ARCEV-01 | Maintainer can run public Prusa arc-fitting parity evidence that validates the checked-in arc summary artifact through the Rust boundary while preserving the existing public Prusa G-code output command contract. [VERIFIED: .planning/REQUIREMENTS.md] | Add `//packages/parity:prusaslicer_arc_fitting_parity` as a separate `sh_binary`, backed by a narrow Rust summary binary over `prusa_arc_fitting_summary_lines`; keep `//packages/parity:prusaslicer_gcode_output_parity` unchanged and run it as regression proof. [VERIFIED: packages/parity/BUILD.bazel; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: bazel query/test/run] |
| ARCEV-02 | Maintainer can see fail-closed mutation guards for G2/G3 counts, direction, center offsets, coordinate bounds, extrusion/feedrate observations, source identity, fixture identity, and unsupported claims. [VERIFIED: .planning/REQUIREMENTS.md] | Mirror `compare_prusaslicer_gcode_output_test.sh`: mutate isolated temp copies, invoke the public comparator/Rust-backed path, and assert diagnostics naming the mutated artifact/field. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs] |
| ARCEV-03 | Maintainer can inspect status/package/port docs for only the narrow `fork.prusaslicer.arc-fitting` slice while preserving broad deferrals and the existing G-code output meaning. [VERIFIED: .planning/REQUIREMENTS.md] | Publish exactly one arc-fitting status row after executable proof; update `packages/parity/README.md` and direct `docs/port/*` surfaces with the Phase 57-60 chain; keep exactly one `generated-outputs` row as `in progress` and do not alter the existing `fork.prusaslicer.gcode-output` row text. [VERIFIED: packages/parity/status.tsv; VERIFIED: packages/parity/README.md; VERIFIED: docs/port/package-map.md; VERIFIED: docs/port/parity-matrix.md; VERIFIED: docs/port/migration-guidance.md] |
</phase_requirements>

## Summary

Phase 60 should be planned as a publication layer over already-green scope, fixture, and Rust boundary work: Phase 57 created the scope contract, Phase 58 created the checked-in `expected-arc-summary.tsv`, and Phase 59 added the pure `slic3r_flavors::prusa_arc_fitting` parser/readiness API. [VERIFIED: .planning/ROADMAP.md; VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md] The public arc target and a Rust arc summary binary do not currently exist, and `packages/parity/status.tsv` currently has zero `fork.prusaslicer.arc-fitting` rows. [VERIFIED: `bazel query //packages/parity:prusaslicer_arc_fitting_parity`; VERIFIED: `bazel query //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary`; VERIFIED: awk status audit]

The safest plan is to add a small Rust binary named `prusa_arc_fitting_summary` that reads one caller-supplied local TSV, calls `prusa_arc_fitting_summary_lines`, and prints deterministic TSV facts, then add `packages/parity/compare_prusaslicer_arc_fitting.sh` and the public `sh_binary` `//packages/parity:prusaslicer_arc_fitting_parity` around that binary. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh] This keeps Bash orchestration thin, keeps parsed fact authority in Rust, and avoids touching the existing G-code output command contract. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

The docs/status work should be gated after executable evidence and mutation tests pass, because current scope and fixture verifiers intentionally reject premature public status publication and planned/future wording drift. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] The plan must update those exact wording contracts narrowly when Phase 60 legitimately publishes the target and status row, while preserving forbidden-claim checks and the broad `generated-outputs` `in progress` guard. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: packages/parity/status.tsv]

**Primary recommendation:** Add a new narrow Rust `prusa_arc_fitting_summary` binary plus a new `packages/parity` shell comparator/target/test, then publish exactly one arc-fitting status/docs slice after the executable and mutation guards pass. [VERIFIED: codebase pattern inspection]

## Project Constraints (from AGENTS.md)

- The repo-level `AGENTS.md` requires reading `AGENTS.bright-builds.md`, `standards-overrides.md` when present, and relevant canonical Bright Builds standards before plan, review, implementation, or audit work. [VERIFIED: AGENTS.md; VERIFIED: AGENTS.bright-builds.md]
- `AGENTS.bright-builds.md` says the managed Bright Builds files should not be edited directly and local customization belongs in `AGENTS.md` or `standards-overrides.md`. [VERIFIED: AGENTS.bright-builds.md]
- `standards-overrides.md` exists and contains no active project-specific override beyond its placeholder table. [VERIFIED: standards-overrides.md]
- The local `standards/` tree is absent, so the pinned canonical standards were read from the Bright Builds GitHub raw URLs. [VERIFIED: `find . -maxdepth 3 -type d -name standards`; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/index.md]
- Bright Builds architecture guidance prefers functional core / imperative shell, parsing boundary data into domain types, and making illegal states unrepresentable when practical. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md]
- Bright Builds code-shape guidance prefers early returns, language-native guard constructs, `maybe` names for optional internal values, extracting substantial foreign-language logic from strings, rerunnable scripts, and splitting oversized functions/files as refactor triggers. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md]
- Bright Builds verification guidance requires relevant repo-native verification before commit and prefers repo-owned verify/check entrypoints when they exist. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md]
- Bright Builds testing guidance requires unit tests for pure/business logic, one concern per unit test, and clear Arrange/Act/Assert structure. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md]
- Bright Builds Rust guidance prefers `foo.rs` plus `foo/` over new `mod.rs`, `let...else` for guard extraction, `maybe_` for optional internal values, newtypes/enums for invariants, and thin adapters around a pure core. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md]
- Repo-local guidance says `.planning/phases/*/*-SUMMARY.md` frontmatter must keep `requirements-completed` synchronized, use the hyphenated key, use `[]` when no requirements close, and must not be processed through `mdformat`. [VERIFIED: AGENTS.md]
- The user-provided AGENTS instructions require plan-first behavior for non-trivial work, verification before done, use of `rg` for searching, Bash scripts with `#!/usr/bin/env bash` and `set -euo pipefail`, Rust pre-commit checks before commits, and behavior-focused tests with Arrange/Act/Assert comments. [VERIFIED: user-provided AGENTS instructions]

## Standard Stack

### Core

| Tool/Library | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| Bazel / Bazelisk | Repo pins Bazel `8.6.0`; local `bazel` and `bazelisk` report `bazel 8.6.0`. [VERIFIED: .bazelversion; VERIFIED: `bazel --version`; VERIFIED: `bazelisk --version`] | Define `rust_binary`, `sh_binary`, and `sh_test` targets for public parity evidence and mutation tests. [VERIFIED: packages/parity/BUILD.bazel; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Existing public parity commands and Rust summary binaries are Bazel targets, so Phase 60 should use the same build/test surface. [VERIFIED: packages/parity/BUILD.bazel] |
| Rust `slic3r_flavors` crate | Crate version `0.1.0`; local `cargo 1.91.1` and `rustc 1.91.1` are installed. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml; VERIFIED: `cargo --version`; VERIFIED: `rustc --version`] | Own typed parsing/readiness facts for Prusa fork evidence boundaries. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] | Phase 59 already exposes `parse_prusa_arc_fitting_summary` and `prusa_arc_fitting_summary_lines`, so Phase 60 should adapt that boundary rather than re-parse in Bash. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| Bash 3.2-compatible shell scripts | Local `/bin/bash` is GNU Bash `3.2.57(1)-release`. [VERIFIED: `bash --version`] | Orchestrate Bazel runfiles, temp mutation copies, file checks, and user-visible public evidence output. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh] | Existing public parity wrappers are Bash scripts with `set -euo pipefail` and deterministic diagnostics. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh] |
| POSIX/macOS text tools | `diff`, `awk`, `sed`, and `shasum` are available; local `shasum` reports `6.02` and local `diff` reports Apple diff. [VERIFIED: command availability audit] | Compare generated summary facts, derive mutation diagnostics, and verify fixture integrity. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] | Existing verifier and comparator scripts already depend on these tools. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |

### Supporting

| Tool/Library | Version | Purpose | When to Use |
|--------------|---------|---------|-------------|
| `shfmt` | Local `shfmt 3.12.0` is available. [VERIFIED: `shfmt --version`] | Check shell formatting for newly added shell scripts. [CITED: Bright Builds verification standard] | Use check/list/diff mode for changed shell scripts if the execution plan includes formatter verification. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md] |
| `mdformat` | Local `mdformat 1.0.0` is available. [VERIFIED: `mdformat --version`] | Optional Markdown formatting checks for docs. [CITED: Bright Builds verification standard] | Do not run it on phase `*-SUMMARY.md`; for Phase 60 docs, prefer targeted checks and `git diff --check` unless the plan explicitly chooses Markdown formatter checks. [VERIFIED: AGENTS.md; CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| New `prusa_arc_fitting_summary` Rust binary [RECOMMENDED] | Extend `prusa_gcode_output_summary` with an arc mode. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs] | Extending the existing G-code binary risks widening or confusing the preserved `fork.prusaslicer.gcode-output` command contract, while a new arc binary maps one-to-one to `slic3r_flavors::prusa_arc_fitting`. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |
| Rust-backed summary validation [RECOMMENDED] | Reimplement the TSV checks in Bash. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] | Bash can orchestrate and diff, but the Phase 60 decision says Rust remains the authority for parsed arc facts and invalid summary rejection. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |
| Checked-in fixture summary evidence [RECOMMENDED] | Live PrusaSlicer/ArcWelder generation. [VERIFIED: .planning/REQUIREMENTS.md] | Live generation, upstream import, network, printer-runtime, and algorithm-equivalence behavior are explicitly deferred for v1.15. [VERIFIED: .planning/REQUIREMENTS.md] |

**Installation:** No new packages are recommended for Phase 60; use the existing Bazel, Rust, Bash, and checked-in fixture surfaces. [VERIFIED: codebase inspection; VERIFIED: environment availability audit]

**Version verification:** Package-manager version lookup is not applicable because Phase 60 should not add npm/crates.io dependencies; local tool versions were verified with `bazel --version`, `bazelisk --version`, `cargo --version`, `rustc --version`, `bash --version`, `shfmt --version`, and `mdformat --version`. [VERIFIED: command availability audit]

## Architecture Patterns

### Recommended Project Structure

```text
packages/
├── parity/
│   ├── compare_prusaslicer_arc_fitting.sh        # new thin public comparator shell
│   ├── compare_prusaslicer_arc_fitting_test.sh   # new mutation guard suite
│   ├── BUILD.bazel                               # new sh_binary/sh_test target wiring
│   ├── README.md                                 # publish narrow public command docs
│   └── status.tsv                                # exactly one new arc-fitting status row after evidence passes
├── parity-fixtures/
│   └── forks/prusaslicer/prusaslicer.arc-fitting/
│       └── expected-arc-summary.tsv              # existing checked-in artifact consumed by public command
├── prusa-arc-fitting-scope/
│   ├── arc-fitting-scope.md                      # existing scope contract; may need narrow Phase 60 wording update
│   └── verify_prusa_arc_fitting_scope.sh         # existing exact verifier; do not relax forbidden-claim checks
└── slic3r-rust/crates/slic3r_flavors/
    ├── src/bin/prusa_arc_fitting_summary.rs      # new tiny Rust binary adapter
    ├── src/prusa_arc_fitting.rs                  # existing pure parser/readiness boundary
    └── BUILD.bazel                               # new rust_binary plus clippy/rustfmt wiring
docs/port/
├── package-map.md
├── parity-matrix.md
├── migration-guidance.md
└── README.md                                     # update only if direct visibility is needed
```

This structure follows existing public Prusa evidence ownership and keeps arc-fitting out of the existing `prusaslicer.gcode-output` namespace. [VERIFIED: packages/parity/BUILD.bazel; VERIFIED: packages/parity-fixtures/BUILD.bazel; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

### Pattern 1: Rust Functional Core, Shell Adapter

**What:** Keep validation in Rust domain functions over caller-supplied strings, then expose a tiny Rust binary and shell command that only perform local file reads, runfile orchestration, diffs, assertions, and public output. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh]

**When to use:** Use for `ARCEV-01` because the checked-in arc summary must be validated through `slic3r_flavors::prusa_arc_fitting` and exposed as a public Bazel command. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Example:**

```rust
#![forbid(unsafe_code)]

use std::{env, fs, path::Path, process::ExitCode};

use slic3r_flavors::prusa_arc_fitting_summary_lines;

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    let result = match args.as_slice() {
        [_, fixture_path] => run_summary(Path::new(fixture_path)),
        _ => Err("expected expected-arc-summary.tsv".to_owned()),
    };

    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}
```

The example is adapted from the existing `prusa_gcode_output_summary` binary pattern and should call the existing arc summary-lines helper. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]

### Pattern 2: Public Comparator Validates Checked-In Artifact Twice

**What:** The public `sh_binary` should pass the checked-in arc summary as both the trusted Rust input and expected artifact for the normal run, while the mutation test passes a temp-mutated expected artifact to prove failure. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; VERIFIED: packages/parity/BUILD.bazel]

**When to use:** Use for public command parity with the existing G-code comparator and for mutation tests that should fail through the same public path. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Example:**

```bash
if ! "${summary_binary}" "${expected_artifact}" >"${expected_summary_lines}"; then
    printf 'error: expected-arc-summary.tsv failed Rust arc validation at %s in %s\n' \
        "${mismatch_label}" "${expected_artifact}" >&2
    exit 1
fi
```

This pattern keeps the diagnostic authority in the Rust-backed summary path while shell owns public error context. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh]

### Pattern 3: Exact Status/Docs Publication After Evidence Passes

**What:** Add one `fork.prusaslicer.arc-fitting` row only after the command and mutation suite pass, and use docs wording that names the Phase 57-60 chain and explicit deferrals. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**When to use:** Use for `ARCEV-03` and update only directly related public surfaces: `packages/parity/status.tsv`, `packages/parity/README.md`, `docs/port/package-map.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, and possibly `docs/port/README.md`. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Example status wording skeleton:**

```text
fork.prusaslicer.arc-fitting	verified	//packages/parity:prusaslicer_arc_fitting_parity	Shared fixture comparison proves the narrow Prusa arc-fitting checked-in summary evidence slice backed by the Phase 57 scope contract, Phase 58 fixture corpus, Phase 59 Rust parser/readiness boundary, and Phase 60 public parity command only; byte-for-byte G-code parity, broad generated-output verification, ArcWelder algorithm equivalence, tolerance or geometry parity, printability, firmware behavior, printer-runtime behavior, GUI behavior, support generation, wall seam behavior, release behavior, host upload, network/device behavior, upstream source imports, sync automation, Bambu Studio, OrcaSlicer, and non-Prusa fork behavior remain deferred
```

The skeleton mirrors existing status row style and keeps broad generated-output graduation deferred. [VERIFIED: packages/parity/status.tsv; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

### Anti-Patterns to Avoid

- **Do not modify `prusaslicer_gcode_output_parity` to carry arc facts:** that would risk widening a command/status row whose existing meaning must remain semantic G-code output only. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: packages/parity/status.tsv]
- **Do not validate arc drift only in Bash:** Phase 60 requires the Rust `slic3r_flavors::prusa_arc_fitting` boundary to remain authoritative for parsed facts and invalid summaries. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]
- **Do not promote `generated-outputs`:** the existing broad row is exactly `in progress`, and one arc-fitting slice is not broad generated-output verification. [VERIFIED: packages/parity/status.tsv; VERIFIED: .planning/REQUIREMENTS.md]
- **Do not add live generation, Git, network, process discovery, upstream import, printer-runtime, or GUI behavior:** v1.15 explicitly defers those surfaces. [VERIFIED: .planning/REQUIREMENTS.md; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]
- **Do not weaken forbidden-claim verifiers:** exact wording updates may be necessary for Phase 60 publication, but forbidden-claim and generated-output guards must remain strict. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Arc summary parsing | A Bash TSV parser for G2/G3 facts. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] | `slic3r_flavors::prusa_arc_fitting::parse_prusa_arc_fitting_summary` and `prusa_arc_fitting_summary_lines`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] | Rust already rejects invalid header, wrong columns, missing/duplicate/out-of-order rows, unsupported fields, source/fixture/value drift, and unsupported boundary text. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs] |
| ArcWelder behavior | A generator, geometry comparator, tolerance checker, or printability/runtime proxy. [VERIFIED: .planning/REQUIREMENTS.md] | Checked-in `expected-arc-summary.tsv` facts only. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv] | Full algorithm equivalence, tolerance/geometry parity, printability, firmware, and runtime behavior are deferred. [VERIFIED: .planning/REQUIREMENTS.md] |
| Public mutation harness | Custom one-off destructive mutation of tracked files. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh] | Temp-copy mutation tests that call the public comparator and assert diagnostics. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] | Existing mutation suites prove one failure class per test without changing repo fixtures. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh] |
| Status interpretation | A new broad generated-output status model. [VERIFIED: packages/parity/status.tsv] | Existing `status.tsv` row shape plus exactly one narrow `fork.prusaslicer.arc-fitting` row. [VERIFIED: packages/parity/status.tsv; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] | Existing public parity rows use one surface/status/evidence/notes row per verified slice. [VERIFIED: packages/parity/status.tsv] |
| Documentation truth source | Scattered optimistic docs language. [VERIFIED: docs/port/migration-guidance.md] | Phase chain wording across package docs and direct port docs. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] | Public docs currently maintain precise deferral language for Prusa G-code output and generated outputs. [VERIFIED: docs/port/parity-matrix.md; VERIFIED: docs/port/migration-guidance.md] |

**Key insight:** The hard problem is not detecting arcs; the checked-in fixture already records two arc observations and the Rust boundary already validates the closed facts. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] The hard problem for Phase 60 is publishing public evidence without changing the meaning of broader status rows or claiming behavior not represented by the summary. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

## Common Pitfalls

### Pitfall 1: Accidentally Widening `fork.prusaslicer.gcode-output`

**What goes wrong:** Arc facts are added to the existing G-code comparator/docs/status text, making the old row appear to cover arc fitting. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Why it happens:** The arc-fitting slice is a generated-output feature, but the existing public Prusa G-code command is already published for a narrow semantic G-code evidence chain. [VERIFIED: packages/parity/status.tsv; VERIFIED: docs/port/parity-matrix.md]

**How to avoid:** Add separate `prusaslicer_arc_fitting_parity` command/docs/status row and run the existing `prusaslicer_gcode_output_parity` command/test as regression proof. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: successful `bazel run //packages/parity:prusaslicer_gcode_output_parity`; VERIFIED: successful `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test`]

**Warning signs:** Diffs touching `compare_prusaslicer_gcode_output.sh` or the exact existing `fork.prusaslicer.gcode-output` row without a narrowly justified no-widening guard. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/parity/status.tsv]

### Pitfall 2: Publishing Status Before Evidence Passes

**What goes wrong:** `packages/parity/status.tsv` gets a `fork.prusaslicer.arc-fitting` row before the public target and mutation suite exist. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh]

**Why it happens:** Scope and readiness metadata already mention the planned status token, but planned metadata is not public executable proof. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]

**How to avoid:** Order tasks as Rust binary/comparator, public target, mutation tests, verification, then status/docs publication and verifier wording updates. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Warning signs:** `awk` reports an arc status row before `bazel query //packages/parity:prusaslicer_arc_fitting_parity` succeeds. [VERIFIED: awk status audit; VERIFIED: bazel query failure]

### Pitfall 3: Mutation Tests Duplicate Rust Validation Logic

**What goes wrong:** Bash tests independently decide what is valid instead of proving the public Rust-backed path fails. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Why it happens:** Fixture verifiers already contain exact Bash constants, so it is tempting to copy those checks into public parity tests. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**How to avoid:** Mutation tests should edit one field in a temp copy, run the public comparator, and assert stderr names `expected-arc-summary.tsv` plus the field or forbidden phrase. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

**Warning signs:** A mutation test passes without invoking `compare_prusaslicer_arc_fitting.sh` or the Rust summary binary. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh]

### Pitfall 4: Exact Verifiers Fail After Legitimate Publication

**What goes wrong:** Scope or fixture verifiers reject Phase 60 docs/status wording because their Phase 57/58 expected text still says the public command/status is future. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**Why it happens:** The verifiers are intentionally exact and currently protect the pre-publication boundary. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

**How to avoid:** Update exact expected wording narrowly to Phase 60-published wording after the command/mutation evidence passes, and preserve forbidden-claim scans. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Warning signs:** Verifier failures that mention planned/future public command/status text rather than a real forbidden claim. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh]

### Pitfall 5: Overclaiming Public Output

**What goes wrong:** The command or docs say "byte parity", "generated-output parity", "algorithm equivalence", "geometry parity", "printability", "runtime behavior", "GUI behavior", "release behavior", "sync behavior", or non-Prusa fork support. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**Why it happens:** The Bazel target name includes `parity`, but the evidence slice is only checked-in arc-summary fact validation. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

**How to avoid:** Print only source identity, fixture identity/path, counts, observations, bounds, extrusion/feedrate observations, and checked-in-summary boundary. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs]

**Warning signs:** New public lines contain the forbidden behavior nouns without "deferred" boundary wording. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh]

## Code Examples

Verified patterns from existing sources:

### Rust Binary Adapter Pattern

```rust
fn read_input(path: &Path) -> Result<String, String> {
    fs::read_to_string(path).map_err(|error| format!("failed to read {}: {error}", path.display()))
}

fn print_lines(lines: Vec<String>) {
    for line in lines {
        println!("{line}");
    }
}
```

This existing pattern should be reused for the new `prusa_arc_fitting_summary` binary, replacing the called helper with `prusa_arc_fitting_summary_lines`. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]

### Public Comparator Failure Pattern

```bash
if ! diff_output="$(diff -u "${expected_summary_lines}" "${actual_summary}")"; then
    mismatch_label="$(first_summary_mismatch_label "${expected_summary_lines}" "${actual_summary}")"
    printf 'error: expected-arc-summary.tsv mismatch at %s in %s\n' \
        "${mismatch_label}" "${expected_artifact}" >&2
    printf '%s\n' "${diff_output}" >&2
    exit 1
fi
```

This pattern gives reviewers exact drift diagnostics and should be adapted to arc summary line comparisons. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh]

### Bazel Target Wiring Pattern

```python
sh_binary(
    name = "prusaslicer_arc_fitting_parity",
    srcs = ["compare_prusaslicer_arc_fitting.sh"],
    data = [
        "status.tsv",
        "//packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary",
        "//packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary",
        "//packages/parity-fixtures:prusa_arc_fitting_provenance",
    ],
    args = [
        "$(location //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_summary)",
        "$(location //packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary)",
        "$(location //packages/parity-fixtures:prusa_arc_fitting_expected_arc_summary)",
        "$(location //packages/parity-fixtures:prusa_arc_fitting_provenance)",
    ],
)
```

This skeleton mirrors the existing public Prusa parity target shape while using an arc-specific Rust binary and fixture aliases. [VERIFIED: packages/parity/BUILD.bazel; VERIFIED: packages/parity-fixtures/BUILD.bazel]

### Mutation Test Pattern

```bash
cp "${expected_arc_summary}" "${mutated_expected}"
mutate_arc_value "${mutated_expected}" "arc_command_counts" "G2:2;G3:1;total_arc_commands:3"

if run_comparator "${mutated_expected}" "${stdout_file}" "${stderr_file}"; then
    fail "mutated expected-arc-summary.tsv passed for arc_command_counts"
fi

assert_contains "${stderr_file}" "expected-arc-summary.tsv"
assert_contains "${stderr_file}" "arc_command_counts"
```

The pattern should be repeated once per ARCEV-02 drift class, with one mutation concern per test. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; VERIFIED: .planning/REQUIREMENTS.md]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Source/inventory metadata only for arc fitting. [VERIFIED: .planning/STATE.md] | Phase 57 reviewed closed scope contract for `prusaslicer.arc-fitting`. [VERIFIED: .planning/ROADMAP.md; VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] | 2026-06-23. [VERIFIED: .planning/ROADMAP.md] | Planning can rely on approved fields, planned command/status token, and no-overclaiming boundary. [VERIFIED: packages/prusa-arc-fitting-scope/arc-fitting-scope.md] |
| No checked-in arc summary artifact. [VERIFIED: .planning/phases/58-arc-fitting-fixture-corpus/58-CONTEXT.md] | Phase 58 checked in `expected-arc-summary.tsv`, provenance, fixture bytes, and fail-closed fixture verifier. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] | 2026-06-23. [VERIFIED: .planning/ROADMAP.md] | Public evidence can validate a real checked-in artifact without live generation. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/README.md] |
| No Rust arc parser/readiness boundary. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-CONTEXT.md] | Phase 59 added pure typed `slic3r_flavors::prusa_arc_fitting` parser/readiness metadata and tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_arc_fitting.rs] | 2026-06-24. [VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md] | Phase 60 should add only the executable adapter/publication layer. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |
| `fork.prusaslicer.arc-fitting` absent from public status. [VERIFIED: awk status audit] | Phase 60 may publish exactly one row after public evidence/mutation guards pass. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] | Future Phase 60 execution. [VERIFIED: .planning/ROADMAP.md] | Planner must order status/docs after executable proof. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |

**Deprecated/outdated:** Treating source pins, registry metadata, or fixture presence as executable parity proof is not valid in this repo; public `verified` fork status requires a runnable `//packages/parity:*_parity` evidence command. [VERIFIED: docs/port/parity-matrix.md; VERIFIED: docs/port/migration-guidance.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| - | No assumed claims are used in this research. [VERIFIED: self-audit] | All sections | None from assumptions; remaining risk is implementation/order discipline. [VERIFIED: self-audit] |

## Open Questions

1. **None blocking.** The exact shell helper names and output line order are intentionally left to implementation discretion, constrained by deterministic output and the approved fact list. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel | Public `sh_binary`/`sh_test` targets and verification. [VERIFIED: packages/parity/BUILD.bazel] | Yes. [VERIFIED: `command -v bazel`] | `8.6.0`. [VERIFIED: `bazel --version`; VERIFIED: .bazelversion] | Bazelisk is also installed. [VERIFIED: `command -v bazelisk`] |
| Bazelisk | Repo-pinned Bazel launcher. [VERIFIED: docs/port/README.md] | Yes. [VERIFIED: `command -v bazelisk`] | Reports `bazel 8.6.0`. [VERIFIED: `bazelisk --version`] | Use `bazel` directly, already version-matched. [VERIFIED: `bazel --version`] |
| Cargo | Rust crate tests and optional binary tests. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml] | Yes. [VERIFIED: `command -v cargo`] | `cargo 1.91.1`. [VERIFIED: `cargo --version`] | Use Bazel Rust targets if Cargo is not part of the plan gate. [VERIFIED: packages/slic3r-rust/BUILD.bazel] |
| Rust compiler | New Rust summary binary. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel] | Yes. [VERIFIED: `command -v rustc`] | `rustc 1.91.1`. [VERIFIED: `rustc --version`] | None needed locally because Rust is available. [VERIFIED: environment availability audit] |
| Bash | Comparator and mutation scripts. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh] | Yes. [VERIFIED: `command -v bash`] | GNU Bash `3.2.57(1)-release`. [VERIFIED: `bash --version`] | None; keep scripts Bash 3.2-compatible. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] |
| `diff`, `awk`, `sed`, `shasum` | Summary diffs, mutation edits, and fixture checks. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] | Yes. [VERIFIED: command availability audit] | `shasum 6.02`; Apple diff. [VERIFIED: `shasum --version`; VERIFIED: `diff --version`] | None required. [VERIFIED: environment availability audit] |
| `shfmt` | Optional shell formatting check. [CITED: Bright Builds verification standard] | Yes. [VERIFIED: `command -v shfmt`] | `3.12.0`. [VERIFIED: `shfmt --version`] | Use manual review if formatter not included in the plan. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md] |
| `mdformat` | Optional Markdown formatting check, excluding phase summaries. [VERIFIED: AGENTS.md] | Yes. [VERIFIED: `command -v mdformat`] | `1.0.0`. [VERIFIED: `mdformat --version`] | Use `git diff --check` and targeted doc checks if formatter is not chosen. [VERIFIED: AGENTS.md] |

**Missing dependencies with no fallback:** None found for the Phase 60 planning surface. [VERIFIED: environment availability audit]

**Missing dependencies with fallback:** None found for the Phase 60 planning surface. [VERIFIED: environment availability audit]

## Verification Architecture

Skipped because `.planning/config.json` does not set `workflow.nyquist_validation` to `true`. [VERIFIED: .planning/config.json]

## Recommended Verification Gate

Run these after implementation, in this order, because they match the locked Phase 60 verification gate and current repo patterns. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md]

```bash
bazel run //packages/parity:prusaslicer_arc_fitting_parity
bazel test //packages/parity:prusaslicer_arc_fitting_parity_failure_test --test_output=errors
bazel run //packages/parity:prusaslicer_gcode_output_parity
bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors
bazel run //packages/parity-fixtures:verify_prusa_arc_fitting_fixture
bazel test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test --test_output=errors
bazel run //packages/prusa-arc-fitting-scope:verify
bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test --test_output=errors
bazel test //packages/slic3r-rust:verify --test_output=errors
bazel run //packages/parity:status
git diff --check
```

Existing baseline checks passed for the arc scope mutation test, arc fixture mutation test, arc Rust parser test, existing G-code public mutation test, and existing G-code public command during this research session. [VERIFIED: `bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test //packages/parity-fixtures:verify_prusa_arc_fitting_fixture_test //packages/slic3r-rust/crates/slic3r_flavors:prusa_arc_fitting_test --test_output=errors`; VERIFIED: `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors`; VERIFIED: `bazel run //packages/parity:prusaslicer_gcode_output_parity`]

## Security Domain

`security_enforcement` is not explicitly set to `false` in `.planning/config.json`, so include security analysis for planning. [VERIFIED: .planning/config.json] OWASP ASVS is a web application security verification standard and its current project page identifies latest stable version 5.0.0; this phase is a local Bazel/Rust fixture evidence command, so web auth/session/access-control categories are not applicable unless a future phase adds a web or service surface. [CITED: https://owasp.org/www-project-application-security-verification-standard/]

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No. [VERIFIED: codebase inspection] | No user identity, credentials, login, or secret handling is introduced by the planned local command. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |
| V3 Session Management | No. [VERIFIED: codebase inspection] | No sessions or tokens are present in the planned local command/test surfaces. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs] |
| V4 Access Control | No. [VERIFIED: codebase inspection] | The command reads Bazel-provided checked-in files and does not create authorization boundaries. [VERIFIED: packages/parity/BUILD.bazel; VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md] |
| V5 Input Validation | Yes, for local checked-in TSV input. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] | Use the existing Rust parser to reject invalid headers, columns, rows, values, source/fixture drift, and unsupported evidence boundaries. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs] |
| V6 Cryptography | No new cryptography. [VERIFIED: codebase inspection] | Do not add crypto; fixture SHA-256 integrity remains `shasum`-based verifier evidence, not a security protocol. [VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Evidence overclaiming through public docs/status wording. [VERIFIED: .planning/REQUIREMENTS.md] | Spoofing / Repudiation. [VERIFIED: threat-model mapping] | Exact status/docs wording, forbidden-claim scans, and regression checks preserving `generated-outputs` and `fork.prusaslicer.gcode-output`. [VERIFIED: packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh] |
| Tampering with checked-in arc facts. [VERIFIED: packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv] | Tampering. [VERIFIED: threat-model mapping] | Rust parse/fact validation plus public mutation tests for every ARCEV-02 drift class. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: .planning/REQUIREMENTS.md] |
| Runtime side effects such as Git/network/process/source discovery. [VERIFIED: .planning/REQUIREMENTS.md] | Information Disclosure / Tampering. [VERIFIED: threat-model mapping] | Keep Rust boundary and public command limited to caller-supplied local files and Bazel runfiles; avoid live generation and external access. [VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs; VERIFIED: .planning/phases/59-rust-arc-fitting-evidence-boundary/59-VERIFICATION.md] |
| Shell quoting or temp-file mutation mistakes. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh] | Tampering. [VERIFIED: threat-model mapping] | Use `set -euo pipefail`, quote variables, mutate temp copies, and remove temp dirs with traps. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output_test.sh; VERIFIED: packages/parity-fixtures/verify_prusa_arc_fitting_fixture_test.sh] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md` - locked Phase 60 decisions, public command name, mutation classes, docs/status constraints, and verification gate. [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` - ARCEV-01, ARCEV-02, ARCEV-03, and v1.15 out-of-scope boundaries. [VERIFIED: file read]
- `.planning/STATE.md` - current project position and accumulated evidence-chain decisions. [VERIFIED: file read]
- `.planning/ROADMAP.md` and `.planning/PROJECT.md` - active milestone state, Phase 57-60 ladder, and Phase 60 goal. [VERIFIED: file read]
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo guidance and Bright Builds workflow constraints. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs` - existing pure Rust parser/readiness boundary and summary-lines helper. [VERIFIED: file read]
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs` - existing Rust summary binary adapter pattern. [VERIFIED: file read]
- `packages/parity/compare_prusaslicer_gcode_output.sh` and `packages/parity/compare_prusaslicer_gcode_output_test.sh` - public comparator and mutation-test precedent. [VERIFIED: file read]
- `packages/parity/BUILD.bazel`, `packages/parity/status.tsv`, `packages/parity/README.md` - public parity command/status/docs surfaces. [VERIFIED: file read]
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/*` and `packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` - checked-in arc fixture/provenance/summary and fixture verifier. [VERIFIED: file read]
- `packages/prusa-arc-fitting-scope/*` - scope contract and verifier that may need narrow Phase 60 publication wording updates. [VERIFIED: file read]
- `docs/port/package-map.md`, `docs/port/parity-matrix.md`, `docs/port/migration-guidance.md`, `docs/port/README.md` - public docs surfaces and current Prusa generated-output deferral language. [VERIFIED: file read]
- Command checks: Bazel query confirmed the arc public target and arc Rust binary are absent; awk confirmed zero arc status rows; Bazel tests/runs confirmed baseline arc and G-code checks pass. [VERIFIED: command outputs]

### Primary Web Sources (HIGH confidence)

- Bright Builds standards index: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/index.md - rule levels and corpus use. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- Bright Builds architecture: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md - functional core, parse at boundaries, illegal states. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- Bright Builds code shape: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/code-shape.md - early returns, `maybe`, script shape, size triggers. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- Bright Builds verification: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md - repo-native verification and formatter-check guidance. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- Bright Builds testing: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md - unit tests, one concern, Arrange/Act/Assert. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- Bright Builds Rust: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md - Rust module, guard, optional naming, invariant, and verification guidance. [CITED: official pinned repository URL from AGENTS.bright-builds.md]
- OWASP ASVS project page: https://owasp.org/www-project-application-security-verification-standard/ - ASVS purpose and latest stable version statement. [CITED: official OWASP project page]

### Secondary (MEDIUM confidence)

- None used. [VERIFIED: self-audit]

### Tertiary (LOW confidence)

- None used. [VERIFIED: self-audit]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - local versions and existing Bazel/Rust/Bash targets were inspected and command-probed. [VERIFIED: command outputs; VERIFIED: BUILD.bazel files]
- Architecture: HIGH - the pattern is a direct extension of existing public Prusa parity commands and Phase 59 Rust boundary APIs. [VERIFIED: packages/parity/compare_prusaslicer_gcode_output.sh; VERIFIED: packages/slic3r-rust/crates/slic3r_flavors/src/prusa_arc_fitting.rs]
- Pitfalls: HIGH - each pitfall maps to a locked Phase 60 decision or an existing fail-closed verifier/test. [VERIFIED: .planning/phases/60-executable-arc-fitting-evidence/60-CONTEXT.md; VERIFIED: verifier/test files]

**Research date:** 2026-06-24 [VERIFIED: system current date]
**Valid until:** 2026-07-24 for repo-internal planning facts; re-check if upstream Bright Builds standards, Bazel/Rust toolchains, or Phase 60 context changes before planning. [VERIFIED: current repo state; CITED: Bright Builds standards URLs]
