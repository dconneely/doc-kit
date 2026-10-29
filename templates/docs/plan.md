# Plan

Single ranked backlog, most important first. Entries are **deleted** when done, never annotated - a
plan that accumulates completed items stops being read.

Each entry is a heading, a tag line, then **one paragraph**. No design; anything longer needs a task
note or an ADR. If you keep task notes under `docs/plan/`, `0000-template.md` there is the optional
starting shape.

- **Type** - `bug`, `debt`, `feature` or `docs`.
- **Importance** - `low`, `medium`, `high`: what it costs to keep not doing this.
- **Effort** - `low` under a day, `medium` under a week, `high` larger or not yet known.

## Short title, imperative

**Type:** feature - **Importance:** medium - **Effort:** low

One paragraph on what and why. Name what it unblocks, or what it costs to keep not doing. If the
entry is blocked on another, say which.
