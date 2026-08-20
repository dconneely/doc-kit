# 8. Accepting a decision record is a human action

## Status

Proposed

## Context

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

## Decision

Authoring a record and accepting one are different acts, and only the second is reserved.

An agent MAY draft a record, argue it, and merge it as `Proposed`. **Changing a record's status —
to `Accepted`, `Deprecated`, or `Superseded by` — is a human action.** An agent must not do it
unprompted, and a person doing it is asserting that a decision was actually made.

**Only `Accepted` records bind.** A `Proposed` record is a suggestion, and no reader — human or
agent — may treat it as a constraint. This is what bounds the damage: an enthusiastic agent can
generate noise, but it cannot generate authority.

## Consequences

The blast radius of an over-productive agent is limited to clutter. Clutter is a real cost and the
plan should carry an entry when it appears, but it is recoverable in a way that false constraint is
not — a `Proposed` record can simply be deleted, since nothing depended on it.

The rule is not mechanically enforceable, and we do not pretend otherwise. Commit metadata can be
set by anything. This is a convention held by review, and its main value is being written down so
that a reviewer seeing an agent-authored status flip knows to object.

Projects using pull requests should make the status flip **its own pull request**. A separate commit
is not enough: squash merging collapses a branch into a single commit on the trunk, so a flip made
alongside the drafting disappears into it, and the control becomes unobservable exactly where it
needs to be seen. A dedicated pull request survives any merge strategy and reduces acceptance to a
one-line diff — trivial to review, and conspicuous if it arrives unaccompanied by a decision.

This stays a recommendation rather than a requirement, because projects without pull requests are
not excluded from this structure and should not be told they are.

The cost is one word edited by a person. That is deliberately trivial: a control expensive enough to
resent is one that gets bypassed.

The reasoning generalises past records. Any artifact whose authority comes from someone having
decided — rather than from being checkable — needs the same separation between drafting and
committing to it. Accepting a record is the only such artifact in this structure today.
