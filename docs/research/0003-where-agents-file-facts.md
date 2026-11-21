# Where agents file facts in a repository that has adopted the kit

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` between 2026-10-30 and 2026-11-20. Most scenarios ran
once per repository and model, a sample rather than a rate; on the templates alone, five models ran
each scenario three times, one of them under two agents, and Haiku also did in two customised
repositories.

## Finding

Given one fact to record, an agent files it where the map says it belongs, and model size makes
little difference. Across the same seven repositories, Claude Opus placed 54 of 56 facts as the
template map expects and Claude Haiku 55 of 56; every exception followed that repository's own
customised map rather than the template's. Existing documentation did not divert facts: nothing
landed in ripgrep's `GUIDE.md` or `FAQ.md`, or in the existing `docs/` trees of httpx, commander.js
or cobra.

The "Deliberately not here" section of a customised map steers as strongly as the artefacts table.
In play-bazlang, which records that it has no glossary and that terms are defined where each is
introduced, both models defined a new term in `docs/spec/mcp.md`; where its map records no how-to
guides, both created a single `docs/howto.md` and mapped it, as the growth rule (ADR-0014) allows.

Over three runs in play-bazlang and identigon, Haiku kept the rules in all 72 sessions and placed 7
of 12 scenarios in every run in each. Most misses followed the repository's map: where it leaves out
the template's home for a term, a how-to or a known defect, sessions used the home the map names
instead, or declined, and both are readings of a map that says the artefact is absent. Declining the
how-to in play-bazlang differs from the single runs, which created one. Three sessions declined an
invented fact foreign to the project - a vendor API's rate limit, a proxy's upload cap, an HTTP
status in a repository with no HTTP - although the prompt says to treat it as true. Two were real
misses: a rule and its reason filed as a quirk, and the same rule in a decision record with nothing
in the specification.

Those eight scenarios each have one obvious home, so near-perfect scores there are a ceiling of the
test. Four harder ones hold up too. A rule with its reason is split into the specification and a
`proposed` decision record; a correction rewrites the specification in place and is logged in the
changelog; history goes to a decision record; and a fact with no documentation value is left
unwritten. Once told to, every session that added a decision record regenerated the decisions index;
before the stanza said so, none did. Told that a team had agreed to a proposed record, DeepSeek
Flash often accepted it until the stanza said that is not permission (research note 0007).

Asked to record an invented fact about code a repository lacks, Opus declines unless told the fact
is invented: it names the right destination but will not fill a quirk's `Where:` or test fields, or
a changelog entry, with things that do not exist. The harness therefore says so in its prompt.

The agent matters less than the model. On the templates alone, Gemini 3.8 Flash under `agy`, which
reads `AGENTS.md` itself with no `CLAUDE.md` alias to follow, and DeepSeek Flash under Claude Code
placed 71 of 72 sessions across three runs each and kept the rules in 71. DeepSeek Flash under
OpenCode, which also reads `AGENTS.md` itself, placed 36 of 36 and kept the rules in 35; the one
break, a stale index, is the same one Gemini made. Claude Haiku under Claude Code placed 36 of 36
and kept the rules in 36; Claude Sonnet under `agy` placed 35 of 36, and under Claude Code kept the
rules in all nine sessions that write a decision record. GPT-OSS 120B under `agy` did not: it placed
19 of 36 sessions and kept the rules in 33, all three breaks in decision sessions. Outside `agy`'s
sandbox, every session that wrote a decision record left the index stale too, so the breaks would
have happened without it. It placed no research finding where the map says, often described where a
fact belonged and what to write without writing it, and three times out of three did not recognise
the plan scenario's fact as a fact to record.

In single runs before the scenarios changed, Gemini and DeepSeek each placed 11 of 12. Each miss
followed a passage of the kit that the scenario did not allow for. DeepSeek put the 25 MB cap and
its reason in the specification alone, citing the record template's note that a record with only one
option is usually a misfiled specification entry. Gemini declined the MySQL history, citing the
map's rule to write the least that is true ("No history or account of how you got there, in
documents") and the template's warning against a record reconstructed years afterwards. The map's
row for "was X tried?" and `ADOPTING.md` Step 2, which converts old reasoning into records, support
a decision record instead. Since the kit's text supports both readings in each case, the scenarios
now accept both: the rule-and-reason scenario requires only the specification, and the history may
be left unwritten.

## Evidence

The harness writes no `CLAUDE.md`, and adds `@AGENTS.md` to one a base repository already has. Every
run below but the last predates that and gave its repository a `CLAUDE.md` linking to `AGENTS.md`.
From Claude Code v2.1.277 such a file stops Claude Code loading `AGENTS.md`, so in Claude Code runs
on those versions the agent read the stanza only if it opened `AGENTS.md`; the version each run used
is not recorded.

`claude -p --permission-mode acceptEdits --model opus` and `--model haiku`, harness of 2026-10-30,
eight scenarios per repository: a decision, a kept defect, a sourced finding, future work, a term, a
shipped change, a behaviour rule and a procedure, each repository run in sequence. Opus ran
play-looplang and cobra, and Haiku every repository, with the how-to pattern widened partway through
to accept a single file.

| Repository                | Base commit    | Starting state                  | Opus  | Haiku |
| ------------------------- | -------------- | ------------------------------- | ----- | ----- |
| `dconneely/play-bazlang`  | `6d3f49cc9b44` | adopted, customised map         | 6 / 8 | 7 / 8 |
| `dconneely/play-eightbit` | `a0cc6d16a309` | README only; templates overlaid | 8 / 8 | 8 / 8 |
| `dconneely/play-looplang` | `09a761d33c1b` | templates overlaid              | 8 / 8 | 8 / 8 |
| `BurntSushi/ripgrep`      | `91f5d22ef48b` | many root documents; overlaid   | 8 / 8 | 8 / 8 |
| `tj/commander.js`         | `ba6d13ddb424` | existing `docs/`; overlaid      | 8 / 8 | 8 / 8 |
| `encode/httpx`            | `b5addb64f016` | existing `docs/`; overlaid      | 8 / 8 | 8 / 8 |
| `spf13/cobra`             | `adbc8813901b` | existing `site/` docs; overlaid | 8 / 8 | 8 / 8 |

play-bazlang's misses were scored against the template's expectations: the term in both runs
(expected `docs/glossary.md`), and for Opus the procedure (expected under `docs/howto/` before that
widening). All followed its map, as described above. Every research note was numbered, and every
decision record took the next free number, in every repository.

Sonnet (`--model sonnet`) on the templates alone placed 7 of 8. The miss was a research note named
`vendor-api-rate-limit.md`, which no rule then forbade; `docs/spec.md` §3.4 now requires the number.

Twelve scenarios - the eight plus a rule with its reason, a correction to seeded specification text,
history, and a fact with no home - scored also on the rules (no new checker failure, every touched
record `proposed`), harness of 2026-10-30, with the agent allowed to run the index generator:

| Repository                | Haiku placed | Haiku rules | Opus placed | Opus rules |
| ------------------------- | ------------ | ----------- | ----------- | ---------- |
| `dconneely/play-bazlang`  | 10 / 12      | 11 / 12     | 10 / 12     | 12 / 12    |
| `dconneely/play-eightbit` | 11 / 12      | 12 / 12     | -           | -          |
| `BurntSushi/ripgrep`      | 8 / 12       | 12 / 12     | -           | -          |
| `tj/commander.js`         | 11 / 12      | 12 / 12     | -           | -          |
| `encode/httpx`            | -            | -           | 11 / 12     | 12 / 12    |

The rule-and-reason, correction and history scenarios placed correctly in every run but two history
runs, which also stated the current database in the specification; that is present-tense behaviour,
and the scenario now forbids only the history there. The one broken rule was a stale index in
play-bazlang, whose own stanza did not yet say to regenerate it. The other misses were the
scenarios' own: a research note's source also indexed in `docs/sources.md`, as §3.7 provides; the
no-home fact, a review-day preference, put in `CONTRIBUTING.md`, where for an open-source project it
belongs; play-bazlang's term again; and one decline in ripgrep by Haiku on the grounds that the
repository has no upload feature. The harness corrected the first three scenarios on 2026-10-31.

`identigon/identigon`, a second customised map, at `8321b29` with its stanza given the index line,
harness with those corrections, Haiku: 8 of 12 placed, 11 of 12 rules kept. Its map leaves out
quirks, a glossary and how-tos, and says known limitations are stated inline in each specification
member. Every miss but one followed that: the kept defect went to a specification member with a
decision record, the term to a specification member, and the how-to was declined as an artefact the
map says is the owner's to add. The other was a decline of the upload cap, as in ripgrep. The broken
rule was a plan entry typed `unknown`, because the prompt allowed "unknown" for a missing path or
test name and Haiku extended it to the type; the prompt now limits it to those, and the entry then
passed both.

The 0.10.0 templates on an empty repository, `--model claude-haiku-5-5`, 2026-11-16: 12 of 12
placed, 11 of 12 rules kept. The broken rule was the harness's own: the plan template's example
entry fails the checker in every fresh adoption, and the agent's entry above it moved that failure
to a new line number, which the harness compared. It now normalises away line numbers and subtracts
one occurrence per failure already present, so a moved failure is not new but a second copy is. The
plan scenario passed both under that comparison in each of the two runs below.

The same templates, 2026-11-17, before the scenarios accepted both readings, with two models other
than Claude's. `agy` 1.5.2 with `--model gemini-3.8-flash-low --sandbox`, in its default mode, which
ran the index generator without a permission rule: 11 of 12 placed, 12 of 12 rules kept; the miss
was the history declined. Claude Code pointed at DeepSeek's Anthropic-compatible endpoint, model
`deepseek-flash` at low effort, with the index generator allowed: 11 of 12 placed, 12 of 12 rules
kept; the miss was the rule and its reason with no decision record. Every decision record either
wrote was `proposed`, and every one was followed by a regenerated index.

The same templates, 2026-11-17, with the scenarios accepting both readings, `DOC_KIT_EVAL_RUNS=3`.
DeepSeek Flash as above: 35 of 36 sessions placed, 36 of 36 rules kept. The miss filed the kept
CSV-date defect in `docs/quirks.md` and also as a plan entry to restore ISO dates once the customer
import no longer needs them; the quirk's "Expires when" already holds that trigger, so the fact had
two homes. Gemini 3.8 Flash as above: 36 of 36 placed, 35 of 36 rules kept; the break was a decision
record whose index was not regenerated. A run with `agy --model gpt-oss-120b-medium` stopped after
ten sessions when the server reported no capacity for the model (HTTP 503).

GPT-OSS again, 2026-11-19, `agy` 1.5.10 with `--model gpt-oss-120b-medium --sandbox`, three runs: 19
of 36 sessions placed, 33 of 36 rules kept, 3 of 12 scenarios placed in every run. Every decision
session broke the rules: two left the index stale, and one numbered its record `0001`, already
taken; one record was named by date, `20231119-sqlite-choice.md`, a placement miss, since a record's
name starts with a four-digit number. No research finding went to `docs/research/`: twice to
`docs/sources/README.md`, once also to the specification, and once to a new
`docs/sources/api-limits.md`. All three plan sessions asked for the fact to record, not recognising
"Later, the uploader needs retry with backoff" as one. Five sessions - two changelog, two
specification, one rule and its reason - described the destination and the text to add, then wrote
nothing. Two history sessions logged the move in the changelog alone, one kept defect went to
`docs/testing.md` as well as the quirks, one rule and its reason went to the quirks as well as the
specification, and one no-home fact went to the quirks. The glossary, how-to and correction
scenarios placed in every run.

The same templates, 2026-11-18, OpenCode 2.3.2 as
`opencode run --standalone --archived --auto -m deepseek/deepseek-flash#low`, with
`OPENCODE_DISABLE_CLAUDE_CODE=1` and a configuration that allows the index generator and denies
every other shell command and every path outside the repository. The logs do not show whether the
low effort was applied. One run: 12 of 12 placed, 12 of 12 rules kept. Three runs: 36 of 36 placed,
35 of 36 rules kept. The break was a history record whose index was not regenerated: the session's
first shell command, an unrelated one, was refused, and it ended by telling the user to run the
generator rather than trying it. Across both OpenCode runs, all nine sessions that wrote a decision
record had a shell command refused; in six the refusal came before the generator was due, and five
of those six ran it anyway. A refusal is not the only cause of a stale index: Gemini's came with
nothing refused, and GPT-OSS never ran the generator. Only OpenCode's logs show refusals - Claude
Code's hold only its final reply, and `agy` refused nothing. All three rule-and-reason sessions in
the repeated runs put the cap in the specification alone; the single run also wrote a decision
record.

