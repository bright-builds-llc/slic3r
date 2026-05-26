# Phase 32: Vendor Source Manifest and License Baseline - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution
> agents. Decisions are captured in `32-CONTEXT.md` - this log preserves the
> alternatives considered.

**Date:** 2026-05-26T16:14:55.811Z
**Phase:** 32 - Vendor Source Manifest and License Baseline
**Mode:** Yolo
**Areas discussed:** Manifest Shape and Location, Git-Ref Verification
Strategy, License and Provenance Vocabulary, Refresh and Drift Policy

---

## Manifest Shape and Location

| Option | Description | Selected |
|--------|-------------|----------|
| New `packages/fork-vendors/forks.tsv`, one row per fork | Clean owner for vendor-source intake, mirrors `packages/parity/status.tsv`, easy Bazel shell verification, avoids vendored source trees | yes |
| New `packages/fork-vendors/vendor-sources.toml`, one table per fork | Self-describing and better for arrays, but requires a parser or brittle shell parsing | |
| `docs/port/forks/vendor-sources.md` as the primary registry | Most readable, but machine validation is fragile | |
| `packages/parity/vendor-sources.tsv` inside the existing parity package | Reuses existing package, but conflates vendor intake with executable parity evidence | |

**User's choice:** Auto-selected the new `packages/fork-vendors/forks.tsv`
package and one-row-per-fork TSV registry.
**Notes:** This matches the existing checked-in TSV pattern while keeping source
intake separate from parity status.

---

## Git-Ref Verification Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Bazel shell target using `git ls-remote` | No clone, no new dependencies, uses native peeled-tag output, fits existing shell target pattern | yes |
| GitHub REST refs/tags API verifier | Structured JSON, but GitHub-specific and likely needs JSON tooling or credentials for richer use | |
| Temporary shallow/blobless fetch of exact tag | Stronger object semantics, but closer to cloning and broader than Phase 32 needs | |

**User's choice:** Auto-selected a Bazel-owned shell target that uses
`git ls-remote`.
**Notes:** The verifier should fail for selected tag or peeled commit mismatch
and report default branch movement as drift-only.

---

## License and Provenance Vocabulary

| Option | Description | Selected |
|--------|-------------|----------|
| Freeform per-fork license notes | Fast and readable, but hard to validate and easy to overclaim | |
| Structured observed-provenance fields | SPDX field plus separate license source, attribution, lineage, caution flags, scope note, and non-legal-review marker | yes |
| SPDX/SBOM-style package records | Standards-aligned, but overkill and may imply formal compliance tooling or vendored source ingestion | |

**User's choice:** Auto-selected structured observed-provenance fields.
**Notes:** Use current SPDX identifiers where supported by upstream statements,
and keep non-free/network cautions outside the license expression.

---

## Refresh and Drift Policy

| Option | Description | Selected |
|--------|-------------|----------|
| Single registry with separated evidence fields | One source satisfies VEND-01, keeps stable tag and peeled commit as accepted baseline, records branch head as drift-only | yes |
| Split baseline registry and drift snapshot | Strong physical separation, but introduces join validation and stale/orphaned row risk | |
| Compute branch drift only at verification time | Smallest registry, but does not satisfy the checked-in observed branch head and capture date requirement | |

**User's choice:** Auto-selected a single registry with separated evidence
fields.
**Notes:** Phase 32 records the baseline and refresh command; Phase 36 owns
the fuller drift-refresh protocol template.

---

## the agent's Discretion

- Exact shell helper layout under `packages/fork-vendors`.
- Exact TSV column names, provided all VEND-01 and VEND-03 fields are present
  and validation remains straightforward.
- Whether branch-head drift reports as a warning in the same verifier or as a
  separate informational command.

## Deferred Ideas

- Formal SBOM or compliance tooling.
- Signed tag verification or object-level tag audit.
- Full drift-refresh protocol templates.
- Runtime fork parity, fork release builds, GUI migration, cloud/network
  integrations, and non-free plugin ingestion.
