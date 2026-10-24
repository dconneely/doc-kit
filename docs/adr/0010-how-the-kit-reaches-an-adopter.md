---
status: "accepted"
date: 2026-10-24
decision-makers: David Conneely
approval: 'Yes (asked: "Do you accept ADR-0001 to ADR-0013?")'
---

# 10. How the kit reaches an adopter

## Context and Problem Statement

The kit ships text - templates and a procedure - and one executable file, `tools/doc-kit-check.sh`,
a POSIX shell script depending on nothing beyond `awk`, `sed`, `grep` and `find`. Adoption never
requires running anything, and any infrastructure the kit offers is optional (ADR-0005).

Three questions follow: how the checker is distributed, whether anything connects an adopter's copy
to this repository afterwards, and where the skill that drives an adoption lives.

## Considered Options

- Checker: a pre-commit hook provider, a CI action, a packaged CLI on npm or PyPI, vendoring, or
  nothing
- Afterwards: version-stamp the copied artifacts and ship migration notes; publish the shared rules
  as a referenced file; or fork-and-forget, with the changelog as the upgrade path
- Skill: `.claude/skills/`, `.agents/skills/`, or both

## Decision Outcome

Chosen option: **vendor the checker, fork-and-forget, and keep the skill under `.agents/skills/`**.

- **The checker is vendored.** It is copied into the adopting repository like the templates, under
  the same MIT-0 licence, and kept at `tools/` beside `templates/`. A vendored checker versions with
  the structure it checks: an adopter's map is frozen at adoption, and a referenced hook would keep
  moving and could start failing a repository that never changed.
- **Adoption is fork-and-forget.** What an adopter copies is theirs. There is no version stamp, no
  migration tooling and no obligation to track this repository. `CHANGELOG.md` is the whole upgrade
  mechanism: an adopter reads it and applies what they want by hand.
- **The adoption skill lives at `.agents/skills/doc-kit-adopt/`.** Claude Code discovers it there as
  it does under `.claude/skills/`, and the path says it is written for agents generally, as root
  `AGENTS.md` does.

A hook provider, an action or a package would each bring a runtime, a registry and a network
dependency the rest of the kit does not have. Shipping no checker was rejected because the two
checks that rot - every artifact the map names exists, every documentation file appears in the map -
are the ones a person stops making. Version stamps were rejected because they put the kit's name
inside every adopting repository, and imply a migration a map customised by deletion cannot have.
Referenced rules were rejected because they make an adopter's documentation depend on this
repository staying reachable. Keeping the skill in both places was rejected because a skill is its
whole content, with nothing for a second copy to point at.

### Consequences

- Good, because the checker inherits the kit's distribution model: no runtime, no registry, no
  network, auditable before use, and optional.
- Good, because there is no machinery to build, version or maintain.
- Bad, because improvements do not propagate. Adopters keep what they took, mistakes included, and a
  vendored checker ages silently, passing while no longer testing what the current specification
  requires.
- Neutral: a tool that reads `.agents/skills/` but expects a different skill format still needs its
  own adapter.
