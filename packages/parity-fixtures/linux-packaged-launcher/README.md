# Linux Packaged Launcher Fixtures

These fixtures cover the bounded Phase 29 Linux packaged launcher parity slice.

They prove the package-shaped tree produced by:

- `packages/launcher:linux_packaged_launcher_tree`

The shared behavior expectations are reused from the existing help, version,
config, export, and transform fixture bundles. These platform-specific files
cover only the Linux packaged tree layout and in-artifact scope note.

Included evidence:

- package file layout for `Slic3r-linux`
- `share/slic3r/packaged-slice.txt` contents
- packaged startup handoff through `bin/slic3r`

Deferred:

- AppImage, deb, rpm, Flatpak, Snap, signing, GUI packaging, and release
  channels
