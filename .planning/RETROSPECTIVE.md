# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.15 — PrusaSlicer Arc-Fitting G-code Evidence Slice

**Shipped:** 2026-06-25\
**Phases:** 5 | **Plans:** 14 | **Sessions:** yolo phase execution plus
milestone audit, integration check, requirements-ledger gap closure, archive
closeout, phase archival, retrospective, and requirements reset

### What Was Built

- Reviewed `prusaslicer.arc-fitting` scope contract with accepted source
  identity, inventory/category traceability, approved fields, planned evidence
  path, deferred scope, and fail-closed verifier mutation coverage
- Source-pinned arc-fitting fixture namespace with G2/G3 observation fixture,
  provenance, ordered `expected-arc-summary.tsv`, Bazel ownership, and
  fail-closed fixture verification
- Pure Rust `slic3r_flavors::prusa_arc_fitting` parser/readiness boundary over
  caller-supplied checked-in TSV text, with Cargo/Bazel coverage for valid and
  malformed summaries
- Public `//packages/parity:prusaslicer_arc_fitting_parity` command and
  mutation suite that validates checked-in arc summary evidence through Rust
  while preserving the existing Prusa G-code output command
- Exact narrow `fork.prusaslicer.arc-fitting` status row, package docs, scope
  docs, fixture docs, and port docs that keep broad `generated-outputs` in
  progress and keep `fork.prusaslicer.gcode-output` separate
- Requirements-ledger reconciliation phase that aligned ARCFIX checkboxes and
  traceability with passed Phase 58 verification and summary metadata

### What Worked

- The v1.12-v1.14 evidence ladder transferred cleanly to a feature-specific
  arc-fitting slice without broad generated-output promotion.
- Keeping scope, fixture, Rust boundary, public command/status/docs, and ledger
  reconciliation in separate phases made each handoff auditable.
- Exact status-row and overclaim guards across fixture and scope verifiers made
  stale or widened publication wording fail closed.
- The final audit found no implementation, integration, flow, or requirements
  coverage blockers after Phase 61 closed the ledger drift.

### What Was Inefficient

- The first audit caught stale ARCFIX requirements metadata after all
  behavioral evidence had already passed, requiring a metadata-only Phase 61.
- Closeout still required manual ROADMAP collapse, PROJECT evolution,
  MILESTONES cleanup, STATE normalization, retrospective writing, phase
  archival, and requirements removal after the archive helper ran.
- A stale deferred-items note survived after the underlying ShellCheck warning
  no longer reproduced, so deferred notes need explicit closeout review.

### Patterns Established

- Feature-specific generated-output evidence can publish a narrow fork status
  row while broad `generated-outputs` remains in progress.
- Public parity commands should validate checked-in expected artifacts through
  the same Rust boundary used by tests.
- Requirements-ledger gap closure can be metadata-only when prior phase
  verification and summary frontmatter already prove the behavioral work.

### Key Lessons

1. Milestone audits should run after every requirements-ledger edit, not only
   after product-surface work, because stale metadata can block archive
   readiness.
1. Deferred-items files need closeout review; stale debt notes can persist even
   after the underlying warning disappears.
1. Narrow generated-output slices remain easier to verify when scope,
   fixture, Rust parser, public command, status/docs, and requirements metadata
   stay as separate ownership boundaries.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led audit and archive closeout
- Sessions: yolo discuss/plan/execute phases plus milestone audit,
  integration checker, Phase 61 gap closure, archive closeout, phase archival,
  retrospective, and requirements reset
- Notable: implementation verification was clean; the extra cost came from
  requirements-ledger reconciliation and closeout hygiene

______________________________________________________________________

## Milestone: v1.14 — PrusaSlicer G-code Semantic Evidence Foundation

**Shipped:** 2026-06-22\
**Phases:** 4 | **Plans:** 11 | **Sessions:** yolo phase execution plus
milestone audit, integration check, archive closeout, phase archival, and
requirements reset

### What Was Built

- Closed nine-field semantic Prusa G-code evidence contract with traceability
  to fixture, Rust boundary, public command, status, docs, security, deferred
  scope, and reviewer boundaries
- Source-pinned semantic G-code sidecar for the selected Prusa `set_speed`
  fixture, with Bazel fixture ownership and fail-closed semantic verifier
  mutation coverage
- Pure typed Rust parser, typed facts projection, and readiness metadata for
  the semantic sidecar, keeping parsing caller-supplied and side-effect free
- Public `//packages/parity:prusaslicer_gcode_output_parity` semantic evidence
  path that validates marker, structural, and semantic TSV artifacts through
  Rust
- Semantic value, fixture identity, and deferred-claim mutation guards; exact
  narrow semantic `fork.prusaslicer.gcode-output` status wording; and
  package/scope/fixture/port docs that keep broad generated-output/runtime/fork
  surfaces deferred

### What Worked

- The v1.12 and v1.13 evidence ladder extended cleanly from marker and
  structural summaries into semantic summaries without widening the public
  generated-output claim.
- Keeping Phase 54 fixture data, Phase 55 Rust parsing/readiness, and Phase 56
  public command/status/docs publication separate made cross-phase wiring easy
  to audit.
- Exact field-order, source/fixture identity, row-value, evidence-boundary,
  status-row, and overclaim checks gave maintainers concrete failure modes for
  semantic drift.
- The milestone audit and integration checker found no orphaned requirements,
  broken maintainer flows, or broad generated-output overclaims.

### What Was Inefficient

- Closeout still required manual roadmap collapse, project-state evolution,
  richer milestone-entry editing, retrospective writing, and requirements
  deletion after the archive helper finished.
