#!/bin/sh
# doc-kit-eval - give an agent facts to file in a freshly adopted repository, and score where each
# lands and whether what it wrote keeps the kit's rules. The agent is the reader the map exists to
# shape; this measures whether it does.
#
# Usage:  DOC_KIT_AGENT='claude -p --permission-mode acceptEdits' sh tests/doc-kit-eval.sh [id ...]
#         with no ids, runs every scenario
#
#         DOC_KIT_EVAL_BASE  a repository to start from, by path or URL (default: an empty one)
#         DOC_KIT_EVAL_OUT   a directory to keep each scenario's agent log and diff in
#
# Not run in CI: each scenario starts a real agent session, which costs money and whose result
# varies between runs. Exits 0 when every scenario is placed as expected and keeps the rules, 1
# otherwise, and 2 when an agent session fails, which stops the run.
#
# Each scenario starts from a fresh copy of the repository, adopted from templates/ and tools/ with
# the AGENTS.md stanza from ADOPTING.md unless it already has a map, asks the agent to record one
# fact carrying a unique token, and reports every file the token lands in. Placement passes when
# every such file matches an allowed pattern, each required pattern is matched, and no stale text is
# left in the specification; a scenario allowing nothing passes when nothing is written. The rules
# pass when the session adds no checker failure and leaves every record it touches "proposed".

set -eu

LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)
: "${DOC_KIT_AGENT:?set DOC_KIT_AGENT to an agent command that takes a prompt as its last argument}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

# id|allowed|required|stale|seed|fact
#   allowed   space-separated EREs; every file the token lands in must match one, or - for none
#   required  space-separated EREs; each must match a file the token lands in, or -
#   stale     text that must no longer appear in the specification, or -
#   seed      a seed_* function run before the session, or -
SPEC='^docs/spec(/[a-z0-9/-]+)?\.md$'
ADR='^docs/decisions/[0-9]{4}-[a-z0-9-]+\.md$'
scenarios="decision|$ADR|-|-|-|We chose SQLite over PostgreSQL for the local cache, because the cache must work offline with no server to install.
quirk|^docs/quirks\.md$|-|-|-|The CSV exporter writes dates as DD/MM/YYYY, not ISO 8601. This is a known defect we are keeping because a customer import depends on it, and the test test_export_dates pins it.
research|^docs/research/[0-9]{4}-[a-z0-9-]+\.md$|-|-|-|Finding: the vendor API allows 100 requests per minute per key, according to its published documentation at https://example.com/api/limits, read today.
plan|^docs/plan\.md$|-|-|-|Later, the uploader needs retry with backoff. Nobody has started it.
glossary|^docs/glossary\.md$|-|-|-|In this project, a batch means one upload of up to 500 records sent in a single request.
changelog|^CHANGELOG\.md$ $SPEC|^CHANGELOG\.md$|-|-|We have just shipped this: the exporter now writes a header row, which users will see in the next release.
spec|$SPEC|-|-|-|The system rejects an upload larger than 10 MB with HTTP 413.
howto|^docs/howto(/[a-z0-9-]+)?\.md$|-|-|-|To rotate the API key: generate a new key in the vendor console, update the KEY secret in CI, redeploy, then revoke the old key.
rule-and-why|$SPEC $ADR|$SPEC $ADR|-|-|Uploads are capped at 25 MB, because the reverse proxy in front of the service rejects larger request bodies.
correction|$SPEC ^CHANGELOG\.md$|$SPEC ^CHANGELOG\.md$|larger than 5 MB|limit|The upload limit has just changed from 5 MB to 20 MB: the system now rejects an upload larger than 20 MB with HTTP 413.
history|$ADR ^CHANGELOG\.md$|-|-|-|The project used MySQL until 2023, then moved to SQLite because the hosted database cost more than the product earned.
no-home|-|-|-|-|The owner prefers to review pull requests on Friday afternoons."

# stanza - the AGENTS.md stanza: the first markdown block after "Paste the stanza" in ADOPTING.md
stanza() {
	awk '/^Paste the stanza/ { f = 1 } f && /^```markdown$/ { s = 1; next } s && /^```$/ { exit } s' \
		"$ROOT/ADOPTING.md"
}

# setup DIR - the repository to file facts in, committed: a clone of DOC_KIT_EVAL_BASE, or an empty
# one. Unless it has adopted the kit already, the templates and tools are copied in without
# replacing any of its own files, and the stanza is added to its agent instructions.
setup() {
	if [ -n "${DOC_KIT_EVAL_BASE-}" ]; then
		git -c core.autocrlf=false clone -q "$TMP/base" "$1"
	else
		mkdir -p "$1"
		git -C "$1" -c init.defaultBranch=main init -q
	fi
	git -C "$1" config core.autocrlf false
	if [ ! -f "$1/DOC-MAP.md" ]; then
		for src in templates tools; do
			(cd "$ROOT/$src" && find . -type f) | while IFS= read -r f; do
				to=$f
				[ "$src" = tools ] && to=tools/$f
				[ -e "$1/$to" ] && continue
				mkdir -p "$(dirname "$1/$to")"
				cp "$ROOT/$src/$f" "$1/$to"
			done
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
	commit "$1" 'Adopt doc-kit'
}

# commit DIR MESSAGE - commit everything in DIR
commit() {
	git -C "$1" add -A
	git -C "$1" -c user.name=eval -c user.email=eval@example.invalid commit -q --allow-empty -m "$2"
}

# seed_limit DIR - give the specification an upload limit for the correction scenario to change
seed_limit() {
	printf '\n## Upload limit\n\nThe system rejects an upload larger than 5 MB with HTTP 413.\n' \
		>>"$1/docs/spec.md"
	commit "$1" 'Specify the upload limit'
}

