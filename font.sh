#!/usr/bin/env bash
set -euo pipefail

FONTS=(
  "Agave"
  "CascadiaCode"
  "CodeNewRoman"
  "FiraCode"
  "Hack"
  "Monaspace"
  "Mononoki"
  "SpaceMono"
  "ShareTechMono"
  "Terminus"
  "Ubuntu"
)

DEST="$HOME/.local/share/fonts/NerdFonts"
mkdir -p "$DEST"

BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

echo ">>> Installing Nerd Fonts into $DEST"

for FONT in "${FONTS[@]}"; do
  ZIP="${FONT}.zip"
  echo ">>> Downloading $FONT ..."
  curl -fL -o "/tmp/$ZIP" "$BASE_URL/$ZIP"
  
  echo ">>> Extracting $FONT ..."
  mkdir -p "$DEST/$FONT"
  unzip -o "/tmp/$ZIP" -d "$DEST/$FONT" >/dev/null || {
    echo "⚠️ Failed to unzip $ZIP (maybe not available in release). Skipping..."
  }
  rm -f "/tmp/$ZIP"
done

echo ">>> Updating font cache ..."
fc-cache -fv "$DEST"

echo "✅ Done! Installed: ${FONTS[*]}"