- The archive helper still warned on the STATE.md `Last Activity Description`
  shape and briefly moved status text backward to `verifying`, so STATE needed
  manual normalization.
- Phase 55 kept marker, structural, and semantic Prusa G-code code in one Rust
  module; this preserved the evidence boundary but left a future refactor
  trigger.

### Patterns Established

- Semantic generated-output evidence can be proven as a narrow executable slice
  without claiming byte-for-byte G-code parity, printability, or runtime
  behavior.
- Semantic sidecars should mirror a reviewed closed field contract and be
  verifier-owned before Rust or public parity commands consume them.
- Public parity commands can grow by adding checked-in expected artifacts to an
  existing target when the command contract is already established.
- Broad `generated-outputs` should remain in progress until multiple narrow
  executable slices justify a broader status change.

### Key Lessons

1. Semantic G-code evidence is the right next step after structural summaries,
   but it still needs explicit deferred-surface wording everywhere it appears.
1. Exact status-row constants reused across fixture and scope verifiers reduce
   stale-publication drift.
1. Milestone closeout should treat helper output as a draft and still review
   STATE, PROJECT, ROADMAP, and MILESTONES for semantic accuracy.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led audit and archive closeout
- Sessions: yolo discuss/plan/execute phases plus milestone audit,
  integration checker, archive closeout, phase archival, retrospective, and
  requirements reset
- Notable: implementation verification was clean; closeout effort centered on
  archival hygiene, current-state alignment, and preserving narrow claim
  language

______________________________________________________________________

## Milestone: v1.13 — PrusaSlicer G-code Structural Evidence Expansion

**Shipped:** 2026-06-19\
**Phases:** 4 | **Plans:** 12 | **Sessions:** yolo phase execution plus
milestone audit, integration check, archive closeout, phase archival, and
requirements reset

### What Was Built

- Closed 16-field Prusa G-code structural scope contract with traceability to
  inventory, fixture, expected summary, provenance, narrow status, and broad
  generated-output status boundaries
- Source-pinned structural G-code sidecar for the selected Prusa `set_speed`
  fixture, with Bazel fixture ownership and fail-closed structural verifier
  mutation coverage
- Pure typed Rust parser and readiness metadata for the structural sidecar,
  keeping parsing caller-supplied and side-effect free
- Public `//packages/parity:prusaslicer_gcode_output_parity` structural
  evidence path that validates both summary and structural TSV artifacts
  through Rust
- `command_count_g1` mutation guard, exact narrow structural
  `fork.prusaslicer.gcode-output` status wording, and package/port docs that
  keep broad generated-output/runtime/fork surfaces deferred

### What Worked

- The v1.12 evidence ladder extended cleanly from marker-level summaries to
  structural summaries without widening the public claim.
- Keeping Phase 50 fixture data, Phase 51 Rust parsing, and Phase 52 public
  command/status publication separate made the handoffs easy to audit.
- Exact row-count, row-order, source/fixture identity, status-row, and
  overclaim checks gave maintainers concrete failure modes for structural
  drift.
- The milestone audit caught stale Phase 50 requirement metadata before
  archival, and the integration checker found no broken scope -> fixture ->
  Rust -> parity -> docs flow.

### What Was Inefficient

- Closeout still required manual roadmap collapse, project-state evolution,
  retrospective writing, phase directory archival, and requirements deletion
  after the archive helper finished.
- The archive helper warned on one STATE.md field shape and left current focus
  text needing manual cleanup.
- The interactive confirmation tool was unavailable in Default mode, so the
  skill adapter fallback had to select the recommended proceed path after the
  passed audit/readiness checks.

### Patterns Established

- Generated-output evidence can become more meaningful through structural
  summaries before byte-for-byte or semantic output parity is attempted.
- Structural sidecars should mirror a reviewed closed field contract and be
  verifier-owned before Rust or public parity commands depend on them.
- Public parity commands should validate checked-in expected artifacts through
  the same Rust boundary that tests consume.
- Broad `generated-outputs` should remain in progress until several narrow
  executable slices justify a broader status change.

### Key Lessons

1. Structural evidence is the right intermediate step between marker-level
   summaries and byte-for-byte G-code parity.
1. Requirement checkboxes and traceability rows need the same three-source
   cross-check as code: requirements file, summary frontmatter, and phase
   verification tables.
1. Milestone closeout remains a separate engineering workflow; archive helpers
   reduce the mechanical work but do not replace project judgment.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led audit and archive closeout
- Sessions: yolo discuss/plan/execute phases plus milestone audit,
  integration checker, archive closeout, phase archival, retrospective, and
  requirements reset
- Notable: implementation verification was clean; closeout effort centered on
  planning metadata, archival hygiene, and current-state alignment

______________________________________________________________________

## Milestone: v1.12 — PrusaSlicer G-code Output Evidence Foundation

**Shipped:** 2026-06-15\
**Phases:** 4 | **Plans:** 12 | **Sessions:** yolo phase execution plus
milestone audit, integration check, archive closeout, and requirements reset

### What Was Built

- Reviewed `prusaslicer.gcode-output` scope gate with accepted source identity,
  expected-summary contract, planned command/status token, and explicit
  generated-output deferrals
- Source-pinned Prusa G-code fixture namespace with provenance, update rules,
  byte/hash checks, and a summary-only expected marker artifact
- Pure Rust G-code summary parser, metadata boundary, registry row, and tests
  over the Phase 46 expected-summary TSV
- Public `//packages/parity:prusaslicer_gcode_output_parity` command backed by
  the Rust summary boundary and checked-in expected artifact
