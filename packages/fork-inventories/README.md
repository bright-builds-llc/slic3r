# Fork Feature Inventories

`packages/fork-inventories` owns the Phase 33 source-pinned feature inventory
templates and per-fork inventory TSVs for PrusaSlicer, Bambu Studio, and
OrcaSlicer.

Run the verifier with:

```bash
bazel run //packages/fork-inventories:verify
```

Inventories are source-observed planning inputs only. They do not prove executable parity, user-facing behavior, GUI support, fork release builds, or support for non-free/network plugins.

Selected stable tags and peeled commits from `packages/fork-vendors/forks.tsv`
are the only accepted row source refs. Branch heads in that registry are
drift-only observations and are not valid inventory anchors.

## Inventory TSV Contract

`inventory-template.tsv`, `prusaslicer.tsv`, `bambustudio.tsv`, and
`orcaslicer.tsv` use this exact 12-column header:

```text
# inventory_id	vendor_id	source_ref	source_paths	feature_surface	feature_category	ownership	complexity	parity_dependency	v1_9_decision	caution_flags	future_parity_notes
```

Inventory files use literal tabs, LF row endings, no blank required fields, and
semicolon-delimited multi-value fields with no spaces around semicolons.

Accepted `source_ref` values are derived from `packages/fork-vendors/forks.tsv`
as `<vendor_id>:<selected_stable_tag>@<peeled_commit_sha>`.

## Enums

`ownership` values:

- `base-slic3r`
- `shared-downstream`
- `fork-specific`
- `unknown-needs-review`

`complexity` values:

- `none`
- `low`
- `medium`
- `high`
- `unknown-needs-review`

`v1_9_decision` values:

- `future-candidate`
- `deferred`
- `no-action-base`
- `needs-review`

`caution_flags` is `none` or a semicolon-delimited list of:

- `network-scope`
- `cloud-scope`
- `credential-scope`
- `non-free-plugin-scope`
- `license-provenance`
- `runtime-parity-not-verified`

`parity_dependency` is `none` or a semicolon-delimited list of surface values
from column 1 of `packages/parity/status.tsv`.

## Category Map Contract

`category-map.tsv` uses this exact 6-column header:

```text
# map_id	feature_category	ownership	v1_9_decision	inventory_ids	notes
```

Every inventory row ID from the per-fork TSVs must appear in exactly one
`inventory_ids` list. Deferred rows stay separate from future implementation
candidate rows.

## Scope

This package records maintainer planning data only. Rows with network, cloud,
credential, or non-free plugin cautions are deferred metadata and do not create
online integration, credential handling, device communication, plugin ingestion,
or runtime fork support in v1.9.
