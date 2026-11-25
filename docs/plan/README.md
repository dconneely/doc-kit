# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR or a plan note. `docs/spec.md` §3.3 defines the scales.

## Publish doc-kit's checks as prek hooks

**Type:** feature - **Importance:** medium - **Effort:** low

Adopting repositories copy doc-kit's checks into their own `.pre-commit-config.yaml` as local hooks:
`lowercase-adr-status` and `no-nygard-status-section` appear word for word in this repository and
one adopter, `no-template-banner` here alone, and one adopter runs its own copy of
`tools/doc-kit-check.sh`. The copies drift from each other and from the doc-kit version adopted. A
`.pre-commit-hooks.yaml` here would let each adopter pin them at the release it adopted, the checker
as a `language: script` hook and the others as `pygrep`, with this repository running them as local
hooks so each change is checked by the version it makes. `sh-scripts-are-posix` stays out: it is not
a documentation rule, and is planned for a shared hook repository instead. `ADOPTING.md` then says
which hooks to pin.

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
