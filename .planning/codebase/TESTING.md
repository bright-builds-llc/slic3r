# Testing Patterns

**Analysis Date:** 2026-04-06

## Test Framework

**Active C++ test suite**
- Catch2 is the active test framework for the newer code paths
- The harness is wired in `src/CMakeLists.txt`
- `src/test/test_harness.cpp` defines `CATCH_CONFIG_MAIN`
- `src/test/GUI/test_harness_gui.cpp` defines `CATCH_CONFIG_RUNNER` for GUI-oriented tests

**Legacy Perl test suites**
- `t/*.t` uses `Test::More`
- `xs/t/*.t` also uses `Test::More`
- These suites are still present, but `README.md` labels both as deprecated

**Rust migration test suites**
- Rust crates under `packages/slic3r-rust/crates/` use Cargo integration tests and Bazel `rust_test` targets.
- The package aggregate `//packages/slic3r-rust:verify` includes Rust tests, rustfmt checks, and clippy checks for wired crates.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/flavor_registry.rs` covers pure static flavor registry metadata and provenance behavior.
- `packages/slic3r-rust/crates/slic3r_flavors/tests/prusa_project_file.rs`
  covers the pure Prusa project-file expected-summary parser, traceability
  metadata, malformed inputs, and no-overclaiming public names.
- Metadata-only Prusa fork scope packages use package-local Bash verifier
  scripts and Bazel `sh_test` mutation tests, for example
  `//packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`.

**Assertions and style**
- Catch2 tests use `TEST_CASE`, `SCENARIO`, `GIVEN`, `WHEN`, `THEN`, and `REQUIRE`
- Legacy TAP tests use `ok`, `is`, `is_deeply`, `plan tests => N`, and `done_testing()`
- Rust tests use `#[test]`, `assert!`, `assert_eq!`, and explicit Arrange/Act/Assert comments for behavior-focused cases.

## Test File Organization

**Active tests**
- `src/test/libslic3r/` contains the main unit tests for `libslic3r`
- `src/test/GUI/` contains GUI-level Catch2 tests and their harness helpers
- `src/test/inputs/` contains the fixture data used by those tests

**Legacy tests**
- `t/` contains the older Perl suite for core behavior
- `xs/t/` contains the older XS-facing Perl suite
- Those directories still matter for compatibility coverage even though they are marked deprecated in `README.md`

## Run Commands

**Perl and XS bootstrap**
- `perl Build.PL` installs required Perl dependencies and, when it finishes successfully, runs `App::Prove`
- `perl Build.PL --gui` installs the GUI dependency set
- The build scripts in `package/linux/travis-build-main.sh` and `package/osx/travis-build-main.sh` both call `perl ./Build.PL` and `perl ./Build.PL --gui`

**CMake and Catch2**
- `src/CMakeLists.txt` defines `SLIC3R_BUILD_TESTS` and adds `add_test(NAME TestSlic3r COMMAND slic3r_test)`
- The active C++ suite is meant to be run through a CMake build directory with `ctest`
- `src/CMakeLists.txt` also supports `GUI_BUILD_TESTS` for GUI-specific test builds

**Rust and Bazel**
- `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml --all-features`
- `bazel test //packages/slic3r-rust:verify`
- `bazel run //packages/prusa-gcode-output-scope:verify`
- `bazel test //packages/prusa-gcode-output-scope:verify_prusa_gcode_output_scope_test`
- Crate-focused Rust checks can target package tests such as `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test flavor_registry`.
- Prusa project-file parser checks can target
  `rustup run 1.94.1 cargo test --manifest-path packages/slic3r-rust/Cargo.toml -p slic3r_flavors --test prusa_project_file`
  and
  `bazel test //packages/slic3r-rust/crates/slic3r_flavors:prusa_project_file_test`.

## Test Structure

**Catch2 examples**
- Tests are grouped by behavior, not by class or method count
- `src/test/libslic3r/test_geometry.cpp` mixes `TEST_CASE` and `SCENARIO` blocks in one file
- `src/test/GUI/test_misc_ui.cpp` uses `SCENARIO` blocks for small GUI utility behavior

**Legacy TAP examples**
- `t/support.t` uses a fixed test count and many small `ok` / `is` assertions
- `xs/t/01_trianglemesh.t` performs direct object setup and then checks round-trip behavior with `is_deeply`
- Many legacy tests load `local::lib "$FindBin::Bin/../local-lib"` in a `BEGIN` block so the repo-local dependency tree is available

## Fixtures and Inputs

- Fixture meshes and configs live under `src/test/inputs/`
- Legacy XS fixtures live under `xs/t/models/` and `xs/t/inc/`
- Tests frequently use small deterministic inputs such as `20mmbox.stl`, `20mmbox_config.ini`, and `box.3mf`

## Practical Guidance

- For new core behavior, prefer the Catch2 tree under `src/test/`
- For new Rust-port behavior, prefer focused crate integration tests under `packages/slic3r-rust/crates/<crate>/tests/` and wire them into the crate-local Bazel `rust_test`.
- For legacy Perl-facing behavior, add or update `t/*.t` or `xs/t/*.t` only when the old path is still the right coverage surface
- Keep each test focused on a single behavior and use concrete fixture data rather than synthetic mocks when the code is geometry-heavy
- GUI tests should go through the dedicated harness in `src/test/GUI/test_harness_gui.cpp` rather than trying to exercise the event loop ad hoc
- When a change touches both the C++ core and the Perl/XS compatibility layer, expect to validate both suites
