#!/bin/bash
set -e

DIALECT="mssql"
FOLDER="global"
ENV=""
PARAMS=()

show_help() {
  echo "Usage: find_proc.sh -E <env> -P key=value [-P key=value ...]"
  exit 0
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -E) ENV="$2"; shift ;;
    -P) PARAMS+=("$2"); shift ;; # <-- this must capture key=value as a single string
    -h|--help) show_help ;;
    *) echo "Unknown option: $1"; show_help ;;
  esac
  shift
done

if [[ -z "$ENV" ]]; then
  echo "❌ Missing required environment (-E)."
  show_help
fi

# Forward params correctly: wrap each -P arg in quotes
for param in "${PARAMS[@]}"; do
  ARGS+=("-P" "$param")
done

"$HOME/.config/sql/scripts/run_query.sh" \
  -D "$DIALECT" \
  -E "$ENV" \
  -S "$FOLDER" \
  -X find_proc \
  "${ARGS[@]}" \
  | "$HOME/.config/sql/scripts/format_sql_output.sh"
