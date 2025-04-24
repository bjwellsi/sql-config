#!/bin/bash
set -e

ENV_PATH="$HOME/.config/sql/connections/stellify.env"
source "$ENV_PATH"

if [[ -t 0 ]]; then
  # STDIN is not piped, assume file path
  SQLFILE="$(realpath "$1")"
  if [[ ! -f "$SQLFILE" ]]; then
    echo "❌ File not found: $SQLFILE"
    exit 1
  fi
  sql=$(cat "$SQLFILE")
else
  sql=$(cat)
fi

sqlcmd -S "$DB_HOST" -U "$DB_USER" -P "$DB_PASS" -d "$DB_NAME" -Q "$sql"
