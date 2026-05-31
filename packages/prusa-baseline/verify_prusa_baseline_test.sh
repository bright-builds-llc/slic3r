#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/prusa-baseline/verify_prusa_baseline.sh"
else
	verifier="${script_dir}/verify_prusa_baseline.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-prusa-baseline-test.XXXXXX")"
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
		sed -n '1,160p' "${file}" >&2
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
# Prusa Baseline and Checklist Gate

bazel run //packages/prusa-baseline:verify
Phase 37 verification does not prove Prusa runtime support.
Phase 37 verification does not prove executable fork parity.
source pins, inventories, checklist records, and Prusa baseline records are planning inputs only.
future executable parity evidence required.
This package creates no Prusa fixture files, fork parity status rows, executable Prusa parity targets, upstream source imports, vendored fork source trees, automatic sync, runtime fork support, GUI support, network/device integration, profile auto-update execution, or fork release packaging.
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961
EOF

	cat >"${dir}/drift-refresh-record.md" <<'EOF'
# PrusaSlicer Drift-Refresh Record

https://github.com/prusa3d/PrusaSlicer
version_2.9.5
29bfec81347bd07dc738269d2c010fe4c4a5dc07
9a583bd438b195856f3bcf7ea99b69ba4003a961
43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b
prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961
bazel run //packages/fork-vendors:verify
Branch-head data is drift-only observation.
accepted source pins remain unchanged unless a future reviewed intake update modifies packages/fork-vendors/forks.tsv
PENDING - human reviewer UTC date required before implementation consumes this gate.
PENDING - human reviewer name and UTC date required before implementation consumes this gate.
Reviewer decision
Reviewer signoff
Selected stable tag confirmation
Peeled commit confirmation
Branch drift observation
EOF

	cat >"${dir}/profile-schema-checklist.md" <<'EOF'
# Prusa Profile Schema Checklist

| Required Field | Maintainer Entry |
| --- | --- |
| Inventory row ID | `prusaslicer.profile-schema` |
| Source pin | `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961` |
| Candidate Rust module | `packages/slic3r-rust` shared profile/config boundary for Phase 39; exact crate or module name deferred by the roadmap. No Prusa-only Rust workspace and no copied upstream source tree. |
| Fixture need | Planned Phase 38 namespace `packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/...`; not created in Phase 37. |
| Evidence command | Planned Phase 40 command `bazel run //packages/parity:prusaslicer_profile_schema_parity`; not created in Phase 37. |
| Docs touched | `docs/port/README.md`; `docs/port/package-map.md`; `docs/port/migration-guidance.md`; `docs/port/parity-matrix.md` |
| License or security note | `AGPL-3.0-only`; metadata-only-not-legal-review; no network, cloud, credential, profile auto-update, plugin ingestion, or runtime support scope in Phase 37. |
| Deferred scope | Prusa project files; STEP import; support generation; arc fitting; wall seam behavior; network/device integration; profile auto-update execution; full fork runtime support; GUI support; fork release builds; sync automation; upstream source imports; Prusa fixtures; executable Prusa parity commands. |
| Reviewer signoff | PENDING - human reviewer name and UTC date required before implementation consumes this gate. |

resources/profiles/PrusaResearch.ini
profile-schema
fork-specific
medium
config;config.persistence
future-candidate
EOF
}

run_verifier() {
	local dir="$1"
	local stdout_file="$2"
	local stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/README.md" \
		"${dir}/drift-refresh-record.md" \
		"${dir}/profile-schema-checklist.md" >"${stdout_file}" 2>"${stderr_file}"
	local status="$?"
	set -e

	return "${status}"
}

test_complete_fixture_passes() {
	# Arrange
	local dir="${tmp_dir}/valid"
	write_valid_fixture "${dir}"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,160p' "${tmp_dir}/valid.err" >&2
		fail "valid fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" '^ok: Prusa baseline verification passed$'
}

test_missing_accepted_tag_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-tag"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/drift-refresh-record.md" "version_2.9.5"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-tag.out" "${tmp_dir}/missing-tag.err"; then
		fail "missing accepted tag fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-tag.err" '^error:'
	assert_contains "${tmp_dir}/missing-tag.err" 'version_2.9.5'
}

test_missing_peeled_commit_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-commit"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/drift-refresh-record.md" "9a583bd438b195856f3bcf7ea99b69ba4003a961"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-commit.out" "${tmp_dir}/missing-commit.err"; then
		fail "missing peeled commit fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-commit.err" '^error:'
	assert_contains "${tmp_dir}/missing-commit.err" '9a583bd438b195856f3bcf7ea99b69ba4003a961'
}

test_missing_checklist_label_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-label"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/profile-schema-checklist.md" "| Evidence command |"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-label.out" "${tmp_dir}/missing-label.err"; then
		fail "missing checklist label fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-label.err" '^error:'
	assert_contains "${tmp_dir}/missing-label.err" 'Evidence command'
}

test_missing_pending_human_review_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-pending-review"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/profile-schema-checklist.md" "PENDING - human reviewer name and UTC date required before implementation consumes this gate."

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-pending-review.out" "${tmp_dir}/missing-pending-review.err"; then
		fail "missing pending human review fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-pending-review.err" '^error:'
	assert_contains "${tmp_dir}/missing-pending-review.err" 'PENDING - human reviewer name and UTC date required before implementation consumes this gate'
}

test_missing_non_overclaiming_phrase_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-non-overclaim"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/README.md" "Phase 37 verification does not prove executable fork parity."

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-non-overclaim.out" "${tmp_dir}/missing-non-overclaim.err"; then
		fail "missing non-overclaiming phrase fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-non-overclaim.err" '^error:'
	assert_contains "${tmp_dir}/missing-non-overclaim.err" 'Phase 37 verification does not prove executable fork parity'
}

test_missing_phase37_future_only_wording_fails() {
	# Arrange
	local dir="${tmp_dir}/missing-future-only"
	write_valid_fixture "${dir}"
	remove_line_containing "${dir}/profile-schema-checklist.md" "not created in Phase 37"

	# Act
	if run_verifier "${dir}" "${tmp_dir}/missing-future-only.out" "${tmp_dir}/missing-future-only.err"; then
		fail "missing Phase 37 future-only wording fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/missing-future-only.err" '^error:'
	assert_contains "${tmp_dir}/missing-future-only.err" 'not created in Phase 37'
}

test_complete_fixture_passes
test_missing_accepted_tag_fails
test_missing_peeled_commit_fails
test_missing_checklist_label_fails
test_missing_pending_human_review_fails
test_missing_non_overclaiming_phrase_fails
test_missing_phase37_future_only_wording_fails

printf 'ok: verify_prusa_baseline_test\n'
