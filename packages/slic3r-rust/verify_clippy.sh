#!/usr/bin/env bash
set -euo pipefail

# If this test is running, Bazel has already built the `clippy` data dependency.
# A clippy failure would stop this test from launching, so reaching here is success.
exit 0
