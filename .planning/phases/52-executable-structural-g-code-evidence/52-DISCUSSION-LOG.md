# Phase 52: Executable Structural G-code Evidence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-06-18T01:11:16.536Z
**Phase:** 52 - Executable Structural G-code Evidence
**Mode:** Yolo
**Areas discussed:** Public structural parity command, Structural mutation
guard, Status and documentation publication, Lifecycle and verification

---

## Public Structural Parity Command

| Option | Description | Selected |
|--------|-------------|----------|
| Extend the existing public command | Keep `//packages/parity:prusaslicer_gcode_output_parity` as the maintainer-facing entry point and add structural validation to the existing evidence path. | yes |
| Add a separate structural target only | Add a new target beside the summary-only command and leave existing status evidence unchanged. | |
| Replace lower-level fixture verification | Treat fixture verifier success as the public evidence instead of validating through Rust from the parity command. | |

**Yolo choice:** Extend the existing public command unless planning finds a
lower-risk adjacent target that still preserves the status token contract.
**Notes:** This keeps the public evidence path stable for maintainers while
making the already-verified narrow slice structurally meaningful.

---

## Structural Mutation Guard

| Option | Description | Selected |
|--------|-------------|----------|
| Add one command-level structural drift case | Mutate a meaningful structural value and assert public comparator failure with structural diagnostics. | yes |
| Duplicate the complete fixture/parser rejection matrix | Recreate every Phase 50 and Phase 51 negative case in `packages/parity`. | |
| Skip command-level structural mutation | Rely on lower-level fixture and Rust tests only. | |

**Yolo choice:** Add one focused structural-summary drift case to the public
parity failure test.
**Notes:** Lower layers already own schema, row, duplicate, order, unsupported
field, and unsupported claim rejection. Phase 52 needs proof that the public
command itself fails closed on structural drift.

---

## Status and Documentation Publication

| Option | Description | Selected |
|--------|-------------|----------|
| Narrow structural wording | Update the Prusa G-code row/docs from summary-only to narrow structural evidence while keeping broad generated outputs in progress. | yes |
| Broad generated-output promotion | Mark `generated-outputs` verified because the structural path now exists. | |
| Minimal status change only | Change `status.tsv` but leave package and port docs summary-only. | |

**Yolo choice:** Publish narrow structural wording in status and docs while
keeping broad `generated-outputs` in progress and deferrals explicit.
**Notes:** This aligns with GCEV-03 and preserves the milestone's
no-overclaiming boundary.

---

## Lifecycle and Verification

| Option | Description | Selected |
|--------|-------------|----------|
| Run targeted Bazel plus Rust workspace checks | Verify the public command, mutation test, Rust flavor tests, and touched lower-level verifiers. | yes |
| Run only the public Bazel command | Fast but misses Rust/parser and mutation coverage. | |
| Run all legacy suites | Broader than the changed surface and likely disproportionate for this phase. | |

**Yolo choice:** Run targeted Bazel checks plus the Rust pre-commit sequence if
Rust files change.
**Notes:** The phase likely touches Bash, Bazel, Rust, TSV status, and docs, so
verification must cover each changed surface.

## the agent's Discretion

- Exact Rust CLI integration shape: extend the current summary binary, add a
  structural mode, add a second binary, or choose another local pattern that
  keeps validation Rust-owned and diagnostics clear.
- Exact Bash helper names and structural diagnostics in the public comparator.
- Minimal doc wording and touched file set.

## Deferred Ideas

- Byte-for-byte G-code parity, geometry/toolpath parity, printability,
  printer-runtime behavior, support generation, wall seam behavior, arc
  fitting, STEP import, full 3MF import/export, GUI behavior, binary G-code,
  thumbnails, post-processing, host upload, network/device integration,
  profile auto-update execution, fork release builds, Bambu Studio,
  OrcaSlicer, upstream source imports, release behavior, and sync automation
  remain future work.
