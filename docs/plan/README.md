# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR or a plan note. `docs/spec.md` §3.3 defines the scales.

## Run the evals on the other models

**Type:** docs - **Importance:** medium - **Effort:** low

The stanza and the template map were cut, and the stanza left without a line asking agents to report
the decay they meet, on evidence from Haiku and Sonnet alone (research notes 0005 and 0006). Run the
full suite three times on Gemini, DeepSeek and GPT-OSS, with the commands in research note 0003.
GPT-OSS, which missed most there, is the likeliest to need what was cut or a report line; restore a
passage, or add the line, only if a model misses where it would help.

## Build a worked example

**Type:** docs - **Importance:** medium - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. The README
offers this repository as the example, but it is a documentation kit with almost no product code, no
quirks and no archive, so it shows an outside adopter few of the artefacts they would keep. It can
wait until the procedure has stopped moving.

## State each repeated rule and list once

**Type:** docs - **Importance:** low - **Effort:** low

`docs/spec.md` states the owner's permission rule for decision records in full twice, in §3's
mutability bullets and in §3.1, and `ADOPTING.md`'s four consequences reappear as a numbered list in
`ADOPTING-NOTES.md`. Keep one copy of each and point to it from the other place, as §4.1 requires;
the copies agree today, so this guards a future edit that changes only one.
`tests/doc-kit-duplicate-check.sh` reports neither, which is worth a look while doing it.

## Rewrite research note 0003 as its current answer

**Type:** docs - **Importance:** low - **Effort:** medium

`docs/research/0003-where-agents-file-facts.md` has grown into a sequence of dated runs, with
passages such as "before the correction seed was fixed" and a long account of one agent's sandbox -
the research-diary shape `ADOPTING-NOTES.md` names as a failure. Restate the evidence by model and
repository, keep the results and the dead ends that would save someone repeating the work, and drop
the order in which the runs happened.

## Evaluate the adoption procedure

**Type:** docs - **Importance:** low - **Effort:** high

`tests/doc-kit-eval.sh` measures an agent working in an adopted repository, so it never reads
`ADOPTING.md`, the specification or the `doc-kit-adopt` skill, and cannot show whether text in them
is needed. Scenarios that run an adoption - of an empty repository, of one with messy documentation,
and a re-adoption - would. Each is a long session, so they cost far more than the filing scenarios;
the worked example's starting repository could serve as one.
