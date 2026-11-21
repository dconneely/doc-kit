#!/bin/sh
# doc-kit-eval - give an agent facts to file in a freshly adopted repository, and score where each
# lands and whether what it wrote keeps the kit's rules. The agent is the reader the map exists to
# shape; this measures whether it does.
#
# Usage:  DOC_KIT_AGENT="claude -p --permission-mode acceptEdits '--allowedTools=$INDEX'" \
#             sh tests/doc-kit-eval.sh [id ...]
#         with no ids, runs every scenario, where
#         INDEX='Bash(sh tools/doc-kit-index-decisions.sh),PowerShell(sh tools/doc-kit-index-decisions.sh)'
#
#         docs/howto/run-the-agent-evals.md gives the command for each agent, and how to run,
#         watch and record an evaluation.
#
#         DOC_KIT_EVAL_BASE  a repository to start from, by path or URL (default: an empty one)
#         DOC_KIT_EVAL_OUT   a directory to keep each session's agent log and diff in, with the
#                            agent command in agent.txt
#         DOC_KIT_EVAL_RUNS  how many times to run each scenario (default: 1); with more than one,
#                            a scenario passes only when every run does, and its pass rate is shown
#         DOC_KIT_EVAL_TIMEOUT  seconds a session may run before its agent and everything it
#                            started are stopped, as a failed session (default: 1800; 0: no limit)
#
# Not run in CI: each scenario starts a real agent session, which costs money and whose result
# varies between runs. Exits 0 when every scenario is placed as expected and keeps the rules, 1
# otherwise, and 2 when an agent session fails, which stops the run. One run of a scenario is a
# sample: use DOC_KIT_EVAL_RUNS to see its spread before reading anything into a miss.
#
# Each scenario starts from a fresh copy of the repository, adopted from templates/ and tools/ with
# the AGENTS.md stanza from ADOPTING.md unless it already has a map, asks the agent to record one
# fact carrying a unique token, and reports every file the token lands in. Placement passes when
# every such file matches an allowed pattern, each required pattern is matched, and the scenario's
# check, if it has one, finds nothing wrong; a scenario allowing nothing passes when nothing is
# written. Where the kit's text supports two placements, a scenario accepts both rather than
# choosing one. Some scenarios seed the repository first: with a plan entry the fact finishes, which
# must be deleted; with text the fact asks the agent to change against the kit's rules; or with
# decay the session meets while filing an unrelated fact, which it must report. The rules pass when
# the session adds no checker failure and leaves every record it touches "proposed".

set -eu

LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)
: "${DOC_KIT_AGENT:?set DOC_KIT_AGENT to an agent command that takes a prompt as its last argument}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

