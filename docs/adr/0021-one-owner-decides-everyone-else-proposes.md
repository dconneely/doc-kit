---
status: "proposed"
date: 2026-10-24
decision-makers: {who decided - required once the status is not "proposed"}
---

# 21. Position the kit as one owner's way of directing many agents

## Context and Problem Statement

The kit is written as if for a team of people who decide together: "use the gate you already have",
the pull request as the approval, a meeting or mailing list as alternatives, RACI fields below "a
certain team size", and community health files for when outside contributions begin. It also
presents itself mainly as a way to migrate an old repository's documentation.

Every repository using it is in a different situation. One person owns it and makes its decisions.
Most of the writing - code, documents, proposed records - comes from agent sessions, many of them,
with no memory of each other. Other people contribute occasionally, but do not decide anything.

In that situation the scarce resource is the owner's attention, not agreement between people. Two
things go wrong:

- **The owner's purpose does not reach the agents.** What the project is for, what it excludes, and
  what has been decided are scattered or unstated, so each session infers them again, differently.
- **Agent-written documentation accumulates as slop.** Each session adds text and none removes it.
  Unmaintained documents contradict each other and carry outdated assumptions and references, and a
  new session, which has no way to tell current text from stale, trusts all of it.

## Considered Options

- Keep the team positioning, and treat one owner as the smallest team
- Position the kit as one owner's way of directing many agents: the owner decides, every other
  contributor - human or agent - proposes
- Position it for one owner only, with no provision for other contributors

## Decision Outcome

Chosen option: **one owner directing many agents**, because it describes how the kit is actually
used, and names the two problems the structure exists to solve.

The kit's purpose is to communicate the owner's purpose to agent sessions clearly, and to stop the
documentation they write accumulating into contradictory, stale text that misleads the next session.
Its rules serve that purpose:

- **A new session can tell what binds.** Every document is current, or visibly marked as not
  binding: `proposed`, superseded, planned or archived.
- **The owner's purpose has one home**, and only the owner changes it.
- **Text is written to be deleted.** Every artifact has a point at which its content is removed or
  replaced, and the structure says where that is.

The owner decides; everyone else proposes:

- `docs/decisions/` is where the owner records decisions about the project. A contributor - human or
  agent - creates, changes, deletes or obsoletes a record only with the owner's explicit agreement,
  asked for first.
- `proposed` exists so that an agent can put a decision in front of the owner before it is decided.
  It no longer marks a record waiting for several people to meet and agree. `accepted` records that
  the owner decided it; `decision-makers` names the owner, and is how a reader tells that a person,
  not an agent session, made the decision.
- Gates spend the owner's attention, so there are as few as possible: agreeing to a record or a
  change to one, accepting it, and reviewing the Step 4 inventory. Everything else proceeds without
  asking.

Migrating an existing repository stays in the procedure, as the way to clean up documentation that
has already accumulated. It is no longer the kit's main purpose.

Keeping the team positioning was rejected because its guidance - pull requests, squash merges, who
to consult - addresses a situation no user is in, and costs every agent session the context to read
it. Excluding other contributors was rejected because occasional outside contributions do happen,
and they fit the rule unchanged: they propose, like an agent.

This refines ADR-0008: a status change is still a human action, and the human is the owner.

### Consequences

- Good, because the rule protecting decisions becomes simple: one person agrees to every record and
  accepts it, and nothing an agent writes binds until they do.
- Good, because every rule can be tested against one question: does it help a new session tell what
  the owner wants from what an earlier session wrote?
- Good, because guidance about pull requests, consultation and team size can leave the specification
  and templates, which shortens what every agent session reads.
- Good, because it bounds the churn of accepted records: they change only when the owner changes
  their mind.
- Bad, because a team that adopts the kit gets less guidance than it does today.
- Bad, because nothing in the repository stops an agent session that runs with the owner's
  credentials from changing a status. Detecting it, from history, becomes the checker's job.
- Neutral: `README.md`, the specification's purpose and scope, `ADOPTING.md` Step 0 and the decision
  record template change to match. The change to the specification's purpose is this record.
