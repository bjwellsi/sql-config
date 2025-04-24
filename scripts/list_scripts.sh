#!/bin/bash
set -e

ROOT="$HOME/.config/sql/scripts"
FILTER=""
DIALECT=""

# Parse options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -D) DIALECT="$2"; shift ;;
    -f|--filter) FILTER="$2"; shift ;;
    -h|--help)
      echo "Usage: list_scripts.sh [-D dialect] [-f name_substring]"
      echo "  -D       Filter by dialect (e.g. mssql, postgres)"
      echo "  -f       Grep-style filter for script name"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

echo ""
echo "🧰 Available SQL Scripts:"
echo ""

# Crawl scripts
DIALECT_PATHS=("$ROOT"/*)
[ -n "$DIALECT" ] && DIALECT_PATHS=("$ROOT/$DIALECT")

for dialect_path in "${DIALECT_PATHS[@]}"; do
  [ -d "$dialect_path" ] || continue
  DIALECT_NAME=$(basename "$dialect_path")

  for folder in "$dialect_path"/*; do
    [ -d "$folder" ] || continue
    FOLDER_NAME=$(basename "$folder")

    MATCHING_SCRIPTS=()
    while IFS= read -r -d $'\0' script; do
      script_name=$(basename "$script" .sh)
      [[ -z "$FILTER" || "$script_name" == *"$FILTER"* ]] && MATCHING_SCRIPTS+=("$script")
    done < <(find "$folder" -maxdepth 1 -type f -name '*.sh' -print0)

    [ "${#MATCHING_SCRIPTS[@]}" -eq 0 ] && continue

    echo "📦 $DIALECT_NAME / $FOLDER_NAME"
    for script in "${MATCHING_SCRIPTS[@]}"; do
      base=$(basename "$script" .sh)
      printf "   🔹 %-15s %s\n" "$base" "$script"
    done
    echo ""
  done
done
