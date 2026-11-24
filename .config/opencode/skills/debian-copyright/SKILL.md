---
name: Debian Copyright
description: Update or fix debian/copyright to match Debian policy (DEP-5) and pass lrc and dfsg-author-check. Use when maintaining a Debian source package's copyright file, fixing license mismatches, rewriting a free-form copyright file, or validating license stanzas.
---

# Maintaining `debian/copyright`

Guidance for "update/fix `debian/copyright` to match Debian policy" and making
the automated checks pass. Written from experience on a `3.0 (quilt)` package
reviewed via `dnq`; applies to any DEP-5 copyright file.

## TL;DR workflow

1. Work in a **clean source tree**. Delete editor swap files / build artifacts
   first (`find . -name '.*.sw[a-p]' -not -path './.git/*'`). `lrc` scans
   everything and will report junk like `.copyright.swp` as a license diff.
2. Run `lrc` from the tree root. Read the `d/copyright | licensecheck` table.
3. For every flagged file, read its header and determine the *real* license.
   `licensecheck -r <file>` helps but is not authoritative.
4. Fix `debian/copyright`: add/adjust a `Files:` stanza + a `License:`
   paragraph for each. Fix case/version mismatches.
5. Run `lrc` again until `No significant differences found` (exit 0).
6. Run `dfsg-author-check` from the tree root and ensure `every holder found
   is named in debian/copyright`.
7. Validate DEP-5 syntax and license references (see below).
8. Re-check no author names were dropped when restructuring stanzas.

## Tools

### `lrc` (licenserecon)
- Parses a DEP-5 `debian/copyright`, runs `licensecheck`, and reports files
  where the declared license differs from what licensecheck detects.
- Run in the **top level of a cleaned tree**.
- Exit codes: `0` no differences, `1` could not run (bad copyright), `3`
  differences found.
- Output columns: left = what `debian/copyright` says, right = licensecheck.
- Config file **`debian/lrc.config`** (optional, per package):
  - Lines starting with `-` are extra command-line options.
  - Bare lines are filenames/partial paths to **exclude** (no `*` wildcards).
    Directories end with `/`. Built-ins already exclude `copying`,
    `copyright`, `readme`, `debian/patches/`, etc.
  - **License aliases** (`d/copyright name | licensecheck name`, e.g. the
    built-in `MIT | Expat`) work only from the *global*
    `/usr/share/lrc/lrc.config`. In lrc 18.x, alias lines added to a
    per-package `debian/lrc.config` are **silently ignored** — verified with
    minimal scratch packages, even using the exact name shown in the table.
    Don't rely on package-level aliases; use a file **exclusion** instead
    (with a comment documenting the declared license and why).
- Debugging lrc: `lrc -l` lists *every* file licensecheck detects with its
  internal name (useful to learn the exact right-hand name). The installed
  `lrc` is a stripped ELF — you cannot read its source; debug by behavior.
  The right column of the table is a *shortened* display of licensecheck's
  name (versionless GPL → `GPL`).
- lrc prints informational notes that do **not** affect the exit code:
  `Missing Files: Paragraph for debian/` when there is no `Files: debian/*`
  stanza, and (depending on the lrc version and on whether the pattern is
  written `debian/*` or `debian/`) `** Superfluous file pattern ... debian/`
  because lrc never scans `debian/`. Keep the `Files: debian/*` stanza (see
  the rule below); the notes are harmless, and lrc 20.1 prints neither with
  `Files: debian/*`.
- `** Superfluous file pattern <name>` is also printed for every `Files:`
  pattern that matches no file in the tree — usually a stale file list after
  upstream restructured (files removed, or renamed). Fix by updating the
  `Files:` line to the files that actually exist; a `debian/` pattern is the
  one exception (lrc never scans `debian/`, and `debian/*` normally produces
  no note). `debian/lrc.config` is not involved (it only excludes files from
  scanning).

### `dfsg-author-check`
- Finds copyright holders named in source files but absent from
  `debian/copyright`.
- Run in the **top level of the unpacked tree** (the directory containing
  `debian/`); an optional directory argument overrides the current directory.
- Exit status: `0` no holder missing, `1` missing holders, `2` error.
- Passes with `Result: every holder found is named in debian/copyright`.
  Missing holders are listed under `Not named in debian/copyright`.
