---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 8. Accepting a decision record is a human action

## Context and Problem Statement

This structure tells its readers to treat decision records as authoritative, and ADR-0001 makes
immutability the property that gives them their value. Both assumptions were formed when records
were written by people, at the rate people write them.

Coding agents change the arithmetic. They draft records readily, they produce well-argued Context
and Consequences sections that are indistinguishable in form from deliberated ones, and they can
produce twenty in an afternoon. A developer running one enthusiastically can commit records that
every other developer's agent then reads as settled constraint.

Three properties of this structure make that worse rather than better:

- `AGENTS.md` and the map explicitly direct agents to records for the reasoning behind constraints,
  so a trust channel exists and is currently unguarded.
- An accepted record is immutable by design, so a mistaken one is **sticky**: correcting it requires
  writing a successor, which is heavy machinery for content nobody decided.
- Volume alone degrades the set. A directory of forty records, most of them unconsidered, is one
  nobody reads carefully, which costs the ten real ones their authority.

What was not known when the structure was designed: how cheap authoring would become relative to
deciding. The two were previously the same act, and the structure quietly assumed it.

## Considered Options

* Leave it to review, with no stated rule
* Forbid tools from authoring records at all
* Separate authoring from accepting, and reserve only the second

## Decision Outcome

Chosen option: **separate authoring from accepting**. A tool MAY draft a record, argue it, and merge
it as `proposed`. Changing a record's status — to `accepted`, `rejected`, `deprecated`, or
`superseded by` — is a human action, and a person doing it asserts that a decision was actually
made.

**Only `accepted` records bind.** A `proposed` record is a suggestion, and no reader may treat it as
a constraint. This is what bounds the damage: an enthusiastic tool can generate noise, but it cannot
generate authority.

Forbidding tools from authoring was rejected — drafting is genuinely useful, and the hazard is not
authorship but unearned authority. Leaving it to review was rejected because an unwritten rule gives
a reviewer nothing to point at.

Projects using pull requests should make the status flip **its own pull request**. A separate commit
is not enough: squash merging collapses a branch into a single commit on the trunk, so a flip made
alongside the drafting disappears into it, and the control becomes unobservable exactly where it
needs to be seen. This stays a recommendation, because projects without pull requests are not
excluded from this structure and should not be told they are.

### Consequences

* Good, because the blast radius of an over-productive tool is limited to clutter — recoverable in a
  way false constraint is not, since a `proposed` record can simply be deleted.
* Good, because the cost is one word edited by a person. Deliberately trivial: a control expensive
  enough to resent is one that gets bypassed.
* Bad, because the rule is not mechanically enforceable and we do not pretend otherwise. Commit
  metadata can be set by anything. It is a convention held by review, whose value is being written
  down so a reviewer seeing a tool-authored status flip knows to object.
* Neutral: clutter remains a real cost even when inert, and the plan should carry an entry when it
  appears.
* Neutral: ADR-0010 later adopted MADR front-matter, whose `decision-makers` field records *who*
  decided. Its presence on a non-proposed record is checkable, which is a stronger signal than this
  decision could offer on its own.
