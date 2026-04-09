# Contract Inventory

This registry enumerates the externally visible contracts the Rust port must
preserve. Use [`parity-matrix.md`](./parity-matrix.md) for the short status
dashboard and [`migration-guidance.md`](./migration-guidance.md) for the rules
that govern how later phases should move these surfaces.

## Evidence Status

| Status | Meaning |
| --- | --- |
| `trusted-oracle` | The legacy surface is anchored to repo source and is currently exercised by the trusted macOS oracle check `//:legacy_oracle_smoke`. |
| `source-only` | Repo source defines the contract, but the trusted oracle does not exercise it yet. |
| `source-plus-deferred` | Repo source defines the contract and there is additional evidence, but that evidence is broader, weaker, or currently deferred rather than trusted. |

## CLI Behavior

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Help, version, mode-selection, and top-level runtime flags such as `--help`, `--version`, `--gui`, `--no-gui`, `-j`/`--threads`, and `--datadir` | `packages/legacy-slic3r/slic3r.pl`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r` | `//:legacy_oracle_smoke` via `tools/bazel/legacy/test_legacy_smoke.sh` | `trusted-oracle` | Inventoried now; still legacy-only | `_slic3r` cross-checks option spellings and descriptions that the smoke test does not parse deeply | Later CLI phases still need option-by-option behavioral parity, not just usage parity | `packages/slic3r-rust`, `packages/launcher` |
| Geometry, repair, merge, split, and layout operations such as `--repair`, `--cut`, `--cut-grid`, `--split`, `--merge`, `--info`, `--print-center`, and `--dont-arrange` | `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` only proves the retained CLI entry path exists, not these behaviors specifically | `source-plus-deferred` | Phase 13 moves the scoped single-input `--info`, `--repair`, and `--split` slice into the Rust-backed path, and Phase 14 verifies that bounded slice through shared fixtures; merge, cut, cut-grid, and layout remain deferred | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` exercises layout behavior such as `--center` and `--dont-arrange` | The trusted oracle still does not exercise these behaviors end to end, so the verified scope stays bounded to the shared fixture slice | `packages/slic3r-rust` |

## Config Semantics

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CLI-to-config overlay order, shortcut expansion, and external config loading semantics | `packages/legacy-slic3r/slic3r.pl`, `packages/legacy-slic3r/lib/Slic3r/Config.pm` | No stronger trusted check than the retained CLI smoke path today | `source-only` | Inventoried now; still legacy-only | `Slic3r::Config->new_from_cli`, `normalize`, and the `--load` handling in `slic3r.pl` define the current merge order | Later config work should preserve observable overlay rules before redesigning internals | `packages/slic3r-rust` |
| INI persistence, serialization shape, and config-file save/load behavior | `packages/legacy-slic3r/lib/Slic3r/Config.pm`, `packages/legacy-slic3r/slic3r.pl` | No stronger trusted check than the retained CLI smoke path today | `source-plus-deferred` | Inventoried now; still legacy-only | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` covers `--save`, and `packages/legacy-slic3r/lib/Slic3r/GUI.pm` shows `slic3r.ini` datadir handling | The fixture corpus does not exist yet, so config round-trip parity remains a later proof step | `packages/slic3r-rust` |
| Validation rules for numeric, enum, and feature-gated print settings | `packages/legacy-slic3r/lib/Slic3r/Config.pm` | No stronger trusted check than the retained CLI smoke path today | `source-only` | Inventoried now; still legacy-only | The source explicitly validates items such as `threads`, `first_layer_height`, `gcode_flavor`, and `fill_pattern` | Exhaustive per-option extraction is deferred to later contract-oriented Rust module work | `packages/slic3r-rust` |

