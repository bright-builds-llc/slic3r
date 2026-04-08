# Phase 02: Legacy Oracle - Verification

**Verified:** 2026-04-07
**Status:** passed
**Phase Goal:** Keep the legacy implementation buildable, testable, and visibly reference-only under the new Bazel monorepo shape.

## Must-Haves Checked

### Observable Truths

- ✓ Maintainer can build the retained legacy package from Bazel on macOS.
- ✓ Maintainer can run a trusted retained legacy oracle check from Bazel on macOS.
- ✓ Contributors can tell from the repo layout and docs that the legacy package is preserved for reference, not preferred for new feature work.

### Supporting Artifacts

- ✓ `tools/bazel/legacy/check_legacy_prereqs.sh`, `build_legacy_oracle.sh`, `test_legacy_smoke.sh`, and `test_legacy_oracle.sh`
- ✓ Stable root and package-level legacy oracle labels in `BUILD.bazel`, `packages/BUILD.bazel`, and `packages/legacy-slic3r/BUILD.bazel`
- ✓ `packages/legacy-slic3r/README.md`
- ✓ `docs/port/README.md`, `docs/port/checklist.md`, `docs/port/package-map.md`, and `docs/port/parity-matrix.md`

### Key Links

- ✓ `//:legacy_oracle_build` reaches the retained legacy build wrapper through Bazel
- ✓ `//:legacy_oracle_smoke` is the current trusted macOS oracle check
- ✓ The package README and `docs/port/` describe the same reference-only oracle boundary and prerequisite model

## Evidence

- `.planning/.tmp/bin/bazelisk run //:legacy_oracle_prereqs` passed
- The retained XS bundle exists at `packages/legacy-slic3r/xs/blib/arch/auto/Slic3r/XS/XS.bundle`
- `.planning/.tmp/bin/bazelisk run //:legacy_oracle_smoke` exited `0`
- The Legacy Oracle docs explicitly distinguish the trusted smoke path from the deferred broader retained test wrapper

## Notes

- `//:legacy_oracle_test` is intentionally documented as a deferred broader retained test surface, not part of the trusted Phase 2 oracle set
- Phase 2 therefore passes with a deliberately narrow trusted oracle surface on macOS rather than historical test breadth

## Gaps

None.

---

*Phase: 02-legacy-oracle*
*Verification completed: 2026-04-07*