- `line_4` expected-summary mutation guard, exact
  `fork.prusaslicer.gcode-output` status row, publication-aware scope/fixture
  verifiers, and non-overclaiming package/port docs

### What Worked

- The v1.10 and v1.11 evidence ladder scaled cleanly to the first generated
  output slice: scope gate, fixture, typed Rust boundary, parity command,
  mutation guard, status row, docs, and audit.
- Keeping the expected artifact summary-only avoided byte-for-byte G-code,
  geometry, extrusion, timing, runtime, and printability claims while still
  proving an executable evidence path.
- Earlier verifiers evolved from absence guards to exact publication checks,
  which kept the handoff between phases explicit instead of letting stale
  guards linger.
- The integration checker found no broken flows; the maintainer command passed
  during audit with `rows: 5`.

### What Was Inefficient

- Planning closeout still required manual roadmap collapse, project evolution,
  state cleanup, retrospective writing, phase directory archival, and
  requirements reset after the archive CLI ran.
- `mdformat` again rewrote YAML frontmatter in a milestone audit file, so
  frontmatter-bearing planning artifacts need targeted integrity checks.
- STATE metadata used an unexpected shape for one field, causing the archive
  helper to warn and leaving some closeout text for manual cleanup.

### Patterns Established

- Generated-output parity should start with one reviewed summary-only slice
  before broad generated-output or byte parity is considered.
- G-code expected artifacts can use stable metadata and marker rows as a
  defensible first executable evidence contract.
- Scope and fixture verifiers should be updated at each phase boundary to
  reject only still-forbidden future artifacts.
- Public docs should name the exact verified fork slice and the deferred broad
  surfaces together.

### Key Lessons

1. First generated-output milestones should prove evidence plumbing and
   non-overclaiming status before semantic output parity.
1. Phase-boundary verifiers need deliberate reconciliation as planned future
   artifacts become real.
1. Frontmatter-bearing planning files need direct delimiter/field validation
   and `git diff --check`, not blanket Markdown formatting.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led audit and archive closeout
- Sessions: yolo discuss/plan/execute phases plus milestone audit, integration
  checker, archive closeout, retrospective, and requirements reset
- Notable: implementation evidence passed cleanly; closeout work was mostly
  governance, archive hygiene, and current-state alignment

______________________________________________________________________

## Milestone: v1.11 — PrusaSlicer Broader Parity Port

**Shipped:** 2026-06-06\
**Phases:** 4 | **Plans:** 9 | **Sessions:** yolo phase execution plus
milestone audit, integration check, archive closeout, and requirements reset

### What Was Built

- Reviewed `prusaslicer.project-file` scope gate with accepted source identity,
  fixture decision, expected-artifact contract, planned command, status token,
  and explicit deferred surfaces
- Source-pinned project-file fixture namespace with provenance, update rules,
  presence-level expected summary, and fail-closed fixture verification
- Pure Rust project-file parser and metadata boundary with typed traceability
  to fixture, source, registry, and planned status data
- Public `//packages/parity:prusaslicer_project_file_parity` command backed by
  checked-in expected artifacts and a mutation failure guard
- Exact `fork.prusaslicer.project-file` status publication plus package and
  port docs that name the verified evidence slice without broad Prusa runtime
  claims

### What Worked

- Reusing the v1.10 trust chain made the broader Prusa slice predictable:
  scope gate, fixture, typed Rust boundary, expected artifact, parity command,
  status row, docs, and audit all lined up.
- The Phase 41 scope gate prevented project-file evidence from drifting into
  full 3MF import/export, GUI behavior, generated-output parity, or runtime
  support claims.
- Fail-closed fixture and parity checks caught the important text/status/TSV
  boundaries without requiring upstream source imports or network access.
- The integration checker found stale current-state docs and requirements
  metadata before archive, while confirming the executable flow was wired end
  to end.

### What Was Inefficient

- Live planning state still drifted after implementation: requirements,
  package README wording, PROJECT, STATE, and ROADMAP needed closeout cleanup
  before archive.
- `mdformat` again proved unsafe for planning files with YAML frontmatter; the
  milestone audit frontmatter had to be manually restored after formatting.
- The milestone completion helper handled the archive files and milestone
  entry, but roadmap collapse, project evolution, state cleanup, phase
  archival, requirements reset, and retrospective still required manual work.

### Patterns Established

- Broader PrusaSlicer parity should advance one executable evidence slice at a
  time, with exact status rows only after a rerunnable command and failure
  guard exist.
- Project-file and future generated-output surfaces need explicit scope gates
  before fixture or parser work starts.
- Thin explicit-path binaries are a good boundary between Rust summary logic
  and package-owned Bazel parity commands.
- Milestone audits should be allowed to repair stale planning metadata before
  the final archive report is written.

### Key Lessons

1. Evidence close to broad runtime behavior needs a reviewed scope package
   before code or docs can make safe claims.
1. The closeout path should treat planning metadata drift as expected audit
   work, not as an implementation failure.
1. Frontmatter-bearing planning files need targeted integrity checks; blanket
   Markdown formatting can corrupt them.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led audit and archive closeout
- Sessions: yolo discuss/plan/execute phases plus final integration check,
  audit, archive, requirements reset, and retrospective
- Notable: late closeout effort was mostly governance alignment and archival
  hygiene; implementation evidence itself passed cleanly

______________________________________________________________________

## Milestone: v1.10 — PrusaSlicer Parity Evidence Foundation

**Shipped:** 2026-06-02\
**Phases:** 4 | **Plans:** 6 | **Sessions:** yolo phase execution plus
milestone audit, UAT, security verification, and archive closeout

### What Was Built

