# Phase 29: Cross-Platform Packaging Evidence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-23T11:45:16.382Z
**Phase:** 29-cross-platform-packaging-evidence
**Mode:** Yolo
**Areas discussed:** Shared evidence shape, Platform coverage, Fixture coverage, Scope boundaries

---

## Shared Evidence Shape

| Option | Description | Selected |
|--------|-------------|----------|
| Add platform-specific parity commands | Mirror existing Linux/Windows runtime parity labels with packaged launcher commands. | yes |
| Add only smoke tests | Rely on existing package smoke targets without checked-in parity fixtures. | |
| Fold into status update | Update parity status and docs in the same phase. | |

**User's choice:** Auto-selected platform-specific parity commands.
**Notes:** This best matches PKGE-03 because maintainers can inspect checked-in fixtures and run explicit commands.

---

## Platform Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Execute packaged startup commands | Build temp package trees and run the packaged commands themselves. | yes |
| Execute raw runtime targets | Reuse runtime parity commands without proving packaged startup handoff. | |
| Compare generated files only | Verify layout and notes but skip behavior execution. | |

**User's choice:** Auto-selected packaged startup execution.
**Notes:** This keeps the evidence tied to the actual Linux and Windows package trees from Phases 27 and 28.

---

## Fixture Coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse shared behavior fixtures plus packaged layout fixtures | Avoid duplicate help/version/config/export/transform expected outputs and add only missing package fixtures. | yes |
| Duplicate every platform expected output | Create complete Linux and Windows packaged fixture sets. | |
| Use loose smoke assertions | Check substrings and file existence without exact fixture comparison. | |

**User's choice:** Auto-selected reuse of shared behavior fixtures plus package-specific layout fixtures.
**Notes:** This keeps the evidence small, reviewable, and aligned with existing parity command patterns.

---

## Scope Boundaries

| Option | Description | Selected |
|--------|-------------|----------|
| Evidence only | Add commands and fixtures without publishing final status or broad docs updates. | yes |
| Evidence plus status | Mark packaging-visible parity status verified now. | |
| Evidence plus release packaging | Extend package trees toward release artifacts. | |

**User's choice:** Auto-selected evidence only.
**Notes:** Phase 30 owns visibility and status publication; release-grade packaging remains outside v1.7 scope.

---

## the agent's Discretion

- Choose the smallest script structure that keeps Linux and Windows packaged parity reviewable.
- Add narrow package/fixture discoverability only where needed for maintainers to run the evidence.

## Deferred Ideas

- Parity status publication and broad docs updates remain Phase 30.
- Installer, signing, GUI packaging, AppImage/MSI/DMG, and release-channel automation remain future work.
