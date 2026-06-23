# Prusa Arc-Fitting Scope Contract

`packages/prusa-arc-fitting-scope` owns the Phase 57 reviewed scope contract for `prusaslicer.arc-fitting`.

Run `bazel run //packages/prusa-arc-fitting-scope:verify` to check the
reviewed Phase 57 arc-fitting scope contract.

Phase 57 records the accepted source identity, inventory row, source anchors,
planned fixture namespace, planned expected arc summary, planned Rust boundary,
planned public evidence command, planned status wording, security note,
deferred generated-output scope, and reviewer signoff for the narrow
`prusaslicer.arc-fitting` evidence slice.

Phase 57 creates no fixture bytes, expected arc summary, Rust parser, public
parity command, verified `fork.prusaslicer.arc-fitting` status row, upstream
source import, network/device behavior, printer-runtime behavior, GUI
behavior, Bambu Studio support, OrcaSlicer support, or release artifact.

The existing `fork.prusaslicer.gcode-output` status row remains limited to the
Phase 53 through Phase 56 semantic Prusa G-code evidence slice. Broad
`generated-outputs` remains `in progress`.

## Records

- [`arc-fitting-scope.md`](arc-fitting-scope.md) records the Phase 57
  maintainer scope contract, approved arc evidence field list, traceability,
  planned status wording, security note, and deferred scope for
  `prusaslicer.arc-fitting`.

## Boundary

This package is metadata and verifier owned. It creates no generated-output
fixture corpus, executable Rust parser, public parity target, status
publication, runtime behavior, printability evidence, upstream source import,
or external integration.
