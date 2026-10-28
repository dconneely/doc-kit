#!/bin/sh
# doc-kit-duplicate-check - report repeated tables, value lists and numbered step sequences.
#
# Advisory: prints findings and always exits 0. Templates are excluded because a template and its
# instance may repeat content (ADR-0006). A step sequence is a run of three or more numbered lines
# under a heading that names a step, procedure, process, or one of the decision-record actions.
#
# Usage: sh tests/doc-kit-duplicate-check.sh

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

files=$(find . -name '*.md' ! -path './.git/*' ! -path './templates/*' ! -path './docs/archive/*' |
	sed 's:^\./::' | sort)

hits=$(
	for f in $files; do
		awk -v file="$f" '
			function norm(s) { gsub(/`/, "", s); gsub(/[ \t|]/, "", s); return s }
			FNR == 1 { prev = ""; heading = ""; steps = 0; sig = "" }
			/^#+ / { heading = $0 }
			/^\|/ && prev ~ /^\|/ && $0 ~ /^\|[ :|-]*-/ {
				h = norm(prev)
				if (h != "") print "table\t" file "\t" (FNR - 1) "\t" h
			}
			/^[0-9]+\. / {
				t = $0
				sub(/^[0-9]+\. /, "", t)
				gsub(/[`*]/, "", t)
				if (steps == 0) start = FNR
				steps++
				sig = sig (steps > 1 ? " | " : "") t
			}
			!/^[0-9]+\. / {
				if (steps >= 3 && heading ~ /[Ss]tep|[Pp]rocedure|[Pp]rocess|[Pp]ropose|[Aa]ccept|[Aa]mend|[Aa]dopt/) print "steps\t" file "\t" start "\t" sig
				steps = 0
				sig = ""
			}
			{ prev = $0 }
			END {
				if (steps >= 3 && heading ~ /[Ss]tep|[Pp]rocedure|[Pp]rocess|[Pp]ropose|[Aa]ccept|[Aa]mend|[Aa]dopt/) print "steps\t" file "\t" start "\t" sig
			}
		' "$f"

		# shellcheck disable=SC2016  # backticks are literal Markdown
		grep -nE '`[^`]+`(, *`[^`]+`){2,}' "$f" 2>/dev/null |
			while IFS=: read -r no line; do
				sig=$(printf '%s' "$line" | sed -E 's/[` ]//g')
				printf 'values\t%s\t%s\t%s\n' "$f" "$no" "$sig"
			done || true
	done
)

printf '%s\n' "$hits" | awk -F'\t' '
	NF {
		key = $1 SUBSEP $4
		count[key]++
		if (count[key] == 1) {
			order[++n] = key
			first[key] = $2 ":" $3
		} else {
			last[key] = last[key] ", " $2 ":" $3
		}
	}
	END {
		found = 0
		for (i = 1; i <= n; i++) {
			key = order[i]
			if (count[key] > 1) {
				split(key, parts, SUBSEP)
				print "ADVISORY: repeated " parts[1] " at " first[key] last[key]
				found = 1
			}
		}
		if (!found) print "doc-kit-duplicate-check: no repeated tables, value lists or step sequences found."
	}
'