- Reviewer-gated PrusaSlicer profile-schema baseline and checklist records
  with fail-closed verification and maintainer signoff
- Static Prusa profile-schema fixture namespace with provenance, checksum
  guards, update rules, and docs-only status reservation
- A pure Rust Prusa profile parser and summary boundary with typed fixture
  metadata traceable to accepted source refs and registry capability metadata
- A public `//packages/parity:prusaslicer_profile_schema_parity` command backed
  by checked-in `expected-summary.tsv` and a mutation failure guard
- Exact `fork.prusaslicer.profile-schema` status publication, fixture/status
  verifier coverage, narrow-scope docs, UAT, and security verification

### What Worked

- Keeping the first fork slice narrow made the evidence defensible: every
  verified claim points to a fixture, source ref, checked-in expected artifact,
  status row, or rerunnable command.
- The v1.9 typed contracts and flavor registry made Prusa metadata traceable
  without adding vendor-specific Rust workspaces.
- Fail-closed Bash verifiers were effective at protecting TSV/status/doc
  boundaries because the data format is intentionally narrow and reviewable.
- The milestone audit caught governance debt in reviewer signoff before
  archive, and the final signoff turned the audit from tech-debt to passed.

### What Was Inefficient

- UAT was useful for explicit acceptance, but a skipped docs checkpoint needed
  a follow-up acceptance note before `audit-uat` reflected a fully resolved
  milestone.
- `mdformat` is unsafe for planning files that rely on YAML frontmatter beyond
  summaries; the security report needed manual frontmatter restoration after a
  formatter pass.
- The milestone completion helper created archive artifacts and moved the audit
  correctly, but still required manual ROADMAP, PROJECT, STATE, MILESTONES, and
  retrospective cleanup.

### Patterns Established

- Verified fork status rows should appear only after the exact evidence command
  passes and the fixture verifier rejects missing, duplicate, wrong-evidence,
  and overclaiming rows.
- Docs for narrow fork evidence should name both the verified slice and the
  deferred runtime, GUI, generated-output, release, network, plugin, and sync
  surfaces together.
- Future fork parity work should use a pure Rust parser/summary core plus thin
  explicit-path binaries and package-owned parity commands.

### Key Lessons

1. Fork parity milestones should ship a complete trust chain before broadening:
   source pin, fixture, typed parser, expected artifact, parity command, status
   row, docs, UAT, and security.
1. Frontmatter-bearing planning files need targeted validation instead of
   blanket Markdown formatting.
1. Broader Prusa work should proceed one executable slice at a time; generated
   output and runtime claims need their own fixtures and fail-closed guards.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led closeout
- Sessions: yolo discuss/plan/execute phases plus final audit, signoff, UAT,
  security, and milestone archive
- Notable: most late closeout effort was governance/documentation alignment,
  not implementation repair

______________________________________________________________________

## Milestone: v1.9 — Fork Vendor Intake and Module Architecture

**Shipped:** 2026-05-29\
**Phases:** 5 | **Plans:** 8 | **Sessions:** yolo phase execution plus
milestone audit and archive closeout

### What Was Built

- A metadata-only fork vendor registry for PrusaSlicer, Bambu Studio, and
  OrcaSlicer with pinned source refs, branch observations, lineage, source
  paths, refresh commands, SPDX metadata, provenance notes, and caution flags
- Source-pinned fork feature inventories, a reusable inventory template, and an
  exact-once category map for base, shared downstream, fork-specific, and
  deferred source-observed planning inputs
- Typed Rust flavor contracts for downstream fork identity, flavor identity,
  vendor source identity, feature origin, parity surface, and checklist status
- A pure `slic3r_flavors` registry crate with hand-curated static metadata,
  lookup helpers, provenance tests, and Cargo/Bazel verification
- Fork parity checklist, fixture namespace, launcher-shape, manual drift
  refresh, and deferral templates that reserve verified fork status for future
  executable evidence

### What Worked

- Pinned refs plus local verifiers gave maintainers reproducible fork intake
  facts without cloning, fetching, building, or vendoring upstream fork source
  trees.
- Modeling typed Rust contracts before registry data kept vendor names,
  source pins, feature origins, parity surfaces, and checklist labels from
  leaking as raw strings.
- Keeping the registry pure and static made it easy to test metadata without
  coupling the milestone to runtime parsing, sync automation, or release
  behavior.
- Phase 36 templates made future fork parity expectations explicit without
  falsely promoting source-observed rows to verified runtime support.

### What Was Inefficient

- Live planning status drifted after Phase 36 and had to be corrected during
  milestone audit and archive closeout.
- The milestone completion helper moved and copied the core archive artifacts
  correctly, but still left `PROJECT.md`, `ROADMAP.md`, and `STATE.md`
  needing manual cleanup.
- Summary and audit markdown with YAML frontmatter remains incompatible with
  blanket `mdformat` use, so closeout verification needs targeted frontmatter
  and diff checks.

### Patterns Established

- Fork intake should begin with pinned source references and explicit caution
  boundaries before any runtime porting work starts.
- Source-observed inventory rows are planning inputs only until executable
  fixtures, status rows, and reviewer signoff exist.
- A shared flavor registry is the right boundary for fork metadata;
  vendor-specific Rust workspaces would duplicate base behavior too early.
- Drift refresh should stay manual and reviewer-gated until fork modules,
  fixtures, and evidence commands are stable.

### Key Lessons

1. The first fork milestone should protect trust boundaries more than it
   expands runtime scope.
1. Metadata-only architecture work needs as much wording verification as code
   verification because the main regression risk is overclaiming support.
