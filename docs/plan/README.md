# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR or a plan note. `docs/spec.md` §3.3 defines the scales.

## Evaluate whether coding work updates the documents unprompted

**Type:** docs - **Importance:** high - **Effort:** medium

Every `tests/doc-kit-eval.sh` scenario asks the agent to change the documentation, most by handing
it a fact worded much like a row of the routing table, so the evals do not show whether ordinary
coding work keeps the documents current. Seed a project of two or three source files with tests and
matching entries in the specification, plan and quirks, then give coding prompts that never mention
documentation: raise the upload limit (are the specification and changelog updated?), implement a
planned feature (is its plan entry deleted?), and fix a bug that `docs/quirks.md` records as
accepted-wrong (is the quirk left alone, or the owner asked?). The seeding pattern `seed_code`
already uses extends to this, and the same scenarios can later run against the worked example
through `DOC_KIT_EVAL_BASE`.

## Score reports with a model grader calibrated on saved logs

**Type:** debt - **Importance:** medium - **Effort:** medium

`check_decay_plan`, `both_limits`, `check_pointer` and `check_work_quirk` in `tests/doc-kit-eval.sh`
decide whether a session reported something by matching its answer against regular expressions,
which have failed both ways - missing a report worded another way, and passing sessions that only
quoted text they had written (research note 0005, Dead ends) - so every log has to be read. Grade
each report with a model instead, as research note 0009 describes: a rubric per scenario, an example
answer for each verdict, and a verdict with its reason. Score the saved logs of earlier runs by hand
where research note 0005 has not, measure how often the grader agrees, and use it only as far as it
does - to replace reading every log, or to pick out the logs to read.

## Build a worked example

**Type:** docs - **Importance:** medium - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. The README
offers this repository as the example, but it is a documentation kit with almost no product code, no
quirks and no archive, so it shows an outside adopter few of the artefacts they would keep. It can
wait until the procedure has stopped moving.

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
