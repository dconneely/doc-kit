---
status: "proposed"
# proposed | rejected | accepted | deprecated | superseded by ADR-NNNN
date: {YYYY-MM-DD, of the latest change of status or content}
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 0. The question this record answers

<!--
Copy to NNNN-kebab-case-title.md, four-digit zero-padded, unique and never reused. The heading
number matches the filename, and the title names the question, not the answer, so that a changed
answer leaves it true. Keep this file as 0000; it is the template, and the rules for every record
live here.

Follows the MADR minimal template (https://adr.github.io/madr/).

Rules:

- Only `accepted` binds. A `proposed` record is a suggestion: commit it undecided, and iterate on it
  freely until the owner decides.
- An accepted record is the current answer to its question. Amend it in place, even to reverse it;
  supersede it only when its question splits, merges with another, or is cited from outside the
  repository. A later choice between real options is its own record, linked from this one.
- Cite records as ADR-NNNN. Another repository's record is cited by a link.

Change a status, or an accepted record's content, only when all of these hold:

- [ ] The owner asked, in this session, for this record - by number - to take this status or this
      change. "Looks good", "go ahead", or approval of other work is not that.
- [ ] Their words are copied verbatim into `approval`, `decision-makers` names them, and `date` is
      today.
- [ ] Every citation of this record that the change makes untrue is fixed in the same commit.
      Search for its ID; leave commit messages alone.

A formatting-only change, which alters no word, needs none of this.

Write it when the decision is made, not later. A record reconstructed years afterwards is usually an
argument for what you already do, and it dilutes the ones written contemporaneously.

Delete this comment, and every other HTML comment in this template, in the copy: they are
guidance for the author, not part of the record.
-->

## Context and Problem Statement

What forces were at play, and what made this decision non-obvious. What was known at the time - and,
more usefully, what was **not**. If nothing here would surprise a newcomer, this may not need a
record.

## Considered Options

- {option 1}
- {option 2}
- {option 3}

<!--
This section is what makes the file a decision rather than a statement. A record with only one
option to consider is usually a specification entry that has been misfiled.

Include the option you rejected even when it now looks obviously wrong - especially then. The next
person will think of it too, and this is what stops them re-litigating it.

Delete this comment in the copy.
-->

## Decision Outcome

Chosen option: "{option}", because {justification in one sentence}.

Then, if needed, a paragraph on what the decision does _not_ settle.

### Consequences

- Good, because {what becomes easier}.
- Bad, because {what becomes harder, or what is given up}.
- Neutral: {what changes without being better or worse}.

<!--
The honest ones are the useful ones. A record listing only benefits tells a future reader nothing
about whether the trade-off still holds - which is the question they came here to answer.

Delete this comment in the copy.
-->
