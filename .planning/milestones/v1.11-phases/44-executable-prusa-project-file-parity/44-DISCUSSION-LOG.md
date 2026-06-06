# Phase 44: Executable Prusa Project-File Parity - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-06-05T23:05:16.426Z
**Phase:** 44-Executable Prusa Project-File Parity
**Mode:** Yolo
**Areas discussed:** Parity Command Surface, Expected Evidence Comparison,
Failure Guard, Status and Docs Publication, Verification Shape

---

## Parity Command Surface

| Option | Description | Selected |
| --- | --- | --- |
| Mirror profile-schema comparator | Add `//packages/parity:prusaslicer_project_file_parity` using the existing Prusa profile-schema shell comparator and Bazel target shape. | yes |
| Create a new framework | Build a more general parity framework before project-file evidence. | |
| Agent discretion | Let planning choose the narrowest command structure that still satisfies PPEV-01. | |

**User's choice:** Auto-selected recommended default: mirror the profile-schema
comparator pattern.
**Notes:** This keeps Phase 44 narrow and consistent with the v1.10 Prusa
profile-schema evidence path.

---

## Expected Evidence Comparison

| Option | Description | Selected |
| --- | --- | --- |
| Compare Rust summary to checked-in expected TSV | Use the Phase 43 Rust summary boundary and Phase 42 `expected-project-summary.tsv` as the evidence surface. | yes |
| Parse the 3MF archive in parity shell code | Inspect archive internals directly from the comparator. | |
| Broaden to load/save parity | Treat project-file evidence as full GUI or runtime project behavior. | |

**User's choice:** Auto-selected recommended default: compare Rust-backed
summary output to the checked-in expected TSV.
**Notes:** This preserves Phase 42/43 scope and avoids overclaiming full 3MF or
PrusaSlicer runtime behavior.

---

## Failure Guard

| Option | Description | Selected |
| --- | --- | --- |
| Mutate a temporary expected artifact | Add a `sh_test` that mutates a temp copy and proves the comparator fails with useful stderr. | yes |
| Mutate checked-in fixture files | Edit real fixture files during tests. | |
| Rely on happy-path command only | Skip negative testing. | |

**User's choice:** Auto-selected recommended default: mutate a temporary
expected artifact.
**Notes:** This directly satisfies PPEV-02 without risking checked-in fixture
bytes.

---

## Status and Docs Publication

| Option | Description | Selected |
| --- | --- | --- |
| Publish one narrow verified status row | Add `fork.prusaslicer.project-file` only after the command exists and passes, with docs naming the exact slice. | yes |
| Keep row unavailable after command exists | Leave status stale despite runnable evidence. | |
| Publish broad PrusaSlicer support | Claim runtime, GUI, generated-output, or broader project behavior. | |

**User's choice:** Auto-selected recommended default: publish one narrow
verified status row.
**Notes:** Docs must keep all adjacent Prusa surfaces deferred.

---

## Verification Shape

| Option | Description | Selected |
| --- | --- | --- |
| Run command, failure guard, Rust/Bazel checks, and docs/status checks | Verify all three PPEV requirements with executable and textual proof. | yes |
| Run only the new command | Proves happy path but misses divergence and docs/status evidence. | |
| Defer verification to CI only | Avoids local proof before completion. | |

**User's choice:** Auto-selected recommended default: verify command, failure
guard, Rust/Bazel wiring, and docs/status wording.
**Notes:** The phase should not pass unless maintainers can rerun the evidence
and inspect exact non-overclaiming publication.

---

## the agent's Discretion

- Exact shell helper names and row-label extraction logic.
- Whether a small Rust summary CLI is required or an existing binary route can
  be reused cleanly.
- Minimum docs edits needed to publish the narrow evidence slice.

## Deferred Ideas

None - yolo discussion stayed within Phase 44 scope.
