---
status: "accepted"
date: 2026-11-16
decision-makers: David Conneely
---

# 2. How documentation is divided into artefacts

## Context and Problem Statement

Documentation rots in a characteristic way. It is rarely that nobody writes anything; it is that one
file accumulates several jobs - part record of work done, part backlog, part assessment - until no
part of it can be trusted or pruned with confidence. Nobody can delete a line from it, because
deleting the stale half might delete the live half.

Dividing by subject or by medium does not prevent this. Subjects overlap, and a fact about a subject
still has to be filed somewhere within it. Dividing by medium invents separate categories for
technical debt, machine-readable contracts or audience variants, and fragments the repository into
unread lists. If audience is free text, two documents escape a duplication check on phrasing
("adopters" against "consumers").

## Considered Options

- Organise by **subject** - a file per topic, per component, per concern
- Organise by **tense, mutability and audience** from closed sets, treating candidates sharing all
  three properties as a prompt to check
- Impose no organising principle, and rely on review to keep files coherent

## Decision Outcome

Chosen option: **tense, mutability and audience**, because those are the properties whose mixture
causes the rot, and organising by anything else leaves them free to mix.

The sets are closed (`docs/spec.md` §2.7). Audience names one or more of five roles, each covering
human and agent readers unless the map says otherwise:

| Role          | Who                                                                               |
| ------------- | --------------------------------------------------------------------------------- |
| `owner`       | the one person who decides (ADR-0001)                                             |
| `contributor` | anyone changing the repository - agent sessions, and humans who are not the owner |
| `consumer`    | anyone building on what the repository publishes - a caller, a client, an adopter |
| `end-user`    | anyone using the running product without seeing the repository                    |
| `operator`    | anyone deploying, running or monitoring it                                        |

Because the sets are small, some artefacts the template map defines share a triple while holding
different facts. The checker exempts exactly these pairs, and a test fails if its list and this
table differ:

| Pair                                                    | Why the facts differ                                                 |
| ------------------------------------------------------- | -------------------------------------------------------------------- |
| `DOC-MAP.md` and `docs/testing.md`                      | the map says where each fact belongs; testing says what checks cover |
| `README.md` and `docs/glossary.md`                      | the README orients a newcomer; the glossary defines the vocabulary   |
| `docs/quirks.md` and `docs/spec.md`                     | the specification is the contract; quirks are deliberate deviations  |
| `docs/archive/README.md` and `docs/decisions/README.md` | one says what the archive holds; the other indexes decision records  |

Two structural cases are exempt as well, because the growth rule (ADR-0014) splits one artefact into
them: the parts of one container, its entry point included; and the parts of a container paired with
whatever its entry point is paired with. An entry point `docs/name/README.md` counts as the
`docs/name.md` it replaces. Product and template rows are exempt by `docs/spec.md` §2.8. Every other
shared triple is reported as a warning.

The list is held here and in the checker, not in the map, so that changing it needs the owner's
permission and a release. A warning for every pair on every run was rejected because a warning that
never changes stops being read. An `Allowed overlaps` table in the map was rejected because an agent
could add a row to silence any warning. Reporting only triples that a change newly creates was
rejected because it never prompts a check of what is already there.

The test settles two commonly requested categories without new artefacts:

- **Technical debt is a type tag in the one ranked plan.** It shares the plan's tense, mutability
  and audience, and a separate list would never be traded off against features.
- **Machine-readable contracts are members of the specification.** Schemas and interface definitions
  share its tense, mutability and audience; being checked by a machine makes a contract a stronger
  specification, not a different category. The specification is a set, not a single file.

### Consequences

- Good, because filing becomes mechanical: the tense usually settles it, and a sentence that resists
  is usually two sentences.
- Good, because debt and features compete in one ordered list. Filing changes a tag, not a location.
- Good, because a run on the template map's artefacts emits no shared-triple warning, so a new one
  stands out.
- Bad, because a new template-map artefact that shares a triple needs this record reopened before
  its pair stops warning.
- Bad, because the duplicate test is a prompt, not a proof: custom artefacts that genuinely hold
  different facts keep warning, and a person decides.
- Neutral: the three properties are a heuristic justified by what they prevent, not by an external
  standard.

## Confirmation

`tools/doc-kit-check.sh`
