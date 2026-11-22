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
- For a variant run, the change to test committed: the variant script copies `HEAD`, without
  uncommitted changes, and takes a restored file from any revision, such as another branch.

## Steps

1. **Decide what to compare, and how many sessions.**

   Three sessions per scenario show a change that flips most sessions, such as a line whose removal
   makes agents reword the scope. To compare rates, such as how often agents report decay, run
   fifteen sessions per scenario and arm, on kits that differ only in what is being tested, with the
   arms side by side rather than one after the other, so that both meet the provider's load at the
   same hours. Three per arm once suggested an effect that fifteen showed was not there (research
   note 0006, Dead ends). At fifteen per scenario and arm, only a difference of five to seven
   sessions or more is unlikely to be chance (Fisher's exact test, p < 0.05); for other counts, run
   the test before claiming one arm does better. Test each scenario on its own: scenarios differ in
   difficulty, and pooling them can show or hide a difference no scenario has. To combine them, use
   a test stratified by scenario, such as Cochran-Mantel-Haenszel.

2. **Set the agent command.**

   `DOC_KIT_AGENT` is a command that takes the prompt as its last argument. Allow it to run the
   decision-index generator, or every new decision record fails the rules on a stale index. On
   Windows, Claude runs the generator through its PowerShell tool, so allow both:

   ```sh
   INDEX='Bash(sh tools/doc-kit-index-decisions.sh),PowerShell(sh tools/doc-kit-index-decisions.sh)'
   DOC_KIT_AGENT="claude -p --permission-mode acceptEdits --model claude-haiku-5-5 '--allowedTools=$INDEX'"
   export DOC_KIT_AGENT
   ```

   Claude Code also loads your user-level instructions, skills and settings, as `agy` and OpenCode
   may load theirs; note any that could change where a session files a fact, since they can differ
   between the days or machines of runs you compare. Claude's `--setting-sources project,local`
   leaves out `~/.claude/CLAUDE.md`, `~/.claude/rules/` and the user's settings, and still loads the
   repository's `CLAUDE.md`, but only for sessions outside your home directory: below it, Claude
   still loads the first two, without their imports. Sessions run in `mktemp -d`, which on Windows
   is below it, so set `TMPDIR` to an existing directory outside it, such as `export TMPDIR=/d/tmp`.
   `--disable-slash-commands` leaves Claude's skills out. `agy` loads `~/.gemini/GEMINI.md` and its
   skills wherever the session runs, with or without `--disable-slash-commands`, and has no flag to
   stop either. Not `--bare`: it skips the `CLAUDE.md` that brings in the stanza, and needs an API
   key. Give every arm the same flags, and compare an isolated arm only with a baseline rerun the
   same way: results so far ran with the user-level configuration loaded.

   - **Another model under Claude Code**, such as DeepSeek through its Anthropic-compatible
     endpoint: set the endpoint, key and model name its provider documents for Claude Code, and keep
     the rest of the command.
   - **`agy`**, in single quotes so that `$PWD` is left for each session to expand, with `-p` last:

     ```sh
     DOC_KIT_AGENT='agy --model MODEL --dangerously-skip-permissions --add-dir "$PWD" --settings FILE -p'
     export DOC_KIT_AGENT
     ```

     Double quotes would expand `$PWD` once, to where you ran the eval. `agy models` lists the model
     names. `FILE` is the absolute path of
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
     the generator, and `OPENCODE_DISABLE_CLAUDE_CODE=1`, or it also loads `~/.claude/CLAUDE.md` and
     Claude's skills. On Windows it takes its directory from `PWD`, which `sh` sets; without `PWD`
     it works in the home directory.

3. **Choose the kit.**

   - As it stands: `sh tests/doc-kit-eval.sh [id ...]`. It runs the working tree, uncommitted
     changes included, where a variant copies `HEAD`: compare the two only from a clean tree.
   - With lines removed: `sh tests/doc-kit-eval-variant.sh -d FILE:LINES [id ...]`, line numbers as
     at `HEAD`.
   - With a file as it was at another commit: `-r FILE:REV`, such as
     `-r templates/DOC-MAP.md:a00b431^` to compare the shipped map with the one before a cut. The
     revision can be a branch never checked out, so a variant need not be committed where you work.

   Each takes the settings in step 4; without `DOC_KIT_EVAL_OUT`, there are no logs to read.

   To find passages agents do not need, cut one passage per copy and rerun the scenarios that use
   it, with the baseline's model; then run the full suite once with every candidate cut together,
   since two passages can back each other up, so that each cut passes alone and both fail together.
   A passage is a candidate only when a scenario that could fail without it did not: one already at
   full marks shows only harm, and a passage no scenario exercises always looks cuttable. A hazard,
   such as the permission rule for decision records, keeps its salience whatever the result.

4. **Run, keeping every log.**

   ```sh
   DOC_KIT_EVAL_RUNS=15 DOC_KIT_EVAL_OUT="$HOME/evals/haiku-shipped" sh tests/doc-kit-eval.sh decay-plan
   ```

   `DOC_KIT_EVAL_OUT` keeps each session's log and diff; in `agent.txt`, the date, kit commit, base,
   agent command, time limit, system and the directory the sessions ran in; and, in `verdicts.txt`,
   the verdicts printed. A variant run's `variant.txt` names the commit it copied. Without it they
   are deleted with the run. Record the agent's version yourself, from its `--version`. Runs for
   different models or kits can go side by side, each in its own shell and output directory, but not
   too many: with six at once on Windows, Claude's PowerShell tool timed out, and sessions that
   could not run the index generator broke a rule; four ran cleanly. Look for timeouts in the logs,
   and compare arms only when they ran under the same load.

5. **Set the time limit for slow models.**

   A session whose agent runs longer than `DOC_KIT_EVAL_TIMEOUT` seconds, 900 unless set, is stopped
   with everything it started, and its run ends with an `ERROR ... agent stopped` line. Raise the
   limit for a model whose sessions are slow, rather than setting it to 0, which leaves a hung agent
   stopping its run without a word.

6. **Rerun failed sessions.**

   A session that ends with an `ERROR` line stops the run with exit status 2. The script runs every
   session of one scenario before the next, so rerun, into a new output directory, the stopped
   scenario with `DOC_KIT_EVAL_RUNS` set to the number missing, then any scenario not reached with
   the full number. Read the failed session's log, which is kept with the others.

   - **The provider's failure**, such as no capacity, a usage limit or a server error: do not count
     the session.
   - **The model's**, such as a hang or a session stopped at the time limit (`agent stopped`): count
     it as failing, or report how many sessions finished beside the scores of those that did. A hang
     tracks the scenario and the model, so leaving it out flatters the arm. A model that hangs
     repeatedly is a finding, as GPT-OSS's hangs were (research note 0006).

7. **Read every log.**

   The verdicts are heuristics. Read each session's log and diff, and score it yourself: a report
   names the decay specifically; a session that only says where it put its own fact has not
   reported. In `decay-plan`, deleting the finished entry also passes. Where a verdict and your
   reading disagree, use your reading, fix the check in `tests/doc-kit-eval.sh`, and rescore every
   saved log and diff by the fixed rule before relying on it. The script cannot rescore, and keeps
   no session's repository, so do it by reading or with a script of your own.

   A log holds the agent's final answer, not its tool calls: whether a session read the map, or ran
   a command and was refused, is not in it. `agy --output-format stream-json` records each call,
   refused ones included, but leave it out of the command: the checks read the log as lines of text,
   and in its JSON a whole answer, or a file a tool read, is one line, so a check needing two facts
   on one line passes when it should not.

8. **Record the result.**

   Write it in the research note that asks the question, or a new one copied from
   `templates/docs/research/0000-template.md`. Rewrite the finding in place as the current answer.
   In Evidence, give the agent command, the agent's version, the kit's commit, and the sessions
   passing per scenario and arm; put a result that misled in Dead ends.

## Verification

- Every arm ran the planned number of sessions. No session the provider failed is counted, and every
  one the model hung in is counted as failing or reported.
- Every score in the note agrees with a reading of its session's log.
- `sh tools/doc-kit-check.sh` passes.
- `git status` shows only the research note and any check you fixed: the output directories are
  outside the repository.
