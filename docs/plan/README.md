# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR or a plan note. `docs/spec.md` §3.3 defines the scales.

## Run the decay scenarios on the other models

**Type:** docs - **Importance:** medium - **Effort:** low

Haiku and Sonnet report the decay they meet in a file they edit without the stanza asking them to
(research note 0005), so the stanza has no line asking for it. Gemini, DeepSeek and GPT-OSS have not
run `decay-plan`, `decay-spec` and `decay-code`; GPT-OSS, which missed most in research note 0003,
is the likeliest to need the line. Run the three scenarios three times on each, with the commands in
0003, and add a report line to the stanza only if a model misses decay it read.

## Find the text agents do not need

**Type:** docs - **Importance:** medium - **Effort:** medium

Shorten the text agents read in an adopted repository - the `AGENTS.md` stanza, then the template
map's routing - in scratch copies of the kit, never in the real files, and run
`tests/doc-kit-eval.sh` against the original and each shortened copy. A passage whose removal
changes neither where facts land nor whether the rules are kept is a candidate for cutting; one
whose removal changes results stays, with its point and its reason. Every session in an adopted
repository reads the map first, and at 2,161 words it is the largest cost the kit imposes; the word
budgets in `tests/doc-kit-word-budget.sh` sit just above today's counts and come down with each cut.
The harness and its scenarios need work first:
[`find-text-agents-do-not-need.md`](find-text-agents-do-not-need.md).

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