1. Future fork parity milestones need executable evidence before docs or status
   rows use `verified`.

### Cost Observations

- Model mix: balanced GSD profile with Codex-led archive closeout
- Sessions: yolo discuss/plan/execute flow for final phase work plus
  milestone audit and completion
- Notable: final audit used the fork vendor, fork inventory, fork template,
  and Rust aggregate Bazel verification targets before archive

______________________________________________________________________

## Milestone: v1.8 — Cross-Platform Release Build Automation

**Shipped:** 2026-05-24\
**Phases:** 1 | **Plans:** 1 | **Sessions:** 1 focused milestone run plus
hosted workflow hardening

### What Was Built

- A `Release Build Artifacts` GitHub Actions workflow for macOS, Linux, and
  Windows hosted runners
- A repo-owned release artifact script that runs packaged launcher parity
  evidence before creating platform archives
- Embedded `release-provenance.txt`, release manifests, and checksums for each
  platform output
- Release automation docs that publish the supported artifact boundary and
  deferred distribution work
- A verified hosted workflow matrix that passed on all three platforms after
  CI hardening

### What Worked

- Reusing packaged launcher parity targets kept release automation tied to the
  already trusted packaging-visible evidence surface.
- Keeping the workflow thin and pushing artifact logic into a repo-owned Bash
  script made local smoke verification practical.
- Running the new workflow immediately exposed real hosted-runner differences
  that local package-shaped smoke tests could not fully simulate.

### What Was Inefficient

- Windows hosted runners exposed several separate path and checkout behaviors:
  Bazel output-root length, Bazel runfiles resolution, CRLF fixture checkout,
  MSYS temp path conversion, and Windows-derived default export separators.
- The milestone summary one-liner extractor returned no accomplishment for the
  generated summary, so the milestone entry needed manual cleanup.

### Patterns Established

- Release build automation should remain a thin matrix wrapper around
  repo-owned scripts.
- Windows release CI should use a short Bazel output root and disable automatic
  CRLF checkout conversion before checkout.
- Cross-platform parity scripts need deterministic sorting and explicit
  normalization where Git Bash path conversion affects observed stdout.

### Key Lessons

1. Hosted workflow verification is not optional for cross-platform release
   automation; Windows runner behavior can differ meaningfully from local
   package-shaped smoke checks.
1. Provenance and manifest generation are easiest to trust when they are part
   of the same script that runs the evidence gate and builds the package tree.

### Cost Observations

- Model mix: Codex-led execution with GSD planning and one integration-checker
  subagent during milestone audit
- Sessions: 1 milestone run plus CI hardening and archive closeout
- Notable: Most fixes were CI harness normalization, not release feature
  redesign, because the release workflow reused existing package/parity targets

______________________________________________________________________

## Milestone: v1.7 — Cross-Platform Packaging-Visible Parity

**Shipped:** 2026-05-23\
**Phases:** 4 | **Plans:** 8 | **Sessions:** 1 focused milestone run plus
manual archive cleanup

### What Was Built

- Scoped Linux and Windows packaged launcher/startup surfaces for the verified
  Rust-backed help/version/config/export/transform slice
- Shared Linux and Windows packaged launcher parity commands with checked-in
  package layout, scope-note, and behavior fixtures
- Verified `linux.packaged-launcher` and `windows.packaged-launcher` parity
  status rows
- Updated migration, launcher, package, parity, and fixture docs for the exact
  packaged launcher scope
- Archived v1.7 roadmap, requirements, and phase history while activating the
  v1.8 release automation milestone

### What Worked

- Reusing the existing macOS packaging pattern kept Linux and Windows packaged
  launcher work scoped to thin startup handoff logic.
- Shared packaged launcher evidence made the status/docs publication phase
  concrete instead of documentation-only.
- Final traceability and packaged parity reruns caught the exact acceptance
  boundary before milestone closeout.

### What Was Inefficient

- `REQUIREMENTS.md` still had Phase 30 PVIS rows marked pending after the phase
  summaries and verification showed them complete, so archive cleanup had to
  reconcile the stale status manually.
- The installed `gsd-tools` does not expose the `milestone complete` command
  referenced by the workflow, leaving milestone archival as a manual operation.
- Summary verification can misread generated package-tree files as repo files;
  lifecycle verification was the more accurate closeout signal for this
  milestone.

### Patterns Established

- Cross-platform packaged launcher parity should publish separate
  platform-specific status rows rather than broad aggregate packaging claims.
- Release automation should reuse verified packaged launcher evidence rather
  than introducing a second, uncorrelated release-build proof path.
- Phase directories can be archived under the milestone once a new active phase
  exists, keeping `.planning/phases/` aligned with the active roadmap.

### Key Lessons

1. Visibility requirements need to be updated in both phase summaries and the
   live requirements table before closeout; otherwise the milestone archive
   inherits stale pending rows.
1. Milestone transition should verify what the next GSD target resolver sees,
   not only whether the archive files exist.

### Cost Observations

- Model mix: Codex-led execution with Bazel parity evidence reused from the
  verified runtime and packaging surfaces
- Sessions: 1 focused milestone run plus closeout cleanup
- Notable: packaged launcher parity stayed manageable because the evidence
  commands reused existing behavior fixtures and only added platform-specific
  package layout expectations

______________________________________________________________________

## Milestone: v1.6 — Windows Parity Foundation

**Shipped:** 2026-05-21\
**Phases:** 3 | **Plans:** 7 | **Sessions:** 1 focused milestone run plus
closeout UAT and security passes

### What Was Built

- A preferred Windows launcher/runtime target and Bazel smoke surface for the
  existing verified Rust-backed slice
