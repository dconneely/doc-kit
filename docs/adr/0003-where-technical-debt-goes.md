---
status: "proposed"
date: 2026-10-24
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 3. Where technical debt goes

## Context and Problem Statement

A separate technical-debt file is one of the most commonly requested additions to a documentation
structure. It looks necessary: debt is a distinct kind of work, teams track it separately, and the
worry behind the request is real - that debt items are drowned by feature items and never surface.

## Considered Options

- A separate `DEBT.md` or `docs/debt.md` alongside `PLAN.md`
- A type tag within the single ranked plan
- A separate section within `PLAN.md`, ranked independently

## Decision Outcome

Chosen option: **a type tag within the single ranked plan**, alongside `bug`, `feature` and `docs`,
because debt shares its tense, mutability and audience with everything else in the plan (ADR-0002).

A separate file fails that test. A separately ranked section was rejected for the same reason: it
prevents the comparison that matters.

### Consequences

- Good, because debt and features compete in one ordered list, which is the only place that
  trade-off can be made. With two lists the comparison never happens, and the second list stops
  being read.
- Good, because filing stops being a classification exercise. Whether an item is debt, a bug or a
  specification gap is genuinely fuzzy, and with one list the answer changes a tag, not a location.
- Bad, because the worry behind the request remains. If debt items are drowned, that is a ranking
  problem, and the answer is to rank them higher - which one list at least makes possible.
