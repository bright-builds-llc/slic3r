# Pitfalls Research

**Domain:** v1.12 PrusaSlicer G-code output evidence foundation
**Project:** Slic3r Rust Port
**Researched:** 2026-06-06
**Confidence:** HIGH for evidence-process pitfalls; MEDIUM for exact G-code
markers until the Phase 45 scope gate selects the fixture and expected summary.

## Scope Assumption

The roadmap should continue the v1.10/v1.11 trust chain:

1. **Phase 45: Prusa G-code Scope Gate** - reviewed fixture source, provenance,
   expected-summary contract, status token, deferred scope, and signoff.
1. **Phase 46: Prusa G-code Fixture Surface** - checked-in small
   Prusa-generated G-code fixture, provenance TSV, summary-only expected
   artifact, fixture verifier, and update rules.
1. **Phase 47: Rust Prusa G-code Summary Boundary** - typed pure Rust parser
   for the expected summary and marker vocabulary only.
1. **Phase 48: Executable Prusa G-code Evidence** - public Bazel parity command,
   mutation guard, exact status row, and docs/status publication.

If the roadmap uses different phase numbers or names, keep the same ordering.
Do not publish a verified row before the fixture, Rust summary boundary, parity
command, and mutation guard all exist.

## Critical Pitfalls

### Pitfall 1: Byte-for-Byte G-code Parity Overclaim

**What goes wrong:**
A small Prusa-generated G-code fixture gets treated as proof that the Rust port
matches PrusaSlicer generated output byte-for-byte, or that geometry, movement
planning, extrusion, print time, printer safety, or firmware behavior is
verified.

**Why it happens:**
G-code looks like the final user-visible output, so reviewers may assume that
any checked fixture means output-content parity. PrusaSlicer G-code can also
carry metadata, custom G-code expansions, thumbnails, comments, post-processing
effects, printer-specific commands, and version/profile-dependent choices. A
raw full-file diff is tempting but too broad for this milestone.

**How to avoid:**
Make the expected artifact summary-only. The selected rows should be stable
metadata and marker evidence such as generated-by/version comments, known
section markers, selected header metadata, or explicit fixture-specific markers.
Every row needs a `deferred_semantics` or equivalent column that says what is
not being proved. Ban notes that claim geometry, support generation, wall seam,
arc fitting, printer-runtime behavior, binary G-code compatibility, or GUI
parity.

**Warning signs:**

- Expected files named like `expected.gcode` or `expected-output.gcode`.
- Docs say "G-code output parity", "generated-output parity", or "matches
  PrusaSlicer output" without "summary-only" and "narrow fixture".
- The status row updates `generated-outputs` to `verified`.
- The comparator diffs the whole G-code file instead of a typed summary.

**Phase to address:**
Phase 45 defines the contract; Phase 46 enforces it in fixture artifacts; Phase
48 enforces it in status/docs.

**Verification hooks:**

- Fixture verifier rejects extra expected-summary rows and unsupported
  `deferred_semantics` values.
- Rust tests reject notes containing broad claims such as `geometry`,
  `support`, `seam`, `arc`, `printer-runtime`, `runtime`, `safe-to-print`, or
  `byte-for-byte`.
- Status/docs check confirms the existing `generated-outputs` row remains `in progress`, and the new row is a single exact fork evidence row.

______________________________________________________________________

### Pitfall 2: Unreviewed Or Unreproducible Fixture Provenance

**What goes wrong:**
A convenient local G-code sample is checked in without a source pin, generator
version, profile/config context, fixture role, checksum, update route, or
reviewer signoff.

**Why it happens:**
Generated G-code is easy to produce locally, but the generation environment is
part of the evidence. Without provenance, maintainers cannot tell whether the
fixture came from the accepted PrusaSlicer source identity, a local GUI session,
a profile modified after the fact, a post-processed output, or an unsupported
binary export.

**How to avoid:**
Phase 45 must define the accepted fixture source before bytes land. Phase 46
must record source identity, accepted tag or commit, generator build/version,
input model or project source, profile/config source, generation command or
reviewed manual export note, byte count, SHA-256, line endings, role, update
route, and exclusions. Branch-head observations are drift-only unless a
reviewed intake update changes the pinned source.

**Warning signs:**

- Provenance says "generated locally" without a command, PrusaSlicer version,
  config/profile input, or reviewer note.
