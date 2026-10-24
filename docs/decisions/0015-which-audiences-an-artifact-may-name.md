---
status: "accepted"
date: 2026-10-24
decision-makers: David Conneely
approval: 'Yes to all of these (asked: "Do you accept ADR-0014 as drafted? And for ADR-0015: do you accept it, and may I reopen ADR-0002 to match it?")'
---

# 15. Which audiences an artifact may name

## Context and Problem Statement

Tense and mutability are closed sets; audience is free text (`docs/spec.md` §2.7). Free text lets
two maps - or two rows of one map - describe the same reader differently: "adopters", "consumers",
"anyone relying on a cited convention". It also lets a row escape the test that two artifacts
sharing all three properties are one, by phrasing.

The kit is for one owner directing many agent sessions (ADR-0001), so whether a reader is human or
agent rarely separates two documents: both read the same English. It does separate a few, such as
`AGENTS.md` from the map.

Closing the set has a cost that free text hides. Applied to this repository's map with the roles
below, the specification and the checker share all three properties - `present`,
`rewritten in place`, `consumer` and `contributor` - though they hold different facts. The test as
written would merge them, and more such pairs follow as a map grows.

## Considered Options

- Keep audience free text
- A closed set of roles, with human and agent readers assumed and an exception marked
- A closed set across several dimensions - human or agent, author or consumer, technical or not

## Decision Outcome

Chosen option: **a closed set of roles**. An artifact's audience names one or more of them:

| Role          | Who                                                                               |
| ------------- | --------------------------------------------------------------------------------- |
| `owner`       | the one person who decides (ADR-0001)                                             |
| `contributor` | anyone changing the repository - agent sessions, and humans who are not the owner |
| `consumer`    | anyone building on what the repository publishes - a caller, a client, an adopter |
| `end-user`    | anyone using the running product without seeing the repository                    |
| `operator`    | anyone deploying, running or monitoring it                                        |

A role covers human and agent readers both. An artifact read by only one says so after the role:
`contributor (agents)`.

Sharing all three properties becomes a warning to check, not a failure: two artifacts that share
them are reported, and are merged unless they hold different facts. That changes ADR-0002, which
says such a candidate "is a section or a tag within that artifact"; accepting this record needs
ADR-0002 reopened and amended to match.

Free text was rejected because it cannot be checked and lets near-duplicates escape on phrasing.
Several dimensions were rejected because most combinations never occur, and the one that matters
here - human or agent - is an exception, not a dimension.

### Consequences

- Good, because the checker can verify audience as it does tense and mutability.
- Good, because two maps describe the same reader the same way.
- Bad, because the duplicate test is weaker: a warning can be dismissed, where a failure could not.
- Bad, because five roles are coarse. "Adopters who are stuck or deciding" becomes `consumer`, and
  the moment of reading moves to the purpose column.
- Neutral: the roles name relationships to the repository, not people. The owner is also a
  contributor and a consumer; an artifact names the role it is written for.
