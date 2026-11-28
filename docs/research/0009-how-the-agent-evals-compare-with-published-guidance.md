# How the agent evals compare with published guidance on evaluating agents

**Confidence:** medium

Checked on 2026-11-28 against guidance from Anthropic, OpenAI, Google, Braintrust and three
practitioner articles, and against the lessons of Anthropic's prompt-evaluation course.

## Finding

`tests/doc-kit-eval.sh` and `docs/howto/run-the-agent-evals.md` follow part of the guidance.
Placement and the rules are graded with deterministic checks on the repository a session leaves, not
on the path it took, and a `work-*` scenario also runs the seeded project's tests. Each session
starts from a fresh repository. Results are compared as pass rates, with a test of significance
across arms. The how-to asks for a control for each behaviour - Anthropic: "Test both the cases
where a behavior _should_ occur and where it _shouldn't_" - so `no-home` must write nothing and
`work-refactor`, a change that alters no behaviour, must change no document. It asks for a check of
each new scenario with stub agents, one making a correct session's changes and one doing the wrong
thing, as Anthropic's reference solution per task is meant to show a task can be passed.

Five gaps remain, most consequential first:

- **No transcripts.** A log keeps the agent's final answer, not its tool calls, so whether a session
  opened the map, the quirks or the code cannot be seen. A session that never read the map and one
  that misread it need different fixes to the kit, and Anthropic says to read transcripts.
- **A narrow task set.** There are 23 scenarios, one wording each, in a repository holding little
  but the templates. Anthropic's course recommends at least 100 test cases, and OpenAI warns against
  cases that do not reproduce real use. Repeating a scenario measures the spread of one wording, not
  what the set leaves untested.
- **Reference stubs are not kept.** They are run by hand when a scenario is added, so a later change
  to a seed or a check is not caught until a paid run.
- **Sessions are not isolated from user-level configuration** unless the command says so, and the
  how-to's default command does not. User-level instructions can bear on what a session refuses, and
  they change between runs.
- **Reports are graded by regular expressions.** Whether a session reported decay, a stale link or a
  quirk is a pattern match over its answer, which research note 0005 records failing both ways, so
  every log is read. Anthropic's course calls a regular expression for refusal phrases "a very
  brittle approach", and grades such answers with a model instead. Its own grader gives the model a
  rubric for each criterion, with what each score means, a passing and a failing example with their
  scores, and the material judged in tags; it asks for the scores and an explanation as JSON, at
  temperature 0, and code turns the scores into a verdict. OpenAI and Google add that a model grader
  is trusted only once it agrees with human scores, and Anthropic that it should be able to answer
  "unknown". Reading the logs is also how a fault in the kit shows up, as one did in research note
  0010, so a grader would pick out logs to read rather than replace reading them.

One practice does not apply: mining production logs for cases, since the kit has no production
traffic. Scenarios come from failures seen in earlier runs and reviews instead, which the guidance
also recommends.

Most scenarios are near their ceiling. Filing is (research note 0003), and Claude Haiku passed 11 of
12 coding sessions (research note 0010). Anthropic describes an eval at full marks as tracking
regressions with no signal for improvement. Weaker models, the decay and refusal scenarios, and a
realistic repository are where a change to the kit can still show an effect.

## Evidence

- Anthropic, [_Demystifying evals for AI agents_][anthropic], January 2026. Its terms: task, trial,
  transcript, outcome. It prefers deterministic graders for coding agents, grading the outcome
  rather than the exact sequence of tool calls, isolated trials, pass^k where consistency matters,
  balanced sets with controls, a reference solution per task, and reading transcripts. Capability
  evals should start with a low pass rate; regression evals should pass almost always.
- OpenAI, [evaluation best practices][openai-bp] and the [Evals guide][openai-evals]: typical, edge
  and adversarial cases; calibrate a model grader against human labels before scaling it; avoid
  "vibe-based evals". The Evals platform shuts down on 2026-11-30. Its guidance does not depend on
  the platform.
- Google, [Stax best practices][stax] and [agent evaluation][google-agent]: the happy path, edge
  cases and adversarial examples; separate regression sets from challenge sets; iterate an autorater
  prompt until it agrees with your own scores. Neither page gives a number of runs.
- Braintrust, [evaluation best practices][braintrust]: build datasets from failures, read why cases
  fail, change one variable at a time, and compare averages rather than single results, which
  matters most for differences under five percentage points. orchestrator.dev's [2026
  guide][orchestrator] suggests 3 to 10 runs. [Gradient Flow][gradientflow] adds nothing these do
  not; [Mind the Product][mtp] adds example judge prompts.
- Anthropic, [prompt evaluations course][course], nine lessons, archived in September 2026: an eval
  is an input, a golden answer, the output and a score; grade with code where the criteria are
  objective, with a model where they need judgement, and with people - "the gold standard", though
  slow, costly and inconsistent between graders - where neither will do; use at least 100 test
  cases. The kit has 23 scenarios, and repeating one measures its spread, not what it leaves
  untested. In one lesson a more capable model fails a check by reading the task more exactly than
  its golden answer does - an octopus has arms, not legs - so a miss can be the task's fault.

On the number of sessions, the how-to ties its figures to a test of significance (three to see a
change that flips most sessions, fifteen per arm with Fisher's exact test to compare rates), which
no source read does. The sources get their confidence from many distinct cases instead, which
repeating one scenario does not supply.

[anthropic]: https://www.anthropic.com/research/demystifying-evals-for-ai-agents
[openai-bp]:
  https://developers.openai.com/api/docs/guides/evaluation-best-practices?api-mode=responses
[openai-evals]: https://developers.openai.com/api/docs/guides/evals?api-mode=responses
[stax]: https://developers.google.com/stax/best-practices
[google-agent]:
  https://docs.cloud.google.com/gemini-enterprise-agent-platform/optimize/evaluation/agent-evaluation
[braintrust]: https://docs.braintrust.dev/evaluate/best-practices
[orchestrator]: https://orchestrator.dev/blog/2026-02-18-ai-evaluation-guide-2026/
[gradientflow]: https://gradientflow.com/the-complete-guide-to-ai-evaluation/
[mtp]: https://www.mindtheproduct.com/how-to-implement-effective-ai-evaluations/

## Dead ends

The trajectory metrics some agent-evaluation tools offer, such as matching tool calls in order, do
not fit here: Anthropic calls exact tool-call sequences too rigid, and a filing session can reach
the right files by many paths. Neither Google page defines them.

orchestrator.dev's figures for business impact, such as "up to 60%", cite no source.

## Open questions

- Whether a model grader would agree with hand scores of the saved logs closely enough to pick out
  the logs worth reading. The plan has an entry for it.

[course]: https://github.com/anthropics/courses/blob/master/prompt_evaluations/README.md
