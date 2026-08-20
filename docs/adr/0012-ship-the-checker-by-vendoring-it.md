---
status: "proposed"
date: 2026-08-20
decision-makers:
---

# 12. Ship the checker by vendoring it

## Context and Problem Statement

ADR-0007 deferred how a checker would be distributed until one existed, on the grounds that the
options differ mainly in ecosystem assumptions and picking blind would commit the kit to somebody
else's toolchain. `tools/doc-kit-check.sh` now exists, and building it settled the facts the
decision was waiting on.

It is a single POSIX shell file of about 170 lines, depending on nothing beyond `awk`, `sed`, `grep`
and `find`. It runs from a repository root, reads the map, and exits 0 or 1. On Windows it works
under the `sh` that ships with Git or Cygwin — though not the WSL `bash`, which sees a different
filesystem.

Two constraints from ADR-0007 bind the answer. Adoption may never require running anything, so
whatever ships is optional. And any infrastructure the kit offers is made available, never applied.

## Considered Options

* A pre-commit hook provider, referenced by URL and revision
* A CI action
* A packaged CLI on npm or PyPI
* Vendoring: the adopter copies the script alongside the templates
* Ship nothing, and let adopters write their own

## Decision Outcome

Chosen option: **vendoring**. The script is copied into the adopting repository like everything else
the kit ships, and MIT-0 means it arrives with no obligation attached.

The decisive argument is one that only became visible once the checker was written: **a vendored
checker versions with the structure it checks.** An adopter customises the map by deletion, freezing
a structure at the moment they adopt. A referenced hook would keep moving, and could start failing a
repository that never changed — the checker would have upgraded, the structure would not. Copying
keeps the two in step by construction.

Everything else follows the kit's existing shape. It ships text; hand-copying is the supported path;
a reader can audit 170 lines before running them in their own repository. A packaged CLI or a hook
provider would each introduce a runtime, a registry and a network dependency that the rest of the
kit does not have, and would exclude the air-gapped and policy-constrained repositories ADR-0007
went out of its way to keep in scope.

Shipping nothing was rejected because the two rules that rot — every artifact the map names exists,
every documentation file appears in the map — are exactly the ones a person stops checking.

The script stays at `tools/`, a peer of `templates/` rather than inside it, matching ADR-0006's
framing of the checker as product alongside the templates rather than one of them.

### Consequences

* Good, because the checker inherits the kit's whole distribution model: no runtime, no registry, no
  network, auditable before use, and optional throughout.
* Good, because an adopter's checker matches the structure they actually adopted, and cannot start
  failing them because the kit moved on.
* Bad, because a vendored copy has no upgrade path. This is the same problem the copied templates
  have, and it now applies to executable content — where a stale checker fails quietly by not
  testing something newer, rather than loudly.
* Bad, because the adopter carries a shell dependency they may not want. Mitigated by it being
  optional: `SPECIFICATION.md` §6 makes verification-by-hand fully conformant.
* Neutral: nothing forecloses adding a hook provider or an action later. Those become alternative
  front ends to the same script rather than replacements for it.
