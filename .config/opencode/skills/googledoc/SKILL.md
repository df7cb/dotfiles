---
name: Google Docs
description: Read and edit Google Docs in the browser (the editor is canvas-rendered) through Chrome DevTools MCP tools. Use when asked to review, copy-edit, expand or restyle an open Google Doc, or to extract its text and structure.
---

# Editing Google Docs through the browser

Google Docs renders the document into `<canvas>`, so the DOM contains almost no
text. Read through an export, edit through keyboard + synthetic mouse events,
and verify through exports. Assumes the `chrome` MCP tools (`list_pages`,
`evaluate_script`, `press_key`, `type_text`, `take_snapshot`, `click`, ...).

## TL;DR

1. Identify the page: `list_pages`, then `select_page`.
2. **Read the document first** (see below): `mobilebasic` fetch by default,
   an export download if the filesystem is writable. Do not try to scrape the
   canvas.
3. Before any key press, focus the hidden text-event iframe (see Focus).
4. Anchor edits with Find (`Ctrl+F`) + keyboard. Avoid pixel coordinates; they
   drift and silently produce wrong edits.
5. Apply styles with `Ctrl+Alt+1/2/3/0`. Create code blocks via
   `Insert > Building blocks > Code block > Shell`.
6. Export and diff after every risky batch. `Ctrl+Z` is your safety net.
7. Restore the clipboard if touched; clean up test downloads.

## Reading the document

### Best: the `mobilebasic` view, read in-page

`/document/d/<id>/mobilebasic` returns the whole document as plain HTML, and it
is same-origin, so `fetch` works even when downloads are blocked (for example a
read-only `~/Downloads`). Strip the tags — do **not** use `DOMParser`, the page
enforces TrustedHTML and will throw:

```js
const id = location.pathname.match(/\/document\/d\/([^/]+)/)[1];
const res = await fetch('/document/d/' + id + '/mobilebasic', {credentials: 'include'});
let html = await res.text();
html = html.replace(/<script[\s\S]*?<\/script>/gi, '').replace(/<style[\s\S]*?<\/style>/gi, '');
const i = html.search(/<body/i);
let body = i >= 0 ? html.slice(i) : html;
body = body.replace(/<br\s*\/?>/gi, '\n')
           .replace(/<\/(p|div|h[1-6]|li|tr|table|ul|ol)>/gi, '\n')
           .replace(/<[^>]+>/g, '')
           .replace(/&nbsp;/g, ' ').replace(/&amp;/g, '&').replace(/&lt;/g, '<')
           .replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
body = body.replace(/[ \t]+/g, ' ').replace(/\n{3,}/g, '\n\n').trim();
```

Return only a slice (`body.slice(body.indexOf('Section A'), body.indexOf('Section B'))`)
to keep tool results small; the whole doc may be large. A U+FFFC-ish marker
around a command means it really is a code block; a bare line is a paragraph.

Do not try to read the document through the clipboard: `Ctrl+A`, `Ctrl+C` in the
editor did not reach the X clipboard at all (`xclip -o` returned unrelated
content), so cut/copy/paste is not a usable transport here.

### Alternative: export download

Trigger a download with a same-origin anchor (session cookies apply), then read
the file from `~/Downloads`:

```js
const id = location.pathname.match(/\/document\/d\/([^/]+)/)[1];
const a = document.createElement('a');
a.href = `/document/d/${id}/export?format=txt`; // txt | html | docx | pdf
document.body.appendChild(a);
a.click();
a.remove();
```

```sh
F=$(ls -t ~/Downloads/*.txt | head -1)
sed 's/\r$//' "$F"          # exports are CRLF
```

- `format=txt`: content plus paragraph/line breaks, no styles or links.
  Code-block text appears as plain lines; private-use characters (e.g.
  U+E900-ish) mark block boundaries.
- `format=html`: paragraph classes and structure. Use it to check whether text
  is a real code block or just monospace paragraphs, and to see list/heading
  markup.
- Always keep the exports out of the repo; delete test downloads.

## Focus — the most common failure

Key presses only reach the editor when the hidden text-event iframe has focus.
After menu clicks it is usually `.docs-menubar` or `<body>`, and keys are
silently dropped (typing appears to do nothing).

