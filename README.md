# VG Twine Sketches

Short branching text adventures for Valorous Garden brainstorming. Writers push `.twee` stories; GitHub Pages serves a playable index.

## For writers

1. Add a new file under `stories/` named like `my-sketch.twee` (Twee 3 / SugarCube).
2. Keep passages short — this is a brainstorm tool, not a novel.
3. Push to `main`. Pages rebuilds automatically.
4. Open the repo’s GitHub Pages URL and pick your story from the index.

### Minimal `.twee` shape

```twee
:: StoryData
{
  "ifid": "<generate a unique UUID>",
  "format": "SugarCube",
  "format-version": "2.37.3",
  "start": "Start"
}

:: StoryTitle
My Sketch Title

:: Start
Prose here.

[[Choice text|NextPassage]]
```

## Layout

| Path | Purpose |
|------|---------|
| `stories/` | Source `.twee` drafts (git-friendly) |
| `player/` | Story index chrome + SugarCube skin (DesignBot) |
| `docs/` | Built HTML output (Pages publishes from here) |
| `.github/workflows/pages.yml` | Tweego build + Pages deploy |

## Local build (optional)

Install [Tweego](https://www.motoslave.net/tweego/), then:

```bash
./scripts/build.sh
```

Opens nothing by itself — open `docs/index.html` in a browser.

## Enable Pages deploy (one-time)

The GitHub token in this environment lacks the `workflow` scope, so the Action lives at `ci/pages.yml` until Jim copies it:

1. Copy `ci/pages.yml` → `.github/workflows/pages.yml` (via GitHub web UI or a token with `workflow` scope).
2. Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Re-run the workflow (or push any commit).

Pages URL will be: `https://jivallama.github.io/vg-twine-sketches/`
