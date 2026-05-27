#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/fork-templates/verify_templates.sh"
else
	verifier="${script_dir}/verify_templates.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-templates-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	local file="$1"
	local pattern="$2"
	if ! grep -Eq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,120p' "${file}" >&2
		exit 1
	fi
}

remove_line_containing() {
	local file="$1"
	local pattern="$2"
	local tmp_file
	tmp_file="${file}.tmp"
	grep -Fv "${pattern}" "${file}" >"${tmp_file}"
	mv "${tmp_file}" "${file}"
}

write_valid_fixture() {
	local dir="$1"
	mkdir -p "${dir}"

	cat >"${dir}/README.md" <<'EOF'
# Fixture README

bazel run //packages/fork-templates:verify
template verification does not prove fork parity.
source pins and inventories are planning inputs only.
future executable parity evidence is required.
do not add fork rows to packages/parity/status.tsv in v1.9.
[deferrals](../../docs/port/README.md#v19-fork-parity-deferrals)
EOF

	cat >"${dir}/fork-parity-checklist-template.md" <<'EOF'
# Fixture Checklist

template verification does not prove fork parity.
source pins and inventories are planning inputs only.
future executable parity evidence is required.
do not add fork rows to packages/parity/status.tsv in v1.9.

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | example |
| Source pin | example |
| Candidate Rust module | example |
| Fixture need | example |
| Evidence command | example |
| Docs touched | example |
| License or security note | example |
| Deferred scope | example |
| Reviewer signoff | example |
EOF

	cat >"${dir}/fork-launcher-shape-template.md" <<'EOF'
# Fixture Launcher

fork-flavor release builds stay deferred.
[deferrals](../../docs/port/README.md#v19-fork-parity-deferrals)
EOF

	cat >"${dir}/manual-drift-refresh-protocol.md" <<'EOF'
# Fixture Drift Protocol

bazel run //packages/fork-vendors:verify
selected stable tag confirmations are recorded.
peeled commit confirmations are recorded.
drift observations do not change accepted source pins by themselves.
EOF
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/README.md" \
		"${dir}/fork-parity-checklist-template.md" \
		"${dir}/fork-launcher-shape-template.md" \
		"${dir}/manual-drift-refresh-protocol.md" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

test_complete_package_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,120p' "${tmp_dir}/valid.err" >&2
		fail "valid fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" '^ok: fork template verification passed$'
}

test_missing_checklist_label_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-label"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/fork-parity-checklist-template.md" "Fixture need"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-label.out" "${tmp_dir}/missing-label.err"; then
		fail "missing label fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-label.err" '^error:'
	assert_contains "${tmp_dir}/missing-label.err" 'Fixture need'
}

test_missing_non_overclaiming_phrase_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-phrase"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/README.md" "template verification does not prove fork parity"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-phrase.out" "${tmp_dir}/missing-phrase.err"; then
		fail "missing non-overclaiming phrase fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-phrase.err" '^error:'
	assert_contains "${tmp_dir}/missing-phrase.err" 'template verification does not prove fork parity'
}

test_missing_drift_only_distinction_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-drift"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/manual-drift-refresh-protocol.md" "drift observations do not change accepted source pins by themselves"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-drift.out" "${tmp_dir}/missing-drift.err"; then
		fail "missing drift-only distinction fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-drift.err" '^error:'
	assert_contains "${tmp_dir}/missing-drift.err" 'drift observations do not change accepted source pins by themselves'
}

test_complete_package_fixture_passes
test_missing_checklist_label_fails
test_missing_non_overclaiming_phrase_fails
test_missing_drift_only_distinction_fails

printf 'ok: verify_templates_test\n'

