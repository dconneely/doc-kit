# Testing

The test strategy, and - the part that only lives here - what is deliberately **not** covered.

## What is verified

The layers that exist, what each is responsible for, and where a new test should go. Enough that a
contributor does not have to infer the convention from whichever file they opened first.

## What is verified only approximately

Anything checked by sampling, snapshot, property, or tolerance rather than exactly. State the
tolerance and why it is acceptable. A reader who assumes exactness here will eventually be
surprised.

## What is deliberately not covered

The section that earns this file. For each gap: what is uncovered, why that is an acceptable risk,
and what would change the answer.

Without this, an uncovered area is indistinguishable from an oversight, and the reasoning survives
only in a test comment nobody reads - or nowhere at all.

## Running them

The command. Anything a newcomer needs that is not obvious: fixtures, containers, environment,
which suites are slow enough to skip locally.
