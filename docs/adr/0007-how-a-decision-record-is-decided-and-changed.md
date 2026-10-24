---
status: "proposed"
date: 2026-10-24
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 7. How a decision record is decided and changed

## Context and Problem Statement

Agents draft decision records readily, with Context and Consequences sections indistinguishable in
form from deliberated ones, and they can produce twenty in an afternoon. `AGENTS.md` and the map
send every session to the records for the reasoning behind constraints, so a record nobody decided
is read as settled. Drafting and deciding were once the same act; with agents they are not.

A record must also stay true. What it protects is a citation: a commit message, a code comment or
another record that says ADR-NNNN relies on the record meaning what it meant. A citation inside the
repository can be found and fixed, provided every citation uses one exact form. One in another
repository cannot.

## Considered Options

- Leave records to review, with no stated rule
- Forbid agents from writing records at all
- Keep accepted records immutable: revise them by successor, with a `refined by` pointer for a
  revision that does not supersede, and an exemption for formatting
- Rewrite accepted records freely, like the specification
- Let agents draft and revise `proposed` records freely; require the owner's permission for every
  change of status and every deletion; amend accepted records in place after the owner reopens them,
  fixing the citations in the same commit

## Decision Outcome

Chosen option: **agents draft, the owner decides every change of status, and accepted records are
amended in place**, because it separates writing from deciding without a successor for every change
of mind.

The statuses are MADR's own: `proposed`, `accepted`, `rejected` and `deprecated` (ADR-0008). An
agent may create a record as `proposed`, copied from the template rather than from another record,
and may revise a `proposed` record. The owner's explicit permission, asked for first, is needed to
accept a record, reject one, reopen an accepted one to change it, deprecate one, or delete one. Only
`accepted` binds; `proposed` exists so an agent can put a decision in front of the owner before it
is decided. The owner's words are kept verbatim in `approval`, and `decision-makers` names the
owner.

A record is the current answer to one question, and its title names the question. Changing an
accepted record takes two permissions: reopening it, and accepting the change. If the owner rejects
the change, the last accepted version is restored. A record is normally accepted before it is
committed, so history holds its accepted versions, and carries no revision log of its own. When a
record's question splits, merges or no longer applies, the record is deprecated or, more simply,
deleted, and links to whatever replaces it.

Citations take one form, `ADR-NNNN`, and a bare ID names a record in this repository; another
repository's record is cited by a link. A change, deletion included, fixes in the same commit every
citation it makes untrue. Commit messages are history, and are left alone. Formatting applied by a
tool, which alters no word, is not a change.

Leaving it to review was rejected because an unwritten rule gives nobody anything to point at.
Forbidding agents from writing records was rejected because drafting is useful; the hazard is
unearned authority, not authorship. Immutability was rejected because every correction became a
successor, and readers assembled chains of records to learn what one decision was. Rewriting freely
was rejected because a citation could then come to mean anything.

### Consequences

- Good, because an over-productive agent can generate clutter, but not authority.
- Good, because corrections and reversals land in the record a reader opens, and there are no
  supersession chains.
- Good, because a checker can find every citation and report one that names no record here.
- Bad, because nothing mechanical stops an agent changing a status. The rule is held by instruction,
  and `approval` only makes a skipped permission visible: an agent omitting it leaves the field
  empty or invents the owner's words.
- Bad, because a commit message citing a record may describe what the record no longer says, and
  `git show` at that commit is the only way to read what it cited.
- Bad, because reading each citation after a change is a judgement, and a search finds nothing
  outside the repository.
