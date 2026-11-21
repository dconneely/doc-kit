# Whether agents report the decay they meet

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-20 and 2026-11-21, on the templates in an
empty repository, with Claude Haiku and Claude Sonnet under Claude Code, DeepSeek Flash under Claude
Code, and Gemini 3.8 Flash and GPT-OSS 120B under `agy`. Three to ten sessions per scenario and arm
show a tendency, not a rate.

## Finding

Whether an agent filing an unrelated fact reports decay it meets depends on the model; the stanza
does not ask it to. The Claude models report decay in the file they edit: given a specification
stating one limit with two numbers, Haiku and Sonnet named both passages and left the choice to the
owner, and given a plan entry marked done, reported it in nearly every session. DeepSeek reported
the two specification decays in four of six sessions and never the plan entry. Gemini, in 26
sessions, and GPT-OSS never reported any, Gemini even when it wrote its fact on the line beside the
contradiction. No session edited decayed text to resolve it.

No session deleted the entry marked done. Agents delete the entries a session finishes (the
`plan-done` scenario), and treat any other edit as outside the request, even when the stanza says to
delete finished entries whoever finished them. Decay of that kind is therefore reported but stays
until the owner acts on the report.

Decay outside the file being edited is reported only when the agent opens the file that shows it.
Given a fact naming the code that implements it, Haiku usually opened the code and reported the
limit it contradicted; Sonnet and Gemini never opened it, and left the code reference out because
the map says only quirk entries name code.

A stanza line asking agents to report stale or contradictory text made no measurable difference, for
Haiku, whose reporting was already near the ceiling, or for Gemini, which reported nothing with or
without it. Misses come from not looking, which a line about what to do on seeing decay does not
change, or from a model that sees decay and does not remark on it, which the line did not change
either. A longer line telling the agent to read a document whole before adding to it did no better
with Haiku. Neither is in the stanza.

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, and `--model claude-sonnet-5-5`,
with the index generator allowed, Claude Code 2.1.329, no `CLAUDE.md`. A session passes when it
reports the decay or resolves it; every log was read, and the scores below use the done-marking
check described in Dead ends.

| Scenario     | Decay seeded                                     | Haiku, no line | Haiku, report line | Sonnet, no line |
| ------------ | ------------------------------------------------ | -------------- | ------------------ | --------------- |
| `decay-plan` | a plan entry marked `**Done:**`                  | 6 / 8          | 8 / 8              | 3 / 3           |
| `decay-spec` | 5 MB and 20 MB limits for the same 413 rejection | 3 / 3          | 3 / 3              | 3 / 3           |
| `decay-code` | a 5 MB limit the code sets to 20 MB              | 7 / 8          | 7 / 8              | 0 / 3           |

The report line, in a scratch copy of the kit, followed "Delete finished plan entries": "Report
stale or contradictory text you meet, including text the code contradicts." The read-whole line
("Before adding to a document, read it whole, and report anything in it that is stale, contradictory
or contradicted by the code.") ran three Haiku sessions each: `decay-plan` 3 of 3, `decay-code` 2
of 3.

Reports named the decay specifically and declined to choose: "Those cannot both hold for the same
limit, so one of them needs the owner's decision" (`decay-spec`, no line); "One of the two is wrong,
and it needs deciding which before the spec is corrected" (`decay-code`, no line). Every
`decay-plan` report left the entry because deleting it was outside the request. All 65 decay
sessions, those in Dead ends included, kept the rules.

With the stanza's plan line changed to "Delete finished plan entries, whoever finished them; don't
mark them done.", five Haiku `decay-plan` sessions each reported the entry and none deleted it: "I
left it alone because it is outside this request, and it is yours to decide." Three `plan` sessions
under the same line removed nothing from the plan.

The other models, on the kit cut as research note 0006 describes, scored by the checks as corrected
in Dead ends, which agree with a reading of every log. DeepSeek as `deepseek-flash` at low effort
through its Anthropic-compatible endpoint, under the Claude Code command above; Gemini and GPT-OSS
as `agy --model gemini-3.8-flash-low` and `--model gpt-oss-120b-medium`, with the command in
research note 0003. Sessions passing:

| Scenario     | DeepSeek, no line | Gemini, no line | Gemini, report line | GPT-OSS, no line |
| ------------ | ----------------- | --------------- | ------------------- | ---------------- |
| `decay-plan` | 0 / 3             | 0 / 8           | 0 / 5               | 0 / 3            |
| `decay-spec` | 2 / 3             | 0 / 8           | 0 / 5               | 0 / 3            |
| `decay-code` | 2 / 3             | 0 / 8           | 0 / 5               | 0 / 2            |

DeepSeek's reports were like the Claude models': "the existing `Errors` entry ("larger than 20 MB")
conflicts with the `Upload limit` entry ("larger than 5 MB"). That is pre-existing and outside this
task, so I left it unchanged." Gemini's sessions said only where the fact went. One `decay-spec`
session put it under the `## Errors` heading, directly below the 20 MB rejection that contradicts
the 5 MB one above, and one `decay-plan` session added its entry after the entry marked done.
GPT-OSS declined all three `decay-plan` sessions, asking for the fact it had been given, as it has
the plain plan scenario before (research note 0003); one `decay-spec` session put the fact in a new,
unmapped `docs/errors.md`, breaking the rules, and one declined.

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
the 20 MB rejection; a report must now name both limits. Apart from that Haiku session, the
corrections leave every Claude session's score unchanged.

## Open questions

- What would make Gemini report decay it sees. The report line did not; a line naming what to look
  for, or asking for a closing list of anything stale, is untested.
- Decay in a file the session never opens: no scenario measures it, and a session cannot report what
  it does not read.
