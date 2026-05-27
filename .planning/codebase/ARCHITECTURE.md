# Architecture

**Analysis Date:** 2026-04-06

## Pattern Overview

**Overall:** Hybrid desktop application with a Perl launcher, a compiled C++ geometry/slicing core, and an optional wxWidgets GUI.

**Key Characteristics:**
- `slic3r.pl` is the main user-facing launcher for CLI and GUI flows.
- `src/slic3r.cpp` hosts the native CLI entry point and command dispatch.
- `lib/Slic3r.pm` wires together Perl runtime behavior, threading, and shared domain types.
- `xs/src/libslic3r/` contains the core slicing and geometry engine used by both Perl and C++ surfaces.
- `src/CMakeLists.txt` builds the native executable and optional test targets.

## Layers

**Launch and Packaging Layer:**
- Purpose: start the app, bootstrap dependencies, and assemble distributable artifacts.
- Contains: `Build.PL`, `slic3r.pl`, `package/common/util.sh`, `package/linux/*.sh`, `package/osx/*.sh`, `package/win/*.ps1`.
- Depends on: Perl, local library bootstrap, platform packaging tools, and environment variables.
- Used by: users starting the CLI/GUI, release packaging scripts, and CI-era build jobs.

**Perl Runtime Layer:**
- Purpose: load modules, manage threading, and expose shared helpers for non-GUI execution.
- Contains: `lib/Slic3r.pm`, `lib/Slic3r/*` modules, and Perl-facing helpers under `xs/lib/Slic3r/`.
- Depends on: `Moo`, `threads`, `Thread::Semaphore`, `Encode`, `Unicode::Normalize`, and XS bindings.
- Used by: `slic3r.pl`, tests under `t/`, and parts of the GUI bootstrap.

**Native Core Layer:**
- Purpose: implement geometry, model processing, slicing, gcode generation, and low-level file transforms.
- Contains: `xs/src/libslic3r/*`, `xs/src/admesh/*`, `xs/src/expat/*`, `xs/src/Zip/*`, `xs/src/miniz/*`.
- Depends on: Boost, C++11, vendored geometry libraries, and Perl XS glue.
- Used by: the Perl runtime, native CLI, and test code.

**Native Application Layer:**
- Purpose: provide the current CLI executable and optional GUI shell.
- Contains: `src/slic3r.cpp`, `src/slic3r.hpp`, `src/GUI/*`, `src/utils/extrude-tin.cpp`, `src/standalone/config.h`.
- Depends on: `libslic3r`, Boost, Catch2 for tests, and wxWidgets when `Enable_GUI` is on.
- Used by: the packaged binary, local developer builds, and native tests.

**Rust Migration Layer:**
- Purpose: stage the preferred Rust-backed implementation beside the retained legacy oracle without replacing it all at once.
- Contains: `packages/slic3r-rust/crates/slic3r_core/`, `slic3r_contracts/`, `slic3r_cli/`, and `slic3r_flavors/`.
- Depends on: Cargo, Bazel `rules_rust`, and local crate boundaries.
- Used by: the launcher package, parity evidence, typed contract tests, and flavor registry metadata inspection.

**Test and Verification Layer:**
- Purpose: exercise both the legacy Perl-facing API and the native C++ implementation.
- Contains: `t/*.t`, `xs/t/*.t`, `src/test/*.cpp`, `src/test/test_data.*`, and Rust integration tests under `packages/slic3r-rust/crates/*/tests/`.
- Depends on: `Test::More`, `Catch2`, XS bindings, Cargo, Bazel, and the generated `src/test/test_options.hpp`.
- Used by: `Build.PL`, `xs/Build.PL`, and the native CMake test target.

## Data Flow

**CLI Invocation:**
1. User runs `slic3r.pl` with input files or options.
2. `slic3r.pl` loads `lib/` and `local-lib`, then either launches `Slic3r::GUI` or continues in CLI mode.
3. `src/slic3r.cpp` parses CLI actions into config objects in `Slic3r::Config`.
4. Input meshes are loaded through `Slic3r::Model::read_from_file()` and normalized.
5. Transformations such as merge, duplicate, cut, scale, and arrange are applied.
6. The result is emitted as STL, config, SVG, or G-code depending on selected actions.

**GUI Launch:**
1. `slic3r.pl` starts the GUI when `--gui` is requested or when no non-option arguments are present.
2. `Slic3r::GUI` is loaded from `src/GUI/GUI.cpp` and related modules.
3. `src/GUI/MainFrame.cpp` and `src/GUI/Plater.cpp` mediate user actions.
4. GUI state is translated into `Slic3r::Config` and `Slic3r::Print` operations.
5. The GUI renders model, toolpath, and progress state through the wxWidgets layer.

