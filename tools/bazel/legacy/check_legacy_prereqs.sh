#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
  repo_root="$(cd "${script_dir}/../../.." && pwd)"
fi
legacy_dir="${repo_root}/packages/legacy-slic3r"

emit_shell=false
if [[ "${1:-}" == "--emit-shell" ]]; then
  emit_shell=true
fi

fail() {
  printf 'legacy oracle prerequisites failed: %s\n' "$1" >&2
  exit 1
}

resolve_cpanm() {
  local maybe_cp
  if [[ -n "${CPANM:-}" && -x "${CPANM}" ]]; then
    printf '%s\n' "${CPANM}"
    return 0
  fi

  maybe_cp="$(command -v cpanm || true)"
  if [[ -n "${maybe_cp}" ]]; then
    printf '%s\n' "${maybe_cp}"
    return 0
  fi

  for candidate in \
    "${repo_root}/.planning/.tmp/bin/cpanm" \
    "${repo_root}/.planning/.tmp/cpanm"
  do
    if [[ -x "${candidate}" ]]; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  fail "cpanm is required for the retained legacy oracle path. Install it or set CPANM=/path/to/cpanm."
}

resolve_boost_dir() {
  local include_dir lib_dir prefix

  include_dir="${BOOST_INCLUDEDIR:-}"
  lib_dir="${BOOST_LIBRARYPATH:-}"

  if [[ -n "${include_dir}" || -n "${lib_dir}" ]]; then
    [[ -n "${include_dir}" && -d "${include_dir}" ]] || fail "BOOST_INCLUDEDIR must point to an existing directory."
    [[ -n "${lib_dir}" && -d "${lib_dir}" ]] || fail "BOOST_LIBRARYPATH must point to an existing directory."
  else
    for prefix in \
      "${BOOST_DIR:-}" \
      "$(command -v brew >/dev/null 2>&1 && brew --prefix boost 2>/dev/null || true)" \
      /opt/homebrew/opt/boost \
      /usr/local/opt/boost
    do
      [[ -n "${prefix}" ]] || continue
      if [[ -d "${prefix}/include" && -d "${prefix}/lib" ]]; then
        include_dir="${prefix}/include"
        lib_dir="${prefix}/lib"
        break
      fi
    done
  fi

  [[ -n "${include_dir}" && -d "${include_dir}" ]] || fail "Boost headers were not found. Set BOOST_INCLUDEDIR or install a compatible Boost distribution."
  [[ -n "${lib_dir}" && -d "${lib_dir}" ]] || fail "Boost libraries were not found. Set BOOST_LIBRARYPATH or install a compatible Boost distribution."

  [[ -f "${include_dir}/boost/version.hpp" ]] || fail "Boost headers are incomplete at ${include_dir}."

  local required_lib
  for required_lib in system filesystem thread; do
    if ! find "${lib_dir}" -maxdepth 1 \( -name "libboost_${required_lib}.a" -o -name "libboost_${required_lib}.dylib" \) | grep -q .; then
      fail "Boost library boost_${required_lib} was not found under ${lib_dir}. Install a Boost distribution with system/filesystem/thread or point BOOST_LIBRARYPATH at one."
    fi
  done

  printf '%s\n%s\n' "${include_dir}" "${lib_dir}"
}

[[ -x /usr/bin/perl ]] || fail "System perl is required at /usr/bin/perl."
[[ -d "${legacy_dir}" ]] || fail "Retained legacy package not found at ${legacy_dir}."
[[ -d /Applications/Xcode.app/Contents/Developer || -n "$(xcode-select -p 2>/dev/null || true)" ]] || fail "Xcode Command Line Tools are required on macOS."

cpanm_path="$(resolve_cpanm)"
boost_paths="$(resolve_boost_dir)"
boost_include="$(printf '%s\n' "${boost_paths}" | sed -n '1p')"
boost_lib="$(printf '%s\n' "${boost_paths}" | sed -n '2p')"
archname="$(/usr/bin/perl -MConfig -e 'print $Config{archname}')"
perl_lib="${legacy_dir}/local-lib/lib/perl5"
perl_arch_lib="${perl_lib}/${archname}"

if [[ "${emit_shell}" == true ]]; then
  cat <<EOF
export LEGACY_ORACLE_PACKAGE_DIR='${legacy_dir}'
export LEGACY_ORACLE_CPANM='${cpanm_path}'
export LEGACY_ORACLE_BOOST_INCLUDEDIR='${boost_include}'
export LEGACY_ORACLE_BOOST_LIBRARYPATH='${boost_lib}'
export LEGACY_ORACLE_PERL_LIB='${perl_lib}'
export LEGACY_ORACLE_PERL_ARCH_LIB='${perl_arch_lib}'
EOF
else
  cat <<EOF
Legacy oracle prerequisites satisfied.
  package: ${legacy_dir}
  cpanm: ${cpanm_path}
  boost include: ${boost_include}
  boost lib: ${boost_lib}
  perl lib: ${perl_lib}
  perl arch lib: ${perl_arch_lib}
EOF
fi
