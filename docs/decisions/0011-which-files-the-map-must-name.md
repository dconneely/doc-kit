---
status: "accepted"
date: 2026-11-26
decision-makers: David Conneely
---

# 11. Which files the map must name

## Context and Problem Statement

`docs/spec.md` §2.4 requires every documentation file to appear in the map. Several kinds of
Markdown file strain that rule, because the repository does not maintain them as documentation:

- **Gitignored files.** Working notes, build output and dependency trees are not part of the tracked
  structure, and a check over them reports on content the map was never meant to describe.
- **Vendored and generated files.** Third-party source brings its own `README.md` or `docs/` tree,
  and a generator writes Markdown nobody edits. Naming either in the map would claim a content, a
  mutability and an audience for text this repository does not write, and editing the files to mark
  them is lost on the next update.
- **Tool configuration.** Agent commands, skills and instruction files, issue and pull-request
  templates live in top-level dot-directories such as `.claude/` and `.github/`. They are read by a
  tool, not filed by the structure, and they multiply as tools are added. Copilot's instruction
  files in `.github/` are the exception: like `AGENTS.md`, they hold rules an agent follows, and can
  contradict the map.
- **Licence files.** Legal text, copied verbatim, holds no fact the structure routes.

## Considered Options

- Treat all of them like any other Markdown file
- Check gitignored files, and report a hit in one as advisory
- Mark exempt files with front matter, a map row, or a kit-specific git attribute
- Exempt them by rules a repository already follows: git's ignore rules, the `linguist-vendored` and
  `linguist-generated` attributes, top-level dot-directories, and licence file names

## Decision Outcome

Chosen option: **exempt them by rules a repository already follows**, because each rule is one the
repository sets for another reason, so the exemption costs nothing to maintain.

A gitignored file, a file whose `linguist-vendored` or `linguist-generated` attribute is set, a file
below a top-level directory whose name starts with a dot, and a file whose name starts with
`LICENSE`, `LICENCE` or `COPYING` in upper case is not a documentation file, and is skipped
silently, as the archive is. The agent instruction files `.github/copilot-instructions.md` and
`.github/instructions/*.instructions.md` stay documentation files, as the root `AGENTS.md` and
`CLAUDE.md` do, so the map names every file that tells an agent what to do.

Treating them like any other file was rejected because it blocks on content the map was never meant
to describe. Advisory checking of gitignored files was rejected because a warning nobody acts on is
noise on every run. Front matter was rejected because it edits files the repository does not own; a
map row because it lies about scope; a kit-specific attribute because the Linguist attributes
already exist for exactly this, and repositories already set them for their language statistics.

### Consequences

- Good, because one line in `.gitattributes` or `.gitignore` covers a tree however many files it
  holds, and survives updates.
- Good, because adding an agent tool's configuration never touches the map.
- Bad, because the git-based exemptions need `git`. Without it a checker cannot read ignore rules or
  attributes, and checks those files like any other - the stricter direction, never silence.
- Bad, because every exemption is silent, so ignoring or marking a file the repository actually
  maintains, or keeping real documentation in a dot-directory, hides it from the check. That is
  visible in `.gitignore`, `.gitattributes` and the tree, and a matter for review.

## Confirmation

`tools/doc-kit-check.sh` and `tests/doc-kit-check.test.sh`
