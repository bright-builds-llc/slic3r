# Fork Launcher-Shape Template

Use this template to describe future fork launcher intent without adding Phase
36 launcher targets, release builds, signing, installers, or release channels.
The full v1.9 deferral list lives in
[docs/port/README.md#v19-fork-parity-deferrals](../../docs/port/README.md#v19-fork-parity-deferrals).

## Launcher Intent

| Field | Maintainer Entry |
| --- | --- |
| Fork flavor | `prusaslicer`, `bambustudio`, `orcaslicer`, or later approved flavor |
| Inventory trace | Inventory row IDs that motivate this future launcher shape |
| Candidate entrypoint | Future launcher or command path, if known |
| Required parity evidence | Future `//packages/parity:*_parity` command required before support claims |
| Fixture expectation | Future fixture namespace, if launcher behavior needs fixtures |
| Deferred behavior | Explicit launcher, release, or integration behavior excluded from v1.9 |
| Reviewer signoff | Reviewer name and review date |

## Phase 36 Boundary

Phase 36 records launcher-shape planning only. It does not add fork launcher
targets, fork-flavor release builds, signing, notarization, installers, release
channels, GitHub Actions build matrices, runtime dispatch, GUI migration, cloud
integration, profile auto-update execution, or non-free plugin ingestion.

## Future Review Notes

Future launcher work must point back to the central deferral block and to real
fork parity evidence before any user-facing fork launcher or release behavior
is documented as supported.