- `possible` and `ignored` holders are reported but do **not** fail the run;
  only missing holders change the exit status.
- `-all` also lists the known/declared holders and their locations;
  `-copyright-file` / `-author-file` add extra allowed holders (both may be
  given more than once).
- `-dep5` prints ready-to-paste `Files:` paragraphs for the missing holders;
  `-markdown` formats the report for a review note; `-json` for scripting;
  `-q` prints nothing when nothing is missing or possibly named.
- Note: `dnq license-check` still needs the `dnq` API (`dnq init`) and may be
  unavailable offline. `dfsg-author-check` works standalone.

### `lintian`
- Cannot lint a source *directory* directly; it needs a `.changes`, `.dsc`,
  or built artifact. Without those, validate manually (below).

### Validation snippets
```bash
# DEP-5 parses, and every referenced license is defined — either inline in
# the Files: stanza, or in a standalone License: paragraph.
# Note (python-debian 1.1.x): p.license is a License object with .synopsis
# and .text, and all_license_paragraphs() returns only *standalone*
# License: paragraphs. A refs-vs-standalone set check therefore reports
# false "undefined" for files that write the license text inline in the
# Files: stanza — check p.license.text for those.
python3 - <<'EOF'
from debian.copyright import Copyright
c = Copyright(open('debian/copyright'))
standalone = {p.license.synopsis for p in c.all_license_paragraphs()}
for p in c.all_files_paragraphs():
    inline = bool(p.license.text and p.license.text.strip())
    defined = inline or p.license.synopsis in standalone
    how = 'inline' if inline else ('standalone' if defined else 'MISSING')
    print(f"{p.license.synopsis:15} <- {list(p.files)}  [{how}]")
EOF

# Per-file license detection
licensecheck -r path/to/file
```

## DEP-5 rules that bite

- **Blank lines in license text** are a single space followed by `.`
  (a line containing just ` .`). Continuation lines of a field are indented
  by one space.
- **`*` matches path separators**, so `Files: modem/freedv/*` also matches
  everything in subdirectories — exceptions need their own stanza.
- **Consecutive `License:` paragraphs need a blank line between them.**
  deb822 paragraphs are blank-line separated; without one,
  `python3 -c "from debian.copyright import Copyright; Copyright(open('debian/copyright'))"`
  dies with `Duplicate field "License" in paragraph N`. lrc is lenient,
  the python parser is not.
- **No orphaned `License:` paragraphs**: if a stanza change (e.g. dropping a
  `Files:` stanza) leaves a license name unreferenced, remove that `License:`
  paragraph too (lintian-clean; the python check above reports unused ones).
- **Order general → specific** (`Files: *` first, then broad dirs, then
  individual files). Most parsers pick the most specific match; ordering this
  way is safe for last-match implementations too.
- **Add a `Files: debian/*` stanza** after the upstream stanzas, documenting
  the packaging as copyright of its maintainers. Copy the current
  `Maintainer:` and `Uploaders:` from `debian/control`, one holder per line
  (deduplicate someone listed in both); **omit the `Maintainer:` when it is a
  group/team address** (e.g. `Debian Foo Maintainers
  <team+foo@tracker.debian.org>`) — a team is not a copyright holder. Use the
  same `License:` short name as the upstream code.
  ```
  Files: debian/*
  Copyright:
   2026 Jane Packager <jane@example.org>
  License: Apache-2.0
  ```
