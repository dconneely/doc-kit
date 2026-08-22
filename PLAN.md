# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

## Run the link sweep nightly in CI

**Type:** feature — **Importance:** low — **Effort:** low

`lychee` is configured as a manual-stage hook, so the sweep exists but only when someone runs it.
Nightly CI is where it belongs, since link rot happens without anyone touching the repository —
blocked on this repository being published and having CI at all. All 49 unique external links
resolved when last checked (2026-08-22), 2 via redirect.

## Build a worked example

**Type:** docs — **Importance:** low — **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.
