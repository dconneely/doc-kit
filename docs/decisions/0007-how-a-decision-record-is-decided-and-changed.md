---
status: "accepted"
date: 2026-10-25
decision-makers: David Conneely
approval: "yes"
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
is read as settled. Drafting and deciding were once the same act; with agents they are not.

A record must also stay true. What it protects is a citation: a commit message, a code comment or
another record that says ADR-NNNN relies on the record meaning what it meant. A citation inside the
repository can be found and fixed, provided every citation uses one exact form. One in another
repository cannot.

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

### Template structure and front matter

Records follow the MADR minimal template copied from `templates/docs/decisions/0000-template.md`:

- **Front matter** carries `status`, `date`, `decision-makers`, and `approval`. The status takes
  MADR's lowercase values: `proposed`, `accepted`, `rejected`, and `deprecated`. `consulted` and
  `informed` are permitted, not required.
- **Headings** keep their `NNNN.` numbers (`# NNNN. Question`), which `adr-tools` uses and MADR
  permits.
- **Sections** require `## Context and Problem Statement`, `## Considered Options`,
  `## Decision Outcome`, `### Consequences`, and optionally `## Confirmation`.

The full MADR template was rejected as padding: Pros and Cons tables and Decision Drivers earn their
place when weighing multiple complex options, whereas most records here evaluate one real
alternative. Nygard's format was rejected because its section names stay non-standard and lack
machine-readable front matter.

### Lifecycle and authority

An agent may create a record as `proposed`, copied from the template rather than from an existing
record, and may revise a `proposed` record. The owner's explicit permission, asked for first, is
needed to accept a record, reject one, reopen an accepted one to change it, deprecate one, or delete
one.

Only `accepted` binds; `proposed` exists so an agent can put a decision in front of the owner before
it is decided. The owner's words are recorded verbatim in `approval`, and `decision-makers` names
the owner (ADR-0001).

### In-place amendment and citations

A record is the current answer to one question. Changing an accepted record takes two permissions:
reopening it, and accepting the change. If the owner rejects the change, the last accepted version
is restored. A record is normally accepted before it is committed, so git history holds its accepted
versions without needing an internal revision log. When a question splits, merges, or no longer
applies, the record is deprecated or deleted, and links to whatever replaces it.

Citations take one exact form, `ADR-NNNN`. A bare ID names a record in this repository; another
repository's record is cited by a full link. A change, deletion included, fixes in the same commit
every citation it makes untrue. Commit messages are history and are left alone. Formatting applied
by a tool, which alters no word, is not a change.

Immutability was rejected because every correction became a successor, forcing readers to assemble
chains of records to discover the settled decision. Rewriting freely was rejected because citations
could drift into meaning anything.

### Consequences

- Good, because tools expecting MADR can parse these records.
- Good, because `Considered Options` forces alternatives into the open, distinguishing a decision
  from a specification statement.
- Good, because an over-productive agent can generate drafts, but not unearned authority.
- Good, because corrections land in the record a reader opens, without supersession chains.
- Good, because a checker can find every citation and report broken or malformed references.
- Bad, because front matter is machinery the structure otherwise avoids, and `approval` is a custom
  field MADR does not define.
- Bad, because the authority gate is held by instruction: an agent could omit it or invent words.
- Bad, because a commit message citing a record may describe what the record no longer says.

## Confirmation

`tools/doc-kit-check.sh` and `prek run lowercase-adr-status`
