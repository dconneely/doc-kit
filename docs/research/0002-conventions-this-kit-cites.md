# What the other cited conventions actually specify

**Confidence:** high

Checked directly against primary sources on 2026-08-20, closing the open questions left by
[`0001-adr-conventions.md`](0001-adr-conventions.md). That note found the kit was not following the
convention it claimed to follow, and that recalling a schema had produced a plausible but wrong
answer; this one checks everything else the kit cites rather than assuming the first miss was
isolated.

## Finding

Four of five citations were accurate. **The Spec Kit claim was wrong.**

### Keep a Changelog — accurate

Six categories, exactly as `SPECIFICATION.md` §3.2 prescribes: `Added` for new features, `Changed`
for changes in existing functionality, `Deprecated` for soon-to-be removed features, `Removed` for
now removed features, `Fixed` for any bug fixes, `Security` in case of vulnerabilities.

It does prescribe an `Unreleased` section — "Keep an `Unreleased` section at the top to track
upcoming changes" — and reverse-chronological order: "The latest version comes first."

It also states the changelog/commit-log distinction the kit relies on: "The purpose of a changelog
entry is to document the noteworthy difference, often across multiple commits, to communicate them
clearly to end users", and "Using commit log diffs as changelogs is a bad idea: they're full of
noise."

### Nygard 2011 — accurate, and his statuses were lowercase

Sections: Title, Context, Decision, Status, Consequences. Statuses: **proposed**, **accepted**,
**deprecated**, **superseded** — written lowercase in the original. ADR-0010 adopted MADR's
lowercase spelling on MADR's authority; it turns out to match Nygard too, which the kit had not
noticed.

### adr-tools — accurate

Its template heading is `# NUMBER. TITLE`, confirming ADR-0010's basis for keeping numbered
headings. The template carries a `Date:` line and the sections Status, Context, Decision,
Consequences.

### agents.md — accurate but weaker than "convention" suggests

There is **no required structure**: "AGENTS.md is just standard Markdown. Use any headings you like;
the agent simply parses the text you provide." It supports nested files — "Agents automatically read
the nearest file in the directory tree, so the closest one takes precedence" — and says nothing at
all about `CLAUDE.md` or other tool-specific files. So the kit's `CLAUDE.md` pointer is neither
blessed nor contradicted by it.

### GitHub Spec Kit — **the kit's claim was wrong**

`ADOPTING-NOTES.md` said Spec Kit "drives a `specify → plan → tasks` flow producing exactly it",
meaning root-level `SPECIFICATION.md` and `PLAN.md`. It does not.

Spec Kit defines seven slash commands — `/speckit.constitution`, `/speckit.specify`,
`/speckit.plan`, `/speckit.tasks`, `/speckit.taskstoissues`, `/speckit.implement`,
`/speckit.converge` — and stores artifacts under `specs/` with configuration in `.specify/`. It
produces no root-level file of either name.

The flow's *shape* is real; the claim about the filenames it produces was not.

### Where the `SPECIFICATION.md` / `PLAN.md` naming actually comes from — nowhere

Neither leading spec-driven toolchain produces those filenames. Spec Kit's own `spec-driven.md`
gives the structure directly:

```text
specs/003-chat-system/
  spec.md          feature specification — user stories, acceptance criteria
  plan.md          implementation plan
  research.md      technical research
  data-model.md    schemas and entity definitions
  contracts/       API specifications and event definitions
  quickstart.md    key validation scenarios
  tasks.md         executable task list derived from the plan
```

Branches and directories are numbered `[NNN]-[description]`. Every filename is **lowercase with
hyphens**, and every one is **nested under a per-feature directory** — none at the repository root.

Kiro is the same shape, one level more hidden:

```text
.kiro/specs/user-authentication/
  requirements.md   user stories with acceptance criteria
  design.md         technical architecture, data models, interfaces
  tasks.md          ordered implementation checklist
```

`bugfix.md` replaces `requirements.md` for bugfix specs.

**Neither tool is proposing a documentation convention at all.** Both keep per-feature state in a
tool-owned directory — `.specify/`, `.kiro/` — that a tool reads and writes. Their `spec.md`
describes one feature and is spent when it ships; this kit's `SPECIFICATION.md` describes the
repository and outlives every feature. Different artifacts sharing a word, so there was never a
naming convention here to inherit.

The genre converged during 2025 — Spec Kit, Kiro and BMAD-METHOD its flagship implementations, Sean
Grove's "The New Code" (AI Engineer World's Fair, 2025) commonly cited as its founding statement.
That timeline is the one claim here from a secondary source.

Searching more widely for any standard prescribing either filename at a repository root found none.
What exists instead:

- **GitHub community health files** — the one formal root-file convention, covering
  `CODE_OF_CONDUCT`, `CONTRIBUTING`, `FUNDING`, `SECURITY`, `SUPPORT` and the issue/PR templates,
  alongside `README` and `LICENSE`. Neither `SPECIFICATION.md` nor `PLAN.md` appears in it.
- **`AGENTS.md`** — de-facto rather than formal, but widely adopted.
- **`ROADMAP.md`** — the nearest analogue to `PLAN.md`, and project-specific rather than
  standardised.
- Individual projects using a `specification.md` (OpenTracing, for one), which is one project's
  choice rather than a convention.
- **IEEE 830-1998**, superseded by **ISO/IEC/IEEE 29148:2011**, which do standardise a requirements
  specification — but its *content and structure*, not what the file is called or where it sits.
  IEEE 830 is still widely referenced by name despite the supersession. Both are enterprise-scale,
  for the same reason the kit already sets aside ISO/IEC/IEEE 29119-3 for testing.

**Conclusion: this kit's `SPECIFICATION.md` and `PLAN.md` are its own naming, not inherited.** The
familiarity is genre resemblance, not convention.

This is a negative result from search, which is weaker than a positive one: absence of evidence
across several queries is not proof no such convention exists. It is enough to stop the
kit asserting one.

## Evidence

- [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/)
- [Nygard, *Documenting Architecture Decisions*, 2011][nygard]
- [`adr-tools` template][adrtools]
- [agents.md](https://agents.md)
- [github/spec-kit](https://github.com/github/spec-kit), and its [`spec-driven.md`][sdd] for the
  file tree — both read directly
- [Kiro specs documentation](https://kiro.dev/docs/specs/) for the filenames, and its
  [best practices page](https://kiro.dev/docs/specs/best-practices/) for the `.kiro/specs/` tree
- [Spec-driven development](https://en.wikipedia.org/wiki/Spec-driven_development) — for the genre's
  timeline only, which is the one claim here resting on a secondary source

[sdd]: https://raw.githubusercontent.com/github/spec-kit/main/spec-driven.md

[nygard]: https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions
[adrtools]: https://raw.githubusercontent.com/npryce/adr-tools/master/src/template.md

## Dead ends

`adr-tools`' own README does not state its filename format or status vocabulary — the README search
was inconclusive and the answer came from `src/template.md`. Checking a project's README is not the
same as checking the artifact it generates.

## Open questions

- Nothing outstanding. The genre's 2025 timeline is the one claim here still resting on a secondary
  source, and nothing in this kit depends on it.
- MADR's `consulted` and `informed` fields remain unadopted by choice, not by evidence — carried
  over from `0001-adr-conventions.md`.
