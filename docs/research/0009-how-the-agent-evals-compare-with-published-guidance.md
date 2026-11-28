# How the agent evals compare with published guidance on evaluating agents

**Confidence:** medium

Checked on 2026-11-28 against guidance from Anthropic, OpenAI, Google, Braintrust and three
practitioner articles, and against the lessons of Anthropic's prompt-evaluation course.

## Finding

`tests/doc-kit-eval.sh` and `docs/howto/run-the-agent-evals.md` follow the guidance that applies to
them. Graders are deterministic checks on the repository a session leaves, not on the path it took.
Each session starts from a fresh repository. A scenario passes only when every run does, which is
pass^k. Every log is read, and a check is fixed when a reading disagrees with it. The guidance says
to prefer each of these.

Two more practices the guidance recommends are in the how-to:

- **A control for each behaviour.** Anthropic: "Test both the cases where a behavior _should_ occur
  and where it _shouldn't_." Without a control, a change that makes agents do the thing every time
  scores as an improvement. `no-home` must write nothing; `work-refactor`, a change that alters no
  behaviour, must change no document, so a session that edits the documents after every code change
  fails it.
- **A reference solution.** Anthropic recommends one per task, "a known working output that passes
  all graders", because a task no trial passes is more often broken than hard. A stub agent that
  makes a correct session's changes, and one that does the wrong thing, show that a scenario's check
  passes and misses when it should.

One practice is missing. Whether a session reported decay, a stale link or a quirk is checked with
regular expressions over its answer, and the how-to makes up for them by reading every log.
Anthropic's course calls a regular expression for refusal phrases "a very brittle approach", and
grades such answers with a model instead. Its own grader gives the model a rubric for each
criterion, with what each score means, a passing and a failing example with their scores, and the
material judged in tags; it asks for the scores and an explanation as JSON, at temperature 0, and
code turns the scores into a verdict. OpenAI and Google add that a model grader is trusted only once
it agrees with human scores. The saved logs of earlier runs, hundreds of them from the decay and
pointer scenarios, many scored by reading every log for research note 0005, are such a set.

One practice does not apply: mining production logs for cases, since the kit has no production
traffic. Scenarios come from failures seen in earlier runs and reviews instead, which the guidance
also recommends.

The filing scenarios are near their ceiling (research note 0003). Anthropic describes an eval at
full marks as tracking regressions with no signal for improvement, so they guard against a change
breaking filing. The decay, refusal and coding scenarios are where a change to the kit can show an
effect.

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

On the number of sessions, the how-to's figures (three to see a change that flips most sessions,
fifteen per arm with Fisher's exact test to compare rates) are stricter than any source read, none
of which ties a run count to a test of significance.

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

- Whether a model grader would agree with hand scores of the saved logs closely enough to replace
  reading every log, or only to pick out the logs worth reading. The plan has an entry for it.

[course]: https://github.com/anthropics/courses/blob/master/prompt_evaluations/README.md
