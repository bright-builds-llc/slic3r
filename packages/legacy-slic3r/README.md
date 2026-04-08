# Legacy Reference Package

This package contains the retained legacy Slic3r implementation.

It is the behavioral oracle for the Rust port and should be treated as the reference package during the migration. New feature work targets the Rust implementation unless a change is explicitly needed to keep this legacy package buildable, testable, and parity-preserving.

The code here is intentionally visible rather than hidden so contributors can compare behavior, contracts, and package boundaries directly. Treat structural integration changes cautiously and avoid cleanup work here unless it is necessary to preserve the oracle role.

## Bazel Oracle Surface

Phase 2 adds Bazel-facing oracle entrypoints for the retained legacy package on macOS:

- `//:legacy_oracle_prereqs` checks the documented prerequisite set
- `//:legacy_oracle_build` drives the retained legacy oracle build path
- `//:legacy_oracle_smoke` is the current trusted macOS oracle check
- `//:legacy_oracle_test` is exposed, but currently treated as a deferred broader legacy surface rather than the trusted oracle set

## macOS Prerequisites

The wrapped legacy oracle path currently assumes:

- Xcode Command Line Tools or a full Xcode install
- `/usr/bin/perl`
- a usable `cpanm` path
- Homebrew Boost headers plus `boost_filesystem` and `boost_thread`

The Bazel wrapper is intentionally honest about these assumptions. It preserves the oracle path; it does not yet make the retained legacy package hermetic.
