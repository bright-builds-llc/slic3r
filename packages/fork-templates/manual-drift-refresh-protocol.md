# Manual Drift-Refresh Protocol

Use this runbook before any later fork parity milestone begins. The protocol is
manual and review-gated. It records observations for maintainers; it does not
update accepted source pins automatically.

## Procedure

1. Run the existing vendor verifier:

   ```bash
   bazel run //packages/fork-vendors:verify
   ```

1. Record each selected stable tag confirmation from the verifier output.

1. Record each peeled commit confirmation for the selected stable tag.

1. Record branch-head warnings as drift-only observations.

1. Ask a reviewer to decide whether any observed drift needs a future intake
   update before fork parity implementation starts.

1. Keep accepted source pins unchanged unless a future reviewed intake change
   updates `packages/fork-vendors/forks.tsv`.

## Required Distinction

Selected stable tag values and peeled commit values are the accepted source
baseline. Branch heads are observations of current upstream movement.
drift observations do not change accepted source pins by themselves.

## Prohibited Work

Do not clone upstream repositories, fetch worktrees, build upstream fork source
trees, import fork source files, vendor upstream fork source trees, schedule
nightly sync, update source refs automatically, or create an automatic source
refresh path in Phase 36.

## Reviewer Record

| Field | Maintainer Entry |
| --- | --- |
| Review date | UTC date |
| Vendor | `prusaslicer`, `bambustudio`, or `orcaslicer` |
| Selected stable tag | Tag confirmed by `bazel run //packages/fork-vendors:verify` |
| Peeled commit | Commit confirmed by the verifier |
| Branch drift observation | Warning text or `none observed` |
| Reviewer decision | `keep accepted source pin`, `plan future intake update`, or `defer` |
| Reviewer signoff | Reviewer name and date |
