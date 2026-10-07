#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/docs"
STORY_OUT="$OUT/stories"
mkdir -p "$STORY_OUT"

TWEEGO="${TWEEGO:-tweego}"

if [[ -d "$ROOT/player" ]]; then
  mkdir -p "$OUT"
  find "$ROOT/player" -mindepth 1 -maxdepth 1 ! -name 'README.md' ! -name 'DESIGNBOT.md' ! -name '.gitkeep' -exec cp -a {} "$OUT"/ \;
fi

shopt -s nullglob
stories=("$ROOT"/stories/*.twee)
if (( ${#stories[@]} == 0 )); then
  echo "No .twee files in stories/" >&2
  exit 1
fi

LIST_JSON="$OUT/stories.json"
echo "[" > "$LIST_JSON"
first=1
for twee in "${stories[@]}"; do
  base="$(basename "$twee" .twee)"
  # Skip templates / private drafts (_TEMPLATE.twee, _draft-*.twee)
  if [[ "$base" == _* ]]; then
    echo "Skipping template/private: $base"
    continue
  fi
  html="$STORY_OUT/${base}.html"
  echo "Building $base..."
  "$TWEEGO" -o "$html" "$twee"
  # VG3E skin after SugarCube CSS
  if [[ -f "$OUT/css/sugarcube-skin.css" ]] && ! grep -q 'sugarcube-skin.css' "$html"; then
    sed -i 's|</head>|<link rel="stylesheet" href="../css/sugarcube-skin.css">\n</head>|' "$html"
  fi
  title="$base"
  if grep -q '^:: StoryTitle' "$twee"; then
    title="$(awk '/^:: StoryTitle/{getline; gsub(/\r/,""); if(NF){print; exit}}' "$twee")"
  fi
  if [[ $first -eq 0 ]]; then echo "," >> "$LIST_JSON"; fi
  first=0
  printf '  {"id":"%s","title":"%s","path":"stories/%s.html"}' \
    "$base" "$(echo "$title" | sed 's/"/\\"/g')" "$base" >> "$LIST_JSON"
done
echo "" >> "$LIST_JSON"
echo "]" >> "$LIST_JSON"

if [[ ! -f "$OUT/index.html" ]]; then
  cat > "$OUT/index.html" << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VG Twine Sketches</title>
  <style>
    body { font-family: Georgia, serif; max-width: 40rem; margin: 2rem auto; padding: 0 1rem; line-height: 1.5; }
    h1 { font-weight: normal; }
    ul { padding-left: 1.2rem; }
    a { color: #3a2f1f; }
  </style>
</head>
<body>
  <h1>VG Twine Sketches</h1>
  <p>Short branching brainstorms. Pick a story:</p>
  <ul id="list"></ul>
  <script>
    fetch("stories.json").then(r => r.json()).then(items => {
      const ul = document.getElementById("list");
      items.forEach(s => {
        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = s.path;
        a.textContent = s.title;
        li.appendChild(a);
        ul.appendChild(li);
      });
    });
  </script>
</body>
</html>
HTML
fi

echo "Built → $OUT"
