# What the ADR conventions actually specify

**Confidence: high**

Verified directly against the MADR repository on 2026-08-20. Prompted by the kit claiming to follow
"a recognised convention" while using section names none of the conventions use.

## Finding

MADR ships **two** templates, not one, and its status vocabulary is **deliberately open-ended**.

The full template's headings are: Context and Problem Statement, Decision Drivers (optional),
Considered Options, Decision Outcome, Consequences (optional), Confirmation (optional), Pros and
Cons of the Options, More Information (optional).

The minimal template's are: Context and Problem Statement, Considered Options, Decision Outcome,
Consequences (optional).

Both carry YAML front-matter, all of it optional:

```yaml
status: "{proposed | rejected | accepted | deprecated | … | superseded by ADR-0123}"
date: {YYYY-MM-DD when the decision was last updated}
decision-makers: {list everyone involved in the decision}
consulted: {list everyone whose opinions are sought}
informed: {list everyone who is kept up-to-date on progress}
```

Three things matter and were not obvious:

- **The ellipsis is in the template.** The permitted status set is explicitly not closed, so
  extending it — as ADR-0009 does with `accepted (refined by ADR-NNNN)` — is sanctioned by the
  convention rather than a deviation from it.
- **`rejected` is standard.** This kit had omitted it.
- **`decision-makers`, `consulted` and `informed` are RACI fields.** `decision-makers` records who
  decided, which is the signal ADR-0008 wanted and had to leave to review.

## Evidence

- [`template/adr-template.md`][full] — full template, fetched 2026-08-20.
- [`template/adr-template-minimal.md`][minimal] — minimal template, same date.
- [adr.github.io/madr](https://adr.github.io/madr/) — project page, consistent with both.

[full]: https://raw.githubusercontent.com/adr/madr/main/template/adr-template.md
[minimal]: https://raw.githubusercontent.com/adr/madr/main/template/adr-template-minimal.md

Sources agree; nothing needed reconciling. Confidence is `high` because the templates were read
directly rather than described by a third party.

## Dead ends

Recalling the schema from memory produced a plausible but wrong answer: it missed `rejected`
entirely, missed that two templates exist, and would have led to adopting the full template's
Pros-and-Cons structure as though it were the only option. The lesson generalises to every other
convention this kit cites — see "Open questions".

## Open questions

- **Nygard's original post** was not checked. The four classic statuses are attributed to it
  throughout this kit on recollection alone.
- **`adr-tools`** filename and numbering behaviour was not checked. ADR-0010 asserts it uses
  numbered headings, which is the basis for keeping them.
- **Keep a Changelog's** six categories are prescribed by `SPECIFICATION.md` §3.2 without having
  been verified against the source.
- Whether MADR's front-matter should be adopted beyond `status`, `date` and `decision-makers`
  remains open; `consulted` and `informed` were judged overhead for a small project rather than
  wrong.
