# Phase 2: Legacy Oracle - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Make the retained legacy package buildable and testable through Bazel on macOS while keeping it clearly reference-only. This phase is about preserving the legacy implementation as a trustworthy oracle under the new monorepo and Bazel surface, not about modernizing legacy internals, broadening platform scope, or reopening legacy feature development.

</domain>

<decisions>
## Implementation Decisions

### Legacy build scope

- Phase 2 should prioritize the legacy CLI and native oracle build path on macOS, not the legacy GUI build.
- Release packaging outputs such as `.dmg`, installers, and archive production are out of scope for this phase.
- If a legacy build path still depends on existing scripts or manual bootstrap behavior, Bazel may invoke that path and document the caveats rather than replacing it with a clean Bazel-native implementation now.
- Success for this phase is producing the retained legacy executable or artifacts needed for reference use on macOS, not matching the historical packaging layout exactly.

### Legacy test scope

- Phase 2 should elevate the most reliable and meaningful legacy macOS test and smoke surfaces as the first-class oracle set, even if some older paths are deferred.
- A lightweight oracle smoke test is acceptable in this phase if deeper legacy suites are not yet Bazel-friendly, as long as the gap is documented explicitly.
- When Perl-era tests and native tests differ in usefulness or reliability, the planner should prioritize the tests that best preserve the behavioral oracle on macOS rather than preserving historical symmetry.
- Phase 2 should explicitly document which legacy tests are part of the trusted oracle set versus which are retained only for historical or reference reasons.

### Bootstrap and dependency policy

- Phase 2 should prefer documented wrapper fidelity over trying to eliminate every awkward legacy bootstrap step immediately.
- Non-hermetic or host-specific legacy dependencies are acceptable in this phase if they are treated as explicit debt and recorded clearly.
- If a legacy dependency path is too brittle to automate cleanly in Phase 2, the acceptable outcome is a Bazel target plus documented manual prerequisites, not a hidden dependency-modernization project.
- Phase 2 should produce a clear record of what the legacy oracle path assumes is already present on macOS.

### Reference-package guardrails

- The legacy package remains reference-only; build and test enablement does not reopen it as a normal feature-development surface.
- If Bazel wrapping requires small legacy edits, they must remain minimal, parity-preserving integration changes only.
- Phase 2 docs should state that Bazel support for the legacy package exists to preserve the oracle, not because the long-term target is continued investment in the legacy implementation.
- If contributors find tempting legacy cleanup opportunities, those should be captured as deferred notes rather than folded into this phase.

### Claude's Discretion

- Exact names and grouping of Bazel targets that expose the legacy build and test surfaces
- Which specific legacy test and smoke commands form the first trusted oracle set, as long as the selection is documented and justified
- Exact wording and structure for the oracle caveat documentation and prerequisite notes

</decisions>

<specifics>
## Specific Ideas

- The “oracle” framing matters more than historical completeness in this phase: the planner should optimize for a reliable macOS legacy reference path, not perfect coverage of every old script.
- Bazel may act as an honest wrapper around the legacy reality, including manual prerequisites and caveats, as long as those assumptions are surfaced clearly.
- The planner should leave clear documentation that distinguishes trusted oracle checks from merely retained legacy checks.
- The planner should continue using the visible `packages/legacy-slic3r` package boundary as the main way to communicate that the legacy code is preserved but not preferred.

</specifics>

<deferred>
## Deferred Ideas

- Legacy GUI build support — future phase
- Legacy release packaging outputs under Bazel — future phase
- Legacy dependency cleanup or full hermetic bootstrap redesign — future phase
- Linux and Windows legacy-oracle support under Bazel — future phase

</deferred>

---

*Phase: 02-legacy-oracle*
*Context gathered: 2026-04-07*