```js
document.querySelector('iframe.docs-texteventtarget-iframe').focus();
```

Check with `document.activeElement.tagName` (want `IFRAME`). Do this before each
batch of keys/typing, especially after using the menus.

`type_text` is reliable once focused: it inserts straight quotes unchanged (no
smart-quote conversion) and also works inside code blocks.

## Anchoring edits with Find (preferred)

- `Ctrl+F`, type a unique string, `Enter`, `Escape`: the match stays selected.
- `ArrowLeft` / `ArrowRight`: collapse the selection to its start / end.
- `Home` / `End`: start/end of the **visual** line, not the paragraph. A wrapped
  line or a line after a hard break is not the paragraph start — this is the
  single biggest source of half-deleted paragraphs. `Ctrl+Home` / `Ctrl+End`:
  document start/end.
- `Enter` at a paragraph start inserts an empty paragraph above; at the end it
  inserts one below.
- `Shift+End`: select the rest of the visual line.
- `Ctrl+Shift+ArrowDown` from the paragraph start selects the whole paragraph,
  including hard breaks and wrapped lines.
- `End` then `Ctrl+Shift+ArrowUp` N times selects N logical lines upward (a
  wrapped line counts once, not per visual line).
- `Ctrl+Z` / `Ctrl+Y`: undo / redo.
- Search runs forward from the caret and wraps; count occurrences carefully.
  Closing the Find & Replace panel can reset the caret, so a "unique" string that
  also exists in another section may match the wrong one. Verify with a
  screenshot before any destructive key.
- `Ctrl+F` twice on a repeated string is not deterministic — verify by exporting
  or by checking the caret/heading style.

Tip: many imported Docs contain *hard line breaks* inside paragraphs. Join them
with Find & Replace (see below) so paragraphs reflow naturally.

## Styling

- `Ctrl+Alt+1` / `2` / `3` = Heading 1 / 2 / 3; `Ctrl+Alt+0` = Normal text.
- `Ctrl+\` clears direct formatting and applies it to the whole current
  paragraph when nothing is selected (useful for wrongly monospaced prose).
- Bulleted/numbered lists: `Ctrl+Shift+8` / `Ctrl+Shift+7` (standard Docs
  shortcuts; not exercised in the session that produced this skill).
- Normal text in branded templates often has **no space before/after**, so
  visual separation comes from empty paragraphs. Add them deliberately.

### Code blocks

- Insert an **empty** block: `Insert > Building blocks > Code block > Shell`
  (`Insert` menu -> `Building blocks` submenu -> `Code block` submenu ->
  language). With the caret in an empty paragraph, the new block replaces that
  paragraph and the caret is inside it: focus the text-event iframe and type
  directly (no click needed). `Enter` adds lines; leading spaces and quotes are
  preserved, and syntax highlighting appears as you type.
- Applying the building block to a **non-empty** paragraph does not convert it:
  Docs splits the paragraph at the caret, inserts an empty block, and leaves the
  text dangling above/below. Always clear the paragraph first.
- Applying it to a multi-paragraph selection converts only the first paragraph.
  Build blocks by inserting empty and typing the content.
- Do **not** delete the language label as if it were text; it belongs to the
  block widget.
- Do **not** use Find & Replace with `\n` inside a code block. In an earlier
  session that converted real code blocks into plain monospace paragraphs,
  losing the block styling. Edit code blocks in place with the keyboard instead.

#### Converting existing plain commands into blocks

The reliable recipe, per command paragraph:

1. `Ctrl+F` a string unique *in that paragraph* (prefer the last line, or a
   distinctive middle fragment), `Enter`, `Escape`.
2. `End`, then `Ctrl+Shift+ArrowUp` once per **logical** line of the paragraph
   (a 4-line `\`-continued command = 4 presses).
3. Screenshot-check the highlight before deleting: it must cover exactly the
   command, with nothing of the preceding bullet in it.
4. `Delete` — one empty paragraph remains, and the code block will take it over.
5. Insert the empty Shell block and type the lines, `Enter` between them.

Pitfalls learned the hard way:

- `Home` + `Ctrl+Shift+Down` is only safe when the anchor is on the paragraph's
  **first** line; otherwise it selects just that visual line and the rest of the
  command survives as a duplicated leftover paragraph.
- `Ctrl+Up` / `Ctrl+Down` do not reliably get you out of a code block, so you
  cannot walk from a block back to the paragraph above it. Anchor from text.
- Deleting the paragraph *mark* instead of just the text merges the following
  bullet into a normal paragraph and loses its list style. Deleting only the
  text and leaving an empty paragraph is the safe outcome.
- `Ctrl+X` / `Ctrl+V` are not dependable (the clipboard round-trip fails), so
  retype lines rather than moving them.
- Leftover fragments are easiest to spot in the `mobilebasic` dump: compare the
  section against the expected command list after each batch.

### Links

- With text selected, `Ctrl+K` opens the "Edit or Insert link" popup. It contains
  a DOM combobox named `Link` (focused); type the URL and press `Enter`.
- A Find & Replace that rewrites a hyperlinked phrase silently drops the link.
  `txt` exports cannot show this. Check the `html` export for `<a href` around
  the phrase, and re-add the link with `Ctrl+K` (for a PGEE repository step,
  `https://deb.cybertec-postgresql.com` is the canonical DEB repo page).

