---
status: "accepted"
date: 2026-11-16
decision-makers: David Conneely
---

# 7. How a decision record is decided and changed

## Context and Problem Statement

Decision records are one of only two external conventions this kit follows, and their value is
largely that other people and tools already recognise them. That holds only if records follow a
recognised convention exactly. Nygard's original format has four sections and no front matter; MADR
carries YAML front matter, names its sections differently, and makes rejected alternatives a
dedicated section. The sources are in
[`docs/research/0001-adr-conventions.md`](../research/0001-adr-conventions.md).

Agents draft decision records readily, with Context and Consequences sections indistinguishable in
form from deliberated ones, and they can produce twenty in an afternoon. `AGENTS.md` and the map
send every session to the records for the reasoning behind constraints, so a record nobody decided
is read as settled.

A record must also stay true. A commit message, a code comment or another record that cites ADR-NNNN
relies on the record meaning what it meant. A citation inside the repository can be found and fixed,
provided every citation uses one exact form. One in another repository cannot.

## Considered Options

- Nygard's four sections with no front matter, left to review with no stated rule
- The full MADR template (including Decision Drivers and Pros/Cons tables), with accepted records
  kept immutable and revised only by successor records
- The MADR minimal template with YAML front matter; agents draft `proposed` records freely; the
  owner decides every status change; accepted records are amended in place with citations fixed in
  the same commit

## Decision Outcome

Chosen option: **the MADR minimal template with front matter, where agents draft, the owner decides
every change of status, and accepted records are amended in place**. This separates writing from
deciding, aligns with recognised tooling, and avoids successor chains for every change of mind.

The rules are in `docs/spec.md` §3.1 and the record template. The choices within them:

- **MADR's own front matter and lowercase status values**, with no field MADR does not define, and
  numbered headings (`# NNNN. Question`), which `adr-tools` uses and MADR permits.
- **`decision-makers` and the commit that changes a status are the record of the owner's decision.**
  Copying the owner's words into a custom `approval` field was rejected: an agent that would skip
  asking could write any words there, and the words without the question did not show what was
  approved.
- **One citation form, `ADR-NNNN`**, so that every citation a change makes untrue can be found and
  fixed in the same commit.

The full MADR template was rejected as padding: Pros and Cons tables and Decision Drivers earn their
place when weighing several complex options, whereas most records here evaluate one real
alternative. Nygard's format was rejected because its section names are not MADR's and it has no
machine-readable front matter. Immutability was rejected because every correction became a
successor, forcing readers to assemble chains of records to find the settled decision. Rewriting
freely was rejected because citations could drift into meaning anything.

### Consequences

- Good, because tools expecting MADR can parse these records.
- Good, because `Considered Options` forces alternatives into the open, distinguishing a decision
  from a specification statement.
- Good, because an over-productive agent can generate drafts, but not unearned authority.
- Good, because corrections land in the record a reader opens, without supersession chains.
- Good, because a checker can find every citation and report broken or malformed references.
- Bad, because front matter is machinery the structure otherwise avoids.
- Bad, because the authority gate is held by instruction: an agent could change a status without
  asking, and the record would not show it.
- Bad, because a commit message citing a record may describe what the record no longer says.

## Confirmation

`tools/doc-kit-check.sh` and `prek run lowercase-adr-status`
