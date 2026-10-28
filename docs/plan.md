# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Implement the shared-content guideline

**Type:** debt - **Importance:** medium - **Effort:** medium

ADR-0006 is amended. Rewrite §4.1 as the guideline, align the map rules, testing and glossary, test
the checker's value sets against the templates, and add the advisory detector for repeated tables,
value lists and step sequences. Short instructional copies and template/instance pairs are allowed
and are not the target.

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
