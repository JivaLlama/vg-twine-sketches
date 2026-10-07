# VG Story Sketches — player UI (DesignBot first pass)

**Date:** 2026-10-06  
**For:** Codeward (Tweego / Actions / Pages)  
**From:** DesignBot  
**Greenlit by:** Jim Bohan — Tweego → SugarCube HTML → GitHub Pages  
**Writers:** keep `.twee` under `stories/`

Chrome and skin only. Not full VG parchment — that pass comes later.

---

## What’s in this brief

| Path (in this brief) | Role |
| --- | --- |
| `player/index.html` | Story index (“VG Story Sketches”) |
| `player/css/index.css` | Styles for the index |
| `player/css/sugarcube-skin.css` | SugarCube overrides (link **after** SugarCube CSS) |
| `stories/sample-sketch.twee` | Tiny WORKING demo (meta “how to write a sketch”) |

Compiled story HTML (e.g. `sample-sketch.html`) is **your** Tweego output — not shipped as a prebuilt binary here. Index cards already point at `./stories/sample-sketch.html`.

---

## Wire-up: SugarCube skin

Tweego embeds SugarCube’s CSS in the compiled HTML. Append the skin **after** that so overrides win.

### Option A — Story stylesheet passage (per `.twee`)

In each story (or a shared include you concatenate):

```twee
:: StoryStylesheet [stylesheet]
@import url("../css/sugarcube-skin.css");
```

Adjust the relative URL to match deploy layout (see paths below).  
`@import` must be the first rule in that stylesheet block if mixed with other CSS.

### Option B — Post-process / template (preferred for many stories)

After Tweego emits `stories/foo.html`, inject once before `</head>`:

```html
<link rel="stylesheet" href="../css/sugarcube-skin.css">
```

Same `href` for every story if the tree is:

```text
docs/                    (or gh-pages root)
  index.html             ← from player/index.html
  css/
    index.css
    sugarcube-skin.css
  stories/
    sample-sketch.html   ← Tweego output
    other-sketch.html
```

From `stories/*.html`, the skin path is `../css/sugarcube-skin.css`.  
From `index.html`, index CSS is `./css/index.css`; story links are `./stories/<name>.html`.

### Option C — Tweego `-m` / module head fragment

If you maintain a head partial, put the `<link>` there and pass it into every build so writers never forget the skin.

---

## Expected deploy paths

Assume GitHub Pages serves either `docs/` on the default branch or a `gh-pages` branch root. Layout should match either way:

```text
<pages-root>/
  index.html
  css/index.css
  css/sugarcube-skin.css
  stories/*.html
```

**Source tree (writers + CI), suggested:**

```text
stories/*.twee                 # writers own these
player/index.html              # DesignBot chrome → copy to pages root
player/css/*.css               # → pages css/
# CI: tweego -o <pages-root>/stories/<name>.html stories/<name>.twee
```

Index placeholder cards already link to `./stories/sample-sketch.html`. After first successful Tweego run, that URL should resolve.

---

## Tweego sketch (for your Actions)

Illustrative only — adjust format path / version to whatever you pin:

```bash
tweego -f sugarcube-2 \
  -o docs/stories/sample-sketch.html \
  stories/sample-sketch.twee
```

Ensure `sugarcube-skin.css` is linked per Option A/B/C before publishing.

Rebuild trigger: push to `stories/**/*.twee` (and player chrome if you want).

---

## Design notes (first pass)

- Ground `#F3E6D0`, ink `#2C241B` — light parchment nod; same tokens as sourcebook mockup.
- Body: system serif (Georgia stack). UI chrome: system sans.
- Reading column ~38rem; choice links underlined with clear focus rings for phone use.
- `.working` / `.badge-working` utility matches the WORKING badge language on the index.
- **Not** full VG parchment (no texture, no Cormorant/Crimson webfonts yet). Later DesignBot pass.

---

## Constraints honored

- No Forgotten Realms / D&D IP  
- No invented Valorous Garden canon (sample is meta + generic ford/courier)  
- Mobile-friendly index + skin  
- Self-contained HTML/CSS — no build step for these assets themselves  

---

## Assumptions for Codeward

1. Pages root maps 1:1 to the tree above (`index.html` + `css/` + `stories/`).  
2. You own Tweego version pin, SugarCube 2.x format install, and Actions workflow.  
3. Story IFID in `sample-sketch.twee` is a placeholder — replace if you generate real IFIDs in CI.  
4. Index lists cards by hand for v1; automating the card list from `stories/*.html` is optional later.  
5. Second placeholder card intentionally also points at the sample so the index isn’t a dead end before more `.twee` exist.  
6. DesignBot owns future parchment skin; keep the `<link>` stable so a drop-in CSS replace works.
