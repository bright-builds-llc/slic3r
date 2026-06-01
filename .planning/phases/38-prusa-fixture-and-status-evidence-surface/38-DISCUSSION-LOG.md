# Phase 38: Prusa Fixture and Status Evidence Surface - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md - this log preserves the
> alternatives considered.

**Date:** 2026-06-01T00:40:01.598Z
**Phase:** 38-Prusa Fixture and Status Evidence Surface
**Mode:** Yolo
**Areas discussed:** Fixture namespace and file shape, Fixture provenance and
update rules, Status vocabulary and non-overclaiming, Scope boundaries

---

## Fixture Namespace and File Shape

| Option | Description | Selected |
| --- | --- | --- |
| Full pinned vendor-bundle fixture plus manifest | Check in exact `PrusaResearch.ini` and matching `PrusaResearch.idx` from the accepted Prusa source pin, with a fixture-local manifest and no parity command. | yes |
| Curated exact section excerpts | Check in smaller source excerpts for representative parser cases with a source map. | |
| Derived key/value expectation fixture | Define parser-friendly normalized expectations before Rust parsing exists. | |

**User's choice:** Yolo selected full pinned vendor-bundle fixture plus manifest.
**Notes:** This best satisfies EVID-02 and keeps Phase 39 parser work grounded in
real Prusa source shape while avoiding derived parser contracts in Phase 38.

---

## Fixture Provenance and Update Rules

| Option | Description | Selected |
| --- | --- | --- |
| Fixture-local provenance manifest plus verifier | Store source pin, source path, fixture status, update route, hash/checkable fields, and exclusion boundaries beside the fixtures. | yes |
| Minimal derived fixture subset plus source-pin manifest | Keep only selected profile/config examples and justify extraction choices. | |
| Central README/runbook only | Document update rules centrally without per-fixture provenance. | |
| Networked regeneration script as authority | Add a script that fetches the pinned upstream fixture as the authoritative refresh path. | |

**User's choice:** Yolo selected fixture-local provenance manifest plus verifier.
**Notes:** Verification should be static and fail closed. It can check files,
manifest fields, source pins, boundary wording, and forbidden fork/network/plugin
fixtures, but it should not fetch upstream source or run profile update logic.

---

## Status Vocabulary and Non-Overclaiming

| Option | Description | Selected |
| --- | --- | --- |
| Add an unverified/deferred Prusa row in `status.tsv` now | Make the future Prusa row visible in the status command before executable evidence exists. | |
| Update status vocabulary/docs only | Reserve the future token in docs while keeping `status.tsv` limited to executable evidence rows. | yes |
| Wait entirely until Phase 40 | Make no status vocabulary change in Phase 38. | |

**User's choice:** Yolo selected status vocabulary/docs only.
**Notes:** The future token should be `fork.prusaslicer.profile-schema`.
`packages/parity/status.tsv` must not gain a Prusa row until Phase 40 creates a
rerunnable executable parity command.

---

## Scope Boundaries

| Option | Description | Selected |
| --- | --- | --- |
| Explicit non-overclaiming guardrails in fixture docs and verifier | State that fixtures do not prove runtime support or executable parity and reject Bambu/Orca/network/cloud/credential/non-free plugin fixture scope. | yes |
| Rely on existing Phase 37 and docs wording only | Avoid adding new boundary text in Phase 38 files. | |
| Broaden fixture scope for future fork work | Add other fork or network/plugin examples now. | |

**User's choice:** Yolo selected explicit non-overclaiming guardrails in fixture
docs and verifier.
**Notes:** Phase 38 stays fixture/status-surface only. Rust parsing is Phase 39;
executable parity and verified status publication are Phase 40.

---

## the agent's Discretion

- Exact fixture scenario directory names under
  `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/`.
- Exact manifest filename and grep-verifiable format.
- Exact verifier organization, provided it is rerunnable through Bazel and
  follows existing shell patterns.
- Exact docs placement for reserved status vocabulary, provided `status.tsv`
  remains unchanged for Prusa in Phase 38.

## Deferred Ideas

- Rust profile/config parser and normalization logic - Phase 39.
- Executable Prusa profile/config parity command and verified status row -
  Phase 40.
- Broader Prusa runtime, project files, STEP import, support generation, arc
  fitting, wall seam, network/device integration, profile auto-update execution,
  GUI support, fork release builds, Bambu Studio, OrcaSlicer, upstream source
  imports, and vendor sync automation - future phases only.
