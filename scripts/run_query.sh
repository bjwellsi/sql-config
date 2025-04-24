#!/bin/bash
set -e

show_help() {
  cat <<EOF
Usage: run_query.sh -D DIALECT -E ENV_NAME -S SCRIPT_FOLDER -X SCRIPT_NAME [-P key=value]...

Options:
  -D        Database dialect (e.g., mssql, postgres)
  -E        Environment name (used to load ~/.config/sql/connections/<env>.env)
  -S        Subfolder under scripts/<dialect> (e.g., global, mycompany)
  -X        Script name (without .sql extension)
  -P        Named parameter (e.g., -P pattern=calc). Repeatable.

Example:
  run_query.sh -D mssql -E stellify -S global -X find_proc -P pattern=order

EOF
  exit 0
}

# Parse args
PARAMS=()
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -D) DIALECT="$2"; shift ;;
    -E) ENV_NAME="$2"; shift ;;
    -S) SUBFOLDER="$2"; shift ;;
    -X) TOOL="$2"; shift ;;
    -P) PARAMS+=("$2"); shift ;;
    -h|--help) show_help ;;
    *) echo "Unknown option: $1" >&2; show_help ;;
  esac
  shift
done

# Validate
ENV_PATH="$HOME/.config/sql/connections/${ENV_NAME}.env"
SQL_PATH="$HOME/.config/sql/scripts/${DIALECT}/${SUBFOLDER}/${TOOL}.sql"

[ -z "$DIALECT" ] || [ -z "$ENV_NAME" ] || [ -z "$SUBFOLDER" ] || [ -z "$TOOL" ] && {
  echo "Missing required argument(s)."
  show_help
}

[ ! -f "$ENV_PATH" ] && { echo "Missing env: $ENV_PATH"; exit 1; }
[ ! -f "$SQL_PATH" ] && { echo "Missing SQL: $SQL_PATH"; exit 1; }

source "$ENV_PATH"

# Load SQL and substitute
sql=$(cat "$SQL_PATH")
for pair in "${PARAMS[@]}"; do
  key="${pair%%=*}"
  val="${pair#*=}"
  sql="${sql//\{\{$key\}\}/$val}"
done

# Execute
sqlcmd -S "$DB_HOST" -U "$DB_USER" -P "$DB_PASS" -d "$DB_NAME" -Q "$sql" -s $'\t' -W -h -1 \
  | "$HOME/.config/sql/scripts/format_sql_output.sh"