- Fixture path is outside `packages/parity-fixtures/forks/prusaslicer/`.
- No checksum or byte count is recorded.
- Update rules mention pulling latest upstream automatically.

**Phase to address:**
Phase 45 owns source decision and signoff. Phase 46 owns provenance and
checksum verification.

**Verification hooks:**

- `verify_prusa_gcode_fixture` requires an exact provenance header and exactly
  one fixture row unless Phase 45 explicitly approves more.
- The verifier checks bytes, SHA-256, line-ending policy, fixture namespace,
  source ref, update route, and Phase 45 scope-record path.
- The failure test mutates the fixture checksum and proves the verifier fails.

______________________________________________________________________

### Pitfall 3: Binary G-code And Thumbnail Scope Leakage

**What goes wrong:**
The fixture is binary `.bgcode`, embeds large thumbnail payloads, or mixes
thumbnail/image behavior into the evidence. The milestone then accidentally
tests file encoding, compression, image formats, or firmware preview behavior
instead of stable ASCII G-code metadata markers.

**Why it happens:**
Prusa documents binary G-code support and says binary export can be enabled for
supported printer profiles starting with PrusaSlicer 2.7.0. Prusa also
documents G-code thumbnails with PNG/QOI behavior. Those features are adjacent
to G-code output but are not the narrow evidence path requested here.

**How to avoid:**
Phase 45 should explicitly choose an ASCII `.gcode` fixture unless the
milestone is renamed to include binary G-code. If thumbnail marker presence is
useful, treat it as marker presence only and do not decode or validate image
data. Prefer a small fixture without embedded thumbnail blocks for v1.12.

**Warning signs:**

- Fixture extension is `.bgcode`.
- Expected summary includes image dimensions, QOI/PNG decoding results, or
  compressed block details.
- Fixture verifier needs `libbgcode`, image libraries, or thumbnail decoding.
- G-code file size grows because preview data was kept for no evidence value.

**Phase to address:**
Phase 45 decides ASCII vs binary and thumbnail exclusions. Phase 46 enforces
the selected format.

**Verification hooks:**

- Fixture verifier rejects `.bgcode`, NUL bytes, or non-text content unless
  Phase 45 explicitly allowed binary scope.
- Provenance records `line_endings` and `encoding`.
- README exclusions name binary G-code, thumbnail decoding, and printer
  preview behavior as deferred unless explicitly in scope.

______________________________________________________________________

### Pitfall 4: Post-Processing And Host Upload Effects Sneak In

**What goes wrong:**
The fixture includes post-processing script mutations or host-upload behavior,
then the evidence is misread as PrusaSlicer core output or printer integration.

**Why it happens:**
Prusa documents post-processing scripts that receive a temporary G-code path,
can modify the file, and can affect the final output name. It also documents
host destinations such as PrusaLink and OctoPrint through post-processing
environment variables. Those are real workflows, but they are out of scope for
v1.12.

**How to avoid:**
The scope record must state "no post-processing scripts" and "file export only"
unless the fixture is intentionally a post-processed sample, which should be a
future milestone. The provenance should include a field that records
post-processing as `none`.

**Warning signs:**

- G-code contains custom comments or host metadata not attributable to the
  reviewed PrusaSlicer export.
- Provenance mentions OctoPrint, PrusaLink, removable media export, or
  `SLIC3R_PP_*`.
- Fixture update route runs arbitrary scripts.

**Phase to address:**
Phase 45 excludes post-processing and host upload scope. Phase 46 scans the
fixture and provenance for those markers.

**Verification hooks:**

- Fixture verifier rejects provenance values other than `post_processing=none`.
- Security scan rejects `SLIC3R_PP_`, `OctoPrint`, `PrusaLink`, host URLs, and
  local absolute paths in the fixture unless Phase 45 explicitly documents why
  a marker is safe and non-secret.

______________________________________________________________________

### Pitfall 5: Expected Summary Encodes G-code Semantics Instead Of Evidence

**What goes wrong:**
The summary rows start interpreting commands, moves, extrusion, temperatures,
estimated print time, layer counts, support behavior, seam placement, or arc
commands as verified behavior.

**Why it happens:**
G-code is readable and command-like. It is easy to drift from "marker exists"
into "this command proves the printer does X" or "this row proves Prusa
geometry behavior." That crosses into printer-runtime and generated-output
parity.

