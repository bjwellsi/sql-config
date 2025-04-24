#!/bin/bash
set -e

SOURCE_DIR="$HOME/.config/sql/scripts"
TARGET_DIR="$HOME/bin/sqltools"

mkdir -p "$TARGET_DIR"

# Step 1: Clean up broken or outdated symlinks
for link in "$TARGET_DIR"/*; do
  [ -L "$link" ] || continue
  target=$(readlink "$link")
  if [ ! -f "$target" ]; then
    echo "🗑️  Removing stale symlink: $(basename "$link")"
    rm "$link"
  fi
done

# Step 2: Create symlinks for current tools
while IFS= read -r -d $'\0' script; do
  name=$(basename "$script" .sh)
  dest="$TARGET_DIR/$name"

  # Only link if not already correct
  if [ ! -L "$dest" ] || [ "$(readlink "$dest")" != "$script" ]; then
    echo "🔗 Linking: $name → $script"
    ln -sf "$script" "$dest"
  fi
done < <(find "$SOURCE_DIR" -type f -name "*.sh" -print0)

echo "✅ Symlink sync complete."