## Supported File Formats

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Model input formats accepted by the retained CLI path | `packages/legacy-slic3r/slic3r.pl`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r` | `//:legacy_oracle_smoke` only proves the retained CLI help path | `source-only` | Inventoried now; still legacy-only | `_slic3r` advertises `stl`, `obj`, `amf`, and `xml` input files, while `slic3r.pl` routes input files through `Slic3r::Model->read_from_file(...)` | Format-by-format parsing parity and fixture coverage are deferred to later phases | `packages/slic3r-rust` |
| Export format families exposed through the legacy CLI | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r`, `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` does not exercise format exports directly | `source-plus-deferred` | Phase 14 now verifies the scoped Rust-backed export families through shared fixtures: G-code, STL, OBJ, AMF, 3MF, layered SVG, and SLA SVG | `test_cli.cpp` covers `gcode`, `obj`, `pov`, `amf`, `3mf`, `svg`, and `stl` export paths | The broader direct retained-oracle proof is still weaker than the fixture-backed scoped slice, and `pov` remains deferred | `packages/slic3r-rust` |

## Generated Outputs

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Default output naming, explicit `--output`, and `--output-filename-format` behavior | `packages/legacy-slic3r/slic3r.pl`, `packages/legacy-slic3r/utils/zsh/functions/_slic3r` | `//:legacy_oracle_smoke` does not exercise output creation | `source-plus-deferred` | Inventoried now; still legacy-only | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` checks output overrides such as `output.stl` and `output.svg` | Later parity work must prove both generated filenames and file contents | `packages/slic3r-rust` |
| Repair, cut, and split output naming conventions such as `_fixed.obj`, `_upper.stl`, `_lower.stl`, and numbered split files | `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` does not exercise output creation | `source-only` | Phase 13 moves the scoped `_fixed.obj` and numbered split-file naming slice into the Rust-backed path, and Phase 14 verifies that bounded slice through shared fixtures; cut outputs remain deferred | The implementation itself encodes these filename conventions in the retained CLI path | The verified scope covers repair and split only; cut-derived outputs remain deferred | `packages/slic3r-rust` |
| Layered SVG, SLA SVG, and exported artifact creation patterns | `packages/legacy-slic3r/src/test/GUI/test_cli.cpp` | `//:legacy_oracle_smoke` does not exercise output creation | `source-plus-deferred` | Phase 14 now verifies the bounded Rust-backed layered SVG and SLA SVG artifact patterns through shared fixtures | Legacy CLI tests assert numbered SVG output for slice export and single-SVG behavior for SLA flows | Output-content parity is later work; Phase 14 verifies only the bounded supported artifact pattern | `packages/slic3r-rust` |

## Launcher Path

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Direct retained script entrypoint and CLI-versus-GUI dispatch | `packages/legacy-slic3r/slic3r.pl` | `//:legacy_oracle_smoke` via `tools/bazel/legacy/test_legacy_smoke.sh` | `trusted-oracle` | Inventoried now; still legacy-only | The option completion file `_slic3r` reinforces the visible CLI flag surface | Later launcher work may replace the implementation, but not the user-visible handoff contract, without explicit migration docs | `packages/launcher` |
| macOS and Linux packaged startup scripts that bootstrap bundled Perl and environment state | `packages/legacy-slic3r/package/osx/startup_script.sh`, `packages/legacy-slic3r/package/linux/startup_script.sh` | No trusted packaged-oracle check exists today | `source-plus-deferred` | Inventoried now; implementation deferred | The scripts show that packaged launch behavior includes bundled `perl-local`, `local-lib`, and on Linux `LD_LIBRARY_PATH` setup | Packaged launcher parity is visible behavior even though Phase 4 does not implement it | `packages/launcher` |
| Windows wrapper executable and packaged binary handoff to `slic3r.pl` | `packages/legacy-slic3r/package/common/shell.cpp`, `packages/legacy-slic3r/package/win/package_win32.ps1` | No trusted packaged-oracle check exists today | `source-plus-deferred` | Inventoried now; Windows implementation deferred beyond the current milestone | The wrapper and packaging script show the current executable names, argument forwarding, and packaging expectations | Windows remains deferred, but the contract still belongs in the inventory now | `packages/launcher` |

## Packaging-Visible Behavior

| Contract Item | Legacy Source of Truth | Trusted Check | Evidence Status | Current Scope | Weaker Or Deferred Evidence | Deferred Notes | Future Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| macOS app bundle and DMG naming, bundled resources, and packaged startup artifact layout | `packages/legacy-slic3r/package/osx/make_dmg.sh`, `packages/legacy-slic3r/package/osx/startup_script.sh` | No trusted packaging-oracle check exists today | `source-plus-deferred` | Inventoried now; macOS packaging implementation deferred | The packaging script defines `.app` structure, bundled resources, copied `slic3r.pl`, and DMG naming conventions | macOS is the first platform priority, but packaging parity still comes after CLI/core parity work | `packages/launcher`, repo-root packaging glue |
| Linux archive and AppImage naming, desktop metadata, and AppRun surface | `packages/legacy-slic3r/package/linux/make_archive.sh`, `packages/legacy-slic3r/package/linux/appimage.sh`, `packages/legacy-slic3r/package/linux/startup_script.sh` | No trusted packaging-oracle check exists today | `source-plus-deferred` | Inventoried now; Linux implementation deferred to a later milestone | The retained scripts define archive names, AppImage assembly, desktop metadata, and bundled runtime layout | Linux is explicitly deferred for later parity milestones, but the visible package contract is still tracked here | `packages/launcher`, repo-root packaging glue |
| Windows archive naming and bundled executable set | `packages/legacy-slic3r/package/win/package_win32.ps1`, `packages/legacy-slic3r/package/common/shell.cpp` | No trusted packaging-oracle check exists today | `source-plus-deferred` | Inventoried now; Windows implementation deferred to a later milestone | The retained packaging script defines archive naming and packaged executables such as `Slic3r.exe` and `Slic3r-console.exe` | Windows parity is outside the current milestone, so this inventory is the only current contract record | `packages/launcher`, repo-root packaging glue |
