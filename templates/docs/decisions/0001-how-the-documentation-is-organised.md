---
status: "proposed"
date: {YYYY-MM-DD, of the latest change of status or content}
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 1. How the documentation is organised

<!--
Renumber to the next free number if this repository already has records, and update the path in
DOC-MAP.md to match. Leave the status "proposed": the owner accepts it, following the checklist in
0000-template.md.

Fill in the Context, the justification and the deviations. The consequences say what the structure's
rules prevent; delete any whose rule you did not adopt, and add one for each deviation.

Delete this comment in the copy.
-->

## Context and Problem Statement

{What is wrong with this repository's documentation today, and who it affects.}

The structure comes from doc-kit at commit {commit}. Its decision records, which give the reasons
for each rule, are at `https://github.com/dconneely/doc-kit/tree/{commit}/docs/decisions`.

## Considered Options

- Adopt doc-kit's structure
- Keep everything in one `README.md` or `AGENTS.md`
- Keep the current documentation as it is

## Decision Outcome

Chosen option: "Adopt doc-kit's structure", because {justification in one sentence}.

Deviations from the kit: {each deviation and its reason, or "none"}.

### Consequences

- Good, because each fact has one home, and `DOC-MAP.md` says which.
- Good, because completed plan entries are deleted, so the plan stays a list of open work.
- Good, because the changelog lists only effects users can see, so it does not become a commit log.
- Good, because only the owner accepts or changes a decision record, so nothing an agent session
  writes binds until the owner says so, and each record stays the current answer to its question.
- Good, because the specification states current behaviour, not how it came to be.
- Good, because research notes state the current finding and its confidence, not how it was reached,
  and findings with sources are not lost in commit messages and comments.
- Good, because prose links to machine-readable contracts rather than restating them.
- Good, because text, code comments included, states what is true rather than recounting its
  history.
- Bad, because the map must name every documentation file, and someone has to keep it so.
- Bad, because migrating existing documentation proceeds one document at a time, with no end date.
