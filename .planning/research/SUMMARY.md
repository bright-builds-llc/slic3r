# v1.12 Research Summary: PrusaSlicer G-code Output Evidence Foundation

**Project:** Slic3r Rust Port
**Milestone:** v1.12 PrusaSlicer G-code Output Evidence Foundation
**Researched:** 2026-06-06
**Confidence:** HIGH for roadmap shape and stack; MEDIUM for exact fixture
details until Phase 45 selects the reviewed G-code fixture.

## Executive Summary

v1.12 should prove one narrow PrusaSlicer G-code output evidence path without
claiming broad generated-output, printer-runtime, geometry, or GUI parity. The
recommended approach is the same evidence ladder that worked in v1.10 and
v1.11: reviewed scope gate, source-pinned fixture, summary-only expected
artifact, pure Rust boundary, public Bazel parity command, mutation failure
guard, exact status row, and non-overclaiming docs.

The slice should use a dedicated `prusaslicer.gcode-output` fixture namespace
and status token, not the existing base `export-workflows` G-code fixture. The
expected artifact should be `expected-gcode-summary.tsv`, comparing stable
metadata and marker evidence only. Full G-code bytes, toolpath geometry,
support generation, seam placement, arc fitting, printer runtime behavior,
GUI/export UX, binary G-code, thumbnails, post-processing, and host upload
behavior remain out of scope.

No new dependency stack is needed. Use the Rust standard library, existing
`slic3r_flavors` and `slic3r_contracts` crates, existing Bazel/rules_rust
wiring, shell verifiers, `packages/parity-fixtures`, `packages/parity`, and
port docs.

## Key Findings

### Recommended Stack

Use existing repo-owned surfaces only:

- `packages/prusa-gcode-output-scope` for the reviewed scope gate.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/` for
  one small reviewed ASCII `.gcode` fixture, provenance, update rules, and
  `expected-gcode-summary.tsv`.
- `packages/slic3r-rust/crates/slic3r_flavors` for
  `slic3r_flavors::prusa_gcode_output`, a std-only typed summary boundary,
  tests, and a thin summary binary.
- `packages/parity` for
  `bazel run //packages/parity:prusaslicer_gcode_output_parity`, mutation
  failure guard, and exact `fork.prusaslicer.gcode-output` status row.
- `docs/port` and package READMEs for exact scope and deferred-surface
  publication.

Do not add third-party G-code parsers, geometry libraries, printer simulators,
PrusaSlicer source imports, live generation in Bazel, or new package
architecture.

### Expected Features

**Must have for v1.12:**

- Reviewed `prusaslicer.gcode-output` scope record with accepted source
  identity, fixture decision, expected-summary contract, candidate Rust
  boundary, planned parity command, planned status token, docs touched,
  license/security note, deferred scope, and reviewer signoff.
- One checked-in small Prusa-generated ASCII `.gcode` fixture with provenance,
  byte count, SHA-256, line-ending/encoding policy, update route, and no
  post-processing or host-upload scope.
- Summary-only expected artifact with stable metadata and marker evidence,
  plus explicit deferred semantics on every row.
- Pure Rust G-code summary boundary that parses caller-supplied text into typed
  values and rejects unsupported evidence kinds, overclaiming notes, wrong
  source refs, wrong fixture paths, missing rows, duplicate rows, extra rows,
  and wrong ordering.
- Public Bazel parity command and mutation failure test proving summary drift
  fails closed.
- Exact status/docs publication that keeps broad `generated-outputs` and
  adjacent Prusa rows such as support generation, wall seam, and arc fitting
  deferred.

**Defer:**

- Full G-code byte parity, toolpath geometry, extrusion, timing, support,
  seam, arc, STEP, printer-runtime, firmware, printability, GUI export,
  G-code viewer, binary G-code, thumbnails, post-processing, host upload,
  network/device, profile-update, release, sync, Bambu Studio, and OrcaSlicer
  behavior.

### Architecture Approach

Keep the architecture fixture-first and functional-core/imperative-shell:

1. Scope package locks the evidence contract before fixture bytes, Rust code,
   parity command, or status rows exist.
1. Fixture package owns static bytes, provenance, expected summary, update
   rules, and fail-closed fixture verification.
1. Rust core in `slic3r_flavors::prusa_gcode_output` owns marker and metadata
   interpretation as pure data-in/data-out logic.
1. Thin shell/Bazel adapters own file reads, diffing, process execution, and
   status publication.
1. Docs publish exact scope and deferrals.

The broad `generated-outputs` status row should remain `in progress`; v1.12
adds only the narrow `fork.prusaslicer.gcode-output` row after executable
evidence passes.

### Critical Pitfalls

1. **Byte-for-byte G-code parity overclaim** - use summary-only TSV rows and
   reject status/docs wording that implies broad generated-output parity.
1. **Unreviewed fixture provenance** - require source identity, generator
   version/build context, fixture role, byte count, SHA-256, line endings,
   update route, and reviewer signoff.
1. **Binary G-code or thumbnail leakage** - choose an ASCII `.gcode` fixture;
   reject `.bgcode`, NUL bytes, thumbnail decoding, and image behavior unless a
   future milestone scopes them explicitly.
1. **Post-processing or host upload effects** - require
   `post_processing=none`; reject `SLIC3R_PP_`, OctoPrint, PrusaLink, host
   URLs, and local absolute paths unless deliberately scoped later.
1. **Semantic drift in expected summaries** - keep a closed vocabulary such as
   file metadata, comment marker, section marker, and command presence only;
   reject geometry, runtime, support, seam, arc, or printability evidence
   kinds.