**Packaging Flow:**
1. `package/common/util.sh` derives version, branch, commit, and build identifiers.
2. `package/linux/make_archive.sh` collects `slic3r.pl`, `local-lib`, bundled binaries, and `var/` assets.
3. `package/linux/appimage.sh`, `package/osx/make_dmg.sh`, and the Windows scripts wrap the same app state for their targets.
4. Packaging assumes the repo root layout and the `local-lib` dependency cache created by `Build.PL`.

**State Management:**
- Mutable application state lives mostly in `Slic3r::Config`, `Slic3r::Model`, `Slic3r::Print`, and GUI controller objects.
- Geometry objects are heavily value-like, but several classes cache derived state such as meshes, slices, and print statistics.
- Threading is used in Perl space for parallel slicing and cleanup coordination, with explicit thread lifecycle handling in `lib/Slic3r.pm`.
- Rust flavor contracts and registry metadata are pure typed values and static slices; they do not perform filesystem, process, environment, clock, network, or runtime TSV loading.

## Key Abstractions

**Model and Print Pipeline:**
- Purpose: represent loaded meshes, arrangement, and print-ready structure.
- Examples: `Slic3r::Model`, `Slic3r::Model::Object`, `Slic3r::Print`, `Slic3r::Print::Object`, `Slic3r::Print::Region`.
- Pattern: a mutable pipeline that starts with imported geometry and ends in print-ready layers and toolpaths.

**Geometry Primitives:**
- Purpose: provide reusable points, polygons, polylines, triangles, and bounding boxes.
- Examples: `Slic3r::Point`, `Slic3r::Line`, `Slic3r::Polygon`, `Slic3r::Polyline`, `Slic3r::TriangleMesh`.
- Pattern: shared domain primitives with both Perl and C++ surfaces.

**Configuration System:**
- Purpose: define printer, filament, and print job settings and apply them consistently.
- Examples: `Slic3r::Config`, `Slic3r::Config::Static`, `Slic3r::Config::Print`, `Slic3r::Config::PrintObject`.
- Pattern: layered config objects with normalization, validation, and CLI loading support.

**Flavor Metadata Boundary:**
- Purpose: model base Slic3r, shared downstream, and fork-specific planning metadata without copying core Rust workspaces.
- Examples: `FlavorId`, `VendorSourceRef`, `FeatureOrigin`, `ParitySurface`, `ChecklistStatus`, `FlavorRegistryEntry`, and `FlavorCapability`.
- Pattern: typed contract values plus a pure static registry in `slic3r_flavors`.

**GCode Pipeline:**
- Purpose: convert print state into extrusion paths and machine instructions.
- Examples: `Slic3r::GCodeWriter`, `Slic3r::GCode::Reader`, `Slic3r::Print::GCode`, `Slic3r::GCode::MotionPlanner`.
- Pattern: staged processing with derived buffers and writer objects.

## Entry Points

**Perl Launcher:**
- Location: `slic3r.pl`
- Triggers: direct user invocation.
- Responsibilities: extend `@INC`, load `local-lib`, parse CLI options, start GUI or run CLI transforms.

**Native CLI:**
- Location: `src/slic3r.cpp`
- Triggers: native build of the `slic3r` executable.
- Responsibilities: parse options, load models and configs, run transforms, and emit outputs.

**Dependency Bootstrap:**
- Location: `Build.PL`
- Triggers: developer bootstrap and Perl dependency setup.
- Responsibilities: install required CPAN modules, prepare `local-lib`, and run the Perl test suite.

**XS Build:**
- Location: `xs/Build.PL`
- Triggers: building the Perl/C++ binding layer.
- Responsibilities: compile the XS module and the vendored C++ support libraries.

**Native Build Definition:**
- Location: `src/CMakeLists.txt`
- Triggers: CMake configure/build for the native app and tests.
- Responsibilities: define options like `Enable_GUI`, `SLIC3R_BUILD_TESTS`, and the executable/test targets.

## Error Handling

- Perl code generally reports failures with `die`, `warn`, or `Test::More` assertions.
- Native C++ code uses standard exceptions, early exits, and logging through `Slic3r::Log`.
- CLI parsing failures print help and exit immediately in `src/slic3r.cpp`.
- Config loading and geometry import failures are surfaced as exception messages tied to the input file that failed.

## Notes

- `src/CMakeLists.txt` is the best summary of the native dependency graph, because it enumerates the current C++ sources, vendored libraries, and build flags.
- `lib/Slic3r.pm` is the best summary of the runtime shape, because it defines the shared Perl-side lifecycle, threading, and module loading.
- The codebase is still centered on the legacy Perl runtime, but the native `src/` tree is the clearer path for CLI evolution.
