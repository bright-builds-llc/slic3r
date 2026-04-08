# Phase 3: Rust Workspace - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning
**Mode:** Auto-generated (infrastructure phase, yolo autonomous flow)

<domain>
## Phase Boundary

Stand up the Rust workspace, toolchain, and verification path under Bazel with Bright Builds-aligned structure and practices. This phase establishes the new Rust package as a real buildable and checkable workspace on macOS; it does not add user-facing parity features yet.

</domain>

<decisions>
## Implementation Decisions

### the agent's Discretion

All implementation choices are at the agent's discretion within the locked roadmap and project constraints. Use the Phase 3 goal, success criteria, existing package scaffold, Bright Builds requirements, and Bazel-first repo structure as the governing spec.

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets

- The Bazel root is already in place with [BUILD.bazel](/Users/peterryszkiewicz/Repos/Slic3r/BUILD.bazel), [MODULE.bazel](/Users/peterryszkiewicz/Repos/Slic3r/MODULE.bazel), [`.bazelversion`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelversion), and [`.bazelrc`](/Users/peterryszkiewicz/Repos/Slic3r/.bazelrc).
- The package skeleton already exists under [packages/](/Users/peterryszkiewicz/Repos/Slic3r/packages), including [packages/slic3r-rust](/Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust).
- The migration control-plane docs already exist under [docs/port](/Users/peterryszkiewicz/Repos/Slic3r/docs/port).

### Established Patterns

- Bazel is the top-level build and test entrypoint for the repo.
- The monorepo keeps shared orchestration at the root and domain-specific ownership inside `packages/`.
- The legacy package is preserved as a visible reference oracle and should not be treated as the preferred implementation surface.

### Integration Points

- [packages/BUILD.bazel](/Users/peterryszkiewicz/Repos/Slic3r/packages/BUILD.bazel) is the package-level alias surface that the Rust workspace should plug into.
- [packages/slic3r-rust/Cargo.toml](/Users/peterryszkiewicz/Repos/Slic3r/packages/slic3r-rust/Cargo.toml) is the current Rust workspace root scaffold.
- [docs/port/checklist.md](/Users/peterryszkiewicz/Repos/Slic3r/docs/port/checklist.md) and [docs/port/package-map.md](/Users/peterryszkiewicz/Repos/Slic3r/docs/port/package-map.md) should be updated as the Rust workspace becomes real.

</code_context>

<specifics>
## Specific Ideas

No specific requirements beyond the roadmap and project constraints — infrastructure phase.

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>