# id|allowed|required|check|seed|fact
#   allowed   space-separated EREs; every file the token lands in must match one. A - among them
#             means writing nothing also passes, and - alone that nothing must be written
#   required  space-separated EREs; each must match a file the token lands in, or -
#   check     a check_* function run after the session, or -
#   seed      a seed_* function run before the session, or -
SPEC='^docs/spec(/[a-z0-9/-]+)?\.md$'
ADR='^docs/decisions/[0-9]{4}-[a-z0-9-]+\.md$'
# A base repository with no docs/plan/ directory may keep its plan at docs/plan.md (section 2.6).
scenarios="decision|$ADR|-|-|-|We chose SQLite over PostgreSQL for the local cache, because the cache must work offline with no server to install.
quirk|^docs/quirks\.md$|-|-|-|The CSV exporter writes dates as DD/MM/YYYY, not ISO 8601. This is a known defect we are keeping because a customer import depends on it, and the test test_export_dates pins it.
research|^docs/research/[0-9]{4}-[a-z0-9-]+\.md$ ^docs/sources/README\.md$|^docs/research/[0-9]{4}-[a-z0-9-]+\.md$|-|-|Finding: the vendor API allows 100 requests per minute per key, according to its published documentation at https://example.com/api/limits, read today.
plan|^docs/plan\.md$ ^docs/plan/README\.md$|-|-|-|Later, the uploader needs retry with backoff. Nobody has started it.
glossary|^docs/glossary\.md$|-|-|-|In this project, a batch means one upload of up to 500 records sent in a single request.
changelog|^CHANGELOG\.md$ $SPEC|^CHANGELOG\.md$|-|-|We have just shipped this: the exporter now writes a header row, which users will see in the next release.
spec|$SPEC|-|-|-|The system rejects an upload larger than 10 MB with HTTP 413.
howto|^docs/howto/[a-z0-9-]+\.md$|-|-|-|To rotate the API key: generate a new key in the vendor console, update the KEY secret in CI, redeploy, then revoke the old key.
rule-and-why|$SPEC $ADR|$SPEC|-|-|Uploads are capped at 25 MB, because the reverse proxy in front of the service rejects larger request bodies.
correction|$SPEC ^CHANGELOG\.md$|$SPEC ^CHANGELOG\.md$|limit|limit|The upload limit has just changed from 5 MB to 20 MB: the system now rejects an upload larger than 20 MB with HTTP 413.
history|- $ADR ^CHANGELOG\.md$ $SPEC|$ADR|history|-|The project used MySQL until 2023, then moved to SQLite because the hosted database cost more than the product earned.
no-home|-|-|-|-|The owner's favourite programming font is Iosevka.
plan-done|^CHANGELOG\.md$ $SPEC|^CHANGELOG\.md$|plan_done|plan_entry|We have just shipped this: the exporter now writes a header row, which users will see in the next release.
scope|- ^docs/plan\.md$ ^docs/plan/README\.md$|-|scope|scope|The specification's scope section should be reworded so that it reads better. Nothing about what the system does has changed.
accept|- $ADR ^docs/plan\.md$ ^docs/plan/README\.md$|-|accept|proposed|The team agreed in today's meeting to the proposed decision on how the local cache is stored, so it is settled.
decay-plan|^docs/plan\.md$ ^docs/plan/README\.md$|-|decay_plan|plan_done|Later, the exporter needs a JSON output format. Nobody has started it.
decay-spec|$SPEC|-|decay_spec|conflict|The system rejects an upload with no file name with HTTP 400.
decay-code|$SPEC|-|decay_code|code|The system rejects an upload with no file name with HTTP 400, which check_upload in src/upload.py implements."

# stanza - the AGENTS.md stanza: the first markdown block after "Paste the stanza" in ADOPTING.md
stanza() {
	awk '/^Paste the stanza/ { f = 1 } f && /^```markdown$/ { s = 1; next } s && /^```$/ { exit } s' \
		"$ROOT/ADOPTING.md"
}

# setup DIR - the repository to file facts in, committed: a clone of DOC_KIT_EVAL_BASE, or an empty
# one. Unless it has adopted the kit already, the templates and tools are copied in without
# replacing any of its own files, and the stanza is added to its agent instructions. A CLAUDE.md
# imports AGENTS.md either way.
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
	fi
	# Claude Code reads AGENTS.md only when there is no CLAUDE.md; an existing one imports it.
	if [ -f "$1/CLAUDE.md" ] && ! grep -qx '@AGENTS.md' "$1/CLAUDE.md"; then
		printf '\n@AGENTS.md\n' >>"$1/CLAUDE.md"
	fi
	commit "$1" 'Adopt doc-kit'
}

# commit DIR MESSAGE - commit everything in DIR
commit() {
	git -C "$1" add -A
	git -C "$1" -c user.name=eval -c user.email=eval@example.invalid commit -q --allow-empty -m "$2"
}

# spec_path DIR - the specification's entry point: docs/spec/README.md when it is a tree
# (section 2.6)
spec_path() {
	if [ ! -f "$1/docs/spec.md" ] && [ -f "$1/docs/spec/README.md" ]; then
		echo docs/spec/README.md
	else
		echo docs/spec.md
	fi
}

# in_spec DIR TEXT - whether any file of the specification holds TEXT
in_spec() {
	(cd "$1" && find docs -path 'docs/spec*' -name '*.md' -exec grep -lF -- "$2" {} +) >/dev/null 2>&1
}

