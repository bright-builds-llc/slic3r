#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/fork-vendors/verify_forks.sh"
else
	verifier="${script_dir}/verify_forks.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-forks-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fake_bin="${tmp_dir}/bin"
mkdir -p "${fake_bin}"

cat >"${fake_bin}/git" <<'GITMOCK'
#!/usr/bin/env bash
set -euo pipefail

: "${GIT_CALL_LOG:?}"
: "${GIT_NETWORK_MARKER:?}"

printf '%s' "$1" >>"${GIT_CALL_LOG}"
shift
for arg in "$@"; do
	printf '\t%s' "${arg}" >>"${GIT_CALL_LOG}"
done
printf '\n' >>"${GIT_CALL_LOG}"
: >"${GIT_NETWORK_MARKER}"

if [[ "$1" != "ls-remote" ]]; then
	printf 'unexpected git command\n' >&2
	exit 1
fi

mode="$2"
repo="$3"

if [[ "${mode}" == "--tags" ]]; then
	case "${repo}" in
		https://github.com/example/Annotated)
			printf '1111111111111111111111111111111111111111\trefs/tags/v1.0.0\n'
			printf '2222222222222222222222222222222222222222\trefs/tags/v1.0.0^{}\n'
			;;
		https://github.com/example/Lightweight)
			printf '3333333333333333333333333333333333333333\trefs/tags/v2.0.0\n'
			;;
		https://github.com/example/Drift)
			printf '4444444444444444444444444444444444444444\trefs/tags/v3.0.0\n'
			printf '5555555555555555555555555555555555555555\trefs/tags/v3.0.0^{}\n'
			;;
		*)
			printf 'unexpected tag repo: %s\n' "${repo}" >&2
			exit 1
			;;
	esac
	exit 0
fi

if [[ "${mode}" == "--symref" ]]; then
	case "${repo}" in
		https://github.com/example/Annotated)
			printf 'ref: refs/heads/master\tHEAD\n'
			printf 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\tHEAD\n'
			;;
		https://github.com/example/Lightweight)
			printf 'ref: refs/heads/main\tHEAD\n'
			printf 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\tHEAD\n'
			;;
		https://github.com/example/Drift)
			printf 'ref: refs/heads/main\tHEAD\n'
			printf '6666666666666666666666666666666666666666\tHEAD\n'
			;;
		*)
			printf 'unexpected head repo: %s\n' "${repo}" >&2
			exit 1
			;;
	esac
	exit 0
fi

printf 'unexpected ls-remote mode: %s\n' "${mode}" >&2
exit 1
GITMOCK
chmod +x "${fake_bin}/git"

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	file="$1"
	pattern="$2"
	if ! grep -Eq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,120p' "${file}" >&2
		exit 1
	fi
}

assert_not_contains() {
	file="$1"
	pattern="$2"
	if grep -Eq "${pattern}" "${file}"; then
		printf 'unexpected pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,120p' "${file}" >&2
		exit 1
	fi
}

write_header() {
	registry="$1"
	printf '# vendor_id\tdisplay_name\tofficial_repo_url\tselected_stable_tag\ttag_kind\ttag_ref_sha\ttag_object_sha\tpeeled_commit_sha\tdefault_branch\tobserved_default_branch_head\tcapture_date_utc\tlineage_ids\tsource_paths\trefresh_command\tspdx_identifier\tobserved_license_id\tlicense_source\tattribution_notes\tprovenance_notes\tcaution_flags\tcaution_notes\n' >"${registry}"
}

append_row() {
	registry="$1"
	shift
	printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@" >>"${registry}"
}

append_annotated_row() {
	registry="$1"
	vendor_id="$2"
	repo_url="$3"
	tag="$4"
	tag_ref_sha="$5"
	peeled_commit_sha="$6"
	default_branch="$7"
	default_head="$8"
	refresh_command="$9"
	append_row "${registry}" \
		"${vendor_id}" "Annotated" "${repo_url}" "${tag}" "annotated" \
		"${tag_ref_sha}" "${tag_ref_sha}" "${peeled_commit_sha}" \
		"${default_branch}" "${default_head}" "2026-05-26T16:23:36Z" \
		"slic3r" "src" "${refresh_command}" "AGPL-3.0-only" \
		"AGPL-3.0" "README.md@v1.0.0;LICENSE@v1.0.0" \
		"Attribution" "metadata-only-not-legal-review" "none" "No caution"
}

append_lightweight_row() {
	registry="$1"
	vendor_id="$2"
	peeled_commit_sha="$3"
	append_row "${registry}" \
		"${vendor_id}" "Lightweight" "https://github.com/example/Lightweight" \
		"v2.0.0" "lightweight" \
		"3333333333333333333333333333333333333333" "-" "${peeled_commit_sha}" \
		"main" "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" \
		"2026-05-26T16:23:36Z" "slic3r" "src" \
		"git ls-remote --tags https://github.com/example/Lightweight refs/tags/v2.0.0 refs/tags/v2.0.0^{}" \
		"AGPL-3.0-only" "AGPL-3.0" "README.md@v2.0.0;LICENSE@v2.0.0" \
		"Attribution" "metadata-only-not-legal-review" "none" "No caution"
}

run_verifier() {
	registry="$1"
	stdout_file="$2"
	stderr_file="$3"
	GIT_CALL_LOG="${tmp_dir}/git.log"
	GIT_NETWORK_MARKER="${tmp_dir}/network-called"
	rm -f "${GIT_CALL_LOG}" "${GIT_NETWORK_MARKER}"

	set +e
	PATH="${fake_bin}:${PATH}" \
		GIT_CALL_LOG="${GIT_CALL_LOG}" \
		GIT_NETWORK_MARKER="${GIT_NETWORK_MARKER}" \
		"${verifier}" "${registry}" >"${stdout_file}" 2>"${stderr_file}"
	status="$?"
	set -e

	return "${status}"
}

