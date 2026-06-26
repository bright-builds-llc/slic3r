# Project Research - Pitfalls

**Project:** Slic3r Rust Port
**Milestone:** v1.16 PrusaSlicer Wall-Seam G-code Evidence Slice
**Researched:** 2026-06-26
**Confidence:** HIGH because the risks match prior generated-output evidence
milestones.

## Critical Pitfalls

### Overclaiming Wall-Seam Evidence

Wall-seam observations can prove only the checked-in summary evidence slice.
They do not prove byte-for-byte G-code parity, broad generated-output parity,
seam geometry equivalence, seam visibility, printability, firmware behavior,
printer-runtime behavior, GUI behavior, release behavior, upstream imports,
sync automation, Bambu Studio, or OrcaSlicer.

**Prevention:** Phase 62 must define forbidden wording, and all verifiers must
reject unsupported broad claims.

### Widening Existing Public Rows

The existing `fork.prusaslicer.gcode-output` row is semantic G-code evidence,
and `fork.prusaslicer.arc-fitting` is arc summary evidence. Wall seam needs its
own status row.

**Prevention:** Phase 65 should verify exact rows for all three Prusa
generated-output slices and keep `generated-outputs` exactly `in progress`.

### Choosing The Wrong Source Row

The relevant inventory row is `prusaslicer.wall-seam`, and the category-map row
is `seam.shared`. Generic Slic3r seam tests can help orient fixture design but
do not replace the accepted PrusaSlicer source identity.

**Prevention:** Scope and fixture verifiers should check exact inventory,
category-map, source identity, source path, and fixture identity values.

### Weak Fixture Evidence

A fixture that does not exercise seam transitions can pass mechanically while
proving the wrong thing. A fixture that exercises too much can accidentally
claim geometry or printability.

**Prevention:** Phase 62 must approve field names before Phase 63 checks in
fixtures. Phase 63 should include positive seam observations and explicit
evidence-boundary text.

### Loose TSV Parsing

Arbitrary key-value parsing would let unknown fields become evidence. Row order
and duplicate rows matter because the checked-in summary is the contract.

**Prevention:** Phase 64 should parse into closed Rust domain types and reject
unknown fields, missing rows, duplicate rows, row-order drift, wrong source or
fixture identities, and broad claim text.

### Shell Owning Business Logic

Bash verifiers are good at exact file, path, and mutation orchestration, but
they should not become the seam-domain parser.

**Prevention:** Keep seam field validation and summary parsing in Rust. Keep
Bash thin around runfiles, temp copies, diffs, and exact public text checks.

### Premature Live Generation

Running PrusaSlicer, cloning upstream, or generating new G-code would expand
the milestone into runtime and sync behavior.

**Prevention:** Verifiers should operate only on checked-in artifacts and
caller-supplied local files.

### Ledger Drift At Archive

v1.15 needed a metadata-only gap closure phase after requirements traceability
drifted from verified artifacts.

**Prevention:** Keep `.planning/REQUIREMENTS.md` checkboxes, traceability, and
phase summary `requirements-completed` metadata aligned as each phase
completes.
