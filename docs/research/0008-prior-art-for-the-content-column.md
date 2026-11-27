# Prior art for the content column, and what Diátaxis covers

**Confidence:** medium

Checked on 2026-11-27 against the primary sources for Diátaxis, the Divio documentation system, DITA
1.3, Every Page Is Page One and the Good Docs Project. Information Mapping's information types rest
on secondary accounts that do not cite Horn, and minimalism's principles on a weak source; the open
questions say what would settle each.

## Finding

No framework read here types documentation by the kind of fact it holds and how that fact ages.
Those that type it at all type it by its purpose for the reader. The map's `Content` column, with
`Mutability` beside it, has no direct precedent. Information Mapping is the nearest: it divides
material into units that each have one purpose and gives each unit a type. None of the six types
reported for it is bound to time, so it has nothing like the kit's `history` or `intent`.

### Diátaxis

Diátaxis divides documentation into four types along two axes, action or cognition and acquisition
or application: tutorials serve learning, how-to guides goals, reference information, and
explanation understanding. Its compass asks the two axis questions to place a piece of text. It
claims "four and only four types", because "There is simply no other territory to cover".

Its stated context is narrower than that claim reads. The colophon says the "original context... was
limited to software product documentation". The home page says it covers content, style and
architecture, but none of the pages read mentions changelogs, decision records or plans. The kit's
content values map onto it only in part: `procedure` is a how-to guide, `behaviour` is reference,
and `rationale` overlaps explanation. `intent`, `history`, `routing`, `index`, `coverage`,
`deviation`, `finding`, `source` and `template` describe how a project maintains its own knowledge,
which is outside that context.

Diátaxis does not make the four types a layout. "Getting started with Diátaxis does not require you
to think about dividing up your documentation into four sections": it "changes the structure of your
documentation from the inside", and the top-level structure forms as material moves. It treats
change over time as improving the whole: "documentation is also never finished", and it recommends
"small, responsive iterations from which overall patterns emerge"; its quality page adds that each
release means checking the work again. It does not separate facts by how they age, and the kit
prescribes its files from the start, customised by deleting.

Diátaxis therefore supports the kit's how-to guides, and the template map's exclusion of tutorials,
but not its split of the rest. Its reason for dividing documentation is that readers have four
different needs; the kit's is that a file whose facts age differently decays. ADR-0005 already
rejects Diátaxis for its question on this ground: it "classifies documentation by what a reader
needs".

On how-to guides it agrees with the how-to template: they are "goal-oriented", carry "no digression,
explanation, teaching", and link to explanation "if they're important".

### The Divio documentation system

The Divio page is an earlier presentation of the same system by the same author, Daniele Procida,
written while he worked at Divio between 2014 and 2021. He says of it that "there are several
aspects that I now think I got wrong". It has the same four types. Its how-to page already calls
guides "wholly goal-oriented", so goal-orientation is not a later change; both versions also frame a
guide as working through a problem. The Divio pages carry no pointer to Diátaxis and no update date.
Diátaxis asks to be cited as diataxis.fr.

### Information Mapping

Robert E. Horn developed Information Mapping, a structured-writing method, from 1969. Its vendor
describes three components: units of information that each have one purpose, research-based
principles, and information types that categorise material by its purpose for the audience. Its six
types - procedure, process, principle, concept, structure and fact - are listed by Tom Johnson, who
takes them from Iva Cheung's introduction to the method, and by the Substack field guide; neither
cites Horn. Typing at the level of a unit, by kind of information, is the closest any source comes
to the `Content` column.

### DITA

DITA 1.3 is an OASIS Standard, current as Errata 02 of 19 June 2018. Every topic type specialises
the base topic type, `<topic>`; concept, task and reference are specialisations outside the base
edition, and the standard calls the set of information types "unbounded". A DITA map aggregates
topics into a deliverable, lists its contents, defines its navigation, and records relationships
between topics. The kit's map instead says which file a fact belongs in and the rules for writing
there: the two share a name and nothing else.

### Every Page Is Page One

Mark Baker's book, from XML Press, holds that readers "arrive at your pages", not at a site, so each
topic must "establish its context". His characteristics of such a topic are that it is
self-contained, has a specific and limited purpose, conforms to a type, establishes its context,
assumes the reader is qualified, stays on one level and links richly. An agent session is that
reader. Self-containment pulls against the map's rule that facts have one home; the kit settles it
by letting short instructional copies repeat and linking for the rest.

### Minimalism

John M. Carroll's _The Nurnberg Funnel_ (MIT Press, 1990) argues for short, action-oriented
instruction that treats an error as something to learn from. That supports the how-to template's
leaving out explanation. Carroll's own list of principles was not checked.

### The Good Docs Project

The Good Docs Project publishes 25 templates under MIT-0, among them README, how-to, tutorial,
concept, reference, troubleshooting, release notes, changelog and glossary. It has no decision
record, plan, specification or map, and nothing that says which template a fact belongs in. None of
the pages read mentions Diátaxis; Johnson describes it as supplying templates for each type where
Diátaxis supplies the architecture.

### Secondary accounts

