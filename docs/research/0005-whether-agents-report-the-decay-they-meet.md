# Whether agents report the decay they meet

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-20, on the templates in an empty
repository, with Claude Haiku and Claude Sonnet under Claude Code. Three to eight sessions per
scenario and arm show a tendency, not a rate.

## Finding

An agent filing an unrelated fact usually reports decay it meets in the file it edits, although the
stanza does not ask it to. Given a specification stating one limit with two numbers, both models
named both passages and left the choice to the owner. Given a plan entry marked done, both reported
it in nearly every session. No session edited decayed text to resolve it.

No session deleted the entry marked done. Agents delete the entries a session finishes (the
`plan-done` scenario), and treat any other edit as outside the request, even when the stanza says to
delete finished entries whoever finished them. Decay of that kind is therefore reported but stays
until the owner acts on the report.

Decay outside the file being edited is reported only when the agent opens the file that shows it.
Given a fact naming the code that implements it, Haiku usually opened the code and reported the
limit it contradicted; Sonnet never opened it, and left the code reference out because the map says
only quirk entries name code.

A stanza line asking agents to report stale or contradictory text made no measurable difference.
Reporting was already near the ceiling, and the remaining misses come from not looking, which a line
about what to do on seeing decay does not change. A longer line telling the agent to read a document
whole before adding to it did no better. Neither is in the stanza.

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
The check now looks for "done", which every report used and no other session did.

## Open questions

- Whether Gemini, DeepSeek or GPT-OSS report decay unprompted: none has run these scenarios. Running
  them would settle whether any model needs the report line.
- Decay in a file the session never opens: no scenario measures it, and a session cannot report what
  it does not read.
