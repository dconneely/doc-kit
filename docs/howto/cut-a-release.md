# How to cut a release

## Goal

Give the changes under `## Unreleased` in `CHANGELOG.md` a version and a date, tag the commit that
does so, and publish it as a GitHub release, so that adopters can read what changed since the
release their adoption record names and pin the hooks to it. Follow it when `## Unreleased` holds
changes adopters should take.

## Prerequisites

- Signing set up in git, with `commit.gpgsign` on: the release commit is signed, and the release is
  a signed annotated tag.
- `gh`, signed in to GitHub with permission to publish releases.
- A clean working tree on `main`, with every change for the release committed.

## Steps

1. **Check the entries against the commits.**

   ```sh
   git log --oneline "$(git describe --tags --abbrev=0)..HEAD"
   ```

   Every change an adopter can see needs an entry under `## Unreleased`, and no entry may describe a
   change only this repository sees (`docs/spec.md` §3.2). Fix the entries in a commit of their own.

2. **Choose the version.**

   Follow [Semantic Versioning](https://semver.org). While the major version is 0, bump the minor
   version, or the patch version for a release of small corrections only, as 0.7.1 was.

3. **Date the entries.**

   Insert `## [X.Y.Z] - YYYY-MM-DD` directly below `## Unreleased`, leaving `## Unreleased` empty
   above it, as Keep a Changelog's example does
   ([research note 0002](../research/0002-conventions-this-kit-cites.md)). Change nothing else.

4. **Commit the heading.**

   ```sh
   git commit -m "docs: Release X.Y.Z" CHANGELOG.md
   ```

5. **Push the commit, and wait for CI to pass on it.**

   Hook adopters pin to the tag, so tag only a commit that passes. CI runs on a push to `main`, on
   Linux, macOS and Windows.

   ```sh
   git push
   gh run list --commit "$(git rev-parse HEAD)"
   ```

   Every run must finish with `success`. If one fails, fix it in a new commit and repeat this step;
   the heading stays where it is.

6. **Tag the commit that passed, and push the tag.**

   ```sh
   git tag -s vX.Y.Z -m vX.Y.Z
   git push origin vX.Y.Z
   ```

7. **Publish the GitHub release.**

   Write the notes to a file outside the repository: one paragraph saying what the release does and
   what a repository updating from the previous release should change, then the version's section of
   `CHANGELOG.md` without its heading.

   ```sh
   gh release create vX.Y.Z --verify-tag --title vX.Y.Z --notes-file path/to/notes.md
   ```

## Verification

- `git tag -v vX.Y.Z` reports a good signature, and `git show vX.Y.Z` shows the commit CI passed.
- `gh release view vX.Y.Z` shows the release, marked Latest in `gh release list`.
- `## Unreleased` is empty and directly above `## [X.Y.Z]`.