Tom Johnson (2023) found the four-way split "overly opinionated and arbitrary" at first, and reports
that Procida told him it is not meant to impose four rigid categories. He expects chatbots to make
the arrangement of help content matter less, while the source "still needs to be well-structured". A
field guide on the Substack _The Way We Write Now_ recommends Diátaxis as the first sort, with the
others filling what it leaves out, and does not mention agents.

GitBook's guide to information architecture, a vendor page with no author or calendar date, calls
Diátaxis "the most popular and well-known framework" and offers it as a starting point, adding that
"the dividing lines between the different categories aren't always clear". It lets the product and
its users decide the sections, lists a changelog and an FAQ among the usual types, and says to
cross-reference rather than explain a concept on several pages. It is the one source here that
writes for machine readers: it recommends descriptive headings, short sections, consistent terms, an
`llms.txt` and a Markdown copy of each page.

None of these accounts discusses documentation that changes over time beyond a changelog.

## Evidence

- [Diátaxis][diataxis]: the [home page][diataxis], [foundations][foundations], [compass][compass],
  [how-to guides][dx-howto], [explanation][dx-explanation], [map][dx-map], [guide to work][dx-work],
  [quality][dx-quality] and [colophon][colophon] pages, read directly.
- [The Divio documentation system][divio] and its [how-to guides page][divio-howto], read directly.
- [DITA 1.3 Part 0, overview][dita0], and from [Part 1, base edition][dita1], the [information
  typing][dita-typing] and [purpose of maps][dita-maps] pages, read directly.
- [Information Mapping methodology][im], the vendor's description, and [Robert E. Horn][horn] on
  Wikipedia for the dates.
- [Every Page Is Page One][eppo], the author's static archive of the book's chapter headings.
- [Minimalism (technical communication)][minimalism] on Wikipedia, which carries banners for essay
  style and missing citations.
- [The Good Docs Project templates][tgdp] and its [repository][tgdp-repo] for the licence.
- [Tom Johnson, "What is Diátaxis and should you be using it with your documentation?"][johnson],
  2023-10-18: secondary. Its list of Information Mapping's six types comes from Iva Cheung's post
  "Introduction to Information Mapping", which was not read.
- ["Documentation frameworks: a field guide"][arrants], _The Way We Write Now_: secondary, the
  survey that pointed to the sources above.
- [GitBook, "How to structure technical documentation: information architecture best
  practices"][gitbook]: secondary, and a vendor's guide.

Where the sources disagree on how many types there are - Diátaxis four, Information Mapping six,
DITA unbounded - the disagreement is about what each types: reader needs, units of information, and
XML topics. Nothing here needs it resolved.

## Dead ends

Diátaxis has no page at `/complex-hierarchies/`; what it says about structure is on its map and
guide-to-work pages. Wikipedia has no article at `Information_mapping`, and the vendor's public
pages name the information types without listing them. The minimalism article on Wikipedia has no
list of principles.

The belief that Divio called how-to guides "problem-oriented" and Diátaxis changed that to
"goal-oriented" is false: both say goal-oriented.

## Open questions

- Horn's six information types, from Horn's own work rather than accounts that do not cite it.
- Carroll's principles of minimalism, from _The Nurnberg Funnel_ or _Minimalism Beyond the Nurnberg
  Funnel_.
- Whether the Good Docs Project's own documentation says its templates follow Diátaxis.

[diataxis]: https://diataxis.fr/
[foundations]: https://diataxis.fr/foundations/
[compass]: https://diataxis.fr/compass/
[dx-howto]: https://diataxis.fr/how-to-guides/
[dx-explanation]: https://diataxis.fr/explanation/
[dx-map]: https://diataxis.fr/map/
[dx-work]: https://diataxis.fr/how-to-use-diataxis/
[dx-quality]: https://diataxis.fr/quality/
[colophon]: https://diataxis.fr/colophon/
[divio]: https://docs.divio.com/documentation-system/
[divio-howto]: https://docs.divio.com/documentation-system/how-to-guides.md
[dita0]:
  https://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part0-overview/dita-v1.3-errata02-os-part0-overview-complete.html
[dita1]:
  https://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part1-base/dita-v1.3-errata02-os-part1-base-complete.html
[dita-typing]:
  https://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part1-base/archSpec/base/information-typing.html
[dita-maps]:
  https://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part1-base/archSpec/base/purpose-of-ditamaps.html
[im]: https://www.informationmapping.com/pages/information-mapping-methodology
[horn]: https://en.wikipedia.org/wiki/Robert_E._Horn
[eppo]: https://everypageispageone.com/the-book/
[minimalism]: https://en.wikipedia.org/wiki/Minimalism_(technical_communication)
[tgdp]: https://www.thegooddocsproject.dev/template
[tgdp-repo]: https://gitlab.com/tgdp/templates
[johnson]: https://idratherbewriting.com/blog/what-is-diataxis-documentation-framework
[arrants]: https://stevearrants.substack.com/p/documentation-frameworks-a-field
[gitbook]: https://gitbook.com/docs/guides/docs-best-practices/documentation-structure-tips
