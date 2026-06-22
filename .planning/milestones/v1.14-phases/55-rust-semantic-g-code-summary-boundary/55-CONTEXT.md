---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 55-2026-06-21T14-58-10
generated_at: 2026-06-21T14:58:10.950Z
---

# Phase 55: Rust Semantic G-code Summary Boundary - Context

**Gathered:** 2026-06-21
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Phase 55 adds the pure typed Rust boundary for the v1.14 Prusa G-code semantic
summary artifact created in Phase 54. Developers should be able to parse
caller-supplied checked-in semantic summary text into typed values, inspect
static readiness metadata through the existing Rust registry boundary, and run
Cargo/Bazel coverage proving invalid semantic summaries fail closed.

The phase completes GSRUST-01, GSRUST-02, and GSRUST-03 only. It does not add
the public Phase 56 parity command behavior, does not update public status/docs
wording, does not claim byte-for-byte G-code parity or generated-output
verification, and does not introduce generator, filesystem discovery, Git,
network, process execution, printer-runtime, release, sync, GUI, support, seam,
arc, or non-Prusa fork behavior.
</domain>

<decisions>
## Implementation Decisions

### Rust boundary placement

- **D-01:** Extend the existing
  `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs`
  module instead of creating a new crate or vendor-specific workspace. This
  preserves the marker summary, structural summary, and semantic summary
  evidence chain for `prusaslicer.gcode-output`.
- **D-02:** Add semantic parsing as a pure data-in/data-out API over
  caller-supplied TSV text. The boundary must not read files, discover fixture
  paths, invoke generators, shell out, fetch network resources, inspect Git
  state, or publish runtime/parity status.
- **D-03:** Keep the existing marker and structural parser APIs stable while
  adding semantic types and helpers. Phase 55 should be additive unless a local
  rename is required by Rust tests and can be kept internal.

### Semantic row model

- **D-04:** Model the Phase 54 semantic header exactly:
  `source_ref`, `fixture_path`, `semantic_field`, `semantic_category`,
  `semantic_value`, and `evidence_boundary`.
- **D-05:** Accept exactly the Phase 53/54 closed semantic field set:
  `source_ref`, `fixture_id`, `fixture_path`, `command_class_counts`,
  `movement_class_counts`, `coordinate_bounds`, `extrusion_total`,
  `feedrate_observations`, and `layer_marker_relationships`.
- **D-06:** Preserve source and fixture identity as typed values where existing
  contracts support that, especially
  `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`,
  `gcodewriter-set-speed.gcode`, and the checked-in semantic fixture path.
- **D-07:** Semantic values may remain narrow string-backed domain values when
  wrapping them in richer enums would add ceremony without preventing a real
  invalid state. The closed semantic field and category identities should be
  typed because downstream code depends on fail-closed recognition.

### Rejection coverage

- **D-08:** Add focused Cargo/Bazel tests proving valid semantic fixture rows
  parse and invalid semantic summaries fail closed for invalid headers, wrong
  column counts, missing rows, duplicate rows, out-of-order rows, unsupported
  semantic fields, unsupported claim text, wrong source refs, and wrong fixture
  identities.
- **D-09:** Keep each new Rust unit or integration test focused on one concern,
  with explicit Arrange, Act, Assert comments when setup is non-trivial.
- **D-10:** Reuse the existing `prusa_gcode_output_test` Bazel target and
  compile-data pattern, adding the Phase 54 semantic expected summary artifact
  as compile data instead of inventing a separate test surface.

### Readiness metadata

- **D-11:** Expose semantic readiness through the existing registry/readiness
  boundary in `slic3r_flavors`, tracing the accepted Prusa source identity,
  fixture corpus, semantic expected summary path, planned public command,
  planned status token, and deferred generated-output surfaces.
- **D-12:** Readiness wording must stay explicitly pre-publication: semantic
  parser/readiness metadata exists for Phase 55 developers, while public
  semantic parity evidence and status/docs publication remain Phase 56 work.
- **D-13:** Keep the broad `generated-outputs` surface in progress and keep
  `fork.prusaslicer.gcode-output` status publication unchanged in Phase 55.

### No-overclaiming boundary

- **D-14:** Public and internal helper names must not imply byte-for-byte
  G-code parity, printability, printer-runtime behavior, support generation,
  seam behavior, arc fitting, GUI behavior, release behavior, upstream source
  imports, sync automation, or non-Prusa fork behavior.
- **D-15:** Evidence-boundary text should be parsed or checked narrowly enough
  that broad semantic claim text fails closed without requiring Phase 55 to
  understand printer runtime semantics.

### the agent's Discretion

- Choose exact Rust type names for semantic rows, fields, categories, and
  values, provided optional internals use `maybe_` names and public names stay
  narrow.
- Choose whether the semantic parser shares helper functions with the marker
  and structural parsers or uses new small helpers, provided control flow stays
  shallow and tests remain focused.
- Choose exact readiness metadata structure inside the existing registry
  boundary, provided downstream agents can inspect semantic readiness without
  filesystem discovery, Git, network, process execution, status publication, or
  broad generated-output claims.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope

- `.planning/ROADMAP.md` - Phase 55 goal, dependency, requirements, planned
  plans, and success criteria.
- `.planning/REQUIREMENTS.md` - GSRUST-01, GSRUST-02, GSRUST-03, and the
  v1.14 out-of-scope boundary.
- `.planning/PROJECT.md` - v1.14 milestone goal and current-state constraints.
- `.planning/STATE.md` - current phase position and accumulated Prusa G-code
  evidence-chain decisions.
