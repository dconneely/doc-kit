---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 10. Adopt the MADR minimal template

## Context and Problem Statement

This kit's records used Nygard's original four sections — Status, Context, Decision, Consequences —
and the adoption guide tells adopters that ADRs are one of only two genuine standards here, whose
value is largely that other people and tools already recognise them. Checking that claim showed the
kit was not following the convention it cited: MADR carries YAML front-matter, names its sections
differently, and makes rejected alternatives structural rather than leaving them in prose. The
sources are in [`docs/research/0001-adr-conventions.md`](../research/0001-adr-conventions.md).

Two gaps mattered beyond naming. MADR defines a `rejected` status this kit omitted. And
`decision-makers` records *who* decided — the thing ADR-0008 wants and currently leaves to review.

## Considered Options

* Keep Nygard's sections, add MADR front-matter only
* Adopt the MADR **minimal** template — front-matter, Context and Problem Statement, Considered
  Options, Decision Outcome, Consequences
* Adopt the full MADR template, including Decision Drivers, Confirmation, and Pros and Cons of the
  Options

## Decision Outcome

Chosen option: **the MADR minimal template**, because it is an official MADR template rather than a
compromise between two conventions, and because making Considered Options structural is what
distinguishes a decision record from a specification statement.

The full template was rejected as padding: Pros-and-Cons tables and Decision Drivers earn their
place when a decision weighs several serious contenders, and most records here had one real
alternative. Front-matter alone was rejected because it would leave the section names
non-standard — the half-measure that made the original claim inaccurate.

Records keep their `NNNN.` heading numbers, which `adr-tools` uses and MADR does not forbid. Status
values take MADR's lowercase spelling.

### Consequences

* Good, because the claim that this kit follows a recognised convention becomes true, and tools
  expecting MADR can read these records.
* Good, because `Considered Options` forces the alternatives into the open, where several existing
  records had left them implicit.
* Good, because `decision-makers` gives ADR-0008 a stronger signal than commit authorship, and one
  whose presence a checker can verify.
* Bad, because nine existing records must be rewritten, and rewriting them is only defensible while
  the repository is unpublished — see `SPECIFICATION.md` §3.1.
* Bad, because front-matter is machinery this structure had otherwise avoided, and `consulted` and
  `informed` are overhead on a small project. They are permitted but not required.
* Neutral: the change is invisible to adopters who have not yet copied the template, and there are
  none.
