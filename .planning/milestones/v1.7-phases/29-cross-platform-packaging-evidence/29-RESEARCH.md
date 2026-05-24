# Phase 29: Cross-Platform Packaging Evidence - Research

**Researched:** 2026-05-23
**Domain:** Bazel/Bash packaged launcher parity evidence
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

- Prove Linux and Windows packaged launcher behavior through shared checked-in
  evidence.
- Execute the packaged startup commands themselves rather than raw runtime
  targets.
- Reuse existing help/version/config/export/transform fixtures where possible.
- Add only the missing package-specific fixtures: expected file lists, expected
  scope notes, and fixture READMEs.
- Keep status publication, broad docs visibility, release packaging, signing,
  installers, GUI packaging, and release-channel automation out of this phase.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
| --- | --- | --- |
| PKGE-01 | Maintainer can execute shared Linux packaged launcher parity evidence that proves artifact layout, startup handoff, help/version, and representative config behavior. | Add `//packages/parity:linux_packaged_launcher_parity` backed by the Phase 27 Linux package builder and checked-in Linux package layout/scope fixtures. |
| PKGE-02 | Maintainer can execute shared Windows packaged launcher parity evidence that proves artifact layout, startup handoff, help/version, and representative config behavior. | Add `//packages/parity:windows_packaged_launcher_parity` backed by the Phase 28 Windows package builder and checked-in Windows package layout/scope fixtures. |
| PKGE-03 | The shared packaged evidence is reviewable through checked-in fixtures and commands rather than manual spot checks. | Add fixture filegroups under `packages/parity-fixtures` and exact fixture comparison in the parity script. |
</phase_requirements>

## Summary

The existing code already has platform package builders and smoke tests under
`packages/launcher`. Phase 29 should not duplicate those smoke tests. It should
lift the evidence into `packages/parity` by comparing generated package trees
against checked-in fixtures, the same way existing runtime parity commands
compare behavior output and `macos_packaged_launcher_parity` compares packaged
layout/config behavior.

The simplest robust shape is one shared Bash comparator that accepts a platform
mode and the platform builder inputs. It should:

- build the scoped package tree under a temporary root
- compare the package file list against a checked-in fixture
- compare `share/slic3r/packaged-slice.txt` against a checked-in fixture
- execute the packaged startup command for `--version`, `--help`, `--save`,
  `--datadir --load`, `--export-gcode`, `--info`, `--repair`, and `--split`
- compare behavior outputs to the existing shared parity fixtures

This keeps Phase 29 evidence inspectable without moving into Phase 30 status
publication.

## Standard Stack

| Tool | Purpose | Existing Pattern |
| --- | --- | --- |
| Bazel `sh_binary` | Expose maintainer-runnable parity labels. | `packages/parity/BUILD.bazel` runtime and macOS packaged commands. |
| Bash | Build temp trees and compare fixtures. | `compare_linux_runtime.sh`, `compare_windows_runtime.sh`, `compare_macos_packaged_launcher.sh`. |
| `packages/parity-fixtures` | Store reviewable expected outputs. | Existing CLI, runtime, transform, export, and macOS package fixtures. |

## Implementation Notes

- The Linux generated file list should be:
  `./bin/slic3r`, `./bin/slic3r_cli`,
  `./share/slic3r/packaged-slice.txt`.
- The Windows generated file list should be:
  `./Slic3r-console.exe`, `./share/slic3r/packaged-slice.txt`.
- The checked-in expected notes should match the platform package
  `packaged_slice.txt` files exactly.
- `packages/parity/README.md` can mention the new labels for command
  discoverability, but `packages/parity/status.tsv` should remain unchanged
  until Phase 30.

## Verification Recommendations

- `bash -n packages/parity/compare_packaged_launcher.sh`
- `shfmt -d packages/parity/compare_packaged_launcher.sh`
- `bazel run //packages/parity:linux_packaged_launcher_parity`
- `bazel run //packages/parity:windows_packaged_launcher_parity`
- `bazel run //packages/parity:macos_packaged_launcher_parity`
- `bazel run //packages/parity:linux_runtime_parity`
- `bazel run //packages/parity:windows_runtime_parity`
- `git diff --check`
