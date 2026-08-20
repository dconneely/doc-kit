---
status: "proposed"
date: {YYYY-MM-DD, when the status last changed}
decision-makers: {who decided — required once the status is not "proposed"}
# consulted: {optional — whose opinion was sought}
# informed:  {optional — who is kept up to date}
---

# 0. Short title, imperative, naming the problem and the answer

<!--
Copy to NNNN-kebab-case-title.md, four-digit zero-padded, numbers unique and never reused.
The heading number matches the filename. Keep this file as 0000; it is the template.

This follows the MADR minimal template (https://adr.github.io/madr/). Status values, lowercase:

  proposed                 suggested, not yet decided — binds nothing
  rejected                 considered and turned down, kept so it is not re-proposed
  accepted                 decided and in effect
  deprecated               no longer applies, and nothing replaced it
  superseded by ADR-NNNN   replaced by a later record, which must exist

Immutability attaches to the STATUS, not to the commit. While it says proposed, edit it freely —
and merge it if the decision is still open, since a pending decision is more discoverable in the
tree than in a branch nobody is watching. Once it says accepted it is immutable: never edit it
except to change its status and date. Correcting a decision means writing its successor.

If a decision is still being argued, leave it proposed. Accepting early and then revising is the
common failure, and it destroys exactly the property the record exists for.

CHANGING THE STATUS IS A HUMAN ACTION. A tool may draft this file, argue it, and merge it as
proposed. Only a person moves it off proposed, and doing so asserts that a decision was really
made — which is what decision-makers records. Only accepted records bind anything.

Make that flip its own pull request. A separate commit is not enough — squash merging folds it back
into the commit that drafted the record, and the one moment worth seeing becomes invisible.

Write it when the decision is made, not later. A record reconstructed years afterwards is usually
an argument for what you already do, and it dilutes the ones written contemporaneously.

Delete this comment in the copy.
-->

## Context and Problem Statement

What forces were at play, and what made this decision non-obvious. What was known at the time —
and, more usefully, what was **not**. If nothing here would surprise a newcomer, this may not need
a record.

## Considered Options

* {option 1}
* {option 2}
* {option 3}

<!--
This section is what makes the file a decision rather than a statement. A record with only one
option to consider is usually a specification entry that has been misfiled.

Include the option you rejected even when it now looks obviously wrong — especially then. The next
person will think of it too, and the record is what stops them re-litigating it.
-->

## Decision Outcome

Chosen option: "{option}", because {justification in one sentence}.

Then, if needed, a paragraph on what the decision does *not* settle.

### Consequences

* Good, because {what becomes easier}.
* Bad, because {what becomes harder, or what is given up}.
* Neutral: {what changes without being better or worse}.

<!--
The honest ones are the useful ones. A record listing only benefits tells a future reader nothing
about whether the trade-off still holds — which is the question they came here to answer.
-->
