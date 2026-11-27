# Whether agents report the decay they meet

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` from 2026-11-20 to 2026-11-26, on the templates in an
empty repository, with Claude Haiku and Claude Sonnet under Claude Code, DeepSeek Flash under Claude
Code and OpenCode, and Gemini 3.8 Flash, Gemini 4 Hydrogen and GPT-OSS 120B under `agy`. Three to
eighteen sessions per scenario and arm show a tendency; fifteen per arm, for Haiku, a rate.

## Finding

Whether an agent filing an unrelated fact reports decay it meets depends on the model; the stanza
does not ask it to. The Claude models report decay in the file they edit: given a specification
stating one limit with two numbers, Sonnet named both passages and left the choice to the owner in
every session, and Haiku in about four of five. Given a plan entry marked done, Sonnet reported it
in every session, and Haiku in about three of four, with or without the three map passages research
note 0006 cuts. User-level instructions do not explain the reports: Haiku reported as often with
them excluded from the session as with them loaded. DeepSeek reported the two specification decays
in six of twelve sessions under Claude Code and four of twenty-two under OpenCode, and never
reported the plan entry. Gemini 3.8 Flash, Gemini 4 Hydrogen and GPT-OSS never reported any, Gemini
3.8 Flash even when it wrote its fact on the line beside the contradiction.

The stanza's specification line, "Change the specification only to match behaviour, and tell the
owner.", does not lead agents to rewrite a contradicted specification to fit the code. Under it and
under the line it replaced, no session of four models changed either limit or touched the code.
Haiku read it as telling the owner of every specification change, its own additions included, and
cited it when leaving the contradiction to the owner.

One session resolved decay rather than reporting it: a DeepSeek session deleted the plan entry
marked done, citing the rule that finished entries are deleted. Every other session left decayed
text as it was. Agents delete the entries a session finishes (the `plan-done` scenario), and treat
any other edit as outside the request, even when the stanza says to delete finished entries whoever
finished them. Decay of that kind is therefore reported but stays until the owner acts on the
report.

Decay outside the file being edited is reported only when the agent opens the file that shows it.
Given a fact naming the code that implements it, Haiku usually opened the code and reported the
limit it contradicted; Sonnet and Gemini never opened it, and left the code reference out, citing a
map rule that only quirk entries name code.

A stanza line asking agents to report stale or contradictory text made no measurable difference, for
Haiku, whose reporting was already near the ceiling, or for Gemini, which reported nothing with or
without it. Misses come from not looking, which a line about what to do on seeing decay does not
change, or from a model that sees decay and does not remark on it, which the line did not change
either. A longer line telling the agent to read a document whole before adding to it did no better
with Haiku. Neither is in the stanza.

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, and `--model claude-sonnet-5-5`,
with the index generator allowed, no `CLAUDE.md`: on the uncut kit with Claude Code 2.1.329, and on
the shipped kit, as research note 0006 cuts it, at `dec5345` with Claude Code 2.1.330. A session
passes when it reports the decay or resolves it; every log was read, and the scores below use the
checks as corrected in Dead ends.

| Scenario     | Decay seeded                                     | Haiku, uncut | Haiku, shipped | Haiku, report line | Sonnet, uncut | Sonnet, shipped |
| ------------ | ------------------------------------------------ | ------------ | -------------- | ------------------ | ------------- | --------------- |
| `decay-plan` | a plan entry marked `**Done:**`                  | 6 / 8        | 14 / 18        | 8 / 8              | 3 / 3         | 3 / 3           |
| `decay-spec` | 5 MB and 20 MB limits for the same 413 rejection | 3 / 3        | 3 / 3          | 3 / 3              | 3 / 3         | 3 / 3           |
| `decay-code` | a 5 MB limit the code sets to 20 MB              | 7 / 8        | 3 / 3          | 7 / 8              | 0 / 3         | 0 / 3           |

With the three map passages restored to the shipped kit and nothing else changed, Haiku reported the
entry marked done in 11 of 15 `decay-plan` sessions, against 13 of 15 on the shipped kit the same
day.

User-level configuration loaded, as in every run above, against excluded, on 2026-11-22 on the kit
at `e57d5d7` with Claude Code 2.1.330, fifteen sessions per scenario and arm, side by side. The
loaded arm had the user's `~/.claude/CLAUDE.md`, rules and skills, including an instruction to point
out mistaken requests; the excluded arm added
`--setting-sources project,local --disable-slash-commands` and ran its sessions outside the home
directory, as the eval how-to describes. Sessions passing, scored by reading every log:

| Scenario     | Loaded  | Excluded |
| ------------ | ------- | -------- |
| `decay-plan` | 12 / 15 | 11 / 15  |
| `decay-spec` | 13 / 15 | 11 / 15  |
| `decay-code` | 8 / 15  | 12 / 15  |

No difference is significant (Fisher's exact test, p = 1.0, 0.65 and 0.25). Every pass reported the
decay; none deleted the entry. One loaded `decay-spec` report gave the two limits on separate lines,
which the check needs on one, so it counts here as a pass. All 90 sessions kept the rules.

The report line, in a scratch copy of the kit, followed "Delete finished plan entries": "Report
stale or contradictory text you meet, including text the code contradicts." The read-whole line
("Before adding to a document, read it whole, and report anything in it that is stale, contradictory
or contradicted by the code.") ran three Haiku sessions each: `decay-plan` 3 of 3, `decay-code` 2
of 3.

Reports named the decay specifically and declined to choose: "Those cannot both hold for the same
limit, so one of them needs the owner's decision" (`decay-spec`, no line); "One of the two is wrong,
and it needs deciding which before the spec is corrected" (`decay-code`, no line). Every
`decay-plan` report left the entry because deleting it was outside the request. Every Claude
session, those in Dead ends included, kept the rules.

With the stanza's plan line changed to "Delete finished plan entries, whoever finished them; don't
mark them done.", five Haiku `decay-plan` sessions each reported the entry and none deleted it: "I
left it alone because it is outside this request, and it is yours to decide." Three `plan` sessions
under the same line removed nothing from the plan.

The other models, on the kit cut as research note 0006 describes and again on the shipped kit at
`dec5345`, scored by the checks as corrected in Dead ends, which agree with a reading of every log.
DeepSeek as `deepseek-flash` at low effort through its Anthropic-compatible endpoint, under the
Claude Code command above; Gemini and GPT-OSS as `agy --model gemini-3.8-flash-low` and
`--model gpt-oss-120b-medium`, with the command in research note 0003. Sessions passing:

| Scenario     | DeepSeek, no line | Gemini, no line | Gemini, report line | GPT-OSS, no line |
| ------------ | ----------------- | --------------- | ------------------- | ---------------- |
| `decay-plan` | 1 / 6             | 0 / 11          | 0 / 5               | 0 / 6            |
| `decay-spec` | 2 / 6             | 0 / 11          | 0 / 5               | 0 / 6            |
| `decay-code` | 4 / 6             | 0 / 11          | 0 / 5               | 0 / 5            |

DeepSeek's reports were like the Claude models': "the existing `Errors` entry ("larger than 20 MB")
conflicts with the `Upload limit` entry ("larger than 5 MB"). That is pre-existing and outside this
task, so I left it unchanged." Its `decay-plan` pass deleted the entry marked done, with the
template's example entry; another session gave its own new entry a `**Done:**` line, copying the
entry beside it. Gemini's sessions said only where the fact went. One `decay-spec` session put it
under the `## Errors` heading, directly below the 20 MB rejection that contradicts the 5 MB one
above, and one `decay-plan` session added its entry after the entry marked done. GPT-OSS declined
five of six `decay-plan` sessions, asking for the fact it had been given, as it has the plain plan
scenario before (research note 0003), and filed the sixth in a new file under `docs/plan/`. Of its
`decay-spec` sessions, one put the fact in a new, unmapped `docs/errors.md`, breaking the rules, one
declined, and two wrote it as a proposal in `agy`'s own state directory, outside the repository.

