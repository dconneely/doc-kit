---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 2. Keep technical debt in the plan

## Context and Problem Statement

A separate technical-debt file is one of the most commonly requested additions to any documentation
structure, and it was the first candidate to test the three-property rule from ADR-0001. It looked
obviously necessary: debt is a distinct kind of work, teams track it separately, and there is a real
worry behind the request - that debt items get drowned by feature items and never surface.

## Considered Options

- A separate `DEBT.md` or `docs/debt.md` alongside `PLAN.md`
- A type tag within the single ranked plan
- A separate section within `PLAN.md`, ranked independently

## Decision Outcome

Chosen option: **a type tag within the single ranked plan**, alongside `bug`, `feature` and `docs`,
because debt shares its tense, mutability and audience with everything else in the plan, and the
structure divides on those three properties rather than on category.

A separate file was rejected on that test. A separately-ranked section was rejected for the same
reason as a separate file: it prevents the comparison that matters.

### Consequences

- Good, because the trade-off that matters most stays visible. Debt versus feature can only be
  decided inside one ordered list; two lists mean the comparison never happens, and the second list
  is the one that stops being read.
- Good, because filing stops being a classification exercise. "Is decomposing this god object debt
  or architecture? Is a long-standing parser defect a bug, debt, or a specification gap?" - the
  boundary is genuinely fuzzy, and with one list the answer only changes a tag rather than a
  location.
- Bad, because the worry behind the request is real and this decision does not address it. If debt
  items are being drowned, that is a ranking problem, and the answer is to rank them higher - which
  is at least now possible, because they sit in the same list as the things outranking them.
- Neutral: the general lesson, which ADR-0003 then repeated - this candidate split on **category**
  where the structure splits on tense, mutability and audience. Splitting on the wrong axis is what
  makes such files drift apart in format and go stale.