- A shared Windows runtime parity command and Windows runtime fixture bundle
- Windows validation state published in the checked-in parity status source and
  the migration docs
- Archived v1.6 phase history and milestone requirements for the next
  milestone boundary

### What Worked

- Reusing the existing verified help/version/config/export/transform fixtures
  kept Windows runtime parity narrow and easy to defend.
- Splitting Windows runtime delivery, shared evidence, and visibility
  publication across three phases kept each phase independently reviewable.

### What Was Inefficient

- The milestone-completion helper still produced a skeletal milestone entry and
  left live planning files needing manual cleanup for `PROJECT.md`,
  `ROADMAP.md`, `STATE.md`, and `MILESTONES.md`.
- Automated accomplishment extraction for milestone summaries still collapsed
  to placeholder `Plan XX-YY:` lines instead of the real one-liners from the
  summary bodies.

### Patterns Established

- New platform work can reuse the Linux-to-Windows ladder directly:
  launcher/runtime path first, shared parity evidence second, visibility
  publication third.
- Publishing validation state deserves a dedicated closeout phase even when the
  underlying runtime evidence already exists.

### Key Lessons

1. Once the parity surface is bounded and backed by shared evidence, expanding
   to the next platform is much cheaper than the first platform foundation.
1. Milestone closeout needs its own verification passes for docs, UAT, and
   security so archival reflects the real shipped surface rather than just the
   implementation commits.

### Cost Observations

- Model mix: Codex-led execution with shared parity evidence reusing the
  retained legacy oracle only where needed
- Sessions: 1 focused milestone run with later closeout UAT and security gates
- Notable: Windows runtime parity was cheaper than Linux because the fixture
  and documentation pattern already existed

______________________________________________________________________

## Milestone: v1.4 — Linux Parity Foundation

**Shipped:** 2026-04-11\
**Phases:** 3 | **Plans:** 7 | **Sessions:** 1 focused milestone run

### What Was Built

- A preferred Linux launcher/runtime shim and Bazel smoke surface for the
  existing verified Rust-backed slice
- A shared Linux runtime parity command and Linux runtime fixture bundle
- Linux validation state published in the checked-in parity status source and
  the migration docs
- Archived v1.4 phase history, requirements, and audit artifacts for the next
  milestone boundary

### What Worked

- Reusing the already verified help/version/config/export/transform fixtures
  kept Linux parity work narrow and easy to verify.
- Splitting Linux runtime delivery, shared evidence, and visibility
  publication across three phases kept each phase independently defensible.

### What Was Inefficient

- The milestone-completion helper still left live planning files in a
  half-archived state and needed manual cleanup for `PROJECT.md`, `ROADMAP.md`,
  `STATE.md`, and `MILESTONES.md`.
- Bazel output-base lock contention is still easy to trigger when several
  run/test commands are started too aggressively in parallel.

### Patterns Established

- New platform work should follow the same ladder: launcher/runtime path first,
  shared parity evidence second, visibility publication third.
- Shared parity evidence can reuse existing slice fixtures when the expected
  outputs are platform-agnostic.

### Key Lessons

1. Platform expansion is much easier when the parity surface is already shaped
   around explicit shared evidence commands rather than ad hoc checks.
1. Publishing validation state deserves its own milestone phase; otherwise the
   status/docs layer lags behind the real evidence and weakens trust.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still kept in
  reserve rather than on the critical path
- Sessions: 1 focused milestone run with no follow-up gap phase required
- Notable: Linux runtime parity was materially cheaper than the first packaging
  milestone because it reused the existing slice boundaries and fixtures

## Milestone: v1.3 — Packaging-Visible Parity

**Shipped:** 2026-04-11\
**Phases:** 3 | **Plans:** 6 | **Sessions:** 1 milestone completion cycle with 1 audit-driven gap-closure phase

### What Was Built

- A scoped macOS packaged launcher bundle and startup shim for the verified
  Rust-backed slice
- Shared packaged parity evidence for bundle layout, startup handoff, packaged
  `--help`, packaged `--version`, and representative config persistence
- Aligned packaged launcher docs, notes, and parity status for the exact
  packaged evidence surface
- Archived v1.3 phase history, requirements, and audit artifacts for the next
  milestone boundary

### What Worked

- Treating the packaged launcher surface as its own parity slice kept the
  packaging work verifiable instead of vague.
- Using one representative packaged config-persistence path was enough to prove
  the packaged startup shim does real bounded work without overclaiming every
  packaged subflow.

### What Was Inefficient

- The milestone-completion helper still leaves live planning files in a
  half-archived state and needs manual cleanup for `PROJECT.md`, `ROADMAP.md`,
  `STATE.md`, and the milestone summary entry.
- The strict lifecycle hardening caught Phase 20 correctly, but only after a
  fallback-planned attempt had already been committed, which created avoidable
  rework.

### Patterns Established

- Packaged parity should verify one real packaged workflow beyond `--help` and
  `--version`, not just bundle layout.
- Packaged-scope notes should describe only what the shared packaged evidence
  command actually proves; broader slice ownership belongs elsewhere.

### Key Lessons

1. A packaged parity command is only trustworthy when it exercises the packaged
   startup shim through at least one representative stateful workflow.
1. Lifecycle provenance is now a real execution gate; fallback planning must be
   corrected before execution instead of papered over during wrap-up.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still doing
  the slowest parity confirmation work
- Sessions: 1 milestone completion cycle with 1 formal gap-closure phase
- Notable: the packaging work stayed manageable because the evidence surface
  was kept narrow and reused the existing CLI parity slice

## Milestone: v1.2 — Export and Transform Parity

