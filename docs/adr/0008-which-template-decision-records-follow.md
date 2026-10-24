---
status: "accepted"
date: 2026-10-24
decision-makers: David Conneely
approval: 'Yes (asked: "Do you accept ADR-0001 to ADR-0013?")'
---

# 8. Which template decision records follow

## Context and Problem Statement

Decision records are one of only two genuine standards this kit follows, and their value is largely
that other people and tools already recognise them. That holds only if the records follow a
recognised convention exactly. Nygard's original format has four sections and no front matter; MADR
carries YAML front matter, names its sections differently, and makes the rejected alternatives a
section of their own. The sources are in
[`docs/research/0001-adr-conventions.md`](../research/0001-adr-conventions.md).

## Considered Options

- Nygard's four sections, with MADR front matter added
- The MADR minimal template - Context and Problem Statement, Considered Options, Decision Outcome,
  Consequences - with front matter
- The full MADR template, including Decision Drivers, Confirmation, and Pros and Cons of the Options

## Decision Outcome

Chosen option: **the MADR minimal template, with front matter**, because it is an official MADR
template rather than a blend of two conventions, and because making `Considered Options` a section
is what distinguishes a decision record from a statement in the specification.

Front matter carries `status`, `date` and, once the owner has decided, `decision-makers` and
`approval` (ADR-0007). `status` takes MADR's values, in MADR's lowercase spelling. `consulted` and
`informed` are permitted, not required. Headings keep their `NNNN.` numbers, which `adr-tools` uses
and MADR does not forbid.

The full template was rejected as padding: Pros and Cons tables and Decision Drivers earn their
place when a decision weighs several serious contenders, and most records here have one real
alternative. Nygard's sections with front matter were rejected because the section names would stay
non-standard.

### Consequences

- Good, because tools expecting MADR can read these records.
- Good, because `Considered Options` forces the alternatives into the open.
- Bad, because front matter is machinery the structure otherwise avoids, and `approval` is a field
  MADR does not define.
