# Quirks

Deliberate deviations from the reference, specification or obvious expectation, and defects
knowingly left unfixed. It answers one question: **is this a bug, or a decision?**

**Look here before "fixing" anything that looks wrong.** This is the only file in the structure that
says _do not change this_, and the reader most likely to need telling is a coding agent, which reads
deliberate strangeness as a defect and corrects it. Every entry names the code it governs, so a
search for the symbol finds the entry rather than requiring someone to read the whole file first.

Two kinds of entry, and the distinction matters:

- **Deliberate** - we differ on purpose, and intend to keep differing.
- **Accepted-wrong** - we know this is incorrect and have not fixed it. Usually there is a test
  asserting today's incorrect output, which is why recording it matters: without an entry here, the
  next person "fixes" the test and reintroduces the behaviour it was pinning.

---

## Short title

**Kind:** accepted-wrong **Where:** the file, function or symbol this governs - the string someone
would grep for on their way to changing it. List every site if there is more than one. **Expected:**
what the reference, specification or a reasonable reader would predict. **Actual:** what this
project does. **Why:** the reason, in a sentence. If it is long, it is an ADR and this entry links
to it. **Pinned by:** the test asserting current behaviour, by path and name. **Expires when:** what
would have to change for this entry to be deleted. "Never" is a valid answer for a deliberate
deviation; for an accepted-wrong entry it usually means the entry is really debt, and belongs in
`PLAN.md` as well.