**Shipped:** 2026-04-11\
**Phases:** 6 | **Plans:** 14 | **Sessions:** 1 milestone completion cycle with follow-up gap-closure passes

### What Was Built

- Rust-backed export workflows for G-code, STL, OBJ, AMF, 3MF, layered SVG,
  and explicit `--export-sla-svg`
- Rust-backed non-slicing `--info`, `--repair`, and `--split` behavior
- Shared fixture comparison commands for export and transform workflows
- Full fixture coverage for the explicit SLA SVG alias and the documented
  `--info` input matrix
- `requirements-completed` summary metadata and control-plane doc alignment for
  stronger milestone audits

### What Worked

- Keeping the implementation surface scoped and the verification surface
  explicit made it possible to expand parity without losing traceability.
- Phase-specific gap-closure passes worked well for converting audit findings
  into deterministic cleanup work instead of letting docs/process debt linger.

### What Was Inefficient

- The milestone-completion helper still required substantial manual cleanup for
  `PROJECT.md`, `ROADMAP.md`, `RETROSPECTIVE.md`, and the new milestone entry.
- `mdformat` is unsafe for phase `*-SUMMARY.md` files in this repo because it
  can flatten YAML frontmatter that the audit tooling depends on.

### Patterns Established

- Verify export and transform surfaces with dedicated parity commands backed by
  fixture corpora that map directly to the supported slice.
- Carry `requirements-completed` metadata in summary frontmatter so milestone
  audits can cross-check claims against phase outputs.
- Treat the `docs/port/` overview files as part of parity completion, not as
  optional polish after the behavior is already verified.

### Key Lessons

1. A parity row is not truly done until the overview docs and status surfaces
   say the same thing as the fixture commands.
1. Audit-trail metadata needs to be treated like product state: if the field is
   mandatory for tooling, it must be preserved explicitly and not handed to
   a formatter blindly.

### Cost Observations

- Model mix: Codex-led execution with the retained legacy oracle still doing
  the slowest work
- Sessions: 1 milestone completion cycle with 2 follow-up gap-closure passes
- Notable: the legacy oracle rebuild remains expensive, but the parity commands
  stay understandable because each verified surface maps to one explicit
  evidence command

## Milestone: v1.1 — CLI Parity Expansion

**Shipped:** 2026-04-08\
**Phases:** 3 | **Plans:** 8 | **Sessions:** 1 milestone expansion run

### What Was Built

- Rust-backed help and usage support through the preferred launcher path
- Rust-backed scoped config persistence for save/load/datadir
- Shared fixture comparison commands for help, version, and config persistence
- Verified parity visibility for the supported CLI slice set

### What Worked

- Continuing from the narrow `--version` slice kept the next milestone focused
  and easy to verify.
- Separate comparison commands per supported slice made the verified status
  table concrete and reviewable.

### What Was Inefficient

- The retained legacy oracle rebuild still dominates fixture comparison runtime,
  even when only one supported slice is being verified.
- The GSD roadmap metadata still underreports `roadmap_complete` even when the
  milestone is actually complete.

### Patterns Established

- Verify each supported CLI slice with its own comparison command and fixture
  corpus.
- Promote a slice from `rust-backed` to `verified` only after the corresponding
  comparison command passes and the status surface is updated in the same change.

### Key Lessons

1. Help and config persistence are the right kinds of next-step CLI slices after
   `--version`: small enough to verify, but still representative of real
   contract expansion.
1. Checked-in parity status is most trustworthy when every verified row points
   at exactly one evidence command.

### Cost Observations

- Model mix: Codex-led execution with the legacy oracle still doing the slowest
  work
- Sessions: 1 focused follow-up milestone run
- Notable: the fixture corpus stayed small, but the oracle build cost is still
  the pacing factor

______________________________________________________________________

## Milestone: v1.0 — Rust Port Foundations

**Shipped:** 2026-04-08\
**Phases:** 8 | **Plans:** 22 | **Sessions:** 1 major milestone run

### What Was Built

- Bazel monorepo scaffolding with retained legacy and new Rust packages
- A buildable and testable macOS legacy oracle preserved behind Bazel
- Contract inventory, migration guidance, parity visibility, and fixture workflow docs
- The first supported Rust-backed CLI slice for `--version`
- A shared fixture comparison harness that verifies `cli.version`

### What Worked

- Narrowing the first supported Rust-backed slice to `--version` kept parity
  claims honest and verifiable.
- Bazel package boundaries made it straightforward to expose launcher, parity,
  and fixture ownership without rewriting the whole legacy surface.

### What Was Inefficient

- The autonomous/yolo wrapper path degraded into nested workflow overhead and
  did not reliably carry the formal discuss/plan lifecycle for phases 5-8.
- The built-in milestone archival helper only handled the mechanical archive
  steps; the higher-signal roadmap and project evolution still needed manual
  cleanup.

### Patterns Established

- Preserve the legacy implementation as a narrow, explicit oracle instead of
  overclaiming test coverage.
- Treat shared parity fixtures and checked-in status data as first-class package
  surfaces, not ad hoc docs-only state.

### Key Lessons

1. Keep the first parity slice extremely small when introducing a new runtime
   path; verifiability matters more than surface area early on.
1. Autonomous workflows need explicit provenance and watchdogs if they are going
   to claim a guaranteed discuss -> plan -> execute lifecycle.

### Cost Observations

- Model mix: dominated by Codex interactive execution in one repo-bound session
- Sessions: 1 sustained milestone completion run
- Notable: the retained legacy oracle rebuild remains the slowest verification
  surface and should stay scoped tightly

______________________________________________________________________

