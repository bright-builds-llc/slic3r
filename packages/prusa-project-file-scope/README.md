# Prusa Project-File Scope Gate

`packages/prusa-project-file-scope` owns the Phase 41 reviewed scope gate for
`prusaslicer.project-file`.

Run the package verifier with:

```bash
bazel run //packages/prusa-project-file-scope:verify
```

Phase 41 verification does not prove executable Prusa project-file parity.
Phase 41 verification does not prove full 3MF import/export, full PrusaSlicer runtime support, or GUI project behavior.

This package creates no fixture bytes, expected artifacts, Rust parser, parity command, status row, upstream source import, vendored fork source tree, Git/network/vendor sync behavior, profile auto-update execution, network/device integration, credential handling, Bambu Studio support, OrcaSlicer support, or fork release build.

## Records

- [`project-file-scope.md`](project-file-scope.md) records the Phase 41
  maintainer scope gate for `prusaslicer.project-file`.

## Boundary

This package is a scope gate only. It records the reviewed source identity,
downstream fixture contract, planned Rust boundary, planned evidence command,
planned status token, and deferred scope before later phases consume them.
