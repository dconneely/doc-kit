---
status: "accepted"
date: 2026-08-22
decision-makers: David Conneely
---

# 15. Locate the skill under `.agents/skills/`, not `.claude/skills/`

## Context and Problem Statement

`doc-kit-adopt` — the skill that drives an adoption into another repository — lived at
`.claude/skills/doc-kit-adopt/SKILL.md`, the conventional Claude Code project-skill location.
Claude Code's own documentation map also lists `.agents/skills` as a recognised project-level skill
location alongside `.claude/skills`. Given the kit already treats `AGENTS.md` at the repository root
as the canonical, cross-tool agent-instructions surface (rather than a Claude-specific file), the
skill's own location was inconsistent with that choice.

## Considered Options

* Leave it at `.claude/skills/doc-kit-adopt/`, the conventional Claude Code location.
* Move it to `.agents/skills/doc-kit-adopt/`, recognised by Claude Code and signalling intent to
  other agents.md-aware tooling.
* Keep both, with one an alias-style pointer to the other.

## Decision Outcome

Chosen option: move to `.agents/skills/doc-kit-adopt/`. Claude Code discovers skills there exactly
as it does under `.claude/skills/`, so nothing is lost for this tool, and the path itself now
signals — the same way root `AGENTS.md` does — that this is written for coding agents generally,
not exclusively for one vendor's tool. Keeping both was rejected: a `SKILL.md` is not the kind of
single-purpose pointer file `CLAUDE.md`→`AGENTS.md` aliasing suits (see `DOC-MAP.md` §2.7); it is the
skill's entire content, and there is nothing for a second copy to point at without duplicating it.

### Consequences

* Good, because the path now matches the kit's own stance on `AGENTS.md`, rather than contradicting
  it.
* Good, because nothing about Claude Code's own discovery of the skill changes.
* Neutral: other tools that read `.agents/skills/` but expect a different frontmatter or invocation
  convention than Claude Code's `SKILL.md` format would still need their own adapter — this move
  signals intent, it does not itself guarantee cross-tool compatibility.
