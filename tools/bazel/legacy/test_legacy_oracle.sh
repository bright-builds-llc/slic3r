#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
  repo_root="$(cd "${script_dir}/../../.." && pwd)"
fi
package_dir="${repo_root}/packages/legacy-slic3r"
build_wrapper="${repo_root}/tools/bazel/legacy/build_legacy_oracle.sh"

"${build_wrapper}"

archname="$(/usr/bin/perl -MConfig -e 'print $Config{archname}')"

cd "${package_dir}"

/usr/bin/prove \
  -Ilib \
  -Ilocal-lib/lib/perl5 \
  -I"local-lib/lib/perl5/${archname}" \
  t/angles.t \
  t/clipper.t
