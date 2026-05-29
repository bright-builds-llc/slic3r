# Phase 36: Parity, Fixture, Launcher, and Deferral Templates - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-05-27T13:38:25.226Z
**Phase:** 36 - Parity, Fixture, Launcher, and Deferral Templates
**Mode:** Yolo
**Areas discussed:** Fork parity checklist template shape and location, fork
fixture namespace and parity-status vocabulary, v1.9 deferral language and
documentation placement, manual drift-refresh protocol

---

## Fork Parity Checklist Template Shape and Location

| Option | Description | Selected |
|--------|-------------|----------|
| Dedicated Phase 36 package | Create `packages/fork-templates` with Markdown templates and a Bazel verifier. | yes |
| Inventory-adjacent TSV | Add a checklist TSV under `packages/fork-inventories` and extend inventory verification. | |
| Docs-only template | Add a standalone `docs/port/fork-parity-checklist.md`. | |
| Existing parity package | Place the template beside current parity status/evidence files. | |

**User's choice:** Auto-selected dedicated Phase 36 package.
**Notes:** This keeps template ownership separate from source inventories and
current executable parity evidence while preserving repo-native verification.

---

## Fork Fixture Namespace and Parity-Status Vocabulary

| Option | Description | Selected |
|--------|-------------|----------|
| Existing parity package, inventory-id fork namespace | Reserve future fork fixtures under `packages/parity-fixtures/forks/<vendor_id>/<inventory_id-or-slug>/<scenario>/`; keep status rows evidence-only. | yes |
| Existing parity package, category/shared namespace | Group future fixtures by shared downstream categories instead of inventory IDs. | |
| Separate fork parity package/status file | Create a separate fork-specific parity visibility surface. | |
| Reserved status rows now | Add fork rows to current `packages/parity/status.tsv` before executable evidence exists. | |

**User's choice:** Auto-selected existing parity fixture namespace with
inventory-traceable future status tokens.
**Notes:** This reserves vocabulary without implying source pins or inventories
are verified behavior.

---

## v1.9 Deferral Language and Documentation Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Central README deferral block | Add a central v1.9 deferral block to `docs/port/README.md` and link to it from template/process docs. | yes |
| Migration guidance only | Put the full deferral language in `docs/port/migration-guidance.md`. | |
| Templates only | Keep deferrals primarily in the Phase 36 checklist/template docs. | |
| Mirror everywhere | Repeat the full deferral list across README, migration guidance, package map, and contract inventory. | |

**User's choice:** Auto-selected central deferral block with cross-links.
**Notes:** This creates one auditable source of truth while avoiding duplicated
scope language that can drift.

---

## Manual Drift-Refresh Protocol

| Option | Description | Selected |
|--------|-------------|----------|
| Docs-only pre-milestone runbook | Follow a manual protocol using existing vendor verification and reviewer decision capture. | yes |
| Manual drift report target | Add a new command that emits a drift report without updating refs. | |
| Checked-in worksheet template | Add a worksheet template for pre-milestone drift review evidence. | |
| Temp clone/fetch comparison protocol | Use temporary upstream clones for deeper source inspection. | |

**User's choice:** Auto-selected docs-only pre-milestone runbook, with a manual
report target allowed only if planning finds it necessary.
**Notes:** This fits the v1.9 no-vendoring/no-automation boundary while meeting
the "run or follow" PAR-04 wording.

---

## the agent's Discretion

- Exact template package file names.
- Verifier implementation language and exact Bazel target shape.
- Example wording inside templates and runbooks.

## Deferred Ideas

- Full fork parity ports and executable fork behavior.
- GUI migration, fork release engineering, nightly sync, online/cloud or
  credentialed integrations, profile auto-update execution, and non-free plugin
  ingestion.
