# Which passages of the AGENTS.md stanza agents need

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-20, on the templates in an empty
repository, with Claude Haiku under Claude Code only. Three runs per scenario and variant show
whether a passage changes results, not by how much.

## Finding

Two passages of the stanza made no difference to where Haiku filed facts or whether it kept the
rules, and are cut: the list giving each artefact's tense, which the template map also gives, and
the bold "Write the least that is true" line, which the template map states word for word as a rule
of its own. The quirks and archive lines from the tense list stay: one is a hazard, and no scenario
covers the other.

Two passages are needed. Without "Change the specification because behaviour changed, never because
it'd read better. Purpose and scope aren't yours to revise.", sessions asked to reword the
specification's scope did so. Without "Delete finished plan entries; don't mark them done.", a
session that finished a planned piece of work once never opened the plan and left the entry; with
the line, none did. The plan template's own header says the same, which is likely why most sessions
deleted the entry without the line.

"Adding a document means updating `DOC-MAP.md` in the same commit" is untested: every scenario's
fact has a home the map already names, so none could fail without the line.

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, the index generator allowed,
Claude Code 2.1.329, no `CLAUDE.md`, three runs. Each variant was a scratch copy of the kit with one
passage removed from the stanza, and ran the scenarios that use the passage. The baseline is the
same model's full-suite runs on the uncut stanza that day (research notes 0003 and 0005).

| Passage removed                                          | Scenarios run                                                                                                 | Baseline       | Without it     |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------- | -------------- |
| the tense list, keeping the quirks and archive lines     | decision, quirk, research, plan, changelog, spec, howto, rule-and-why, correction, history, plan-done, accept | 35 / 36 placed | 36 / 36 placed |
| "Change the specification because behaviour changed ..." | spec, changelog, correction, rule-and-why, scope                                                              | 15 / 15        | 13 / 15        |
| "Delete finished plan entries; don't mark them done."    | plan-done, decay-plan                                                                                         | 3 / 3, 6 / 8   | 3 / 3, 2 / 3   |
| "Write the least that is true. ..."                      | history, correction, decision, rule-and-why                                                                   | 12 / 12        | 12 / 12        |
| "Adding a document means updating `DOC-MAP.md` ..."      | howto, research, decision                                                                                     | 9 / 9          | 9 / 9          |

Every session in every variant kept the rules. Both misses without the specification line were
`scope`: the session rewrote the scope sentence in place, one saying "The meaning is the same, and
nothing about what the system does has changed."

With the tense list, the plan line and the write-the-least line removed together, the full suite of
18 scenarios placed 51 of 54 sessions and kept the rules in 54. `decay-plan` and `decay-code` each
missed once, within their baseline spread. `plan-done` missed once: the session recorded the shipped
change in the changelog and the specification and never opened the plan. With that, removing the
plan line left the entry in one of six sessions, and keeping it in none of six, so the line stays.
The stanza went from 264 words to 178.

## Dead ends

None.

## Open questions

- Whether other models need the cut passages. Only Haiku ran; research note 0003 shows the filing
  scenarios agree across five models, so a full-suite run of one other model on the cut stanza would
  settle it.
- Whether the map line is needed. A scenario whose fact no mapped artefact holds, so that the agent
  must add a document, would test it.