On 2026-11-19, before the correction seed was fixed (see Dead ends),
`claude -p --permission-mode acceptEdits --model claude-haiku-5-5` with the index generator allowed,
`DOC_KIT_EVAL_RUNS=3`:

| Repository                | Base commit | Placed in every run | Sessions keeping the rules |
| ------------------------- | ----------- | ------------------- | -------------------------- |
| templates on an empty one | -           | 12 / 12             | 36 / 36                    |
| `dconneely/play-bazlang`  | `37697b1`   | 7 / 12              | 36 / 36                    |
| `identigon/identigon`     | `1a27658`   | 7 / 12              | 36 / 36                    |

On the templates, the rule and its reason went to the specification alone once and with a decision
record twice, and the history once also took a changelog entry; the scenarios allow both. In
play-bazlang the term was declined twice and put in `docs/spec/mcp.md` once, and the how-to declined
three times; the research finding and the upload cap were each declined once, the cap filed once in
`docs/quirks.md`, and the correction missed once (see Dead ends). In identigon the kept defect went
to a specification member with a decision record three times, twice also to `docs/testing.md`; the
term went to a specification member and the how-to was declined, three times each; the 413 rule was
declined once, as fitting none of its three members; and the upload cap went once to a decision
record alone.

The same templates, 2026-11-19, `agy` 1.5.12 with `--model claude-sonnet-5-5-low --sandbox`, three
runs, in two parts because the account's quota ran out at the second history session; history then
ran again from its first run. 35 of 36 sessions placed, 11 of 12 scenarios in every run; the miss
filed the CSV-date defect in `docs/quirks.md` and also as a plan entry, as DeepSeek did once. 30 of
36 sessions kept the rules, and the six breaks were the six decision and history sessions, each
leaving the index stale because the sandbox could not run `sh` (see Dead ends). The rule result says
nothing about the model.

