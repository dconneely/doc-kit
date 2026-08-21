# Testing

This repository has no unit tests, because it has almost no code. What it has instead is a
conformance checker that reads the documentation and a set of hooks that guard against drift. This
file says what each verifies, what it verifies only approximately, and what is deliberately left to
a reader.

## What is verified exactly

`tools/doc-kit-check.sh`, run as `sh tools/doc-kit-check.sh [map|adr|plan]`. Every rule it enforces
cites the `SPECIFICATION.md` clause it comes from, so a failure is traceable to the contract rather
than to the tool's opinion.

| Group | Verified |
|---|---|
| `map` | A map exists (§2.1). The artifacts table, lifecycle table and layout block name the same set, with the table authoritative (§2.2). Every artifact named exists, globs included (§2.3). Every Markdown file outside `templates/` and `docs/archive/` is named by some artifact pattern (§2.4). No template placeholder text survives (§2.5) |
| `adr` | Filenames match `NNNN-kebab-case-title.md`; numbers are unique. Front-matter carries a `status` from the permitted set, a `date`, and `decision-makers` on anything past `proposed`. Forward pointers name a record that exists. The three MADR minimal headings are present (§3.1) |
| `plan` | No entry is annotated done, struck through or marked completed. Every entry carries a valid type tag (§3.3) |

The pre-commit hooks cover a second, narrower band: line length at 100 columns
(`.markdownlint-cli2.jsonc`), secrets, file hygiene, and three `pygrep` drift guards for the
failure this repository actually produces — a convention changed in one file and not the others.

## What is verified only approximately

**Link resolution.** `lychee` runs on demand, not on commit, and reports HTTP status rather than
whether a page still says what it was cited for. A standards body can reorganise a document without
changing its URL. Last full sweep: 2026-08-20, all 32 links resolving.

**Glob matching in §2.4.** A file is considered mapped if any artifact pattern matches it under
shell `case` semantics, where `*` crosses `/`. So `templates/*` matches arbitrarily deep paths. That
is deliberate — it is what makes a directory artifact work — but it means a coarse pattern can cover
a file nobody intended to map.

## What is deliberately not covered

**Record immutability.** `SPECIFICATION.md` §3.1 forbids editing an `accepted` record, and says a
checker SHOULD verify this from history rather than from a working tree. The checker does not: it
sees only the current files. This is the largest gap, and it guards a rule the repository has leaned
on repeatedly.

**Substantive conformance (§4).** No fact in two places; prose never restating a machine-readable
contract. §6 assigns this to review because it is not mechanically decidable, and the deduplication
passes this repository has needed were all found by reading, not by tooling.

**Specification clauses with no instance here.** §3.2 changelog categories, §3.4 research confidence
levels, §3.5 quirk entry shape, and §5 archive provenance headers are unimplemented. Three of the
four have nothing to check against — this repository has no quirks file and no archive — but the
changelog and research notes do exist, so those two are genuine omissions rather than vacuous ones.

**Prose quality of any kind.** A repository can pass every check and be badly written. Structural
conformance is a floor.

## The checker has no tests of its own

It was verified by running it against deliberate violations — an unmapped file, a Title-Case status,
a plan entry marked done — and confirming each was caught and that the repository was clean again
afterwards. That is a manual ritual, not a suite, and it is not repeated on change.

Four real bugs surfaced on first run, which is the argument for treating the tool with suspicion:
unquoted loops glob-expanding artifact patterns into the files they matched, artifact paths passed
to `grep` as regexes so `*` was not literal, `grep -n`'s line prefix breaking a match, and a no-op
`sed`. A checker that reports conformance while silently checking nothing is worse than no checker,
and nothing currently protects against that.

## Running everything

```sh
sh tools/doc-kit-check.sh          # conformance
prek run --all-files               # hygiene, line length, drift guards
prek run --hook-stage manual lychee-system --all-files
```

Nothing here is required. `SPECIFICATION.md` §6 makes a repository that holds these properties
without ever running a check fully conformant.
