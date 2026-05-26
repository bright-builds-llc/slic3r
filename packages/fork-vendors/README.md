# Fork Vendor Source Registry

`packages/fork-vendors` owns the Phase 32 vendor-source intake baseline for
PrusaSlicer, Bambu Studio, and OrcaSlicer.

Run the verifier with:

```bash
bazel run //packages/fork-vendors:verify
```

The verifier checks the selected stable tag ref and peeled commit recorded in
`forks.tsv` by using `git ls-remote`. It does not clone, fetch, build, vendor,
or import upstream fork source trees. Source pins, inventories, license
metadata, and branch observations are intake evidence only; they do not mark fork parity as verified.

## Registry Format

`forks.tsv` is a fixed-column registry. It uses:

- a literal tab as the field delimiter
- LF as the row delimiter
- semicolon with no surrounding spaces for multi-value fields
- `-` for an empty optional scalar

Fields must not contain literal tabs or newlines.

The `refresh_command` column is display-only. It is provided as a maintainer
inspection aid and is not executed by `verify_forks.sh`.

## Scope

Phase 32 is intake metadata only. The registry records source pins, observed
branch heads, lineage, source path hints, SPDX identifiers, license sources,
attribution notes, provenance notes, and caution flags. The
`metadata-only-not-legal-review` provenance note is intentional: this package is
not legal review, not a full drift-refresh protocol, and not verified fork
parity.

Branch heads are drift-only observations. Selected stable tags and peeled
commits are the accepted source baseline.

Non-free and network-plugin cautions are kept separate from SPDX license
identifiers. Rows with `do-not-ingest-plugin-code-or-credentials` caution future
work against importing plugin code, credentials, or network/cloud integrations
from upstream forks. These cautions do not create runtime fork support, online
integration support, or non-free plugin ingestion scope.
