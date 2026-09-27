# What the ADR conventions actually specify

**Confidence:** high

Verified directly against the MADR repository on 2026-08-20. Prompted by the kit claiming to follow
"a recognised convention" while using section names none of the conventions use. Y-statements were
checked on 2026-09-27, prompted by an adopter pointing at them as a leaner alternative.

## Finding

MADR ships **two** templates, not one, and its status vocabulary is **deliberately open-ended**.

The full template's headings are: Context and Problem Statement, Decision Drivers (optional),
Considered Options, Decision Outcome, Consequences (optional), Confirmation (optional), Pros and
Cons of the Options, More Information (optional).

The minimal template's are: Context and Problem Statement, Considered Options, Decision Outcome,
Consequences (optional).

Both carry YAML front-matter, all of it optional:

```yaml
status: "{proposed | rejected | accepted | deprecated | ... | superseded by ADR-0123}"
date: {YYYY-MM-DD when the decision was last updated}
decision-makers: {list everyone involved in the decision}
consulted: {list everyone whose opinions are sought}
informed: {list everyone who is kept up-to-date on progress}
```

Three things matter and were not obvious:

- **The ellipsis is in the template.** The permitted status set is explicitly not closed, so
  extending it - as ADR-0009 does with `accepted (refined by ADR-NNNN)` - is sanctioned by the
  convention rather than a deviation from it.
- **`rejected` is standard.** This kit had omitted it.
- **`decision-makers`, `consulted` and `informed` are RACI fields.** `decision-makers` records who
  decided, which is the signal ADR-0008 wanted and had to leave to review.

### Y-statements - the same record, compressed to a sentence

A Y-statement is a one-sentence decision record, from Zimmermann, Capilla, Tran and Zdun. The ADR
organisation gives a short form:

> In the context of `<use case/user story>`, facing `<concern>` we decided for `<option>` to achieve
> `<quality>`, accepting `<downside>`.

and a long form:

> In the context of `<use case/user story>`, facing `<concern>`, we decided for `<option>` and
> neglected `<other options>`, to achieve `<system qualities/desired consequences>`, accepting
> `<downside/undesired consequences>`, because `<additional rationale>`.

It is MADR's ancestor, not a rival: MADR 1.3.0 (2018-01-30) "Changed template to be closer to the
Y-Statements", and the long form maps clause for clause onto the minimal template. _Context_ and
_facing_ are Context and Problem Statement; _decided for_ and _neglected_ are Considered Options and
Decision Outcome; _to achieve_ and _accepting_ are the Good and Bad consequences; _because_ is the
justification in "Chosen option: X, because Y". A record in either form says the same things.

What differs is where it lives and whether it changes:

- **Its authors pitch it at people who already have the context.** The InfoQ article says architects
  "prefer using lean documentation rather than elaborate, large decision templates", and concedes
  that people new to a project "typically prefer to read the full-blown templates".
- **Its best-known current use puts it in source comments.** Helsing's `yadr` lints and extracts a
  modified long form written as a dated comment beside the code it governs, trading discoverability
  from the code ("more likely that they are seen, read, and updated") for discoverability from
  outside ("harder to spot").
- **That use is mutable.** `yadr` records carry an optional changelog and are meant to be revised in
  place, where this kit's records are immutable once accepted and are corrected by a successor. By
  the three-property test that makes an in-code Y-statement a different artifact from an ADR, not a
  shorter spelling of one.

ADR-0010 did not consider Y-statements as an option. Nothing found here argues it should have chosen
them: the minimal template already carries every clause.

## Evidence

- [`template/adr-template.md`][full] - full template, fetched 2026-08-20.
- [`template/adr-template-minimal.md`][minimal] - minimal template, same date.
- [adr.github.io/madr](https://adr.github.io/madr/) - project page, consistent with both.
- [ADR templates post][ystmt] on adr.github.io - both Y-statement forms, read directly 2026-09-27.
- [MADR `CHANGELOG.md`][madr-log] - the 1.3.0 entry, same date.
- [Sustainable Architectural Design Decisions][infoq] - Zimmermann, Capilla, Tran, Zdun, InfoQ,
  2014-03-09; the original template and the two quotations above.
- [`helsing-ai/yadr`][yadr] README - the in-code form and its trade-off, same date.

[full]: https://raw.githubusercontent.com/adr/madr/main/template/adr-template.md
[minimal]: https://raw.githubusercontent.com/adr/madr/main/template/adr-template-minimal.md
[ystmt]: https://github.com/adr/adr.github.io/blob/main/_posts/2024-10-25-adr-templates.md
[madr-log]: https://github.com/adr/madr/blob/main/CHANGELOG.md
[infoq]: https://www.infoq.com/articles/sustainable-architectural-design-decisions/
[yadr]: https://github.com/helsing-ai/yadr

Zimmermann's own Medium post, which `yadr` cites, could not be read; the forms above come from the
ADR organisation and InfoQ instead, and agree with `yadr`'s quotation of the long form.

Sources agree; nothing needed reconciling. Confidence is `high` because the templates were read
directly rather than described by a third party.

## Dead ends

Recalling the schema from memory produced a plausible but wrong answer: it missed `rejected`
entirely, missed that two templates exist, and would have led to adopting the full template's
Pros-and-Cons structure as though it were the only option. The lesson generalises to every other
convention this kit cites - see "Open questions".

## Open questions

Closed by [`0002-conventions-this-kit-cites.md`](0002-conventions-this-kit-cites.md): Nygard's
original post, `adr-tools` numbering, and Keep a Changelog's categories were all checked and all
proved accurate. Nygard's statuses turned out to be lowercase in the original, which supports
ADR-0010 on a ground it had not claimed.

- Whether MADR's front-matter should be adopted beyond `status`, `date` and `decision-makers`
  remains open; `consulted` and `informed` were judged overhead for a small project rather than
  wrong.
- Whether the map should route anything to code comments - an in-code Y-statement included - is
  open. `SPECIFICATION.md` currently puts comments out of scope.
