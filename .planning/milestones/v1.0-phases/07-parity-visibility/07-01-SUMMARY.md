# Phase 07: Parity Visibility Summary

**Plan 07-01:** a checked-in parity status command now exists under `packages/parity`.

## Verification

- `shfmt -l -d packages/parity/parity_status.sh`
- `./.planning/.tmp/bin/bazelisk run //packages/parity:status`
