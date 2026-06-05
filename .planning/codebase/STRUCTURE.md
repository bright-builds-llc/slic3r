# Codebase Structure

**Analysis Date:** 2026-04-06

## Directory Layout

```text
Slic3r/
├── Build.PL                  # Perl dependency bootstrap and test runner
├── slic3r.pl                 # Main Perl launcher for CLI and GUI
├── lib/                      # Perl runtime modules and shared domain code
├── src/                      # Native CLI, GUI, native tests, and build definitions
├── xs/                       # XS bindings plus vendored C/C++ dependencies
├── t/                        # Legacy Perl test suite
├── package/                  # Packaging, release, and installer scripts
├── packages/                 # Bazel monorepo packages for retained legacy, Rust port, launcher, parity, and fork metadata
├── utils/                    # Standalone helper scripts for conversion and inspection
├── translation/              # .po locale catalogs
├── var/                      # Icons, artwork, and bundled runtime assets
├── .github/                  # Contribution templates and workflow metadata
└── README.md                 # User-facing project overview and install guidance
```

## Directory Purposes

**`lib/`:**
- Purpose: Perl runtime modules that back the launcher and legacy CLI behavior.
- Contains: `*.pm` modules, mostly under `lib/Slic3r/`.
- Key files: `lib/Slic3r.pm`.
- Subdirectories: `lib/Slic3r/` contains runtime classes for geometry, config, print handling, and GUI support.

**`src/`:**
- Purpose: native application sources and newer test code.
- Contains: C++ source, headers, GUI modules, test harness code, and standalone helpers.
- Key files: `src/slic3r.cpp`, `src/slic3r.hpp`, `src/CMakeLists.txt`, `src/standalone/config.h`.
- Subdirectories: `src/GUI/` for wxWidgets UI, `src/test/` for Catch2 tests, `src/utils/` for native utility entry points.

**`xs/`:**
- Purpose: XS binding layer and the vendored geometry/tooling code it exposes to Perl.
- Contains: `xs/src/libslic3r/`, `xs/src/admesh/`, `xs/src/expat/`, `xs/src/Zip/`, `xs/src/miniz/`, `xs/xsp/`, and Perl glue.
- Key files: `xs/Build.PL`, `xs/lib/Slic3r/XS.pm`, `xs/src/perlglue.cpp`, `xs/src/libslic3r/libslic3r.h`.
- Subdirectories: `xs/t/` holds unit tests for the XS layer, and `xs/xsp/` holds binding declarations.

**`t/`:**
- Purpose: legacy Perl regression tests for the higher-level runtime.
- Contains: many focused `*.t` files covering geometry, print logic, and config behavior.
- Key files: `t/geometry.t`, `t/print.t`, `t/config.t`, `t/gcode.t`.
- Subdirectories: none at this depth; tests live directly in the directory.

**`package/`:**
- Purpose: packaging and release scripts for Linux, macOS, Windows, and deployment jobs.
- Contains: shell scripts, PowerShell scripts, platform metadata, and shared packaging helpers.
- Key files: `package/common/util.sh`, `package/linux/make_archive.sh`, `package/linux/appimage.sh`, `package/osx/make_dmg.sh`, `package/win/package_win32.ps1`.
- Subdirectories: `package/common/`, `package/linux/`, `package/osx/`, `package/win/`, `package/deploy/`.

**`packages/`:**
- Purpose: Bazel-organized migration packages that let the retained legacy package, Rust port, launcher, parity evidence, and fork metadata evolve side by side.
- Contains: `packages/legacy-slic3r/`, `packages/slic3r-rust/`, `packages/launcher/`, `packages/parity/`, `packages/parity-fixtures/`, `packages/fork-vendors/`, and `packages/fork-inventories/`.
- Key files: `packages/slic3r-rust/Cargo.toml`,
  `packages/slic3r-rust/BUILD.bazel`,
  `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`, and
  `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`.
- Subdirectories: `packages/slic3r-rust/crates/` contains the Rust crate boundaries for contracts, core, CLI, and flavor registry metadata.

**`utils/`:**
- Purpose: ad hoc helper scripts for mesh conversion, G-code inspection, and viewer-style workflows.
- Contains: Perl scripts and a small `utils/clang_format` helper.
- Key files: `utils/view-mesh.pl`, `utils/view-toolpaths.pl`, `utils/split_stl.pl`, `utils/send-gcode.pl`.
- Subdirectories: none at this depth.

