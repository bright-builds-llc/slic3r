# Fork Templates

`packages/fork-templates` owns the Phase 36 maintainer templates for future
fork parity work. These files prepare reviews for later PrusaSlicer, Bambu
Studio, and OrcaSlicer parity milestones without adding fork runtime behavior.

Run the local template verifier with:

```bash
bazel run //packages/fork-templates:verify
```

template verification does not prove fork parity. It checks that required
template fields and boundary wording are present.
source pins and inventories are planning inputs only.
future executable parity evidence is required before future fork behavior can
be called verified.

do not add fork rows to packages/parity/status.tsv in v1.9. Future fork status
rows must point at real `//packages/parity:*_parity` evidence, not at this
package, source pins, or inventory rows.

## Templates

- [Fork parity checklist template](fork-parity-checklist-template.md) records
  required review fields before future fork work can move toward verified
  status.
- [Fork launcher-shape template](fork-launcher-shape-template.md) records
  future launcher intent while keeping fork-flavor release builds, signing,
  installers, and release channels deferred.
- [Manual drift-refresh protocol](manual-drift-refresh-protocol.md) describes
  the review-gated vendor drift check that maintainers should run before later
  fork parity milestones.

The central v1.9 deferral list lives in
[docs/port/README.md#v19-fork-parity-deferrals](../../docs/port/README.md#v19-fork-parity-deferrals).
Link to that block instead of repeating the complete scope list in every
future fork planning note.

## Boundary

This package must stay documentation and template verification only. It must
not clone, fetch, build, import, vendor, schedule sync, update source refs,
create fork fixture files, add launcher targets, or publish fork release
artifacts.
