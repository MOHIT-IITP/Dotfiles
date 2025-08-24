#!/bin/bash

# Path to your yazi config folder (adjust if needed)
SOURCE_DIR="$PWD/yazi"
TARGET_DIR="$HOME/.config/yazi"

echo ">>> Setting up Yazi config..."

# Check if source exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "❌ Error: $SOURCE_DIR does not exist!"
  exit 1
fi

# Remove old config if it exists
if [ -d "$TARGET_DIR" ]; then
  echo "⚠️  Existing Yazi config found. Replacing..."
  rm -rf "$TARGET_DIR"
fi

# Copy config
mkdir -p "$HOME/.config"
cp -r "$SOURCE_DIR" "$HOME/.config/"

echo "✅ Yazi config installed at $TARGET_DIR"

