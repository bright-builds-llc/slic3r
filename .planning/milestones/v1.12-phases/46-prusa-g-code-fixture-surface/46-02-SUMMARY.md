---
phase: 46-prusa-g-code-fixture-surface
plan: "02"
subsystem: parity-fixtures
tags: [prusaslicer, gcode-output, fixtures, bazel, bash, verifier]
requires:
  - phase: 46-prusa-g-code-fixture-surface
    provides: "Plan 46-01 source-pinned G-code fixture namespace, provenance, and expected summary artifact"
provides:
  - "Bazel-visible Prusa G-code fixture bundle, aliases, verifier binary, and verifier test"
  - "Fail-closed Bash verifier for fixture bytes, provenance, expected-summary shape, README scope text, and future-phase absence"
  - "Mutation tests proving verifier failure on checksum, ASCII/LF, TSV, README, status, parity, Rust, and forbidden-behavior drift"
  - "Phase 45 scope verifier reconciliation that allows Phase 46 fixture artifacts while rejecting Phase 47/48 artifacts"
affects: [46-prusa-g-code-fixture-surface, 47-rust-prusa-g-code-summary-boundary, 48-executable-prusa-g-code-evidence]
tech-stack:
  added: []
  patterns:
    - "Bazel sh_binary/sh_test fixture verifier targets around source-controlled Prusa G-code evidence"
    - "Bash exact-contract verification with self-scan-safe forbidden behavior checks"
key-files:
  created:
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh
    - packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
    - .planning/phases/46-prusa-g-code-fixture-surface/46-02-SUMMARY.md
  modified:
    - packages/parity-fixtures/BUILD.bazel
    - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh
    - packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
key-decisions:
  - "Kept G-code fixture verification as local Bash exact checks instead of adding a parser or generator framework."
  - "Used self-scan-safe split literals so the verifier rejects Git/network/generation/host-upload behavior without matching its own forbidden-term list."
  - "Allowed only the Phase 46 fixture namespace and expected-summary artifact in the Phase 45 scope verifier while keeping status, parity, and Rust summary artifacts absent."
patterns-established:
  - "G-code fixture bundles expose stable Bazel labels before Rust summary or parity targets consume them."
  - "Verifier tests mutate temp checkout copies instead of checked-in fixture, status, parity, or Rust files."
requirements-completed: [PGFIX-02]
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 46-2026-06-13T16-58-19
generated_at: 2026-06-13T18:30:16Z
duration: "18 min"
completed: 2026-06-13
---

# Phase 46 Plan 02: Prusa G-code Fixture Surface Verification Summary

**Fail-closed Prusa G-code fixture verification through Bazel, Bash exact checks, and mutation tests**

## Performance

- **Duration:** 18 min
- **Started:** 2026-06-13T18:11:56Z
- **Completed:** 2026-06-13T18:30:16Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments

- Exposed `prusa_gcode_output_bundle`, fixture aliases, `verify_prusa_gcode_output_fixture`, and `verify_prusa_gcode_output_fixture_test` through `packages/parity-fixtures/BUILD.bazel`.
- Added `verify_prusa_gcode_output_fixture.sh` to validate exact fixture bytes, SHA-256, ASCII LF policy, provenance row, expected-summary rows, README scope text, and future-phase absence.
- Added mutation tests covering checksum drift, CRLF/non-ASCII drift, provenance and expected-summary drift, README update/exclusion drift, overclaims, premature status/parity/Rust artifacts, and forbidden verifier behavior.
- Reconciled the Phase 45 scope verifier so Phase 46 fixture artifacts are allowed while Phase 47 Rust and Phase 48 parity/status artifacts remain rejected.

## Task Commits

Each task was committed atomically:

1. **Task 1: Export G-code fixture bundle through Bazel** - `3f0d33e58` (`feat`)
2. **Task 2 RED: Add failing verifier mutation tests** - `43f420745` (`test`)
3. **Task 2 GREEN: Implement fail-closed fixture verifier** - `4e9481aed` (`feat`)
4. **Task 3 RED: Add Phase 46 scope allowance tests** - `0c56daaee` (`test`)
5. **Task 3 GREEN: Reconcile scope verifier** - `12575fda0` (`feat`)

