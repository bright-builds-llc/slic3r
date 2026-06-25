---
phase: 60-executable-arc-fitting-evidence
plan: "02"
subsystem: parity
tags: [bash, bazel, prusaslicer, arc-fitting, mutation-tests, evidence]

requires:
  - phase: 60-executable-arc-fitting-evidence
    provides: Rust-backed public Prusa arc-fitting evidence command from Plan 60-01
provides:
  - Public `//packages/parity:prusaslicer_arc_fitting_parity_failure_test` mutation suite
  - Fail-closed coverage for every ARCEV-02 arc summary drift class
  - Temp-copy guards proving mutation tests leave checked-in arc summaries unchanged
affects:
  - 60-executable-arc-fitting-evidence
  - packages/parity

tech-stack:
  added: []
  patterns:
    - Public mutation tests invoke the Rust-backed arc-fitting comparator instead of duplicating validation logic in Bash
    - Per-field temp copies preserve the `expected-arc-summary.tsv` basename for maintainer diagnostics
    - Bazel sh_test wiring publishes the public arc-fitting failure suite beside existing Prusa parity failure tests

key-files:
  created:
    - .planning/phases/60-executable-arc-fitting-evidence/60-02-SUMMARY.md
    - packages/parity/compare_prusaslicer_arc_fitting_test.sh
  modified:
    - packages/parity/BUILD.bazel

key-decisions:
  - "Kept ARCEV-02 drift coverage in a dedicated public Bazel sh_test target beside the existing Prusa parity failure tests."
  - "Mutated only temp copies of `expected-arc-summary.tsv` and preserved that basename for public comparator diagnostics."
  - "Used the public Rust-backed comparator as the failure authority instead of reimplementing arc summary validation in Bash."

patterns-established:
  - "Arc-fitting mutation guards target column 5 for value drift and column 6 for deferred-claim boundary drift."
  - "Every mutation case asserts stderr names both `expected-arc-summary.tsv` and the changed arc field."

requirements-completed:
  - ARCEV-02
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 60-2026-06-24T15-09-13
generated_at: 2026-06-24T16:13:29Z

duration: 4 min
completed: 2026-06-24
---

# Phase 60 Plan 02: Public Arc-Fitting Mutation Guards Summary

**Public arc-fitting parity now fails closed on field drift and deferred-claim text through the Rust-backed command path**

## Performance

- **Duration:** 4 min
- **Started:** 2026-06-24T16:08:55Z
- **Completed:** 2026-06-24T16:13:29Z
- **Tasks:** 2
- **Files modified:** 2 implementation/test files plus this summary

## Accomplishments

- Added `compare_prusaslicer_arc_fitting_test.sh`, a public mutation harness that copies `expected-arc-summary.tsv` into per-case temp directories and mutates one field per case.
- Covered every ARCEV-02 drift class: G2/G3 counts, direction counts, center offsets, coordinate bounds, extrusion observations, feedrate observations, source identity, fixture identity/path, and unsupported deferred-behavior text.
- Wired `//packages/parity:prusaslicer_arc_fitting_parity_failure_test` into Bazel with the public comparator, Rust summary binary, expected arc summary, and provenance runfiles.
- Proved the checked-in `expected-arc-summary.tsv` retained the exact approved `arc_command_counts`, `fixture_id`, and `fixture_path` rows after mutation tests ran.
- Re-ran the existing public Prusa G-code output command and failure test to prove this plan did not widen or break that contract.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add field-specific temp-copy mutation cases** - `efe00e008` (test)
2. **Task 2: Wire the public mutation suite into Bazel and run regressions** - `b8bbba8d2` (test)

## Files Created/Modified

- `packages/parity/compare_prusaslicer_arc_fitting_test.sh` - New temp-copy mutation suite for ARCEV-02 public comparator failure coverage.
- `packages/parity/BUILD.bazel` - New `prusaslicer_arc_fitting_parity_failure_test` `sh_test` target.
- `.planning/phases/60-executable-arc-fitting-evidence/60-02-SUMMARY.md` - Plan execution record, verification evidence, and requirement completion metadata.

## Verification

