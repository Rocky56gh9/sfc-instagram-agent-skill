#!/usr/bin/env bash
# SFC Central NJ fork installer. Run from the repo root: ./install.sh
# Symlinks skills and brand files so a `git pull` updates everything in place
# and any edit a skill makes to voice.md lands back in this repo.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
SKILLS="$HOME/.claude/skills"
IG="$HOME/.claude/instagram"
mkdir -p "$SKILLS" "$IG"

link() {  # link SRC DEST, backing up any real file/dir already at DEST
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"
    echo "  backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "  $dest -> $src"
}

echo "Skills:"
for d in "$REPO"/skills/ig-*; do link "$d" "$SKILLS/$(basename "$d")"; done
echo "Brand files:"
link "$REPO/sfc/brand-rules.md" "$IG/brand-rules.md"
link "$REPO/sfc/voice.md"       "$IG/voice.md"
echo "Done. log.md and swipe.md stay local in $IG (not tracked)."
echo "Restart Claude Code, then try: /ig-reel"
