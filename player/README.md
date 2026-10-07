# player/

DesignBot owns this folder: story index chrome + SugarCube skin.

Codeward’s build copies everything here into `docs/` before/alongside Tweego output.
Expected handoff:

- `index.html` — story list (can read `stories.json` produced by the build)
- optional CSS / fonts / parchment skin
- do not put compiled story HTML here; those land in `docs/stories/`
