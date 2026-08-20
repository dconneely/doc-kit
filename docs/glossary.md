# Glossary

Terms that mean something specific in this project, and ordinary words used precisely.

**Adopter** — a person applying the kit to a repository. The audience for `ADOPTING.md`, and
distinct from a maintainer of the kit itself.

**Adopting repository** — the repository the kit is being applied to. Almost always one that already
exists and already has documentation; the greenfield case is the easy one and is not the target.

**Accepted-wrong** — behaviour known to be incorrect and deliberately left in place, usually with a
test asserting today's incorrect output. A quirk with an expiry condition, recorded so the next
reader does not "fix" the test.

**Archive** — a quarantine directory for documentation whose currency cannot be established. Exempt
from the map's completeness check; every file in it carries a provenance header. See ADR-0005.

**Artifact** — one document, or one directory of documents, named in the map and given a tense, a
durability and an audience. The unit the structure is built from.

**Confidence level** — `high`, `medium` or `low`, attached to a research note. Defined in
`SPECIFICATION.md` §3.4. It qualifies a finding, never a decision: decisions carry no confidence,
only consequences.

**Documentation file** — for checking purposes, any Markdown file that is not vendored, not
generated into an ignored directory, and not below an archive. Defined precisely in
`SPECIFICATION.md` §1, because the map's completeness check is undecidable without it.

**Instance** — a customised copy of a template, living in an adopting repository. The root
`DOCUMENTATION.md` here is an instance; `templates/DOCUMENTATION.md` is the template.

**Map** — `DOCUMENTATION.md`. Names every artifact, what each is for, and where a given fact belongs.
The entry point, and the thing that must never promise a file that does not exist.

**Mixed-tense file** — a document doing several jobs at once: part record of work done, part
backlog, part assessment. The characteristic failure the structure exists to prevent, and the first
thing to look for when adopting.

**Mutability** — how a document changes: rewritten in place, append-only, immutable, or disposable.
One of the three properties.

**Provenance header** — the block at the top of an archived file stating that it is not
authoritative, when it was last known accurate, and why it was not migrated.

**Specification** — a set, not a file. Members may be prose or machine-readable; both are
specification. See ADR-0003.

**Structural conformance** — satisfying the mechanically checkable requirements. Contrast
**substantive conformance**, which adds the single-source-of-truth rules and needs a reviewer.

**Tense** — whether a document describes what is, what was, or what is intended. The most useful of
the three properties, because the tense of the sentence being written usually settles where it goes.

**Three properties** — tense, mutability and audience. The axis the structure divides on, and the
test every proposed new document must pass. See ADR-0001.