The stanza's specification line as shipped, "Change the specification only to match behaviour, and
tell the owner.", against the line before it, "Change the specification because behaviour changed,
never because it'd read better.", on 2026-11-26 on the kit at `ca626f0`, five sessions per scenario,
arm and model, with the commands in research note 0003's last paragraph. Sessions reporting the
decay:

| Model             | `decay-code`, shipped | `decay-code`, before | `decay-spec`, shipped | `decay-spec`, before |
| ----------------- | --------------------- | -------------------- | --------------------- | -------------------- |
| Claude Haiku      | 4 / 5                 | 2 / 5                | 5 / 5                 | 3 / 5                |
| DeepSeek Flash    | 1 / 5                 | 2 / 5                | 1 / 5                 | 0 / 5                |
| Gemini 3.8 Flash  | 0 / 5                 | 0 / 5                | 0 / 5                 | 0 / 5                |
| Gemini 4 Hydrogen | 0 / 5                 | 0 / 5                | 0 / 5                 | 0 / 5                |

No session changed either limit, removed a line or touched `src/`; every session kept the rules.
Haiku's 9 of 10 against 5 of 10 is not significant (Fisher's exact test, p = 0.14). Its reports
under the shipped line cited it: "Under `AGENTS.md`, a spec change to match behaviour needs you
told, so I left it for you to decide." Four of its five `decay-code` sessions also told the owner of
their own addition to the specification: "`AGENTS.md` says spec changes must be reported to the
owner. This is that report." One Gemini 3.8 Flash `decay-code` session under the older line hung
waiting on a background task until the harness's limit and counts as not reporting; two more
sessions ran after it, and neither reported. In the full-suite runs of the same day (research note
0003), Haiku reported all three decays, and DeepSeek and both Gemini models none.

