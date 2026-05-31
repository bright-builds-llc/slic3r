# PrusaSlicer Drift-Refresh Record

This Phase 37 record applies the manual drift-refresh protocol to the accepted
v1.9 PrusaSlicer source pin. It records maintainer-review fields for the narrow
v1.10 profile schema/config evidence slice without updating accepted source
pins.

Run the current comparison command before consuming this gate:

```bash
bazel run //packages/fork-vendors:verify
```

## Accepted Source Baseline

| Field | Maintainer Entry |
| --- | --- |
| Vendor | `prusaslicer` |
| Display name | `PrusaSlicer` |
| Upstream repo | `https://github.com/prusa3d/PrusaSlicer` |
| Selected stable tag | `version_2.9.5` |
| Tag kind | `annotated` |
| Tag ref SHA | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` |
| Tag object SHA | `29bfec81347bd07dc738269d2c010fe4c4a5dc07` |
| Peeled commit | `9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Default branch | `master` |
| Recorded observed branch head | `43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b` |
| Source pin | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Source paths | `src;resources;doc;tests;version.inc` |

## Reviewer Record

| Field | Maintainer Entry |
| --- | --- |
| Review date | PENDING - human reviewer UTC date required before implementation consumes this gate. |
| Vendor | `prusaslicer` |
| Upstream repo | `https://github.com/prusa3d/PrusaSlicer` |
| Selected stable tag | `version_2.9.5` |
| Selected stable tag confirmation | confirmed by bazel run //packages/fork-vendors:verify during Phase 37 execution |
| Peeled commit | `9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Peeled commit confirmation | confirmed by bazel run //packages/fork-vendors:verify during Phase 37 execution |
| Branch drift observation | none observed during Phase 37 execution |
| Reviewer decision | PENDING - human reviewer must choose keep accepted source pin, plan future intake update, or defer before implementation consumes this gate. |
| Reviewer signoff | PENDING - human reviewer name and UTC date required before implementation consumes this gate. |

## Boundary

Branch-head data is drift-only observation.
accepted source pins remain unchanged unless a future reviewed intake update
modifies packages/fork-vendors/forks.tsv.

Do not clone upstream repositories, fetch worktrees, build upstream fork source
trees, import fork source files, vendor upstream fork source trees, schedule
sync, update source refs automatically, or create an automatic source refresh
path in Phase 37.
