---
status: "proposed"
date: 2026-10-24
decision-makers: {who decided - required once the status is not "proposed"}
---

# 22. Amend an accepted record unless the change would mislead what cites it

## Context and Problem Statement

`SPECIFICATION.md` §3.1 makes an accepted record immutable except for its status, date and
decision-makers. Every other change needs a successor, however small. Two records already work
around that: ADR-0009 adds a `refined by` pointer, so that a revision need not supersede, and
ADR-0016 permits formatting-only edits. A `PLAN.md` entry proposes a third workaround, an
append-only revisions section.

MADR does not require immutability. Its `date` is "when the decision was last updated".

What immutability protects is a citation. A commit message, a code comment or another record that
says "ADR-0012" relies on the record meaning what it meant when cited. A typo fix, a link to a later
record, or a consequence discovered afterwards does not disturb that. Reversing the decision does.

Under ADR-0021 the owner is the only person who decides, so the question of who may change a record
has one answer. What the owner needs is a test for which kind of change it is.

## Considered Options

- Keep immutability, with the `refined by` pointer and the formatting exemption
- Amend an accepted record in place unless the change would mislead what cites it; supersede it
  otherwise
- Rewrite accepted records in place, like the specification

## Decision Outcome

Chosen option: **amend unless the change would mislead what cites it**, because that is the property
immutability was protecting, and it protects it without a successor for every correction.

The test: after the change, would anything citing the record (a commit, a comment, another record)
say something false or be misled? If not, amend it in place. If so, supersede it.

- **Amend:** a correction that keeps the meaning, a clarification, a consequence found later, a link
  to a related or later record, a `Confirmation` section, or formatting.
- **Supersede:** the chosen option changes or is reversed, the decision's scope changes so that a
  citation no longer holds, or the justification no longer holds.

A later choice between real options is its own record, even when it does not supersede. The earlier
record gains a link to it by amendment. This replaces the `refined by` pointer, and supersedes
ADR-0009.

**The owner changes an accepted record.** A change to its content or its status is made only on the
owner's explicit instruction, in the session making the change, naming the record. "Looks good", "go
ahead", or approval of other work is not that instruction. The owner's words are copied verbatim
into an `approval` front-matter field, and `date` becomes the date of the change. A formatting-only
change, which alters no word, needs no instruction (ADR-0016).

The record carries no revision log. Git holds what it said when, and the record says what is true
now.

Keeping immutability was rejected because every small correction becomes a successor, and readers
assemble chains to learn what one decision is. Rewriting freely was rejected because a citation
could then come to mean anything, and the record would become a part of the specification with a
past-tense heading.

### Consequences

- Good, because corrections land in the record a reader opens, and successors exist only for real
  reversals.
- Good, because the `refined by` pointer, its status syntax and its checker rule go.
- Good, because `approval` makes a skipped instruction visible: an agent omitting the step has to
  leave the field empty or invent the owner's words.
- Bad, because the test is a judgement, and an agent may judge a change in meaning minor. The owner
  makes the final call, because only the owner instructs the change.
- Bad, because what a record said when it was cited now needs `git show` at that commit.
- Bad, because the checker can verify that `approval` is present, not that the words are genuine,
  nor that an amendment passes the test.
- Neutral: decision records stop being `immutable`. The map's closed set of mutability values gains
  `amendable` - changed in place within its meaning, replaced when its meaning changes.
- Neutral: `SPECIFICATION.md` §3.1 and §2.7, the decision record template, the `AGENTS.md` stanza,
  this repository's `AGENTS.md` and the checker change to match, and the `PLAN.md` entry on
  append-only revisions is deleted.
- Neutral: the `refined by` pointers on ADR-0004, ADR-0007 and ADR-0014 become links, and ADR-0008
  and ADR-0016 gain links to this record - all amendments under this rule.
