---
status: "proposed"
date: 2026-09-26
decision-makers: {who decided - required once the status is not "proposed"}
---

# 18. Exempt vendored files marked in .gitattributes

## Context and Problem Statement

A repository that vendors third-party source - tracked, not gitignored - inherits that project's
Markdown: a `README.md`, a `CHANGELOG.md`, sometimes a whole `docs/` tree. `SPECIFICATION.md` §1
counts every one as a documentation file, so §2.4 fails until the map names it. Naming it is a lie
about scope: the map would claim a tense, a mutability and an audience for text this repository
neither writes nor maintains.

ADR-0014 covered only the gitignored case, and deliberately kept it checked with a warning, because
a repository's own gitignored working notes are worth checking. Vendored files are the opposite
case: never this repository's documentation, so there is nothing to check and nothing to warn about.
The question is how a checker tells a vendored file from the repository's own, without anyone
editing the third-party files themselves, since those edits are lost on the next vendor update.

## Considered Options

- **Front matter** - a `doc-kit: vendored` key in each vendored file's YAML front matter.
- **A map row** - the map names the vendored directory as an artifact, with some marker exempting it
  from the tense, mutability and audience rules.
- **A kit-specific git attribute** - e.g. `doc-kit-vendored` in `.gitattributes`.
- **`linguist-vendored` in `.gitattributes`** - the attribute GitHub Linguist already defines for
  exactly this, set per path pattern and read with `git check-attr`.

## Decision Outcome

Chosen option: **`linguist-vendored` in `.gitattributes`**, because it marks a whole tree in one
line without touching a third-party file, and reuses a convention repositories already follow for
their language statistics rather than inventing one.

A file whose `linguist-vendored` attribute is set is not a documentation file, and a checker skips
it silently, as it does an archive. Gitignored files are unaffected: ADR-0014 stands for them. A
file both gitignored and vendored is vendored.

### Consequences

- Good, because one line covers a vendored tree however many files it holds, and survives vendor
  updates.
- Good, because a repository marking a tree vendored for GitHub gets the documentation exemption for
  free, and the reverse.
- Bad, because the exemption depends on `git`, like ADR-0014's warning. Without it a checker cannot
  read attributes, and vendored files fail - the stricter direction, never silence.
- Bad, because the attribute is silent by design, so marking a tree the repository actually
  maintains as vendored hides it from the check. That is a review concern, visible in
  `.gitattributes`.
- Neutral: front matter was rejected for vendored files specifically - editing someone else's file
  is the problem being solved. If accepted, ADR-0014's status gains `(refined by ADR-0018)`.