## Find & Replace (`Ctrl+H`)

The panel is real DOM and addressable from snapshots:

- textboxes `Find` and `Replace with`
- checkbox `Use regular expressions`
- checkbox `Match case`
- buttons `Replace` and `Replace all` (disabled until a match exists)

Uids change every time the panel opens (e.g. `2_3`, `31_3`), so take a fresh
snapshot after `Ctrl+H`. The panel stays open across replacements.

- Regex mode supports `\n` for a line/paragraph break. In JS source write
  `"\\n"` so the field receives a literal backslash + `n`.
- `^...$` anchors match whole paragraphs, which is a good way to target a stray
  line — but F&R also matches **inside code blocks**, so make the pattern
  paragraph-anchored before trusting `Replace all`.
- Use it for exact label fixes and for joining hard-wrapped prose:
  pattern `"cluster to\\nstream decrypted data"` -> replacement
  `"cluster to stream decrypted data"`.
- Turn on `Match case` before changing a bullet like "Encrypt cluster" so you do
  not also hit a heading "Encrypt Cluster".
- Prefer `Replace all` for unique strings; it avoids caret-position mistakes.
- **Deleting with an empty replacement is a trap.** `fill` with `""` on the
  `Replace with` box does not reliably clear it — a snapshot can even show no
  value while the previous replacement text is still live, and `Replace` then
  writes that stale text into every match. To delete text, select it and press
  `Delete` instead, or clear the box with a real click + `Ctrl+A` + `Backspace`
  and verify by performing one single `Replace` and re-reading the export.

## Clicking and selecting (use sparingly)

Synthetic mouse events do move the Docs caret and can create ranges:

```js
const click = (x, y, shift) => {
  const el = document.elementFromPoint(x, y);
  const o = {clientX: x, clientY: y, bubbles: true, cancelable: true,
             view: window, detail: 1, buttons: 1, shiftKey: !!shift};
  el.dispatchEvent(new MouseEvent('mousemove', o));
  el.dispatchEvent(new MouseEvent('mousedown', o));
  el.dispatchEvent(new MouseEvent('mouseup', Object.assign({}, o, {buttons: 0})));
};
```

- Scroll with the document scroller, not the window:
  `document.querySelector('.kix-appview-editor').scrollTop = N`.
- Coordinates are viewport pixels at the moment of the click; the layout shifts
  after edits and insertions. Recompute before every click batch.
- Docs **scrolls to reveal the caret after a click**, so a coordinate measured
  from a screenshot taken one call earlier can land a line or two off. Click,
  then screenshot and check `.kix-cursor` before selecting or deleting anything;
  if you are off by a line, fix it with `ArrowUp`/`ArrowDown` rather than
  re-clicking.
- `.kix-cursor`'s `style.transform: translate(Xpx, Ypx)` is the caret position
  in document coordinates; use it to sanity-check where a click landed.
- A click can land one line off and split a paragraph mid-sentence. If you need
  to replace text, prefer Find + keyboard selection.
- Shift-click selection is the reliable way to select a long cross-page range,
  but the end can stop mid-word. **Export and diff before and after any
  destructive action.**

