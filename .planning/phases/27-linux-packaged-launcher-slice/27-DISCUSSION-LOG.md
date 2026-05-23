# Phase 27: Linux Packaged Launcher Slice - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-05-23T01:40:54.843Z
**Phase:** 27-Linux Packaged Launcher Slice
**Mode:** Yolo
**Areas discussed:** Packaged artifact shape, startup boundary, smoke coverage, docs boundaries

---

## Packaged Artifact Shape

| Option | Description | Selected |
| --- | --- | --- |
| Scoped package-shaped tree | Materialize a deterministic Linux launcher tree through Bazel, without producing a real distro or AppImage package. | yes |
| AppImage or distro package | Move into installer-grade packaging. | no |
| Runtime-only target | Keep only `linux_slic3r` with no packaging-visible artifact. | no |

**User's choice:** Auto-selected scoped package-shaped tree.
**Notes:** This satisfies Phase 27 without crossing into AppImage, distro package, signing, or release automation scope.

---

## Startup Boundary

| Option | Description | Selected |
| --- | --- | --- |
| Reuse thin Linux startup shim | Copy the existing shell handoff into the package tree and keep behavior in Rust/Bazel-backed code. | yes |
| Add new shell behavior | Implement CLI or config logic in packaging shell code. | no |
| Replace Rust CLI handoff | Introduce a new launcher implementation path. | no |

**User's choice:** Auto-selected reuse thin Linux startup shim.
**Notes:** LPKG-03 requires startup/bootstrap code to stay thin.

---

## Smoke Coverage

| Option | Description | Selected |
| --- | --- | --- |
| Bazel smoke over package layout and startup slice | Add a `sh_test` that builds the package tree and verifies startup behavior through the bundled command. | yes |
| Manual smoke command only | Document local commands without checked-in coverage. | no |
| Shared fixture parity now | Fold Phase 29 evidence into this phase. | no |

**User's choice:** Auto-selected Bazel smoke over package layout and startup slice.
**Notes:** Smoke should prove maintainers do not need ad hoc local setup.

---

## Docs Boundaries

| Option | Description | Selected |
| --- | --- | --- |
| Minimal nearby docs update | Update package-local and Linux slice docs enough to expose the target and keep scope wording accurate. | yes |
| Full packaging docs refresh | Rewrite all packaging visibility docs now. | no |
| No docs | Leave stale Linux packaging-deferred wording in touched surfaces. | no |

**User's choice:** Auto-selected minimal nearby docs update.
**Notes:** Phase 30 still owns broad cross-platform packaging visibility and docs.

## the agent's Discretion

- Exact tree layout and file names may be chosen to fit existing Bazel and shell patterns.

## Deferred Ideas

- AppImage, distro package, installer, signing, notarization, release-channel automation, shared packaged parity evidence, and final cross-platform visibility docs.
