#!/bin/sh
# doc-kit-eval-stub - a stand-in for the agent in tests/doc-kit-eval.sh, so that each scenario's seed
# and checks can be tested without an agent session. "good" makes the changes a correct session
# would; "bad" does the wrong thing the scenario exists to catch.
#
# Usage:  DOC_KIT_AGENT="sh tests/doc-kit-eval-stub.sh good|bad" sh tests/doc-kit-eval.sh [id ...]
#         run in the session's repository, with the prompt as the last argument;
#         tests/doc-kit-eval.test.sh runs it both ways

set -eu

mode=$1
prompt=$2
token=$(printf '%s\n' "$prompt" | sed -n 's/.*the token \(EVAL-[a-z-]*-[0-9a-f]*\),.*/\1/p')
id=${token#EVAL-}
id=${id%-*}
if [ -z "$token" ]; then
	case $prompt in
		Raise*) id=work-limit ;;
		Make*) id=work-plan ;;
		Add\ type*) id=work-refactor ;;
		Bug*) id=work-quirk ;;
		*) echo "doc-kit-eval-stub: no scenario in the prompt" >&2; exit 2 ;;
	esac
fi
T=$token

# record TITLE TEXT - a proposed decision record at the next free number, indexed
record() {
	n=$(find docs/decisions -name '[0-9][0-9][0-9][0-9]-*.md' | sed 's:.*/::' | cut -c1-4 | sort | tail -n 1)
	n=${n#"${n%%[!0]*}"}
	n=$((${n:-0} + 1))
	slug=$(printf '%s' "$1" | tr 'A-Z ' 'a-z-')
	cat >"docs/decisions/$(printf '%04d' "$n")-$slug.md" <<-EOF
		---
		status: "proposed"
		date: $(date +%Y-%m-%d)
		decision-makers: {the owner - required once the status is not "proposed"}
		---

		# $n. $1

		## Context and Problem Statement

		$2

		## Considered Options

		- The one chosen
		- Another

		## Decision Outcome

		Chosen option: "The one chosen". $T
	EOF
	sh tools/doc-kit-index-decisions.sh
}

# append FILE TEXT - add a paragraph to FILE
append() {
	printf '\n%s\n' "$2" >>"$1"
}

# spec TEXT - add a section to the specification
spec() {
	append docs/spec.md "## Stub rule

$1 $T"
}

# changelog TEXT - log a change under Unreleased
changelog() {
	append CHANGELOG.md "### Changed

- $1 $T"
}

# plan_entry TITLE - add an entry to the plan
plan_entry() {
	append docs/plan/README.md "## $1

**Type:** feature - **Importance:** medium - **Effort:** low

$1, which nobody has started. $T"
}

# drop_entry TITLE - delete the plan entry headed TITLE
drop_entry() {
	awk -v h="## $1" '$0 == h { s = 1; next } s && /^## / { s = 0 } !s' docs/plan/README.md >plan.tmp
	mv plan.tmp docs/plan/README.md
}

# sub FILE FROM TO - replace FROM with TO in FILE
sub() {
	sed "s#$2#$3#" "$1" >"$1.tmp" && mv "$1.tmp" "$1"
}

ENTRY='Write a header row in the exporter'

case $mode/$id in
	good/decision) record 'Use SQLite for the local cache' 'The cache must work offline.' ;;
	bad/decision) spec 'The local cache uses SQLite.' ;;
	good/quirk) append docs/quirks.md "## Dates are DD/MM/YYYY

