# Coding Conventions

**Analysis Date:** 2026-04-06

## Naming Patterns

**Perl modules and packages**
- `lib/Slic3r/*.pm` uses `package Slic3r::Name;`
- Subroutines and methods are usually `snake_case`, for example `new_from_defaults`, `load_ini_hash`, and `save_window_pos`
- Module files mirror the package name when practical, such as `lib/Slic3r/Config.pm`

**C++ core and XS**
- Core library code lives in `xs/src/libslic3r/`
- Types and classes use `PascalCase`, for example `Print`, `Config`, `Geometry`, and `TriangleMesh`
- Methods and free functions are commonly `snake_case`, for example `make_brim`, `clear_objects`, `convex_hull`, and `circle_taubin_newton`
- File names are usually `PascalCase.cpp` / `PascalCase.hpp`, such as `Print.cpp`, `Geometry.cpp`, and `BoundingBox.hpp`

**GUI code**
- GUI code lives primarily under `src/GUI/`
- The same mixed style applies there: `PascalCase` types, `snake_case` functions, and paired `.cpp` / `.hpp` files
- Event and helper names tend to stay descriptive and domain-specific, such as `show_error`, `trim_zeroes`, and `Settings::restore_window_pos`

**Tests and fixtures**
- Catch2 tests use `test_*.cpp` or subsystem-specific names under `src/test/libslic3r/` and `src/test/GUI/`
- Legacy Perl tests remain in `t/*.t` and `xs/t/*.t`
- Test fixture files live under `src/test/inputs/` and `xs/t/models/`

## Code Style

**Perl**
- Perl files generally start with `use strict; use warnings;` and often `use utf8;`
- Short utility modules tend to use a small number of imports and explicit symbol lists
- Legacy Perl test files commonly end with `__END__`

**C++**
- Includes are usually grouped at the top, followed by namespace scope and then implementation
- The codebase favors direct, imperative control flow and explicit early returns
- Comments are mostly terse and practical, often documenting why a branch exists or where legacy behavior came from
- `TODO` markers are used freely for follow-up work, especially in bridge code and compatibility shims

**Shell**
- Repository scripts use `#!/bin/bash` or `#!/usr/bin/env bash` depending on the file
- Shell scripts commonly use `set -e` or `set -eo pipefail`
- Packaging scripts are kept as standalone checked-in executables under `package/`

## Import and Include Organization

**Perl**
- Tests and scripts usually add `lib/` and `local-lib/` through `FindBin` plus `local::lib`
- Example: `use lib "$FindBin::Bin/../lib";`
- Example: `use local::lib "$FindBin::Bin/../local-lib";`

**C++**
- Local headers come first, then system headers, then standard library headers
- Headers are included by their logical module name, such as `#include "Print.hpp"` or `#include "misc_ui.hpp"`
- Internal namespaces are `Slic3r` and `Slic3r::GUI`

## Error Handling

**Perl**
- Build scripts and config helpers often `die` on invalid configuration or missing prerequisites
- `Build.PL` prefers explicit failure messages over silent fallback

**C++**
- GUI helpers use explicit modal error dialogs and then raise exceptions when the failure should stop execution
- Core logic tends to use assertions, exceptions, or explicit return values instead of hidden recovery

## Logging and Diagnostics

- Debug output is present but lightweight
- `src/GUI/misc_ui.cpp` uses `warn`, `std::cerr`, and modal dialogs for user-facing failures
- `Build.PL` prints install and prerequisite status directly to the terminal

## Repository-Specific Notes

- This is a mixed legacy codebase, so conventions are not perfectly uniform across Perl, XS/C++, and the newer Catch2 test tree
- When adding code, follow the local style of the directory you are editing rather than trying to normalize the whole repository
- Prefer preserving the existing file naming scheme in `xs/src/libslic3r/` and `src/GUI/`
- Follow the existing `local::lib` and `FindBin` pattern in Perl-facing scripts and tests
