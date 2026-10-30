#!/bin/sh
# doc-kit-eval - give an agent facts to file in a freshly adopted repository, and score where each
# lands. The agent is the reader the map exists to shape; this measures whether it does.
#
# Usage:  DOC_KIT_AGENT='claude -p --permission-mode acceptEdits' sh tests/doc-kit-eval.sh [id ...]
#         with no ids, runs every scenario
#
#         DOC_KIT_EVAL_BASE  a repository to start from, by path or URL (default: an empty one)
#         DOC_KIT_EVAL_OUT   a directory to keep each scenario's agent log and diff in
#
# Not run in CI: each scenario starts a real agent session, which costs money and whose result
# varies between runs. Exits 0 when every scenario lands where expected, 1 otherwise.
#
# Each scenario starts from a fresh copy of the repository, adopted from templates/ with the
# AGENTS.md stanza from ADOPTING.md unless it already has a map, asks the agent to record one fact
# carrying a unique token, and reports every file the token lands in. A scenario passes when the
# token lands only in files matching its expected pattern.

set -eu

LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)
: "${DOC_KIT_AGENT:?set DOC_KIT_AGENT to an agent command that takes a prompt as its last argument}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

# id|expected path (extended regex)|fact to record
scenarios='decision|^docs/decisions/[0-9]{4}-[a-z0-9-]+\.md$|We chose SQLite over PostgreSQL for the local cache, because the cache must work offline with no server to install.
quirk|^docs/quirks\.md$|The CSV exporter writes dates as DD/MM/YYYY, not ISO 8601. This is a known defect we are keeping because a customer import depends on it, and the test test_export_dates pins it.
research|^docs/research/[0-9]{4}-[a-z0-9-]+\.md$|Finding: the vendor API allows 100 requests per minute per key, according to its published documentation at https://example.com/api/limits, read today.
plan|^docs/plan\.md$|Later, the uploader needs retry with backoff. Nobody has started it.
glossary|^docs/glossary\.md$|In this project, a batch means one upload of up to 500 records sent in a single request.
changelog|^CHANGELOG\.md$|We have just shipped this: the exporter now writes a header row, which users will see in the next release.
spec|^docs/spec(/[a-z0-9/-]+)?\.md$|The system rejects an upload larger than 10 MB with HTTP 413.
howto|^docs/howto/[a-z0-9-]+\.md$|To rotate the API key: generate a new key in the vendor console, update the KEY secret in CI, redeploy, then revoke the old key.'

# stanza - the AGENTS.md stanza: the first markdown block after "Paste the stanza" in ADOPTING.md
stanza() {
	awk '/^Paste the stanza/ { f = 1 } f && /^```markdown$/ { s = 1; next } s && /^```$/ { exit } s' \
		"$ROOT/ADOPTING.md"
}

# setup DIR - the repository to file facts in, committed: a clone of DOC_KIT_EVAL_BASE, or an empty
# one. Unless it has adopted the kit already, the templates are copied in without replacing any of
# its own files, and the stanza is added to its agent instructions.
setup() {
	if [ -n "${DOC_KIT_EVAL_BASE-}" ]; then
		git -c core.autocrlf=false clone -q "$TMP/base" "$1"
	else
		mkdir -p "$1"
		git -C "$1" -c init.defaultBranch=main init -q
	fi
	git -C "$1" config core.autocrlf false
	if [ ! -f "$1/DOC-MAP.md" ]; then
		(cd "$ROOT/templates" && find . -type f) | while IFS= read -r f; do
			[ -e "$1/$f" ] && continue
			mkdir -p "$(dirname "$1/$f")"
			cp "$ROOT/templates/$f" "$1/$f"
		done
		if [ -f "$1/AGENTS.md" ]; then printf '\n' >>"$1/AGENTS.md"; else printf '# AGENTS.md\n\n' >"$1/AGENTS.md"; fi
		stanza >>"$1/AGENTS.md"
		# shellcheck disable=SC2016  # backticks are literal Markdown
		if [ -f "$1/CLAUDE.md" ]; then
			printf '\nSee [`AGENTS.md`](AGENTS.md) for where documentation belongs.\n' >>"$1/CLAUDE.md"
		else
			printf '# CLAUDE.md\n\nSee [`AGENTS.md`](AGENTS.md).\n' >"$1/CLAUDE.md"
		fi
	fi
	git -C "$1" add -A
	git -C "$1" -c user.name=eval -c user.email=eval@example.invalid commit -q --allow-empty -m 'Adopt doc-kit'
}

# One shallow clone of the base per run; each scenario clones that.
if [ -n "${DOC_KIT_EVAL_BASE-}" ]; then
	git -c core.autocrlf=false clone -q --depth 1 "$DOC_KIT_EVAL_BASE" "$TMP/base"
fi

passed=0
failed=0
oldifs=$IFS
IFS='
'
for line in $scenarios; do
	IFS=$oldifs
	id=${line%%|*}
	rest=${line#*|}
	want=${rest%%|*}
	fact=${rest#*|}
	if [ $# -gt 0 ]; then
		case " $* " in *" $id "*) ;; *) continue ;; esac
	fi

	dir="$TMP/$id"
	setup "$dir"
	start=$(git -C "$dir" rev-parse HEAD)
	token="EVAL-$id-$(od -An -N4 -tx4 /dev/urandom | tr -d ' ')"
	# shellcheck disable=SC2034  # read by the eval below
	prompt="The owner states this as true of this repository; record it in the documentation, wherever it belongs: $fact Include the token $token once, verbatim, in what you write. Do not commit."

	set +e
	(cd "$dir" && eval "$DOC_KIT_AGENT" '"$prompt"') >"$TMP/$id.log" 2>&1
	code=$?
	set -e

	landed=$(cd "$dir" && grep -rlF --exclude-dir=.git -- "$token" . | sed 's:^\./::' | sort || true)
	stray=$(printf '%s\n' "$landed" | grep -Ev -- "$want" | sed '/^$/d' || true)
	shown=$(printf '%s' "$landed" | tr '\n' ' ')
	if [ -n "${DOC_KIT_EVAL_OUT-}" ]; then
		mkdir -p "$DOC_KIT_EVAL_OUT"
		cp "$TMP/$id.log" "$DOC_KIT_EVAL_OUT/$id.log"
		(cd "$dir" && git add -A && git diff --cached "$start") >"$DOC_KIT_EVAL_OUT/$id.diff"
	fi
	if [ -n "$landed" ] && [ -z "$stray" ]; then
		passed=$((passed + 1))
		printf 'ok   %-10s %s\n' "$id" "$shown"
	else
		failed=$((failed + 1))
		printf 'MISS %-10s landed in [%s], wanted %s (agent exit %s)\n' "$id" "${shown% }" "$want" "$code"
	fi
	IFS='
'
done
IFS=$oldifs

printf '%s passed, %s missed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]
