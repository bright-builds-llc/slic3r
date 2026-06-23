---
generated_by: gsd-phase-researcher
phase: 57
phase_name: Arc-Fitting Scope Contract
generated_at: 2026-06-23T18:55:00.000Z
status: complete
---

# Phase 57 Research: Arc-Fitting Scope Contract

## Research Question

What does planning need to know to implement Phase 57 well?

Phase 57 is a scope-and-verifier phase. It must create a reviewed,
fail-closed `prusaslicer.arc-fitting` scope contract and prove the contract
protects the rest of the v1.15 evidence chain before any fixture corpus, Rust
boundary, public parity command, status publication, or public docs claim is
created.

## Source Inputs

- `.planning/phases/57-arc-fitting-scope-contract/57-CONTEXT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `.planning/STATE.md`
- `.planning/PROJECT.md`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/fork-inventories/category-map.tsv`
- `packages/prusa-gcode-output-scope/gcode-output-scope.md`
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope.sh`
- `packages/prusa-gcode-output-scope/verify_prusa_gcode_output_scope_test.sh`
- `packages/prusa-gcode-output-scope/BUILD.bazel`
- `packages/parity/status.tsv`

## Key Findings

### Inventory and Category Inputs Already Exist

`packages/fork-inventories/prusaslicer.tsv` already contains the accepted
`prusaslicer.arc-fitting` planning row:

- source identity:
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`
- source path: `src/libslic3r/Geometry/ArcWelder.cpp`
- feature surface/category: `arc-fitting`
- ownership: `shared-downstream`
- complexity: `medium`
- parity dependency: `generated-outputs`
- decision: `future-candidate`

`packages/fork-inventories/category-map.tsv` already contains `arc.shared`,
which references `prusaslicer.arc-fitting` and `bambustudio.arc-fitting`.
Phase 57 should verify the Prusa row and exactly one category-map reference,
but it should not make Bambu or non-Prusa behavior executable.

### Existing Scope Package Is a Strong Template

`packages/prusa-gcode-output-scope` is the best package pattern to reuse. It
contains:

- a package-local Markdown scope record
- a `README.md` that names the boundary and command
- a Bash verifier with exact row/text checks
- a mutation `sh_test` that copies valid fixtures into temp directories and
  breaks one invariant per test
- a `BUILD.bazel` with `sh_binary(name = "verify")`, a `sh_test`, and a
  `package_boundary` filegroup

The G-code package should remain unchanged except where future docs explicitly
cross-reference the new arc-fitting package. Phase 57's context recommends a
new `packages/prusa-arc-fitting-scope` package so the existing
`fork.prusaslicer.gcode-output` meaning is not widened.

### Verifier Patterns to Reuse

The existing verifier patterns are directly applicable:

- `require_file` for all required inputs
- `require_text` for mandatory README/scope wording
- `reject_text` and overclaim regexes for forbidden claims
- `require_section_table_row` and `require_section_table_exact_row` for
  scope and traceability tables
- row-count checks for the closed allowed-field table
- exact TSV row checks for inventory/status expectations
- first-field duplicate checks for status rows and inventory IDs
- category-map reference count checks

For Phase 57, planning should require verifier functions that prove:

- the scope record has all required high-level fields
- the arc field table contains exactly the approved fields
- the accepted `prusaslicer.arc-fitting` inventory row exists exactly once
- the `arc.shared` category-map row references `prusaslicer.arc-fitting`
  exactly once
- `generated-outputs` remains exactly `in progress`
- `fork.prusaslicer.gcode-output` remains exactly the current semantic row
- `fork.prusaslicer.arc-fitting` is not published as verified during Phase 57
- planned arc status wording is present only as planned text and remains
  narrow
- deferred-scope wording includes broad generated-output, byte parity,
  ArcWelder algorithm/tolerance/geometry equivalence, printability, runtime,
  GUI, support, seam, release, upstream import, sync, device/network, and
  non-Prusa fork deferrals

### Mutation Tests Should Be Focused

The existing `verify_prusa_gcode_output_scope_test.sh` pattern uses a
`write_valid_fixture` helper and small mutation helpers such as line removal,
text replacement, and inserted unsupported rows. Phase 57 should use the same
style.

Recommended mutation cases:

- valid fixture passes
- missing required scope row fails
- missing approved arc field fails
- unsupported arc field fails
- duplicate arc field row fails
- inventory row drift fails
- duplicate `prusaslicer.arc-fitting` inventory row fails
- missing or duplicate `arc.shared` category-map reference fails
- generated-outputs status promotion fails
- existing `fork.prusaslicer.gcode-output` wording drift fails
- premature `fork.prusaslicer.arc-fitting` verified status publication fails
- missing deferred-scope term fails
- runtime, printability, byte-parity, broad generated-output, or algorithm
  equivalence overclaim fails

### Status Preservation Is the Highest-Risk Surface

`packages/parity/status.tsv` currently has:

- `generated-outputs` with status `in progress`
- `fork.prusaslicer.gcode-output` with status `verified` and notes limited to
  the Phase 53-56 semantic G-code evidence slice

Phase 57 should not add `fork.prusaslicer.arc-fitting` as a verified row. It
may include planned status wording inside the new scope record. The verifier
should fail if broad `generated-outputs` is promoted or if the existing G-code
output row is edited to imply arc-fitting evidence is already covered.

### Recommended Verification Commands for the Plan

The final Phase 57 plan should include these commands, adjusted if final file
names differ:

- `bash packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope.sh`
- `bash packages/prusa-arc-fitting-scope/verify_prusa_arc_fitting_scope_test.sh`
- `bazel run //packages/prusa-arc-fitting-scope:verify`
- `bazel test //packages/prusa-arc-fitting-scope:verify_prusa_arc_fitting_scope_test`
- `bazel run //packages/fork-inventories:verify`
- `git diff --check -- packages/prusa-arc-fitting-scope .planning/phases/57-arc-fitting-scope-contract`

If documentation outside the scope package is touched, include the exact
package or docs verification already used by the touched surface.

## Planning Guidance

Recommended plan decomposition:

1. Create the arc-fitting scope package and human-readable contract.
2. Implement the fail-closed verifier for the contract, inventory/category
   traceability, status preservation, and forbidden claims.
3. Add mutation tests and Bazel wiring, then run the verifier/test matrix.

This keeps ARCSCOPE-01, ARCSCOPE-02, and ARCSCOPE-03 independently checkable
while avoiding a large single plan that mixes contract writing, verifier
implementation, and final validation.

## Risks and Mitigations

- **Risk:** accidentally widening `fork.prusaslicer.gcode-output`.
  **Mitigation:** exact-status-row check for the current semantic G-code row.
- **Risk:** broad `generated-outputs` promotion.
  **Mitigation:** exact first-field/status check requiring one in-progress row.
- **Risk:** arc field creep into algorithm equivalence or printability.
  **Mitigation:** closed field table plus overclaim rejection tests.
- **Risk:** fixture/Rust/public evidence created too early.
  **Mitigation:** Phase 57 verifier rejects premature verified status and the
  contract describes planned artifacts as planned text only.
- **Risk:** loose Markdown checks allow duplicate or missing field rows.
  **Mitigation:** exact body row-count checks and duplicate field checks.

## Research Complete

## RESEARCH COMPLETE
