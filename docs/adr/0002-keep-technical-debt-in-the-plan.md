# 2. Keep technical debt in the plan

## Status

Accepted

## Context

A separate technical-debt file is one of the most commonly requested additions to any documentation
structure, and it was the first candidate to test the three-property rule from ADR-0001. It looked
obviously necessary: debt is a distinct kind of work, teams track it separately, and there is a real
worry behind the request — that debt items get drowned by feature items and never surface.

The alternative was a `DEBT.md` or `docs/debt.md` alongside `PLAN.md`.

## Decision

We will not have a separate technical-debt file. Debt is a **type tag within the single ranked
plan**, alongside `bug`, `feature` and `docs`.

## Consequences

The trade-off that matters most stays visible. Debt versus feature is exactly the decision worth
making explicitly, and it can only be made inside one ordered list; two lists mean the comparison
never happens, and the second list is the one that stops being read.

Filing stops being a classification exercise. "Is decomposing this god object debt or architecture?
Is a long-standing parser defect a bug, debt, or a specification gap?" — the boundary is genuinely
fuzzy, and with one list the answer only changes a tag rather than a location.

The worry behind the request is real and is not addressed by this decision. If debt items are being
drowned, that is a ranking problem, and the answer is to rank them higher — which is now possible,
because they are in the same list as the things outranking them.

The general lesson, which ADR-0003 then repeated: this candidate split on **category** where the
structure splits on tense, mutability and audience. Debt shares all three with the plan. Splitting on
the wrong axis is what makes such files drift apart in format and go stale.
