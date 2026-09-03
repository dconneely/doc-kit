# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

## Wire Prettier for Markdown auto-wrapping

**Type:** feature - **Importance:** medium - **Effort:** low

Per ADR-0017: add `.prettierrc.json` (`proseWrap: always`, `printWidth: 100`,
`embeddedLanguageFormatting: off`, scoped to `*.md`) and a pinned pre-commit hook, then run the
one-time bulk reformat it accepts. Dry-run against `templates/` first and confirm the diff stays
cosmetic there before wiring the hook to run on every commit.
