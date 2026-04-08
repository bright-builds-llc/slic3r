# Phase 09: Help and Usage Slice - Research

**Researched:** 2026-04-08
**Confidence:** HIGH

## Summary

The legacy `--help` contract is already explicit in `slic3r.pl`, and the first
Rust-backed slice is narrow enough that the safest implementation is to preserve
the legacy banner and usage heading while making the support boundary explicit in
the option list. The status surface should mark help as `rust-backed`, not
`verified`, until the next milestone adds fixtures for it.
