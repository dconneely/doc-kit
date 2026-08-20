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

- **Never edit an accepted ADR.** Write its successor and set the old `Status` to
  `Superseded by ADR-NNNN`. An unpublished draft is still a draft; a committed one is immutable.
- **Delete completed `PLAN.md` entries.** Do not annotate, strike through, or move them to a done
  section — that is the specific failure that makes a plan stop being read.
- **`CHANGELOG.md` is for changes an adopter can see.** Plan edits and repository infrastructure are
  not, and do not belong there.
- **Adding a document means updating `DOCUMENTATION.md` in the same commit.** Every artifact the map
  names must exist, and every Markdown file outside `docs/archive/` must appear in the map.

## Conventions

British spelling throughout — *customise*, *behaviour*, *licence* as the noun. Prose wraps at 100
columns. Commit subjects follow Conventional Commits: product changes take `feat`/`fix`/`refactor`,
this repository's own documentation takes `docs`.
