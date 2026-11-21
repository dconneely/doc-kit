---
status: "accepted"
date: 2026-11-21
decision-makers: David Conneely
---

# 16. How much this repository's routing table says

## Context and Problem Statement

The template map's routing table was shortened from 395 words to 216: it lost its "If you are
asking..." column, its two plan rows and two quirks rows were each merged into one, and its longer
cells were shortened. Claude Haiku and Gemini 3.8 Flash placed facts and kept the rules as well with
it (research note 0006).

This repository's `DOC-MAP.md` has a routing table of the same shape, with rows of its own for
`ADOPTING.md`, `ADOPTING-NOTES.md` and `templates/`. The evals build from the templates, so none has
measured this repository's table. Dropping a column changes the map's structure, which is a decision
rather than a side effect.

## Considered Options

- Keep the table as it is
- Make the same cuts as the template: drop the asking column and shorten the longer cells
- Drop the table, leaving the artefacts table to route

## Decision Outcome

Chosen option: **make the same cuts as the template**, because the template is this map's source,
and the evidence that agents route as well without the column and the longer wording comes from the
template's table.

The rows this repository adds keep their destinations; only their wording is shortened. Dropping the
table was rejected: Haiku routed as well without the ten rows the evals cover, but no other model
has run without them.

### Consequences

- Good, because every session that reads this map reads about half the routing words.
- Good, because the map and its template keep the same shape.
- Bad, because a reader looking up a fact by the question they have, rather than filing one, loses
  the column written for them; no eval measures that reader.
- Neutral: the evidence is the template's, carried over to a table no eval exercises.

## Confirmation

`sh tools/doc-kit-check.sh map` passes, and the routing table has the template's columns.
