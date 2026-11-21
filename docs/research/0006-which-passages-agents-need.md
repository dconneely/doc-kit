# Which passages of the stanza and the template map agents need

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-20 and 2026-11-21, on the templates in an
empty repository. The variants ran with Claude Haiku under Claude Code; DeepSeek Flash, Gemini 3.8
Flash and GPT-OSS 120B then ran the full suite on the cut kit. Three runs per scenario and variant
show whether a passage changes results, not by how much.

## Finding

Five passages made no difference to where Haiku filed facts or whether it kept the rules, and are
cut. From the `AGENTS.md` stanza: the list giving each artefact's tense, which the template map also
gives, and the bold "Write the least that is true" line, which the map states as a rule of its own.
From the template map: the paragraph saying each artefact holds its own rules and pointing to the
adoption record, the advice to split a sentence that fits two places, and the rule that tense routes
a fact, which the routing table already does. The stanza went from 264 words to 178, the map from
2,106 to 2,031.

Four passages are needed:

- **The stanza's specification line.** Without "Change the specification because behaviour changed,
  never because it'd read better. Purpose and scope aren't yours to revise.", sessions asked to
  reword the specification's scope did so.
- **The stanza's plan line, and the map's Flow.** Without "Delete finished plan entries; don't mark
  them done.", or without the Flow ending in the entry's deletion, a session that finished planned
  work sometimes never opened the plan and left the entry; with both, none did.
- **The map's routing rows.** With the ten rows a scenario covers removed, facts still landed where
  they belong, but sessions far less often reported a finished plan entry they met while adding one.

The other three models placed as well on the cut kit as on the uncut one (research note 0003), and
none of their misses was where a cut passage would have helped. Their misses came where a passage
that stays should have prevented them, or where the map allows the reading the model took.

Most of the map is not a candidate: the layout, artefacts and lifecycle tables and the property
values are what the checker and the specification read, and `ADOPTING.md` names the sections. The
passages no scenario exercises stay, untested: the stanza's archive, `decision-makers`, citation and
map-update lines; the map's other routing rows, its "If you are asking..." column, which serves a
reader looking for a fact rather than filing one, "Deliberately not here", and "Adding a new kind of
document".

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, the index generator allowed,
Claude Code 2.1.329, no `CLAUDE.md`, three runs. Each variant was a copy of the kit with one passage
removed, running the scenarios that use the passage; `tests/doc-kit-eval-variant.sh` builds such a
copy. The baseline is the same model's full-suite runs on the uncut kit that day (research notes
0003 and 0005). Sessions placed:

| Passage removed                                                  | Scenarios run                                                                                                               | Baseline                  | Without it                |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------- | ------------------------- |
| stanza: the tense list, keeping the quirks and archive lines     | decision, quirk, research, plan, changelog, spec, howto, rule-and-why, correction, history, plan-done, accept               | 35 / 36                   | 36 / 36                   |
| stanza: "Change the specification because behaviour changed ..." | spec, changelog, correction, rule-and-why, scope                                                                            | 15 / 15                   | 13 / 15                   |
| stanza: "Delete finished plan entries; don't mark them done."    | plan-done, decay-plan                                                                                                       | 3 / 3, 6 / 8              | 3 / 3, 2 / 3              |
| stanza: "Write the least that is true. ..."                      | history, correction, decision, rule-and-why                                                                                 | 12 / 12                   | 12 / 12                   |
| stanza: "Adding a document means updating `DOC-MAP.md` ..."      | howto, research, decision                                                                                                   | 9 / 9                     | 9 / 9                     |
| map: the ten covered routing rows                                | decision, quirk, research, plan, glossary, changelog, spec, howto, rule-and-why, correction, history, plan-done, decay-plan | 35 / 36, decay-plan 6 / 8 | 36 / 36, decay-plan 2 / 8 |
| map: the Flow                                                    | plan-done, correction, changelog, decision, rule-and-why, history                                                           | 18 / 18                   | 17 / 18                   |
| map: rule 2, "Tense routes it"                                   | spec, decision, changelog, plan, history, correction                                                                        | 18 / 18                   | 18 / 18                   |
| map: "If a sentence seems to fit two places ..."                 | rule-and-why, correction, changelog, history                                                                                | 12 / 12                   | 12 / 12                   |
| map: "Each artefact holds its own format and rules ..."          | decision, research, howto, quirk, plan                                                                                      | 14 / 15                   | 15 / 15                   |

Every session in every variant kept the rules. Both misses without the specification line were
`scope`: the session rewrote the scope sentence in place, one saying "The meaning is the same, and
nothing about what the system does has changed." Each `plan-done` miss, without the plan line or
without the Flow, recorded the shipped change in the changelog and the specification and never
opened the plan. Without the routing rows, six of eight `decay-plan` sessions filed their new entry
correctly and said nothing of the entry marked done beside it, against two of eight on the uncut
map.

Cut together, the stanza's tense list, plan line and write-the-least line placed 51 of 54 full-suite
sessions; the one `plan-done` miss among them is why the plan line stays. The three map passages cut
together placed 52 of 54: one `quirk` session also filed the defect as a plan entry, and one
`decay-plan` session did not report, each within its baseline spread. Both combined runs kept the
rules in all 54.

The full suite on the cut kit at `a395432`, three runs, before the decision-record template's
sentence on agreement (research note 0007). DeepSeek Flash, as in research note 0007, placed every
filing scenario in all three runs, against 35 of 36 sessions on the uncut kit; its one `plan-done`
miss logged the shipped change in the changelog and never opened the plan, as Haiku's did without
the plan line, which DeepSeek had. Gemini 3.8 Flash under `agy`, as in research note 0003, placed 13
of the 14 filing and refusal scenarios in all three runs. The exception was the rule and its reason,
placed once: one session wrote nothing, reading the proxy's upload cap as deployment detail, which
the map's "Deliberately not here" leaves out ("runbooks, unless this is a deployed service"), and
one filed it as a quirk. GPT-OSS 120B under `agy`, on the kit at `95f2399`, with seven sessions hung
and four ended by an error (see Dead ends): of the 28 filing sessions that finished, it placed 23,
against 19 of 36 on the uncut kit, with the same kinds of miss - a record reusing a taken number or
named without one, a research note numbered `0000` or not at all, and the future-work fact not
recognised. It reworded the specification's scope in all three `scope` sessions and left the
finished entry in two `plan-done` sessions; the lines that forbid both are in the stanza.

## Dead ends

GPT-OSS's sessions under `agy` hung in seven of its first fifteen: the model listed the repository
with `ls -R`, which the shell `agy` starts resolves to a recursive listing tool that never returned,
and `agy` waited on it. A deny rule for recursive listings, added to the command in research note
0003, stopped the hangs; the model, told the command was refused, carried on. Four sessions ended
with an agent error and no log. One Gemini session, before the rule, hung the same way, waiting on a
background task; what that task was is not recorded.

## Open questions

- Whether the untested passages are needed. Each needs a scenario that could fail without it: for
  the map-update line, a fact no mapped artefact holds, so that the agent must add a document.
