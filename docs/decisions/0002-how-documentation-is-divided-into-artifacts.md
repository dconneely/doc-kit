---
status: "proposed"
date: 2026-10-30
decision-makers: David Conneely
---

# 2. How documentation is divided into artifacts

## Context and Problem Statement

Documentation rots in a characteristic way. It is rarely that nobody writes anything; it is that one
file accumulates several jobs - part record of work done, part backlog, part assessment - until no
part of it can be trusted or pruned with confidence. Nobody can delete a line from it, because
deleting the stale half might delete the live half.

The temptation is to divide documentation by subject or by medium. Subjects overlap, and a fact
about a subject still has to be filed somewhere within it. Dividing by medium tempts teams to invent
separate categories for technical debt, machine-readable contracts (OpenAPI, schemas, migrations),
or audience variants, fragmenting the repository into unread lists.

Audience also needs rigour: if audience is free text, two documents escape duplication checks by
phrasing ("adopters" vs "consumers"), while a closed set must still distinguish artifacts that hold
different facts.

## Considered Options

- Organise by **subject** - a file per topic, per component, per concern
- Organise by **tense, mutability and audience** from closed sets, treating candidates sharing all
  three properties as a prompt to check
- Impose no organising principle, and rely on review to keep files coherent

## Decision Outcome

Chosen option: **tense, mutability and audience**, because those are the properties whose mixture
causes the rot, and organising by anything else leaves them free to mix.

Does it describe what is, what was, or what is intended? How does it change over its life? Who reads
it?

### Closed property sets and the duplicate test

Tense, mutability, and audience are drawn from closed sets (`docs/spec.md` §2.7). Audience names one
or more of five repository roles:

| Role          | Who                                                                               |
| ------------- | --------------------------------------------------------------------------------- |
| `owner`       | the one person who decides (ADR-0001)                                             |
| `contributor` | anyone changing the repository - agent sessions, and humans who are not the owner |
| `consumer`    | anyone building on what the repository publishes - a caller, a client, an adopter |
| `end-user`    | anyone using the running product without seeing the repository                    |
| `operator`    | anyone deploying, running or monitoring it                                        |

Each role covers human and agent readers by default. An artifact read by only one marks the
exception: `contributor (agents)`.

A candidate document sharing all three properties with an existing artifact is reported as a warning
to check, not an automatic failure: two artifacts sharing all three are merged unless they hold
different facts.

Because the closed sets are small, some artifacts the template map defines share a triple while
holding different facts. The checker exempts exactly these pairs, and a test fails if its list and
this table differ:

| Pair                                      | Why the facts differ                                                 |
| ----------------------------------------- | -------------------------------------------------------------------- |
| `DOC-MAP.md` and `docs/testing.md`        | the map says where each fact belongs; testing says what checks cover |
| `README.md` and `docs/glossary.md`        | the README orients a newcomer; the glossary defines the vocabulary   |
| `docs/quirks.md` and `docs/spec.md`       | the specification is the contract; quirks are deliberate deviations  |
| `docs/archive.md` and `docs/decisions.md` | one indexes undatable documents; the other indexes decision records  |

Two structural cases are exempt as well: an entry point and its parts (`docs/spec.md` and
`docs/spec/*`, say), and the parts of one container (two files in `docs/howto/`, say), because the
growth rule (ADR-0014) splits one artifact into them. Product and template rows are exempt by
`docs/spec.md` §2.8. Every other shared triple is reported.

The list is held here and in the checker, not in the map, so that changing it needs the owner's
permission and a release. A warning for every pair on every run was rejected because a warning that
never changes stops being read. An `Allowed overlaps` table in the map was rejected because an agent
could add a row to silence any warning. Reporting only triples that a change newly creates was
rejected because it never prompts a check of what is already there.

### Applications: technical debt and machine-readable contracts

This test resolves commonly requested categories without inventing new artifacts:

- **Technical debt belongs in the single ranked plan (`docs/plan.md`) as a type tag** alongside
  `bug`, `feature`, and `docs`. Debt shares its tense (future), mutability (ordered list, pruned on
  completion), and audience (`contributor`, `owner`) with the rest of the plan. A separate debt file
  or independently ranked section prevents the comparison that matters; with two lists, debt is
  never traded off against features, and the second list stops being read.
- **Machine-readable contracts are members of the specification (`docs/spec.md` or `docs/spec/`).**
  Schemas, OpenAPI/AsyncAPI documents, and interface definitions share the specification's tense
  (present), mutability (rewritten in place), and audience (`consumer`, `contributor`). Being
  checked by a machine makes a contract a stronger specification, not a different category. The
  specification is a set, not a single file, and its members may be prose or machine-readable.

Three things stay distinguished for machine-readable contracts:

1. **Source of truth** - the contract itself, versioned and reviewed like code.
2. **Generated views** - diagrams, rendered references, and client code, marked with a generated-by
   header and producing no diff on regeneration.
3. **Prose that cannot be derived** - rationale, invariants, units, ownership, and policy.

Prose may link to a machine-readable contract; it never restates one.

### Consequences

- Good, because filing becomes mechanical rather than a judgement call: the tense usually settles
  it, and a sentence that resists is usually two sentences.
- Good, because debt and features compete in one ordered list where trade-offs can actually be made.
  Filing changes a tag, not a location.
- Good, because schemas and prose live under one specification umbrella without duplicating facts.
- Good, because audience roles are uniform across maps and checkable by tooling.
- Good, because standard runs emit zero duplicate-property warnings, eliminating warning fatigue.
- Good, because new custom artifacts that overlap produce a high-contrast single warning.
- Good, because an `Allowed overlaps` table is omitted, avoiding map schema churn and agent misuse.
- Bad, because a new artifact the template map defines that shares a triple needs this record
  reopened before its pair stops warning.
- Bad, because custom artifacts that genuinely share a triple will always report an advisory
  warning.
- Bad, because the duplicate test is a prompt, not a proof: artifacts holding different facts can
  share all three properties, requiring human review to evaluate the warning.
- Bad, because the rule against restating a contract is expensive to hold in review.
- Neutral: the three properties are a heuristic justified by what they prevent, not by an external
  standard.

## Confirmation

`tools/doc-kit-check.sh`