- Every `License:` short name used in a `Files:` stanza **must** have a
  matching `License:` paragraph, and the paragraph must contain the full
  text or a reference to `/usr/share/common-licenses/...`.
  Maintainer preference (pisg, 2026): use the **short inline GPL boilerplate
  plus the Debian pointer line**, not just a bare `Text:` field:
  ```
  License: GPL-2+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   .
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   .
   On Debian GNU/Linux systems, the complete text of the GNU General
   Public License can be found in `/usr/share/common-licenses/GPL-2'.
  ```
  For exact `GPL-2` use "version 2 dated June, 1991." (no "or later" clause).
- Prefer standard short names: `GPL-3+`, `GPL-2+`, `GPL-2`, `GPL-3`,
  `LGPL-2.1`, `LGPL-2.1+`, `LGPL-2`, `BSD-2-Clause`, `BSD-3-Clause`,
  `MIT`/`Expat`, `Unlicense`, `public-domain`, `Apache-2.0`.
- **Case matters**: `BSD-2-clause` (definition) vs `BSD-2-Clause` (reference)
  is a silent bug — lintian/a parser will treat the reference as undefined.
- Detect "or later" in the header: *"either version N ... or (at your
  option) any later version"* → `-N+`; plain *"version N"* → `-N`.
- Common license texts to reference rather than paste:
  `/usr/share/common-licenses/{GPL-2,GPL-3,LGPL-2,LGPL-2.1,LGPL-3}`.
- Useful header fields: `Source:` (upstream URL), `Files-Excluded:` aligned
  with spaces for files stripped from the repacked tarball.

## Reading upstream headers correctly

- Bundled single-file libraries often embed multiple licenses. licensecheck
  reports the **file-level** result; use that for the `Files:` stanza and keep
  all embedded copyright holders in the `Copyright:` field.
- An explicit `SPDX-License-Identifier:` is authoritative; use it verbatim.
- Ambiguous/invalid headers are common (e.g. *"GNU General Public License
  version 2.1"*, a version that does not exist; licensecheck then emits
  generic `GPL`; or a versionless "under the terms of the GPL" block, e.g.
  end-of-file POD license sections). Decide the real component license (check
  the project README/`LICENSE`/`COPYING` and the versioned headers of sibling
  files), declare it, and **exclude the file in `debian/lrc.config`** with a
  comment + source of truth (package-level aliases don't work in lrc 18.x).
- Headers saying "either version X or any later" vs "version X only" change
  `+` vs no `+`; get it right per file.
- `"All rights reserved."` belongs to the *copyright notice*, not the
  license grant: keep it in the `Copyright:` field, not inside the
  `License:` text (e.g. BSD-3-Clause). Non-standard short names (observed:
  `License: NTT` for a BSD-3-Clause `COPYRIGHT`) should be renamed to the
  standard name the text actually is — `licensecheck -r` on the license file
  shows the canonical one (here: `BSD 3-Clause License` → `BSD-3-Clause`).

## General findings (lessons learned)

These are the recurring, non-package-specific traps observed while doing a
from-scratch DEP-5 rewrite of a C extension package.

- **`lrc`'s expected short name is the source of truth for the tool and is
  not always the SPDX/DEP-5 name you'd guess.** Zero-clause BSD is a real
  case: declared `BSD-0-Clause` is reported against `0BSD` (lrc's canonical,
  and the id in the installed `spdx-license-ids`). The right-hand column of
  the `d/copyright | licensecheck` table shows the name lrc wants — just
  match it (both names are valid SPDX). If you deliberately keep a different
  declared name, note that per-package aliases don't work in lrc 18.x (see
  Tools) — exclude the file with a comment instead.

- **Generated files carry their generator's license, not the source file's.**
  A grammar/parser in `.y`/`.l` without any header produces `.c`/`.h` whose
  header is GNU Bison's boilerplate: `License: GPL-3+ with Bison-2.2
  exception` (lrc's short form of SPDX `Bison-exception-2.2`) and an FSF
  copyright. licensecheck and `dfsg-author-check` both flag these, so they
  need their own `Files:` stanza (and the FSF name in `Copyright:`). Don't
  paper over a generated file with the grammar's license just because both
  are "the same project".

- **`License: <name> with <exception>` is valid DEP-5, and it must match
  verbatim** between the `Files:` stanza and the `License:` paragraph —
  same case-sensitivity rule as any other synopsis.

- **`lrc` only cross-checks files licensecheck can detect a license on**
  ("only files with a copyright header are checked"). Headerless source files
  are *not* verified against your stanzas — so `Files: *` is unenforced by
  lrc but still must carry the real project license (from `LICENSE`/README),
  it's the licensecheck-detected files that pin your stanzas down.

- **A green `lrc` can be vacuous: exit 0 with *zero* files checked.**
  licensecheck needs the *full license text* to classify a file — a
  copyright-line-only header (e.g. the PostgreSQL-style "Portions Copyright
  (c) 1996-2026, PostgreSQL Global Development Group" without the permission
  paragraph) is `UNKNOWN`, and the built-in exclusion `copyright` matches
  `copyright.*` too, so `COPYRIGHT` and `COPYRIGHT.postgresql` are skipped
  as well. A PostgreSQL extension tree can thus report `No significant
  differences found` while checking nothing. Establish the real licenses
  from the file headers + upstream `LICENSE`/`COPYRIGHT`/README, and
  spot-check with `licensecheck -r <file>` (its output also reveals the
  canonical short name, e.g. `BSD 3-Clause License` for an NTT
  3-clause-BSD `COPYRIGHT`).

- **`LICENSE` is not excluded by lrc's built-ins** (which are
  `about authors copying copyright dep5 readme`, each `foo.*` too), so it is
  scanned and compared. **But no separate `Files:`/`Copyright:` stanza is
  needed for the license file itself** (maintainer preference, pisg 2026):
  let `Files: *` cover it. Observed with lrc 18.1 / licensecheck 3.3.9: a
  verbatim GPL-2 `LICENSE.md` under a `Files: *` declared `GPL-2+` produced
  **no** lrc diff, and `dfsg-author-check` did not flag the FSF copyright
  inside it. When
  you drop the only stanza that used an exact-version name (e.g. `GPL-2` for
  `LICENSE.md`), drop the now-orphaned `License:` paragraph as well.

- **`dfsg-author-check` skips standalone `LICENSE`/`README` but flags names in
  `NEWS` and in generated-file headers (e.g. "Free Software Foundation"),
  even though those never appeared in `debian/copyright` before.** The error
  text "debian/copyright contains no Copyright: fields" means a free-form
  file was read as DEP-5 and is simply missing `Copyright:` fields — a hint
  the file needs the DEP-5 rewrite, not that authors are absent. Not every
  `LICENSE` name gets flagged; that's no reason to omit them, just never
  *drop* names when restructuring.

- **Debian build artifacts also pollute `lrc` if left in the tree.** Besides
  editor swap files, delete the untracked/ignored output of the previous
  `dpkg-buildpackage`/`dh` run before scanning: `debian/<package>/`,
  `debian/.debhelper/`, `debian/files`, `debian/*.debhelper.log`,
  `debian/*.substvars`. Many are git-ignored (even via a global excludes
  file) so `git status` won't warn you, but `lrc` still reads them from disk
  and reports their licenses as diffs.

- **An old free-form `debian/copyright` fails `lrc` immediately with
  "Invalid DEP-5 header" (exit `1`)** — there's no point running `lrc` to
  "show you what to fix" until the file is converted to
  `Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/`
  and at least a `Files: *` stanza exists. Do the license survey
  (`licensecheck -r .`) first, then write the file, then iterate with `lrc`.

- **A read-only source disk can appear mid-session** (host remounts `ro`
  between turns; `touch` fails with "Read-only file system" and so does the
  write tool). Workaround: mirror the tree to writable scratch
  (`cp -a <tree> /tmp/opencode/opencode/<name>-work`), develop and fully
  validate there, then copy the finished files back and re-run all checks in
  the real tree once it is writable again.

## Pitfalls / checklist

- [ ] Tree is clean (no `.swp`, build output) before running `lrc`.
- [ ] `lrc` exits 0 with `No significant differences found`.
- [ ] `dfsg-author-check` reports `every holder found is named in
      debian/copyright` (exit 0).
- [ ] When splitting/merging stanzas, **never drop existing author names** —
      `dfsg-author-check` fails if a name disappears from `debian/copyright`.
- [ ] Fix spelling/case of license short names and version suffixes.
- [ ] Every referenced license has a full-text paragraph or a
      `/usr/share/common-licenses` reference; conversely, no orphaned
      (unreferenced) `License:` paragraphs remain.
- [ ] Consecutive `License:` paragraphs are separated by a blank line.
- [ ] License files (`LICENSE`, `LICENSE.md`, `COPYING`) have no separate
      stanza — they are covered by `Files: *`.
- [ ] `Files: debian/*` lists the current `Maintainer:`/`Uploaders:` as
      holders (group/team `Maintainer:` omitted) under the upstream license.
- [ ] Keep non-source metadata (`Source:`, `Files-Excluded:`) present and
      correctly indented.
- [ ] Prefer minimal, targeted edits; don't rewrite intact stanzas.
