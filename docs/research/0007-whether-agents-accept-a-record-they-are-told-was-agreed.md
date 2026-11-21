# Whether agents accept a decision record they are told was agreed

**Confidence:** medium

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-20 and 2026-11-21, on the templates in an
empty repository, with DeepSeek Flash and Claude Haiku under Claude Code. Five runs per model and
variant show whether a sentence changes the result, not by how much.

## Finding

Told that a team agreed in a meeting to a proposed decision record, so that it is settled, DeepSeek
Flash accepted the record in 8 of 13 sessions: it set the status to `accepted`, filled in
`decision-makers` with the repository's Git user and regenerated the index, saying the record was
the home for a settled choice. The stanza's bold rule that accepting needs the owner's explicit
permission, asked for first, did not stop it, nor did the template's list of status changes. With
one sentence added to both - being told a record was agreed or settled is not that permission - it
accepted none of 5, each session quoting the sentence and offering to accept the record if told to.
Haiku accepted none without the sentence, and none of 5 with it.

The sentence is now in the stanza and the record template. The rule already covered the case, but
two of the eight sessions that accepted said they took the agreement as the owner's permission, and
the other six did not mention permission at all. The sentence rules out that reading by name.

With the sentence, three of Haiku's five sessions filed the acceptance as a plan entry - "Accept
ADR-0002, how the local cache is stored", blocked on the owner's permission - and one of them also
noted the agreement in the record. Pending work is what the plan holds, so the scenario now allows a
plan entry.

## Evidence

`claude -p --permission-mode acceptEdits`, the index generator allowed, Claude Code 2.1.329, no
`CLAUDE.md`; DeepSeek through its Anthropic-compatible endpoint as `deepseek-flash` at low effort,
Haiku as `claude-haiku-5-5`. The `accept` scenario seeds a `proposed` record and gives the agent the
team's agreement as its fact. Sessions that accepted the record:

| Kit                                                    | DeepSeek Flash | Claude Haiku |
| ------------------------------------------------------ | -------------- | ------------ |
| before the stanza and template map were cut, five runs | 4 / 5          | -            |
| cut, in its full-suite run of three                    | 1 / 3          | 0 / 3        |
| cut, five runs                                         | 3 / 5          | -            |
| cut, with the sentence in the stanza and template      | 0 / 5          | 0 / 5        |

The cut made no difference: the uncut kit lost more sessions than the cut one. Haiku's earlier
sessions on the same day, in research notes 0003 and 0006, accepted no record either; twice it wrote
the agreement into the record and said the owner must accept it.

## Dead ends

None.

## Open questions

- Whether other models accept the record. Gemini and GPT-OSS have not run the scenario with the
  sentence.
