# Phase 40: Executable Prusa Profile Parity - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-06-02T12:10:38.683Z
**Phase:** 40-executable-prusa-profile-parity
**Mode:** Yolo
**Areas discussed:** Repo-owned parity command, comparison contract,
divergence failure guard, status and documentation publication, scope
guardrails

---

## Repo-Owned Parity Command

| Option | Description | Selected |
|--------|-------------|----------|
| `//packages/parity:prusaslicer_profile_schema_parity` | Publish the maintainer-facing evidence command from the existing parity package. | yes |
| Rust-crate-only test target | Keep evidence hidden in Rust crate tests without a repo-owned parity command. | |
| Fixture-package command | Put the maintainer-facing parity command in `packages/parity-fixtures`. | |

**User's choice:** Auto-selected the parity package command because Phase 40
requires a repo-owned Bazel parity command and status publication belongs to
`packages/parity`.
**Notes:** The command may call helper scripts or Rust code, but the public
target remains `bazel run //packages/parity:prusaslicer_profile_schema_parity`.

---

## Comparison Contract

| Option | Description | Selected |
|--------|-------------|----------|
| Deterministic Rust parser output vs checked-in expected artifact | Compare stable parser summary/provenance fields from `PrusaResearch.ini`. | yes |
| Full Prusa runtime configuration engine | Resolve all profile inheritance and runtime config behavior now. | |
| Upstream Prusa binary comparison | Run upstream PrusaSlicer or imported upstream source as the oracle. | |

**User's choice:** Auto-selected deterministic Rust parser output against
checked-in expectations.
**Notes:** This matches the Phase 39 parser boundary and avoids full runtime,
network, Git, vendor sync, or upstream binary dependencies.

---

## Divergence Failure Guard

| Option | Description | Selected |
|--------|-------------|----------|
| Add a controlled negative test | Prove the command fails when expected data or parsed output diverges. | yes |
| Rely on positive parity command only | Treat a passing command as enough evidence. | |
| Human-only inspection | Let maintainers manually inspect output without an automated failure guard. | |

**User's choice:** Auto-selected a controlled negative test.
**Notes:** The failure guard should not mutate real fixtures and should produce
clear mismatch diagnostics.

---

## Status and Documentation Publication

| Option | Description | Selected |
|--------|-------------|----------|
| Publish one narrow status row after executable evidence passes | Add `fork.prusaslicer.profile-schema` with the Phase 40 command as evidence. | yes |
| Keep status token reserved only | Leave status unchanged even after command exists. | |
| Publish broader Prusa support language | Treat the first command as full Prusa runtime support. | |

**User's choice:** Auto-selected one narrow status row after the command and
failure guard pass.
**Notes:** Docs must explicitly limit the verified claim to profile-schema
evidence.

---

## Scope Guardrails

| Option | Description | Selected |
|--------|-------------|----------|
| Preserve all Phase 37-39 deferrals | Keep full runtime, GUI, generated-output, release, sync, network/cloud, and other fork work out of scope. | yes |
| Add adjacent Prusa runtime capabilities | Use this phase to start broader fork runtime behavior. | |
| Add cross-fork evidence | Include Bambu Studio or OrcaSlicer evidence now. | |

**User's choice:** Auto-selected preserving all existing deferrals.
**Notes:** The phase proves the first executable evidence path only.

## the agent's Discretion

- Exact verifier implementation language and expected artifact format.
- Exact helper target structure, provided the public command remains in
  `packages/parity`.
- Exact docs section placement and wording, provided the narrow verified claim
  is unambiguous.

## Deferred Ideas

None.
