# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `SPECIFICATION.md` §3.3 defines the scales.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

## Let an accepted ADR carry an append-only revisions section

**Type:** feature - **Importance:** low - **Effort:** medium

Trigger: adopters still writing a successor ADR for each revision of a decision, despite iterating
while `proposed`. Then write an ADR on letting an accepted record carry a dated, append-only
`Revisions` section, as `yadr` does for Y-statements - moving ADRs from immutable to append-only,
which keeps the original words but changes a core rule of `SPECIFICATION.md` §3.1, and the
history-based immutability check it recommends. Until the trigger, iterating while `proposed` is the
answer.
