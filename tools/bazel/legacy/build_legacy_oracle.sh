#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
  repo_root="$(cd "${script_dir}/../../.." && pwd)"
fi
check_script="${script_dir}/check_legacy_prereqs.sh"

eval "$("${check_script}" --emit-shell)"

package_dir="${LEGACY_ORACLE_PACKAGE_DIR}"
cpanm_path="${LEGACY_ORACLE_CPANM}"
boost_include="${LEGACY_ORACLE_BOOST_INCLUDEDIR}"
boost_lib="${LEGACY_ORACLE_BOOST_LIBRARYPATH}"
perl_lib="${LEGACY_ORACLE_PERL_LIB}"
perl_arch_lib="${LEGACY_ORACLE_PERL_ARCH_LIB}"

mkdir -p "${repo_root}/.planning/.tmp/bin"

if [[ ! -x "${repo_root}/.planning/.tmp/bin/cpanm" ]]; then
  ln -sf "${cpanm_path}" "${repo_root}/.planning/.tmp/bin/cpanm"
fi

bootstrap_modules=(
  Devel::CheckLib
  ExtUtils::CppGuess
  Module::Build::WithXSpp
)

need_bootstrap=false
for module_path in \
  "${perl_lib}/Devel/CheckLib.pm" \
  "${perl_lib}/ExtUtils/CppGuess.pm" \
  "${perl_lib}/Module/Build/WithXSpp.pm"
do
  if [[ ! -f "${module_path}" ]]; then
    need_bootstrap=true
    break
  fi
done

if [[ "${need_bootstrap}" == true ]]; then
  "${cpanm_path}" --local-lib="${package_dir}/local-lib" --notest "${bootstrap_modules[@]}"
fi

cd "${package_dir}/xs"

/usr/bin/perl \
  -I../local-lib/lib/perl5 \
  -I"../local-lib/lib/perl5/$(/usr/bin/perl -MConfig -e 'print $Config{archname}')" \
  Build.PL

./Build