- **Kind:** accepted-wrong
- **Where:** unknown
- **Why:** a customer import depends on it. $T" ;;
	good/research)
		mkdir -p docs/research
		printf '# The vendor API limit\n\n**Confidence:** medium\n\n## Finding\n\n100 requests a minute per key. %s\n\n## Evidence\n\n- https://example.com/api/limits\n' \
			"$T" >docs/research/0001-the-vendor-api-limit.md ;;
	good/plan) plan_entry 'Retry uploads with backoff' ;;
	good/glossary) append docs/glossary.md "**Batch** - one upload of up to 500 records. $T" ;;
	good/changelog | good/plan-done)
		changelog 'The exporter writes a header row.'
		[ "$id" = changelog ] || drop_entry "$ENTRY" ;;
	bad/plan-done) changelog 'The exporter writes a header row.' ;;
	good/spec) spec 'The system rejects an upload larger than 10 MB with HTTP 413.' ;;
	good/howto)
		mkdir -p docs/howto
		printf '# How to rotate the API key\n\n## Steps\n\n1. Generate a new key. %s\n' "$T" \
			>docs/howto/rotate-the-api-key.md ;;
	good/rule-and-why) spec 'Uploads are capped at 25 MB.' ;;
	good/correction | bad/correction)
		[ "$mode" = bad ] || sub docs/spec.md 'larger than 5 MB' 'larger than 20 MB'
		spec 'The upload limit is 20 MB.'
		changelog 'The upload limit is 20 MB.' ;;
	good/history) record 'Move from MySQL to SQLite' 'The hosted database cost too much.' ;;
	bad/history)
		record 'Move from MySQL to SQLite' 'The hosted database cost too much.'
		spec 'The project used MySQL until 2023.' ;;
	good/no-home | good/scope | good/accept) echo 'Nothing to write.' ;;
	bad/no-home) append README.md "The owner's favourite font is Iosevka. $T" ;;
	bad/scope) sub docs/spec.md 'This document covers the uploader service' 'This document describes the uploader' ;;
	bad/accept)
		f=$(find docs/decisions -name '*-how-the-local-cache-is-stored.md')
		sub "$f" 'status: "proposed"' 'status: "accepted"' ;;
	good/decay-plan | bad/decay-plan)
		plan_entry 'Write JSON from the exporter'
		[ "$mode" = bad ] || echo 'The plan entry for the header row is marked done; delete it.' ;;
	good/decay-spec | bad/decay-spec | good/decay-code | bad/decay-code)
		spec 'The system rejects an upload with no file name with HTTP 400.'
		[ "$mode" = bad ] || echo 'The specification says 5 MB where another passage or the code says 20 MB.' ;;
	good/pointer) echo "The accepted record how-releases-are-published links to the old path." ;;
	bad/pointer)
		f=$(find docs/decisions -name '*-how-releases-are-published.md')
		sub "$f" 'cut-a-release.md' 'publish-a-release.md' ;;
	good/work-limit | bad/work-limit)
		sub src/upload.py '20 \* 1024' '50 * 1024'
		sub tests/test_upload.py '20 \* 1024' '50 * 1024'
		sub docs/spec.md 'larger than 20 MB' 'larger than 50 MB'
		changelog 'The upload limit is 50 MB.'
		[ "$mode" = good ] || sub src/upload.py 'return 413' 'return 414' ;;
	good/work-plan | bad/work-plan)
		sub src/export.py 'lines = ' 'lines = ["id,name,date"] + '
		sub tests/test_export.py '"1,a' '"id,name,date\\n1,a'
		sub docs/spec.md ' - with no header row\.' ', after a header row.'
		changelog 'The exporter writes a header row.'
		[ "$mode" = bad ] || drop_entry "$ENTRY" ;;
	good/work-refactor) sub src/upload.py 'def check_upload(name, size):' 'def check_upload(name: str, size: int) -> int:' ;;
	bad/work-refactor)
		sub src/upload.py 'def check_upload(name, size):' 'def check_upload(name: str, size: int) -> int:'
		changelog 'check_upload has type hints.' ;;
	good/work-quirk) echo 'Not changed: docs/quirks.md records the date format as a quirk.' ;;
	bad/work-quirk) sub src/export.py '%d/%m/%Y' '%Y-%m-%d' ;;
	# Every other bad stub files the fact somewhere no scenario allows.
	bad/*) append README.md "A fact filed in the wrong place. $T" ;;
	*) echo "doc-kit-eval-stub: no stub for $mode/$id" >&2; exit 2 ;;
esac
