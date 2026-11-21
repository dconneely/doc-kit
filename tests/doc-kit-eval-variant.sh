#!/bin/sh
# doc-kit-eval-variant - run the agent evals on a copy of the kit with some lines removed, to see
# whether agents need them. The copy is HEAD exported to a temporary directory, so uncommitted
# changes are not in it, and line numbers are as at HEAD.
#
# Usage:  sh tests/doc-kit-eval-variant.sh -d FILE:LINES [-d FILE:LINES ...] [id ...]
#         FILE   a path in the kit, such as ADOPTING.md or templates/DOC-MAP.md
#         LINES  comma-separated line numbers and ranges, such as 16,18-20
#         id     the scenarios to run, as tests/doc-kit-eval.sh takes them (default: every one)
#
#         DOC_KIT_AGENT, DOC_KIT_EVAL_RUNS and DOC_KIT_EVAL_OUT pass through to tests/doc-kit-eval.sh.
#         The removed lines are printed first, and kept in DOC_KIT_EVAL_OUT/variant.txt when it is
#         set.
#
# Exits as tests/doc-kit-eval.sh does, and 2 on a usage error or a line that does not exist.

set -eu

LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)
usage='usage: sh tests/doc-kit-eval-variant.sh -d FILE:LINES [-d FILE:LINES ...] [id ...]'

cuts=''
while [ $# -gt 0 ]; do
	case $1 in
		-d)
			[ $# -ge 2 ] || { echo "$usage" >&2; exit 2; }
			cuts="$cuts
$2"
			shift 2
			;;
		-h | --help) echo "$usage"; exit 0 ;;
		-*) echo "$usage" >&2; exit 2 ;;
		*) break ;;
	esac
done
[ -n "$cuts" ] || { echo "$usage" >&2; exit 2; }

# One cut per file, so that every line number is as at HEAD however many cuts name the file.
cuts=$(printf '%s\n' "$cuts" | awk 'NF {
	i = index($0, ":")
	if (i == 0) { printf "bad cut %s\n", $0 >"/dev/stderr"; bad = 1; next }
	f = substr($0, 1, i - 1)
	if (f in lines) lines[f] = lines[f] "," substr($0, i + 1)
	else { order[++n] = f; lines[f] = substr($0, i + 1) }
}
END { for (k = 1; k <= n; k++) print order[k] ":" lines[order[k]]; exit bad }') || exit 2

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
KIT="$TMP/kit"
mkdir "$KIT"
git -C "$ROOT" archive HEAD | tar -x -C "$KIT"

removed="$TMP/variant.txt"
: >"$removed"
oldifs=$IFS
IFS='
'
for cut in $cuts; do
	IFS=$oldifs
	file=${cut%%:*}
	lines=${cut#*:}
	case $lines in '' | *[!0-9,-]*) echo "bad line list in $cut" >&2; exit 2 ;; esac
	[ -f "$KIT/$file" ] || { echo "no such file at HEAD: $file" >&2; exit 2; }
	printf '%s\n' "$file" >>"$removed"
	awk -v r="$lines" -v out="$KIT/$file.new" -v gone="$removed" '
		BEGIN {
			n = split(r, part, ",")
			for (i = 1; i <= n; i++) {
				if (part[i] ~ /^[0-9]+$/) { cut[part[i] + 0] = 1; continue }
				split(part[i], b, "-")
				if (part[i] !~ /^[0-9]+-[0-9]+$/ || b[1] + 0 > b[2] + 0) {
					printf "bad line range %s\n", part[i] >"/dev/stderr"
					badrange = 1
					exit 2
				}
				for (j = b[1] + 0; j <= b[2] + 0; j++) cut[j] = 1
			}
		}
		(FNR in cut) { printf "%5d  %s\n", FNR, $0 >>gone; delete cut[FNR]; next }
		{ print >out }
		END {
			if (badrange) exit 2
			for (k in cut) { printf "line %s does not exist\n", k >"/dev/stderr"; bad = 1 }
			exit bad
		}
	' "$KIT/$file" || exit 2
	mv "$KIT/$file.new" "$KIT/$file"
	IFS='
'
done
IFS=$oldifs

cat "$removed"
if [ -n "${DOC_KIT_EVAL_OUT-}" ]; then
	mkdir -p "$DOC_KIT_EVAL_OUT"
	cp "$removed" "$DOC_KIT_EVAL_OUT/variant.txt"
fi

set +e
sh "$KIT/tests/doc-kit-eval.sh" "$@"
code=$?
set -e
exit "$code"
