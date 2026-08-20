# Agent guide

Orientation for coding agents. Humans start at [`README.md`](README.md).

**Read [`DOCUMENTATION.md`](DOCUMENTATION.md) before writing anything down.** It is the map: it says
which file a given fact belongs in, and the answer is rarely the file you already have open. This
page routes; the map decides.

## Which document to trust

When two documents disagree, tense settles it:

- **`SPECIFICATION.md`** — present tense, authoritative about what a conformant repository is.
- **`CHANGELOG.md`** — past tense. Records what changed, never what is currently true.
- **`PLAN.md`** — intent. Nothing described in it exists yet.
- **`docs/adr/`** — past tense, and records *why*. Check `Status` before relying on one; it may have
  been superseded.

## This repository is its own first adopter

`ADOPTING.md` and `templates/` are **product** — source, not documentation. Everything else at the
root is this repository's own documentation, produced by applying the kit to itself.

The consequence that catches agents: **files under `templates/` are meant to stay uncustomised.**
Their banners, placeholder headings and unfilled sections are the deliverable, not an oversight. Do
not tidy them, fill them in, or lint them into shape.

`.gitattributes` and anything like it is infrastructure — it configures this repository and never
reaches an adopter. See [ADR-0007](docs/adr/0007-keep-repository-infrastructure-out-of-the-product.md).

## Before you edit

- **Never change an ADR's `status`, and never edit one that says `accepted`.** Drafting a record is
  yours; deciding one is not. Write it `proposed` and say so. `SPECIFICATION.md` §3.1 has the rest —
  read it before touching `docs/adr/`. Copy `templates/docs/adr/0000-template.md` for the shape, and
  fill in `Considered Options` honestly.
- **Delete completed `PLAN.md` entries.** Do not annotate, strike through, or move them to a done
  section — that is the specific failure that makes a plan stop being read.
- **`CHANGELOG.md` is for changes an adopter can see.** Plan edits and repository infrastructure are
  not, and do not belong there.
- **Adding a document means updating `DOCUMENTATION.md` in the same commit.** Every artifact the map
  names must exist, and every Markdown file outside `docs/archive/` must appear in the map.

## Changing the specification

**The specification follows the work; it does not lead it.** Change it for one of two reasons:
behaviour changed because you implemented something, or it misdescribes what the project actually
does. Never because you have decided it would read better, cover more, or be organised differently.

The flow in the map is the whole procedure: an ADR first if a real choice was made, then
`SPECIFICATION.md` in the present tense, then a `CHANGELOG.md` line if an adopter can see the
change, then delete the `PLAN.md` entry if there was one.

Two things to watch:

- **A missing plan entry does not mean the work was unsanctioned.** Requests arrive from issue
  trackers and conversations this repository cannot see. It does mean you should say what prompted
  the change, so a reviewer can tell the difference between implementing a request and improvising.
- **Purpose and scope are not yours to revise.** The section stating what this project is for and
  what it excludes is positioning, not description. Changing it is a decision — an ADR, accepted by
  a person — never a side effect of implementing something else. The same holds for restructuring
  the map.

If you think the specification is wrong and nothing has changed, **say so and leave it alone**. That
is a finding to report, not an edit to make.

## Conventions

British spelling throughout — *customise*, *behaviour*, *licence* as the noun. Prose wraps at 100
columns. Commit subjects follow Conventional Commits: product changes take `feat`/`fix`/`refactor`,
this repository's own documentation takes `docs`.