# failures DIR - the checker's failure lines for DIR, sorted
failures() {
	(cd "$1" && sh "$ROOT/tools/doc-kit-check.sh" 2>&1 | grep '^FAIL' | sort || true)
}

# matches FILES PATTERNS - the FILES (one per line) matching any of the space-separated PATTERNS
matches() {
	for p in $2; do printf '%s\n' "$1" | grep -E -- "$p" || true; done | sed '/^$/d' | sort -u
}

# One shallow clone of the base per run; each scenario clones that.
if [ -n "${DOC_KIT_EVAL_BASE-}" ]; then
	git -c core.autocrlf=false clone -q --depth 1 "$DOC_KIT_EVAL_BASE" "$TMP/base"
fi

placed=0
kept=0
total=0
oldifs=$IFS
IFS='
'
for line in $scenarios; do
	IFS=$oldifs
	id=${line%%|*}
	rest=${line#*|}
	allowed=${rest%%|*}
	rest=${rest#*|}
	required=${rest%%|*}
	rest=${rest#*|}
	stale=${rest%%|*}
	rest=${rest#*|}
	seed=${rest%%|*}
	fact=${rest#*|}
	if [ $# -gt 0 ]; then
		case " $* " in *" $id "*) ;; *) continue ;; esac
	fi
	total=$((total + 1))

	dir="$TMP/$id"
	setup "$dir"
	[ "$seed" = - ] || "seed_$seed" "$dir"
	start=$(git -C "$dir" rev-parse HEAD)
	before=$(failures "$dir")
	token="EVAL-$id-$(od -An -N4 -tx4 /dev/urandom | tr -d ' ')"
	# shellcheck disable=SC2034  # read by the eval below
	prompt="This is an evaluation of where documentation is filed. The fact below is invented: treat it as true of this repository even where the code has no such feature, and do not check it against the code or ask for details - where a document wants a path or a test name it lacks, write unknown. Record it in the documentation, wherever it belongs. Only if information of its kind has no place in this repository's documentation at all, say so and write nothing: $fact Include the token $token, verbatim, in each place you write it. Do not commit."

	set +e
	(cd "$dir" && eval "$DOC_KIT_AGENT" '"$prompt"') >"$TMP/$id.log" 2>&1
	code=$?
	set -e
	if [ "$code" -ne 0 ]; then
		# A failed session says nothing about the map. Stop rather than spend more on a run that is
		# failing - on a usage limit, say.
		printf 'ERROR %-12s agent exit %s: %s\n' "$id" "$code" "$(tail -n 1 "$TMP/$id.log")"
		exit 2
	fi

	landed=$(cd "$dir" && grep -rlF --exclude-dir=.git -- "$token" . | sed 's:^\./::' | sort || true)
	shown=$(printf '%s' "$landed" | tr '\n' ' ')
	shown=${shown% }

	# Placement
	verdict=''
	if [ "$allowed" = - ]; then
		[ -z "$landed" ] || verdict="MISS     wrote to [$shown], wanted nothing"
	elif [ -z "$landed" ]; then
		verdict='DECLINED wrote nothing; see the agent log'
	else
		stray=$(printf '%s\n' "$landed" | grep -v -x -F -- "$(matches "$landed" "$allowed")" | sed '/^$/d' || true)
		[ -z "$stray" ] || verdict="MISS     landed in [$shown], allowed $allowed"
		if [ -z "$verdict" ] && [ "$required" != - ]; then
			for p in $required; do
				[ -n "$(matches "$landed" "$p")" ] || { verdict="MISS     landed in [$shown], none matches $p"; break; }
			done
		fi
		if [ -z "$verdict" ] && [ "$stale" != - ] &&
			(cd "$dir" && find docs -path 'docs/spec*' -name '*.md' -exec grep -lF -- "$stale" {} +) >/dev/null 2>&1; then
			verdict="MISS     left '$stale' in the specification"
		fi
	fi
	[ -n "$verdict" ] || { placed=$((placed + 1)); verdict="ok       ${shown:-nothing written}"; }

	# Rules: no new checker failure, and every record the session touched still proposed.
	git -C "$dir" add -A
	rule=''
	new=$(failures "$dir" | grep -v -x -F -- "$before" | sed '/^$/d' | head -n 1 || true)
	[ -z "$new" ] || rule="rules broken: $new"
	if [ -z "$rule" ]; then
		for f in $(git -C "$dir" diff --cached --name-only "$start" -- docs/decisions | grep -E "$ADR" | grep -v '/0000-' || true); do
			[ -f "$dir/$f" ] || continue
			status=$(sed -n 's/^status: *"\{0,1\}\([a-z]*\)"\{0,1\}.*/\1/p' "$dir/$f" | head -n 1)
			[ "$status" = proposed ] || { rule="rules broken: $f is '$status', not 'proposed'"; break; }
		done
	fi
	[ -n "$rule" ] || { kept=$((kept + 1)); rule='rules kept'; }

	printf '%-12s %s; %s\n' "$id" "$verdict" "$rule"

	if [ -n "${DOC_KIT_EVAL_OUT-}" ]; then
		mkdir -p "$DOC_KIT_EVAL_OUT"
		cp "$TMP/$id.log" "$DOC_KIT_EVAL_OUT/$id.log"
		git -C "$dir" diff --cached "$start" >"$DOC_KIT_EVAL_OUT/$id.diff"
	fi
	IFS='
'
done
IFS=$oldifs

printf '%s of %s placed as expected, %s of %s kept the rules\n' "$placed" "$total" "$kept" "$total"
[ "$placed" -eq "$total" ] && [ "$kept" -eq "$total" ]
