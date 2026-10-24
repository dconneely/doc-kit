---
status: "proposed"
date: 2026-10-24
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 11. Which files the map must name

## Context and Problem Statement

`SPECIFICATION.md` §2.4 requires every documentation file to appear in the map. Two kinds of
Markdown file strain that rule from opposite directions.

- **Gitignored files.** A repository's own gitignored working notes are worth checking against the
  map while they exist - they are often exactly the material a migration needs to place - but they
  are not part of the tracked structure, and should not fail a run.
- **Vendored files.** Third-party source copied into the repository brings its own `README.md` or
  `docs/` tree. Naming it in the map would claim a tense, a mutability and an audience for text this
  repository neither writes nor maintains, and editing the files to mark them is lost on the next
  vendor update.

## Considered Options

- Exempt gitignored files entirely, as the archive is exempt
- Treat gitignored files like tracked ones
- Check gitignored files, and report a hit in one as advisory
- Mark vendored files with front matter, a map row, or a kit-specific git attribute
- Mark vendored files with `linguist-vendored` in `.gitattributes`

## Decision Outcome

Chosen option: **check gitignored files as advisory, and exempt files marked `linguist-vendored`**.

A gitignored documentation file is still checked against the map, but a hit in one is reported as a
warning and never affects the exit status. A file whose `linguist-vendored` attribute is set is not
a documentation file at all, and is skipped silently, as the archive is. A file both gitignored and
vendored is vendored.

Full exemption of gitignored files was rejected because it hides a working-notes convention that
deserves checking. Treating them like tracked files was rejected because it blocks on content the
map was never meant to describe. Front matter was rejected because it edits someone else's files; a
map row because it lies about scope; a kit-specific attribute because `linguist-vendored` already
exists for exactly this, and repositories already set it for their language statistics.

### Consequences

- Good, because one line in `.gitattributes` covers a vendored tree however many files it holds, and
  survives vendor updates.
- Good, because a repository marking a tree vendored for GitHub gets the exemption without doing
  anything more.
- Bad, because both treatments need `git`. Without it a checker cannot read ignore rules or
  attributes, and every unmapped file fails - the stricter direction, never silence.
- Bad, because the vendored exemption is silent by design, so marking a tree the repository actually
  maintains hides it from the check. That is visible in `.gitattributes`, and a matter for review.
