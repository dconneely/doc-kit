# Where agents file facts in a repository that has adopted the kit

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` between 2026-10-30 and 2026-11-17, but each scenario
ran once per repository and model, so a single run is a sample of agent behaviour, not a rate.

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

Those eight scenarios each have one obvious home, so near-perfect scores there are a ceiling of the
test. Four harder ones hold up too. A rule with its reason is split into the specification and a
`proposed` decision record; a correction rewrites the specification in place and is logged in the
changelog; history goes to a decision record; and a fact with no documentation value is left
unwritten. Agents keep the decision-record rules: no session accepted a record, and once told to,
every session that added one regenerated the decisions index. Before the stanza said so, none did.

Asked to record an invented fact about code a repository lacks, Opus declines unless told the fact
is invented: it names the right destination but will not fill a quirk's `Where:` or test fields, or
a changelog entry, with things that do not exist. The harness therefore says so in its prompt.

Neither the model nor the agent changes this much. On the templates alone, Gemini 3.8 Flash under
`agy`, which reads `AGENTS.md` itself with no `CLAUDE.md` alias to follow, and DeepSeek Flash under
Claude Code each placed 11 of 12 and kept every rule. Each miss followed a passage of the kit that
the scenario does not allow for. DeepSeek put the 25 MB cap and its reason in the specification
alone, citing the record template's note that a record with only one option is usually a misfiled
specification entry. Gemini declined the MySQL history, citing the map's rule 5 ("No history or
account of how you got there, in documents") and the template's warning against a record
reconstructed years afterwards. The map's row for "was X tried?" and `ADOPTING.md` Step 2, which
converts old reasoning into records, support the scenarios' answers instead; the kit does not say
which reading wins.

## Evidence

`claude -p --permission-mode acceptEdits --model opus` and `--model haiku`, harness as of commit
`e354486`, eight scenarios per repository: a decision, a kept defect, a sourced finding, future
work, a term, a shipped change, a behaviour rule and a procedure, each repository run in sequence.
Opus ran play-looplang and cobra, and Haiku every repository, with the how-to pattern widened in
`972ee20`.

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
(expected `docs/glossary.md`), and for Opus the procedure (expected under `docs/howto/` before
`972ee20`). All followed its map, as described above. Every research note was numbered, and every
decision record took the next free number, in every repository.

Sonnet (`--model sonnet`) on the templates alone placed 7 of 8. The miss was a research note named
`vendor-api-rate-limit.md`, which no rule then forbade; `docs/spec.md` §3.4 now requires the number.

Twelve scenarios - the eight plus a rule with its reason, a correction to seeded specification text,
history, and a fact with no home - scored also on the rules (no new checker failure, every touched
record `proposed`), harness as of commit `40f97e1`, with the agent allowed to run the index
generator:

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
repository has no upload feature. Commit `7e49188` corrects the first three scenarios.

`identigon/identigon`, a second customised map, at `8321b29` with its stanza given the index line,
harness as of `7e49188`, Haiku: 8 of 12 placed, 11 of 12 rules kept. Its map leaves out quirks, a
glossary and how-tos, and says known limitations are stated inline in each specification member.
Every miss but one followed that: the kept defect went to a specification member with a decision
record, the term to a specification member, and the how-to was declined as an artefact the map says
is the owner's to add. The other was a decline of the upload cap, as in ripgrep. The broken rule was
a plan entry typed `unknown`, because the prompt allowed "unknown" for a missing path or test name
and Haiku extended it to the type; the prompt now limits it to those, and the entry then passed
both.

The 0.10.0 templates on an empty repository, harness as of `dbe72d2`, `--model claude-haiku-5-5`,
2026-11-16: 12 of 12 placed, 11 of 12 rules kept. The broken rule was the harness's own: the plan
template's example entry fails the checker in every fresh adoption, and the agent's entry above it
moved that failure to a new line number, which the harness compared. It now normalises away line
numbers and subtracts one occurrence per failure already present, so a moved failure is not new but
a second copy is. The plan scenario passed both under that comparison in each of the two runs below.

The same templates, harness as of `d08084f`, 2026-11-17, with two models other than Claude's. `agy`
1.5.2 with `--model gemini-3.8-flash-low --sandbox`, in its default mode, which ran the index
generator without a permission rule: 11 of 12 placed, 12 of 12 rules kept; the miss was the history
declined. Claude Code pointed at DeepSeek's Anthropic-compatible endpoint, model `deepseek-flash` at
low effort, with the index generator allowed: 11 of 12 placed, 12 of 12 rules kept; the miss was the
rule and its reason with no decision record. Every decision record either wrote was `proposed`, and
every one was followed by a regenerated index.

## Dead ends

Running five repositories in parallel exhausted the account's usage limit mid-run, and every session
after that exited with an error the harness first scored as a miss. The harness now reports a failed
session as `ERROR` and stops.

Under `--permission-mode acceptEdits`, an agent told to regenerate the decisions index tried and was
refused, so the session failed the rules for the harness's reason. On Windows, Claude runs the
generator through its PowerShell tool, so a `Bash(...)` permission alone does not match; the harness
documents both.

## Open questions

- Whether placement holds across runs: each scenario here ran once. Repeating each several times
  would give a rate rather than a sample.
- Whether it holds for other agents: `agy` is the only one tried that reads `AGENTS.md` without a
  `CLAUDE.md` alias, with one model, once.
- Which reading of the rule-and-reason and history scenarios the kit intends. Both misses on
  2026-11-17 follow passages of the kit, and settling them means changing a scenario or a passage.
- How placement compares when scored against each repository's own map rather than the template's;
  every miss here was a repository-specific choice the template expectations did not know.
