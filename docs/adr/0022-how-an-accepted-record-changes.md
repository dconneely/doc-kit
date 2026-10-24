---
status: "proposed"
date: 2026-10-24
decision-makers: {who decided - required once the status is not "proposed"}
---

# 22. How an accepted record changes

## Context and Problem Statement

`SPECIFICATION.md` §3.1 makes an accepted record immutable except for its status, date and
decision-makers. Every other change needs a successor, however small. Two records already work
around that: ADR-0009 adds a `refined by` pointer, so that a revision need not supersede, and
ADR-0016 permits formatting-only edits. A `PLAN.md` entry proposes a third workaround, an
append-only revisions section. MADR itself does not require immutability: its `date` is "when the
decision was last updated".

What immutability protects is a citation. A commit message, a code comment or another record that
says ADR-0012 relies on the record meaning what it meant when cited. A typo fix does not disturb
that; reversing the decision does. But a citation inside the repository can be found and changed,
provided every citation uses one exact form. In this repository 107 citations already use the form
`ADR-NNNN`. One does not mean a record here: ADR-0017 cites `identigon/identigon`'s ADR-0036, naming
the repository in the prose. A reader understands it; a search for the ID cannot tell it from a
citation of this repository's own records.

Under ADR-0021 the owner is the only person who decides. The question left is what may change in an
accepted record, and what a change has to bring with it.

## Considered Options

- Keep immutability, with the `refined by` pointer and the formatting exemption
- Amend an accepted record only where nothing citing it would be misled; supersede it otherwise
- Amend an accepted record in place, and fix every citation in the repository in the same commit;
  supersede only where citations cannot be fixed
- Rewrite accepted records in place, like the specification

## Decision Outcome

Chosen option: **amend in place and fix the citations**, because it keeps the property immutability
protected - a citation means what the record says - without a successor for each change of mind.

A record is **the current answer to one question**. Its filename and title name the question, not
the answer, so that a changed answer does not make them false. The number of records grows with the
number of questions, not with the number of changes.

**Every change takes two agreements from the owner.** Changing a record - its content or its status,
deleting it or obsoleting it - needs the owner's explicit agreement, asked for first. Once the
change is made, the record is `proposed` again until the owner accepts the change, which is the
second agreement; it then returns to `accepted`. "Looks good", "go ahead", or approval of other work
is neither. The owner's words of acceptance are copied verbatim into an `approval` front-matter
field, and `date` becomes the date of the change. A formatting change applied by a tool, which
alters no word, needs neither (ADR-0016). A change is normally accepted before it is committed, so
history holds the accepted versions, and the accepted text binds until then.

**The change and its citations go in one commit.** Search the repository for the record's ID, read
each citation, and correct it or confirm it still holds.

**Citations take one form.** `ADR-NNNN` - upper case, a hyphen, four digits - and a bare ID always
means a record in this repository. A record in another repository is cited by a link to it. A
citation names the record and claims as little as possible about it: "see ADR-0012" survives a
change that "Postgres, per ADR-0012" does not.

**What cannot be fixed is left alone.** Commit messages are history; `git show` at that commit gives
the record they cited. Citations outside the repository - issues, other repositories, agent memory
files - cannot be found by a search here. Supersede a record when its question splits in two, when
two records merge, or when it is cited from outside in a way that matters, such as by the consumers
of a published library.

A later choice between real options is its own record, linked from the earlier one. This replaces
the `refined by` pointer, and supersedes ADR-0009. The record carries no revision log: git holds
what it said when, and the record says what is true now.

Keeping immutability was rejected because every correction becomes a successor, and readers assemble
chains to learn what one decision is. Amending only where nothing would be misled was rejected
because it leaves reversals to supersession, when the citations a reversal would mislead can be
found and fixed. Rewriting freely was rejected because without the owner's agreement and the
citation fixes, a citation could come to mean anything.

### Consequences

- Good, because corrections and reversals land in the record a reader opens, and supersession chains
  exist only where a question split, merged, or is cited from outside.
- Good, because the `refined by` pointer, its status syntax and its checker rule go.
- Good, because a checker can find every citation and report any that names a record that does not
  exist, and a hook can reject the forms that are not canonical.
- Good, because `approval` makes a skipped agreement visible: an agent omitting the step has to
  leave the field empty or invent the owner's words.
- Bad, because a commit message citing a record may now describe what the record no longer says.
- Bad, because reading each citation is still a judgement, and the search finds nothing outside the
  repository.
- Bad, because the checker can verify that `approval` is present, not that the words are genuine.
- Neutral: decision records stop being `immutable`. The map's closed set of mutability values gains
  `amendable` - rewritten in place, each change agreed and accepted by the owner.
- Neutral: `SPECIFICATION.md` §3.1 and §2.7, the decision record template, the adoption record
  template, the `AGENTS.md` stanza, this repository's `AGENTS.md`, the checker and the hooks change
  to match, and the `PLAN.md` entry on append-only revisions is deleted.
- Neutral: the `refined by` pointers on ADR-0004, ADR-0007 and ADR-0014 become links, ADR-0008 and
  ADR-0016 gain links to this record, and ADR-0017's citation of `identigon/identigon`'s ADR-0036
  becomes a link to that record.