## Deleting

- Select, then focus the text-event iframe, then press `Delete`/`Backspace`.
  Without focus the key is silently lost.
- A partial selection leaves fragments (in this session a bad end coordinate
  left `ain` from `plain`, and a wrong `Home` left whole duplicated lines).
  Undo (`Ctrl+Z`) and retry with a safer anchor.
- Deleting the text of a paragraph leaves an empty paragraph. That is the safe
  outcome: it keeps the following bullet/heading style intact. Only an extra
  blank line is left behind.
- `Backspace` at the start of a paragraph joins it with the previous one (or
  merges it into a code block); note that this can drop or duplicate spaces at
  the join.
- After deleting a multi-line command, always re-read the dump: leftover
  fragments look plausible in a screenshot but are duplicates in the text.

## Menus

- Click menu items by snapshot uid. Submenus open in place; take a snapshot to
  get the next level's uids.
- `Alt+/` menu search is fuzzy and can pick the wrong command (e.g. "code
  block" -> "Page setup"). Prefer clicking the menus.
- `Insert > Building blocks` currently hosts `Code block`; the `Format` menu in
  this Docs version has no code-block entry.

## Image budget (read this before screenshotting)

Screenshots are the most expensive thing you can do in a long Docs session.
Models have an upper bound on images per prompt, and the images accumulate in
the conversation. OpenCode will eventually fail with:

```
Error: At most 67 image(s) may be provided in one prompt. (parameter=image)
```

Mitigations:

- Prefer exports (`txt`/`html`), `.kix-cursor`, `activeElement`, and DOM reads
  over `take_screenshot`. Only screenshot when you truly need pixels.
- When you hit the limit, switch the session to text-only input in
  `opencode.jsonc` and run compaction:

  ```jsonc
  "capabilities": {
    "input": ["text"],
    "output": ["text"],
    "tools": true
  }
  ```

  Compaction then drops the accumulated images from context. Remove the block
  (or restore the image input) afterwards if vision is needed again.
- The same limit applies to other image tools. Keep a rough count; a session
  with dozens of screenshots will hit it.

## Verification loop

- After each risky operation: re-read the affected section via the
  `mobilebasic` dump (or a `txt`/`html` export when downloads work).
- Check especially: headings vs normal text, **duplicated leftover fragments**
  (a half-deleted command leaves a trailing line), merged/split paragraphs,
  blank-line spacing, code-block boundaries, and hard line breaks.
- Compare the section against the expected command list; a duplicated line is
  easy to miss in a screenshot but obvious in the text dump.
- The document's table of contents and page numbers may become stale after
  content changes; either refresh the TOC object or flag it in the summary.
- Screenshots may be unusable: vision may be disabled, or the prompt may have hit
  the image limit (see "Image budget" above). Do not depend on them; use
  exports, `.kix-cursor`, and `innerText` of real DOM controls instead.

## Housekeeping

- Docs autosaves; the title bar shows `Saved to Drive`.
- Downloads land in `~/Downloads`; remove test exports when done. If the
  filesystem is read-only the export silently does nothing (no new file, no
  error) — check `ls -t ~/Downloads` and fall back to `mobilebasic`.
- Touching the system clipboard is intrusive. In this environment `xclip` could
  read/write the X clipboard, but Chrome did not paste it (`Ctrl+V` had no
  effect), and copying *out* of the editor did not reach the clipboard either, so
  typing is the dependable path. If you do clobber it, save the previous value
  and restore it.
- Google Docs API via `gcloud auth print-access-token` was unavailable (read-only
  gcloud config); browser editing was used instead.

## Workflow checklist

1. `list_pages` / `select_page`; confirm the doc and its title.
2. Export `txt`; read the full text and identify sections.
3. Export `html` once if formatting (code blocks, lists) matters.
4. Plan edits as exact-string replacements where possible.
5. For each edit: focus iframe -> anchor with `Ctrl+F` -> keys/`type_text` ->
   restyle if needed.
6. After each batch: export and diff. Undo immediately on mistakes.
7. Final pass: export `txt`/`html`, read end to end, check headings, bullets,
   code blocks, links, and spacing.
8. Restore clipboard/temp files; report anything left unresolved (for example a
   hyperlink lost during a text replacement).
