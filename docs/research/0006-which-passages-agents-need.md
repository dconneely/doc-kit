# Which passages of the stanza and the template map agents need

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` from 2026-11-20 to 2026-11-22, on the templates in an
empty repository. The variants ran with Claude Haiku under Claude Code; DeepSeek Flash, Gemini 3.8
Flash and GPT-OSS 120B then ran the full suite on the cut kit, and Haiku its decay scenarios
(research note 0005). A shorter routing table ran with Haiku and Gemini 3.8 Flash. Three runs per
scenario and variant show whether a passage changes results, not by how much.

## Finding

Five passages made no difference to where Haiku filed facts or whether it kept the rules, and are
cut. From the `AGENTS.md` stanza: the list giving each artefact's tense, which the template map also
gives, and the bold "Write the least that is true" line, which the map states as a rule of its own.
From the template map: the paragraph saying each artefact holds its own rules and pointing to the
adoption record, the advice to split a sentence that fits two places, and the rule that tense routes
a fact, which the routing table already does. The stanza went from 264 words to 178, the map from
2,106 to 2,031, and to 1,819 with the shorter routing table below.

Three passages are needed:

- **The stanza's specification line.** Without "Change the specification because behaviour changed,
  never because it'd read better. Purpose and scope aren't yours to revise.", sessions asked to
  reword the specification's scope did so.
- **The stanza's plan line, and the map's Flow.** Without "Delete finished plan entries; don't mark
  them done.", or without the Flow ending in the entry's deletion, a session that finished planned
  work sometimes never opened the plan and left the entry; with both, none did.

The routing table is shorter, not cut. Without its "If you are asking..." column, with the two plan
rows and the two quirks rows each merged into one and the longer cells shortened, it went from 395
words to 216, and Haiku and Gemini placed facts and kept the rules as well as on the full table. On
either table, Gemini filed the rule with its reason, an upload cap the reverse proxy imposes, as a
quirk in about half its sessions, reading the cap as a constraint the system knowingly lives with,
and edited the generated decisions index by hand in about a third of the sessions that wrote a
record. Cut outright, the ten rows a scenario covers made no difference to Haiku, which also
reported a finished plan entry it met while adding one as often as on the full map; no other model
has run without them.

The three map passages, cut together, did not cost that report either: on the same day, Haiku
reported a finished plan entry in 13 of 15 sessions on the shipped kit and in 11 of 15 with the
three restored (research note 0005).

The other three models placed as well on the cut kit as on the uncut one (research note 0003), and
none of their misses was where a cut passage would have helped. Their misses came where a passage
that stays should have prevented them, or where the map allows the reading the model took.

Most of the map is not a candidate: the layout, artefacts and lifecycle tables and the property
values are what the checker and the specification read, and `ADOPTING.md` names the sections. The
passages no scenario exercises stay, untested: the stanza's archive, `decision-makers`, citation and
map-update lines; the map's other routing rows, "Deliberately not here", and "Adding a new kind of
document".

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, the index generator allowed,
Claude Code 2.1.329, no `CLAUDE.md`, three runs. Each variant was a copy of the kit with one passage
removed, running the scenarios that use the passage; `tests/doc-kit-eval-variant.sh` builds such a
copy. The baseline is the same model's full-suite runs on the uncut kit that day (research notes
0003 and 0005). Sessions placed:

| Passage removed                                                  | Scenarios run                                                                                                               | Baseline                    | Without it                  |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------- | --------------------------- |
| stanza: the tense list, keeping the quirks and archive lines     | decision, quirk, research, plan, changelog, spec, howto, rule-and-why, correction, history, plan-done, accept               | 35 / 36                     | 36 / 36                     |
| stanza: "Change the specification because behaviour changed ..." | spec, changelog, correction, rule-and-why, scope                                                                            | 15 / 15                     | 13 / 15                     |
| stanza: "Delete finished plan entries; don't mark them done."    | plan-done, decay-plan                                                                                                       | 3 / 3, 6 / 8                | 3 / 3, 2 / 3                |
| stanza: "Write the least that is true. ..."                      | history, correction, decision, rule-and-why                                                                                 | 12 / 12                     | 12 / 12                     |
| stanza: "Adding a document means updating `DOC-MAP.md` ..."      | howto, research, decision                                                                                                   | 9 / 9                       | 9 / 9                       |
| map: the ten covered routing rows                                | decision, quirk, research, plan, glossary, changelog, spec, howto, rule-and-why, correction, history, plan-done, decay-plan | 35 / 36, decay-plan 11 / 15 | 36 / 36, decay-plan 13 / 15 |
| map: the Flow                                                    | plan-done, correction, changelog, decision, rule-and-why, history                                                           | 18 / 18                     | 17 / 18                     |
| map: rule 2, "Tense routes it"                                   | spec, decision, changelog, plan, history, correction                                                                        | 18 / 18                     | 18 / 18                     |
| map: "If a sentence seems to fit two places ..."                 | rule-and-why, correction, changelog, history                                                                                | 12 / 12                     | 12 / 12                     |
| map: "Each artefact holds its own format and rules ..."          | decision, research, howto, quirk, plan                                                                                      | 14 / 15                     | 15 / 15                     |

Every session in every variant kept the rules. Both misses without the specification line were
`scope`: the session rewrote the scope sentence in place, one saying "The meaning is the same, and
nothing about what the system does has changed." Each `plan-done` miss, without the plan line or
without the Flow, recorded the shipped change in the changelog and the specification and never
opened the plan. The routing rows' `decay-plan` counts are fifteen sessions per arm, run side by
side on 2026-11-21 on the kit at `e9fb1ea` with Claude Code 2.1.330; every session that reported
named the entry marked done and said finished entries are deleted, and every miss filed its own
entry and said nothing of the other.

Cut together, the stanza's tense list, plan line and write-the-least line placed 51 of 54 full-suite
sessions; the one `plan-done` miss among them is why the plan line stays. The three map passages cut
together placed 51 of 54: one `quirk` session also filed the defect as a plan entry, and two
`decay-plan` sessions did not report, each within its baseline spread; on the shipped kit, Haiku
reported the entry in 14 of 18 `decay-plan` sessions (research note 0005). Both combined runs kept
the rules in all 54.

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

The shorter routing table ran on 2026-11-21 on the kit at `e8f3e2c`, the 13 filing scenarios three
times per arm and model, side by side: Haiku under Claude Code 2.1.330 as above, and Gemini 3.8
Flash under `agy` 1.5.14 with the command in the how-to. Sessions placed, and sessions that kept the
rules:

| Routing table                                  | Words | Haiku placed | Haiku kept | Gemini placed | Gemini kept |
| ---------------------------------------------- | ----- | ------------ | ---------- | ------------- | ----------- |
| full                                           | 395   | 38 / 39      | 38 / 39    | 39 / 39       | 39 / 39     |
| without the asking column                      | 275   | 39 / 39      | 38 / 39    | 37 / 38       | 37 / 38     |
| also merged and shortened, quirks row as above | 213   | 39 / 39      | 39 / 39    | 38 / 39       | 38 / 39     |

Haiku's one miss, on the full table, was a `plan-done` session that never opened the plan. Both its
rule breaks left the decisions index stale because PowerShell timed out on every command with six
runs sharing the machine, which the sessions reported; such timeouts appear in all three arms.
Gemini's misses: a quirk also filed as a plan entry; a history fact placed in a decision record and
the generated index hand-edited, the same rule break as one `decision` session; and the rule with
its reason filed as a quirk. One Gemini session, a rule with its reason without the asking column,
ran past the 30-minute limit and is not counted. The third table, with the quirks row's "from the
reference/spec" restored, is the one shipped.

Gemini then ran six more times on the shipped table and on the full one, side by side on 2026-11-22
on the kit at `e840bce`. It placed 74 of 78 sessions on the shipped table and 75 of 78 on the full
one, and kept the rules in 74 of 78 on each. Every miss was the rule with its reason filed as a
quirk: four on the shipped table, one of them also writing it in the specification, and three on the
full one. Every rule break was a stale decisions index: of the 24 sessions that wrote a record,
seven edited the index by hand - four on the shipped table, three on the full one - and one left it
untouched, although the stanza says to run the generator and the index's header says not to edit it
by hand.

Allowing Haiku to run `tools/doc-kit-check.sh` as well as the index generator changed nothing: on
the same day and kit, with and without it, Haiku placed 38 of 39 sessions and kept the rules in
all 39. Fewer sessions said they could not run the checker, but none filed a fact differently.

## Dead ends

One Gemini session on the shortest table filed the rule with its reason as a quirk, citing the
quirks row shortened to "we knowingly differ here", which suggested the shortening caused it.
Restoring "from the reference/spec" did not help: with the original wording, on the shipped table
and on the full one, Gemini made the same miss in seven of twelve sessions.

GPT-OSS's sessions under `agy` hung in seven of its first fifteen: the model listed the repository
with `ls -R`, which the shell `agy` starts resolves to a recursive listing tool that never returned,
and `agy` waited on it. A deny rule for recursive listings, added to the command in research note
0003, stopped the hangs; the model, told the command was refused, carried on. Four sessions ended
with an agent error and no log. One Gemini session, before the rule, hung the same way, waiting on a
background task; what that task was is not recorded.

Three `decay-plan` sessions per kit suggested that two cuts cost the report of a finished plan
entry. Without the routing rows, two of eight sessions reported it, against six of eight on the
uncut map; without the three map passages cut together, two of six. Fifteen sessions per kit on the
same day, with only the cut differing, showed no such effect for either. Three runs show a passage
that changes everything, not one that changes a rate.

## Open questions

- Whether the untested passages are needed. Each needs a scenario that could fail without it: for
  the map-update line, a fact no mapped artefact holds, so that the agent must add a document.
