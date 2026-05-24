# Phase 31: Cross-Platform Release Build Workflow - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in CONTEXT.md; this log preserves the
> alternatives considered.

**Date:** 2026-05-24T13:42:03Z
**Phase:** 31-Cross-Platform Release Build Workflow
**Mode:** Yolo
**Areas discussed:** Artifact Shape, Evidence Reuse, GitHub Actions Boundary,
Documentation Scope

---

## Artifact Shape

| Option | Description | Selected |
| --- | --- | --- |
| Uploaded package tree with provenance | Upload the scoped package tree/archive plus manifest/provenance from GitHub Actions. | yes |
| Installer-grade packages | Build AppImage/MSI/DMG or signed artifacts. | |
| GitHub Release publication | Automatically publish release assets to a GitHub Release. | |

**User's choice:** Yolo selected uploaded package artifacts with provenance.
**Notes:** This satisfies v1.8 without crossing into signing, installers, or
release-channel publishing.

## Evidence Reuse

| Option | Description | Selected |
| --- | --- | --- |
| Run existing packaged launcher parity before upload | Reuse the already verified macOS/Linux/Windows packaged launcher evidence labels. | yes |
| Add a release-only smoke path | Create separate release smoke checks for the workflow. | |
| Upload without evidence | Build artifacts without parity gating. | |

**User's choice:** Yolo selected existing parity evidence reuse.
**Notes:** Release build automation should not invent a parallel verification
story.

## GitHub Actions Boundary

| Option | Description | Selected |
| --- | --- | --- |
| Matrix workflow over hosted macOS/Linux/Windows runners | Use one matrix and a repo-owned Bash script for artifact logic. | yes |
| Separate workflow per platform | More files and duplicated YAML. | |
| Local-only release script | Useful but does not meet the GitHub Actions requirement. | |

**User's choice:** Yolo selected a matrix workflow with minimal external
actions.

## Documentation Scope

| Option | Description | Selected |
| --- | --- | --- |
| Add focused release-build automation doc | Document commands, artifact contents, provenance, and exclusions. | yes |
| Update only workflow YAML comments | Too hidden for maintainers. | |
| Rewrite broad migration docs | Larger than the phase needs. | |

**User's choice:** Yolo selected a focused doc plus nearby index/package docs.

## Deferred Ideas

- GitHub Release publishing.
- Signing, notarization, and release channels.
- AppImage, MSI, DMG, distro packages, and native installers.
- GUI packaging.
- Fork-flavor build matrix.