test_invalid_rows_fail_before_git() {
	# Arrange
	cases_dir="${tmp_dir}/invalid-cases"
	mkdir -p "${cases_dir}"

	printf 'only\tthree\tfields\n' >"${cases_dir}/malformed.tsv"

	write_header "${cases_dir}/missing-required.tsv"
	append_annotated_row "${cases_dir}/missing-required.tsv" "missing" \
		"https://github.com/example/Annotated" "v1.0.0" \
		"1111111111111111111111111111111111111111" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"
	perl -pi -e 's/^missing\tAnnotated\t/missing\t\t/' "${cases_dir}/missing-required.tsv"

	write_header "${cases_dir}/invalid-sha.tsv"
	append_annotated_row "${cases_dir}/invalid-sha.tsv" "badsha" \
		"https://github.com/example/Annotated" "v1.0.0" "not-a-sha" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"

	write_header "${cases_dir}/invalid-tag-kind.tsv"
	append_annotated_row "${cases_dir}/invalid-tag-kind.tsv" "badkind" \
		"https://github.com/example/Annotated" "v1.0.0" \
		"1111111111111111111111111111111111111111" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"
	perl -pi -e 's/\tannotated\t/\tsigned\t/' "${cases_dir}/invalid-tag-kind.tsv"

	write_header "${cases_dir}/invalid-url.tsv"
	append_annotated_row "${cases_dir}/invalid-url.tsv" "badurl" \
		"https://example.com/not/github" "v1.0.0" \
		"1111111111111111111111111111111111111111" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"

	write_header "${cases_dir}/bad-delimiter.tsv"
	append_annotated_row "${cases_dir}/bad-delimiter.tsv" "baddelimiter" \
		"https://github.com/example/Annotated" "v1.0.0" \
		"1111111111111111111111111111111111111111" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"
	perl -pi -e 's/\tslic3r\t/\tslic3r; prusaslicer\t/' "${cases_dir}/bad-delimiter.tsv"

	for registry in "${cases_dir}"/*.tsv; do
		# Act
		if run_verifier "${registry}" "${tmp_dir}/invalid.out" "${tmp_dir}/invalid.err"; then
			fail "invalid registry passed: ${registry}"
		fi

		# Assert
		assert_contains "${tmp_dir}/invalid.err" '^error:'
		if [[ -e "${tmp_dir}/network-called" ]]; then
			fail "network check ran for invalid registry: ${registry}"
		fi
	done
}

test_tag_mismatches_fail() {
	# Arrange
	annotated_registry="${tmp_dir}/annotated-mismatch.tsv"
	write_header "${annotated_registry}"
	append_annotated_row "${annotated_registry}" "annotated" \
		"https://github.com/example/Annotated" "v1.0.0" \
		"1111111111111111111111111111111111111111" \
		"0000000000000000000000000000000000000000" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "display-only"

	lightweight_registry="${tmp_dir}/lightweight-mismatch.tsv"
	write_header "${lightweight_registry}"
	append_lightweight_row "${lightweight_registry}" "lightweight" \
		"0000000000000000000000000000000000000000"

	# Act
	if run_verifier "${annotated_registry}" "${tmp_dir}/annotated.out" "${tmp_dir}/annotated.err"; then
		fail "annotated mismatch passed"
	fi
	if run_verifier "${lightweight_registry}" "${tmp_dir}/lightweight.out" "${tmp_dir}/lightweight.err"; then
		fail "lightweight mismatch passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/annotated.err" '^error:'
	assert_contains "${tmp_dir}/lightweight.err" '^error:'
}

test_branch_drift_warns_without_failing() {
	# Arrange
	registry="${tmp_dir}/branch-drift.tsv"
	write_header "${registry}"
	append_annotated_row "${registry}" "drift" "https://github.com/example/Drift" \
		"v3.0.0" "4444444444444444444444444444444444444444" \
		"5555555555555555555555555555555555555555" "master" \
		"dddddddddddddddddddddddddddddddddddddddd" "display-only"

	# Act
	if ! run_verifier "${registry}" "${tmp_dir}/drift.out" "${tmp_dir}/drift.err"; then
		fail "branch drift failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/drift.err" '^warning: branch drift observed for drift:'
	assert_contains "${tmp_dir}/drift.out" '^ok: drift v3.0.0 -> 5555555555555555555555555555555555555555$'
}

test_refresh_command_is_never_executed() {
	# Arrange
	refresh_marker="${tmp_dir}/refresh-command-ran"
	registry="${tmp_dir}/refresh-display-only.tsv"
	write_header "${registry}"
	append_annotated_row "${registry}" "annotated" "https://github.com/example/Annotated" \
		"v1.0.0" "1111111111111111111111111111111111111111" \
		"2222222222222222222222222222222222222222" "master" \
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "touch ${refresh_marker}"

	# Act
	if ! run_verifier "${registry}" "${tmp_dir}/refresh.out" "${tmp_dir}/refresh.err"; then
		fail "valid refresh display-only row failed"
	fi

	# Assert
	if [[ -e "${refresh_marker}" ]]; then
		fail "refresh_command was executed"
	fi
	assert_contains "${tmp_dir}/git.log" $'ls-remote\t--tags\thttps://github.com/example/Annotated\trefs/tags/v1.0.0\trefs/tags/v1.0.0\\^\\{\\}'
	assert_not_contains "${tmp_dir}/git.log" 'touch '
}

test_invalid_rows_fail_before_git
test_tag_mismatches_fail
test_branch_drift_warns_without_failing
test_refresh_command_is_never_executed

printf 'ok: verify_forks_test\n'
