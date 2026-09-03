---
status: "proposed"
date: 2026-09-03
decision-makers: {who decided - required once the status is not "proposed"}
---

# 17. Adopt Prettier for Markdown, accepting the emphasis-style rewrite

## Context and Problem Statement

`markdownlint-cli2`'s `MD013` (line length, 100 columns) has no auto-fix in any markdownlint
implementation - `.pre-commit-config.yaml` already says so: "this reports and does not rewrap."
Every rewrap today is manual: edit, lint, find the violation, count columns, rewrap by hand,
re-lint.

Two adopting repositories were checked directly rather than assumed. `identigon/identigon`'s own
ADR-0036 adopted Prettier for exactly this reason, but its pre-commit hook passes only
`--embedded-language-formatting=off --write`, with no `--prose-wrap` or `--print-width` anywhere and
no `.prettierrc*` file in the repository - run directly against a long paragraph, it leaves every
line untouched. Its stated benefit does not fire. `identigon.github.io`'s `.prettierrc.json` sets
`proseWrap: "always"` and `printWidth: 100` alongside the same `embeddedLanguageFormatting: "off"`,
and, checked the same way, does rewrap. The config file is what makes the difference, not the tool.

The obstacle specific to this repository: Prettier's markdown printer has no configuration option
for single-emphasis style, confirmed empirically - a bare `*text*` becomes `_text_` on first run and
every run after. This repository's prose uses `*word*` exclusively; a search found no genuine
`_word_` emphasis anywhere. Adopting Prettier is therefore not "run it and review the diff" but
"accept a permanent, repository-wide switch from `*word*` to `_word_`, with no way to configure
around it, in exchange for automatic line-wrapping."

Two more things any wiring will need to account for, not settled here: one file
(`docs/research/0001-adr-conventions.md`) contains a fenced YAML block, the same shape that
corrupted YAML examples in `identigon/identigon` when `embedded-language-formatting` was left at its
default; and `templates/` must stay uncustomised (`AGENTS.md`), so a formatter wired to run on
commit needs its effect there checked, not assumed.

## Considered Options

- Adopt Prettier for `*.md`, accept the emphasis-style rewrite as the cost of automatic wrapping.
- Don't adopt Prettier; keep the manual rewrap-by-hand cost `MD013` already imposes today.
- Look for a narrower tool that wraps prose without also rewriting emphasis style - not found
  readily available, and not pursued further once the first option was judged worth its cost anyway.

## Decision Outcome

Chosen option: **adopt Prettier**, configured via a `.prettierrc.json` - not CLI flags on the hook
line, which is the reason `identigon/identigon`'s own copy doesn't work - scoping
`proseWrap: "always"`, `printWidth: 100` and `embeddedLanguageFormatting: "off"` to `*.md`, matching
`identigon.github.io`'s working configuration. Prettier complements `markdownlint-cli2` rather than
replacing it, the same split already in use: a formatter (wrapping, table alignment) and a linter
(structural rules Prettier doesn't check at all - `MD024`, `MD032`, and the rest of the enabled
default set) are different jobs.

This record settles the trade-off, not the wiring. The hook, the config file, the one-time bulk
reformat, and the `templates/` dry-run all remain to be done - tracked in `PLAN.md`, not decided
here.

### Consequences

- Good, because future edits no longer need manual line-counting and rewrapping - the exact gap
  `.pre-commit-config.yaml` already names.
- Good, because the two tools' responsibilities don't overlap: Prettier never needs to know
  `markdownlint-cli2`'s structural rules, and `markdownlint-cli2` needs no line-wrap logic of its
  own.
- Bad, because every existing `*word*` in this repository becomes `_word_` in one bulk reformat
  commit - a large diff with no semantic content, reviewed as such rather than read line by line.
  The bulk reformat touching already-`accepted` records is formatting-only and permitted by
  ADR-0016; it is not an exception being carved out for this decision.
- Bad, because `embedded-language-formatting: off` is load-bearing, not cosmetic - without it,
  `docs/research/0001-adr-conventions.md`'s fenced YAML block is at the same risk that hit
  `identigon/identigon`'s own YAML examples.
- Neutral: table cell alignment padding (`| a | b |` -> `| a   | b   |`) is a side effect of the
  same bulk reformat, not a decision point of its own.
- Neutral: `templates/` needs its own dry-run diff reviewed before the hook is wired, to confirm the
  reformat stays cosmetic there rather than reading as the kind of tidying `AGENTS.md` forbids.