**`translation/`:**
- Purpose: localization catalogs used by the UI and user-facing strings.
- Contains: `.po` files for supported locales.
- Key files: `translation/en_US.po`, `translation/fr_FR.po`, `translation/de_DE.po`, `translation/zh_CN.po`.
- Subdirectories: none at this depth.

**`var/`:**
- Purpose: bundled icons, logos, and other runtime assets.
- Contains: PNG and icon files used by the launcher, GUI, and packaging scripts.
- Key files: `var/Slic3r_128px.png`, `var/Slic3r.icns`, `var/Slic3r.ico`, `var/gcode.icns`.
- Subdirectories: `var/solarized/` for theme-related assets.

**`.github/`:**
- Purpose: repository metadata for contribution and automated workflows.
- Contains: issue templates, pull request template, CODEOWNERS, and the Bright Builds auto-update workflow.
- Key files: `.github/pull_request_template.md`, `.github/CONTRIBUTING.md`, `.github/workflows/bright-builds-auto-update.yml`.
- Subdirectories: `.github/ISSUE_TEMPLATE/`.

## Key File Locations

**Entry Points:**
- `slic3r.pl`: primary user-facing launcher.
- `src/slic3r.cpp`: native CLI executable entry point.
- `packages/slic3r-rust/crates/slic3r_cli/src/main.rs`: preferred Rust-backed CLI entrypoint for the verified slice.
- `src/test/test_harness.cpp`: Catch2 main for native tests.
- `Build.PL`: Perl bootstrap and test runner.
- `xs/Build.PL`: XS compilation bootstrap.

**Configuration:**
- `src/CMakeLists.txt`: native build options and source lists.
- `src/standalone/config.h`: standalone configuration header.
- `xs/MANIFEST` and `xs/MANIFEST.SKIP`: XS packaging inputs.
- `package/common/util.sh`: packaging metadata helpers.

**Core Logic:**
- `lib/Slic3r.pm`: Perl runtime orchestration and threading.
- `lib/Slic3r/*`: domain models, geometry, print, gcode, and config classes.
- `xs/src/libslic3r/*`: C++ geometry and slicing implementation.
- `src/GUI/*`: GUI controllers, view state, and widgets.
- `packages/slic3r-rust/crates/slic3r_contracts/src/flavor.rs`: typed Rust flavor and fork contract values.
- `packages/slic3r-rust/crates/slic3r_flavors/src/registry.rs`: pure static flavor registry metadata and lookup helpers.
- `packages/slic3r-rust/crates/slic3r_flavors/src/prusa_project_file.rs`:
  pure Prusa project-file expected-summary parser and traceability metadata.

**Testing:**
- `t/*.t`: Perl tests for runtime and geometry behavior.
- `xs/t/*.t`: XS-level unit tests.
- `src/test/*.cpp`: native Catch2 tests and test data helpers.
- `src/test/test_options.hpp.in`: generated include for test input paths.
- `packages/slic3r-rust/crates/*/tests/*.rs`: Rust crate integration tests run through Cargo and Bazel.

**Documentation:**
- `README.md`: high-level project overview, install info, and structure summary.
- `.github/CONTRIBUTING.md`: contributor guidance mirrored from the upstream repo.
- `xs/libslic3r.doxygen`: Doxygen input for the C++ library.

## Naming Conventions

**Files:**
- `*.pm` for Perl modules.
- `*.cpp` and `*.hpp` pairs for native C++ sources and headers.
- `*.t` for Perl and XS tests.
- `*.sh` for shell packaging scripts and `*.ps1` for Windows packaging scripts.
- `*.po` for translation catalogs.

**Directories:**
- Lowercase names are used for most feature and platform directories, such as `src/`, `xs/`, `t/`, and `package/`.
- `src/GUI/` is capitalized because it contains the GUI subsystem and mirrors the native application naming.
- `lib/Slic3r/` and `xs/lib/Slic3r/` follow module namespace structure rather than feature naming.

**Special Patterns:**
- `src/test/` groups newer native tests away from the legacy `t/` tree.
- `xs/xsp/` contains binding declarations that generate XS glue.
- `package/*/` directories split platform packaging concerns cleanly by target OS.
- `var/` holds runtime assets that the launcher and GUI load at runtime or bundle into distributions.
