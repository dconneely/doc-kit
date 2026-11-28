#!/bin/sh
# Tests for tests/doc-kit-eval.sh, with tests/doc-kit-eval-stub.sh in place of the agent: every
# scenario must pass when the stub makes a correct session's changes, and miss or break the rules
# when it does the wrong thing. No agent session runs, so this costs nothing; the work-* scenarios
# need Python.
#
# Usage:  sh tests/doc-kit-eval.test.sh [id ...]   (default: every scenario)

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

failed=0
total=0
for mode in good bad; do
	out="$TMP/$mode.out"
	# One run each, from an empty repository, and no time limit: a caller's settings for real runs
	# would change what is tested, and a stub never hangs.
	DOC_KIT_AGENT="sh '$ROOT/tests/doc-kit-eval-stub.sh' $mode" DOC_KIT_EVAL_RUNS=1 DOC_KIT_EVAL_BASE='' \
		DOC_KIT_EVAL_OUT='' DOC_KIT_EVAL_TIMEOUT=0 sh "$ROOT/tests/doc-kit-eval.sh" "$@" >"$out" 2>&1 || :
	# A run that ended early, from a stub or a script error, has no summary line.
	if grep -q '^ERROR' "$out" || ! grep -q '^[0-9][0-9]* of [0-9][0-9]* placed' "$out"; then
		cat "$out"
		echo "FAIL the $mode stub stopped the run"
		exit 1
	fi
	# One line per session; the last line is the summary.
	grep -v '^[0-9][0-9]* of [0-9][0-9]* placed' "$out" >"$TMP/$mode.lines" || :
	while IFS= read -r line; do
		total=$((total + 1))
		case $line in
			*' ok '*'; rules kept') passed=yes ;;
			*'; rules kept' | *'; rules broken: '*) passed=no ;;
			*)
				echo "FAIL not a session's verdict: $line"
				failed=$((failed + 1))
				continue
				;;
		esac
		if [ "$mode" = good ] && [ "$passed" = no ]; then
			echo "FAIL a correct session misses: $line"
			failed=$((failed + 1))
		elif [ "$mode" = bad ] && [ "$passed" = yes ]; then
			echo "FAIL a wrong session passes: $line"
			failed=$((failed + 1))
		fi
	done <"$TMP/$mode.lines"
done

if [ "$total" -eq 0 ]; then
	echo 'FAIL no session ran'
	exit 1
fi
if [ "$failed" -gt 0 ]; then
	echo "$failed of $total sessions scored wrongly"
	exit 1
fi
echo "$total sessions scored as expected"
