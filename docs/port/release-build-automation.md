# Release Build Automation

Phase 31 adds a scoped GitHub Actions release build workflow for the base
Rust-backed Slic3r package. It turns the already verified packaged launcher
surfaces into downloadable workflow artifacts for macOS, Linux, and Windows.

## Workflow

The workflow is named `Release Build Artifacts` and lives at
`.github/workflows/release-build-artifacts.yml`.

It runs on:

- `workflow_dispatch`
- pushes to tags matching `v*`

The matrix builds on:

- `macos-latest`
- `ubuntu-latest`
- `windows-latest`

The Windows job sets `BAZEL_OUTPUT_USER_ROOT=C:/b` so Bazel and MSVC use a
short output path on hosted Windows runners.

Each matrix job checks out the repo, sets up Bazelisk, runs the repo-owned
release artifact script, and uploads the generated archive and manifest with
`actions/upload-artifact`.

CI outputs are written under `release-artifacts/` so upload-artifact does not
need to include hidden paths.

## Local Command

Build one platform artifact locally:

```bash
bash tools/release/build_release_artifact.sh macos
```

Build every scoped platform artifact locally:

```bash
bash tools/release/build_release_artifact.sh all
```

Local outputs are written under `.planning/.tmp/release-builds/` by default.

## Artifact Contents

The release artifact script reuses the existing package builders:

| Platform | Package target | Artifact root |
| --- | --- | --- |
| macOS | `//packages/launcher:macos_packaged_launcher_bundle` | `Slic3r.app` |
| Linux | `//packages/launcher:linux_packaged_launcher_tree` | `Slic3r-linux` |
| Windows | `//packages/launcher:windows_packaged_launcher_tree` | `Slic3r-windows` |

Each platform output includes `release-provenance.txt` inside the package tree:

- macOS: `Slic3r.app/Contents/Resources/release-provenance.txt`
- Linux: `Slic3r-linux/share/slic3r/release-provenance.txt`
- Windows: `Slic3r-windows/share/slic3r/release-provenance.txt`

The provenance file records:

- product
- platform
- commit and short commit
- ref
- GitHub run id and attempt, or `local`
- build mode and Bazel compilation mode
- supported package scope
- package target
- evidence target
- creation timestamp
- dirty worktree state
- explicit out-of-scope release surfaces

The script also writes a `release-manifest.txt` beside the archive and a
`.sha256` checksum file beside each `.tar.gz` archive.

## Evidence Gate

The workflow runs the existing packaged launcher parity evidence before
uploading artifacts:

| Platform | Evidence target |
| --- | --- |
| macOS | `//packages/parity:macos_packaged_launcher_parity` |
| Linux | `//packages/parity:linux_packaged_launcher_parity` |
| Windows | `//packages/parity:windows_packaged_launcher_parity` |

This keeps release build automation tied to the same checked-in evidence used
by the parity status surfaces instead of creating a parallel release-only proof
path.

## Scope Boundaries

These artifacts are scoped release build outputs for the base Rust-backed
Slic3r package and the verified help/version/config/export/transform slice.

They are not:

- signing or notarization evidence
- GitHub Release publications
- AppImage, MSI, DMG, deb, rpm, Flatpak, Snap, or installer-grade packages
- GUI packages
- release-channel publishing
- fork-flavor builds
- proof of new CLI behavior beyond the verified slice
