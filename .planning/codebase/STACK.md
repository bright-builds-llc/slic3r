# Technology Stack

**Analysis Date:** 2026-04-06

## Languages

**Primary:**
- C++11/C++14 - core slicer logic in `xs/src/libslic3r/`, `src/slic3r.cpp`, and the GUI sources under `src/GUI/`
- Perl 5 - CLI wrapper, packaging glue, tests, and legacy XS bindings in `slic3r.pl`, `Build.PL`, `lib/Slic3r.pm`, and `xs/Build.PL`

**Secondary:**
- Bash - build/deploy scripts in `package/common/`, `package/linux/`, `package/osx/`, and `package/deploy/`
- PowerShell - Windows bootstrap/build/deploy scripts in `package/win/`
- C - vendored C dependencies such as `xs/src/miniz/miniz.c` and `xs/src/expat/*.c`

## Runtime

**Environment:**
- Native desktop applications and command-line tools on Windows, macOS, and Linux
- Perl runtime with local module installation via `local::lib`
- C++ toolchain with Boost, wxWidgets, OpenGL, and Catch2 available for the GUI/test builds

**Package Manager:**
- CPAN/`cpanm` - used by `Build.PL` and `xs/Build.PL` to install Perl prerequisites into `local-lib/`
- No lockfile-based package manager is present

## Frameworks

**Core:**
- `Module::Build::WithXSpp` - used by `xs/Build.PL` to build the XS bridge and compile the C++ extension layer
- `CMake` - used by `src/CMakeLists.txt` for the newer C++ build, GUI build, and C++ test targets
- `wxWidgets` - GUI framework used from `src/GUI/` when `Enable_GUI` is enabled

**Testing:**
- Catch2 - C++ test framework pulled from GitHub by `src/CMakeLists.txt` for `slic3r_test` and `gui_test`
- Perl `App::Prove` - used by `Build.PL` to run the Perl test suite after prerequisites are installed

**Build/Dev:**
- `ExtUtils::CppGuess` - detects compiler and linker flags in `xs/Build.PL`
- `Devel::CheckLib` - verifies native library availability for the XS build
- `local::lib` - isolates Perl dependencies in `local-lib/`

## Key Dependencies

**Critical:**
- Boost - filesystem, thread, system, and nowide support across the C++ and XS builds
- wxWidgets - GUI frontend and GUI test harness support
- OpenGL - GUI rendering dependency in `src/CMakeLists.txt`
- Catch2 - test dependency fetched from `https://github.com/catchorg/Catch2`
- `Module::Build::WithXSpp` - required for the XS build path

**Infrastructure:**
- `Devel::CheckLib` - native library probing for the Perl/XS build
- `ExtUtils::ParseXS`, `ExtUtils::MakeMaker`, `Moo`, `Encode::Locale`, and related Perl modules listed in `Build.PL`
- Vendored geometry/parser code in `xs/src/` such as `clipper`, `poly2tri`, `admesh`, `expat`, `BSpline`, and `tiny_obj_loader`

## Configuration

**Environment:**
- `BOOST_DIR`, `BOOST_INCLUDEDIR`, and `BOOST_LIBRARYPATH` are used by `xs/Build.PL` to locate Boost
- `SLIC3R_STATIC`, `SLIC3R_DEBUG`, `SLIC3R_NO_AUTO`, and `SLIC3R_GIT_VERSION` influence the Perl/XS and C++ builds
- `SLIC3R_VAR_REL`, `SLIC3R_VAR_ABS`, and `SLIC3R_VAR_ABS_PATH` are consumed by `src/CMakeLists.txt`
- `WXDIR`, `ARCH`, `FORCE_WX_BUILD`, and `FORCE_BOOST_REINSTALL` are used by the Windows packaging scripts

**Build:**
- `Build.PL` - installs Perl dependencies and runs tests for the main Perl/XS path
- `xs/Build.PL` - builds the XS/C++ extension layer
- `src/CMakeLists.txt` - defines `slic3r`, `slic3r_test`, `gui_test`, `libslic3r`, and optional `extrude-tin`
- `.travis.yml` and `appveyor.yml` - CI orchestration for legacy Linux/macOS and Windows builds

## Platform Requirements

**Development:**
- Linux, macOS, or Windows with a working Perl toolchain and C++ compiler
- wxWidgets/OpenGL development headers for GUI builds
- Git is used during CMake builds to stamp the build commit

**Production:**
- Desktop packaging targets for Linux tarballs/AppImages, macOS `.dmg`, and Windows installers/archives
- Distribution artifacts are prepared by the scripts under `package/linux/`, `package/osx/`, and `package/win/`

---

*Stack analysis: 2026-04-06*
