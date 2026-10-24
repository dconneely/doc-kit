---
status: "proposed"
date: 2026-10-24
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 13. How Markdown is formatted here

## Context and Problem Statement

`markdownlint-cli2`'s `MD013` reports lines over 100 columns but cannot rewrap them, so without a
formatter every rewrap is manual. Prettier rewraps Markdown, but only when configured to:
[`identigon/identigon`'s ADR-0036](https://github.com/identigon/identigon/blob/main/docs/adr/0036-adopt-prettier-for-markdown-alongside-markdownlint-cli2.md)
adopted it for this reason with only CLI flags on its hook, and checked directly, it leaves long
lines untouched. `identigon.github.io`'s `.prettierrc.json`, which sets `proseWrap` and
`printWidth`, does rewrap.

Prettier's Markdown printer has no option for single-emphasis style: `*text*` always becomes
`_text_`. It also rewrites fenced YAML unless `embeddedLanguageFormatting` is off, which corrupted
YAML examples in `identigon/identigon`.

## Considered Options

- Adopt Prettier for Markdown, accepting the emphasis rewrite as the cost of automatic wrapping
- Do not adopt Prettier, and keep rewrapping by hand
- Find a narrower tool that wraps prose without rewriting emphasis

## Decision Outcome

Chosen option: **adopt Prettier for Markdown**, configured in `.prettierrc.json` rather than by
flags on the hook, with `proseWrap: "always"`, `printWidth: 100` and
`embeddedLanguageFormatting: "off"`. Prettier formats - wrapping and table alignment - and
`markdownlint-cli2` lints the structural rules Prettier does not check. Both run as pre-commit
hooks. This is infrastructure, never shipped to an adopter (ADR-0005).

Rewrapping by hand was rejected as a cost paid on every edit. No narrower tool was found readily
available.

### Consequences

- Good, because no edit needs manual rewrapping.
- Good, because the formatter and the linter do not overlap.
- Bad, because emphasis is written `_word_` throughout, with no way to configure otherwise.
- Bad, because `embeddedLanguageFormatting: "off"` is essential, not cosmetic: without it, the
  fenced YAML in `docs/research/0001-adr-conventions.md` would be rewritten.
