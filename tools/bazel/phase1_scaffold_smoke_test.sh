#!/usr/bin/env bash
set -euo pipefail

repo_root="${TEST_SRCDIR}/${TEST_WORKSPACE}"

test -f "${repo_root}/MODULE.bazel"
test -f "${repo_root}/.bazelversion"
test -f "${repo_root}/.bazelrc"
test -f "${repo_root}/packages/BUILD.bazel"
test -f "${repo_root}/packages/slic3r-rust/Cargo.toml"