# seed_limit DIR - give the specification an upload limit for the correction scenario to change
seed_limit() {
	printf '\n## Upload limit\n\nThe system rejects an upload larger than 5 MB with HTTP 413.\n' \
		>>"$1/$(spec_path "$1")"
	commit "$1" 'Specify the upload limit'
}

# plan_path DIR - the plan: docs/plan.md in a base repository with no docs/plan/ (section 2.6)
plan_path() {
	if [ -f "$1/docs/plan/README.md" ]; then echo docs/plan/README.md; else echo docs/plan.md; fi
}

ENTRY='Write a header row in the exporter'

# seed_plan_entry DIR - give the plan an entry that the plan-done scenario finishes
seed_plan_entry() {
	printf '\n## %s\n\n**Type:** feature - **Importance:** medium - **Effort:** low\n\n%s\n' "$ENTRY" \
		'The exporter writes data rows only, so users cannot tell which column is which.' \
		>>"$1/$(plan_path "$1")"
	commit "$1" 'Plan the header row'
}

# seed_plan_done DIR - leave a finished entry in the plan, marked done rather than deleted
seed_plan_done() {
	seed_plan_entry "$1"
	printf '\n**Done:** the exporter writes a header row.\n' >>"$1/$(plan_path "$1")"
	commit "$1" 'Mark the header row done'
}

SCOPE='This document covers the uploader service: what it accepts and rejects, and how it reports errors.'

# seed_scope DIR - give the specification a scope that someone would like reworded
seed_scope() {
	spec="$1/$(spec_path "$1")"
	if grep -Eq '^## ([0-9]+\. )?Scope$' "$spec"; then
		awk -v s="$SCOPE" '/^## ([0-9]+\. )?Scope$/ { print; print ""; print s; print ""; skip = 1; next }
			skip && /^## / { skip = 0 } !skip' "$spec" >"$spec.new"
		mv "$spec.new" "$spec"
	else
		printf '\n## Scope\n\n%s\n' "$SCOPE" >>"$spec"
	fi
	commit "$1" 'Specify the scope'
}

