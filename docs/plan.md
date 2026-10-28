# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Reduce repeated tables, value lists and multi-step processes

**Type:** debt - **Importance:** medium - **Effort:** medium

Needs an ADR. Treat §4.1 as a guideline, not an absolute: a table, a list of more than three values,
or a process of three or more steps should have one home, while short instructional copies and
template/instance pairs may repeat. Decide whether the templates or the specification own each
shared table, value list and process; keep the checker in step with the winner; write the exception
into §4.1 and align the map rules, testing and glossary; and add an advisory detector for repeated
tables, value lists and step sequences rather than repeated sentences. The templates and the kit's
own instance may repeat their own content; that is not the duplication to remove.

## Test the map with agent evals

**Type:** feature - **Importance:** medium - **Effort:** medium

Give agent sessions facts to file - a choice and its reason, a known defect pinned by a test, a
finding with a source - and score where each lands. The agent is the reader whose behaviour the kit
exists to shape, and nothing yet measures whether the map shapes it.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.
