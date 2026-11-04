# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Find the text agents do not need

**Type:** docs - **Importance:** medium - **Effort:** medium

Shorten the text agents read - the `AGENTS.md` stanza, the map template's routing, `ADOPTING.md`'s
steps, then the specification - in scratch copies of the kit, never in the real files, and run
`tests/doc-kit-eval.sh` against the original and each shortened copy. A passage whose removal
changes neither where facts land nor whether the rules are kept is a candidate for cutting; one
whose removal changes results stays, with its point and its reason. Each scenario is a paid agent
session whose result varies, so compare repeated runs rather than single ones.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.