Sonnet again for the rules, 2026-11-19,
`claude -p --permission-mode acceptEdits --model claude-sonnet-5-5` with the index generator
allowed, three runs of the decision, rule-and-reason and history scenarios: 9 of 9 placed, 9 of 9
rules kept. Every decision and history session wrote a `proposed` record and regenerated the index;
every rule and its reason went to the specification alone.

GPT-OSS again for the rules, 2026-11-19, outside the sandbox: `agy` 1.5.12 with
`--model gpt-oss-120b-medium --dangerously-skip-permissions`, a deny list for network, package,
remote Git and deletion commands - and, since 2026-11-21, recursive listings (see Dead ends) - and
the repository added with `--add-dir`; three runs of the decision, rule-and-reason and history
scenarios, one session at a time. 7 of 9 placed, 5 of 9 rules kept. All four sessions that wrote a
decision record - three decisions and one history - left the index stale. Across the nine, GPT-OSS
tried the generator once, as `powershell -File` on the `sh` script, which cannot run it; nothing was
denied, and every command was a read-only listing, most of them of the repository. One decision
record was named after the eval's token rather than numbered, and one rule and its reason went to
`docs/quirks.md`; two history sessions wrote nothing, which the scenario allows.

The templates on an empty repository, 2026-11-20, with no `CLAUDE.md`, so with the stanza loaded:
`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, Claude Code 2.1.329, the index
generator allowed, three runs. 35 of 36 filing sessions placed and 36 of 36 kept the rules; the miss
put the kept CSV-date defect in the specification as well as the quirks. Three scenarios that seed
the repository placed in all nine sessions. A fact finishing a plan entry deleted that entry each
time. A request to reword the specification's scope left it alone, once filing a plan entry instead.
A team's agreement to a proposed decision record left it `proposed`; twice the session wrote the
agreement into the record, once as a `## Status` section, and said the owner must accept it.
Research note 0005 has the decay scenarios from the same run.