## Cross-Milestone Trends

### Process Evolution

| Milestone | Sessions | Phases | Key Change |
|-----------|----------|--------|------------|
| v1.15 | yolo plus audit/integration/gap closure/closeout | 5 | Published the narrow Prusa arc-fitting evidence slice while preserving broad generated-output deferrals |
| v1.14 | yolo plus audit/integration/closeout | 4 | Deepened the Prusa G-code evidence path from structural summaries to semantic summaries without broad generated-output claims |
| v1.13 | yolo plus audit/integration/closeout | 4 | Strengthened the Prusa G-code evidence path from marker-level summaries to structural summaries without broad generated-output claims |
| v1.12 | yolo plus audit/integration/closeout | 4 | Established the first executable Prusa G-code output evidence slice while keeping it summary-only and narrow |
| v1.11 | yolo plus audit/integration/closeout | 4 | Reused the first Prusa trust chain for a broader project-file evidence slice without claiming full runtime or GUI support |
| v1.10 | yolo plus audit/signoff/closeout | 4 | Established the first executable Prusa profile/config evidence chain with exact status publication and non-overclaiming docs |
| v1.9 | yolo plus audit/closeout | 5 | Established fork intake and metadata architecture for downstream Slic3r-family work without claiming runtime fork support |
| v1.4 | 1 | 3 | Expanded verified parity from macOS-only runtime/package surfaces into a verified Linux runtime slice with a dedicated Linux evidence command |
| v1.3 | 1 | 3 | Extended verified parity into packaging-visible launcher behavior and hardened the packaged evidence surface with a representative config-persistence proof |
| v1.2 | 1 | 6 | Expanded verified parity from help/config into export and transform slices, then hardened fixture coverage and audit metadata |
| v1.1 | 1 | 3 | Expanded the verified CLI slice set from `--version` to help/version/config persistence |
| v1.0 | 1 | 8 | Established the full Bazel/Rust/legacy/parity migration control plane |

### Cumulative Quality

| Milestone | Tests | Coverage | Zero-Dep Additions |
|-----------|-------|----------|-------------------|
| v1.15 | Verified arc-fitting scope, fixture corpus, Rust parser/readiness, public parity command, mutation guards, exact status row, docs, requirements-ledger reconciliation, and milestone audit | milestone-scoped | kept broad generated-output, byte-for-byte G-code, full ArcWelder equivalence, printability, runtime behavior, GUI behavior, non-Prusa forks, upstream imports, release, and sync out of scope |
| v1.14 | Verified semantic scope, fixture sidecar, Rust parser/readiness, public parity command, semantic mutation guards, exact status row, docs, and milestone audit | milestone-scoped | kept byte-for-byte G-code, printability, runtime behavior, GUI behavior, non-Prusa forks, upstream imports, release, and sync out of scope |
| v1.13 | Verified structural scope, fixture sidecar, Rust parser/readiness, public parity command, mutation guard, exact status row, docs, and milestone audit | milestone-scoped | kept byte-for-byte G-code, geometry/toolpath, printability, runtime, GUI, non-Prusa forks, upstream imports, release, and sync out of scope |
| v1.12 | Verified G-code scope, fixture, Rust summary parser, public parity command, mutation guard, exact status row, docs, and milestone audit | milestone-scoped | kept broad generated-output, byte-for-byte G-code, geometry/toolpath, runtime/printer, GUI, release, network, and sync out of scope |
| v1.11 | Verified project-file scope, fixture, Rust parser, parity command, mutation guard, exact status row, and milestone audit | milestone-scoped | kept full 3MF import/export, GUI behavior, generated-output parity, runtime support, release, network/device, and sync surfaces out of scope |
| v1.10 | Verified Prusa profile/config baseline, fixtures, Rust parser, parity command, mutation guard, status row, UAT, and security report | milestone-scoped | kept Prusa evidence narrow and avoided upstream source imports, runtime fork support, and profile auto-update execution |
| v1.9 | Verified fork vendor refs, fork inventory TSVs, fork template contracts, Rust flavor contracts, and pure flavor registry metadata | milestone-scoped | kept fork source trees, runtime fork support, sync automation, and vendor-specific Rust workspaces out of scope |
| v1.4 | Verified Linux launcher runtime parity for representative help/version/config/export/transform flows | milestone-scoped | reused the existing slice fixtures instead of cloning a second platform-specific corpus |
| v1.3 | Verified packaged launcher parity for bundle layout, startup handoff, packaged help/version, and representative config persistence | milestone-scoped | reused the existing bundled Rust CLI slice instead of broadening packaged scope prematurely |
| v1.2 | Verified fixture parity for export and transform workflows plus summary metadata auditability | milestone-scoped | kept parity command-per-slice-family and added summary requirement metadata |
| v1.1 | Verified fixture parity for help/version/config persistence | milestone-scoped | kept fixture verification command-per-slice |
| v1.0 | Verified fixture parity for `cli.version` plus package verification surfaces | milestone-scoped | kept new runtime dependencies minimal |

### Top Lessons (Verified Across Milestones)

1. Shared parity fixtures should arrive as soon as a supported Rust-backed slice exists.
1. Migration docs and executable package boundaries need to move together.
1. Milestone audit metadata should be treated as a first-class artifact, not post-hoc prose.
1. Source-observed fork metadata should stay separate from verified fork
   behavior until executable evidence exists.
1. Broader fork parity should advance one executable evidence slice at a time,
   with exact status rows only after rerunnable commands and failure guards
   pass.
1. Deferred-items notes need explicit closeout review during milestone archive,
   because stale planning debt can outlive the underlying warning.
