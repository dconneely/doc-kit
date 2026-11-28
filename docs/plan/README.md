# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR or a plan note. `docs/spec.md` §3.3 defines the scales.

## Keep each eval session's tool calls

**Type:** debt - **Importance:** medium - **Effort:** medium

A session's log holds its final answer only, so whether it opened the map, the quirks or the code
cannot be seen, and a session that never read the map needs a different fix to the kit from one that
misread it (research note 0009). Save the agent's full event stream beside the log, such as Claude's
`--output-format stream-json --verbose`, and keep the log as the final answer alone, since the
checks read it as lines of text and a JSON stream puts a whole answer on one line.

## Build a worked example

**Type:** docs - **Importance:** medium - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. The README
offers this repository as the example, but it is a documentation kit with almost no product code, no
quirks and no archive, so it shows an outside adopter few of the artefacts they would keep. Its
adopted state, given as `DOC_KIT_EVAL_BASE`, would also let the eval scenarios, the coding ones
above all, run in a realistic repository rather than one holding little but the templates. It can
wait until the procedure has stopped moving.

## Score reports with a model grader calibrated on saved logs

**Type:** debt - **Importance:** low - **Effort:** medium

`check_decay_plan`, `both_limits`, `check_pointer` and `check_work_quirk` in `tests/doc-kit-eval.sh`
decide whether a session reported something by matching its answer against regular expressions,
which have failed both ways - missing a report worded another way, and passing sessions that only
quoted text they had written (research note 0005, Dead ends). Grade each report with a model as
research note 0009 describes: a rubric per scenario, scored examples, reasoning before the verdict,
and "unknown" as an answer. Score the saved logs by hand where research note 0005 has not, tune the
grader on some models' logs and measure its agreement on the others', and use it to pick out the
logs to read. Reading them stays: it is how a fault in the kit itself is found.

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
