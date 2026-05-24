#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: build_release_artifact.sh <macos|linux|windows|all> [output-root]

Builds a scoped base Slic3r release artifact from the existing Bazel packaged
launcher targets. The script runs the matching packaged launcher parity target
before materializing and archiving the package tree.
EOF
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
	usage
	exit 64
fi

platform="${1}"
requested_output_root="${2:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! repo_root="$(git -C "${script_dir}" rev-parse --show-toplevel 2>/dev/null)"; then
	repo_root="$(cd "${script_dir}/../.." && pwd)"
fi

if [[ -z "${requested_output_root}" ]]; then
	output_root="${repo_root}/.planning/.tmp/release-builds"
elif [[ "${requested_output_root}" == /* ]]; then
	output_root="${requested_output_root}"
else
	output_root="${repo_root}/${requested_output_root}"
fi

if [[ "${platform}" == "all" ]]; then
	for next_platform in macos linux windows; do
		"${BASH_SOURCE[0]}" "${next_platform}" "${output_root}"
	done
	exit 0
fi

case "${platform}" in
macos)
	package_target="//packages/launcher:macos_packaged_launcher_bundle"
	evidence_target="//packages/parity:macos_packaged_launcher_parity"
	artifact_dir_name="Slic3r.app"
	provenance_relative_path="Slic3r.app/Contents/Resources/release-provenance.txt"
	package_scope="scoped macOS packaged launcher bundle for the verified help/version/config/export/transform slice"
	;;
linux)
	package_target="//packages/launcher:linux_packaged_launcher_tree"
	evidence_target="//packages/parity:linux_packaged_launcher_parity"
	artifact_dir_name="Slic3r-linux"
	provenance_relative_path="Slic3r-linux/share/slic3r/release-provenance.txt"
	package_scope="scoped Linux package-shaped launcher tree for the verified help/version/config/export/transform slice"
	;;
windows)
	package_target="//packages/launcher:windows_packaged_launcher_tree"
	evidence_target="//packages/parity:windows_packaged_launcher_parity"
	artifact_dir_name="Slic3r-windows"
	provenance_relative_path="Slic3r-windows/share/slic3r/release-provenance.txt"
	package_scope="scoped Windows package-shaped launcher tree for the verified help/version/config/export/transform slice"
	;;
*)
	printf 'Unsupported release platform: %s\n\n' "${platform}" >&2
	usage >&2
	exit 64
	;;
esac

bazel_cmd="${BAZEL:-bazel}"
compilation_mode="${BAZEL_COMPILATION_MODE:-opt}"
build_mode="${BUILD_MODE:-bazel-${compilation_mode}}"
platform_root="${output_root}/${platform}"
package_output_root="${platform_root}/package"
archive_root="${platform_root}/archives"
manifest_path="${platform_root}/release-manifest.txt"
artifact_root="${package_output_root}/${artifact_dir_name}"
provenance_path="${package_output_root}/${provenance_relative_path}"

run_bazel() {
	if [[ -n "${BAZEL_OUTPUT_USER_ROOT:-}" ]]; then
		"${bazel_cmd}" "--output_user_root=${BAZEL_OUTPUT_USER_ROOT}" "$@"
		return
	fi

	"${bazel_cmd}" "$@"
}

printf 'Preparing release artifact workspace: %s\n' "${platform_root}"
rm -rf "${platform_root}"
mkdir -p "${package_output_root}" "${archive_root}"

printf 'Verifying packaged launcher evidence for %s...\n' "${platform}"
run_bazel run --compilation_mode="${compilation_mode}" "${evidence_target}"

printf 'Building %s package tree with %s...\n' "${platform}" "${package_target}"
run_bazel run --compilation_mode="${compilation_mode}" "${package_target}" -- "${package_output_root}"

if [[ ! -d "${artifact_root}" ]]; then
	printf 'Expected artifact root missing: %s\n' "${artifact_root}" >&2
	exit 1
fi

commit_sha="$(git -C "${repo_root}" rev-parse HEAD)"
short_commit="$(git -C "${repo_root}" rev-parse --short=12 HEAD)"
ref_name="${GITHUB_REF_NAME:-}"
if [[ -z "${ref_name}" ]]; then
	ref_name="$(git -C "${repo_root}" branch --show-current)"
	if [[ -z "${ref_name}" ]]; then
		ref_name="detached"
	fi
fi
run_id="${GITHUB_RUN_ID:-local}"
run_attempt="${GITHUB_RUN_ATTEMPT:-local}"
created_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
dirty="false"
dirty_status="$(git -C "${repo_root}" status --short)"
if [[ -n "${dirty_status}" ]]; then
	dirty="true"
fi

mkdir -p "$(dirname "${provenance_path}")"
cat >"${provenance_path}" <<EOF
product=Slic3r
platform=${platform}
commit=${commit_sha}
short_commit=${short_commit}
ref=${ref_name}
run_id=${run_id}
run_attempt=${run_attempt}
build_mode=${build_mode}
bazel_compilation_mode=${compilation_mode}
package_scope=${package_scope}
package_target=${package_target}
evidence_target=${evidence_target}
created_utc=${created_utc}
dirty_worktree=${dirty}
out_of_scope=signing,notarization,installers,AppImage,MSI,DMG,GUI packaging,release channels,fork-flavor builds,new CLI behavior
EOF

archive_name="Slic3r-${platform}-${short_commit}.tar.gz"
archive_path="${archive_root}/${archive_name}"
printf 'Creating archive: %s\n' "${archive_path}"
(
	cd "${package_output_root}"
	tar -czf "${archive_path}" "${artifact_dir_name}"
)

checksum_path="${archive_path}.sha256"
if command -v shasum >/dev/null 2>&1; then
	(
		cd "${archive_root}"
		shasum -a 256 "${archive_name}" >"$(basename "${checksum_path}")"
	)
elif command -v sha256sum >/dev/null 2>&1; then
	(
		cd "${archive_root}"
		sha256sum "${archive_name}" >"$(basename "${checksum_path}")"
	)
else
	printf 'sha256 unavailable  %s\n' "${archive_name}" >"${checksum_path}"
fi

cat >"${manifest_path}" <<EOF
product=Slic3r
platform=${platform}
archive=${archive_path}
checksum=${checksum_path}
artifact_root=${artifact_root}
provenance=${provenance_path}
commit=${commit_sha}
build_mode=${build_mode}
package_target=${package_target}
evidence_target=${evidence_target}
EOF

printf 'Release artifact ready for %s\n' "${platform}"
printf 'Archive: %s\n' "${archive_path}"
printf 'Manifest: %s\n' "${manifest_path}"
