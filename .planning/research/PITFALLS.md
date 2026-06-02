# v1.11 Pitfall Research: PrusaSlicer Broader Parity Port

**Project:** Slic3r Rust Port
**Milestone:** v1.11 PrusaSlicer Broader Parity Port
**Researched:** 2026-06-02

## Pitfalls And Mitigations

### Overclaiming Project-File Parity

Risk: A narrow project-file fixture summary could be mistaken for full
PrusaSlicer project load/save, GUI project behavior, or 3MF runtime parity.

Mitigation: Requirements and docs must name the exact evidence slice and keep
full runtime, GUI, generated-output, and release support deferred.

### Hidden Full 3MF Parser Scope

Risk: The project-file slice could turn into broad ZIP/XML parsing or full
model import/export work before the fixture contract is reviewed.

Mitigation: Phase 41 must lock the fixture and expected-artifact contract
before Phase 42 or Phase 43 implementation. Any new parsing dependency must be
justified by the phase plan.

### Weak Fixture Provenance

Risk: A convenient local sample could be checked in without traceability to the
accepted Prusa source pin or a reviewed source decision.

Mitigation: Fixture provenance must include source ref, source path or reviewed
sample source, checksum, update route, checklist path, and deferred scope.

### Generated-Output Drift

Risk: Support generation, arc fitting, and wall seam work may appear adjacent
to project files but require much stronger output comparison evidence.

Mitigation: Keep generated-output candidates out of v1.11 unless a future
milestone explicitly plans them.

### Status Vocabulary Drift

Risk: `packages/parity/status.tsv` may gain broad wording such as full Prusa
support.

Mitigation: Add exact-row checks and negative wording checks to the parity or
fixture verifier before publishing the row.

### Rust Boundary Side Effects

Risk: Rust project-file logic could perform Git, network, filesystem
discovery, process execution, release, or vendor sync operations.

Mitigation: Keep Rust logic pure and fixture-path explicit. Use tests and docs
to prove the boundary is side-effect-free.

### Stale Research Or Roadmap Inputs

Risk: v1.9 fork-intake research could remain in `.planning/research/` and
mislead v1.11 roadmapping.

Mitigation: Replace current research files with v1.11-specific project-file
evidence research during milestone setup.
