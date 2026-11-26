---
status: "accepted"
date: 2026-11-26
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

In a Git repository the commit history is the past, and everything at the head describes the
present: a decision record states the current answer to its question, a research note the current
finding. Grammatical tense therefore separates almost nothing.

## Considered Options

- Organise by **subject** - a file per topic, per component, per concern
- Organise by **tense, mutability and audience** from closed sets, treating candidates sharing all
  three properties as a prompt to check
- Organise by **content, mutability and audience** from closed sets, where content is the kind of
  fact an artefact holds, treating candidates sharing all three as a prompt to check
- Impose no organising principle, and rely on review to keep files coherent

## Decision Outcome

Chosen option: **content, mutability and audience**, because those are the properties whose mixture
causes the rot, and organising by anything else leaves them free to mix.

Content names the kind of fact - behaviour, rationale, history, intent, a finding, vocabulary, a
procedure and so on - so two artefacts holding different facts differ in content by definition. The
sets are closed (`docs/spec.md` §2.7). Audience names one or more of five roles, each covering human
and agent readers unless the map says otherwise:

| Role          | Who                                                                               |
| ------------- | --------------------------------------------------------------------------------- |
| `owner`       | the one person who decides (ADR-0001)                                             |
| `contributor` | anyone changing the repository - agent sessions, and humans who are not the owner |
| `consumer`    | anyone building on what the repository publishes - a caller, a client, an adopter |
| `end-user`    | anyone using the running product without seeing the repository                    |
| `operator`    | anyone deploying, running or monitoring it                                        |

Every artefact the template map defines has a distinct triple, so the checker exempts no pair of
them. One structural case is exempt: the parts of one container, its entry point included, which the
growth rule (ADR-0014) splits from one artefact. Product and template rows are exempt by
`docs/spec.md` §2.8. Every other shared triple is reported as a warning.

Tense was rejected because it no longer separates artefacts: nearly every one is present, so the
test reduced to mutability and audience, and artefacts holding different facts collided often enough
to need a hand-kept list of exempt pairs. A sentence's tense remains a useful cue when filing - "we
chose X because Y" is rationale - but it is not a property of an artefact.

The test settles two commonly requested categories without new artefacts:

- **Technical debt is a type tag in the one ranked plan.** It shares the plan's content, mutability
  and audience, and a separate list would never be traded off against features.
- **Machine-readable contracts are members of the specification.** Schemas and interface definitions
  share its content, mutability and audience; being checked by a machine makes a contract a stronger
  specification, not a different category. The specification is a set, not a single file.

### Consequences

- Good, because filing becomes mechanical: the kind of fact usually settles it, and a sentence that
  resists is usually two sentences.
- Good, because debt and features compete in one ordered list. Filing changes a tag, not a location.
- Good, because a run on the template map's artefacts emits no shared-triple warning without any
  exemption list, so a new one stands out.
- Bad, because the content set must grow when a genuinely new kind of fact earns an artefact, and
  that is a change to the specification.
- Bad, because the duplicate test is a prompt, not a proof: a custom artefact given the wrong
  content value escapes it, and a person decides.
- Neutral: the three properties are a heuristic justified by what they prevent, not by an external
  standard.

## Confirmation

`tools/doc-kit-check.sh`
