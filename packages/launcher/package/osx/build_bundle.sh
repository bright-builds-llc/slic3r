#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

rust_launcher="${1}"
startup_script="${2}"
icon_path="${3}"
slice_notes="${4}"
output_root="${5:-${repo_root}/.planning/.tmp/macos-packaged-launcher}"

resolve_input() {
	local path="${1}"
	if [[ "${path}" == /* ]]; then
		printf '%s\n' "${path}"
		return
	fi
	if [[ -e "${path}" ]]; then
		printf '%s/%s\n' "$(cd "$(dirname "${path}")" && pwd)" "$(basename "${path}")"
		return
	fi
	printf '%s/%s\n' "${repo_root}" "${path}"
}

resolved_rust_launcher="$(resolve_input "${rust_launcher}")"
startup_script="$(resolve_input "${startup_script}")"
icon_path="$(resolve_input "${icon_path}")"
slice_notes="$(resolve_input "${slice_notes}")"

if [[ -x "${resolved_rust_launcher}" ]]; then
	rust_launcher="${resolved_rust_launcher}"
else
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

app_root="${output_root}/Slic3r.app"
macos_root="${app_root}/Contents/MacOS"
resources_root="${app_root}/Contents/Resources"
info_plist="${app_root}/Contents/Info.plist"
pkg_info="${app_root}/Contents/PkgInfo"
version="$("${rust_launcher}" --version | tr -d '\n')"

printf 'Preparing packaged macOS launcher bundle at %s\n' "${app_root}"
rm -rf "${app_root}"
mkdir -p "${macos_root}" "${resources_root}"

printf 'Copying Rust launcher binary...\n'
cp -f "${rust_launcher}" "${macos_root}/slic3r_cli"
chmod +x "${macos_root}/slic3r_cli"

printf 'Copying startup script...\n'
cp -f "${startup_script}" "${macos_root}/Slic3r"
chmod +x "${macos_root}/Slic3r"

if [[ -f "${icon_path}" ]]; then
	printf 'Copying bundle icon...\n'
	cp -f "${icon_path}" "${resources_root}/Slic3r.icns"
fi

printf 'Copying packaged slice notes...\n'
cp -f "${slice_notes}" "${resources_root}/packaged-slice.txt"

cat >"${info_plist}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>Slic3r</string>
  <key>CFBundleIdentifier</key>
  <string>org.slic3r.packaged-launcher</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Slic3r</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>${version}</string>
  <key>CFBundleVersion</key>
  <string>${version}</string>
  <key>CFBundleIconFile</key>
  <string>Slic3r.icns</string>
  <key>LSMinimumSystemVersion</key>
  <string>10.13</string>
</dict>
</plist>
EOF

printf 'APPL????' >"${pkg_info}"

printf 'Packaged launcher ready: %s\n' "${app_root}"
