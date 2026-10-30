# Where agents file facts in a repository that has adopted the kit

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-10-30, but each scenario ran once per
repository and model, so a single run is a sample of agent behaviour, not a rate.

## Finding

Given one fact to record, an agent files it where the map says it belongs. Claude Opus placed 54 of
56 facts as the template map expects across seven repositories, and the two exceptions followed that
repository's own customised map rather than the template's. Existing documentation did not divert
facts: nothing landed in ripgrep's `GUIDE.md` or `FAQ.md`, or in the existing `docs/` trees of
httpx, commander.js or cobra.

The "Deliberately not here" section of a customised map steers as strongly as the artifacts table.
In play-bazlang, which records that it has no glossary and that terms are defined where each is
introduced, Opus defined a new term in `docs/spec/mcp.md`; where its map records no how-to guides,
Opus created a single `docs/howto.md` and mapped it, as the growth rule (ADR-0014) allows.

Asked to record an invented fact about code a repository lacks, Opus declines unless told the fact
is invented: it names the right destination but will not fill a quirk's `Where:` or test fields, or
a changelog entry, with things that do not exist. The harness therefore says so in its prompt.

## Evidence

Opus (`claude -p --permission-mode acceptEdits --model opus`), harness as of commit `e354486`, eight
scenarios per repository: a decision, a kept defect, a sourced finding, future work, a term, a
shipped change, a behaviour rule and a procedure. The first five repositories were run in sequence;
play-looplang and cobra were run with the how-to pattern widened in `972ee20`.

| Repository                | Base commit    | Starting state                  | Result |
| ------------------------- | -------------- | ------------------------------- | ------ |
| `dconneely/play-bazlang`  | `6d3f49cc9b44` | adopted, customised map         | 6 / 8  |
| `dconneely/play-eightbit` | `a0cc6d16a309` | README only; templates overlaid | 8 / 8  |
| `dconneely/play-looplang` | `09a761d33c1b` | templates overlaid              | 8 / 8  |
| `BurntSushi/ripgrep`      | `91f5d22ef48b` | many root documents; overlaid   | 8 / 8  |
| `tj/commander.js`         | `ba6d13ddb424` | existing `docs/`; overlaid      | 8 / 8  |
| `encode/httpx`            | `b5addb64f016` | existing `docs/`; overlaid      | 8 / 8  |
| `spf13/cobra`             | `adbc8813901b` | existing `site/` docs; overlaid | 8 / 8  |

play-bazlang's two misses were scored against the template's expectations: the term (expected
`docs/glossary.md`) and the procedure (expected under `docs/howto/` before `972ee20`). Both followed
its map, as described above. Every research note was numbered, in every repository.

Sonnet (`--model sonnet`) on the templates alone placed 7 of 8. The miss was a research note named
`vendor-api-rate-limit.md`, which no rule then forbade; `docs/spec.md` §3.4 now requires the number.

## Dead ends

Running five repositories in parallel exhausted the account's usage limit mid-run, and every session
after that exited with an error the harness first scored as a miss. The harness now reports a failed
session as `ERROR` and stops.

## Open questions

- Whether placement holds across runs: each scenario here ran once. Repeating each several times
  would give a rate rather than a sample.
- Whether it holds for agents other than Claude, which read `AGENTS.md` without a `CLAUDE.md` alias.
- Whether a fact that fits two artifacts - a behaviour rule that is also a decision - is split
  correctly. Every scenario here has one right answer.