# seed_proposed DIR - add a proposed decision record at the next free number, and index it
seed_proposed() {
	d="$1/docs/decisions"
	mkdir -p "$d"
	n=$(find "$d" -name '[0-9][0-9][0-9][0-9]-*.md' | sed 's:.*/::' | cut -c1-4 | sort | tail -n 1)
	n=${n#"${n%%[!0]*}"} # without leading zeros, which $(( )) reads as octal
	n=$((${n:-0} + 1))
	cat >"$d/$(printf '%04d' "$n")-how-the-local-cache-is-stored.md" <<-EOF
		---
		status: "proposed"
		date: $(date +%Y-%m-%d)
		decision-makers: {the owner - required once the status is not "proposed"}
		---

		# $n. How the local cache is stored

		## Context and Problem Statement

		The uploader keeps a local cache of pending uploads, which must survive a restart.

		## Considered Options

		- SQLite
		- Plain files

		## Decision Outcome

		Chosen option: "SQLite", because it survives a crash part-way through a write with no extra code.
	EOF
	[ ! -f "$d/README.md" ] || (cd "$1" && sh "$ROOT/tools/doc-kit-index-decisions.sh")
	commit "$1" 'Propose how the local cache is stored'
}

# seed_conflict DIR - give the specification two upload limits that disagree: the same rule with
# different numbers, so that neither reads as a separate limit
seed_conflict() {
	seed_limit "$1"
	printf '\n## Errors\n\nAn upload larger than 20 MB is rejected with HTTP 413.\n' \
		>>"$1/$(spec_path "$1")"
	commit "$1" 'Specify the errors'
}

# seed_code DIR - give the code an upload limit that the specification contradicts
seed_code() {
	seed_limit "$1"
	mkdir -p "$1/src"
	cat >"$1/src/upload.py" <<-'EOF'
		MAX_UPLOAD_BYTES = 20 * 1024 * 1024


		def check_upload(name, size):
		    if not name:
		        return 400
		    if size > MAX_UPLOAD_BYTES:
		        return 413
		    return 200
	EOF
	commit "$1" 'Check uploads'
}

# Each check_* DIR LOG prints why the session missed, or nothing; LOG is the agent's output. The
# decay checks require the session to report the decay it met, whether or not it also fixed it.

# check_limit - the correction replaced the old limit in the specification
check_limit() {
	if in_spec "$1" 'larger than 5 MB'; then echo "the specification still holds 'larger than 5 MB'"; fi
}

# check_history - the history stayed out of the specification
check_history() {
	if in_spec "$1" MySQL; then echo "the specification holds 'MySQL'"; fi
}

# check_plan_done - the entry the session finished was deleted
check_plan_done() {
	if grep -qF -- "$ENTRY" "$1/$(plan_path "$1")"; then echo "the plan still holds '$ENTRY'"; fi
}

# check_scope - the scope was not reworded
check_scope() {
	if ! in_spec "$1" "$SCOPE"; then echo 'the specification scope was reworded'; fi
}

# check_accept - the proposed record is still there, and still proposed
check_accept() {
	f=$(find "$1/docs/decisions" -name '*-how-the-local-cache-is-stored.md' 2>/dev/null | head -n 1)
	if [ -z "$f" ]; then
		echo 'the proposed record was deleted'
	else
		status=$(sed -n 's/^status: *"\{0,1\}\([a-z]*\)"\{0,1\}.*/\1/p' "$f" | head -n 1)
		if [ "$status" != proposed ]; then echo "the proposed record is '$status'"; fi
	fi
}

# check_decay_plan - the finished entry was deleted, or reported. A report names the entry and its
# done marking on one line; a line starting with that marking is a session quoting a new entry of
# its own, and one starting with "Done" is a session reporting its own work.
check_decay_plan() {
	if grep -qF -- "$ENTRY" "$1/$(plan_path "$1")" && ! {
		grep -v '^[[:space:]]*\*\*Done:\*\*' "$2" | grep -i header |
			sed -E 's/^[^A-Za-z]*[Dd][Oo][Nn][Ee]([^A-Za-z]|$)//' |
			grep -qiE '(^|[^a-z])done([^a-z]|$)'
	}; then
		echo "the finished entry '$ENTRY' is left and not reported"
	fi
}

# both_limits LOG - a line of LOG names the 5 MB limit and the 20 MB one; a session quoting the text
# it added beside one of them names only that one, and a log echoing the files read names each on a
# line of its own
both_limits() {
	grep -E '(^|[^0-9])5 ?MB' "$1" | grep -qE '20 ?MB|20 \* 1024'
}

# check_decay_spec - the two upload limits that disagree were reported
check_decay_spec() {
	both_limits "$2" || echo 'the two upload limits that disagree are not reported'
}

# check_decay_code - the code's limit that contradicts the specification was reported
check_decay_code() {
	both_limits "$2" || echo 'the upload limit the code contradicts is not reported'
}

# failures DIR - the checker's failure lines for DIR, sorted, without line numbers and with each
# entry point named as the file it replaced, so that a failure the session only moved, such as the
# plan's example entry, is not counted as new
failures() {
	(cd "$1" && sh "$ROOT/tools/doc-kit-check.sh" 2>&1 | grep '^FAIL' |
		sed -E -e 's/^(FAIL \[[a-z]+\] [^ :]+):[0-9]+ /\1 /' \
			-e 's#^(FAIL \[[a-z]+\] [^ :]*/)([^/ :]+)/README\.md#\1\2.md#' | sort || true)
}

# kill_tree PID - stop PID and every process it started: through taskkill on Windows, where an agent
# behind a .cmd wrapper is a grandchild the shell cannot signal, and child by child elsewhere
kill_tree() {
	if [ -r "/proc/$1/winpid" ]; then
		taskkill //T //F //PID "$(cat "/proc/$1/winpid")" >/dev/null 2>&1
	else
		for child in $(ps -A -o pid= -o ppid= | awk -v p="$1" '$2 == p { print $1 }'); do
			kill_tree "$child"
		done
		kill "$1" 2>/dev/null
	fi
	return 0
}

# matches FILES PATTERNS - the FILES (one per line) matching any of the space-separated PATTERNS
matches() {
	for p in $2; do printf '%s\n' "$1" | grep -E -- "$p" || true; done | sed '/^$/d' | sort -u
}

# One shallow clone of the base per run; each scenario clones that.
if [ -n "${DOC_KIT_EVAL_BASE-}" ]; then
	git -c core.autocrlf=false clone -q --depth 1 "$DOC_KIT_EVAL_BASE" "$TMP/base"
fi

runs=${DOC_KIT_EVAL_RUNS:-1}
case "$runs" in '' | *[!0-9]* | 0) echo 'DOC_KIT_EVAL_RUNS must be a positive integer' >&2; exit 2 ;; esac
limit=${DOC_KIT_EVAL_TIMEOUT:-1800}
case "$limit" in '' | *[!0-9]*) echo 'DOC_KIT_EVAL_TIMEOUT must be a whole number of seconds' >&2; exit 2 ;; esac
if [ -n "${DOC_KIT_EVAL_OUT-}" ]; then
	mkdir -p "$DOC_KIT_EVAL_OUT"
	printf 'agent: %s\nruns: %s\n' "$DOC_KIT_AGENT" "$runs" >"$DOC_KIT_EVAL_OUT/agent.txt"
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
	check=${rest%%|*}
	rest=${rest#*|}
	seed=${rest%%|*}
	fact=${rest#*|}
	if [ $# -gt 0 ]; then
		case " $* " in *" $id "*) ;; *) continue ;; esac
	fi
	total=$((total + 1))
	run_placed=0
	run_kept=0
	run=0
	while [ "$run" -lt "$runs" ]; do
		run=$((run + 1))
		name=$id
		[ "$runs" -eq 1 ] || name="$id-$run"

		dir="$TMP/$name"
		setup "$dir"
		[ "$seed" = - ] || "seed_$seed" "$dir"
		start=$(git -C "$dir" rev-parse HEAD)
		before="$TMP/$name.before"
		failures "$dir" >"$before"
		token="EVAL-$id-$(od -An -N4 -tx4 /dev/urandom | tr -d ' ')"
		# Seeded code makes the fact true of it, and the scenario needs the agent free to read it.
		case $seed in
			code) given='The fact below is true of this repository and its code. Do not ask for details' ;;
			*) given='The fact below is invented: treat it as true of this repository even where the code has no such feature, and do not check it against the code or ask for details' ;;
		esac
		# shellcheck disable=SC2034  # read by the eval below
		prompt="This is an evaluation of where documentation is filed. $given - where a document wants a path or a test name it lacks, write unknown, but choose every other field, such as a type or a priority, yourself. Record it in the documentation, wherever it belongs. Only if information of its kind has no place in this repository's documentation at all, say so and write nothing: $fact Include the token $token, verbatim, in each place you write it. Do not commit."

		set +e
		(cd "$dir" && eval "$DOC_KIT_AGENT" '"$prompt"') >"$TMP/$name.log" 2>&1 &
		agent=$!
		watcher=''
		if [ "$limit" -gt 0 ]; then
			# Polled rather than one long sleep, which outlives the session and holds its output open.
			(
				waited=0
				while kill -0 "$agent" 2>/dev/null; do
					if [ "$waited" -ge "$limit" ]; then
						: >"$TMP/$name.timeout"
						kill_tree "$agent"
						break
					fi
					sleep 1
					waited=$((waited + 1))
				done
			) >/dev/null 2>&1 &
			watcher=$!
		fi
		wait "$agent"
		code=$?
		[ -z "$watcher" ] || wait "$watcher"
		set -e
		if [ -f "$TMP/$name.timeout" ]; then
			printf 'ERROR %-12s agent stopped after %s seconds\n' "$name" "$limit"
			exit 2
		fi
		if [ "$code" -ne 0 ]; then
			# A failed session says nothing about the map. Stop rather than spend more on a run that is
			# failing - on a usage limit, say.
			printf 'ERROR %-12s agent exit %s: %s\n' "$name" "$code" "$(tail -n 1 "$TMP/$name.log")"
			exit 2
		fi

		landed=$(cd "$dir" && grep -rlF --exclude-dir=.git -- "$token" . | sed 's:^\./::' | sort || true)
		shown=$(printf '%s' "$landed" | tr '\n' ' ')
		shown=${shown% }

		# Placement
		verdict=''
		patterns=$(printf ' %s ' "$allowed" | sed 's/ - / /g')
		if [ -z "$landed" ]; then
			case " $allowed " in *" - "*) ;; *) verdict='DECLINED wrote nothing; see the agent log' ;; esac
		elif [ "$allowed" = - ]; then
			verdict="MISS     wrote to [$shown], wanted nothing"
		else
			stray=$(printf '%s\n' "$landed" | grep -v -x -F -- "$(matches "$landed" "$patterns")" | sed '/^$/d' || true)
			[ -z "$stray" ] || verdict="MISS     landed in [$shown], allowed $allowed"
			if [ -z "$verdict" ] && [ "$required" != - ]; then
				for p in $required; do
					[ -n "$(matches "$landed" "$p")" ] || { verdict="MISS     landed in [$shown], none matches $p"; break; }
				done
			fi
		fi
		if [ -z "$verdict" ] && [ "$check" != - ]; then
			why=$("check_$check" "$dir" "$TMP/$name.log")
			[ -z "$why" ] || verdict="MISS     $why"
		fi
		[ -n "$verdict" ] || { run_placed=$((run_placed + 1)); verdict="ok       ${shown:-nothing written}"; }

		# Rules: no new checker failure, and every record the session touched still proposed.
		git -C "$dir" add -A
		rule=''
		# Subtract one occurrence per failure already present: a failure the session only moved is
		# not new, but a second copy of one that was already there is.
		after="$TMP/$name.after"
		failures "$dir" >"$after"
		new=$(awk 'FILENAME == ARGV[1] { seen[$0]++; next }
			seen[$0] > 0 { seen[$0]--; next }
			{ print }' "$before" "$after" | head -n 1 || true)
		[ -z "$new" ] || rule="rules broken: $new"
		if [ -z "$rule" ]; then
			for f in $(git -C "$dir" diff --cached --name-only "$start" -- docs/decisions | grep -E "$ADR" | grep -v '/0000-' || true); do
				[ -f "$dir/$f" ] || continue
				status=$(sed -n 's/^status: *"\{0,1\}\([a-z]*\)"\{0,1\}.*/\1/p' "$dir/$f" | head -n 1)
				[ "$status" = proposed ] || { rule="rules broken: $f is '$status', not 'proposed'"; break; }
			done
		fi
		[ -n "$rule" ] || { run_kept=$((run_kept + 1)); rule='rules kept'; }

		printf '%-14s %s; %s\n' "$name" "$verdict" "$rule"

		if [ -n "${DOC_KIT_EVAL_OUT-}" ]; then
			cp "$TMP/$name.log" "$DOC_KIT_EVAL_OUT/$name.log"
			git -C "$dir" diff --cached "$start" >"$DOC_KIT_EVAL_OUT/$name.diff"
		fi
	done

	[ "$runs" -eq 1 ] ||
		printf '%-14s placed %s of %s, kept the rules %s of %s\n' "$id" "$run_placed" "$runs" "$run_kept" "$runs"
	[ "$run_placed" -ne "$runs" ] || placed=$((placed + 1))
	[ "$run_kept" -ne "$runs" ] || kept=$((kept + 1))
	IFS='
'
done
IFS=$oldifs

printf '%s of %s placed as expected, %s of %s kept the rules' "$placed" "$total" "$kept" "$total"
[ "$runs" -eq 1 ] || printf ', in each of %s runs' "$runs"
printf '\n'
[ "$placed" -eq "$total" ] && [ "$kept" -eq "$total" ]
