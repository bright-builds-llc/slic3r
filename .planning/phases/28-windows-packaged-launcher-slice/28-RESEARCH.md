# Phase 28: Windows Packaged Launcher Slice - Research

**Researched:** 2026-05-23
**Domain:** Bazel/Bash/Rust packaged launcher slice
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

## Implementation Decisions

### Packaged Artifact Shape

- Create a checked-in Bazel-facing builder for a deterministic Windows
  packaged launcher tree under `.planning/.tmp/windows-packaged-launcher`.
- Keep the artifact scoped and package-shaped, not installer-shaped: include
  the Windows runtime executable with Windows-facing naming and a scope note
  that makes the supported slice explicit.
- Mirror the Phase 27 Linux packaged tree pattern where it helps
  maintainability, but do not add a Linux or macOS shell startup shim for
  Windows.

### Startup and Business Logic Boundary

- The Windows packaged startup path should be the direct Rust console runtime
  executable from `//packages/launcher:windows_slic3r`.
- The package builder may copy files and write scope metadata, but it must not
  parse or implement CLI business behavior.
- The Rust-backed CLI continues to own help/version/config/export/transform
  behavior through `packages/slic3r-rust` and the existing Windows runtime
  entrypoint.

### Smoke Coverage

- Add Bazel smoke coverage for the Windows packaged startup path so
  maintainers can run it without ad hoc local setup.
- The smoke test should prove artifact layout, direct executable startup
  handoff, packaged `--help`, packaged `--version`, representative config
  persistence, and representative export/transform flows through the packaged
  executable.
- Keep shared cross-platform packaged parity evidence in Phase 29; this phase
  owns the Windows build/smoke slice only.

### Scope and Naming

- Use legacy Windows packaging sources only as naming and scope references,
  especially `Slic3r-console.exe`; do not recreate the legacy Perl/PAR bundle.
- Avoid claiming `Slic3r.exe` GUI behavior, MSI support, signing,
  release-channel automation, or release-grade archives.
- Update nearby package-local docs only where needed to make the new target
  discoverable and to remove stale "Windows packaging remains deferred"
  wording for this scoped tree.

### the agent's Discretion

- Choose the simplest package tree layout that is easy to inspect and smoke
  through Bazel from the current development host.
- If host-built Bazel artifacts are used for smoke coverage, keep the docs
  precise: this proves the scoped Windows packaged launcher surface and naming
  path, not native Windows installer or cross-compiled release output.

### Deferred Ideas (OUT OF SCOPE)

- MSI, zip release archives, signing, release-channel automation, GUI
  packaging behavior, and broad bundled dependency layout remain future work.
- Shared Windows packaged parity evidence belongs in Phase 29.
- Cross-platform validation status and broader packaging docs belong in Phase
  30.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| WPKG-01 | Maintainer can build a scoped Windows packaging-visible launcher artifact for the already verified Rust-backed help/version/config/export/transform slice. [VERIFIED: .planning/REQUIREMENTS.md] | Add `//packages/launcher:windows_packaged_launcher_tree` as a Bazel `sh_binary` builder that copies `//packages/launcher:windows_slic3r` into `.planning/.tmp/windows-packaged-launcher/Slic3r-windows/Slic3r-console.exe` with `share/slic3r/packaged-slice.txt`. [VERIFIED: packages/launcher/BUILD.bazel; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |
| WPKG-02 | Maintainer can run the Windows packaged startup path through Bazel smoke coverage without relying on Linux or macOS launcher shims. [VERIFIED: .planning/REQUIREMENTS.md] | Add `//packages/launcher:windows_packaged_launcher_smoke` as a Bazel `sh_test` that builds the tree in a temp root and executes `Slic3r-console.exe` directly for layout/help/version/config/export/transform checks. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/launcher/package/linux/test_packaged_launcher.sh] |
| WPKG-03 | The Windows packaged launcher surface keeps startup/bootstrap logic thin and does not overclaim installer or release-channel support. [VERIFIED: .planning/REQUIREMENTS.md] | Keep the builder to path resolution, `cp`, `chmod`, and note copying; update docs and CLI help wording to say this is a scoped package-shaped console launcher, not MSI/signing/release-channel/native release output. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; docs/port/windows-launcher-slice.md; packages/slic3r-rust/crates/slic3r_cli/src/lib.rs] |
</phase_requirements>

## Summary

Phase 28 should follow the Phase 27 package-tree pattern, but the Windows startup path must be a direct executable copy rather than a shell shim. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md; packages/launcher/package/linux/build_packaged_launcher.sh] The recommended artifact is `.planning/.tmp/windows-packaged-launcher/Slic3r-windows/` with `Slic3r-console.exe` at the artifact root and `share/slic3r/packaged-slice.txt` as the scoped maintainer note. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