## Dead ends

Running five repositories in parallel exhausted the account's usage limit mid-run, and every session
after that exited with an error the harness first scored as a miss. The harness now reports a failed
session as `ERROR` and stops.

Under `--permission-mode acceptEdits`, an agent told to regenerate the decisions index tried and was
refused, so the session failed the rules for the harness's reason. On Windows, Claude runs the
generator through its PowerShell tool, so a `Bash(...)` permission alone does not match; the harness
documents both.

On Windows, `opencode run` started from PowerShell worked in the home directory rather than the
current one, so it read neither the repository's `AGENTS.md` nor its permission rules, and wrote its
note outside the repository. It takes its directory from `PWD`, which PowerShell does not set and
`sh` does; the harness runs agents from `sh`, and its usage notes say so.

On Windows, `agy` 1.5.12's terminal sandbox cannot start `sh`: it fails with
`fatal error - NtCreateDirectoryObject ... 0xC0000022`, an access denial, so the index generator
never runs. Sessions reported it as an exit code 0 with no change, or as exit code 1 followed by a
hand-edited index. The sandbox is not only `--sandbox`'s: print mode starts in `auto` mode, which
runs every command in it, so dropping the flag changes nothing. Gemini's three runs on 2026-11-17
under 1.5.2 regenerated the index in the same mode, so the fault came with a later version.

