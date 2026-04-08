---
phase: 03
slug: rust-workspace
status: ready
nyquist_compliant: true
wave_0_complete: true
created: 2026-04-08
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Bazel plus `rules_rust` native Rust targets |
| **Config file** | `MODULE.bazel`, `packages/slic3r-rust/BUILD.bazel`, and crate-level `BUILD.bazel` files |
| **Quick run command** | `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust:verify` |
| **Full suite command** | `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust/...` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust:verify`
- **After every plan wave:** Run `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust/...`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | RUST-01 | T-03-01 / — | Pinned Rust toolchain and first crate build through Bazel | build | `.planning/.tmp/bin/bazelisk build //packages/slic3r-rust/...` | ❌ W0 | ⬜ pending |
| 03-01-02 | 01 | 1 | RUST-01 | T-03-02 / — | First real crate exists as a Bright Builds-aligned library | smoke | `.planning/.tmp/bin/bazelisk build //packages/slic3r-rust/crates/slic3r_core:slic3r_core` | ❌ W0 | ⬜ pending |
| 03-02-01 | 02 | 2 | RUST-02 | T-03-03 / — | Rust tests run through Bazel for the new package | unit | `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust:verify` | ❌ W0 | ⬜ pending |
| 03-02-02 | 02 | 2 | RUST-02 | T-03-04 / — | Rust fmt/lint/test surfaces are Bazel-native rather than shell wrappers | lint/format | `.planning/.tmp/bin/bazelisk test //packages/slic3r-rust/...` | ❌ W0 | ⬜ pending |
| 03-03-01 | 03 | 3 | RUST-01 | T-03-05 / — | Contributors can discover the Rust package and commands from docs | doc check | `rg -n "//packages/slic3r-rust:verify|rules_rust|Bazelisk" packages/slic3r-rust/README.md docs/port/*.md` | ❌ W0 | ⬜ pending |
| 03-03-02 | 03 | 3 | RUST-02 | T-03-06 / — | Migration docs reflect the real Rust workspace and verification state | doc check | `mdformat --check packages/slic3r-rust/README.md docs/port/*.md` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `packages/slic3r-rust/crates/slic3r_core/BUILD.bazel` — first real crate target surface
- [ ] `packages/slic3r-rust/crates/slic3r_core/Cargo.toml` — first workspace member manifest
- [ ] `packages/slic3r-rust/crates/slic3r_core/src/lib.rs` — first library entry point
- [ ] `packages/slic3r-rust/crates/slic3r_core/tests/smoke.rs` — smoke test fixture
- [ ] `packages/slic3r-rust/BUILD.bazel` verify suite updates
- [ ] `rules_rust` and toolchain registration in `MODULE.bazel`

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Contributor can understand the Rust workspace structure quickly | RUST-01 | Readability/discoverability is partly subjective | Read `packages/slic3r-rust/README.md` and `docs/port/package-map.md`; confirm the package role and verify command are obvious |

---

## Validation Sign-Off

- [x] All tasks have `<verify>` coverage or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all missing references
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-04-08
