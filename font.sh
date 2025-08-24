#!/usr/bin/env bash
set -e

# Correct Nerd Fonts package names from official releases
FONTS=(
  "Agave"
  "CaskaydiaCove"
  "CodeNewRoman"
  "FiraCode"
  "Hack"
  "SpaceMono"
  "TerminessTTF"
  "Ubuntu"
)

# Destination directory (system-wide)
DEST_DIR="/usr/local/share/fonts/NerdFonts"
mkdir -p "$DEST_DIR"

# Base release URL
BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

echo ">>> Downloading and installing Nerd Fonts..."

for FONT in "${FONTS[@]}"; do
  ZIP_NAME="${FONT}.zip"
  echo ">>> Installing $FONT..."
  if wget -q --show-progress -O "/tmp/$ZIP_NAME" "$BASE_URL/$ZIP_NAME"; then
    unzip -o "/tmp/$ZIP_NAME" -d "$DEST_DIR/$FONT" >/dev/null
    rm "/tmp/$ZIP_NAME"
  else
    echo "⚠️  Font $FONT not found in Nerd Fonts release. Skipping..."
  fi
done

echo ">>> Updating font cache..."
fc-cache -fv

echo ">>> Nerd Fonts installation complete! Script by MOHIITP 🚀"