- `.planning/phases/53-semantic-g-code-scope-contract/53-CONTEXT.md` - locked
  semantic field contract, planned Rust boundary, and no-overclaiming boundary.
- `.planning/phases/54-semantic-g-code-fixture-corpus/54-CONTEXT.md` - locked
  semantic artifact shape, fixture values, verifier expectations, and Phase 55
  handoff.
- `.planning/phases/54-semantic-g-code-fixture-corpus/54-VERIFICATION.md` -
  evidence that the semantic fixture corpus and mutation guards passed.

### Rust boundary and tests

- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_gcode_output.rs` -
  existing marker and structural parser/readiness boundary to extend.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_gcode_output.rs` -
  existing Rust integration coverage to extend with semantic valid and
  fail-closed cases.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs` - existing
  flavor capability/readiness metadata boundary.
- `packages/slic3r-rust/crates/slic3r_flavors/src/lib.rs` - module exports for
  `slic3r_flavors`.
- `packages/slic3r-rust/crates/slic3r_flavors/src/bin/prusa_gcode_output_summary.rs`
  - existing summary adapter and likely Phase 56 integration point.
- `packages/slic3r-rust/crates/slic3r_flavors/BUILD.bazel` - Bazel Rust
  library, compile data, clippy, rustfmt, and test targets.
- `packages/slic3r-rust/crates/slic3r_flavors/Cargo.toml` - crate manifest for
  Cargo verification.

### Semantic fixture and scope inputs

- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv`
  - Phase 54 semantic summary artifact that Phase 55 parses.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv`
  - existing structural summary pattern that semantic parsing extends.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv`
  - original marker summary pattern that must remain stable.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/fixture-provenance.tsv`
  - accepted source identity, fixture identity, source literal, checksum,
  update route, and deferrals.
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/README.md`
  - fixture namespace and semantic artifact documentation.
- `packages/prusa-gcode-output-scope/gcode-output-scope.md` - approved Phase
  53 semantic field list and deferred semantic scope.
- `packages/prusa-gcode-output-scope/README.md` - package-level semantic scope
  verification command and boundary.

### Status and public docs boundary

- `packages/fork-inventories/prusaslicer.tsv` - accepted
  `prusaslicer.gcode-output` inventory row.
- `packages/fork-inventories/category-map.tsv` - `gcode.shared` category-map
  reference to `prusaslicer.gcode-output`.
- `packages/parity/status.tsv` - broad `generated-outputs` and narrow
  `fork.prusaslicer.gcode-output` rows that Phase 55 must not publish or
  promote.
- `packages/parity/README.md` - public parity package docs that Phase 55 must
  not broaden.
- `docs/port/package-map.md` - package ownership and phase history.
- `docs/port/parity-matrix.md` - public generated-output and fork evidence
  wording that must remain non-overclaiming.
- `docs/port/migration-guidance.md` - maintainer-facing migration guidance for
  Prusa G-code evidence boundaries.
</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `prusa_gcode_output.rs` already contains constants, typed row models,
  exact-header parsing, expected marker and structural row definitions, and
  no-overclaiming boundary text that can be mirrored for semantic summaries.
- `tests/prusa_gcode_output.rs` already exercises valid marker/structural
  parsing and fail-closed invalid cases; Phase 55 should extend this surface.
- `BUILD.bazel` already wires `prusa_gcode_output_test` with compile data for
  marker and structural summaries; add the semantic summary artifact there.
- `registry.rs` already carries Prusa G-code capability provenance and future
  parity notes, making it the natural place for semantic readiness metadata.

### Established Patterns

- Rust flavor code keeps parsing pure and deterministic over caller-supplied
  content. Bazel and shell own file orchestration and public command behavior.
- The evidence ladder is additive: marker summary, structural summary,
  semantic summary, Rust parser/readiness boundary, then public executable
  semantic evidence.
- Summary parsers reject malformed rows by exact header, column count, row
  identity, source identity, fixture path, and unsupported claim text.
- Public docs and status rows stay narrow until the phase that explicitly owns
  publication.

### Integration Points

- Phase 55 should update `slic3r_flavors` Rust source, Rust tests, Cargo/Bazel
  manifests or compile-data wiring, and readiness metadata.
- Phase 56 will consume the semantic parser/readiness boundary when adding
  public semantic parity evidence and status/docs updates.
</code_context>

<specifics>
## Specific Ideas

- Treat semantic parsing as the third internal evidence rung after marker and
  structural parsing, not as public generated-output parity.
- The checked-in fixture currently records four feedrate-only `G1 F...`
  commands and no coordinate axes, extrusion axes, layer markers, temperature
  markers, or tool changes. The Rust typed boundary should preserve those
  exact narrow observations.
- Invalid semantic cases should be easy for future maintainers to diagnose:
  bad header, wrong column count, missing approved field, duplicate approved
  field, out-of-order approved field, unsupported semantic field, wrong source
  ref, wrong fixture identity, and broad behavior claim.
</specifics>

<deferred>
## Deferred Ideas

- Phase 56 owns public semantic parity evidence, semantic mutation guards,
  exact status wording, public docs, and any public command integration.
- Byte-for-byte G-code parity, broad generated-output verification,
  geometry/toolpath parity, printability, printer-runtime behavior, support
  generation, wall seam behavior, arc fitting, STEP import, full 3MF
  import/export, GUI behavior, binary G-code, thumbnails, post-processing, host
  upload, network/device integration, profile auto-update execution, fork
  release builds, Bambu Studio, OrcaSlicer, upstream source imports, release
  behavior, and sync automation remain out of scope.
</deferred>

---

*Phase: 55-rust-semantic-g-code-summary-boundary*
*Context gathered: 2026-06-21*
