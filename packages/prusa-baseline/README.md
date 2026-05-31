# Prusa Baseline and Checklist Gate

`packages/prusa-baseline` owns the Phase 37 review-gated Prusa baseline and
checklist records for the narrow v1.10 Prusa profile schema/config evidence
slice.

Run the package verifier with:

```bash
bazel run //packages/prusa-baseline:verify
```

Phase 37 verification does not prove Prusa runtime support.
Phase 37 verification does not prove executable fork parity.
source pins, inventories, checklist records, and Prusa baseline records are
planning inputs only.
future executable parity evidence required.

This package creates no Prusa fixture files, fork parity status rows,
executable Prusa parity targets, upstream source imports, vendored fork source
trees, automatic sync, runtime fork support, GUI support, network/device
integration, profile auto-update execution, or fork release packaging.

## Records

- [`drift-refresh-record.md`](drift-refresh-record.md) records the accepted
  PrusaSlicer source baseline and the Phase 37 maintainer drift-review fields.
- [`profile-schema-checklist.md`](profile-schema-checklist.md) records the
  completed checklist gate for `prusaslicer.profile-schema`.

## Source Inputs

- [`packages/fork-vendors/forks.tsv`](../fork-vendors/forks.tsv) is the source
  of the accepted PrusaSlicer tag and peeled commit.
- [`packages/fork-inventories/prusaslicer.tsv`](../fork-inventories/prusaslicer.tsv)
  is the source of the `prusaslicer.profile-schema` inventory row.
- [`docs/port/README.md`](../../docs/port/README.md) is the port control-plane
  entrypoint for current fork and Prusa milestone state.

## Boundary

The accepted Phase 37 source pin is
`prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.
Branch-head data is drift-only observation, and accepted source pins remain
unchanged unless a future reviewed intake update modifies
`packages/fork-vendors/forks.tsv`.

The selected checklist row is `prusaslicer.profile-schema`, which points at
`resources/profiles/PrusaResearch.ini` and remains a planning input until later
fixtures, Rust parsing, and executable parity evidence exist.
