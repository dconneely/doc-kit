# Archive — not authoritative

Documentation kept for its historical value, whose **currency cannot be established**. Nothing here
is maintained. Nothing here may be relied on.

This directory is exempt from the map's completeness check, and appears in `DOCUMENTATION.md` as a
single entry rather than file by file.

## What belongs here

Material that reads perfectly well but cannot be **dated**: a file stating "the system does X" with
nothing to say whether that is current behaviour or a description of five years ago. Documents
citing decisions, people, tickets or systems that no longer exist. Material in formats nobody can
check any more.

The distinction that matters is currency, not readability. A document that is hard to read but
verifiable should be migrated. A document that is easy to read but undatable belongs here.

## Why not just migrate it

Because migrating an unverified claim into `SPECIFICATION.md` **launders** it. The whole point of
the specification is that readers trust it, so a stale sentence promoted into it is more dangerous
than the same sentence sitting in a folder marked untrusted. A confident migration is worse than no
migration.

## Why not just delete it

Because these files are often the only surviving record of why something is the way it is, and the
cost of losing that is invisible until years later.

## Rules

1. **Every file carries a provenance header.** This one is not optional and this README does not
   substitute for it — readers and tools arrive at these files directly, by search, and never see
   this page.
2. **Every entry states why it was not migrated.** Without a stated reason the archive becomes a
   landfill, which is the plan-graveyard failure in a new location.
3. **Nothing outside the archive cites anything inside it.** Material worth relying on gets migrated
   first, at which point it acquires a confidence level and a real home.

## The header

Paste this at the very top of every file added here:

```markdown
> **ARCHIVED — NOT AUTHORITATIVE. Do not rely on this file.**
> Last known accurate: YYYY-MM (unverified) — or "unknown", which is an honest answer.
> Not migrated because: the specific reason. "Could not establish whether the behaviour it
> describes is current" is the usual one, and is worth stating rather than implying.
> Superseded by: where to look instead, if anywhere. "Nothing" is a valid answer.
```

For files that are not Markdown, put the same header in a sibling `<filename>.provenance.md`.
