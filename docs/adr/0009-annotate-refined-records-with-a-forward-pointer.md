---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 9. Annotate refined records with a forward pointer

## Context and Problem Statement

One status carries a forward pointer, `superseded by ADR-NNNN`, which is what lets a reader arriving
at an obsolete record find its replacement.

A third relationship between records has no pointer: **refinement**, where a decision stands but a
later record revises something that follows from it. A reader of the earlier record cannot tell that
a later one bears on it. ADR-0006 refines ADR-0004 in exactly this way.

MADR's status field carries an explicit ellipsis - the permitted set is **deliberately open**, so
extending it is sanctioned rather than deviant. Checked against the template rather than recalled;
see [`docs/research/0001-adr-conventions.md`](../research/0001-adr-conventions.md).

## Considered Options

- Supersede the earlier record
- Edit the earlier record to add a note
- Add a fifth status _value_ for refined records
- Rename `superseded` to `obsolete`, making the pointer an optional annotation on every status
- Allow an optional parenthesised annotation on an existing status value

## Decision Outcome

Chosen option: **an optional parenthesised annotation**, so that a status is a base value plus an
optional modifier rather than a longer list of values:

```text
accepted (refined by ADR-0006)
```

It means: this decision stands, and a later record has revised something that follows from it. It is
set on the earlier record when the later one is accepted. Being a status change, it is a human
action under ADR-0008, and is permitted on an accepted record because the immutability rule allows
status changes and nothing else.

**Refinement must not change the decision.** If the _Decision Outcome_ stopped being true, that is
supersession and the heavier form is correct. The annotation is not a way to avoid writing a
successor.

Superseding was rejected as overstating - it says the decision was replaced when it was not. Editing
the earlier record is forbidden by the immutability rule. A fifth status _value_ was rejected
because growing the vocabulary is what this structure resists; the annotation framing avoids that
entirely. Renaming `superseded` to `obsolete` would make pointers uniformly optional and read more
consistently, but it renames a term Nygard, MADR and `adr-tools` all share, and the case it would
serve - a record that no longer applies with nothing replacing it - is already `deprecated`.

### Consequences

- Good, because a reader arriving at any record can tell whether it is the last word on its subject,
  which was previously true only for superseded ones.
- Good, because the base vocabulary is unchanged: a tool that understands the five statuses still
  understands these, seeing a known value with trailing text rather than an unknown value.
- Bad, because the distinction between refining and superseding is a judgement call and will
  sometimes be got wrong. The test is narrow enough to apply honestly: did the _Decision Outcome_
  stop being true?
- Neutral: a checker gains an optional suffix to parse and a second forward reference to resolve.
- Neutral: if accepted, `SPECIFICATION.md` §3.1 gains the form, the template documents it, and
  ADR-0004's status becomes `accepted (refined by ADR-0006)`.