1. **Reusing base export fixtures as Prusa proof** - create a dedicated Prusa
   fixture namespace; do not reinterpret
   `packages/parity-fixtures/export-workflows/expected-gcode.txt`.

## Implications for Roadmap

### Phase 45: Prusa G-code Output Scope Gate

**Rationale:** G-code output is close enough to broad runtime/generated-output
claims that the exact evidence contract must be reviewed before fixtures or
status rows exist.

**Delivers:** Scope package, verifier, accepted source identity, fixture
decision, expected-summary contract, planned Rust boundary, planned parity
command, planned status token, docs route, license/security note, deferred
scope, and signoff.

**Avoids:** Premature fixture bytes, parser work, status rows, broad
generated-output claims, and byte parity.

### Phase 46: Prusa G-code Fixture Surface

**Rationale:** Rust and parity work need a reviewed raw fixture and expected
summary before they can encode a contract.

**Delivers:** Dedicated Prusa fixture namespace, one small ASCII `.gcode`
fixture, `.gitattributes`, provenance TSV, update rules, expected summary TSV,
fixture verifier, and verifier failure tests.

**Avoids:** Base export fixture reuse, live generation, upstream source fetches,
binary G-code, thumbnails, post-processing, host upload, and missing
provenance.

### Phase 47: Rust Prusa G-code Summary Boundary

**Rationale:** Marker interpretation belongs in a typed pure Rust boundary
before shell/Bazel parity commands publish evidence.

**Delivers:** `slic3r_flavors::prusa_gcode_output`, metadata API, summary
binary, focused Rust tests, registry traceability, and public surface names
that avoid runtime/geometry/support/seam/arc claims.

**Avoids:** Shell-owned parsing, new parser dependencies, filesystem discovery,
process execution, network access, vendor sync, and broad semantics.

### Phase 48: Executable Prusa G-code Evidence

**Rationale:** Status publication should happen only after fixture verification,
Rust summary logic, public parity command, and mutation guard pass.

**Delivers:** `//packages/parity:prusaslicer_gcode_output_parity`, comparator
script, mutation failure test, exact `fork.prusaslicer.gcode-output` status
row, fixture/status verifier updates, package docs, and port docs.

**Avoids:** Marking broad `generated-outputs` verified or completing adjacent
Prusa support/seam/arc/STEP/runtime surfaces.

### Phase Ordering Rationale

- Scope first prevents overclaiming before any evidence surfaces exist.
- Fixture second gives Rust code a reviewed input/output contract.
- Rust third keeps domain interpretation pure and testable.
- Parity/status/docs last ensures publication follows executable evidence.

### Research Flags

- **Phase 45:** confirm the exact G-code fixture candidate and stable marker
  vocabulary during scope planning.
- **Phase 46:** verify fixture provenance, checksum, line endings, privacy, and
  post-processing exclusions carefully.
- **Phase 47:** keep expected-summary semantics closed and typed.
- **Phase 48:** check status/docs wording against all deferred surfaces.

## Confidence Assessment

| Area | Confidence | Notes |
| --- | --- | --- |
| Stack | HIGH | Existing v1.10/v1.11 Rust/Bazel/parity stack fits without new dependencies. |
| Features | HIGH | The required evidence chain is clear from shipped Prusa slices. |
| Architecture | HIGH | Component boundaries map directly onto existing packages. |
| Pitfalls | HIGH | Major risks are known from prior milestone audits and G-code adjacency. |
| Fixture details | MEDIUM | The exact fixture and marker vocabulary remain Phase 45 decisions. |

**Overall confidence:** HIGH for planning the milestone shape; MEDIUM for
fixture specifics until Phase 45.

### Gaps to Address

- Exact `.gcode` fixture source and stable marker set: resolve in Phase 45.
- Whether to add a new inventory row or keep the stable slug only in the scope
  record: resolve in Phase 45 with docs/status implications.
- Expected summary column names and evidence-kind vocabulary: define in Phase
  45 and enforce in Phase 46/47.

## Sources

### Local Project Evidence

- `.planning/PROJECT.md`
- `.planning/MILESTONES.md`
- `.planning/RETROSPECTIVE.md`
- `.planning/milestones/v1.10-REQUIREMENTS.md`
- `.planning/milestones/v1.10-ROADMAP.md`
- `.planning/milestones/v1.10-MILESTONE-AUDIT.md`
- `.planning/milestones/v1.11-REQUIREMENTS.md`
- `.planning/milestones/v1.11-ROADMAP.md`
- `.planning/milestones/v1.11-MILESTONE-AUDIT.md`
- `packages/fork-vendors/forks.tsv`
- `packages/fork-inventories/prusaslicer.tsv`
- `packages/fork-inventories/category-map.tsv`
- `packages/prusa-project-file-scope/project-file-scope.md`
- `packages/parity-fixtures/README.md`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/`
- `packages/parity/README.md`
- `packages/parity/BUILD.bazel`
- `packages/parity/status.tsv`
- `packages/slic3r-rust/crates/slic3r_flavors/`
- `docs/port/README.md`
- `docs/port/package-map.md`
- `docs/port/migration-guidance.md`
- `docs/port/parity-matrix.md`
- `docs/port/contract-inventory.md`

### Standards

- `AGENTS.md`
- `AGENTS.bright-builds.md`
- `standards-overrides.md`
- Bright Builds pinned standards at
  `05f8d7a6c9c2e157ec4f922a05273e72dab97676`: index, architecture,
  verification, testing, and Rust guidance.

______________________________________________________________________

*Research completed: 2026-06-06*
*Ready for roadmap: yes*
