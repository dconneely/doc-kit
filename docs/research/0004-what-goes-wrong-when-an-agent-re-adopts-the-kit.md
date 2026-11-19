# What goes wrong when an agent re-adopts the kit

**Confidence:** medium

Observed directly in the diffs of four re-adoptions on 2026-11-17 and of eight sessions repeating
two of them on 2026-11-19, with two models, each once: it shows what goes wrong and that the fixes
held, not how often.

## Finding

An agent given a reviewed worksheet carries out a re-adoption: every row was done, every move used
`git mv`, and the checker passed in all four repositories. Four gaps in `ADOPTING.md` and the
`doc-kit-adopt` skill caused the problems, and none of them is the agent misreading the text.

1. **A session rooted in the target cannot read the kit.** Claude Code confines a session to its
   working directory, so all four Part 2 sessions stopped before any edit until started with
   `--add-dir` for the kit. The skill tells Part 2 to read `ADOPTING.md` and the skill "from the kit
   path" but not that the agent must be given access to it. The same flag gives write access to the
   kit; the sessions left it unchanged.
2. **Fixing links rewrote history.** Told to fix every link to a moved file, a session also rewrote
   past-tense statements in accepted records - "Identigon adopted ... `docs/spec.md`" and "0.5.0
   moved those paths to `docs/spec.md`" - so that they named the new paths and became false. A move
   makes a pointer untrue, not a statement of what was true then; neither `ADOPTING.md` nor the
   stanza draws that line.
3. **Replacing a copied tool discarded a local improvement.** play-retroemu's decisions generator
   joined a Confirmation's wrapped lines, a change its `scripts/README.md` recorded. The worksheet
   said to replace the tool with the kit's copy, and the index lost text from four cells. The
   procedure says what you copy is yours (ADR-0010) but gives no step to compare a copied tool or
   template with the kit's before replacing it. The improvement is now in the kit.
4. **A target's hooks can act on the whole repository.** Running identigon's hooks on the changed
   files ran `./gradlew spotlessApply`, which reformatted 49 Java files the re-adoption never
   touched, because a dependency update had moved the formatter to a new major version. The same
   formatter change failed play-bazlang's CI after the re-adoption was pushed. The procedure says
   nothing about keeping a re-adoption's commit apart from changes the target's own tooling makes.

With those four points added to `ADOPTING.md` and the skill, a second re-adoption of identigon and
play-retroemu, from the commits before the first, avoided each gap with both DeepSeek and Haiku.
Every Part 1 report said to start Part 2 with read access to the kit. No session rewrote a statement
of what was true then; both identigon sessions left its records on consolidating the documentation
and on the site repository alone for that reason. Every play-retroemu session found the generator's
local change, recorded that the kit now carries it, and replaced the tool with nothing lost. In
identigon the formatter again reformatted about 50 unrelated Java files: Haiku stopped and asked,
and DeepSeek reported them as separate, unstaged changes and carried on, where the skill says to
stop. What the rule protects held in both: no change the formatter made entered the adoption's.
Stronger wording is left until a session mixes them in, since one session cannot show whether
DeepSeek would follow it.

The worksheet-first gate worked as intended: the inventory surfaced every decision that needed the
owner - five accepted records to reopen, research mutability, a checker false positive - before
anything moved, and the sessions applied exactly the permissions recorded in it.

## Evidence

Kit as of 2026-11-17, 0.10.0 with some unreleased changes; the fenced-block checker fix was made
while the sessions ran. Part 1 - reading the changelog from each adoption record's version, the
inventory and the worksheet - ran in a session rooted in the kit. Part 2 ran once per repository as
`claude -p` pointed at DeepSeek's Anthropic-compatible endpoint, model `deepseek-flash`, high
effort, `--permission-mode acceptEdits`, with `git mv`, `git status`, `git diff`, `git grep` and the
repository's own `sh` tools allowed, and the worksheet's owner decisions in the prompt. Every
changed line was then compared with its worksheet row.

| Repository                    | From  | Moves                                     | Result                                     |
| ----------------------------- | ----- | ----------------------------------------- | ------------------------------------------ |
| `dconneely/play-bazlang`      | 0.6.0 | decisions, plan, spec to `README.md` form | 12 of 12 rows; checker passes              |
| `identigon/identigon`         | 0.6.0 | the same, plus paths in code and config   | 12 of 12 rows; two history rewrites undone |
| `dconneely/play-retroemu`     | 0.9.0 | none                                      | 6 of 6 rows; generator improvement lost    |
| `dconneely/play-shellshifter` | 0.9.0 | none                                      | 5 of 5 rows; checker passes                |

Each session stopped and asked when it could not read the kit, rather than working from memory of
it. In identigon it also reported, without fixing, a deviation in its adoption record made stale by
the new tools, because the owner's permission covered paths and the kit version only.

The repeat, kit as of 2026-11-19 with the four points added, in scratch clones of the kit and of
each target, so neither real repository changed: identigon from the commit before its formatter
change, and play-retroemu from the commit before its first re-adoption. Each model ran Part 1 rooted
in its kit clone, told only to follow the skill, stop at the gate and say how to start Part 2; the
owner's answers, the same as in the first run, were then added to each worksheet. Part 2 used the
first run's prompt with the date and the kit path changed, and one addition: to run the repository's
hooks on the files it changed, as a commit would. DeepSeek as above; Haiku as
`claude -p --model claude-haiku-5-5`.

| Gap                | DeepSeek, identigon       | Haiku, identigon          | DeepSeek, play-retroemu | Haiku, play-retroemu |
| ------------------ | ------------------------- | ------------------------- | ----------------------- | -------------------- |
| Kit access         | named in Part 1's report  | named                     | named                   | named                |
| History kept       | yes                       | yes                       | yes                     | yes                  |
| Copied tools       | compared in Part 1        | compared in Part 2        | local change found      | local change found   |
| Hooks' own changes | reported, carried on      | stopped and asked         | none made               | none made            |
| Checker at the end | 2 failures, both expected | 2 failures, both expected | 3, all expected         | 3, all expected      |

The expected failures are files absent from a scratch clone: identigon's sibling repository, and
play-retroemu's ignored or generated artefacts. Haiku left two lines of identigon's adoption
record's deviation list naming the old paths, so they no longer describe the repository; DeepSeek
updated one and reworded the other, which the move made no longer a deviation and which could have
been deleted instead. Haiku also copied the plan template into play-retroemu during Part 1, which
Part 1 does not do.

## Dead ends

The checker's failure count misled. play-bazlang reported 87 failures and identigon 129, almost all
from one cause: the `## Artifacts` map heading, which 0.10.0 no longer accepts, leaves the artefacts
table unread, so every file looks unmapped. Renaming the heading in a scratch clone left three
failures in play-bazlang and four in identigon, one of them the checker's false positive on a plan
entry format shown in a fenced block.

Checking a scratch clone of identigon reported its sibling paths `../identigon.github.io/*.md` as
missing; they exist beside the real repository.

The repeat first started play-retroemu from its 0.9.0 adoption, which predates the generator's local
change, so Part 1 found nothing to keep. It was rerun from the commit before its first re-adoption.

## Open questions

Nothing outstanding. One question is left to the plan rather than answered here:

- How a first adoption into a repository with messy documentation goes: these were re-adoptions of
  repositories already shaped by the kit, and the plan entry "Evaluate the adoption procedure"
  covers it.