**How to avoid:**
Use a small closed vocabulary. Good summary categories are `file-metadata-only`,
`comment-marker-only`, `section-marker-only`, and `command-presence-only` if
the scope record allows command presence. Bad categories are
`geometry-matches`, `print-runtime-verified`, `support-generation-verified`,
`seam-placement-verified`, or `arc-fitting-verified`.

**Warning signs:**

- Summary columns include coordinates, extrusion totals, movement counts,
  calculated print time, support counts, or mesh facts.
- Expected notes describe what the printer will do.
- Parser names include `runtime`, `geometry`, `support`, `wall_seam`,
  `arc_fitting`, `printer`, or `simulation`.

**Phase to address:**
Phase 46 defines the summary rows. Phase 47 makes illegal rows unrepresentable
in Rust.

**Verification hooks:**

- Rust parser uses enums/newtypes for marker and evidence-kind values.
- Rust tests reject unsupported evidence kinds, unexpected notes, duplicate
  rows, missing rows, extra rows, wrong order, wrong source ref, and wrong
  fixture path.
- Public Rust surface-name test rejects overclaiming names.

______________________________________________________________________

### Pitfall 6: Reusing The Existing Base Export G-code Fixture As Prusa Proof

**What goes wrong:**
The roadmap or implementation points to
`packages/parity-fixtures/export-workflows/expected-gcode.txt` as evidence for
PrusaSlicer-generated output.

**Why it happens:**
The repo already has a scoped G-code export fixture from v1.2, so it looks like
a convenient starting point. That fixture is part of the base Rust CLI export
workflow and contains `generated_by=rust_cli`; it is not a Prusa-generated
fixture and does not prove downstream fork output evidence.

**How to avoid:**
Create a separate namespace such as
`packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/`. Keep
the fixture provenance tied to the accepted Prusa source and the Phase 45 scope
record. Do not move or reinterpret the base export workflow fixture.

**Warning signs:**

- v1.12 fixture path is under `export-workflows/`.
- The selected fixture contains `generated_by=rust_cli`.
- The status row points to `//packages/parity:export_workflows_parity`.

**Phase to address:**
Phase 46 owns fixture namespace isolation.

**Verification hooks:**

- Fixture verifier rejects `export-workflows` paths and `generated_by=rust_cli`
  in the Prusa G-code evidence fixture.
- Status row exact check requires a new Prusa-specific parity target, not the
  existing base export target.

______________________________________________________________________

### Pitfall 7: Rust Boundary Grows Into A General G-code Parser

**What goes wrong:**
The Rust implementation starts parsing arbitrary G-code, normalizing moves,
interpreting commands, walking files from disk, invoking tools, or owning
generation logic.

**Why it happens:**
A G-code fixture invites parser work. But v1.12 only needs a typed summary
boundary for the checked expected artifact, not a general G-code runtime, not a
PrusaSlicer invocation wrapper, and not a printer simulator.

**How to avoid:**
Keep the Rust core pure: input string to typed summary to summary lines. Let
Bazel/package-owned shell wrappers pass explicit paths. Do not add filesystem
discovery, Git/network access, process execution, profile auto-update, vendor
sync, or PrusaSlicer runtime execution to `slic3r_flavors`.

**Warning signs:**

- Rust module imports `std::process`, networking, Git, temp dirs, or recursive
  file walking outside a tiny CLI adapter.
- Public APIs accept arbitrary file paths instead of summary strings.
- Parser supports many command families not present in the expected artifact.

**Phase to address:**
Phase 47.

**Verification hooks:**

- Unit tests cover the pure parser near-total branch behavior.
- CLI adapter remains a thin explicit-path binary.
- Source scan rejects side-effect imports in the core module.
- Rust tests follow Arrange, Act, Assert and one concern per test.

______________________________________________________________________

### Pitfall 8: Fail-Open Bazel Parity Command

**What goes wrong:**
The public parity command prints success even when the expected artifact
changes, the wrong fixture is passed, the status row is missing, or the summary
binary validates the same file twice.

**Why it happens:**
The prior slices use simple Bash comparators. They are effective only when they
check exact inputs, exact status row text, and mutation behavior. It is easy to
wire a command that checks existence and row count but does not prove drift is
caught.

**How to avoid:**
Phase 48 must compare Rust-produced summary output against the checked expected
artifact and include a failure test that mutates a meaningful marker, note,
row order, row count, source ref, or status row. The comparator should print
the first mismatch label and a useful diff.

