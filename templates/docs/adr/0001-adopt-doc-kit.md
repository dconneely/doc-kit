---
status: "proposed"
date: {YYYY-MM-DD, when the status last changed}
decision-makers: {who decided - required once the status is not "proposed"}
---

# 1. Adopt doc-kit's documentation structure

<!--
Renumber to the next free number if this repository already has records, and update the path in
DOC-MAP.md to match. Leave the status "proposed": a person accepts it.

Fill in the Context, the justification and the deviations. The consequences say what the structure's
rules prevent; delete any whose rule you did not adopt, and add one for each deviation.

Delete this comment in the copy.
-->

## Context and Problem Statement

{What is wrong with this repository's documentation today, and who it affects.}

The structure comes from doc-kit at commit {commit}:
`https://github.com/dconneely/doc-kit/tree/{commit}`. The kit's decision records give the reasons
for each rule; this record cites them as "kit ADR-NNNN".

## Considered Options

- Adopt doc-kit's structure
- Keep everything in one `README.md` or `AGENTS.md`
- Keep the current documentation as it is

## Decision Outcome

Chosen option: "Adopt doc-kit's structure", because {justification in one sentence}.

Deviations from the kit: {each deviation and its reason, or "none"}.

### Consequences

- Good, because each fact has one home, and `DOC-MAP.md` says which (kit ADR-0001).
- Good, because completed plan entries are deleted, so the plan stays a list of open work.
- Good, because the changelog lists only effects users can see, so it does not become a commit log.
- Good, because accepted records are never edited, so each stays faithful to what was known when it
  was made.
- Good, because the specification states current behaviour, not how it came to be.
- Good, because research notes state the current finding and its confidence, not how it was reached,
  and findings with sources are not lost in commit messages and comments.
- Good, because prose links to machine-readable contracts rather than restating them (kit ADR-0003).
- Good, because text, code comments included, states what is true rather than recounting its history
  (kit ADR-0019).
- Bad, because the map must name every documentation file, and someone has to keep it so.
- Bad, because migrating existing documentation proceeds one document at a time, with no end date.