An allow list does not get around it. Under `--mode accept-edits`, commands run outside the sandbox
and only those a rule allows run at all, since print mode cannot ask, but a denied command ends the
session. With the generator alone allowed, GPT-OSS's two sessions ended at their first listing; with
common read-only commands allowed too, listings in forms the list did not foresee - a pipeline,
`pwsh -Command` - ended two of five with nothing written. Under `--dangerously-skip-permissions`,
deny rules still hold and a denial is reported to the model, which carries on, so a deny list is the
workable guard. `--settings` replaces the global permission lists for the session; on Windows a rule
matches only the exact command line unless it uses `regex:`; and with non-workspace access off and
no `--add-dir`, a session wrote its record into `agy`'s own state directory. A bare `ls -R`, aliased
in that shell to a recursive listing tool, never returned and hung the session; on 2026-11-21 it
hung seven of GPT-OSS's first fifteen. A deny rule matching `ls`, `dir`, `Get-ChildItem`, `eza` or
`tree` with a recursive flag, and `eza` and `tree` alone, stopped it.

The correction scenario seeded its 5 MB limit by appending to `docs/spec.md`, which in a repository
whose specification is a tree creates an unmapped file beside `docs/spec/`. In play-bazlang one
session logged the change only and asked whether to delete that file, one edited it and one edited
`docs/spec/mcp.md`; in identigon all three edited it and passed. Neither repository's correction
result says anything about its map. The seed now goes to the specification's entry point.

## Open questions

Nothing outstanding. These are left unanswered deliberately, each for the reason given:

- Repeated runs for Opus, and in customised repositories other than play-bazlang and identigon: four
  of the five models run three times agree on the templates and Haiku is stable in two customised
  maps, so more runs would add little.
- How to make an agent record an invented fact foreign to the project rather than decline it:
  declining a fact the project cannot have is defensible, and such a miss is the scenario's, not the
  map's.
- Agents other than Claude Code, `agy` and OpenCode: the two that read `AGENTS.md` themselves agreed
  with Claude Code, and no other was available.
- How often a refused shell command stops an agent running the index generator: one of six OpenCode
  sessions refused first did not, and a rate needs a scenario built to force refusals.
- Placement scored against each repository's own map rather than the template's: the evidence
  classifies every miss in a customised repository against its map by hand, and no planned work
  needs that done mechanically.