**Warning signs:**

- No `*_failure_test` target exists.
- Failure test mutates only whitespace or an unused field.
- Comparator accepts duplicate rows, wrong source refs, or unsupported markers.
- Parity command does not include `status.tsv` where status publication is part
  of the claim.

**Phase to address:**
Phase 48.

**Verification hooks:**

- `bazel run //packages/parity:prusaslicer_gcode_output_parity` passes.
- `bazel test --cache_test_results=no //packages/parity:prusaslicer_gcode_output_parity_failure_test`
  fails the mutated artifact and reports the changed marker.
- Fixture verifier also checks the exact status row and target name after
  publication.

______________________________________________________________________

### Pitfall 9: Status Vocabulary Drift

**What goes wrong:**
`packages/parity/status.tsv`, `docs/port/parity-matrix.md`, or package docs
start implying full generated-output parity, full PrusaSlicer runtime support,
printer safety, GUI support, or broad file-format support.

**Why it happens:**
The project already has high-level rows named `generated-outputs` and
`file-formats`. Adding a G-code evidence row near those surfaces can make a
narrow fork slice look like a broad status change.

**How to avoid:**
Phase 45 must reserve an exact token before implementation. Use a narrow token
such as `fork.prusaslicer.gcode-output` only if the scope record defines it
precisely; otherwise choose a more specific slug from the selected fixture.
Phase 48 may add exactly one verified fork row and must leave broad rows
conservative.

**Warning signs:**

- `generated-outputs` changes from `in progress` to `verified`.
- Docs say "Prusa generated-output parity is verified" without "one
  summary-only fixture".
- Multiple new Prusa G-code rows appear from one fixture.
- Status notes omit deferred support generation, wall seam, arc fitting,
  printer-runtime, GUI, binary G-code, and post-processing scope.

**Phase to address:**
Phase 45 reserves status vocabulary. Phase 48 publishes and verifies it.

**Verification hooks:**

- Exact status-row check for the selected token, status, evidence target, and
  non-overclaiming notes.
- Duplicate-row check for the selected token.
- Negative grep confirms broad generated-output rows were not promoted.

______________________________________________________________________

### Pitfall 10: Docs And Package READMEs Drift Out Of Sync

**What goes wrong:**
Fixture docs say parity is unavailable after Phase 48, or port docs say parity
is verified before the command exists. The evidence is correct but the user
surface contradicts it.

**Why it happens:**
v1.10 and v1.11 audits found live planning and README drift after
implementation. G-code evidence adds more docs surfaces, so stale wording is a
likely failure mode.

**How to avoid:**
Treat docs as part of the executable evidence phase. Phase 46 docs should say
fixture-only. Phase 47 docs should say Rust summary boundary only. Phase 48
docs should name the exact command and status row, while keeping deferred
scope explicit.

**Warning signs:**

- Phrases like "remains unavailable until Phase 48" remain after Phase 48.
- Docs mention parser readiness during fixture-only phase.
- Package README, parity README, and `docs/port/parity-matrix.md` disagree.

**Phase to address:**
All phases, with final consistency check in Phase 48.

**Verification hooks:**

- Fixture verifier rejects stale "unavailable until Phase 48" wording after
  publication.
- `rg` checks exact token, command, fixture path, and deferred language across
  `packages/parity/README.md`, `packages/parity-fixtures/README.md`, fixture
  README, and `docs/port/*.md`.
- Milestone audit reruns `bazel run //packages/parity:status` and checks the
  printed row.

______________________________________________________________________

### Pitfall 11: Fixture Leaks Local Paths, Host Data, Or Unsafe Claims

**What goes wrong:**
The G-code fixture contains absolute local paths, usernames, host names,
network upload metadata, local removable-media paths, or comments implying the
file is safe to print on real hardware.

**Why it happens:**
G-code often embeds human-readable comments and can be affected by filename
templates, post-processing, host upload settings, and profile notes. A
maintainer-generated fixture can accidentally capture local environment data.

**How to avoid:**
Use a reviewed small fixture with no host upload and no post-processing.
Scan the fixture before check-in. Docs should say the fixture is evidence for
metadata/marker parsing only and is not printer-runtime validation or a
recommendation to print.

**Warning signs:**