- RED Task 1: `rg -n 'arc_command_counts' packages/parity/compare_prusaslicer_arc_fitting_test.sh` failed before the test file existed.
- `bash -n packages/parity/compare_prusaslicer_arc_fitting_test.sh`
- `shfmt -l -d packages/parity/compare_prusaslicer_arc_fitting_test.sh`
- `shellcheck packages/parity/compare_prusaslicer_arc_fitting_test.sh`
- `cargo +1.94.1 fmt --manifest-path packages/slic3r-rust/Cargo.toml --all`
- `cargo +1.94.1 clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings`
- `cargo +1.94.1 build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features`
- `cargo +1.94.1 test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `bazel query //packages/parity:prusaslicer_arc_fitting_parity_failure_test`
- `bazel test --cache_test_results=no //packages/parity:prusaslicer_arc_fitting_parity_failure_test --test_output=errors`
- `bazel run //packages/parity:prusaslicer_arc_fitting_parity`
- `bazel run //packages/parity:prusaslicer_gcode_output_parity`
- `bazel test //packages/parity:prusaslicer_gcode_output_parity_failure_test --test_output=errors`
- `rg -n 'name = "prusaslicer_arc_fitting_parity_failure_test"' packages/parity/BUILD.bazel`
- `rg -n 'compare_prusaslicer_arc_fitting_test.sh' packages/parity/BUILD.bazel`
- `rg -n $'arc_command_counts\tcommand observations\tG2:1;G3:1;total_arc_commands:2' packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv`
- `git diff --check -- packages/parity/compare_prusaslicer_arc_fitting_test.sh packages/parity/BUILD.bazel`
- `git diff --check HEAD~2..HEAD -- packages/parity/compare_prusaslicer_arc_fitting_test.sh packages/parity/BUILD.bazel`

## Decisions Made

- Kept all mutation assertions on the public comparator path so Rust remains the authority for arc summary validation and forbidden-claim rejection.
- Used one case per ARCEV-02 drift class and checked stderr for both the public artifact name and the mutated field.
- Added a separate Bazel failure-test target rather than folding arc-fitting mutations into the existing Prusa G-code output failure suite, keeping the two evidence surfaces separate.

## Deviations from Plan

None - product scope executed exactly as written.

### Process Adjustments

**1. TDD RED was captured as a failing file/field scan instead of a failing commit**
- **Found during:** Task 1
- **Reason:** Repo instructions require passing verification before commits, and the user requested atomic task commits.
- **Adjustment:** Captured the RED signal with the planned missing-file `rg` check, then committed Task 1 only after Bash syntax, shfmt, ShellCheck, acceptance scans, and the repo-required Rust gate passed.
- **Files modified:** None beyond planned files.
- **Verification:** `efe00e008` was created after the Task 1 checks passed.

**2. Loaded pinned Bright Builds canonical pages from raw GitHub URLs**
- **Found during:** Project instruction loading
- **Reason:** `AGENTS.md` requires reading the pinned canonical standards pages, but this checkout does not vendor a local `standards/` tree.
- **Adjustment:** Loaded the pinned `05f8d7a6c9c2e157ec4f922a05273e72dab97676` standards pages for index, architecture, code shape, verification, and testing before implementation.
- **Files modified:** None.
- **Verification:** The implementation followed the loaded verification and shell-script guidance, including shfmt, ShellCheck, and repo-required pre-commit gates.

**Total deviations:** 0 auto-fixed.
**Impact on plan:** No product scope changed; both adjustments preserved repo policy and plan intent.

## Known Stubs

None.

## Threat Flags

None - no unplanned network endpoint, auth path, host upload, external service, or file access pattern outside the planned temp-copy mutation harness was introduced.

## Issues Encountered

- `state record-metric` returned `recorded: false` because its expected metrics table shape is not present in this repo's current `STATE.md`. The successful state/roadmap/requirements commands advanced progress, session continuity, roadmap plan count, decisions, and `ARCEV-02`; the missing recent-execution metric line was patched directly and verified with `git diff --check`.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Plan 60-03 can publish the exact `fork.prusaslicer.arc-fitting` status row and status verifier guards. The public arc-fitting command and mutation suite are green, and the existing public Prusa G-code output command/test still pass.

*Phase: 60-executable-arc-fitting-evidence*
*Completed: 2026-06-24*

## Self-Check: PASSED

- Summary file exists at `.planning/phases/60-executable-arc-fitting-evidence/60-02-SUMMARY.md`.
- Created/modified files exist: `packages/parity/compare_prusaslicer_arc_fitting_test.sh` and `packages/parity/BUILD.bazel`.
- Task commits exist: `efe00e008` and `b8bbba8d2`.
- Summary frontmatter parses with `requirements_completed: [ARCEV-02]`.
- Summary closeout checks passed: `summary-extract` and `git diff --check` on this summary.
