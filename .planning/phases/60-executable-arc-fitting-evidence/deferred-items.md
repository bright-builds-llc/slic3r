# Deferred Items: Phase 60

## 60-03-shellcheck-peeled-commit | 2026-06-24

- **Found during:** Plan 60-03 Task 1 verification.
- **Scope:** Out of scope for status-row publication.
- **Issue:** `shellcheck packages/parity-fixtures/verify_prusa_arc_fitting_fixture.sh` reports pre-existing `SC2034` for the unused `PEELED_COMMIT` constant.
- **Reason deferred:** The warning predates this plan and is unrelated to the exact arc-fitting status row and verifier mutation coverage.
- **Suggested follow-up:** Either use the constant in provenance validation or remove it in a focused cleanup plan.