Use the existing `//packages/launcher:windows_slic3r` alias and `slic3r_windows_runtime.rs` binary as the only startup executable under test. [VERIFIED: packages/launcher/BUILD.bazel; packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs] The Bazel smoke test should build the package tree in a temp root, assert layout and scope notes, then run `--help`, `--version`, `--save`, `--datadir --load`, `--export-gcode`, `--info`, `--repair`, and `--split` through `Slic3r-console.exe`. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/launcher/package/linux/test_packaged_launcher.sh]

Docs must be precise because this host-built artifact proves the scoped Windows packaging-visible launcher surface and naming path, not a native Windows installer, zip release, signing flow, GUI package, or cross-compiled release output. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md; docs/port/windows-launcher-slice.md]

**Primary recommendation:** Add `build_packaged_launcher.sh`, `packaged_slice.txt`, `test_packaged_launcher.sh`, `windows_packaged_launcher_tree`, and `windows_packaged_launcher_smoke`; update only the stale package/docs/help surfaces needed to advertise the scoped Windows console package without overclaiming release support. [VERIFIED: packages/launcher/BUILD.bazel; .planning/phases/27-linux-packaged-launcher-slice/27-01-SUMMARY.md]

## Project Constraints (from AGENTS.md)

- Do not edit the Bright Builds managed block in `AGENTS.md` or the managed `AGENTS.bright-builds.md` file. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- Read `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and relevant canonical standards before plan/review/implementation/audit work. [VERIFIED: AGENTS.md; AGENTS.bright-builds.md]
- No active local standards overrides are defined beyond the placeholder table in `standards-overrides.md`. [VERIFIED: standards-overrides.md]
- Prefer functional core / imperative shell; for this phase that means shell scripts may orchestrate files and process launch, while CLI behavior remains in Rust. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/architecture.md]
- Keep scripts shallow and readable, with early exits or guard checks where they improve clarity. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Do not hide substantial foreign-language logic inside inline strings; checked-in Bash scripts are the right place for packaging orchestration. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/code-shape.md]
- Run relevant repo-native verification before commit; Phase 27 verified this surface with `git diff --check`, `bash -n`, `shfmt`, targeted Bazel tests/runs, and Rust checks when help text changed. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md]
- Pure Rust business logic needs focused tests with Arrange/Act/Assert structure; if Phase 28 changes help text, update `packages/slic3r-rust/crates/slic3r_cli/tests/version.rs` and parity fixtures. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/testing.md] [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/tests/version.rs]
- For `.planning/phases/*/*-SUMMARY.md`, preserve the `requirements-completed` key exactly and do not run `mdformat` over phase summaries. [VERIFIED: AGENTS.md]
- No `.claude/skills/` or `.agents/skills/` project skill directories were present during research. [VERIFIED: find .claude/skills .agents/skills]

## Standard Stack

### Core

| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Bazel shell rules: `sh_binary`, `sh_test` | Bazel 8.6.0 pinned by `.bazelversion` and reported by repo-local Bazelisk. [VERIFIED: .bazelversion; ./.planning/.tmp/bin/bazelisk --version] | Expose a checked-in package-tree builder and smoke target. [VERIFIED: packages/launcher/BUILD.bazel] | Official Bazel shell rules support executable shell scripts, runtime `data`, and shell tests; the repo already uses them for Linux, Windows runtime, and macOS packaged launcher surfaces. [CITED: https://bazel.build/reference/be/shell] [VERIFIED: packages/launcher/BUILD.bazel] |
| Bazel `alias` and `filegroup` | Bazel 8.6.0. [VERIFIED: .bazelversion] | Keep `windows_slic3r` stable and update package boundary aggregations. [VERIFIED: packages/launcher/BUILD.bazel] | Official `alias` points one label at another target, and `filegroup` gathers target outputs under a single label; the package already uses both for launcher discoverability. [CITED: https://bazel.build/reference/be/general#alias] [CITED: https://bazel.build/reference/be/general#filegroup] |
| `rules_rust` / Rust toolchain | `rules_rust` 0.69.0 pinned in `MODULE.bazel`; Rust 1.94.1 pinned by the `rust.toolchain` extension and available locally. [VERIFIED: MODULE.bazel; cargo +1.94.1 --version; rustc +1.94.1 --version] | Build the existing Rust CLI and Windows runtime executable. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/BUILD.bazel] | The repo already exposes `slic3r_windows_runtime` as a `rust_binary`; this phase should consume it rather than adding a new runtime implementation. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/BUILD.bazel] |
| Bash scripts | GNU Bash 3.2.57 available locally. [VERIFIED: bash --version] | Implement the builder and smoke scripts using the repo's existing `#!/usr/bin/env bash` and `set -euo pipefail` pattern. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; packages/launcher/package/win/test_windows_launcher.sh] | Existing launcher package scripts are Bash and already handle Bazel path resolution plus temp-root smoke coverage. [VERIFIED: packages/launcher/package/linux/test_packaged_launcher.sh; packages/launcher/package/osx/build_bundle.sh] |
| Existing Windows runtime target | `//packages/launcher:windows_slic3r` aliases `//packages/slic3r-rust/crates/slic3r_cli:slic3r_windows_runtime`. [VERIFIED: packages/launcher/BUILD.bazel] | Direct packaged startup executable. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | The Rust entrypoint collects process args, calls `execute_args`, writes stdout/stderr, and exits with the returned code. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs] |

### Supporting

| Tool / File | Version | Purpose | When to Use |
|-------------|---------|---------|-------------|
| `shfmt` | 3.12.0 available locally. [VERIFIED: shfmt --version] | Check formatting of new Windows Bash scripts. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md] | Run `shfmt -d packages/launcher/package/win/build_packaged_launcher.sh packages/launcher/package/win/test_packaged_launcher.sh` before commit. [VERIFIED: shfmt --version] |
| `mdformat` | 1.0.0 available locally. [VERIFIED: mdformat --version] | Check ordinary Markdown docs touched by the phase. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md] | Use `mdformat --check` only on non-summary docs; do not run it on phase `*-SUMMARY.md` files. [VERIFIED: AGENTS.md] |
| `packages/parity-fixtures/cli-help/stdout.txt` | Checked-in fixture file. [VERIFIED: packages/parity-fixtures/cli-help/stdout.txt via rg] | Keep shared help parity aligned if help text changes to mention the Windows packaged launcher tree. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/src/lib.rs; packages/parity/compare_windows_runtime.sh] | Update alongside `slic3r_cli/src/lib.rs` and `tests/version.rs` when packaged `--help` wording changes. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-01-SUMMARY.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `sh_binary` builder | Bazel `genrule` or custom Starlark rule. [CITED: https://bazel.build/reference/be/general#genrule] | Do not use it here: existing packaged builders are maintainer-run scripts that intentionally write inspectable trees under `.planning/.tmp`, while `genrule` would imply declared build outputs and more Bazel-specific plumbing. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; packages/launcher/package/osx/build_bundle.sh] |
| Direct `Slic3r-console.exe` copy | PowerShell packaging builder. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1] | Do not use it here: `pwsh` is not available locally, and the locked scope says not to recreate the legacy Perl/PAR bundle. [VERIFIED: pwsh --version probe; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |
| Scoped tree | MSI, signed archive, zip release, GUI package. [VERIFIED: .planning/REQUIREMENTS.md] | Deferred by user decision and roadmap scope. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md; .planning/ROADMAP.md] |
| Direct Rust executable | Recreated C++ wrapper from `shell.cpp`. [VERIFIED: packages/legacy-slic3r/package/common/shell.cpp] | Do not use it here: the wrapper boots Perl and manipulates Windows DLL/path state, while Phase 28 owns only the already verified Rust-backed slice. [VERIFIED: packages/legacy-slic3r/package/common/shell.cpp; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |

**Installation:**

```bash
# No new dependency install is required for Phase 28.
./.planning/.tmp/bin/bazelisk test //packages/launcher:windows_packaged_launcher_smoke
```

**Version verification:** `Bazel 8.6.0`, `rules_rust 0.69.0`, `Rust 1.94.1`, `Bash 3.2.57`, `shfmt 3.12.0`, and `mdformat 1.0.0` were verified locally or from repo pins during this research. [VERIFIED: .bazelversion; MODULE.bazel; cargo +1.94.1 --version; rustc +1.94.1 --version; bash --version; shfmt --version; mdformat --version]

## Architecture Patterns

### Recommended Project Structure

```text
packages/launcher/
├── BUILD.bazel
├── README.md
└── package/
    └── win/
        ├── build_packaged_launcher.sh
        ├── packaged_slice.txt
        ├── test_packaged_launcher.sh
        └── test_windows_launcher.sh

docs/port/
├── windows-launcher-slice.md
├── entrypoint-architecture.md
├── contract-inventory.md
├── package-map.md
├── parity-matrix.md
└── README.md
```

This structure keeps Windows packaged launcher ownership under `packages/launcher/package/win`, which matches the existing Windows runtime smoke location and the Linux packaged tree pattern. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/launcher/package/linux/build_packaged_launcher.sh] Include `docs/port/README.md` if implementation makes its current "without claiming packaging parity" Windows sentence stale. [VERIFIED: docs/port/README.md]

### Pattern 1: Bazel-Facing Builder Script

**What:** Add `packages/launcher/package/win/build_packaged_launcher.sh` as a checked-in Bash builder that accepts `windows_launcher`, `slice_notes`, and optional `output_root`, then materializes `.planning/.tmp/windows-packaged-launcher/Slic3r-windows`. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**When to use:** Use this for maintainer-inspectable package-shaped output, not for declared release artifacts or installer packages. [VERIFIED: .planning/ROADMAP.md; packages/launcher/package/linux/packaged_slice.txt]

**Example:**

```bash
#!/usr/bin/env bash
set -euo pipefail

windows_launcher="${1}"
slice_notes="${2}"
output_root="${3:-${repo_root}/.planning/.tmp/windows-packaged-launcher}"

artifact_root="${output_root}/Slic3r-windows"
share_root="${artifact_root}/share/slic3r"

rm -rf "${artifact_root}"
mkdir -p "${share_root}"
cp -f "${windows_launcher}" "${artifact_root}/Slic3r-console.exe"
chmod +x "${artifact_root}/Slic3r-console.exe"
cp -f "${slice_notes}" "${share_root}/packaged-slice.txt"
```

Source pattern: local Linux builder plus locked Phase 28 direct executable decision. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

### Pattern 2: Direct Packaged Startup

**What:** The packaged startup path is the executable file `Slic3r-windows/Slic3r-console.exe`, copied from `//packages/launcher:windows_slic3r`. [VERIFIED: packages/launcher/BUILD.bazel; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**When to use:** Use this in both the builder output and smoke test to prove the Windows packaged path does not rely on `package/linux/startup_script.sh`, macOS app startup scripts, PowerShell, or C++/Perl wrappers. [VERIFIED: packages/launcher/package/linux/startup_script.sh; packages/launcher/package/osx/build_bundle.sh; packages/legacy-slic3r/package/common/shell.cpp]

**Example:**

```bash
startup_path="${artifact_root}/Slic3r-console.exe"

[[ -x "${startup_path}" ]]
version_output="$("${startup_path}" --version)"
[[ "${version_output}" == "1.3.1-dev" ]]
```

Source pattern: existing Windows runtime smoke already copies and executes the runtime directly under a console-style name. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh]

### Pattern 3: Bazel Targets Mirror Existing Launcher Package Shape

**What:** Add the new builder and smoke target to `packages/launcher/BUILD.bazel`, and add new Windows files to `exports_files` plus `package_boundary`. [VERIFIED: packages/launcher/BUILD.bazel]

**When to use:** Use this whenever a file under `packages/launcher/package/win` becomes part of the package-local ownership surface. [VERIFIED: packages/launcher/BUILD.bazel]

**Example:**

```python
sh_binary(
    name = "windows_packaged_launcher_tree",
    srcs = ["package/win/build_packaged_launcher.sh"],
    data = [
        ":windows_slic3r",
        "package/win/packaged_slice.txt",
    ],
    args = [
        "$(location :windows_slic3r)",
        "$(location package/win/packaged_slice.txt)",
    ],
)

sh_test(
    name = "windows_packaged_launcher_smoke",
    srcs = ["package/win/test_packaged_launcher.sh"],
    data = [
        ":windows_slic3r",
        "package/win/build_packaged_launcher.sh",
        "package/win/packaged_slice.txt",
    ],
    args = [
        "$(location package/win/build_packaged_launcher.sh)",
        "$(location :windows_slic3r)",
        "$(location package/win/packaged_slice.txt)",
    ],
)
```

Source pattern: local Linux packaged targets plus official Bazel shell-rule support for `srcs`, `data`, and `args`. [VERIFIED: packages/launcher/BUILD.bazel] [CITED: https://bazel.build/reference/be/shell]

### Pattern 4: Smoke the Existing Slice, Not New Behavior

**What:** Reuse the existing representative Windows runtime flows: help, version, config save/load, G-code export, info, repair, and split. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/parity/compare_windows_runtime.sh]

**When to use:** Use this for Phase 28 smoke coverage because Phase 29 owns shared packaged parity evidence and this phase owns build/smoke visibility only. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**Example:**

```bash
save_target="${temp_root}/saved.ini"
save_output="$("${startup_path}" --save "${save_target}")"
[[ "${save_output}" == "Saved config to ${save_target}" ]]
grep -q '^generated_by=rust_cli$' "${save_target}"
```

Source pattern: existing Windows runtime and Linux packaged smoke scripts. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/launcher/package/linux/test_packaged_launcher.sh]

### Anti-Patterns to Avoid

- **Adding a shell startup shim for Windows:** The locked startup path is the direct Rust console runtime executable. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]
- **Recreating legacy PAR packaging:** The legacy PowerShell script packages Perl, DLLs, wrappers, and archive names that are explicitly outside Phase 28. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1; .planning/ROADMAP.md]
- **Moving CLI parsing into Bash:** The Rust `execute_args` path already owns help/version/config/export/transform behavior. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/src/lib.rs; packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs]
- **Calling the artifact native Windows release output:** The current host-built executable can be copied with a Windows-facing name for smoke coverage, but docs must not claim cross-compiled Windows release output. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md; .planning/ROADMAP.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| CLI behavior dispatch | Bash parsing for `--help`, `--version`, config, export, or transform flags. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh] | Existing Rust `execute_args` through `slic3r_windows_runtime`. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs] | The supported slice is already verified in Rust; shell logic would violate WPKG-03. [VERIFIED: .planning/REQUIREMENTS.md] |
| Windows wrapper/runtime bootstrap | PowerShell, C++, or shell wrapper that manipulates Perl/DLL state. [VERIFIED: packages/legacy-slic3r/package/common/shell.cpp; packages/legacy-slic3r/package/win/package_win32.ps1] | Direct copy of `//packages/launcher:windows_slic3r` to `Slic3r-console.exe`. [VERIFIED: packages/launcher/BUILD.bazel] | The phase excludes legacy Perl/PAR and broad bundled dependency layout. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |
| Release packaging | MSI/zip/signing/release-channel automation. [VERIFIED: .planning/ROADMAP.md] | Scoped `.planning/.tmp/windows-packaged-launcher/Slic3r-windows` tree. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Release-grade distribution is out of scope and would blur WPKG-03. [VERIFIED: .planning/REQUIREMENTS.md] |
| Cross-platform packaged parity evidence | New shared fixtures or parity commands under `packages/parity`. [VERIFIED: .planning/REQUIREMENTS.md] | Package-local smoke target only. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Phase 29 owns `PKGE-02`; Phase 28 owns Windows build/smoke. [VERIFIED: .planning/ROADMAP.md] |
| Bazel runfile framework | New runfiles library or custom resolver. [CITED: https://bazel.build/reference/be/make-variables] | Existing `resolve_input` helper pattern in package scripts. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; packages/launcher/package/win/test_windows_launcher.sh] | The repo already handles `$(location)` paths and workspace fallbacks in local shell scripts. [VERIFIED: packages/launcher/package/linux/test_packaged_launcher.sh] |

**Key insight:** The hard part is not Windows packaging technology; it is preserving a narrow contract boundary where the package is visible and smokeable without implying installer, release, GUI, or native Windows distribution support. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md; .planning/ROADMAP.md]

## Common Pitfalls

### Pitfall 1: Accidentally Testing a Shell Shim Instead of Windows Startup

**What goes wrong:** The smoke test runs `package/linux/startup_script.sh` or a new shell wrapper, so WPKG-02 is not actually proving the Windows packaged startup path. [VERIFIED: .planning/REQUIREMENTS.md; packages/launcher/package/linux/startup_script.sh]

**Why it happens:** Linux Phase 27 legitimately reuses a thin shell handoff, but Phase 28 explicitly forbids adding a Linux or macOS shell startup shim for Windows. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-01-SUMMARY.md; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**How to avoid:** Make `Slic3r-console.exe` the executable under test and keep `package/linux/startup_script.sh` plus `package/osx/startup_script.sh` out of the Windows package target data. [VERIFIED: packages/launcher/BUILD.bazel]

**Warning signs:** The Windows packaged target has `startup_script.sh` in `data`, the artifact contains `bin/slic3r`, or the smoke command invokes a `.sh` file inside the packaged tree. [VERIFIED: packages/launcher/package/linux/test_packaged_launcher.sh]

### Pitfall 2: Overclaiming Native Windows Release Support

**What goes wrong:** Docs imply Phase 28 produces a native Windows installer, release zip, signed artifact, GUI package, or cross-compiled release binary. [VERIFIED: .planning/ROADMAP.md]

**Why it happens:** The artifact uses the Windows-facing name `Slic3r-console.exe`, while the smoke host can still be the current development host. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**How to avoid:** Use wording like "scoped Windows package-shaped launcher tree" and explicitly defer MSI, zip releases, signing, release channels, `Slic3r.exe` GUI behavior, broad DLL bundling, and native release output. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

**Warning signs:** New docs say "Windows parity verified", "installer", "release package", "native Windows build", or "Slic3r.exe" without a deferred qualifier. [VERIFIED: docs/port/windows-launcher-slice.md; docs/port/parity-matrix.md]

### Pitfall 3: Forgetting Bazel Data/Export Surfaces

**What goes wrong:** The scripts exist, but `bazel run` or `bazel test` cannot find notes/scripts because they are missing from `exports_files`, `data`, or `package_boundary`. [VERIFIED: packages/launcher/BUILD.bazel]

**Why it happens:** Bazel shell rules make runtime files available through target dependencies and runfiles, not through arbitrary package-directory discovery. [CITED: https://bazel.build/reference/be/shell]

**How to avoid:** Add `package/win/build_packaged_launcher.sh`, `package/win/packaged_slice.txt`, and `package/win/test_packaged_launcher.sh` to `exports_files` and `package_boundary`, and list the builder/note/runtime in the relevant target `data`. [VERIFIED: packages/launcher/BUILD.bazel]

**Warning signs:** The test only works from the source checkout, fails under Bazel, or falls back to `bazel-bin` because the passed path was not executable. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh]

### Pitfall 4: Updating Help Text Without Fixture Parity

**What goes wrong:** Packaged `--help` correctly mentions the Windows packaged launcher tree, but `cli_help_parity` or `windows_runtime_parity` fails because `packages/parity-fixtures/cli-help/stdout.txt` still contains old text. [VERIFIED: packages/parity/compare_windows_runtime.sh; packages/parity-fixtures/cli-help/stdout.txt]

**Why it happens:** Shared parity commands compare exact help output against checked-in fixtures. [VERIFIED: packages/parity/compare_windows_runtime.sh]

**How to avoid:** If `slic3r_cli/src/lib.rs` changes the "Rust-backed launcher paths" stanza, update `tests/version.rs` and `packages/parity-fixtures/cli-help/stdout.txt` in the same plan. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/src/lib.rs; packages/slic3r-rust/crates/slic3r_cli/tests/version.rs]

**Warning signs:** `bazel run //packages/parity:cli_help_parity` or `bazel run //packages/parity:windows_runtime_parity` reports a help mismatch. [VERIFIED: packages/parity/compare_windows_runtime.sh]

### Pitfall 5: Using Bash 4 Features on macOS

**What goes wrong:** The script passes on a newer shell but fails on the local macOS Bash 3.2 runtime. [VERIFIED: bash --version]

**Why it happens:** macOS still commonly exposes Bash 3.2 as `/bin/bash`, and this repo's current shell scripts are compatible with that shape. [VERIFIED: bash --version; packages/launcher/package/linux/build_packaged_launcher.sh]

**How to avoid:** Stick to the existing script style: scalar variables, functions, `[[ ... ]]`, `mktemp -d`, quoted expansions, and no associative arrays or Bash 4-only features. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; packages/launcher/package/win/test_windows_launcher.sh]

**Warning signs:** Script uses `declare -A`, `mapfile`, process substitution-heavy flows, or unquoted path expansion. [VERIFIED: bash --version]

## Code Examples

Verified patterns from official and local sources:

### Windows Builder Shape

```bash
# Source: packages/launcher/package/linux/build_packaged_launcher.sh adapted for Windows direct executable scope
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

windows_launcher="${1}"
slice_notes="${2}"
output_root="${3:-${repo_root}/.planning/.tmp/windows-packaged-launcher}"

# Reuse the existing resolve_input function pattern before copying files.
artifact_root="${output_root}/Slic3r-windows"
share_root="${artifact_root}/share/slic3r"

printf 'Preparing packaged Windows launcher tree at %s\n' "${artifact_root}"
rm -rf "${artifact_root}"
mkdir -p "${share_root}"
cp -f "${windows_launcher}" "${artifact_root}/Slic3r-console.exe"
chmod +x "${artifact_root}/Slic3r-console.exe"
cp -f "${slice_notes}" "${share_root}/packaged-slice.txt"
printf 'Packaged Windows launcher ready: %s\n' "${artifact_root}"
```

This keeps the builder to file orchestration and does not parse CLI flags. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

### Windows Smoke Shape

```bash
# Source: packages/launcher/package/linux/test_packaged_launcher.sh and package/win/test_windows_launcher.sh
"${build_package}" "${windows_launcher}" "${slice_notes}" "${temp_root}" >"${build_log}"

artifact_root="${temp_root}/Slic3r-windows"
startup_path="${artifact_root}/Slic3r-console.exe"
resource_notes="${artifact_root}/share/slic3r/packaged-slice.txt"

[[ -x "${startup_path}" ]]
[[ -f "${resource_notes}" ]]

version_output="$("${startup_path}" --version)"
[[ "${version_output}" == "1.3.1-dev" ]]
```

This proves packaged layout and direct executable startup before representative CLI flows. [VERIFIED: packages/launcher/package/linux/test_packaged_launcher.sh; packages/launcher/package/win/test_windows_launcher.sh]

### Scope Note Shape

```text
This packaged tree is the scoped Windows packaging-visible launcher slice for
the currently verified Rust-backed help/version/config/export/transform surface.

Included:
- Slic3r-console.exe: direct Rust console runtime executable for the verified slice
- share/slic3r/packaged-slice.txt: this scope note

Deferred:
- MSI, zip release archives, signing, and release-channel automation
- Slic3r.exe GUI packaging behavior
- broad bundled DLL/dependency layout
- shared cross-platform packaged parity evidence
```

This mirrors the Linux scope-note pattern while using Windows-specific naming and deferred scope. [VERIFIED: packages/launcher/package/linux/packaged_slice.txt; packages/legacy-slic3r/package/win/package_win32.ps1]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Legacy Windows packaging used PowerShell, PAR, Perl DLLs, wrapper executables, and archive naming. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1] | Phase 28 should build a scoped `Slic3r-windows` tree around the existing Rust runtime executable only. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Phase 28 in v1.7. [VERIFIED: .planning/ROADMAP.md] | Plan a thin package-visible slice, not a release package. [VERIFIED: .planning/REQUIREMENTS.md] |
| Windows runtime existed only as `//packages/launcher:windows_slic3r` plus runtime smoke/parity. [VERIFIED: docs/port/windows-launcher-slice.md; packages/launcher/BUILD.bazel] | Add a package-shaped build/smoke surface that executes the same runtime as `Slic3r-console.exe`. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Phase 28 follows Phase 24-26 Windows runtime foundation. [VERIFIED: .planning/STATE.md] | Maintainers can inspect package layout without adding new CLI behavior. [VERIFIED: .planning/REQUIREMENTS.md] |
| Shared parity evidence currently covers Windows runtime, not Windows packaged launcher. [VERIFIED: packages/parity/compare_windows_runtime.sh; .planning/REQUIREMENTS.md] | Phase 28 remains package-local smoke; Phase 29 owns shared Windows packaged parity evidence. [VERIFIED: .planning/ROADMAP.md] | Phase 29 is next in roadmap. [VERIFIED: .planning/ROADMAP.md] | Do not add `packages/parity` packaged evidence in Phase 28 unless needed for help fixture alignment. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |

**Deprecated/outdated:**

- Treating all Windows packaging-visible behavior as deferred is stale once Phase 28 lands; update Windows-specific docs to say the scoped console package tree exists while release-grade Windows packaging remains deferred. [VERIFIED: docs/port/windows-launcher-slice.md; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]
- Reusing legacy `Slic3r.exe` GUI or `slic3r-debug-console.exe` wrapper behavior is out of scope for Phase 28. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| None | All material claims in this research were verified against local repo files, local tool probes, official Bazel docs, the Bazel Central Registry, or pinned Bright Builds standards. | All | No assumption confirmation required. |

## Open Questions

None blocking. The planner should include `docs/port/README.md` in the docs task if implementation changes make its current Windows packaging sentence stale. [VERIFIED: docs/port/README.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Bazel/Bazelisk | Build and smoke targets. [VERIFIED: packages/launcher/BUILD.bazel] | Yes [VERIFIED: ./.planning/.tmp/bin/bazelisk --version] | 8.6.0 [VERIFIED: .bazelversion; ./.planning/.tmp/bin/bazelisk --version] | Use repo-local `./.planning/.tmp/bin/bazelisk`; no new install needed. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md] |
| Bash | Builder and smoke scripts. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh] | Yes [VERIFIED: bash --version] | GNU Bash 3.2.57 [VERIFIED: bash --version] | Keep scripts Bash 3.2-compatible. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh] |
| Rust/Cargo toolchain | Existing Rust CLI/help tests if help text changes. [VERIFIED: MODULE.bazel] | Yes [VERIFIED: cargo +1.94.1 --version; rustc +1.94.1 --version] | 1.94.1 [VERIFIED: MODULE.bazel; cargo +1.94.1 --version] | Use Bazel Rust targets if direct Cargo is unnecessary. [VERIFIED: packages/slic3r-rust/crates/slic3r_cli/BUILD.bazel] |
| `shfmt` | Shell formatting check. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md] | Yes [VERIFIED: shfmt --version] | 3.12.0 [VERIFIED: shfmt --version] | If unavailable on another machine, use `bash -n` plus Bazel smoke and document formatter gap. [CITED: https://raw.githubusercontent.com/bright-builds-llc/bright-builds-rules/05f8d7a6c9c2e157ec4f922a05273e72dab97676/standards/core/verification.md] |
| `mdformat` | Markdown docs check for non-summary docs. [VERIFIED: .planning/phases/27-linux-packaged-launcher-slice/27-VERIFICATION.md] | Yes [VERIFIED: mdformat --version] | 1.0.0 [VERIFIED: mdformat --version] | Use `git diff --check` if unavailable; never run `mdformat` on phase summaries. [VERIFIED: AGENTS.md] |
| PowerShell (`pwsh`) | Legacy Windows packaging reference only. [VERIFIED: packages/legacy-slic3r/package/win/package_win32.ps1] | No [VERIFIED: pwsh --version probe] | - | No fallback required because Phase 28 must not recreate the PowerShell/PAR package. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] |

**Missing dependencies with no fallback:**

- None for the scoped Phase 28 implementation. [VERIFIED: Environment Availability probes]

**Missing dependencies with fallback:**

- PowerShell is missing, but it is not required because the legacy Windows PowerShell script is a naming/scope reference only. [VERIFIED: pwsh --version probe; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|------------------|
| V2 Authentication | No. The phase adds local maintainer build/smoke scripts and no authentication flow. [VERIFIED: .planning/ROADMAP.md] | No auth control needed. [VERIFIED: .planning/ROADMAP.md] |
| V3 Session Management | No. The phase has no sessions. [VERIFIED: .planning/ROADMAP.md] | No session control needed. [VERIFIED: .planning/ROADMAP.md] |
| V4 Access Control | No external access-control boundary is added. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Keep inputs repo-owned through Bazel `data` and explicit script args. [CITED: https://bazel.build/reference/be/shell] |
| V5 Input Validation | Yes. Scripts accept local paths for the runtime executable, scope note, and output root. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh] | Resolve paths with the existing `resolve_input` pattern, quote all expansions, avoid `eval`, and use `set -euo pipefail`. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh] |
| V6 Cryptography | No. Signing and release-channel cryptography are explicitly out of scope. [VERIFIED: .planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md] | Do not add signing, key handling, or certificate code. [VERIFIED: .planning/ROADMAP.md] |

### Known Threat Patterns for Bazel/Bash Local Packaging

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Path confusion between runfiles, workspace paths, and `bazel-bin`. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh] | Tampering | Use the existing `resolve_input` function and list files in Bazel `data`. [VERIFIED: packages/launcher/package/linux/test_packaged_launcher.sh; packages/launcher/BUILD.bazel] |
| Shell word splitting or glob expansion on paths. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh] | Tampering | Quote every variable expansion and avoid arrays/features not needed for Bash 3.2. [VERIFIED: packages/launcher/package/linux/build_packaged_launcher.sh; bash --version] |
| Executing a user-supplied arbitrary binary by mistake. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh] | Spoofing | Default Bazel target data to `:windows_slic3r`; fallback only to the known `bazel-bin` Rust runtime path used by existing smoke scripts. [VERIFIED: packages/launcher/package/win/test_windows_launcher.sh; packages/launcher/BUILD.bazel] |
| Overclaiming installer/signing/release support. [VERIFIED: .planning/ROADMAP.md] | Repudiation | Put explicit deferred scope in `packaged_slice.txt`, `windows-launcher-slice.md`, and package README/docs. [VERIFIED: packages/launcher/package/linux/packaged_slice.txt; docs/port/windows-launcher-slice.md] |

## Sources

### Primary (HIGH confidence)

- `.planning/phases/28-windows-packaged-launcher-slice/28-CONTEXT.md` - locked Phase 28 artifact, startup, smoke, naming, and deferred-scope decisions.
- `.planning/REQUIREMENTS.md` - WPKG-01, WPKG-02, WPKG-03 definitions and traceability.
- `.planning/ROADMAP.md` - Phase 28 goal, success criteria, dependencies, and Phase 29/30 boundaries.
- `.planning/STATE.md` - current phase state and v1.7 non-goals.
- `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md` - repo-local and Bright Builds workflow constraints.
- `packages/launcher/BUILD.bazel` - existing launcher targets and where new Windows packaged targets belong.
- `packages/launcher/package/win/test_windows_launcher.sh` - existing Windows runtime smoke flow.
- `packages/launcher/package/linux/build_packaged_launcher.sh`, `packages/launcher/package/linux/test_packaged_launcher.sh`, `packages/launcher/package/linux/packaged_slice.txt` - Phase 27 package-tree pattern.
- `packages/slic3r-rust/crates/slic3r_cli/src/bin/slic3r_windows_runtime.rs` - direct Windows runtime entrypoint.
- `packages/legacy-slic3r/package/win/package_win32.ps1`, `packages/legacy-slic3r/package/common/shell.cpp` - legacy naming and out-of-scope wrapper/package behavior.
- `docs/port/windows-launcher-slice.md`, `docs/port/entrypoint-architecture.md`, `docs/port/contract-inventory.md`, `docs/port/package-map.md`, `docs/port/parity-matrix.md`, `docs/port/README.md` - documentation surfaces that currently describe Windows runtime/package scope.
- Official Bazel shell rules reference - `sh_binary` / `sh_test` behavior and attributes, last updated 2026-05-07. https://bazel.build/reference/be/shell
- Official Bazel general rules reference - `alias` / `filegroup` behavior. https://bazel.build/reference/be/general
- Official Bazel make variables reference - path substitution caveats and runfiles guidance. https://bazel.build/reference/be/make-variables
- Bazel Central Registry `rules_rust` 0.69.0 - module version exists and repo pin is valid. https://registry.bazel.build/modules/rules_rust/0.69.0
- `rules_rust` docs - Bzlmod setup and Rust toolchain extension shape. https://bazelbuild.github.io/rules_rust/

### Secondary (MEDIUM confidence)

- None. The implementation is constrained by local code and official docs.

### Tertiary (LOW confidence)

- None.

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - repo pins and local environment probes verify Bazel, rules_rust, Rust, Bash, shfmt, and mdformat; official Bazel docs verify shell-rule usage.
- Architecture: HIGH - Phase 28 context locks the direct runtime path, and Phase 27 code provides an immediately reusable package-tree pattern.
- Pitfalls: HIGH - pitfalls are grounded in existing local scripts, docs, prior Phase 27 verification, and explicit deferred scope.

**Research date:** 2026-05-23
**Valid until:** 2026-06-22 for repo-local planning, or sooner if `MODULE.bazel`, `packages/launcher/BUILD.bazel`, or Phase 28 context changes.
