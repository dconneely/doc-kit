# How to run the agent evals

## Goal

Measure whether agents file facts where the map says, keep the rules and report the decay they meet,
on the kit as it stands or with a passage cut or restored, and record the result in a research note.
Follow it when a change to the stanza, the template map or a template could change what agents do.
What the evals score, and what they do not, is in [`docs/testing.md`](../testing.md).

## Prerequisites

- `sh` and `git`; on Windows, the `sh` that comes with Git.
- The agent's command-line tool, signed in: Claude Code (`claude`), `agy` or OpenCode.
- Agreement to spend: every session is a paid agent run.
- For a variant run, the change to test committed: the variant script copies `HEAD`.

## Steps

1. **Decide what to compare, and how many sessions.**

   Three sessions per scenario show a change that flips most sessions, such as a line whose removal
   makes agents reword the scope. To compare rates, such as how often agents report decay, run
   fifteen sessions per arm, on the same day, on kits that differ only in what is being tested.
   Three per arm once suggested an effect that fifteen showed was not there (research note 0006,
   Dead ends).

2. **Set the agent command.**

   `DOC_KIT_AGENT` is a command that takes the prompt as its last argument. Allow it to run the
   decision-index generator, or every new decision record fails the rules on a stale index. On
   Windows, Claude runs the generator through its PowerShell tool, so allow both:

   ```sh
   INDEX='Bash(sh tools/doc-kit-index-decisions.sh),PowerShell(sh tools/doc-kit-index-decisions.sh)'
   DOC_KIT_AGENT="claude -p --permission-mode acceptEdits --model claude-haiku-5-5 '--allowedTools=$INDEX'"
   export DOC_KIT_AGENT
   ```

   - **Another model under Claude Code**, such as DeepSeek through its Anthropic-compatible
     endpoint: set the endpoint, key and model name its provider documents for Claude Code, and keep
     the rest of the command.
   - **`agy`**:
     `agy --model MODEL --dangerously-skip-permissions --add-dir "$PWD" --settings FILE -p`, with
     `-p` last and `$PWD` left for the session to expand. `FILE` is the absolute path of
     [`tests/agy-eval-settings.json`](../../tests/agy-eval-settings.json), in the form `agy`
     accepts: on Windows, `D:/...` rather than `/d/...`. Its deny rules stop network, package,
     remote Git, deletion and recursive-listing commands; the last stops GPT-OSS hanging. Keep them
     as deny rules: `agy`'s default mode runs commands in a sandbox where, on Windows, `sh` cannot
     start, and an allow list ends the session at the first refused command, where a deny rule is
     reported to the model. `--settings` replaces the global permission lists. Without `--add-dir`,
     `agy` writes into its own state directory; GPT-OSS sometimes does even with it (research note
     0005).
   - **OpenCode**: `opencode run --standalone --auto -m PROVIDER/MODEL`, with `OPENCODE_CONFIG`
     naming a configuration whose permissions deny `external_directory` and every shell command but
     the generator, and `OPENCODE_DISABLE_CLAUDE_CODE=1`, or it also loads `~/.claude/CLAUDE.md`. On
     Windows it takes its directory from `PWD`, which `sh` sets; without `PWD` it works in the home
     directory.

3. **Choose the kit.**

   - As it stands: `sh tests/doc-kit-eval.sh [id ...]`.
   - With lines removed: `sh tests/doc-kit-eval-variant.sh -d FILE:LINES [id ...]`, line numbers as
     at `HEAD`.
   - With a file as it was at another commit: `-r FILE:REV`, such as
     `-r templates/DOC-MAP.md:a00b431^` to compare the shipped map with the one before a cut.

   To find passages agents do not need, cut one passage per copy and rerun the scenarios that use
   it, with the baseline's model; then run the full suite once with every candidate cut together. A
   passage is a candidate only when a scenario that could fail without it did not: one already at
   full marks shows only harm, and a passage no scenario exercises always looks cuttable. A hazard,
   such as the permission rule for decision records, keeps its salience whatever the result.

4. **Run, keeping every log.**

   ```sh
   DOC_KIT_EVAL_RUNS=15 DOC_KIT_EVAL_OUT="$HOME/evals/haiku-shipped" sh tests/doc-kit-eval.sh decay-plan
   ```

   `DOC_KIT_EVAL_OUT` keeps each session's log and diff, and the agent command; without it they are
   deleted with the run. Runs for different models or kits can go side by side, each in its own
   shell and output directory, but not too many: with six at once on Windows, Claude's PowerShell
   tool timed out, and sessions that could not run the index generator broke a rule. Look for
   timeouts in the logs, and compare arms only when they ran under the same load.

5. **Set the time limit for slow models.**

   A session whose agent runs longer than `DOC_KIT_EVAL_TIMEOUT` seconds, 1800 unless set, is
   stopped with everything it started, and its run ends with an `ERROR ... agent stopped` line.
   Raise the limit for a model whose sessions are slow, rather than setting it to 0, which leaves a
   hung agent stopping its run without a word.

6. **Rerun failed sessions.**

   A session that ends with an `ERROR` line stops the run with exit status 2. When the cause is the
   provider's, such as no capacity or a usage limit, or a session that hung, rerun the unfinished
   sessions with `DOC_KIT_EVAL_RUNS` set to the number missing, into a new output directory. Do not
   count the failed session, but read its log, which is kept with the others: a model that hangs
   repeatedly is a finding for the research note, as GPT-OSS's hangs were (research note 0006).

7. **Read every log.**

   The verdicts are heuristics. Read each session's log and diff, and score it yourself: a report
   names the decay specifically; a session that only says where it put its own fact has not
   reported. Where a verdict and your reading disagree, use your reading, fix the check in
   `tests/doc-kit-eval.sh`, and rescore every saved log with the fixed check before relying on it.

8. **Record the result.**

   Write it in the research note that asks the question, or a new one copied from
   `templates/docs/research/0000-template.md`. Rewrite the finding in place as the current answer.
   In Evidence, give the agent command, the agent's version, the kit's commit, and the sessions
   passing per scenario and arm; put a result that misled in Dead ends.

## Verification

- Every arm ran the planned number of sessions, and no session that ended with `ERROR` is counted.
- Every score in the note agrees with a reading of its session's log.
- `sh tools/doc-kit-check.sh` passes.
