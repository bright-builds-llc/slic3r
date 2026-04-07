# Legacy Reference Package

This package contains the retained legacy Slic3r implementation.

It is the behavioral oracle for the Rust port and should be treated as the reference package during the migration. New feature work targets the Rust implementation unless a change is explicitly needed to keep this legacy package buildable, testable, and parity-preserving.

The code here is intentionally visible rather than hidden so contributors can compare behavior, contracts, and package boundaries directly. Treat structural integration changes cautiously and avoid cleanup work here unless it is necessary to preserve the oracle role.
