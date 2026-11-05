# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Find the text agents do not need

**Type:** docs - **Importance:** medium - **Effort:** medium

Shorten the text agents read in an adopted repository - the `AGENTS.md` stanza, then the template
map's routing - in scratch copies of the kit, never in the real files, and run
`tests/doc-kit-eval.sh` against the original and each shortened copy. A passage whose removal
changes neither where facts land nor whether the rules are kept is a candidate for cutting; one
whose removal changes results stays, with its point and its reason. The harness and its scenarios
need work first: [`find-text-agents-do-not-need.md`](find-text-agents-do-not-need.md).

## Evaluate the adoption procedure

**Type:** docs - **Importance:** low - **Effort:** high

`tests/doc-kit-eval.sh` measures an agent working in an adopted repository, so it never reads
`ADOPTING.md`, the specification or the `doc-kit-adopt` skill, and cannot show whether text in them
is needed. Scenarios that run an adoption - of an empty repository, of one with messy documentation,
and a re-adoption - would. Each is a long session, so they cost far more than the filing scenarios;
the worked example's starting repository could serve as one.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.
