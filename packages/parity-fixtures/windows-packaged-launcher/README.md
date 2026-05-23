# Windows Packaged Launcher Fixtures

These fixtures cover the bounded Phase 29 Windows packaged launcher parity
slice.

They prove the package-shaped tree produced by:

- `packages/launcher:windows_packaged_launcher_tree`

The shared behavior expectations are reused from the existing help, version,
config, export, and transform fixture bundles. These platform-specific files
cover only the Windows packaged tree layout and in-artifact scope note.

Included evidence:

- package file layout for `Slic3r-windows`
- `share/slic3r/packaged-slice.txt` contents
- direct packaged startup handoff through `Slic3r-console.exe`

Deferred:

- MSI, zip release archives, signing, GUI packaging, native Windows release
  output, cross-compiled release output, broad DLL bundling, and release
  channels
