# Project Research - Features

**Project:** Slic3r Rust Port
**Milestone:** v1.16 PrusaSlicer Wall-Seam G-code Evidence Slice
**Researched:** 2026-06-26
**Confidence:** HIGH for feature boundaries; MEDIUM for exact fixture fields
until Phase 62 closes the scope contract.

## Feature Goal

v1.16 should prove one narrow, source-pinned PrusaSlicer wall-seam G-code
evidence slice. It is not a full seam algorithm port, a byte-for-byte G-code
parity milestone, or a printability/runtime milestone.

## Table Stakes

- Reviewed `prusaslicer.wall-seam` scope contract with accepted source
  identity, inventory row, category-map row, source anchors, fixture namespace,
  expected summary artifact, Rust boundary, public command, planned status
  wording, docs touched, security note, deferred scope, and reviewer signoff.
- Fail-closed scope verifier rejecting unsupported seam fields, duplicate or
  missing rows, traceability drift, broad generated-output claims,
  printability/runtime claims, and missing deferred-scope language.
- Source-pinned wall-seam fixture corpus with provenance, update rules, fixture
  identity, expected summary paths, and explicit exclusion of generator,
  runtime, network, sync, host-upload, post-processing, thumbnail,
  printability, and GUI behavior.
- Checked-in expected wall-seam summaries covering only approved observation
  fields such as source identity, fixture identity, source anchors,
  seam-transition observations, layer or travel context, coordinate bounds,
  extrusion/retraction observations, and evidence-boundary text.
- Pure typed Rust boundary parsing caller-supplied checked-in wall-seam
  summaries into domain values with no Git, network, filesystem discovery,
  process, generator, printer-runtime, release, or sync side effects.
- Static readiness or registry metadata tracing the wall-seam boundary to the
  source identity, fixture corpus, expected summaries, planned command, status
  wording, and deferred generated-output surfaces.
- Public wall-seam evidence command that validates checked-in summary artifacts
  through Rust while preserving existing Prusa G-code output and arc-fitting
  command contracts.
- Fail-closed mutation guards for seam observation drift, layer/travel context
  drift, coordinate-bound drift, extrusion/retraction observation drift, source
  identity drift, fixture identity drift, row-order drift, and unsupported
  deferred-behavior claims.
- Exact public status/docs wording for `fork.prusaslicer.wall-seam` that keeps
  broad `generated-outputs` in progress and preserves the existing
  `fork.prusaslicer.gcode-output` and `fork.prusaslicer.arc-fitting` meanings.

## Differentiators

- Separate wall-seam status row instead of widening semantic G-code or
  arc-fitting rows.
- Source-to-evidence traceability from `SeamAligned.cpp` to fixture summary
  fields and public docs.
- Narrow seam transition observations that are strong enough to catch drift but
  do not claim algorithmic, geometric, or printability equivalence.
- Mutation diagnostics that identify the failing wall-seam evidence field
  rather than returning a generic TSV mismatch.

## Anti-Features

These must stay out of v1.16:

- Broad `generated-outputs` graduation.
- Byte-for-byte G-code parity.
- Full wall-seam algorithm equivalence, geometry proof, tolerance proof, seam
  visibility proof, printability proof, or printer-runtime proof.
- Support generation, STEP import, full 3MF behavior, binary G-code,
  thumbnails, post-processing, host upload, GUI behavior, release behavior,
  upstream source imports, sync automation, non-Prusa fork behavior, Bambu
  Studio, and OrcaSlicer.