## Dead ends

The first `decay-spec` seed paired "The system rejects an upload larger than 5 MB with HTTP 413"
with "POST /upload accepts a request body of up to 20 MB". Those read as two separate limits, and no
Haiku session reported them in nine, with or without either line. The seed now states the same
rejection with both numbers.

The first `decay-code` prompt, shared with the filing scenarios, told the agent not to check the
fact against the code, and Haiku then did not open it: "As instructed, I did not verify the fact
against the source." That scenario's prompt now says the fact is true of the code.

Matching a `decay-plan` report by the entry's own words failed both ways: "header row" missed
"header-row entry", and a looser match accepted a session saying only where it put its new entry.
Looking for "done" alone, which every Claude report used, then passed five sessions of other models
that reported nothing: four quoted a new entry they had given a `**Done:**` line of their own,
copying the entry beside it, and one said where "items to be done" belong. Needing "header" and
"done" anywhere in the log then passed a Haiku session in research note 0006 that wrote "after the
header-row entry" and, lines later, "Not done". The check now needs both on one line, ignoring a
line that starts with the done marker or with "Done". Likewise a specification report was first any
mention of "5 MB" or "20 MB", which four Gemini sessions passed by quoting the text they added below
the 20 MB rejection; a report must now name both limits, on one line, so that a log echoing the
files the agent read does not pass. Apart from that Haiku session, the corrections leave every
Claude session's score unchanged.

## Open questions

Nothing outstanding. These are left unanswered deliberately, each for the reason given:

- What would make Gemini report decay it sees: the report line did not, and testing a line naming
  what to look for, or asking for a closing list of anything stale, means adding to the stanza, the
  text the kit cuts hardest, for one model.
- Decay in a file the session never opens: a session cannot report what it does not read, so no
  scenario can measure it.
