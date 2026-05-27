# Fork Parity Checklist Template

Use this template before a future fork feature can be considered for verified
status. source pins and inventories are planning inputs only; future fork work
needs future executable parity evidence before any status row can move to
verified.

template verification does not prove fork parity.
Completing this checklist also does not prove fork parity; it prepares the
review package that a later executable `//packages/parity:*_parity` target must
support.

## Checklist

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `vendor.inventory-row` from `packages/fork-inventories/*.tsv` |
| Source pin | `vendor:selected_stable_tag@peeled_commit` from `packages/fork-vendors/forks.tsv` |
| Candidate Rust module | Shared Rust module or future fork-specific module path |
| Fixture need | Future fixture path or `none-yet` |
| Evidence command | Future `//packages/parity:*_parity` command or `deferred` |
| Docs touched | Docs that must move with the future implementation |
| License or security note | License, network, credential, cloud, or plugin caution |
| Deferred scope | Behavior excluded from the future verified slice |
| Reviewer signoff | Reviewer name and review date |

## Review Rules

1. Confirm the inventory row traces to the accepted source pin, not a branch
   drift observation.
2. Confirm the evidence command is a future executable parity command before
   any future status row is marked verified.
3. Keep network, cloud, credential, profile auto-update, and non-free plugin
   ingestion notes explicit when the inventory row touches those surfaces.
4. Do not add fork rows to packages/parity/status.tsv in v1.9.

## Future Evidence Notes

Future verified fork status requires executable parity evidence that can be
rerun by maintainers. A completed checklist may justify planning a parity
target, fixture namespace, and docs update, but it is not itself evidence.
