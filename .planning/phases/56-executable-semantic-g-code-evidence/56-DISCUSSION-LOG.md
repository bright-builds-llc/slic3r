# Phase 56: Executable Semantic G-code Evidence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md - this log preserves the alternatives considered.

**Date:** 2026-06-21T16:55:00Z
**Phase:** 56-Executable Semantic G-code Evidence
**Mode:** Yolo
**Areas discussed:** Public command integration, Semantic mutation guards, Status publication, Documentation publication, Verification and phase closeout

---

## Public Command Integration

| Option | Description | Selected |
|--------|-------------|----------|
| Extend existing command | Keep `//packages/parity:prusaslicer_gcode_output_parity` and add semantic validation to the same public path. | yes |
| Add companion command | Create a separate semantic command while preserving the existing structural command. | |
| Delay public semantic mode | Keep semantic readiness internal and leave public parity structural-only. | |

**User's choice:** Auto-selected recommended option: extend existing command.
**Notes:** The roadmap and Phase 55 readiness metadata already name the existing public command as the planned Phase 56 path.

---

## Semantic Mutation Guards

| Option | Description | Selected |
|--------|-------------|----------|
| Focused field drift guards | Add one temp-artifact mutation per required semantic drift class. | yes |
| Broad fixture rewrite guard | Compare the whole semantic artifact only and rely on diff output. | |
| Parser-only coverage | Rely on existing Rust semantic parser tests without public command mutation coverage. | |

**User's choice:** Auto-selected recommended option: focused field drift guards.
**Notes:** Roadmap success criteria explicitly names movement class, coordinate-bound, extrusion-total, feedrate observation, fixture identity, and unsupported deferred-behavior drift.

---

## Status Publication

| Option | Description | Selected |
|--------|-------------|----------|
| Narrow semantic wording | Update only `fork.prusaslicer.gcode-output` wording to semantic evidence while keeping `generated-outputs` in progress. | yes |
| Promote generated outputs | Mark broad `generated-outputs` verified after semantic G-code evidence. | |
| Leave status structural-only | Avoid status wording changes despite new public semantic evidence. | |

**User's choice:** Auto-selected recommended option: narrow semantic wording.
**Notes:** The milestone requires exact semantic slice publication and explicitly forbids broad generated-output promotion.

---

## Documentation Publication

| Option | Description | Selected |
|--------|-------------|----------|
| Update parity, scope, fixture, and port docs narrowly | Publish semantic evidence only where the public command/status boundary is documented. | yes |
| Rewrite generated-output docs broadly | Recast the full generated-output migration story around semantic evidence. | |
| Package docs only | Update package docs and leave port docs structural-only. | |

**User's choice:** Auto-selected recommended option: narrow docs across package/scope/port surfaces.
**Notes:** Phase 56 owns both package docs and public port docs, but only for the exact `fork.prusaslicer.gcode-output` semantic slice.

---

## Verification and Phase Closeout

| Option | Description | Selected |
|--------|-------------|----------|
| Run focused parity, verifier, Rust, and doc checks | Verify the public command path, mutation guards, scope/fixture verifiers, Rust checks, summaries, and diff hygiene. | yes |
| Run only the public parity command | Exercise the new command without mutation or docs verification. | |
| Defer heavy checks to CI | Land docs/code with local spot checks only. | |

**User's choice:** Auto-selected recommended option: run focused parity, verifier, Rust, and doc checks.
**Notes:** Rust-touching work must honor repo pre-commit requirements, and the wrapper may push only after clean phase verification.

---

## the agent's Discretion

- Exact helper names and printed semantic summary-line field names are left to implementation, provided they remain narrow and diagnostics identify the failing semantic field.
- The five roadmap plans may be adjusted internally as long as the command, mutation, status, package/scope docs, and port-doc surfaces remain reviewable.

## Deferred Ideas

- Byte-for-byte G-code parity, broad generated-output verification, support generation, seam behavior, arc fitting, STEP import, GUI behavior, release behavior, sync automation, and non-Prusa fork behavior remain future planning topics.
