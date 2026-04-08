#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
  repo_root="$(cd "${script_dir}/../../.." && pwd)"
fi
check_script="${repo_root}/tools/bazel/legacy/check_legacy_prereqs.sh"
if [[ ! -x "${check_script}" ]]; then
  check_script="${script_dir}/check_legacy_prereqs.sh"
fi

prereq_exports="$("${check_script}" --emit-shell)"
eval "${prereq_exports}"

package_dir="${LEGACY_ORACLE_PACKAGE_DIR}"
cpanm_path="${LEGACY_ORACLE_CPANM}"
boost_include="${LEGACY_ORACLE_BOOST_INCLUDEDIR}"
boost_lib="${LEGACY_ORACLE_BOOST_LIBRARYPATH}"
boost_system_mode="${LEGACY_ORACLE_BOOST_SYSTEM_MODE:-library}"
perl_lib="${LEGACY_ORACLE_PERL_LIB}"
perl_arch_lib="${LEGACY_ORACLE_PERL_ARCH_LIB}"
perl_bin="${package_dir}/local-lib/bin"

mkdir -p "${repo_root}/.planning/.tmp/bin"

if [[ ! -x "${repo_root}/.planning/.tmp/bin/cpanm" ]]; then
  ln -sf "${cpanm_path}" "${repo_root}/.planning/.tmp/bin/cpanm"
fi

if [[ -d "${perl_bin}" ]]; then
  export PATH="${perl_bin}:${PATH}"
fi
export PERL5LIB="${perl_arch_lib}:${perl_lib}${PERL5LIB:+:${PERL5LIB}}"

resolved_boost_lib="${boost_lib}"
if [[ "${boost_system_mode}" == "header_only" ]]; then
  compat_root="${repo_root}/.planning/.tmp/boost-compat"
  compat_lib_dir="${compat_root}/lib"
  shim_src="${compat_root}/boost_system_compat.c"
  shim_obj="${compat_root}/boost_system_compat.o"

  mkdir -p "${compat_lib_dir}"

  for lib in filesystem thread; do
    src="${boost_lib}/libboost_${lib}.a"
    if [[ -f "${src}" ]]; then
      ln -sf "${src}" "${compat_lib_dir}/$(basename "${src}")"
    fi
  done

  if [[ ! -f "${compat_lib_dir}/libboost_system.a" ]]; then
    cat > "${shim_src}" <<'EOF'
int boost_system_compat_stub = 0;
EOF
    clang -c "${shim_src}" -o "${shim_obj}"
    /usr/bin/libtool -static -o "${compat_lib_dir}/libboost_system.a" "${shim_obj}"
  fi

  resolved_boost_lib="${compat_lib_dir}"
fi

bootstrap_modules=(
  Devel::CheckLib
  ExtUtils::ParseXS
  ExtUtils::CppGuess
  ExtUtils::Typemaps
  ExtUtils::Typemaps::Basic
  ExtUtils::Typemaps::Default
  ExtUtils::XSpp
  local::lib
  Module::Build
  Module::Build::WithXSpp
)

need_bootstrap=false
for module_path in \
  "${perl_lib}/Devel/CheckLib.pm" \
  "${perl_lib}/ExtUtils/ParseXS.pm" \
  "${perl_lib}/ExtUtils/CppGuess.pm" \
  "${perl_lib}/ExtUtils/Typemaps.pm" \
  "${perl_lib}/ExtUtils/Typemaps/Basic.pm" \
  "${perl_lib}/ExtUtils/Typemaps/Default.pm" \
  "${perl_lib}/ExtUtils/XSpp.pm" \
  "${perl_lib}/local/lib.pm" \
  "${perl_lib}/Module/Build.pm" \
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

export BOOST_INCLUDEDIR="${boost_include}"
export BOOST_LIBRARYPATH="${resolved_boost_lib}"

/usr/bin/perl \
  -I../local-lib/lib/perl5 \
  -I"../local-lib/lib/perl5/$(/usr/bin/perl -MConfig -e 'print $Config{archname}')" \
  Build.PL

rm -f buildtmp/XS.c buildtmp/XS.o

./Build
