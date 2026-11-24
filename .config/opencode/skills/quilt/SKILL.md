---
name: Debian Quilt patches
description: Create and maintain Debian packaging patches in debian/patches using the quilt tool
---

# Description

Debian packages in "3.0 (quilt)" format carry patches in a format compatible to the "quilt" tool. This skill explains how to use the tool to create and maintain patches that are compatible with what dpkg-buildpackage expects.

quilt itself is only the editing helper: dpkg-buildpackage/dpkg-source apply the files listed in `debian/patches/series` in order with `patch -p1`, at unpack/build time. A source tree is therefore normally kept **with no patches applied**.

# TL;DR

* ~/.quiltrc sets `QUILT_PATCHES=debian/patches`, the location where dpkg-buildpackage expects them
* Use `quilt push` and `quilt pop` (-a for all) to navigate the patch stack in debian/patches/series
* Use `quilt new <name>` to create a new patch (inserted after the current one in the series file). Unless instructed otherwise, add new patches at the end of the stack.
* Before changing a file in the upstream sources, use `quilt add <file>` to add it to the patch. Then do the edits on the upstream source.
* After changing upstream files, use `quilt refresh` to build the patch in `debian/patches/<name>`.
* Give the patch a DEP-3 header (`quilt header -e --dep3`, or edit the file in place).
* Finish with `quilt pop -a` and verify that dpkg can apply the series (`dpkg-source --before-build .`, see below).

# Prerequisites

```
cat debian/source/format
# 3.0 (quilt)

grep -E 'QUILT_(PATCHES|REFRESH_ARGS|DIFF_OPTS)' ~/.quiltrc
```

A usable `/etc/quilt.quiltrc` or `~/.quiltrc` contains:

```
QUILT_PATCHES=debian/patches
QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
QUILT_DIFF_OPTS="-p"
```

`-p ab` makes refresh write `a/`…`b/` paths (what dpkg's `-p1` expects); `--no-timestamps` and `--no-index` keep the patch free of noise.

# Creating a new patch

```
quilt push -a                        # apply the existing series first
quilt new 0002-fix-the-thing.patch   # inserted after the topmost patch
quilt add src/foo.c src/foo.h        # every file the patch changes, including new files
$EDITOR src/foo.c
quilt diff                           # review, without writing the patch yet
quilt refresh                        # write debian/patches/0002-fix-the-thing.patch
quilt pop -a                         # leave the tree unapplied
```

Notes:

* On a package with no `debian/patches/` at all (all patches upstreamed, or a first patch), `quilt new` creates the directory and the `series` file for you. `git status` will then show `debian/patches/` as new.
* Number patches `NNNN-short-description.patch`; keep the numbers in sync with the order in `series`. Add new patches at the end unless a patch must apply after another one that touches the same file.
* `debian/patches/series` is one filename per line; blank lines and lines starting with `#` are ignored, and a patch may carry a `-pN` option after its name. Keep the file newline-terminated.
* Edit upstream files **only after** `quilt add`, otherwise the change belongs to no patch and is silently not shipped (and `dpkg-source` will complain about the unpatchable tree).
* Do not put packaging changes into patches: changes to `debian/` are already part of the source package and need no patch, unless the patch deliberately modifies a file below `debian/`.

# Editing an existing patch

```
quilt push 0002-fix-the-thing.patch     # or: quilt push -a
quilt files 0002-fix-the-thing.patch    # which files does it own?
quilt add src/foo.c                     # only needed for files not yet in the patch
$EDITOR src/foo.c
quilt refresh
quilt pop -a
```

`quilt refresh` keeps the patch header; only the diff below it is regenerated. It is fine to add or edit the DEP-3 header before or after refreshing.

# Patch header (DEP-3)

`quilt header -e --dep3` opens `$EDITOR` with a DEP-3 template; the header can also be written directly at the top of the patch file:

```
Description: short one-line summary
 Longer explanation, wrapped at about 75 columns.
 .
 A line with a single space and a dot starts a new paragraph.
Author: First Last <mail@example.org>
Last-Update: 2026-11-22
Bug: https://example.org/issue/123
Forwarded: https://... (or: no)
```

* `Description` is mandatory in DEP-3; continuation lines are indented by one space.
* `Author` and `Last-Update` (`YYYY-MM-DD`) are recommended; `Forwarded`, `Bug`, `Origin`, `Reviewed-by`, `Applied-Upstream` are the other common fields.
* The header is not part of the diff, so it stays effective when the patch is applied in reverse (`quilt pop`, `dpkg-source --after-build`).

# Inspecting the stack

```
quilt series          # all patches in order
quilt applied         # applied ones
quilt unapplied       # still to be pushed
quilt top / next / previous
quilt files [patch]   # files owned by a patch
quilt diff            # unrefreshed changes of the top patch
quilt patches <file>  # which patches touch a file
```

# Verifying what dpkg will see

A `quilt push -a` / `quilt pop -a` round trip proves the series applies and reverses. To check exactly what a build does, use dpkg's own hooks — preferably in a scratch copy of the tree, since they patch the real files:

```
cp -a ../pkg-1.0 ../check && cd ../check
dpkg-source --before-build .    # applies debian/patches/series, like unpacking a source package
# ... inspect or build ...
dpkg-source --after-build .     # reverses the series again
```

`dpkg-buildpackage`/`dpkg-source -b` run `--before-build` automatically; a patch that does not apply stops the build. Do not leave `.pc/` (quilt's state directory) in the source package or in git.

# Removing or renaming

```
quilt delete -r 0002-fix-the-thing.patch   # drop from series and delete the file
quilt remove src/foo.c                     # drop one file from the topmost patch
quilt rename 0002-better-name.patch        # rename the topmost (or -P <patch>) patch
```

After any of these, run `grep . debian/patches/series` and repeat the push/pop verification.

# Pitfalls

* `quilt pop -a` refuses when the working tree has changes that conflict with reversing the patch. Either fold the change into the patch (`quilt refresh`) or discard it (`quilt revert <file>`), never leave it dangling between patches.
* After a new upstream version, `quilt push -a` may stop at a patch with `.rej`/`.orig` files. Resolve the hunks, `quilt refresh` the patch, delete the rejects, then `quilt pop -a`.
* If refresh output has `Index:` lines or timestamps, `QUILT_REFRESH_ARGS` is not set; run `quilt refresh -p ab --no-timestamps --no-index` once to normalise the patch.
* A patch that creates a file must be added with `quilt add` before the file is created; otherwise it never appears in the patch.
* Do not mix the two stacks: if `dpkg-source --before-build` applied the series, reverse it with `dpkg-source --after-build`, not with `quilt pop` (quilt has no record of that application and `quilt push` would then fail on already-applied hunks).
* Keep the source tree committed with patches **popped**: `git status` should show only intended `debian/patches/` changes (plus the new patch file), not modified upstream sources.