## Files Created/Modified

- `packages/parity-fixtures/BUILD.bazel` - Adds G-code fixture exports, aliases, bundle, verifier binary/test targets, and package-boundary entries.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` - Local fail-closed verifier for the G-code fixture surface and Phase 47/48 absence boundaries.
- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh` - Mutation-style tests for fixture integrity, scope text, overclaim, future-artifact, and verifier-behavior drift.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh` - Allows Phase 46 fixture artifacts while continuing to reject premature status, parity, and Rust summary artifacts.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh` - Proves Phase 46 fixture namespace and expected-summary artifacts are allowed, and later artifacts still fail.

## Decisions Made

- Kept verification local and hermetic: no Git, network, upstream import, live generation, host upload, printer-runtime, plugin, or credential behavior.
- Kept the expected artifact contract at the Phase 45 seven-column schema and verified the exact five expected rows from Plan 46-01.
- Split forbidden verifier-behavior literals inside the verifier so the script can scan itself without false positives.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- During GREEN for Task 2, ShellCheck flagged the `FIXTURE_PATH` contract constant as unused. The verifier now checks that fixture path in `expected-gcode-summary.tsv`.
- During GREEN for Task 2, the self-scan initially matched internal source literals and variable names for forbidden behavior terms. The implementation now uses split literals and neutral variable names while preserving the runtime checks.

## Known Stubs

- `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh:327` - `placeholder.sh` is written only into a temp `packages/parity/BUILD.bazel` to prove the verifier rejects a premature G-code parity target.
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh:357` - `placeholder.sh` is written only into a temp `packages/parity/BUILD.bazel` to prove the scope verifier rejects a premature G-code parity target.

## Auth Gates

None.

## Verification

All required final verification commands passed:

```bash
bazel query //packages/parity-fixtures:prusa_gcode_output_bundle
bazel run //packages/parity-fixtures:verify_prusa_gcode_output_fixture
bazel test //packages/parity-fixtures:verify_prusa_gcode_output_fixture_test
bash packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh
bazel run //packages/prusa-gcode-output-scope:verify
bash packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test
shfmt -d packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
shellcheck packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh
bazel query //packages/parity:all
! bazel query //packages/parity:prusaslicer_gcode_output_parity
! rg -n '^fork\.prusaslicer\.gcode-output\t' packages/parity/status.tsv
! rg -n 'slic3r_flavors::prusa_gcode_output|pub mod prusa_gcode_output|prusa_gcode_output_summary|parse_prusa_gcode_output_summary' packages/slic3r-rust
git diff --check
```

Before each task commit, the Rust pre-commit gate passed:

```bash
rustup run 1.94.1 cargo fmt --manifest-path packages/slic3r-rust/Cargo.toml --all
rustup run 1.94.1 cargo clippy --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features -- -D warnings
rustup run 1.94.1 cargo build --manifest-path packages/slic3r-rust/Cargo.toml --all-targets --all-features
rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features
```

## User Setup Required

None - verification uses checked-in files and local CLI tooling only.

## Next Phase Readiness

Plan 46-03 can update fixture/package docs and run final status-boundary verification. Phase 47 Rust summary parsing and Phase 48 executable parity/status publication remain intentionally unavailable.

## Self-Check: PASSED

- Created summary file found: `.planning/phases/46-prusa-g-code-fixture-surface/46-02-SUMMARY.md`.
- Created verifier files found: `packages/parity-fixtures/verify_prusa_gcode_output_fixture.sh` and `packages/parity-fixtures/verify_prusa_gcode_output_fixture_test.sh`.
- Task commits found in git history: `3f0d33e58`, `43f420745`, `4e9481aed`, `0c56daaee`, and `12575fda0`.
- `summary-extract` reads `requirements_completed: PGFIX-02`.
- Summary frontmatter includes `requirements-completed: [PGFIX-02]`, `lifecycle_mode: yolo`, and `phase_lifecycle_id: 46-2026-06-13T16-58-19`.
- Summary `git diff --check` passed.

---
*Phase: 46-prusa-g-code-fixture-surface*
*Completed: 2026-06-13*
