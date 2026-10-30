# Where agents file facts in a repository that has adopted the kit

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-10-30, but each scenario ran once per
repository and model, so a single run is a sample of agent behaviour, not a rate.

## Finding

Given one fact to record, an agent files it where the map says it belongs, and model size makes
little difference. Across the same seven repositories, Claude Opus placed 54 of 56 facts as the
template map expects and Claude Haiku 55 of 56; every exception followed that repository's own
customised map rather than the template's. Existing documentation did not divert facts: nothing
landed in ripgrep's `GUIDE.md` or `FAQ.md`, or in the existing `docs/` trees of httpx, commander.js
or cobra.

The "Deliberately not here" section of a customised map steers as strongly as the artifacts table.
In play-bazlang, which records that it has no glossary and that terms are defined where each is
introduced, both models defined a new term in `docs/spec/mcp.md`; where its map records no how-to
guides, both created a single `docs/howto.md` and mapped it, as the growth rule (ADR-0014) allows.

These scenarios measure placement only, and each has one obvious home, so near-perfect scores are a
ceiling of the test rather than a measure of the map.

Asked to record an invented fact about code a repository lacks, Opus declines unless told the fact
is invented: it names the right destination but will not fill a quirk's `Where:` or test fields, or
a changelog entry, with things that do not exist. The harness therefore says so in its prompt.

## Evidence

`claude -p --permission-mode acceptEdits --model opus` and `--model haiku`, harness as of commit
`e354486`, eight scenarios per repository: a decision, a kept defect, a sourced finding, future
work, a term, a shipped change, a behaviour rule and a procedure, each repository run in sequence.
Opus ran play-looplang and cobra, and Haiku every repository, with the how-to pattern widened in
`972ee20`.

| Repository                | Base commit    | Starting state                  | Opus  | Haiku |
| ------------------------- | -------------- | ------------------------------- | ----- | ----- |
| `dconneely/play-bazlang`  | `6d3f49cc9b44` | adopted, customised map         | 6 / 8 | 7 / 8 |
| `dconneely/play-eightbit` | `a0cc6d16a309` | README only; templates overlaid | 8 / 8 | 8 / 8 |
| `dconneely/play-looplang` | `09a761d33c1b` | templates overlaid              | 8 / 8 | 8 / 8 |
| `BurntSushi/ripgrep`      | `91f5d22ef48b` | many root documents; overlaid   | 8 / 8 | 8 / 8 |
| `tj/commander.js`         | `ba6d13ddb424` | existing `docs/`; overlaid      | 8 / 8 | 8 / 8 |
| `encode/httpx`            | `b5addb64f016` | existing `docs/`; overlaid      | 8 / 8 | 8 / 8 |
| `spf13/cobra`             | `adbc8813901b` | existing `site/` docs; overlaid | 8 / 8 | 8 / 8 |

play-bazlang's misses were scored against the template's expectations: the term in both runs
(expected `docs/glossary.md`), and for Opus the procedure (expected under `docs/howto/` before
`972ee20`). All followed its map, as described above. Every research note was numbered, and every
decision record took the next free number, in every repository.

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
  correctly, a correction is made in place, or a fact with no home prompts a question. Every
  scenario here has one obvious home.
- Whether what is written follows the kit's rules, not only where it lands: a new record left
  `proposed`, a new file given a map row, the decisions index regenerated. The harness scores only
  the file a fact's token lands in.
- How placement compares when scored against each repository's own map rather than the template's;
  every miss here was a repository-specific choice the template expectations did not know.