- Fixture contains `/Users/`, `C:\`, home-directory paths, host URLs, API-like
  tokens, removable-media labels, or personal filenames.
- README says "safe to print" or "printer-compatible".
- Fixture provenance omits privacy/security review.

**Phase to address:**
Phase 46 fixture security scan; Phase 48 docs check.

**Verification hooks:**

- Fixture verifier rejects common absolute path patterns and host/network
  tokens.
- README requires "not printer-runtime validation" and "not a safe-to-print
  claim" wording.
- Security/UAT closeout confirms no local secrets or host metadata.

______________________________________________________________________

### Pitfall 12: Oversized Fixture Or Full-File Parser Makes Verification Slow

**What goes wrong:**
The fixture is too large, contains large embedded thumbnails, or the Rust
boundary scans the full G-code for many markers on every test. Bazel parity
becomes slow and maintainers stop running it locally.

**Why it happens:**
Generated outputs can be large, and G-code examples from real prints can
contain thousands or millions of lines. The milestone only needs one narrow
evidence path.

**How to avoid:**
Select the smallest reviewed Prusa-generated fixture that contains the chosen
stable metadata and markers. Keep the expected artifact short and exact. Avoid
running PrusaSlicer or doing full generated-output comparisons in Bazel.

**Warning signs:**

- Fixture exceeds the size needed for the marker contract.
- Expected summary grows with layer count or movement count.
- Tests rely on external tools, upstream builds, or slow decompression.

**Phase to address:**
Phase 45 sets size expectations. Phase 46 enforces fixture size and summary
row count. Phase 47 keeps parser scope short.

**Verification hooks:**

- Provenance records byte count and line count.
- Fixture verifier enforces an approved maximum size and exact expected-summary
  row count.
- Rust unit tests parse the expected summary, not the full G-code, unless
  Phase 45 explicitly approves a tiny marker scan.

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Diff the full G-code file | Fast to write a comparator | Overclaims byte-for-byte output and creates brittle noise | Never for v1.12 |
| Use a locally generated fixture without full provenance | Quick fixture intake | Future maintainers cannot reproduce or trust the evidence | Never |
| Reuse `export-workflows/expected-gcode.txt` | Avoids new fixture namespace | Converts base Rust export evidence into false Prusa evidence | Never |
| Let expected-summary rows be free-form strings | Minimal parser work | Unsupported semantic claims pass silently | Only in Phase 45 planning text, not in checked artifacts |
| Add one broad `generated-outputs verified` status row | Looks like visible progress | Misrepresents the evidence and breaks the parity matrix | Never |
| Parse arbitrary G-code commands in Rust | Feels closer to real support | Starts a general parser/runtime surface without requirements | Defer to a dedicated generated-output milestone |
| Skip mutation failure tests | Saves time | Parity command may be fail-open | Never once Phase 48 claims verified evidence |

## Integration Gotchas

Common mistakes when connecting the new slice to the existing repo.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Phase 45 scope package | Let fixture work start before source, expected summary columns, and status token are reviewed | Lock source identity, fixture decision, expected artifact contract, status token, docs touched, exclusions, and reviewer signoff first |
| `packages/parity-fixtures` | Put Prusa G-code evidence beside base export fixtures or omit `.gitattributes`/line-ending policy | Use a new fork namespace with provenance TSV, expected summary, README, checksum, line-ending policy, and fixture verifier |
| Rust `slic3r_flavors` | Add a general G-code parser or file discovery | Add a pure `prusa_gcode_output` summary boundary over the checked expected artifact |
| Bazel runfiles | Pass the same expected artifact as both "actual input" and "expected" without a meaningful drift check | Wire explicit summary binary, fixture/summary inputs, expected artifact, provenance, and status file; mutation test proves mismatches fail |
| `packages/parity/status.tsv` | Promote `generated-outputs` or add duplicate fork rows | Add one exact fork row only after Phase 48 evidence passes |
| `docs/port` | Describe broad generated-output support because G-code is user-visible | Say "one summary-only Prusa G-code metadata/marker fixture" and list deferred surfaces |
| Existing Prusa inventory | Treat `arc-fitting`, `wall-seam`, or `support-generation` rows as completed | Reference them only as deferred generated-output candidates that need future evidence |

## Performance Traps

Patterns that work at small scale but fail as evidence grows.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Full-file G-code comparison | Diffs are huge and unstable | Summary-only expected artifact | First fixture with timestamps, thumbnails, or profile drift |
| Large real-print fixture | Slow Bazel tests and noisy reviews | Pick the smallest reviewed fixture with stable markers | When the fixture moves from KB to MB without adding evidence value |
| Thumbnail/image validation | Pulls image tooling into parity fixture checks | Exclude thumbnails or verify marker presence only | As soon as PNG/QOI decoding is required |
| Running PrusaSlicer in the parity command | Requires external binary, profiles, GUI/runtime assumptions | Check in reviewed fixture and expected summary | Immediately in clean CI/Bazel environments |
| Broad Rust command parser | Unit tests multiply with every command family | Closed enum vocabulary for selected markers only | Once a second command family is added without a new scope record |

## Security Mistakes

Domain-specific security and safety issues beyond generic repo hygiene.

| Mistake | Risk | Prevention |
|---------|------|------------|
| Committing local path or username comments | Privacy leak and non-reproducible fixture | Scan G-code for absolute path patterns and personal filenames |
| Including host upload metadata | Implies network/device support and may leak host data | Require file-export-only provenance and reject host/upload markers |
| Running post-processing scripts in verification | Executes arbitrary local code and changes evidence meaning | Post-processing is deferred; fixture verifier requires `post_processing=none` |
| Treating fixture as safe-to-print | Could imply printer-runtime validation that does not exist | Docs must say no printer-runtime, firmware, or safe-print claim |
| Pulling live upstream fixture bytes during verification | Network dependency and supply-chain drift | Check fixture bytes in with checksum and manual update route |
| Adding binary G-code conversion tooling | Introduces new binary parsing/compression attack surface | Exclude `.bgcode` and conversion until a dedicated milestone |

## UX Pitfalls

Here "UX" means maintainer and reviewer experience for the evidence path.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Command output says only `ok` | Maintainers cannot see what evidence passed | Print token, source ref, fixture path, expected artifact, and row count |
| Docs hide deferred scope | Reviewers infer broad support | Put verified slice and deferred surfaces in the same paragraph |
| Mismatch errors do not name the marker | Mutation failures are hard to debug | Report first mismatch label and include `diff -u` output |
| Phase docs use stale tense | Roadmap consumers cannot tell fixture-only vs verified | Phase 46 says fixture-only; Phase 48 says executable evidence |
| Status row is too long but vague | Users cannot map command to claim | Keep one exact row with command and narrow evidence wording |

## "Looks Done But Isn't" Checklist

- [ ] **Scope gate:** Looks complete with a source ref, but missing generator
  command/profile context, post-processing exclusion, status token, or reviewer
  signoff.
- [ ] **Fixture:** Looks checked in, but checksum, byte count, line endings,
  privacy scan, and update route are not verified.
- [ ] **Expected summary:** Looks stable, but rows encode geometry/runtime
  semantics or allow arbitrary notes.
- [ ] **Rust parser:** Looks typed, but public names or enums imply general
  G-code parsing, support generation, wall seam, arc fitting, or runtime
  support.
- [ ] **Bazel command:** Looks runnable, but no mutation failure test proves it
  fails on drift.
- [ ] **Status row:** Looks published, but broad `generated-outputs` status or
  docs overclaim beyond the single fixture.
- [ ] **Docs:** Looks updated, but fixture README, parity README, and
  `docs/port/parity-matrix.md` disagree on what is verified.

## Recovery Strategies

When pitfalls occur despite prevention, how to recover.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Byte-for-byte overclaim | MEDIUM | Rename artifacts to summary-only, replace full-file expected output with TSV summary, add negative docs/status checks |
| Weak fixture provenance | HIGH | Remove verified claim, create Phase 45 scope record, regenerate or reselect fixture with full provenance, re-run verifier |
| Binary/post-processed fixture selected accidentally | MEDIUM | Replace fixture with ASCII file-export sample or explicitly defer binary/post-processing; update checks and docs |
| Rust parser too broad | MEDIUM | Split pure summary parser from any broader parser, remove unsupported public API names, add overclaim tests |
| Fail-open parity command | MEDIUM | Add meaningful mutation guard, exact status row check, duplicate-row check, and diff diagnostics before status publication |
| Docs/status drift | LOW | Patch exact rows and docs, then add verifier checks so stale wording fails next time |
| Local data leak in fixture | HIGH | Remove fixture, rotate any exposed secret if relevant, reselect fixture, add scanner guard |

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Byte-for-byte G-code overclaim | Phase 45, Phase 46, Phase 48 | Scope record says summary-only; expected summary has deferred semantics; status/docs exact row does not promote broad generated outputs |
| Unreviewed fixture provenance | Phase 45, Phase 46 | Exact provenance TSV, checksum/bytes/line-ending checks, reviewer signoff, manual update route |
| Binary G-code and thumbnail leakage | Phase 45, Phase 46 | Fixture verifier rejects `.bgcode`/NUL bytes and image decoding scope unless explicitly approved |
| Post-processing and host upload effects | Phase 45, Phase 46 | Provenance requires file export and `post_processing=none`; fixture scan rejects host markers |
| Semantic expected-summary rows | Phase 46, Phase 47 | Closed evidence-kind enums and tests reject unsupported semantic claims |
| Base export fixture reuse | Phase 46 | Namespace and marker scan reject `export-workflows` and `generated_by=rust_cli` |
| General G-code parser creep | Phase 47 | Pure parser tests, source scan for side effects, public surface-name overclaim test |
| Fail-open Bazel parity command | Phase 48 | Public parity command plus mutation failure test with `--cache_test_results=no` in audit |
| Status vocabulary drift | Phase 45, Phase 48 | Exact status row, duplicate check, broad-row negative check |
| Docs drift | Phase 46, Phase 47, Phase 48 | README and `docs/port` checks for phase-appropriate tense and deferred scope |
| Local path or host data leak | Phase 46, Phase 48 | Fixture scan and docs safety wording |
| Oversized fixture or slow parser | Phase 45, Phase 46, Phase 47 | Max fixture size, row-count guard, no external PrusaSlicer invocation |

## Phase-Specific Warning Signs

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|----------------|------------|
| Phase 45 scope gate | Scope says "G-code output parity" instead of "one summary-only fixture" | Require exact deferred-scope list and reviewed status token before fixture work |
| Phase 46 fixture surface | Fixture is local, binary, post-processed, too large, or under the base export namespace | Require provenance, ASCII/text policy, checksum, namespace isolation, and size/line checks |
| Phase 47 Rust boundary | Parser supports arbitrary G-code commands or file discovery | Keep core input as expected-summary text and model rows as enums/newtypes |
| Phase 48 executable evidence | Status row lands without mutation guard or docs consistency | Gate publication on parity command, failure test, exact row check, and docs scan |

## Sources

Local project sources, HIGH confidence:

- `AGENTS.md`, `AGENTS.bright-builds.md`, and `standards-overrides.md`
- `.planning/PROJECT.md`, `.planning/MILESTONES.md`,
  `.planning/RETROSPECTIVE.md`
- `.planning/milestones/v1.10-MILESTONE-AUDIT.md`
- `.planning/milestones/v1.11-MILESTONE-AUDIT.md`
- `packages/parity/README.md`
- `packages/parity/status.tsv`
- `packages/parity/BUILD.bazel`
- `packages/parity-fixtures/BUILD.bazel`
- `packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/*`
- `packages/prusa-project-file-scope/*`
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs`
- `docs/port/parity-matrix.md`
- `packages/fork-inventories/prusaslicer.tsv`

Canonical standards, HIGH confidence:

- Bright Builds architecture standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/architecture.md`
- Bright Builds verification standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/verification.md`
- Bright Builds testing standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/core/testing.md`
- Bright Builds Rust standard:
  `https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/main/standards/languages/rust.md`

Official Prusa sources, MEDIUM confidence for general G-code scope risks:

- Binary G-code:
  `https://help.prusa3d.com/article/binary-g-code_646763`
- Model preview / thumbnails:
  `https://help.prusa3d.com/article/model-preview_648687`
- Post-processing scripts:
  `https://help.prusa3d.com/article/post-processing-scripts_283913?product=prusaslicer`
- Placeholder/macro behavior:
  `https://help.prusa3d.com/article/macros_1775`
- Prusa firmware-specific G-code commands:
  `https://help.prusa3d.com/article/prusa-firmware-specific-g-code-commands_112173?product=prusaslicer`
- PrusaSlicer CLI wiki:
  `https://github.com/prusa3d/PrusaSlicer/wiki/Command-Line-Interface`

______________________________________________________________________

*Pitfalls research for: v1.12 PrusaSlicer G-code output evidence foundation*
*Researched: 2026-06-06*
