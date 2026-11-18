# What goes wrong when an agent re-adopts the kit

**Confidence:** medium

Observed directly in the diffs of four re-adoptions on 2026-11-17, but each ran once, with one
model, so it shows what can go wrong rather than how often.

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

The worksheet-first gate worked as intended: the inventory surfaced every decision that needed the
owner - five accepted records to reopen, research mutability, a checker false positive - before
anything moved, and the sessions applied exactly the permissions recorded in it.

## Evidence

Kit as of `93ab7a4`, 2026-11-17; the fenced-block checker fix was made while the sessions ran. Part
1 - reading the changelog from each adoption record's version, the inventory and the worksheet - ran
in a session rooted in the kit. Part 2 ran once per repository as `claude -p` pointed at DeepSeek's
Anthropic-compatible endpoint, model `deepseek-flash`, high effort, `--permission-mode acceptEdits`,
with `git mv`, `git status`, `git diff`, `git grep` and the repository's own `sh` tools allowed, and
the worksheet's owner decisions in the prompt. Every changed line was then compared with its
worksheet row.

| Repository                    | From  | Moves                                     | Result                                     |
| ----------------------------- | ----- | ----------------------------------------- | ------------------------------------------ |
| `dconneely/play-bazlang`      | 0.6.0 | decisions, plan, spec to `README.md` form | 12 of 12 rows; checker passes              |
| `identigon/identigon`         | 0.6.0 | the same, plus paths in code and config   | 12 of 12 rows; two history rewrites undone |
| `dconneely/play-retroemu`     | 0.9.0 | none                                      | 6 of 6 rows; generator improvement lost    |
| `dconneely/play-shellshifter` | 0.9.0 | none                                      | 5 of 5 rows; checker passes                |

Each session stopped and asked when it could not read the kit, rather than working from memory of
it. In identigon it also reported, without fixing, a deviation in its adoption record made stale by
the new tools, because the owner's permission covered paths and the kit version only.

## Dead ends

The checker's failure count misled. play-bazlang reported 87 failures and identigon 129, almost all
from one cause: the `## Artifacts` map heading, which 0.10.0 no longer accepts, leaves the artefacts
table unread, so every file looks unmapped. Renaming the heading in a scratch clone left three
failures in play-bazlang and four in identigon, one of them the checker's false positive on a plan
entry format shown in a fenced block.

Checking a scratch clone of identigon reported its sibling paths `../identigon.github.io/*.md` as
missing; they exist beside the real repository.

## Open questions

- Whether other models make the same mistakes: one model, one session per repository.
- Whether fixing the four gaps in `ADOPTING.md` and the skill prevents them; a second re-adoption
  after the fix would show it.
- How a first adoption into a repository with messy documentation goes; these were re-adoptions of
  repositories already shaped by the kit.
