# Codebase Concerns

**Analysis Date:** 2026-04-06

## Tech Debt

**Legacy CI and packaging scripts:**
- `package/linux/travis-build-main.sh`, `package/linux/travis-build-cpp.sh`, `package/osx/travis-build-main.sh`, `package/osx/travis-build-cpp.sh`, `package/win/appveyor_buildscript.ps1`, and `package/win/appveyor_preinstall.ps1` still encode the Travis/AppVeyor era of the project.
- `package/deploy/bintray.sh`, `package/deploy/sftp.sh`, and `package/deploy/sftp-symlink.sh` still assume the old release distribution flow.
- Why it matters: these scripts are still valuable reference material, but they are not a coherent modern release pipeline and are easy to break if someone tries to reuse them as-is.
- Fix approach: either retire them explicitly or rewrite them around the current release process so the active packaging path is obvious.

**Split test ecosystems:**
- `src/test/` is the newer Catch2-based test tree, while `t/` and `xs/t/` remain in the repo even though `README.md` marks them as deprecated.
- `Build.PL` still bootstraps and runs tests through Perl tooling such as `App::Prove`, which keeps the old Perl-facing path alive beside the C++ test harness.
- Why it matters: contributors have to understand two different test models, and coverage can drift between them.
- Fix approach: keep `src/test/` as the primary harness and reduce the role of the deprecated Perl test paths over time.

**Large orchestration entry points:**
- `src/slic3r.cpp`, `src/GUI/Plater.cpp`, and `src/GUI/MainFrame.cpp` each coordinate many unrelated responsibilities in one place.
- The TODOs in those files show the strain directly, for example the `src/slic3r.cpp` note about copying less stuff around and the `src/GUI/MainFrame.cpp` note about reimplementing the config wizard.
- Why it matters: these are change-heavy files where a small edit can affect object loading, transforms, GUI wiring, and export behavior at once.
- Fix approach: keep moving behavior into smaller helpers or lower-level modules and leave these files as thin orchestration layers.

## Known Bugs

**Output rename failure can leave temporary files behind:**
- `lib/Slic3r/Print.pm` writes G-code to `$output_file.tmp`, then retries the rename only five times before logging a warning.
- Why it matters: locked destinations or platform-specific rename issues can leave stale `.tmp` files or a missing final output, especially on Windows.
- Workaround: rerun the export after clearing the destination file lock.
- Fix approach: centralize output writing and surface a stronger failure path when the rename never succeeds.

## Security Considerations

**Unencrypted bootstrap and artifact downloads:**
- `Build.PL` still documents `curl -L http://cpanmin.us`.
- `package/linux/travis-build-main.sh`, `package/linux/travis-build-cpp.sh`, `package/osx/travis-build-cpp.sh`, `package/win/appveyor_preinstall.ps1`, and `package/win/appveyor_buildscript.ps1` download toolchains and dependencies from old build servers and artifact hosts, often over plain HTTP.
- Why it matters: these flows are vulnerable to supply-chain tampering if anyone reuses them outside a trusted, controlled environment.
- Current mitigation: the scripts are mostly historical/CI-era tooling rather than the active day-to-day workflow.
- Recommendations: prefer authenticated, pinned, modern package sources and keep old bootstrap scripts clearly marked as legacy.

**Config-driven script execution:**
- `lib/Slic3r/Print.pm` runs configured post-processing scripts directly with `system($executable, @parsed_script)`.
- Why it matters: this is safe only when project files and print configs are trusted. A malicious or unexpected config can still trigger arbitrary local binaries.
- Current mitigation: the code avoids shell interpolation and checks that the executable path exists.
- Recommendations: keep warning users that post-processing is a trusted-input feature and avoid opening unknown project files with elevated trust.

**Release credentials live in the repo tree:**
- `package/deploy/slic3r-upload.ppk.enc` and `package/deploy/slic3r-upload.rsa.enc` are encrypted deployment keys.
- Why it matters: even encrypted key material should stay tightly scoped to trusted release automation and reviewed carefully when packaging scripts change.
- Recommendations: avoid broadening the deployment surface and keep the decryption path restricted to trusted CI or release steps.

## Performance Bottlenecks

**Copy-heavy CLI model transforms:**
- `src/slic3r.cpp` merges, duplicates, cuts, and reassigns whole `Model` objects in several transform branches.
- The file itself calls out the problem with TODOs like “copy less stuff around using pointers”.
- Why it matters: large plates or multi-object inputs will pay for repeated model copying and allocation churn.
- Improvement path: move toward shared ownership or narrower mutation points for transforms that currently rebuild whole models.

**Whole-job in-memory processing:**
- `lib/Slic3r/Print.pm` runs infill, support generation, skirt, brim, and export in one in-memory pipeline.
- Why it matters: large prints can consume a lot of memory before the final G-code write begins, and long jobs are harder to interrupt cleanly.
- Improvement path: keep the pipeline incremental where possible and avoid materializing more intermediate geometry than needed.

## Fragile Areas

**Legacy test helpers depend on repo-local layout:**
- `t/support.t` and the rest of `t/` expect `../lib` and `../local-lib` from the repository root.
- Why it matters: moving the test tree, running from an unexpected working directory, or refreshing dependencies out of band can break these tests even when the code is fine.
- Safe modification: preserve the repo-relative setup or migrate the old tests together with their bootstrap assumptions.
- Test coverage: the newer Catch2 suite in `src/test/` is less tied to the Perl bootstrap path.

**GUI event wiring is tightly coupled:**
- `src/GUI/Plater.cpp` and `src/GUI/MainFrame.cpp` create large widget trees, bind callbacks inline, and interleave state setup with UI construction.
- Why it matters: a small change in one control can ripple into selection, preview, and status bar behavior.
- Safe modification: keep GUI changes local, add focused tests where possible, and avoid bundling unrelated widget setup into the same edit.

**Temporary-file export flow is only lightly protected:**
- `lib/Slic3r/Print.pm` uses a plain `*.tmp` output path and only a short retry loop before giving up.
- Why it matters: failure modes are noisy but not fatal in a way that automatically repairs the output path, so users can end up with stale files.
- Safe modification: if you touch export behavior, keep the rename and cleanup behavior explicit and tested on the target platform.

