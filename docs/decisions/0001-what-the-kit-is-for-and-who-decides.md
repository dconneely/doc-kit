---
status: "accepted"
date: 2026-10-28
decision-makers: David Conneely
approval: "Use review where unverified"
---

# 1. What the kit is for, and who decides

## Context and Problem Statement

A repository using this kit has one owner, who makes its decisions. Most of what is written in it -
code, documents, proposed records - comes from agent sessions, many of them, with no memory of each
other. Other people contribute occasionally, but do not decide anything.

The owner's attention is the scarce resource, not agreement between people. Two things go wrong:

- **The owner's purpose does not reach the agents.** What the project is for, what it excludes and
  what has been decided are scattered or unstated, so each session infers them again, differently.
- **Agent-written documentation accumulates as slop.** Each session adds text and none removes it.
  Unmaintained documents contradict each other and carry outdated assumptions and references, and a
  new session, which cannot tell current text from stale, trusts all of it.

## Considered Options

- Position the kit for a team of people who decide together, treating one owner as the smallest team
- Position it as one owner's way of directing many agents: the owner decides, every other
  contributor - human or agent - proposes
- Position it for one owner only, with no provision for other contributors

## Decision Outcome

Chosen option: **one owner directing many agents**, because it describes how the kit is used, and
names the two problems the structure exists to solve.

The kit's purpose is to communicate the owner's purpose to agent sessions clearly, and to stop the
documentation they write accumulating into contradictory, stale text that misleads the next session.
Its rules serve that purpose:

- **A new session can tell what binds.** Every document is current, or visibly marked as not
  binding: `proposed`, deprecated, planned or archived.
- **The owner's purpose has one home**, and only the owner changes it.
- **Text is written to be deleted.** Every artifact has a point at which its content is removed or
  replaced, and the structure says where that is.

The owner decides; everyone else proposes. A contributor may draft a decision record and revise it
while it is `proposed`; every change of status, and every deletion, needs the owner's explicit
permission (ADR-0007). Gates spend the owner's attention, so there are as few as possible: those
changes of status, and reviewing the inventory before a migration. Everything else proceeds without
asking.

The team positioning was rejected because its guidance - pull requests, squash merges, who to
consult - addresses a situation no user is in, and every agent session pays to read it. Excluding
other contributors was rejected because occasional outside contributions happen, and they fit the
rule unchanged: they propose, like an agent.

### Consequences

- Good, because the rule protecting decisions is simple: one person accepts every record, and
  nothing an agent writes binds until they do.
- Good, because every rule can be tested against one question: does it help a new session tell what
  the owner wants from what an earlier session wrote?
- Good, because accepted records change only when the owner changes their mind.
- Bad, because a team that adopts the kit gets no guidance on how its members agree.
- Bad, because nothing in the repository stops an agent session that runs with the owner's
  credentials from changing a status. The rule is held by instruction, not by mechanism.

## Confirmation

`review`
